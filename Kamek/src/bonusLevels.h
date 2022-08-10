#ifndef __BONUSLEVELS_H
#define __BONUSLEVELS_H

#include <common.h>
#include <game.h>
#include <g3dhax.h>
#include <sfx.h>
#include "levelinfo.h"
#include "fileload.h"


void BonusLevelsDrawFunc();

class BonusLevelsInfo {
public:
	u32 authorID;
	u32 authorNameOffset;
	u32 authorQuoteOffset;
	u8 filenameW;
	u8 filenameL;
	u8 displaynameW;
	u8 displaynameL;
	GXColor topAuthorColor;
	GXColor bottomAuthorColor;
	GXColor topLevelColor;
	GXColor bottomLevelColor;
};

class BonusLevelsBinary {
public:
	u32 magic;
	u32 levelCount;
	BonusLevelsInfo bonusLevelsInfo[];
};

class dScBonusLevels_c : public dScene_c {
	public:
		dScBonusLevels_c();
		~dScBonusLevels_c();

		int onCreate();
		int onDelete();
		int onExecute();
		int onDraw();

   		FileHandle fileHandles[5];
   		BonusLevelsBinary *bonusLevelsFile;

   		TPLPalette *sampleOne, *sampleTwo;
   		TPLPalette *pfpOne, *pfpTwo;

		u32 currentStateID;

		u32 currentPage;

		nw4r::snd::SoundHandle handle;

		m2d::EmbedLayout_c layout;
		u8 layoutLoaded, isVisible;

		dYesNoWindow_c *yesNoWindow;
		int yesNoStage;


		nw4r::lyt::Picture *Samples[2];
		nw4r::lyt::Picture *PFPs[2];
		nw4r::lyt::TextBox *LevelNames[2];
		nw4r::lyt::TextBox *AuthorNames[2];
		nw4r::lyt::TextBox *AuthorQuotes[2];
		nw4r::lyt::Pane *PropertiesContainers[2];


		static dScBonusLevels_c *build();
		static dScBonusLevels_c *instance;

		void finish(bool startLevel);
		void loadLevel(u32 levelNum, bool isLeft);
		void moveLevel();

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

