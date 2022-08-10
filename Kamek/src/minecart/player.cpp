#include "minecart/player.h"

static const char *mdlNames[] = {"MB_model", "SMB_model", "PLMB_model", "PMB_model"};
static const char *patNames[] = {"PB_switch_swim", "PB_switch_swim", "PLMB_switch_swim", "PLB_switch_swim"};

dMCPlayer_c *dMCPlayer_c::instance = 0;

dMCPlayer_c *dMCPlayer_c::build() {

	void *buffer = AllocFromGameHeap1(sizeof(dMCPlayer_c));
	dMCPlayer_c *c = new(buffer) dMCPlayer_c;


	instance = c;
	return c;
}

#include <profile.h>
Profile MCPlayerProfile = Profile((buildFunc)&dMCPlayer_c::build, ProfileId::MC_PLAYER, 0, ProfileId::MC_PLAYER, ProfileId::MC_PLAYER, 0, "MC_PLAYER", 0);

int dMCPlayer_c::onCreate() {

	this->modelHandler = new dPlayerModelHandler_c(0);
	// loadModel(u8 player_id, int powerup_id, int unk);
	// Unk is some kind of mode: 0=in-game, 1=map, 2=2D

	// Here we do a bit of a hack
	//this->modelHandler->loadModel(0, 3, 1);
	dPlayerModel_c *pm = (dPlayerModel_c*)modelHandler->mdlClass;

	pm->mode_maybe = 1;
	pm->player_id_1 = 0;
	pm->allocator.link(0xC000, GameHeaps[0], 0, 0x20);
	pm->prepare();

	for (int i = 0; i < 4; i++) {
		nw4r::g3d::ResMdl mdl = pm->modelResFile.GetResMdl(mdlNames[i]);
		nw4r::g3d::ResAnmTexPat pat = pm->modelResFile.GetResAnmTexPat(patNames[i]);

		pats[i].setup(mdl, pat, &pm->allocator, 0, 1);
	}

	pm->allocator.unlink();
	pm->setPowerup(3);
	pm->finaliseModel();

	pm->startAnimation(0, 1.2, 10.0, 0.0);
	modelHandler->setSRT((Vec){0.0,100.0,-100.0}, (S16Vec){0,0,0}, (Vec){2.0,2.0,2.0});

	// hammerSuit.setup(this->modelHandler);

	pos = (Vec){0.0f,0.0f,3000.0f};
	rot = (S16Vec){0x4000,0,0};
	scale = (Vec){1.0f,1.0f,1.0f};

	hasEffect = false;
	hasSound = false;
	step = false;
	effectName = "";
	soundName = 0;
	timer = 0;
	jumpOffset = 0.0;

	// -1 or 0xC000? normally we use -1 but Player uses 0xC000....
	//allocator.link(0xC000, GameHeaps[0], 0, 0x20);
	//allocator.unlink();

	return true;
}

int dMCPlayer_c::onDelete() {
	delete modelHandler;

	return true;
}


int dMCPlayer_c::onExecute() {
	this->pos = (Vec){boundPos->x + posOffs.x, boundPos->y + posOffs.y, boundPos->z + posOffs.z};
	this->rot = (S16Vec){(s16)(boundRot->x + rotOffs.x), (s16)(boundRot->y + rotOffs.y), (s16)(boundRot->z + rotOffs.z)};

	if (Player_Flags[0] & 1) {
		modelHandler->mdlClass->enableStarColours();
		modelHandler->mdlClass->enableStarEffects();
		// dKPMusic::playStarMusic();
	}

	// if (spinning)
	// 	rot.y += 0xC00;
	// else
	// 	SmoothRotation(&rot.y, targetRotY, 0xC00);

	this->modelHandler->update();
	pats[((dPlayerModel_c*)modelHandler->mdlClass)->currentPlayerModelID].process();

	mMtx myMatrix;
	myMatrix.scale(scale.x, scale.y, scale.z);
	myMatrix.applyTranslation(pos.x, pos.y + jumpOffset, pos.z);
	myMatrix.applyRotationYXZ(&rot.x, &rot.y, &rot.z);
	// Z is unused for now
	modelHandler->setMatrix(myMatrix);

	if (dScMinecart_c::instance->loaded) {
		if (hasEffect) { 
			Vec effPos = {pos.x, pos.y, 3300.0f};
			effect.spawn(effectName, 0, &effPos, &rot, &scale);
		}

		if (hasSound) {
			timer++;

			if (timer == 12) {
				if (step) { MapSoundPlayer(SoundRelatedClass, soundName, 1); step = false; }
				else { MapSoundPlayer(SoundRelatedClass, soundName+1, 1); step = true; }
				timer = 0;
			}

			if (timer > 12) { timer = 0; }
		}
	}

	return true;
}

int dMCPlayer_c::onDraw() {
	if (!visible)
		return true;

	this->modelHandler->draw();
	// hammerSuit.draw();

	return true;
}


void dMCPlayer_c::startAnimation(int id, float frame, float unk, float updateRate) {
	if (id == currentAnim && frame == currentFrame && unk == currentUnk && updateRate == currentUpdateRate)
		return;

	bool isOldSwimming = (currentAnim == swim_wait);
	bool isNewSwimming = (id == swim_wait);

	currentAnim = id;
	currentFrame = frame;
	currentUnk = unk;
	currentUpdateRate = updateRate;
	this->modelHandler->mdlClass->startAnimation(id, frame, unk, updateRate);

	if (isOldSwimming != isNewSwimming)
		bindPats();
}

void dMCPlayer_c::bindPats() {
	dPlayerModel_c *pm = (dPlayerModel_c*)modelHandler->mdlClass;
	int id = pm->currentPlayerModelID;

	static const float frames[] = {0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 2.0f, 3.0f};
	float frame = frames[pm->powerup_id];
	if (currentAnim == swim_wait)
		frame += (pm->powerup_id == 4 || pm->powerup_id == 5) ? 1.0f : 4.0f;

	nw4r::g3d::ResAnmTexPat pat = pm->modelResFile.GetResAnmTexPat(patNames[id]);
	pats[id].bindEntry(
			&pm->models[id].body,
			&pat,
			0, 4);
	pats[id].setUpdateRateForEntry(0.0f, 0);
	pats[id].setFrameForEntry(frame, 0);

	pm->models[id].body.bindAnim(&pats[id]);
}