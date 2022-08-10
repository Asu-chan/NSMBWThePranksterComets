#include "minecart/core.h"
#include "creditsCam.h"


/****************/
/* Initializing */
/****************/

CREATE_STATE(dScMinecart_c, Init);

// Instancing
dScMinecart_c *dScMinecart_c::instance = 0;

dScMinecart_c *dScMinecart_c::build() {
	void *buffer = AllocFromGameHeap1(sizeof(dScMinecart_c));
	dScMinecart_c *c = new(buffer) dScMinecart_c;

	instance = c;
	return c;
}

#include <profile.h>
Profile MinecartProfile = Profile((buildFunc)&dScMinecart_c::build, ProfileId::MINECART, 0, ProfileId::MINECART, ProfileId::MINECART, 0, "MINECART", 0);

dScMinecart_c::dScMinecart_c() : acState(this, &StateID_Init) {
	yesNoWindow = (dYesNoWindow_c*)CreateParentedObject(YES_NO_WINDOW, this, 0, 0);
	CreateParentedObject(SELECT_CURSOR, this, 0, 0);

	dCreditsCamera_c *cam = (dCreditsCamera_c*)CreateParentedObject(STAFFCREDITS_CAMERA, this, 0, 0);
	cam->currentX = -522.52f;
	cam->currentY = 140.0f;
	cam->currentZ = 495.0f;

	DVD_LoadFile(GetDVDClass(), "Minecart", "minecart", 0);
	// DVD_LoadFile(GetDVDClass(), "Minecart", "CaveBG", 0);
}

dScMinecart_c::~dScMinecart_c() {
}

/******************/
/* Main functions */
/******************/

extern "C" void MakeScene(u32 heap, u32 unk);
extern "C" void LoadMapScene();

dMCNode_c *nodes[10] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

int nodeCount = 6;
Vec3 nodePos[] = {  (Vec){-740.8f, 59.4f, 0.0f},
					(Vec){-361.2f, 59.4f, 0.0f},
					(Vec){-65.1f, 59.4f, -296.2f},
					(Vec){177.0f, 42.5f, -331.7f},
					(Vec){507.9f, 59.4f, 0.0f},
					(Vec){850.0f, 59.4f, 0.0f},
				 };
Vec3 camPos[] = {   (Vec){-367.9f, 194.4f, 495.0f},
					(Vec){-367.9f, 194.4f, 495.0f},
					(Vec){0.3f, 194.4f, 71.3f},
					(Vec){64.6f, 127.4f, 71.3f},
					(Vec){497.6f, 146.7f, 366.6f},
					(Vec){497.6f, 146.7f, 366.6f},
				 };
Vec3 camOffets[] = { (Vec){0.0f, 60.3f, 0.0f},
					(Vec){0.0f, 60.3f, 0.0f},
					(Vec){0.0f, 45.5f, 0.0f},
					(Vec){0.0f, 34.0f, 0.0f},
					(Vec){0.0f, 34.0f, 0.0f},
					(Vec){0.0f, 34.0f, 0.0f},
				 };

