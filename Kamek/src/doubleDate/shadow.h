/* Double Date, yay
 * Created by Asu-chan, using Ninji's work obviously
 */

#ifndef __DOUBLEDATE_SHADOW_H
#define __DOUBLEDATE_SHADOW_H

#include <common.h>
#include <game.h>
#include <g3dhax.h>
#include <sfx.h>

#include "doubleDate/core.h"

class dRHShadow_c : public dBase_c {
	public:
		dRHShadow_c();
		~dRHShadow_c();

		int onCreate();
		int onDelete();
		int onExecute();
		int onDraw();

		m2d::EmbedLayout_c layout;

		bool layoutLoaded, visible;

		Vec2 pos, scale;

		nw4r::lyt::Pane *secondaryRoot;

		static dRHShadow_c *build();
};

#endif

