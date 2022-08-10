#include <asm_setup.S>

#define WPAD_BUTTON_2							0x0001
#define WPAD_BUTTON_1							0x0002
#define WPAD_BUTTON_B							0x0004
#define WPAD_BUTTON_A							0x0008
#define WPAD_BUTTON_MINUS						0x0010
#define WPAD_BUTTON_HOME						0x0080
#define WPAD_BUTTON_LEFT						0x0100
#define WPAD_BUTTON_RIGHT						0x0200
#define WPAD_BUTTON_DOWN						0x0400
#define WPAD_BUTTON_UP							0x0800
#define WPAD_BUTTON_PLUS						0x1000

#define WPAD_CLASSIC_BUTTON_UP					0x0001
#define WPAD_CLASSIC_BUTTON_LEFT				0x0002
#define WPAD_CLASSIC_BUTTON_R					0x0004
#define WPAD_CLASSIC_BUTTON_X					0x0008
#define WPAD_CLASSIC_BUTTON_A					0x0010
#define WPAD_CLASSIC_BUTTON_Y					0x0020
#define WPAD_CLASSIC_BUTTON_B					0x0040
#define WPAD_CLASSIC_BUTTON_L					0x0080
#define WPAD_CLASSIC_BUTTON_ZR					0x0200
#define WPAD_CLASSIC_BUTTON_PLUS				0x0400
#define WPAD_CLASSIC_BUTTON_HOME				0x0800
#define WPAD_CLASSIC_BUTTON_MINUS				0x1000
#define WPAD_CLASSIC_BUTTON_ZL					0x2000
#define WPAD_CLASSIC_BUTTON_DOWN				0x4000
#define WPAD_CLASSIC_BUTTON_RIGHT				0x8000

.set stackSize,0x30;
.set r4Place,0x10;
.set r5Place,0x14;
.set r6Place,0x18;
.set r26Place,0x1c;
.set f8Place,0x20;
.set f9Place,0x24;
.set f10Place,0x28;
.set f11Place,0x2c;

.text
.align 4





.global waggleAdjust
waggleAdjust:
	
	lbz		r5, 0x5C(r3)		# wiimote extension type
	cmpwi	r5, 2				# classic controller

	beq ClassicControllerWaggle

	stfs	f0, 0(r4)
	blr

ClassicControllerWaggle:

	li		r12, 0
	stw		r12, 0(r4)
	blr




.global _switch_buttons
_switch_buttons:
	addi    r1,r1,0x50			# replaced instruction

	stwu	r1,-stackSize(r1)		# provide new stack for saving regs
	mflr    r14
	stw		r4,r4Place(r1)
	stw		r5,r5Place(r1)
	stw		r6,r6Place(r1)
	stw		r26,r26Place(r1)
	stfs	f8,f8Place(r1)
	stfs	f9,f9Place(r1)
	stfs	f10,f10Place(r1)
	stfs	f11,f11Place(r1)

	lbz		r5,0x5C(r26)		# wiimote extension type
	cmpwi	r5, 2				# classic controller
	bne		cleanup

	lis     r4, inside_kpads@h
	ori     r4, r4, inside_kpads@l
	sub     r8, r26, r4
	li      r4, 0x15E
	divwu   r8, r8, r4 # Wiimote number! (0x15E = 0x578 / 4)

	lwz		r5, 0x60(r26)

Tilt:
	li		r5,	0
	stw		r5,	0x54(r26)
	stw		r5,	0x58(r26)

	lwz		r5,	0x80(r26)
	cmpwi	r5,	0
	beq		TiltLeftSkip

	lfs		f11, 0x80(r26)

	lis		r5,	0
	stw		r5,	0x80(r26)
	lfs		f10, 0x80(r26)

	fsubs	f11, f10, f11
	
	stfs    f11, 0x58(r26)

TiltLeftSkip:
	
	lwz		r5,	0x7C(r26)
	cmpwi	r5,	0
	beq		TiltRightSkip
	stw		r5,	0x58(r26)

