/* Minecart shit
 * Created by Asu-chan, using Ninji's work obviously
 */

#ifndef __MINECART_H
#define __MINECART_H

#include <common.h>
#include <game.h>
#include <g3dhax.h>
#include <sfx.h>

#include "minecart/player.h"
#include "minecart/node.h"

class dMCPlayer_c;
class dMCNode_c;

void MinecartDrawFunc();

class dScMinecart_c : public dScene_c {
	public:
		dScMinecart_c();
		~dScMinecart_c();

		int onCreate();
		int onDelete();
		int onExecute();
		int onDraw();

		nw4r::snd::SoundHandle handle;

		dYesNoWindow_c *yesNoWindow;
		int yesNoStage;

		dStateWrapper_c<dScMinecart_c> acState;

		dMCPlayer_c *player;
		// dWMHud_c *hud;

		int currentNode;

		bool keepMusicPlaying;
		bool loaded;

		int ftimer;


		mHeapAllocator_c allocator;

		dDvdLoader_c bgLoader;
		m3d::mdl_c bgModel;
		m3d::anmChr_c bgChrAnm;
		m3d::anmTexSrt_c bgSrtAnm;

		mMtx bgMatrix;
		Vec bgPos;

		m3d::mdl_c minecartModel;
		m3d::anmChr_c minecartChrAnm;

		mMtx minecartMatrix;
		Vec minecartPos;
		S16Vec minecartRot;
		Vec minecartScale;

		Vec camOffs;
		Vec camTarget;
		Vec camRPos;

		// int nodeCount;

		static dScMinecart_c *build();
		static dScMinecart_c *instance;

		USING_STATES(dScMinecart_c);
		DECLARE_STATE(Init);
};

#endif