int dScMinecart_c::onCreate() {
	*CurrentDrawFunc = MinecartDrawFunc;
	if(!loaded) {
		// OSReport("loading\n");
		if (!bgLoader.load("/Minecart/CaveBG.brres"))
			return false;
		if (DVD_StillLoading(GetDVDClass2()))
			return false;
		// OSReport("loaded\n");

		LoadMapScene();
		GameSetup__LoadScene(0);

		loaded = true;

		/*******************/
		/* 3D Models stuff */
		/*******************/

		bgPos = (Vec){0.0f, 0.0f, 0.0f};
		minecartPos = (Vec){-618.8f, 59.4f, 0.0f};
		minecartRot = (S16Vec){0, -0x4000, 0};
		minecartScale = (Vec){0.01f, 0.01f, 0.01f};

		allocator.link(-1, GameHeaps[0], 0, 0x20);

		// BG

		nw4r::g3d::ResFile rf(bgLoader.buffer);
		rf.CheckRevision();
		rf.Init();
		rf.Bind(rf);

		nw4r::g3d::ResMdl bgModelRes = rf.GetResMdl("CaveBG");
		nw4r::g3d::ResAnmChr anmResChr = rf.GetResAnmChr("CaveBG");
		nw4r::g3d::ResAnmTexSrt anmResSrt = rf.GetResAnmTexSrt("CaveBG");


		bgModel.setup(bgModelRes, &allocator, 0x32C, 1, 0);

		bgChrAnm.setup(bgModelRes, anmResChr, &allocator, 0);
		bgChrAnm.bind(&bgModel, anmResChr, 0);
		bgModel.bindAnim(&bgChrAnm, 0.0f);

		bgSrtAnm.setup(bgModelRes, anmResSrt, &allocator, 0, 1);
		bgSrtAnm.bindEntry(&bgModel, anmResSrt, 0, 0);
		bgModel.bindAnim(&bgSrtAnm, 0.0f);

		nw4r::g3d::ResFile rf2(getResource("minecart", "g3d/minecart.brres"));
		rf2.CheckRevision();
		rf2.Init();
		rf2.Bind(rf2);

		nw4r::g3d::ResMdl minecartModelRes = rf2.GetResMdl("minecart");
		nw4r::g3d::ResAnmChr minecartAnmResChr = rf2.GetResAnmChr("run");

		minecartModel.setup(minecartModelRes, &allocator, 0x32C, 1, 0);
		SetupTextures_MapObj(&minecartModel, 0);

		minecartChrAnm.setup(minecartModelRes, minecartAnmResChr, &allocator, 0);
		minecartChrAnm.bind(&minecartModel, minecartAnmResChr, 0);
		minecartModel.bindAnim(&minecartChrAnm, 0.0f);

		allocator.unlink();

		// Players

		player = (dMCPlayer_c*)CreateParentedObject(MC_PLAYER, this, 0, 0);
		player->modelHandler->mdlClass->setPowerup(Player_Powerup[0]);
		player->bindPats();
		player->modelHandler->mdlClass->startAnimation(0, 1.2f, 10.0f, 0.0f);

		player->boundPos = &minecartPos;
		player->boundRot = &minecartRot;
		player->posOffs = (Vec){0.0f, 20.8f, 0.0f};
		player->rotOffs = (S16Vec){0, 0x7FFF, 0};

		// Camera

		dCreditsCamera_c *cam = dCreditsCamera_c::instance;
		cam->isBound = true;
		cam->boundTo = &camRPos;
		cam->boundStart = minecartPos;
		cam->posStart = *(Vec*)&cam->currentX;

		cam->bdMin.x = -522.52f;
		cam->bdMax.x = 609.2f;

		cam->bdMin.y = 52.0f;
		cam->bdMax.y = 116.2f;

		cam->bdMin.z = 1.0f;
		cam->bdMax.z = 495.0f;

		cam->isTargetted = true;
		cam->target = &camTarget;

		// Nodes

		for(int i = 0; i < nodeCount; i++) {
			nodes[i] = (dMCNode_c*)CreateParentedObject(MC_NODE, this, 0, 0);
			nodes[i]->nodePos = nodePos[i];
		}
		minecartPos = nodePos[0];
		camRPos = camPos[0];
		camOffs = camOffets[0];
		currentNode = 0;

	}

	return true;
}
int dScMinecart_c::onDelete() {
	FreeScene(0);
	FreeScene(1);

	CleanUpEffectThings();
	FreeEffects(1);
	FreeBreff(1);
	FreeBreft(1);

	DVD_FreeFile(GetDVDClass2(), "minecart");
	// DVD_FreeFile(GetDVDClass2(), "CaveBG");

	return true;
}

extern bool doRot;
extern u8 currPlay;