TiltRightSkip:
	lwz		r5,0x60(r26)		# wiimote cc data ; KPADInsideStatus->KPADEXStatus_bl->hold
	bl		 map_buttons
	lwz		r4,0(r26)			# wiimote ; KPADInsideStatus->hold
	or		 r5,r5,r4
	stw		r5,0(r26)			# wiimote ; KPADInsideStatus->hold
	lwz		r5,0x64(r26)		# wiimote cc data ; KPADInsideStatus->KPADEXStatus_bl->trig
	bl		 map_buttons
	lwz		r4,4(r26)			# wiimote ; KPADInsideStatus->trig
	or		 r5,r5,r4
	stw		r5,4(r26)			# wiimote ; KPADInsideStatus->trig
	lwz		r5,0x68(r26)		# wiimote cc data ; KPADInsideStatus->KPADEXStatus_bl->release
	bl		 map_buttons
	lwz		r4,8(r26)			# wiimote ; KPADInsideStatus->release
	or		 r5,r5,r4
	stw		r5,8(r26)			# wiimote ; KPADInsideStatus->release

cleanup:
	mr r3, r26
	bl _Z11doOSReportsP10KPADStatus
	lwz		r4,r4Place(r1)
	lwz		r5,r5Place(r1)
	lwz		r6,r6Place(r1)
	lwz		r26,r26Place(r1)
	lfs		f8,f8Place(r1)
	lfs		f9,f9Place(r1)
	lfs		f10,f10Place(r1)
	lfs		f11,f11Place(r1)
	mtlr    r14
	addi	r1,r1,stackSize
	blr

# r5 == CC data
# r5 returns the wpad data


map_buttons:
	mflr    r15

	lis     r7, amIinStage@h
	ori     r7, r7, amIinStage@l
	lwz     r7, 0(r7)
	cmpwi   r7, 5
	beq     imInStage

	lis     r7, classicControllerType@h
	ori     r7, r7, classicControllerType@l
	add    r7, r7, r8
	lwz     r7, 0(r7)
imInStage:

	li		r6,0
	andi.   r4,r5,0x10		// WPAD_CLASSIC_BUTTON_A
	beq-    skip_A
	ori		r6,r6,0x100		// WPAD_BUTTON_2
skip_A:
	andi.   r4,r5,0x800		// WPAD_CLASSIC_BUTTON_HOME
	beq-    skip_home
	ori		r6,r6,0x8000	// WPAD_BUTTON_HOME
skip_home:
	andi.   r4,r5,0x20		// WPAD_CLASSIC_BUTTON_Y
	beq-    skip_Y
	ori		r6,r6,0x200		// WPAD_BUTTON_1
skip_Y:
	andi.   r4,r5,0x8		// WPAD_CLASSIC_BUTTON_X
	beq-    skip_X
	cmpwi   r7, 5
	beq     doXA
	cmpwi   r7, 1
	ble     doXA
	cmpwi   r7, 2
	beq     doX1
	doX2:
	ori		r6,r6,0x100		// WPAD_BUTTON_2
	b skip_X
	doXA:
	ori		r6,r6,0x800		// WPAD_BUTTON_A
	b skip_X
	doX1:
	ori		r6,r6,0x200		// WPAD_BUTTON_1
skip_X:
	andi.   r4,r5,0x40		// WPAD_CLASSIC_BUTTON_B
	beq-    skip_B
	cmpwi   r7, 5
	beq     doB1
	cmpwi   r7, 2
	bge		doBA
	cmpwi   r7, 0
	beq     doB1
	ori		r6,r6,0x100		// WPAD_BUTTON_2
	b skip_B
	doBA:
	ori		r6,r6,0x800		// WPAD_BUTTON_A
	b skip_B
	doB1:
	ori		r6,r6,0x200		// WPAD_BUTTON_1
skip_B:
	andi.   r4,r5,0x80		// WPAD_CLASSIC_BUTTON_ZL
	beq-    skip_ZL
	lis     r6,0x7fc0		// float
	stw     r6,0x10(r26)	// set waggle ; KPADInsideStatus->acc->y
skip_ZL:
	andi.   r4,r5,0x4		// WPAD_CLASSIC_BUTTON_ZR
	beq-    skip_ZR
	lis     r6,0x7fc0		// float
	stw     r6,0x10(r26)	// set waggle ; KPADInsideStatus->acc->y
skip_ZR:
	andi.   r4,r5,0x400		// WPAD_CLASSIC_BUTTON_PLUS
	beq-    skip_plus
	ori		r6,r6,0x10		// WPAD_BUTTON_PLUS
skip_plus:
	andi.   r4,r5,0x1000	// WPAD_CLASSIC_BUTTON_MINUS
	beq-    skip_minus
	ori		r6,r6,0x1000	// WPAD_BUTTON_MINUS
