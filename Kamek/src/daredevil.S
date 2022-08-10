.text
#include <asm_setup.S>
.align 4

.global OneHitKill
OneHitKill:
	lis r10, enableDaredevil@h
	ori r10, r10, enableDaredevil@l
	lbz r10, 0(r10)
	cmpwi r10, 0
	beq NoOneHitKill

	li r0, 0
	cmpwi r0, 0
	blr

NoOneHitKill:
	cmpwi r0, 0
	blr



.align 4

.data

.global enableDaredevil
enableDaredevil:
	.byte 0

.align 4
