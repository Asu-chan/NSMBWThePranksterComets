.text
#include <asm_setup.S>
.align 4

.extern doneWithGetSpeedyTimer
.extern doneWithForbidTimeUpIfSpeedy
.extern doneWithForbidQuickMusicIfSpeedy
.extern doneWithForbidQuickMusicIfSpeedy2
.extern doneWithSetTimeKeeperTime

.global GetSpeedyTimer
GetSpeedyTimer:
	lis r4, speedyTimer@h
	ori r4, r4, speedyTimer@l
	stw r30, 0(r4)

	mr r4, r30
	b doneWithGetSpeedyTimer


# .global ForbidTimeUpIfSpeedy
# ForbidTimeUpIfSpeedy:
# 	lis r3, enableSpeedy@h
# 	ori r3, r3, enableSpeedy@l
# 	lbz r3, 0(r3)
# 	cmpwi r3, 1
# 	beqlr
# 	bgtlr
# 	b doneWithForbidTimeUpIfSpeedy


.global ForbidQuickMusicIfSpeedy
ForbidQuickMusicIfSpeedy:
	lis r3, enableSpeedy@h
	ori r3, r3, enableSpeedy@l
	lbz r3, 0(r3)
	cmpwi r3, 1
	beq dontPlayQuickMusic
	li r0, 1
	b doneWithForbidQuickMusicIfSpeedy

dontPlayQuickMusic:
	b doneWithForbidQuickMusicIfSpeedy2


.global SetTimeKeeperTime
SetTimeKeeperTime:
	lis r4, enableSpeedy@h
	ori r4, r4, enableSpeedy@l
	lbz r4, 0(r4)
	cmpwi r4, 1
	beq SetTimeKeeperToSpeedyTimer

	addic. r0, r3, -92
	b doneWithSetTimeKeeperTime

SetTimeKeeperToSpeedyTimer:
	lis r3, speedyTimer@h
	ori r3, r3, speedyTimer@l
	lwz r3, 0(r3)
	slwi r0, r3, 12
	cmpwi r0, 1
	b doneWithSetTimeKeeperTime


.global TimeKeeperSetTime
TimeKeeperSetTime:
	lis r3, enableSpeedy@h
	ori r3, r3, enableSpeedy@l
	lbz r3, 0(r3)
	cmpwi r3, 1
	beq SetSpeedyTime
	blr
SetSpeedyTime:
	lis r3, speedyTimer@h
	ori r3, r3, speedyTimer@l
	stw r4, 0(r3)
	blr


.global LayoutResetAnimCorrectly
LayoutResetAnimCorrectly:
	cmpwi r5, 2
	beq SetF1To0

	fsubs f1, f1, f0
	b doneWithLayoutResetAnimCorrectly

SetF1To0:
	lis r5, float1@h
	ori r5, r5, float1@l
	lfs f1, 0(r5)
	b doneWithLayoutResetAnimCorrectly


#.global StarCoinGiveTime # Commented out because this is being done in plusClock.cpp now
#StarCoinGiveTime:
#	lis r3, enableSpeedy@h
#	ori r3, r3, enableSpeedy@l
#	lbz r3, 0(r3)
#	cmpwi r3, 1
#	beq AddSpeedyTime
#	b returnFromStarCoinGiveTime
#
#AddSpeedyTime:
#	lis r3, speedyTimer@h
#	ori r3, r3, speedyTimer@l
#	lwz r5, 0(r3)
#	addi r5, r5, 10
#	stw r5, 0(r3)
#
#returnFromStarCoinGiveTime:
#	mr r3, r31
#	b doneWithStarCoinGiveTime


.global NoBonusTime
NoBonusTime:
	lis r4, enableSpeedy@h
	ori r4, r4, enableSpeedy@l
	lbz r4, 0(r4)
	cmpwi r4, 1
	beq RemoveBonusTime

	lwz r0, 0xAF4(r3)
	b doneWithNoBonusTime
RemoveBonusTime:
	addi r27, r27, 200

	bl GetActivePlayerCount
	cmpwi r3, 1
	ble noBonus30Secs
	addi r27, r27, 30

noBonus30Secs:
	b doneWithNoBonusTime2



.data
.align 4

.global speedyTimer
speedyTimer:
	.long 0

.global enableSpeedy
enableSpeedy:
	.byte 0
	.align 4

.global float05
float05:
	.float 0.5

.global float1
float1:
	.float 1.0

.global float2
float2:
	.float 2.0