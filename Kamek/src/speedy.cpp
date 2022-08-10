#include <game.h>
#include <common.h>

class daEnStarCoin_c : public dEn_c {
public:
	int onExecute_orig();
	int newOnExecute();
};

int daEnStarCoin_c::newOnExecute() {
	int orig_val = this->onExecute_orig();
	
	// OSReport("-----\n");
	// OSReport("xDistToCenter: %f\nyDistToCenter: %f\n", this->aPhysics.info.xDistToCenter, this->aPhysics.info.yDistToCenter);
	// OSReport("xDistToEdge: %f\nyDistToEdge: %f\n", this->aPhysics.info.xDistToEdge, this->aPhysics.info.yDistToEdge);
	// OSReport("category1: 0x%X\ncategory2: 0x%X\n", this->aPhysics.info.category1, this->aPhysics.info.category2);
	// OSReport("bitfield1: 0x%X\nbitfield2: 0x%X\n", this->aPhysics.info.bitfield1, this->aPhysics.info.bitfield2);
	// OSReport("unkShort1C: 0x%X\n", this->aPhysics.info.unkShort1C);

	return orig_val;
}