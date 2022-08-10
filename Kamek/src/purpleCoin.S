.text
#include <asm_setup.S>

.extern purplecoinsCollected
.extern purplecoinsCollected_checkpoint
.extern purplecoins
.extern purplecoins_checkpoint

.global WipePurpleCoins
WipePurpleCoins:
	lbz		r3, 0x120E(r30) # Restore instruction

	li		r8, 0
	lis		r7, purplecoins@ha
	stw		r8, purplecoins@l(r7)

	lis		r7, purplecoinsCollected@h
	ori		r7, r7, purplecoinsCollected@l
	li		r9, 0
	b		startPCWipingLoop

continuePCWipingLoop:
	stwx	r8, r7, r9
	addi	r9, r9, 4

startPCWipingLoop:
	cmpwi	r9, 8
	blt		continuePCWipingLoop

	blr

.global RestorePurpleCoins
RestorePurpleCoins:
	clrlwi	r30, r0, 31 # Restore instruction

	lis		r7, purplecoins_checkpoint@ha
	lwz		r8, purplecoins_checkpoint@l(r7)
	lis		r7, purplecoins@ha
	stw		r8, purplecoins@l(r7)
	

	lis		r7, purplecoinsCollected@h
	ori		r7, r7, purplecoinsCollected@l
	lis		r10, purplecoinsCollected_checkpoint@h
	ori		r10, r10, purplecoinsCollected_checkpoint@l
	li		r9, 0
	b		startPCRestoringLoop

continuePCRestoringLoop:
	lwzx	r8, r10, r9
	stwx	r8, r7, r9
	addi	r9, r9, 4

startPCRestoringLoop:
	cmpwi	r9, 8
	blt		continuePCRestoringLoop

	blr