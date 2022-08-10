/* Double Date, yay
 * Created by Asu-chan, using Ninji's work obviously
 */

#ifndef __DOUBLEDATE_LEAVES_H
#define __DOUBLEDATE_LEAVES_H

#include <common.h>
#include <game.h>
#include <g3dhax.h>
#include <sfx.h>

#include "doubleDate/core.h"

class dRHLeaves_c : public dBase_c {
	public:
		dRHLeaves_c();
		~dRHLeaves_c();

		int onCreate();
		int onDelete();
		int onExecute();
		int onDraw();

		m2d::EmbedLayout_c layout;

		bool layoutLoaded, visible;

		Vec2 pos, scale;

		u32 leavesTimer;

		void leavesFall();

		static dRHLeaves_c *build();
};

#endif

