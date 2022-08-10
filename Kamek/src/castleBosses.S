.text
#include <asm_setup.S>
.align 4

.extern _ZN12dPowerStar_c18StateID_CastleFallE
.extern _ZN12dPowerStar_c19StateID_CastleFloatE

.global SpawnStarInsteadOfKey
SpawnStarInsteadOfKey:
	lwz		r5, 4(r27)			# Get this->settings so we can check if we should use the key or the power star
	rlwinm	r5, r5, 4, 31, 31	# Equivalent of ((r5 >> 28) & 1) which is our "Use Power Star" bit
	cmpwi	r5, 1
	beq		spawnStar

	li		r5, 0 # Restore instruction
	blr
spawnStar:
	li		r3, 340	# WALLINSECT_MGR = Power star
	li		r5, 2	# bit 2 from the right is our "Castle Star" bit
	blr

.global CheckForStarState
CheckForStarState:
	mtctr	r12  # Restore instruction

	lwz		r5, 4(r31)			# Get this->settings 
	rlwinm	r5, r5, 4, 31, 31	# Get "Use Power Star" bit
	cmpwi	r5, 1
	beq		checkStarState
	blr
checkStarState:
	lis		r4, _ZN12dPowerStar_c18StateID_CastleFallE@h
	ori		r4, r4, _ZN12dPowerStar_c18StateID_CastleFallE@l
	blr

.global UseR31ForStar
UseR31ForStar:
	mr		r31, r3
	lwz		r3, 0x450(r3)
	blr

.global UseFallStarState
UseFallStarState:
	mtctr	r12  # Restore instruction

	lwz		r5, 4(r31)			# Get this->settings 
	rlwinm	r5, r5, 4, 31, 31	# Get "Use Power Star" bit
	cmpwi	r5, 1
	beq		fallStarState
	blr
fallStarState:
	lis		r4, _ZN12dPowerStar_c18StateID_CastleFallE@h
	ori		r4, r4, _ZN12dPowerStar_c18StateID_CastleFallE@l
	blr

.global UseFloatStarState
UseFloatStarState:
	mtctr	r12  # Restore instruction

	lwz		r5, 4(r31)			# Get this->settings 
	rlwinm	r5, r5, 4, 31, 31	# Get "Use Power Star" bit
	cmpwi	r5, 1
	beq		floatStarState
	blr
floatStarState:
	lis		r4, _ZN12dPowerStar_c19StateID_CastleFloatE@h
	ori		r4, r4, _ZN12dPowerStar_c19StateID_CastleFloatE@l
	blr

.global UseInvisibleStarState
UseInvisibleStarState:
	mtctr	r12  # Restore instruction

	lwz		r5, 4(r31)			# Get this->settings 
	rlwinm	r5, r5, 4, 31, 31	# Get "Use Power Star" bit
	cmpwi	r5, 1
	beq		invisibleStarState
	blr
invisibleStarState:
	lis		r4, _ZN12dPowerStar_c18StateID_CastleWaitE@h
	ori		r4, r4, _ZN12dPowerStar_c18StateID_CastleWaitE@l
	blr

.global UseInvisibleStarState2
UseInvisibleStarState2:
	mtctr	r12  # Restore instruction

	lwz		r5, 4(r27)			# Get this->settings 
	rlwinm	r5, r5, 4, 31, 31	# Get "Use Power Star" bit
	cmpwi	r5, 1
	beq		invisibleStarState2
	blr
invisibleStarState2:
	lis		r4, _ZN12dPowerStar_c18StateID_CastleWaitE@h
	ori		r4, r4, _ZN12dPowerStar_c18StateID_CastleWaitE@l
	blr