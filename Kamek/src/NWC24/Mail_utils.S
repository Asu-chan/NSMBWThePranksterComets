.text
#include <asm_setup.S>
.align 4

.global Mail_strcpy
Mail_strcpy:
		mr        r5, r3
		b         loc_8002AA48
loc_8002AA38:
		lbz       r0, 0(r4)
		addi      r4, r4, 1
		stb       r0, 0(r5)
		addi      r5, r5, 1
loc_8002AA48:
		lbz       r0, 0(r4)
		extsb.    r0, r0
		bne       loc_8002AA38
		li        r0, 0
		stb       r0, 0(r5)
		blr


.global Mail_strlen
Mail_strlen:
		li        r4, 0
		b         loc_8002AA70
loc_8002AA68:
		addi      r4, r4, 1
		addi      r3, r3, 1
loc_8002AA70:
		lbz       r0, 0(r3)
		extsb.    r0, r0
		bne       loc_8002AA68
		mr        r3, r4
		blr


.global STD_strnlen
STD_strnlen:
		li        r5, 0
		mtctr     r4
		cmplwi    r4, 0
		ble       loc_8002AAAC
loc_8002AA94:
		lbz       r0, 0(r3)
		extsb.    r0, r0
		beq       loc_8002AAAC
		addi      r5, r5, 1
		addi      r3, r3, 1
		bdnz      loc_8002AA94
loc_8002AAAC:
		mr        r3, r5
		blr


.global Mail_memcpy
Mail_memcpy:
		b         NETMemCpy


.global Mail_memset
Mail_memset:
		b         NETMemSet


.global Mail_strcat
Mail_strcat:
		mr        r6, r3
		li        r5, 0
		b         loc_8002AAD0
loc_8002AAC8:
		addi      r6, r6, 1
		addi      r5, r5, 1
loc_8002AAD0:
		lbz       r0, 0(r6)
		extsb.    r0, r0
		bne       loc_8002AAC8
		add       r5, r3, r5
		b         loc_8002AAF4
loc_8002AAE4:
		lbz       r0, 0(r4)
		addi      r4, r4, 1
		stb       r0, 0(r5)
		addi      r5, r5, 1
loc_8002AAF4:
		lbz       r0, 0(r4)
		extsb.    r0, r0
		bne       loc_8002AAE4
		li        r0, 0
		stb       r0, 0(r5)
		blr


.global Mail_strncat
Mail_strncat:
		li        r6, 0
		mr        r7, r3
		b         loc_8002AB20
loc_8002AB18:
		addi      r7, r7, 1
		addi      r6, r6, 1
loc_8002AB20:
		lbz       r0, 0(r7)
		extsb.    r0, r0
		bne       loc_8002AB18
		add       r7, r3, r6
		li        r9, 0
		b         loc_8002AB48
loc_8002AB38:
		stb       r8, 0(r7)
		addi      r7, r7, 1
		addi      r9, r9, 1
		addi      r4, r4, 1
loc_8002AB48:
		cmplw     r9, r5
		bge       loc_8002AB5C
		lbz       r8, 0(r4)
		extsb.    r0, r8
		bne       loc_8002AB38
loc_8002AB5C:
		add       r0, r6, r9
		li        r4, 0
		stbx      r4, r3, r0
		blr


.global convNum
convNum:
.set back_chain, -0x20
.set pre_back_chain,  0
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x20+sender_lr(r1)
		addi      r11, r1, 0x20+pre_back_chain
		bl        _savegpr_27
		cmpwi     r7, 0
		beq       loc_8002AB9C
		clrrwi.   r0, r4, 31
		beq       loc_8002AB9C
		neg       r4, r4
		li        r30, 1
		b         loc_8002ABA0
loc_8002AB9C:
		li        r30, 0
loc_8002ABA0:
		li        r31, 0
		li        r12, 0
		lis       r7, -0x8000
		b         loc_8002ACEC
loc_8002ABB0:
		divwu     r0, r4, r5
		mr        r27, r3
		li        r11, 0
		mullw     r0, r0, r5
		subf      r0, r0, r4
		divwu     r4, r4, r5
		extsb     r0, r0
		b         loc_8002ABD8
loc_8002ABD0:
		addi      r27, r27, 1
		addi      r11, r11, 1
