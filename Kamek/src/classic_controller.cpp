#include <game.h>
#include <common.h>


class KPADEXStatus {
public:
    u32  hold;
    u32  trig;
    u32  release;

    Vec2 lstick;
    Vec2 rstick;
    
    f32  ltrigger;
    f32  rtrigger;
};

class KPADStatus {
public:
    u32  hold;
    u32  trig;
    u32  release;

    Vec  acc;
    f32  acc_value;
    f32  acc_speed;

    Vec2 pos;
    Vec2 vec;
    f32  speed;

    Vec2 horizon;
    Vec2 hori_vec;
    f32  hori_speed;

    f32  dist;
    f32  dist_vec;
    f32  dist_speed;

    Vec2 acc_vertical;

    u8   dev_type;
    s8   wpad_err;
    s8   dpd_valid_fg;
    u8   data_format;

    KPADEXStatus ex_status;
};

void doOSReports(KPADStatus* kpad) {
	// OSReport("------\n");
	// OSReport("hold: %08X; trig: %08X; release: %08X\n", kpad->hold, kpad->trig, kpad->release);
	// OSReport("acc: %f ; %f\n", kpad->acc.x, kpad->acc.y);
	// OSReport("acc_value: %f; acc_speed: %f\n", kpad->acc_value, kpad->acc_speed);
	// OSReport("pos: %f ; %f\n", kpad->pos.x, kpad->pos.y);
	// OSReport("vec: %f ; %f\n", kpad->vec.x, kpad->vec.y);
	// OSReport("speed: %f\n", kpad->speed);
	// OSReport("horizon: %f ; %f\n", kpad->horizon.x, kpad->horizon.y);
	// OSReport("hori_vec: %f ; %f\n", kpad->hori_vec.x, kpad->hori_vec.y);
	// OSReport("hori_speed: %f\n", kpad->hori_speed);
	// OSReport("dist: %f; dist_vec: %f; dist_speed: %f\n", kpad->dist, kpad->dist_vec, kpad->dist_speed);
	// OSReport("acc_vertical: %f ; %f ; %p\n", kpad->acc_vertical.x, kpad->acc_vertical.y, &kpad->acc_vertical);
	// OSReport("rstick: %f ; %f\n", kpad->ex_status.rstick.x, kpad->ex_status.rstick.y);
	// OSReport("------\n");
}

Vec2 rightStickTilt = (Vec2){0, 0};

void adaptRightStick(KPADStatus* kpad) {
	if(kpad->ex_status.rstick.x != 0.0f || kpad->ex_status.rstick.y != 0.0f) {
		kpad->acc_vertical.y = -kpad->ex_status.rstick.y;
	}
}


class dWarningClassic_c {
public:
	// dWarningClassic_c() : acState(this, &StateID_StartWait) { }
	dWarningClassic_c();
	~dWarningClassic_c();

	u32 vtable;
	m2d::EmbedLayout_c layout;
	dStateWrapper_c<dWarningClassic_c> acState;

	nw4r::lyt::Pane *rootPane;
	nw4r::lyt::TextBox *T_player;
	nw4r::lyt::Pane *W_extensionCN;

	u8 layoutLoaded, isVisible, _1E6, _1E7;

	u32 whichWiimote;

	nw4r::lyt::Pane *W_BtnOutline_00;
	nw4r::lyt::Pane *P_Schemes[4];

	u32 needArrowRefresh;

	int onCreate();
	int onDelete();
	void onExecute();
	void onDraw();

	void show(u32 num);
	void set1E6and1E7toOne();

	// static dWarningClassic_c *build();

	USING_STATES(dWarningClassic_c);
	DECLARE_STATE(StartWait);
	DECLARE_STATE(OpenAnimeEndWait);
	DECLARE_STATE(ExitWait);
	DECLARE_STATE(ExitAnimeEndWait);
};

dWarningClassic_c::dWarningClassic_c() : layout(), acState(this, &StateID_StartWait) {
	layoutLoaded = 0;
	whichWiimote = 0;
}