int dScMinecart_c::onExecute() {
	/********************/
	/* Model processing */
	/********************/

	// BG

	bgChrAnm.process();
	bgSrtAnm.process();
	
	bgMatrix.translation(bgPos.x, bgPos.y, bgPos.z);
	bgModel.setDrawMatrix(bgMatrix);
	bgModel.setScale(1.0f, 1.0f, 1.0f);
	bgModel.calcWorld(false);

	if(bgChrAnm.isAnimationDone())
		bgChrAnm.setCurrentFrame(0.0);

	minecartChrAnm.process();

	minecartMatrix.translation(minecartPos.x, minecartPos.y, minecartPos.z);
	minecartMatrix.applyRotationYXZ(&minecartRot.x, &minecartRot.y, &minecartRot.z);
	minecartModel.setDrawMatrix(minecartMatrix);
	minecartModel.setScale(minecartScale.x, minecartScale.y, minecartScale.z);
	minecartModel.calcWorld(false);

	if(minecartChrAnm.isAnimationDone())
		minecartChrAnm.setCurrentFrame(0.0);

	/********************/
	/* Skipping credits */
	/********************/

	camTarget = (Vec){minecartPos.x + camOffs.x, minecartPos.y + camOffs.y, minecartPos.z + camOffs.z};

	int nowPressed = Remocon_GetPressed(GetActiveRemocon());
	int nowHeld = Remocon_GetButtons(GetActiveRemocon());

	if(nowPressed & WPAD_PLUS) {
		doRot = !doRot;
	}
	if(nowPressed & WPAD_MINUS) {
		currPlay++;
		if(currPlay > 1) currPlay -= 2;
	}

	if(currPlay != 3) {
		Vec *poss[4] = {(Vec*)&dCreditsCamera_c::instance->currentX, &camOffs, &player->posOffs, 0};
		S16Vec *rots[4] = {&minecartRot, &minecartRot, &player->rotOffs, 0};
		Vec *scales[4] = {&minecartScale, &minecartScale, &player->scale, 0};

		Vec *ppos = poss[currPlay];
		S16Vec *prot = rots[currPlay];
		Vec *pscale = scales[currPlay];

		// if(nowHeld & WPAD_TWO) {
		// 	pscale->x += 0.01f;
		// 	pscale->y += 0.01f;
		// 	pscale->z += 0.01f;
		// }
		// else if(nowHeld & WPAD_ONE) {
		// 	pscale->x -= 0.01f;
		// 	pscale->y -= 0.01f;
		// 	pscale->z -= 0.01f;
		// }

		if(doRot) {
			if(nowHeld & WPAD_RIGHT) {
				prot->x += 0x10;
			}
			else if(nowHeld & WPAD_LEFT) {
				prot->x -= 0x10;
			}

			if(nowHeld & WPAD_UP) {
				prot->y += 0x10;
			}
			else if(nowHeld & WPAD_DOWN) {
				prot->y -= 0x10;
			}

			if(nowHeld & WPAD_A) {
				prot->z += 0x10;
			}
			else if(nowHeld & WPAD_B) {
				prot->z -= 0x10;
			}
		}
		else {
			if(nowHeld & WPAD_RIGHT) {
				ppos->x += 0.1f;
			}
			else if(nowHeld & WPAD_LEFT) {
				ppos->x -= 0.1f;
			}

			if(nowHeld & WPAD_UP) {
				ppos->y += 0.1f;
			}
			else if(nowHeld & WPAD_DOWN) {
				ppos->y -= 0.1f;
			}

			if(nowHeld & WPAD_A) {
				ppos->z += 0.1f;
			}
			else if(nowHeld & WPAD_B) {
				ppos->z -= 0.1f;
			}
		}

		OSReport("player: %d\n", currPlay);
		OSReport("playerPos.x: %f, playerPos.y: %f, playerPos.z: %f\n", ppos->x, ppos->y, ppos->z);
		// OSReport("playerRot.x: %04X, playerRot.y: %04X, playerRot.z: %04X\n", prot->x, prot->y, prot->z);
		// OSReport("playerScale.x: %f, playerScale.y: %f, playerScale.z: %f\n", pscale->x, pscale->y, pscale->z);
	}

	switch (yesNoStage) {
		case 1:
			// Opening
			if (!yesNoWindow->animationActive)
				yesNoStage = 2;
			return true;
		case 2:
			// Opened
			if (nowPressed & WPAD_LEFT)
				yesNoWindow->current = 1;
			else if (nowPressed & WPAD_RIGHT)
				yesNoWindow->current = 0;
			else if (Wiimote_TestButtons(GetActiveWiimote(), WPAD_A | WPAD_TWO)) {
				yesNoWindow->close = true;

				if (yesNoWindow->current != 1)
					yesNoWindow->hasBG = true;
				yesNoStage = 3;

			} else {
				// Cancel using B or 1
				if (CheckIfMenuShouldBeCancelledForSpecifiedWiimote(0)) {
					yesNoWindow->cancelled = true;
					yesNoWindow->current = 1;
					yesNoStage = 3;
				}
			}
			return true;
		case 3:
			// Closing
			if (!yesNoWindow->visible) {
				if (yesNoWindow->current == 1) {
					yesNoStage = 0;
					for (int i = 0; i < 40; i++)
						if (handle.Exists()) {
							handle.Pause(false, 3);
						}
				} else {
					yesNoStage = 4;
					// acState.setState(&StateID_SaveAndQuit);
				}

				// UpdateSelectCursor(this->layout.findPaneByName("N_buttonO_00"), 0, false);
				HideSelectCursor((void*)SelectCursorPointer, 0);
			}
			return true;
		case 4:
			// Waiting for exit transition
			acState.execute();
			return true;
	}

	// if (yesNoWindow->layoutLoaded && (nowPressed & WPAD_PLUS)) {
	// 	HideSelectCursor((void*)SelectCursorPointer, 0);
	// 	yesNoStage = 1;
	// 	yesNoWindow->type = 3;
	// 	yesNoWindow->visible = true;

	// 	for (int i = 0; i < 40; i++)
	// 		if (handle.Exists()) {
	// 			handle.Pause(true, 3);
	// 		}
	// 	return true;
	// }

	/****************************/
	/* State & Layout execution */
	/****************************/

	acState.execute();

	return true;
}

