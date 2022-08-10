#include "minecart/node.h"


/****************/
/* Initializing */
/****************/

CREATE_STATE(dMCNode_c, Init);

// Instancing
// dMCNode_c *dMCNode_c::instance = 0;

dMCNode_c *dMCNode_c::build() {
	void *buffer = AllocFromGameHeap1(sizeof(dMCNode_c));
	dMCNode_c *c = new(buffer) dMCNode_c;

	// instance = c;
	return c;
}

#include <profile.h>
Profile MCNodeProfile = Profile((buildFunc)&dMCNode_c::build, ProfileId::MC_NODE, 0, ProfileId::MC_NODE, ProfileId::MC_NODE, 0, "MC_NODE", 0);

dMCNode_c::dMCNode_c() : acState(this, &StateID_Init) {
	DVD_LoadFile(GetDVDClass(), "Worldmap", "cobCourse", 0);
	// DVD_LoadFile(GetDVDClass(), "Minecart", "CaveBG", 0);

	this->loaded = false;
}

dMCNode_c::~dMCNode_c() {
}

/******************/
/* Main functions */
/******************/

int dMCNode_c::onCreate() {
	if(!loaded) {
		if (DVD_StillLoading(GetDVDClass2()))
			return false;

		loaded = true;

		/*******************/
		/* 3D Models stuff */
		/*******************/

		// nodePos = (Vec){0.0f, 0.0f, 0.0f};

		allocator.link(-1, GameHeaps[0], 0, 0x20);

		nw4r::g3d::ResFile rf(getResource("cobCourse", "g3d/model.brres"));
		rf.CheckRevision();
		rf.Init();
		rf.Bind(rf);

		nw4r::g3d::ResMdl nodeModelRes = rf.GetResMdl("cobCourse");
		nw4r::g3d::ResAnmClr anmResClr = rf.GetResAnmClr("cobCourseClear");


		nodeModel.setup(nodeModelRes, &allocator, 0x32C, 1, 0);
		SetupTextures_MapObj(&nodeModel, 0);

		nodeClrAnm.setup(nodeModelRes, anmResClr, &allocator, 0, 1);
		nodeClrAnm.bind(&nodeModel, anmResClr, 0, 0);
		nodeModel.bindAnim(&nodeClrAnm, 0.0f);

		allocator.unlink();

		nodeClrAnm.process();
		nodeClrAnm.process();
	}

	return true;
}
int dMCNode_c::onDelete() {
	DVD_FreeFile(GetDVDClass2(), "cobCourse");

	return true;
}

extern u8 currPlay;

int dMCNode_c::onExecute() {
	/********************/
	/* Model processing */
	/********************/

	// node
	
	nodeMatrix.translation(nodePos.x, nodePos.y, nodePos.z);
	nodeModel.setDrawMatrix(nodeMatrix);
	nodeModel.setScale(0.2f, 0.2f, 0.2f);
	nodeModel.calcWorld(false);

	/********************/
	/* Skipping credits */
	/********************/

	int nowPressed = Remocon_GetPressed(GetActiveRemocon());
	int nowHeld = Remocon_GetButtons(GetActiveRemocon());

	if(currPlay == 3) {
		if(nowHeld & WPAD_RIGHT) {
			nodePos.x += 0.1f;
		}
		else if(nowHeld & WPAD_LEFT) {
			nodePos.x -= 0.1f;
		}

		if(nowHeld & WPAD_UP) {
			nodePos.y += 0.1f;
		}
		else if(nowHeld & WPAD_DOWN) {
			nodePos.y -= 0.1f;
		}

		if(nowHeld & WPAD_A) {
			nodePos.z += 0.1f;
		}
		else if(nowHeld & WPAD_B) {
			nodePos.z -= 0.1f;
		}
	}

	// OSReport("nodePos.x: %f, nodePos.y: %f, nodePos.z: %f\n", nodePos.x, nodePos.y, nodePos.z);

	/****************************/
	/* State & Layout execution */
	/****************************/

	acState.execute();

	return true;
}

int dMCNode_c::onDraw() {
	nodeModel.scheduleForDrawing();

	return true;
}

/**************************/
/* Text processing states */
/**************************/

// Init State

void dMCNode_c::beginState_Init() {
	OSReport("Init Node.\n");
}

void dMCNode_c::executeState_Init() {
}

void dMCNode_c::endState_Init() {
	
}