loc_8002ABD8:
		lbz       r29, 0(r27)
		extsb.    r29, r29
		bne       loc_8002ABD0
		cmpwi     cr1, r11, 0
		blt       cr1, loc_8002ACCC
		addi      r29, r11, 1
		cmpwi     r29, 8
		ble       loc_8002ACA8
		li        r28, 0
		li        r27, 0
		blt       cr1, loc_8002AC14
		addi      r29, r7, 1 
		cmpw      r11, r29
		blt       loc_8002AC14
		li        r27, 1
loc_8002AC14:
		cmpwi     r27, 0
		beq       loc_8002AC44
		clrrwi.   r29, r11, 31
		li        r27, 1
		bne       loc_8002AC38
		addi      r29, r11, 1
		clrrwi.   r29, r29, 31
		beq       loc_8002AC38
		li        r27, 0
loc_8002AC38:
		cmpwi     r27, 0
		beq       loc_8002AC44
		li        r28, 1
loc_8002AC44:
		cmpwi     r28, 0
		beq       loc_8002ACA8
		srwi      r29, r11, 3
		mtctr     r29
		cmpwi     r11, 8
		blt       loc_8002ACA8
loc_8002AC5C:
		lbzx      r29, r3, r11
		add       r27, r3, r11
		stb       r29, 1(r27)
		lbz       r29, -1(r27)
		stbx      r29, r3, r11
		addi      r11, r11, -8
		lbz       r29, -2(r27)
		stb       r29, -1(r27)
		lbz       r29, -3(r27)
		stb       r29, -2(r27)
		lbz       r29, -4(r27)
		stb       r29, -3(r27)
		lbz       r29, -5(r27)
		stb       r29, -4(r27)
		lbz       r29, -6(r27)
		stb       r29, -5(r27)
		lbz       r29, -7(r27)
		stb       r29, -6(r27)
		bdnz      loc_8002AC5C
loc_8002ACA8:
		addi      r29, r11, 1
		mtctr     r29
		cmpwi     r11, 0
		blt       loc_8002ACCC
loc_8002ACB8:
		lbzx      r29, r3, r11
		add       r27, r3, r11
		addi      r11, r11, -1
		stb       r29, 1(r27)
		bdnz      loc_8002ACB8
loc_8002ACCC:
		cmpwi     r0, 9
		li        r11, 0x30
		ble       loc_8002ACDC
		extsb     r11, r6
loc_8002ACDC:
		add       r0, r0, r11
		addi      r12, r12, 1
		stb       r0, 0(r3)
		addi      r31, r31, 1
loc_8002ACEC:
		cmpwi     r4, 0
		bne       loc_8002ABB0
		lbz       r0, 0(r3)
		extsb.    r0, r0
		bne       loc_8002AE1C
		mr        r4, r3
		li        r5, 0
		b         loc_8002AD14
loc_8002AD0C:
		addi      r4, r4, 1
		addi      r5, r5, 1
loc_8002AD14:
		lbz       r0, 0(r4)
		extsb.    r0, r0
		bne       loc_8002AD0C
		cmpwi     cr1, r5, 0
		blt       cr1, loc_8002AE0C
		addi      r0, r5, 1
		cmpwi     r0, 8
		ble       loc_8002ADE8
		li        r6, 0
		li        r7, 0
		blt       cr1, loc_8002AD54
		lis       r4, -0x8000
		addi      r0, r4, 1 
		cmpw      r5, r0
		blt       loc_8002AD54
		li        r7, 1
loc_8002AD54:
		cmpwi     r7, 0
		beq       loc_8002AD84
		clrrwi.   r0, r5, 31
		li        r4, 1
		bne       loc_8002AD78
		addi      r0, r5, 1
		clrrwi.   r0, r0, 31
		beq       loc_8002AD78
		li        r4, 0
loc_8002AD78:
		cmpwi     r4, 0
		beq       loc_8002AD84
		li        r6, 1
loc_8002AD84:
		cmpwi     r6, 0
		beq       loc_8002ADE8
		srwi      r0, r5, 3
		mtctr     r0
		cmpwi     r5, 8
		blt       loc_8002ADE8
