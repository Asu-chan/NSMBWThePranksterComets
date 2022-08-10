#ifndef __NEWER_WORLDSELECT_H
#define __NEWER_WORLDSELECT_H

#include <game.h>
#include <common.h>

class dWMActor_c : public dActor_c {
public:
	u8 _125, _126, _127;
	u32 _128, _12C, _30;
	float _134;
};

class dWMActorWithModel_c : public dWMActor_c {
public:
	u8 _138, _139, _13A, _13B;
	mHeapAllocator_c allocator;
	m3d::mdl_c bodyModel;
};

class daCometModel_c : public dWMActorWithModel_c {
public:
	int onCreate();
	int onExecute();
	int onDelete();
	// int onDraw();
	virtual void specialDraw1();

	nw4r::g3d::ResFile resFile;
	m3d::anmChr_c animationChr;
	m3d::anmChr_c animationChr2;
	m3d::mdl_c disabledModel;

	int starID;
	bool isEnabled;
	bool invisible;

	static daCometModel_c *build();

	void updateModelMatrices();
	void bindAnimChr_and_setUpdateRate(const char* name, int unk, float unk2, float rate);
};

bool areWorldLevelsFinished(u32 worldID);


#endif