dWarningClassic_c::~dWarningClassic_c() {
	delete &layout;
	delete &acState;
}


CREATE_STATE(dWarningClassic_c, StartWait);
CREATE_STATE(dWarningClassic_c, OpenAnimeEndWait);
CREATE_STATE(dWarningClassic_c, ExitWait);
CREATE_STATE(dWarningClassic_c, ExitAnimeEndWait);

// extern "C" u32* CurrentWarningManager;

// dWarningClassic_c *dWarningClassic_c::build() {
// 	// void *buffer = AllocFromGameHeap1(sizeof(dWarningClassic_c));
// 	dWarningClassic_c *c = new((void*)(*CurrentWarningManager + 0xB94)) dWarningClassic_c;
	
// 	return c;
// }

int dWarningClassic_c::onCreate() {
	if(!layoutLoaded) {
		if (!layout.loadArc("extensionControllerClassic.arc", false))
			return false;

		static const char *brlanNames[11] = {
			"extensionControllerClassic_inWindow.brlan",
			"extensionControllerClassic_loopWindow.brlan",
			"extensionControllerClassic_toLeft.brlan",
			"extensionControllerClassic_fromLeft.brlan",
			"extensionControllerClassic_toRight.brlan",
			"extensionControllerClassic_fromRight.brlan",
			"extensionControllerClassic_inArrow.brlan",
			"extensionControllerClassic_loopArrow.brlan",
			"extensionControllerClassic_hitArrow.brlan",
			"extensionControllerClassic_outArrow.brlan",
			"extensionControllerClassic_outWindow.brlan",
		};

		static const char *groupNames[27] = {
			"A00_Window",
			"A00_Window",
			"B01_Scheme", "B02_Scheme", "B03_Scheme", "B04_Scheme",
			"B01_Scheme", "B02_Scheme", "B03_Scheme", "B04_Scheme",
			"B01_Scheme", "B02_Scheme", "B03_Scheme", "B04_Scheme",
			"B01_Scheme", "B02_Scheme", "B03_Scheme", "B04_Scheme",
			"C00_arrowR", "C01_arrowL",
			"C00_arrowR", "C01_arrowL",
			"C00_arrowR", "C01_arrowL",
			"C00_arrowR", "C01_arrowL",
			"A00_Window",
		};

		static const int groupIDs[27] = {
			0,
			1,
			2, 2, 2, 2,
			3, 3, 3, 3,
			4, 4, 4, 4,
			5, 5, 5, 5,
			6, 6,
			7, 7,
			8, 8,
			9, 9,
			10,
		};

		layout.build("extensionControllerClassic.brlyt");

		layout.loadAnimations(brlanNames, 11);
		layout.loadGroups(groupNames, groupIDs, 27);
		// layout.disableAllAnimations();

		rootPane = layout.getRootPane();

		T_player = layout.findTextBoxByName("T_player");
		W_extensionCN = layout.findPaneByName("W_extensionCN");
		W_BtnOutline_00 = layout.findPaneByName("W_BtnOutline_00");
		P_Schemes[0] = layout.findPaneByName("P_Scheme_00");
		P_Schemes[1] = layout.findPaneByName("P_Scheme_01");
		P_Schemes[2] = layout.findPaneByName("P_Scheme_02");
		P_Schemes[3] = layout.findPaneByName("P_Scheme_03");

		for(int i = 0; i < 4; i++)
			P_Schemes[i]->SetVisible(false);

		static const char *bmgTextboxesNames[7] = {
			"T_guide_01",		// "Spin"
			"T_guide_00",		// "Tilt"
			"T_guide_02",		// "Jump"
			"T_guide_03",		// "Dash"
			"T_guide_04",		// "Bubble"
			"T_classic_01",		// "Controls changed" Text
			"T_classicS_00",	// "Controls changed" Shadow
		};

		static const int bmgTextboxesIDs[7] = {
			2,
			3,
			4,
			5,
			6,
			7,
			7,
		};

		layout.setLangStrings(bmgTextboxesNames, bmgTextboxesIDs, 0x3EA, 7);

		layout.resetAnim(0);
		
		layout.update();
		layout.execAnimations();

		layout.disableAllAnimations();

		layout.drawOrder = 151;

		rootPane->flag &= 0xFE;

		isVisible = false;
		_1E7 = false;
		layoutLoaded = true;

		OSReport("Classic loaded!\n");
	}

	return true;
}