loc_8002AD9C:
		lbzx      r0, r3, r5
		add       r4, r3, r5
		stb       r0, 1(r4)
		lbz       r0, -1(r4)
		stbx      r0, r3, r5
		addi      r5, r5, -8
		lbz       r0, -2(r4)
		stb       r0, -1(r4)
		lbz       r0, -3(r4)
		stb       r0, -2(r4)
		lbz       r0, -4(r4)
		stb       r0, -3(r4)
		lbz       r0, -5(r4)
		stb       r0, -4(r4)
		lbz       r0, -6(r4)
		stb       r0, -5(r4)
		lbz       r0, -7(r4)
		stb       r0, -6(r4)
		bdnz      loc_8002AD9C
loc_8002ADE8:
		addi      r0, r5, 1
		mtctr     r0
		cmpwi     r5, 0
		blt       loc_8002AE0C
loc_8002ADF8:
		lbzx      r0, r3, r5
		add       r4, r3, r5
		addi      r5, r5, -1
		stb       r0, 1(r4)
		bdnz      loc_8002ADF8
loc_8002AE0C:
		li        r0, 0x30
		addi      r12, r12, 1
		stb       r0, 0(r3)
		addi      r31, r31, 1
loc_8002AE1C:
		extsb     r0, r9
		cmpwi     r0, 0x30
		beq       loc_8002AE2C
		li        r9, 0x20
loc_8002AE2C:
		extsb     r5, r10
		add       r31, r31, r30
		lis       r10, -0x8000
		li        r4, 0x20
		li        r0, 0
		b         loc_8002AF94
loc_8002AE44:
		cmpwi     r5, 0x4C
		bne       loc_8002AE80
		mr        r11, r3
		li        r7, 0
		b         loc_8002AE60
loc_8002AE58:
		addi      r11, r11, 1
		addi      r7, r7, 1
loc_8002AE60:
		lbz       r6, 0(r11)
		extsb.    r6, r6
		bne       loc_8002AE58
		stbx      r4, r3, r7
		addi      r6, r7, 1
		addi      r12, r12, 1
		stbx      r0, r3, r6
		b         loc_8002AF90
loc_8002AE80:
		mr        r11, r3
		li        r6, 0
		b         loc_8002AE94
loc_8002AE8C:
		addi      r11, r11, 1
		addi      r6, r6, 1
loc_8002AE94:
		lbz       r7, 0(r11)
		extsb.    r7, r7
		bne       loc_8002AE8C
		cmpwi     cr1, r6, 0
		blt       cr1, loc_8002AF88
		addi      r7, r6, 1
		cmpwi     r7, 8
		ble       loc_8002AF64
		li        r11, 0
		li        r29, 0
		blt       cr1, loc_8002AED0
		addi      r7, r10, 1 
		cmpw      r6, r7
		blt       loc_8002AED0
		li        r29, 1
loc_8002AED0:
		cmpwi     r29, 0
		beq       loc_8002AF00
		clrrwi.   r7, r6, 31
		li        r29, 1
		bne       loc_8002AEF4
		addi      r7, r6, 1
		clrrwi.   r7, r7, 31
		beq       loc_8002AEF4
		li        r29, 0
loc_8002AEF4:
		cmpwi     r29, 0
		beq       loc_8002AF00
		li        r11, 1
loc_8002AF00:
		cmpwi     r11, 0
		beq       loc_8002AF64
		srwi      r7, r6, 3
		mtctr     r7
		cmpwi     r6, 8
		blt       loc_8002AF64
loc_8002AF18:
		lbzx      r7, r3, r6
		add       r11, r3, r6
		stb       r7, 1(r11)
		lbz       r7, -1(r11)
		stbx      r7, r3, r6
		addi      r6, r6, -8
		lbz       r7, -2(r11)
		stb       r7, -1(r11)
		lbz       r7, -3(r11)
		stb       r7, -2(r11)
		lbz       r7, -4(r11)
		stb       r7, -3(r11)
		lbz       r7, -5(r11)
		stb       r7, -4(r11)
		lbz       r7, -6(r11)
		stb       r7, -5(r11)
		lbz       r7, -7(r11)
		stb       r7, -6(r11)
		bdnz      loc_8002AF18
loc_8002AF64:
		addi      r7, r6, 1
		mtctr     r7
		cmpwi     r6, 0
		blt       loc_8002AF88
loc_8002AF74:
		lbzx      r7, r3, r6
		add       r11, r3, r6
		addi      r6, r6, -1
		stb       r7, 1(r11)
		bdnz      loc_8002AF74
