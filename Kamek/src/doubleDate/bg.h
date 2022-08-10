/* Double Date, yay
 * Created by Asu-chan, using Ninji's work obviously
 */

#ifndef __DOUBLEDATE_BG_H
#define __DOUBLEDATE_BG_H

#include <common.h>
#include <game.h>
#include <g3dhax.h>
#include <sfx.h>

#include "doubleDate/core.h"

class dRHBackground_c : public dBase_c {
	public:
		dRHBackground_c();
		~dRHBackground_c();

		int onCreate();
		int onDelete();
		int onExecute();
		int onDraw();

		m2d::EmbedLayout_c layout;
		dStateWrapper_c<dRHBackground_c> acState;

		bool layoutLoaded, visible;

		Vec2 pos, scale;

		u32 leavesTimer;

		void leavesShake();

		static dRHBackground_c *build();

		USING_STATES(dRHBackground_c);
		DECLARE_STATE(Init);
};

#endif

