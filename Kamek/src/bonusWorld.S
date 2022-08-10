.text
#include <asm_setup.S>
.align 4

.extern doneWithFixWMNum
.extern doneWithFixWMNum2

.global FixWMNum
FixWMNum:
	clrlwi r3, r7, 28
	cmpwi r3, 9

	lis r8, isBonusWorld@h
	ori r8, r8, isBonusWorld@l

	beq doBWorldNum

	li r6, 0
	b returnFromFixWMNum

doBWorldNum:
	li r6, 1
	li r3, 8
	andi. r7, r7, 0xFFFE
	stw r7, 4(r30)

returnFromFixWMNum:
	stb r6, 0(r8)
	b doneWithFixWMNum


.global FixWMNum2
FixWMNum2:
	addi r6, r6, 1

	lis r7, isBonusWorld@h
	ori r7, r7, isBonusWorld@l
	lbz r7, 0(r7)
	cmpwi r7, 1
	bne returnFromFixWMNum2

	addi r6, r6, 1

returnFromFixWMNum2:
	b doneWithFixWMNum2


.global FixWMNum3
FixWMNum3:
	addi r6, r6, 1

	lis r7, isBonusWorld@h
	ori r7, r7, isBonusWorld@l
	lbz r7, 0(r7)
	cmpwi r7, 1
	bne returnFromFixWMNum3

	addi r6, r6, 1

returnFromFixWMNum3:
	b doneWithFixWMNum3


.global LoadCSWMA
LoadCSWMA:
	addi r6, r5, 1

	lis r7, isBonusWorld@h
	ori r7, r7, isBonusWorld@l
	lbz r7, 0(r7)
	cmpwi r7, 1
	bne returnFromLoadCSWMA

	addi r6, r6, 1

returnFromLoadCSWMA:
	b doneWithLoadCSWMA


.global WMMusicID
WMMusicID:
	lis r3, WorldMapMusicTracks@h
	ori r3, r3, WorldMapMusicTracks@l
	b downWithWMMusicID


.global NewLoadingJTable
NewLoadingJTable:
	lis r4, WMLoadingJumpTable@h
	ori r4, r4, WMLoadingJumpTable@l
	b doneWithNewLoadingJTable


.global NewLoadingJTable2
NewLoadingJTable2:
	lis r4, WMLoadingJumpTable2@h
	ori r4, r4, WMLoadingJumpTable2@l
	b doneWithNewLoadingJTable2
	ori r4, r3, 0x10


.data
.global isBonusWorld
isBonusWorld:
	.byte 0
	.align 4

.global WorldMapMusicTracks
WorldMapMusicTracks:
	.long 8, 9, 0xA, 0xB, 0xC, 0xD, 0xE, 0xF, 0x10, 0x1B, 0

.global WMLoadingJumpTable
WMLoadingJumpTable:
	.long loc_80926A40 # Case 0
	.long loc_80926A50 # Case 1
	.long loc_80926A60 # Case 2
	.long loc_80926A70 # Case 3
	.long loc_80926A80 # Case 4
	.long loc_80926A94 # Case 5
	.long loc_80926AA4 # Case 6
	.long loc_80926AB4 # Case 7
	.long loc_80926AC4 # Case 8
	.long loc_80926AC4 # Case 9

.global WMLoadingJumpTable2
WMLoadingJumpTable2:
	.long loc_80926970
	.long loc_80926980
	.long loc_80926990
	.long loc_809269A0
	.long loc_809269B0
	.long loc_809269C0
	.long loc_809269D0
	.long loc_809269E0
	.long loc_809269F0
	.long loc_809269F0