int dWarningClassic_c::onDelete() {
	return layout.free();
}


void dWarningClassic_c::onExecute() {

	if(isVisible) {
		acState.execute();
		layout.execAnimations();
		layout.update();
	}
}


void dWarningClassic_c::onDraw() {
	if(isVisible) {
		layout.scheduleForDrawing();
	}
}

void dWarningClassic_c::show(u32 num) {
	whichWiimote = num;
	isVisible = 1;
	_1E6 = 1;
}

void dWarningClassic_c::set1E6and1E7toOne() {
	_1E6 = 1;
	_1E7 = 1;
}

extern u32 classicControllerType[4];

void dWarningClassic_c::beginState_StartWait() {
	rootPane->flag &= 0xFE;
}

void dWarningClassic_c::executeState_StartWait() {
	WriteBMGToTextBox(T_player, GetBMG(), 104, whichWiimote+4, 0);
	acState.setState(&StateID_OpenAnimeEndWait);
}

void dWarningClassic_c::endState_StartWait() {
	P_Schemes[classicControllerType[whichWiimote]]->SetVisible(true);

	switch(classicControllerType[whichWiimote]) {
		case 0:
			layout.enableNonLoopAnim(18);
			layout.enableNonLoopAnim(25);
			break;
		case 1:
		case 2:
			layout.enableNonLoopAnim(18);
			layout.enableNonLoopAnim(19);
			break;
		case 3:
			layout.enableNonLoopAnim(19);
			layout.enableNonLoopAnim(24);
			break;
	}

	for(int i = 0; i < 4; i++)
		P_Schemes[i]->SetVisible(false);

	P_Schemes[classicControllerType[whichWiimote]]->SetVisible(true);
	layout.resetAnim(2);
	layout.resetAnim(3);
	layout.resetAnim(4);
	layout.resetAnim(5);
}


void dWarningClassic_c::beginState_OpenAnimeEndWait() {
	_1E6 = 1;
	rootPane->flag &= 0xFE;
	rootPane->flag |= 1;
	layout.enableNonLoopAnim(0);
}

void dWarningClassic_c::executeState_OpenAnimeEndWait() {
	if(!layout.isAnimOn(0)) {
		acState.setState(&StateID_ExitWait);
	}
}

void dWarningClassic_c::endState_OpenAnimeEndWait() {
	_1E6 = 0;
}


void dWarningClassic_c::beginState_ExitWait() {
	_1E7 = 0;
	layout.enableNonLoopAnim(1);
}

