.text
#include <asm_setup.S>
.align 4

.global NWC24FOpen
NWC24FOpen:
.set back_chain, -0x20
.set var_C, -0xC
.set var_8, -8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		cmplwi    r5, 9
		stw       r0, 0x20+sender_lr(r1)
		li        r0, 0
		stw       r31, 0x20+var_4(r1)
		mr        r31, r5
		stw       r30, 0x20+var_8(r1)
		mr        r30, r4
		stw       r29, 0x20+var_C(r1)
		mr        r29, r3
		lis       r7, InstanceIdGen@h
		ori       r7, r7, InstanceIdGen@l
		lwz       r6, 0(r7)
		addi      r6, r6, 1
		oris      r4, r6, 0x8000
		stw       r4, 0(r7)
		stw       r4, 0(r3)
		stw       r0, 8(r3)
		stw       r5, 4(r3)
		beq       loc_8002B680
		cmplwi    r5, 0xA
		beq       loc_8002B680
		addi      r0, r5, -0x109
		cmplwi    r0, 1
		bgt       loc_8002B6A0
loc_8002B680:
		bl        NWC24IsMsgLibOpened
		cmpwi     r3, 0
		bne       loc_8002B6A0
		bl        NWC24IsMsgLibOpenedByTool
		cmpwi     r3, 0
		bne       loc_8002B6A0
		li        r3, -9
		b         loc_8002B6F8
loc_8002B6A0:
		cmplwi    r31, 9
		beq       loc_8002B6B0
		cmplwi    r31, 0x109
		bne       loc_8002B6CC
loc_8002B6B0:
		lis       r7, WrBufferMutex@h
		ori       r7, r7, WrBufferMutex@l
		lwz       r0, 0(r7)
		cmpwi     r0, 0
		beq       loc_8002B6C4
		li        r3, -0x16
		b         loc_8002B6F8
loc_8002B6C4:
		lwz       r0, 0(r29)
		stw       r0, 0(r7)
loc_8002B6CC:
		rlwinm.   r0, r31, 0,23,23
		beq       loc_8002B6E8
		mr        r3, r29
		mr        r4, r30
		mr        r5, r31
		bl        NWC24iFOpenVF
		b         loc_8002B6F8
loc_8002B6E8:
		mr        r3, r29
		mr        r4, r30
		mr        r5, r31
		bl        NWC24iFOpenNand
loc_8002B6F8:
		lwz       r0, 0x20+sender_lr(r1)
		lwz       r31, 0x20+var_4(r1)
		lwz       r30, 0x20+var_8(r1)
		lwz       r29, 0x20+var_C(r1)
		mtlr      r0
		addi      r1, r1, 0x20
		blr


NWC24iFOpenNand:
.set back_chain, -0x30
.set pre_back_chain,  0
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x30+sender_lr(r1)
		addi      r11, r1, 0x30+pre_back_chain
		bl        _savegpr_22
		cmplwi    r5, 0xA       
		mr        r29, r3
		mr        r30, r4
		mr        r31, r5
		bgt       def_8002B750  
		lis       r3, _3073_0@ha
		slwi      r0, r5, 2
		addi      r3, r3, _3073_0@l
		lwzx      r3, r3, r0
		mtctr     r3
		bctr		    
loc_8002B754:
		mr        r3, r30       
		li        r4, 0x3F
		li        r5, 0
		bl        NANDPrivateCreate
		cmpwi     r3, 0
		beq       loc_8002B77C
		cmpwi     r3, -6
		beq       loc_8002B77C
		li        r3, -0x15
		b         loc_8002B834
loc_8002B77C:
		li        r23, 2
		b         loc_8002B79C
loc_8002B784:
		li        r23, 1        
		b         loc_8002B79C
loc_8002B78C:
		li        r23, 3        
		b         loc_8002B79C
def_8002B750:
		li        r3, -3        
		b         loc_8002B834
loc_8002B79C:
		li        r22, 0
		li        r27, 0x3E8
		mullw     r28, r22, r27
		lis       r3, 0x1062
		lis       r26, -0x8000
		addi      r25, r3, 0x4DD3 
loc_8002B7B4:
		mr        r3, r30
		mr        r5, r23
		addi      r4, r29, 0xC
		bl        NANDPrivateOpen
		addi      r0, r3, 3
		mr        r24, r3
		cmplwi    r0, 1
		bgt       loc_8002B800
		lwz       r0, 0xF8(r26)
		srwi      r0, r0, 2
		mulhwu    r0, r25, r0
		srwi      r3, r0, 6
		mulhwu    r0, r3, r27
		mulli     r4, r3, 0x3E8
		add       r3, r0, r28
		bl        OSSleepTicks
		addi      r22, r22, 1
		cmplwi    r22, 3
		blt       loc_8002B7B4
loc_8002B800:
		cmpwi     r24, 0
		beq       loc_8002B830
		cmplwi    r31, 9
		bne       loc_8002B818
		li        r0, 0
		lis       r7, WrBufferMutex@h
		ori       r7, r7, WrBufferMutex@l
		stw       r0, 0(r7)
loc_8002B818:
		cmpwi     r24, -0xC
		bne       loc_8002B828
		li        r3, -0x14
		b         loc_8002B834
loc_8002B828:
		li        r3, -0x10
		b         loc_8002B834
loc_8002B830:
		li        r3, 0
loc_8002B834:
		addi      r11, r1, 0x30+pre_back_chain
		bl        _restgpr_22
		lwz       r0, 0x30+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x30
		blr


NWC24iFOpenVF:
.set back_chain, -0x20
.set var_C, -0xC
.set var_8, -8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		cmpwi     r5, 0x109
		stw       r0, 0x20+sender_lr(r1)
		stw       r31, 0x20+var_4(r1)
		stw       r30, 0x20+var_8(r1)
		mr        r30, r5
		stw       r29, 0x20+var_C(r1)
		mr        r29, r3
		beq       loc_8002B89C
		bge       loc_8002B890
		cmpwi     r5, 0x102
		beq       loc_8002B8A4
		bge       loc_8002B8AC
		cmpwi     r5, 0x101
		bge       loc_8002B89C
		b         loc_8002B8AC
loc_8002B890:
		cmpwi     r5, 0x10B
		bge       loc_8002B8AC
		b         loc_8002B8A4
loc_8002B89C:
		lis       r31, _3091_0@h
		ori       r31, r31, _3091_0@l
		b         loc_8002B8B4
loc_8002B8A4:
		lis       r31, _3092_0@h
		ori       r31, r31, _3092_0@l
		b         loc_8002B8B4
loc_8002B8AC:
		li        r3, -3
		b         loc_8002B958
loc_8002B8B4:
		mr        r3, r4
		mr        r4, r31
		li        r5, 0
		bl        VFOpenFile
		cmpwi     r3, 0
		stw       r3, 0x98(r29)
		bne       loc_8002B954
		bl        VFGetLastError
		cmplwi    r30, 0x109
		bne       loc_8002B8E4
		li        r0, 0
		lis       r7, WrBufferMutex@h
		ori       r7, r7, WrBufferMutex@l
		stw       r0, 0(r7)
loc_8002B8E4:
		lbz       r0, 0(r31)
		cmpwi     r0, 0x72
		bne       loc_8002B900
		cmpwi     r3, 2
		bne       loc_8002B900
		li        r3, -0x14
		b         loc_8002B958
loc_8002B900:
		cmpwi     r3, 5
		bne       loc_8002B94C
		lis       r3, _3093_0@h
		ori       r3, r3, _3093_0@l
		bl        VFGetLastDeviceError
		cmpwi     r3, -5
		beq       loc_8002B934
		bge       loc_8002B928
		cmpwi     r3, -0xF
		beq       loc_8002B934
		b         loc_8002B944
loc_8002B928:
		cmpwi     r3, -3
		bge       loc_8002B944
		b         loc_8002B93C
loc_8002B934:
		li        r3, -0x2E
		b         loc_8002B958
loc_8002B93C:
		li        r3, -0x26
		b         loc_8002B958
loc_8002B944:
		li        r3, -0x10
		b         loc_8002B958
loc_8002B94C:
		li        r3, -0x10
		b         loc_8002B958
loc_8002B954:
		li        r3, 0
loc_8002B958:
		lwz       r0, 0x20+sender_lr(r1)
		lwz       r31, 0x20+var_4(r1)
		lwz       r30, 0x20+var_8(r1)
		lwz       r29, 0x20+var_C(r1)
		mtlr      r0
		addi      r1, r1, 0x20
		blr


.global NWC24FClose
NWC24FClose:
.set back_chain, -0x10
.set var_8, -8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x10+sender_lr(r1)
		stw       r31, 0x10+var_4(r1)
		li        r31, 0
		stw       r30, 0x10+var_8(r1)
		mr        r30, r3
		lwz       r0, 4(r3)
		cmplwi    r0, 9
		beq       loc_8002B9A4
		cmplwi    r0, 0x109
		bne       loc_8002B9B8
loc_8002B9A4:
		mr        r3, r30
		bl        BufferedWriteFlush
		li        r0, 0
		mr        r31, r3
		lis       r7, WrBufferMutex@h
		ori       r7, r7, WrBufferMutex@l
		stw       r0, 0(r7)
loc_8002B9B8:
		lwz       r0, 4(r30)
		rlwinm.   r0, r0, 0,23,23
		beq       loc_8002BA30
		lwz       r3, 0x98(r30)
		bl        VFCloseFile
		cmpwi     r3, 0
		beq       loc_8002BA28
		cmpwi     r3, 5
		bne       loc_8002BA20
		lis       r3, _3093_0@h
		ori       r3, r3, _3093_0@l
		bl        VFGetLastDeviceError
		cmpwi     r3, -5
		beq       loc_8002BA08
		bge       loc_8002B9FC
		cmpwi     r3, -0xF
		beq       loc_8002BA08
		b         loc_8002BA18
loc_8002B9FC:
		cmpwi     r3, -3
		bge       loc_8002BA18
		b         loc_8002BA10
loc_8002BA08:
		li        r3, -0x2E
		b         loc_8002BA38
loc_8002BA10:
		li        r3, -0x26
		b         loc_8002BA38
loc_8002BA18:
		li        r3, -0x11
		b         loc_8002BA38
loc_8002BA20:
		li        r3, -0x11
		b         loc_8002BA38
loc_8002BA28:
		li        r3, 0
		b         loc_8002BA38
loc_8002BA30:
		mr        r3, r30
		bl        NWC24iFCloseNand
loc_8002BA38:
		cmpwi     r31, 0
		beq       loc_8002BA44
		mr        r3, r31
loc_8002BA44:
		lwz       r0, 0x10+sender_lr(r1)
		lwz       r31, 0x10+var_4(r1)
		lwz       r30, 0x10+var_8(r1)
		mtlr      r0
		addi      r1, r1, 0x10
		blr


NWC24iFCloseNand:
.set back_chain, -0x30
.set pre_back_chain,  0
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x30+sender_lr(r1)
		addi      r11, r1, 0x30+pre_back_chain
		bl        _savegpr_24
		li        r26, 0
		li        r30, 0x3E8
		mullw     r31, r26, r30
		lis       r4, 0x1062
		mr        r24, r3
		addi      r28, r4, 0x4DD3 
		li        r25, 0
		lis       r29, -0x8000
loc_8002BA90:
		addi      r3, r24, 0xC
		bl        NANDClose
		addi      r0, r3, 3
		mr        r27, r3
		cmplwi    r0, 1
		bgt       loc_8002BAD4
		lwz       r0, 0xF8(r29)
		srwi      r0, r0, 2
		mulhwu    r0, r28, r0
		srwi      r3, r0, 6
		mulhwu    r0, r3, r30
		mulli     r4, r3, 0x3E8
		add       r3, r0, r31
		bl        OSSleepTicks
		addi      r25, r25, 1
		cmplwi    r25, 3
		blt       loc_8002BA90
loc_8002BAD4:
		cmpwi     r27, -4
		bne       loc_8002BAE4
		li        r26, -0x26
		b         loc_8002BAF0
loc_8002BAE4:
		cmpwi     r27, 0
		beq       loc_8002BAF0
		li        r26, -0x11
loc_8002BAF0:
		addi      r11, r1, 0x30+pre_back_chain
		mr        r3, r26
		bl        _restgpr_24
		lwz       r0, 0x30+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x30
		blr


.global NWC24FSeek
NWC24FSeek:
.set back_chain, -0x30
.set pre_back_chain,  0
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x30+sender_lr(r1)
		addi      r11, r1, 0x30+pre_back_chain
		bl        _savegpr_23
		lwz       r0, 4(r3)
		mr        r29, r3
		mr        r30, r4
		mr        r31, r5
		cmplwi    r0, 0xA
		beq       loc_8002BB40
		cmplwi    r0, 0x10A
		bne       loc_8002BBF8
loc_8002BB40:
		lwz       r0, 4(r3)
		slwi      r5, r4, 27
		srwi      r6, r4, 31
		rlwinm.   r0, r0, 0,23,23
		subf      r5, r6, r5
		rotlwi    r0, r5, 5
		add       r0, r0, r6
		stw       r0, 8(r3)
		subf      r4, r0, r4
		beq       loc_8002BBD8
		lwz       r3, 0x98(r3)
		mr        r5, r31
		bl        VFSeekFile
		cmpwi     r3, 0
		beq       loc_8002BBD0
		cmpwi     r3, 5
		bne       loc_8002BBC8
		lis       r3, _3093_0@h
		ori       r3, r3, _3093_0@l
		bl        VFGetLastDeviceError
		cmpwi     r3, -5
		beq       loc_8002BBB0
		bge       loc_8002BBA4
		cmpwi     r3, -0xF
		beq       loc_8002BBB0
		b         loc_8002BBC0
loc_8002BBA4:
		cmpwi     r3, -3
		bge       loc_8002BBC0
		b         loc_8002BBB8
loc_8002BBB0:
		li        r3, -0x2E
		b         loc_8002BCE4
loc_8002BBB8:
		li        r3, -0x26
		b         loc_8002BCE4
loc_8002BBC0:
		li        r3, -0x15
		b         loc_8002BCE4
loc_8002BBC8:
		li        r3, -0x15
		b         loc_8002BCE4
loc_8002BBD0:
		li        r3, 0
		b         loc_8002BCE4
loc_8002BBD8:
		mr        r5, r31
		addi      r3, r3, 0xC
		bl        NANDSeek
		cmpwi     r3, 0
		li        r3, 0
		bge       loc_8002BCE4
		li        r3, -0x15
		b         loc_8002BCE4
loc_8002BBF8:
		rlwinm.   r0, r0, 0,23,23
		beq       loc_8002BC6C
		lwz       r3, 0x98(r3)
		bl        VFSeekFile
		cmpwi     r3, 0
		beq       loc_8002BC64
		cmpwi     r3, 5
		bne       loc_8002BC5C
		lis       r3, _3093_0@h
		ori       r3, r3, _3093_0@l
		bl        VFGetLastDeviceError
		cmpwi     r3, -5
		beq       loc_8002BC44
		bge       loc_8002BC38
		cmpwi     r3, -0xF
		beq       loc_8002BC44
		b         loc_8002BC54
loc_8002BC38:
		cmpwi     r3, -3
		bge       loc_8002BC54
		b         loc_8002BC4C
loc_8002BC44:
		li        r3, -0x2E
		b         loc_8002BCE4
loc_8002BC4C:
		li        r3, -0x26
		b         loc_8002BCE4
loc_8002BC54:
		li        r3, -0x15
		b         loc_8002BCE4
loc_8002BC5C:
		li        r3, -0x15
		b         loc_8002BCE4
loc_8002BC64:
		li        r3, 0
		b         loc_8002BCE4
loc_8002BC6C:
		li        r23, 0
		li        r27, 0x3E8
		mullw     r28, r23, r27
		lis       r3, 0x1062
		lis       r26, -0x8000
		addi      r25, r3, 0x4DD3 
loc_8002BC84:
		mr        r4, r30
		mr        r5, r31
		addi      r3, r29, 0xC
		bl        NANDSeek
		addi      r0, r3, 3
		mr        r24, r3
		cmplwi    r0, 1
		bgt       loc_8002BCD0
		lwz       r0, 0xF8(r26)
		srwi      r0, r0, 2
		mulhwu    r0, r25, r0
		srwi      r3, r0, 6
		mulhwu    r0, r3, r27
		mulli     r4, r3, 0x3E8
		add       r3, r0, r28
		bl        OSSleepTicks
		addi      r23, r23, 1
		cmplwi    r23, 3
		blt       loc_8002BC84
loc_8002BCD0:
		cmpwi     r24, 0
		bge       loc_8002BCE0
		li        r3, -0x15
		b         loc_8002BCE4
loc_8002BCE0:
		li        r3, 0
loc_8002BCE4:
		addi      r11, r1, 0x30+pre_back_chain
		bl        _restgpr_23
		lwz       r0, 0x30+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x30
		blr


.global NWC24FRead
NWC24FRead:
.set back_chain, -0x30
.set pre_back_chain,  0
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x30+sender_lr(r1)
		addi      r11, r1, 0x30+pre_back_chain
		bl        _savegpr_23
		lwz       r0, 4(r5)
		mr        r29, r3
		mr        r30, r4
		mr        r31, r5
		cmpwi     r0, 0xA
		beq       loc_8002BD64
		bge       loc_8002BD44
		cmpwi     r0, 1
		beq       loc_8002BD5C
		blt       loc_8002BD78
		cmpwi     r0, 9
		bge       loc_8002BD5C
		b         loc_8002BD78
loc_8002BD44:
		cmpwi     r0, 0x10A
		beq       loc_8002BD64
		bge       loc_8002BD78
		cmpwi     r0, 0x101
		beq       loc_8002BD5C
		b         loc_8002BD78
loc_8002BD5C:
		li        r3, -7
		b         loc_8002BEB4
loc_8002BD64:
		mr        r3, r29
		mr        r4, r30
		mr        r5, r31
		bl        BufferedRead
		b         loc_8002BEB4
loc_8002BD78:
		rlwinm.   r0, r0, 0,23,23
		beq       loc_8002BDF8
		lwz       r3, 0x98(r5)
		mr        r4, r29
		mr        r5, r30
		li        r6, 0
		bl        VFReadFile
		cmpwi     r3, 0
		beq       loc_8002BDF0
		cmpwi     r3, 5
		bne       loc_8002BDE8
		lis       r3, _3093_0@h
		ori       r3, r3, _3093_0@l
		bl        VFGetLastDeviceError
		cmpwi     r3, -5
		beq       loc_8002BDD0
		bge       loc_8002BDC4
		cmpwi     r3, -0xF
		beq       loc_8002BDD0
		b         loc_8002BDE0
loc_8002BDC4:
		cmpwi     r3, -3
		bge       loc_8002BDE0
		b         loc_8002BDD8
loc_8002BDD0:
		li        r3, -0x2E
		b         loc_8002BEB4
loc_8002BDD8:
		li        r3, -0x26
		b         loc_8002BEB4
loc_8002BDE0:
		li        r3, -0x12
		b         loc_8002BEB4
loc_8002BDE8:
		li        r3, -0x12
		b         loc_8002BEB4
loc_8002BDF0:
		li        r3, 0
		b         loc_8002BEB4
loc_8002BDF8:
		li        r23, 0
		li        r27, 0x3E8
		mullw     r28, r23, r27
		lis       r3, 0x1062
		lis       r26, -0x8000
		addi      r25, r3, 0x4DD3 
loc_8002BE10:
		mr        r4, r29
		mr        r5, r30
		addi      r3, r31, 0xC
		bl        NANDRead
		addi      r0, r3, 3
		mr        r24, r3
		cmplwi    r0, 1
		bgt       loc_8002BE5C
		lwz       r0, 0xF8(r26)
		srwi      r0, r0, 2
		mulhwu    r0, r25, r0
		srwi      r3, r0, 6
		mulhwu    r0, r3, r27
		mulli     r4, r3, 0x3E8
		add       r3, r0, r28
		bl        OSSleepTicks
		addi      r23, r23, 1
		cmplwi    r23, 3
		blt       loc_8002BE10
loc_8002BE5C:
		cmpwi     r24, -4
		bne       loc_8002BE6C
		li        r3, -0x26
		b         loc_8002BEB4
loc_8002BE6C:
		cmpwi     r24, 0
		bge       loc_8002BEB0
		cmpwi     r24, -5
		beq       loc_8002BE98
		bge       loc_8002BE8C
		cmpwi     r24, -0xF
		beq       loc_8002BE98
		b         loc_8002BEA8
loc_8002BE8C:
		cmpwi     r24, -3
		bge       loc_8002BEA8
		b         loc_8002BEA0
loc_8002BE98:
		li        r3, -0x2E
		b         loc_8002BEB4
loc_8002BEA0:
		li        r3, -0x26
		b         loc_8002BEB4
loc_8002BEA8:
		li        r3, -0x12
		b         loc_8002BEB4
loc_8002BEB0:
		li        r3, 0
loc_8002BEB4:
		addi      r11, r1, 0x30+pre_back_chain
		bl        _restgpr_23
		lwz       r0, 0x30+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x30
		blr


.global NWC24FWrite
NWC24FWrite:
.set back_chain, -0x30
.set pre_back_chain,  0
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x30+sender_lr(r1)
		addi      r11, r1, 0x30+pre_back_chain
		bl        _savegpr_23
		lwz       r0, 4(r5)
		mr        r29, r3
		mr        r30, r4
		mr        r31, r5
		cmpwi     r0, 0xA
		beq       loc_8002BF40
		bge       loc_8002BF14
		cmpwi     r0, 2
		beq       loc_8002BF40
		blt       loc_8002BF48
		cmpwi     r0, 9
		bge       loc_8002BF2C
		b         loc_8002BF48
loc_8002BF14:
		cmpwi     r0, 0x109
		beq       loc_8002BF2C
		bge       loc_8002BF48
		cmpwi     r0, 0x102
		beq       loc_8002BF40
		b         loc_8002BF48
loc_8002BF2C:
		mr        r3, r29
		mr        r4, r30
		mr        r5, r31
		bl        BufferedWrite
		b         loc_8002C08C
loc_8002BF40:
		li        r3, -7
		b         loc_8002C08C
loc_8002BF48:
		rlwinm.   r0, r0, 0,23,23
		beq       loc_8002BFC4
		lwz       r3, 0x98(r5)
		mr        r4, r29
		mr        r5, r30
		bl        VFWriteFile
		cmpwi     r3, 0
		beq       loc_8002BFBC
		cmpwi     r3, 5
		bne       loc_8002BFB4
		lis       r3, _3093_0@h
		ori       r3, r3, _3093_0@l
		bl        VFGetLastDeviceError
		cmpwi     r3, -5
		beq       loc_8002BF9C
		bge       loc_8002BF90
		cmpwi     r3, -0xF
		beq       loc_8002BF9C
		b         loc_8002BFAC
loc_8002BF90:
		cmpwi     r3, -3
		bge       loc_8002BFAC
		b         loc_8002BFA4
loc_8002BF9C:
		li        r3, -0x2E
		b         loc_8002C08C
loc_8002BFA4:
		li        r3, -0x26
		b         loc_8002C08C
loc_8002BFAC:
		li        r3, -0x13
		b         loc_8002C08C
loc_8002BFB4:
		li        r3, -0x13
		b         loc_8002C08C
loc_8002BFBC:
		li        r3, 0
		b         loc_8002C08C
loc_8002BFC4:
		li        r23, 0
		li        r27, 0x3E8
		mullw     r28, r23, r27
		lis       r3, 0x1062
		lis       r26, -0x8000
		addi      r25, r3, 0x4DD3 
loc_8002BFDC:
		mr        r4, r29
		mr        r5, r30
		addi      r3, r31, 0xC
		bl        NANDWrite
		addi      r0, r3, 3
		mr        r24, r3
		cmplwi    r0, 1
		bgt       loc_8002C028
		lwz       r0, 0xF8(r26)
		srwi      r0, r0, 2
		mulhwu    r0, r25, r0
		srwi      r3, r0, 6
		mulhwu    r0, r3, r27
		mulli     r4, r3, 0x3E8
		add       r3, r0, r28
		bl        OSSleepTicks
		addi      r23, r23, 1
		cmplwi    r23, 3
		blt       loc_8002BFDC
loc_8002C028:
		cmpwi     r24, -4
		bne       loc_8002C038
		li        r3, -0x26
		b         loc_8002C08C
loc_8002C038:
		cmpwi     r24, 0
		bge       loc_8002C07C
		cmpwi     r24, -5
		beq       loc_8002C064
		bge       loc_8002C058
		cmpwi     r24, -0xF
		beq       loc_8002C064
		b         loc_8002C074
loc_8002C058:
		cmpwi     r24, -3
		bge       loc_8002C074
		b         loc_8002C06C
loc_8002C064:
		li        r3, -0x2E
		b         loc_8002C08C
loc_8002C06C:
		li        r3, -0x26
		b         loc_8002C08C
loc_8002C074:
		li        r3, -0x13
		b         loc_8002C08C
loc_8002C07C:
		cmpw      r24, r30
		li        r3, 0
		beq       loc_8002C08C
		li        r3, -0x13
loc_8002C08C:
		addi      r11, r1, 0x30+pre_back_chain
		bl        _restgpr_23
		lwz       r0, 0x30+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x30
		blr


.global NWC24FGetLength
NWC24FGetLength:
.set back_chain, -0x10
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x10+sender_lr(r1)
		stw       r31, 0x10+var_4(r1)
		mr        r31, r4
		lwz       r0, 4(r3)
		rlwinm.   r0, r0, 0,23,23
		beq       loc_8002C134
		lwz       r3, 0x98(r3)
		bl        VFGetFileSizeByFd
		cmpwi     r3, 0
		bge       loc_8002C128
		cmpwi     r3, 5
		bne       loc_8002C120
		lis       r3, _3093_0@h
		ori       r3, r3, _3093_0@l
		bl        VFGetLastDeviceError
		cmpwi     r3, -5
		beq       loc_8002C108
		bge       loc_8002C0FC
		cmpwi     r3, -0xF
		beq       loc_8002C108
		b         loc_8002C118
loc_8002C0FC:
		cmpwi     r3, -3
		bge       loc_8002C118
		b         loc_8002C110
loc_8002C108:
		li        r3, -0x2E
		b         loc_8002C14C
loc_8002C110:
		li        r3, -0x26
		b         loc_8002C14C
loc_8002C118:
		li        r3, -0x15
		b         loc_8002C14C
loc_8002C120:
		li        r3, -0x15
		b         loc_8002C14C
loc_8002C128:
		stw       r3, 0(r31)
		li        r3, 0
		b         loc_8002C14C
loc_8002C134:
		addi      r3, r3, 0xC
		bl        NANDGetLength
		cmpwi     r3, 0
		li        r3, 0
		beq       loc_8002C14C
		li        r3, -0x15
loc_8002C14C:
		lwz       r0, 0x10+sender_lr(r1)
		lwz       r31, 0x10+var_4(r1)
		mtlr      r0
		addi      r1, r1, 0x10
		blr


.global NWC24FDeleteVF
NWC24FDeleteVF:
.set back_chain, -0x10
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x10+sender_lr(r1)
		bl        VFDeleteFile
		cmpwi     r3, 2
		bne       loc_8002C180
		li        r3, 0
		b         loc_8002C1E0
loc_8002C180:
		cmpwi     r3, 0
		beq       loc_8002C1DC
		cmpwi     r3, 5
		bne       loc_8002C1D4
		lis       r3, _3093_0@h
		ori       r3, r3, _3093_0@l
		bl        VFGetLastDeviceError
		cmpwi     r3, -5
		beq       loc_8002C1BC
		bge       loc_8002C1B0
		cmpwi     r3, -0xF
		beq       loc_8002C1BC
		b         loc_8002C1CC
loc_8002C1B0:
		cmpwi     r3, -3
		bge       loc_8002C1CC
		b         loc_8002C1C4
loc_8002C1BC:
		li        r3, -0x2E
		b         loc_8002C1E0
loc_8002C1C4:
		li        r3, -0x26
		b         loc_8002C1E0
loc_8002C1CC:
		li        r3, -0x15
		b         loc_8002C1E0
loc_8002C1D4:
		li        r3, -0x15
		b         loc_8002C1E0
loc_8002C1DC:
		li        r3, 0
loc_8002C1E0:
		lwz       r0, 0x10+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x10
		blr


.global NWC24MountVF
NWC24MountVF:
.set back_chain, -0x10
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x10+sender_lr(r1)
		stw       r31, 0x10+var_4(r1)
		mr        r31, r3
		bl        VFMountDriveNANDFlashEx
		addis     r0, r3, 0
		cmplwi    r0, 0xB001
		bne       loc_8002C21C
		li        r3, -0x14
		b         loc_8002C2E4
loc_8002C21C:
		cmpwi     r3, 0
		beq       loc_8002C278
		cmpwi     r3, 5
		bne       loc_8002C270
		lis       r3, _3093_0@h
		ori       r3, r3, _3093_0@l
		bl        VFGetLastDeviceError
		cmpwi     r3, -5
		beq       loc_8002C258
		bge       loc_8002C24C
		cmpwi     r3, -0xF
		beq       loc_8002C258
		b         loc_8002C268
loc_8002C24C:
		cmpwi     r3, -3
		bge       loc_8002C268
		b         loc_8002C260
loc_8002C258:
		li        r3, -0x2E
		b         loc_8002C2E4
loc_8002C260:
		li        r3, -0x26
		b         loc_8002C2E4
loc_8002C268:
		li        r3, -0x2B
		b         loc_8002C2E4
loc_8002C270:
		li        r3, -0x2B
		b         loc_8002C2E4
loc_8002C278:
		mr        r3, r31
		li        r4, 1
		bl        VFSetSyncMode
		cmpwi     r3, 0
		beq       loc_8002C2E0
		cmpwi     r3, 5
		bne       loc_8002C2D8
		lis       r3, _3093_0@h
		ori       r3, r3, _3093_0@l
		bl        VFGetLastDeviceError
		cmpwi     r3, -5
		beq       loc_8002C2C0
		bge       loc_8002C2B4
		cmpwi     r3, -0xF
		beq       loc_8002C2C0
		b         loc_8002C2D0
loc_8002C2B4:
		cmpwi     r3, -3
		bge       loc_8002C2D0
		b         loc_8002C2C8
loc_8002C2C0:
		li        r3, -0x2E
		b         loc_8002C2E4
loc_8002C2C8:
		li        r3, -0x26
		b         loc_8002C2E4
loc_8002C2D0:
		li        r3, -0x2B
		b         loc_8002C2E4
loc_8002C2D8:
		li        r3, -0x2B
		b         loc_8002C2E4
loc_8002C2E0:
		li        r3, 0
loc_8002C2E4:
		lwz       r0, 0x10+sender_lr(r1)
		lwz       r31, 0x10+var_4(r1)
		mtlr      r0
		addi      r1, r1, 0x10
		blr


.global NWC24UnmountVF
NWC24UnmountVF:
.set back_chain, -0x10
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x10+sender_lr(r1)
		bl        VFUnmountDrive
		cmpwi     r3, 0
		beq       loc_8002C364
		cmpwi     r3, 5
		bne       loc_8002C35C
		lis       r3, _3093_0@h
		ori       r3, r3, _3093_0@l
		bl        VFGetLastDeviceError
		cmpwi     r3, -5
		beq       loc_8002C344
		bge       loc_8002C338
		cmpwi     r3, -0xF
		beq       loc_8002C344
		b         loc_8002C354
loc_8002C338:
		cmpwi     r3, -3
		bge       loc_8002C354
		b         loc_8002C34C
loc_8002C344:
		li        r3, -0x2E
		b         loc_8002C368
loc_8002C34C:
		li        r3, -0x26
		b         loc_8002C368
loc_8002C354:
		li        r3, -0x2B
		b         loc_8002C368
loc_8002C35C:
		li        r3, -0x2B
		b         loc_8002C368
loc_8002C364:
		li        r3, 0
loc_8002C368:
		lwz       r0, 0x10+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x10
		blr


.global NWC24CheckSizeVF
NWC24CheckSizeVF:
.set back_chain, -0x10
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x10+sender_lr(r1)
		stw       r31, 0x10+var_4(r1)
		mr        r31, r4
		bl        VFGetDriveFreeSize
		cmpwi     r3, 0
		stw       r3, 0(r31)
		bge       loc_8002C3F4
		bl        VFGetLastError
		cmpwi     r3, 5
		bne       loc_8002C3EC
		lis       r3, _3093_0@h
		ori       r3, r3, _3093_0@l
		bl        VFGetLastDeviceError
		cmpwi     r3, -5
		beq       loc_8002C3D4
		bge       loc_8002C3C8
		cmpwi     r3, -0xF
		beq       loc_8002C3D4
		b         loc_8002C3E4
loc_8002C3C8:
		cmpwi     r3, -3
		bge       loc_8002C3E4
		b         loc_8002C3DC
loc_8002C3D4:
		li        r3, -0x2E
		b         loc_8002C3F8
loc_8002C3DC:
		li        r3, -0x26
		b         loc_8002C3F8
loc_8002C3E4:
		li        r3, -0x2B
		b         loc_8002C3F8
loc_8002C3EC:
		li        r3, -0x2B
		b         loc_8002C3F8
loc_8002C3F4:
		li        r3, 0
loc_8002C3F8:
		lwz       r0, 0x10+sender_lr(r1)
		lwz       r31, 0x10+var_4(r1)
		mtlr      r0
		addi      r1, r1, 0x10
		blr


BufferedWrite:
.set back_chain, -0x40
.set pre_back_chain,  0
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x40+sender_lr(r1)
		addi      r11, r1, 0x40+pre_back_chain
		bl        _savegpr_18
		lis       r7, NWC24WorkP@h
		ori       r7, r7, NWC24WorkP@l
		lwz       r6, 0(r7)
		mr        r27, r3
		lwz       r29, 8(r5)
		mr        r30, r4
		mr        r23, r5
		addi      r28, r6, 0xB00
		li        r25, 0
		lis       r18, -0x8000
		lis       r19, 0x1062
		li        r20, 0
		li        r21, 0x3E8
		b         loc_8002C578
loc_8002C450:
		subfic    r22, r29, 0x800
		cmplw     r30, r22
		bge       loc_8002C460
		mr        r22, r30
loc_8002C460:
		mr        r4, r27
		mr        r5, r22
		add       r3, r28, r29
		bl        memcpy
		add       r29, r29, r22
		subf      r30, r22, r30
		cmplwi    r29, 0x800
		add       r27, r27, r22
		blt       loc_8002C578
		lwz       r0, 4(r23)
		li        r29, 0
		rlwinm.   r0, r0, 0,23,23
		beq       loc_8002C500
		lwz       r3, 0x98(r23)
		mr        r4, r28
		li        r5, 0x800
		bl        VFWriteFile
		cmpwi     r3, 0
		beq       loc_8002C578
		cmpwi     r3, 5
		bne       loc_8002C4F8
		lis       r3, _3093_0@h
		ori       r3, r3, _3093_0@l
		bl        VFGetLastDeviceError
		cmpwi     r3, -5
		beq       loc_8002C4E0
		bge       loc_8002C4D4
		cmpwi     r3, -0xF
		beq       loc_8002C4E0
		b         loc_8002C4F0
loc_8002C4D4:
		cmpwi     r3, -3
		bge       loc_8002C4F0
		b         loc_8002C4E8
loc_8002C4E0:
		li        r25, -0x2E
		b         loc_8002C580
loc_8002C4E8:
		li        r25, -0x26
		b         loc_8002C580
loc_8002C4F0:
		li        r25, -0x13
		b         loc_8002C580
loc_8002C4F8:
		li        r25, -0x13
		b         loc_8002C580
loc_8002C500:
		mullw     r22, r20, r21
		addi      r31, r19, 0x4DD3 
		li        r24, 0
loc_8002C50C:
		mr        r4, r28
		addi      r3, r23, 0xC
		li        r5, 0x800
		bl        NANDWrite
		addi      r0, r3, 3
		mr        r26, r3
		cmplwi    r0, 1
		bgt       loc_8002C558
		lwz       r0, 0xF8(r18)
		srwi      r0, r0, 2
		mulhwu    r0, r31, r0
		srwi      r3, r0, 6
		mulhwu    r0, r3, r21
		mulli     r4, r3, 0x3E8
		add       r3, r0, r22
		bl        OSSleepTicks
		addi      r24, r24, 1
		cmplwi    r24, 3
		blt       loc_8002C50C
loc_8002C558:
		cmpwi     r26, -4
		bne       loc_8002C568
		li        r3, -0x26
		b         loc_8002C588
loc_8002C568:
		cmpwi     r26, 0x800
		beq       loc_8002C578
		li        r25, -0x13
		b         loc_8002C580
loc_8002C578:
		cmpwi     r30, 0
		bne       loc_8002C450
loc_8002C580:
		stw       r29, 8(r23)
		mr        r3, r25
loc_8002C588:
		addi      r11, r1, 0x40+pre_back_chain
		bl        _restgpr_18
		lwz       r0, 0x40+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x40
		blr


BufferedWriteFlush:
.set back_chain, -0x30
.set pre_back_chain,  0
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x30+sender_lr(r1)
		addi      r11, r1, 0x30+pre_back_chain
		bl        _savegpr_22
		lwz       r31, 8(r3)
		mr        r28, r3
		lis       r7, NWC24WorkP@h
		ori       r7, r7, NWC24WorkP@l
		lwz       r4, 0(r7)
		li        r29, 0
		cmpwi     r31, 0
		addi      r30, r4, 0xB00
		bne       loc_8002C5D8
		li        r3, 0
		b         loc_8002C6F8
loc_8002C5D8:
		add       r4, r30, r31
		li        r5, 0
		b         loc_8002C5F0
loc_8002C5E4:
		stb       r5, 0(r4)
		addi      r31, r31, 1
		addi      r4, r4, 1
loc_8002C5F0:
		clrlwi.   r0, r31, 27
		bne       loc_8002C5E4
		lwz       r0, 4(r3)
		rlwinm.   r0, r0, 0,23,23
		beq       loc_8002C674
		lwz       r3, 0x98(r3)
		mr        r4, r30
		mr        r5, r31
		bl        VFWriteFile
		cmpwi     r3, 0
		beq       loc_8002C66C
		cmpwi     r3, 5
		bne       loc_8002C668
		lis       r3, _3093_0@h
		ori       r3, r3, _3093_0@l
		bl        VFGetLastDeviceError
		cmpwi     r3, -5
		beq       loc_8002C650
		bge       loc_8002C644
		cmpwi     r3, -0xF
		beq       loc_8002C650
		b         loc_8002C660
loc_8002C644:
		cmpwi     r3, -3
		bge       loc_8002C660
		b         loc_8002C658
loc_8002C650:
		li        r29, -0x2E
		b         loc_8002C66C
loc_8002C658:
		li        r29, -0x26
		b         loc_8002C66C
loc_8002C660:
		li        r29, -0x13
		b         loc_8002C66C
loc_8002C668:
		li        r29, -0x13
loc_8002C66C:
		mr        r3, r29
		b         loc_8002C6F8
loc_8002C674:
		li        r22, 0
		li        r26, 0x3E8
		mullw     r27, r22, r26
		lis       r3, 0x1062
		lis       r25, -0x8000
		addi      r24, r3, 0x4DD3 
loc_8002C68C:
		mr        r4, r30
		mr        r5, r31
		addi      r3, r28, 0xC
		bl        NANDWrite
		addi      r0, r3, 3
		mr        r23, r3
		cmplwi    r0, 1
		bgt       loc_8002C6D8
		lwz       r0, 0xF8(r25)
		srwi      r0, r0, 2
		mulhwu    r0, r24, r0
		srwi      r3, r0, 6
		mulhwu    r0, r3, r26
		mulli     r4, r3, 0x3E8
		add       r3, r0, r27
		bl        OSSleepTicks
		addi      r22, r22, 1
		cmplwi    r22, 3
		blt       loc_8002C68C
loc_8002C6D8:
		cmpwi     r23, -4
		bne       loc_8002C6E8
		li        r3, -0x26
		b         loc_8002C6F8
loc_8002C6E8:
		cmplw     r23, r31
		beq       loc_8002C6F4
		li        r29, -0x13
loc_8002C6F4:
		mr        r3, r29
loc_8002C6F8:
		addi      r11, r1, 0x30+pre_back_chain
		bl        _restgpr_22
		lwz       r0, 0x30+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x30
		blr


BufferedRead:
.set back_chain, -0x60
.set var_58, -0x58
.set pre_back_chain,  0
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x60+sender_lr(r1)
		addi      r11, r1, 0x60+pre_back_chain
		bl        _savegpr_15
		lis       r7, RdBufferMutex@h
		ori       r7, r7, RdBufferMutex@l
		lwz       r0, 0(r7)
		mr        r15, r4
		lis       r7, NWC24WorkP@h
		ori       r7, r7, NWC24WorkP@l
		lwz       r4, 0(r7)
		mr        r19, r3
		cmpwi     r0, 0
		mr        r16, r5
		mr        r25, r15
		addi      r20, r4, 0x900
		li        r18, 0
		beq       loc_8002C754
		li        r3, -0x16
		b         loc_8002C8E4
loc_8002C754:
		lwz       r0, 0(r5)
		lis       r7, RdBufferMutex@h
		ori       r7, r7, RdBufferMutex@l
		stw       r0, 0(r7)
		lwz       r21, 8(r5)
		clrrwi.   r0, r21, 31
		beq       loc_8002C770
		li        r3, -0x28
		b         loc_8002C8E4
loc_8002C770:
		lis       r27, -0x8000
		lis       r28, 0x1062
		li        r29, 0
		li        r30, 0x3E8
		b         loc_8002C8BC
loc_8002C784:
		subfic    r23, r21, 0x200
		li        r24, 0x200
		cmplw     r25, r23
		bge       loc_8002C7A4
		add       r3, r25, r21
		mr        r23, r25
		addi      r0, r3, 0x1F
		clrrwi    r24, r0, 5
loc_8002C7A4:
		lwz       r0, 4(r16)
		rlwinm.   r0, r0, 0,23,23
		beq       loc_8002C828
		lwz       r3, 0x98(r16)
		mr        r4, r20
		mr        r5, r24
		addi      r6, r1, 0x60+var_58
		bl        VFReadFile
		cmpwi     r3, 0
		beq       loc_8002C820
		cmpwi     r3, 5
		bne       loc_8002C818
		lis       r3, _3093_0@h
		ori       r3, r3, _3093_0@l
		bl        VFGetLastDeviceError
		cmpwi     r3, -5
		beq       loc_8002C800
		bge       loc_8002C7F4
		cmpwi     r3, -0xF
		beq       loc_8002C800
		b         loc_8002C810
loc_8002C7F4:
		cmpwi     r3, -3
		bge       loc_8002C810
		b         loc_8002C808
loc_8002C800:
		li        r18, -0x2E
		b         loc_8002C8C4
loc_8002C808:
		li        r18, -0x26
		b         loc_8002C8C4
loc_8002C810:
		li        r18, -0x12
		b         loc_8002C8C4
loc_8002C818:
		li        r18, -0x12
		b         loc_8002C8C4
loc_8002C820:
		lwz       r22, 0x60+var_58(r1)
		b         loc_8002C890
loc_8002C828:
		mullw     r31, r29, r30
		addi      r26, r28, 0x4DD3 
		li        r17, 0
loc_8002C834:
		mr        r4, r20
		mr        r5, r24
		addi      r3, r16, 0xC
		bl        NANDRead
		addi      r0, r3, 3
		mr        r22, r3
		cmplwi    r0, 1
		bgt       loc_8002C880
		lwz       r0, 0xF8(r27)
		srwi      r0, r0, 2
		mulhwu    r0, r26, r0
		srwi      r3, r0, 6
		mulhwu    r0, r3, r30
		mulli     r4, r3, 0x3E8
		add       r3, r0, r31
		bl        OSSleepTicks
		addi      r17, r17, 1
		cmplwi    r17, 3
		blt       loc_8002C834
loc_8002C880:
		cmpwi     r22, -4
		bne       loc_8002C890
		li        r3, -0x26
		b         loc_8002C8E4
loc_8002C890:
		cmplw     r22, r24
		beq       loc_8002C8A0
		li        r18, -0x12
		b         loc_8002C8C4
loc_8002C8A0:
		mr        r3, r19
		mr        r5, r23
		add       r4, r20, r21
		bl        memcpy
		add       r19, r19, r23
		subf      r25, r23, r25
		li        r21, 0
loc_8002C8BC:
		cmpwi     r25, 0
		bne       loc_8002C784
loc_8002C8C4:
		lwz       r4, 8(r16)
		li        r0, 0
		mr        r3, r18
		add       r4, r4, r15
		clrlwi    r4, r4, 27
		oris      r4, r4, 0x8000
		stw       r4, 8(r16)
		lis       r7, RdBufferMutex@h
		ori       r7, r7, RdBufferMutex@l
		stw       r0, 0(r7)
loc_8002C8E4:
		addi      r11, r1, 0x60+pre_back_chain
		bl        _restgpr_15
		lwz       r0, 0x60+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x60
		blr


.global NWC24GetMyUserId
NWC24GetMyUserId:
.set back_chain, -0x20
.set var_18, -0x18
.set var_8, -8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x20+sender_lr(r1)
		stw       r31, 0x20+var_4(r1)
		li        r31, 0
		stw       r30, 0x20+var_8(r1)
		mr        r30, r3
		bl        NWC24IsMsgLibOpened
		cmpwi     r3, 0
		bne       loc_8002C930
		bl        NWC24IsMsgLibOpenedByTool
		cmpwi     r3, 0
		beq       loc_8002C948
loc_8002C930:
		lis       r9, config@h
		ori       r9, r9, config@l
		lwz       r3, 0(r9)
		lwz       r0, 8(r3)
		lwz       r3, 0xC(r3)
		stw       r3, 4(r30)
		stw       r0, 0(r30)
		b         loc_8002CA48
loc_8002C948:
		lis       r4, -0x8000
		lwz       r3, 0x31C0(r4)
		lwz       r4, 0x31C4(r4)
		or.       r0, r4, r3
		stw       r4, 4(r30)
		stw       r3, 0(r30)
		bne       loc_8002C96C
		li        r3, -5
		b         loc_8002C970
loc_8002C96C:
		bl        NWC24iCheckUserIdCRC
loc_8002C970:
		cmpwi     r3, 0
		bne       loc_8002C97C
		b         loc_8002CA4C
loc_8002C97C:
		bl        NWC24SuspendScheduler
		cmpwi     r3, 0
		bge       loc_8002C98C
		b         loc_8002CA4C
loc_8002C98C:
		li        r3, 1
		bl        NWC24BlockOpenMsgLib
		cmpwi     r3, 0
		bge       loc_8002C9A0
		b         loc_8002CA18
loc_8002C9A0:
		li        r0, 0
		cmpwi     r30, 0
		stw       r0, 0x20+var_18(r1)
		bne       loc_8002C9B8
		li        r31, -3
		b         loc_8002CA00
loc_8002C9B8:
		lis       r3, 0x6FC1
		lis       r4, 0x24
		addi      r5, r3, -1 
		addi      r0, r4, -0x790E 
		stw       r5, 4(r30)
		mr        r3, r30
		addi      r4, r1, 0x20+var_18
		stw       r0, 0(r30)
		bl        NWC24iRequestGenerateUserId
		lwz       r0, 0(r30)
		lis       r5, -0x8000
		lwz       r6, 4(r30)
		mr        r31, r3
		addi      r3, r5, 0x31C0 
		li        r4, 0x20
		stw       r6, 0x31C4(r5)
		stw       r0, 0x31C0(r5)
		bl        DCStoreRange
loc_8002CA00:
		li        r3, 0
		bl        NWC24BlockOpenMsgLib
		cmpwi     r31, 0
		blt       loc_8002CA14
		mr        r31, r3
loc_8002CA14:
		mr        r3, r31
loc_8002CA18:
		addi      r0, r3, 0x24
		mr        r31, r3
		cmplwi    r0, 1
		bgt       loc_8002CA2C
		li        r31, 0
loc_8002CA2C:
		bl        NWC24ResumeScheduler
		cmpwi     r3, 0
		bge       loc_8002CA48
		cmpwi     r31, 0
		beq       loc_8002CA44
		mr        r3, r31
loc_8002CA44:
		mr        r31, r3
loc_8002CA48:
		mr        r3, r31
loc_8002CA4C:
		lwz       r0, 0x20+sender_lr(r1)
		lwz       r31, 0x20+var_4(r1)
		lwz       r30, 0x20+var_8(r1)
		mtlr      r0
		addi      r1, r1, 0x20
		blr


.global NWC24iConfigOpen
NWC24iConfigOpen:
.set back_chain, -0x10
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x10+sender_lr(r1)
		li        r0, 0
		stw       r31, 0x10+var_4(r1)
		lis       r7, NWC24WorkP@h
		ori       r7, r7, NWC24WorkP@l
		lwz       r3, 0(r7)
		lis       r7, ConfigModified@h
		ori       r7, r7, ConfigModified@l
		stw       r0, 0(r7)
		addi      r0, r3, 0x1300
		lis       r7, config@h
		ori       r7, r7, config@l
		stw       r0, 0(r7)
		bl        NWC24iConfigReload
		cmpwi     r3, -0x14
		mr        r31, r3
		beq       loc_8002CAC4
		cmpwi     r3, 0
		bne       loc_8002CAC4
		lis       r7, config@h
		ori       r7, r7, config@l
		lwz       r6, 0(r7)
		lis       r5, -0x8000
		addi      r3, r5, 0x31C0 
		li        r4, 0x20
		lwz       r0, 8(r6)
		lwz       r6, 0xC(r6)
		stw       r6, 0x31C4(r5)
		stw       r0, 0x31C0(r5)
		bl        DCStoreRange
loc_8002CAC4:
		mr        r3, r31
		lwz       r31, 0x10+var_4(r1)
		lwz       r0, 0x10+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x10
		blr


.global NWC24iConfigReload
NWC24iConfigReload:
.set back_chain, -0xB0
.set var_A8, -0xA8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0xB0+sender_lr(r1)
		stw       r31, 0xB0+var_4(r1)
		lis       r7, NWC24WorkP@h
		ori       r7, r7, NWC24WorkP@l
		lwz       r0, 0(r7)
		cmpwi     r0, 0
		bne       loc_8002CB00
		li        r3, -9
		b         loc_8002CBBC
loc_8002CB00:
		lis       r7, ConfigFile@h
		ori       r7, r7, ConfigFile@l
		lwz       r4, 0(r7)
		addi      r3, r1, 0xB0+var_A8
		li        r5, 2
		bl        NWC24FOpen
		cmpwi     r3, 0
		bne       loc_8002CB40
		lis       r7, config@h
		ori       r7, r7, config@l
		lwz       r3, 0(r7)
		addi      r5, r1, 0xB0+var_A8
		li        r4, 0x400
		bl        NWC24FRead
		mr        r31, r3
		addi      r3, r1, 0xB0+var_A8
		bl        NWC24FClose
		cmpwi     r31, 0
		beq       loc_8002CB40
		mr        r3, r31
loc_8002CB40:
		cmpwi     r3, 0
		bne       loc_8002CB60
		bl        CheckConfig
		cmpwi     r3, 0
		bne       loc_8002CB60
		li        r0, 0
		lis       r7, ConfigModified@h
		ori       r7, r7, ConfigModified@l
		stw       r0, 0(r7)
		b         loc_8002CBBC
loc_8002CB60:
		lis       r7, CfgBakFile@h
		ori       r7, r7, CfgBakFile@l
		lwz       r4, 0(r7)
		addi      r3, r1, 0xB0+var_A8
		li        r5, 2
		bl        NWC24FOpen
		cmpwi     r3, 0
		bne       loc_8002CBA0
		lis       r7, config@h
		ori       r7, r7, config@l
		lwz       r3, 0(r7)
		addi      r5, r1, 0xB0+var_A8
		li        r4, 0x400
		bl        NWC24FRead
		mr        r31, r3
		addi      r3, r1, 0xB0+var_A8
		bl        NWC24FClose
		cmpwi     r31, 0
		beq       loc_8002CBA0
		mr        r3, r31
loc_8002CBA0:
		cmpwi     r3, 0
		bne       loc_8002CBBC
		bl        CheckConfig
		cmpwi     r3, 0
		bne       loc_8002CBBC
		li        r0, 1
		lis       r7, ConfigModified@h
		ori       r7, r7, ConfigModified@l
		stw       r0, 0(r7)
loc_8002CBBC:
		lwz       r0, 0xB0+sender_lr(r1)
		lwz       r31, 0xB0+var_4(r1)
		mtlr      r0
		addi      r1, r1, 0xB0
		blr


.global NWC24iConfigFlush
NWC24iConfigFlush:
.set back_chain, -0xB0
.set var_A8, -0xA8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0xB0+sender_lr(r1)
		stw       r31, 0xB0+var_4(r1)
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r0, 0(r9)
		cmpwi     r0, 0
		bne       loc_8002CBF4
		li        r3, -9
		b         loc_8002CD3C
loc_8002CBF4:
		lis       r9, ConfigModified@h
		ori       r9, r9, ConfigModified@l
		lwz       r0, 0(r9)
		cmpwi     r0, 0
		bne       loc_8002CC08
		li        r3, 0
		b         loc_8002CD3C
loc_8002CC08:
		lis       r9, config@h
		ori       r9, r9, config@l
		lwz       r8, 0(r9)
		li        r0, 0x1F
		li        r7, 0
		mr        r6, r8
		mtctr     r0
loc_8002CC1C:
		lwz       r3, 0(r6)
		lwz       r0, 4(r6)
		add       r7, r7, r3
		lwz       r3, 8(r6)
		add       r7, r7, r0
		lwz       r0, 0xC(r6)
		add       r7, r7, r3
		lwz       r3, 0x10(r6)
		add       r7, r7, r0
		lwz       r0, 0x14(r6)
		add       r7, r7, r3
		lwz       r3, 0x18(r6)
		add       r7, r7, r0
		lwz       r0, 0x1C(r6)
		add       r7, r7, r3
		addi      r6, r6, 0x20
		add       r7, r7, r0
		bdnz      loc_8002CC1C
		lwz       r0, 0(r6)
		addi      r3, r1, 0xB0+var_A8
		lwz       r4, 4(r6)
		li        r5, 1
		add       r7, r7, r0
		lwz       r0, 8(r6)
		add       r7, r7, r4
		lwz       r4, 0xC(r6)
		add       r7, r7, r0
		lwz       r0, 0x10(r6)
		add       r7, r7, r4
		lwz       r4, 0x14(r6)
		add       r7, r7, r0
		lwz       r0, 0x18(r6)
		add       r7, r7, r4
		add       r7, r7, r0
		stw       r7, 0x3FC(r8)
		lis       r9, ConfigFile@h
		ori       r9, r9, ConfigFile@l
		lwz       r4, 0(r9)
		bl        NWC24FOpen
		cmpwi     r3, 0
		bne       loc_8002CCE8
		lis       r9, config@h
		ori       r9, r9, config@l
		lwz       r3, 0(r9)
		addi      r5, r1, 0xB0+var_A8
		li        r4, 0x400
		bl        NWC24FWrite
		mr        r31, r3
		addi      r3, r1, 0xB0+var_A8
		bl        NWC24FClose
		cmpwi     r31, 0
		beq       loc_8002CCE0
		mr        r3, r31
loc_8002CCE0:
		li        r0, 0
		lis       r9, ConfigModified@h
		ori       r9, r9, ConfigModified@l
		stw       r0, 0(r9)
loc_8002CCE8:
		cmpwi     r3, 0
		beq       loc_8002CCF4
		b         loc_8002CD3C
loc_8002CCF4:
		lis       r9, CfgBakFile@h
		ori       r9, r9, CfgBakFile@l
		lwz       r4, 0(r9)
		addi      r3, r1, 0xB0+var_A8
		li        r5, 1
		bl        NWC24FOpen
		cmpwi     r3, 0
		bne       loc_8002CD3C
		lis       r9, config@h
		ori       r9, r9, config@l
		lwz       r3, 0(r9)
		addi      r5, r1, 0xB0+var_A8
		li        r4, 0x400
		bl        NWC24FWrite
		mr        r31, r3
		addi      r3, r1, 0xB0+var_A8
		bl        NWC24FClose
		cmpwi     r31, 0
		beq       loc_8002CD34
		mr        r3, r31
loc_8002CD34:
		li        r0, 0
		lis       r9, ConfigModified@h
		ori       r9, r9, ConfigModified@l
		stw       r0, 0(r9)
loc_8002CD3C:
		lwz       r0, 0xB0+sender_lr(r1)
		lwz       r31, 0xB0+var_4(r1)
		mtlr      r0
		addi      r1, r1, 0xB0
		blr


.global NWC24GetAccountDomain
NWC24GetAccountDomain:
		lis       r9, config@h
		ori       r9, r9, config@l
		lwz       r3, 0(r9)
		addi      r3, r3, 0x18
		blr


.global NWC24GetMBoxDir
NWC24GetMBoxDir:
.set back_chain, -0x10
.set var_8, -8
.set var_6, -6
.set var_5, -5
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x10+sender_lr(r1)
		addi      r3, r1, 0x10+var_8
		bl        __OSGetIOSRev
		lbz       r0, 0x10+var_8+1(r1)
		cmpwi     r0, 0
		bne       loc_8002CDB8
		lbz       r3, 0x10+var_6(r1)
		cmplwi    r3, 7
		bne       loc_8002CD94
		lbz       r0, 0x10+var_5(r1)
		cmpwi     r0, 0
		beq       loc_8002CD9C
loc_8002CD94:
		cmplwi    r3, 7
		bge       loc_8002CDB8
loc_8002CD9C:
		lis       r3, _2383@ha
		lis       r5, _2384@ha
		addi      r3, r3, _2383@l 
		li        r4, 0x2B7
		addi      r5, r5, _2384@l 
		crclr     4*cr1+eq
		bl        OSPanic
loc_8002CDB8:
		lwz       r0, 0x10+sender_lr(r1)
		lis       r9, MBoxDir@h
		ori       r9, r9, MBoxDir@l
		lwz       r3, 0(r9)
		mtlr      r0
		addi      r1, r1, 0x10
		blr


.global NWC24GetAppId
NWC24GetAppId:
.set back_chain, -0x10
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x10+sender_lr(r1)
		stw       r31, 0x10+var_4(r1)
		bl        OSGetAppGamename
		lwz       r31, 0(r3)
		cmpwi     r31, 0
		bne       loc_8002CE00
		bl        OSGetAppType
		clrlwi.   r0, r3, 24
		bne       loc_8002CE00
		bl        DVDGetCurrentDiskID
		lwz       r31, 0(r3)
loc_8002CE00:
		mr        r3, r31
		lwz       r31, 0x10+var_4(r1)
		lwz       r0, 0x10+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x10
		blr


.global NWC24GetGroupId
NWC24GetGroupId:
.set back_chain, -0x20
.set var_18, -0x18
.set var_14, -0x14
.set var_8, -8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x20+sender_lr(r1)
		stw       r31, 0x20+var_4(r1)
		stw       r30, 0x20+var_8(r1)
		lis       r9, VirtualGroupId@h
		ori       r9, r9, VirtualGroupId@l
		lhz       r31, 0(r9)
		bl        OSGetAppType
		clrlwi    r0, r3, 24
		cmpwi     r0, 0x80
		beq       loc_8002CE64
		bge       loc_8002CE50
		cmpwi     r0, 0x40
		beq       loc_8002CE5C
		b         loc_8002CEA0
loc_8002CE50:
		cmpwi     r0, 0x82
		bge       loc_8002CEA0
		b         loc_8002CE70
loc_8002CE5C:
		li        r31, 1
		b         loc_8002CEA0
loc_8002CE64:
		bl        DVDGetCurrentDiskID
		lhz       r31, 4(r3)
		b         loc_8002CEA0
loc_8002CE70:
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r3, 0(r9)
		addi      r30, r3, 0x800
		mr        r3, r30
		bl        NANDGetHomeDir
		cmpwi     r3, 0
		bne       loc_8002CEA0
		mr        r3, r30
		addi      r4, r1, 0x20+var_18
		bl        NANDGetStatus
		cmpwi     r3, 0
		bne       loc_8002CEA0
		lhz       r31, 0x20+var_14(r1)
loc_8002CEA0:
		mr        r3, r31
		lwz       r31, 0x20+var_4(r1)
		lwz       r30, 0x20+var_8(r1)
		lwz       r0, 0x20+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x20
		blr


CheckConfig:
		lis       r9, config@h
		ori       r9, r9, config@l
		lwz       r6, 0(r9)
		lwz       r3, 0(r6)
		addis     r0, r3, -0x5763
		cmplwi    r0, 0x4366
		beq       loc_8002CED8
		li        r3, -0xE
		blr
loc_8002CED8:
		li        r0, 0x1F
		mr        r4, r6
		li        r5, 0
		mtctr     r0
loc_8002CEE8:
		lwz       r3, 0(r4)
		lwz       r0, 4(r4)
		add       r5, r5, r3
		lwz       r3, 8(r4)
		add       r5, r5, r0
		lwz       r0, 0xC(r4)
		add       r5, r5, r3
		lwz       r3, 0x10(r4)
		add       r5, r5, r0
		lwz       r0, 0x14(r4)
		add       r5, r5, r3
		lwz       r3, 0x18(r4)
		add       r5, r5, r0
		lwz       r0, 0x1C(r4)
		add       r5, r5, r3
		addi      r4, r4, 0x20
		add       r5, r5, r0
		bdnz      loc_8002CEE8
		lwz       r3, 0(r4)
		lwz       r0, 4(r4)
		add       r5, r5, r3
		lwz       r3, 8(r4)
		add       r5, r5, r0
		lwz       r0, 0xC(r4)
		add       r5, r5, r3
		lwz       r3, 0x10(r4)
		add       r5, r5, r0
		lwz       r0, 0x14(r4)
		add       r5, r5, r3
		lwz       r3, 0x18(r4)
		add       r5, r5, r0
		lwz       r0, 0x3FC(r6)
		add       r5, r5, r3
		cmplw     r0, r5
		beq       loc_8002CF7C
		li        r3, -0xE
		blr
loc_8002CF7C:
		lwz       r0, 0x10(r6)
		cmplwi    r0, 0x20
		blt       loc_8002CF90
		li        r3, -0xE
		blr
loc_8002CF90:
		lwz       r0, 4(r6)
		li        r3, 0
		cmplwi    r0, 8
		beqlr
		li        r3, -0x1B
		blr


.global NWC24Data_Init
NWC24Data_Init:
		li        r0, 0
		stw       r0, 0(r3)
		stw       r0, 4(r3)
		blr


.global NWC24Data_SetDataP
NWC24Data_SetDataP:
		stw       r4, 0(r3)
		stw       r5, 4(r3)
		blr


.global NWC24Date_Init
NWC24Date_Init:
		li        r0, 0
		li        r5, 1
		li        r6, 0x7D0
		li        r4, 0xC
		sth       r6, 0(r3)
		stb       r5, 2(r3)
		stb       r5, 3(r3)
		stb       r4, 4(r3)
		stb       r0, 6(r3)
		stb       r0, 5(r3)
		stb       r0, 7(r3)
		blr


.global NWC24iConvIdToStr
NWC24iConvIdToStr:
.set back_chain, -0x20
.set pre_back_chain,  0
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x20+sender_lr(r1)
		addi      r11, r1, 0x20+pre_back_chain
		bl        _savegpr_26
		mr        r29, r3
		mr        r28, r4
		mr        r26, r5
		li        r27, 0xF
		li        r31, 0x30
loc_8002D01C:
		mr        r3, r29
		mr        r4, r28
		add       r30, r26, r27
		li        r6, 0xA
		li        r5, 0
		bl        __mod2u
		addc      r0, r4, r31
		mr        r3, r29
		stb       r0, 0(r30)
		mr        r4, r28
		li        r5, 0
		li        r6, 0xA
		bl        __div2u
		mr        r28, r4
		mr        r29, r3
		li        r6, 0xA
		li        r5, 0
		bl        __mod2u
		addc      r0, r4, r31
		mr        r3, r29
		stb       r0, -1(r30)
		mr        r4, r28
		li        r5, 0
		li        r6, 0xA
		bl        __div2u
		mr        r28, r4
		mr        r29, r3
		li        r6, 0xA
		li        r5, 0
		bl        __mod2u
		addc      r0, r4, r31
		mr        r3, r29
		stb       r0, -2(r30)
		mr        r4, r28
		li        r5, 0
		li        r6, 0xA
		bl        __div2u
		mr        r28, r4
		mr        r29, r3
		li        r6, 0xA
		li        r5, 0
		bl        __mod2u
		addc      r0, r4, r31
		mr        r3, r29
		stb       r0, -3(r30)
		mr        r4, r28
		li        r5, 0
		li        r6, 0xA
		bl        __div2u
		mr        r28, r4
		mr        r29, r3
		li        r6, 0xA
		li        r5, 0
		bl        __mod2u
		addc      r0, r4, r31
		mr        r3, r29
		stb       r0, -4(r30)
		mr        r4, r28
		li        r5, 0
		li        r6, 0xA
		bl        __div2u
		mr        r28, r4
		mr        r29, r3
		li        r6, 0xA
		li        r5, 0
		bl        __mod2u
		addc      r0, r4, r31
		mr        r3, r29
		stb       r0, -5(r30)
		mr        r4, r28
		li        r5, 0
		li        r6, 0xA
		bl        __div2u
		mr        r28, r4
		mr        r29, r3
		li        r6, 0xA
		li        r5, 0
		bl        __mod2u
		addc      r0, r4, r31
		mr        r3, r29
		stb       r0, -6(r30)
		mr        r4, r28
		li        r5, 0
		li        r6, 0xA
		bl        __div2u
		mr        r28, r4
		mr        r29, r3
		li        r6, 0xA
		li        r5, 0
		bl        __mod2u
		addc      r0, r4, r31
		mr        r3, r29
		stb       r0, -7(r30)
		mr        r4, r28
		li        r5, 0
		li        r6, 0xA
		bl        __div2u
		addic.    r27, r27, -8
		mr        r28, r4
		mr        r29, r3
		bge       loc_8002D01C
		li        r0, 0
		addi      r11, r1, 0x20+pre_back_chain
		stb       r0, 0x10(r26)
		bl        _restgpr_26
		lwz       r0, 0x20+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x20
		blr


.global NWC24iRegister
NWC24iRegister:
.set back_chain, -0x10
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x10+sender_lr(r1)
		lis       r9, Registered@h
		ori       r9, r9, Registered@l
		lwz       r0, 0(r9)
		cmpwi     r0, 0
		bne       loc_8002D1F8
		lis       r9, __NWC24Version@h
		ori       r9, r9, __NWC24Version@l
		lwz       r3, 0(r9)
		bl        OSRegisterVersion
		li        r0, 1
		lis       r9, Registered@h
		ori       r9, r9, Registered@l
		stw       r0, 0(r9)
loc_8002D1F8:
		lwz       r0, 0x10+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x10
		blr


.global NWC24OpenLib
NWC24OpenLib:
		lis       r9, Opened@h
		ori       r9, r9, Opened@l
		lwz       r0, 0(r9)
		cmpwi     r0, 2
		bne       loc_8002D21C
		li        r3, -0x1A
		blr
loc_8002D21C:
		li        r4, 1
		b         NWC24OpenLibInternal

		blr

NWC24OpenLibInternal:
.set back_chain, -0x20
.set var_C, -0xC
.set var_8, -8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x20+sender_lr(r1)
		li        r0, 0
		stw       r31, 0x20+var_4(r1)
		stw       r30, 0x20+var_8(r1)
		mr        r30, r3
		stw       r29, 0x20+var_C(r1)
		mr        r29, r4
		lis       r9, GlobalErrorCode@h
		ori       r9, r9, GlobalErrorCode@l
		stw       r0, 0(r9)
		bl        VFIsAvailable
		cmpwi     r3, 0
		bne       loc_8002D264
		li        r3, -1
		b         def_8002D3C8  
loc_8002D264:
		lis       r9, Opened@h
		ori       r9, r9, Opened@l
		lwz       r0, 0(r9)
		cmpwi     r0, 1
		bne       loc_8002D278
		li        r3, -0xA
		b         def_8002D3C8  
loc_8002D278:
		cmpwi     r0, 3
		bne       loc_8002D288
		li        r3, -0x1A
		b         def_8002D3C8  
loc_8002D288:
		cmpwi     r30, 0
		bne       loc_8002D298
		li        r3, -5
		b         def_8002D3C8  
loc_8002D298:
		clrlwi.   r0, r30, 27
		beq       loc_8002D2A8
		li        r3, -0x17
		b         def_8002D3C8  
loc_8002D2A8:
		bl        NWC24iTrySuspendForOpenLib
		cmpwi     r3, 0
		bne       loc_8002D3A8
		lis       r9, Registered@h
		ori       r9, r9, Registered@l
		lwz       r0, 0(r9)
		cmpwi     r0, 0
		bne       loc_8002D2D0
		lis       r9, __NWC24Version@h
		ori       r9, r9, __NWC24Version@l
		lwz       r3, 0(r9)
		bl        OSRegisterVersion
		li        r0, 1
		lis       r9, Registered@h
		ori       r9, r9, Registered@l
		stw       r0, 0(r9)
loc_8002D2D0:
		lis       r9, YouGotMail@h
		ori       r9, r9, YouGotMail@l
		lwz       r0, 0(r9)
		addi      r3, r30, 0x1900
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		stw       r30, 0(r9)
		clrrwi    r0, r0, 1
		lis       r9, YouGotMail@h
		ori       r9, r9, YouGotMail@l
		stw       r0, 0(r9)
		bl        NWC24InitBase64Table
		li        r30, 0
		li        r31, 0
		bl        NWC24iConfigOpen
		cmpwi     r3, 0
		beq       loc_8002D304
		mr        r31, r3
		ori       r30, r30, 4
loc_8002D304:
		bl        NWC24iOpenMBox
		cmpwi     r3, 0
		beq       loc_8002D318
		mr        r31, r3
		ori       r30, r30, 4
loc_8002D318:
		bl        NWC24iOpenFriendList
		cmpwi     r3, 0
		beq       loc_8002D32C
		mr        r31, r3
		ori       r30, r30, 4
loc_8002D32C:
		bl        NWC24iOpenSecretFriendList
		cmpwi     r3, 0
		beq       loc_8002D350
		cmpwi     r3, -0x14
		mr        r31, r3
		ori       r0, r30, 1
		beq       loc_8002D34C
		ori       r0, r30, 4
loc_8002D34C:
		mr        r30, r0
loc_8002D350:
		bl        NWC24iOpenDlTaskList
		cmpwi     r3, 0
		bge       loc_8002D374
		cmpwi     r3, -0x14
		mr        r31, r3
		ori       r0, r30, 2
		beq       loc_8002D370
		ori       r0, r30, 4
loc_8002D370:
		mr        r30, r0
loc_8002D374:
		cmplwi    r30, 3
		bne       loc_8002D380
		li        r31, -0x31
loc_8002D380:
		cmpwi     r30, 0
		beq       loc_8002D39C
		li        r0, 0
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		stw       r0, 0(r9)
		bl        NWC24iResumeForCloseLib
		mr        r3, r31
		b         loc_8002D3A8
loc_8002D39C:
		lis       r9, Opened@h
		ori       r9, r9, Opened@l
		stw       r29, 0(r9)
		li        r3, 0
		b         def_8002D3C8  
loc_8002D3A8:
		addi      r0, r3, 0x31
		cmplwi    r0, 0x30      
		bgt       def_8002D3C8  
		lis       r4, _2977@ha
		slwi      r0, r0, 2
		addi      r4, r4, _2977@l
		lwzx      r4, r4, r0
		mtctr     r4
		bctr		    
loc_8002D3CC:
		addis     r4, r3, -2    
		addi      r0, r4, 0x5638
		lis       r9, GlobalErrorCode@h
		ori       r9, r9, GlobalErrorCode@l
		stw       r0, 0(r9)
def_8002D3C8:
		lwz       r0, 0x20+sender_lr(r1) 
		lwz       r31, 0x20+var_4(r1)
		lwz       r30, 0x20+var_8(r1)
		lwz       r29, 0x20+var_C(r1)
		mtlr      r0
		addi      r1, r1, 0x20
		blr


.global NWC24CloseLib
NWC24CloseLib:
.set back_chain, -0x10
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x10+sender_lr(r1)
		lis       r9, Opened@h
		ori       r9, r9, Opened@l
		lwz       r0, 0(r9)
		cmpwi     r0, 1
		beq       loc_8002D414
		li        r3, -9
		b         loc_8002D450
loc_8002D414:
		bl        NWC24iConfigFlush
		cmpwi     r3, 0
		beq       loc_8002D424
		b         loc_8002D450
loc_8002D424:
		bl        NWC24iCloseDlTaskList
		cmpwi     r3, 0
		bge       loc_8002D434
		b         loc_8002D450
loc_8002D434:
		bl        NWC24iResumeForCloseLib
		cmpwi     r3, 0
		beq       loc_8002D444
		b         loc_8002D450
loc_8002D444:
		li        r0, 0
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		stw       r0, 0(r9)
		lis       r9, Opened@h
		ori       r9, r9, Opened@l
		stw       r0, 0(r9)
loc_8002D450:
		lwz       r0, 0x10+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x10
		blr


.global NWC24IsMsgLibOpened
NWC24IsMsgLibOpened:
		lis       r9, Opened@h
		ori       r9, r9, Opened@l
		lwz       r3, 0(r9)
		addi      r0, r3, -1
		cntlzw    r0, r0
		srwi      r3, r0, 5
		blr


.global NWC24IsMsgLibOpenedByTool
NWC24IsMsgLibOpenedByTool:
		lis       r9, Opened@h
		ori       r9, r9, Opened@l
		lwz       r3, 0(r9)
		addi      r0, r3, -2
		cntlzw    r0, r0
		srwi      r3, r0, 5
		blr


.global NWC24IsMsgLibOpenBlocking
NWC24IsMsgLibOpenBlocking:
		lis       r9, Opened@h
		ori       r9, r9, Opened@l
		lwz       r3, 0(r9)
		addi      r0, r3, -3
		cntlzw    r0, r0
		srwi      r3, r0, 5
		blr


.global NWC24BlockOpenMsgLib
NWC24BlockOpenMsgLib:
.set back_chain, -0x10
.set var_8, -8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x10+sender_lr(r1)
		stw       r31, 0x10+var_4(r1)
		li        r31, 0
		stw       r30, 0x10+var_8(r1)
		mr        r30, r3
		bl        __RAS_OSDisableInterrupts_begin
		cmpwi     r30, 0
		beq       loc_8002D4F4
		lis       r9, Opened@h
		ori       r9, r9, Opened@l
		lwz       r0, 0(r9)
		cmpwi     r0, 0
		bne       loc_8002D4DC
		li        r0, 3
		lis       r9, Opened@h
		ori       r9, r9, Opened@l
		stw       r0, 0(r9)
		b         loc_8002D51C
loc_8002D4DC:
		cmpwi     r0, 1
		bne       loc_8002D4EC
		li        r31, -0xA
		b         loc_8002D51C
loc_8002D4EC:
		li        r31, -0x1A
		b         loc_8002D51C
loc_8002D4F4:
		lis       r9, Opened@h
		ori       r9, r9, Opened@l
		lwz       r4, 0(r9)
		addi      r0, r4, -3
		cntlzw    r0, r0
		srwi.     r4, r0, 5
		beq       loc_8002D510
		li        r0, 0
		lis       r9, Opened@h
		ori       r9, r9, Opened@l
		stw       r0, 0(r9)
loc_8002D510:
		cmpwi     r4, 0
		bne       loc_8002D51C
		li        r31, -9
loc_8002D51C:
		bl        OSRestoreInterrupts
		mr        r3, r31
		lwz       r31, 0x10+var_4(r1)
		lwz       r30, 0x10+var_8(r1)
		lwz       r0, 0x10+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x10
		blr


.global NWC24iSetNewMsgArrived
NWC24iSetNewMsgArrived:
		lis       r9, YouGotMail@h
		ori       r9, r9, YouGotMail@l
		lwz       r0, 0(r9)
		or        r0, r0, r3
		li        r3, 0
		lis       r9, YouGotMail@h
		ori       r9, r9, YouGotMail@l
		stw       r0, 0(r9)
		blr


.global NWC24iSetErrorCode
NWC24iSetErrorCode:
		lis       r9, GlobalErrorCode@h
		ori       r9, r9, GlobalErrorCode@l
		stw       r3, 0(r9)
		blr


.global NWC24InitMsgObj
NWC24InitMsgObj:
.set back_chain, -0x20
.set pre_back_chain,  0
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x20+sender_lr(r1)
		addi      r11, r1, 0x20+pre_back_chain
		bl        _savegpr_26
		mr        r30, r4
		mr        r31, r3
		li        r4, 0
		li        r5, 0x100
		bl        Mail_memset
		li        r29, 0
		li        r0, 0x100
		stw       r29, 0(r31)
		stw       r0, 4(r31)
		bl        NWC24GetAppId
		stw       r3, 0xC(r31)
		stw       r29, 0x18(r31)
		stw       r29, 0x14(r31)
		bl        NWC24GetGroupId
		cmpwi     r30, 2
		sth       r3, 0xCA(r31)
		beq       loc_8002D5F4
		bge       loc_8002D5C4
		cmpwi     r30, 0
		beq       loc_8002D5D4
		bge       loc_8002D5E4
		b         loc_8002D624
loc_8002D5C4:
		cmpwi     r30, 4
		beq       loc_8002D614
		bge       loc_8002D624
		b         loc_8002D604
loc_8002D5D4:
		lwz       r0, 4(r31)
		ori       r0, r0, 0xD
		stw       r0, 4(r31)
		b         loc_8002D62C
loc_8002D5E4:
		lwz       r0, 4(r31)
		ori       r0, r0, 5
		stw       r0, 4(r31)
		b         loc_8002D62C
loc_8002D5F4:
		lwz       r0, 4(r31)
		ori       r0, r0, 9
		stw       r0, 4(r31)
		b         loc_8002D62C
loc_8002D604:
		lwz       r0, 4(r31)
		ori       r0, r0, 1
		stw       r0, 4(r31)
		b         loc_8002D62C
loc_8002D614:
		lwz       r0, 4(r31)
		ori       r0, r0, 2
		stw       r0, 4(r31)
		b         loc_8002D62C
loc_8002D624:
		li        r3, -3
		b         loc_8002D730
loc_8002D62C:
		lwz       r0, 4(r31)
		li        r29, 0
		stw       r29, 0x28(r31)
		addi      r3, r31, 0x20
		oris      r0, r0, 0x20
		stw       r0, 4(r31)
		stw       r29, 0x2C(r31)
		bl        NWC24GetMyUserId
		stb       r29, 0xC8(r31)
		mr        r28, r31
		addi      r27, r31, 0x88
		li        r26, 0
loc_8002D65C:
		cmpwi     r30, 4
		bne       loc_8002D670
		mr        r3, r27
		bl        NWC24Data_Init
		b         loc_8002D678
loc_8002D670:
		stw       r29, 0x8C(r28)
		stw       r29, 0x88(r28)
loc_8002D678:
		addi      r26, r26, 1
		addi      r28, r28, 8
		cmplwi    r26, 8
		addi      r27, r27, 8
		blt       loc_8002D65C
		addi      r3, r31, 0x40
		bl        NWC24Data_Init
		addi      r3, r31, 0x48
		bl        NWC24Data_Init
		li        r29, 0
		mr        r27, r31
		stw       r29, 0x60(r31)
		addi      r28, r31, 0x68
		li        r26, 0
		lis       r30, 1
		stw       r29, 0x64(r31)
		stb       r29, 0xC9(r31)
loc_8002D6BC:
		mr        r3, r28
		bl        NWC24Data_Init
		stw       r29, 0x78(r27)
		addi      r26, r26, 1
		cmplwi    r26, 2
		addi      r28, r28, 8
		stw       r30, 0x80(r27)
		addi      r27, r27, 4
		blt       loc_8002D6BC
		addi      r3, r31, 0x30
		bl        NWC24Data_Init
		addi      r3, r31, 0x38
		bl        NWC24Data_Init
		addi      r3, r31, 0x50
		bl        NWC24Data_Init
		addi      r3, r31, 0x58
		bl        NWC24Data_Init
		addi      r3, r31, 0xD0
		bl        NWC24Data_Init
		addi      r3, r31, 0xD8
		bl        NWC24Data_Init
		addi      r3, r31, 0xE0
		bl        NWC24Data_Init
		li        r4, 0
		lis       r0, -0x8000
		stw       r4, 0xCC(r31)
		li        r3, 0
		stw       r4, 0xEC(r31)
		stw       r0, 0xF0(r31)
loc_8002D730:
		addi      r11, r1, 0x20+pre_back_chain
		bl        _restgpr_26
		lwz       r0, 0x20+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x20
		blr


.global NWC24SetMsgToId
NWC24SetMsgToId:
		lwz       r4, 4(r3)
		rlwinm.   r0, r4, 0,23,23
		beq       loc_8002D75C
		rlwinm.   r0, r4, 0,22,22
		beq       loc_8002D764
loc_8002D75C:
		li        r3, -7
		blr
loc_8002D764:
		clrlwi.   r0, r4, 31
		bne       loc_8002D774
		li        r3, -4
		blr
loc_8002D774:
		lbz       r0, 0xC8(r3)
		cmplwi    r0, 8
		blt       loc_8002D788
		li        r3, -6
		blr
loc_8002D788:
		clrlslwi  r0, r0, 24,3
		add       r4, r3, r0
		stw       r6, 0x8C(r4)
		stw       r5, 0x88(r4)
		lbz       r4, 0xC8(r3)
		addi      r0, r4, 1
		stb       r0, 0xC8(r3)
		li        r3, 0
		blr


.global NWC24SetMsgSubject
NWC24SetMsgSubject:
.set back_chain, -0x10
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x10+sender_lr(r1)
		lwz       r6, 4(r3)
		rlwinm.   r0, r6, 0,23,23
		beq       loc_8002D7CC
		rlwinm.   r0, r6, 0,22,22
		beq       loc_8002D7D4
loc_8002D7CC:
		li        r3, -7
		b         loc_8002D80C
loc_8002D7D4:
		cmpwi     r4, 0
		beq       loc_8002D7E8
		lbz       r0, 0(r4)
		extsb.    r0, r0
		bne       loc_8002D7F0
loc_8002D7E8:
		li        r3, -5
		b         loc_8002D80C
loc_8002D7F0:
		cmplwi    r5, 0x3F4
		blt       loc_8002D800
		li        r3, -8
		b         loc_8002D80C
loc_8002D800:
		addi      r3, r3, 0x40
		bl        NWC24Data_SetDataP
		li        r3, 0
loc_8002D80C:
		lwz       r0, 0x10+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x10
		blr


.global NWC24SetMsgText
NWC24SetMsgText:
.set back_chain, -0x20
.set pre_back_chain,  0
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x20+sender_lr(r1)
		addi      r11, r1, 0x20+pre_back_chain
		bl        _savegpr_27
		lwz       r8, 4(r3)
		mr        r27, r3
		mr        r28, r4
		mr        r29, r5
		rlwinm.   r0, r8, 0,23,23
		mr        r30, r6
		mr        r31, r7
		beq       loc_8002D858
		rlwinm.   r0, r8, 0,22,22
		beq       loc_8002D860
loc_8002D858:
		li        r3, -7
		b         loc_8002D93C
loc_8002D860:
		mr        r3, r30
		bl        NWC24GetCharsetStr
		cmpwi     r3, 0
		bne       loc_8002D878
		li        r3, -3
		b         loc_8002D93C
loc_8002D878:
		mr        r3, r31
		bl        NWC24GetEncodingStr
		cmpwi     r3, 0
		bne       loc_8002D890
		li        r3, -3
		b         loc_8002D93C
loc_8002D890:
		cmpwi     r28, 0
		bne       loc_8002D8A8
		addi      r3, r27, 0x48
		bl        NWC24Data_Init
		li        r3, 0
		b         loc_8002D93C
loc_8002D8A8:
		cmpwi     r31, 1
		bne       loc_8002D8C4
		lwz       r0, 4(r27)
		rlwinm.   r0, r0, 0,30,30
		beq       loc_8002D8C4
		li        r3, -4
		b         loc_8002D93C
loc_8002D8C4:
		cmpwi     r31, 0
		bne       loc_8002D920
		mr        r4, r28
		add       r5, r28, r29
		li        r3, 0
		b         loc_8002D918
loc_8002D8DC:
		lbz       r0, 0(r4)
		cmpwi     r0, 0xD
		bne       loc_8002D900
		lbz       r0, 1(r4)
		cmpwi     r0, 0xA
		bne       loc_8002D900
		li        r3, 0
		addi      r4, r4, 1
		b         loc_8002D914
loc_8002D900:
		addi      r3, r3, 1
		cmplwi    r3, 0x3E6
		ble       loc_8002D914
		li        r3, -0x18
		b         loc_8002D93C
loc_8002D914:
		addi      r4, r4, 1
loc_8002D918:
		cmplw     r4, r5
		blt       loc_8002D8DC
loc_8002D920:
		mr        r4, r28
		mr        r5, r29
		addi      r3, r27, 0x48
		bl        NWC24Data_SetDataP
		stw       r30, 0x60(r27)
		li        r3, 0
		stw       r31, 0x64(r27)
loc_8002D93C:
		addi      r11, r1, 0x20+pre_back_chain
		bl        _restgpr_27
		lwz       r0, 0x20+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x20
		blr


.global NWC24SetMsgAttached
NWC24SetMsgAttached:
.set back_chain, -0x20
.set pre_back_chain,  0
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x20+sender_lr(r1)
		addi      r11, r1, 0x20+pre_back_chain
		bl        _savegpr_27
		lwz       r7, 4(r3)
		mr        r31, r3
		mr        r27, r4
		mr        r28, r5
		rlwinm.   r0, r7, 0,23,23
		mr        r29, r6
		li        r30, 0
		beq       loc_8002D990
		rlwinm.   r0, r7, 0,22,22
		beq       loc_8002D998
loc_8002D990:
		li        r3, -7
		b         loc_8002DBA4
loc_8002D998:
		cmpwi     r4, 0
		beq       loc_8002D9A8
		cmpwi     r5, 0
		bne       loc_8002D9B0
loc_8002D9A8:
		li        r3, -5
		b         loc_8002DBA4
loc_8002D9B0:
		lbz       r0, 0xC9(r3)
		cmplwi    r0, 2
		blt       loc_8002D9C4
		li        r3, -6
		b         loc_8002DBA4
loc_8002D9C4:
		mr        r3, r29
		bl        NWC24GetMIMETypeStr
		cmpwi     r3, 0
		bne       loc_8002D9DC
		li        r3, -3
		b         loc_8002DBA4
loc_8002D9DC:
		lwz       r0, 4(r31)
		rlwinm.   r0, r0, 0,30,30
		beq       loc_8002DA1C
		addis     r0, r29, -1
		cmplwi    r0, 0
		beq       loc_8002DA1C
		cmplwi    r0, 1
		beq       loc_8002DA1C
		addis     r0, r29, -2
		cmplwi    r0, 0
		beq       loc_8002DA1C
		addis     r0, r29, -3
		cmplwi    r0, 0
		beq       loc_8002DA1C
		li        r3, -4
		b         loc_8002DBA4
loc_8002DA1C:
		lis       r3, 3
		addi      r0, r3, 1 
		cmpw      r29, r0
		beq       loc_8002DA60
		bge       loc_8002DA44
		lis       r3, 2
		addi      r0, r3, 1 
		cmpw      r29, r0
		beq       loc_8002DA54
		b         loc_8002DA74
loc_8002DA44:
		addi      r0, r3, 3 
		cmpw      r29, r0
		bge       loc_8002DA74
		b         loc_8002DA6C
loc_8002DA54:
		lis       r3, 1
		addi      r0, r3, 0x4000 
		b         loc_8002DA7C
loc_8002DA60:
		lis       r3, 2
		addi      r0, r3, -0x2000 
		b         loc_8002DA7C
loc_8002DA6C:
		li        r0, 0x80
		b         loc_8002DA7C
loc_8002DA74:
		lis       r3, 2
		addi      r0, r3, 0x45B0 
loc_8002DA7C:
		cmplw     r28, r0
		ble       loc_8002DA8C
		li        r3, -8
		b         loc_8002DBA4
loc_8002DA8C:
		lbz       r5, 0xC9(r31)
		li        r6, 0
		cmpwi     r5, 0
		beq       loc_8002DB34
		cmplwi    r5, 8
		addi      r3, r5, -8
		ble       loc_8002DB0C
		addi      r0, r3, 7
		mr        r4, r31
		srwi      r0, r0, 3
		mtctr     r0
		cmplwi    r3, 0
		ble       loc_8002DB0C
loc_8002DAC0:
		lwz       r3, 0x78(r4)
		addi      r6, r6, 8
		lwz       r0, 0x7C(r4)
		add       r30, r30, r3
		lwz       r3, 0x80(r4)
		add       r30, r30, r0
		lwz       r0, 0x84(r4)
		add       r30, r30, r3
		lwz       r3, 0x88(r4)
		add       r30, r30, r0
		lwz       r0, 0x8C(r4)
		add       r30, r30, r3
		lwz       r3, 0x90(r4)
		add       r30, r30, r0
		lwz       r0, 0x94(r4)
		add       r30, r30, r3
		addi      r4, r4, 0x20
		add       r30, r30, r0
		bdnz      loc_8002DAC0
loc_8002DB0C:
		slwi      r3, r6, 2
		subf      r0, r6, r5
		add       r3, r31, r3
		mtctr     r0
		cmplw     r6, r5
		bge       loc_8002DB34
loc_8002DB24:
		lwz       r0, 0x78(r3)
		addi      r3, r3, 4
		add       r30, r30, r0
		bdnz      loc_8002DB24
loc_8002DB34:
		lis       r3, 2
		add       r30, r30, r28
		addi      r0, r3, 0x45B0 
		cmplw     r30, r0
		blt       loc_8002DB50
		li        r3, -8
		b         loc_8002DBA4
loc_8002DB50:
		clrlslwi  r0, r5, 24,3
		mr        r4, r27
		add       r3, r31, r0
		mr        r5, r28
		addi      r3, r3, 0x68
		bl        NWC24Data_SetDataP
		lbz       r0, 0xC9(r31)
		li        r3, 0
		slwi      r0, r0, 2
		add       r4, r31, r0
		stw       r28, 0x78(r4)
		lbz       r0, 0xC9(r31)
		slwi      r0, r0, 2
		add       r4, r31, r0
		stw       r29, 0x80(r4)
		lbz       r4, 0xC9(r31)
		lwz       r0, 4(r31)
		addi      r4, r4, 1
		oris      r0, r0, 1
		stb       r4, 0xC9(r31)
		stw       r0, 4(r31)
loc_8002DBA4:
		addi      r11, r1, 0x20+pre_back_chain
		bl        _restgpr_27
		lwz       r0, 0x20+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x20
		blr


.global NWC24SetMsgAltName
NWC24SetMsgAltName:
.set back_chain, -0x10
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x10+sender_lr(r1)
		lwz       r6, 4(r3)
		rlwinm.   r0, r6, 0,23,23
		beq       loc_8002DBDC
		rlwinm.   r0, r6, 0,22,22
		beq       loc_8002DBE4
loc_8002DBDC:
		li        r3, -7
		b         loc_8002DC30
loc_8002DBE4:
		lwz       r0, 0xE4(r3)
		cmpwi     r0, 0
		beq       loc_8002DBF8
		li        r3, -6
		b         loc_8002DC30
loc_8002DBF8:
		cmplwi    r5, 0x23
		ble       loc_8002DC08
		li        r3, -3
		b         loc_8002DC30
loc_8002DC08:
		cmpwi     r4, 0
		beq       loc_8002DC18
		cmpwi     r5, 0
		bne       loc_8002DC20
loc_8002DC18:
		li        r3, -5
		b         loc_8002DC30
loc_8002DC20:
		slwi      r5, r5, 1
		addi      r3, r3, 0xE0
		bl        NWC24Data_SetDataP
		li        r3, 0
loc_8002DC30:
		lwz       r0, 0x10+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x10
		blr


.global NWC24SetMsgDesignatedTime
NWC24SetMsgDesignatedTime:
.set back_chain, -0x20
.set var_18, -0x18
.set var_8, -8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		cmpwi     r4, 0
		stw       r0, 0x20+sender_lr(r1)
		li        r0, 0
		stw       r31, 0x20+var_4(r1)
		mr        r31, r4
		stw       r30, 0x20+var_8(r1)
		mr        r30, r3
		stw       r0, 0x20+var_18(r1)
		ble       loc_8002DC74
		cmpwi     r4, 0x3840
		ble       loc_8002DC7C
loc_8002DC74:
		li        r3, -3
		b         loc_8002DCC4
loc_8002DC7C:
		addi      r3, r1, 0x20+var_18
		bl        NWC24iGetUniversalTimeMinute
		cmpwi     r3, 0
		bge       loc_8002DC90
		b         loc_8002DCC4
loc_8002DC90:
		lwz       r4, 4(r30)
		lwz       r3, 0x20+var_18(r1)
		rlwinm.   r0, r4, 0,23,23
		add       r3, r3, r31
		beq       loc_8002DCAC
		rlwinm.   r0, r4, 0,22,22
		beq       loc_8002DCB4
loc_8002DCAC:
		li        r3, -7
		b         loc_8002DCC4
loc_8002DCB4:
		oris      r0, r4, 0x100
		stw       r3, 0x2C(r30)
		li        r3, 0
		stw       r0, 4(r30)
loc_8002DCC4:
		lwz       r0, 0x20+sender_lr(r1)
		lwz       r31, 0x20+var_4(r1)
		lwz       r30, 0x20+var_8(r1)
		mtlr      r0
		addi      r1, r1, 0x20
		blr


.global NWC24iOpenMBox
NWC24iOpenMBox:
.set back_chain, -0x150
.set var_148, -0x148
.set var_144, -0x144
.set var_A8, -0xA8
.set var_8, -8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		li        r4, 0
		li        r5, 0x80
		stw       r0, 0x150+sender_lr(r1)
		stw       r31, 0x150+var_4(r1)
		stw       r30, 0x150+var_8(r1)
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r3, 0(r9)
		addi      r30, r3, 0x800
		addi      r3, r3, 0x1700
		bl        Mail_memset
		addi      r4, r1, 0x150+var_148
		li        r3, 0
		bl        GetCachedMBCHeader
		cmpwi     r3, 0
		beq       loc_8002DD20
		b         loc_8002DE58
loc_8002DD20:
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r3, 0(r9)
		li        r4, 0
		li        r5, 0x80
		addi      r3, r3, 0x1780
		bl        Mail_memset
		addi      r4, r1, 0x150+var_148
		li        r3, 1
		bl        GetCachedMBCHeader
		cmpwi     r3, 0
		beq       loc_8002DD4C
		b         loc_8002DE58
loc_8002DD4C:
		bl        NWC24GetMBoxDir
		mr        r31, r3
		li        r4, 0x40
		bl        STD_strnlen
		addi      r0, r3, 0xE
		cmpwi     r0, 0x100
		ble       loc_8002DD70
		li        r3, -0xB
		b         loc_8002DD90
loc_8002DD70:
		lis       r6, _3738@ha
		mr        r3, r30
		mr        r5, r31
		lis       r4, _3643@h
		ori       r4, r4, _3643@l

		addi      r6, r6, _3738@l 
		crclr     4*cr1+eq
		bl        Mail_sprintf
		li        r3, 0
loc_8002DD90:
		cmpwi     r3, 0
		beq       loc_8002DD9C
		b         loc_8002DE58
loc_8002DD9C:
		mr        r4, r30
		addi      r3, r1, 0x150+var_A8
		li        r5, 2
		bl        NWC24FOpen
		cmpwi     r3, 0
		bne       loc_8002DDBC
		addi      r3, r1, 0x150+var_A8
		bl        NWC24FClose
loc_8002DDBC:
		cmpwi     r3, 0
		beq       loc_8002DDC8
		b         loc_8002DE58
loc_8002DDC8:
		bl        NWC24GetMBoxDir
		mr        r31, r3
		li        r4, 0x40
		bl        STD_strnlen
		addi      r0, r3, 0xE
		cmpwi     r0, 0x100
		ble       loc_8002DDEC
		li        r3, -0xB
		b         loc_8002DE0C
loc_8002DDEC:
		lis       r6, _3739@ha
		mr        r3, r30
		mr        r5, r31
		lis       r4, _3643@h
		ori       r4, r4, _3643@l

		addi      r6, r6, _3739@l 
		crclr     4*cr1+eq
		bl        Mail_sprintf
		li        r3, 0
loc_8002DE0C:
		cmpwi     r3, 0
		beq       loc_8002DE18
		b         loc_8002DE58
loc_8002DE18:
		mr        r4, r30
		addi      r3, r1, 0x150+var_144
		li        r5, 2
		bl        NWC24FOpen
		cmpwi     r3, 0
		bne       loc_8002DE38
		addi      r3, r1, 0x150+var_144
		bl        NWC24FClose
loc_8002DE38:
		cmpwi     r3, 0
		beq       loc_8002DE44
		b         loc_8002DE58
loc_8002DE44:
		li        r0, 0
		lis       r4, MountInfo@h
		ori       r4, r4, MountInfo@l

		lis       r9, MountInfo@h
		ori       r9, r9, MountInfo@l
		stw       r0, 0(r9)
		li        r3, 0
		lis       r9, dword_80083714@h
		ori       r9, r9, dword_80083714@l
		stw       r0, 0(r9)
loc_8002DE58:
		lwz       r0, 0x150+sender_lr(r1)
		lwz       r31, 0x150+var_4(r1)
		lwz       r30, 0x150+var_8(r1)
		mtlr      r0
		addi      r1, r1, 0x150
		blr


.global NWC24iMBoxOpenNewMsg
NWC24iMBoxOpenNewMsg:
.set back_chain, -0x30
.set var_28, -0x28
.set var_24, -0x24
.set var_20, -0x20
.set var_C, -0xC
.set var_8, -8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x30+sender_lr(r1)
		stw       r31, 0x30+var_4(r1)
		mr        r31, r3
		stw       r30, 0x30+var_8(r1)
		mr        r30, r5
		stw       r29, 0x30+var_C(r1)
		mr        r29, r4
		addi      r4, r1, 0x30+var_20
		bl        GetCachedMBCHeader
		cmpwi     r3, 0
		beq       loc_8002DEA8
		b         loc_8002DFF8
loc_8002DEA8:
		lwz       r5, 0x30+var_20(r1)
		lwz       r3, 0(r5)
		addis     r0, r3, -0x5763
		cmplwi    r0, 0x5466
		beq       loc_8002DEC4
		li        r3, -3
		b         loc_8002DEF8
loc_8002DEC4:
		lis       r3, 0xF
		lwz       r4, 0x18(r5)
		addi      r0, r3, 0x4240 
		cmplw     r4, r0
		ble       loc_8002DEE0
		li        r0, 1
		stw       r0, 0x18(r5)
loc_8002DEE0:
		lwz       r0, 0x18(r5)
		li        r3, 0
		stw       r0, 0(r30)
		lwz       r4, 0x18(r5)
		addi      r0, r4, 1
		stw       r0, 0x18(r5)
loc_8002DEF8:
		cmpwi     r3, 0
		beq       loc_8002DF04
		b         loc_8002DFF8
loc_8002DF04:
		mr        r3, r31
		bl        MountVFMBox
		cmpwi     r3, 0
		beq       loc_8002DF18
		b         loc_8002DFF8
loc_8002DF18:
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r3, 0(r9)
		cmpwi     r31, 1
		lwz       r5, 0(r30)
		addi      r30, r3, 0x800
		beq       loc_8002DF54
		bge       loc_8002DF6C
		cmpwi     r31, 0
		bge       loc_8002DF3C
		b         loc_8002DF6C
loc_8002DF3C:
		lis       r4, _3813@ha
		mr        r3, r30
		addi      r4, r4, _3813@l # "@24:
		crclr     4*cr1+eq
		bl        Mail_sprintf
		b         loc_8002DF74
loc_8002DF54:
		lis       r4, _3814_0@ha
		mr        r3, r30
		addi      r4, r4, _3814_0@l # "@24:
		crclr     4*cr1+eq
		bl        Mail_sprintf
		b         loc_8002DF74
loc_8002DF6C:
		li        r31, -3
		b         loc_8002DF78
loc_8002DF74:
		li        r31, 0
loc_8002DF78:
		cmpwi     r31, 0
		bne       loc_8002DF94
		mr        r3, r29
		mr        r4, r30
		li        r5, 0x109
		bl        NWC24FOpen
		mr        r31, r3
loc_8002DF94:
		cmpwi     r31, 0
		beq       loc_8002DFF4
		lis       r9, MountInfo@h
		ori       r9, r9, MountInfo@l
		lwz       r3, 0(r9)
		cmpwi     r3, 0
		beq       loc_8002DFF4
		addic.    r0, r3, -1
		lis       r9, MountInfo@h
		ori       r9, r9, MountInfo@l
		stw       r0, 0(r9)
		bgt       loc_8002DFF4
		lis       r3, MountInfo@h
		ori       r3, r3, MountInfo@l

		addi      r4, r1, 0x30+var_28
		lis       r9, dword_80083714@h
		ori       r9, r9, dword_80083714@l
		lwz       r3, 0(r9)
		bl        GetCachedMBCHeader
		cmpwi     r3, 0
		bne       loc_8002DFF4
		addi      r4, r1, 0x30+var_24
		lis       r3, _3815_0@h
		ori       r3, r3, _3815_0@l

		bl        NWC24CheckSizeVF
		cmpwi     r3, 0
		bne       loc_8002DFF4
		lwz       r0, 0x30+var_24(r1)
		lis       r3, _3815_0@h
		ori       r3, r3, _3815_0@l

		lwz       r4, 0x30+var_28(r1)
		stw       r0, 0x24(r4)
		bl        NWC24UnmountVF
loc_8002DFF4:
		mr        r3, r31
loc_8002DFF8:
		lwz       r0, 0x30+sender_lr(r1)
		lwz       r31, 0x30+var_4(r1)
		lwz       r30, 0x30+var_8(r1)
		lwz       r29, 0x30+var_C(r1)
		mtlr      r0
		addi      r1, r1, 0x30
		blr


.global NWC24iMBoxCloseMsg
NWC24iMBoxCloseMsg:
.set back_chain, -0x20
.set var_18, -0x18
.set var_14, -0x14
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x20+sender_lr(r1)
		stw       r31, 0x20+var_4(r1)
		bl        NWC24FClose
		lis       r9, MountInfo@h
		ori       r9, r9, MountInfo@l
		lwz       r4, 0(r9)
		mr        r31, r3
		cmpwi     r4, 0
		bne       loc_8002E040
		li        r3, 0
		b         loc_8002E09C
loc_8002E040:
		addic.    r0, r4, -1
		lis       r9, MountInfo@h
		ori       r9, r9, MountInfo@l
		stw       r0, 0(r9)
		ble       loc_8002E054
		li        r3, 0
		b         loc_8002E09C
loc_8002E054:
		lis       r3, MountInfo@h
		ori       r3, r3, MountInfo@l

		addi      r4, r1, 0x20+var_18
		lis       r9, dword_80083714@h
		ori       r9, r9, dword_80083714@l
		lwz       r3, 0(r9)
		bl        GetCachedMBCHeader
		cmpwi     r3, 0
		beq       loc_8002E070
		b         loc_8002E09C
loc_8002E070:
		addi      r4, r1, 0x20+var_14
		lis       r3, _3815_0@h
		ori       r3, r3, _3815_0@l

		bl        NWC24CheckSizeVF
		cmpwi     r3, 0
		beq       loc_8002E088
		b         loc_8002E09C
loc_8002E088:
		lwz       r0, 0x20+var_14(r1)
		lis       r3, _3815_0@h
		ori       r3, r3, _3815_0@l

		lwz       r4, 0x20+var_18(r1)
		stw       r0, 0x24(r4)
		bl        NWC24UnmountVF
loc_8002E09C:
		cmpwi     r31, 0
		beq       loc_8002E0B0
		cmpwi     r3, 0
		beq       loc_8002E0B0
		b         loc_8002E0B4
loc_8002E0B0:
		mr        r3, r31
loc_8002E0B4:
		lwz       r0, 0x20+sender_lr(r1)
		lwz       r31, 0x20+var_4(r1)
		mtlr      r0
		addi      r1, r1, 0x20
		blr


.global NWC24iMBoxCancelMsg
NWC24iMBoxCancelMsg:
.set back_chain, -0x30
.set var_28, -0x28
.set var_24, -0x24
.set var_20, -0x20
.set var_1C, -0x1C
.set var_10, -0x10
.set var_C, -0xC
.set var_8, -8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x30+sender_lr(r1)
		stw       r31, 0x30+var_4(r1)
		mr        r31, r5
		stw       r30, 0x30+var_8(r1)
		stw       r29, 0x30+var_C(r1)
		stw       r28, 0x30+var_10(r1)
		mr        r28, r4
		bl        NWC24FClose
		mr        r29, r3
		mr        r3, r28
		bl        MountVFMBox
		cmpwi     r3, 0
		beq       loc_8002E10C
		mr        r31, r3
		b         loc_8002E208
loc_8002E10C:
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r3, 0(r9)
		cmpwi     r28, 1
		addi      r30, r3, 0x800
		beq       loc_8002E148
		bge       loc_8002E164
		cmpwi     r28, 0
		bge       loc_8002E12C
		b         loc_8002E164
loc_8002E12C:
		lis       r4, _3813@ha
		mr        r3, r30
		mr        r5, r31
		addi      r4, r4, _3813@l # "@24:
		crclr     4*cr1+eq
		bl        Mail_sprintf
		b         loc_8002E16C
loc_8002E148:
		lis       r4, _3814_0@ha
		mr        r3, r30
		mr        r5, r31
		addi      r4, r4, _3814_0@l # "@24:
		crclr     4*cr1+eq
		bl        Mail_sprintf
		b         loc_8002E16C
loc_8002E164:
		li        r31, -3
		b         loc_8002E170
loc_8002E16C:
		li        r31, 0
loc_8002E170:
		cmpwi     r31, 0
		beq       loc_8002E17C
		b         loc_8002E208
loc_8002E17C:
		mr        r3, r30
		bl        NWC24FDeleteVF
		lis       r9, MountInfo@h
		ori       r9, r9, MountInfo@l
		lwz       r4, 0(r9)
		mr        r30, r3
		cmpwi     r4, 0
		bne       loc_8002E19C
		li        r3, 0
		b         loc_8002E1F8
loc_8002E19C:
		addic.    r0, r4, -1
		lis       r9, MountInfo@h
		ori       r9, r9, MountInfo@l
		stw       r0, 0(r9)
		ble       loc_8002E1B0
		li        r3, 0
		b         loc_8002E1F8
loc_8002E1B0:
		lis       r3, MountInfo@h
		ori       r3, r3, MountInfo@l

		addi      r4, r1, 0x30+var_1C
		lis       r9, dword_80083714@h
		ori       r9, r9, dword_80083714@l
		lwz       r3, 0(r9)
		bl        GetCachedMBCHeader
		cmpwi     r3, 0
		beq       loc_8002E1CC
		b         loc_8002E1F8
loc_8002E1CC:
		addi      r4, r1, 0x30+var_20
		lis       r3, _3815_0@h
		ori       r3, r3, _3815_0@l

		bl        NWC24CheckSizeVF
		cmpwi     r3, 0
		beq       loc_8002E1E4
		b         loc_8002E1F8
loc_8002E1E4:
		lwz       r0, 0x30+var_20(r1)
		lis       r3, _3815_0@h
		ori       r3, r3, _3815_0@l

		lwz       r4, 0x30+var_1C(r1)
		stw       r0, 0x24(r4)
		bl        NWC24UnmountVF
loc_8002E1F8:
		cmpwi     r30, 0
		beq       loc_8002E204
		mr        r3, r30
loc_8002E204:
		mr        r31, r3
loc_8002E208:
		li        r0, 1
		lis       r9, MountInfo@h
		ori       r9, r9, MountInfo@l
		stw       r0, 0(r9)
		b         loc_8002E218
		b         loc_8002E278
loc_8002E218:
		li        r0, 0
		cmpwi     r0, 0
		lis       r9, MountInfo@h
		ori       r9, r9, MountInfo@l
		stw       r0, 0(r9)
		ble       loc_8002E230
		li        r3, 0
		b         loc_8002E278
loc_8002E230:
		lis       r3, MountInfo@h
		ori       r3, r3, MountInfo@l

		addi      r4, r1, 0x30+var_24
		lis       r9, dword_80083714@h
		ori       r9, r9, dword_80083714@l
		lwz       r3, 0(r9)
		bl        GetCachedMBCHeader
		cmpwi     r3, 0
		beq       loc_8002E24C
		b         loc_8002E278
loc_8002E24C:
		addi      r4, r1, 0x30+var_28
		lis       r3, _3815_0@h
		ori       r3, r3, _3815_0@l

		bl        NWC24CheckSizeVF
		cmpwi     r3, 0
		beq       loc_8002E264
		b         loc_8002E278
loc_8002E264:
		lwz       r0, 0x30+var_28(r1)
		lis       r3, _3815_0@h
		ori       r3, r3, _3815_0@l

		lwz       r4, 0x30+var_24(r1)
		stw       r0, 0x24(r4)
		bl        NWC24UnmountVF
loc_8002E278:
		cmpwi     r29, 0
		beq       loc_8002E288
		mr        r3, r29
		b         loc_8002E2AC
loc_8002E288:
		cmpwi     r31, 0
		beq       loc_8002E298
		mr        r3, r31
		b         loc_8002E2AC
loc_8002E298:
		cmpwi     r3, 0
		li        r0, 0
		beq       loc_8002E2A8
		mr        r0, r3
loc_8002E2A8:
		mr        r3, r0
loc_8002E2AC:
		lwz       r0, 0x30+sender_lr(r1)
		lwz       r31, 0x30+var_4(r1)
		lwz       r30, 0x30+var_8(r1)
		lwz       r29, 0x30+var_C(r1)
		lwz       r28, 0x30+var_10(r1)
		mtlr      r0
		addi      r1, r1, 0x30
		blr


.global NWC24iMBoxAddMsgObj
NWC24iMBoxAddMsgObj:
.set back_chain, -0xC0
.set var_B8, -0xB8
.set var_B4, -0xB4
.set var_10, -0x10
.set var_C, -0xC
.set var_8, -8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0xC0+sender_lr(r1)
		stw       r31, 0xC0+var_4(r1)
		stw       r30, 0xC0+var_8(r1)
		stw       r29, 0xC0+var_C(r1)
		mr        r29, r4
		addi      r4, r1, 0xC0+var_B8
		stw       r28, 0xC0+var_10(r1)
		mr        r28, r3
		bl        GetCachedMBCHeader
		cmpwi     r3, 0
		beq       loc_8002E304
		b         loc_8002E478
loc_8002E304:
		lwz       r4, 0xC0+var_B8(r1)
		lwz       r3, 8(r4)
		lwz       r0, 0xC(r4)
		cmplw     r3, r0
		bne       loc_8002E320
		li        r3, -6
		b         loc_8002E478
loc_8002E320:
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r3, 0(r9)
		addi      r30, r3, 0x800
		bl        NWC24GetMBoxDir
		mr        r31, r3
		li        r4, 0x40
		bl        STD_strnlen
		addi      r0, r3, 0xE
		cmpwi     r0, 0x100
		ble       loc_8002E34C
		li        r3, -0xB
		b         loc_8002E3B0
loc_8002E34C:
		cmpwi     r28, 1
		beq       loc_8002E384
		bge       loc_8002E3A4
		cmpwi     r28, 0
		bge       loc_8002E364
		b         loc_8002E3A4
loc_8002E364:
		lis       r6, _3644@ha
		mr        r3, r30
		mr        r5, r31
		lis       r4, _3643@h
		ori       r4, r4, _3643@l

		addi      r6, r6, _3644@l 
		crclr     4*cr1+eq
		bl        Mail_sprintf
		b         loc_8002E3AC
loc_8002E384:
		lis       r6, _3645@ha
		mr        r3, r30
		mr        r5, r31
		lis       r4, _3643@h
		ori       r4, r4, _3643@l

		addi      r6, r6, _3645@l 
		crclr     4*cr1+eq
		bl        Mail_sprintf
		b         loc_8002E3AC
loc_8002E3A4:
		li        r3, -3
		b         loc_8002E3B0
loc_8002E3AC:
		li        r3, 0
loc_8002E3B0:
		cmpwi     r3, 0
		beq       loc_8002E3BC
		b         loc_8002E478
loc_8002E3BC:
		mr        r4, r30
		addi      r3, r1, 0xC0+var_B4
		li        r5, 4
		bl        NWC24FOpen
		cmpwi     r3, 0
		beq       loc_8002E3D8
		b         loc_8002E478
loc_8002E3D8:
		lwz       r3, 0xC0+var_B8(r1)
		mr        r4, r29
		addi      r5, r1, 0xC0+var_B4
		bl        AddMBCEntry
		cmpwi     r3, 0
		mr        r31, r3
		bne       loc_8002E418
		lwz       r3, 0xC0+var_B8(r1)
		mr        r4, r29
		mr        r6, r28
		addi      r5, r1, 0xC0+var_B4
		bl        DuplicationCheck
		cmpwi     r3, 0
		mr        r31, r3
		bne       loc_8002E464
		b         loc_8002E430
loc_8002E418:
		cmpwi     r3, -0xE
		bne       loc_8002E464
		lis       r4, 0x4252
		lwz       r3, 0xC0+var_B8(r1)
		addi      r0, r4, 0x4B4E 
		stw       r0, 0(r3)
loc_8002E430:
		lwz       r31, 0xC0+var_B8(r1)
		addi      r3, r1, 0xC0+var_B4
		li        r4, 0
		li        r5, 0
		bl        NWC24FSeek
		cmpwi     r3, 0
		beq       loc_8002E450
		b         loc_8002E460
loc_8002E450:
		mr        r3, r31
		addi      r5, r1, 0xC0+var_B4
		li        r4, 0x80
		bl        NWC24FWrite
loc_8002E460:
		mr        r31, r3
loc_8002E464:
		addi      r3, r1, 0xC0+var_B4
		bl        NWC24FClose
		cmpwi     r31, 0
		beq       loc_8002E478
		mr        r3, r31
loc_8002E478:
		lwz       r0, 0xC0+sender_lr(r1)
		lwz       r31, 0xC0+var_4(r1)
		lwz       r30, 0xC0+var_8(r1)
		lwz       r29, 0xC0+var_C(r1)
		lwz       r28, 0xC0+var_10(r1)
		mtlr      r0
		addi      r1, r1, 0xC0
		blr


.global NWC24iMBoxFlushHeader
NWC24iMBoxFlushHeader:
.set back_chain, -0xC0
.set var_B8, -0xB8
.set var_B4, -0xB4
.set var_C, -0xC
.set var_8, -8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0xC0+sender_lr(r1)
		addi      r4, r1, 0xC0+var_B8
		stw       r31, 0xC0+var_4(r1)
		stw       r30, 0xC0+var_8(r1)
		stw       r29, 0xC0+var_C(r1)
		mr        r29, r3
		bl        GetCachedMBCHeader
		cmpwi     r3, 0
		beq       loc_8002E4C8
		b         loc_8002E5CC
loc_8002E4C8:
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r3, 0(r9)
		addi      r30, r3, 0x800
		bl        NWC24GetMBoxDir
		mr        r31, r3
		li        r4, 0x40
		bl        STD_strnlen
		addi      r0, r3, 0xE
		cmpwi     r0, 0x100
		ble       loc_8002E4F4
		li        r3, -0xB
		b         loc_8002E558
loc_8002E4F4:
		cmpwi     r29, 1
		beq       loc_8002E52C
		bge       loc_8002E54C
		cmpwi     r29, 0
		bge       loc_8002E50C
		b         loc_8002E54C
loc_8002E50C:
		lis       r6, _3644@ha
		mr        r3, r30
		mr        r5, r31
		lis       r4, _3643@h
		ori       r4, r4, _3643@l

		addi      r6, r6, _3644@l 
		crclr     4*cr1+eq
		bl        Mail_sprintf
		b         loc_8002E554
loc_8002E52C:
		lis       r6, _3645@ha
		mr        r3, r30
		mr        r5, r31
		lis       r4, _3643@h
		ori       r4, r4, _3643@l

		addi      r6, r6, _3645@l 
		crclr     4*cr1+eq
		bl        Mail_sprintf
		b         loc_8002E554
loc_8002E54C:
		li        r3, -3
		b         loc_8002E558
loc_8002E554:
		li        r3, 0
loc_8002E558:
		cmpwi     r3, 0
		beq       loc_8002E564
		b         loc_8002E5CC
loc_8002E564:
		mr        r4, r30
		addi      r3, r1, 0xC0+var_B4
		li        r5, 4
		bl        NWC24FOpen
		cmpwi     r3, 0
		beq       loc_8002E580
		b         loc_8002E5CC
loc_8002E580:
		lwz       r31, 0xC0+var_B8(r1)
		addi      r3, r1, 0xC0+var_B4
		li        r4, 0
		li        r5, 0
		bl        NWC24FSeek
		cmpwi     r3, 0
		beq       loc_8002E5A4
		mr        r31, r3
		b         loc_8002E5B8
loc_8002E5A4:
		mr        r3, r31
		addi      r5, r1, 0xC0+var_B4
		li        r4, 0x80
		bl        NWC24FWrite
		mr        r31, r3
loc_8002E5B8:
		addi      r3, r1, 0xC0+var_B4
		bl        NWC24FClose
		cmpwi     r31, 0
		beq       loc_8002E5CC
		mr        r3, r31
loc_8002E5CC:
		lwz       r0, 0xC0+sender_lr(r1)
		lwz       r31, 0xC0+var_4(r1)
		lwz       r30, 0xC0+var_8(r1)
		lwz       r29, 0xC0+var_C(r1)
		mtlr      r0
		addi      r1, r1, 0xC0
		blr


.global NWC24iMBoxCheck
NWC24iMBoxCheck:
.set back_chain, -0x20
.set var_18, -0x18
.set var_14, -0x14
.set var_8, -8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		lis       r5, 3
		stw       r0, 0x20+sender_lr(r1)
		addi      r0, r5, 0x1C00 
		cmplw     r4, r0
		stw       r31, 0x20+var_4(r1)
		stw       r30, 0x20+var_8(r1)
		mr        r30, r3
		blt       loc_8002E618
		li        r3, -8
		b         loc_8002E6E0
loc_8002E618:
		addi      r31, r4, 0x4000
		addi      r4, r1, 0x20+var_14
		bl        GetCachedMBCHeader
		cmpwi     r3, 0
		beq       loc_8002E630
		b         loc_8002E6E0
loc_8002E630:
		cmpwi     r30, 0
		bne       loc_8002E668
		lwz       r4, 0x20+var_14(r1)
		lwz       r3, 8(r4)
		lwz       r0, 0xC(r4)
		cmplw     r3, r0
		blt       loc_8002E654
		li        r3, -6
		b         loc_8002E6E0
loc_8002E654:
		lwz       r0, 0x24(r4)
		cmplw     r0, r31
		bgt       loc_8002E6DC
		li        r3, -6
		b         loc_8002E6E0
loc_8002E668:
		cmpwi     r30, 1
		bne       loc_8002E6D4
		b         loc_8002E6B0
loc_8002E674:
		lwz       r0, 0x20(r4)
		mr        r3, r30
		li        r5, 0
		stw       r0, 0x20+var_18(r1)
		lwz       r4, 0x20+var_18(r1)
		bl        DeleteMsg
		cmpwi     r3, 0
		beq       loc_8002E698
		b         loc_8002E6E0
loc_8002E698:
		mr        r3, r30
		addi      r4, r1, 0x20+var_14
		bl        GetCachedMBCHeader
		cmpwi     r3, 0
		beq       loc_8002E6B0
		b         loc_8002E6E0
loc_8002E6B0:
		lwz       r4, 0x20+var_14(r1)
		lwz       r3, 8(r4)
		lwz       r0, 0xC(r4)
		cmplw     r3, r0
		bge       loc_8002E674
		lwz       r0, 0x24(r4)
		cmplw     r0, r31
		ble       loc_8002E674
		b         loc_8002E6DC
loc_8002E6D4:
		li        r3, -3
		b         loc_8002E6E0
loc_8002E6DC:
		li        r3, 0
loc_8002E6E0:
		lwz       r0, 0x20+sender_lr(r1)
		lwz       r31, 0x20+var_4(r1)
		lwz       r30, 0x20+var_8(r1)
		mtlr      r0
		addi      r1, r1, 0x20
		blr


DeleteMsg:
.set back_chain, -0xE0
.set var_D8, -0xD8
.set var_D4, -0xD4
.set var_D0, -0xD0
.set var_CC, -0xCC
.set pre_back_chain,  0
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0xE0+sender_lr(r1)
		addi      r11, r1, 0xE0+pre_back_chain
		bl        _savegpr_20
		lis       r31, _3644@ha
		mr        r22, r3
		mr        r23, r4
		mr        r24, r5
		addi      r31, r31, _3644@l 
		li        r29, 0
		li        r27, 0
		li        r26, 0
		bl        NWC24IsMsgLibOpened
		cmpwi     r3, 0
		bne       loc_8002E74C
		bl        NWC24IsMsgLibOpenedByTool
		cmpwi     r3, 0
		bne       loc_8002E74C
		li        r3, -9
		b         loc_8002EB80
loc_8002E74C:
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r5, 0(r9)
		mr        r3, r22
		addi      r4, r1, 0xE0+var_D0
		addi      r25, r5, 0x1800
		bl        GetCachedMBCHeader
		cmpwi     r3, 0
		beq       loc_8002E76C
		b         loc_8002EB80
loc_8002E76C:
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r3, 0(r9)
		addi      r21, r3, 0x800
		bl        NWC24GetMBoxDir
		mr        r20, r3
		li        r4, 0x40
		bl        STD_strnlen
		addi      r0, r3, 0xE
		cmpwi     r0, 0x100
		ble       loc_8002E798
		li        r3, -0xB
		b         loc_8002E7F4
loc_8002E798:
		cmpwi     r22, 1
		beq       loc_8002E7CC
		bge       loc_8002E7E8
		cmpwi     r22, 0
		bge       loc_8002E7B0
		b         loc_8002E7E8
loc_8002E7B0:
		mr        r3, r21
		mr        r5, r20
		addi      r6, r31, 0
		lis       r4, _3643@h
		ori       r4, r4, _3643@l

		crclr     4*cr1+eq
		bl        Mail_sprintf
		b         loc_8002E7F0
loc_8002E7CC:
		mr        r3, r21
		mr        r5, r20
		lis       r6, _3645@h
		ori       r6, r6, _3645@l

		lis       r4, _3643@h
		ori       r4, r4, _3643@l

		crclr     4*cr1+eq
		bl        Mail_sprintf
		b         loc_8002E7F0
loc_8002E7E8:
		li        r3, -3
		b         loc_8002E7F4
loc_8002E7F0:
		li        r3, 0
loc_8002E7F4:
		cmpwi     r3, 0
		beq       loc_8002E800
		b         loc_8002EB80
loc_8002E800:
		mr        r4, r21
		addi      r3, r1, 0xE0+var_CC
		li        r5, 4
		bl        NWC24FOpen
		cmpwi     r3, 0
		beq       loc_8002E81C
		b         loc_8002EB80
loc_8002E81C:
		li        r30, -0xD
		li        r28, 0x80
		lis       r21, 2
		lis       r20, 0xE
		b         loc_8002E980
loc_8002E830:
		mr        r4, r28
		addi      r3, r1, 0xE0+var_CC
		li        r5, 0
		bl        NWC24FSeek
		cmpwi     r3, 0
		beq       loc_8002E850
		mr        r30, r3
		b         loc_8002E990
loc_8002E850:
		mr        r3, r25
		addi      r5, r1, 0xE0+var_CC
		li        r4, 0x80
		bl        NWC24FRead
		cmpwi     r3, 0
		beq       loc_8002E870
		mr        r30, r3
		b         loc_8002E990
loc_8002E870:
		lwz       r3, 0(r25)
		cmpwi     r3, 0
		beq       loc_8002E97C
		cmplw     r3, r23
		addi      r29, r29, 1
		bne       loc_8002E908
		cmpwi     r24, 0
		beq       loc_8002E8FC
		lwz       r0, 4(r25)
		rlwinm.   r0, r0, 0,30,30
		beq       loc_8002E8C0
		lwz       r0, 0xC(r25)
		cmpwi     r0, 0
		bne       loc_8002E8C0
		bl        NWC24GetAppId
		addis     r0, r3, -0x4841
		cmplwi    r0, 0x4541
		beq       loc_8002E8FC
		li        r30, -7
		b         loc_8002E990
loc_8002E8C0:
		bl        NWC24GetAppId
		lwz       r0, 0xC(r25)
		clrrwi    r3, r3, 8
		clrrwi    r0, r0, 8
		cmplw     r0, r3
		beq       loc_8002E8FC
		lwz       r0, 4(r25)
		rlwinm.   r0, r0, 0,28,28
		beq       loc_8002E8F4
		bl        NWC24GetAppId
		addis     r0, r3, -0x4841
		cmplwi    r0, 0x4541
		beq       loc_8002E8FC
loc_8002E8F4:
		li        r30, -7
		b         loc_8002E990
loc_8002E8FC:
		mr        r27, r28
		li        r30, 0
		b         loc_8002E97C
loc_8002E908:
		cmpwi     r26, 0
		beq       loc_8002E978
		cmplw     r26, r3
		bne       loc_8002E920
		li        r0, 0
		b         loc_8002E970
loc_8002E920:
		addi      r0, r20, -0x4460 
		cmplw     r26, r0
		ble       loc_8002E940
		addi      r0, r21, -0x7960 
		cmplw     r3, r0
		bge       loc_8002E940
		li        r0, -1
		b         loc_8002E970
loc_8002E940:
		addi      r0, r21, -0x7960 
		cmplw     r26, r0
		bge       loc_8002E960
		addi      r0, r20, -0x4460 
		cmplw     r3, r0
		ble       loc_8002E960
		li        r0, 1
		b         loc_8002E970
loc_8002E960:
		cmplw     r26, r3
		li        r0, -1
		ble       loc_8002E970
		li        r0, 1
loc_8002E970:
		cmpwi     r0, 0
		ble       loc_8002E97C
loc_8002E978:
		mr        r26, r3
loc_8002E97C:
		addi      r28, r28, 0x80
loc_8002E980:
		lwz       r3, 0xE0+var_D0(r1)
		lwz       r0, 0x14(r3)
		cmplw     r28, r0
		blt       loc_8002E830
loc_8002E990:
		cmpwi     r30, -0xD
		bne       loc_8002E9D8
		lwz       r3, 0xE0+var_D0(r1)
		lwz       r0, 8(r3)
		cmplw     r0, r29
		beq       loc_8002E9D8
		stw       r29, 8(r3)
		addi      r3, r1, 0xE0+var_CC
		li        r4, 0
		li        r5, 0
		lwz       r20, 0xE0+var_D0(r1)
		bl        NWC24FSeek
		cmpwi     r3, 0
		bne       loc_8002E9D8
		mr        r3, r20
		addi      r5, r1, 0xE0+var_CC
		li        r4, 0x80
		bl        NWC24FWrite
loc_8002E9D8:
		cmpwi     r30, 0
		beq       loc_8002E9FC
		addi      r3, r1, 0xE0+var_CC
		bl        NWC24FClose
		cmpwi     r23, 0
		bne       loc_8002E9F4
		li        r30, -3
loc_8002E9F4:
		mr        r3, r30
		b         loc_8002EB80
loc_8002E9FC:
		lwz       r3, 0xE0+var_D0(r1)
		mr        r5, r27
		addi      r4, r1, 0xE0+var_CC
		stw       r26, 0x20(r3)
		lwz       r3, 0xE0+var_D0(r1)
		bl        ClearMBCEntry
		mr        r24, r3
		mr        r3, r22
		bl        MountVFMBox
		cmpwi     r3, 0
		beq       loc_8002EA2C
		b         loc_8002EB1C
loc_8002EA2C:
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r3, 0(r9)
		cmpwi     r22, 1
		addi      r20, r3, 0x800
		beq       loc_8002EA64
		bge       loc_8002EA7C
		cmpwi     r22, 0
		bge       loc_8002EA4C
		b         loc_8002EA7C
loc_8002EA4C:
		mr        r3, r20
		mr        r5, r23
		lis       r4, _3813@h
		ori       r4, r4, _3813@l

		crclr     4*cr1+eq
		bl        Mail_sprintf
		b         loc_8002EA84
loc_8002EA64:
		mr        r3, r20
		mr        r5, r23
		lis       r4, _3814_0@h
		ori       r4, r4, _3814_0@l

		crclr     4*cr1+eq
		bl        Mail_sprintf
		b         loc_8002EA84
loc_8002EA7C:
		li        r3, -3
		b         loc_8002EA88
loc_8002EA84:
		li        r3, 0
loc_8002EA88:
		cmpwi     r3, 0
		beq       loc_8002EA94
		b         loc_8002EB1C
loc_8002EA94:
		mr        r3, r20
		bl        NWC24FDeleteVF
		lis       r9, MountInfo@h
		ori       r9, r9, MountInfo@l
		lwz       r4, 0(r9)
		mr        r20, r3
		cmpwi     r4, 0
		bne       loc_8002EAB4
		li        r3, 0
		b         loc_8002EB10
loc_8002EAB4:
		addic.    r0, r4, -1
		lis       r9, MountInfo@h
		ori       r9, r9, MountInfo@l
		stw       r0, 0(r9)
		ble       loc_8002EAC8
		li        r3, 0
		b         loc_8002EB10
loc_8002EAC8:
		lis       r3, MountInfo@h
		ori       r3, r3, MountInfo@l

		addi      r4, r1, 0xE0+var_D4
		lis       r9, dword_80083714@h
		ori       r9, r9, dword_80083714@l
		lwz       r3, 0(r9)
		bl        GetCachedMBCHeader
		cmpwi     r3, 0
		beq       loc_8002EAE4
		b         loc_8002EB10
loc_8002EAE4:
		addi      r4, r1, 0xE0+var_D8
		lis       r3, _3815_0@h
		ori       r3, r3, _3815_0@l

		bl        NWC24CheckSizeVF
		cmpwi     r3, 0
		beq       loc_8002EAFC
		b         loc_8002EB10
loc_8002EAFC:
		lwz       r0, 0xE0+var_D8(r1)
		lis       r3, _3815_0@h
		ori       r3, r3, _3815_0@l

		lwz       r4, 0xE0+var_D4(r1)
		stw       r0, 0x24(r4)
		bl        NWC24UnmountVF
loc_8002EB10:
		cmpwi     r20, 0
		beq       loc_8002EB1C
		mr        r3, r20
loc_8002EB1C:
		cmpwi     r24, 0
		mr        r21, r3
		beq       loc_8002EB2C
		mr        r21, r24
loc_8002EB2C:
		lwz       r20, 0xE0+var_D0(r1)
		addi      r3, r1, 0xE0+var_CC
		li        r4, 0
		li        r5, 0
		bl        NWC24FSeek
		cmpwi     r3, 0
		beq       loc_8002EB4C
		b         loc_8002EB5C
loc_8002EB4C:
		mr        r3, r20
		addi      r5, r1, 0xE0+var_CC
		li        r4, 0x80
		bl        NWC24FWrite
loc_8002EB5C:
		cmpwi     r21, 0
		mr        r22, r3
		beq       loc_8002EB6C
		mr        r22, r21
loc_8002EB6C:
		addi      r3, r1, 0xE0+var_CC
		bl        NWC24FClose
		cmpwi     r22, 0
		beq       loc_8002EB80
		mr        r3, r22
loc_8002EB80:
		addi      r11, r1, 0xE0+pre_back_chain
		bl        _restgpr_20
		lwz       r0, 0xE0+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0xE0
		blr


DuplicationCheck:
.set back_chain, -0x40
.set var_38, -0x38
.set var_34, -0x34
.set pre_back_chain,  0
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x40+sender_lr(r1)
		addi      r11, r1, 0x40+pre_back_chain
		bl        _savegpr_20
		cmpwi     r6, 0
		mr        r20, r3
		mr        r21, r4
		mr        r22, r5
		mr        r23, r6
		li        r3, 0
		li        r28, 0
		li        r27, 0
		li        r26, 0
		li        r25, 0
		bne       loc_8002EBE0
		li        r3, 0
		b         loc_8002EEF8
loc_8002EBE0:
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r4, 0(r9)
		li        r29, 0x80
		lis       r31, 2
		lis       r30, 0xE
		addi      r24, r4, 0x1800
		b         loc_8002EDA8
loc_8002EBF8:
		lwz       r0, 8(r20)
		cmplw     r28, r0
		bge       loc_8002EDB4
		mr        r3, r22
		mr        r4, r29
		li        r5, 0
		bl        NWC24FSeek
		cmpwi     r3, 0
		bne       loc_8002EDB4
		mr        r3, r24
		mr        r5, r22
		li        r4, 0x80
		bl        NWC24FRead
		cmpwi     r3, 0
		bne       loc_8002EDB4
		lwz       r0, 0(r24)
		cmpwi     r0, 0
		beq       loc_8002EDA4
		lwz       r4, 0(r21)
		li        r10, 1
		addi      r28, r28, 1
		cmplw     r0, r4
		bne       loc_8002EC58
		li        r10, 0
loc_8002EC58:
		lwz       r4, 4(r21)
		lwz       r5, 4(r24)
		and       r6, r5, r4
		clrlwi.   r6, r6, 31
		beq       loc_8002ECA4
		lwz       r7, 0xC(r24)
		lwz       r6, 0xC(r21)
		cmplw     r7, r6
		beq       loc_8002EC80
		li        r10, 0
loc_8002EC80:
		lwz       r8, 0x20(r24)
		lwz       r6, 0x20(r21)
		lwz       r9, 0x24(r24)
		lwz       r7, 0x24(r21)
		xor       r6, r8, r6
		xor       r7, r9, r7
		or.       r6, r7, r6
		beq       loc_8002ECA4
		li        r10, 0
loc_8002ECA4:
		cmpwi     r10, 0
		beq       loc_8002ED30
		lwz       r6, 0x14(r21)
		clrlwi.   r7, r6, 16
		beq       loc_8002ECD4
		lwz       r6, 0x14(r24)
		clrlwi    r6, r6, 16
		cmplw     r6, r7
		bne       loc_8002ECD4
		mr        r27, r0
		mr        r26, r29
		b         loc_8002EDA4
loc_8002ECD4:
		lwz       r7, 0x1C(r21)
		cmpwi     r7, 0
		beq       loc_8002ED30
		lwz       r6, 0x1C(r24)
		cmplw     r6, r7
		bne       loc_8002ED30
		cmplw     r5, r4
		bne       loc_8002ED30
		lwz       r5, 8(r24)
		lwz       r4, 8(r21)
		cmplw     r5, r4
		bne       loc_8002ED30
		lwz       r5, 0x10(r24)
		lwz       r4, 0x10(r21)
		cmplw     r5, r4
		bne       loc_8002ED30
		lwz       r5, 0x28(r24)
		lwz       r4, 0x28(r21)
		cmpw      r5, r4
		bne       loc_8002ED30
		mr        r27, r0
		mr        r26, r29
		b         loc_8002EDA4
loc_8002ED30:
		cmpwi     r25, 0
		beq       loc_8002EDA0
		cmplw     r25, r0
		bne       loc_8002ED48
		li        r4, 0
		b         loc_8002ED98
loc_8002ED48:
		addi      r4, r30, -0x4460 
		cmplw     r25, r4
		ble       loc_8002ED68
		addi      r4, r31, -0x7960 
		cmplw     r0, r4
		bge       loc_8002ED68
		li        r4, -1
		b         loc_8002ED98
loc_8002ED68:
		addi      r4, r31, -0x7960 
		cmplw     r25, r4
		bge       loc_8002ED88
		addi      r4, r30, -0x4460 
		cmplw     r0, r4
		ble       loc_8002ED88
		li        r4, 1
		b         loc_8002ED98
loc_8002ED88:
		cmplw     r25, r0
		li        r4, -1
		ble       loc_8002ED98
		li        r4, 1
loc_8002ED98:
		cmpwi     r4, 0
		ble       loc_8002EDA4
loc_8002EDA0:
		mr        r25, r0
loc_8002EDA4:
		addi      r29, r29, 0x80
loc_8002EDA8:
		lwz       r0, 0x14(r20)
		cmplw     r29, r0
		blt       loc_8002EBF8
loc_8002EDB4:
		cmpwi     r3, 0
		beq       loc_8002EDC0
		b         loc_8002EEF8
loc_8002EDC0:
		cmpwi     r27, 0
		stw       r25, 0x20(r20)
		beq       loc_8002EEF8
		mr        r3, r20
		mr        r4, r22
		mr        r5, r26
		bl        ClearMBCEntry
		mr        r21, r3
		mr        r3, r23
		bl        MountVFMBox
		cmpwi     r3, 0
		beq       loc_8002EDF4
		b         loc_8002EEEC
loc_8002EDF4:
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r3, 0(r9)
		cmpwi     r23, 1
		addi      r20, r3, 0x800
		beq       loc_8002EE30
		bge       loc_8002EE4C
		cmpwi     r23, 0
		bge       loc_8002EE14
		b         loc_8002EE4C
loc_8002EE14:
		lis       r4, _3813@ha
		mr        r3, r20
		mr        r5, r27
		addi      r4, r4, _3813@l # "@24:
		crclr     4*cr1+eq
		bl        Mail_sprintf
		b         loc_8002EE54
loc_8002EE30:
		lis       r4, _3814_0@ha
		mr        r3, r20
		mr        r5, r27
		addi      r4, r4, _3814_0@l # "@24:
		crclr     4*cr1+eq
		bl        Mail_sprintf
		b         loc_8002EE54
loc_8002EE4C:
		li        r3, -3
		b         loc_8002EE58
loc_8002EE54:
		li        r3, 0
loc_8002EE58:
		cmpwi     r3, 0
		beq       loc_8002EE64
		b         loc_8002EEEC
loc_8002EE64:
		mr        r3, r20
		bl        NWC24FDeleteVF
		lis       r9, MountInfo@h
		ori       r9, r9, MountInfo@l
		lwz       r4, 0(r9)
		mr        r20, r3
		cmpwi     r4, 0
		bne       loc_8002EE84
		li        r3, 0
		b         loc_8002EEE0
loc_8002EE84:
		addic.    r0, r4, -1
		lis       r9, MountInfo@h
		ori       r9, r9, MountInfo@l
		stw       r0, 0(r9)
		ble       loc_8002EE98
		li        r3, 0
		b         loc_8002EEE0
loc_8002EE98:
		lis       r3, MountInfo@h
		ori       r3, r3, MountInfo@l

		addi      r4, r1, 0x40+var_34
		lis       r9, dword_80083714@h
		ori       r9, r9, dword_80083714@l
		lwz       r3, 0(r9)
		bl        GetCachedMBCHeader
		cmpwi     r3, 0
		beq       loc_8002EEB4
		b         loc_8002EEE0
loc_8002EEB4:
		addi      r4, r1, 0x40+var_38
		lis       r3, _3815_0@h
		ori       r3, r3, _3815_0@l

		bl        NWC24CheckSizeVF
		cmpwi     r3, 0
		beq       loc_8002EECC
		b         loc_8002EEE0
loc_8002EECC:
		lwz       r0, 0x40+var_38(r1)
		lis       r3, _3815_0@h
		ori       r3, r3, _3815_0@l

		lwz       r4, 0x40+var_34(r1)
		stw       r0, 0x24(r4)
		bl        NWC24UnmountVF
loc_8002EEE0:
		cmpwi     r20, 0
		beq       loc_8002EEEC
		mr        r3, r20
loc_8002EEEC:
		cmpwi     r21, 0
		beq       loc_8002EEF8
		mr        r3, r21
loc_8002EEF8:
		addi      r11, r1, 0x40+pre_back_chain
		bl        _restgpr_20
		lwz       r0, 0x40+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x40
		blr


GetCachedMBCHeader:
.set back_chain, -0xC0
.set var_B8, -0xB8
.set var_10, -0x10
.set var_C, -0xC
.set var_8, -8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		cmpwi     r3, 0
		li        r5, 0
		stw       r0, 0xC0+sender_lr(r1)
		stw       r31, 0xC0+var_4(r1)
		stw       r30, 0xC0+var_8(r1)
		stw       r29, 0xC0+var_C(r1)
		mr        r29, r4
		stw       r28, 0xC0+var_10(r1)
		mr        r28, r3
		bne       loc_8002EF50
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r3, 0(r9)
		addi      r0, r3, 0x1700
		stw       r0, 0(r4)
		b         loc_8002EF78
loc_8002EF50:
		cmpwi     r3, 1
		bne       loc_8002EF68
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r3, 0(r9)
		addi      r0, r3, 0x1780
		stw       r0, 0(r4)
		b         loc_8002EF78
loc_8002EF68:
		li        r0, 0
		li        r3, -3
		stw       r0, 0(r4)
		b         loc_8002F0F4
loc_8002EF78:
		lwz       r3, 0(r4)
		lwz       r3, 0(r3)
		addis     r0, r3, -0x5763
		cmplwi    r0, 0x5466
		beq       loc_8002F0B8
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r3, 0(r9)
		addi      r30, r3, 0x800
		bl        NWC24GetMBoxDir
		mr        r31, r3
		li        r4, 0x40
		bl        STD_strnlen
		addi      r0, r3, 0xE
		cmpwi     r0, 0x100
		ble       loc_8002EFB8
		li        r3, -0xB
		b         loc_8002F01C
loc_8002EFB8:
		cmpwi     r28, 1
		beq       loc_8002EFF0
		bge       loc_8002F010
		cmpwi     r28, 0
		bge       loc_8002EFD0
		b         loc_8002F010
loc_8002EFD0:
		lis       r6, _3644@ha
		mr        r3, r30
		mr        r5, r31
		lis       r4, _3643@h
		ori       r4, r4, _3643@l

		addi      r6, r6, _3644@l 
		crclr     4*cr1+eq
		bl        Mail_sprintf
		b         loc_8002F018
loc_8002EFF0:
		lis       r6, _3645@ha
		mr        r3, r30
		mr        r5, r31
		lis       r4, _3643@h
		ori       r4, r4, _3643@l

		addi      r6, r6, _3645@l 
		crclr     4*cr1+eq
		bl        Mail_sprintf
		b         loc_8002F018
loc_8002F010:
		li        r3, -3
		b         loc_8002F01C
loc_8002F018:
		li        r3, 0
loc_8002F01C:
		cmpwi     r3, 0
		beq       loc_8002F028
		b         loc_8002F0F4
loc_8002F028:
		mr        r4, r30
		addi      r3, r1, 0xC0+var_B8
		li        r5, 2
		bl        NWC24FOpen
		cmpwi     r3, 0
		beq       loc_8002F044
		b         loc_8002F0F4
loc_8002F044:
		lwz       r31, 0(r29)
		addi      r3, r1, 0xC0+var_B8
		li        r4, 0
		li        r5, 0
		bl        NWC24FSeek
		cmpwi     r3, 0
		beq       loc_8002F068
		mr        r31, r3
		b         loc_8002F0A0
loc_8002F068:
		mr        r3, r31
		addi      r5, r1, 0xC0+var_B8
		li        r4, 0x80
		bl        NWC24FRead
		cmpwi     r3, 0
		beq       loc_8002F088
		mr        r31, r3
		b         loc_8002F0A0
loc_8002F088:
		lwz       r3, 0(r31)
		li        r31, 0
		addis     r0, r3, -0x5763
		cmplwi    r0, 0x5466
		beq       loc_8002F0A0
		li        r31, -0xE
loc_8002F0A0:
		addi      r3, r1, 0xC0+var_B8
		bl        NWC24FClose
		cmpwi     r31, 0
		beq       loc_8002F0B4
		mr        r3, r31
loc_8002F0B4:
		mr        r5, r3
loc_8002F0B8:
		cmpwi     r5, 0
		beq       loc_8002F0C8
		mr        r3, r5
		b         loc_8002F0F4
loc_8002F0C8:
		lwz       r3, 0(r29)
		lwz       r0, 0x1C(r3)
		clrlwi.   r0, r0, 27
		beq       loc_8002F0E0
		li        r3, -0xE
		b         loc_8002F0F4
loc_8002F0E0:
		lwz       r0, 4(r3)
		cmplwi    r0, 4
		beq       loc_8002F0F0
		li        r5, -0x1B
loc_8002F0F0:
		mr        r3, r5
loc_8002F0F4:
		lwz       r0, 0xC0+sender_lr(r1)
		lwz       r31, 0xC0+var_4(r1)
		lwz       r30, 0xC0+var_8(r1)
		lwz       r29, 0xC0+var_C(r1)
		lwz       r28, 0xC0+var_10(r1)
		mtlr      r0
		addi      r1, r1, 0xC0
		blr


AddMBCEntry:
.set back_chain, -0x20
.set pre_back_chain,  0
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x20+sender_lr(r1)
		addi      r11, r1, 0x20+pre_back_chain
		bl        _savegpr_27
		lwz       r30, 0x1C(r3)
		mr        r31, r3
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r6, 0(r9)
		mr        r27, r4
		cmpwi     r30, 0
		mr        r28, r5
		addi      r29, r6, 0x1800
		bne       loc_8002F150
		li        r3, -6
		b         loc_8002F248
loc_8002F150:
		lwz       r0, 0x14(r3)
		cmplw     r30, r0
		bge       loc_8002F168
		addi      r0, r30, -0x80
		clrlwi.   r0, r0, 25
		beq       loc_8002F170
loc_8002F168:
		li        r3, -0xE
		b         loc_8002F248
loc_8002F170:
		mr        r3, r28
		mr        r4, r30
		li        r5, 0
		bl        NWC24FSeek
		cmpwi     r3, 0
		beq       loc_8002F18C
		b         loc_8002F248
loc_8002F18C:
		mr        r3, r29
		mr        r5, r28
		li        r4, 0x80
		bl        NWC24FRead
		cmpwi     r3, 0
		beq       loc_8002F1A8
		b         loc_8002F248
loc_8002F1A8:
		lwz       r3, 0xC(r29)
		lwz       r0, 0x14(r31)
		cmplw     r3, r0
		bge       loc_8002F1C4
		addi      r0, r3, -0x80
		clrlwi.   r0, r0, 25
		beq       loc_8002F1CC
loc_8002F1C4:
		li        r3, -0xE
		b         loc_8002F248
loc_8002F1CC:
		stw       r3, 0x1C(r31)
		mr        r3, r27
		mr        r4, r29
		bl        CopyMsgObjToMBCFmt
		mr        r3, r28
		mr        r4, r30
		li        r5, 0
		bl        NWC24FSeek
		cmpwi     r3, 0
		beq       loc_8002F1F8
		b         loc_8002F248
loc_8002F1F8:
		mr        r3, r29
		mr        r5, r28
		li        r4, 0x80
		bl        NWC24FWrite
		cmpwi     r3, 0
		beq       loc_8002F214
		b         loc_8002F248
loc_8002F214:
		lwz       r0, 8(r31)
		cmpwi     r0, 0
		bne       loc_8002F228
		lwz       r0, 0(r27)
		stw       r0, 0x20(r31)
loc_8002F228:
		lwz       r5, 8(r31)
		li        r3, 0
		lwz       r4, 0x10(r31)
		lwz       r0, 8(r27)
		addi      r5, r5, 1
		stw       r5, 8(r31)
		add       r0, r4, r0
		stw       r0, 0x10(r31)
loc_8002F248:
		addi      r11, r1, 0x20+pre_back_chain
		bl        _restgpr_27
		lwz       r0, 0x20+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x20
		blr


ClearMBCEntry:
.set back_chain, -0x20
.set var_10, -0x10
.set var_C, -0xC
.set var_8, -8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x20+sender_lr(r1)
		stw       r31, 0x20+var_4(r1)
		stw       r30, 0x20+var_8(r1)
		mr        r30, r5
		li        r5, 0
		stw       r29, 0x20+var_C(r1)
		mr        r29, r4
		mr        r4, r30
		stw       r28, 0x20+var_10(r1)
		mr        r28, r3
		mr        r3, r29
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r6, 0(r9)
		addi      r31, r6, 0x1800
		bl        NWC24FSeek
		cmpwi     r3, 0
		beq       loc_8002F2AC
		b         loc_8002F32C
loc_8002F2AC:
		mr        r3, r31
		mr        r5, r29
		li        r4, 0x80
		bl        NWC24FRead
		cmpwi     r3, 0
		beq       loc_8002F2C8
		b         loc_8002F32C
loc_8002F2C8:
		lwz       r5, 8(r28)
		mr        r3, r31
		lwz       r0, 0x10(r28)
		li        r4, 0
		addi      r6, r5, -1
		li        r5, 0x80
		stw       r6, 8(r28)
		lwz       r6, 8(r31)
		subf      r0, r6, r0
		stw       r0, 0x10(r28)
		bl        memset
		lwz       r0, 0x1C(r28)
		mr        r3, r29
		mr        r4, r30
		li        r5, 0
		stw       r0, 0xC(r31)
		stw       r30, 0x1C(r28)
		bl        NWC24FSeek
		cmpwi     r3, 0
		beq       loc_8002F31C
		b         loc_8002F32C
loc_8002F31C:
		mr        r3, r31
		mr        r5, r29
		li        r4, 0x80
		bl        NWC24FWrite
loc_8002F32C:
		lwz       r0, 0x20+sender_lr(r1)
		lwz       r31, 0x20+var_4(r1)
		lwz       r30, 0x20+var_8(r1)
		lwz       r29, 0x20+var_C(r1)
		lwz       r28, 0x20+var_10(r1)
		mtlr      r0
		addi      r1, r1, 0x20
		blr


MountVFMBox:
.set back_chain, -0x20
.set var_18, -0x18
.set var_14, -0x14
.set var_C, -0xC
.set var_8, -8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x20+sender_lr(r1)
		stw       r31, 0x20+var_4(r1)
		stw       r30, 0x20+var_8(r1)
		stw       r29, 0x20+var_C(r1)
		mr        r29, r3
		lis       r9, MountInfo@h
		ori       r9, r9, MountInfo@l
		lwz       r0, 0(r9)
		cmpwi     r0, 0
		beq       loc_8002F3E0
		lis       r4, MountInfo@h
		ori       r4, r4, MountInfo@l

		lis       r9, dword_80083714@h
		ori       r9, r9, dword_80083714@l
		lwz       r4, 0(r9)
		cmpw      r4, r3
		beq       loc_8002F3E0
		li        r0, 1
		lis       r9, MountInfo@h
		ori       r9, r9, MountInfo@l
		stw       r0, 0(r9)
		li        r0, 0
		cmpwi     r0, 0
		lis       r9, MountInfo@h
		ori       r9, r9, MountInfo@l
		stw       r0, 0(r9)
		bgt       loc_8002F3D8
		mr        r3, r4
		addi      r4, r1, 0x20+var_14
		bl        GetCachedMBCHeader
		cmpwi     r3, 0
		bne       loc_8002F3D8
		addi      r4, r1, 0x20+var_18
		lis       r3, _3815_0@h
		ori       r3, r3, _3815_0@l

		bl        NWC24CheckSizeVF
		cmpwi     r3, 0
		bne       loc_8002F3D8
		lwz       r0, 0x20+var_18(r1)
		lis       r3, _3815_0@h
		ori       r3, r3, _3815_0@l

		lwz       r4, 0x20+var_14(r1)
		stw       r0, 0x24(r4)
		bl        NWC24UnmountVF
loc_8002F3D8:
		li        r3, -1
		b         loc_8002F4BC
loc_8002F3E0:
		lis       r9, MountInfo@h
		ori       r9, r9, MountInfo@l
		lwz       r3, 0(r9)
		addi      r0, r3, 1
		cmpwi     r0, 1
		lis       r9, MountInfo@h
		ori       r9, r9, MountInfo@l
		stw       r0, 0(r9)
		ble       loc_8002F3FC
		li        r3, 0
		b         loc_8002F4BC
loc_8002F3FC:
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r3, 0(r9)
		addi      r30, r3, 0x800
		bl        NWC24GetMBoxDir
		mr        r31, r3
		li        r4, 0x40
		bl        STD_strnlen
		addi      r0, r3, 0xE
		cmpwi     r0, 0x100
		ble       loc_8002F428
		li        r3, -0xB
		b         loc_8002F48C
loc_8002F428:
		cmpwi     r29, 1
		beq       loc_8002F460
		bge       loc_8002F480
		cmpwi     r29, 0
		bge       loc_8002F440
		b         loc_8002F480
loc_8002F440:
		lis       r6, _3739@ha
		mr        r3, r30
		mr        r5, r31
		lis       r4, _3643@h
		ori       r4, r4, _3643@l

		addi      r6, r6, _3739@l 
		crclr     4*cr1+eq
		bl        Mail_sprintf
		b         loc_8002F488
loc_8002F460:
		lis       r6, _3738@ha
		mr        r3, r30
		mr        r5, r31
		lis       r4, _3643@h
		ori       r4, r4, _3643@l

		addi      r6, r6, _3738@l 
		crclr     4*cr1+eq
		bl        Mail_sprintf
		b         loc_8002F488
loc_8002F480:
		li        r3, -3
		b         loc_8002F48C
loc_8002F488:
		li        r3, 0
loc_8002F48C:
		cmpwi     r3, 0
		beq       loc_8002F498
		b         loc_8002F4BC
loc_8002F498:
		mr        r4, r30
		lis       r3, _3815_0@h
		ori       r3, r3, _3815_0@l
		bl        NWC24MountVF
		cmpwi     r3, 0
		beq       loc_8002F4B0
		b         loc_8002F4BC
loc_8002F4B0:
		lis       r4, MountInfo@h
		ori       r4, r4, MountInfo@l

		li        r3, 0
		lis       r9, dword_80083714@h
		ori       r9, r9, dword_80083714@l
		stw       r29, 0(r9)
loc_8002F4BC:
		lwz       r0, 0x20+sender_lr(r1)
		lwz       r31, 0x20+var_4(r1)
		lwz       r30, 0x20+var_8(r1)
		lwz       r29, 0x20+var_C(r1)
		mtlr      r0
		addi      r1, r1, 0x20
		blr


CopyMsgObjToMBCFmt:
.set back_chain, -0x70
.set var_68, -0x68
.set var_64, -0x64
.set var_60, -0x60
.set var_5C, -0x5C
.set var_58, -0x58
.set var_54, -0x54
.set var_50, -0x50
.set pre_back_chain,  0
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x70+sender_lr(r1)
		addi      r11, r1, 0x70+pre_back_chain
		bl        _savegpr_14
		lwz       r0, 0x44(r3)
		lwz       r15, 0x6C(r3)
		slwi      r18, r0, 20
		lwz       r0, 0x5C(r3)
		stw       r15, 0x70+var_50(r1)
		slwi      r16, r0, 20
		lwz       r0, 0x58(r3)
		lwz       r15, 0x78(r3)
		insrwi    r16, r0, 20,12
		lwz       r0, 0xF0(r3)
		stw       r15, 0x70+var_68(r1)
		lwz       r15, 0x80(r3)
		stw       r0, 0x78(r4)
		lwz       r0, 0x70+var_50(r1)
		lwz       r5, 0x3C(r3)
		stw       r15, 0x70+var_64(r1)
		lwz       r15, 0x70(r3)
		slwi      r19, r5, 20
		stw       r0, 0x54(r4)
		lwz       r0, 0x70+var_68(r1)
		lwz       r6, 0x34(r3)
		lwz       r5, 0x54(r3)
		stw       r15, 0x70+var_60(r1)
		slwi      r20, r6, 20
		lwz       r15, 0x74(r3)
		slwi      r17, r5, 20
		stw       r0, 0x60(r4)
		lwz       r0, 0x70+var_64(r1)
		lwz       r8, 0x30(r3)
		lwz       r7, 0x38(r3)
		insrwi    r20, r8, 20,12
		lwz       r6, 0x40(r3)
		insrwi    r19, r7, 20,12
		lwz       r5, 0x50(r3)
		insrwi    r18, r6, 20,12
		stw       r15, 0x70+var_5C(r1)
		insrwi    r17, r5, 20,12
		lwz       r21, 0(r3)
		stw       r0, 0x68(r4)
		lwz       r0, 0x70+var_60(r1)
		lwz       r22, 4(r3)
		lwz       r23, 8(r3)
		lwz       r24, 0xC(r3)
		lwz       r25, 0x10(r3)
		lwz       r26, 0x14(r3)
		lwz       r27, 0x18(r3)
		lwz       r28, 0x1C(r3)
		lwz       r29, 0x20(r3)
		lwz       r30, 0x24(r3)
		lwz       r31, 0x28(r3)
		lwz       r12, 0x2C(r3)
		lbz       r11, 0xC8(r3)
		lbz       r10, 0xC9(r3)
		lhz       r9, 0xCA(r3)
		lwz       r8, 0x48(r3)
		lwz       r7, 0x4C(r3)
		lwz       r6, 0xE8(r3)
		lwz       r5, 0xEC(r3)
		lwz       r14, 0x68(r3)
		lwz       r15, 0x7C(r3)
		lwz       r3, 0x84(r3)
		stw       r0, 0x58(r4)
		lwz       r0, 0x70+var_5C(r1)
		stw       r3, 0x70+var_54(r1)
		li        r3, 0
		stw       r0, 0x5C(r4)
		mr        r0, r15
		stw       r0, 0x64(r4)
		lwz       r0, 0x70+var_54(r1)
		stw       r15, 0x70+var_58(r1)
		stw       r21, 0(r4)
		stw       r22, 4(r4)
		stw       r23, 8(r4)
		stw       r24, 0xC(r4)
		stw       r25, 0x10(r4)
		stw       r26, 0x14(r4)
		stw       r27, 0x18(r4)
		stw       r28, 0x1C(r4)
		stw       r29, 0x20(r4)
		stw       r30, 0x24(r4)
		stw       r31, 0x28(r4)
		stw       r12, 0x2C(r4)
		stb       r11, 0x30(r4)
		stb       r10, 0x31(r4)
		sth       r9, 0x32(r4)
		stw       r20, 0x34(r4)
		stw       r19, 0x38(r4)
		stw       r18, 0x3C(r4)
		stw       r17, 0x40(r4)
		stw       r16, 0x44(r4)
		stw       r8, 0x48(r4)
		stw       r7, 0x4C(r4)
		stw       r6, 0x70(r4)
		stw       r5, 0x74(r4)
		stw       r14, 0x50(r4)
		stw       r0, 0x6C(r4)
		addi      r11, r1, 0x70+pre_back_chain
		bl        _restgpr_14
		lwz       r0, 0x70+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x70
		blr


Base64Encode:
.set back_chain, -0x20
.set pre_back_chain,  0
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x20+sender_lr(r1)
		addi      r11, r1, 0x20+pre_back_chain
		bl        _savegpr_27
		addi      r11, r4, 2
		li        r0, 3
		divwu     r11, r11, r0
		li        r10, 0
		li        r0, 0
		li        r9, 0
		mtctr     r11
		cmpwi     r4, 0
		ble       loc_8002F780
loc_8002F6BC:
		addi      r11, r9, 3
		cmpw      r11, r7
		blt       loc_8002F6D0
		li        r0, -8
		b         loc_8002F780
loc_8002F6D0:
		addi      r11, r10, 1
		lbzx      r12, r3, r10
		cmpw      r11, r4
		add       r31, r3, r10
		li        r29, 0
		li        r28, 0
		slwi      r27, r12, 8
		bge       loc_8002F6FC
		lbz       r11, 1(r31)
		li        r28, 1
		or        r27, r27, r11
loc_8002F6FC:
		addi      r11, r10, 2
		slwi      r27, r27, 8
		cmpw      r11, r4
		bge       loc_8002F718
		lbz       r11, 2(r31)
		li        r29, 1
		or        r27, r27, r11
loc_8002F718:
		lis       r7, MIMEEncStr@h
		ori       r7, r7, MIMEEncStr@l
		lwz       r31, 0(r7)
		extrwi    r11, r27, 6,8
		extrwi    r12, r27, 6,14
		add       r30, r6, r9
		lbzx      r31, r31, r11 
		cmpwi     r28, 0
		li        r11, 0x40
		stbx      r31, r6, r9
		lis       r7, MIMEEncStr@h
		ori       r7, r7, MIMEEncStr@l
		lwz       r31, 0(r7)
		lbzx      r12, r31, r12 
		stb       r12, 1(r30)
		lis       r7, MIMEEncStr@h
		ori       r7, r7, MIMEEncStr@l
		lwz       r12, 0(r7)
		beq       loc_8002F750
		extrwi    r11, r27, 6,20
loc_8002F750:
		lbzx      r12, r12, r11 
		cmpwi     r29, 0
		li        r11, 0x40
		stb       r12, 2(r30)
		lis       r7, MIMEEncStr@h
		ori       r7, r7, MIMEEncStr@l
		lwz       r12, 0(r7)
		beq       loc_8002F76C
		clrlwi    r11, r27, 26
loc_8002F76C:
		lbzx      r11, r12, r11 
		addi      r9, r9, 4
		addi      r10, r10, 3
		stb       r11, 3(r30)
		bdnz      loc_8002F6BC
loc_8002F780:
		cmpwi     r5, 0
		stw       r9, 0(r8)
		beq       loc_8002F79C
		cmpw      r4, r10
		bge       loc_8002F798
		mr        r10, r4
loc_8002F798:
		stw       r10, 0(r5)
loc_8002F79C:
		addi      r11, r1, 0x20+pre_back_chain
		mr        r3, r0
		bl        _restgpr_27
		lwz       r0, 0x20+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x20
		blr


.global NWC24Base64Encode
NWC24Base64Encode:
		mr        r9, r5
		mr        r0, r6
		mr        r8, r7
		li        r5, 0
		mr        r6, r9
		mr        r7, r0
		b         Base64Encode


.global NWC24InitBase64Table
NWC24InitBase64Table:
.set back_chain, -0x30
.set pre_back_chain,  0
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x30+sender_lr(r1)
		addi      r11, r1, 0x30+pre_back_chain
		bl        _savegpr_25
		li        r0, 8
		li        r6, 0
		li        r4, -1
		mtctr     r0
loc_8002F7F8:
		stbx      r4, r3, r6
		add       r5, r3, r6
		addi      r6, r6, 8
		stb       r4, 1(r5)
		stb       r4, 2(r5)
		stb       r4, 3(r5)
		stb       r4, 4(r5)
		stb       r4, 5(r5)
		stb       r4, 6(r5)
		stb       r4, 7(r5)
		add       r5, r3, r6
		stbx      r4, r3, r6
		addi      r6, r6, 8
		stb       r4, 1(r5)
		stb       r4, 2(r5)
		stb       r4, 3(r5)
		stb       r4, 4(r5)
		stb       r4, 5(r5)
		stb       r4, 6(r5)
		stb       r4, 7(r5)
		add       r5, r3, r6
		stbx      r4, r3, r6
		addi      r6, r6, 8
		stb       r4, 1(r5)
		stb       r4, 2(r5)
		stb       r4, 3(r5)
		stb       r4, 4(r5)
		stb       r4, 5(r5)
		stb       r4, 6(r5)
		stb       r4, 7(r5)
		add       r5, r3, r6
		stbx      r4, r3, r6
		addi      r6, r6, 8
		stb       r4, 1(r5)
		stb       r4, 2(r5)
		stb       r4, 3(r5)
		stb       r4, 4(r5)
		stb       r4, 5(r5)
		stb       r4, 6(r5)
		stb       r4, 7(r5)
		bdnz      loc_8002F7F8
		li        r12, 0
		li        r11, 1
		stb       r12, 0x41(r3)
		li        r10, 2
		li        r9, 3
		li        r8, 4
		stb       r11, 0x42(r3)
		li        r7, 5
		li        r6, 6
		li        r5, 7
		stb       r10, 0x43(r3)
		li        r12, 8
		li        r11, 9
		li        r10, 0xA
		stb       r9, 0x44(r3)
		li        r9, 0xB
		li        r4, 0x18
		li        r0, 0x19
		stb       r8, 0x45(r3)
		li        r8, 0xC
		stb       r7, 0x46(r3)
		li        r7, 0xD
		stb       r6, 0x47(r3)
		li        r6, 0xE
		stb       r5, 0x48(r3)
		li        r5, 0xF
		stb       r12, 0x49(r3)
		li        r12, 0x10
		stb       r11, 0x4A(r3)
		li        r11, 0x11
		stb       r10, 0x4B(r3)
		li        r10, 0x12
		stb       r9, 0x4C(r3)
		li        r9, 0x13
		stb       r8, 0x4D(r3)
		li        r8, 0x14
		stb       r7, 0x4E(r3)
		li        r7, 0x15
		stb       r6, 0x4F(r3)
		li        r6, 0x16
		stb       r5, 0x50(r3)
		li        r5, 0x17
		stb       r12, 0x51(r3)
		stb       r11, 0x52(r3)
		stb       r10, 0x53(r3)
		stb       r9, 0x54(r3)
		stb       r8, 0x55(r3)
		stb       r7, 0x56(r3)
		stb       r6, 0x57(r3)
		stb       r5, 0x58(r3)
		stb       r4, 0x59(r3)
		stb       r0, 0x5A(r3)
		li        r25, 0x1A
		li        r26, 0x1B
		stb       r25, 0x61(r3)
		li        r27, 0x1C
		li        r28, 0x1D
		li        r29, 0x1E
		stb       r26, 0x62(r3)
		li        r30, 0x1F
		li        r31, 0x20
		li        r12, 0x21
		stb       r27, 0x63(r3)
		li        r25, 0x22
		li        r26, 0x23
		li        r27, 0x24
		stb       r28, 0x64(r3)
		li        r28, 0x25
		li        r11, 0x32
		li        r10, 0x33
		stb       r29, 0x65(r3)
		li        r29, 0x26
		li        r9, 0x34
		li        r8, 0x35
		stb       r30, 0x66(r3)
		li        r30, 0x27
		li        r7, 0x36
		li        r6, 0x37
		stb       r31, 0x67(r3)
		li        r31, 0x28
		li        r5, 0x38
		li        r4, 0x3E
		stb       r12, 0x68(r3)
		li        r12, 0x29
		li        r0, 0x3F
		stb       r25, 0x69(r3)
		li        r25, 0x2A
		stb       r26, 0x6A(r3)
		li        r26, 0x2B
		stb       r27, 0x6B(r3)
		li        r27, 0x2C
		stb       r28, 0x6C(r3)
		li        r28, 0x2D
		stb       r29, 0x6D(r3)
		li        r29, 0x2E
		stb       r30, 0x6E(r3)
		li        r30, 0x2F
		stb       r31, 0x6F(r3)
		li        r31, 0x30
		stb       r12, 0x70(r3)
		li        r12, 0x31
		stb       r25, 0x71(r3)
		stb       r26, 0x72(r3)
		stb       r27, 0x73(r3)
		stb       r28, 0x74(r3)
		stb       r29, 0x75(r3)
		stb       r30, 0x76(r3)
		stb       r31, 0x77(r3)
		stb       r12, 0x78(r3)
		stb       r11, 0x79(r3)
		addi      r11, r1, 0x30+pre_back_chain
		stb       r10, 0x7A(r3)
		stb       r9, 0x30(r3)
		li        r9, 0x39
		stb       r8, 0x31(r3)
		li        r8, 0x3A
		stb       r7, 0x32(r3)
		li        r7, 0x3B
		stb       r6, 0x33(r3)
		li        r6, 0x3C
		stb       r5, 0x34(r3)
		li        r5, 0x3D
		stb       r9, 0x35(r3)
		stb       r8, 0x36(r3)
		stb       r7, 0x37(r3)
		stb       r6, 0x38(r3)
		stb       r5, 0x39(r3)
		stb       r4, 0x2B(r3)
		stb       r0, 0x2F(r3)
		bl        _restgpr_25
		lwz       r0, 0x30+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x30
		blr


QEncode:
.set back_chain, -0x40
.set var_38, -0x38
.set var_36, -0x36
.set pre_back_chain,  0
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x40+sender_lr(r1)
		addi      r11, r1, 0x40+pre_back_chain
		bl        _savegpr_21
		cmpwi     r3, 0
		li        r27, 0
		bne       loc_8002FADC
		li        r3, -3
		b         loc_8002FDC8
loc_8002FADC:
		cmpwi     r6, 0
		bne       loc_8002FAEC
		li        r3, -3
		b         loc_8002FDC8
loc_8002FAEC:
		cmpwi     r7, 0
		bne       loc_8002FAFC
		li        r3, -8
		b         loc_8002FDC8
loc_8002FAFC:
		cmpwi     r8, 0
		beq       loc_8002FB0C
		li        r0, 0
		stw       r0, 0(r8)
loc_8002FB0C:
		cmpwi     r5, 0
		beq       loc_8002FB1C
		li        r0, 0
		stw       r0, 0(r5)
loc_8002FB1C:
		li        r26, 0
		li        r29, 0
		li        r28, 0
		li        r31, 0x3D
		lis       r12, 0x6666
		li        r11, 0xD
		li        r0, 0xA
		lis       r10, -0x8000
		b         loc_8002FDA4
loc_8002FB40:
		lbz       r21, 0(r6)
		li        r25, 0
		extsb     r22, r21
		cmpwi     r22, 0x21
		blt       loc_8002FB74
		cmpwi     r22, 0x7E
		bgt       loc_8002FB74
		cmpwi     r22, 0x3D
		beq       loc_8002FB74
		stb       r21, 0x40+var_38(r1)
		li        r23, 1
		li        r24, 1
		b         loc_8002FC74
loc_8002FB74:
		addi      r22, r28, 1
		cmplw     r22, r7
		bge       loc_8002FBB0
		extsb     r22, r21
		cmpwi     r22, 0xD
		bne       loc_8002FBB0
		lbz       r22, 1(r6)
		cmpwi     r22, 0xA
		bne       loc_8002FBB0
		stb       r21, 0x40+var_38(r1)
		li        r23, 2
		li        r24, 1
		lbz       r22, 1(r6)
		stb       r22, 0x40+var_38+1(r1)
		b         loc_8002FC74
loc_8002FBB0:
		stb       r31, 0x40+var_38(r1)
		lbz       r22, 0(r6)
		srawi     r30, r22, 4
		cmpwi     r30, 0xA
		blt       loc_8002FBEC
		addi      r22, r12, 0x6667 
		mulhw     r22, r22, r30
		srawi     r22, r22, 2
		srwi      r23, r22, 31
		add       r22, r22, r23
		mulli     r22, r22, 0xA
		subf      r22, r22, r30
		addi      r22, r22, 0x41
		stb       r22, 0x40+var_38+1(r1)
		b         loc_8002FC10
loc_8002FBEC:
		addi      r22, r12, 0x6667 
		mulhw     r22, r22, r30
		srawi     r22, r22, 2
		srwi      r23, r22, 31
		add       r22, r22, r23
		mulli     r22, r22, 0xA
		subf      r22, r22, r30
		addi      r22, r22, 0x30
		stb       r22, 0x40+var_38+1(r1)
loc_8002FC10:
		lbz       r22, 0(r6)
		clrlwi    r30, r22, 28
		cmpwi     r30, 0xA
		blt       loc_8002FC48
		addi      r22, r12, 0x6667 
		mulhw     r22, r22, r30
		srawi     r22, r22, 2
		srwi      r23, r22, 31
		add       r22, r22, r23
		mulli     r22, r22, 0xA
		subf      r22, r22, r30
		addi      r22, r22, 0x41
		stb       r22, 0x40+var_36(r1)
		b         loc_8002FC6C
loc_8002FC48:
		addi      r22, r12, 0x6667 
		mulhw     r22, r22, r30
		srawi     r22, r22, 2
		srwi      r23, r22, 31
		add       r22, r22, r23
		mulli     r22, r22, 0xA
		subf      r22, r22, r30
		addi      r22, r22, 0x30
		stb       r22, 0x40+var_36(r1)
loc_8002FC6C:
		li        r23, 1
		li        r24, 3
loc_8002FC74:
		cmpwi     r9, 0
		bne       loc_8002FC90
		add       r22, r26, r24
		cmpwi     r22, 0x4B
		blt       loc_8002FC90
		li        r25, 1
		addi      r24, r24, 3
loc_8002FC90:
		add       r22, r29, r24
		cmplw     r22, r4
		blt       loc_8002FCA4
		li        r27, -8
		b         loc_8002FDAC
loc_8002FCA4:
		cmpwi     r25, 0
		add       r29, r29, r24
		beq       loc_8002FCC8
		stb       r31, 0(r3)
		li        r26, 0
		addi      r24, r24, -3
		stb       r11, 1(r3)
		stb       r0, 2(r3)
		addi      r3, r3, 3
loc_8002FCC8:
		cmpwi     cr1, r24, 0
		add       r26, r26, r24
		li        r25, 0
		ble       cr1, loc_8002FD9C
		cmpwi     r24, 8
		addi      r21, r24, -8
		ble       loc_8002FD6C
		li        r30, 0
		blt       cr1, loc_8002FCFC
		addi      r22, r10, -2 
		cmpw      r24, r22
		bgt       loc_8002FCFC
		li        r30, 1
loc_8002FCFC:
		cmpwi     r30, 0
		beq       loc_8002FD6C
		addi      r22, r21, 7
		addi      r30, r1, 0x40+var_38
		srwi      r22, r22, 3
		mtctr     r22
		cmpwi     r21, 0
		ble       loc_8002FD6C
loc_8002FD1C:
		lbz       r22, 0(r30)
		addi      r25, r25, 8
		stb       r22, 0(r3)
		lbz       r22, 1(r30)
		stb       r22, 1(r3)
		lbz       r22, 2(r30)
		stb       r22, 2(r3)
		lbz       r22, 3(r30)
		stb       r22, 3(r3)
		lbz       r22, 4(r30)
		stb       r22, 4(r3)
		lbz       r22, 5(r30)
		stb       r22, 5(r3)
		lbz       r22, 6(r30)
		stb       r22, 6(r3)
		lbz       r22, 7(r30)
		addi      r30, r30, 8
		stb       r22, 7(r3)
		addi      r3, r3, 8
		bdnz      loc_8002FD1C
loc_8002FD6C:
		addi      r21, r1, 0x40+var_38
		subf      r30, r25, r24
		add       r21, r21, r25
		mtctr     r30
		cmpw      r25, r24
		bge       loc_8002FD9C
loc_8002FD84:
		lbz       r22, 0(r21)
		addi      r21, r21, 1
		addi      r25, r25, 1
		stb       r22, 0(r3)
		addi      r3, r3, 1
		bdnz      loc_8002FD84
loc_8002FD9C:
		add       r28, r28, r23
		add       r6, r6, r23
loc_8002FDA4:
		cmplw     r28, r7
		blt       loc_8002FB40
loc_8002FDAC:
		cmpwi     r8, 0
		beq       loc_8002FDB8
		stw       r28, 0(r8)
loc_8002FDB8:
		cmpwi     r5, 0
		beq       loc_8002FDC4
		stw       r29, 0(r5)
loc_8002FDC4:
		mr        r3, r27
loc_8002FDC8:
		addi      r11, r1, 0x40+pre_back_chain
		bl        _restgpr_21
		lwz       r0, 0x40+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x40
		blr


.global NWC24EncodeQuotedPrintable
NWC24EncodeQuotedPrintable:
		li        r9, 0
		b         QEncode


.global NWC24GetMIMETypeStr
NWC24GetMIMETypeStr:
		lis       r4, MIMETypeConv@ha
		li        r0, 0xA
		addi      r4, r4, MIMETypeConv@l
		li        r5, 0
		mtctr     r0
loc_8002FDFC:
		lwz       r0, 0(r4)
		cmpw      r3, r0
		bne       loc_8002FE1C
		lis       r3, MIMETypeStr@ha
		slwi      r0, r5, 2
		addi      r3, r3, MIMETypeStr@l
		lwzx      r3, r3, r0
		blr
loc_8002FE1C:
		addi      r4, r4, 4
		addi      r5, r5, 1
		bdnz      loc_8002FDFC
		li        r3, 0
		blr


.global NWC24iGetMIMETypeSuffix
NWC24iGetMIMETypeSuffix:
		lis       r4, MIMETypeConv@ha
		li        r0, 0xA
		addi      r4, r4, MIMETypeConv@l
		li        r5, 0
		mtctr     r0
loc_8002FE44:
		lwz       r0, 0(r4)
		cmpw      r3, r0
		bne       loc_8002FE64
		lis       r3, MIMETypeSuffix@ha
		slwi      r0, r5, 2
		addi      r3, r3, MIMETypeSuffix@l
		lwzx      r3, r3, r0
		blr
loc_8002FE64:
		addi      r4, r4, 4
		addi      r5, r5, 1
		bdnz      loc_8002FE44
		li        r3, 0
		blr


.global NWC24GetCharsetStr
NWC24GetCharsetStr:
		lis       r4, CharsetConv@ha
		li        r0, 0x12
		addi      r4, r4, CharsetConv@l
		li        r5, 0
		mtctr     r0
loc_8002FE8C:
		lwz       r0, 0(r4)
		cmpw      r3, r0
		bne       loc_8002FEAC
		lis       r3, CharsetStr@ha
		slwi      r0, r5, 2
		addi      r3, r3, CharsetStr@l
		lwzx      r3, r3, r0
		blr
loc_8002FEAC:
		addi      r4, r4, 4
		addi      r5, r5, 1
		bdnz      loc_8002FE8C
		li        r3, 0
		blr


.global NWC24GetEncodingStr
NWC24GetEncodingStr:
		lis       r4, EncodingConv@ha
		li        r0, 4
		addi      r4, r4, EncodingConv@l
		li        r5, 0
		mtctr     r0
loc_8002FED4:
		lwz       r0, 0(r4)
		cmpw      r3, r0
		bne       loc_8002FEF4
		lis       r3, EncodingStr@ha
		slwi      r0, r5, 2
		addi      r3, r3, EncodingStr@l
		lwzx      r3, r3, r0
		blr
loc_8002FEF4:
		addi      r4, r4, 4
		addi      r5, r5, 1
		bdnz      loc_8002FED4
		li        r3, 0
		blr


.global NWC24CommitMsg
NWC24CommitMsg:
.set back_chain, -0x20
.set var_18, -0x18
.set var_14, -0x14
.set var_8, -8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x20+sender_lr(r1)
		stw       r31, 0x20+var_4(r1)
		li        r31, 0
		stw       r30, 0x20+var_8(r1)
		mr        r30, r3
		bl        NWC24IsMsgLibOpened
		cmpwi     r3, 0
		bne       loc_8002FF44
		bl        NWC24IsMsgLibOpenedByTool
		cmpwi     r3, 0
		bne       loc_8002FF44
		li        r3, -9
		b         loc_8002FFB8
loc_8002FF44:
		lwz       r3, 4(r30)
		rlwinm.   r0, r3, 0,23,23
		beq       loc_8002FF58
		rlwinm.   r0, r3, 0,22,22
		beq       loc_8002FF60
loc_8002FF58:
		li        r3, -7
		b         loc_8002FFB8
loc_8002FF60:
		lis       r9, LoopBackEnable@h
		ori       r9, r9, LoopBackEnable@l
		lwz       r0, 0(r9)
		cmpwi     r0, 0
		beq       loc_8002FFAC
		clrlwi.   r0, r3, 31
		beq       loc_8002FFAC
		addi      r3, r1, 0x20+var_18
		bl        NWC24GetMyUserId
		lbz       r0, 0xC8(r30)
		cmplwi    r0, 1
		bne       loc_8002FFAC
		lwz       r4, 0x88(r30)
		lwz       r0, 0x20+var_18(r1)
		lwz       r5, 0x8C(r30)
		lwz       r3, 0x20+var_14(r1)
		xor       r0, r4, r0
		xor       r3, r5, r3
		or.       r0, r3, r0
		bne       loc_8002FFAC
		li        r31, 1
loc_8002FFAC:
		mr        r3, r30
		mr        r4, r31
		bl        NWC24CommitMsgInternal
loc_8002FFB8:
		lwz       r0, 0x20+sender_lr(r1)
		lwz       r31, 0x20+var_4(r1)
		lwz       r30, 0x20+var_8(r1)
		mtlr      r0
		addi      r1, r1, 0x20
		blr


NWC24CommitMsgInternal:
.set back_chain, -0x120
.set var_118, -0x118
.set var_114, -0x114
.set var_110, -0x110
.set var_10C, -0x10C
.set var_108, -0x108
.set var_104, -0x104
.set var_100, -0x100
.set var_FC, -0xFC
.set var_F8, -0xF8
.set var_F4, -0xF4
.set var_F0, -0xF0
.set var_EC, -0xEC
.set var_E8, -0xE8
.set var_C8, -0xC8
.set pre_back_chain,  0
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x120+sender_lr(r1)
		addi      r11, r1, 0x120+pre_back_chain
		bl        _savegpr_23
		lis       r31, _3490@ha
		mr        r25, r3
		mr        r26, r4
		addi      r3, r1, 0x120+var_100
		addi      r31, r31, _3490@l # "Message-Id:
		bl        NWC24Data_Init
		addi      r3, r1, 0x120+var_108
		bl        NWC24Data_Init
		addi      r23, r1, 0x120+var_F8
		li        r24, 0
loc_8003000C:
		mr        r3, r23
		bl        NWC24Data_Init
		addi      r24, r24, 1
		addi      r23, r23, 8
		cmpwi     r24, 2
		blt       loc_8003000C
		addi      r3, r1, 0x120+var_C8
		li        r4, 0
		li        r5, 0x9C
		bl        Mail_memset
		li        r3, 0
		bl        NWC24iSetErrorCode
		mr        r3, r25
		bl        CorrectHeadersForMBDelay
		cmpwi     r3, 0
		mr        r27, r3
		bne       loc_80030C80
		mr        r3, r25
		bl        CheckMsgObject
		cmpwi     r3, 0
		mr        r27, r3
		bne       loc_80030C80
		mr        r3, r25
		mr        r4, r26
		bl        CheckMsgBoxSpace
		cmpwi     r3, 0
		mr        r27, r3
		bne       loc_80030C80
		mr        r3, r26
		addi      r4, r1, 0x120+var_C8
		addi      r5, r1, 0x120+var_114
		bl        NWC24iMBoxOpenNewMsg
		cmpwi     r3, 0
		beq       loc_8003009C
		mr        r27, r3
		b         loc_80030C80
loc_8003009C:
		lwz       r3, 0x120+var_114(r1)
		li        r0, 0
		cmpwi     r26, 0
		addi      r28, r1, 0x120+var_C8
		stw       r3, 0(r25)
		stw       r0, 8(r25)
		lis       r9, m_pFile@h
		ori       r9, r9, m_pFile@l
		stw       r28, 0(r9)
		bne       loc_8003015C
		mr        r3, r25
		bl        WriteSMTP_MAILFROM
		cmpwi     r3, 0
		mr        r23, r3
		beq       loc_800300E0
		mr        r3, r28
		bl        NWC24FClose
		mr        r27, r23
		b         loc_80030BA4
loc_800300E0:
		mr        r3, r25
		bl        WriteSMTP_RCPTTO
		cmpwi     r3, 0
		mr        r23, r3
		beq       loc_80030104
		mr        r3, r28
		bl        NWC24FClose
		mr        r27, r23
		b         loc_80030BA4
loc_80030104:
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r23, 0(r9)
		lis       r4, _3489@h
		ori       r4, r4, _3489@l

		mr        r3, r23
		bl        Mail_strcpy
		mr        r3, r23
		bl        Mail_strlen
		lis       r9, m_pFile@h
		ori       r9, r9, m_pFile@l
		lwz       r5, 0(r9)
		mr        r4, r3
		mr        r3, r23
		bl        NWC24FWrite
		cmpwi     r3, 0
		mr        r28, r3
		bne       loc_80030144
		lwz       r4, 8(r25)
		addi      r0, r4, 6
		stw       r0, 8(r25)
loc_80030144:
		cmpwi     r3, 0
		beq       loc_8003015C
		addi      r3, r1, 0x120+var_C8
		bl        NWC24FClose
		mr        r27, r28
		b         loc_80030BA4
loc_8003015C:
		mr        r3, r25
		bl        WriteDateField
		cmpwi     r3, 0
		mr        r23, r3
		beq       loc_80030180
		addi      r3, r1, 0x120+var_C8
		bl        NWC24FClose
		mr        r27, r23
		b         loc_80030BA4
loc_80030180:
		mr        r3, r25
		bl        WriteFromField
		cmpwi     r3, 0
		mr        r23, r3
		beq       loc_800301A4
		addi      r3, r1, 0x120+var_C8
		bl        NWC24FClose
		mr        r27, r23
		b         loc_80030BA4
loc_800301A4:
		mr        r3, r25
		bl        WriteToField
		cmpwi     r3, 0
		mr        r23, r3
		beq       loc_800301C8
		addi      r3, r1, 0x120+var_C8
		bl        NWC24FClose
		mr        r27, r23
		b         loc_80030BA4
loc_800301C8:
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r29, 0(r9)
		bl        NWC24GetAccountDomain
		mr        r28, r3
		addi      r3, r1, 0x120+var_110
		bl        NWC24GetMyUserId
		mr        r3, r29
		li        r4, 0
		li        r5, 0x400
		bl        Mail_memset
		mr        r3, r29
		addi      r4, r31, 0
		bl        Mail_strcpy
		addi      r3, r1, 0x120+var_E8
		li        r4, 0
		li        r5, 0x20
		bl        Mail_memset
		lwz       r6, 0x120+var_110(r1)
		addi      r3, r1, 0x120+var_E8
		lwz       r7, 0x120+var_10C(r1)
		lis       r4, _3491@h
		ori       r4, r4, _3491@l

		lwz       r5, 0(r25)
		lwz       r8, 0x28(r25)
		crclr     4*cr1+eq
		bl        Mail_sprintf
		mr        r3, r29
		addi      r4, r1, 0x120+var_E8
		bl        Mail_strcat
		mr        r3, r29
		mr        r4, r28
		bl        Mail_strcat
		mr        r3, r29
		lis       r4, _3492@h
		ori       r4, r4, _3492@l

		bl        Mail_strcat
		mr        r3, r29
		bl        Mail_strlen
		mr        r28, r3
		lis       r9, m_pFile@h
		ori       r9, r9, m_pFile@l
		lwz       r5, 0(r9)
		mr        r3, r29
		mr        r4, r28
		bl        NWC24FWrite
		cmpwi     r3, 0
		mr        r29, r3
		bne       loc_80030280
		lwz       r0, 8(r25)
		add       r0, r0, r28
		stw       r0, 8(r25)
loc_80030280:
		cmpwi     r3, 0
		beq       loc_80030298
		addi      r3, r1, 0x120+var_C8
		bl        NWC24FClose
		mr        r27, r29
		b         loc_80030BA4
loc_80030298:
		lwz       r3, 8(r25)
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r29, 0(r9)
		addi      r0, r3, 9
		stw       r0, 0x120+var_100(r1)
		lwz       r0, 0x44(r25)
		cmpwi     r0, 0
		bne       loc_800302BC
		li        r3, -5
		b         loc_8003032C
loc_800302BC:
		mr        r3, r29
		li        r4, 0
		li        r5, 0x400
		bl        Mail_memset
		mr        r3, r29
		lis       r4, _3493@h
		ori       r4, r4, _3493@l

		bl        Mail_strcpy
		lwz       r4, 0x40(r25)
		mr        r3, r29
		lwz       r5, 0x44(r25)
		bl        Mail_strncat
		mr        r3, r29
		lis       r4, _3494@h
		ori       r4, r4, _3494@l

		li        r5, 3
		bl        Mail_strncat
		mr        r3, r29
		li        r4, 0x400
		bl        STD_strnlen
		mr        r28, r3
		lis       r9, m_pFile@h
		ori       r9, r9, m_pFile@l
		lwz       r5, 0(r9)
		mr        r3, r29
		mr        r4, r28
		bl        NWC24FWrite
		cmpwi     r3, 0
		bne       loc_8003032C
		lwz       r0, 8(r25)
		add       r0, r0, r28
		stw       r0, 8(r25)
loc_8003032C:
		cmpwi     r3, 0
		mr        r23, r3
		bne       loc_80030350
		lwz       r3, 0x120+var_100(r1)
		lwz       r0, 8(r25)
		subf      r3, r3, r0
		addi      r0, r3, -2
		stw       r0, 0x120+var_FC(r1)
		b         loc_80030360
loc_80030350:
		cmpwi     r3, -5
		bne       loc_80030360
		li        r23, 0
		stw       r23, 0x120+var_100(r1)
loc_80030360:
		cmpwi     r23, 0
		beq       loc_80030378
		addi      r3, r1, 0x120+var_C8
		bl        NWC24FClose
		mr        r27, r23
		b         loc_80030BA4
loc_80030378:
		lwz       r0, 4(r25)
		clrlwi.   r0, r0, 31
		beq       loc_800307B0
		mr        r3, r25
		bl        WriteXWiiAppIdField
		cmpwi     r3, 0
		mr        r23, r3
		beq       loc_800303A8
		addi      r3, r1, 0x120+var_C8
		bl        NWC24FClose
		mr        r27, r23
		b         loc_80030BA4
loc_800303A8:
		lwz       r0, 0x18(r25)
		cmpwi     r0, 0
		bne       loc_800303BC
		li        r28, 0
		b         loc_80030418
loc_800303BC:
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r23, 0(r9)
		li        r4, 0
		li        r5, 0x400
		mr        r3, r23
		bl        Mail_memset
		lwz       r5, 0x18(r25)
		mr        r3, r23
		lis       r4, _3495@h
		ori       r4, r4, _3495@l

		crclr     4*cr1+eq
		bl        Mail_sprintf
		mr        r3, r23
		bl        Mail_strlen
		mr        r28, r3
		lis       r9, m_pFile@h
		ori       r9, r9, m_pFile@l
		lwz       r5, 0(r9)
		mr        r3, r23
		mr        r4, r28
		bl        NWC24FWrite
		cmpwi     r3, 0
		bne       loc_80030414
		lwz       r0, 8(r25)
		add       r0, r0, r28
		stw       r0, 8(r25)
loc_80030414:
		mr        r28, r3
loc_80030418:
		cmpwi     r28, 0
		beq       loc_80030430
		addi      r3, r1, 0x120+var_C8
		bl        NWC24FClose
		mr        r27, r28
		b         loc_80030BA4
loc_80030430:
		lwz       r0, 0x14(r25)
		cmpwi     r0, 0
		bne       loc_80030444
		li        r28, 0
		b         loc_800304A0
loc_80030444:
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r23, 0(r9)
		li        r4, 0
		li        r5, 0x400
		mr        r3, r23
		bl        Mail_memset
		lwz       r5, 0x14(r25)
		mr        r3, r23
		lis       r4, _3496@h
		ori       r4, r4, _3496@l

		crclr     4*cr1+eq
		bl        Mail_sprintf
		mr        r3, r23
		bl        Mail_strlen
		mr        r28, r3
		lis       r9, m_pFile@h
		ori       r9, r9, m_pFile@l
		lwz       r5, 0(r9)
		mr        r3, r23
		mr        r4, r28
		bl        NWC24FWrite
		cmpwi     r3, 0
		bne       loc_8003049C
		lwz       r0, 8(r25)
		add       r0, r0, r28
		stw       r0, 8(r25)
loc_8003049C:
		mr        r28, r3
loc_800304A0:
		cmpwi     r28, 0
		beq       loc_800304B8
		addi      r3, r1, 0x120+var_C8
		bl        NWC24FClose
		mr        r27, r28
		b         loc_80030BA4
loc_800304B8:
		lwz       r0, 4(r25)
		rlwinm.   r0, r0, 0,18,18
		bne       loc_800304CC
		li        r28, 0
		b         loc_80030528
loc_800304CC:
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r23, 0(r9)
		li        r4, 0
		li        r5, 0x400
		mr        r3, r23
		bl        Mail_memset
		lwz       r5, 0xEC(r25)
		mr        r3, r23
		lis       r4, _3497@h
		ori       r4, r4, _3497@l

		crclr     4*cr1+eq
		bl        Mail_sprintf
		mr        r3, r23
		bl        Mail_strlen
		mr        r28, r3
		lis       r9, m_pFile@h
		ori       r9, r9, m_pFile@l
		lwz       r5, 0(r9)
		mr        r3, r23
		mr        r4, r28
		bl        NWC24FWrite
		cmpwi     r3, 0
		bne       loc_80030524
		lwz       r0, 8(r25)
		add       r0, r0, r28
		stw       r0, 8(r25)
loc_80030524:
		mr        r28, r3
loc_80030528:
		cmpwi     r28, 0
		beq       loc_80030540
		addi      r3, r1, 0x120+var_C8
		bl        NWC24FClose
		mr        r27, r28
		b         loc_80030BA4
loc_80030540:
		mr        r3, r25
		bl        WriteXWiiAltNameField
		cmpwi     r3, 0
		mr        r23, r3
		beq       loc_80030564
		addi      r3, r1, 0x120+var_C8
		bl        NWC24FClose
		mr        r27, r23
		b         loc_80030BA4
loc_80030564:
		mr        r3, r25
		bl        WriteXWiiFaceField
		cmpwi     r3, 0
		mr        r23, r3
		beq       loc_80030588
		addi      r3, r1, 0x120+var_C8
		bl        NWC24FClose
		mr        r27, r23
		b         loc_80030BA4
loc_80030588:
		lwz       r3, 0xF0(r25)
		cmpwi     r3, 0
		beq       loc_800305A0
		addis     r0, r3, -0x8000
		cmplwi    r0, 0
		bne       loc_800305A8
loc_800305A0:
		li        r28, 0
		b         loc_80030604
loc_800305A8:
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r23, 0(r9)
		li        r4, 0
		li        r5, 0x400
		mr        r3, r23
		bl        Mail_memset
		lwz       r5, 0xF0(r25)
		mr        r3, r23
		lis       r4, _3498@h
		ori       r4, r4, _3498@l

		crclr     4*cr1+eq
		bl        Mail_sprintf
		mr        r3, r23
		bl        Mail_strlen
		mr        r28, r3
		lis       r9, m_pFile@h
		ori       r9, r9, m_pFile@l
		lwz       r5, 0(r9)
		mr        r3, r23
		mr        r4, r28
		bl        NWC24FWrite
		cmpwi     r3, 0
		bne       loc_80030600
		lwz       r0, 8(r25)
		add       r0, r0, r28
		stw       r0, 8(r25)
loc_80030600:
		mr        r28, r3
loc_80030604:
		cmpwi     r28, 0
		beq       loc_8003061C
		addi      r3, r1, 0x120+var_C8
		bl        NWC24FClose
		mr        r27, r28
		b         loc_80030BA4
loc_8003061C:
		lwz       r0, 0xCC(r25)
		cmpwi     r0, 0
		beq       loc_800307B0
		clrrwi.   r0, r0, 31
		bne       loc_80030638
		li        r28, 0
		b         loc_80030680
loc_80030638:
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r23, 0(r9)
		li        r4, 0
		li        r5, 0x400
		mr        r3, r23
		bl        Mail_memset
		mr        r3, r23
		lis       r4, _3499@h
		ori       r4, r4, _3499@l

		bl        Mail_strcpy
		lis       r9, m_pFile@h
		ori       r9, r9, m_pFile@l
		lwz       r5, 0(r9)
		mr        r3, r23
		li        r4, 0x15
		bl        NWC24FWrite
		cmpwi     r3, 0
		bne       loc_8003067C
		lwz       r4, 8(r25)
		addi      r0, r4, 0x15
		stw       r0, 8(r25)
loc_8003067C:
		mr        r28, r3
loc_80030680:
		cmpwi     r28, 0
		beq       loc_80030698
		addi      r3, r1, 0x120+var_C8
		bl        NWC24FClose
		mr        r27, r28
		b         loc_80030BA4
loc_80030698:
		lwz       r0, 0xCC(r25)
		clrlwi.   r23, r0, 16
		bne       loc_800306AC
		li        r28, 0
		b         loc_8003070C
loc_800306AC:
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r24, 0(r9)
		li        r4, 0
		li        r5, 0x400
		mr        r3, r24
		bl        Mail_memset
		mr        r3, r24
		mr        r5, r23
		lis       r4, _3500@h
		ori       r4, r4, _3500@l

		crclr     4*cr1+eq
		bl        Mail_sprintf
		mr        r3, r24
		li        r4, 0x400
		bl        STD_strnlen
		mr        r28, r3
		lis       r9, m_pFile@h
		ori       r9, r9, m_pFile@l
		lwz       r5, 0(r9)
		mr        r3, r24
		mr        r4, r28
		bl        NWC24FWrite
		cmpwi     r3, 0
		bne       loc_80030708
		lwz       r0, 8(r25)
		add       r0, r0, r28
		stw       r0, 8(r25)
loc_80030708:
		mr        r28, r3
loc_8003070C:
		cmpwi     r28, 0
		beq       loc_80030724
		addi      r3, r1, 0x120+var_C8
		bl        NWC24FClose
		mr        r27, r28
		b         loc_80030BA4
loc_80030724:
		lwz       r0, 0xCC(r25)
		rlwinm.   r23, r0, 0,8,15
		bne       loc_80030738
		li        r28, 0
		b         loc_80030798
loc_80030738:
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r24, 0(r9)
		li        r4, 0
		li        r5, 0x400
		mr        r3, r24
		bl        Mail_memset
		mr        r3, r24
		lis       r4, _3501@h
		ori       r4, r4, _3501@l

		srwi      r5, r23, 16
		crclr     4*cr1+eq
		bl        Mail_sprintf
		mr        r3, r24
		li        r4, 0x400
		bl        STD_strnlen
		mr        r28, r3
		lis       r9, m_pFile@h
		ori       r9, r9, m_pFile@l
		lwz       r5, 0(r9)
		mr        r3, r24
		mr        r4, r28
		bl        NWC24FWrite
		cmpwi     r3, 0
		bne       loc_80030794
		lwz       r0, 8(r25)
		add       r0, r0, r28
		stw       r0, 8(r25)
loc_80030794:
		mr        r28, r3
loc_80030798:
		cmpwi     r28, 0
		beq       loc_800307B0
		addi      r3, r1, 0x120+var_C8
		bl        NWC24FClose
		mr        r27, r28
		b         loc_80030BA4
loc_800307B0:
		lwz       r4, 0xD4(r25)
		cmpwi     r4, 0
		bne       loc_800307C4
		li        r28, 0
		b         loc_800307EC
loc_800307C4:
		lwz       r3, 0xD0(r25)
		lis       r9, m_pFile@h
		ori       r9, r9, m_pFile@l
		lwz       r5, 0(r9)
		bl        NWC24FWrite
		cmpwi     r3, 0
		bne       loc_800307E8
		lwz       r4, 8(r25)
		lwz       r0, 0xD4(r25)
		add       r0, r4, r0
		stw       r0, 8(r25)
loc_800307E8:
		mr        r28, r3
loc_800307EC:
		cmpwi     r28, 0
		beq       loc_80030804
		addi      r3, r1, 0x120+var_C8
		bl        NWC24FClose
		mr        r27, r28
		b         loc_80030BA4
loc_80030804:
		lis       r28, MultiPartDivider@ha
		li        r4, 0
		addi      r3, r28, MultiPartDivider@l
		li        r5, 0x28
		bl        Mail_memset
		lwz       r5, 0x28(r25)
		addi      r3, r28, MultiPartDivider@l
		lwz       r6, 0(r25)
		lis       r4, _3502@h
		ori       r4, r4, _3502@l

		crclr     4*cr1+eq
		bl        Mail_sprintf
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r23, 0(r9)
		li        r4, 0
		li        r5, 0x400
		mr        r3, r23
		bl        Mail_memset
		mr        r3, r23
		lis       r4, _3503@h
		ori       r4, r4, _3503@l

		bl        Mail_strcpy
		lwz       r0, 4(r25)
		rlwinm.   r0, r0, 0,15,15
		beq       loc_80030880
		mr        r3, r23
		lis       r4, _3504@h
		ori       r4, r4, _3504@l

		bl        Mail_strcat
		mr        r3, r23
		addi      r4, r28, MultiPartDivider@l
		bl        Mail_strcat
		mr        r3, r23
		lis       r4, _3505@h
		ori       r4, r4, _3505@l

		bl        Mail_strcat
loc_80030880:
		mr        r3, r23
		bl        Mail_strlen
		mr        r28, r3
		lis       r9, m_pFile@h
		ori       r9, r9, m_pFile@l
		lwz       r5, 0(r9)
		mr        r3, r23
		mr        r4, r28
		bl        NWC24FWrite
		cmpwi     r3, 0
		mr        r29, r3
		bne       loc_800308B4
		lwz       r0, 8(r25)
		add       r0, r0, r28
		stw       r0, 8(r25)
loc_800308B4:
		cmpwi     r3, 0
		beq       loc_800308CC
		addi      r3, r1, 0x120+var_C8
		bl        NWC24FClose
		mr        r27, r29
		b         loc_80030BA4
loc_800308CC:
		lwz       r0, 4(r25)
		rlwinm.   r0, r0, 0,15,15
		beq       loc_80030964
		lwz       r0, 8(r25)
		li        r4, 0
		li        r5, 0x400
		stw       r0, 0x10(r25)
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r23, 0(r9)
		mr        r3, r23
		bl        Mail_memset
		lis       r5, MultiPartDivider@ha
		mr        r3, r23
		addi      r5, r5, MultiPartDivider@l
		lis       r4, _3506@h
		ori       r4, r4, _3506@l

		crclr     4*cr1+eq
		bl        Mail_sprintf
		mr        r3, r23
		lis       r4, _3507@h
		ori       r4, r4, _3507@l

		bl        Mail_strcat
		mr        r3, r23
		bl        Mail_strlen
		mr        r28, r3
		lis       r9, m_pFile@h
		ori       r9, r9, m_pFile@l
		lwz       r5, 0(r9)
		mr        r3, r23
		mr        r4, r28
		bl        NWC24FWrite
		cmpwi     r3, 0
		mr        r29, r3
		bne       loc_8003094C
		lwz       r0, 8(r25)
		add       r0, r0, r28
		stw       r0, 8(r25)
loc_8003094C:
		cmpwi     r3, 0
		beq       loc_80030964
		addi      r3, r1, 0x120+var_C8
		bl        NWC24FClose
		mr        r27, r29
		b         loc_80030BA4
loc_80030964:
		mr        r3, r25
		bl        WriteContentTypeField
		cmpwi     r3, 0
		mr        r23, r3
		beq       loc_80030988
		addi      r3, r1, 0x120+var_C8
		bl        NWC24FClose
		mr        r27, r23
		b         loc_80030BA4
loc_80030988:
		lwz       r0, 4(r25)
		rlwinm.   r0, r0, 0,15,15
		bne       loc_8003099C
		lwz       r0, 8(r25)
		stw       r0, 0x10(r25)
loc_8003099C:
		lwz       r0, 8(r25)
		mr        r3, r25
		stw       r0, 0x120+var_108(r1)
		bl        WritePlainText
		cmpwi     r3, -5
		mr        r28, r3
		bne       loc_800309BC
		li        r28, 0
loc_800309BC:
		cmpwi     r28, 0
		beq       loc_800309D4
		addi      r3, r1, 0x120+var_C8
		bl        NWC24FClose
		mr        r27, r28
		b         loc_80030BA4
loc_800309D4:
		lwz       r3, 0x120+var_108(r1)
		mr        r29, r25
		lwz       r0, 8(r25)
		addi      r30, r1, 0x120+var_F8
		li        r28, 0
		lis       r31, MultiPartDivider@ha
		subf      r0, r3, r0
		stw       r0, 0x120+var_104(r1)
		b         loc_80030B98
loc_800309F8:
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r23, 0(r9)
		li        r4, 0
		li        r5, 0x400
		mr        r3, r23
		bl        Mail_memset
		mr        r3, r23
		addi      r5, r31, MultiPartDivider@l
		lis       r4, _3506@h
		ori       r4, r4, _3506@l

		crclr     4*cr1+eq
		bl        Mail_sprintf
		mr        r3, r23
		lis       r4, _3507@h
		ori       r4, r4, _3507@l

		bl        Mail_strcat
		mr        r3, r23
		bl        Mail_strlen
		mr        r24, r3
		lis       r9, m_pFile@h
		ori       r9, r9, m_pFile@l
		lwz       r5, 0(r9)
		mr        r3, r23
		mr        r4, r24
		bl        NWC24FWrite
		cmpwi     r3, 0
		mr        r23, r3
		bne       loc_80030A60
		lwz       r0, 8(r25)
		add       r0, r0, r24
		stw       r0, 8(r25)
loc_80030A60:
		cmpwi     r3, 0
		beq       loc_80030A78
		addi      r3, r1, 0x120+var_C8
		bl        NWC24FClose
		mr        r27, r23
		b         loc_80030BA4
loc_80030A78:
		mr        r3, r25
		mr        r4, r28
		bl        WriteMIMEAttachHeader
		cmpwi     r3, 0
		mr        r23, r3
		beq       loc_80030AA0
		addi      r3, r1, 0x120+var_C8
		bl        NWC24FClose
		mr        r27, r23
		b         loc_80030BA4
loc_80030AA0:
		lwz       r0, 8(r25)
		addi      r5, r1, 0x120+var_118
		stw       r0, 0(r30)
		lwz       r3, 0x68(r29)
		lwz       r4, 0x6C(r29)
		bl        WriteBase64Data
		cmpwi     r3, 0
		mr        r23, r3
		bne       loc_80030AD4
		lwz       r4, 8(r25)
		lwz       r0, 0x120+var_118(r1)
		add       r0, r4, r0
		stw       r0, 8(r25)
loc_80030AD4:
		cmpwi     r3, 0
		beq       loc_80030AEC
		addi      r3, r1, 0x120+var_C8
		bl        NWC24FClose
		mr        r27, r23
		b         loc_80030BA4
loc_80030AEC:
		lwz       r3, 0(r30)
		lwz       r0, 8(r25)
		subf      r0, r3, r0
		stw       r0, 4(r30)
		lbz       r3, 0xC9(r25)
		addi      r0, r3, -1
		cmpw      r28, r0
		bne       loc_80030B8C
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r24, 0(r9)
		li        r4, 0
		li        r5, 0x400
		mr        r3, r24
		bl        Mail_memset
		mr        r3, r24
		addi      r5, r31, MultiPartDivider@l
		lis       r4, _3506@h
		ori       r4, r4, _3506@l

		crclr     4*cr1+eq
		bl        Mail_sprintf
		mr        r3, r24
		lis       r4, _3508@h
		ori       r4, r4, _3508@l

		bl        Mail_strcat
		mr        r3, r24
		bl        Mail_strlen
		mr        r23, r3
		lis       r9, m_pFile@h
		ori       r9, r9, m_pFile@l
		lwz       r5, 0(r9)
		mr        r3, r24
		mr        r4, r23
		bl        NWC24FWrite
		cmpwi     r3, 0
		mr        r24, r3
		bne       loc_80030B74
		lwz       r0, 8(r25)
		add       r0, r0, r23
		stw       r0, 8(r25)
loc_80030B74:
		cmpwi     r3, 0
		beq       loc_80030B8C
		addi      r3, r1, 0x120+var_C8
		bl        NWC24FClose
		mr        r27, r24
		b         loc_80030BA4
loc_80030B8C:
		addi      r30, r30, 8
		addi      r29, r29, 8
		addi      r28, r28, 1
loc_80030B98:
		lbz       r0, 0xC9(r25)
		cmplw     r28, r0
		blt       loc_800309F8
loc_80030BA4:
		cmpwi     r27, 0
		bne       loc_80030BB8
		addi      r3, r1, 0x120+var_C8
		bl        NWC24iMBoxCloseMsg
		b         loc_80030BD4
loc_80030BB8:
		lwz       r5, 0x120+var_114(r1)
		mr        r4, r26
		addi      r3, r1, 0x120+var_C8
		bl        NWC24iMBoxCancelMsg
		mr        r3, r26
		bl        NWC24iMBoxFlushHeader
		b         loc_80030C80
loc_80030BD4:
		lwz       r4, 0x120+var_100(r1)
		cmpwi     r26, 1
		lwz       r3, 0x120+var_FC(r1)
		lwz       r0, 4(r25)
		stw       r4, 0x40(r25)
		ori       r0, r0, 0x200
		stw       r3, 0x44(r25)
		lwz       r4, 0x120+var_108(r1)
		lwz       r3, 0x120+var_104(r1)
		stw       r4, 0x48(r25)
		stw       r3, 0x4C(r25)
		lwz       r4, 0x120+var_F8(r1)
		lwz       r3, 0x120+var_F4(r1)
		stw       r4, 0x68(r25)
		stw       r3, 0x6C(r25)
		lwz       r4, 0x120+var_F0(r1)
		lwz       r3, 0x120+var_EC(r1)
		stw       r4, 0x70(r25)
		stw       r3, 0x74(r25)
		stw       r0, 4(r25)
		bne       loc_80030C34
		ori       r0, r0, 0x20
		stw       r0, 4(r25)
		b         loc_80030C44
loc_80030C34:
		cmpwi     r26, 0
		bne       loc_80030C44
		ori       r0, r0, 0x10
		stw       r0, 4(r25)
loc_80030C44:
		mr        r3, r26
		mr        r4, r25
		bl        NWC24iMBoxAddMsgObj
		cmpwi     r27, 0
		beq       loc_80030C5C
		mr        r3, r27
loc_80030C5C:
		cmpwi     r26, 1
		mr        r27, r3
		bne       loc_80030C80
		lwz       r0, 4(r25)
		li        r3, 1
		rlwinm.   r0, r0, 0,28,28
		beq       loc_80030C7C
		ori       r3, r3, 2
loc_80030C7C:
		bl        NWC24iSetNewMsgArrived
loc_80030C80:
		cmpwi     r27, -6
		beq       loc_80030CC0
		cmpwi     r27, -0x10
		bgt       loc_80030C98
		cmpwi     r27, -0x15
		bge       loc_80030CC0
loc_80030C98:
		cmpwi     r27, -0x26
		beq       loc_80030CC0
		cmpwi     r27, -0x29
		beq       loc_80030CC0
		cmpwi     r27, -0x2B
		beq       loc_80030CC0
		cmpwi     r27, -0x2E
		beq       loc_80030CC0
		cmpwi     r27, -0xE
		bne       loc_80030CCC
loc_80030CC0:
		addis     r3, r27, -2
		addi      r3, r3, 0x550C
		bl        NWC24iSetErrorCode
loc_80030CCC:
		addi      r11, r1, 0x120+pre_back_chain
		mr        r3, r27
		bl        _restgpr_23
		lwz       r0, 0x120+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x120
		blr


CorrectHeadersForMBDelay:
.set back_chain, -0x20
.set var_18, -0x18
.set var_14, -0x14
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x20+sender_lr(r1)
		li        r0, 0
		stw       r31, 0x20+var_4(r1)
		mr        r31, r3
		stw       r0, 0x20+var_14(r1)
		stw       r0, 0x20+var_18(r1)
		lwz       r0, 0xCC(r3)
		rlwinm.   r0, r0, 0,8,15
		bne       loc_80030D1C
		li        r3, 0
		b         loc_80030DA4
loc_80030D1C:
		lwz       r0, 4(r3)
		rlwinm.   r0, r0, 0,28,28
		bne       loc_80030D30
		li        r3, -4
		b         loc_80030DA4
loc_80030D30:
		addi      r3, r1, 0x20+var_18
		bl        NWC24GetMyUserId
		cmpwi     r3, 0
		bge       loc_80030D44
		b         loc_80030DA4
loc_80030D44:
		lbz       r0, 0xC8(r31)
		cmplwi    r0, 1
		bne       loc_80030D70
		lwz       r4, 0x88(r31)
		lwz       r0, 0x20+var_18(r1)
		lwz       r5, 0x8C(r31)
		lwz       r3, 0x20+var_14(r1)
		xor       r0, r4, r0
		xor       r3, r5, r3
		or.       r0, r3, r0
		beq       loc_80030D78
loc_80030D70:
		li        r3, -3
		b         loc_80030DA4
loc_80030D78:
		lwz       r0, 0xCC(r31)
		mr        r3, r31
		extrwi    r0, r0, 8,8
		mulli     r4, r0, 0x3C
		bl        NWC24SetMsgDesignatedTime
		cmpwi     r3, 0
		bge       loc_80030DA0
		lwz       r0, 0x18(r31)
		rlwinm    r0, r0, 0,14,12
		stw       r0, 0x18(r31)
loc_80030DA0:
		li        r3, 0
loc_80030DA4:
		lwz       r0, 0x20+sender_lr(r1)
		lwz       r31, 0x20+var_4(r1)
		mtlr      r0
		addi      r1, r1, 0x20
		blr


CheckMsgObject:
		lbz       r0, 0xC8(r3)
		cmpwi     r0, 0
		bne       loc_80030DCC
		li        r3, -5
		blr
loc_80030DCC:
		cmplwi    r0, 8
		ble       loc_80030DDC
		li        r3, -3
		blr
loc_80030DDC:
		lwz       r5, 0x40(r3)
		cmpwi     r5, 0
		beq       loc_80030E3C
		b         loc_80030E30
loc_80030DEC:
		extsb     r0, r4
		cmpwi     r0, 0xD
		bne       loc_80030E0C
		lbz       r0, 1(r5)
		cmpwi     r0, 0xA
		beq       loc_80030E0C
		li        r3, -0x18
		blr
loc_80030E0C:
		extsb     r0, r4
		cmpwi     r0, 0xA
		bne       loc_80030E2C
		lbz       r0, 1(r5)
		cmpwi     r0, 0x20
		beq       loc_80030E2C
		li        r3, -0x18
		blr
loc_80030E2C:
		addi      r5, r5, 1
loc_80030E30:
		lbz       r4, 0(r5)
		extsb.    r0, r4
		bne       loc_80030DEC
loc_80030E3C:
		lbz       r0, 0xC9(r3)
		cmplwi    r0, 2
		ble       loc_80030E50
		li        r3, -3
		blr
loc_80030E50:
		li        r3, 0
		blr


CheckMsgBoxSpace:
.set back_chain, -0x30
.set pre_back_chain,  0
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x30+sender_lr(r1)
		addi      r11, r1, 0x30+pre_back_chain
		bl        _savegpr_22
		lbz       r7, 0xC9(r3)
		li        r31, 0
		li        r30, 0
		cmpwi     cr1, r7, 0
		ble       cr1, loc_800310EC
		cmpwi     r7, 8
		addi      r9, r7, -8
		ble       loc_80031084
		li        r6, 0
		blt       cr1, loc_80030EA8
		lis       r5, -0x8000
		addi      r0, r5, -2 
		cmpw      r7, r0
		bgt       loc_80030EA8
		li        r6, 1
loc_80030EA8:
		cmpwi     r6, 0
		beq       loc_80031084
		addi      r5, r9, 7
		lis       r6, -0x5555
		lis       r8, 0x1F70
		mr        r7, r3
		srwi      r5, r5, 3
		addi      r6, r6, -0x5555 
		addi      r0, r8, 0x47DD 
		mtctr     r5
		cmpwi     r9, 0
		ble       loc_80031084
loc_80030ED8:
		lwz       r25, 0x78(r7)
		lwz       r8, 0x7C(r7)
		mulhwu    r23, r0, r25
		slwi      r5, r25, 2
		lwz       r11, 0x88(r7)
		addi      r22, r5, 2
		lwz       r9, 0x80(r7)
		slwi      r5, r8, 2
		mulhwu    r26, r0, r8
		addi      r24, r5, 2
		slwi      r28, r11, 2
		lwz       r12, 0x8C(r7)
		slwi      r5, r9, 2
		lwz       r10, 0x84(r7)
		mulhwu    r27, r6, r22
		subf      r22, r23, r25
		addi      r25, r5, 2
		srwi      r22, r22, 1
		subf      r8, r26, r8
		add       r22, r22, r23
		srwi      r5, r27, 1
		slwi      r27, r10, 2
		mulhwu    r23, r6, r24
		srwi      r24, r8, 1
		slwi      r8, r12, 2
		add       r24, r24, r26
		addi      r29, r8, 2
		addi      r27, r27, 2
		mulhwu    r26, r0, r9
		rlwinm    r22, r22, 28,4,30
		add       r5, r31, r5
		srwi      r8, r23, 1
		add       r31, r5, r22
		rlwinm    r24, r24, 28,4,30
		subf      r5, r26, r9
		addi      r31, r31, 4
		add       r9, r31, r8
		addi      r28, r28, 2
		srwi      r5, r5, 1
		add       r31, r9, r24
		mulhwu    r25, r6, r25
		add       r5, r5, r26
		addi      r31, r31, 4
		rlwinm    r26, r5, 28,4,30
		mulhwu    r8, r0, r10
		srwi      r9, r25, 1
		add       r9, r31, r9
		add       r31, r9, r26
		subf      r5, r8, r10
		mulhwu    r27, r6, r27
		addi      r31, r31, 4
		srwi      r5, r5, 1
		add       r5, r5, r8
		mulhwu    r9, r0, r11
		srwi      r10, r27, 1
		add       r8, r31, r10
		rlwinm    r31, r5, 28,4,30
		add       r31, r8, r31
		mulhwu    r10, r6, r28
		subf      r5, r9, r11
		addi      r31, r31, 4
		srwi      r5, r5, 1
		add       r5, r5, r9
		mulhwu    r9, r6, r29
		srwi      r10, r10, 1
		rlwinm    r11, r5, 28,4,30
		add       r10, r31, r10
		mulhwu    r8, r0, r12
		add       r31, r10, r11
		srwi      r9, r9, 1
		addi      r31, r31, 4
		subf      r5, r8, r12
		srwi      r5, r5, 1
		add       r5, r5, r8
		rlwinm    r8, r5, 28,4,30
		add       r5, r31, r9
		add       r31, r5, r8
		addi      r31, r31, 4
		lwz       r9, 0x90(r7)
		addi      r30, r30, 8
		lwz       r12, 0x94(r7)
		addi      r7, r7, 0x20
		mulhwu    r10, r0, r9
		slwi      r8, r9, 2
		slwi      r5, r12, 2
		addi      r8, r8, 2
		addi      r5, r5, 2
		mulhwu    r11, r6, r8
		subf      r8, r10, r9
		srwi      r9, r8, 1
		add       r9, r9, r10
		srwi      r10, r11, 1
		rlwinm    r11, r9, 28,4,30
		mulhwu    r9, r6, r5
		add       r10, r31, r10
		add       r31, r10, r11
		addi      r31, r31, 4
		mulhwu    r8, r0, r12
		srwi      r9, r9, 1
		subf      r5, r8, r12
		srwi      r5, r5, 1
		add       r5, r5, r8
		rlwinm    r8, r5, 28,4,30
		add       r5, r31, r9
		add       r31, r5, r8
		addi      r31, r31, 4
		bdnz      loc_80030ED8
loc_80031084:
		lbz       r10, 0xC9(r3)
		slwi      r7, r30, 2
		lis       r6, -0x5555
		lis       r5, 0x1F70
		subf      r0, r30, r10
		add       r9, r3, r7
		addi      r8, r6, -0x5555 
		addi      r6, r5, 0x47DD 
		mtctr     r0
		cmpw      r30, r10
		bge       loc_800310EC
loc_800310B0:
		lwz       r10, 0x78(r9)
		addi      r9, r9, 4
		slwi      r7, r10, 2
		addi      r0, r7, 2
		mulhwu    r7, r8, r0
		mulhwu    r5, r6, r10
		srwi      r7, r7, 1
		subf      r0, r5, r10
		srwi      r0, r0, 1
		add       r0, r0, r5
		rlwinm    r5, r0, 28,4,30
		add       r0, r31, r7
		add       r31, r0, r5
		addi      r31, r31, 4
		bdnz      loc_800310B0
loc_800310EC:
		lwz       r0, 0x64(r3)
		cmpwi     r0, 2
		beq       loc_8003111C
		bge       loc_80031108
		cmpwi     r0, 0
		bge       loc_80031114
		b         loc_8003117C
loc_80031108:
		cmpwi     r0, 4
		bge       loc_8003117C
		b         loc_80031160
loc_80031114:
		lwz       r0, 0x4C(r3)
		b         loc_80031180
loc_8003111C:
		lwz       r7, 0x4C(r3)
		lis       r3, 0x1F70
		addi      r0, r3, 0x47DD 
		lis       r5, -0x5555
		mulhwu    r3, r0, r7
		slwi      r6, r7, 2
		addi      r5, r5, -0x5555 
		addi      r0, r6, 2
		mulhwu    r5, r5, r0
		subf      r0, r3, r7
		srwi      r0, r0, 1
		add       r0, r0, r3
		srwi      r3, r5, 1
		rlwinm    r0, r0, 28,4,30
		add       r3, r0, r3
		addi      r0, r3, 4
		b         loc_80031180
loc_80031160:
		lwz       r0, 0x4C(r3)
		lis       r3, -0x5555
		addi      r3, r3, -0x5555 
		slwi      r0, r0, 2
		mulhwu    r0, r3, r0
		srwi      r0, r0, 1
		b         loc_80031180
loc_8003117C:
		li        r0, 0
loc_80031180:
		lis       r3, 3
		add       r31, r31, r0
		addi      r0, r3, 0x1C00 
		cmplw     r31, r0
		blt       loc_8003119C
		li        r3, -8
		b         loc_800311BC
loc_8003119C:
		mr        r3, r4
		addi      r4, r31, 0x400
		bl        NWC24iMBoxCheck
		cmpwi     r3, 0
		li        r0, 0
		beq       loc_800311B8
		mr        r0, r3
loc_800311B8:
		mr        r3, r0
loc_800311BC:
		addi      r11, r1, 0x30+pre_back_chain
		bl        _restgpr_22
		lwz       r0, 0x30+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x30
		blr


SynthesizeAddrStr:
.set back_chain, -0x40
.set var_38, -0x38
.set pre_back_chain,  0
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x40+sender_lr(r1)
		addi      r11, r1, 0x40+pre_back_chain
		bl        _savegpr_26
		clrlwi.   r0, r4, 31
		mr        r26, r3
		mr        r27, r5
		mr        r28, r6
		mr        r29, r7
		li        r31, 0
		beq       loc_80031278
		bl        NWC24GetAccountDomain
		mr        r30, r3
		bl        Mail_strlen
		cmpwi     r3, 0
		bgt       loc_80031220
		li        r31, -0xC
		b         loc_800312C8
loc_80031220:
		addi      r0, r3, 0x12
		cmpw      r0, r28
		blt       loc_80031234
		li        r31, -0xB
		b         loc_800312C8
loc_80031234:
		lwz       r3, 0(r26)
		addi      r5, r1, 0x40+var_38
		lwz       r4, 4(r26)
		bl        NWC24iConvIdToStr
		mr        r3, r27
		mr        r7, r30
		addi      r6, r1, 0x40+var_38
		lis       r4, _3611@h
		ori       r4, r4, _3611@l

		li        r5, 0x77
		crclr     4*cr1+eq
		bl        Mail_sprintf
		cmpwi     r3, 0
		bne       loc_80031270
		li        r31, -1
		b         loc_800312C8
loc_80031270:
		stw       r3, 0(r29)
		b         loc_800312C8
loc_80031278:
		rlwinm.   r0, r4, 0,30,30
		beq       loc_800312C4
		lwz       r3, 4(r3)
		addi      r0, r3, 3
		cmplw     r0, r6
		blt       loc_80031298
		li        r31, -0xB
		b         loc_800312C8
loc_80031298:
		lwz       r5, 0(r26)
		mr        r3, r27
		lis       r4, _3612@h
		ori       r4, r4, _3612@l

		crclr     4*cr1+eq
		bl        Mail_sprintf
		cmpwi     r3, 0
		bne       loc_800312BC
		li        r31, -1
		b         loc_800312C8
loc_800312BC:
		stw       r3, 0(r29)
		b         loc_800312C8
loc_800312C4:
		li        r31, -3
loc_800312C8:
		addi      r11, r1, 0x40+pre_back_chain
		mr        r3, r31
		bl        _restgpr_26
		lwz       r0, 0x40+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x40
		blr


WriteSMTP_MAILFROM:
.set back_chain, -0x20
.set var_18, -0x18
.set var_8, -8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		li        r4, 0
		li        r5, 0x400
		stw       r0, 0x20+sender_lr(r1)
		stw       r31, 0x20+var_4(r1)
		stw       r30, 0x20+var_8(r1)
		mr        r30, r3
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r31, 0(r9)
		mr        r3, r31
		bl        Mail_memset
		lis       r4, _3630@ha
		mr        r3, r31
		addi      r4, r4, _3630@l # "MAIL FROM:
		li        r5, 0x3FE
		bl        Mail_strncat
		lwz       r0, 4(r30)
		addi      r31, r31, 0xB
		li        r4, 1
		rlwinm.   r0, r0, 0,11,11
		beq       loc_8003133C
		li        r4, 2
loc_8003133C:
		mr        r5, r31
		addi      r3, r30, 0x20
		addi      r7, r1, 0x20+var_18
		li        r6, 0x3F1
		bl        SynthesizeAddrStr
		cmpwi     cr1, r3, 0
		beq       cr1, loc_8003135C
		b         loc_800313B4
loc_8003135C:
		lwz       r5, 0x20+var_18(r1)
		li        r4, 0xD
		li        r0, 0xA
		stbux     r4, r31, r5
		stb       r0, 1(r31)
		lwz       r4, 0x20+var_18(r1)
		subfic    r0, r4, 0x3F1
		addi      r31, r4, 0xD
		cmpwi     r0, 0
		bgt       loc_8003138C
		li        r3, -0xB
		b         loc_800313B4
loc_8003138C:
		bne       cr1, loc_800313B4
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r3, 0(r9)
		mr        r4, r31
		lis       r9, m_pFile@h
		ori       r9, r9, m_pFile@l
		lwz       r5, 0(r9)
		bl        NWC24FWrite
		cmpwi     r3, 0
		bne       loc_800313B4
		lwz       r0, 8(r30)
		add       r0, r0, r31
		stw       r0, 8(r30)
loc_800313B4:
		lwz       r0, 0x20+sender_lr(r1)
		lwz       r31, 0x20+var_4(r1)
		lwz       r30, 0x20+var_8(r1)
		mtlr      r0
		addi      r1, r1, 0x20
		blr


WriteSMTP_RCPTTO:
.set back_chain, -0x40
.set var_38, -0x38
.set pre_back_chain,  0
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x40+sender_lr(r1)
		addi      r11, r1, 0x40+pre_back_chain
		bl        _savegpr_22
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r27, 0(r9)
		mr        r22, r3
		li        r25, 0
		li        r23, 0
		mr        r3, r27
		li        r4, 0
		li        r5, 0x400
		bl        Mail_memset
		addi      r28, r22, 0x88
		li        r24, 0x3FE
		li        r26, 0
		lis       r29, _3649@ha
		li        r30, 0xD
		li        r31, 0xA
		b         loc_8003148C
loc_8003141C:
		mr        r3, r27
		mr        r5, r24
		addi      r4, r29, _3649@l # "RCPT TO:
		bl        Mail_strncat
		addi      r27, r27, 9
		addi      r24, r24, -0xB
		lwz       r4, 4(r22)
		mr        r3, r28
		mr        r5, r27
		mr        r6, r24
		addi      r7, r1, 0x40+var_38
		bl        SynthesizeAddrStr
		cmpwi     r3, 0
		mr        r23, r3
		bne       loc_80031498
		lwz       r0, 0x40+var_38(r1)
		stbux     r30, r27, r0
		stb       r31, 1(r27)
		addi      r27, r27, 2
		lwz       r0, 0x40+var_38(r1)
		subf.     r24, r0, r24
		add       r3, r25, r0
		addi      r25, r3, 0xB
		bgt       loc_80031484
		li        r23, -0xB
		b         loc_80031498
loc_80031484:
		addi      r28, r28, 8
		addi      r26, r26, 1
loc_8003148C:
		lbz       r0, 0xC8(r22)
		cmplw     r26, r0
		blt       loc_8003141C
loc_80031498:
		cmpwi     r23, 0
		bne       loc_800314C8
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r3, 0(r9)
		mr        r4, r25
		lis       r9, m_pFile@h
		ori       r9, r9, m_pFile@l
		lwz       r5, 0(r9)
		bl        NWC24FWrite
		cmpwi     r3, 0
		mr        r23, r3
		bne       loc_800314C8
		lwz       r0, 8(r22)
		add       r0, r0, r25
		stw       r0, 8(r22)
loc_800314C8:
		addi      r11, r1, 0x40+pre_back_chain
		mr        r3, r23
		bl        _restgpr_22
		lwz       r0, 0x40+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x40
		blr


WriteFromField:
.set back_chain, -0x20
.set var_18, -0x18
.set var_8, -8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		li        r4, 0
		li        r5, 0x400
		stw       r0, 0x20+sender_lr(r1)
		stw       r31, 0x20+var_4(r1)
		mr        r31, r3
		stw       r30, 0x20+var_8(r1)
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r30, 0(r9)
		mr        r3, r30
		bl        Mail_memset
		mr        r3, r30
		lis       r4, _3665@h
		ori       r4, r4, _3665@l

		li        r5, 0x3FE
		bl        Mail_strncat
		lwz       r0, 4(r31)
		addi      r30, r30, 6
		lwz       r3, 8(r31)
		li        r4, 1
		rlwinm.   r0, r0, 0,11,11
		addi      r0, r3, 6
		stw       r0, 0x30(r31)
		beq       loc_80031544
		li        r4, 2
loc_80031544:
		mr        r5, r30
		addi      r3, r31, 0x20
		addi      r7, r1, 0x20+var_18
		li        r6, 0x3F6
		bl        SynthesizeAddrStr
		cmpwi     cr1, r3, 0
		beq       cr1, loc_80031564
		b         loc_800315CC
loc_80031564:
		lwz       r5, 0x20+var_18(r1)
		li        r4, 0xD
		li        r0, 0xA
		stbux     r4, r30, r5
		stb       r0, 1(r30)
		lwz       r4, 0x20+var_18(r1)
		subfic    r0, r4, 0x3F6
		addi      r30, r4, 8
		cmpwi     r0, 0
		bgt       loc_80031594
		li        r3, -0xB
		b         loc_800315CC
loc_80031594:
		bne       cr1, loc_800315CC
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r3, 0(r9)
		mr        r4, r30
		lis       r9, m_pFile@h
		ori       r9, r9, m_pFile@l
		lwz       r5, 0(r9)
		bl        NWC24FWrite
		cmpwi     r3, 0
		bne       loc_800315CC
		lwz       r4, 8(r31)
		lwz       r0, 0x30(r31)
		add       r5, r4, r30
		subf      r4, r0, r5
		stw       r5, 8(r31)
		addi      r0, r4, -2
		stw       r0, 0x34(r31)
loc_800315CC:
		lwz       r0, 0x20+sender_lr(r1)
		lwz       r31, 0x20+var_4(r1)
		lwz       r30, 0x20+var_8(r1)
		mtlr      r0
		addi      r1, r1, 0x20
		blr


WriteToField:
.set back_chain, -0x40
.set var_38, -0x38
.set pre_back_chain,  0
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x40+sender_lr(r1)
		addi      r11, r1, 0x40+pre_back_chain
		bl        _savegpr_21
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r25, 0(r9)
		mr        r29, r3
		li        r30, 0
		li        r4, 0
		mr        r3, r25
		li        r5, 0x400
		bl        Mail_memset
		mr        r3, r25
		lis       r4, _3685@h
		ori       r4, r4, _3685@l

		li        r5, 0x3FE
		bl        Mail_strncat
		lwz       r3, 8(r29)
		addi      r23, r25, 4
		addi      r24, r29, 0x88
		li        r22, 0
		addi      r0, r3, 4
		li        r31, 4
		stw       r0, 0x38(r29)
		li        r21, 0x3FA
		li        r25, 0x2C
		li        r26, 0xD
		li        r27, 0xA
		li        r28, 0x20
		b         loc_800316D0
loc_80031658:
		lwz       r4, 4(r29)
		mr        r3, r24
		mr        r5, r23
		mr        r6, r21
		addi      r7, r1, 0x40+var_38
		bl        SynthesizeAddrStr
		cmpwi     r3, 0
		mr        r30, r3
		bne       loc_800316DC
		lwz       r0, 0x40+var_38(r1)
		subf      r21, r0, r21
		add       r23, r23, r0
		cmpwi     r21, 4
		add       r31, r31, r0
		bgt       loc_8003169C
		li        r30, -0xB
		b         loc_800316DC
loc_8003169C:
		lbz       r3, 0xC8(r29)
		addi      r0, r3, -1
		cmpw      r22, r0
		bge       loc_800316C8
		stb       r25, 0(r23)
		addi      r31, r31, 4
		addi      r21, r21, -4
		stb       r26, 1(r23)
		stb       r27, 2(r23)
		stb       r28, 3(r23)
		addi      r23, r23, 4
loc_800316C8:
		addi      r24, r24, 8
		addi      r22, r22, 1
loc_800316D0:
		lbz       r0, 0xC8(r29)
		cmpw      r22, r0
		blt       loc_80031658
loc_800316DC:
		li        r0, 0xD
		cmpwi     r30, 0
		stb       r0, 0(r23)
		li        r0, 0xA
		stb       r0, 1(r23)
		bne       loc_80031730
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r3, 0(r9)
		addi      r4, r31, 2
		lis       r9, m_pFile@h
		ori       r9, r9, m_pFile@l
		lwz       r5, 0(r9)
		bl        NWC24FWrite
		cmpwi     r3, 0
		mr        r30, r3
		bne       loc_80031730
		lwz       r3, 8(r29)
		lwz       r0, 0x38(r29)
		add       r3, r31, r3
		addi      r4, r3, 2
		subf      r3, r0, r4
		stw       r4, 8(r29)
		addi      r0, r3, -2
		stw       r0, 0x3C(r29)
loc_80031730:
		addi      r11, r1, 0x40+pre_back_chain
		mr        r3, r30
		bl        _restgpr_21
		lwz       r0, 0x40+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x40
		blr


WriteDateField:
.set back_chain, -0x50
.set var_48, -0x48
.set var_46, -0x46
.set var_45, -0x45
.set var_44, -0x44
.set var_43, -0x43
.set var_42, -0x42
.set var_40, -0x40
.set var_3C, -0x3C
.set var_38, -0x38
.set var_34, -0x34
.set var_30, -0x30
.set var_2C, -0x2C
.set var_C, -0xC
.set var_8, -8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x50+sender_lr(r1)
		stw       r31, 0x50+var_4(r1)
		mr        r31, r3
		addi      r3, r1, 0x50+var_48
		stw       r30, 0x50+var_8(r1)
		stw       r29, 0x50+var_C(r1)
		bl        NWC24Date_Init
		addi      r3, r1, 0x50+var_40
		bl        NETGetUniversalCalendar
		lwz       r3, 0x50+var_30(r1)
		lwz       r7, 0x50+var_2C(r1)
		addi      r6, r3, 1
		lwz       r5, 0x50+var_34(r1)
		clrlwi    r0, r6, 24
		lwz       r4, 0x50+var_38(r1)
		lwz       r3, 0x50+var_3C(r1)
		cmplwi    r0, 0xC
		lwz       r0, 0x50+var_40(r1)
		sth       r7, 0x50+var_48(r1)
		stb       r6, 0x50+var_46(r1)
		stb       r5, 0x50+var_45(r1)
		stb       r4, 0x50+var_44(r1)
		stb       r3, 0x50+var_42(r1)
		stb       r0, 0x50+var_43(r1)
		ble       loc_800317C0
		li        r3, -0x18
		b         loc_80031868
loc_800317C0:
		addi      r3, r31, 0x28
		addi      r4, r1, 0x50+var_48
		bl        NWC24iDateToMinutes
		lwz       r0, 4(r31)
		rlwinm.   r0, r0, 0,7,7
		beq       loc_800317E4
		lwz       r4, 0x2C(r31)
		addi      r3, r1, 0x50+var_48
		bl        NWC24iMinutesToDate
loc_800317E4:
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r30, 0(r9)
		li        r4, 0
		li        r5, 0x400
		mr        r3, r30
		bl        Mail_memset
		lbz       r6, 0x50+var_46(r1)
		lis       r3, MonthStr@ha
		lis       r4, _3695@ha
		lbz       r5, 0x50+var_45(r1)
		addi      r0, r6, -1
		addi      r3, r3, MonthStr@l
		slwi      r0, r0, 2
		lhz       r7, 0x50+var_48(r1)
		lwzx      r6, r3, r0
		mr        r3, r30
		lbz       r8, 0x50+var_44(r1)
		addi      r4, r4, _3695@l # "Date:
		lbz       r9, 0x50+var_42(r1)
		lbz       r10, 0x50+var_43(r1)
		crclr     4*cr1+eq
		bl        Mail_sprintf
		mr        r3, r30
		bl        Mail_strlen
		mr        r29, r3
		lis       r9, m_pFile@h
		ori       r9, r9, m_pFile@l
		lwz       r5, 0(r9)
		mr        r3, r30
		mr        r4, r29
		bl        NWC24FWrite
		cmpwi     r3, 0
		bne       loc_80031868
		lwz       r0, 8(r31)
		add       r0, r0, r29
		stw       r0, 8(r31)
loc_80031868:
		lwz       r0, 0x50+sender_lr(r1)
		lwz       r31, 0x50+var_4(r1)
		lwz       r30, 0x50+var_8(r1)
		lwz       r29, 0x50+var_C(r1)
		mtlr      r0
		addi      r1, r1, 0x50
		blr


WriteXWiiAppIdField:
.set back_chain, -0x30
.set var_28, -0x28
.set var_C, -0xC
.set var_8, -8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		li        r4, 0
		li        r5, 0x400
		stw       r0, 0x30+sender_lr(r1)
		stw       r31, 0x30+var_4(r1)
		stw       r30, 0x30+var_8(r1)
		li        r30, 0
		stw       r29, 0x30+var_C(r1)
		mr        r29, r3
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r31, 0(r9)
		mr        r3, r31
		bl        Mail_memset
		lis       r4, _3708@ha
		mr        r3, r31
		addi      r4, r4, _3708@l # "X-Wii-AppId:
		bl        Mail_strcpy
		bl        NWC24IsMsgLibOpenedByTool
		cmpwi     r3, 0
		bne       loc_800318FC
		bl        NWC24GetAppId
		addis     r0, r3, -0x4841
		cmplwi    r0, 0x4541
		beq       loc_800318FC
		lwz       r3, 0xC(r29)
		addis     r0, r3, -0x4841
		cmplwi    r0, 0x4341
		beq       loc_800318FC
		bl        NWC24GetAppId
		stw       r3, 0xC(r29)
loc_800318FC:
		lwz       r3, 4(r29)
		rlwinm.   r0, r3, 0,29,29
		beq       loc_8003190C
		ori       r30, r30, 1
loc_8003190C:
		rlwinm.   r0, r3, 0,28,28
		beq       loc_80031918
		ori       r30, r30, 2
loc_80031918:
		addi      r3, r1, 0x30+var_28
		li        r4, 0
		li        r5, 0x10
		bl        Mail_memset
		lis       r4, _3709@ha
		lwz       r6, 0xC(r29)
		lhz       r7, 0xCA(r29)
		mr        r5, r30
		addi      r3, r1, 0x30+var_28
		addi      r4, r4, _3709@l 
		crclr     4*cr1+eq
		bl        Mail_sprintf
		mr        r3, r31
		addi      r4, r1, 0x30+var_28
		bl        Mail_strcat
		mr        r3, r31
		bl        Mail_strlen
		mr        r30, r3
		lis       r9, m_pFile@h
		ori       r9, r9, m_pFile@l
		lwz       r5, 0(r9)
		mr        r3, r31
		mr        r4, r30
		bl        NWC24FWrite
		cmpwi     r3, 0
		bne       loc_80031984
		lwz       r0, 8(r29)
		add       r0, r0, r30
		stw       r0, 8(r29)
loc_80031984:
		lwz       r0, 0x30+sender_lr(r1)
		lwz       r31, 0x30+var_4(r1)
		lwz       r30, 0x30+var_8(r1)
		lwz       r29, 0x30+var_C(r1)
		mtlr      r0
		addi      r1, r1, 0x30
		blr


WriteXWiiFaceField:
.set back_chain, -0x40
.set var_38, -0x38
.set pre_back_chain,  0
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x40+sender_lr(r1)
		addi      r11, r1, 0x40+pre_back_chain
		bl        _savegpr_23
		lwz       r0, 0xDC(r3)
		mr        r23, r3
		cmpwi     r0, 0
		bne       loc_800319CC
		li        r3, 0
		b         loc_80031A88
loc_800319CC:
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r28, 0(r9)
		li        r4, 0
		li        r5, 0x400
		mr        r3, r28
		bl        Mail_memset
		lis       r4, _3721@ha
		mr        r3, r28
		addi      r4, r4, _3721@l # "X-WiiFace:
		bl        Mail_strcpy
		lwz       r27, 0xD8(r23)
		li        r26, 0xA
		lwz       r25, 0xDC(r23)
		li        r29, 0x20
		li        r30, 0xD
		li        r31, 0xA
		b         loc_80031A5C
loc_80031A0C:
		cmpwi     r25, 0x2A
		stbx      r29, r28, r26
		mr        r24, r25
		addi      r26, r26, 1
		ble       loc_80031A24
		li        r24, 0x2A
loc_80031A24:
		mr        r3, r27
		mr        r4, r24
		add       r5, r28, r26
		addi      r7, r1, 0x40+var_38
		li        r6, 0x4C
		bl        NWC24Base64Encode
		lwz       r0, 0x40+var_38(r1)
		add       r27, r27, r24
		subf      r25, r24, r25
		add       r26, r26, r0
		stbx      r30, r28, r26
		addi      r26, r26, 1
		stbx      r31, r28, r26
		addi      r26, r26, 1
loc_80031A5C:
		cmpwi     r25, 0
		bgt       loc_80031A0C
		lis       r9, m_pFile@h
		ori       r9, r9, m_pFile@l
		lwz       r5, 0(r9)
		mr        r3, r28
		mr        r4, r26
		bl        NWC24FWrite
		cmpwi     r3, 0
		bne       loc_80031A88
		lwz       r0, 8(r23)
		add       r0, r0, r26
		stw       r0, 8(r23)
loc_80031A88:
		addi      r11, r1, 0x40+pre_back_chain
		bl        _restgpr_23
		lwz       r0, 0x40+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x40
		blr


WriteXWiiAltNameField:
.set back_chain, -0x40
.set var_38, -0x38
.set pre_back_chain,  0
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x40+sender_lr(r1)
		addi      r11, r1, 0x40+pre_back_chain
		bl        _savegpr_23
		lwz       r0, 0xE4(r3)
		mr        r23, r3
		cmpwi     r0, 0
		bne       loc_80031ACC
		li        r3, 0
		b         loc_80031B88
loc_80031ACC:
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r28, 0(r9)
		li        r4, 0
		li        r5, 0x400
		mr        r3, r28
		bl        Mail_memset
		lis       r4, _3733@ha
		mr        r3, r28
		addi      r4, r4, _3733@l # "X-Wii-AltName:
		bl        Mail_strcpy
		lwz       r27, 0xE0(r23)
		li        r26, 0xE
		lwz       r25, 0xE4(r23)
		li        r29, 0x20
		li        r30, 0xD
		li        r31, 0xA
		b         loc_80031B5C
loc_80031B0C:
		cmpwi     r25, 0x2A
		stbx      r29, r28, r26
		mr        r24, r25
		addi      r26, r26, 1
		ble       loc_80031B24
		li        r24, 0x2A
loc_80031B24:
		mr        r3, r27
		mr        r4, r24
		add       r5, r28, r26
		addi      r7, r1, 0x40+var_38
		li        r6, 0x4C
		bl        NWC24Base64Encode
		lwz       r0, 0x40+var_38(r1)
		add       r27, r27, r24
		subf      r25, r24, r25
		add       r26, r26, r0
		stbx      r30, r28, r26
		addi      r26, r26, 1
		stbx      r31, r28, r26
		addi      r26, r26, 1
loc_80031B5C:
		cmpwi     r25, 0
		bgt       loc_80031B0C
		lis       r9, m_pFile@h
		ori       r9, r9, m_pFile@l
		lwz       r5, 0(r9)
		mr        r3, r28
		mr        r4, r26
		bl        NWC24FWrite
		cmpwi     r3, 0
		bne       loc_80031B88
		lwz       r0, 8(r23)
		add       r0, r0, r26
		stw       r0, 8(r23)
loc_80031B88:
		addi      r11, r1, 0x40+pre_back_chain
		bl        _restgpr_23
		lwz       r0, 0x40+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x40
		blr


WriteMIMEAttachHeader:
.set back_chain, -0x30
.set pre_back_chain,  0
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x30+sender_lr(r1)
		addi      r11, r1, 0x30+pre_back_chain
		bl        _savegpr_24
		mr        r31, r3
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r3, 0(r9)
		mr        r24, r4
		li        r4, 0
		li        r5, 0x400
		bl        Mail_memset
		slwi      r0, r24, 2
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r27, 0(r9)
		add       r28, r31, r0
		lwz       r3, 0x80(r28)
		bl        NWC24GetMIMETypeStr
		mr        r26, r3
		lwz       r3, 0x80(r28)
		bl        NWC24iGetMIMETypeSuffix
		mr        r25, r3
		lis       r9, ContentTxEncA@h
		ori       r9, r9, ContentTxEncA@l
		lwz       r3, 0(r9)
		bl        Mail_strlen
		mr        r28, r3
		lis       r9, ContentTypeA@h
		ori       r9, r9, ContentTypeA@l
		lwz       r3, 0(r9)
		bl        Mail_strlen
		mr        r30, r3
		lis       r9, ContentDispA@h
		ori       r9, r9, ContentDispA@l
		lwz       r3, 0(r9)
		bl        Mail_strlen
		mr        r29, r3
		mr        r3, r26
		add       r30, r30, r28
		bl        Mail_strlen
		add       r0, r29, r30
		add       r3, r3, r0
		addi      r3, r3, 4
		cmpwi     r3, 0x400
		blt       loc_80031C3C
		li        r3, -0xB
		b         loc_80031CF8
loc_80031C3C:
		addi      r0, r24, 0x61
		lis       r9, ContentTypeA@h
		ori       r9, r9, ContentTypeA@l
		lwz       r4, 0(r9)
		lwz       r7, 0(r31)
		mr        r3, r27
		mr        r5, r26
		mr        r8, r25
		extsb     r6, r0
		crclr     4*cr1+eq
		bl        Mail_sprintf
		cmpwi     r3, 0
		mr        r30, r3
		bgt       loc_80031C74
		li        r3, -2
		b         loc_80031CF8
loc_80031C74:
		add       r27, r27, r3
		lis       r9, ContentTxEncA@h
		ori       r9, r9, ContentTxEncA@l
		lwz       r4, 0(r9)
		mr        r3, r27
		crclr     4*cr1+eq
		bl        Mail_sprintf
		cmpwi     r3, 0
		mr        r5, r3
		bgt       loc_80031C9C
		li        r3, -2
		b         loc_80031CF8
loc_80031C9C:
		addi      r0, r24, 0x61
		lis       r9, ContentDispA@h
		ori       r9, r9, ContentDispA@l
		lwz       r4, 0(r9)
		mr        r7, r25
		add       r25, r30, r5
		lwz       r6, 0(r31)
		add       r3, r27, r3
		extsb     r5, r0
		crclr     4*cr1+eq
		bl        Mail_sprintf
		cmpwi     r3, 0
		bgt       loc_80031CD0
		li        r3, -2
		b         loc_80031CF8
loc_80031CD0:
		add       r25, r25, r3
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r3, 0(r9)
		lis       r9, m_pFile@h
		ori       r9, r9, m_pFile@l
		lwz       r5, 0(r9)
		mr        r4, r25
		bl        NWC24FWrite
		cmpwi     r3, 0
		bne       loc_80031CF8
		lwz       r0, 8(r31)
		add       r0, r0, r25
		stw       r0, 8(r31)
loc_80031CF8:
		addi      r11, r1, 0x30+pre_back_chain
		bl        _restgpr_24
		lwz       r0, 0x30+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x30
		blr


WriteContentTypeField:
.set back_chain, -0x20
.set var_10, -0x10
.set var_C, -0xC
.set var_8, -8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		li        r4, 0
		li        r5, 0x400
		stw       r0, 0x20+sender_lr(r1)
		stw       r31, 0x20+var_4(r1)
		stw       r30, 0x20+var_8(r1)
		stw       r29, 0x20+var_C(r1)
		li        r29, 0
		stw       r28, 0x20+var_10(r1)
		mr        r28, r3
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r31, 0(r9)
		mr        r3, r31
		bl        Mail_memset
		lwz       r3, 0x60(r28)
		bl        NWC24GetCharsetStr
		cmpwi     r3, 0
		mr        r30, r3
		beq       loc_80031D9C
		lis       r9, ContentTypeTP@h
		ori       r9, r9, ContentTypeTP@l
		lwz       r4, 0(r9)
		mr        r3, r31
		mr        r5, r30
		crclr     4*cr1+eq
		bl        Mail_sprintf
		lwz       r4, 8(r28)
		mr        r3, r30
		addi      r0, r4, 0x22
		stw       r0, 0x50(r28)
		bl        Mail_strlen
		addi      r0, r3, 1
		mr        r3, r31
		stw       r0, 0x54(r28)
		bl        Mail_strlen
		mr        r29, r3
		add       r31, r31, r3
loc_80031D9C:
		lwz       r3, 0x64(r28)
		bl        NWC24GetEncodingStr
		cmpwi     r3, 0
		mr        r30, r3
		beq       loc_80031DF0
		lis       r9, ContentTxEncT@h
		ori       r9, r9, ContentTxEncT@l
		lwz       r4, 0(r9)
		mr        r3, r31
		mr        r5, r30
		crclr     4*cr1+eq
		bl        Mail_sprintf
		lwz       r0, 8(r28)
		mr        r3, r30
		add       r4, r29, r0
		addi      r0, r4, 0x1B
		stw       r0, 0x58(r28)
		bl        Mail_strlen
		addi      r0, r3, 1
		mr        r3, r31
		stw       r0, 0x5C(r28)
		bl        Mail_strlen
		add       r29, r29, r3
loc_80031DF0:
		cmpwi     r29, 0
		bne       loc_80031E00
		li        r3, 0
		b         loc_80031E24
loc_80031E00:
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r3, 0(r9)
		mr        r4, r29
		lis       r9, m_pFile@h
		ori       r9, r9, m_pFile@l
		lwz       r5, 0(r9)
		bl        NWC24FWrite
		cmpwi     r3, 0
		bne       loc_80031E24
		lwz       r0, 8(r28)
		add       r0, r0, r29
		stw       r0, 8(r28)
loc_80031E24:
		lwz       r0, 0x20+sender_lr(r1)
		lwz       r31, 0x20+var_4(r1)
		lwz       r30, 0x20+var_8(r1)
		lwz       r29, 0x20+var_C(r1)
		lwz       r28, 0x20+var_10(r1)
		mtlr      r0
		addi      r1, r1, 0x20
		blr


WritePlainText:
.set back_chain, -0x20
.set var_18, -0x18
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x20+sender_lr(r1)
		stw       r31, 0x20+var_4(r1)
		mr        r31, r3
		lwz       r4, 0x4C(r3)
		cmpwi     r4, 0
		bne       loc_80031E6C
		li        r3, -5
		b         loc_80031EF0
loc_80031E6C:
		lwz       r0, 0x64(r3)
		cmpwi     r0, 2
		beq       loc_80031EAC
		bge       loc_80031E88
		cmpwi     r0, 0
		bge       loc_80031E94
		b         loc_80031ECC
loc_80031E88:
		cmpwi     r0, 4
		bge       loc_80031ECC
		b         loc_80031EBC
loc_80031E94:
		lwz       r3, 0x48(r3)
		lis       r9, m_pFile@h
		ori       r9, r9, m_pFile@l
		lwz       r5, 0(r9)
		bl        NWC24FWrite
		lwz       r0, 0x4C(r31)
		stw       r0, 0x20+var_18(r1)
		b         loc_80031ED0
loc_80031EAC:
		lwz       r3, 0x48(r3)
		addi      r5, r1, 0x20+var_18
		bl        WriteBase64Data
		b         loc_80031ED0
loc_80031EBC:
		lwz       r3, 0x48(r3)
		addi      r5, r1, 0x20+var_18
		bl        WriteQPData
		b         loc_80031ED0
loc_80031ECC:
		li        r3, -3
loc_80031ED0:
		cmpwi     r3, 0
		bne       loc_80031EF0
		lwz       r0, 0x4C(r31)
		lwz       r4, 8(r31)
		stw       r0, 0xE8(r31)
		lwz       r0, 0x20+var_18(r1)
		add       r0, r4, r0
		stw       r0, 8(r31)
loc_80031EF0:
		lwz       r0, 0x20+sender_lr(r1)
		lwz       r31, 0x20+var_4(r1)
		mtlr      r0
		addi      r1, r1, 0x20
		blr


WriteBase64Data:
.set back_chain, -0x30
.set var_28, -0x28
.set pre_back_chain,  0
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x30+sender_lr(r1)
		addi      r11, r1, 0x30+pre_back_chain
		bl        _savegpr_24
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r31, 0(r9)
		mr        r25, r3
		mr        r24, r4
		mr        r29, r5
		li        r30, 0
		li        r3, 0
		li        r26, 0xD
		li        r27, 0xA
		li        r28, 0
		b         loc_80031FB4
loc_80031F40:
		mr        r3, r31
		li        r4, 0
		li        r5, 0x400
		bl        Mail_memset
		mr        r3, r25
		mr        r5, r31
		addi      r7, r1, 0x30+var_28
		li        r4, 0x39
		li        r6, 0x4C
		bl        NWC24Base64Encode
		cmpwi     r3, 0
		bne       loc_80031FBC
		lwz       r4, 0x30+var_28(r1)
		mr        r3, r31
		stbx      r26, r31, r4
		addi      r4, r4, 1
		addi      r0, r4, 1
		stbx      r27, r31, r4
		stw       r0, 0x30+var_28(r1)
		stbx      r28, r31, r0
		lwz       r4, 0x30+var_28(r1)
		lis       r9, m_pFile@h
		ori       r9, r9, m_pFile@l
		lwz       r5, 0(r9)
		bl        NWC24FWrite
		cmpwi     r3, 0
		bne       loc_80031FBC
		lwz       r0, 0x30+var_28(r1)
		addi      r25, r25, 0x39
		addi      r24, r24, -0x39
		add       r30, r30, r0
loc_80031FB4:
		cmpwi     r24, 0x39
		bge       loc_80031F40
loc_80031FBC:
		cmpwi     r3, 0
		bne       loc_8003204C
		mr        r3, r31
		li        r4, 0
		li        r5, 0x400
		bl        Mail_memset
		mr        r3, r25
		mr        r4, r24
		mr        r5, r31
		addi      r7, r1, 0x30+var_28
		li        r6, 0x4C
		bl        NWC24Base64Encode
		cmpwi     r3, 0
		bne       loc_8003204C
		lwz       r3, 0x30+var_28(r1)
		li        r8, 0xD
		li        r7, 0xA
		li        r0, 0
		stbx      r8, r31, r3
		addi      r4, r3, 1
		addi      r6, r4, 1
		mr        r3, r31
		stbx      r7, r31, r4
		addi      r5, r6, 1
		addi      r4, r5, 1
		stbx      r8, r31, r6
		stbx      r7, r31, r5
		stw       r4, 0x30+var_28(r1)
		stbx      r0, r31, r4
		lwz       r4, 0x30+var_28(r1)
		lis       r9, m_pFile@h
		ori       r9, r9, m_pFile@l
		lwz       r5, 0(r9)
		bl        NWC24FWrite
		cmpwi     r3, 0
		bne       loc_8003204C
		lwz       r0, 0x30+var_28(r1)
		add       r30, r30, r0
loc_8003204C:
		stw       r30, 0(r29)
		addi      r11, r1, 0x30+pre_back_chain
		bl        _restgpr_24
		lwz       r0, 0x30+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x30
		blr


WriteQPData:
.set back_chain, -0x30
.set var_28, -0x28
.set var_24, -0x24
.set pre_back_chain,  0
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x30+sender_lr(r1)
		addi      r11, r1, 0x30+pre_back_chain
		bl        _savegpr_27
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r31, 0(r9)
		mr        r30, r3
		mr        r29, r4
		mr        r27, r5
		li        r28, 0
		li        r3, 0
		b         loc_80032134
loc_80032098:
		cmpwi     r28, 0
		ble       loc_800320CC
		mr        r3, r31
		lis       r4, _3791@h
		ori       r4, r4, _3791@l

		li        r5, 3
		bl        Mail_memcpy
		lis       r9, m_pFile@h
		ori       r9, r9, m_pFile@l
		lwz       r5, 0(r9)
		mr        r3, r31
		li        r4, 3
		bl        NWC24FWrite
		cmpwi     r3, 0
		bne       loc_8003213C
		addi      r28, r28, 3
loc_800320CC:
		mr        r3, r31
		li        r4, 0
		li        r5, 0x400
		bl        Mail_memset
		mr        r3, r31
		mr        r6, r30
		mr        r7, r29
		addi      r5, r1, 0x30+var_28
		addi      r8, r1, 0x30+var_24
		li        r4, 0x400
		bl        NWC24EncodeQuotedPrintable
		cmpwi     r3, 0
		beq       loc_80032108
		cmpwi     r3, -8
		bne       loc_8003213C
loc_80032108:
		lwz       r4, 0x30+var_28(r1)
		mr        r3, r31
		lis       r9, m_pFile@h
		ori       r9, r9, m_pFile@l
		lwz       r5, 0(r9)
		bl        NWC24FWrite
		cmpwi     r3, 0
		bne       loc_8003213C
		lwz       r4, 0x30+var_24(r1)
		lwz       r0, 0x30+var_28(r1)
		add       r30, r30, r4
		subf      r29, r4, r29
		add       r28, r28, r0
loc_80032134:
		cmpwi     r29, 0
		bgt       loc_80032098
loc_8003213C:
		stw       r28, 0(r27)
		addi      r11, r1, 0x30+pre_back_chain
		bl        _restgpr_27
		lwz       r0, 0x30+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x30
		blr


.global NWC24SuspendScheduler
NWC24SuspendScheduler:
.set back_chain, -0x10
.set var_8, -8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x10+sender_lr(r1)
		stw       r31, 0x10+var_4(r1)
		lis       r31, nwc24ScdCommandMutex@ha
		addi      r31, r31, nwc24ScdCommandMutex@l
		stw       r30, 0x10+var_8(r1)
		lis       r9, nwc24ScdInitialized@h
		ori       r9, r9, nwc24ScdInitialized@l
		lwz       r0, 0(r9)
		clrlwi.   r0, r0, 31
		bne       loc_800321D8
		bl        __RAS_OSDisableInterrupts_begin
		lis       r9, nwc24ScdInitialized@h
		ori       r9, r9, nwc24ScdInitialized@l
		lwz       r0, 0(r9)
		mr        r30, r3
		clrlwi.   r0, r0, 31
		bne       loc_800321D0
		addi      r3, r31, 0
		bl        OSInitMutex
		lis       r3, nwc24ScdCounterMutex@h
		ori       r3, r3, nwc24ScdCounterMutex@l

		bl        OSInitMutex
		lis       r3, nwc24ScdCommonBuffer@h
		ori       r3, r3, nwc24ScdCommonBuffer@l

		li        r4, 0
		li        r5, 0x20
		bl        memset
		lis       r3, nwc24ScdCommonResult@h
		ori       r3, r3, nwc24ScdCommonResult@l

		li        r4, 0
		li        r5, 0x20
		bl        memset
		lis       r9, nwc24ScdInitialized@h
		ori       r9, r9, nwc24ScdInitialized@l
		lwz       r0, 0(r9)
		ori       r0, r0, 1
		lis       r9, nwc24ScdInitialized@h
		ori       r9, r9, nwc24ScdInitialized@l
		stw       r0, 0(r9)
loc_800321D0:
		mr        r3, r30
		bl        OSRestoreInterrupts
loc_800321D8:
		lis       r3, nwc24ScdCounterMutex@h
		ori       r3, r3, nwc24ScdCounterMutex@l

		bl        OSLockMutex
		bl        ExecSuspendScheduler
		cmpwi     r3, 0
		mr        r30, r3
		blt       loc_80032204
		lis       r9, nwc24ScdSuspendCnt@h
		ori       r9, r9, nwc24ScdSuspendCnt@l
		lwz       r4, 0(r9)
		lis       r9, nwc24ScdOpenCnt@h
		ori       r9, r9, nwc24ScdOpenCnt@l
		lwz       r0, 0(r9)
		addi      r4, r4, 1
		lis       r9, nwc24ScdSuspendCnt@h
		ori       r9, r9, nwc24ScdSuspendCnt@l
		stw       r4, 0(r9)
		subf      r30, r0, r3
loc_80032204:
		lis       r3, nwc24ScdCounterMutex@h
		ori       r3, r3, nwc24ScdCounterMutex@l

		bl        OSUnlockMutex
		mr        r3, r30
		lwz       r31, 0x10+var_4(r1)
		lwz       r30, 0x10+var_8(r1)
		lwz       r0, 0x10+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x10
		blr


.global NWC24ResumeScheduler
NWC24ResumeScheduler:
.set back_chain, -0x10
.set var_8, -8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x10+sender_lr(r1)
		stw       r31, 0x10+var_4(r1)
		lis       r31, nwc24ScdCommandMutex@ha
		addi      r31, r31, nwc24ScdCommandMutex@l
		stw       r30, 0x10+var_8(r1)
		lis       r9, nwc24ScdInitialized@h
		ori       r9, r9, nwc24ScdInitialized@l
		lwz       r0, 0(r9)
		clrlwi.   r0, r0, 31
		bne       loc_800322A8
		bl        __RAS_OSDisableInterrupts_begin
		lis       r9, nwc24ScdInitialized@h
		ori       r9, r9, nwc24ScdInitialized@l
		lwz       r0, 0(r9)
		mr        r30, r3
		clrlwi.   r0, r0, 31
		bne       loc_800322A0
		addi      r3, r31, 0
		bl        OSInitMutex
		lis       r3, nwc24ScdCounterMutex@h
		ori       r3, r3, nwc24ScdCounterMutex@l

		bl        OSInitMutex
		lis       r3, nwc24ScdCommonBuffer@h
		ori       r3, r3, nwc24ScdCommonBuffer@l

		li        r4, 0
		li        r5, 0x20
		bl        memset
		lis       r3, nwc24ScdCommonResult@h
		ori       r3, r3, nwc24ScdCommonResult@l

		li        r4, 0
		li        r5, 0x20
		bl        memset
		lis       r9, nwc24ScdInitialized@h
		ori       r9, r9, nwc24ScdInitialized@l
		lwz       r0, 0(r9)
		ori       r0, r0, 1
		lis       r9, nwc24ScdInitialized@h
		ori       r9, r9, nwc24ScdInitialized@l
		stw       r0, 0(r9)
loc_800322A0:
		mr        r3, r30
		bl        OSRestoreInterrupts
loc_800322A8:
		lis       r3, nwc24ScdCounterMutex@h
		ori       r3, r3, nwc24ScdCounterMutex@l

		bl        OSLockMutex
		lis       r9, nwc24ScdOpenCnt@h
		ori       r9, r9, nwc24ScdOpenCnt@l
		lwz       r0, 0(r9)
		cmpwi     r0, 0
		ble       loc_800322D0
		lis       r9, nwc24ScdSuspendCnt@h
		ori       r9, r9, nwc24ScdSuspendCnt@l
		lwz       r0, 0(r9)
		cmpwi     r0, 0
		bne       loc_800322D0
		li        r30, 0
		b         loc_800322F4
loc_800322D0:
		bl        ExecResumeScheduler
		lis       r9, nwc24ScdSuspendCnt@h
		ori       r9, r9, nwc24ScdSuspendCnt@l
		lwz       r4, 0(r9)
		mr        r30, r3
		cmpwi     r4, 0
		ble       loc_800322F4
		addi      r4, r4, -1
		lis       r9, nwc24ScdOpenCnt@h
		ori       r9, r9, nwc24ScdOpenCnt@l
		lwz       r0, 0(r9)
		lis       r9, nwc24ScdSuspendCnt@h
		ori       r9, r9, nwc24ScdSuspendCnt@l
		stw       r4, 0(r9)
		subf      r30, r0, r3
loc_800322F4:
		lis       r3, nwc24ScdCounterMutex@h
		ori       r3, r3, nwc24ScdCounterMutex@l

		bl        OSUnlockMutex
		mr        r3, r30
		lwz       r31, 0x10+var_4(r1)
		lwz       r30, 0x10+var_8(r1)
		lwz       r0, 0x10+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x10
		blr


.global NWC24iSetScriptMode
NWC24iSetScriptMode:
.set back_chain, -0x20
.set var_18, -0x18
.set var_10, -0x10
.set var_C, -0xC
.set var_8, -8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x20+sender_lr(r1)
		stw       r31, 0x20+var_4(r1)
		stw       r30, 0x20+var_8(r1)
		lis       r30, nwc24ScdCommandMutex@ha
		addi      r30, r30, nwc24ScdCommandMutex@l
		stw       r29, 0x20+var_C(r1)
		stw       r28, 0x20+var_10(r1)
		mr        r28, r3
		bl        OSGetCurrentThread
		cmpwi     r3, 0
		bne       loc_80032354
		li        r3, -1
		b         loc_8003238C
loc_80032354:
		bl        NWC24IsMsgLibOpened
		cmpwi     r3, 0
		bne       loc_8003236C
		bl        NWC24IsMsgLibOpenedByTool
		cmpwi     r3, 0
		beq       loc_80032374
loc_8003236C:
		li        r3, -0xA
		b         loc_8003238C
loc_80032374:
		bl        NWC24IsMsgLibOpenBlocking
		cmpwi     r3, 0
		beq       loc_80032388
		li        r3, -0x1A
		b         loc_8003238C
loc_80032388:
		li        r3, 0
loc_8003238C:
		cmpwi     r3, 0
		bge       loc_80032398
		b         loc_80032498
loc_80032398:
		lis       r9, nwc24ScdInitialized@h
		ori       r9, r9, nwc24ScdInitialized@l
		lwz       r0, 0(r9)
		clrlwi.   r0, r0, 31
		bne       loc_800323FC
		bl        __RAS_OSDisableInterrupts_begin
		lis       r9, nwc24ScdInitialized@h
		ori       r9, r9, nwc24ScdInitialized@l
		lwz       r0, 0(r9)
		mr        r31, r3
		clrlwi.   r0, r0, 31
		bne       loc_800323F4
		addi      r3, r30, 0
		bl        OSInitMutex
		lis       r3, nwc24ScdCounterMutex@h
		ori       r3, r3, nwc24ScdCounterMutex@l

		bl        OSInitMutex
		lis       r3, nwc24ScdCommonBuffer@h
		ori       r3, r3, nwc24ScdCommonBuffer@l

		li        r4, 0
		li        r5, 0x20
		bl        memset
		lis       r3, nwc24ScdCommonResult@h
		ori       r3, r3, nwc24ScdCommonResult@l

		li        r4, 0
		li        r5, 0x20
		bl        memset
		lis       r9, nwc24ScdInitialized@h
		ori       r9, r9, nwc24ScdInitialized@l
		lwz       r0, 0(r9)
		ori       r0, r0, 1
		lis       r9, nwc24ScdInitialized@h
		ori       r9, r9, nwc24ScdInitialized@l
		stw       r0, 0(r9)
loc_800323F4:
		mr        r3, r31
		bl        OSRestoreInterrupts
loc_800323FC:
		addi      r3, r30, 0
		bl        OSLockMutex
		lis       r3, nwc24ScdCommonBuffer@h
		ori       r3, r3, nwc24ScdCommonBuffer@l

		li        r4, 0
		li        r5, 0x20
		bl        memset
		lis       r31, __FUNCTION___1622@ha
		lis       r4, _2441@ha
		addi      r3, r31, __FUNCTION___1622@l 
		addi      r5, r1, 0x20+var_18
		addi      r4, r4, _2441@l 
		li        r6, 0
		bl        NWC24iOpenResourceManager
		cmpwi     r3, 0
		mr        r29, r3
		blt       loc_8003248C
		lis       r9, nwc24ScdCommonBuffer@h
		ori       r9, r9, nwc24ScdCommonBuffer@l
		stw       r28, 0(r9)
		addi      r3, r31, __FUNCTION___1622@l 
		lwz       r4, 0x20+var_18(r1)
		lis       r6, nwc24ScdCommonBuffer@h
		ori       r6, r6, nwc24ScdCommonBuffer@l

		lis       r8, nwc24ScdCommonResult@h
		ori       r8, r8, nwc24ScdCommonResult@l

		li        r5, 0x22
		li        r7, 0x20
		li        r9, 0x20
		bl        NWC24iIoctlResourceManager
		cmpwi     r3, 0
		mr        r29, r3
		blt       loc_80032470
		lis       r9, nwc24ScdCommonResult@h
		ori       r9, r9, nwc24ScdCommonResult@l
		lwz       r29, 0(r9)
loc_80032470:
		lis       r3, __FUNCTION___1622@ha
		lwz       r4, 0x20+var_18(r1)
		addi      r3, r3, __FUNCTION___1622@l 
		bl        NWC24iCloseResourceManager
		cmpwi     r29, 0
		blt       loc_8003248C
		mr        r29, r3
loc_8003248C:
		addi      r3, r30, 0
		bl        OSUnlockMutex
		mr        r3, r29
loc_80032498:
		lwz       r0, 0x20+sender_lr(r1)
		lwz       r31, 0x20+var_4(r1)
		lwz       r30, 0x20+var_8(r1)
		lwz       r29, 0x20+var_C(r1)
		lwz       r28, 0x20+var_10(r1)
		mtlr      r0
		addi      r1, r1, 0x20
		blr


.global NWC24iRequestGenerateUserId
NWC24iRequestGenerateUserId:
.set back_chain, -0x30
.set var_28, -0x28
.set pre_back_chain,  0
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x30+sender_lr(r1)
		addi      r11, r1, 0x30+pre_back_chain
		bl        _savegpr_27
		lis       r29, nwc24ScdCommandMutex@ha
		mr        r27, r3
		mr        r31, r4
		addi      r29, r29, nwc24ScdCommandMutex@l
		bl        OSGetCurrentThread
		cmpwi     r3, 0
		bne       loc_800324F0
		li        r3, -1
		b         loc_80032514
loc_800324F0:
		bl        NWC24IsMsgLibOpened
		cmpwi     r3, 0
		bne       loc_80032508
		bl        NWC24IsMsgLibOpenedByTool
		cmpwi     r3, 0
		beq       loc_80032510
loc_80032508:
		li        r3, -0xA
		b         loc_80032514
loc_80032510:
		li        r3, 0
loc_80032514:
		cmpwi     r3, 0
		bge       loc_80032520
		b         loc_8003265C
loc_80032520:
		lis       r9, nwc24ScdInitialized@h
		ori       r9, r9, nwc24ScdInitialized@l
		lwz       r0, 0(r9)
		clrlwi.   r0, r0, 31
		bne       loc_80032584
		bl        __RAS_OSDisableInterrupts_begin
		lis       r9, nwc24ScdInitialized@h
		ori       r9, r9, nwc24ScdInitialized@l
		lwz       r0, 0(r9)
		mr        r30, r3
		clrlwi.   r0, r0, 31
		bne       loc_8003257C
		addi      r3, r29, 0
		bl        OSInitMutex
		lis       r3, nwc24ScdCounterMutex@h
		ori       r3, r3, nwc24ScdCounterMutex@l

		bl        OSInitMutex
		lis       r3, nwc24ScdCommonBuffer@h
		ori       r3, r3, nwc24ScdCommonBuffer@l

		li        r4, 0
		li        r5, 0x20
		bl        memset
		lis       r3, nwc24ScdCommonResult@h
		ori       r3, r3, nwc24ScdCommonResult@l

		li        r4, 0
		li        r5, 0x20
		bl        memset
		lis       r9, nwc24ScdInitialized@h
		ori       r9, r9, nwc24ScdInitialized@l
		lwz       r0, 0(r9)
		ori       r0, r0, 1
		lis       r9, nwc24ScdInitialized@h
		ori       r9, r9, nwc24ScdInitialized@l
		stw       r0, 0(r9)
loc_8003257C:
		mr        r3, r30
		bl        OSRestoreInterrupts
loc_80032584:
		addi      r3, r29, 0
		bl        OSLockMutex
		lis       r30, __FUNCTION___1690@ha
		lis       r4, _2441@ha
		addi      r3, r30, __FUNCTION___1690@l 
		addi      r5, r1, 0x30+var_28
		addi      r4, r4, _2441@l 
		li        r6, 0
		bl        NWC24iOpenResourceManager
		cmpwi     r3, 0
		mr        r28, r3
		blt       loc_80032650
		lwz       r4, 0x30+var_28(r1)
		addi      r3, r30, __FUNCTION___1690@l 
		lis       r8, nwc24ScdCommonResult@h
		ori       r8, r8, nwc24ScdCommonResult@l

		li        r5, 0xF
		li        r6, 0
		li        r7, 0
		li        r9, 0x20
		bl        NWC24iIoctlResourceManager
		cmpwi     r3, 0
		mr        r28, r3
		blt       loc_80032634
		lis       r9, nwc24ScdCommonResult@h
		ori       r9, r9, nwc24ScdCommonResult@l
		lwz       r28, 0(r9)
		cmpwi     r28, 0
		beq       loc_800325FC
		cmpwi     r28, -0x23
		beq       loc_800325FC
		cmpwi     r28, -0x24
		bne       loc_80032634
loc_800325FC:
		li        r0, 0
		cmplw     r27, r0
		beq       loc_8003261C
		lis       r3, nwc24ScdCommonResult@h
		ori       r3, r3, nwc24ScdCommonResult@l

		lis       r9, dword_800928C4@h
		ori       r9, r9, dword_800928C4@l
		lwz       r0, 0(r9)
		lis       r9, dword_800928C8@h
		ori       r9, r9, dword_800928C8@l
		lwz       r3, 0(r9)
		stw       r3, 4(r27)
		stw       r0, 0(r27)
loc_8003261C:
		li        r0, 0
		cmplw     r31, r0
		beq       loc_80032634
		lis       r3, nwc24ScdCommonResult@h
		ori       r3, r3, nwc24ScdCommonResult@l

		lis       r9, dword_800928CC@h
		ori       r9, r9, dword_800928CC@l
		lwz       r0, 0(r9)
		stw       r0, 0(r31)
loc_80032634:
		lis       r3, __FUNCTION___1690@ha
		lwz       r4, 0x30+var_28(r1)
		addi      r3, r3, __FUNCTION___1690@l 
		bl        NWC24iCloseResourceManager
		cmpwi     r28, 0
		blt       loc_80032650
		mr        r28, r3
loc_80032650:
		addi      r3, r29, 0
		bl        OSUnlockMutex
		mr        r3, r28
loc_8003265C:
		addi      r11, r1, 0x30+pre_back_chain
		bl        _restgpr_27
		lwz       r0, 0x30+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x30
		blr


.global NWC24iTrySuspendForOpenLib
NWC24iTrySuspendForOpenLib:
.set back_chain, -0x10
.set var_8, -8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x10+sender_lr(r1)
		stw       r31, 0x10+var_4(r1)
		lis       r31, nwc24ScdCommandMutex@ha
		addi      r31, r31, nwc24ScdCommandMutex@l
		stw       r30, 0x10+var_8(r1)
		lis       r9, nwc24ScdInitialized@h
		ori       r9, r9, nwc24ScdInitialized@l
		lwz       r0, 0(r9)
		clrlwi.   r0, r0, 31
		bne       loc_800326F4
		bl        __RAS_OSDisableInterrupts_begin
		lis       r9, nwc24ScdInitialized@h
		ori       r9, r9, nwc24ScdInitialized@l
		lwz       r0, 0(r9)
		mr        r30, r3
		clrlwi.   r0, r0, 31
		bne       loc_800326EC
		addi      r3, r31, 0
		bl        OSInitMutex
		lis       r3, nwc24ScdCounterMutex@h
		ori       r3, r3, nwc24ScdCounterMutex@l

		bl        OSInitMutex
		lis       r3, nwc24ScdCommonBuffer@h
		ori       r3, r3, nwc24ScdCommonBuffer@l

		li        r4, 0
		li        r5, 0x20
		bl        memset
		lis       r3, nwc24ScdCommonResult@h
		ori       r3, r3, nwc24ScdCommonResult@l

		li        r4, 0
		li        r5, 0x20
		bl        memset
		lis       r9, nwc24ScdInitialized@h
		ori       r9, r9, nwc24ScdInitialized@l
		lwz       r0, 0(r9)
		ori       r0, r0, 1
		lis       r9, nwc24ScdInitialized@h
		ori       r9, r9, nwc24ScdInitialized@l
		stw       r0, 0(r9)
loc_800326EC:
		mr        r3, r30
		bl        OSRestoreInterrupts
loc_800326F4:
		lis       r3, nwc24ScdCounterMutex@h
		ori       r3, r3, nwc24ScdCounterMutex@l

		bl        OSTryLockMutex
		cmpwi     r3, 0
		bne       loc_8003270C
		li        r3, -0x16
		b         loc_8003273C
loc_8003270C:
		li        r3, 0
		bl        ExecTrySuspendScheduler
		cmpwi     r3, 0
		mr        r30, r3
		blt       loc_80032730
		lis       r9, nwc24ScdOpenCnt@h
		ori       r9, r9, nwc24ScdOpenCnt@l
		lwz       r3, 0(r9)
		li        r30, 0
		addi      r0, r3, 1
		lis       r9, nwc24ScdOpenCnt@h
		ori       r9, r9, nwc24ScdOpenCnt@l
		stw       r0, 0(r9)
loc_80032730:
		lis       r3, nwc24ScdCounterMutex@h
		ori       r3, r3, nwc24ScdCounterMutex@l

		bl        OSUnlockMutex
		mr        r3, r30
loc_8003273C:
		lwz       r0, 0x10+sender_lr(r1)
		lwz       r31, 0x10+var_4(r1)
		lwz       r30, 0x10+var_8(r1)
		mtlr      r0
		addi      r1, r1, 0x10
		blr


.global NWC24iResumeForCloseLib
NWC24iResumeForCloseLib:
.set back_chain, -0x10
.set var_8, -8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x10+sender_lr(r1)
		stw       r31, 0x10+var_4(r1)
		lis       r31, nwc24ScdCommandMutex@ha
		addi      r31, r31, nwc24ScdCommandMutex@l
		stw       r30, 0x10+var_8(r1)
		lis       r9, nwc24ScdInitialized@h
		ori       r9, r9, nwc24ScdInitialized@l
		lwz       r0, 0(r9)
		clrlwi.   r0, r0, 31
		bne       loc_800327D4
		bl        __RAS_OSDisableInterrupts_begin
		lis       r9, nwc24ScdInitialized@h
		ori       r9, r9, nwc24ScdInitialized@l
		lwz       r0, 0(r9)
		mr        r30, r3
		clrlwi.   r0, r0, 31
		bne       loc_800327CC
		addi      r3, r31, 0
		bl        OSInitMutex
		lis       r3, nwc24ScdCounterMutex@h
		ori       r3, r3, nwc24ScdCounterMutex@l

		bl        OSInitMutex
		lis       r3, nwc24ScdCommonBuffer@h
		ori       r3, r3, nwc24ScdCommonBuffer@l

		li        r4, 0
		li        r5, 0x20
		bl        memset
		lis       r3, nwc24ScdCommonResult@h
		ori       r3, r3, nwc24ScdCommonResult@l

		li        r4, 0
		li        r5, 0x20
		bl        memset
		lis       r9, nwc24ScdInitialized@h
		ori       r9, r9, nwc24ScdInitialized@l
		lwz       r0, 0(r9)
		ori       r0, r0, 1
		lis       r9, nwc24ScdInitialized@h
		ori       r9, r9, nwc24ScdInitialized@l
		stw       r0, 0(r9)
loc_800327CC:
		mr        r3, r30
		bl        OSRestoreInterrupts
loc_800327D4:
		lis       r3, nwc24ScdCounterMutex@h
		ori       r3, r3, nwc24ScdCounterMutex@l

		bl        OSLockMutex
		bl        ExecResumeScheduler
		cmpwi     r3, 0
		mr        r30, r3
		blt       loc_800327FC
		lis       r9, nwc24ScdOpenCnt@h
		ori       r9, r9, nwc24ScdOpenCnt@l
		lwz       r3, 0(r9)
		li        r30, 0
		addi      r0, r3, -1
		lis       r9, nwc24ScdOpenCnt@h
		ori       r9, r9, nwc24ScdOpenCnt@l
		stw       r0, 0(r9)
loc_800327FC:
		lis       r3, nwc24ScdCounterMutex@h
		ori       r3, r3, nwc24ScdCounterMutex@l

		bl        OSUnlockMutex
		mr        r3, r30
		lwz       r31, 0x10+var_4(r1)
		lwz       r30, 0x10+var_8(r1)
		lwz       r0, 0x10+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x10
		blr


ExecSuspendScheduler:
		li        r3, 0
		li        r4, 1
		li        r5, 0
		b         ExecNoParamCommand


ExecTrySuspendScheduler:
.set back_chain, -0x20
.set var_18, -0x18
.set var_10, -0x10
.set var_C, -0xC
.set var_8, -8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x20+sender_lr(r1)
		stw       r31, 0x20+var_4(r1)
		stw       r30, 0x20+var_8(r1)
		lis       r30, nwc24ScdCommandMutex@ha
		addi      r30, r30, nwc24ScdCommandMutex@l
		stw       r29, 0x20+var_C(r1)
		stw       r28, 0x20+var_10(r1)
		mr        r28, r3
		bl        OSGetCurrentThread
		cmpwi     r3, 0
		bne       loc_8003286C
		li        r3, -1
		b         loc_80032890
loc_8003286C:
		bl        NWC24IsMsgLibOpened
		cmpwi     r3, 0
		bne       loc_80032884
		bl        NWC24IsMsgLibOpenedByTool
		cmpwi     r3, 0
		beq       loc_8003288C
loc_80032884:
		li        r3, -0xA
		b         loc_80032890
loc_8003288C:
		li        r3, 0
loc_80032890:
		cmpwi     r3, 0
		bge       loc_8003289C
		b         loc_8003299C
loc_8003289C:
		lis       r9, nwc24ScdInitialized@h
		ori       r9, r9, nwc24ScdInitialized@l
		lwz       r0, 0(r9)
		clrlwi.   r0, r0, 31
		bne       loc_80032900
		bl        __RAS_OSDisableInterrupts_begin
		lis       r9, nwc24ScdInitialized@h
		ori       r9, r9, nwc24ScdInitialized@l
		lwz       r0, 0(r9)
		mr        r31, r3
		clrlwi.   r0, r0, 31
		bne       loc_800328F8
		addi      r3, r30, 0
		bl        OSInitMutex
		lis       r3, nwc24ScdCounterMutex@h
		ori       r3, r3, nwc24ScdCounterMutex@l

		bl        OSInitMutex
		lis       r3, nwc24ScdCommonBuffer@h
		ori       r3, r3, nwc24ScdCommonBuffer@l

		li        r4, 0
		li        r5, 0x20
		bl        memset
		lis       r3, nwc24ScdCommonResult@h
		ori       r3, r3, nwc24ScdCommonResult@l

		li        r4, 0
		li        r5, 0x20
		bl        memset
		lis       r9, nwc24ScdInitialized@h
		ori       r9, r9, nwc24ScdInitialized@l
		lwz       r0, 0(r9)
		ori       r0, r0, 1
		lis       r9, nwc24ScdInitialized@h
		ori       r9, r9, nwc24ScdInitialized@l
		stw       r0, 0(r9)
loc_800328F8:
		mr        r3, r31
		bl        OSRestoreInterrupts
loc_80032900:
		addi      r3, r30, 0
		bl        OSTryLockMutex
		cmpwi     r3, 0
		bne       loc_80032918
		li        r3, -0x16
		b         loc_8003299C
loc_80032918:
		lis       r31, __FUNCTION___1850@ha
		lis       r4, _2441@ha
		addi      r3, r31, __FUNCTION___1850@l 
		addi      r5, r1, 0x20+var_18
		addi      r4, r4, _2441@l 
		li        r6, 0
		bl        NWC24iOpenResourceManager
		cmpwi     r3, 0
		mr        r29, r3
		blt       loc_80032990
		lis       r9, nwc24ScdCommonBuffer@h
		ori       r9, r9, nwc24ScdCommonBuffer@l
		stw       r28, 0(r9)
		addi      r3, r31, __FUNCTION___1850@l 
		lwz       r4, 0x20+var_18(r1)
		lis       r6, nwc24ScdCommonBuffer@h
		ori       r6, r6, nwc24ScdCommonBuffer@l

		lis       r8, nwc24ScdCommonResult@h
		ori       r8, r8, nwc24ScdCommonResult@l

		li        r5, 2
		li        r7, 0x20
		li        r9, 0x20
		bl        NWC24iIoctlResourceManager
		cmpwi     r3, 0
		mr        r29, r3
		blt       loc_80032974
		lis       r9, nwc24ScdCommonResult@h
		ori       r9, r9, nwc24ScdCommonResult@l
		lwz       r29, 0(r9)
loc_80032974:
		lis       r3, __FUNCTION___1850@ha
		lwz       r4, 0x20+var_18(r1)
		addi      r3, r3, __FUNCTION___1850@l 
		bl        NWC24iCloseResourceManager
		cmpwi     r3, 0
		bge       loc_80032990
		mr        r29, r3
loc_80032990:
		addi      r3, r30, 0
		bl        OSUnlockMutex
		mr        r3, r29
loc_8003299C:
		lwz       r0, 0x20+sender_lr(r1)
		lwz       r31, 0x20+var_4(r1)
		lwz       r30, 0x20+var_8(r1)
		lwz       r29, 0x20+var_C(r1)
		lwz       r28, 0x20+var_10(r1)
		mtlr      r0
		addi      r1, r1, 0x20
		blr


ExecResumeScheduler:
		li        r3, 0
		li        r4, 3
		li        r5, 0
		b         ExecNoParamCommand


ExecNoParamCommand:
.set back_chain, -0x30
.set var_28, -0x28
.set pre_back_chain,  0
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x30+sender_lr(r1)
		addi      r11, r1, 0x30+pre_back_chain
		bl        _savegpr_27
		lis       r31, nwc24ScdCommandMutex@ha
		mr        r27, r3
		mr        r28, r4
		mr        r29, r5
		addi      r31, r31, nwc24ScdCommandMutex@l
		bl        OSGetCurrentThread
		cmpwi     r3, 0
		bne       loc_80032A08
		li        r3, -1
		b         loc_80032B14
loc_80032A08:
		lis       r9, nwc24ScdInitialized@h
		ori       r9, r9, nwc24ScdInitialized@l
		lwz       r0, 0(r9)
		clrlwi.   r0, r0, 31
		bne       loc_80032A6C
		bl        __RAS_OSDisableInterrupts_begin
		lis       r9, nwc24ScdInitialized@h
		ori       r9, r9, nwc24ScdInitialized@l
		lwz       r0, 0(r9)
		mr        r30, r3
		clrlwi.   r0, r0, 31
		bne       loc_80032A64
		addi      r3, r31, 0
		bl        OSInitMutex
		lis       r3, nwc24ScdCounterMutex@h
		ori       r3, r3, nwc24ScdCounterMutex@l

		bl        OSInitMutex
		lis       r3, nwc24ScdCommonBuffer@h
		ori       r3, r3, nwc24ScdCommonBuffer@l

		li        r4, 0
		li        r5, 0x20
		bl        memset
		lis       r3, nwc24ScdCommonResult@h
		ori       r3, r3, nwc24ScdCommonResult@l

		li        r4, 0
		li        r5, 0x20
		bl        memset
		lis       r9, nwc24ScdInitialized@h
		ori       r9, r9, nwc24ScdInitialized@l
		lwz       r0, 0(r9)
		ori       r0, r0, 1
		lis       r9, nwc24ScdInitialized@h
		ori       r9, r9, nwc24ScdInitialized@l
		stw       r0, 0(r9)
loc_80032A64:
		mr        r3, r30
		bl        OSRestoreInterrupts
loc_80032A6C:
		addi      r3, r31, 0
		bl        OSLockMutex
		lis       r4, _2441@ha
		mr        r3, r27
		addi      r4, r4, _2441@l 
		addi      r5, r1, 0x30+var_28
		li        r6, 0
		bl        NWC24iOpenResourceManager
		cmpwi     r3, 0
		mr        r30, r3
		blt       loc_80032B08
		lwz       r4, 0x30+var_28(r1)
		mr        r3, r27
		mr        r5, r28
		lis       r8, nwc24ScdCommonResult@h
		ori       r8, r8, nwc24ScdCommonResult@l

		li        r6, 0
		li        r7, 0
		li        r9, 0x20
		bl        NWC24iIoctlResourceManager
		cmpwi     r3, 0
		mr        r30, r3
		blt       loc_80032AF0
		lis       r9, nwc24ScdCommonResult@h
		ori       r9, r9, nwc24ScdCommonResult@l
		lwz       r30, 0(r9)
		cmpwi     r30, -2
		beq       loc_80032AD8
		cmpwi     r30, -0x21
		bne       loc_80032AF0
loc_80032AD8:
		li        r0, 0
		cmplw     r29, r0
		beq       loc_80032AF0
		lis       r3, nwc24ScdCommonResult@h
		ori       r3, r3, nwc24ScdCommonResult@l

		lis       r9, dword_800928C4@h
		ori       r9, r9, dword_800928C4@l
		lwz       r0, 0(r9)
		stw       r0, 0(r29)
loc_80032AF0:
		lwz       r4, 0x30+var_28(r1)
		mr        r3, r27
		bl        NWC24iCloseResourceManager
		cmpwi     r3, 0
		bge       loc_80032B08
		mr        r30, r3
loc_80032B08:
		addi      r3, r31, 0
		bl        OSUnlockMutex
		mr        r3, r30
loc_80032B14:
		addi      r11, r1, 0x30+pre_back_chain
		bl        _restgpr_27
		lwz       r0, 0x30+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x30
		blr


.global NWC24iDateToMinutes
NWC24iDateToMinutes:
.set back_chain, -0x10
.set var_8, -8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x10+sender_lr(r1)
		stw       r31, 0x10+var_4(r1)
		mr        r31, r4
		lbz       r5, 3(r31)
		stw       r30, 0x10+var_8(r1)
		mr        r30, r3
		lhz       r3, 0(r4)
		lbz       r4, 2(r4)
		bl        ConvertDateToDays
		cmpwi     r3, -1
		bne       loc_80032B68
		li        r3, -2
		b         loc_80032BBC
loc_80032B68:
		lbz       r0, 4(r31)
		lbz       r4, 6(r31)
		cmplwi    r0, 0x17
		bgt       loc_80032B80
		cmplwi    r4, 0x3B
		ble       loc_80032B88
loc_80032B80:
		li        r4, -1
		b         loc_80032B90
loc_80032B88:
		mulli     r0, r0, 0x3C
		add       r4, r4, r0
loc_80032B90:
		cmpwi     r4, -1
		beq       loc_80032BA4
		lbz       r0, 5(r31)
		cmplwi    r0, 0x3C
		ble       loc_80032BAC
loc_80032BA4:
		li        r3, -2
		b         loc_80032BBC
loc_80032BAC:
		mulli     r0, r3, 0x5A0
		li        r3, 0
		add       r0, r4, r0
		stw       r0, 0(r30)
loc_80032BBC:
		lwz       r0, 0x10+sender_lr(r1)
		lwz       r31, 0x10+var_4(r1)
		lwz       r30, 0x10+var_8(r1)
		mtlr      r0
		addi      r1, r1, 0x10
		blr


.global NWC24iMinutesToDate
NWC24iMinutesToDate:
.set back_chain, -0x10
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		cmpwi     r4, 0
		mr        r10, r4
		stw       r0, 0x10+sender_lr(r1)
		bge       loc_80032BF0
		li        r10, 0
loc_80032BF0:
		lis       r4, -0x49F5
		lis       r5, -0x7777
		addi      r0, r4, 0x60B7 
		mulhw     r6, r0, r10
		addi      r4, r3, 2
		addi      r0, r5, -0x7777 
		addi      r5, r3, 3
		add       r6, r6, r10
		srawi     r8, r6, 0xA
		srawi     r6, r6, 0xA
		srwi      r7, r6, 31
		srwi      r9, r8, 31
		add       r6, r6, r7
		mulli     r7, r6, 0x5A0
		add       r6, r8, r9
		subf      r10, r7, r10
		mulhw     r0, r0, r10
		add       r0, r0, r10
		srawi     r8, r0, 5
		srawi     r0, r0, 5
		srwi      r7, r0, 31
		srwi      r9, r8, 31
		add       r0, r0, r7
		mulli     r0, r0, 0x3C
		add       r7, r8, r9
		stb       r7, 4(r3)
		subf      r0, r0, r10
		stb       r0, 6(r3)
		bl        ConvertDaysToDate
		lwz       r0, 0x10+sender_lr(r1)
		li        r3, 0
		mtlr      r0
		addi      r1, r1, 0x10
		blr


.global NWC24iEpochSecondsToDate
NWC24iEpochSecondsToDate:
.set back_chain, -0x20
.set pre_back_chain,  0
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x20+sender_lr(r1)
		addi      r11, r1, 0x20+pre_back_chain
		bl        _savegpr_27
		lis       r4, -0x7C56
		li        r7, 0
		addi      r0, r4, 0x7E80 
		mr        r31, r3
		addc      r3, r6, r0
		xoris     r4, r7, 0x8000 
		adde      r0, r5, r7
		mr        r28, r5
		xoris     r0, r0, 0x8000
		subfc     r3, r7, r3
		subfe     r4, r4, r0
		mr        r27, r6
		subfe     r4, r0, r0
		neg.      r4, r4
		beq       loc_80032CD4
		lis       r3, 0x7C56
		li        r28, -1
		addi      r27, r3, -0x7E80 
loc_80032CD4:
		lis       r30, -0x7C56
		li        r29, 0
		addi      r0, r30, 0x7E80 
		li        r6, 0x3C
		addc      r4, r27, r0
		li        r5, 0
		adde      r3, r28, r29
		bl        __mod2i
		addi      r0, r30, 0x7E80 
		stb       r4, 5(r31)
		addc      r4, r27, r0
		li        r6, 0x3C
		adde      r3, r28, r29
		li        r5, 0
		bl        __div2i
		cmpwi     r4, 0
		mr        r10, r4
		bge       loc_80032D20
		li        r10, 0
loc_80032D20:
		lis       r3, -0x49F5
		lis       r4, -0x7777
		addi      r0, r3, 0x60B7 
		addi      r5, r31, 3
		mulhw     r6, r0, r10
		mr        r3, r31
		addi      r0, r4, -0x7777 
		addi      r4, r31, 2
		add       r6, r6, r10
		srawi     r8, r6, 0xA
		srawi     r6, r6, 0xA
		srwi      r7, r6, 31
		srwi      r9, r8, 31
		add       r6, r6, r7
		mulli     r7, r6, 0x5A0
		add       r6, r8, r9
		subf      r10, r7, r10
		mulhw     r0, r0, r10
		add       r0, r0, r10
		srawi     r8, r0, 5
		srawi     r0, r0, 5
		srwi      r7, r0, 31
		srwi      r9, r8, 31
		add       r0, r0, r7
		mulli     r0, r0, 0x3C
		add       r7, r8, r9
		stb       r7, 4(r31)
		subf      r0, r0, r10
		stb       r0, 6(r31)
		bl        ConvertDaysToDate
		addi      r11, r1, 0x20+pre_back_chain
		li        r3, 0
		bl        _restgpr_27
		lwz       r0, 0x20+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x20
		blr


.global NWC24iEpochSecondsToMinutes
NWC24iEpochSecondsToMinutes:
.set back_chain, -0x10
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		lis       r4, -0x7C56
		li        r7, 0
		stw       r0, 0x10+sender_lr(r1)
		addi      r0, r4, 0x7E80 
		xoris     r4, r7, 0x8000 
		mr        r8, r5
		stw       r31, 0x10+var_4(r1)
		mr        r31, r3
		addc      r3, r6, r0
		adde      r0, r5, r7
		mr        r5, r6
		xoris     r0, r0, 0x8000
		subfc     r3, r7, r3
		subfe     r4, r4, r0
		subfe     r4, r0, r0
		neg.      r4, r4
		beq       loc_80032E0C
		lis       r3, 0x7C56
		li        r8, -1
		addi      r5, r3, -0x7E80 
loc_80032E0C:
		lis       r3, -0x7C56
		li        r0, 0
		addi      r3, r3, 0x7E80 
		li        r6, 0x3C
		addc      r4, r5, r3
		li        r5, 0
		adde      r3, r8, r0
		bl        __div2i
		stw       r4, 0(r31)
		li        r3, 0
		lwz       r31, 0x10+var_4(r1)
		lwz       r0, 0x10+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x10
		blr


.global NWC24iDateToOSCalendarTime
NWC24iDateToOSCalendarTime:
.set back_chain, -0x10
.set var_8, -8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		lis       r6, DAYS_OF_YEAR@ha
		lbz       r7, 2(r4)
		stw       r0, 0x10+sender_lr(r1)
		addi      r6, r6, DAYS_OF_YEAR@l
		lhz       r5, 0(r4)
		li        r0, 0
		stw       r31, 0x10+var_4(r1)
		mr        r31, r3
		lbz       r12, 3(r4)
		stw       r30, 0x10+var_8(r1)
		addi      r30, r7, -1
		slwi      r7, r30, 1
		lbz       r11, 4(r4)
		lhzx      r8, r6, r7
		slwi      r6, r5, 30
		srwi      r7, r5, 31
		lbz       r10, 6(r4)
		subf      r6, r7, r6
		lbz       r9, 5(r4)
		rotlwi    r6, r6, 2
		add       r8, r12, r8
		add.      r6, r6, r7
		stw       r5, 0x14(r3)
		addi      r7, r8, -1
		stw       r30, 0x10(r3)
		mr        r6, r4
		stw       r12, 0xC(r3)
		stw       r11, 8(r3)
		stw       r10, 4(r3)
		stw       r9, 0(r3)
		stw       r0, 0x20(r3)
		stw       r0, 0x24(r3)
		stw       r7, 0x1C(r3)
		bne       loc_80032EFC
		lis       r7, 0x51EC
		addi      r7, r7, -0x7AE1 
		mulhw     r7, r7, r5
		srawi     r7, r7, 5
		srwi      r8, r7, 31
		add       r7, r7, r8
		mulli     r7, r7, 0x64
		subf.     r7, r7, r5
		bne       loc_80032F20
loc_80032EFC:
		lis       r7, 0x51EC
		addi      r7, r7, -0x7AE1 
		mulhw     r7, r7, r5
		srawi     r7, r7, 7
		srwi      r8, r7, 31
		add       r7, r7, r8
		mulli     r7, r7, 0x190
		subf.     r5, r7, r5
		bne       loc_80032F24
loc_80032F20:
		li        r0, 1
loc_80032F24:
		cmpwi     r0, 0
		beq       loc_80032F44
		lbz       r0, 2(r4)
		cmplwi    r0, 2
		ble       loc_80032F44
		lwz       r5, 0x1C(r3)
		addi      r0, r5, 1
		stw       r0, 0x1C(r3)
loc_80032F44:
		lhz       r3, 0(r4)
		lbz       r4, 2(r4)
		lbz       r5, 3(r6)
		bl        ConvertDateToDays
		lis       r4, -0x6DB7
		addi      r5, r3, 1
		addi      r0, r4, 0x2493 
		li        r3, 0
		mulhw     r0, r0, r5
		add       r0, r0, r5
		srawi     r0, r0, 2
		srwi      r4, r0, 31
		add       r0, r0, r4
		mulli     r0, r0, 7
		subf      r0, r0, r5
		stw       r0, 0x18(r31)
		lwz       r31, 0x10+var_4(r1)
		lwz       r30, 0x10+var_8(r1)
		lwz       r0, 0x10+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x10
		blr


ConvertDateToDays:
		cmplwi    r3, 0x76C
		blt       loc_80032FB4
		cmplwi    r4, 1
		blt       loc_80032FB4
		cmplwi    r4, 0xC
		ble       loc_80032FBC
loc_80032FB4:
		li        r3, -1
		blr
loc_80032FBC:
		cmplwi    r4, 2
		bne       loc_8003304C
		slwi      r0, r3, 30
		srwi      r6, r3, 31
		subf      r0, r6, r0
		li        r7, 0
		rotlwi    r0, r0, 2
		add.      r0, r0, r6
		bne       loc_80033004
		lis       r6, 0x51EC
		addi      r0, r6, -0x7AE1 
		mulhw     r0, r0, r3
		srawi     r0, r0, 5
		srwi      r6, r0, 31
		add       r0, r0, r6
		mulli     r0, r0, 0x64
		subf.     r0, r0, r3
		bne       loc_80033028
loc_80033004:
		lis       r6, 0x51EC
		addi      r0, r6, -0x7AE1 
		mulhw     r0, r0, r3
		srawi     r0, r0, 7
		srwi      r6, r0, 31
		add       r0, r0, r6
		mulli     r0, r0, 0x190
		subf.     r0, r0, r3
		bne       loc_8003302C
loc_80033028:
		li        r7, 1
loc_8003302C:
		cmpwi     r7, 0
		beq       loc_8003304C
		cmplwi    r5, 1
		blt       loc_80033044
		cmplwi    r5, 0x1D
		ble       loc_80033074
loc_80033044:
		li        r3, -1
		blr
loc_8003304C:
		cmplwi    r5, 1
		blt       loc_8003306C
		lis       r6, DAYS_OF_MONTH@ha
		addi      r6, r6, DAYS_OF_MONTH@l
		add       r6, r4, r6
		lbz       r0, -1(r6)
		cmplw     r0, r5
		bge       loc_80033074
loc_8003306C:
		li        r3, -1
		blr
loc_80033074:
		addi      r0, r4, -1
		lis       r6, DAYS_OF_YEAR@ha
		slwi      r0, r0, 1
		cmplwi    r4, 3
		addi      r6, r6, DAYS_OF_YEAR@l
		addi      r4, r5, -1
		lhzx      r0, r6, r0
		add       r4, r4, r0
		blt       loc_8003310C
		slwi      r0, r3, 30
		srwi      r5, r3, 31
		subf      r0, r5, r0
		li        r6, 0
		rotlwi    r0, r0, 2
		add.      r0, r0, r5
		bne       loc_800330D8
		lis       r5, 0x51EC
		addi      r0, r5, -0x7AE1 
		mulhw     r0, r0, r3
		srawi     r0, r0, 5
		srwi      r5, r0, 31
		add       r0, r0, r5
		mulli     r0, r0, 0x64
		subf.     r0, r0, r3
		bne       loc_800330FC
loc_800330D8:
		lis       r5, 0x51EC
		addi      r0, r5, -0x7AE1 
		mulhw     r0, r0, r3
		srawi     r0, r0, 7
		srwi      r5, r0, 31
		add       r0, r0, r5
		mulli     r0, r0, 0x190
		subf.     r0, r0, r3
		bne       loc_80033100
loc_800330FC:
		li        r6, 1
loc_80033100:
		cmpwi     r6, 0
		beq       loc_8003310C
		addi      r4, r4, 1
loc_8003310C:
		addi      r6, r3, -0x76C
		lis       r3, 0x51EC
		addi      r5, r3, -0x7AE1 
		addi      r0, r6, 0x12B
		addi      r3, r6, -1
		mulhw     r0, r5, r0
		mulli     r7, r6, 0x16D
		srawi     r0, r0, 7
		srwi      r6, r0, 31
		mulhw     r5, r5, r3
		add       r4, r4, r7
		add       r0, r0, r6
		add       r0, r4, r0
		srawi     r4, r5, 5
		srwi      r5, r4, 31
		srawi     r3, r3, 2
		add       r4, r4, r5
		addze     r3, r3
		subf      r3, r4, r3
		add       r3, r3, r0
		blr


ConvertDaysToDate:
.set back_chain, -0x10
.set var_4, -4
		stwu      r1, back_chain(r1)
		li        r7, 0x76C
		li        r0, 1
		cmpwi     r6, 0
		stw       r31, 0x10+var_4(r1)
		sth       r7, 0(r3)
		stb       r0, 0(r4)
		stb       r0, 0(r5)
		blt       loc_800332F0
		lis       r9, 0x51EC
loc_80033188:
		lhz       r10, 0(r3)
		mr        r0, r6
		li        r11, 1
		li        r12, 0
		slwi      r7, r10, 30
		srwi      r8, r10, 31
		subf      r7, r8, r7
		rotlwi    r7, r7, 2
		add.      r7, r7, r8
		bne       loc_800331D4
		addi      r7, r9, -0x7AE1 
		mulhw     r7, r7, r10
		srawi     r7, r7, 5
		srwi      r8, r7, 31
		add       r7, r7, r8
		mulli     r7, r7, 0x64
		subf.     r7, r7, r10
		beq       loc_800331D4
		li        r12, 1
loc_800331D4:
		cmpwi     r12, 0
		bne       loc_80033200
		addi      r7, r9, -0x7AE1 
		mulhw     r7, r7, r10
		srawi     r7, r7, 7
		srwi      r8, r7, 31
		add       r7, r7, r8
		mulli     r7, r7, 0x190
		subf.     r7, r7, r10
		beq       loc_80033200
		li        r11, 0
loc_80033200:
		neg       r7, r11
		or        r7, r7, r11
		srwi      r7, r7, 31
		addi      r7, r7, 0x16D
		subf.     r6, r7, r6
		bge       loc_80033220
		mr        r6, r0
		b         loc_80033230
loc_80033220:
		lhz       r7, 0(r3)
		addi      r0, r7, 1
		sth       r0, 0(r3)
		b         loc_80033188
loc_80033230:
		lis       r9, DAYS_OF_MONTH@ha
		lis       r11, 0x51EC
		addi      r9, r9, DAYS_OF_MONTH@l
loc_8003323C:
		lbz       r0, 0(r4)
		mr        r7, r6
		cmplwi    r0, 2
		bne       loc_800332C0
		lhz       r31, 0(r3)
		li        r12, 0
		slwi      r8, r31, 30
		srwi      r10, r31, 31
		subf      r8, r10, r8
		rotlwi    r8, r8, 2
		add.      r8, r8, r10
		bne       loc_8003328C
		addi      r8, r11, -0x7AE1 
		mulhw     r8, r8, r31
		srawi     r8, r8, 5
		srwi      r10, r8, 31
		add       r8, r8, r10
		mulli     r8, r8, 0x64
		subf.     r8, r8, r31
		bne       loc_800332AC
loc_8003328C:
		addi      r8, r11, -0x7AE1 
		mulhw     r8, r8, r31
		srawi     r8, r8, 7
		srwi      r10, r8, 31
		add       r8, r8, r10
		mulli     r8, r8, 0x190
		subf.     r8, r8, r31
		bne       loc_800332B0
loc_800332AC:
		li        r12, 1
loc_800332B0:
		cmpwi     r12, 0
		beq       loc_800332C0
		addi      r6, r6, -0x1D
		b         loc_800332CC
loc_800332C0:
		add       r8, r9, r0
		lbz       r0, -1(r8)
		subf      r6, r0, r6
loc_800332CC:
		cmpwi     r6, 0
		blt       loc_800332E4
		lbz       r7, 0(r4)
		addi      r0, r7, 1
		stb       r0, 0(r4)
		b         loc_8003323C
loc_800332E4:
		lbz       r0, 0(r5)
		add       r0, r0, r7
		stb       r0, 0(r5)
loc_800332F0:
		lwz       r31, 0x10+var_4(r1)
		addi      r1, r1, 0x10
		blr


.global NWC24iOpenFriendList
NWC24iOpenFriendList:
.set back_chain, -0x10
.set var_8, -8
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		li        r4, 0
		li        r5, 0x360
		stw       r0, 0x10+sender_lr(r1)
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r3, 0(r9)
		addi      r3, r3, 0x2A00
		stw       r3, 0x10+var_8(r1)
		bl        Mail_memset
		addi      r3, r1, 0x10+var_8
		bl        GetCachedFLHeader
		lwz       r0, 0x10+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x10
		blr


GetCachedFLHeader:
.set back_chain, -0xB0
.set var_A8, -0xA8
.set var_8, -8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0xB0+sender_lr(r1)
		stw       r31, 0xB0+var_4(r1)
		stw       r30, 0xB0+var_8(r1)
		mr        r30, r3
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r4, 0(r9)
		addi      r4, r4, 0x2A00
		stw       r4, 0(r3)
		lwz       r3, 0(r4)
		addis     r0, r3, -0x5763
		cmplwi    r0, 0x466C
		beq       loc_800333FC
		lis       r9, FLFilePath@h
		ori       r9, r9, FLFilePath@l
		lwz       r4, 0(r9)
		addi      r3, r1, 0xB0+var_A8
		li        r5, 2
		bl        NWC24FOpen
		cmpwi     r3, 0
		beq       loc_80033388
		b         loc_80033400
loc_80033388:
		addi      r3, r1, 0xB0+var_A8
		li        r4, 0
		li        r5, 0
		bl        NWC24FSeek
		lwz       r3, 0(r30)
		addi      r5, r1, 0xB0+var_A8
		li        r4, 0x360
		bl        NWC24FRead
		mr        r31, r3
		addi      r3, r1, 0xB0+var_A8
		bl        NWC24FClose
		cmpwi     r31, 0
		beq       loc_800333C0
		mr        r3, r31
loc_800333C0:
		cmpwi     r3, 0
		beq       loc_800333CC
		b         loc_80033400
loc_800333CC:
		lwz       r4, 0(r30)
		lwz       r3, 0(r4)
		addis     r0, r3, -0x5763
		cmplwi    r0, 0x466C
		beq       loc_800333E8
		li        r3, -0xE
		b         loc_80033400
loc_800333E8:
		lwz       r0, 4(r4)
		cmplwi    r0, 2
		beq       loc_800333FC
		li        r3, -0x1B
		b         loc_80033400
loc_800333FC:
		li        r3, 0
loc_80033400:
		lwz       r0, 0xB0+sender_lr(r1)
		lwz       r31, 0xB0+var_4(r1)
		lwz       r30, 0xB0+var_8(r1)
		mtlr      r0
		addi      r1, r1, 0xB0
		blr


.global NWC24iOpenSecretFriendList
NWC24iOpenSecretFriendList:
.set back_chain, -0x10
.set var_8, -8
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		li        r4, 0
		li        r5, 0x800
		stw       r0, 0x10+sender_lr(r1)
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r3, 0(r9)
		addi      r3, r3, 0x2E00
		stw       r3, 0x10+var_8(r1)
		bl        Mail_memset
		addi      r3, r1, 0x10+var_8
		bl        GetCachedSecretFLHeader
		lwz       r0, 0x10+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x10
		blr


GetCachedSecretFLHeader:
.set back_chain, -0xB0
.set var_A8, -0xA8
.set var_8, -8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0xB0+sender_lr(r1)
		stw       r31, 0xB0+var_4(r1)
		stw       r30, 0xB0+var_8(r1)
		mr        r30, r3
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r4, 0(r9)
		addi      r4, r4, 0x2E00
		stw       r4, 0(r3)
		lwz       r3, 0(r4)
		addis     r0, r3, -0x5763
		cmplwi    r0, 0x4673
		beq       loc_80033518
		lis       r9, FLFilePath_0@h
		ori       r9, r9, FLFilePath_0@l
		lwz       r4, 0(r9)
		addi      r3, r1, 0xB0+var_A8
		li        r5, 2
		bl        NWC24FOpen
		cmpwi     r3, 0
		beq       loc_800334A4
		b         loc_8003351C
loc_800334A4:
		addi      r3, r1, 0xB0+var_A8
		li        r4, 0
		li        r5, 0
		bl        NWC24FSeek
		lwz       r3, 0(r30)
		addi      r5, r1, 0xB0+var_A8
		li        r4, 0x800
		bl        NWC24FRead
		mr        r31, r3
		addi      r3, r1, 0xB0+var_A8
		bl        NWC24FClose
		cmpwi     r31, 0
		beq       loc_800334DC
		mr        r3, r31
loc_800334DC:
		cmpwi     r3, 0
		beq       loc_800334E8
		b         loc_8003351C
loc_800334E8:
		lwz       r4, 0(r30)
		lwz       r3, 0(r4)
		addis     r0, r3, -0x5763
		cmplwi    r0, 0x4673
		beq       loc_80033504
		li        r3, -0xE
		b         loc_8003351C
loc_80033504:
		lwz       r0, 4(r4)
		cmplwi    r0, 2
		beq       loc_80033518
		li        r3, -0x1B
		b         loc_8003351C
loc_80033518:
		li        r3, 0
loc_8003351C:
		lwz       r0, 0xB0+sender_lr(r1)
		lwz       r31, 0xB0+var_4(r1)
		lwz       r30, 0xB0+var_8(r1)
		mtlr      r0
		addi      r1, r1, 0xB0
		blr


.global __shr2u
__shr2u:				
		subfic    r8, r5, 0x20
		addic     r9, r5, -0x20
		srw       r4, r4, r5
		slw       r10, r3, r8
		or        r4, r4, r10
		srw       r10, r3, r9
		or        r4, r4, r10
		srw       r3, r3, r5
		blr


.global NWC24iCheckUserIdCRC
NWC24iCheckUserIdCRC:
.set back_chain, -0x20
.set var_C, -0xC
.set var_8, -8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x20+sender_lr(r1)
		stw       r31, 0x20+var_4(r1)
		stw       r30, 0x20+var_8(r1)
		stw       r29, 0x20+var_C(r1)
		bl        getUnScrambleId
		mr        r30, r4
		mr        r31, r3
		li        r29, 0
loc_8003355C:
		addi      r0, r29, 1
		mr        r3, r31
		mr        r4, r30
		subfic    r5, r0, 0x35
		bl        __shr2u
		clrlwi.   r0, r4, 31
		beq       loc_80033590
		subfic    r5, r29, 0x2A
		li        r4, 0x635
		li        r3, 0
		bl        __shl2i
		xor       r30, r30, r4
		xor       r31, r31, r3
loc_80033590:
		addi      r29, r29, 1
		cmpwi     r29, 0x2B
		blt       loc_8003355C
		or.       r0, r30, r31
		beq       loc_800335AC
		li        r3, -0x25
		b         loc_800335B0
loc_800335AC:
		li        r3, 0
loc_800335B0:
		lwz       r0, 0x20+sender_lr(r1)
		lwz       r31, 0x20+var_4(r1)
		lwz       r30, 0x20+var_8(r1)
		lwz       r29, 0x20+var_C(r1)
		mtlr      r0
		addi      r1, r1, 0x20
		blr


getUnScrambleId:
.set back_chain, -0x20
.set var_C, -0xC
.set var_8, -8
.set var_4, -4
		li        r9, -1
		lis       r7, 0x20
		lis       r6, 0x5E5E
		stwu      r1, back_chain(r1)
		addi      r7, r7, -1 
		and       r8, r4, r9
		addi      r0, r6, 0x5E5E 
		stw       r31, 0x20+var_4(r1)
		and       r3, r3, r7
		lis       r5, -1
		xor       r8, r8, r0
		stw       r30, 0x20+var_8(r1)
		and       r8, r8, r9
		xori      r3, r3, 0x5E5E
		clrlslwi  r0, r8, 31,21
		li        r6, -0x100
		and       r3, r3, r7
		rotrwi    r8, r8, 1
		or        r3, r3, r0
		stw       r29, 0x20+var_C(r1)
		insrwi    r8, r3, 1,0
		lis       r4, -0xFF
		srwi      r7, r3, 1
		addi      r5, r5, 0xFF 
		rotrwi    r30, r8, 8
		extrwi    r29, r3, 8,15
		and       r12, r7, r9
		li        r0, 0
		rlwimi    r30, r3, 23,0,7
		and       r31, r8, r6
		insrwi    r31, r30, 8,24
		rlwinm    r11, r3, 31,16,23
		and       r30, r31, r5
		and       r12, r12, r9
		inslwi    r0, r29, 8,24
		addi      r4, r4, -1 
		or        r12, r12, r0
		or        r11, r30, r11
		and       r30, r11, r4
		clrlwi    r31, r8, 24
		li        r0, 0
		clrlslwi  r11, r8, 24,16
		lis       r10, 0x100
		and       r12, r12, r9
		inslwi    r0, r31, 16,16
		or        r30, r30, r11
		or        r29, r12, r0
		extrwi    r12, r3, 8,23
		addi      r0, r10, -1 
		li        r10, 0
		inslwi    r10, r12, 24,8
		and       r11, r29, r9
		and       r12, r30, r0
		extlwi    r3, r3, 8,23
		or        r3, r12, r3
		or        r12, r11, r10
		and       r10, r3, r9
		lis       r3, TtableInv@ha
		and       r31, r10, r9
		rotrwi    r30, r8, 16
		extrwi    r11, r31, 4,24
		addi      r3, r3, TtableInv@l
		insrwi    r30, r7, 16,0
		clrlwi    r10, r31, 28
		and       r29, r12, r6
		rotlwi    r12, r8, 8
		lbzx      r11, r3, r11
		insrwi    r12, r7, 24,0
		lbzx      r7, r3, r10
		insrwi    r29, r30, 8,24
		slwi      r8, r11, 4
		clrlslwi  r10, r12, 24,8
		and       r11, r29, r5
		or        r10, r11, r10
		or        r7, r8, r7
		and       r11, r31, r6
		li        r8, 0
		insrwi    r11, r7, 8,24
		and       r12, r10, r9
		rotrwi    r10, r11, 8
		li        r7, 0
		insrwi    r10, r12, 8,0
		and       r31, r11, r5
		extrwi    r11, r10, 4,24
		and       r12, r12, r9
		clrlwi    r10, r10, 28
		lbzx      r11, r3, r11
		lbzx      r10, r3, r10
		slwi      r11, r11, 4
		or        r10, r11, r10
		clrlwi    r11, r10, 24
		clrlslwi  r10, r10, 24,8
		inslwi    r8, r11, 8,24
		or        r10, r31, r10
		or        r8, r12, r8
		rotrwi    r12, r10, 16
		and       r11, r10, r4
		insrwi    r12, r8, 16,0
		and       r10, r8, r9
		extrwi    r8, r12, 4,24
		clrlwi    r4, r12, 28
		lbzx      r8, r3, r8
		lbzx      r4, r3, r4
		slwi      r8, r8, 4
		or        r4, r8, r4
		clrlwi    r8, r4, 24
		clrlslwi  r4, r4, 24,16
		or        r29, r11, r4
		inslwi    r7, r8, 16,16
		or        r11, r10, r7
		lis       r4, 1
		rotlwi    r8, r29, 8
		and       r31, r29, r0
		insrwi    r8, r11, 24,0
		and       r12, r11, r9
		extrwi    r10, r8, 4,24
		addi      r0, r4, -0x4C4D 
		lbzx      r11, r3, r10
		clrlwi    r8, r8, 28
		lbzx      r10, r3, r8
		li        r8, 0
		slwi      r11, r11, 4
		lis       r7, -0x4C4C
		or        r11, r11, r10
		clrlwi    r10, r11, 24
		addi      r7, r7, -0x4C4D 
		inslwi    r8, r10, 24,8
		slwi      r4, r11, 24
		or        r10, r12, r8
		extrwi    r8, r10, 4,24
		or        r12, r31, r4
		clrlwi    r4, r10, 28
		lbzx      r8, r3, r8
		and       r11, r10, r6
		lbzx      r4, r3, r4
		slwi      r6, r8, 4
		and       r8, r12, r9
		or        r4, r6, r4
		insrwi    r11, r4, 8,24
		and       r10, r8, r9
		extrwi    r6, r11, 4,16
		extrwi    r4, r11, 4,20
		lbzx      r6, r3, r6
		lbzx      r3, r3, r4
		and       r8, r11, r5
		slwi      r5, r6, 4
		and       r4, r10, r9
		or        r3, r5, r3
		clrlslwi  r3, r3, 24,8
		or        r3, r8, r3
		clrlslwi  r5, r3, 21,10
		extrwi    r3, r3, 10,11
		inslwi    r5, r4, 10,22
		insrwi    r3, r4, 22,0
		xor       r4, r3, r7
		xor       r3, r5, r0
		lwz       r31, 0x20+var_4(r1)
		lwz       r30, 0x20+var_8(r1)
		lwz       r29, 0x20+var_C(r1)
		addi      r1, r1, 0x20
		blr


.global NWC24iGetUniversalTimeMinute
NWC24iGetUniversalTimeMinute:
.set back_chain, -0x20
.set var_18, -0x18
.set var_14, -0x14
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x20+sender_lr(r1)
		li        r0, 0
		stw       r31, 0x20+var_4(r1)
		mr        r31, r3
		addi      r3, r1, 0x20+var_18
		stw       r0, 0x20+var_14(r1)
		stw       r0, 0x20+var_18(r1)
		bl        NWC24iGetUniversalTime
		cmpwi     r3, 0
		bge       loc_80033884
		b         loc_80033894
loc_80033884:
		lwz       r5, 0x20+var_18(r1)
		mr        r3, r31
		lwz       r6, 0x20+var_14(r1)
		bl        NWC24iEpochSecondsToMinutes
loc_80033894:
		lwz       r0, 0x20+sender_lr(r1)
		lwz       r31, 0x20+var_4(r1)
		mtlr      r0
		addi      r1, r1, 0x20
		blr


.global NWC24iGetUniversalTime
NWC24iGetUniversalTime:
.set back_chain, -0x10
.set var_8, -8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		cmpwi     r3, 0
		stw       r0, 0x10+sender_lr(r1)
		stw       r31, 0x10+var_4(r1)
		mr        r31, r3
		stw       r30, 0x10+var_8(r1)
		bne       loc_800338DC
		li        r0, 0
		li        r3, -3
		lis       r9, dword_8008373C@h
		ori       r9, r9, dword_8008373C@l
		stw       r0, 0(r9)
		lis       r9, nwc24TimeDifference@h
		ori       r9, r9, nwc24TimeDifference@l
		stw       r0, 0(r9)
		b         loc_800339D0
loc_800338DC:
		lis       r9, whenCached_716@h
		ori       r9, r9, whenCached_716@l
		lwz       r0, 0(r9)
		lis       r9, dword_80083744@h
		ori       r9, r9, dword_80083744@l
		lwz       r3, 0(r9)
		or.       r0, r3, r0
		beq       loc_80033938
		bl        __OSGetSystemTime
		lis       r5, -0x8000
		lis       r9, dword_80083744@h
		ori       r9, r9, dword_80083744@l
		lwz       r8, 0(r9)
		lwz       r6, 0xF8(r5)
		xoris     r0, r3, 0x8000
		lis       r9, whenCached_716@h
		ori       r9, r9, whenCached_716@l
		lwz       r7, 0(r9)
		li        r5, 0
		srwi      r3, r6, 2
		addc      r6, r8, r3
		adde      r3, r7, r5
		xoris     r5, r3, 0x8000
		subfc     r3, r6, r4
		subfe     r5, r5, r0
		subfe     r5, r0, r0
		neg.      r5, r5
		beq       loc_80033938
		lis       r9, nwc24TimeRtc@h
		ori       r9, r9, nwc24TimeRtc@l
		lwz       r0, 0(r9)
		cmpwi     r0, 0
		bne       loc_800339AC
loc_80033938:
		lis       r3, nwc24TimeDifference@h
		ori       r3, r3, nwc24TimeDifference@l

		bl        NWC24iGetTimeDifference
		cmpwi     r3, 0
		bge       loc_8003394C
		b         loc_800339D0
loc_8003394C:
		bl        SCCheckStatus
		cmplwi    r3, 2
		bne       loc_80033960
		li        r3, -1
		b         loc_80033994
loc_80033960:
		cmpwi     r3, 0
		bne       loc_8003394C
		bl        SCGetCounterBias
		mr        r30, r3
		bl        OSGetTime
		lis       r6, -0x8000
		li        r5, 0
		lwz       r0, 0xF8(r6)
		srwi      r6, r0, 2
		bl        __div2i
		subfc     r0, r30, r4
		li        r3, 0
		lis       r9, nwc24TimeRtc@h
		ori       r9, r9, nwc24TimeRtc@l
		stw       r0, 0(r9)
loc_80033994:
		cmpwi     r3, 0
		beq       loc_800339A0
		b         loc_800339D0
loc_800339A0:
		bl        __OSGetSystemTime
		lis       r9, dword_80083744@h
		ori       r9, r9, dword_80083744@l
		stw       r4, 0(r9)
		lis       r9, whenCached_716@h
		ori       r9, r9, whenCached_716@l
		stw       r3, 0(r9)
loc_800339AC:
		lis       r9, dword_8008373C@h
		ori       r9, r9, dword_8008373C@l
		lwz       r6, 0(r9)
		li        r0, 0
		lis       r9, nwc24TimeRtc@h
		ori       r9, r9, nwc24TimeRtc@l
		lwz       r4, 0(r9)
		li        r3, 0
		lis       r9, nwc24TimeDifference@h
		ori       r9, r9, nwc24TimeDifference@l
		lwz       r5, 0(r9)
		addc      r4, r6, r4
		adde      r0, r5, r0
		stw       r4, 4(r31)
		stw       r0, 0(r31)
loc_800339D0:
		lwz       r0, 0x10+sender_lr(r1)
		lwz       r31, 0x10+var_4(r1)
		lwz       r30, 0x10+var_8(r1)
		mtlr      r0
		addi      r1, r1, 0x10
		blr


.global NWC24iGetTimeDifference
NWC24iGetTimeDifference:
.set back_chain, -0x20
.set var_18, -0x18
.set var_10, -0x10
.set var_C, -0xC
.set var_8, -8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x20+sender_lr(r1)
		stw       r31, 0x20+var_4(r1)
		stw       r30, 0x20+var_8(r1)
		lis       r30, buf_691@ha
		addi      r30, r30, buf_691@l
		stw       r29, 0x20+var_C(r1)
		stw       r28, 0x20+var_10(r1)
		mr        r28, r3
		bl        OSGetCurrentThread
		cmpwi     r3, 0
		bne       loc_80033A24
		li        r3, -1
		b         loc_80033A28
loc_80033A24:
		li        r3, 0
loc_80033A28:
		cmpwi     r3, 0
		bge       loc_80033A34
		b         loc_80033B3C
loc_80033A34:
		lis       r9, nwc24TimeInitialized@h
		ori       r9, r9, nwc24TimeInitialized@l
		lwz       r0, 0(r9)
		cmpwi     r0, 0
		bne       loc_80033A8C
		bl        __RAS_OSDisableInterrupts_begin
		lis       r9, nwc24TimeInitialized@h
		ori       r9, r9, nwc24TimeInitialized@l
		lwz       r0, 0(r9)
		mr        r31, r3
		cmpwi     r0, 0
		bne       loc_80033A84
		lis       r3, nwc24TimeCommandMutex@h
		ori       r3, r3, nwc24TimeCommandMutex@l

		bl        OSInitMutex
		lis       r3, nwc24TimeCommonBuffer@h
		ori       r3, r3, nwc24TimeCommonBuffer@l

		li        r4, 0
		li        r5, 0x20
		bl        memset
		lis       r3, nwc24TimeCommonResult@h
		ori       r3, r3, nwc24TimeCommonResult@l

		li        r4, 0
		li        r5, 0x20
		bl        memset
		li        r0, 1
		lis       r9, nwc24TimeInitialized@h
		ori       r9, r9, nwc24TimeInitialized@l
		stw       r0, 0(r9)
loc_80033A84:
		mr        r3, r31
		bl        OSRestoreInterrupts
loc_80033A8C:
		lis       r3, nwc24TimeCommandMutex@h
		ori       r3, r3, nwc24TimeCommandMutex@l

		bl        OSLockMutex
		lis       r31, __FUNCTION___733@ha
		lis       r4, _974@ha
		addi      r3, r31, __FUNCTION___733@l 
		addi      r5, r1, 0x20+var_18
		addi      r4, r4, _974@l 
		li        r6, 0
		bl        NWC24iOpenResourceManager
		cmpwi     r3, 0
		mr        r29, r3
		blt       loc_80033B30
		lwz       r4, 0x20+var_18(r1)
		addi      r3, r31, __FUNCTION___733@l 
		lis       r8, nwc24TimeCommonResult@h
		ori       r8, r8, nwc24TimeCommonResult@l

		li        r5, 0x18
		li        r6, 0
		li        r7, 0
		li        r9, 0x20
		bl        NWC24iIoctlResourceManager
		cmpwi     r3, 0
		mr        r29, r3
		blt       loc_80033B14
		lis       r9, nwc24TimeCommonResult@h
		ori       r9, r9, nwc24TimeCommonResult@l
		lwz       r29, 0(r9)
		cmpwi     r29, 0
		bne       loc_80033B14
		li        r0, 0
		cmplw     r28, r0
		beq       loc_80033B14
		lis       r3, nwc24TimeCommonResult@h
		ori       r3, r3, nwc24TimeCommonResult@l

		lis       r9, dword_80092AA4@h
		ori       r9, r9, dword_80092AA4@l
		lwz       r0, 0(r9)
		lis       r9, dword_80092AA8@h
		ori       r9, r9, dword_80092AA8@l
		lwz       r3, 0(r9)
		stw       r3, 4(r28)
		stw       r0, 0(r28)
loc_80033B14:
		lis       r3, __FUNCTION___733@ha
		lwz       r4, 0x20+var_18(r1)
		addi      r3, r3, __FUNCTION___733@l 
		bl        NWC24iCloseResourceManager
		cmpwi     r29, 0
		blt       loc_80033B30
		mr        r29, r3
loc_80033B30:
		lis       r3, nwc24TimeCommandMutex@h
		ori       r3, r3, nwc24TimeCommandMutex@l

		bl        OSUnlockMutex
		mr        r3, r29
loc_80033B3C:
		lwz       r0, 0x20+sender_lr(r1)
		lwz       r31, 0x20+var_4(r1)
		lwz       r30, 0x20+var_8(r1)
		lwz       r29, 0x20+var_C(r1)
		lwz       r28, 0x20+var_10(r1)
		mtlr      r0
		addi      r1, r1, 0x20
		blr


.global NWC24iSetRtcCounter
NWC24iSetRtcCounter:
.set back_chain, -0x30
.set var_28, -0x28
.set pre_back_chain,  0
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x30+sender_lr(r1)
		addi      r11, r1, 0x30+pre_back_chain
		bl        _savegpr_27
		lis       r30, buf_691@ha
		mr        r27, r3
		mr        r28, r4
		addi      r30, r30, buf_691@l
		bl        OSGetCurrentThread
		cmpwi     r3, 0
		bne       loc_80033B94
		li        r3, -1
		b         loc_80033B98
loc_80033B94:
		li        r3, 0
loc_80033B98:
		cmpwi     r3, 0
		bge       loc_80033BA4
		b         loc_80033C8C
loc_80033BA4:
		lis       r9, nwc24TimeInitialized@h
		ori       r9, r9, nwc24TimeInitialized@l
		lwz       r0, 0(r9)
		cmpwi     r0, 0
		bne       loc_80033BFC
		bl        __RAS_OSDisableInterrupts_begin
		lis       r9, nwc24TimeInitialized@h
		ori       r9, r9, nwc24TimeInitialized@l
		lwz       r0, 0(r9)
		mr        r31, r3
		cmpwi     r0, 0
		bne       loc_80033BF4
		lis       r3, nwc24TimeCommandMutex@h
		ori       r3, r3, nwc24TimeCommandMutex@l

		bl        OSInitMutex
		lis       r3, nwc24TimeCommonBuffer@h
		ori       r3, r3, nwc24TimeCommonBuffer@l

		li        r4, 0
		li        r5, 0x20
		bl        memset
		lis       r3, nwc24TimeCommonResult@h
		ori       r3, r3, nwc24TimeCommonResult@l

		li        r4, 0
		li        r5, 0x20
		bl        memset
		li        r0, 1
		lis       r9, nwc24TimeInitialized@h
		ori       r9, r9, nwc24TimeInitialized@l
		stw       r0, 0(r9)
loc_80033BF4:
		mr        r3, r31
		bl        OSRestoreInterrupts
loc_80033BFC:
		lis       r3, nwc24TimeCommandMutex@h
		ori       r3, r3, nwc24TimeCommandMutex@l

		bl        OSLockMutex
		lis       r31, __FUNCTION___753@ha
		lis       r4, _974@ha
		addi      r3, r31, __FUNCTION___753@l 
		addi      r5, r1, 0x30+var_28
		addi      r4, r4, _974@l 
		li        r6, 0
		bl        NWC24iOpenResourceManager
		cmpwi     r3, 0
		mr        r29, r3
		blt       loc_80033C80
		lis       r6, nwc24TimeCommonBuffer@h
		ori       r6, r6, nwc24TimeCommonBuffer@l

		lis       r9, nwc24TimeCommonBuffer@h
		ori       r9, r9, nwc24TimeCommonBuffer@l
		stw       r27, 0(r9)
		lwz       r4, 0x30+var_28(r1)
		addi      r3, r31, __FUNCTION___753@l 
		lis       r9, dword_80092A84@h
		ori       r9, r9, dword_80092A84@l
		stw       r28, 0(r9)
		lis       r8, nwc24TimeCommonResult@h
		ori       r8, r8, nwc24TimeCommonResult@l

		li        r5, 0x17
		li        r7, 0x20
		li        r9, 0x20
		bl        NWC24iIoctlResourceManager
		cmpwi     r3, 0
		mr        r29, r3
		blt       loc_80033C64
		lis       r9, nwc24TimeCommonResult@h
		ori       r9, r9, nwc24TimeCommonResult@l
		lwz       r29, 0(r9)
loc_80033C64:
		lis       r3, __FUNCTION___753@ha
		lwz       r4, 0x30+var_28(r1)
		addi      r3, r3, __FUNCTION___753@l 
		bl        NWC24iCloseResourceManager
		cmpwi     r29, 0
		blt       loc_80033C80
		mr        r29, r3
loc_80033C80:
		lis       r3, nwc24TimeCommandMutex@h
		ori       r3, r3, nwc24TimeCommandMutex@l

		bl        OSUnlockMutex
		mr        r3, r29
loc_80033C8C:
		addi      r11, r1, 0x30+pre_back_chain
		bl        _restgpr_27
		lwz       r0, 0x30+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x30
		blr


.global NWC24iSynchronizeRtcCounter
NWC24iSynchronizeRtcCounter:
.set back_chain, -0x10
.set var_8, -8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x10+sender_lr(r1)
		stw       r31, 0x10+var_4(r1)
		stw       r30, 0x10+var_8(r1)
		mr        r30, r3
loc_80033CBC:
		bl        SCCheckStatus
		cmplwi    r3, 2
		bne       loc_80033CD0
		li        r3, -1
		b         loc_80033D00
loc_80033CD0:
		cmpwi     r3, 0
		bne       loc_80033CBC
		bl        SCGetCounterBias
		mr        r31, r3
		bl        OSGetTime
		lis       r6, -0x8000
		li        r5, 0
		lwz       r0, 0xF8(r6)
		srwi      r6, r0, 2
		bl        __div2i
		subfc     r31, r31, r4
		li        r3, 0
loc_80033D00:
		cmpwi     r3, 0
		beq       loc_80033D0C
		b         loc_80033D20
loc_80033D0C:
		neg       r0, r30
		mr        r3, r31
		or        r0, r0, r30
		srwi      r4, r0, 31
		bl        NWC24iSetRtcCounter
loc_80033D20:
		lwz       r0, 0x10+sender_lr(r1)
		lwz       r31, 0x10+var_4(r1)
		lwz       r30, 0x10+var_8(r1)
		mtlr      r0
		addi      r1, r1, 0x10
		blr


.global NWC24iOpenResourceManager
NWC24iOpenResourceManager:
.set back_chain, -0x10
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		cmpwi     r5, 0
		stw       r0, 0x10+sender_lr(r1)
		stw       r31, 0x10+var_4(r1)
		mr        r31, r5
		bne       loc_80033D5C
		li        r3, -3
		b         loc_80033D9C
loc_80033D5C:
		mr        r3, r4
		mr        r4, r6
		bl        IOS_Open
		cmpwi     r3, 0
		stw       r3, 0(r31)
		bge       loc_80033D98
		cmpwi     r3, -6
		bne       loc_80033D84
		li        r3, -0x1D
		b         loc_80033D9C
loc_80033D84:
		cmpwi     r3, -8
		li        r3, -0x2A
		bne       loc_80033D9C
		li        r3, -0x1A
		b         loc_80033D9C
loc_80033D98:
		li        r3, 0
loc_80033D9C:
		lwz       r0, 0x10+sender_lr(r1)
		lwz       r31, 0x10+var_4(r1)
		mtlr      r0
		addi      r1, r1, 0x10
		blr


.global NWC24iCloseResourceManager
NWC24iCloseResourceManager:
.set back_chain, -0x10
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		mr        r3, r4
		stw       r0, 0x10+sender_lr(r1)
		bl        IOS_Close
		cmpwi     r3, 0
		li        r3, 0
		bge       loc_80033DD4
		li        r3, -0x2A
loc_80033DD4:
		lwz       r0, 0x10+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x10
		blr


.global NWC24iIoctlResourceManager
NWC24iIoctlResourceManager:
.set back_chain, -0x10
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		mr        r3, r4
		mr        r4, r5
		stw       r0, 0x10+sender_lr(r1)
		mr        r5, r6
		mr        r6, r7
		mr        r7, r8
		mr        r8, r9
		bl        IOS_Ioctl
		cmpwi     r3, 0
		li        r3, 0
		bge       loc_80033E1C
		li        r3, -0x2A
loc_80033E1C:
		lwz       r0, 0x10+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x10
		blr


.global NWC24iIoctlResourceManagerAsync
NWC24iIoctlResourceManagerAsync:
.set back_chain, -0x10
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		mr        r3, r4
		mr        r4, r5
		stw       r0, 0x10+sender_lr(r1)
		lis       r11, CallbackAsyncIpc@ha
		mr        r5, r6
		mr        r6, r7
		mr        r7, r8
		mr        r8, r9
		addi      r9, r11, CallbackAsyncIpc@l
		bl        IOS_IoctlAsync
		cmpwi     r3, 0
		bge       loc_80033E6C
		li        r3, -0x2A
		b         loc_80033E78
loc_80033E6C:
		li        r0, 1
		li        r3, 0
		lis       r9, NWC24iIsRequestPending@h
		ori       r9, r9, NWC24iIsRequestPending@l
		stw       r0, 0(r9)
loc_80033E78:
		lwz       r0, 0x10+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x10
		blr


.global NWC24iIsAsyncRequestPending
NWC24iIsAsyncRequestPending:
		lis       r9, NWC24iIsRequestPending@h
		ori       r9, r9, NWC24iIsRequestPending@l
		lwz       r3, 0(r9)
		blr


CallbackAsyncIpc:
		cmpwi     r4, 0
		beq       loc_80033E9C
		stw       r3, 0(r4)
loc_80033E9C:
		li        r0, 0
		li        r3, 0
		lis       r9, NWC24iIsRequestPending@h
		ori       r9, r9, NWC24iIsRequestPending@l
		stw       r0, 0(r9)
		blr


.global NWC24CheckDlTask
NWC24CheckDlTask:
.set back_chain, -0x20
.set var_10, -0x10
.set var_C, -0xC
.set var_8, -8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x20+sender_lr(r1)
		stw       r31, 0x20+var_4(r1)
		stw       r30, 0x20+var_8(r1)
		stw       r29, 0x20+var_C(r1)
		stw       r28, 0x20+var_10(r1)
		mr        r28, r3
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r5, 0(r9)
		cmpwi     r5, 0
		beq       loc_80033EE0
		addi      r30, r5, 0x3600
		b         loc_80033EE4
loc_80033EE0:
		li        r30, 0
loc_80033EE4:
		cmpwi     r3, 0
		bne       loc_80033EF4
		li        r3, -3
		b         loc_80033FB4
loc_80033EF4:
		cmpwi     r30, 0
		bne       loc_80033F04
		li        r3, -9
		b         loc_80033FB4
loc_80033F04:
		lwz       r0, 8(r3)
		cmpwi     r0, 0
		beq       loc_80033F1C
		lwz       r0, 0x10(r3)
		cmpwi     r0, 0
		bne       loc_80033F24
loc_80033F1C:
		li        r3, -3
		b         loc_80033FB4
loc_80033F24:
		cmpwi     r4, 0
		beq       loc_80033F90
		bl        NWC24IsMsgLibOpenedByTool
		cmpwi     r3, 0
		bne       loc_80033F90
		lwz       r31, 8(r28)
		bl        NWC24GetAppId
		clrrwi    r3, r3, 8
		clrrwi    r0, r31, 8
		subf      r0, r0, r3
		cntlzw    r0, r0
		srwi.     r0, r0, 5
		bne       loc_80033F90
		lwz       r0, 4(r28)
		li        r31, 0
		lhz       r29, 0x14(r28)
		rlwinm.   r0, r0, 0,25,25
		beq       loc_80033F80
		bl        NWC24GetGroupId
		clrlwi    r0, r3, 16
		cmplw     r29, r0
		bne       loc_80033F80
		li        r31, 1
loc_80033F80:
		cmpwi     r31, 0
		bne       loc_80033F90
		li        r3, -7
		b         loc_80033FB4
loc_80033F90:
		lhz       r3, 0(r28)
		cmplwi    r3, 0xFFFF
		beq       loc_80033FB0
		lhz       r0, 0x14(r30)
		cmplw     r3, r0
		blt       loc_80033FB0
		li        r3, -3
		b         loc_80033FB4
loc_80033FB0:
		li        r3, 0
loc_80033FB4:
		lwz       r0, 0x20+sender_lr(r1)
		lwz       r31, 0x20+var_4(r1)
		lwz       r30, 0x20+var_8(r1)
		lwz       r29, 0x20+var_C(r1)
		lwz       r28, 0x20+var_10(r1)
		mtlr      r0
		addi      r1, r1, 0x20
		blr


.global NWC24iOpenDlTaskList
NWC24iOpenDlTaskList:
.set back_chain, -0x10
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x10+sender_lr(r1)
		bl        NWC24iLoadDlHeader
		cmpwi     r3, 0
		blt       loc_80034020
		li        r3, 0
		bl        NWC24iSynchronizeRtcCounter
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r3, 0(r9)
		cmpwi     r3, 0
		beq       loc_80034008
		addi      r3, r3, 0x3600
		b         loc_8003400C
loc_80034008:
		li        r3, 0
loc_8003400C:
		li        r4, 0
		bl        NWC24iCheckDlHeaderConsistency
		cmpwi     r3, 0
		blt       loc_80034020
		li        r3, 0
loc_80034020:
		lwz       r0, 0x10+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x10
		blr


.global NWC24iCloseDlTaskList
NWC24iCloseDlTaskList:
		li        r3, 0
		blr


.global NWC24iCheckDlHeaderConsistency
NWC24iCheckDlHeaderConsistency:
.set back_chain, -0x2C0
.set var_2B8, -0x2B8
.set var_218, -0x218
.set var_200, -0x200
.set pre_back_chain,  0
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x2C0+sender_lr(r1)
		addi      r11, r1, 0x2C0+pre_back_chain
		bl        _savegpr_26
		addi      r31, r1, 0x2C0+var_218
		mr        r28, r3
		mr        r29, r4
		li        r30, 0
		lis       r27, 1
		b         loc_800343A0
loc_80034064:
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r5, 0(r9)
		clrlwi    r4, r30, 16
		cmpwi     r5, 0
		beq       loc_8003407C
		addi      r3, r5, 0x3600
		b         loc_80034080
loc_8003407C:
		li        r3, 0
loc_80034080:
		lhz       r0, 0x14(r3)
		cmplw     r4, r0
		bge       loc_80034098
		clrlwi    r0, r30, 16
		cmplwi    r0, 0xFFFF
		bne       loc_800340A0
loc_80034098:
		li        r4, -3
		b         loc_800340D0
loc_800340A0:
		cmpwi     r5, 0
		beq       loc_800340B0
		addi      r3, r5, 0x3600
		b         loc_800340B4
loc_800340B0:
		li        r3, 0
loc_800340B4:
		clrlslwi  r0, r30, 16,4
		li        r4, 0
		add       r3, r3, r0
		lwz       r0, 0x80(r3)
		cmpwi     r0, 0
		bne       loc_800340D0
		li        r4, -0xD
loc_800340D0:
		cmpwi     r4, 0
		bne       loc_8003439C
		cmpwi     r29, 0
		beq       loc_8003439C
		cmpwi     r5, 0
		beq       loc_800340F0
		addi      r0, r5, 0x3600
		b         loc_800340F4
loc_800340F0:
		li        r0, 0
loc_800340F4:
		cmpwi     r0, 0
		bne       loc_80034104
		li        r3, -9
		b         loc_80034224
loc_80034104:
		cmpwi     r5, 0
		clrlwi    r4, r30, 16
		beq       loc_80034118
		addi      r3, r5, 0x3600
		b         loc_8003411C
loc_80034118:
		li        r3, 0
loc_8003411C:
		lhz       r0, 0x14(r3)
		cmplw     r4, r0
		bge       loc_80034134
		clrlwi    r0, r30, 16
		cmplwi    r0, 0xFFFF
		bne       loc_8003413C
loc_80034134:
		li        r3, -3
		b         loc_8003416C
loc_8003413C:
		cmpwi     r5, 0
		beq       loc_8003414C
		addi      r4, r5, 0x3600
		b         loc_80034150
loc_8003414C:
		li        r4, 0
loc_80034150:
		clrlslwi  r0, r30, 16,4
		li        r3, 0
		add       r4, r4, r0
		lwz       r0, 0x80(r4)
		cmpwi     r0, 0
		bne       loc_8003416C
		li        r3, -0xD
loc_8003416C:
		cmpwi     r3, 0
		bge       loc_80034178
		b         loc_80034224
loc_80034178:
		lis       r9, DLFilePath@h
		ori       r9, r9, DLFilePath@l
		lwz       r4, 0(r9)
		addi      r3, r1, 0x2C0+var_2B8
		li        r5, 0xA
		bl        NWC24FOpen
		cmpwi     r3, 0
		bge       loc_80034194
		b         loc_80034224
loc_80034194:
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r3, 0(r9)
		cmpwi     r3, 0
		beq       loc_800341A8
		addi      r3, r3, 0x3600
		b         loc_800341AC
loc_800341A8:
		li        r3, 0
loc_800341AC:
		lhz       r3, 0x14(r3)
		cmplwi    r3, 0x78
		bgt       loc_800341C4
		clrlwi    r0, r30, 16
		cmplw     r0, r3
		blt       loc_800341CC
loc_800341C4:
		li        r3, -3
		b         loc_800341E0
loc_800341CC:
		clrlslwi  r4, r30, 16,9
		addi      r3, r1, 0x2C0+var_2B8
		addi      r4, r4, 0x800
		li        r5, 0
		bl        NWC24FSeek
loc_800341E0:
		cmpwi     r3, 0
		bge       loc_800341F0
		mr        r26, r3
		b         loc_80034210
loc_800341F0:
		mr        r3, r31
		addi      r5, r1, 0x2C0+var_2B8
		li        r4, 0x200
		bl        NWC24FRead
		cmpwi     r3, 0
		li        r26, 0
		bge       loc_80034210
		mr        r26, r3
loc_80034210:
		addi      r3, r1, 0x2C0+var_2B8
		bl        NWC24FClose
		cmpwi     r26, 0
		beq       loc_80034224
		mr        r3, r26
loc_80034224:
		cmpwi     r3, 0
		bge       loc_800342CC
		mr        r3, r31
		li        r4, 0
		bl        NWC24CheckDlTask
		cmpwi     r3, 0
		bne       loc_8003439C
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r5, 0(r9)
		lhz       r4, 0x2C0+var_218(r1)
		cmpwi     r5, 0
		beq       loc_80034258
		addi      r3, r5, 0x3600
		b         loc_8003425C
loc_80034258:
		li        r3, 0
loc_8003425C:
		lhz       r0, 0x14(r3)
		cmplw     r4, r0
		bge       loc_80034270
		cmplwi    r4, 0xFFFF
		bne       loc_80034278
loc_80034270:
		li        r4, -3
		b         loc_800342A8
loc_80034278:
		cmpwi     r5, 0
		beq       loc_80034288
		addi      r3, r5, 0x3600
		b         loc_8003428C
loc_80034288:
		li        r3, 0
loc_8003428C:
		clrlslwi  r0, r4, 16,4
		li        r4, 0
		add       r3, r3, r0
		lwz       r0, 0x80(r3)
		cmpwi     r0, 0
		bne       loc_800342A8
		li        r4, -0xD
loc_800342A8:
		cmpwi     r4, 0
		blt       loc_8003439C
		mr        r3, r31
		bl        DeleteDlTask
		cmpwi     r3, 0
		blt       loc_8003439C
		addi      r0, r27, -1 
		sth       r0, 0x2C0+var_218(r1)
		b         loc_8003439C
loc_800342CC:
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r3, 0(r9)
		clrlwi    r4, r30, 16
		cmpwi     r3, 0
		beq       loc_800342E4
		addi      r3, r3, 0x3600
		b         loc_800342E8
loc_800342E4:
		li        r3, 0
loc_800342E8:
		lhz       r0, 0x12(r3)
		cmplw     r4, r0
		blt       loc_8003439C
		lha       r0, 0x2C0+var_200(r1)
		cmpwi     r0, 0
		bne       loc_8003439C
		mr        r3, r31
		li        r4, 0
		bl        NWC24CheckDlTask
		cmpwi     r3, 0
		bne       loc_8003439C
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r5, 0(r9)
		lhz       r4, 0x2C0+var_218(r1)
		cmpwi     r5, 0
		beq       loc_8003432C
		addi      r3, r5, 0x3600
		b         loc_80034330
loc_8003432C:
		li        r3, 0
loc_80034330:
		lhz       r0, 0x14(r3)
		cmplw     r4, r0
		bge       loc_80034344
		cmplwi    r4, 0xFFFF
		bne       loc_8003434C
loc_80034344:
		li        r4, -3
		b         loc_8003437C
loc_8003434C:
		cmpwi     r5, 0
		beq       loc_8003435C
		addi      r3, r5, 0x3600
		b         loc_80034360
loc_8003435C:
		li        r3, 0
loc_80034360:
		clrlslwi  r0, r4, 16,4
		li        r4, 0
		add       r3, r3, r0
		lwz       r0, 0x80(r3)
		cmpwi     r0, 0
		bne       loc_8003437C
		li        r4, -0xD
loc_8003437C:
		cmpwi     r4, 0
		blt       loc_8003439C
		mr        r3, r31
		bl        DeleteDlTask
		cmpwi     r3, 0
		blt       loc_8003439C
		addi      r0, r27, -1 
		sth       r0, 0x2C0+var_218(r1)
loc_8003439C:
		addi      r30, r30, 1
loc_800343A0:
		lhz       r0, 0x14(r28)
		clrlwi    r3, r30, 16
		cmplw     r3, r0
		blt       loc_80034064
		addi      r11, r1, 0x2C0+pre_back_chain
		li        r3, 0
		bl        _restgpr_26
		lwz       r0, 0x2C0+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x2C0
		blr


.global NWC24iLoadDlHeader
NWC24iLoadDlHeader:
.set back_chain, -0x150
.set var_148, -0x148
.set var_144, -0x144
.set var_A8, -0xA8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		li        r5, 2
		stw       r0, 0x150+sender_lr(r1)
		addi      r3, r1, 0x150+var_A8
		stw       r31, 0x150+var_4(r1)
		li        r31, 0
		lis       r9, DLFilePath@h
		ori       r9, r9, DLFilePath@l
		lwz       r4, 0(r9)
		stw       r31, 0x150+var_148(r1)
		bl        NWC24FOpen
		cmpwi     r3, 0
		bge       loc_80034400
		b         loc_80034548
loc_80034400:
		addi      r3, r1, 0x150+var_A8
		li        r4, 0
		li        r5, 0
		bl        NWC24FSeek
		cmpwi     r3, 0
		bge       loc_8003441C
		b         loc_80034440
loc_8003441C:
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r3, 0(r9)
		addi      r5, r1, 0x150+var_A8
		li        r4, 0x800
		addi      r3, r3, 0x3600
		bl        NWC24FRead
		cmpwi     r3, 0
		bge       loc_8003443C
		mr        r31, r3
loc_8003443C:
		mr        r3, r31
loc_80034440:
		cmpwi     r3, 0
		bge       loc_8003444C
		b         loc_80034548
loc_8003444C:
		addi      r3, r1, 0x150+var_A8
		addi      r4, r1, 0x150+var_148
		bl        NWC24FGetLength
		cmpwi     r3, 0
		mr        r31, r3
		blt       loc_80034534
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r3, 0(r9)
		cmpwi     r3, 0
		beq       loc_80034478
		addi      r31, r3, 0x3600
		b         loc_8003447C
loc_80034478:
		li        r31, 0
loc_8003447C:
		lhz       r0, 0x14(r31)
		cmpwi     r0, 0
		bne       loc_80034508
		lhz       r0, 0x10(r31)
		cmpwi     r0, 0
		beq       loc_80034508
		sth       r0, 0x14(r31)
		lhz       r0, 0x10(r31)
		cmplwi    r0, 0x20
		ble       loc_800344AC
		li        r0, 0x20
		sth       r0, 0x10(r31)
loc_800344AC:
		lis       r9, DLFilePath@h
		ori       r9, r9, DLFilePath@l
		lwz       r4, 0(r9)
		addi      r3, r1, 0x150+var_144
		li        r5, 4
		bl        NWC24FOpen
		cmpwi     r3, 0
		blt       loc_80034508
		addi      r3, r1, 0x150+var_144
		li        r4, 0
		li        r5, 0
		bl        NWC24FSeek
		cmpwi     r3, 0
		blt       loc_80034500
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r3, 0(r9)
		cmpwi     r3, 0
		beq       loc_800344F0
		addi      r3, r3, 0x3600
		b         loc_800344F4
loc_800344F0:
		li        r3, 0
loc_800344F4:
		addi      r5, r1, 0x150+var_144
		li        r4, 0x800
		bl        NWC24FWrite
loc_80034500:
		addi      r3, r1, 0x150+var_144
		bl        NWC24FClose
loc_80034508:
		lhz       r3, 0x14(r31)
		cmplwi    r3, 1
		blt       loc_80034528
		lhz       r0, 0x12(r31)
		cmplwi    r0, 1
		blt       loc_80034528
		cmplw     r3, r0
		bge       loc_80034530
loc_80034528:
		li        r31, -0xE
		b         loc_80034534
loc_80034530:
		li        r31, 0
loc_80034534:
		addi      r3, r1, 0x150+var_A8
		bl        NWC24FClose
		cmpwi     r31, 0
		beq       loc_80034548
		mr        r3, r31
loc_80034548:
		lwz       r0, 0x150+sender_lr(r1)
		lwz       r31, 0x150+var_4(r1)
		mtlr      r0
		addi      r1, r1, 0x150
		blr


DeleteDlTask:
.set back_chain, -0xC0
.set var_B8, -0xB8
.set var_C, -0xC
.set var_8, -8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		li        r5, 4
		stw       r0, 0xC0+sender_lr(r1)
		stw       r31, 0xC0+var_4(r1)
		stw       r30, 0xC0+var_8(r1)
		stw       r29, 0xC0+var_C(r1)
		mr        r29, r3
		addi      r3, r1, 0xC0+var_B8
		lis       r9, DLFilePath@h
		ori       r9, r9, DLFilePath@l
		lwz       r4, 0(r9)
		bl        NWC24FOpen
		cmpwi     r3, 0
		bge       loc_80034594
		b         loc_80034704
loc_80034594:
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r3, 0(r9)
		li        r4, 0
		lhz       r31, 0(r29)
		li        r5, 0x200
		addi      r30, r3, 0x3E00
		mr        r3, r30
		bl        memset
		li        r3, 0xFF
		clrlslwi  r0, r31, 16,4
		stb       r3, 2(r30)
		li        r4, 0
		li        r5, 0x10
		sth       r31, 0(r30)
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r3, 0(r9)
		add       r3, r3, r0
		addi      r3, r3, 0x3680
		bl        memset
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r3, 0(r9)
		lhz       r0, 0(r30)
		cmpwi     r3, 0
		beq       loc_800345F0
		addi      r3, r3, 0x3600
		b         loc_800345F4
loc_800345F0:
		li        r3, 0
loc_800345F4:
		lhz       r3, 0x14(r3)
		cmplwi    r3, 0x78
		bgt       loc_80034608
		cmplw     r0, r3
		blt       loc_80034610
loc_80034608:
		li        r3, -3
		b         loc_80034624
loc_80034610:
		clrlslwi  r4, r0, 16,9
		addi      r3, r1, 0xC0+var_B8
		addi      r4, r4, 0x800
		li        r5, 0
		bl        NWC24FSeek
loc_80034624:
		cmpwi     r3, 0
		bge       loc_80034630
		b         loc_8003466C
loc_80034630:
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r3, 0(r9)
		mr        r4, r30
		li        r5, 0x200
		addi      r3, r3, 0x3E00
		bl        memcpy
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r3, 0(r9)
		addi      r5, r1, 0xC0+var_B8
		li        r4, 0x200
		addi      r3, r3, 0x3E00
		bl        NWC24FWrite
		cmpwi     r3, 0
		li        r0, 0
		bge       loc_80034668
		mr        r0, r3
loc_80034668:
		mr        r3, r0
loc_8003466C:
		cmpwi     r3, 0
		mr        r30, r3
		blt       loc_800346F0
		lhz       r0, 0(r29)
		li        r4, 0
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r3, 0(r9)
		li        r5, 0x10
		slwi      r0, r0, 4
		add       r3, r3, r0
		addi      r3, r3, 0x3680
		bl        memset
		addi      r3, r1, 0xC0+var_B8
		li        r4, 0
		li        r5, 0
		bl        NWC24FSeek
		cmpwi     r3, 0
		bge       loc_800346B4
		b         loc_800346EC
loc_800346B4:
		lis       r9, NWC24WorkP@h
		ori       r9, r9, NWC24WorkP@l
		lwz       r3, 0(r9)
		cmpwi     r3, 0
		beq       loc_800346C8
		addi      r3, r3, 0x3600
		b         loc_800346CC
loc_800346C8:
		li        r3, 0
loc_800346CC:
		addi      r5, r1, 0xC0+var_B8
		li        r4, 0x800
		bl        NWC24FWrite
		cmpwi     r3, 0
		li        r0, 0
		bge       loc_800346E8
		mr        r0, r3
loc_800346E8:
		mr        r3, r0
loc_800346EC:
		mr        r30, r3
loc_800346F0:
		addi      r3, r1, 0xC0+var_B8
		bl        NWC24FClose
		cmpwi     r30, 0
		beq       loc_80034704
		mr        r3, r30
loc_80034704:
		lwz       r0, 0xC0+sender_lr(r1)
		lwz       r31, 0xC0+var_4(r1)
		lwz       r30, 0xC0+var_8(r1)
		lwz       r29, 0xC0+var_C(r1)
		mtlr      r0
		addi      r1, r1, 0xC0
		blr


.global NWC24iPrepareShutdown
NWC24iPrepareShutdown:
.set back_chain, -0x20
.set var_18, -0x18
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x20+sender_lr(r1)
		stw       r31, 0x20+var_4(r1)
		li        r31, 0
		bl        NWC24iRegister
		lis       r5, NWC24Shutdown@ha
		lis       r4, ShutdownFuncInfo@ha
		addi      r5, r5, NWC24Shutdown@l
		li        r0, 0x6E
		addi      r3, r4, ShutdownFuncInfo@l
		stw       r5, ShutdownFuncInfo@l(r4)
		lis       r9, dword_80092AC4@h
		ori       r9, r9, dword_80092AC4@l
		stw       r0, 0(r9)
		bl        OSRegisterShutdownFunction
		lis       r9, nwc24ShtFd@h
		ori       r9, r9, nwc24ShtFd@l
		lwz       r0, 0(r9)
		cmpwi     r0, 0
		bge       loc_80034784
		lis       r3, __FUNCTION___2027@ha
		lis       r4, _2205@ha
		addi      r3, r3, __FUNCTION___2027@l 
		lis       r5, nwc24ShtFd@h
		ori       r5, r5, nwc24ShtFd@l

		addi      r4, r4, _2205@l 
		li        r6, 1
		bl        NWC24iOpenResourceManager
		mr        r31, r3
loc_80034784:
		li        r0, 5
		lis       r9, nwc24ShtRetryRest@h
		ori       r9, r9, nwc24ShtRetryRest@l
		stw       r0, 0(r9)
loc_8003478C:
		bl        SCCheckStatus
		cmplwi    r3, 2
		beq       loc_800347B0
		cmplwi    r3, 1
		beq       loc_8003478C
		addi      r3, r1, 0x20+var_18
		bl        SCGetIdleMode
		lbz       r3, 0x20+var_18+1(r1)
		bl        __OSSetIdleLEDMode
loc_800347B0:
		bl        OSGetAppType
		clrlwi    r0, r3, 24
		cmplwi    r0, 0x40
		bne       loc_800347C8
		li        r3, 1
		bl        NWC24iSetScriptMode
loc_800347C8:
		mr        r3, r31
		lwz       r31, 0x20+var_4(r1)
		lwz       r0, 0x20+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x20
		blr


.global NWC24Shutdown
NWC24Shutdown:
.set back_chain, -0x10
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		cmpwi     r3, 0
		stw       r0, 0x10+sender_lr(r1)
		beq       loc_800347FC
		li        r3, 1
		b         loc_800348A0
loc_800347FC:
		lis       r9, shuttingdown_2068@h
		ori       r9, r9, shuttingdown_2068@l
		lwz       r0, 0(r9)
		cmpwi     r0, 0
		beq       loc_80034858
		bl        NWC24iIsAsyncRequestPending
		cmpwi     r3, 0
		beq       loc_8003481C
		li        r3, 0
		b         loc_800348A0
loc_8003481C:
		lis       r9, result_2069@h
		ori       r9, r9, result_2069@l
		lwz       r0, 0(r9)
		cmpwi     r0, 0
		blt       loc_80034830
		li        r3, 1
		b         loc_800348A0
loc_80034830:
		lis       r9, nwc24ShtRetryRest@h
		ori       r9, r9, nwc24ShtRetryRest@l
		lwz       r3, 0(r9)
		cmpwi     r3, 0
		ble       loc_80034850
		addi      r0, r3, -1
		li        r3, 0
		lis       r9, shuttingdown_2068@h
		ori       r9, r9, shuttingdown_2068@l
		stw       r3, 0(r9)
		lis       r9, nwc24ShtRetryRest@h
		ori       r9, r9, nwc24ShtRetryRest@l
		stw       r0, 0(r9)
		b         loc_8003489C
loc_80034850:
		li        r3, 1
		b         loc_800348A0
loc_80034858:
		lis       r5, shtBuffer_2041@ha
		lis       r3, __FUNCTION___2037@ha
		stw       r4, shtBuffer_2041@l(r5)
		lis       r8, shtResult_2042@ha
		addi      r6, r5, shtBuffer_2041@l
		lis       r9, nwc24ShtFd@h
		ori       r9, r9, nwc24ShtFd@l
		lwz       r4, 0(r9)
		addi      r3, r3, __FUNCTION___2037@l 
		addi      r8, r8, shtResult_2042@l
		li        r5, 0x28
		li        r7, 0x20
		li        r9, 0x20
		lis       r10, result_2069@h
		ori       r10, r10, result_2069@l

		bl        NWC24iIoctlResourceManagerAsync
		cmpwi     r3, 0
		blt       loc_8003489C
		li        r0, 1
		lis       r9, shuttingdown_2068@h
		ori       r9, r9, shuttingdown_2068@l
		stw       r0, 0(r9)
loc_8003489C:
		li        r3, 0
loc_800348A0:
		lwz       r0, 0x10+sender_lr(r1)
		mtlr      r0
		addi      r1, r1, 0x10
		blr


.global NETGetUniversalCalendar
NETGetUniversalCalendar:
.set back_chain, -0x20
.set var_18, -0x18
.set var_14, -0x14
.set var_10, -0x10
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x20+sender_lr(r1)
		lis       r9, whenCached_736@h
		ori       r9, r9, whenCached_736@l
		lwz       r0, 0(r9)
		stw       r31, 0x20+var_4(r1)
		mr        r31, r3
		lis       r9, dword_80083764@h
		ori       r9, r9, dword_80083764@l
		lwz       r3, 0(r9)
		or.       r0, r3, r0
		beq       loc_80034918
		bl        __OSGetSystemTime
		lis       r5, -0x8000
		lis       r9, dword_80083764@h
		ori       r9, r9, dword_80083764@l
		lwz       r8, 0(r9)
		lwz       r6, 0xF8(r5)
		xoris     r5, r3, 0x8000
		lis       r9, whenCached_736@h
		ori       r9, r9, whenCached_736@l
		lwz       r7, 0(r9)
		li        r0, 0
		srwi      r3, r6, 2
		mulli     r3, r3, 0x3C
		addc      r3, r8, r3
		adde      r0, r7, r0
		xoris     r0, r0, 0x8000
		subfc     r3, r4, r3
		subfe     r5, r5, r0
		subfe     r5, r0, r0
		neg.      r5, r5
		beq       loc_8003492C
loc_80034918:
		li        r3, 0
		bl        NWC24iSynchronizeRtcCounter
		bl        __OSGetSystemTime
		lis       r9, dword_80083764@h
		ori       r9, r9, dword_80083764@l
		stw       r4, 0(r9)
		lis       r9, whenCached_736@h
		ori       r9, r9, whenCached_736@l
		stw       r3, 0(r9)
loc_8003492C:
		addi      r3, r1, 0x20+var_18
		bl        NWC24iGetUniversalTime
		cmpwi     r3, 0
		blt       loc_80034970
		lwz       r5, 0x20+var_18(r1)
		addi      r3, r1, 0x20+var_10
		lwz       r6, 0x20+var_14(r1)
		bl        NWC24iEpochSecondsToDate
		cmpwi     r3, 0
		blt       loc_80034970
		mr        r3, r31
		addi      r4, r1, 0x20+var_10
		bl        NWC24iDateToOSCalendarTime
		cmpwi     r3, 0
		blt       loc_80034970
		li        r3, 1
		b         loc_80034980
loc_80034970:
		bl        OSGetTime
		mr        r5, r31
		bl        OSTicksToCalendarTime
		li        r3, 0
loc_80034980:
		lwz       r0, 0x20+sender_lr(r1)
		lwz       r31, 0x20+var_4(r1)
		mtlr      r0
		addi      r1, r1, 0x20
		blr


.global NETGetRexPPCVersionPrintable
NETGetRexPPCVersionPrintable:
		lis       r9, NETRexPPCVersionPrintableString@h
		ori       r9, r9, NETRexPPCVersionPrintableString@l
		lwz       r3, 0(r9)
		blr


.global NETMemCpy
NETMemCpy:
.set back_chain, -0x10
.set var_4, -4
		stwu      r1, back_chain(r1)
		cmplw     r3, r4
		mr        r0, r3
		stw       r31, 0x10+var_4(r1)
		bne       loc_800349B4
		b         loc_80034D50
loc_800349B4:
		ble       loc_80034A00
		add       r6, r4, r5
		cmplw     r3, r6
		bge       loc_80034A00
		clrlwi.   r4, r5, 30
		add       r7, r3, r5
		srwi      r5, r5, 2
		beq       loc_800349E4
		mtctr     r4
loc_800349D8:
		lbzu      r3, -1(r6)
		stbu      r3, -1(r7)
		bdnz      loc_800349D8
loc_800349E4:
		cmpwi     r5, 0
		beq       loc_80034D4C
		mtctr     r5
loc_800349F0:
		lwzu      r3, -4(r6)
		stwu      r3, -4(r7)
		bdnz      loc_800349F0
		b         loc_80034D4C
loc_80034A00:
		addi      r6, r4, -0x20
		cmplw     r3, r6
		ble       loc_80034A14
		cmplw     r3, r4
		blt       loc_80034D08
loc_80034A14:
		cmplwi    r5, 0x40
		blt       loc_80034D08
		clrlwi.   r10, r3, 27
		beq       loc_80034A80
		subfic    r10, r10, 0x20
		mr        r8, r4
		srwi.     r6, r10, 2
		mr        r9, r3
		clrlwi    r7, r10, 30
		beq       loc_80034A54
		mtctr     r6
loc_80034A40:
		lwz       r6, 0(r8)
		addi      r8, r8, 4
		stw       r6, 0(r9)
		addi      r9, r9, 4
		bdnz      loc_80034A40
loc_80034A54:
		cmpwi     r7, 0
		beq       loc_80034A74
		mtctr     r7
loc_80034A60:
		lbz       r6, 0(r8)
		addi      r8, r8, 1
		stb       r6, 0(r9)
		addi      r9, r9, 1
		bdnz      loc_80034A60
loc_80034A74:
		add       r3, r3, r10
		add       r4, r4, r10
		subf      r5, r10, r5
loc_80034A80:
		clrlwi    r8, r4, 30
		mr        r7, r4
		cmpwi     r8, 2
		mr        r6, r3
		clrrwi    r31, r5, 5
		srwi      r9, r5, 5
		beq       loc_80034BB8
		bge       loc_80034AB0
		cmpwi     r8, 0
		beq       loc_80034ABC
		bge       loc_80034B14
		b         loc_80034CFC
loc_80034AB0:
		cmpwi     r8, 4
		bge       loc_80034CFC
		b         loc_80034C5C
loc_80034ABC:
		mtctr     r9
loc_80034AC0:
		dcbz      0, r6
		lwz       r12, 0(r7)
		lwz       r11, 4(r7)
		stw       r12, 0(r6)
		stw       r11, 4(r6)
		lwz       r12, 8(r7)
		lwz       r11, 0xC(r7)
		stw       r12, 8(r6)
		stw       r11, 0xC(r6)
		lwz       r12, 0x10(r7)
		lwz       r11, 0x14(r7)
		stw       r12, 0x10(r6)
		stw       r11, 0x14(r6)
		lwz       r12, 0x18(r7)
		lwz       r11, 0x1C(r7)
		addi      r7, r7, 0x20
		stw       r12, 0x18(r6)
		stw       r11, 0x1C(r6)
		addi      r6, r6, 0x20
		bdnz      loc_80034AC0
		b         loc_80034CFC
loc_80034B14:
		lwz       r10, -1(r4)
		mtctr     r9
		addi      r7, r4, 3
		slwi      r10, r10, 8
loc_80034B24:
		dcbz      0, r6
		lwz       r12, 0(r7)
		lwz       r11, 4(r7)
		inslwi    r10, r12, 8,24
		slwi      r8, r12, 8
		stw       r10, 0(r6)
		inslwi    r8, r11, 8,24
		slwi      r9, r11, 8
		lwz       r12, 8(r7)
		stw       r8, 4(r6)
		inslwi    r9, r12, 8,24
		slwi      r8, r12, 8
		lwz       r11, 0xC(r7)
		stw       r9, 8(r6)
		inslwi    r8, r11, 8,24
		slwi      r10, r11, 8
		lwz       r12, 0x10(r7)
		stw       r8, 0xC(r6)
		inslwi    r10, r12, 8,24
		slwi      r8, r12, 8
		lwz       r11, 0x14(r7)
		stw       r10, 0x10(r6)
		inslwi    r8, r11, 8,24
		slwi      r9, r11, 8
		lwz       r12, 0x18(r7)
		stw       r8, 0x14(r6)
		inslwi    r9, r12, 8,24
		slwi      r8, r12, 8
		lwz       r11, 0x1C(r7)
		addi      r7, r7, 0x20
		stw       r9, 0x18(r6)
		inslwi    r8, r11, 8,24
		slwi      r10, r11, 8
		stw       r8, 0x1C(r6)
		addi      r6, r6, 0x20
		bdnz      loc_80034B24
		b         loc_80034CFC
loc_80034BB8:
		lwz       r10, -2(r4)
		mtctr     r9
		addi      r7, r4, 2
		slwi      r10, r10, 16
loc_80034BC8:
		dcbz      0, r6
		lwz       r12, 0(r7)
		lwz       r11, 4(r7)
		inslwi    r10, r12, 16,16
		slwi      r8, r12, 16
		stw       r10, 0(r6)
		inslwi    r8, r11, 16,16
		slwi      r9, r11, 16
		lwz       r12, 8(r7)
		stw       r8, 4(r6)
		inslwi    r9, r12, 16,16
		slwi      r8, r12, 16
		lwz       r11, 0xC(r7)
		stw       r9, 8(r6)
		inslwi    r8, r11, 16,16
		slwi      r10, r11, 16
		lwz       r12, 0x10(r7)
		stw       r8, 0xC(r6)
		inslwi    r10, r12, 16,16
		slwi      r8, r12, 16
		lwz       r11, 0x14(r7)
		stw       r10, 0x10(r6)
		inslwi    r8, r11, 16,16
		slwi      r9, r11, 16
		lwz       r12, 0x18(r7)
		stw       r8, 0x14(r6)
		inslwi    r9, r12, 16,16
		slwi      r8, r12, 16
		lwz       r11, 0x1C(r7)
		addi      r7, r7, 0x20
		stw       r9, 0x18(r6)
		inslwi    r8, r11, 16,16
		slwi      r10, r11, 16
		stw       r8, 0x1C(r6)
		addi      r6, r6, 0x20
		bdnz      loc_80034BC8
		b         loc_80034CFC
loc_80034C5C:
		lwz       r10, -3(r4)
		mtctr     r9
		addi      r7, r4, 1
		slwi      r10, r10, 24
loc_80034C6C:
		dcbz      0, r6
		lwz       r12, 0(r7)
		lwz       r11, 4(r7)
		inslwi    r10, r12, 24,8
		slwi      r8, r12, 24
		stw       r10, 0(r6)
		inslwi    r8, r11, 24,8
		slwi      r9, r11, 24
		lwz       r12, 8(r7)
		stw       r8, 4(r6)
		inslwi    r9, r12, 24,8
		slwi      r8, r12, 24
		lwz       r11, 0xC(r7)
		stw       r9, 8(r6)
		inslwi    r8, r11, 24,8
		slwi      r10, r11, 24
		lwz       r12, 0x10(r7)
		stw       r8, 0xC(r6)
		inslwi    r10, r12, 24,8
		slwi      r8, r12, 24
		lwz       r11, 0x14(r7)
		stw       r10, 0x10(r6)
		inslwi    r8, r11, 24,8
		slwi      r9, r11, 24
		lwz       r12, 0x18(r7)
		stw       r8, 0x14(r6)
		inslwi    r9, r12, 24,8
		slwi      r8, r12, 24
		lwz       r11, 0x1C(r7)
		addi      r7, r7, 0x20
		stw       r9, 0x18(r6)
		inslwi    r8, r11, 24,8
		slwi      r10, r11, 24
		stw       r8, 0x1C(r6)
		addi      r6, r6, 0x20
		bdnz      loc_80034C6C
loc_80034CFC:
		add       r3, r3, r31
		add       r4, r4, r31
		subf      r5, r31, r5
loc_80034D08:
		srwi.     r7, r5, 2
		clrlwi    r6, r5, 30
		beq       loc_80034D2C
		mtctr     r7
loc_80034D18:
		lwz       r5, 0(r4)
		addi      r4, r4, 4
		stw       r5, 0(r3)
		addi      r3, r3, 4
		bdnz      loc_80034D18
loc_80034D2C:
		cmpwi     r6, 0
		beq       loc_80034D4C
		mtctr     r6
loc_80034D38:
		lbz       r5, 0(r4)
		addi      r4, r4, 1
		stb       r5, 0(r3)
		addi      r3, r3, 1
		bdnz      loc_80034D38
loc_80034D4C:
		mr        r3, r0
loc_80034D50:
		lwz       r31, 0x10+var_4(r1)
		addi      r1, r1, 0x10
		blr


.global NETMemSet
NETMemSet:
		cmpwi     r5, 0
		mr        r9, r3
		beqlr
		cmplwi    r5, 0x40
		insrwi    r4, r4, 8,16
		insrwi    r4, r4, 16,0
		blt       loc_80034E24
		clrlwi.   r8, r3, 27
		beq       loc_80034DC4
		subfic    r8, r8, 0x20
		mr        r7, r3
		srwi.     r6, r8, 2
		clrlwi    r0, r8, 30
		beq       loc_80034DA4
		mtctr     r6
loc_80034D98:
		stw       r4, 0(r7)
		addi      r7, r7, 4
		bdnz      loc_80034D98
loc_80034DA4:
		cmpwi     r0, 0
		beq       loc_80034DBC
		mtctr     r0
loc_80034DB0:
		stb       r4, 0(r7)
		addi      r7, r7, 1
		bdnz      loc_80034DB0
loc_80034DBC:
		add       r3, r3, r8
		subf      r5, r8, r5
loc_80034DC4:
		cmpwi     r4, 0
		mr        r6, r3
		clrrwi    r7, r5, 5
		srwi      r0, r5, 5
		bne       loc_80034DEC
		mtctr     r0
loc_80034DDC:
		dcbz      0, r6
		addi      r6, r6, 0x20
		bdnz      loc_80034DDC
		b         loc_80034E1C
loc_80034DEC:
		mtctr     r0
loc_80034DF0:
		dcbz      0, r6
		stw       r4, 0(r6)
		stw       r4, 4(r6)
		stw       r4, 8(r6)
		stw       r4, 0xC(r6)
		stw       r4, 0x10(r6)
		stw       r4, 0x14(r6)
		stw       r4, 0x18(r6)
		stw       r4, 0x1C(r6)
		addi      r6, r6, 0x20
		bdnz      loc_80034DF0
loc_80034E1C:
		add       r3, r3, r7
		subf      r5, r7, r5
loc_80034E24:
		srwi.     r6, r5, 2
		clrlwi    r0, r5, 30
		beq       loc_80034E40
		mtctr     r6
loc_80034E34:
		stw       r4, 0(r3)
		addi      r3, r3, 4
		bdnz      loc_80034E34
loc_80034E40:
		cmpwi     r0, 0
		beq       loc_80034E58
		mtctr     r0
loc_80034E4C:
		stb       r4, 0(r3)
		addi      r3, r3, 1
		bdnz      loc_80034E4C
loc_80034E58:
		mr        r3, r9
		blr


.global OSSleepTicks
OSSleepTicks:		           
.set back_chain, -0x50
.set var_48, -0x48
.set var_10, -0x10
.set var_C, -0xC
.set var_8, -8
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x50+sender_lr(r1)
		stw       r31, 0x50+var_4(r1)
		stw       r30, 0x50+var_8(r1)
		stw       r29, 0x50+var_C(r1)
		mr        r29, r3
		stw       r28, 0x50+var_10(r1)
		mr        r28, r4
		bl        OSDisableInterrupts
		lis       r4, -0x8000
		mr        r30, r3
		lwz       r31, 0xE4(r4)
		cmpwi     r31, 0
		bne       loc_8000F7D4
		bl        OSRestoreInterrupts
		b         loc_8000F818
loc_8000F7D4:		           
		addi      r3, r1, 0x50+var_48
		bl        OSCreateAlarm
		mr        r4, r31
		addi      r3, r1, 0x50+var_48
		bl        __OSSetInternalAlarmUserData
		lis       r7, SleepAlarmHandler@ha
		mr        r6, r28
		mr        r5, r29
		addi      r3, r1, 0x50+var_48
		addi      r7, r7, SleepAlarmHandler@l
		bl        OSSetAlarm
		mr        r3, r31
		bl        OSSuspendThread
		addi      r3, r1, 0x50+var_48
		bl        OSCancelAlarm
		mr        r3, r30
		bl        OSRestoreInterrupts
loc_8000F818:		           
		lwz       r0, 0x50+sender_lr(r1)
		lwz       r31, 0x50+var_4(r1)
		lwz       r30, 0x50+var_8(r1)
		lwz       r29, 0x50+var_C(r1)
		lwz       r28, 0x50+var_10(r1)
		mtlr      r0
		addi      r1, r1, 0x50
		blr


.global __OSSetInternalAlarmUserData
__OSSetInternalAlarmUserData:
	li        r0, -1
	stw       r4, 0x28(r3)
	stw       r0, 4(r3)
	blr


SleepAlarmHandler:		      
.set back_chain, -0x10
.set var_4, -4
.set sender_lr,  4
		stwu      r1, back_chain(r1)
		mflr      r0
		stw       r0, 0x10+sender_lr(r1)
		stw       r31, 0x10+var_4(r1)
		mr        r31, r3
		bl        OSGetAlarmUserData
		lhz       r0, 0x2C8(r3)
		cmpwi     r0, 0
		bne       loc_8000F73C
		li        r0, 0
		b         loc_8000F768
loc_8000F73C:		           
		lis       r4, -0x8000
		lwz       r4, 0xDC(r4)
		b         loc_8000F75C
loc_8000F748:		           
		cmplw     r3, r4
		bne       loc_8000F758
		li        r0, 1
		b         loc_8000F768
loc_8000F758:		           
		lwz       r4, 0x2FC(r4)
loc_8000F75C:		           
		cmpwi     r4, 0
		bne       loc_8000F748
		li        r0, 0
loc_8000F768:		           
		cmpwi     r0, 0
		beq       loc_8000F77C
		mr        r3, r31
		bl        OSGetAlarmUserData
		bl        OSResumeThread
loc_8000F77C:		           
		lwz       r0, 0x10+sender_lr(r1)
		lwz       r31, 0x10+var_4(r1)
		mtlr      r0
		addi      r1, r1, 0x10
		blr


.global __OSSetIdleLEDMode
__OSSetIdleLEDMode:		     
		lis       r9, StmReady@h
		ori       r9, r9, StmReady@l
		lwz       r0, 0(r9)
		cmpwi     r0, 0
		bne       loc_800101B4
		li        r3, -6
		blr
loc_800101B4:		           
		lis       r4, StmImInBuf@ha
		lis       r7, StmImOutBuf@ha
		stw       r3, StmImInBuf@l(r4)
		addi      r5, r4, StmImInBuf@l
		lis       r9, StmImDesc@h
		ori       r9, r9, StmImDesc@l
		lwz       r3, 0(r9)
		addi      r7, r7, StmImOutBuf@l
		li        r4, 0x6002
		li        r6, 0x20
		li        r8, 0x20
		b         IOS_Ioctl


.global DVDGetCurrentDiskID
DVDGetCurrentDiskID:
		lis       r3, -0x8000
		blr



.data
.align 4
RdBufferMutex:				.space 4		
WrBufferMutex:				.space 4		
InstanceIdGen:				.space 4		
							.align 4
config:						.space 4		
ConfigModified:				.space 4		

.global NWC24WorkP
NWC24WorkP:					.space 4	

Opened:						.space 4		
YouGotMail:					.space 4		
GlobalErrorCode:			.space 4		
Registered:					.space 4		
							.align 4
MountInfo:					.space 4		
dword_80083714:				.space 4		
m_pFile:					.space 4		
							.align 4
nwc24ScdInitialized:		.space 4            
nwc24ScdSuspendCnt:			.space 4             
nwc24ScdOpenCnt:			.space 4		
							.align 4
nwc24TimeInitialized:		.space 4           
nwc24TimeRtc:				.space 4		
nwc24TimeDifference:		.space 4            
dword_8008373C:				.space 4		

whenCached_716:				.space 4		
dword_80083744:				.space 4		
NWC24iIsRequestPending:		.space 4         
							.align 4
nwc24ShtRetryRest:			.space 4              

shuttingdown_2068:			.space 4              

result_2069:				.space 4		
							.align 4

whenCached_736:				.space 4		
dword_80083764:				.space 4	        



_3073_0:        .long def_8002B750      
		.long loc_8002B754      
		.long loc_8002B784
		.long def_8002B750
		.long loc_8002B78C
		.long def_8002B750
		.long def_8002B750
		.long def_8002B750
		.long def_8002B750
		.long loc_8002B754
		.long loc_8002B784
		.align 3

_1695:          .string "/shared2/wc24/mbox"
		.byte 0
		.align 2

_1696:          .string "/shared2/wc24/nwc24msg.cfg"
		.byte 0
		.align 2

_1697:          .string "/shared2/wc24/nwc24msg.cbk"
		.byte 0
		.align 2

_2383:          .string "NWC24Config.c" 
		.byte 0
		.align 2

_2384:          .string "stopped."      
		.byte 0
		.align 4

_2088:          .string "<< RVL_SDK - NWC24 \trelease build: Jun  9 2009 18:16:11 (0x4199_60831) >>"
		.byte 0
		.align 2

_2977:          .long loc_8002D3CC      
		.long def_8002D3C8      
		.long def_8002D3C8
		.long loc_8002D3CC
		.long def_8002D3C8
		.long def_8002D3C8
		.long loc_8002D3CC
		.long loc_8002D3CC
		.long def_8002D3C8
		.long def_8002D3C8
		.long def_8002D3C8
		.long loc_8002D3CC
		.long def_8002D3C8
		.long def_8002D3C8
		.long def_8002D3C8
		.long def_8002D3C8
		.long def_8002D3C8
		.long def_8002D3C8
		.long def_8002D3C8
		.long def_8002D3C8
		.long loc_8002D3CC
		.long def_8002D3C8
		.long loc_8002D3CC
		.long loc_8002D3CC
		.long def_8002D3C8
		.long def_8002D3C8
		.long def_8002D3C8
		.long loc_8002D3CC
		.long loc_8002D3CC
		.long loc_8002D3CC
		.long loc_8002D3CC
		.long loc_8002D3CC
		.long loc_8002D3CC
		.long loc_8002D3CC
		.long def_8002D3C8
		.long loc_8002D3CC
		.long def_8002D3C8
		.long def_8002D3C8
		.long def_8002D3C8
		.long def_8002D3C8
		.long def_8002D3C8
		.long def_8002D3C8
		.long def_8002D3C8
		.long def_8002D3C8
		.long def_8002D3C8
		.long def_8002D3C8
		.long def_8002D3C8
		.long def_8002D3C8
		.long loc_8002D3CC

_3644:          .string "/wc24send.ctl" 
		.byte 0		 
		.align 4

_3645:          .string "/wc24recv.ctl" 
		.byte 0
		.align 4

_3738:          .string "/wc24recv.mbx" 
		.byte 0
		.align 4

_3739:          .string "/wc24send.mbx" 
		.byte 0
		.align 4

_3773:          .string "/shared2/wc24/mbox/recvtmp.msg"
		.byte 0
		.align 4

_3774:          .string "/shared2/wc24/mbox/dlcnt.bin"
		.byte 0
		.align 4

_3813:          .string "@24:/mb/s%07d.msg"
		.byte 0
		.align 2

_3814_0:        .string "@24:/mb/r%07d.msg"
		.byte 0
		.align 2

_670:           .string "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="
		.byte 0
		.align 4

_1991:          .string "application/octet-stream"
		.byte 0
		.align 2

_1992:          .string "application/x-wii-minidata"
		.byte 0
		.align 2

_1993:          .string "application/x-wii-msgboard"
		.byte 0
		.align 2

_1994:          .string "image/jpeg"    
		.byte 0
		.align 4

_1995:          .string "image/x-wii-picture"
		.byte 0

_1996:          .string "multipart/alternative"
		.byte 0
		.align 4

_1997:          .string "multipart/mixed"
		.byte 0

_1998:          .string "multipart/related"
		.byte 0
		.align 2

_1999:          .string "text/html"     
		.byte 0
		.align 4

_2000:          .string "text/plain"    
		.byte 0
		.align 4
MIMETypeStr:    .long _1991             
		.long _1992             
		.long _1993             
		.long _1994             
		.long _1995             
		.long _1996             
		.long _1997             
		.long _1998             
		.long _1999             
		.long _2000             
MIMETypeConv:   .byte    0              
		.byte    3
		.byte    0
		.byte    0
		.byte    0
		.byte    3
		.byte    0
		.byte    2
		.byte    0
		.byte    3
		.byte    0
		.byte    1
		.byte    0
		.byte    2
		.byte    0
		.byte    0
		.byte    0
		.byte    2
		.byte    0
		.byte    1
		.byte    0
		.byte  0xF
		.byte    0
		.byte    1
		.byte    0
		.byte  0xF
		.byte    0
		.byte    0
		.byte    0
		.byte  0xF
		.byte    0
		.byte    2
		.byte    0
		.byte    1
		.byte    0
		.byte    1
		.byte    0
		.byte    1
		.byte    0
		.byte    0
MIMETypeSuffix: .long _2001             
		.long _2002
		.long _2002
		.long _2003
		.long _2002
		.long _2004
		.long _2004
		.long _2004
		.long _2005
		.long _2006

_2010:          .string "iso-2022-jp"   
		.byte 0

_2011:          .string "iso-8859-1"    
		.byte 0
		.align 4

_2012:          .string "iso-8859-10"   
		.byte 0

_2013:          .string "iso-8859-15"   
		.byte 0

_2014:          .string "iso-8859-2"    
		.byte 0
		.align 2

_2015:          .string "iso-8859-3"    
		.byte 0
		.align 4

_2016:          .string "iso-8859-5"    
		.byte 0
		.align 2

_2017:          .string "iso-8859-7"    
		.byte 0
		.align 2

_2018:          .string "iso-8859-9"    
		.byte 0
		.align 2

_2019:          .string "shift_jis"     
		.byte 0
		.align 4

_2020:          .string "us-ascii"      
		.byte 0
		.align 2

_2021:          .string "utf-16be"      
		.byte 0
		.align 2

_2022:          .string "utf-32be"      
		.byte 0
		.align 2

_2024:          .string "windows-1252"  
		.byte 0
		.align 3
CharsetStr:     .long _2007             
		.long _2008             
		.long _2009             
		.long _2010             
		.long _2011             
		.long _2012             
		.long _2013             
		.long _2014             
		.long _2015             
		.long _2016             
		.long _2017             
		.long _2018             
		.long _2019             
		.long _2020             
		.long _2021             
		.long _2022             
		.long _2023             
		.long _2024             
CharsetConv:    .byte    0              
		.byte    2
		.byte    0
		.byte    2
		.byte    0
		.byte    3
		.byte    0
		.byte    2
		.byte    0
		.byte  0xB
		.byte 0x23 # 
		.byte 0x12
		.byte    0
		.byte    2
		.byte    0
		.byte    0
		.byte    0
		.byte    8
		.byte    0
		.byte    1
		.byte    0
		.byte    8
		.byte    0
		.byte  0xA
		.byte    0
		.byte    8
		.byte    0
		.byte  0xF
		.byte    0
		.byte    8
		.byte    0
		.byte    2
		.byte    0
		.byte    8
		.byte    0
		.byte    3
		.byte    0
		.byte    8
		.byte    0
		.byte    5
		.byte    0
		.byte    8
		.byte    0
		.byte    7
		.byte    0
		.byte    8
		.byte    0
		.byte    9
		.byte    0
		.byte    2
		.byte    0
		.byte    1
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    1
		.byte    0
		.byte 0x10
		.byte    0
		.byte    1
		.byte    0
		.byte 0x20
		.byte    0
		.byte    1
		.byte    0
		.byte    8
		.byte    0
		.byte  0xF
		.byte 0x12
		.byte 0x52 

_2029:          .string "quoted-printable"
		.byte 0
		.align 4
EncodingStr:    .long _2026             
		.long _2027             
		.long _2028             
		.long _2029             
EncodingConv:   .byte    0              
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    1
		.byte    0
		.byte    0
		.byte    0
		.byte    2
		.byte    0
		.byte    0
		.byte    0
		.byte    3

_3490:          .string "Message-Id: <" 
		.byte 0		 
		.align 4

_3491:          .string "%05X%08X%08X%08X"
		.byte 0
		.align 2

_3493:          .string "Subject: "     
		.byte 0
		.align 4

_3495:          .string "X-Wii-Cmd: %08X\r\n"
		.byte 0
		.align 2

_3496:          .string "X-Wii-Tag: %08X\r\n"
		.byte 0
		.align 2

_3497:          .string "X-Wii-DWCId: %08X\r\n"
		.byte 0

_3498:          .string "X-Wii-IconNew: %08X\r\n"
		.byte 0
		.align 2

_3499:          .string "X-Wii-MB-NoReply: -\r\n"
		.byte 0
		.align 2

_3500:          .string "X-Wii-MB-RegDate: %04X\r\n"
		.byte 0
		.align 2

_3501:          .string "X-Wii-MB-Delay: %02X\r\n"
		.byte 0
		.align 4

_3502:          .string "Boundary-NWC24-%08X%05X"
		.byte 0

_3503:          .string "MIME-Version: 1.0\r\n"
		.byte 0

_3504:          .string "Content-Type: multipart/mixed;\r\n"
		.string " boundary=\""
		.byte 0

_3630:          .string "MAIL FROM: "   
		.byte 0

_3649:          .string "RCPT TO: "     
		.byte 0
		.align 4
MonthStr:       .long _2462             
		.long _2463             
		.long _2464             
		.long _2465             
		.long _2466             
		.long _2467             
		.long _2468             
		.long _2469             
		.long _2470             
		.long _2471             
		.long _2472             
		.long _2473             

_3695:          .string "Date: %02d %s %d %02d:%02d:%02d -0000\r\n"
		.byte 0

_3708:          .string "X-Wii-AppId: " 
		.byte 0
		.align 2

_3709:          .string "%d-%08X-%04X\r\n"
		.byte 0
		.align 2

_3721:          .string "X-WiiFace:"    
		.byte 0
		.align 2

_3733:          .string "X-Wii-AltName:"
		.byte 0
		.align 2

_2668:          .string "Content-Type: %s;\r\n"
		.string " name=%c%07d.%s\r\n"
		.byte 0
		.align 2

_2669:          .string "Content-Transfer-Encoding: base64\r\n"
		.byte 0

_2670:          .string "Content-Disposition: attachment;\r\n"
		.string " filename=%c%07d.%s\r\n"
		.string "\r\n"
		.byte 0
		.align 2

_2695:          .string "Content-Type: text/plain; charset=%s\r\n"
		.byte 0
		.align 2

_2696:          .string "Content-Transfer-Encoding: %s\r\n"
		.string "\r\n"
		.byte 0
		.align 2

_2441:          .string "/dev/net/kd/request"
		.byte 0

__FUNCTION___1622:.string "NWC24iSetScriptMode"
		.byte 0

__FUNCTION___1690:.string "NWC24iRequestGenerateUserId"
		.byte 0
		.align 4

__FUNCTION___1850:.string "ExecTrySuspendScheduler"
		.byte 0

_1605:          .string "/shared2/wc24/nwc24fl.bin"
		.byte 0
		.align 3

_1644:          .string "/shared2/wc24/nwc24fls.bin"
		.byte 0
		.align 3

__FUNCTION___733:.string "NWC24iGetTimeDifference"
		.byte 0

_974:           .string "/dev/net/kd/time"
		.byte 0
		.align 2

__FUNCTION___753:.string "NWC24iSetRtcCounter"
		.byte 0

_1685:          .string "/shared2/wc24/nwc24dl.bin"
		.byte 0
		.align 3

__FUNCTION___2027:.string "NWC24iPrepareShutdown"
		.byte 0
		.align 4

_2205:          .string "/dev/net/kd/request"
		.byte 0

__FUNCTION___2037:.string "NWC24iRequestShutdown"
		.byte 0
		.align 4

_561:           .string "<< REX-PPC 2.4.255.0 (RevoEX-2.4) REL 090609173332 >>"
		.byte 0
		.align 2
.global VFipf_error_to_api_error
VFipf_error_to_api_error:.long 0        
		.byte    0
		.byte    0
		.byte    0
		.byte 0x16
		.byte    0
		.byte    0
		.byte    0
		.byte 0x16
		.byte    0
		.byte    0
		.byte    0
		.byte    2
		.byte    0
		.byte    0
		.byte    0
		.byte 0x10
		.byte    0
		.byte    0
		.byte    0
		.byte 0x5A 
		.byte    0
		.byte    0
		.byte    0
		.byte 0x1C
		.byte    0
		.byte    0
		.byte    0
		.byte    8
		.byte    0
		.byte    0
		.byte    0
		.byte 0x11
		.byte    0
		.byte    0
		.byte    0
		.byte    8
		.byte    0
		.byte    0
		.byte    0
		.byte 0x16
		.byte    0
		.byte    0
		.byte    0
		.byte  0xD
		.byte    0
		.byte    0
		.byte    0
		.byte 0x58 
		.byte    0
		.byte    0
		.byte    0
		.byte    8
		.byte    0
		.byte    0
		.byte    0
		.byte    8
		.byte    0
		.byte    0
		.byte    0
		.byte    8
		.byte    0
		.byte    0
		.byte    0
		.byte  0xD
		.byte    0
		.byte    0
		.byte    0
		.byte    5
		.byte    0
		.byte    0
		.byte    0
		.byte    8
		.byte    0
		.byte    0
		.byte    0
		.byte  0xD
		.byte    0
		.byte    0
		.byte    0
		.byte    2
		.byte    0
		.byte    0
		.byte    0
		.byte 0x17
		.byte    0
		.byte    0
		.byte    0
		.byte 0x18
		.byte    0
		.byte    0
		.byte    0
		.byte 0x15
		.byte    0
		.byte    0
		.byte    0
		.byte  0xD
		.byte    0
		.byte    0
		.byte    0
		.byte    1
		.byte    0
		.byte    0
		.byte    0
		.byte    8
		.byte    0
		.byte    0
		.byte    0
		.byte    8
		.byte    0
		.byte    0
		.byte    0
		.byte    8
		.byte    0
		.byte    0
		.byte    0
		.byte    8
		.byte    0
		.byte    0
		.byte    0
		.byte  0xC
		.byte    0
		.byte    0
		.byte    0
		.byte 0x16
		.byte    0
		.byte    0
		.byte    0
		.byte 0x16
		.byte    0
		.byte    0
		.byte    0
		.byte    8
		.byte    0
		.byte    0
		.byte    0
		.byte    2
		.byte    0
		.byte    0
		.byte    0
		.byte    8
		.byte    0
		.byte    0
		.byte    0
		.byte    8
		.byte    0
		.byte    0
		.byte    0
		.byte 0x1B
		.byte    0
		.byte    0
		.byte    0
		.byte    9
		.byte    0
		.byte    0
		.byte    0
		.byte 0x2E 


 MultiPartDivider:.space 1               # DATA XREF: NWC24CommitMsgInternal+83C↑o
				       # NWC24CommitMsgInternal+84C↑o ...
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 nwc24ScdCommandMutex:.space 1           # DATA XREF: NWC24SuspendScheduler+14↑o
				       # NWC24ResumeScheduler+14↑o ...
				       # Alternative name is '...bss.0'
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 nwc24ScdCounterMutex:.space 1           # DATA XREF: NWC24SuspendScheduler+44↑o
				       # NWC24SuspendScheduler:loc_800321D8↑o ...
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 nwc24ScdCommonBuffer:.space 4           # DATA XREF: NWC24SuspendScheduler+4C↑o
				       # NWC24ResumeScheduler+4C↑o ...
		.align 5
 nwc24ScdCommonResult:.space 4           # DATA XREF: NWC24SuspendScheduler+5C↑o
				       # NWC24ResumeScheduler+5C↑o ...
 dword_800928C4: .space 4                # DATA XREF: NWC24iRequestGenerateUserId+154↑r
				       # ExecNoParamCommand+11C↑r
 dword_800928C8: .space 4                # DATA XREF: NWC24iRequestGenerateUserId+158↑r
 dword_800928CC: .space 4                # DATA XREF: NWC24iRequestGenerateUserId+174↑r
		.align 5
 nwc24ScdStatBuf:.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 # .rename buf_691, "buf$691"
 buf_691:        .space 1                # DATA XREF: NWC24iGetTimeDifference+18↑o
				       # NWC24iSetRtcCounter+20↑o
				       # Alternative name is '...bss.0'
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 nwc24TimeCommandMutex:.space 1          # DATA XREF: NWC24iGetTimeDifference+6C↑o
				       # NWC24iGetTimeDifference:loc_80033A8C↑o ...
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 nwc24TimeCommonBuffer:.space 4          # DATA XREF: NWC24iGetTimeDifference+74↑o
				       # NWC24iSetRtcCounter+70↑o ...
 dword_80092A84: .space 4                # DATA XREF: NWC24iSetRtcCounter+E0↑w
		.align 5
 nwc24TimeCommonResult:.space 4          # DATA XREF: NWC24iGetTimeDifference+84↑o
				       # NWC24iGetTimeDifference+DC↑o ...
 dword_80092AA4: .space 4                # DATA XREF: NWC24iGetTimeDifference+11C↑r
 dword_80092AA8: .space 4                # DATA XREF: NWC24iGetTimeDifference+120↑r
		.align 5
 ShutdownFuncInfo:.space 4               # DATA XREF: NWC24iPrepareShutdown+28↑o
				       # NWC24iPrepareShutdown+2C↑w
 dword_80092AC4: .space 4                # DATA XREF: NWC24iPrepareShutdown+30↑w
		.align 5
 # .rename shtBuffer_2041, "shtBuffer$2041"
 shtBuffer_2041: .space 4                # DATA XREF: NWC24Shutdown+80↑w
				       # NWC24Shutdown+88↑o
		.align 5
 # .rename shtResult_2042, "shtResult$2042"
 shtResult_2042: .space 1                # DATA XREF: NWC24Shutdown+94↑o
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
				       # VFipdm_disk_get_handle+98↑o ...
 word_80092B22:  .space 2                # DATA XREF: VFipdm_disk_get_handle+1B8↑r
				       # VFipdm_disk_get_handle+1C0↑w ...
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_80092CD8: .space 4                # DATA XREF: VFipdm_init_diskmanager+2C↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_80092D10: .space 4                # DATA XREF: VFipdm_init_diskmanager+38↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_80092D48: .space 4                # DATA XREF: VFipdm_init_diskmanager+3C↑w
		.align 6
 dword_80092D80: .space 4                # DATA XREF: VFipdm_init_diskmanager+4C↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_80092DB8: .space 4                # DATA XREF: VFipdm_init_diskmanager+50↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_80092DF0: .space 4                # DATA XREF: VFipdm_init_diskmanager+58↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_80092E28: .space 4                # DATA XREF: VFipdm_init_diskmanager+5C↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_80092E60: .space 4                # DATA XREF: VFipdm_init_diskmanager+60↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_80092E98: .space 4                # DATA XREF: VFipdm_init_diskmanager+64↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_80092ED0: .space 4                # DATA XREF: VFipdm_init_diskmanager+68↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_80092F08: .space 4                # DATA XREF: VFipdm_init_diskmanager+6C↑w
		.align 6
 dword_80092F40: .space 4                # DATA XREF: VFipdm_init_diskmanager+70↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_80092F78: .space 4                # DATA XREF: VFipdm_init_diskmanager+74↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_80092FB0: .space 4                # DATA XREF: VFipdm_init_diskmanager+78↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_80092FE8: .space 4                # DATA XREF: VFipdm_init_diskmanager+7C↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_80093020: .space 4                # DATA XREF: VFipdm_init_diskmanager+80↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_80093058: .space 4                # DATA XREF: VFipdm_init_diskmanager+84↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_80093090: .space 4                # DATA XREF: VFipdm_init_diskmanager+88↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_800930C8: .space 4                # DATA XREF: VFipdm_init_diskmanager+8C↑w
		.align 6
 dword_80093100: .space 4                # DATA XREF: VFipdm_init_diskmanager+90↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_80093138: .space 4                # DATA XREF: VFipdm_init_diskmanager+94↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_80093170: .space 4                # DATA XREF: VFipdm_init_diskmanager+98↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_800931A8: .space 4                # DATA XREF: VFipdm_init_diskmanager+9C↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_800931E0: .space 4                # DATA XREF: VFipdm_init_diskmanager+A0↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_80093284: .space 4                # DATA XREF: VFipdm_init_diskmanager+AC↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_800932B0: .space 4                # DATA XREF: VFipdm_init_diskmanager+B0↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_800932DC: .space 4                # DATA XREF: VFipdm_init_diskmanager+B4↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_80093308: .space 4                # DATA XREF: VFipdm_init_diskmanager+B8↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_80093334: .space 4                # DATA XREF: VFipdm_init_diskmanager+BC↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_80093360: .space 4                # DATA XREF: VFipdm_init_diskmanager+C0↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_8009338C: .space 4                # DATA XREF: VFipdm_init_diskmanager+C4↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_800933B8: .space 4                # DATA XREF: VFipdm_init_diskmanager+C8↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_800933E4: .space 4                # DATA XREF: VFipdm_init_diskmanager+CC↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_80093410: .space 4                # DATA XREF: VFipdm_init_diskmanager+D0↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_8009343C: .space 4                # DATA XREF: VFipdm_init_diskmanager+D4↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_80093468: .space 4                # DATA XREF: VFipdm_init_diskmanager+D8↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_80093494: .space 4                # DATA XREF: VFipdm_init_diskmanager+DC↑w
		.align 6
 dword_800934C0: .space 4                # DATA XREF: VFipdm_init_diskmanager+E0↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_800934EC: .space 4                # DATA XREF: VFipdm_init_diskmanager+E4↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_80093518: .space 4                # DATA XREF: VFipdm_init_diskmanager+E8↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_80093544: .space 4                # DATA XREF: VFipdm_init_diskmanager+EC↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_80093570: .space 4                # DATA XREF: VFipdm_init_diskmanager+F0↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_8009359C: .space 4                # DATA XREF: VFipdm_init_diskmanager+F4↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_800935C8: .space 4                # DATA XREF: VFipdm_init_diskmanager+F8↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_800935F4: .space 4                # DATA XREF: VFipdm_init_diskmanager+FC↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_80093620: .space 4                # DATA XREF: VFipdm_init_diskmanager+100↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_8009364C: .space 4                # DATA XREF: VFipdm_init_diskmanager+104↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 dword_80093678: .space 4                # DATA XREF: VFipdm_init_diskmanager+108↑w
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 l_Mutex:        .space 1                # DATA XREF: VFInit+1C↑o
				       # VFInit+3C↑o ...
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 l_vf_drive_work:.space 1                # DATA XREF: VFInit+58↑o
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 l_vfsys_dev_table:.space 4              # DATA XREF: VFSysInit+104↑o
				       # VFSysMountDrv+148↑o ...
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 l_dev_init_info_table:.space 1          # DATA XREF: VFSysSetDeviceNANDFlash+BC↑o
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
 l_tmpWName:     .space 2                # DATA XREF: _MakeWStr+64↑o
				       # _MakeWStr+F8↑o ...
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1
		.space 1


_3091_0:        .string "w"             
		.byte 0
		.align 2

_3092_0:        .string "r"             
		.byte 0
		.align 2

_3093_0:        .string "@24"           
		.byte 0
		.align 4
MBoxDir:        .long _1695             
ConfigFile:     .long _1696             
CfgBakFile:     .long _1697             
VirtualGroupId: .short 1		
		.align 4
.global __NWC24Version
__NWC24Version: .long _2088             
		.align 3

_3643:          .string "%s%s"          
		.byte 0
		.align 4

_3815_0:        .string "@24"           
		.byte 0
		.align 3
MIMEEncStr:     .long _670              
		.align 4

 _2001:          .byte 0x64 # d          
		.byte 0x61 
		.byte 0x74 
		.byte    0

 _2002:          .byte 0x77 # w          
		.byte 0x69 
		.byte 0x69 
		.byte    0

 _2003:          .byte 0x6A # j          
		.byte 0x70 
		.byte 0x67 
		.byte    0

 _2004:          .byte 0x3F # ?          
		.byte 0x3F 
		.byte 0x3F 
		.byte    0

 _2005:          .byte 0x68 # h          
		.byte 0x74 
		.byte 0x6D 
		.byte    0

 _2006:          .byte 0x74 # t          
		.byte 0x78 
		.byte 0x74 
		.byte    0

 _2007:          .string "euc-jp"        
		.byte 0
		.align 4

 _2008:          .string "euc-kr"        
		.byte 0
		.align 2

 _2009:          .string "gb2312"        
		.byte 0
		.align 4

 _2023:          .string "utf-8"         
		.byte 0
		.align 2

 _2026:          .string "7bit"          
		.byte 0
		.align 4

 _2027:          .string "8bit"          
		.byte 0
		.align 2

 _2028:          .string "base64"        
		.byte 0
		.align 4
LoopBackEnable: .long 1		 
		.align 3

_3489:          .string "DATA\r\n"      
		.byte 0
		.align 4

_3492:          .string ">\r\n"         
		.byte 0

_3494:          .string "\r\n"          
		.byte 0
		.align 2

_3505:          .string "\"\r\n"        
		.byte 0

_3506:          .string "\r\n"          
		.string "--%s"
		.byte 0
		.align 2

_3507:          .string "\r\n"          
		.byte 0
		.align 2

_3508:          .string "--\r\n"        
		.byte 0
		.align 4

_3611:          .string "%c%s%s"        
		.byte 0
		.align 2

_3612:          .string "%s"            
		.byte 0
		.align 2

_3665:          .string "From: "        
		.byte 0
		.align 2

_3685:          .string "To: "          
		.byte 0
		.align 2

 _2462:          .string "Jan"           
		.byte 0

 _2463:          .string "Feb"           
		.byte 0

 _2464:          .string "Mar"           
		.byte 0

 _2465:          .string "Apr"           
		.byte 0

 _2466:          .string "May"           
		.byte 0

 _2467:          .string "Jun"           
		.byte 0

 _2468:          .string "Jul"           
		.byte 0

 _2469:          .string "Aug"           
		.byte 0

 _2470:          .string "Sep"           
		.byte 0

 _2471:          .string "Oct"           
		.byte 0

 _2472:          .string "Nov"           
		.byte 0

 _2473:          .string "Dec"           
		.byte 0
ContentTypeA:   .long _2668             
ContentTxEncA:  .long _2669             
ContentDispA:   .long _2670             
ContentTypeTP:  .long _2695             
ContentTxEncT:  .long _2696             

_3791:          .byte 0x3D # =          
		.byte  0xD
		.byte  0xA
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
FLFilePath:     .long _1605             
		.align 4
FLFilePath_0:   .long _1644             
		.align 3
DLFilePath:     .long _1685             
		.align 4
nwc24ShtFd:     .long 0xFFFFFFFF        
		.align 3
NETRexPPCVersionPrintableString:.long _561
		.align 4

DAYS_OF_MONTH:  .byte 0x1F              
		.byte 0x1C
		.byte 0x1F
		.byte 0x1E
		.byte 0x1F
		.byte 0x1E
		.byte 0x1F
		.byte 0x1F
		.byte 0x1E
		.byte 0x1F
		.byte 0x1E
		.byte 0x1F
		.byte    0
		.byte    0
		.byte    0
		.byte    0
DAYS_OF_YEAR:   .short 0		
		.byte    0
		.byte 0x1F
		.byte    0
		.byte 0x3B 
		.byte    0
		.byte 0x5A 
		.byte    0
		.byte 0x78 
		.byte    0
		.byte 0x97
		.byte    0
		.byte 0xB5
		.byte    0
		.byte 0xD4
		.byte    0
		.byte 0xF3
		.byte    1
		.byte 0x11
		.byte    1
		.byte 0x30 
		.byte    1
		.byte 0x4E 
.align 4

TtableInv:      .byte 0xD               
		.byte    5
		.byte    9
		.byte    7
		.byte    0
		.byte  0xF
		.byte  0xA
		.byte    2
		.byte  0xC
		.byte    3
		.byte  0xE
		.byte    1
		.byte    8
		.byte    6
		.byte  0xB
		.byte    4
.global VFipf_valid_fn_char
VFipf_valid_fn_char:.byte 1             
		.byte    3
		.byte    0
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    0
		.byte    1
		.byte    1
		.byte    3
		.byte    3
		.byte    0
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    0
		.byte    1
		.byte    0
		.byte    1
		.byte    0
		.byte    0
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    1
		.byte    0
		.byte    1
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    3
		.byte    0
		.byte    3
		.byte    3
		.byte    0
.global fat_special_values
fat_special_values:.long 0xFF7          
		.byte    0
		.byte    0
		.byte  0xF
		.byte 0xF8
		.byte    0
		.byte    0
		.byte  0xF
		.byte 0xFF
		.byte    0
		.byte    0
		.byte  0xF
		.byte    0
		.byte    0
		.byte    0
		.byte  0xF
		.byte 0xFF
		.byte    0
		.byte    0
		.byte 0xFF
		.byte 0xF7
		.byte    0
		.byte    0
		.byte 0xFF
		.byte 0xF8
		.byte    0
		.byte    0
		.byte 0xFF
		.byte 0xFF
		.byte    0
		.byte    0
		.byte 0xFF
		.byte    0
		.byte    0
		.byte    0
		.byte 0xFF
		.byte 0xFF
		.byte  0xF
		.byte 0xFF
		.byte 0xFF
		.byte 0xF7
		.byte  0xF
		.byte 0xFF
		.byte 0xFF
		.byte 0xF8
		.byte  0xF
		.byte 0xFF
		.byte 0xFF
		.byte 0xFF
		.byte  0xF
		.byte 0xFF
		.byte 0xFF
		.byte    0
		.byte  0xF
		.byte 0xFF
		.byte 0xFF
		.byte 0xFF
		.byte    0
		.byte    0
		.byte    0
		.byte    0
.global cp932_to_unicode
cp932_to_unicode:.byte 0x30 # 0         
		.byte    0
		.byte 0x30 
		.byte    1
		.byte 0x30 
		.byte    2
		.byte 0xFF
		.byte  0xC
		.byte 0xFF
		.byte  0xE
		.byte 0x30 
		.byte 0xFB
		.byte 0xFF
		.byte 0x1A
		.byte 0xFF
		.byte 0x1B
		.byte 0xFF
		.byte 0x1F
		.byte 0xFF
		.byte    1
		.byte 0x30 
		.byte 0x9B
		.byte 0x30 
		.byte 0x9C
		.byte    0
		.byte 0xB4
		.byte 0xFF
		.byte 0x40 
		.byte    0
		.byte 0xA8
		.byte 0xFF
		.byte 0x3E 
		.byte 0xFF
		.byte 0xE3
		.byte 0xFF
		.byte 0x3F 
		.byte 0x30 
		.byte 0xFD
		.byte 0x30 
		.byte 0xFE
		.byte 0x30 
		.byte 0x9D
		.byte 0x30 
		.byte 0x9E
		.byte 0x30 
		.byte    3
		.byte 0x4E 
		.byte 0xDD
		.byte 0x30 
		.byte    5
		.byte 0x30 
		.byte    6
		.byte 0x30 
		.byte    7
		.byte 0x30 
		.byte 0xFC
		.byte 0x20
		.byte 0x15
		.byte 0x20
		.byte 0x10
		.byte 0xFF
		.byte  0xF
		.byte 0xFF
		.byte 0x3C 
		.byte 0xFF
		.byte 0x5E 
		.byte 0x22 
		.byte 0x25 
		.byte 0xFF
		.byte 0x5C 
		.byte 0x20
		.byte 0x26 
		.byte 0x20
		.byte 0x25 
		.byte 0x20
		.byte 0x18
		.byte 0x20
		.byte 0x19
		.byte 0x20
		.byte 0x1C
		.byte 0x20
		.byte 0x1D
		.byte 0xFF
		.byte    8
		.byte 0xFF
		.byte    9
		.byte 0x30 
		.byte 0x14
		.byte 0x30 
		.byte 0x15
		.byte 0xFF
		.byte 0x3B 
		.byte 0xFF
		.byte 0x3D 
		.byte 0xFF
		.byte 0x5B 
		.byte 0xFF
		.byte 0x5D 
		.byte 0x30 
		.byte    8
		.byte 0x30 
		.byte    9
		.byte 0x30 
		.byte  0xA
		.byte 0x30 
		.byte  0xB
		.byte 0x30 
		.byte  0xC
		.byte 0x30 
		.byte  0xD
		.byte 0x30 
		.byte  0xE
		.byte 0x30 
		.byte  0xF
		.byte 0x30 
		.byte 0x10
		.byte 0x30 
		.byte 0x11
		.byte 0xFF
		.byte  0xB
		.byte 0xFF
		.byte  0xD
		.byte    0
		.byte 0xB1
		.byte    0
		.byte 0xD7
		.byte    0
		.byte    0
		.byte    0
		.byte 0xF7
		.byte 0xFF
		.byte 0x1D
		.byte 0x22 
		.byte 0x60 
		.byte 0xFF
		.byte 0x1C
		.byte 0xFF
		.byte 0x1E
		.byte 0x22 
		.byte 0x66 
		.byte 0x22 
		.byte 0x67 
		.byte 0x22 
		.byte 0x1E
		.byte 0x22 
		.byte 0x34 
		.byte 0x26 
		.byte 0x42 
		.byte 0x26 
		.byte 0x40 
		.byte    0
		.byte 0xB0
		.byte 0x20
		.byte 0x32 
		.byte 0x20
		.byte 0x33 
		.byte 0x21 
		.byte    3
		.byte 0xFF
		.byte 0xE5
		.byte 0xFF
		.byte    4
		.byte 0xFF
		.byte 0xE0
		.byte 0xFF
		.byte 0xE1
		.byte 0xFF
		.byte    5
		.byte 0xFF
		.byte    3
		.byte 0xFF
		.byte    6
		.byte 0xFF
		.byte  0xA
		.byte 0xFF
		.byte 0x20
		.byte    0
		.byte 0xA7
		.byte 0x26 
		.byte    6
		.byte 0x26 
		.byte    5
		.byte 0x25 
		.byte 0xCB
		.byte 0x25 
		.byte 0xCF
		.byte 0x25 
		.byte 0xCE
		.byte 0x25 
		.byte 0xC7
		.byte 0x25 
		.byte 0xC6
		.byte 0x25 
		.byte 0xA1
		.byte 0x25 
		.byte 0xA0
		.byte 0x25 
		.byte 0xB3
		.byte 0x25 
		.byte 0xB2
		.byte 0x25 
		.byte 0xBD
		.byte 0x25 
		.byte 0xBC
		.byte 0x20
		.byte 0x3B 
		.byte 0x30 
		.byte 0x12
		.byte 0x21 
		.byte 0x92
		.byte 0x21 
		.byte 0x90
		.byte 0x21 
		.byte 0x91
		.byte 0x21 
		.byte 0x93
		.byte 0x30 
		.byte 0x13
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte 0x22 
		.byte    8
		.byte 0x22 
		.byte  0xB
		.byte 0x22 
		.byte 0x86
		.byte 0x22 
		.byte 0x87
		.byte 0x22 
		.byte 0x82
		.byte 0x22 
		.byte 0x83
		.byte 0x22 
		.byte 0x2A 
		.byte 0x22 
		.byte 0x29 
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte 0x22 
		.byte 0x27 
		.byte 0x22 
		.byte 0x28 
		.byte 0xFF
		.byte 0xE2
		.byte 0x21 
		.byte 0xD2
		.byte 0x21 
		.byte 0xD4
		.byte 0x22 
		.byte    0
		.byte 0x22 
		.byte    3
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte 0x22 
		.byte 0x20
		.byte 0x22 
		.byte 0xA5
		.byte 0x23 # 
		.byte 0x12
		.byte 0x22 
		.byte    2
		.byte 0x22 
		.byte    7
		.byte 0x22 
		.byte 0x61 
		.byte 0x22 
		.byte 0x52 
		.byte 0x22 
		.byte 0x6A 
		.byte 0x22 
		.byte 0x6B 
		.byte 0x22 
		.byte 0x1A
		.byte 0x22 
		.byte 0x3D 
		.byte 0x22 
		.byte 0x1D
		.byte 0x22 
		.byte 0x35 
		.byte 0x22 
		.byte 0x2B 
		.byte 0x22 
		.byte 0x2C 
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte 0x21 
		.byte 0x2B 
		.byte 0x20
		.byte 0x30 
		.byte 0x26 
		.byte 0x6F 
		.byte 0x26 
		.byte 0x6D 
		.byte 0x26 
		.byte 0x6A 
		.byte 0x20
		.byte 0x20
		.byte 0x20
		.byte 0x21 
		.byte    0
		.byte 0xB6
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte 0x25 
		.byte 0xEF
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte 0xFF
		.byte 0x10
		.byte 0xFF
		.byte 0x11
		.byte 0xFF
		.byte 0x12
		.byte 0xFF
		.byte 0x13
		.byte 0xFF
		.byte 0x14
		.byte 0xFF
		.byte 0x15
		.byte 0xFF
		.byte 0x16
		.byte 0xFF
		.byte 0x17
		.byte 0xFF
		.byte 0x18
		.byte 0xFF
		.byte 0x19
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte 0xFF
		.byte 0x21 
		.byte 0xFF
		.byte 0x22 
		.byte 0xFF
		.byte 0x23 # 
		.byte 0xFF
		.byte 0x24 
		.byte 0xFF
		.byte 0x25 
		.byte 0xFF
		.byte 0x26 
		.byte 0xFF
		.byte 0x27 
		.byte 0xFF
		.byte 0x28 
		.byte 0xFF
		.byte 0x29 
		.byte 0xFF
		.byte 0x2A 
		.byte 0xFF
		.byte 0x2B 
		.byte 0xFF
		.byte 0x2C 
		.byte 0xFF
		.byte 0x2D 
		.byte 0xFF
		.byte 0x2E 
		.byte 0xFF
		.byte 0x2F 
		.byte 0xFF
		.byte 0x30 
		.byte 0xFF
		.byte 0x31 
		.byte 0xFF
		.byte 0x32 
		.byte 0xFF
		.byte 0x33 
		.byte 0xFF
		.byte 0x34 
		.byte 0xFF
		.byte 0x35 
		.byte 0xFF
		.byte 0x36 
		.byte 0xFF
		.byte 0x37 
		.byte 0xFF
		.byte 0x38 
		.byte 0xFF
		.byte 0x39 
		.byte 0xFF
		.byte 0x3A 
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte 0xFF
		.byte 0x41 
		.byte 0xFF
		.byte 0x42 
		.byte 0xFF
		.byte 0x43 
		.byte 0xFF
		.byte 0x44 
		.byte 0xFF
		.byte 0x45 
		.byte 0xFF
		.byte 0x46 
		.byte 0xFF
		.byte 0x47 
		.byte 0xFF
		.byte 0x48 
		.byte 0xFF
		.byte 0x49 
		.byte 0xFF
		.byte 0x4A 
		.byte 0xFF
		.byte 0x4B 
		.byte 0xFF
		.byte 0x4C 
		.byte 0xFF
		.byte 0x4D 
		.byte 0xFF
		.byte 0x4E 
		.byte 0xFF
		.byte 0x4F 
		.byte 0xFF
		.byte 0x50 
		.byte 0xFF
		.byte 0x51 
		.byte 0xFF
		.byte 0x52 
		.byte 0xFF
		.byte 0x53 
		.byte 0xFF
		.byte 0x54 
		.byte 0xFF
		.byte 0x55 
		.byte 0xFF
		.byte 0x56 
		.byte 0xFF
		.byte 0x57 
		.byte 0xFF
		.byte 0x58 
		.byte 0xFF
		.byte 0x59 
		.byte 0xFF
		.byte 0x5A 
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte 0x30 
		.byte 0x41 
		.byte 0x30 
		.byte 0x42 
		.byte 0x30 
		.byte 0x43 
		.byte 0x30 
		.byte 0x44 
		.byte 0x30 
		.byte 0x45 
		.byte 0x30 
		.byte 0x46 
		.byte 0x30 
		.byte 0x47 
		.byte 0x30 
		.byte 0x48 
		.byte 0x30 
		.byte 0x49 
		.byte 0x30 
		.byte 0x4A 
		.byte 0x30 
		.byte 0x4B 
		.byte 0x30 
		.byte 0x4C 
		.byte 0x30 
		.byte 0x4D 
		.byte 0x30 
		.byte 0x4E 
		.byte 0x30 
		.byte 0x4F 
		.byte 0x30 
		.byte 0x50 
		.byte 0x30 
		.byte 0x51 
		.byte 0x30 
		.byte 0x52 
		.byte 0x30 
		.byte 0x53 
		.byte 0x30 
		.byte 0x54 
		.byte 0x30 
		.byte 0x55 
		.byte 0x30 
		.byte 0x56 
		.byte 0x30 
		.byte 0x57 
		.byte 0x30 
		.byte 0x58 
		.byte 0x30 
		.byte 0x59 
		.byte 0x30 
		.byte 0x5A 
		.byte 0x30 
		.byte 0x5B 
		.byte 0x30 
		.byte 0x5C 
		.byte 0x30 
		.byte 0x5D 
		.byte 0x30 
		.byte 0x5E 
		.byte 0x30 
		.byte 0x5F 
		.byte 0x30 
		.byte 0x60 
		.byte 0x30 
		.byte 0x61 
		.byte 0x30 
		.byte 0x62 
		.byte 0x30 
		.byte 0x63 
		.byte 0x30 
		.byte 0x64 
		.byte 0x30 
		.byte 0x65 
		.byte 0x30 
		.byte 0x66 
		.byte 0x30 
		.byte 0x67 
		.byte 0x30 
		.byte 0x68 
		.byte 0x30 
		.byte 0x69 
		.byte 0x30 
		.byte 0x6A 
		.byte 0x30 
		.byte 0x6B 
		.byte 0x30 
		.byte 0x6C 
		.byte 0x30 
		.byte 0x6D 
		.byte 0x30 
		.byte 0x6E 
		.byte 0x30 
		.byte 0x6F 
		.byte 0x30 
		.byte 0x70 
		.byte 0x30 
		.byte 0x71 
		.byte 0x30 
		.byte 0x72 
		.byte 0x30 
		.byte 0x73 
		.byte 0x30 
		.byte 0x74 
		.byte 0x30 
		.byte 0x75 
		.byte 0x30 
		.byte 0x76 
		.byte 0x30 
		.byte 0x77 
		.byte 0x30 
		.byte 0x78 
		.byte 0x30 
		.byte 0x79 
		.byte 0x30 
		.byte 0x7A 
		.byte 0x30 
		.byte 0x7B 
		.byte 0x30 
		.byte 0x7C 
		.byte 0x30 
		.byte 0x7D 
		.byte 0x30 
		.byte 0x7E 
		.byte 0x30 
		.byte 0x7F 
		.byte 0x30 
		.byte 0x80
		.byte 0x30 
		.byte 0x81
		.byte 0x30 
		.byte 0x82
		.byte 0x30 
		.byte 0x83
		.byte 0x30 
		.byte 0x84
		.byte 0x30 
		.byte 0x85
		.byte 0x30 
		.byte 0x86
		.byte 0x30 
		.byte 0x87
		.byte 0x30 
		.byte 0x88
		.byte 0x30 
		.byte 0x89
		.byte 0x30 
		.byte 0x8A
		.byte 0x30 
		.byte 0x8B
		.byte 0x30 
		.byte 0x8C
		.byte 0x30 
		.byte 0x8D
		.byte 0x30 
		.byte 0x8E
		.byte 0x30 
		.byte 0x8F
		.byte 0x30 
		.byte 0x90
		.byte 0x30 
		.byte 0x91
		.byte 0x30 
		.byte 0x92
		.byte 0x30 
		.byte 0x93
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte 0x30 
		.byte 0xA1
		.byte 0x30 
		.byte 0xA2
		.byte 0x30 
		.byte 0xA3
		.byte 0x30 
		.byte 0xA4
		.byte 0x30 
		.byte 0xA5
		.byte 0x30 
		.byte 0xA6
		.byte 0x30 
		.byte 0xA7
		.byte 0x30 
		.byte 0xA8
		.byte 0x30 
		.byte 0xA9
		.byte 0x30 
		.byte 0xAA
		.byte 0x30 
		.byte 0xAB
		.byte 0x30 
		.byte 0xAC
		.byte 0x30 
		.byte 0xAD
		.byte 0x30 
		.byte 0xAE
		.byte 0x30 
		.byte 0xAF
		.byte 0x30 
		.byte 0xB0
		.byte 0x30 
		.byte 0xB1
		.byte 0x30 
		.byte 0xB2
		.byte 0x30 
		.byte 0xB3
		.byte 0x30 
		.byte 0xB4
		.byte 0x30 
		.byte 0xB5
		.byte 0x30 
		.byte 0xB6
		.byte 0x30 
		.byte 0xB7
		.byte 0x30 
		.byte 0xB8
		.byte 0x30 
		.byte 0xB9
		.byte 0x30 
		.byte 0xBA
		.byte 0x30 
		.byte 0xBB
		.byte 0x30 
		.byte 0xBC
		.byte 0x30 
		.byte 0xBD
		.byte 0x30 
		.byte 0xBE
		.byte 0x30 
		.byte 0xBF
		.byte 0x30 
		.byte 0xC0
		.byte 0x30 
		.byte 0xC1
		.byte 0x30 
		.byte 0xC2
		.byte 0x30 
		.byte 0xC3
		.byte 0x30 
		.byte 0xC4
		.byte 0x30 
		.byte 0xC5
		.byte 0x30 
		.byte 0xC6
		.byte 0x30 
		.byte 0xC7
		.byte 0x30 
		.byte 0xC8
		.byte 0x30 
		.byte 0xC9
		.byte 0x30 
		.byte 0xCA
		.byte 0x30 
		.byte 0xCB
		.byte 0x30 
		.byte 0xCC
		.byte 0x30 
		.byte 0xCD
		.byte 0x30 
		.byte 0xCE
		.byte 0x30 
		.byte 0xCF
		.byte 0x30 
		.byte 0xD0
		.byte 0x30 
		.byte 0xD1
		.byte 0x30 
		.byte 0xD2
		.byte 0x30 
		.byte 0xD3
		.byte 0x30 
		.byte 0xD4
		.byte 0x30 
		.byte 0xD5
		.byte 0x30 
		.byte 0xD6
		.byte 0x30 
		.byte 0xD7
		.byte 0x30 
		.byte 0xD8
		.byte 0x30 
		.byte 0xD9
		.byte 0x30 
		.byte 0xDA
		.byte 0x30 
		.byte 0xDB
		.byte 0x30 
		.byte 0xDC
		.byte 0x30 
		.byte 0xDD
		.byte 0x30 
		.byte 0xDE
		.byte 0x30 
		.byte 0xDF
		.byte    0
		.byte    0
		.byte 0x30 
		.byte 0xE0
		.byte 0x30 
		.byte 0xE1
		.byte 0x30 
		.byte 0xE2
		.byte 0x30 
		.byte 0xE3
		.byte 0x30 
		.byte 0xE4
		.byte 0x30 
		.byte 0xE5
		.byte 0x30 
		.byte 0xE6
		.byte 0x30 
		.byte 0xE7
		.byte 0x30 
		.byte 0xE8
		.byte 0x30 
		.byte 0xE9
		.byte 0x30 
		.byte 0xEA
		.byte 0x30 
		.byte 0xEB
		.byte 0x30 
		.byte 0xEC
		.byte 0x30 
		.byte 0xED
		.byte 0x30 
		.byte 0xEE
		.byte 0x30 
		.byte 0xEF
		.byte 0x30 
		.byte 0xF0
		.byte 0x30 
		.byte 0xF1
		.byte 0x30 
		.byte 0xF2
		.byte 0x30 
		.byte 0xF3
		.byte 0x30 
		.byte 0xF4
		.byte 0x30 
		.byte 0xF5
		.byte 0x30 
		.byte 0xF6
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    3
		.byte 0x91
		.byte    3
		.byte 0x92
		.byte    3
		.byte 0x93
		.byte    3
		.byte 0x94
		.byte    3
		.byte 0x95
		.byte    3
		.byte 0x96
		.byte    3
		.byte 0x97
		.byte    3
		.byte 0x98
		.byte    3
		.byte 0x99
		.byte    3
		.byte 0x9A
		.byte    3
		.byte 0x9B
		.byte    3
		.byte 0x9C
		.byte    3
		.byte 0x9D
		.byte    3
		.byte 0x9E
		.byte    3
		.byte 0x9F
		.byte    3
		.byte 0xA0
		.byte    3
		.byte 0xA1
		.byte    3
		.byte 0xA3
		.byte    3
		.byte 0xA4
		.byte    3
		.byte 0xA5
		.byte    3
		.byte 0xA6
		.byte    3
		.byte 0xA7
		.byte    3
		.byte 0xA8
		.byte    3
		.byte 0xA9
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    3
		.byte 0xB1
		.byte    3
		.byte 0xB2
		.byte    3
		.byte 0xB3
		.byte    3
		.byte 0xB4
		.byte    3
		.byte 0xB5
		.byte    3
		.byte 0xB6
		.byte    3
		.byte 0xB7
		.byte    3
		.byte 0xB8
		.byte    3
		.byte 0xB9
		.byte    3
		.byte 0xBA
		.byte    3
		.byte 0xBB
		.byte    3
		.byte 0xBC
		.byte    3
		.byte 0xBD
		.byte    3
		.byte 0xBE
		.byte    3
		.byte 0xBF
		.byte    3
		.byte 0xC0
		.byte    3
		.byte 0xC1
		.byte    3
		.byte 0xC3
		.byte    3
		.byte 0xC4
		.byte    3
		.byte 0xC5
		.byte    3
		.byte 0xC6
		.byte    3
		.byte 0xC7
		.byte    3
		.byte 0xC8
		.byte    3
		.byte 0xC9
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    4
		.byte 0x10
		.byte    4
		.byte 0x11
		.byte    4
		.byte 0x12
		.byte    4
		.byte 0x13
		.byte    4
		.byte 0x14
		.byte    4
		.byte 0x15
		.byte    4
		.byte    1
		.byte    4
		.byte 0x16
		.byte    4
		.byte 0x17
		.byte    4
		.byte 0x18
		.byte    4
		.byte 0x19
		.byte    4
		.byte 0x1A
		.byte    4
		.byte 0x1B
		.byte    4
		.byte 0x1C
		.byte    4
		.byte 0x1D
		.byte    4
		.byte 0x1E
		.byte    4
		.byte 0x1F
		.byte    4
		.byte 0x20
		.byte    4
		.byte 0x21 
		.byte    4
		.byte 0x22 
		.byte    4
		.byte 0x23 # 
		.byte    4
		.byte 0x24 
		.byte    4
		.byte 0x25 
		.byte    4
		.byte 0x26 
		.byte    4
		.byte 0x27 
		.byte    4
		.byte 0x28 
		.byte    4
		.byte 0x29 
		.byte    4
		.byte 0x2A 
		.byte    4
		.byte 0x2B 
		.byte    4
		.byte 0x2C 
		.byte    4
		.byte 0x2D 
		.byte    4
		.byte 0x2E 
		.byte    4
		.byte 0x2F 
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    4
		.byte 0x30 
		.byte    4
		.byte 0x31 
		.byte    4
		.byte 0x32 
		.byte    4
		.byte 0x33 
		.byte    4
		.byte 0x34 
		.byte    4
		.byte 0x35 
		.byte    4
		.byte 0x51 
		.byte    4
		.byte 0x36 
		.byte    4
		.byte 0x37 
		.byte    4
		.byte 0x38 
		.byte    4
		.byte 0x39 
		.byte    4
		.byte 0x3A 
		.byte    4
		.byte 0x3B 
		.byte    4
		.byte 0x3C 
		.byte    4
		.byte 0x3D 
		.byte    0
		.byte    0
		.byte    4
		.byte 0x3E 
		.byte    4
		.byte 0x3F 
		.byte    4
		.byte 0x40 
		.byte    4
		.byte 0x41 
		.byte    4
		.byte 0x42 
		.byte    4
		.byte 0x43 
		.byte    4
		.byte 0x44 
		.byte    4
		.byte 0x45 
		.byte    4
		.byte 0x46 
		.byte    4
		.byte 0x47 
		.byte    4
		.byte 0x48 
		.byte    4
		.byte 0x49 
		.byte    4
		.byte 0x4A 
		.byte    4
		.byte 0x4B 
		.byte    4
		.byte 0x4C 
		.byte    4
		.byte 0x4D 
		.byte    4
		.byte 0x4E 
		.byte    4
		.byte 0x4F 
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte 0x25 
		.byte    0
		.byte 0x25 
		.byte    2
		.byte 0x25 
		.byte  0xC
		.byte 0x25 
		.byte 0x10
		.byte 0x25 
		.byte 0x18
		.byte 0x25 
		.byte 0x14
		.byte 0x25 
		.byte 0x1C
		.byte 0x25 
		.byte 0x2C 
		.byte 0x25 
		.byte 0x24 
		.byte 0x25 
		.byte 0x34 
		.byte 0x25 
		.byte 0x3C 
		.byte 0x25 
		.byte    1
		.byte 0x25 
		.byte    3
		.byte 0x25 
		.byte  0xF
		.byte 0x25 
		.byte 0x13
		.byte 0x25 
		.byte 0x1B
		.byte 0x25 
		.byte 0x17
		.byte 0x25 
		.byte 0x23 # 
		.byte 0x25 
		.byte 0x33 
		.byte 0x25 
		.byte 0x2B 
		.byte 0x25 
		.byte 0x3B 
		.byte 0x25 
		.byte 0x4B 
		.byte 0x25 
		.byte 0x20
		.byte 0x25 
		.byte 0x2F 
		.byte 0x25 
		.byte 0x28 
		.byte 0x25 
		.byte 0x37 
		.byte 0x25 
		.byte 0x3F 
		.byte 0x25 
		.byte 0x1D
		.byte 0x25 
		.byte 0x30 
		.byte 0x25 
		.byte 0x25 
		.byte 0x25 
		.byte 0x38 
		.byte 0x25 
		.byte 0x42 
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte 0x24 
		.byte 0x60 
		.byte 0x24 
		.byte 0x61 
		.byte 0x24 
		.byte 0x62 
		.byte 0x24 
		.byte 0x63 
		.byte 0x24 
		.byte 0x64 
		.byte 0x24 
		.byte 0x65 
		.byte 0x24 
		.byte 0x66 
		.byte 0x24 
		.byte 0x67 
		.byte 0x24 
		.byte 0x68 
		.byte 0x24 
		.byte 0x69 
		.byte 0x24 
		.byte 0x6A 
		.byte 0x24 
		.byte 0x6B 
		.byte 0x24 
		.byte 0x6C 
		.byte 0x24 
		.byte 0x6D 
		.byte 0x24 
		.byte 0x6E 
		.byte 0x24 
		.byte 0x6F 
		.byte 0x24 
		.byte 0x70 
		.byte 0x24 
		.byte 0x71 
		.byte 0x24 
		.byte 0x72 
		.byte 0x24 
		.byte 0x73 
		.byte 0x21 
		.byte 0x60 
		.byte 0x21 
		.byte 0x61 
		.byte 0x21 
		.byte 0x62 
		.byte 0x21 
		.byte 0x63 
		.byte 0x21 
		.byte 0x64 
		.byte 0x21 
		.byte 0x65 
		.byte 0x21 
		.byte 0x66 
		.byte 0x21 
		.byte 0x67 
		.byte 0x21 
		.byte 0x68 
		.byte 0x21 
		.byte 0x69 
		.byte    0
		.byte    0
		.byte 0x33 
		.byte 0x49 
		.byte 0x33 
		.byte 0x14
		.byte 0x33 
		.byte 0x22 
		.byte 0x33 
		.byte 0x4D 
		.byte 0x33 
		.byte 0x18
		.byte 0x33 
		.byte 0x27 
		.byte 0x33 
		.byte    3
		.byte 0x33 
		.byte 0x36 
		.byte 0x33 
		.byte 0x51 
		.byte 0x33 
		.byte 0x57 
		.byte 0x33 
		.byte  0xD
		.byte 0x33 
		.byte 0x26 
		.byte 0x33 
		.byte 0x23 # 
		.byte 0x33 
		.byte 0x2B 
		.byte 0x33 
		.byte 0x4A 
		.byte 0x33 
		.byte 0x3B 
		.byte 0x33 
		.byte 0x9C
		.byte 0x33 
		.byte 0x9D
		.byte 0x33 
		.byte 0x9E
		.byte 0x33 
		.byte 0x8E
		.byte 0x33 
		.byte 0x8F
		.byte 0x33 
		.byte 0xC4
		.byte 0x33 
		.byte 0xA1
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte 0x33 
		.byte 0x7B 
		.byte    0
		.byte    0
		.byte 0x30 
		.byte 0x1D
		.byte 0x30 
		.byte 0x1F
		.byte 0x21 
		.byte 0x16
		.byte 0x33 
		.byte 0xCD
		.byte 0x21 
		.byte 0x21 
		.byte 0x32 
		.byte 0xA4
		.byte 0x32 
		.byte 0xA5
		.byte 0x32 
		.byte 0xA6
		.byte 0x32 
		.byte 0xA7
		.byte 0x32 
		.byte 0xA8
		.byte 0x32 
		.byte 0x31 
		.byte 0x32 
		.byte 0x32 
		.byte 0x32 
		.byte 0x39 
		.byte 0x33 
		.byte 0x7E 
		.byte 0x33 
		.byte 0x7D 
		.byte 0x33 
		.byte 0x7C 
		.byte 0x22 
		.byte 0x52 
		.byte 0x22 
		.byte 0x61 
		.byte 0x22 
		.byte 0x2B 
		.byte 0x22 
		.byte 0x2E 
		.byte 0x22 
		.byte 0x11
		.byte 0x22 
		.byte 0x1A
		.byte 0x22 
		.byte 0xA5
		.byte 0x22 
		.byte 0x20
		.byte 0x22 
		.byte 0x1F
		.byte 0x22 
		.byte 0xBF
		.byte 0x22 
		.byte 0x35 
		.byte 0x22 
		.byte 0x29 
		.byte 0x22 
		.byte 0x2A 
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte    0
		.byte 0x4E 
		.byte 0x9C
		.byte 0x55 
		.byte 0x16
		.byte 0x5A 
		.byte    3
		.byte 0x96
		.byte 0x3F 
		.byte 0x54 
		.byte 0xC0
		.byte 0x61 
		.byte 0x1B
		.byte 0x63 
		.byte 0x28 
		.byte 0x59 
		.byte 0xF6
		.byte 0x90
		.byte 0x22 
		.byte 0x84
		.byte 0x75 
		.byte 0x83
		.byte 0x1C
		.byte 0x7A 
		.byte 0x50 
		.byte 0x60 
		.byte 0xAA
		.byte 0x63 
		.byte 0xE1
		.byte 0x6E 
		.byte 0x25 
		.byte 0x65 
		.byte 0xED
		.byte 0x84
		.byte 0x66 
		.byte 0x82
		.byte 0xA6
		.byte 0x9B
		.byte 0xF5
		.byte 0x68 
		.byte 0x93
		.byte 0x57 
		.byte 0x27 
		.byte 0x65 
		.byte 0xA1
		.byte 0x62 
		.byte 0x71 
		.byte 0x5B 
		.byte 0x9B
		.byte 0x59 
		.byte 0xD0
		.byte 0x86
		.byte 0x7B 
		.byte 0x98
		.byte 0xF4
		.byte 0x7D 
		.byte 0x62 
		.byte 0x7D 
		.byte 0xBE
		.byte 0x9B
		.byte 0x8E
		.byte 0x62 
		.byte 0x16
		.byte 0x7C 
		.byte 0x9F
		.byte 0x88
		.byte 0xB7
		.byte 0x5B 
		.byte 0x89
		.byte 0x5E 
		.byte 0xB5
		.byte 0x63 
		.byte    9
		.byte 0x66 
		.byte 0x97
		.byte 0x68 
		.byte 0x48 
		.byte 0x95
		.byte 0xC7
		.byte 0x97
		.byte 0x8D
		.byte 0x67 
		.byte 0x4F 
		.byte 0x4E 
		.byte 0xE5
		.byte 0x4F 
		.byte  0xA
		.byte 0x4F 
		.byte 0x4D 
		.byte 0x4F 
		.byte 0x9D
		.byte 0x50 
		.byte 0x49 
		.byte 0x56 
		.byte 0xF2
		.byte 0x59 
		.byte 0x37 
		.byte 0x59 
		.byte 0xD4
		.byte 0x5A 
		.byte    1
		.byte 0x5C 
		.byte    9
		.byte 0x60 
		.byte 0xDF
		.byte 0x61 
		.byte  0xF
		.byte 0x61 
		.byte 0x70 
		.byte 0x66 
		.byte 0x13
		.byte 0x69 
		.byte    5
		.byte 0x70 
		.byte 0xBA
		.byte 0x75 
		.byte 0x4F 
		.byte 0x75 
		.byte 0x70 
		.byte 0x79 
		.byte 0xFB
		.byte 0x7D 
		.byte 0xAD
		.byte 0x7D 
		.byte 0xEF
		.byte 0x80
		.byte 0xC3
		.byte 0x84
		.byte  0xE
		.byte 0x88
		.byte 0x63 
		.byte 0x8B
		.byte    2
		.byte 0x90
		.byte 0x55 
		.byte 0x90
		.byte 0x7A 
		.byte 0x53 
		.byte 0x3B 
		.byte 0x4E 
		.byte 0x95
		.byte 0x4E 
		.byte 0xA5
		.byte 0x57 
		.byte 0xDF
		.byte 0x80
		.byte 0xB2
		.byte 0x90
		.byte 0xC1
		.byte 0x78 
		.byte 0xEF
		.byte 0x4E 
		.byte    0
		.byte 0x58 
		.byte 0xF1
		.byte 0x6E 
		.byte 0xA2
		.byte 0x90
		.byte 0x38 
		.byte 0x7A 
		.byte 0x32 
		.byte 0x83
		.byte 0x28 
		.byte 0x82
		.byte 0x8B
		.byte 0x9C
		.byte 0x2F 
		.byte 0x51 
		.byte 0x41 
		.byte 0x53 
		.byte 0x70 
		.byte 0x54 
		.byte 0xBD
		.byte 0x54 
		.byte 0xE1
		.byte 0x56 
		.byte 0xE0
		.byte 0x59 
		.byte 0xFB
		.byte 0x5F 
		.byte 0x15
		.byte 0x98
		.byte 0xF2
		.byte 0x6D 
		.byte 0xEB
		.byte 0x80
		.byte 0xE4
		.byte 0x85
		.byte 0x2D 
		.byte 0x96
		.byte 0x62 
		.byte 0x96
		.byte 0x70 
		.byte 0x96
		.byte 0xA0
		.byte 0x97
		.byte 0xFB
		.byte 0x54 
		.byte  0xB
		.byte 0x53 
		.byte 0xF3
		.byte 0x5B 
		.byte 0x87
		.byte 0x70 
		.byte 0xCF
		.byte 0x7F 
		.byte 0xBD
		.byte 0x8F
		.byte 0xC2
		.byte 0x96
		.byte 0xE8
		.byte 0x53 
		.byte 0x6F 
		.byte 0x9D
		.byte 0x5C 
		.byte 0x7A 
		.byte 0xBA
		.byte 0x4E 
		.byte 0x11
		.byte 0x78 
		.byte 0x93
		.byte 0x81
		.byte 0xFC
		.byte 0x6E 
		.byte 0x26 
		.byte 0x56 
		.byte 0x18
		.byte 0x55 
		.byte    4
		.byte 0x6B 
		.byte 0x1D
		.byte 0x85
		.byte 0x1A
		.byte 0x9C
		.byte 0x3B 
		.byte 0x59 
		.byte 0xE5
		.byte 0x53 
		.byte 0xA9
		.byte 0x6D 
		.byte 0x66 
		.byte 0x74 
		.byte 0xDC
		.byte 0x95
		.byte 0x8F
		.byte 0x56 
		.byte 0x42 
		.byte 0x4E 
		.byte 0x91
		.byte 0x90
		.byte 0x4B 
		.byte 0x96
		.byte 0xF2
		.byte 0x83
		.byte 0x4F 
		.byte 0x99
		.byte  0xC
		.byte 0x53 
		.byte 0xE1
		.byte 0x55 
		.byte 0xB6
		.byte 0x5B 
		.byte 0x30 
		.byte 0x5F 
		.byte 0x71 
		.byte 0x66 
		.byte 0x20
		.byte 0x66 
		.byte 0xF3
		.byte 0x68 
		.byte    4
		.byte 0x6C 
		.byte 0x38 
		.byte 0x6C 
		.byte 0xF3
		.byte 0x6D 
		.byte 0x29 
		.byte 0x74 
		.byte 0x5B 
		.byte 0x76 
		.byte 0xC8
		.byte 0x7A 
		.byte 0x4E 
		.byte 0x98
		.byte 0x34 
		.byte 0x82
		.byte 0xF1
		.byte 0x88
		.byte 0x5B 
		.byte 0x8A
		.byte 0x60 
		.byte 0x92
		.byte 0xED
		.byte 0x6D 
		.byte 0xB2
		.byte 0x75 
		.byte 0xAB
		.byte 0x76 
		.byte 0xCA
		.byte 0x99
		.byte 0xC5
		.byte 0x60 
		.byte 0xA6
		.byte 0x8B
		.byte    1
		.byte 0x8D
		.byte 0x8A
		.byte 0x95
		.byte 0xB2
		.byte 0x69 
		.byte 0x8E
		.byte 0x53 
		.byte 0xAD
		.byte 0x51 
		.byte 0x86
		.byte    0
		.byte    0
		.byte 0x57 
		.byte 0x12
		.byte 0x58 
		.byte 0x30 
		.byte 0x59 
		.byte 0x44 
		.byte 0x5B 
		.byte 0xB4
		.byte 0x5E 
		.byte 0xF6
		.byte 0x60 
		.byte 0x28 
		.byte 0x63 
		.byte 0xA9
		.byte 0x63 
		.byte 0xF4
		.byte 0x6C 
		.byte 0xBF
		.byte 0x6F 
		.byte 0x14
		.byte 0x70 
		.byte 0x8E
		.byte 0x71 
		.byte 0x14
		.byte 0x71 
		.byte 0x59 
		.byte 0x71 
		.byte 0xD5
		.byte 0x73 
		.byte 0x3F 
		.byte 0x7E 
		.byte    1
		.byte 0x82
		.byte 0x76 
		.byte 0x82
		.byte 0xD1
		.byte 0x85
		.byte 0x97
		.byte 0x90
		.byte 0x60 
		.byte 0x92
		.byte 0x5B 
		.byte 0x9D
		.byte 0x1B
		.byte 0x58 
		.byte 0x69 
		.byte 0x65 
		.byte 0xBC
		.byte 0x6C 
		.byte 0x5A 
		.byte 0x75 
		.byte 0x25 
		.byte 0x51 
		.byte 0xF9
		.byte 0x59 
		.byte 0x2E 
		.byte 0x59 
		.byte 0x65 
		.byte 0x5F 
		.byte 0x80
		.byte 0x5F 
		.byte 0xDC
		.byte 0x62 
		.byte 0xBC
		.byte 0x65 
		.byte 0xFA
		.byte 0x6A 
		.byte 0x2A 
		.byte 0x6B 
		.byte 0x27 
		.byte 0x6B 
		.byte 0xB4
		.byte 0x73 
		.byte 0x8B
		.byte 0x7F 
		.byte 0xC1
		.byte 0x89
		.byte 0x56 
		.byte 0x9D
		.byte 0x2C 
		.byte 0x9D
		.byte  0xE
		.byte 0x9E
		.byte 0xC4
		.byte 0x5C 
		.byte 0xA1
		.byte 0x6C 
		.byte 0x96
		.byte 0x83
		.byte 0x7B 
		.byte 0x51 
		.byte    4
		.byte 0x5C 
		.byte 0x4B 
		.byte 0x61 
		.byte 0xB6
		.byte 0x81
		.byte 0xC6
		.byte 0x68 
		.byte 0x76 
		.byte 0x72 
		.byte 0x61 
		.byte 0x4E 
		.byte 0x59 
		.byte 0x4F 
		.byte 0xFA
		.byte 0x53 
		.byte 0x78 
		.byte 0x60 
		.byte 0x69 
		.byte 0x6E 
		.byte 0x29 
		.byte 0x7A 
		.byte 0x4F 
		.byte 0x97
		.byte 0xF3
		.byte 0x4E 
		.byte  0xB
		.byte 0x53 
		.byte 0x16
		.byte 0x4E 
		.byte 0xEE
		.byte 0x4F 
		.byte 0x55 
		.byte 0x4F 
		.byte 0x3D 
		.byte 0x4F 
		.byte 0xA1
		.byte 0x4F 
		.byte 0x73 
		.byte 0x52 
		.byte 0xA0
		.byte 0x53 
		.byte 0xEF
		.byte 0x56 
		.byte    9
		.byte 0x59 
		.byte  0xF
		.byte 0x5A 
		.byte 0xC1
		.byte 0x5B 
		.byte 0xB6
		.byte 0x5B 
		.byte 0xE1
		.byte 0x79 
		.byte 0xD1
		.byte 0x66 
		.byte 0x87
		.byte 0x67 
		.byte 0x9C
		.byte 0x67 
		.byte 0xB6
		.byte 0x6B 
		.byte 0x4C 
		.byte 0x6C 
		.byte 0xB3
		.byte 0x70 
		.byte 0x6B 
		.byte 0x73 
		.byte 0xC2
		.byte 0x79 
		.byte 0x8D
		.byte 0x79 
		.byte 0xBE
		.byte 0x7A 
		.byte 0x3C 
		.byte 0x7B 
		.byte 0x87
		.byte 0x82
		.byte 0xB1
		.byte 0x82
		.byte 0xDB
		.byte 0x83
		.byte    4
		.byte 0x83
		.byte 0x77 
		.byte 0x83
		.byte 0xEF
		.byte 0x83
		.byte 0xD3
		.byte 0x87
		.byte 0x66 
		.byte 0x8A
		.byte 0xB2
		.byte 0x56 
		.byte 0x29 
		.byte 0x8C
		.byte 0xA8
		.byte 0x8F
		.byte 0xE6
		.byte 0x90
		.byte 0x4E 
		.byte 0x97
		.byte 0x1E
		.byte 0x86
		.byte 0x8A
		.byte 0x4F 
		.byte 0xC4
		.byte 0x5C 
		.byte 0xE8
		.byte 0x62 
		.byte 0x11
		.byte 0x72 
		.byte 0x59 
		.byte 0x75 
		.byte 0x3B 
		.byte 0x81
		.byte 0xE5
		.byte 0x82
		.byte 0xBD
		.byte 0x86
		.byte 0xFE
		.byte 0x8C
		.byte 0xC0
		.byte 0x96
		.byte 0xC5
		.byte 0x99
		.byte 0x13
		.byte 0x99
		.byte 0xD5
		.byte 0x4E 
		.byte 0xCB
		.byte 0x4F 
		.byte 0x1A
		.byte 0x89
		.byte 0xE3
		.byte 0x56 
		.byte 0xDE
		.byte 0x58 
		.byte 0x4A 
		.byte 0x58 
		.byte 0xCA
		.byte 0x5E 
		.byte 0xFB
		.byte 0x5F 
		.byte 0xEB
		.byte 0x60 
		.byte 0x2A 
		.byte 0x60 
		.byte 0x94
		.byte 0x60 
		.byte 0x62 
		.byte 0x61 
		.byte 0xD0
		.byte 0x62 
		.byte 0x12
		.byte 0x62 
		.byte 0xD0
		.byte 0x65 
		.byte 0x39 
		.byte 0x9B
		.byte 0x41 
		.byte 0x66 
		.byte 0x66 
		.byte 0x68 
		.byte 0xB0
		.byte 0x6D 
		.byte 0x77 
		.byte 0x70 
		.byte 0x70 
		.byte 0x75 
		.byte 0x4C 
		.byte 0x76 
		.byte 0x86
		.byte 0x7D 
		.byte 0x75 
		.byte 0x82
		.byte 0xA5
		.byte 0x87
		.byte 0xF9
		.byte 0x95
		.byte 0x8B
		.byte 0x96
		.byte 0x8E
		.byte 0x8C
		.byte 0x9D
		.byte 0x51 
		.byte 0xF1
		.byte 0x52 
		.byte 0xBE
		.byte 0x59 
		.byte 0x16
		.byte 0x54 
		.byte 0xB3
		.byte 0x5B 
		.byte 0xB3
		.byte 0x5D 
		.byte 0x16
		.byte 0x61 
		.byte 0x68 
		.byte 0x69 
		.byte 0x82
		.byte 0x6D 
		.byte 0xAF
		.byte 0x78 
		.byte 0x8D
		.byte 0x84
		.byte 0xCB
		.byte 0x88
		.byte 0x57 
		.byte 0x8A
		.byte 0x72 
		.byte 0x93
		.byte 0xA7
		.byte 0x9A
		.byte 0xB8
		.byte 0x6D 
		.byte 0x6C 
		.byte 0x99
		.byte 0xA8
		.byte 0x86
		.byte 0xD9
		.byte 0x57 
		.byte 0xA3
		.byte 0x67 
		.byte 0xFF
		.byte 0x86
		.byte 0xCE
		.byte 0x92
		.byte  0xE
		.byte 0x52 
		.byte 0x83
		.byte 0x56 
		.byte 0x87
		.byte 0x54 
		.byte    4
		.byte 0x5E 
		.byte 0xD3
		.byte 0x62 
		.byte 0xE1
		.byte 0x64 
		.byte 0xB9
		.byte 0x68 
		.byte 0x3C 
		.byte 0x68 
		.byte 0x38 
		.byte 0x6B 
		.byte 0xBB
		.byte 0x73 
		.byte 0x72 
		.byte 0x78 
		.byte 0xBA
		.byte 0x7A 
		.byte 0x6B 
		.byte 0x89
		.byte 0x9A
		.byte 0x89
		.byte 0xD2
		.byte 0x8D
		.byte 0x6B 
		.byte 0x8F
		.byte    3
		.byte 0x90
		.byte 0xED
		.byte 0x95
		.byte 0xA3
		.byte 0x96
		.byte 0x94
		.byte 0x97
		.byte 0x69 
		.byte 0x5B 
		.byte 0x66 
		.byte 0x5C 
		.byte 0xB3
		.byte 0x69 
		.byte 0x7D 
		.byte 0x98
		.byte 0x4D 
		.byte 0x98
		.byte 0x4E 
		.byte 0x63 
		.byte 0x9B
		.byte 0x7B 
		.byte 0x20
		.byte 0x6A 
		.byte 0x2B 
		.byte    0
		.byte    0
		.byte 0x6A 
		.byte 0x7F 
		.byte 0x68 
		.byte 0xB6
		.byte 0x9C
		.byte  0xD
		.byte 0x6F 
		.byte 0x5F 
		.byte 0x52 
		.byte 0x72 
		.byte 0x55 
		.byte 0x9D
		.byte 0x60 
		.byte 0x70 
		.byte 0x62 
		.byte 0xEC
		.byte 0x6D 
		.byte 0x3B 
		.byte 0x6E 
		.byte    7
		.byte 0x6E 
		.byte 0xD1
		.byte 0x84
		.byte 0x5B 
		.byte 0x89
		.byte 0x10
		.byte 0x8F
		.byte 0x44 
		.byte 0x4E 
		.byte 0x14
		.byte 0x9C
		.byte 0x39 
		.byte 0x53 
		.byte 0xF6
		.byte 0x69 
		.byte 0x1B
		.byte 0x6A 
		.byte 0x3A 
		.byte 0x97
		.byte 0x84
		.byte 0x68 
		.byte 0x2A 
		.byte 0x51 
		.byte 0x5C 
		.byte 0x7A 
		.byte 0xC3
		.byte 0x84
		.byte 0xB2
		.byte 0x91
		.byte 0xDC
		.byte 0x93
		.byte 0x8C
		.byte 0x56 
		.byte 0x5B 
		.byte 0x9D
		.byte 0x28 
		.byte 0x68 
		.byte 0x22 
		.byte 0x83
		.byte    5
		.byte 0x84
		.byte 0x31 
		.byte 0x7C 
		.byte 0xA5
		.byte 0x52 
		.byte    8
		.byte 0x82
		.byte 0xC5
		.byte 0x74 
		.byte 0xE6
		.byte 0x4E 
		.byte 0x7E 
		.byte 0x4F 
		.byte 0x83
		.byte 0x51 
		.byte 0xA0
		.byte 0x5B 
		.byte 0xD2
		.byte 0x52 
		.byte  0xA
		.byte 0x52 
		.byte 0xD8
		.byte 0x52 
		.byte 0xE7
		.byte 0x5D 
		.byte 0xFB
		.byte 0x55 
		.byte 0x9A
		.byte 0x58 
		.byte 0x2A 
		.byte 0x59 
		.byte 0xE6
		.byte 0x5B 
		.byte 0x8C
		.byte 0x5B 
		.byte 0x98
		.byte 0x5B 
		.byte 0xDB
		.byte 0x5E 
		.byte 0x72 
		.byte 0x5E 
		.byte 0x79 
		.byte 0x60 
		.byte 0xA3
		.byte 0x61 
		.byte 0x1F
		.byte 0x61 
		.byte 0x63 
		.byte 0x61 
		.byte 0xBE
		.byte 0x63 
		.byte 0xDB
		.byte 0x65 
		.byte 0x62 
		.byte 0x67 
		.byte 0xD1
		.byte 0x68 
		.byte 0x53 
		.byte 0x68 
		.byte 0xFA
		.byte 0x6B 
		.byte 0x3E 
		.byte 0x6B 
		.byte 0x53 
		.byte 0x6C 
		.byte 0x57 
		.byte 0x6F 
		.byte 0x22 
		.byte 0x6F 
		.byte 0x97
		.byte 0x6F 
		.byte 0x45 
		.byte 0x74 
		.byte 0xB0
		.byte 0x75 
		.byte 0x18
		.byte 0x76 
		.byte 0xE3
		.byte 0x77 
		.byte  0xB
		.byte 0x7A 
		.byte 0xFF
		.byte 0x7B 
		.byte 0xA1
		.byte 0x7C 
		.byte 0x21 
		.byte 0x7D 
		.byte 0xE9
		.byte 0x7F 
		.byte 0x36 
		.byte 0x7F 
		.byte 0xF0
		.byte 0x80
		.byte 0x9D
		.byte 0x82
		.byte 0x66 
		.byte 0x83
		.byte 0x9E
		.byte 0x89
		.byte 0xB3
		.byte 0x8A
		.byte 0xCC
		.byte 0x8C
		.byte 0xAB
		.byte 0x90
		.byte 0x84
		.byte 0x94
		.byte 0x51 
		.byte 0x95
		.byte 0x93
		.byte 0x95
		.byte 0x91
		.byte 0x95
		.byte 0xA2
		.byte 0x96
		.byte 0x65 
		.byte 0x97
		.byte 0xD3
		.byte 0x99
		.byte 0x28 
		.byte 0x82
		.byte 0x18
		.byte 0x4E 
		.byte 0x38 
		.byte 0x54 
		.byte 0x2B 
		.byte 0x5C 
		.byte 0xB8
		.byte 0x5D 
		.byte 0xCC
		.byte 0x73 
		.byte 0xA9
		.byte 0x76 
		.byte 0x4C 
		.byte 0x77 
		.byte 0x3C 
		.byte 0x5C 
		.byte 0xA9
		.byte 0x7F 
		.byte 0xEB
		.byte 0x8D
		.byte  0xB
		.byte 0x96
		.byte 0xC1
		.byte 0x98
		.byte 0x11
		.byte 0x98
		.byte 0x54 
		.byte 0x98
		.byte 0x58 
		.byte 0x4F 
		.byte    1
		.byte 0x4F 
		.byte  0xE
		.byte 0x53 
		.byte 0x71 
		.byte 0x55 
		.byte 0x9C
		.byte 0x56 
		.byte 0x68 
		.byte 0x57 
		.byte 0xFA
		.byte 0x59 
		.byte 0x47 
		.byte 0x5B 
		.byte    9
		.byte 0x5B 
		.byte 0xC4
		.byte 0x5C 
		.byte 0x90
		.byte 0x5E 
		.byte  0xC
		.byte 0x5E 
		.byte 0x7E 
		.byte 0x5F 
		.byte 0xCC
		.byte 0x63 
		.byte 0xEE
		.byte 0x67 
		.byte 0x3A 
		.byte 0x65 
		.byte 0xD7
		.byte 0x65 
		.byte 0xE2
		.byte 0x67 
		.byte 0x1F
		.byte 0x68 
		.byte 0xCB
		.byte 0x68 
		.byte 0xC4
		.byte 0x6A 
		.byte 0x5F 
		.byte 0x5E 
		.byte 0x30 
		.byte 0x6B 
		.byte 0xC5
		.byte 0x6C 
		.byte 0x17
		.byte 0x6C 
		.byte 0x7D 
		.byte 0x75 
		.byte 0x7F 
		.byte 0x79 
		.byte 0x48 
		.byte 0x5B 
		.byte 0x63 
		.byte 0x7A 
		.byte    0
		.byte 0x7D 
		.byte    0
		.byte 0x5F 
		.byte 0xBD
		.byte 0x89
		.byte 0x8F
		.byte 0x8A
		.byte 0x18
		.byte 0x8C
		.byte 0xB4
		.byte 0x8D
		.byte 0x77 
		.byte 0x8E
		.byte 0xCC
		.byte 0x8F
		.byte 0x1D
		.byte 0x98
		.byte 0xE2
		.byte 0x9A
		.byte  0xE
		.byte 0x9B
		.byte 0x3C 
		.byte 0x4E 
		.byte 0x80
		.byte 0x50 
		.byte 0x7D 
		.byte 0x51 
		.byte    0
		.byte 0x59 
		.byte 0x93
		.byte 0x5B 
		.byte 0x9C
		.byte 0x62 
		.byte 0x2F 
		.byte 0x62 
		.byte 0x80
		.byte 0x64 
		.byte 0xEC
		.byte 0x6B 
		.byte 0x3A 
		.byte 0x72 
		.byte 0xA0
		.byte 0x75 
		.byte 0x91
		.byte 0x79 
		.byte 0x47 
		.byte 0x7F 
		.byte 0xA9
		.byte 0x87
		.byte 0xFB
		.byte 0x8A
		.byte 0xBC
		.byte 0x8B
		.byte 0x70 
		.byte 0x63 
		.byte 0xAC
		.byte 0x83
		.byte 0xCA
		.byte 0x97
		.byte 0xA0
		.byte 0x54 
		.byte    9
		.byte 0x54 
		.byte    3
		.byte 0x55 
		.byte 0xAB
		.byte 0x68 
		.byte 0x54 
		.byte 0x6A 
		.byte 0x58 
		.byte 0x8A
		.byte 0x70 
		.byte 0x78 
		.byte 0x27 
		.byte 0x67 
		.byte 0x75 
		.byte 0x9E
		.byte 0xCD
		.byte 0x53 
		.byte 0x74 
		.byte 0x5B 
		.byte 0xA2
		.byte 0x81
		.byte 0x1A
		.byte 0x86
		.byte 0x50 
		.byte 0x90
		.byte    6
		.byte 0x4E 
		.byte 0x18
		.byte 0x4E 
		.byte 0x45 
		.byte 0x4E 
		.byte 0xC7
		.byte 0x4F 
		.byte 0x11
		.byte 0x53 
		.byte 0xCA
		.byte 0x54 
		.byte 0x38 
		.byte 0x5B 
		.byte 0xAE
		.byte 0x5F 
		.byte 0x13
		.byte 0x60 
		.byte 0x25 
		.byte 0x65 
		.byte 0x51 
		.byte    0
		.byte    0
		.byte 0x67 
		.byte 0x3D 
		.byte 0x6C 
		.byte 0x42 
		.byte 0x6C 
		.byte 0x72 
		.byte 0x6C 
		.byte 0xE3
		.byte 0x70 
		.byte 0x78 
		.byte 0x74 
		.byte    3
		.byte 0x7A 
		.byte 0x76 
		.byte 0x7A 
		.byte 0xAE
		.byte 0x7B 
		.byte    8
		.byte 0x7D 
		.byte 0x1A
		.byte 0x7C 
		.byte 0xFE
		.byte 0x7D 
		.byte 0x66 
		.byte 0x65 
		.byte 0xE7
		.byte 0x72 
		.byte 0x5B 
		.byte 0x53 
		.byte 0xBB
		.byte 0x5C 
		.byte 0x45 
		.byte 0x5D 
		.byte 0xE8
		.byte 0x62 
		.byte 0xD2
		.byte 0x62 
		.byte 0xE0
		.byte 0x63 
		.byte 0x19
		.byte 0x6E 
		.byte 0x20
		.byte 0x86
		.byte 0x5A 
		.byte 0x8A
		.byte 0x31 
		.byte 0x8D
		.byte 0xDD
		.byte 0x92
		.byte 0xF8
		.byte 0x6F 
		.byte    1
		.byte 0x79 
		.byte 0xA6
		.byte 0x9B
		.byte 0x5A 
		.byte 0x4E 
		.byte 0xA8
		.byte 0x4E 
		.byte 0xAB
		.byte 0x4E 
		.byte 0xAC
		.byte 0x4F 
		.byte 0x9B
		.byte 0x4F 
		.byte 0xA0
		.byte 0x50 
		.byte 0xD1
		.byte 0x51 
		.byte 0x47 
		.byte 0x7A 
		.byte 0xF6
		.byte 0x51 
		.byte 0x71 
		.byte 0x51 
		.byte 0xF6
		.byte 0x53 
		.byte 0x54 
		.byte 0x53 
		.byte 0x21 
		.byte 0x53 
		.byte 0x7F 
		.byte 0x53 
		.byte 0xEB
		.byte 0x55 
		.byte 0xAC
		.byte 0x58 
		.byte 0x83
		.byte 0x5C 
		.byte 0xE1
		.byte 0x5F 
		.byte 0x37 
		.byte 0x5F 
		.byte 0x4A 
		.byte 0x60 
		.byte 0x2F 
		.byte 0x60 
		.byte 0x50 
		.byte 0x60 
		.byte 0x6D 
		.byte 0x63 
		.byte 0x1F
		.byte 0x65 
		.byte 0x59 
		.byte 0x6A 
		.byte 0x4B 
		.byte 0x6C 
		.byte 0xC1
		.byte 0x72 
		.byte 0xC2
		.byte 0x72 
		.byte 0xED
		.byte 0x77 
		.byte 0xEF
		.byte 0x80
		.byte 0xF8
		.byte 0x81
		.byte    5
		.byte 0x82
		.byte    8
		.byte 0x85
		.byte 0x4E 
		.byte 0x90
		.byte 0xF7
		.byte 0x93
		.byte 0xE1
		.byte 0x97
		.byte 0xFF
		.byte 0x99
		.byte 0x57 
		.byte 0x9A
		.byte 0x5A 
		.byte 0x4E 
		.byte 0xF0
		.byte 0x51 
		.byte 0xDD
		.byte 0x5C 
		.byte 0x2D 
		.byte 0x66 
		.byte 0x81
		.byte 0x69 
		.byte 0x6D 
		.byte 0x5C 
		.byte 0x40 
		.byte 0x66 
		.byte 0xF2
		.byte 0x69 
		.byte 0x75 
		.byte 0x73 
		.byte 0x89
		.byte 0x68 
		.byte 0x50 
		.byte 0x7C 
		.byte 0x81
		.byte 0x50 
		.byte 0xC5
		.byte 0x52 
		.byte 0xE4
		.byte 0x57 
		.byte 0x47 
		.byte 0x5D 
		.byte 0xFE
		.byte 0x93
		.byte 0x26 
		.byte 0x65 
		.byte 0xA4
		.byte 0x6B 
		.byte 0x23 # 
		.byte 0x6B 
		.byte 0x3D 
		.byte 0x74 
		.byte 0x34 
		.byte 0x79 
		.byte 0x81
		.byte 0x79 
		.byte 0xBD
		.byte 0x7B 
		.byte 0x4B 
		.byte 0x7D 
		.byte 0xCA
		.byte 0x82
		.byte 0xB9
		.byte 0x83
		.byte 0xCC
		.byte 0x88
		.byte 0x7F 
		.byte 0x89
		.byte 0x5F 
		.byte 0x8B
		.byte 0x39 
		.byte 0x8F
		.byte 0xD1
		.byte 0x91
		.byte 0xD1
		.byte 0x54 
		.byte 0x1F
		.byte 0x92
		.byte 0x80
		.byte 0x4E 
		.byte 0x5D 
		.byte 0x50 
		.byte 0x36 
		.byte 0x53 
		.byte 0xE5
		.byte 0x53 
		.byte 0x3A 
		.byte 0x72 
		.byte 0xD7
		.byte 0x73 
		.byte 0x96
		.byte 0x77 
		.byte 0xE9
		.byte 0x82
		.byte 0xE6
		.byte 0x8E
		.byte 0xAF
		.byte 0x99
		.byte 0xC6
		.byte 0x99
		.byte 0xC8
		.byte 0x99
		.byte 0xD2
		.byte 0x51 
		.byte 0x77 
		.byte 0x61 
		.byte 0x1A
		.byte 0x86
		.byte 0x5E 
		.byte 0x55 
		.byte 0xB0
		.byte 0x7A 
		.byte 0x7A 
		.byte 0x50 
		.byte 0x76 
		.byte 0x5B 
		.byte 0xD3
		.byte 0x90
		.byte 0x47 
		.byte 0x96
		.byte 0x85
		.byte 0x4E 
		.byte 0x32 
		.byte 0x6A 
		.byte 0xDB
		.byte 0x91
		.byte 0xE7
		.byte 0x5C 
		.byte 0x51 
		.byte 0x5C 
		.byte 0x48 
		.byte 0x63 
		.byte 0x98
		.byte 0x7A 
		.byte 0x9F
		.byte 0x6C 
		.byte 0x93
		.byte 0x97
		.byte 0x74 
		.byte 0x8F
		.byte 0x61 
		.byte 0x7A 
		.byte 0xAA
		.byte 0x71 
		.byte 0x8A
		.byte 0x96
		.byte 0x88
		.byte 0x7C 
		.byte 0x82
		.byte 0x68 
		.byte 0x17
		.byte 0x7E 
		.byte 0x70 
		.byte 0x68 
		.byte 0x51 
		.byte 0x93
		.byte 0x6C 
		.byte 0x52 
		.byte 0xF2
		.byte 0x54 
		.byte 0x1B
		.byte 0x85
		.byte 0xAB
		.byte 0x8A
		.byte 0x13
		.byte 0x7F 
		.byte 0xA4
		.byte 0x8E
		.byte 0xCD
		.byte 0x90
		.byte 0xE1
		.byte 0x53 
		.byte 0x66 
		.byte 0x88
		.byte 0x88
		.byte 0x79 
		.byte 0x41 
		.byte 0x4F 
		.byte 0xC2
		.byte 0x50 
		.byte 0xBE
		.byte 0x52 
		.byte 0x11
		.byte 0x51 
		.byte 0x44 
		.byte 0x55 
		.byte 0x53 
		.byte 0x57 
		.byte 0x2D 
		.byte 0x73 
		.byte 0xEA
		.byte 0x57 
		.byte 0x8B
		.byte 0x59 
		.byte 0x51 
		.byte 0x5F 
		.byte 0x62 
		.byte 0x5F 
		.byte 0x84
		.byte 0x60 
		.byte 0x75 
		.byte 0x61 
		.byte 0x76 
		.byte 0x61 
		.byte 0x67 
		.byte 0x61 
		.byte 0xA9
		.byte 0x63 
		.byte 0xB2
		.byte 0x64 
		.byte 0x3A 
		.byte 0x65 
		.byte 0x6C 
		.byte 0x66 
		.byte 0x6F 
		.byte 0x68 
		.byte 0x42 
		.byte 0x6E 
		.byte 0x13
		.byte 0x75 
		.byte 0x66 
		.byte 0x7A 
		.byte 0x3D 
		.byte 0x7C 
		.byte 0xFB
		.byte 0x7D 
		.byte 0x4C 
		.byte 0x7D 
		.byte 0x99
		.byte 0x7E 
		.byte 0x4B 
		.byte 0x7F 
		.byte 0x6B 
		.byte 0x83
		.byte  0xE
		.byte 0x83
		.byte 0x4A 
		.byte 0x86
		.byte 0xCD
		.byte 0x8A
		.byte    8
		.byte 0x8A
		.byte 0x63 
		.byte 0x8B
		.byte 0x66 
		.byte 0x8E
		.byte 0xFD
		.byte 0x98
		.byte 0x1A
		.byte 0x9D
		.byte 0x8F
		.byte 0x82
		.byte 0xB8
		.byte 0x8F
		.byte 0xCE
		.byte 0x9B
		.byte 0xE8
		.byte    0
		.byte    0
		.byte 0x52 
		.byte 0x87
		.byte 0x62 
		.byte 0x1F
		.byte 0x64 
		.byte 0x83
		.byte 0x6F 
		.byte 0xC0
		.byte 0x96
		.byte 0x99
		.byte 0x68 
		.byte 0x41 
		.byte 0x50 
		.byte 0x91
		.byte 0x6B 
		.byte 0x20
		.byte 0x6C 
		.byte 0x7A 
		.byte 0x6F 
		.byte 0x54 
		.byte 0x7A 
		.byte 0x74 
		.byte 0x7D 
		.byte 0x50 
		.byte 0x88
		.byte 0x40 
		.byte 0x8A
		.byte 0x23 # 
		.byte 0x67 
		.byte    8
		.byte 0x4E 
		.byte 0xF6
		.byte 0x50 
		.byte 0x39 
		.byte 0x50 
		.byte 0x26 
		.byte 0x50 
		.byte 0x65 
		.byte 0x51 
		.byte 0x7C 
		.byte 0x52 
		.byte 0x38 
		.byte 0x52 
		.byte 0x63 
		.byte 0x55 
		.byte 0xA7
		.byte 0x57 
		.byte  0xF
		.byte 0x58 
		.byte    5
		.byte 0x5A 
		.byte 0xCC
		.byte 0x5E 
		.byte 0xFA
		.byte 0x61 
		.byte 0xB2
		.byte 0x61 
		.byte 0xF8
		.byte 0x62 
		.byte 0xF3
		.byte 0x63 
		.byte 0x72 
		.byte 0x69 
		.byte 0x1C
		.byte 0x6A 
		.byte 0x29 
		.byte 0x72 
		.byte 0x7D 
		.byte 0x72 
		.byte 0xAC
		.byte 0x73 
		.byte 0x2E 
		.byte 0x78 
		.byte 0x14
		.byte 0x78 
		.byte 0x6F 
		.byte 0x7D 
		.byte 0x79 
		.byte 0x77 
		.byte  0xC
		.byte 0x80
		.byte 0xA9
		.byte 0x89
		.byte 0x8B
		.byte 0x8B
		.byte 0x19
		.byte 0x8C
		.byte 0xE2
		.byte 0x8E
		.byte 0xD2
		.byte 0x90
		.byte 0x63 
		.byte 0x93
		.byte 0x75 
		.byte 0x96
		.byte 0x7A 
		.byte 0x98
		.byte 0x55 
		.byte 0x9A
		.byte 0x13
		.byte 0x9E
		.byte 0x78 
		.byte 0x51 
		.byte 0x43 
		.byte 0x53 
		.byte 0x9F
		.byte 0x53 
		.byte 0xB3
		.byte 0x5E 
		.byte 0x7B 
		.byte 0x5F 
		.byte 0x26 
		.byte 0x6E 
		.byte 0x1B
		.byte 0x6E 
		.byte 0x90
		.byte 0x73 
		.byte 0x84
		.byte 0x73 
		.byte 0xFE
		.byte 0x7D 
		.byte 0x43 
		.byte 0x82
		.byte 0x37 
		.byte 0x8A
		.byte    0
		.byte 0x8A
		.byte 0xFA
		.byte 0x96
		.byte 0x50 
		.byte 0x4E 
		.byte 0x4E 
		.byte 0x50 
		.byte  0xB
		.byte 0x53 
		.byte 0xE4
		.byte 0x54 
		.byte 0x7C 
		.byte 0x56 
		.byte 0xFA
		.byte 0x59 
		.byte 0xD1
		.byte 0x5B 
		.byte 0x64 
		.byte 0x5D 
		.byte 0xF1
		.byte 0x5E 
		.byte 0xAB
		.byte 0x5F 
		.byte 0x27 
		.byte 0x62 
		.byte 0x38 
		.byte 0x65 
		.byte 0x45 
		.byte 0x67 
		.byte 0xAF
		.byte 0x6E 
		.byte 0x56 
		.byte 0x72 
		.byte 0xD0
		.byte 0x7C 
		.byte 0xCA
		.byte 0x88
		.byte 0xB4
		.byte 0x80
		.byte 0xA1
		.byte 0x80
		.byte 0xE1
		.byte 0x83
		.byte 0xF0
		.byte 0x86
		.byte 0x4E 
		.byte 0x8A
		.byte 0x87
		.byte 0x8D
		.byte 0xE8
		.byte 0x92
		.byte 0x37 
		.byte 0x96
		.byte 0xC7
		.byte 0x98
		.byte 0x67 
		.byte 0x9F
		.byte 0x13
		.byte 0x4E 
		.byte 0x94
		.byte 0x4E 
		.byte 0x92
		.byte 0x4F 
		.byte  0xD
		.byte 0x53 
		.byte 0x48 
		.byte 0x54 
		.byte 0x49 
		.byte 0x54 
		.byte 0x3E 
		.byte 0x5A 
		.byte 0x2F 
		.byte 0x5F 
		.byte 0x8C
		.byte 0x5F 
		.byte 0xA1
		.byte 0x60 
		.byte 0x9F
		.byte 0x68 
		.byte 0xA7
		.byte 0x6A 
		.byte 0x8E
		.byte 0x74 
		.byte 0x5A 
		.byte 0x78 
		.byte 0x81
		.byte 0x8A
		.byte 0x9E
		.byte 0x8A
		.byte 0xA4
		.byte 0x8B
		.byte 0x77 
		.byte 0x91
		.byte 0x90
		.byte 0x4E 
		.byte 0x5E 
		.byte 0x9B
		.byte 0xC9
		.byte 0x4E 
		.byte 0xA4
		.byte 0x4F 
		.byte 0x7C 
		.byte 0x4F 
		.byte 0xAF
		.byte 0x50 
		.byte 0x19
		.byte 0x50 
		.byte 0x16
		.byte 0x51 
		.byte 0x49 
		.byte 0x51 
		.byte 0x6C 
		.byte 0x52 
		.byte 0x9F
		.byte 0x52 
		.byte 0xB9
		.byte 0x52 
		.byte 0xFE
		.byte 0x53 
		.byte 0x9A
		.byte 0x53 
		.byte 0xE3
		.byte 0x54 
		.byte 0x11
		.byte 0x54 
		.byte  0xE
		.byte 0x55 
		.byte 0x89
		.byte 0x57 
		.byte 0x51 
		.byte 0x57 
		.byte 0xA2
		.byte 0x59 
		.byte 0x7D 
		.byte 0x5B 
		.byte 0x54 
		.byte 0x5B 
		.byte 0x5D 
		.byte 0x5B 
		.byte 0x8F
		.byte 0x5D 
		.byte 0xE5
		.byte 0x5D 
		.byte 0xE7
		.byte 0x5D 
		.byte 0xF7
		.byte 0x5E 
		.byte 0x78 
		.byte 0x5E 
		.byte 0x83
		.byte 0x5E 
		.byte 0x9A
		.byte 0x5E 
		.byte 0xB7
		.byte 0x5F 
		.byte 0x18
		.byte 0x60 
		.byte 0x52 
		.byte 0x61 
		.byte 0x4C 
		.byte 0x62 
		.byte 0x97
		.byte 0x62 
		.byte 0xD8
		.byte 0x63 
		.byte 0xA7
		.byte 0x65 
		.byte 0x3B 
		.byte 0x66 
		.byte    2
		.byte 0x66 
		.byte 0x43 
		.byte 0x66 
		.byte 0xF4
		.byte 0x67 
		.byte 0x6D 
		.byte 0x68 
		.byte 0x21 
		.byte 0x68 
		.byte 0x97
		.byte 0x69 
		.byte 0xCB
		.byte 0x6C 
		.byte 0x5F 
		.byte 0x6D 
		.byte 0x2A 
		.byte 0x6D 
		.byte 0x69 
		.byte 0x6E 
		.byte 0x2F 
		.byte 0x6E 
		.byte 0x9D
		.byte 0x75 
		.byte 0x32 
		.byte 0x76 
		.byte 0x87
		.byte 0x78 
		.byte 0x6C 
		.byte 0x7A 
		.byte 0x3F 
		.byte 0x7C 
		.byte 0xE0
		.byte 0x7D 
		.byte    5
		.byte 0x7D 
		.byte 0x18
		.byte 0x7D 
		.byte 0x5E 
		.byte 0x7D 
		.byte 0xB1
		.byte 0x80
		.byte 0x15
		.byte 0x80
		.byte    3
		.byte 0x80
		.byte 0xAF
		.byte 0x80
		.byte 0xB1
		.byte 0x81
		.byte 0x54 
		.byte 0x81
		.byte 0x8F
		.byte 0x82
		.byte 0x2A 
		.byte 0x83
		.byte 0x52 
		.byte 0x88
		.byte 0x4C 
		.byte 0x88
		.byte 0x61 
		.byte 0x8B
		.byte 0x1B
		.byte 0x8C
		.byte 0xA2
		.byte 0x8C
		.byte 0xFC
		.byte 0x90
		.byte 0xCA
		.byte 0x91
		.byte 0x75 
		.byte 0x92
		.byte 0x71 
		.byte 0x78 
		.byte 0x3F 
		.byte 0x92
		.byte 0xFC
		.byte 0x95
		.byte 0xA4
		.byte 0x96
		.byte 0x4D 
		.byte    0
		.byte    0
		.byte 0x98
		.byte    5
		.byte 0x99
		.byte 0x99
		.byte 0x9A
		.byte 0xD8
		.byte 0x9D
		.byte 0x3B 
		.byte 0x52 
		.byte 0x5B 
		.byte 0x52 
		.byte 0xAB
		.byte 0x53 
		.byte 0xF7
		.byte 0x54 
		.byte    8
		.byte 0x58 
		.byte 0xD5
		.byte 0x62 
		.byte 0xF7
		.byte 0x6F 
		.byte 0xE0
		.byte 0x8C
		.byte 0x6A 
		.byte 0x8F
		.byte 0x5F 
		.byte 0x9E
		.byte 0xB9
		.byte 0x51 
		.byte 0x4B 
		.byte 0x52 
		.byte 0x3B 
		.byte 0x54 
		.byte 0x4A 
		.byte 0x56 
		.byte 0xFD
		.byte 0x7A 
		.byte 0x40 
		.byte 0x91
		.byte 0x77 
		.byte 0x9D
		.byte 0x60 
		.byte 0x9E
		.byte 0xD2
		.byte 0x73 
		.byte 0x44 
		.byte 0x6F 
		.byte    9
		.byte 0x81
		.byte 0x70 
		.byte 0x75 
		.byte 0x11
		.byte 0x5F 
		.byte 0xFD
		.byte 0x60 
		.byte 0xDA
		.byte 0x9A
		.byte 0xA8
		.byte 0x72 
		.byte 0xDB
		.byte 0x8F
		.byte 0xBC
		.byte 0x6B 
		.byte 0x64 
		.byte 0x98
		.byte    3
		.byte 0x4E 
		.byte 0xCA
		.byte 0x56 
		.byte 0xF0
		.byte 0x57 
		.byte 0x64 
		.byte 0x58 
		.byte 0xBE
		.byte 0x5A 
		.byte 0x5A 
		.byte 0x60 
		.byte 0x68 
		.byte 0x61 
		.byte 0xC7
		.byte 0x66 
		.byte  0xF
		.byte 0x66 
		.byte    6
		.byte 0x68 
		.byte 0x39 
		.byte 0x68 
		.byte 0xB1
		.byte 0x6D 
		.byte 0xF7
		.byte 0x75 
		.byte 0xD5
		.byte 0x7D 
		.byte 0x3A 
		.byte 0x82
		.byte 0x6E 
		.byte 0x9B
		.byte 0x42 
		.byte 0x4E 
		.byte 0x9B
		.byte 0x4F 
		.byte 0x50 
		.byte 0x53 
		.byte 0xC9
		.byte 0x55 
		.byte    6
		.byte 0x5D 
		.byte 0x6F 
		.byte 0x5D 
		.byte 0xE6
		.byte 0x5D 
		.byte 0xEE
		.byte 0x67 
		.byte 0xFB
		.byte 0x6C 
		.byte 0x99
		.byte 0x74 
		.byte 0x73 
		.byte 0x78 
		.byte    2
		.byte 0x8A
		.byte 0x50 
		.byte 0x93
		.byte 0x96
		.byte 0x88
		.byte 0xDF
		.byte 0x57 
		.byte 0x50 
		.byte 0x5E 
		.byte 0xA7
		.byte 0x63 
		.byte 0x2B 
		.byte 0x50 
		.byte 0xB5
		.byte 0x50 
		.byte 0xAC
		.byte 0x51 
		.byte 0x8D
		.byte 0x67 
		.byte    0
		.byte 0x54 
		.byte 0xC9
		.byte 0x58 
		.byte 0x5E 
		.byte 0x59 
		.byte 0xBB
		.byte 0x5B 
		.byte 0xB0
		.byte 0x5F 
		.byte 0x69 
		.byte 0x62 
		.byte 0x4D 
		.byte 0x63 
		.byte 0xA1
		.byte 0x68 
		.byte 0x3D 
		.byte 0x6B 
		.byte 0x73 
		.byte 0x6E 
		.byte    8
		.byte 0x70 
		.byte 0x7D 
		.byte 0x91
		.byte 0xC7
		.byte 0x72 
		.byte 0x80
		.byte 0x78 
		.byte 0x15
		.byte 0x78 
		.byte 0x26 
		.byte 0x79 
		.byte 0x6D 
		.byte 0x65 
		.byte 0x8E
		.byte 0x7D 
		.byte 0x30 
		.byte 0x83
		.byte 0xDC
		.byte 0x88
		.byte 0xC1
		.byte 0x8F
		.byte    9
		.byte 0x96
		.byte 0x9B
		.byte 0x52 
		.byte 0x64 
		.byte 0x57 
		.byte 0x28 
		.byte 0x67 
		.byte 0x50 
		.byte 0x7F 
		.byte 0x6A 
		.byte 0x8C
		.byte 0xA1
		.byte 0x51 
		.byte 0xB4
		.byte 0x57 
		.byte 0x42 
		.byte 0x96
		.byte 0x2A 
		.byte 0x58 
		.byte 0x3A 
		.byte 0x69 
		.byte 0x8A
		.byte 0x80
		.byte 0xB4
		.byte 0x54 
		.byte 0xB2
		.byte 0x5D 
		.byte  0xE
		.byte 0x57 
		.byte 0xFC
		.byte 0x78 
		.byte 0x95
		.byte 0x9D
		.byte 0xFA
		.byte 0x4F 
		.byte 0x5C 
		.byte 0x52 
		.byte 0x4A 
		.byte 0x54 
		.byte 0x8B
		.byte 0x64 
		.byte 0x3E 
		.byte 0x66 
		.byte 0x28 
		.byte 0x67 
		.byte 0x14
		.byte 0x67 
		.byte 0xF5
		.byte 0x7A 
		.byte 0x84
		.byte 0x7B 
		.byte 0x56 
		.byte 0x7D 
		.byte 0x22 
		.byte 0x93
		.byte 0x2F 
		.byte 0x68 
		.byte 0x5C 
		.byte 0x9B
		.byte 0xAD
		.byte 0x7B 
		.byte 0x39 
		.byte 0x53 
		.byte 0x19
		.byte 0x51 
		.byte 0x8A
		.byte 0x52 
		.byte 0x37 
		.byte 0x5B 
		.byte 0xDF
		.byte 0x62 
		.byte 0xF6
		.byte 0x64 
		.byte 0xAE
		.byte 0x64 
		.byte 0xE6
		.byte 0x67 
		.byte 0x2D 
		.byte 0x6B 
		.byte 0xBA
		.byte 0x85
		.byte 0xA9
		.byte 0x96
		.byte 0xD1
		.byte 0x76 
		.byte 0x90
		.byte 0x9B
		.byte 0xD6
		.byte 0x63 
		.byte 0x4C 
		.byte 0x93
		.byte    6
		.byte 0x9B
		.byte 0xAB
		.byte 0x76 
		.byte 0xBF
		.byte 0x66 
		.byte 0x52 
		.byte 0x4E 
		.byte    9
		.byte 0x50 
		.byte 0x98
		.byte 0x53 
		.byte 0xC2
		.byte 0x5C 
		.byte 0x71 
		.byte 0x60 
		.byte 0xE8
		.byte 0x64 
		.byte 0x92
		.byte 0x65 
		.byte 0x63 
		.byte 0x68 
		.byte 0x5F 
		.byte 0x71 
		.byte 0xE6
		.byte 0x73 
		.byte 0xCA
		.byte 0x75 
		.byte 0x23 # 
		.byte 0x7B 
		.byte 0x97
		.byte 0x7E 
		.byte 0x82
		.byte 0x86
		.byte 0x95
		.byte 0x8B
		.byte 0x83
		.byte 0x8C
		.byte 0xDB
		.byte 0x91
		.byte 0x78 
		.byte 0x99
		.byte 0x10
		.byte 0x65 
		.byte 0xAC
		.byte 0x66 
		.byte 0xAB
		.byte 0x6B 
		.byte 0x8B
		.byte 0x4E 
		.byte 0xD5
		.byte 0x4E 
		.byte 0xD4
		.byte 0x4F 
		.byte 0x3A 
		.byte 0x4F 
		.byte 0x7F 
		.byte 0x52 
		.byte 0x3A 
		.byte 0x53 
		.byte 0xF8
		.byte 0x53 
		.byte 0xF2
		.byte 0x55 
		.byte 0xE3
		.byte 0x56 
		.byte 0xDB
		.byte 0x58 
		.byte 0xEB
		.byte 0x59 
		.byte 0xCB
		.byte 0x59 
		.byte 0xC9
		.byte 0x59 
		.byte 0xFF
		.byte 0x5B 
		.byte 0x50 
		.byte 0x5C 
		.byte 0x4D 
		.byte 0x5E 
		.byte    2
		.byte 0x5E 
		.byte 0x2B 
		.byte 0x5F 
		.byte 0xD7
		.byte 0x60 
		.byte 0x1D
		.byte 0x63 
		.byte    7
		.byte 0x65 
		.byte 0x2F 
		.byte 0x5B 
		.byte 0x5C 
		.byte 0x65 
		.byte 0xAF
		.byte 0x65 
		.byte 0xBD
		.byte 0x65 
		.byte 0xE8
		.byte 0x67 
		.byte 0x9D
		.byte 0x6B 
		.byte 0x62 
		.byte    0
		.byte    0
		.byte 0x6B 
		.byte 0x7B 
		.byte 0x6C 
		.byte  0xF
		.byte 0x73 
		.byte 0x45 
		.byte 0x79 
		.byte 0x49 
		.byte 0x79 
		.byte 0xC1
		.byte 0x7C 
		.byte 0xF8
		.byte 0x7D 
		.byte 0x19
		.byte 0x7D 
		.byte 0x2B 
		.byte 0x80
		.byte 0xA2
		.byte 0x81
		.byte    2
		.byte 0x81
		.byte 0xF3
		.byte 0x89
		.byte 0x96
		.byte 0x8A
		.byte 0x5E 
		.byte 0x8A
		.byte 0x69 
		.byte 0x8A
		.byte 0x66 
		.byte 0x8A
		.byte 0x8C
		.byte 0x8A
		.byte 0xEE
		.byte 0x8C
		.byte 0xC7
		.byte 0x8C
		.byte 0xDC
		.byte 0x96
		.byte 0xCC
		.byte 0x98
		.byte 0xFC
		.byte 0x6B 
		.byte 0x6F 
		.byte 0x4E 
		.byte 0x8B
		.byte 0x4F 
		.byte 0x3C 
		.byte 0x4F 
		.byte 0x8D
		.byte 0x51 
		.byte 0x50 
		.byte 0x5B 
		.byte 0x57 
		.byte 0x5B 
		.byte 0xFA
		.byte 0x61 
		.byte 0x48 
		.byte 0x63 
		.byte    1
		.byte 0x66 
		.byte 0x42 
		.byte 0x6B 
		.byte 0x21 
		.byte 0x6E 
		.byte 0xCB
		.byte 0x6C 
		.byte 0xBB
		.byte 0x72 
		.byte 0x3E 
		.byte 0x74 
		.byte 0xBD
		.byte 0x75 
		.byte 0xD4
		.byte 0x78 
		.byte 0xC1
		.byte 0x79 
		.byte 0x3A 
		.byte 0x80
		.byte  0xC
		.byte 0x80
		.byte 0x33 
		.byte 0x81
		.byte 0xEA
		.byte 0x84
		.byte 0x94
		.byte 0x8F
		.byte 0x9E
		.byte 0x6C 
		.byte 0x50 
		.byte 0x9E
		.byte 0x7F 
		.byte 0x5F 
		.byte  0xF
		.byte 0x8B
		.byte 0x58 
		.byte 0x9D
		.byte 0x2B 
		.byte 0x7A 
		.byte 0xFA
		.byte 0x8E
		.byte 0xF8
		.byte 0x5B 
		.byte 0x8D
		.byte 0x96
		.byte 0xEB
		.byte 0x4E 
		.byte    3
		.byte 0x53 
		.byte 0xF1
		.byte 0x57 
		.byte 0xF7
		.byte 0x59 
		.byte 0x31 
		.byte 0x5A 
		.byte 0xC9
		.byte 0x5B 
		.byte 0xA4
		.byte 0x60 
		.byte 0x89
		.byte 0x6E 
		.byte 0x7F 
		.byte 0x6F 
		.byte    6
		.byte 0x75 
		.byte 0xBE
		.byte 0x8C
		.byte 0xEA
		.byte 0x5B 
		.byte 0x9F
		.byte 0x85
		.byte    0
		.byte 0x7B 
		.byte 0xE0
		.byte 0x50 
		.byte 0x72 
		.byte 0x67 
		.byte 0xF4
		.byte 0x82
		.byte 0x9D
		.byte 0x5C 
		.byte 0x61 
		.byte 0x85
		.byte 0x4A 
		.byte 0x7E 
		.byte 0x1E
		.byte 0x82
		.byte  0xE
		.byte 0x51 
		.byte 0x99
		.byte 0x5C 
		.byte    4
		.byte 0x63 
		.byte 0x68 
		.byte 0x8D
		.byte 0x66 
		.byte 0x65 
		.byte 0x9C
		.byte 0x71 
		.byte 0x6E 
		.byte 0x79 
		.byte 0x3E 
		.byte 0x7D 
		.byte 0x17
		.byte 0x80
		.byte    5
		.byte 0x8B
		.byte 0x1D
		.byte 0x8E
		.byte 0xCA
		.byte 0x90
		.byte 0x6E 
		.byte 0x86
		.byte 0xC7
		.byte 0x90
		.byte 0xAA
		.byte 0x50 
		.byte 0x1F
		.byte 0x52 
		.byte 0xFA
		.byte 0x5C 
		.byte 0x3A 
		.byte 0x67 
		.byte 0x53 
		.byte 0x70 
		.byte 0x7C 
		.byte 0x72 
		.byte 0x35 
		.byte 0x91
		.byte 0x4C 
		.byte 0x91
		.byte 0xC8
		.byte 0x93
		.byte 0x2B 
		.byte 0x82
		.byte 0xE5
		.byte 0x5B 
		.byte 0xC2
		.byte 0x5F 
		.byte 0x31 
		.byte 0x60 
		.byte 0xF9
		.byte 0x4E 
		.byte 0x3B 
		.byte 0x53 
		.byte 0xD6
		.byte 0x5B 
		.byte 0x88
		.byte 0x62 
		.byte 0x4B 
		.byte 0x67 
		.byte 0x31 
		.byte 0x6B 
		.byte 0x8A
		.byte 0x72 
		.byte 0xE9
		.byte 0x73 
		.byte 0xE0
		.byte 0x7A 
		.byte 0x2E 
		.byte 0x81
		.byte 0x6B 
		.byte 0x8D
		.byte 0xA3
		.byte 0x91
		.byte 0x52 
		.byte 0x99
		.byte 0x96
		.byte 0x51 
		.byte 0x12
		.byte 0x53 
		.byte 0xD7
		.byte 0x54 
		.byte 0x6A 
		.byte 0x5B 
		.byte 0xFF
		.byte 0x63 
		.byte 0x88
		.byte 0x6A 
		.byte 0x39 
		.byte 0x7D 
		.byte 0xAC
		.byte 0x97
		.byte    0
		.byte 0x56 
		.byte 0xDA
		.byte 0x53 
		.byte 0xCE
		.byte 0x54 
		.byte 0x68 
		.byte 0x5B 
		.byte 0x97
		.byte 0x5C 
		.byte 0x31 
		.byte 0x5D 
		.byte 0xDE
		.byte 0x4F 
		.byte 0xEE
		.byte 0x61 
		.byte    1
		.byte 0x62 
		.byte 0xFE
		.byte 0x6D 
		.byte 0x32 
		.byte 0x79 
		.byte 0xC0
		.byte 0x79 
		.byte 0xCB
		.byte 0x7D 
		.byte 0x42 
		.byte 0x7E 
		.byte 0x4D 
		.byte 0x7F 
		.byte 0xD2
		.byte 0x81
		.byte 0xED
		.byte 0x82
		.byte 0x1F
		.byte 0x84
		.byte 0x90
		.byte 0x88
		.byte 0x46 
		.byte 0x89
		.byte 0x72 
		.byte 0x8B
		.byte 0x90
		.byte 0x8E
		.byte 0x74 
		.byte 0x8F
		.byte 0x2F 
		.byte 0x90
		.byte 0x31 
		.byte 0x91
		.byte 0x4B 
		.byte 0x91
		.byte 0x6C 
		.byte 0x96
		.byte 0xC6
		.byte 0x91
		.byte 0x9C
		.byte 0x4E 
		.byte 0xC0
		.byte 0x4F 
		.byte 0x4F 
		.byte 0x51 
		.byte 0x45 
		.byte 0x53 
		.byte 0x41 
		.byte 0x5F 
		.byte 0x93
		.byte 0x62 
		.byte  0xE
		.byte 0x67 
		.byte 0xD4
		.byte 0x6C 
		.byte 0x41 
		.byte 0x6E 
		.byte  0xB
		.byte 0x73 
		.byte 0x63 
		.byte 0x7E 
		.byte 0x26 
		.byte 0x91
		.byte 0xCD
		.byte 0x92
		.byte 0x83
		.byte 0x53 
		.byte 0xD4
		.byte 0x59 
		.byte 0x19
		.byte 0x5B 
		.byte 0xBF
		.byte 0x6D 
		.byte 0xD1
		.byte 0x79 
		.byte 0x5D 
		.byte 0x7E 
		.byte 0x2E 
		.byte 0x7C 
		.byte 0x9B
		.byte 0x58 
		.byte 0x7E 
		.byte 0x71 
		.byte 0x9F
		.byte 0x51 
		.byte 0xFA
		.byte 0x88
		.byte 0x53 
		.byte 0x8F
		.byte 0xF0
		.byte 0x4F 
		.byte 0xCA
		.byte 0x5C 
		.byte 0xFB
		.byte 0x66 
		.byte 0x25 
		.byte 0x77 
		.byte 0xAC
		.byte 0x7A 
		.byte 0xE3
		.byte 0x82
		.byte 0x1C
		.byte 0x99
		.byte 0xFF
		.byte 0x51 
		.byte 0xC6
		.byte 0x5F 
		.byte 0xAA
		.byte 0x65 
		.byte 0xEC
		.byte 0x69 
		.byte 0x6F 
		.byte 0x6B 
		.byte 0x89
		.byte 0x6D 
		.byte 0xF3
		.byte    0
		.byte    0
		.byte 0x6E 
		.byte 0x96
		.byte 0x6F 
		.byte 0x64 
		.byte 0x76 
		.byte 0xFE
		.byte 0x7D 
		.byte 0x14
		.byte 0x5D 
		.byte 0xE1
		.byte 0x90
		.byte 0x75 
		.byte 0x91
		.byte 0x87
		.byte 0x98
		.byte    6
		.byte 0x51 
		.byte 0xE6
		.byte 0x52 
		.byte 0x1D
		.byte 0x62 
		.byte 0x40 
		.byte 0x66 
		.byte 0x91
		.byte 0x66 
		.byte 0xD9
		.byte 0x6E 
		.byte 0x1A
		.byte 0x5E 
		.byte 0xB6
		.byte 0x7D 
		.byte 0xD2
		.byte 0x7F 
		.byte 0x72 
		.byte 0x66 
		.byte 0xF8
		.byte 0x85
		.byte 0xAF
		.byte 0x85
		.byte 0xF7
		.byte 0x8A
		.byte 0xF8
		.byte 0x52 
		.byte 0xA9
		.byte 0x53 
		.byte 0xD9
		.byte 0x59 
		.byte 0x73 
		.byte 0x5E 
		.byte 0x8F
		.byte 0x5F 
		.byte 0x90
		.byte 0x60 
		.byte 0x55 
		.byte 0x92
		.byte 0xE4
		.byte 0x96
		.byte 0x64 
		.byte 0x50 
		.byte 0xB7
		.byte 0x51 
		.byte 0x1F
		.byte 0x52 
		.byte 0xDD
		.byte 0x53 
		.byte 0x20
		.byte 0x53 
		.byte 0x47 
		.byte 0x53 
		.byte 0xEC
		.byte 0x54 
		.byte 0xE8
		.byte 0x55 
		.byte 0x46 
		.byte 0x55 
		.byte 0x31 
		.byte 0x56 
		.byte 0x17
		.byte 0x59 
		.byte 0x68 
		.byte 0x59 
		.byte 0xBE
		.byte 0x5A 
		.byte 0x3C 
		.byte 0x5B 
		.byte 0xB5
		.byte 0x5C 
		.byte    6
		.byte 0x5C 
		.byte  0xF
		.byte 0x5C 
		.byte 0x11
		.byte 0x5C 
		.byte 0x1A
		.byte 0x5E 
		.byte 0x84
		.byte 0x5E 
		.byte 0x8A
		.byte 0x5E 
		.byte 0xE0
		.byte 0x5F 
		.byte 0x70 
		.byte 0x62 
		.byte 0x7F 
		.byte 0x62 
		.byte 0x84
		.byte 0x62 
		.byte 0xDB
		.byte 0x63 
		.byte 0x8C
		.byte 0x63 
		.byte 0x77 
		.byte 0x66 
		.byte    7
		.byte 0x66 
		.byte  0xC
		.byte 0x66 
		.byte 0x2D 
		.byte 0x66 
		.byte 0x76 
		.byte 0x67 
		.byte 0x7E 
		.byte 0x68 
		.byte 0xA2
		.byte 0x6A 
		.byte 0x1F
		.byte 0x6A 
		.byte 0x35 
		.byte 0x6C 
		.byte 0xBC
		.byte 0x6D 
		.byte 0x88
		.byte 0x6E 
		.byte    9
		.byte 0x6E 
		.byte 0x58 
		.byte 0x71 
		.byte 0x3C 
		.byte 0x71 
		.byte 0x26 
		.byte 0x71 
		.byte 0x67 
		.byte 0x75 
		.byte 0xC7
		.byte 0x77 
		.byte    1
		.byte 0x78 
		.byte 0x5D 
		.byte 0x79 
		.byte    1
		.byte 0x79 
		.byte 0x65 
		.byte 0x79 
		.byte 0xF0
		.byte 0x7A 
		.byte 0xE0
		.byte 0x7B 
		.byte 0x11
		.byte 0x7C 
		.byte 0xA7
		.byte 0x7D 
		.byte 0x39 
		.byte 0x80
		.byte 0x96
		.byte 0x83
		.byte 0xD6
		.byte 0x84
		.byte 0x8B
		.byte 0x85
		.byte 0x49 
		.byte 0x88
		.byte 0x5D 
		.byte 0x88
		.byte 0xF3
		.byte 0x8A
		.byte 0x1F
		.byte 0x8A
		.byte 0x3C 
		.byte 0x8A
		.byte 0x54 
		.byte 0x8A
		.byte 0x73 
		.byte 0x8C
		.byte 0x61 
		.byte 0x8C
		.byte 0xDE
		.byte 0x91
		.byte 0xA4
		.byte 0x92
		.byte 0x66 
		.byte 0x93
		.byte 0x7E 
		.byte 0x94
		.byte 0x18
		.byte 0x96
		.byte 0x9C
		.byte 0x97
		.byte 0x98
		.byte 0x4E 
		.byte  0xA
		.byte 0x4E 
		.byte    8
		.byte 0x4E 
		.byte 0x1E
		.byte 0x4E 
		.byte 0x57 
		.byte 0x51 
		.byte 0x97
		.byte 0x52 
		.byte 0x70 
		.byte 0x57 
		.byte 0xCE
		.byte 0x58 
		.byte 0x34 
		.byte 0x58 
		.byte 0xCC
		.byte 0x5B 
		.byte 0x22 
		.byte 0x5E 
		.byte 0x38 
		.byte 0x60 
		.byte 0xC5
		.byte 0x64 
		.byte 0xFE
		.byte 0x67 
		.byte 0x61 
		.byte 0x67 
		.byte 0x56 
		.byte 0x6D 
		.byte 0x44 
		.byte 0x72 
		.byte 0xB6
		.byte 0x75 
		.byte 0x73 
		.byte 0x7A 
		.byte 0x63 
		.byte 0x84
		.byte 0xB8
		.byte 0x8B
		.byte 0x72 
		.byte 0x91
		.byte 0xB8
		.byte 0x93
		.byte 0x20
		.byte 0x56 
		.byte 0x31 
		.byte 0x57 
		.byte 0xF4
		.byte 0x98
		.byte 0xFE
		.byte 0x62 
		.byte 0xED
		.byte 0x69 
		.byte  0xD
		.byte 0x6B 
		.byte 0x96
		.byte 0x71 
		.byte 0xED
		.byte 0x7E 
		.byte 0x54 
		.byte 0x80
		.byte 0x77 
		.byte 0x82
		.byte 0x72 
		.byte 0x89
		.byte 0xE6
		.byte 0x98
		.byte 0xDF
		.byte 0x87
		.byte 0x55 
		.byte 0x8F
		.byte 0xB1
		.byte 0x5C 
		.byte 0x3B 
		.byte 0x4F 
		.byte 0x38 
		.byte 0x4F 
		.byte 0xE1
		.byte 0x4F 
		.byte 0xB5
		.byte 0x55 
		.byte    7
		.byte 0x5A 
		.byte 0x20
		.byte 0x5B 
		.byte 0xDD
		.byte 0x5B 
		.byte 0xE9
		.byte 0x5F 
		.byte 0xC3
		.byte 0x61 
		.byte 0x4E 
		.byte 0x63 
		.byte 0x2F 
		.byte 0x65 
		.byte 0xB0
		.byte 0x66 
		.byte 0x4B 
		.byte 0x68 
		.byte 0xEE
		.byte 0x69 
		.byte 0x9B
		.byte 0x6D 
		.byte 0x78 
		.byte 0x6D 
		.byte 0xF1
		.byte 0x75 
		.byte 0x33 
		.byte 0x75 
		.byte 0xB9
		.byte 0x77 
		.byte 0x1F
		.byte 0x79 
		.byte 0x5E 
		.byte 0x79 
		.byte 0xE6
		.byte 0x7D 
		.byte 0x33 
		.byte 0x81
		.byte 0xE3
		.byte 0x82
		.byte 0xAF
		.byte 0x85
		.byte 0xAA
		.byte 0x89
		.byte 0xAA
		.byte 0x8A
		.byte 0x3A 
		.byte 0x8E
		.byte 0xAB
		.byte 0x8F
		.byte 0x9B
		.byte 0x90
		.byte 0x32 
		.byte 0x91
		.byte 0xDD
		.byte 0x97
		.byte    7
		.byte 0x4E 
		.byte 0xBA
		.byte 0x4E 
		.byte 0xC1
		.byte 0x52 
		.byte    3
		.byte 0x58 
		.byte 0x75 
		.byte 0x58 
		.byte 0xEC
		.byte 0x5C 
		.byte  0xB
		.byte 0x75 
		.byte 0x1A
		.byte 0x5C 
		.byte 0x3D 
		.byte 0x81
		.byte 0x4E 
		.byte 0x8A
		.byte  0xA
		.byte 0x8F
		.byte 0xC5
		.byte 0x96
		.byte 0x63 
		.byte 0x97
		.byte 0x6D 
		.byte 0x7B 
		.byte 0x25 
		.byte 0x8A
		.byte 0xCF
		.byte 0x98
		.byte    8
		.byte 0x91
		.byte 0x62 
		.byte 0x56 
		.byte 0xF3
		.byte 0x53 
		.byte 0xA8
		.byte    0
		.byte    0
		.byte 0x90
		.byte 0x17
		.byte 0x54 
		.byte 0x39 
		.byte 0x57 
		.byte 0x82
		.byte 0x5E 
		.byte 0x25 
		.byte 0x63 
		.byte 0xA8
		.byte 0x6C 
		.byte 0x34 
		.byte 0x70 
		.byte 0x8A
		.byte 0x77 
		.byte 0x61 
		.byte 0x7C 
		.byte 0x8B
		.byte 0x7F 
		.byte 0xE0
		.byte 0x88
		.byte 0x70 
		.byte 0x90
		.byte 0x42 
		.byte 0x91
		.byte 0x54 
		.byte 0x93
		.byte 0x10
		.byte 0x93
		.byte 0x18
		.byte 0x96
		.byte 0x8F
		.byte 0x74 
		.byte 0x5E 
		.byte 0x9A
		.byte 0xC4
		.byte 0x5D 
		.byte    7
		.byte 0x5D 
		.byte 0x69 
		.byte 0x65 
		.byte 0x70 
		.byte 0x67 
		.byte 0xA2
		.byte 0x8D
		.byte 0xA8
		.byte 0x96
		.byte 0xDB
		.byte 0x63 
		.byte 0x6E 
		.byte 0x67 
		.byte 0x49 
		.byte 0x69 
		.byte 0x19
		.byte 0x83
		.byte 0xC5
		.byte 0x98
		.byte 0x17
		.byte 0x96
		.byte 0xC0
		.byte 0x88
		.byte 0xFE
		.byte 0x6F 
		.byte 0x84
		.byte 0x64 
		.byte 0x7A 
		.byte 0x5B 
		.byte 0xF8
		.byte 0x4E 
		.byte 0x16
		.byte 0x70 
		.byte 0x2C 
		.byte 0x75 
		.byte 0x5D 
		.byte 0x66 
		.byte 0x2F 
		.byte 0x51 
		.byte 0xC4
		.byte 0x52 
		.byte 0x36 
		.byte 0x52 
		.byte 0xE2
		.byte 0x59 
		.byte 0xD3
		.byte 0x5F 
		.byte 0x81
		.byte 0x60 
		.byte 0x27 
		.byte 0x62 
		.byte 0x10
		.byte 0x65 
		.byte 0x3F 
		.byte 0x65 
		.byte 0x74 
		.byte 0x66 
		.byte 0x1F
		.byte 0x66 
		.byte 0x74 
		.byte 0x68 
		.byte 0xF2
		.byte 0x68 
		.byte 0x16
		.byte 0x6B 
		.byte 0x63 
		.byte 0x6E 
		.byte    5
		.byte 0x72 
		.byte 0x72 
		.byte 0x75 
		.byte 0x1F
		.byte 0x76 
		.byte 0xDB
		.byte 0x7C 
		.byte 0xBE
		.byte 0x80
		.byte 0x56 
		.byte 0x58 
		.byte 0xF0
		.byte 0x88
		.byte 0xFD
		.byte 0x89
		.byte 0x7F 
		.byte 0x8A
		.byte 0xA0
		.byte 0x8A
		.byte 0x93
		.byte 0x8A
		.byte 0xCB
		.byte 0x90
		.byte 0x1D
		.byte 0x91
		.byte 0x92
		.byte 0x97
		.byte 0x52 
		.byte 0x97
		.byte 0x59 
		.byte 0x65 
		.byte 0x89
		.byte 0x7A 
		.byte  0xE
		.byte 0x81
		.byte    6
		.byte 0x96
		.byte 0xBB
		.byte 0x5E 
		.byte 0x2D 
		.byte 0x60 
		.byte 0xDC
		.byte 0x62 
		.byte 0x1A
		.byte 0x65 
		.byte 0xA5
		.byte 0x66 
		.byte 0x14
		.byte 0x67 
		.byte 0x90
		.byte 0x77 
		.byte 0xF3
		.byte 0x7A 
		.byte 0x4D 
		.byte 0x7C 
		.byte 0x4D 
		.byte 0x7E 
		.byte 0x3E 
		.byte 0x81
		.byte  0xA
		.byte 0x8C
		.byte 0xAC
		.byte 0x8D
		.byte 0x64 
		.byte 0x8D
		.byte 0xE1
		.byte 0x8E
		.byte 0x5F 
		.byte 0x78 
		.byte 0xA9
		.byte 0x52 
		.byte    7
		.byte 0x62 
		.byte 0xD9
		.byte 0x63 
		.byte 0xA5
		.byte 0x64 
		.byte 0x42 
		.byte 0x62 
		.byte 0x98
		.byte 0x8A
		.byte 0x2D 
		.byte 0x7A 
		.byte 0x83
		.byte 0x7B 
		.byte 0xC0
		.byte 0x8A
		.byte 0xAC
		.byte 0x96
		.byte 0xEA
		.byte 0x7D 
		.byte 0x76 
		.byte 0x82
		.byte  0xC
		.byte 0x87
		.byte 0x49 
		.byte 0x4E 
		.byte 0xD9
		.byte 0x51 
		.byte 0x48 
		.byte 0x53 
		.byte 0x43 
		.byte 0x53 
		.byte 0x60 
		.byte 0x5B 
		.byte 0xA3
		.byte 0x5C 
		.byte    2
		.byte 0x5C 
		.byte 0x16
		.byte 0x5D 
		.byte 0xDD
		.byte 0x62 
		.byte 0x26 
		.byte 0x62 
		.byte 0x47 
		.byte 0x64 
		.byte 0xB0
		.byte 0x68 
		.byte 0x13
		.byte 0x68 
		.byte 0x34 
		.byte 0x6C 
		.byte 0xC9
		.byte 0x6D 
		.byte 0x45 
		.byte 0x6D 
		.byte 0x17
		.byte 0x67 
		.byte 0xD3
		.byte 0x6F 
		.byte 0x5C 
		.byte 0x71 
		.byte 0x4E 
		.byte 0x71 
		.byte 0x7D 
		.byte 0x65 
		.byte 0xCB
		.byte 0x7A 
		.byte 0x7F 
		.byte 0x7B 
		.byte 0xAD
		.byte 0x7D 
		.byte 0xDA
		.byte 0x7E 
		.byte 0x4A 
		.byte 0x7F 
		.byte 0xA8
		.byte 0x81
		.byte 0x7A 
		.byte 0x82
		.byte 0x1B
		.byte 0x82
		.byte 0x39 
		.byte 0x85
		.byte 0xA6
		.byte 0x8A
		.byte 0x6E 
		.byte 0x8C
		.byte 0xCE
		.byte 0x8D
		.byte 0xF5
		.byte 0x90
		.byte 0x78 
		.byte 0x90
		.byte 0x77 
		.byte 0x92
		.byte 0xAD
		.byte 0x92
		.byte 0x91
		.byte 0x95
		.byte 0x83
		.byte 0x9B
		.byte 0xAE
		.byte 0x52 
		.byte 0x4D 
		.byte 0x55 
		.byte 0x84
		.byte 0x6F 
		.byte 0x38 
		.byte 0x71 
		.byte 0x36 
		.byte 0x51 
		.byte 0x68 
		.byte 0x79 
		.byte 0x85
		.byte 0x7E 
		.byte 0x55 
		.byte 0x81
		.byte 0xB3
		.byte 0x7C 
		.byte 0xCE
		.byte 0x56 
		.byte 0x4C 
		.byte 0x58 
		.byte 0x51 
		.byte 0x5C 
		.byte 0xA8
		.byte 0x63 
		.byte 0xAA
		.byte 0x66 
		.byte 0xFE
		.byte 0x66 
		.byte 0xFD
		.byte 0x69 
		.byte 0x5A 
		.byte 0x72 
		.byte 0xD9
		.byte 0x75 
		.byte 0x8F
		.byte 0x75 
		.byte 0x8E
		.byte 0x79 
		.byte  0xE
		.byte 0x79 
		.byte 0x56 
		.byte 0x79 
		.byte 0xDF
		.byte 0x7C 
		.byte 0x97
		.byte 0x7D 
		.byte 0x20
		.byte 0x7D 
		.byte 0x44 
		.byte 0x86
		.byte    7
		.byte 0x8A
		.byte 0x34 
		.byte 0x96
		.byte 0x3B 
		.byte 0x90
		.byte 0x61 
		.byte 0x9F
		.byte 0x20
		.byte 0x50 
		.byte 0xE7
		.byte 0x52 
		.byte 0x75 
		.byte 0x53 
		.byte 0xCC
		.byte 0x53 
		.byte 0xE2
		.byte 0x50 
		.byte    9
		.byte 0x55 
		.byte 0xAA
		.byte 0x58 
		.byte 0xEE
		.byte 0x59 
		.byte 0x4F 
		.byte 0x72 
		.byte 0x3D 
		.byte 0x5B 
		.byte 0x8B
		.byte 0x5C 
		.byte 0x64 
		.byte 0x53 
		.byte 0x1D
		.byte 0x60 
		.byte 0xE3
		.byte 0x60 
		.byte 0xF3
		.byte 0x63 
		.byte 0x5C 
		.byte 0x63 
		.byte 0x83
		.byte 0x63 
		.byte 0x3F 
		.byte 0x63 
		.byte 0xBB
		.byte    0
		.byte    0
		.byte 0x64 
		.byte 0xCD
		.byte 0x65 
		.byte 0xE9
		.byte 0x66 
		.byte 0xF9
		.byte 0x5D 
		.byte 0xE3
		.byte 0x69 
		.byte 0xCD
		.byte 0x69 
		.byte 0xFD
		.byte 0x6F 
		.byte 0x15
		.byte 0x71 
		.byte 0xE5
		.byte 0x4E 
		.byte 0x89
		.byte 0x75 
		.byte 0xE9
		.byte 0x76 
		.byte 0xF8
		.byte 0x7A 
		.byte 0x93
		.byte 0x7C 
		.byte 0xDF
		.byte 0x7D 
		.byte 0xCF
		.byte 0x7D 
		.byte 0x9C
		.byte 0x80
		.byte 0x61 
		.byte 0x83
		.byte 0x49 
		.byte 0x83
		.byte 0x58 
		.byte 0x84
		.byte 0x6C 
		.byte 0x84
		.byte 0xBC
		.byte 0x85
		.byte 0xFB
		.byte 0x88
		.byte 0xC5
		.byte 0x8D
		.byte 0x70 
		.byte 0x90
		.byte    1
		.byte 0x90
		.byte 0x6D 
		.byte 0x93
		.byte 0x97
		.byte 0x97
		.byte 0x1C
		.byte 0x9A
		.byte 0x12
		.byte 0x50 
		.byte 0xCF
		.byte 0x58 
		.byte 0x97
		.byte 0x61 
		.byte 0x8E
		.byte 0x81
		.byte 0xD3
		.byte 0x85
		.byte 0x35 
		.byte 0x8D
		.byte    8
		.byte 0x90
		.byte 0x20
		.byte 0x4F 
		.byte 0xC3
		.byte 0x50 
		.byte 0x74 
		.byte 0x52 
		.byte 0x47 
		.byte 0x53 
		.byte 0x73 
		.byte 0x60 
		.byte 0x6F 
		.byte 0x63 
		.byte 0x49 
		.byte 0x67 
		.byte 0x5F 
		.byte 0x6E 
		.byte 0x2C 
		.byte 0x8D
		.byte 0xB3
		.byte 0x90
		.byte 0x1F
		.byte 0x4F 
		.byte 0xD7
		.byte 0x5C 
		.byte 0x5E 
		.byte 0x8C
		.byte 0xCA
		.byte 0x65 
		.byte 0xCF
		.byte 0x7D 
		.byte 0x9A
		.byte 0x53 
		.byte 0x52 
		.byte 0x88
		.byte 0x96
		.byte 0x51 
		.byte 0x76 
		.byte 0x63 
		.byte 0xC3
		.byte 0x5B 
		.byte 0x58 
		.byte 0x5B 
		.byte 0x6B 
		.byte 0x5C 
		.byte  0xA
		.byte 0x64 
		.byte  0xD
		.byte 0x67 
		.byte 0x51 
		.byte 0x90
		.byte 0x5C 
		.byte 0x4E 
		.byte 0xD6
		.byte 0x59 
		.byte 0x1A
		.byte 0x59 
		.byte 0x2A 
		.byte 0x6C 
		.byte 0x70 
		.byte 0x8A
		.byte 0x51 
		.byte 0x55 
		.byte 0x3E 
		.byte 0x58 
		.byte 0x15
		.byte 0x59 
		.byte 0xA5
		.byte 0x60 
		.byte 0xF0
		.byte 0x62 
		.byte 0x53 
		.byte 0x67 
		.byte 0xC1
		.byte 0x82
		.byte 0x35 
		.byte 0x69 
		.byte 0x55 
		.byte 0x96
		.byte 0x40 
		.byte 0x99
		.byte 0xC4
		.byte 0x9A
		.byte 0x28 
		.byte 0x4F 
		.byte 0x53 
		.byte 0x58 
		.byte    6
		.byte 0x5B 
		.byte 0xFE
		.byte 0x80
		.byte 0x10
		.byte 0x5C 
		.byte 0xB1
		.byte 0x5E 
		.byte 0x2F 
		.byte 0x5F 
		.byte 0x85
		.byte 0x60 
		.byte 0x20
		.byte 0x61 
		.byte 0x4B 
		.byte 0x62 
		.byte 0x34 
		.byte 0x66 
		.byte 0xFF
		.byte 0x6C 
		.byte 0xF0
		.byte 0x6E 
		.byte 0xDE
		.byte 0x80
		.byte 0xCE
		.byte 0x81
		.byte 0x7F 
		.byte 0x82
		.byte 0xD4
		.byte 0x88
		.byte 0x8B
		.byte 0x8C
		.byte 0xB8
		.byte 0x90
		.byte    0
		.byte 0x90
		.byte 0x2E 
		.byte 0x96
		.byte 0x8A
		.byte 0x9E
		.byte 0xDB
		.byte 0x9B
		.byte 0xDB
		.byte 0x4E 
		.byte 0xE3
		.byte 0x53 
		.byte 0xF0
		.byte 0x59 
		.byte 0x27 
		.byte 0x7B 
		.byte 0x2C 
		.byte 0x91
		.byte 0x8D
		.byte 0x98
		.byte 0x4C 
		.byte 0x9D
		.byte 0xF9
		.byte 0x6E 
		.byte 0xDD
		.byte 0x70 
		.byte 0x27 
		.byte 0x53 
		.byte 0x53 
		.byte 0x55 
		.byte 0x44 
		.byte 0x5B 
		.byte 0x85
		.byte 0x62 
		.byte 0x58 
		.byte 0x62 
		.byte 0x9E
		.byte 0x62 
		.byte 0xD3
		.byte 0x6C 
		.byte 0xA2
		.byte 0x6F 
		.byte 0xEF
		.byte 0x74 
		.byte 0x22 
		.byte 0x8A
		.byte 0x17
		.byte 0x94
		.byte 0x38 
		.byte 0x6F 
		.byte 0xC1
		.byte 0x8A
		.byte 0xFE
		.byte 0x83
		.byte 0x38 
		.byte 0x51 
		.byte 0xE7
		.byte 0x86
		.byte 0xF8
		.byte 0x53 
		.byte 0xEA
		.byte 0x53 
		.byte 0xE9
		.byte 0x4F 
		.byte 0x46 
		.byte 0x90
		.byte 0x54 
		.byte 0x8F
		.byte 0xB0
		.byte 0x59 
		.byte 0x6A 
		.byte 0x81
		.byte 0x31 
		.byte 0x5D 
		.byte 0xFD
		.byte 0x7A 
		.byte 0xEA
		.byte 0x8F
		.byte 0xBF
		.byte 0x68 
		.byte 0xDA
		.byte 0x8C
		.byte 0x37 
		.byte 0x72 
		.byte 0xF8
		.byte 0x9C
		.byte 0x48 
		.byte 0x6A 
		.byte 0x3D 
		.byte 0x8A
		.byte 0xB0
		.byte 0x4E 
		.byte 0x39 
		.byte 0x53 
		.byte 0x58 
		.byte 0x56 
		.byte    6
		.byte 0x57 
		.byte 0x66 
		.byte 0x62 
		.byte 0xC5
		.byte 0x63 
		.byte 0xA2
		.byte 0x65 
		.byte 0xE6
		.byte 0x6B 
		.byte 0x4E 
		.byte 0x6D 
		.byte 0xE1
		.byte 0x6E 
		.byte 0x5B 
		.byte 0x70 
		.byte 0xAD
		.byte 0x77 
		.byte 0xED
		.byte 0x7A 
		.byte 0xEF
		.byte 0x7B 
		.byte 0xAA
		.byte 0x7D 
		.byte 0xBB
		.byte 0x80
		.byte 0x3D 
		.byte 0x80
		.byte 0xC6
		.byte 0x86
		.byte 0xCB
		.byte 0x8A
		.byte 0x95
		.byte 0x93
		.byte 0x5B 
		.byte 0x56 
		.byte 0xE3
		.byte 0x58 
		.byte 0xC7
		.byte 0x5F 
		.byte 0x3E 
		.byte 0x65 
		.byte 0xAD
		.byte 0x66 
		.byte 0x96
		.byte 0x6A 
		.byte 0x80
		.byte 0x6B 
		.byte 0xB5
		.byte 0x75 
		.byte 0x37 
		.byte 0x8A
		.byte 0xC7
		.byte 0x50 
		.byte 0x24 
		.byte 0x77 
		.byte 0xE5
		.byte 0x57 
		.byte 0x30 
		.byte 0x5F 
		.byte 0x1B
		.byte 0x60 
		.byte 0x65 
		.byte 0x66 
		.byte 0x7A 
		.byte 0x6C 
		.byte 0x60 
		.byte 0x75 
		.byte 0xF4
		.byte 0x7A 
		.byte 0x1A
		.byte 0x7F 
		.byte 0x6E 
		.byte 0x81
		.byte 0xF4
		.byte 0x87
		.byte 0x18
		.byte 0x90
		.byte 0x45 
		.byte 0x99
		.byte 0xB3
		.byte 0x7B 
		.byte 0xC9
		.byte 0x75 
		.byte 0x5C 
		.byte 0x7A 
		.byte 0xF9
		.byte 0x7B 
		.byte 0x51 
		.byte 0x84
		.byte 0xC4
		.byte    0
		.byte    0
		.byte 0x90
		.byte 0x10
		.byte 0x79 
		.byte 0xE9
		.byte 0x7A 
		.byte 0x92
		.byte 0x83
		.byte 0x36 
		.byte 0x5A 
		.byte 0xE1
		.byte 0x77 
		.byte 0x40 
		.byte 0x4E 
		.byte 0x2D 
		.byte 0x4E 
		.byte 0xF2
		.byte 0x5B 
		.byte 0x99
		.byte 0x5F 
		.byte 0xE0
		.byte 0x62 
		.byte 0xBD
		.byte 0x66 
		.byte 0x3C 
		.byte 0x67 
		.byte 0xF1
		.byte 0x6C 
		.byte 0xE8
		.byte 0x86
		.byte 0x6B 
		.byte 0x88
		.byte 0x77 
		.byte 0x8A
		.byte 0x3B 
		.byte 0x91
		.byte 0x4E 
		.byte 0x92
		.byte 0xF3
		.byte 0x99
		.byte 0xD0
		.byte 0x6A 
		.byte 0x17
		.byte 0x70 
		.byte 0x26 
		.byte 0x73 
		.byte 0x2A 
		.byte 0x82
		.byte 0xE7
		.byte 0x84
		.byte 0x57 
		.byte 0x8C
		.byte 0xAF
		.byte 0x4E 
		.byte    1
		.byte 0x51 
		.byte 0x46 
		.byte 0x51 
		.byte 0xCB
		.byte 0x55 
		.byte 0x8B
		.byte 0x5B 
		.byte 0xF5
		.byte 0x5E 
		.byte 0x16
		.byte 0x5E 
		.byte 0x33 
		.byte 0x5E 
		.byte 0x81
		.byte 0x5F 
		.byte 0x14
		.byte 0x5F 
		.byte 0x35 
		.byte 0x5F 
		.byte 0x6B 
		.byte 0x5F 
		.byte 0xB4
		.byte 0x61 
		.byte 0xF2
		.byte 0x63 
		.byte 0x11
		.byte 0x66 
		.byte 0xA2
		.byte 0x67 
		.byte 0x1D
		.byte 0x6F 
		.byte 0x6E 
		.byte 0x72 
		.byte 0x52 
		.byte 0x75 
		.byte 0x3A 
		.byte 0x77 
		.byte 0x3A 
		.byte 0x80
		.byte 0x74 
		.byte 0x81
		.byte 0x39 
		.byte 0x81
		.byte 0x78 
		.byte 0x87
		.byte 0x76 
		.byte 0x8A
		.byte 0xBF
		.byte 0x8A
		.byte 0xDC
		.byte 0x8D
		.byte 0x85
		.byte 0x8D
		.byte 0xF3
		.byte 0x92
		.byte 0x9A
		.byte 0x95
		.byte 0x77 
		.byte 0x98
		.byte    2
		.byte 0x9C
		.byte 0xE5
		.byte 0x52 
		.byte 0xC5
		.byte 0x63 
		.byte 0x57 
		.byte 0x76 
		.byte 0xF4
		.byte 0x67 
		.byte 0x15
		.byte 0x6C 
		.byte 0x88
		.byte 0x73 
		.byte 0xCD
		.byte 0x8C
		.byte 0xC3
		.byte 0x93
		.byte 0xAE
		.byte 0x96
		.byte 0x73 
		.byte 0x6D 
		.byte 0x25 
		.byte 0x58 
		.byte 0x9C
		.byte 0x69 
		.byte  0xE
		.byte 0x69 
		.byte 0xCC
		.byte 0x8F
		.byte 0xFD
		.byte 0x93
		.byte 0x9A
		.byte 0x75 
		.byte 0xDB
		.byte 0x90
		.byte 0x1A
		.byte 0x58 
		.byte 0x5A 
		.byte 0x68 
		.byte    2
		.byte 0x63 
		.byte 0xB4
		.byte 0x69 
		.byte 0xFB
		.byte 0x4F 
		.byte 0x43 
		.byte 0x6F 
		.byte 0x2C 
		.byte 0x67 
		.byte 0xD8
		.byte 0x8F
		.byte 0xBB
		.byte 0x85
		.byte 0x26 
		.byte 0x7D 
		.byte 0xB4
		.byte 0x93
		.byte 0x54 
		.byte 0x69 
		.byte 0x3F 
		.byte 0x6F 
		.byte 0x70 
		.byte 0x57 
		.byte 0x6A 
		.byte 0x58 
		.byte 0xF7
		.byte 0x5B 
		.byte 0x2C 
		.byte 0x7D 
		.byte 0x2C 
		.byte 0x72 
		.byte 0x2A 
		.byte 0x54 
		.byte  0xA
		.byte 0x91
		.byte 0xE3
		.byte 0x9D
		.byte 0xB4
		.byte 0x4E 
		.byte 0xAD
		.byte 0x4F 
		.byte 0x4E 
		.byte 0x50 
		.byte 0x5C 
		.byte 0x50 
		.byte 0x75 
		.byte 0x52 
		.byte 0x43 
		.byte 0x8C
		.byte 0x9E
		.byte 0x54 
		.byte 0x48 
		.byte 0x58 
		.byte 0x24 
		.byte 0x5B 
		.byte 0x9A
		.byte 0x5E 
		.byte 0x1D
		.byte 0x5E 
		.byte 0x95
		.byte 0x5E 
		.byte 0xAD
		.byte 0x5E 
		.byte 0xF7
		.byte 0x5F 
		.byte 0x1F
		.byte 0x60 
		.byte 0x8C
		.byte 0x62 
		.byte 0xB5
		.byte 0x63 
		.byte 0x3A 
		.byte 0x63 
		.byte 0xD0
		.byte 0x68 
		.byte 0xAF
		.byte 0x6C 
		.byte 0x40 
		.byte 0x78 
		.byte 0x87
		.byte 0x79 
		.byte 0x8E
		.byte 0x7A 
		.byte  0xB
		.byte 0x7D 
		.byte 0xE0
		.byte 0x82
		.byte 0x47 
		.byte 0x8A
		.byte    2
		.byte 0x8A
		.byte 0xE6
		.byte 0x8E
		.byte 0x44 
		.byte 0x90
		.byte 0x13
		.byte 0x90
		.byte 0xB8
		.byte 0x91
		.byte 0x2D 
		.byte 0x91
		.byte 0xD8
		.byte 0x9F
		.byte  0xE
		.byte 0x6C 
		.byte 0xE5
		.byte 0x64 
		.byte 0x58 
		.byte 0x64 
		.byte 0xE2
		.byte 0x65 
		.byte 0x75 
		.byte 0x6E 
		.byte 0xF4
		.byte 0x76 
		.byte 0x84
		.byte 0x7B 
		.byte 0x1B
		.byte 0x90
		.byte 0x69 
		.byte 0x93
		.byte 0xD1
		.byte 0x6E 
		.byte 0xBA
		.byte 0x54 
		.byte 0xF2
		.byte 0x5F 
		.byte 0xB9
		.byte 0x64 
		.byte 0xA4
		.byte 0x8F
		.byte 0x4D 
		.byte 0x8F
		.byte 0xED
		.byte 0x92
		.byte 0x44 
		.byte 0x51 
		.byte 0x78 
		.byte 0x58 
		.byte 0x6B 
		.byte 0x59 
		.byte 0x29 
		.byte 0x5C 
		.byte 0x55 
		.byte 0x5E 
		.byte 0x97
		.byte 0x6D 
		.byte 0xFB
		.byte 0x7E 
		.byte 0x8F
		.byte 0x75 
		.byte 0x1C
		.byte 0x8C
		.byte 0xBC
		.byte 0x8E
		.byte 0xE2
		.byte 0x98
		.byte 0x5B 
		.byte 0x70 
		.byte 0xB9
		.byte 0x4F 
		.byte 0x1D
		.byte 0x6B 
		.byte 0xBF
		.byte 0x6F 
		.byte 0xB1
		.byte 0x75 
		.byte 0x30 
		.byte 0x96
		.byte 0xFB
		.byte 0x51 
		.byte 0x4E 
		.byte 0x54 
		.byte 0x10
		.byte 0x58 
		.byte 0x35 
		.byte 0x58 
		.byte 0x57 
		.byte 0x59 
		.byte 0xAC
		.byte 0x5C 
		.byte 0x60 
		.byte 0x5F 
		.byte 0x92
		.byte 0x65 
		.byte 0x97
		.byte 0x67 
		.byte 0x5C 
		.byte 0x6E 
		.byte 0x21 
		.byte 0x76 
		.byte 0x7B 
		.byte 0x83
		.byte 0xDF
		.byte 0x8C
		.byte 0xED
		.byte 0x90
		.byte 0x14
		.byte 0x90
		.byte 0xFD
		.byte 0x93
		.byte 0x4D 
		.byte 0x78 
		.byte 0x25 
		.byte 0x78 
		.byte 0x3A 
		.byte 0x52 
		.byte 0xAA
		.byte 0x5E 
		.byte 0xA6
		.byte 0x57 
		.byte 0x1F
		.byte 0x59 
		.byte 0x74 
		.byte 0x60 
		.byte 0x12
		.byte 0x50 
		.byte 0x12
		.byte 0x51 
		.byte 0x5A 
		.byte 0x51 
		.byte 0xAC
		.byte    0
		.byte    0
		.byte 0x51 
		.byte 0xCD
		.byte 0x52 
		.byte    0
		.byte 0x55 
		.byte 0x10
		.byte 0x58 
		.byte 0x54 
		.byte 0x58 
		.byte 0x58 
		.byte 0x59 
		.byte 0x57 
		.byte 0x5B 
		.byte 0x95
		.byte 0x5C 
		.byte 0xF6
		.byte 0x5D 
		.byte 0x8B
		.byte 0x60 
		.byte 0xBC
		.byte 0x62 
		.byte 0x95
		.byte 0x64 
		.byte 0x2D 
		.byte 0x67 
		.byte 0x71 
		.byte 0x68 
		.byte 0x43 
		.byte 0x68 
		.byte 0xBC
		.byte 0x68 
		.byte 0xDF
		.byte 0x76 
		.byte 0xD7
		.byte 0x6D 
		.byte 0xD8
		.byte 0x6E 
		.byte 0x6F 
		.byte 0x6D 
		.byte 0x9B
		.byte 0x70 
		.byte 0x6F 
		.byte 0x71 
		.byte 0xC8
		.byte 0x5F 
		.byte 0x53 
		.byte 0x75 
		.byte 0xD8
		.byte 0x79 
		.byte 0x77 
		.byte 0x7B 
		.byte 0x49 
		.byte 0x7B 
		.byte 0x54 
		.byte 0x7B 
		.byte 0x52 
		.byte 0x7C 
		.byte 0xD6
		.byte 0x7D 
		.byte 0x71 
		.byte 0x52 
		.byte 0x30 
		.byte 0x84
		.byte 0x63 
		.byte 0x85
		.byte 0x69 
		.byte 0x85
		.byte 0xE4
		.byte 0x8A
		.byte  0xE
		.byte 0x8B
		.byte    4
		.byte 0x8C
		.byte 0x46 
		.byte 0x8E
		.byte  0xF
		.byte 0x90
		.byte    3
		.byte 0x90
		.byte  0xF
		.byte 0x94
		.byte 0x19
		.byte 0x96
		.byte 0x76 
		.byte 0x98
		.byte 0x2D 
		.byte 0x9A
		.byte 0x30 
		.byte 0x95
		.byte 0xD8
		.byte 0x50 
		.byte 0xCD
		.byte 0x52 
		.byte 0xD5
		.byte 0x54 
		.byte  0xC
		.byte 0x58 
		.byte    2
		.byte 0x5C 
		.byte  0xE
		.byte 0x61 
		.byte 0xA7
		.byte 0x64 
		.byte 0x9E
		.byte 0x6D 
		.byte 0x1E
		.byte 0x77 
		.byte 0xB3
		.byte 0x7A 
		.byte 0xE5
		.byte 0x80
		.byte 0xF4
		.byte 0x84
		.byte    4
		.byte 0x90
		.byte 0x53 
		.byte 0x92
		.byte 0x85
		.byte 0x5C 
		.byte 0xE0
		.byte 0x9D
		.byte    7
		.byte 0x53 
		.byte 0x3F 
		.byte 0x5F 
		.byte 0x97
		.byte 0x5F 
		.byte 0xB3
		.byte 0x6D 
		.byte 0x9C
		.byte 0x72 
		.byte 0x79 
		.byte 0x77 
		.byte 0x63 
		.byte 0x79 
		.byte 0xBF
		.byte 0x7B 
		.byte 0xE4
		.byte 0x6B 
		.byte 0xD2
		.byte 0x72 
		.byte 0xEC
		.byte 0x8A
		.byte 0xAD
		.byte 0x68 
		.byte    3
		.byte 0x6A 
		.byte 0x61 
		.byte 0x51 
		.byte 0xF8
		.byte 0x7A 
		.byte 0x81
		.byte 0x69 
		.byte 0x34 
		.byte 0x5C 
		.byte 0x4A 
		.byte 0x9C
		.byte 0xF6
		.byte 0x82
		.byte 0xEB
		.byte 0x5B 
		.byte 0xC5
		.byte 0x91
		.byte 0x49 
		.byte 0x70 
		.byte 0x1E
		.byte 0x56 
		.byte 0x78 
		.byte 0x5C 
		.byte 0x6F 
		.byte 0x60 
		.byte 0xC7
		.byte 0x65 
		.byte 0x66 
		.byte 0x6C 
		.byte 0x8C
		.byte 0x8C
		.byte 0x5A 
		.byte 0x90
		.byte 0x41 
		.byte 0x98
		.byte 0x13
		.byte 0x54 
		.byte 0x51 
		.byte 0x66 
		.byte 0xC7
		.byte 0x92
		.byte  0xD
		.byte 0x59 
		.byte 0x48 
		.byte 0x90
		.byte 0xA3
		.byte 0x51 
		.byte 0x85
		.byte 0x4E 
		.byte 0x4D 
		.byte 0x51 
		.byte 0xEA
		.byte 0x85
		.byte 0x99
		.byte 0x8B
		.byte  0xE
		.byte 0x70 
		.byte 0x58 
		.byte 0x63 
		.byte 0x7A 
		.byte 0x93
		.byte 0x4B 
		.byte 0x69 
		.byte 0x62 
		.byte 0x99
		.byte 0xB4
		.byte 0x7E 
		.byte    4
		.byte 0x75 
		.byte 0x77 
		.byte 0x53 
		.byte 0x57 
		.byte 0x69 
		.byte 0x60 
		.byte 0x8E
		.byte 0xDF
		.byte 0x96
		.byte 0xE3
		.byte 0x6C 
		.byte 0x5D 
		.byte 0x4E 
		.byte 0x8C
		.byte 0x5C 
		.byte 0x3C 
		.byte 0x5F 
		.byte 0x10
		.byte 0x8F
		.byte 0xE9
		.byte 0x53 
		.byte    2
		.byte 0x8C
		.byte 0xD1
		.byte 0x80
		.byte 0x89
		.byte 0x86
		.byte 0x79 
		.byte 0x5E 
		.byte 0xFF
		.byte 0x65 
		.byte 0xE5
		.byte 0x4E 
		.byte 0x73 
		.byte 0x51 
		.byte 0x65 
		.byte 0x59 
		.byte 0x82
		.byte 0x5C 
		.byte 0x3F 
		.byte 0x97
		.byte 0xEE
		.byte 0x4E 
		.byte 0xFB
		.byte 0x59 
		.byte 0x8A
		.byte 0x5F 
		.byte 0xCD
		.byte 0x8A
		.byte 0x8D
		.byte 0x6F 
		.byte 0xE1
		.byte 0x79 
		.byte 0xB0
		.byte 0x79 
		.byte 0x62 
		.byte 0x5B 
		.byte 0xE7
		.byte 0x84
		.byte 0x71 
		.byte 0x73 
		.byte 0x2B 
		.byte 0x71 
		.byte 0xB1
		.byte 0x5E 
		.byte 0x74 
		.byte 0x5F 
		.byte 0xF5
		.byte 0x63 
		.byte 0x7B 
		.byte 0x64 
		.byte 0x9A
		.byte 0x71 
		.byte 0xC3
		.byte 0x7C 
		.byte 0x98
		.byte 0x4E 
		.byte 0x43 
		.byte 0x5E 
		.byte 0xFC
		.byte 0x4E 
		.byte 0x4B 
		.byte 0x57 
		.byte 0xDC
		.byte 0x56 
		.byte 0xA2
		.byte 0x60 
		.byte 0xA9
		.byte 0x6F 
		.byte 0xC3
		.byte 0x7D 
		.byte  0xD
		.byte 0x80
		.byte 0xFD
		.byte 0x81
		.byte 0x33 
		.byte 0x81
		.byte 0xBF
		.byte 0x8F
		.byte 0xB2
		.byte 0x89
		.byte 0x97
		.byte 0x86
		.byte 0xA4
		.byte 0x5D 
		.byte 0xF4
		.byte 0x62 
		.byte 0x8A
		.byte 0x64 
		.byte 0xAD
		.byte 0x89
		.byte 0x87
		.byte 0x67 
		.byte 0x77 
		.byte 0x6C 
		.byte 0xE2
		.byte 0x6D 
		.byte 0x3E 
		.byte 0x74 
		.byte 0x36 
		.byte 0x78 
		.byte 0x34 
		.byte 0x5A 
		.byte 0x46 
		.byte 0x7F 
		.byte 0x75 
		.byte 0x82
		.byte 0xAD
		.byte 0x99
		.byte 0xAC
		.byte 0x4F 
		.byte 0xF3
		.byte 0x5E 
		.byte 0xC3
		.byte 0x62 
		.byte 0xDD
		.byte 0x63 
		.byte 0x92
		.byte 0x65 
		.byte 0x57 
		.byte 0x67 
		.byte 0x6F 
		.byte 0x76 
		.byte 0xC3
		.byte 0x72 
		.byte 0x4C 
		.byte 0x80
		.byte 0xCC
		.byte 0x80
		.byte 0xBA
		.byte 0x8F
		.byte 0x29 
		.byte 0x91
		.byte 0x4D 
		.byte 0x50 
		.byte  0xD
		.byte 0x57 
		.byte 0xF9
		.byte 0x5A 
		.byte 0x92
		.byte 0x68 
		.byte 0x85
		.byte    0
		.byte    0
		.byte 0x69 
		.byte 0x73 
		.byte 0x71 
		.byte 0x64 
		.byte 0x72 
		.byte 0xFD
		.byte 0x8C
		.byte 0xB7
		.byte 0x58 
		.byte 0xF2
		.byte 0x8C
		.byte 0xE0
		.byte 0x96
		.byte 0x6A 
		.byte 0x90
		.byte 0x19
		.byte 0x87
		.byte 0x7F 
		.byte 0x79 
		.byte 0xE4
		.byte 0x77 
		.byte 0xE7
		.byte 0x84
		.byte 0x29 
		.byte 0x4F 
		.byte 0x2F 
		.byte 0x52 
		.byte 0x65 
		.byte 0x53 
		.byte 0x5A 
		.byte 0x62 
		.byte 0xCD
		.byte 0x67 
		.byte 0xCF
		.byte 0x6C 
		.byte 0xCA
		.byte 0x76 
		.byte 0x7D 
		.byte 0x7B 
		.byte 0x94
		.byte 0x7C 
		.byte 0x95
		.byte 0x82
		.byte 0x36 
		.byte 0x85
		.byte 0x84
		.byte 0x8F
		.byte 0xEB
		.byte 0x66 
		.byte 0xDD
		.byte 0x6F 
		.byte 0x20
		.byte 0x72 
		.byte    6
.align 4
