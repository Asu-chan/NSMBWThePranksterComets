#include <common.h>
#include <game.h>
#include <g3dhax.h>
#include <sfx.h>
#include "fileload.h"

/***************************************************/
/*************** Bad Apple easter egg **************/
/* Inspired by Bent's https://youtu.be/7gWjEOjSR84 */
/***************************************************/

extern "C" bool SpawnEffect(const char*, int, Vec*, S16Vec*, Vec*);


class dBadApple_c : public dEn_c {
public:
	int onCreate();
	int onExecute();
	int onDelete();

	s32 timer;
	u32 frame;
	u32 length;

	FileHandle handle;
	u8* baBuff;

	TileRenderer tiles[42*32];
	bool isAdded[42*32];

	bool skipFrame;
	bool firstFrame;

	static dBadApple_c *build();
};


dBadApple_c *dBadApple_c::build() {
	void *buffer = AllocFromGameHeap1(sizeof(dBadApple_c));
	return new(buffer) dBadApple_c;
}

#include <profile.h>
const SpriteData badAppleData = {ProfileId::BAD_APPLE, 8, -8, 0, 0, 0x100, 0x100, 0, 0, 0, 0, 2};
Profile badAppleProfile = Profile((buildFunc)&dBadApple_c::build, SpriteId::BAD_APPLE, &badAppleData, ProfileId::BAD_APPLE, ProfileId::BAD_APPLE, 0x12, "BAD_APPLE", 0);

extern "C" float badAppleZoomFloat;

extern "C" void *StopBGMMusic();
extern "C" void *StartBGMMusic();

int dBadApple_c::onCreate() {
	this->timer = 0;

	StopBGMMusic();

    baBuff = (u8*)LoadFile(&handle, "/NewerRes/ba3.bin");
    this->length = handle.length / 0xA8;

	TileRenderer::List *list = dBgGm_c::instance->getTileRendererList(0);
	for(int y = 0; y < 32; y++) {
		for(int x = 0; x < 42; x++) {
			int i = (y * 42) + x;
			// list->add(&tiles[i]);

			tiles[i].x = pos.x - 8 + (x * 16);
			tiles[i].y = -(8 + pos.y) + (y * 16);
			tiles[i].tileNumber = 30;

			isAdded[i] = false;
		}
	}

	badAppleZoomFloat = 3.0f;
	skipFrame = true;

	return true;
}


int dBadApple_c::onDelete() {
	badAppleZoomFloat = 2.0f;
	TileRenderer::List *list = dBgGm_c::instance->getTileRendererList(0);
	for(int i = 0; i < 42*32; i++) {
		list->remove(&tiles[i]);
	}

	return FreeFile(&handle);
}

int dBadApple_c::onExecute() {
	// Start music on first executing frame
	if(!this->firstFrame) {
		// OSReport("first frame!\n");
		StartBGMMusic();
		this->firstFrame = true;
	}

	// Following three lines are now irrelevant, I used DAIN-app to interpolate the video to 60fps
	/* Game is 60fps, video is 30fps, so skip a frame on two
	/* this->skipFrame = !this->skipFrame;
	/* if(this->skipFrame) return true;
	*/

	// Do the magic!
	if(this->frame < this->length) {
		TileRenderer::List *list = dBgGm_c::instance->getTileRendererList(0);

		for(int y = 0; y < 32; y++) {
			for(int x = 0; x < 42; x++) {
				int i = (y * 42) + x;
				int idx = (i / 8) + (this->timer * 0xA8);
				int num = (7 - (i % 8));

				// OSReport("uh: %d %d %d", i, idx, num);
				// OSReport(" %p\n", &baBuff[idx]);

				u8 val = (baBuff[idx] >> num) & 1;
				if(val && !isAdded[i]) {
					list->add(&tiles[i]);
					isAdded[i] = true;
				}
				else if(!val && isAdded[i]) {
					list->remove(&tiles[i]);
					isAdded[i] = false;
				}
			}
		}

		this->timer++;
	}

	// OSReport("frame: %d\n", frame);
	this->frame++;

	return true;
}

