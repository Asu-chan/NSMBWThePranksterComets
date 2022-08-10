/* Double Date, yay
 * Created by Asu-chan, using Ninji's work obviously
 */

#ifndef __DOUBLEDATE_BENCH_H
#define __DOUBLEDATE_BENCH_H

#include <common.h>
#include <game.h>
#include <g3dhax.h>
#include <sfx.h>

#include "doubleDate/core.h"

class dRHBench_c : public dBase_c {
	public:
		dRHBench_c();
		~dRHBench_c();

		int onCreate();
		int onDelete();
		int onExecute();
		int onDraw();

		m2d::EmbedLayout_c layout;

		bool layoutLoaded, visible;

		Vec2 pos, scale, rot;

		static dRHBench_c *build();
};

#endif

