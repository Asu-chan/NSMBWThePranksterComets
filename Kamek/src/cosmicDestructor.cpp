#include <game.h>
#include <common.h>
#include <dCourse.h>


extern u32 cosmicKillFlag;

class daCosmicDestructor_c : public dEn_c {
	int onCreate();
	int onExecute();
	int onDelete();
	int onDraw();

	mHeapAllocator_c allocator;
	dAcPy_c* player;

	float left, right, top, bottom;

	static daCosmicDestructor_c *build();
};


daCosmicDestructor_c *daCosmicDestructor_c::build() {
	void *buffer = AllocFromGameHeap1(sizeof(daCosmicDestructor_c));
	return new(buffer) daCosmicDestructor_c;
}


int daCosmicDestructor_c::onCreate() {
	player = dAcPy_c::findByID(0);

	// Location stuff from magicplatform.cpp
	mRect rect;
	dCourseFull_c::instance->get(GetAreaNum())->getRectByID(this->settings & 0xFF, &rect);

	int l = rect.x;
	int r = l + rect.width;
	int t = -rect.y;
	int b = t + rect.height;

	l &= 0xFFF0;
	r = (r + 15) & 0xFFF0;

	t = -(t & 0xFFF0);
	b = -((b + 15) & 0xFFF0);

	left = (float)l;
	right = (float)r;
	top = (float)t;
	bottom = (float)b;

	// OSReport("Created; left=%f right=%f", left, right);
	// OSReport(" top=%f bottom=%f\n", top, bottom);

	this->onExecute();
	return true;
}


int daCosmicDestructor_c::onDelete() {
	return true;
}

int daCosmicDestructor_c::onDraw() {
	return true;
}

int daCosmicDestructor_c::onExecute() {
	// OSReport("Mario: %f %f: ", player->pos.x, player->pos.y);
	// OSReport("%d %d ", player->pos.x >= left, player->pos.x <= right);
	// OSReport("%d %d\n", player->pos.y >= bottom, player->pos.y <= top);
	if(player->pos.x >= left && player->pos.x <= right && player->pos.y >= bottom && player->pos.y <= top) {
		OSReport("Mario is in there!\n");
		cosmicKillFlag = true;
		this->Delete(1);
	}

	return true;
}