#ifndef __COURSESELECTMANAGER_H
#define __COURSESELECTMANAGER_H

#include <common.h>
#include <game.h>

#include "worldmapPause.h"
#include "starSign.h"

class dCourseSelectManager_c : public dBase_c {
public:
	dStateWrapper_c<dCourseSelectManager_c> acState;

	u32 *courseSelectMenuPtr;
	u32 *numberOfPeopleChangePtr;
	u32 *stockItemPtr;

	u8 pad1[4];

	u32 *collectionCoinPtr;
	u32 *worldSelectPtr;

	u8 pad2[4];

	u8 guide[0x450];

	u32 *ptr2dPlayer[4];

	u32 *easyPairingPtr;
	u32 *continuePtr;
	u32 *yesNoWindowPtr;
	u32 *someMsgPtr;
	u32 *letterWindowPtr;

	u8 layoutLoader;
	u8 _53D;
	u8 doesSomethingWithMenuSelect;
	u8 doesWorldSelect;
	u8 _540;
	u8 doesContinueCheckWait;
	u8 doesSaveWindowOpen;
	u8 _543;
	u8 doesMsgOpenAnimeEndWait;
	u8 startedSomeMsgThing;
	u8 endedSomeMsgThing;
	u8 doesYesNoWindowOpenAnimeEndWait;
	u8 doesStockItemSelectWait;
	u8 doSetPowerupsInWm2dPlayer;
	u8 _54A;
	u8 _54B;
	u8 _54C;
	u8 doesLetterWindowWait;

	u8 pad3[2];

	u32 selectedMenuItem;
	u32 _554;
	u32 countdownForSomethingInMenuSelect;
	u32 somethingCopiedIntoYesNoWindow;

	u8 pad4[0x10];

	dSettings_c *settingsPtr;
	dStarSign_c *signPtr;
	u8 doesLetterOpenAnime; // 0x578


	void changeToNormalState();

	USING_STATES(dCourseSelectManager_c);
	REF_NINTENDO_STATE(KeyWait);
	DECLARE_STATE(SettingsWait);
	DECLARE_STATE(LetterOpenAnim);
	DECLARE_STATE(LetterDisp);
	DECLARE_STATE(LetterExitAnim);
};

#endif

