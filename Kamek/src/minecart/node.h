/* Minecart shit
 * Created by Asu-chan, using Ninji's work obviously
 */

#ifndef __MINECART_NODE_H
#define __MINECART_NODE_H

#include <common.h>
#include <game.h>
#include <g3dhax.h>
#include <sfx.h>

#include "minecart/core.h"

class dMCNode_c : public dScene_c {
	public:
		dMCNode_c();
		~dMCNode_c();

		int onCreate();
		int onDelete();
		int onExecute();
		int onDraw();

		dStateWrapper_c<dMCNode_c> acState;

		mHeapAllocator_c allocator;

		m3d::mdl_c nodeModel;
		m3d::anmClr_c nodeClrAnm;

		mMtx nodeMatrix;
		Vec nodePos;

		bool loaded;

		static dMCNode_c *build();
		static dMCNode_c *instance;

		USING_STATES(dMCNode_c);
		DECLARE_STATE(Init);
};

#endif

