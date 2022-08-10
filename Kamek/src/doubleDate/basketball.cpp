#include "doubleDate/basketball.h"


/****************/
/* Initializing */
/****************/

CREATE_STATE(dRHBasketball_c, Init);
CREATE_STATE(dRHBasketball_c, Act);
CREATE_STATE(dRHBasketball_c, Shoot);
CREATE_STATE(dRHBasketball_c, Miss);

// Instancing

dRHBasketball_c *dRHBasketball_c::build() {
	void *buffer = AllocFromGameHeap1(sizeof(dRHBasketball_c));
	return new(buffer) dRHBasketball_c;
}

#include <profile.h>
Profile RHBasketballProfile = Profile((buildFunc)&dRHBasketball_c::build, ProfileId::RH_BASKETBALL, 0, ProfileId::RH_BASKETBALL, ProfileId::RH_BASKETBALL, 0, "RH_BASKETBALL", 0);

dRHBasketball_c::dRHBasketball_c() : acState(this, &StateID_Init) { }

dRHBasketball_c::~dRHBasketball_c() { }

/******************/
/* Main functions */
/******************/

int dRHBasketball_c::onCreate() {
	if (!layoutLoaded) {
		if (!layout.loadArc("doubleDate/basketball.arc", false))
			return false;

		layout.build("basketball.brlyt");

		layoutLoaded = true;
		visible = true;

		layout.drawOrder = 150;

		if (IsWideScreen()) 
			layout.layout.rootPane->scale.x = 0.735f;

		this->pos = (Vec2){0.0f, 0.0f};
		this->scale = (Vec2){0.0f, 0.0f};

		// shadow = (dRHShadow_c*)CreateParentedObject(RH_SHADOW, this, 0, 0);
		// leaves = (dRHLeaves_c*)CreateParentedObject(RH_LEAVES, this, 0, 0);

		this->secondaryRoot = layout.findPaneByName("N_doubleDate_00");
		this->busy = false;
	}

	return true;
}
int dRHBasketball_c::onDelete() {
	return layout.free();
}

int dRHBasketball_c::onExecute() {
	layout.update();
	acState.execute();

	shadow->pos.x = this->pos.x;
	shadow->scale = this->scale;

	secondaryRoot->trans.x = this->pos.x;
	secondaryRoot->trans.y = this->pos.y;
	secondaryRoot->scale.x = this->scale.x;
	secondaryRoot->scale.y = this->scale.y;
	secondaryRoot->rotate.z = this->rotZ;

	this->rotZ -= 7.2f;
	if(this->rotZ < -360.0f) this->rotZ += 360.0f;

	return true;
}

int dRHBasketball_c::onDraw() {
	if(visible) {
		layout.scheduleForDrawing();
	}

	return true;
}

void dRHBasketball_c::act() {
	acState.setState(&StateID_Act);
}

int dRHBasketball_c::canBeShoot() { // Absolute perfect is 92
	if(acState.getCurrentState() == &StateID_Act) {
		if(this->actFrame == 92) {
			acState.setState(&StateID_Shoot);
			this->leaves->leavesFall();
			return 1;
		}
		return 4;

		if(this->actFrame >= 90 && this->actFrame <= 94) {
			acState.setState(&StateID_Shoot);
			this->leaves->leavesFall();
			return 1;
		}
		if(this->actFrame == 99) {
			acState.setState(&StateID_Miss);
			return 2;
		}
	}
	return 0;
}

/**********/
/* States */
/**********/

// Init State

void dRHBasketball_c::beginState_Init() {
	OSReport("Init Basketball.\n");
	this->scale = (Vec2){0.0f, 0.0f};
	this->busy = false;
}

void dRHBasketball_c::executeState_Init() {

}

void dRHBasketball_c::endState_Init() {
	
}

u32 basketballSFXFrames[] = {46, 83, 119, 161, 210, 0xFFFF};
u32 basketballSFXIDs[] = {SFX_RHDD_BOUNCE_BASKETBALL, SFX_RHDD_BOUNCE_BASKETBALL, SFX_RHDD_BOUNCE_GRASS1, SFX_RHDD_BOUNCE_GRASS2, SFX_RHDD_BOUNCE_GRASS3, 0xFFFF};

// Act State

void dRHBasketball_c::beginState_Act() {
	OSReport("Act Basketball.\n");
	this->scale = (Vec2){0.8f, 0.8f};
	this->actTimer = 0.0f;
	this->actFrame = 0;
	this->busy = true;

	this->currentSFXWait = 0;
}