loc_8002AF88:
		stb       r9, 0(r3)
		addi      r12, r12, 1
loc_8002AF90:
		addi      r31, r31, 1
loc_8002AF94:
		cmpw      r31, r8
		blt       loc_8002AE44
		cmpwi     r30, 0
		beq       loc_8002B0B8
		mr        r4, r3
		li        r5, 0
		b         loc_8002AFB8
loc_8002AFB0:
		addi      r4, r4, 1
		addi      r5, r5, 1
loc_8002AFB8:
		lbz       r0, 0(r4)
		extsb.    r0, r0
		bne       loc_8002AFB0
		cmpwi     cr1, r5, 0
		blt       cr1, loc_8002B0B0
		addi      r0, r5, 1
		cmpwi     r0, 8
		ble       loc_8002B08C
		li        r6, 0
		li        r7, 0
		blt       cr1, loc_8002AFF8
		lis       r4, -0x8000
		addi      r0, r4, 1 
		cmpw      r5, r0
		blt       loc_8002AFF8
		li        r7, 1
loc_8002AFF8:
		cmpwi     r7, 0
		beq       loc_8002B028
		clrrwi.   r0, r5, 31
		li        r4, 1
		bne       loc_8002B01C
		addi      r0, r5, 1
		clrrwi.   r0, r0, 31
		beq       loc_8002B01C
		li        r4, 0
loc_8002B01C:
		cmpwi     r4, 0
		beq       loc_8002B028
		li        r6, 1
loc_8002B028:
		cmpwi     r6, 0
		beq       loc_8002B08C
		srwi      r0, r5, 3
		mtctr     r0
		cmpwi     r5, 8
		blt       loc_8002B08C
loc_8002B040:
		lbzx      r0, r3, r5
		add       r4, r3, r5
		stb       r0, 1(r4)
		lbz       r0, -1(r4)
		stbx      r0, r3, r5
		addi      r5, r5, -8
		lbz       r0, -2(r4)
		stb       r0, -1(r4)
		lbz       r0, -3(r4)
		stb       r0, -2(r4)
		lbz       r0, -4(r4)
		stb       r0, -3(r4)
		lbz       r0, -5(r4)
		stb       r0, -4(r4)
		lbz       r0, -6(r4)
		stb       r0, -5(r4)
		lbz       r0, -7(r4)
		stb       r0, -6(r4)
		bdnz      loc_8002B040
loc_8002B08C:
		addi      r0, r5, 1
		mtctr     r0
		cmpwi     r5, 0
		blt       loc_8002B0B0
loc_8002B09C:
		lbzx      r0, r3, r5
		add       r4, r3, r5
		addi      r5, r5, -1
		stb       r0, 1(r4)
		bdnz      loc_8002B09C
loc_8002B0B0:
		li        r0, 0x2D
		stb       r0, 0(r3)
loc_8002B0B8:
		addi      r11, r1, 0x20+pre_back_chain
		mr        r3, r12
		bl        _restgpr_27
		lwz       r0, 0x20+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x20
		blr


.global Mail_sprintf
Mail_sprintf:
.set back_chain, -0x80
.set var_78, -0x78
.set var_74, -0x74
.set var_70, -0x70
.set var_6C, -0x6C
.set var_68, -0x68
.set var_64, -0x64
.set var_60, -0x60
.set var_5C, -0x5C
.set var_58, -0x58
.set var_50, -0x50
.set var_48, -0x48
.set var_40, -0x40
.set var_38, -0x38
.set var_30, -0x30
.set var_28, -0x28
.set var_20, -0x20
.set var_18, -0x18
.set var_14, -0x14
.set var_10, -0x10
.set var_4, -4
.set sender_lr,  4
.set arg_8,  8
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x80+sender_lr(r1)
		stw       r31, 0x80+var_4(r1)
		bne       cr1, loc_8002B108
		stfd      f1, 0x80+var_58(r1)
		stfd      f2, 0x80+var_50(r1)
		stfd      f3, 0x80+var_48(r1)
		stfd      f4, 0x80+var_40(r1)
		stfd      f5, 0x80+var_38(r1)
		stfd      f6, 0x80+var_30(r1)
		stfd      f7, 0x80+var_28(r1)
		stfd      f8, 0x80+var_20(r1)
