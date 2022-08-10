#ifndef __OPENING_H
#define __OPENING_H

#include <common.h>
#include <game.h>
#include <g3dhax.h>
#include <sfx.h>
#include "fileload.h"

void OpeningDrawFunc();
// void NewerMapDrawFunc();


// class dFlipbookRenderer_c : public m3d::proc_c {
// 	public:
// 		dFlipbookRenderer_c();
// 		~dFlipbookRenderer_c();

// 		mAllocator_c allocator;
// 		void drawOpa();
// 		void drawXlu();
// 		void execute();

// 		bool isEnabled;
// 		int flipFrame;

// 		int scheduledBG;

// 		char *tplBuffer[2];
// 		u32 tplBufferSize[2];
// 		GXTexObj bgTexObj[2];

// 		void loadNewBG(int bgID, bool isBackface);
// };


class OpeningInfo {
public:
	u32 lineCount;
	u32 chrCount;
	u16 musicID;
	u16 sfxID;
	u32 textOffset;
};

class OpeningBinary {
public:
	u32 pagesCount;
	OpeningInfo openingInfo[];
};

class dScOpening_c : public dScene_c {
	public:
		dScOpening_c();
		// ~dScOpening_c();

		int onCreate();
		int onDelete();
		int onExecute();
		int onDraw();


		FunctionChain initChain;
   		FileHandle fileHandle;
   		OpeningBinary *openingFile;

   		u16 currentMusicID;
   		int musicHandleID;

		u32 currentStateID;
		u32 textTimer;
		u32 currentChar;
		u8 currentFunc;

		int currentPicture;

		nw4r::snd::SoundHandle handles[40];

		m2d::EmbedLayout_c layout;
		u8 layoutLoaded, isVisible, waitingTime;

		dYesNoWindow_c *yesNoWindow;
		int yesNoStage;

		// dFlipbookRenderer_c renderer;

		nw4r::lyt::Pane *N_flipbook_00;

		nw4r::lyt::Picture *P_rightPage_00;
		nw4r::lyt::Picture *P_leftPage_00;
		nw4r::lyt::Picture *P_orightPage_00;
		nw4r::lyt::Picture *P_oleftPage_00;
		nw4r::lyt::Picture *P_nrightPage_00;
		nw4r::lyt::Picture *P_nleftPage_00;

		nw4r::lyt::TextBox *T_DialogueTxt_00;
		nw4r::lyt::TextBox *T_DialogueSha_00;

		static dScOpening_c *build();
		static dScOpening_c *instance;

		wchar_t *getTextForPage(int page);
		void loadIdlePic();
		void loadPrevPic();
		void loadNextPic();
		void finish();

		void state0_whatever();
		void state1_whatever();
		void state2_whatever();
		void state3_whatever();
		void state4_whatever();
		void state5_whatever();
		void state6_whatever();
		void state7_whatever();
		void state8_whatever();
};



#endif

