.text
.align 4
#include <asm_setup.S>

.extern _801446BC

.global MakeP1BeYoshi
MakeP1BeYoshi:
	lis		r6, _801446BC@h
	ori		r6, r6, _801446BC@l
	cmpw	r0, r6
	beq		noYoshi
	li		r4, 5
	blr
noYoshi:
	clrlwi    r4, r4, 24
	blr

.align 4