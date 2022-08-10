.text
#include <asm_setup.S>

.extern _ZN14dGameDisplay_c16updateCometStuffEi
.extern doneWithInitiateGDComets
.extern doneWithCometFlagsReset
.extern doneWithGameDisplayBRLAN
.extern doneWithGameDisplayGroups

.extern purplecoins
.extern purplecoinsCollected
.extern enableDaredevil
.extern enableSpeedy
.extern speedyFrameCounter
.extern hasSpeedyStarted
.extern cosmicKillFlag
.extern cosmicBeginFlag
.extern doneWithCosmic
.extern didSpawnCosmicChooser
.extern isFastFoe
.extern playerFuckeryEnabled
.extern plusClocksCollected
.extern cosmicTouch
.extern silverstarCollected

.global InitiateGDComets
InitiateGDComets:
	mr r3, r24
	li r4, 0
	bl _ZN14dGameDisplay_c16updateCometStuffEi

	lfs f0, -0x54C0(r2)
	b doneWithInitiateGDComets
	

.global CometFlagsReset
CometFlagsReset:
	cmpwi r3, 5 #Going to a level
	beq dontReset

	lis r7, purplecoins@h
	ori r7, r7, purplecoins@l
	li r8, 0
	stw r8, 0(r7)

	lis r7, cosmicKillFlag@h
	ori r7, r7, cosmicKillFlag@l
	stw r8, 0(r7)

	lis r7, cosmicBeginFlag@h
	ori r7, r7, cosmicBeginFlag@l
	stw r8, 0(r7)

	lis r7, isFastFoe@h
	ori r7, r7, isFastFoe@l
	stb r8, 0(r7)

	lis r7, enableDaredevil@h
	ori r7, r7, enableDaredevil@l
	stb r8, 0(r7)

	lis r7, enableSpeedy@h
	ori r7, r7, enableSpeedy@l
	stb r8, 0(r7)

	lis r7, speedyFrameCounter@h
	ori r7, r7, speedyFrameCounter@l
	stw r8, 0(r7)

	lis r7, hasSpeedyStarted@h
	ori r7, r7, hasSpeedyStarted@l
	stb r8, 0(r7)

	lis r7, doneWithCosmic@h
	ori r7, r7, doneWithCosmic@l
	stb r8, 0(r7)

	lis r7, didSpawnCosmicChooser@h
	ori r7, r7, didSpawnCosmicChooser@l
	stb r8, 0(r7)

	lis r7, cosmicTouch@h
	ori r7, r7, cosmicTouch@l
	stb r8, 0(r7)

	lis r7, silverstarCollected@h
	ori r7, r7, silverstarCollected@l
	stb r8, 0(r7)
	stb r8, 1(r7)
	stb r8, 2(r7)
	stb r8, 3(r7)
	stb r8, 4(r7)
	stb r8, 5(r7)
	stb r8, 6(r7)
	stb r8, 7(r7)

#	lis r7, purplecoinsCollected@h
#	ori r7, r7, purplecoinsCollected@l
#	li r9, 0
#	b startPCWipingLoop
#
#continuePCWipingLoop:
#	stwx r8, r7, r9
#	addi r9, r9, 1
#
#startPCWipingLoop:
#	cmpwi r9, 32
#	blt continuePCWipingLoop

	lis r7, plusClocksCollected@h
	ori r7, r7, plusClocksCollected@l
	li r9, 0
	b startTACWipingLoop

continueTACWipingLoop:
	stwx r8, r7, r9
	addi r9, r9, 1

startTACWipingLoop:
	cmpwi r9, 100
	blt continueTACWipingLoop

dontReset:
	stwu sp, -0x20(sp)
	b doneWithCometFlagsReset


.global GameDisplayBRLAN
GameDisplayBRLAN:
	lis r4, PCBRLAN@h
	ori r4, r4, PCBRLAN@l
	li r5, 9
	b doneWithGameDisplayBRLAN


.global GameDisplayGroups
GameDisplayGroups:
	lis r4, PCGroups@h
	ori r4, r4, PCGroups@l
	lis r5, PCGroupsIDs@h
	ori r5, r5, PCGroupsIDs@l
	li r6, 9
	b doneWithGameDisplayGroups

.data

.global PCBRLAN
PCBRLAN:
	.long Anim_inMarioCoin
	.long Anim_purpleCoin
	.long Anim_countdownCount
	.long Anim_countdownGo
	.long Anim_timerRed
	.long Anim_timerWait
	.long Anim_timerSignal
	.long Anim_timerAppear
	.long Anim_timerSignalRed

.global PCGroups
PCGroups:
	.long Group_inMarioCoin
	.long Group_PurpleCoin
	.long Group_Countdown
	.long Group_Countdown
	.long Group_TimeLimit
	.long Group_TimeLimit
	.long Group_TimeLimit
	.long Group_TimeLimit
	.long Group_TimeLimit

.global PCGroupsIDs
PCGroupsIDs:
	.long 0
	.long 1
	.long 2
	.long 3
	.long 4
	.long 5
	.long 6
	.long 7
	.long 8


.global Anim_inMarioCoin
Anim_inMarioCoin:
	.string "gameScene_37_inMarioCoin.brlan"

.global Anim_purpleCoin
Anim_purpleCoin:
	.string "gameScene_37_purpleCoin.brlan"

.global Anim_countdownCount
Anim_countdownCount:
	.string "gameScene_37_countdownCount.brlan"

.global Anim_countdownGo
Anim_countdownGo:
	.string "gameScene_37_countdownGo.brlan"

.global Anim_timerRed
Anim_timerRed:
	.string "gameScene_37_timerRed.brlan"

.global Anim_timerWait
Anim_timerWait:
	.string "gameScene_37_timerWait.brlan"

.global Anim_timerSignal
Anim_timerSignal:
	.string "gameScene_37_timerSignal.brlan"

.global Anim_timerAppear
Anim_timerAppear:
	.string "gameScene_37_timerAppear.brlan"

.global Anim_timerSignalRed
Anim_timerSignalRed:
	.string "gameScene_37_timerSignalRed.brlan"

.global Group_inMarioCoin
Group_inMarioCoin:
	.string "C00_inMarioCoin"

.global Group_PurpleCoin
Group_PurpleCoin:
	.string "C01_PurpleCoin"

.global Group_Countdown
Group_Countdown:
	.string "C02_Countdown"

.global Group_TimeLimit
Group_TimeLimit:
	.string "C03_TimeLimit"