loc_8002B108:
		addi      r11, r1, 0x80+arg_8
		addi      r0, r1, 0x80+var_78
		lis       r12, 0x200
		stw       r3, 0x80+var_78(r1)
		addi      r31, r1, 0x80+var_18
		stw       r5, 0x80+var_70(r1)
		mr        r5, r31
		stw       r4, 0x80+var_74(r1)
		stw       r6, 0x80+var_6C(r1)
		stw       r7, 0x80+var_68(r1)
		stw       r8, 0x80+var_64(r1)
		stw       r9, 0x80+var_60(r1)
		stw       r10, 0x80+var_5C(r1)
		stw       r12, 0x80+var_18(r1)
		stw       r11, 0x80+var_14(r1)
		stw       r0, 0x80+var_10(r1)
		bl        Mail_vsprintf
		lwz       r0, 0x80+sender_lr(r1)
		lwz       r31, 0x80+var_4(r1)
		mtlr      r0
		addi      r1, r1, 0x80
		blr


.global Mail_vsprintf
Mail_vsprintf:
.set back_chain, -0x50
.set pre_back_chain,  0
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x50+sender_lr(r1)
		addi      r11, r1, 0x50+pre_back_chain
		bl        _savegpr_16
		li        r16, 0
		mr        r20, r3
		stb       r16, 0(r3)
		mr        r21, r4
		mr        r22, r5
		li        r31, 0
		lis       r18, -0x8000
		li        r19, 0x20
		lis       r17, _1802@ha
		b         loc_8002B5F4
		b         loc_8002B1A4
loc_8002B1A0:
		addi      r20, r20, 1
loc_8002B1A4:
		lbz       r0, 0(r20)
		extsb.    r0, r0
		bne       loc_8002B1A0
		extsb     r0, r6
		cmpwi     r0, 0x25
		bne       loc_8002B5BC
		lbz       r0, 0(r21)
		addi      r21, r21, 1
		extsb     r3, r0
		cmpwi     r3, 0x25
		bne       loc_8002B20C
		mr        r4, r20
		mr        r6, r20
		li        r5, 0
		addi      r20, r20, 1
		b         loc_8002B1EC
loc_8002B1E4:
		addi      r6, r6, 1
		addi      r5, r5, 1
loc_8002B1EC:
		lbz       r3, 0(r6)
		extsb.    r3, r3
		bne       loc_8002B1E4
		stbx      r0, r4, r5
		addi      r0, r5, 1
		addi      r31, r31, 1
		stbx      r16, r4, r0
		b         loc_8002B5F4
loc_8002B20C:
		cmpwi     r3, 0x2D
		mr        r26, r0
		bne       loc_8002B220
		lbz       r0, 0(r21)
		addi      r21, r21, 1
loc_8002B220:
		extsb     r3, r0
		mr        r25, r0
		cmpwi     r3, 0x2A
		li        r29, 0
		li        r28, 0xA
		li        r24, 0x30
		li        r30, 0
		bne       loc_8002B25C
		mr        r3, r22
		li        r4, 1
		bl        __va_arg
		lbz       r0, 0(r21)
		addi      r21, r21, 1
		lwz       r27, 0(r3)
		b         loc_8002B290
loc_8002B25C:
		li        r27, 0
		b         loc_8002B27C
loc_8002B264:
		mulli     r4, r27, 0xA
		extsb     r3, r0
		lbz       r0, 0(r21)
		addi      r21, r21, 1
		add       r3, r3, r4
		addi      r27, r3, -0x30
loc_8002B27C:
		extsb     r3, r0
		cmpwi     r3, 0x30
		blt       loc_8002B290
		cmpwi     r3, 0x39
		ble       loc_8002B264
loc_8002B290:
		andi.     r3, r0, 0xDF
		extsb     r23, r3
		cmpwi     r23, 0x4C
		bne       loc_8002B2A8
		lbz       r0, 0(r21)
		addi      r21, r21, 1
loc_8002B2A8:
		extsb     r3, r0
		addi      r0, r3, -0x58
		cmplwi    r0, 0x20      
		bgt       def_8002B2C8  
		addi      r3, r17, _1802@l
		slwi      r0, r0, 2
		lwzx      r3, r3, r0
		mtctr     r3
		bctr		    