int dScMinecart_c::onDraw() {
	bgModel.scheduleForDrawing();
	minecartModel.scheduleForDrawing();

	return true;
}

/**************************/
/* Text processing states */
/**************************/

// Init State

void dScMinecart_c::beginState_Init() {
	OSReport("Init MCCore.\n");
}

// extern "C" void PSVECNormalize(Vec *toNorm);

void dScMinecart_c::executeState_Init() {
	int nowPressed = Remocon_GetPressed(GetActiveRemocon());
	if(currentNode < nodeCount) {
		Vec currentNodePos = nodePos[currentNode];
		Vec targetCamPos = camPos[currentNode];
		Vec targetCamOffs = camOffets[currentNode];

		Vec dif = (Vec){currentNodePos.x - minecartPos.x, currentNodePos.y - minecartPos.y, currentNodePos.z - minecartPos.z};
		Vec difCP = (Vec){targetCamPos.x - camRPos.x, targetCamPos.y - camRPos.y, targetCamPos.z - camRPos.z};
		Vec difCO = (Vec){targetCamOffs.x - camOffs.x, targetCamOffs.y - camOffs.y, targetCamOffs.z - camOffs.z};

		bool doCart = !(abs(dif.x) < 1.0f && abs(dif.y) < 1.0f && abs(dif.z) < 1.0f);
		bool doCP = !(abs(difCP.x) < 1.0f && abs(difCP.y) < 1.0f && abs(difCP.z) < 1.0f);
		bool doCO = !(abs(difCO.x) < 1.0f && abs(difCO.y) < 1.0f && abs(difCO.z) < 1.0f);

		OSReport("difCP: %f %f %f\n", difCP.x, difCP.y, difCP.z);
		OSReport("Do's: %d %d %d\n", doCart, doCP, doCO);

		if(doCart) {
			Vec velocity;
			PSVECNormalize(&dif, &velocity);

			minecartPos.x += velocity.x;
			minecartPos.y += velocity.y;
			minecartPos.z += velocity.z;

			s16 angleZ = (s16)((velocity.x == 0.0f) ? 0 : RADtoS16(atan2(velocity.y, velocity.x)));
			s16 angleY = (s16)((velocity.z == 0.0f) ? -0x4000 : (RADtoS16(acos(velocity.z)) + 0x8000));

			minecartRot = (S16Vec){0, angleY, angleZ};
		}
		else {
			minecartPos = currentNodePos;
		}

		float dist = sqrtf((dif.x * dif.x) + (dif.y * dif.y) + (dif.z * dif.z));
		if(doCP) {
			Vec velocityCP;
			PSVECNormalize(&difCP, &velocityCP);

			float distCP = sqrtf((difCP.x * difCP.x) + (difCP.y * difCP.y) + (difCP.z * difCP.z));
			if(dist == 0.0f) dist = 1.0f;
			float propCP = dist / distCP;

			camRPos.x += velocityCP.x * propCP;
			camRPos.y += velocityCP.y * propCP;
			camRPos.z += velocityCP.z * propCP;
		}
		else {
			camRPos = targetCamPos;
		}

		if(doCO) {
			Vec velocityCO;
			PSVECNormalize(&difCO, &velocityCO);

			float distCO = sqrtf((difCO.x * difCO.x) + (difCO.y * difCO.y) + (difCO.z * difCO.z));
			// if(distCO == 0.0f) distCO = 1.0f;
			float propCO = dist / distCO;

			camOffs.x += velocityCO.x * propCO;
			camOffs.y += velocityCO.y * propCO;
			camOffs.z += velocityCO.z * propCO;
		}
		else {
			camOffs = targetCamOffs;
		}

		if(!doCart && !doCP && !doCO) {
			if(nowPressed & WPAD_TWO) {
				currentNode++;
			}
			return;
		}


		// OSReport("dists: %f %f %f\n", dist, distCP, distCO);


		// OSReport("props: %f %f\n", propCP, propCO);
		// OSReport("velCP: %f %f %f\n", velocityCP.x, velocityCP.y, velocityCP.z);
		// OSReport("velCO: %f %f %f\n", velocityCO.x, velocityCO.y, velocityCO.z);
	}
}

