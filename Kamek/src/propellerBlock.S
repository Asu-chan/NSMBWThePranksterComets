.text
#include <asm_setup.S>

.global MakePropellerDispawnOrNot
MakePropellerDispawnOrNot:
	lwz		r3, 4(r30) # Get the settings
	clrlwi	r3, r3, 28 # Equivalent of (r3 & 0xF)
	cmpwi	r3, 0
	bne		dontDispawn
	mr		r3, r30 # Restore instruction
	b		doneWithMakePropellerDispawnOrNot
dontDispawn:
	b		doneWithMakePropellerDispawnOrNot2