loc_8002B2CC:
		li        r30, 1        
		li        r29, 1
		b         def_8002B2C8  
loc_8002B2D8:
		li        r30, 1        
		li        r28, 8
		b         def_8002B2C8  
loc_8002B2E4:
		li        r30, 1        
		b         def_8002B2C8  
loc_8002B2EC:
		li        r30, 1        
		li        r28, 0x10
		li        r24, 0x57
		b         def_8002B2C8  
loc_8002B2FC:
		li        r30, 1        
		li        r28, 0x10
		li        r24, 0x37
		b         def_8002B2C8  
loc_8002B30C:
		mr        r3, r22       
		li        r4, 1
		bl        __va_arg
		lwz       r0, 0(r3)
		mr        r3, r20
		mr        r5, r20
		li        r4, 0
		extsb     r6, r0
		addi      r20, r20, 1
		b         loc_8002B33C
loc_8002B334:
		addi      r5, r5, 1
		addi      r4, r4, 1
loc_8002B33C:
		lbz       r0, 0(r5)
		extsb.    r0, r0
		bne       loc_8002B334
		stbx      r6, r3, r4
		addi      r0, r4, 1
		addi      r31, r31, 1
		stbx      r16, r3, r0
		b         def_8002B2C8  
loc_8002B35C:
		mr        r3, r22       
		li        r4, 1
		bl        __va_arg
		lwz       r3, 0(r3)
		cmpwi     r3, 0
		beq       loc_8002B3E0
		mr        r4, r3
		li        r5, 0
		b         loc_8002B388
loc_8002B380:
		addi      r4, r4, 1
		addi      r5, r5, 1
loc_8002B388:
		lbz       r0, 0(r4)
		extsb.    r0, r0
		bne       loc_8002B380
		mr        r6, r20
		li        r4, 0
		b         loc_8002B3A8
loc_8002B3A0:
		addi      r6, r6, 1
		addi      r4, r4, 1
loc_8002B3A8:
		lbz       r0, 0(r6)
		extsb.    r0, r0
		bne       loc_8002B3A0
		add       r4, r20, r4
		b         loc_8002B3CC
loc_8002B3BC:
		lbz       r0, 0(r3)
		addi      r3, r3, 1
		stb       r0, 0(r4)
		addi      r4, r4, 1
loc_8002B3CC:
		lbz       r0, 0(r3)
		extsb.    r0, r0
		bne       loc_8002B3BC
		stb       r16, 0(r4)
		b         loc_8002B3E4
loc_8002B3E0:
		li        r5, 0
loc_8002B3E4:
		add       r31, r31, r5
		extsb     r0, r26
		b         loc_8002B53C
loc_8002B3F0:
		cmpwi     r0, 0x2D
		addi      r31, r31, 1
		bne       loc_8002B42C
		mr        r6, r20
		li        r4, 0
		b         loc_8002B410
loc_8002B408:
		addi      r6, r6, 1
		addi      r4, r4, 1
loc_8002B410:
		lbz       r3, 0(r6)
		extsb.    r3, r3
		bne       loc_8002B408
		stbx      r19, r20, r4
		addi      r3, r4, 1
		stbx      r16, r20, r3
		b         loc_8002B538
loc_8002B42C:
		mr        r6, r20
		li        r3, 0
		b         loc_8002B440
loc_8002B438:
		addi      r6, r6, 1
		addi      r3, r3, 1
loc_8002B440:
		lbz       r4, 0(r6)
		extsb.    r4, r4
		bne       loc_8002B438
		cmpwi     cr1, r3, 0
		blt       cr1, loc_8002B534
		addi      r4, r3, 1
		cmpwi     r4, 8
		ble       loc_8002B510
		li        r6, 0
		li        r7, 0
		blt       cr1, loc_8002B47C
		addi      r4, r18, 1 
		cmpw      r3, r4
		blt       loc_8002B47C
		li        r7, 1
loc_8002B47C:
		cmpwi     r7, 0
		beq       loc_8002B4AC
		clrrwi.   r4, r3, 31
		li        r7, 1
		bne       loc_8002B4A0
		addi      r4, r3, 1
		clrrwi.   r4, r4, 31
		beq       loc_8002B4A0
		li        r7, 0
loc_8002B4A0:
		cmpwi     r7, 0
		beq       loc_8002B4AC
		li        r6, 1
