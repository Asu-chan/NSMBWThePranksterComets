#include "doubleDate/leaves.h"


/****************/
/* Initializing */
/****************/

// Instancing

dRHLeaves_c *dRHLeaves_c::build() {
	void *buffer = AllocFromGameHeap1(sizeof(dRHLeaves_c));
	return new(buffer) dRHLeaves_c;
}

#include <profile.h>
Profile RHLeavesProfile = Profile((buildFunc)&dRHLeaves_c::build, ProfileId::RH_LEAVES, 0, ProfileId::RH_LEAVES, ProfileId::RH_LEAVES, 0, "RH_LEAVES", 0);

dRHLeaves_c::dRHLeaves_c() { }

dRHLeaves_c::~dRHLeaves_c() { }

/******************/
/* Main functions */
/******************/

// u32 leavescnt = 0;

int dRHLeaves_c::onCreate() {
	// OSReport("Loading leavescnt %d\n", leavescnt);
	if (!layoutLoaded) {
		if (!layout.loadArc("doubleDate/leaves.arc", false))
			return false;

		static const char *brlanNames[] = {
			"leaves_leaf.brlan",
		};
		static const char *groupNames[] = {
			"A00_leaf",
		};
		static const int groupIDs[] = {
			0,
		};

		layout.build("leaves.brlyt");
		layout.loadAnimations(brlanNames, 1);
		layout.loadGroups(groupNames, groupIDs, 1);
		layout.disableAllAnimations();
		layout.resetAnim(0);

		layoutLoaded = true;
		visible = true;

		layout.drawOrder = 25;

		this->pos = (Vec2){0.0f, 0.0f};
		this->scale = (Vec2){1.0f, 1.0f};

		// leavescnt++;
	}

	return true;
}
int dRHLeaves_c::onDelete() {
	return layout.free();
}

extern u8 currPlay;

int dRHLeaves_c::onExecute() {
	layout.update();

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

int dRHLeaves_c::onDraw() {
	if(visible) {
		layout.scheduleForDrawing();
	}

	return true;
}

void dRHLeaves_c::leavesFall() {
	leavesTimer = 45;
}
