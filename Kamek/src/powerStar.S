.text
#include <asm_setup.S>

.extern doneWithTimeUpTextChange
.extern doneWithTimeUpTextChange2

.global TimeUpTextChange
TimeUpTextChange:
	lbz r3, 0x388(r31)
	cmpwi r3, 1

	lwz r3, 0x374(r31) # Restore instruction

	beq DoTextChange
	b doneWithTimeUpTextChange
DoTextChange: #r3 tb, r4 str, r5 0(r3) -> 0, r6 7c(r5) -> mtctr r6, bctrl
	lis r4, TooBadStr@h
	ori r4, r4, TooBadStr@l

	lwz r5, 0(r3)
	lwz r6, 0x7C(r5)
	li r5, 0

	mtctr r6
	bctrl
	b doneWithTimeUpTextChange2


.global NoLookAtTowerBoss
NoLookAtTowerBoss:
	lwz r4, 4(r31)
	rlwinm r4, r4, 24, 31, 31 # ((this->settings >> 8) & 1)
	cmpwi r4, 1
	beq dontLookAtTowerBoss

	stw r0, 0x380(r3) # Restore instruction
dontLookAtTowerBoss:
	blr


.global _Z12GetCurrentPCv # It actually gets the LR, not the PC, however the LR at this point is the pointer to the instruction that calls this function
_Z12GetCurrentPCv:
	mflr r3
	blr
	

.data
.align 4

.global TooBadStr
TooBadStr:
	.string "\0T\0o\0o\0 \0B\0a\0d\0!"

.align 4