skip_minus:
	andi.	r4,r5,0xC003	// Any_DPAD
	beq-	DPADOnly		// DPAD and Analog are processed separately to avoid conflicting button presses

	andi.   r4,r5,1			// WPAD_CLASSIC_BUTTON_UP
	beq-    skip_up
	ori		r6,r6,2			// WPAD_BUTTON_RIGHT
skip_up:
	andi.   r4,r5,2			// WPAD_CLASSIC_BUTTON_LEFT
	beq-    skip_left
	ori		r6,r6,8			// WPAD_BUTTON_UP
skip_left:
	andi.   r4,r5,0x8000	// WPAD_CLASSIC_BUTTON_RIGHT
	beq-    skip_right
	ori		r6,r6,4			// WPAD_BUTTON_DOWN
skip_right:
	andi.   r4,r5,0x4000	// WPAD_CLASSIC_BUTTON_DOWN
	beq-    skip_down
	ori		r6,r6,1			// WPAD_BUTTON_LEFT
skip_down:
	b handleRightStick

DPADOnly:
	lfs		f8,0x6c(r26)	// left analog x ; KPADInsideStatus->KPADEXStatus_cl->lstick.x
	lfs		f9,0x70(r26)	// left analog y ; KPADInsideStatus->KPADEXStatus_cl->lstick.y

	lis		r5,float_one@ha
	lfs		f10,float_one@l(r5)

	lis		r5,float_neg_one@ha
	lfs		f11,float_neg_one@l(r5)

	fcmpu	cr0,f8,f10		// WPAD_R_ANALOG_RIGHT
	blt		skip_right_analog
	ori		r6,r6,4			// WPAD_BUTTON_DOWN
skip_right_analog:
	fcmpu	cr0,f9,f10		// WPAD_R_ANALOG_UP
	blt		skip_up_analog
	ori		r6,r6,2			// WPAD_BUTTON_RIGHT
skip_up_analog:
	fcmpu	cr0,f8,f11		// WPAD_R_ANALOG_LEFT
	bge		skip_down_analog
	ori		r6,r6,8			// WPAD_BUTTON_UP
skip_down_analog:
	fcmpu	cr0,f9,f11		// WPAD_R_ANALOG_DOWN
	bge		skip_left_analog
	ori		r6,r6,1			// WPAD_BUTTON_LEFT
skip_left_analog:


handleRightStick:
	mr		r3, r26
	bl		_Z15adaptRightStickP10KPADStatus

	#lis		r4, rightStickTilt@h
	#ori		r4, r4, rightStickTilt@l
	#lwz		r8, 0(r4)
	#stw		r8, 0x44(r26)	// set tilt ; KPADInsideStatus->acc_vertical->x
	#lwz		r8, 4(r4)
	#stw		r8, 0x48(r26)	// set tilt ; KPADInsideStatus->acc_vertical->x

	mr		r5,r6
	mtlr    r15
	blr


.global CheckIfInStage
CheckIfInStage:
	lis r4, amIinStage@h
	ori r4, r4, amIinStage@l

	lhz r3, 8(r30)
	cmpwi r3, 5 # STAGE
	bne NotInStage

	lis r3, StageActorDisableFlags@h
	ori r3, r3, StageActorDisableFlags@l
	lbz r3, 0(r3)
	cmpwi r3, 0
	bgt NotInStage

	li r3, -1
	bl QueryGlobal5758
	cmpwi r3, 1
	beq NotInStage

	li r3, 0
	
	b CheckIfInStageReturn

NotInStage:
	li r3, 5

CheckIfInStageReturn:
	stw r3, 0(r4)
	mr r3, r30 # Restore instruction
	b doneWithCheckIfInStage


