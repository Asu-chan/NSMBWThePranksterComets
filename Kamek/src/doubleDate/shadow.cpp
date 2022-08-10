#include "doubleDate/shadow.h"


/****************/
/* Initializing */
/****************/

// Instancing

dRHShadow_c *dRHShadow_c::build() {
	void *buffer = AllocFromGameHeap1(sizeof(dRHShadow_c));
	return new(buffer) dRHShadow_c;
}

#include <profile.h>
Profile RHShadowProfile = Profile((buildFunc)&dRHShadow_c::build, ProfileId::RH_SHADOW, 0, ProfileId::RH_SHADOW, ProfileId::RH_SHADOW, 0, "RH_SHADOW", 0);

dRHShadow_c::dRHShadow_c() { }

dRHShadow_c::~dRHShadow_c() { }

/******************/
/* Main functions */
/******************/

// u32 shadcnt = 0;

int dRHShadow_c::onCreate() {
	// OSReport("Loading shadcnt %d\n", shadcnt);
	if (!layoutLoaded) {
		if (!layout.loadArc("doubleDate/shadow.arc", false))
			return false;

		layout.build("shadow.brlyt");

		layoutLoaded = true;
		visible = true;

		layout.drawOrder = 125;

		if (IsWideScreen()) 
			layout.layout.rootPane->scale.x = 0.735f;

		this->pos = (Vec2){0.0f, -122.0f};
		this->scale = (Vec2){0.0f, 0.0f};

		this->secondaryRoot = layout.findPaneByName("N_doubleDate_00");

		// shadcnt++;
	}

	return true;
}
int dRHShadow_c::onDelete() {
	return layout.free();
}

extern u8 currPlay;

int dRHShadow_c::onExecute() {
	layout.update();

	secondaryRoot->trans.x = this->pos.x;
	secondaryRoot->trans.y = this->pos.y;
	secondaryRoot->scale.x = this->scale.x;
	secondaryRoot->scale.y = this->scale.y;


	return true;
}

int dRHShadow_c::onDraw() {
	if(visible) {
		layout.scheduleForDrawing();
	}

	return true;
}
