#include <asm_setup.S>

.text
.align 4

.global txtrect
txtrect:
	lis r4, float5@ha
	lfs f4, float5@l(r4)

	fsub f1, f1, f4

	lwz	r0, 0xC4(r1) # Restore instruction
	blr


.data
.align 4
float5: .float 5.0