.global AddRemoconState
AddRemoconState:
	lis r3, stru_remoClassicEnd@h
	ori r3, r3, stru_remoClassicEnd@l

	lis r5, stru_remoClassicBegin@h
	ori r5, r5, stru_remoClassicBegin@l

	lis r6, stru_remoClassicExecute@h
	ori r6, r6, stru_remoClassicExecute@l

	lwz r27, 0(r3)
	lwz r12, 4(r3)
	lwz r11, 8(r3)

	lwz r10, 0(r6)
	lwz r9, 4(r6)
	lwz r8, 8(r6)

	lwz r7, 0(r5)
	lwz r6, 4(r5)
	lwz r0, 8(r5)

	lis r4, classicStateName@h
	ori r4, r4, classicStateName@l

	lis r3, stateStuff@h
	ori r3, r3, stateStuff@l
	addi r3, r3, 0x10

	stw r27, 0x8(r1)
	stw r12, 0xC(r1)
	stw r11, 0x10(r1)
	stw r10, 0x14(r1)
	stw r9, 0x18(r1)
	stw r8, 0x1C(r1)
	stw r7, 0x20(r1)
	stw r6, 0x24(r1)
	stw r0, 0x28(r1)

	bl __ct__12dStateBase_cFPCc

	lis r3, stateStuff@h
	ori r3, r3, stateStuff@l
	addi r3, r3, 0x10

	lwz r28, 0x20(r1)
	lwz r12, 0x24(r1)
	mr r7, r27
	lwz r11, 0x28(r1)
	addi r4, r31, -0x2740
	lwz r10, 0x14(r1)

	lis r5, stateStuff@h
	ori r5, r5, stateStuff@l
	lwz r9, 0x18(r1)
	lwz r8, 0x1C(r1)
	lwz r6, 0xC(r1)
	lwz r0, 0x10(r1)

	stw r30, 0x10(r5)
	stw r28, 0x1C(r5)
	stw r12, 0x20(r5)
	stw r11, 0x24(r5)
	stw r10, 0x28(r5)
	stw r9, 0x2C(r5)
	stw r8, 0x30(r5)
	stw r7, 0x34(r5)
	stw r6, 0x38(r5)
	stw r0, 0x3C(r5)

	bl __register_global_object


	addi r11, r1, 0x100 # Restore instruction
	b doneWithAddRemoconState


#.global ChangeIDForCC
#ChangeIDForCC:
#	cmpwi r30, 2
#	bgt isNotCC
#	cmpwi r30, 2
#	blt ChangeIDForCCReturn2
#	li r3, 5
#	b ChangeIDForCCReturn
#isNotCC:
#	li r3, 2
#ChangeIDForCCReturn:
#	stw r3, 8(r28)
#
#ChangeIDForCCReturn2:
#	lwz r0, 0x24(r1) # Restore instruction
#	b doneWithChangeIDForCC


.global RemoconConnectExtension_executeWait
RemoconConnectExtension_executeWait:
	beq waitClassic
	b RemoconConnectExtension_executeWaitReturn
waitClassic:
	lis r4, _ZN23RemoconConnectExtension15StateID_ClassicE@h
	ori r4, r4, _ZN23RemoconConnectExtension15StateID_ClassicE@l
	lwz r12, 0xC(r27)
	addi r3, r27, 0xC
	lwz r12, 0x18(r12)
	mtctr r12
	bctrl
	b RemoconConnectExtension_executeWaitReturn


.global RemoconConnectExtension_executeNone
RemoconConnectExtension_executeNone:
	beq noneClassic
	b RemoconConnectExtension_executeNoneReturn
noneClassic:
	lis r4, _ZN23RemoconConnectExtension15StateID_ClassicE@h
	ori r4, r4, _ZN23RemoconConnectExtension15StateID_ClassicE@l
	lwz r12, 0xC(r28)
	addi r3, r28, 0xC
	lwz r12, 0x18(r12)
	mtctr r12
	bctrl
	b RemoconConnectExtension_executeNoneReturn


.global RemoconConnectExtension_executeFreestyle
RemoconConnectExtension_executeFreestyle:
	beq freestyleClassic
	b RemoconConnectExtension_executeFreestyleReturn
freestyleClassic:
	lis r4, _ZN23RemoconConnectExtension15StateID_ClassicE@h
	ori r4, r4, _ZN23RemoconConnectExtension15StateID_ClassicE@l
	lwz r12, 0xC(r28)
	addi r3, r28, 0xC
	lwz r12, 0x18(r12)
	mtctr r12
	bctrl
	b RemoconConnectExtension_executeFreestyleReturn


.global RemoconConnectExtension_executeOther
RemoconConnectExtension_executeOther:
	cmpwi r30, 2
	beq otherClassic
	b RemoconConnectExtension_executeOtherReturn
otherClassic:
	lis r4, _ZN23RemoconConnectExtension15StateID_ClassicE@h
	ori r4, r4, _ZN23RemoconConnectExtension15StateID_ClassicE@l
	lwz r12, 0xC(r28)
	addi r3, r28, 0xC
	lwz r12, 0x18(r12)
	mtctr r12
	bctrl
	b RemoconConnectExtension_executeOtherReturn


