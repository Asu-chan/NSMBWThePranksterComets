#include "doubleDate/bench.h"


/****************/
/* Initializing */
/****************/

// Instancing

dRHGirl_c *dRHGirl_c::build() {
	void *buffer = AllocFromGameHeap1(sizeof(dRHGirl_c));
	return new(buffer) dRHGirl_c;
}

#include <profile.h>
Profile RHGirlProfile = Profile((buildFunc)&dRHGirl_c::build, ProfileId::RH_GIRL, 0, ProfileId::RH_GIRL, ProfileId::RH_GIRL, 0, "RH_GIRL", 0);

dRHGirl_c::dRHGirl_c() { }

dRHGirl_c::~dRHGirl_c() { }

/******************/
/* Main functions */
/******************/

int dRHGirl_c::onCreate() {
	if (!layoutLoaded) {
		if (!layout.loadArc("doubleDate/girl.arc", false))
			return false;

		static const char *brlanNames[] = {
			"girl_beat.brlan",
			"girl_look.brlan",
			"girl_sad.brlan",
			"girl_smile.brlan",
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

		layout.build("girl.brlyt");
		layout.loadAnimations(brlanNames, 4);
		layout.loadGroups(groupNames, groupIDs, 4);
		layout.disableAllAnimations();
		layout.resetAnim(0);

		layoutLoaded = true;
		visible = true;

		layout.drawOrder = 100;

		this->pos = (Vec2){44.0f, 24.0f};
		this->scale = (Vec2){0.8f, 0.8f};
	}

	return true;
}
int dRHGirl_c::onDelete() {
	return layout.free();
}

extern u8 currPlay;

int dRHGirl_c::onExecute() {
	layout.update();

	layout.execAnimations();

	layout.layout.rootPane->trans.x = this->pos.x;
	layout.layout.rootPane->trans.y = this->pos.y;
	layout.layout.rootPane->scale.x = this->scale.x;
	layout.layout.rootPane->scale.y = this->scale.y;

	return true;
}

int dRHGirl_c::onDraw() {
	if(visible) {
		layout.scheduleForDrawing();
	}

	return true;
}

void dRHGirl_c::beat() {
	if(!layout.isAnimOn(1) && !layout.isAnimOn(2) && !layout.isAnimOn(3))
		layout.enableNonLoopAnim(0);
}

void dRHGirl_c::blush() {
	layout.enableNonLoopAnim(3);
}
