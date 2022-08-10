#include <asm_setup.S>

.text
.align 4

.global APhysicsBitfield2
APhysicsBitfield2:
	lwz r4, 0x18(r5)
	ori r4, r4, 0x8000
	b doneWithAPhysicsBitfield2