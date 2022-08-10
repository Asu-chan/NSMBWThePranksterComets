.text
#include <asm_setup.S>

.extern doneWithSetPowerupPauseFlag
.extern doneWithUnsetPowerupPauseFlag

.global SetPowerupPauseFlag
SetPowerupPauseFlag:
	lis r3, isPowerupPausing@h
	ori r3, r3, isPowerupPausing@l
	li r4, 1
	stb r4, 0(r3)

	mr r3, r31
	b doneWithSetPowerupPauseFlag


.global UnsetPowerupPauseFlag
UnsetPowerupPauseFlag:
	lis r3, isPowerupPausing@h
	ori r3, r3, isPowerupPausing@l
	li r4, 0
	stb r4, 0(r3)

	mr r3, r31
	b doneWithUnsetPowerupPauseFlag
	

.data
.align 4

.global isPowerupPausing
isPowerupPausing:
	.byte 0

.align 4