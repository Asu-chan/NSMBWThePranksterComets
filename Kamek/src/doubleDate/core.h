/* Double Date, yay
 * Created by Asu-chan, using Ninji's work obviously
 */

#ifndef __DOUBLEDATE_H
#define __DOUBLEDATE_H

#include <common.h>
#include <game.h>
#include <g3dhax.h>
#include <sfx.h>
#include "fileload.h"
#include "music.h"

#include "doubleDate/bg.h"
#include "doubleDate/boy.h"
#include "doubleDate/girl.h"
#include "doubleDate/football.h"
#include "doubleDate/basketball.h"
#include "doubleDate/rugby.h"
#include "doubleDate/bench.h"
#include "doubleDate/shadow.h"
#include "doubleDate/leaves.h"

class dRHBackground_c;

class dRHBoy_c;
class dRHGirl_c;

class dRHFootball_c;
class dRHBasketball_c;
class dRHRugby_c;

class dRHBench_c;
class dRHShadow_c;

void DoubleDateDrawFunc();

class dScDoubleDate_c : public dScene_c {
	public:
		dScDoubleDate_c();
		~dScDoubleDate_c();

		int onCreate();
		int onDelete();
		int onExecute();
		int onDraw();

		nw4r::snd::SoundHandle handle;

		dYesNoWindow_c *yesNoWindow;
		int yesNoStage;

		dStateWrapper_c<dScDoubleDate_c> acState;

		bool loaded;

		u32 beatTimer;
		bool quarBeat, halfBeat, quar3Beat, fullBeat;

		bool skipBeat;

		nw4r::snd::SoundHandle beatSHandle;
		nw4r::snd::SoundHandle yesnoSHandle;

		dRHBackground_c *rhBackground;

		dRHBoy_c *rhBoy;
		dRHGirl_c *rhGirl;

		dRHFootball_c *rhFootball[5];
		dRHBasketball_c *rhBasketball[5];
		dRHRugby_c *rhRugby[5];

		dRHBench_c *rhBench;

   		FileHandle rhddFHandle;
		u8 *rhdd;
		u32 rhddLength;

		u32 currentFrame;
		u32 elapsedFrames;
		u32 outroTimer;

		bool musicPlaying;

		long nextBeatSample;
		u32 sampleWaiting;

		enum ActionType {
			ACT_NOTHING = 0b0000,
			ACT_FOOTBALL = 0b0001,
			ACT_BASKETBALL = 0b0010,
			ACT_RUGBY = 0b0100,
			ACT_BEAT = 0b1000,
			ACT_ALL = 0b1111,

		};

		void beat();
		void football();
		void basketball();
		void rugby();
		bool anyoneBusy();
		int lookForShooting();

		void finish();

		void playMusic();
		void pauseMusic(bool pause);
		void stopMusic();
		bool isMusic();
		long getMusicSample();

		static dScDoubleDate_c *build();
		static dScDoubleDate_c *instance;

		USING_STATES(dScDoubleDate_c);
		DECLARE_STATE(Init);
		DECLARE_STATE(Outro);
};

#endif

