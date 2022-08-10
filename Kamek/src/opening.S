.text
#include <asm_setup.S>
.align 4



.global _Z16callOpeningStateP12dScOpening_cj
_Z16callOpeningStateP12dScOpening_cj:
	stwu sp, -0x10(sp)
	mflr r0
	stw r0, 0x14(sp)
	stw r31, 0xC(sp)

	lis r5, openingStates@h
	ori r5, r5, openingStates@l
	mulli r4, r4, 0xC
	add r12, r5, r4
	bl __ptmf_scall

	lwz r0, 0x14(sp)
	lwz r31, 0xC(sp)
	mtlr r0
	addi sp, sp, 16
	blr


.data


.global openingStates
openingStates:
	.long 0, -1, _ZN12dScOpening_c15state0_whateverEv
	.long 0, -1, _ZN12dScOpening_c15state1_whateverEv
	.long 0, -1, _ZN12dScOpening_c15state2_whateverEv
	.long 0, -1, _ZN12dScOpening_c15state3_whateverEv
	.long 0, -1, _ZN12dScOpening_c15state4_whateverEv
	.long 0, -1, _ZN12dScOpening_c15state5_whateverEv
	.long 0, -1, _ZN12dScOpening_c15state6_whateverEv
	.long 0, -1, _ZN12dScOpening_c15state7_whateverEv
	.long 0, -1, _ZN12dScOpening_c15state8_whateverEv