void dScMinecart_c::endState_Init() {
	
}

// Stolen from koopatlas/core.cpp
void MinecartDrawFunc() {
	Reset3DState();
	SetCurrentCameraID(0);
	DoSomethingCameraRelatedWithEGGScreen(0, &dCreditsCamera_c::instance->screen);
	LinkScene(0);
	SceneCalcWorld(0);
	SceneCameraStuff(0);
	ChangeAlphaUpdate(false);
	DrawOpa();
	DrawXlu();
	UnlinkScene(0);
	// Something
	SetupLYTDrawing();
	DrawAllLayoutsBeforeX(0x81);
	RenderEffects(0, 3);
	RenderEffects(0, 2);
	GXDrawDone();
	RemoveAllFromScnRoot();
	Reset3DState();
	SetCurrentCameraID(1);
	DoSpecialDrawing1();
	LinkScene(1);
	SceneCalcWorld(1);
	SceneCameraStuff(1);
	CalcMaterial();
	DrawOpa();
	DrawXlu();
	UnlinkScene(1);
	SetCurrentCameraID(0);
	for (int i = 0; i < 4; i++)
		RenderEffects(0, 0xB+i);
	for (int i = 0; i < 4; i++)
		RenderEffects(0, 7+i);
	GXDrawDone();
	// Leaving out some stuff here
	DrawAllLayoutsAfterX(0x80);
	ClearLayoutDrawList();
	SetCurrentCameraID(0);
}



