#ifndef __NEWER_COSMICCLONE_H
#define __NEWER_COSMICCLONE_H

#include <common.h>
#include <game.h>
#include <g3dhax.h>
#include <sfx.h>

// class AnimState { //Total: 0x24
// 	char* animName;
// 	char* animNameR;
// 	char* animNameYb;
// 	char* animNameP;
// 	u32 doesLoop;
// 	float unk1;
// 	float unk2;
// 	u32 unk3;
// 	u32 flags;
// };

class CosmicBuffer { // Total: 40
public:
	Vec pos;
	S16Vec rot;
	int anim;
	int subAnim;
	float animFrame;
	float subAnimFrame;
};

#endif

