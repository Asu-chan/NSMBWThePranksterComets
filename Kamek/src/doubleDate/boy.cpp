#include "doubleDate/bench.h"


/****************/
/* Initializing */
/****************/

// Instancing

dRHBoy_c *dRHBoy_c::build() {
	void *buffer = AllocFromGameHeap1(sizeof(dRHBoy_c));
	return new(buffer) dRHBoy_c;
}

#include <profile.h>
Profile RHBoyProfile = Profile((buildFunc)&dRHBoy_c::build, ProfileId::RH_BOY, 0, ProfileId::RH_BOY, ProfileId::RH_BOY, 0, "RH_BOY", 0);

dRHBoy_c::dRHBoy_c() { }

dRHBoy_c::~dRHBoy_c() { }

/******************/
/* Main functions */
/******************/

int dRHBoy_c::onCreate() {
	if (!layoutLoaded) {
		if (!layout.loadArc("doubleDate/boy.arc", false))
			return false;

		static const char *brlanNames[] = {
			"boy_beat.brlan",
			"boy_beat_T.brlan",
			"boy_kick.brlan",
			"boy_miss.brlan",
		};
		static const char *groupNames[] = {
			"A00_All",
			"A00_All",
			"A00_All",
			"A00_All",
		};
		static const int groupIDs[] = {
			0,
			1,
			2,
			3,
		};

		layout.build("boy.brlyt");
		layout.loadAnimations(brlanNames, 4);
		layout.loadGroups(groupNames, groupIDs, 4);
		layout.disableAllAnimations();
		layout.resetAnim(0);

		layoutLoaded = true;
		visible = true;

		layout.drawOrder = 100;

		this->pos = (Vec2){-44.0f, 30.0f};
		this->scale = (Vec2){0.8f, 0.8f};
	}

	return true;
}
int dRHBoy_c::onDelete() {
	return layout.free();
}

extern u8 currPlay;

int dRHBoy_c::onExecute() {
	layout.update();

	layout.execAnimations();

	layout.layout.rootPane->trans.x = this->pos.x;
	layout.layout.rootPane->trans.y = this->pos.y;
	layout.layout.rootPane->scale.x = this->scale.x;
	layout.layout.rootPane->scale.y = this->scale.y;

	if(waitBeforeHit) waitBeforeHit--;

	return true;
}

int dRHBoy_c::onDraw() {
	if(visible) {
		layout.scheduleForDrawing();
	}

	return true;
}

void dRHBoy_c::beat() {
	if(!layout.isAnimOn(1) && !layout.isAnimOn(2) && !layout.isAnimOn(3))
		layout.enableNonLoopAnim(0);
}

bool dRHBoy_c::canKick() {
	return (!layout.isAnimOn(3) && (waitBeforeHit == 0));
}

void dRHBoy_c::kick(int anim, u32 sound) {
	layout.enableNonLoopAnim(anim);
	PlaySoundWithFunctionB4(SoundRelatedClass, &boySHandle, sound, 1);
	waitBeforeHit = 15;
}

void dRHBoy_c::blush() {
	layout.disableAllAnimations();
	layout.enableNonLoopAnim(0);
}

