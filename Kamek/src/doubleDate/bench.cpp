#include "doubleDate/bench.h"


/****************/
/* Initializing */
/****************/

// Instancing

dRHBench_c *dRHBench_c::build() {
	void *buffer = AllocFromGameHeap1(sizeof(dRHBench_c));
	return new(buffer) dRHBench_c;
}

#include <profile.h>
Profile RHBenchProfile = Profile((buildFunc)&dRHBench_c::build, ProfileId::RH_BENCH, 0, ProfileId::RH_BENCH, ProfileId::RH_BENCH, 0, "RH_BENCH", 0);

dRHBench_c::dRHBench_c() { }

dRHBench_c::~dRHBench_c() { }

/******************/
/* Main functions */
/******************/

int dRHBench_c::onCreate() {
	if (!layoutLoaded) {
		if (!layout.loadArc("doubleDate/bench.arc", false))
			return false;

		layout.build("bench.brlyt");

		layoutLoaded = true;
		visible = true;

		layout.drawOrder = 50;

		this->pos = (Vec2){0.0f, 21.0f};
		this->scale = (Vec2){0.8f, 0.8f};
	}

	return true;
}
int dRHBench_c::onDelete() {
	return layout.free();
}

extern u8 currPlay;

int dRHBench_c::onExecute() {
	layout.update();

	layout.layout.rootPane->trans.x = this->pos.x;
	layout.layout.rootPane->trans.y = this->pos.y;
	layout.layout.rootPane->scale.x = this->scale.x;
	layout.layout.rootPane->scale.y = this->scale.y;

	return true;
}

int dRHBench_c::onDraw() {
	if(visible) {
		layout.scheduleForDrawing();
	}

	return true;
}