loc_8002B4AC:
		cmpwi     r6, 0
		beq       loc_8002B510
		srwi      r4, r3, 3
		mtctr     r4
		cmpwi     r3, 8
		blt       loc_8002B510
loc_8002B4C4:
		lbzx      r6, r20, r3
		add       r4, r20, r3
		stb       r6, 1(r4)
		lbz       r6, -1(r4)
		stbx      r6, r20, r3
		addi      r3, r3, -8
		lbz       r6, -2(r4)
		stb       r6, -1(r4)
		lbz       r6, -3(r4)
		stb       r6, -2(r4)
		lbz       r6, -4(r4)
		stb       r6, -3(r4)
		lbz       r6, -5(r4)
		stb       r6, -4(r4)
		lbz       r6, -6(r4)
		stb       r6, -5(r4)
		lbz       r6, -7(r4)
		stb       r6, -6(r4)
		bdnz      loc_8002B4C4
loc_8002B510:
		addi      r4, r3, 1
		mtctr     r4
		cmpwi     r3, 0
		blt       loc_8002B534
loc_8002B520:
		lbzx      r4, r20, r3
		add       r6, r20, r3
		addi      r3, r3, -1
		stb       r4, 1(r6)
		bdnz      loc_8002B520
loc_8002B534:
		stb       r19, 0(r20)
loc_8002B538:
		addi      r5, r5, 1
loc_8002B53C:
		cmpw      r5, r27
		blt       loc_8002B3F0
def_8002B2C8:
		cmpwi     r30, 0        
		beq       loc_8002B5F4
		cmpwi     r23, 0x4C
		bne       loc_8002B568
		mr        r3, r22
		li        r4, 1
		bl        __va_arg
		lwz       r4, 0(r3)
		b         loc_8002B594
loc_8002B568:
		cmpwi     r29, 0
		beq       loc_8002B584
		mr        r3, r22
		li        r4, 1
		bl        __va_arg
		lwz       r4, 0(r3)
		b         loc_8002B594
loc_8002B584:
		mr        r3, r22
		li        r4, 1
		bl        __va_arg
		lwz       r4, 0(r3)
loc_8002B594:
		mr        r3, r20
		mr        r5, r28
		mr        r6, r24
		mr        r7, r29
		mr        r8, r27
		extsb     r9, r25
		extsb     r10, r26
		bl        convNum
		add       r31, r31, r3
		b         loc_8002B5F4
loc_8002B5BC:
		mr        r3, r20
		mr        r5, r20
		li        r4, 0
		addi      r20, r20, 1
		b         loc_8002B5D8
loc_8002B5D0:
		addi      r5, r5, 1
		addi      r4, r4, 1
loc_8002B5D8:
		lbz       r0, 0(r5)
		extsb.    r0, r0
		bne       loc_8002B5D0
		stbx      r6, r3, r4
		addi      r0, r4, 1
		addi      r31, r31, 1
		stbx      r16, r3, r0
loc_8002B5F4:
		lbz       r6, 0(r21)
		addi      r21, r21, 1
		extsb.    r0, r6
		bne       loc_8002B1A4
		addi      r11, r1, 0x50+pre_back_chain
		mr        r3, r31
		bl        _restgpr_16
		lwz       r0, 0x50+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x50
		blr

.data
.align 4
_1802:	.long loc_8002B2FC      
		.long def_8002B2C8      
		.long def_8002B2C8
		.long def_8002B2C8
		.long def_8002B2C8
		.long def_8002B2C8
		.long def_8002B2C8
		.long def_8002B2C8
		.long def_8002B2C8
		.long def_8002B2C8
		.long def_8002B2C8
		.long loc_8002B30C
		.long loc_8002B2CC
		.long def_8002B2C8
		.long def_8002B2C8
		.long def_8002B2C8
		.long def_8002B2C8
		.long def_8002B2C8
		.long def_8002B2C8
		.long def_8002B2C8
		.long def_8002B2C8
		.long def_8002B2C8
		.long def_8002B2C8
		.long loc_8002B2D8
		.long def_8002B2C8
		.long def_8002B2C8
		.long def_8002B2C8
		.long loc_8002B35C
		.long def_8002B2C8
		.long loc_8002B2E4
		.long def_8002B2C8
		.long def_8002B2C8
		.long loc_8002B2EC
		.align 3
