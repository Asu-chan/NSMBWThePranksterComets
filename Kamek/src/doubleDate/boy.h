/* Double Date, yay
 * Created by Asu-chan, using Ninji's work obviously
 */

#ifndef __DOUBLEDATE_BOY_H
#define __DOUBLEDATE_BOY_H

#include <common.h>
#include <game.h>
#include <g3dhax.h>
#include <sfx.h>

#include "doubleDate/core.h"

class dRHBoy_c : public dBase_c {
	public:
		dRHBoy_c();
		~dRHBoy_c();

		int onCreate();
		int onDelete();
		int onExecute();
		int onDraw();

		m2d::EmbedLayout_c layout;

		bool layoutLoaded, visible;

		Vec2 pos, scale;

		nw4r::snd::SoundHandle boySHandle;

		u32 waitBeforeHit;

		void beat();
		bool canKick();
		void kick(int anim, u32 sound);
		void blush();

		static dRHBoy_c *build();
};

#endif

