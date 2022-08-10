/* Double Date, yay
 * Created by Asu-chan, using Ninji's work obviously
 */

#ifndef __DOUBLEDATE_GIRL_H
#define __DOUBLEDATE_GIRL_H

#include <common.h>
#include <game.h>
#include <g3dhax.h>
#include <sfx.h>

#include "doubleDate/core.h"

class dRHGirl_c : public dBase_c {
	public:
		dRHGirl_c();
		~dRHGirl_c();

		int onCreate();
		int onDelete();
		int onExecute();
		int onDraw();

		m2d::EmbedLayout_c layout;

		bool layoutLoaded, visible;

		Vec2 pos, scale;

		void beat();
		void blush();

		static dRHGirl_c *build();
};

#endif