void dWarningClassic_c::executeState_ExitWait() {
	if    (!layout.isAnimOn(2)  && !layout.isAnimOn(3)  && !layout.isAnimOn(4)  && !layout.isAnimOn(5)
		&& !layout.isAnimOn(6)  && !layout.isAnimOn(7)  && !layout.isAnimOn(8)  && !layout.isAnimOn(9)
		&& !layout.isAnimOn(10) && !layout.isAnimOn(11) && !layout.isAnimOn(12) && !layout.isAnimOn(13)
		&& !layout.isAnimOn(14) && !layout.isAnimOn(15) && !layout.isAnimOn(16) && !layout.isAnimOn(17)
		&& !layout.isAnimOn(18) && !layout.isAnimOn(19) && !layout.isAnimOn(20) && !layout.isAnimOn(21)
		&& !layout.isAnimOn(22) && !layout.isAnimOn(23) && !layout.isAnimOn(24) && !layout.isAnimOn(25)) {

		_1E6 = 0;
		u32 cctype = classicControllerType[whichWiimote];

		if(needArrowRefresh) {
			if(cctype == 0) {
				layout.enableNonLoopAnim(25);
			}
			else if(cctype == 3) {
				layout.enableNonLoopAnim(24);
			}

			for(int i = 0; i < 4; i++)
				P_Schemes[i]->SetVisible(false);

			P_Schemes[cctype]->SetVisible(true);

			needArrowRefresh = 0;
		}

		u32 nowPressed = GetRemoconMng()->controllers[whichWiimote]->nowPressed;
		if(nowPressed & WPAD_RIGHT && cctype < 3) {
			MapSoundPlayer(SoundRelatedClass, 0x78, 1);

			P_Schemes[cctype]->SetVisible(true);
			layout.enableNonLoopAnim(2 + cctype);

			classicControllerType[whichWiimote]++;
			cctype++;

			P_Schemes[cctype]->SetVisible(true);
			layout.enableNonLoopAnim(14 + cctype);

			if(cctype == 1) {
				layout.enableNonLoopAnim(19);
			}

			needArrowRefresh = 1;
			layout.enableNonLoopAnim(22);
			_1E6 = 1;
		}
		else if(nowPressed & WPAD_LEFT && cctype > 0) {
			MapSoundPlayer(SoundRelatedClass, 0x78, 1);

			P_Schemes[cctype]->SetVisible(true);
			layout.enableNonLoopAnim(10 + cctype);
			
			classicControllerType[whichWiimote]--;
			cctype--;

			P_Schemes[cctype]->SetVisible(true);
			layout.enableNonLoopAnim(6 + cctype);

			if(cctype == 2) {
				layout.enableNonLoopAnim(18);
			}

			needArrowRefresh = 1;
			layout.enableNonLoopAnim(23);
			_1E6 = 1;
		}

		if(_1E7) {
			_1E7 = 0;
			acState.setState(&StateID_ExitAnimeEndWait);
		}
	}
}

void dWarningClassic_c::endState_ExitWait() {
	layout.disableAnim(1);
}


void dWarningClassic_c::beginState_ExitAnimeEndWait() {
	_1E6 = 1;
	layout.enableNonLoopAnim(26);
}

void dWarningClassic_c::executeState_ExitAnimeEndWait() {
	if(!layout.isAnimOn(26)) {
		acState.setState(&StateID_StartWait);
	}
}

void dWarningClassic_c::endState_ExitAnimeEndWait() {
	isVisible = 0;
	_1E6 = 0;
}



class dWarningManager_c : public fBase_c {
public:
	u8 pad1[0xC]; // 0x64
	u32 _70;

	u8 dWarningOther_c[0x1EC]; // 0x74
	u8 dWarningNunchuk_c[0x1EC]; // 0x260
	u8 dWarningYoKo_c[0x1EC]; // 0x44C
	u8 dWarningBattery_c[0x28C]; // 0x638

	u8 pad2[0x18]; // 0x8C3

	u8 dWarningErrorInfo_c[0x230]; // 0x8DC

	dStateWrapper_c<dWarningManager_c> acState; // 0xB0C

	u8 pad3[8]; // 0xB48
	u32 _B50;

	u32 lastWiimoteType[4]; // 0xB54

	u32 _B64;
	u32 _B68;
	u32 _B6C;
	u32 _B70;
	u32 _B74;
	u32 _B78;

	u32 maybe_not_array[4]; // 0xB54

	u8 _B8C;
	u8 isBatteryActive; // 0xB8D
	u8 isErrorActive; // 0xB8E
	u8 isSaveErrorActive; // 0xB8F

	u8 _B90;
	u8 _B91;
	u8 _B92;
	u8 _B93;

	dWarningClassic_c dWarningClassic_c;

	void showWarningClassic(u32 whichWiimote);
	int messWithExistingSceneCount();
	int checkForClose();
	int checkForCloseClassic();
	void setStateToOutOfWarning();

	USING_STATES(dWarningManager_c);
	REF_NINTENDO_STATE(WarningNunchuk);
	DECLARE_STATE(WarningClassic);
};

CREATE_STATE_E(dWarningManager_c, WarningClassic);

