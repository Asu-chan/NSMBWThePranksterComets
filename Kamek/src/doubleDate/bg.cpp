#include "doubleDate/bg.h"


/****************/
/* Initializing */
/****************/

CREATE_STATE(dRHBackground_c, Init);

// Instancing

dRHBackground_c *dRHBackground_c::build() {
	void *buffer = AllocFromGameHeap1(sizeof(dRHBackground_c));
	return new(buffer) dRHBackground_c;
}

#include <profile.h>
Profile RHBGProfile = Profile((buildFunc)&dRHBackground_c::build, ProfileId::RH_BG, 0, ProfileId::RH_BG, ProfileId::RH_BG, 0, "RH_BG", 0);

dRHBackground_c::dRHBackground_c() : acState(this, &StateID_Init) { }

dRHBackground_c::~dRHBackground_c() { }

/******************/
/* Main functions */
/******************/

int dRHBackground_c::onCreate() {
	if (!layoutLoaded) {
		if (!layout.loadArc("doubleDate/bg.arc", false))
			return false;


		static const char *brlanNames[] = {
			"doubleDateBG_leaf.brlan",
		};
		static const char *groupNames[] = {
			"A00_leaf",
		};
		static const int groupIDs[] = {
			0,
		};

		layout.build("doubleDateBG.brlyt");
		layout.loadAnimations(brlanNames, 1);
		layout.loadGroups(groupNames, groupIDs, 1);
		layout.disableAllAnimations();
		layout.resetAnim(0);

		layoutLoaded = true;
		visible = true;

		layout.drawOrder = 0;

		this->pos = (Vec2){0.0f, 0.0f};
		this->scale = (Vec2){1.0f, 1.0f};
	}

	return true;
}
int dRHBackground_c::onDelete() {
	return layout.free();
}

extern u8 currPlay;

int dRHBackground_c::onExecute() {
	layout.update();
	acState.execute();

	layout.execAnimations();

	layout.layout.rootPane->trans.x = this->pos.x;
	layout.layout.rootPane->trans.y = this->pos.y;
	layout.layout.rootPane->scale.x = this->scale.x;
	layout.layout.rootPane->scale.y = this->scale.y;

	if(leavesTimer) leavesTimer--;
	if(leavesTimer == 1) {
		if(!layout.isAnimOn(0))
			layout.enableNonLoopAnim(0);
	}

	return true;
}

int dRHBackground_c::onDraw() {
	if(visible) {
		layout.scheduleForDrawing();
	}

	return true;
}

void dRHBackground_c::leavesShake() {
	leavesTimer = 39;
}

/**********/
/* States */
/**********/

// Init State

void dRHBackground_c::beginState_Init() {
	OSReport("Init BG.\n");
}

void dRHBackground_c::executeState_Init() {

}

void dRHBackground_c::endState_Init() {
	
}

