#ifndef __WORLD_CAMERA_H
#define __WORLD_CAMERA_H

#include <game.h>
#include <common.h>
#include <g3dhax.h>
#include "worldSelect.h"


class dWorldCamera_c : public dWMActorWithModel_c {
	public:
		u8 unk1[0x20];

		EGG::LookAtCamera camera0;
		EGG::Screen screen0;

		EGG::LookAtCamera camera3;
		EGG::Screen screen3;

		EGG::ProjectOrtho project1;
		EGG::LookAtCamera camera1;
		EGG::SimpleViewport viewport;

		u32 cameraID;
		u32 settings2;

		Vec field_4B0;
		Vec field_4BC;
		Vec camUp;
		Vec camPos0;
		Vec camTarget0;
		Vec lastCamTarget0_maybe;

		u32 field_4F8;

		u8 unk2[0xF0];
		float field_5EC;
		u8 unk3[0x14];

		u32 cameraMode;
		u32 someModeVar;

		u8 unk4[0x1C];

		Vec camPos3;
		Vec camTarget3;

		u8 unk5[0x64];

		Vec field_6A4;

		u8 unk6[0x10];
		u8 field_6C0;
		u8 unk7[3];

		u32 field_6C4;
		Vec field_6C8[4];
		float field_6F8;
		float field_6FC;

		u8 unk8[0x1C];

		float field_71C;
		u32 field_720;
		float field_724;
		float field_728;
		u32 field_72C;

		Vec field_730;
		u8 unk9[4];

		u32 field_740;
		u32 field_744;

		static dWorldCamera_c *build();
		static dWorldCamera_c *instance;
};

#endif