extern "C" void DoStuffWtihWiimote(u32 coreController); 
extern "C" void assignSomeColoursToWindow(nw4r::lyt::Pane *window, u32 charID); 
extern u32 CoreControllerPtr[];
extern u32 dRemoconMng_c_ptr;

void dWarningManager_c::showWarningClassic(u32 whichWiimote) {
	for(int i = 0; i < 4; i++) {
		DoStuffWtihWiimote(CoreControllerPtr[*(u32 *)(*(u32 *)(dRemoconMng_c_ptr + (i*4) + 4) + 4)]); // Ninji typo :p
	}

	dWarningClassic_c.show(whichWiimote);

	u32 charID = Player_ID[whichWiimote];
	assignSomeColoursToWindow(dWarningClassic_c.W_extensionCN, charID);
	assignSomeColoursToWindow(dWarningClassic_c.layout.findPaneByName("W_BtnOutline_00"), charID);

	acState.setState(&StateID_WarningClassic);
}

extern u32* GetCurrentPC();
void dWarningManager_c::executeState_WarningClassic() {
	if(!messWithExistingSceneCount()) {
		dWarningClassic_c.onExecute();
		if(!dWarningClassic_c._1E6) {
			_B8C = 0;
			if(checkForCloseClassic()) {
				setStateToOutOfWarning();
				dWarningClassic_c.set1E6and1E7toOne();
			}
		}
	}
}

int dWarningManager_c::checkForCloseClassic() {
	OSReport("nowPressed: %08X\n", GetRemoconMng()->controllers[_B64]->nowPressed);
	if(GetRemoconMng()->controllers[_B64]->nowPressed & WPAD_TWO) {
		MapSoundPlayer(SoundRelatedClass, 0x81, 1);
		return true;
	}
	return false;
}


class RemoconConnectExtension {
	u32 _0;
	u32 controllerID;
	u32 extensionType;
	dStateWrapper_c<RemoconConnectExtension> acState;

	// void executeWait();
	// void executeNone();
	// void executeFreestyle();
	// void executeOther();


	USING_STATES(RemoconConnectExtension);
	REF_NINTENDO_STATE(Wait);
	REF_NINTENDO_STATE(None);
	REF_NINTENDO_STATE(Freestyle);
	REF_NINTENDO_STATE(Other);
	// REF_NINTENDO_STATE(Classic);
	DECLARE_STATE(Classic);
};

// CREATE_STATE(RemoconConnectExtension, Classic);

// extern "C" u32 *dword_8042A740;
// extern "C" u32 CoreControllerPtr;

// void RemoconConnectExtension::executeWait() {
// 	u32 coreCtrl = *(u32*)(*(u32*)(CoreControllerPtr + (this->controllerID << 2)) + 0x74)

// 	u32 wiimoteThing = *dword_8042A740;
// 	u32 wiimoteThing2 = *(u32*)wiimoteThing + 0xE28);

// 	if((this->controllerID < 0 || this->controllerID >= wiimoteThing2) {
// 		u32 stateThing = *(u32*)wiimoteThing + 0xE24);
// 		void (*stateFunc)(u32) = (void*)*(u32*)(stateThing + 0x18);
// 		stateFunc(wiimoteThing + 0xE24);
// 	}

// 	u32 wiimoteThing3 = *(u32*)wiimoteThing + 0xE2C);
// 	u32 wiimoteThing4 = (wiimoteThing3 + (this->controllerID << 2));
// 	if(coreCtrl == wiimoteThing4) {
// 		wiimoteThing4 = coreCtrl - 251
// 	}
// }

// void RemoconConnectExtension::executeNone() {
	
// }

// void RemoconConnectExtension::executeFreestyle() {
	
// }

// void RemoconConnectExtension::executeOther() {
	
// }

void RemoconConnectExtension::beginState_Classic() {
	this->extensionType = 5;
}

// void RemoconConnectExtension::executeState_Classic() {
	
// }

void RemoconConnectExtension::endState_Classic() {
	
}