.global _ZN23RemoconConnectExtension20executeState_ClassicEv
_ZN23RemoconConnectExtension20executeState_ClassicEv:
	stwu r1, -0x20(r1)
	mflr r0
	stw r0, 0x24(r1)
	stw r31, 0x1C(r1)
	stw r30, 0x18(r1)
	stw r29, 0x14(r1)
	stw r28, 0x10(r1)

	mr r28, r3
	lwz r29, 4(r3)
	lis r4, CoreControllerPtr@h
	ori r4, r4, CoreControllerPtr@l

	li r3, 0
	lis r31, dword_8042A740@h
	ori r31, r31, dword_8042A740@l
	lwz r31, 0(r31)
	slwi r0, r29, 2
	cmpwi r29, 0
	lwzx r4, r4, r0
	lbz r30, 0x74(r4)
	blt remoClassicSkip1

	lwz r0, 0xE28(r31)
	cmpw r29, r0
	bge remoClassicSkip1

	li r3, 1

remoClassicSkip1:
	cmpwi r3, 0
	bne remoClassicSkip2

	lwz r12, 0xE24(r31)
	addi r3, r31, 0xE24
	lwz r12, 0x18(r12)
	mtctr r12
	bctrl

remoClassicSkip2:
	lwz r3, 0xE2C(r31)
	slwi r0, r29, 2
	lwzx r0, r3, r0
	cmpw r30, r0
	bne remoClassicReturn

	addi r0, r30, -251
	cmplwi r0, 1
	ble remoClassicOther
	cmpwi r30, 0
	beq remoClassicNone
	cmpwi r30, 1
	beq remoClassicFreestyle
	b remoClassicReturn

remoClassicNone:
	lis r4, _ZN23RemoconConnectExtension12StateID_NoneE@h
	ori r4, r4, _ZN23RemoconConnectExtension12StateID_NoneE@l
	lwz r12, 0xC(r28)
	addi r3, r28, 0xC
	lwz r12, 0x18(r12)
	mtctr r12
	bctrl
	b remoClassicReturn

remoClassicFreestyle:
	lis r4, _ZN23RemoconConnectExtension17StateID_FreestyleE@h
	ori r4, r4, _ZN23RemoconConnectExtension17StateID_FreestyleE@l
	lwz r12, 0xC(r28)
	addi r3, r28, 0xC
	lwz r12, 0x18(r12)
	mtctr r12
	bctrl
	b remoClassicReturn

remoClassicOther:
	lis r4, _ZN23RemoconConnectExtension13StateID_OtherE@h
	ori r4, r4, _ZN23RemoconConnectExtension13StateID_OtherE@l
	lwz r12, 0xC(r28)
	addi r3, r28, 0xC
	lwz r12, 0x18(r12)
	mtctr r12
	bctrl

remoClassicReturn:
	lwz r0, 0x24(r1)
	lwz r31, 0x1C(r1)
	lwz r30, 0x18(r1)
	lwz r29, 0x14(r1)
	lwz r28, 0x10(r1)

	mtlr r0
	addi r1, r1, 0x20
	blr


#.global PatchShowNunchuk
#PatchShowNunchuk:
#	li r4, 0
#	stw r4, 0xD80(r27)
#
#	lwz r12, 0xB0C(r27) # Restore instruction
#	b doneWithPatchShowNunchuk


.global CtorClassic
CtorClassic:
	addi r3, r30, 0xB94
	bl _ZN17dWarningClassic_cC1Ev
	addi r3, r30, 0x8DC
	b doneWithCtorClassic


.global DtorClassic
DtorClassic:
	addi r3, r30, 0xB94
	li r4, -1
	bl _ZN17dWarningClassic_cD1Ev
	addi r3, r30, 0x74
	b doneWithDtorClassic


.global CreateClassic
CreateClassic:
	addi r3, r31, 0xB94
	bl _ZN17dWarningClassic_c8onCreateEv
	cmpwi r3, 0
	bne CreateClassicContinue
	li r3, 0
	b CreateClassicReturn

CreateClassicContinue:
	li r3, 5 # Restore instruction
	b doneWithCreateClassic


.global DeleteClassic
DeleteClassic:
	bne DeleteClassicContinue
	li r3, 0
	b DeleteClassicReturn

DeleteClassicContinue:
	addi r3, r31, 0xB94
	bl _ZN17dWarningClassic_c8onDeleteEv
	cmpwi r3, 0
	bne _DeleteClassicContinue2
	li r3, 0
	b DeleteClassicReturn

_DeleteClassicContinue2:
	b DeleteClassicContinue2


#.global ExecuteClassic
#ExecuteClassic:


