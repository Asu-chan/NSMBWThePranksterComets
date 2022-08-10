#include <asm_setup.S>

.text
.align 4

.extern _Z10getSettingj


.global HardMode
HardMode:
	mr r3, r0
	bl _Z8HardModej
	mr r0, r3

	cmpwi	r0, 0
	b doneWithHardMode