.text
#include <asm_setup.S>
.align 4

.extern MultiplayerModeFlags_maybe

.global _Z20callBonusLevelsStateP16dScBonusLevels_cj
_Z20callBonusLevelsStateP16dScBonusLevels_cj:
	stwu sp, -0x10(sp)
	mflr r0
	stw r0, 0x14(sp)
	stw r31, 0xC(sp)

	lis r5, bonusLevelsStates@h
	ori r5, r5, bonusLevelsStates@l
	mulli r4, r4, 0xC
	add r12, r5, r4
	bl __ptmf_scall

	lwz r0, 0x14(sp)
	lwz r31, 0xC(sp)
	mtlr r0
	addi sp, sp, 16
	blr


.global BackToBonusLevels
BackToBonusLevels:
	lis r3, MultiplayerModeFlags_maybe@h
	ori r3, r3, MultiplayerModeFlags_maybe@l
	lwz r3, 0(r3)
	rlwinm. r3, r3, 0, 27, 27 # r3 & 0x10
	bne GoToResults
	li r3, 9
	b doneWithBackToBonusLevels
GoToResults:
	li r3, 0x2C7
	b doneWithBackToBonusLevels


.global MakeThisStupidMusicWork
MakeThisStupidMusicWork:
	cmpwi r31, 0x155
	beq _storeSceneID
	b doneWithMakeThisStupidMusicWork

_storeSceneID:
	b doneWithMakeThisStupidMusicWork2


.global FSELNewBMGPanes
FSELNewBMGPanes:
	bl _Z6GetBMGv
	mr r31, r3

	addi r3, r30, 0x74
	lis r4, T_multi_02@h
	ori r4, r4, T_multi_02@l
	bl _Z29EmbeddedLayout_FindPaneByNameP6LayoutPKc

	mr r4, r31
	li r5, 0x3EA
	li r6, 8
	li r7, 0
	bl TextBoxSetBmgString

	addi r3, r30, 0x74
	lis r4, T_multiS_02@h
	ori r4, r4, T_multiS_02@l
	bl _Z29EmbeddedLayout_FindPaneByNameP6LayoutPKc

	mr r4, r31
	li r5, 0x3EA
	li r6, 8
	li r7, 0
	bl TextBoxSetBmgString

	li r3, 1
	b doneWithFSELNewBMGPanes


.data
.align 4

.global bonusLevelsStates
bonusLevelsStates:
	.long 0, -1, _ZN16dScBonusLevels_c15state0_whateverEv
	.long 0, -1, _ZN16dScBonusLevels_c15state1_whateverEv
	.long 0, -1, _ZN16dScBonusLevels_c15state2_whateverEv
	.long 0, -1, _ZN16dScBonusLevels_c15state3_whateverEv
	.long 0, -1, _ZN16dScBonusLevels_c15state4_whateverEv
	.long 0, -1, _ZN16dScBonusLevels_c15state5_whateverEv
	.long 0, -1, _ZN16dScBonusLevels_c15state6_whateverEv
	.long 0, -1, _ZN16dScBonusLevels_c15state7_whateverEv
	.long 0, -1, _ZN16dScBonusLevels_c15state8_whateverEv

.global T_multi_02
T_multi_02: .string "T_multi_02"

.global T_multiS_02
T_multiS_02: .string "T_multiS_02"

.align 4