void dRHBasketball_c::executeState_Act() {
	if(this->actTimer >= 0 && this->actTimer < 46) {
		this->pos.x = (3.111111f * this->actTimer) + -500.1111f;
		this->pos.y = (189.0f * cos((this->actTimer + -19.0f) / (2.0f * (27.0f / M_PI)))) + -89.0f;
	}
	else if(this->actTimer >= 46 && this->actTimer < 64) {
		this->pos.x = (4.777778f * this->actTimer) + -576.7778f;
		this->pos.y = (89.0f * cos((this->actTimer + -64.0f) / (2.0f * (18.0f / M_PI)))) + -89.0f;
	}
	else if(this->actTimer >= 64 && this->actTimer < 83) {
		this->pos.x = (4.736842f * this->actTimer) + -574.1579f;
		this->pos.y = (100.0f * cos((this->actTimer + -64.0f) / (2.0f * (19.0f / M_PI)))) + -100.0f;
	}
	else if(this->actTimer >= 83 && this->actTimer < 101) {
		this->pos.x = (5.055555f * this->actTimer) + -600.6111f;
		this->pos.y = (80.0f * cos((this->actTimer + -101.0f) / (2.0f * (18.0f / M_PI)))) + -100.0f;
	}
	else if(this->actTimer >= 101 && this->actTimer < 119) {
		this->pos.x = (5.333333f * this->actTimer) + -628.6667f;
		this->pos.y = (75.0f * cos((this->actTimer + -101.0f) / (2.0f * (18.0f / M_PI)))) + -95.0f;
	}
	else if(this->actTimer >= 119 && this->actTimer < 140) {
		this->pos.x = (5.285714f * this->actTimer) + -623.0f;
		this->pos.y = (55.0f * cos((this->actTimer + -140.0f) / (2.0f * (21.0f / M_PI)))) + -95.0f;
	}
	else if(this->actTimer >= 140 && this->actTimer < 161) {
		this->pos.x = (5.380952f * this->actTimer) + -636.3333f;
		this->pos.y = (60.0f * cos((this->actTimer + -140.0f) / (2.0f * (21.0f / M_PI)))) + -100.0f;
	}
	else if(this->actTimer >= 161 && this->actTimer < 182) {
		this->pos.x = (5.142857f * this->actTimer) + -598.0f;
		this->pos.y = (40.0f * cos((this->actTimer + -182.0f) / (2.0f * (21.0f / M_PI)))) + -100.0f;
	}
	else if(this->actTimer >= 182 && this->actTimer < 210) {
		this->pos.x = (4.904762f * this->actTimer) + -554.6666f;
		this->pos.y = (40.0f * cos((this->actTimer + -182.0f) / (2.0f * (21.0f / M_PI)))) + -100.0f;
	}
	else {
		acState.setState(&StateID_Init);
	}

	if (!IsWideScreen()) 
		this->pos.x *= 0.7245f;

	if(Remocon_GetPressed(GetActiveRemocon()) & WPAD_A) {
		OSReport("basketframe: %d\n", this->actFrame);
	}

	this->actTimer += 1.0f;
	this->actFrame++;


	if(this->actTimer >= basketballSFXFrames[this->currentSFXWait]) {
		PlaySoundWithFunctionB4(SoundRelatedClass, &ballSHandle, basketballSFXIDs[this->currentSFXWait], 1);
		this->currentSFXWait++;
	}
}

void dRHBasketball_c::endState_Act() {

}

// Shoot State

void dRHBasketball_c::beginState_Shoot() {
	OSReport("Shoot Basketball: %d.\n", this->actFrame);
	this->actFrame = 0;
}

void dRHBasketball_c::executeState_Shoot() {
	this->pos.x -= 10.0f;
	this->pos.y += 35.0f;
	this->actFrame++;

	if(this->actFrame == 10) {
		acState.setState(&StateID_Init);
	}
}

void dRHBasketball_c::endState_Shoot() {
	
}

// Miss State

void dRHBasketball_c::beginState_Miss() {
	OSReport("Miss Basketball.\n");
	this->actFrame = 0;
}

void dRHBasketball_c::executeState_Miss() {
	this->actFrame++;

	if(this->actFrame == 1) {
		acState.setState(&StateID_Init);
	}
}

void dRHBasketball_c::endState_Miss() {
	
}