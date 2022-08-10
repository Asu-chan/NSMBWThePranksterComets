#include "doubleDate/rugby.h"


/****************/
/* Initializing */
/****************/

CREATE_STATE(dRHRugby_c, Init);
CREATE_STATE(dRHRugby_c, Act);
CREATE_STATE(dRHRugby_c, Shoot);
CREATE_STATE(dRHRugby_c, Miss);

// Instancing

dRHRugby_c *dRHRugby_c::build() {
	void *buffer = AllocFromGameHeap1(sizeof(dRHRugby_c));
	return new(buffer) dRHRugby_c;
}

#include <profile.h>
Profile RHRugbyProfile = Profile((buildFunc)&dRHRugby_c::build, ProfileId::RH_RUGBY, 0, ProfileId::RH_RUGBY, ProfileId::RH_RUGBY, 0, "RH_RUGBY", 0);

dRHRugby_c::dRHRugby_c() : acState(this, &StateID_Init) { }

dRHRugby_c::~dRHRugby_c() { }

/******************/
/* Main functions */
/******************/

int dRHRugby_c::onCreate() {
	if (!layoutLoaded) {
		if (!layout.loadArc("doubleDate/rugby.arc", false))
			return false;

		layout.build("rugby.brlyt");

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
int dRHRugby_c::onDelete() {
	return layout.free();
}

extern u8 currPlay;

int dRHRugby_c::onExecute() {
	layout.update();
	acState.execute();

	shadow->pos.x = this->pos.x;
	shadow->scale = this->scale;

	secondaryRoot->trans.x = this->pos.x;
	secondaryRoot->trans.y = this->pos.y;
	secondaryRoot->scale.x = this->scale.x;
	secondaryRoot->scale.y = this->scale.y;
	secondaryRoot->rotate.z = this->rotZ;

	this->rotZ += (this->rotatingBackwards) ? 7.2f : -7.2f;
	if(this->rotZ < -360.0f) this->rotZ += 360.0f;
	if(this->rotZ > 360.0f) this->rotZ -= 360.0f;

	return true;
}

int dRHRugby_c::onDraw() {
	if(visible) {
		layout.scheduleForDrawing();
	}

	return true;
}

void dRHRugby_c::act() {
	acState.setState(&StateID_Act);
}

int dRHRugby_c::canBeShoot() { // Absolute perfect is 118
	if(acState.getCurrentState() == &StateID_Act) {
		if(this->actFrame == 118) {
			acState.setState(&StateID_Shoot);
			this->leaves->leavesFall();
			return 3;
		}
		return 4;

		if(this->actFrame >= 116 && this->actFrame <= 120) {
			acState.setState(&StateID_Shoot);
			this->leaves->leavesFall();
			return 3;
		}
		if(this->actFrame == 123) {
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

void dRHRugby_c::beginState_Init() {
	OSReport("Init Rugby.\n");
	this->scale = (Vec2){0.0f, 0.0f};
	this->busy = false;
}

void dRHRugby_c::executeState_Init() {

}

void dRHRugby_c::endState_Init() {
	
}

u32 rugbySFXFrames[] = {46, 88, 134, 146, 194, 0xFFFF};
u32 rugbySFXIDs[] = {SFX_RHDD_BOUNCE_RUGBY, SFX_RHDD_BOUNCE_RUGBY, SFX_RHDD_BOUNCE_GRASS1, SFX_RHDD_GET_REKT, SFX_RHDD_BOUNCE_GRASS3, 0xFFFF};

// Act State

void dRHRugby_c::beginState_Act() {
	OSReport("Act Rugby.\n");
	this->scale = (Vec2){0.8f, 0.8f};
	this->actTimer = 0.0f;
	this->actFrame = 0;
	this->busy = true;

	this->rotatingBackwards = false;
	this->currentSFXWait = 0;
}

void dRHRugby_c::executeState_Act() {
	if(this->actTimer >= 0 && this->actTimer < 19) {
		this->pos.x = (6.37037f * this->actTimer) + -458.037f;
		this->pos.y = (185.0f * cos((this->actTimer + -19.0f) / (2.0f * (27.0f / M_PI)))) + -85.0f;
	}
	else if(this->actTimer >= 19 && this->actTimer < 46) {
		this->pos.x = (6.333333f * this->actTimer) + -457.3333f;
		this->pos.y = (185.0f * cos((this->actTimer + -19.0f) / (2.0f * (27.0f / M_PI)))) + -85.0f;
	}
	else if(this->actTimer >= 46 && this->actTimer < 66) {
		this->rotatingBackwards = true;

		this->pos.x = (-3.65f * this->actTimer) + 1.900004f;
		this->pos.y = (284.0f * cos((this->actTimer + -66.0f) / (2.0f * (20.0f / M_PI)))) + -85.0f;
	}
	else if(this->actTimer >= 66 && this->actTimer < 88) {
		this->pos.x = (-3.409091f * this->actTimer) + -13.99999f;
		this->pos.y = (286.0f * cos((this->actTimer + -66.0f) / (2.0f * (22.0f / M_PI)))) + -87.0f;
	}
	else if(this->actTimer >= 88 && this->actTimer < 111) {
		this->rotatingBackwards = false;
		this->pos.x = (6.26087f * this->actTimer) + -864.9565f;
		this->pos.y = (106.0f * cos((this->actTimer + -111.0f) / (2.0f * (23.0f / M_PI)))) + -87.0f;
	}
	else if(this->actTimer >= 111 && this->actTimer < 134) {
		this->pos.x = (8.521739f * this->actTimer) + -1115.913f;
		this->pos.y = (110.0f * cos((this->actTimer + -111.0f) / (2.0f * (23.0f / M_PI)))) + -91.0f;
	}
	else if(this->actTimer >= 134 && this->actTimer < 141) {
		this->pos.x = (6.285714f * this->actTimer) + -816.2857f;
		this->pos.y = (41.0f * cos((this->actTimer + -141.0f) / (2.0f * (7.0f / M_PI)))) + -91.0f;
	}
	else if(this->actTimer >= 141 && this->actTimer < 146) {
		this->pos.x = (12.0f * this->actTimer) + -1622.0f;
		this->pos.y = (20.0f * cos((this->actTimer + -141.0f) / (2.0f * (5.0f / M_PI)))) + -70.0f;
	}
	else if(this->actTimer >= 146 && this->actTimer < 171) {
		this->pos.x = (5.64f * this->actTimer) + -693.44f;
		this->pos.y = (249.0f * cos((this->actTimer + -171.0f) / (2.0f * (25.0f / M_PI)))) + -70.0f;
	}
	else if(this->actTimer >= 171 && this->actTimer < 194) {
		this->pos.x = (5.913043f * this->actTimer) + -740.1304f;
		this->pos.y = (275.0f * cos((this->actTimer + -171.0f) / (2.0f * (23.0f / M_PI)))) + -96.0f;
	}
	else if(this->actTimer >= 194 && this->actTimer < 210) {
		this->pos.x = (6.5f * this->actTimer) + -854.0f;
		this->pos.y = (27.0f * cos((this->actTimer + -202.0f) / (2.0f * (8.0f / M_PI)))) + -96.0f;
	}
	else {
		acState.setState(&StateID_Init);
	}

	if (!IsWideScreen()) 
		this->pos.x *= 0.7245f;

	if(Remocon_GetPressed(GetActiveRemocon()) & WPAD_A) {
		OSReport("rugbyframe: %d\n", this->actFrame);
	}

	this->actTimer += 1.0f;
	this->actFrame++;


	if(this->actTimer >= rugbySFXFrames[this->currentSFXWait]) {
		PlaySoundWithFunctionB4(SoundRelatedClass, &notaballSHandle, rugbySFXIDs[this->currentSFXWait], 1);
		this->currentSFXWait++;
	}
}

void dRHRugby_c::endState_Act() {

}

// Shoot State

void dRHRugby_c::beginState_Shoot() {
	OSReport("Shoot Rugby: %d.\n", this->actFrame);
	this->actFrame = 0;
}

void dRHRugby_c::executeState_Shoot() {
	this->pos.x -= 10.0f;
	this->pos.y += 35.0f;
	this->actFrame++;

	if(this->actFrame == 10) {
		acState.setState(&StateID_Init);
	}
}

void dRHRugby_c::endState_Shoot() {
	
}

// Miss State

void dRHRugby_c::beginState_Miss() {
	OSReport("Miss Rugby.\n");
	this->actFrame = 0;
}

void dRHRugby_c::executeState_Miss() {
	this->actFrame++;

	if(this->actFrame == 1) {
		acState.setState(&StateID_Init);
	}
}

void dRHRugby_c::endState_Miss() {
	
}