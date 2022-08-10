#ifndef __BONUSLEVELS_H
#define __BONUSLEVELS_H

#include <common.h>
#include <game.h>
#include <g3dhax.h>
#include <sfx.h>
#include "fileload.h"

class StaffCreditsPage {
public:
	u8 contentCount[2]; // Amount of names (AKA contents) in each part
	u16 frameDuration;  // Duration of the page
	u32 title[2];       // Index to the two title texts
	u32 content[6];     // Index to the six content texts
};

class StaffCreditsBinary {
public:
	u32 magic;           // "PSCF" Prankster Staff Credits File
	u32 totalFrameCount; // Total of all pages' frameDuration value
	u32 pageCount;
	StaffCreditsPage pages[];
};

void CreditsDrawFunc();

class dScStaffCredits_c : public dScene_c {
	public:
		dScStaffCredits_c();
		~dScStaffCredits_c();

		int onCreate();
		int onDelete();
		int onExecute();
		int onDraw();

		/*******************/
		/* Utility objects */
		/*******************/

		nw4r::snd::SoundHandle handle;

		m2d::EmbedLayout_c layout;
		u8 layoutLoaded, isVisible;

		dStateWrapper_c<dScStaffCredits_c> acState;
		dStateWrapper_c<dScStaffCredits_c> acState2;

		dYesNoWindow_c *yesNoWindow;
		int yesNoStage;

   		FileHandle fileHandle;
   		StaffCreditsBinary *staffCreditsFile;

		/********************/
		/* Common variables */
		/********************/

		u32 currentPage;

		u32 timer;
		u32 textTimer;
		bool currentDir;

		bool doneWithTextMovement;
		u32 frameC;

		bool savingForEnding;
		bool reachedBottom;

		float textUPSpeed;

		/*****************/
		/* Text handling */
		/*****************/

		nw4r::ut::TextWriter textWriterTitle;
		nw4r::ut::TextWriter textWriterContent;

		nw4r::lyt::Pane *N_credits_00;
		nw4r::lyt::Pane *N_end_00;

		int currentTitleChar[8];
		bool doSkip[8];
		bool letterCountChanged[8];
		const wchar_t *strings[8];
		nw4r::lyt::TextBox *AllTheTextboxes[8];

		nw4r::lyt::Pane *N_titleRtoL_00;
		nw4r::lyt::Pane *N_titleLtoR_00;

		nw4r::lyt::Pane *RtoLContents[3];
		nw4r::lyt::Pane *LtoRContents[3];

		nw4r::lyt::TextBox *T_titleRtoL_00;
		nw4r::lyt::TextBox *T_titleLtoR_00;

		nw4r::lyt::TextBox *RtoLContentsT[3];
		nw4r::lyt::TextBox *LtoRContentsT[3];

		/************/
		/* 3D Stuff */
		/************/

		mHeapAllocator_c allocator;

		// BG
		dDvdLoader_c bgLoader;
		m3d::mdl_c bgModel;
		m3d::anmChr_c bgChrAnm;
		m3d::anmTexSrt_c bgSrtAnm;
		m3d::anmClr_c bgClrAnm;

		mMtx bgMatrix;
		Vec bgPos;

		// Peach
		m3d::mdl_c peachModel;
		m3d::anmTexSrt_c peachSrtAnm;

		mMtx peachMatrix;
		Vec peachPos;
		S16Vec peachRot;

		// Players; Order: Mario, Luigi, Blue Toad, Yellow Toad
		nw4r::g3d::ResFile playersResFile;

		m3d::mdl_c playerModel[4];
		m3d::anmChr_c playerChrAnm[4];

		mMtx playerMatrix[4];
		Vec playerPos[4];
		S16Vec playerRot[4];

		u8 currentPlayerAnimID[4];

		// Shadows
		// m3d::smdl_c shadow;
		// mHeapAllocator_c shadowAllocator;
		// m3d::scnLeaf_c *scn;

		/***************************/
		/* Functions states & misc */
		/***************************/

		static dScStaffCredits_c *build();
		static dScStaffCredits_c *instance;

		void setPositionsAndTexts();
		void bindAnimationToPlayer(u8 player, u8 id);

		const u8 getContentCount(u32 page, u8 num) {
			return staffCreditsFile->pages[page].contentCount[num];
		}

		const u16 getFrameDuration(u32 page) {
			return staffCreditsFile->pages[page].frameDuration;
		}

		const wchar_t* getTitle(u32 page, u8 num) {
			return (const wchar_t*)((u32)staffCreditsFile + staffCreditsFile->pages[page].title[num]);
		}

		const wchar_t* getContent(u32 page, u8 num) {
			return (const wchar_t*)((u32)staffCreditsFile + staffCreditsFile->pages[page].content[num]);
		}


		USING_STATES(dScStaffCredits_c);
		// Text processing states
		DECLARE_STATE(Init);
		DECLARE_STATE(HandleTextAppear);
		DECLARE_STATE(SaveAndQuit);
		// Scrolling states
		DECLARE_STATE(Wait);
		DECLARE_STATE(DoTextMovement);
};


const char* playerMovieNames[4] = {
	"MB", "LB", "KBB", "KYB",
};

const char* playerAnimNames[4][4] = {
	{"wait", "LB_wait", "KB_wait", "KB_wait"},
	{"PL_goal_puton_cap", "PL_goal_puton_cap", "KB_goal_puton_cap", "KB_goal_puton_cap"},
	{"goal_glad", "LB_goal_glad", "KB_goal_glad", "KB_goal_glad"},
};


#endif