.global DrawClassic
DrawClassic:
	addi r3, r31, 0xB94
	bl _ZN17dWarningClassic_c6onDrawEv
	addi r3, r31, 0x8DC
	b doneWithDrawClassic


.global ShowClassic
ShowClassic:
	cmpwi r29, 5 
	beq doClassic

	b doneWithShowClassic
doClassic:
	slwi r0, r25, 2
	mr r3, r31
	add r5, r31, r0
	mr r4, r25
	stw r29, 0xB54(r5)
	bl _ZN17dWarningManager_c18showWarningClassicEj
	li r0, 1
	stw r0, 0xB68(r31)
	b doneWithShowClassic2


.global CheckForClassic
CheckForClassic:
	cmpwi r29, 5
	beq _CheckForClassicContinue
	cmpwi r29, 3
	b doneWithCheckForClassic

_CheckForClassicContinue:
	b CheckForClassicContinue


.global SetClassicVisibility0
SetClassicVisibility0:
	lbz r0, 0xD79(r31) # dWarningClassic_c.isVisible
	cmpwi r0, 0
	beq SkipClassicVisibility
	li r0, 0
	stb r0, 0xD79(r31)
	lis r4, _ZN17dWarningClassic_c17StateID_StartWaitE@h
	ori r4, r4, _ZN17dWarningClassic_c17StateID_StartWaitE@l
	addi r3, r31, 0xD30
	lwz r12, 0xD30(r31)
	lwz r12, 0x18(r12)
	mtctr r12
	bctrl

SkipClassicVisibility:
	lbz r0, 0x8BD(r31) # Restore Instruction
	b doneWithSetClassicVisibility0


.global ExecuteClassicForSomeReason
ExecuteClassicForSomeReason:
	lbz r0, 0xD7A(r31) # dWarningClassic_c._1E6
	cmpwi r0, 0
	beq ExecuteClassicForSomeReasonContinue
	addi r3, r31, 0xB94
	bl _ZN17dWarningClassic_c9onExecuteEv
	b ExecuteClassicForSomeReasonReturn

ExecuteClassicForSomeReasonContinue:
	li r0, 5 # Restore Instruction
	b doneWithExecuteClassicForSomeReason


.global GiveClassicARemoconID
GiveClassicARemoconID:
	bne not_nunchuck
	li r0, 1
	b GiveClassicARemoconIDReturn
not_nunchuck:
	cmpwi r0, 5 # 5??
	bne _doneWithGiveClassicARemoconID
	li r0, 2
GiveClassicARemoconIDReturn:
	stw r0, 8(r3)
_doneWithGiveClassicARemoconID:
	b doneWithGiveClassicARemoconID


.global PatchControllerIconA
PatchControllerIconA:
	cmpwi r0, 1
	beq doANunchuk
	li r6, 86
	b doneWithPatchControllerIcon
doANunchuk:
	li r6, 10
	b doneWithPatchControllerIcon


.global PatchControllerIcon1
PatchControllerIcon1:
	cmpwi r5, 0
	beq do1None
	cmpwi r5, 1
	beq doBNunchuk
	li r6, 85
	b doneWithPatchControllerIcon
do1None:
	li r6, 3
	b doneWithPatchControllerIcon
doBNunchuk:
	li r6, 4
	b doneWithPatchControllerIcon



.data

float_one:
.float 0.5
float_neg_one:
.float -0.5
float_zero:
.float 0.0

.global classicControllerType
classicControllerType: .long 0, 0, 0, 0

.global amIinStage
amIinStage:
	.long 0


.global stru_remoClassicBegin
stru_remoClassicBegin:
	.long 0, -1, remoClassicBegin

.global stru_remoClassicExecute
stru_remoClassicExecute:
	.long 0, -1, remoClassicExecute

.global stru_remoClassicEnd
stru_remoClassicEnd:
	.long 0, -1, remoClassicEnd

.global classicStateName
classicStateName: .string "dRemoconMng_c::dConnect_c::dExtension_c::StateID_Classic"

.align 4

.global stateStuff
stateStuff: .space 0x40


.global stateBegin
stateBegin: .space 0x10
.global _ZN23RemoconConnectExtension15StateID_ClassicE
_ZN23RemoconConnectExtension15StateID_ClassicE:
	.long RemoconConnect_StateVTable, classicStateName, 0x821
	.long 0, -1, _ZN23RemoconConnectExtension18beginState_ClassicEv
	.long 0, -1, _ZN23RemoconConnectExtension20executeState_ClassicEv
	.long 0, -1, _ZN23RemoconConnectExtension16endState_ClassicEv