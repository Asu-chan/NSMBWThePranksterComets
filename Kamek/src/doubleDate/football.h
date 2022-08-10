/* Double Date, yay
 * Created by Asu-chan, using Ninji's work obviously
 */

#ifndef __DOUBLEDATE_FOOTBALL_H
#define __DOUBLEDATE_FOOTBALL_H

#include <common.h>
#include <game.h>
#include <g3dhax.h>
#include <sfx.h>

#include "doubleDate/core.h"
#include "doubleDate/shadow.h"
#include "doubleDate/leaves.h"

class dRHShadow_c;
class dRHLeaves_c;

class dRHFootball_c : public dBase_c {
	public:
		dRHFootball_c();
		~dRHFootball_c();

		int onCreate();
		int onDelete();
		int onExecute();
		int onDraw();

		m2d::EmbedLayout_c layout;
		dStateWrapper_c<dRHFootball_c> acState;

		bool layoutLoaded, visible, busy;

		Vec2 pos, scale;
		float rotZ;

		nw4r::lyt::Pane *secondaryRoot;

		dRHShadow_c *shadow;
		dRHLeaves_c *leaves;

		nw4r::snd::SoundHandle ballSHandle;

		float actTimer;
		u32 actFrame;

		u8 currentSFXWait;

		void act();
		int canBeShoot();

		static dRHFootball_c *build();

		USING_STATES(dRHFootball_c);
		DECLARE_STATE(Init);
		DECLARE_STATE(Act);
		DECLARE_STATE(Shoot);
		DECLARE_STATE(Miss);
};

#endif

