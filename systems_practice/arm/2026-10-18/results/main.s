	.build_version macos, 26, 0	sdk_version 26, 5
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__Z5checkb                      ; -- Begin function _Z5checkb
	.p2align	2
__Z5checkb:                             ; @_Z5checkb
Lfunc_begin0:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception0
; %bb.0:
	stp	x20, x19, [sp, #-32]!           ; 16-byte Folded Spill
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	tbz	w0, #0, LBB0_2
; %bb.1:
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
	ret
LBB0_2:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp0:
Lloh0:
	adrp	x1, l_.str@PAGE
Lloh1:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp1:
; %bb.3:
	mov	x0, x19
	bl	__Z5checkb.cold.1
LBB0_4:
Ltmp2:
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x0, x20
	bl	__Unwind_Resume
	.loh AdrpAdd	Lloh0, Lloh1
Lfunc_end0:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table0:
Lexception0:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end0-Lcst_begin0
Lcst_begin0:
	.uleb128 Lfunc_begin0-Lfunc_begin0      ; >> Call Site 1 <<
	.uleb128 Ltmp0-Lfunc_begin0             ;   Call between Lfunc_begin0 and Ltmp0
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp0-Lfunc_begin0             ; >> Call Site 2 <<
	.uleb128 Ltmp1-Ltmp0                    ;   Call between Ltmp0 and Ltmp1
	.uleb128 Ltmp2-Lfunc_begin0             ;     jumps to Ltmp2
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp1-Lfunc_begin0             ; >> Call Site 3 <<
	.uleb128 Lfunc_end0-Ltmp1               ;   Call between Ltmp1 and Lfunc_end0
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end0:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__Z8validateRKNSt3__16vectorIhNS_9allocatorIhEEEEiii ; -- Begin function _Z8validateRKNSt3__16vectorIhNS_9allocatorIhEEEEiii
	.p2align	2
__Z8validateRKNSt3__16vectorIhNS_9allocatorIhEEEEiii: ; @_Z8validateRKNSt3__16vectorIhNS_9allocatorIhEEEEiii
Lfunc_begin1:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception1
; %bb.0:
	stp	x20, x19, [sp, #-32]!           ; 16-byte Folded Spill
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	cmp	w2, #1, lsl #12                 ; =4096
	b.gt	LBB1_6
; %bb.1:
	cmp	w1, #1, lsl #12                 ; =4096
	b.gt	LBB1_6
; %bb.2:
	orr	w8, w2, w1
	tbnz	w8, #31, LBB1_6
; %bb.3:
	add	w8, w1, w1, lsl #1
	cmp	w3, w8
	b.lt	LBB1_6
; %bb.4:
	ldp	x9, x8, [x0]
	umull	x10, w3, w2
	sub	x8, x8, x9
	cmp	x8, x10
	b.ne	LBB1_6
; %bb.5:
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
	ret
LBB1_6:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp3:
Lloh2:
	adrp	x1, l_.str.1@PAGE
Lloh3:
	add	x1, x1, l_.str.1@PAGEOFF
	bl	__ZNSt16invalid_argumentC1B9nqe210106EPKc
Ltmp4:
; %bb.7:
	mov	x0, x19
	bl	__Z8validateRKNSt3__16vectorIhNS_9allocatorIhEEEEiii.cold.1
LBB1_8:
Ltmp5:
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x0, x20
	bl	__Unwind_Resume
	.loh AdrpAdd	Lloh2, Lloh3
Lfunc_end1:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table1:
Lexception1:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end1-Lcst_begin1
Lcst_begin1:
	.uleb128 Lfunc_begin1-Lfunc_begin1      ; >> Call Site 1 <<
	.uleb128 Ltmp3-Lfunc_begin1             ;   Call between Lfunc_begin1 and Ltmp3
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp3-Lfunc_begin1             ; >> Call Site 2 <<
	.uleb128 Ltmp4-Ltmp3                    ;   Call between Ltmp3 and Ltmp4
	.uleb128 Ltmp5-Lfunc_begin1             ;     jumps to Ltmp5
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp4-Lfunc_begin1             ; >> Call Site 3 <<
	.uleb128 Lfunc_end1-Ltmp4               ;   Call between Ltmp4 and Lfunc_end1
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end1:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.private_extern	__ZNSt16invalid_argumentC1B9nqe210106EPKc ; -- Begin function _ZNSt16invalid_argumentC1B9nqe210106EPKc
	.globl	__ZNSt16invalid_argumentC1B9nqe210106EPKc
	.weak_def_can_be_hidden	__ZNSt16invalid_argumentC1B9nqe210106EPKc
	.p2align	2
__ZNSt16invalid_argumentC1B9nqe210106EPKc: ; @_ZNSt16invalid_argumentC1B9nqe210106EPKc
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZNSt11logic_errorC2EPKc
Lloh4:
	adrp	x8, __ZTVSt16invalid_argument@GOTPAGE
Lloh5:
	ldr	x8, [x8, __ZTVSt16invalid_argument@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x0]
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
	.loh AdrpLdrGot	Lloh4, Lloh5
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__literal16,16byte_literals
	.p2align	4, 0x0                          ; -- Begin function _Z9referenceRKNSt3__16vectorIhNS_9allocatorIhEEEEiii
lCPI3_0:
	.byte	12                              ; 0xc
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	13                              ; 0xd
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	14                              ; 0xe
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	15                              ; 0xf
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
lCPI3_1:
	.byte	8                               ; 0x8
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	9                               ; 0x9
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	10                              ; 0xa
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	11                              ; 0xb
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
lCPI3_2:
	.byte	4                               ; 0x4
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	5                               ; 0x5
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	6                               ; 0x6
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	7                               ; 0x7
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
lCPI3_3:
	.byte	0                               ; 0x0
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	1                               ; 0x1
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	2                               ; 0x2
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	3                               ; 0x3
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__Z9referenceRKNSt3__16vectorIhNS_9allocatorIhEEEEiii
	.p2align	2
__Z9referenceRKNSt3__16vectorIhNS_9allocatorIhEEEEiii: ; @_Z9referenceRKNSt3__16vectorIhNS_9allocatorIhEEEEiii
Lfunc_begin2:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception2
; %bb.0:
	stp	x28, x27, [sp, #-96]!           ; 16-byte Folded Spill
	stp	x26, x25, [sp, #16]             ; 16-byte Folded Spill
	stp	x24, x23, [sp, #32]             ; 16-byte Folded Spill
	stp	x22, x21, [sp, #48]             ; 16-byte Folded Spill
	stp	x20, x19, [sp, #64]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #80]             ; 16-byte Folded Spill
	add	x29, sp, #80
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_offset w23, -56
	.cfi_offset w24, -64
	.cfi_offset w25, -72
	.cfi_offset w26, -80
	.cfi_offset w27, -88
	.cfi_offset w28, -96
	cmp	w2, #1, lsl #12                 ; =4096
	b.gt	LBB3_74
; %bb.1:
	mov	x21, x1
	cmp	w1, #1, lsl #12                 ; =4096
	b.gt	LBB3_74
; %bb.2:
	mov	x20, x2
	mov	x23, x8
	orr	w8, w2, w21
	tbnz	w8, #31, LBB3_74
; %bb.3:
	mov	x19, x3
	add	w8, w21, w21, lsl #1
	cmp	w3, w8
	b.lt	LBB3_74
; %bb.4:
	ldp	x25, x8, [x0]
	umull	x9, w19, w20
	sub	x8, x8, x25
	cmp	x8, x9
	b.ne	LBB3_74
; %bb.5:
	smull	x8, w20, w21
	stp	xzr, xzr, [x23]
	str	xzr, [x23, #16]
	cbz	x8, LBB3_8
; %bb.6:
	lsl	x9, x8, #1
	smaddl	x26, w20, w21, x9
	lsr	x9, x26, #62
	cbnz	x9, LBB3_76
; %bb.7:
	add	x8, x8, x8, lsl #1
	lsl	x24, x8, #2
	mov	x0, x24
	bl	__Znwm
	mov	x22, x0
	str	x0, [x23]
	add	x8, x0, x26, lsl #2
	str	x8, [x23, #16]
	add	x26, x0, x24
	mov	x1, x24
	bl	_bzero
	str	x26, [x23, #8]
	subs	w7, w20, #1
	b.ge	LBB3_9
	b	LBB3_58
LBB3_8:
	mov	x22, #0                         ; =0x0
	subs	w7, w20, #1
	b.lt	LBB3_58
LBB3_9:
	cmp	w21, #1
	b.lt	LBB3_58
; %bb.10:
	mov	w8, w21
	sub	x9, x8, #1
	add	x10, x22, w21, uxtw #2
	add	x3, x8, w21, uxtw #1
	mov	w11, w9
	add	x11, x11, w9, uxtw #1
	tst	x11, #0xffffffff00000000
	cset	w12, ne
	tst	x9, #0xffffffff00000000
	csinc	w12, w12, wzr, eq
	ands	x13, x8, #0xf
	mov	w14, #16                        ; =0x10
	csel	x13, x14, x13, eq
	sub	x14, x8, x13
	ands	x15, x8, #0x7
	mov	w16, #8                         ; =0x8
	csel	x2, x16, x15, eq
	sub	x15, x8, x2
	adrp	x16, lCPI3_2@PAGE
	adrp	x17, lCPI3_3@PAGE
	adrp	x0, lCPI3_0@PAGE
	adrp	x1, lCPI3_1@PAGE
	cmp	w21, #9
	b.hs	LBB3_21
; %bb.11:
	mov	w4, #0                          ; =0x0
	mov	w5, #0                          ; =0x0
	mov	w6, #-1024065536                ; =0xc2f60000
	fmov	s0, w6
	mov	w6, #15819                      ; =0x3dcb
	movk	w6, #15501, lsl #16
	fmov	s1, w6
	mov	x6, x20
	b	LBB3_13
LBB3_12:                                ;   in Loop: Header=BB3_13 Depth=1
	add	w5, w5, w19
	add	w4, w4, w21
	subs	w6, w6, #1
	b.eq	LBB3_37
LBB3_13:                                ; =>This Inner Loop Header: Depth=1
	ldr	b2, [x25, w5, sxtw]
	ucvtf	s2, s2
	fadd	s2, s2, s0
	fmul	s2, s2, s1
	str	s2, [x22, w4, sxtw #2]
	cmp	w21, #1
	b.eq	LBB3_12
; %bb.14:                               ;   in Loop: Header=BB3_13 Depth=1
	add	w7, w5, #3
	ldr	b2, [x25, w7, sxtw]
	ucvtf	s2, s2
	fadd	s2, s2, s0
	fmul	s2, s2, s1
	add	w7, w4, #1
	str	s2, [x22, w7, sxtw #2]
	cmp	w21, #2
	b.eq	LBB3_12
; %bb.15:                               ;   in Loop: Header=BB3_13 Depth=1
	add	w7, w5, #6
	ldr	b2, [x25, w7, sxtw]
	ucvtf	s2, s2
	fadd	s2, s2, s0
	fmul	s2, s2, s1
	add	w7, w4, #2
	str	s2, [x22, w7, sxtw #2]
	cmp	w21, #3
	b.eq	LBB3_12
; %bb.16:                               ;   in Loop: Header=BB3_13 Depth=1
	add	w7, w5, #9
	ldr	b2, [x25, w7, sxtw]
	ucvtf	s2, s2
	fadd	s2, s2, s0
	fmul	s2, s2, s1
	add	w7, w4, #3
	str	s2, [x22, w7, sxtw #2]
	cmp	w21, #4
	b.eq	LBB3_12
; %bb.17:                               ;   in Loop: Header=BB3_13 Depth=1
	add	w7, w5, #12
	ldr	b2, [x25, w7, sxtw]
	ucvtf	s2, s2
	fadd	s2, s2, s0
	fmul	s2, s2, s1
	add	w7, w4, #4
	str	s2, [x22, w7, sxtw #2]
	cmp	w21, #5
	b.eq	LBB3_12
; %bb.18:                               ;   in Loop: Header=BB3_13 Depth=1
	add	w7, w5, #15
	ldr	b2, [x25, w7, sxtw]
	ucvtf	s2, s2
	fadd	s2, s2, s0
	fmul	s2, s2, s1
	add	w7, w4, #5
	str	s2, [x22, w7, sxtw #2]
	cmp	w21, #6
	b.eq	LBB3_12
; %bb.19:                               ;   in Loop: Header=BB3_13 Depth=1
	add	w7, w5, #18
	ldr	b2, [x25, w7, sxtw]
	ucvtf	s2, s2
	fadd	s2, s2, s0
	fmul	s2, s2, s1
	add	w7, w4, #6
	str	s2, [x22, w7, sxtw #2]
	cmp	w21, #7
	b.eq	LBB3_12
; %bb.20:                               ;   in Loop: Header=BB3_13 Depth=1
	add	w7, w5, #21
	ldr	b2, [x25, w7, sxtw]
	ucvtf	s2, s2
	fadd	s2, s2, s0
	fmul	s2, s2, s1
	add	w7, w4, #7
	str	s2, [x22, w7, sxtw #2]
	b	LBB3_12
LBB3_21:
	mov	w4, #0                          ; =0x0
	mov	w5, #0                          ; =0x0
	mov	w6, #0                          ; =0x0
	mov	w23, w19
	umaddl	x7, w23, w7, x25
	add	x7, x7, x3
	sub	x7, x7, #2
	mov	w23, #-1024065536               ; =0xc2f60000
	dup.4s	v0, w23
	fmov	s1, w23
	mov	w23, #15819                     ; =0x3dcb
	movk	w23, #15501, lsl #16
	dup.4s	v2, w23
	fmov	s3, w23
	sub	x23, x2, x8
	ldr	q4, [x16, lCPI3_2@PAGEOFF]
	ldr	q5, [x17, lCPI3_3@PAGEOFF]
	ldr	q6, [x0, lCPI3_0@PAGEOFF]
	ldr	q7, [x1, lCPI3_1@PAGEOFF]
LBB3_22:                                ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB3_29 Depth 2
                                        ;     Child Loop BB3_32 Depth 2
                                        ;     Child Loop BB3_35 Depth 2
	mul	w26, w21, w6
	mul	w24, w6, w19
	add	w27, w26, w9
	add	w28, w24, w11
	cmp	w28, w24
	ccmp	w27, w26, #8, ge
	csinc	w24, w12, wzr, ge
	tbz	w24, #0, LBB3_24
; %bb.23:                               ;   in Loop: Header=BB3_22 Depth=1
	mov	x24, #0                         ; =0x0
	b	LBB3_34
LBB3_24:                                ;   in Loop: Header=BB3_22 Depth=1
	mov	x24, #0                         ; =0x0
	sbfiz	x26, x26, #2, #32
	add	x27, x22, x26
	add	x26, x10, x26
	cmp	x25, x26
	ccmp	x27, x7, #2, lo
	b.lo	LBB3_34
; %bb.25:                               ;   in Loop: Header=BB3_22 Depth=1
	tbnz	w19, #31, LBB3_34
; %bb.26:                               ;   in Loop: Header=BB3_22 Depth=1
	cmp	w21, #17
	b.hs	LBB3_28
; %bb.27:                               ;   in Loop: Header=BB3_22 Depth=1
	mov	x27, #0                         ; =0x0
	b	LBB3_31
LBB3_28:                                ;   in Loop: Header=BB3_22 Depth=1
	mov	x24, x4
	mov	x26, x5
	mov	x27, x14
LBB3_29:                                ;   Parent Loop BB3_22 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	add	x28, x25, w24, sxtw
	ld3.16b	{ v16, v17, v18 }, [x28]
	tbl.16b	v19, { v16 }, v6
	tbl.16b	v20, { v16 }, v7
	tbl.16b	v21, { v16 }, v4
	tbl.16b	v16, { v16 }, v5
	ucvtf.4s	v16, v16
	ucvtf.4s	v17, v21
	ucvtf.4s	v18, v20
	ucvtf.4s	v19, v19
	fadd.4s	v19, v19, v0
	fadd.4s	v18, v18, v0
	fadd.4s	v17, v17, v0
	fadd.4s	v16, v16, v0
	fmul.4s	v16, v16, v2
	fmul.4s	v18, v18, v2
	fmul.4s	v19, v19, v2
	add	x28, x22, w26, sxtw #2
	stp	q18, q19, [x28, #32]
	fmul.4s	v17, v17, v2
	stp	q16, q17, [x28]
	add	w26, w26, #16
	add	w24, w24, #48
	subs	x27, x27, #16
	b.ne	LBB3_29
; %bb.30:                               ;   in Loop: Header=BB3_22 Depth=1
	mov	x27, x14
	mov	x24, x14
	cmp	x13, #9
	b.lo	LBB3_34
LBB3_31:                                ;   in Loop: Header=BB3_22 Depth=1
	add	x24, x23, x27
	add	w26, w5, w27
	add	w27, w27, w27, lsl #1
	add	w27, w4, w27
LBB3_32:                                ;   Parent Loop BB3_22 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	add	x28, x25, w27, sxtw
	ld3.8b	{ v16, v17, v18 }, [x28]
	tbl.16b	v19, { v16 }, v4
	tbl.16b	v16, { v16 }, v5
	ucvtf.4s	v16, v16
	ucvtf.4s	v17, v19
	fadd.4s	v17, v17, v0
	fadd.4s	v16, v16, v0
	fmul.4s	v16, v16, v2
	fmul.4s	v17, v17, v2
	add	x28, x22, w26, sxtw #2
	stp	q16, q17, [x28]
	add	w26, w26, #8
	add	w27, w27, #24
	adds	x24, x24, #8
	b.ne	LBB3_32
; %bb.33:                               ;   in Loop: Header=BB3_22 Depth=1
	mov	x24, x15
LBB3_34:                                ;   in Loop: Header=BB3_22 Depth=1
	add	w26, w5, w24
	add	w27, w24, w24, lsl #1
	add	w27, w4, w27
	sub	x24, x8, x24
LBB3_35:                                ;   Parent Loop BB3_22 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	b16, [x25, w27, sxtw]
	ucvtf	s16, s16
	fadd	s16, s16, s1
	fmul	s16, s16, s3
	str	s16, [x22, w26, sxtw #2]
	add	w26, w26, #1
	add	w27, w27, #3
	subs	x24, x24, #1
	b.ne	LBB3_35
; %bb.36:                               ;   in Loop: Header=BB3_22 Depth=1
	add	w6, w6, #1
	add	w5, w5, w21
	add	w4, w4, w19
	cmp	w6, w20
	b.ne	LBB3_22
LBB3_37:
	add	x3, x25, x3
	sub	x3, x3, #2
	cmp	w21, #9
	b.hs	LBB3_59
; %bb.38:
	mov	w4, #0                          ; =0x0
	mul	w5, w20, w21
	mov	w6, #1                          ; =0x1
	mov	w7, #-1024851968                ; =0xc2ea0000
	fmov	s0, w7
	mov	w7, #47140                      ; =0xb824
	movk	w7, #15503, lsl #16
	fmov	s1, w7
LBB3_39:                                ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB3_40 Depth 2
	mov	x7, x6
	mov	x23, x5
	mov	x24, x8
LBB3_40:                                ;   Parent Loop BB3_39 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	b2, [x25, w7, sxtw]
	ucvtf	s2, s2
	fadd	s2, s2, s0
	fmul	s2, s2, s1
	str	s2, [x22, w23, sxtw #2]
	add	w23, w23, #1
	add	w7, w7, #3
	subs	x24, x24, #1
	b.ne	LBB3_40
; %bb.41:                               ;   in Loop: Header=BB3_39 Depth=1
	add	w4, w4, #1
	add	w5, w5, w21
	add	w6, w6, w19
	cmp	w4, w20
	b.ne	LBB3_39
LBB3_42:
	mov	w4, #0                          ; =0x0
	mul	w5, w20, w21
	lsl	w5, w5, #1
	sub	x2, x2, x8
	mov	w7, #-1026555904                ; =0xc2d00000
	dup.4s	v0, w7
	mov	w6, #2                          ; =0x2
	fmov	s1, w7
	mov	w7, #55539                      ; =0xd8f3
	movk	w7, #15498, lsl #16
	dup.4s	v2, w7
	fmov	s3, w7
	ldr	q4, [x16, lCPI3_2@PAGEOFF]
	ldr	q5, [x17, lCPI3_3@PAGEOFF]
	ldr	q6, [x0, lCPI3_0@PAGEOFF]
	ldr	q7, [x1, lCPI3_1@PAGEOFF]
	mov	w16, #2                         ; =0x2
	mov	x17, x5
LBB3_43:                                ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB3_53 Depth 2
                                        ;     Child Loop BB3_56 Depth 2
                                        ;     Child Loop BB3_50 Depth 2
	cmp	w21, #9
	b.lo	LBB3_48
; %bb.44:                               ;   in Loop: Header=BB3_43 Depth=1
	madd	w1, w21, w4, w5
	madd	w0, w19, w4, w6
	add	w7, w1, w9
	add	w23, w0, w11
	cmp	w23, w0
	ccmp	w7, w1, #8, ge
	csinc	w7, w12, wzr, ge
	tbnz	w7, #0, LBB3_48
; %bb.45:                               ;   in Loop: Header=BB3_43 Depth=1
	sbfiz	x1, x1, #2, #32
	add	x7, x22, x1
	add	x1, x10, x1
	sxtw	x0, w0
	add	x23, x25, x0
	add	x0, x3, x0
	cmp	x7, x0
	ccmp	x23, x1, #2, lo
	b.lo	LBB3_48
; %bb.46:                               ;   in Loop: Header=BB3_43 Depth=1
	cmp	w21, #17
	b.hs	LBB3_52
; %bb.47:                               ;   in Loop: Header=BB3_43 Depth=1
	mov	x23, #0                         ; =0x0
	b	LBB3_55
LBB3_48:                                ;   in Loop: Header=BB3_43 Depth=1
	mov	x7, #0                          ; =0x0
LBB3_49:                                ;   in Loop: Header=BB3_43 Depth=1
	add	w0, w17, w7
	add	w1, w7, w7, lsl #1
	add	w1, w16, w1
	sub	x7, x8, x7
LBB3_50:                                ;   Parent Loop BB3_43 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	b16, [x25, w1, sxtw]
	ucvtf	s16, s16
	fadd	s16, s16, s1
	fmul	s16, s16, s3
	str	s16, [x22, w0, sxtw #2]
	add	w0, w0, #1
	add	w1, w1, #3
	subs	x7, x7, #1
	b.ne	LBB3_50
; %bb.51:                               ;   in Loop: Header=BB3_43 Depth=1
	add	w4, w4, #1
	add	w17, w17, w21
	add	w16, w16, w19
	cmp	w4, w20
	b.ne	LBB3_43
	b	LBB3_58
LBB3_52:                                ;   in Loop: Header=BB3_43 Depth=1
	mov	x0, x16
	mov	x1, x17
	mov	x7, x14
LBB3_53:                                ;   Parent Loop BB3_43 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	add	x23, x25, w0, sxtw
	ld3.16b	{ v16, v17, v18 }, [x23]
	tbl.16b	v19, { v16 }, v6
	tbl.16b	v20, { v16 }, v7
	tbl.16b	v21, { v16 }, v4
	tbl.16b	v16, { v16 }, v5
	ucvtf.4s	v16, v16
	ucvtf.4s	v17, v21
	ucvtf.4s	v18, v20
	ucvtf.4s	v19, v19
	fadd.4s	v19, v19, v0
	fadd.4s	v18, v18, v0
	fadd.4s	v17, v17, v0
	fadd.4s	v16, v16, v0
	fmul.4s	v16, v16, v2
	fmul.4s	v18, v18, v2
	fmul.4s	v19, v19, v2
	add	x23, x22, w1, sxtw #2
	stp	q18, q19, [x23, #32]
	fmul.4s	v17, v17, v2
	stp	q16, q17, [x23]
	add	w1, w1, #16
	add	w0, w0, #48
	subs	x7, x7, #16
	b.ne	LBB3_53
; %bb.54:                               ;   in Loop: Header=BB3_43 Depth=1
	mov	x23, x14
	mov	x7, x14
	cmp	x13, #9
	b.lo	LBB3_49
LBB3_55:                                ;   in Loop: Header=BB3_43 Depth=1
	add	x0, x2, x23
	add	w1, w17, w23
	add	w7, w23, w23, lsl #1
	add	w7, w16, w7
LBB3_56:                                ;   Parent Loop BB3_43 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	add	x23, x25, w7, sxtw
	ld3.8b	{ v16, v17, v18 }, [x23]
	tbl.16b	v19, { v16 }, v4
	tbl.16b	v16, { v16 }, v5
	ucvtf.4s	v16, v16
	ucvtf.4s	v17, v19
	fadd.4s	v17, v17, v0
	fadd.4s	v16, v16, v0
	fmul.4s	v16, v16, v2
	fmul.4s	v17, v17, v2
	add	x23, x22, w1, sxtw #2
	stp	q16, q17, [x23]
	add	w1, w1, #8
	add	w7, w7, #24
	adds	x0, x0, #8
	b.ne	LBB3_56
; %bb.57:                               ;   in Loop: Header=BB3_43 Depth=1
	mov	x7, x15
	b	LBB3_49
LBB3_58:
	ldp	x29, x30, [sp, #80]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #64]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #48]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #32]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #16]             ; 16-byte Folded Reload
	ldp	x28, x27, [sp], #96             ; 16-byte Folded Reload
	ret
LBB3_59:
	mov	w4, #0                          ; =0x0
	mul	w5, w20, w21
	sub	x6, x2, x8
	mov	w7, #1                          ; =0x1
	mov	w23, #-1024851968               ; =0xc2ea0000
	dup.4s	v0, w23
	fmov	s1, w23
	mov	w23, #47140                     ; =0xb824
	movk	w23, #15503, lsl #16
	dup.4s	v2, w23
	fmov	s3, w23
	ldr	q4, [x16, lCPI3_2@PAGEOFF]
	ldr	q5, [x17, lCPI3_3@PAGEOFF]
	ldr	q6, [x0, lCPI3_0@PAGEOFF]
	mov	w23, #1                         ; =0x1
	ldr	q7, [x1, lCPI3_1@PAGEOFF]
LBB3_60:                                ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB3_69 Depth 2
                                        ;     Child Loop BB3_72 Depth 2
                                        ;     Child Loop BB3_66 Depth 2
	add	w24, w20, w4
	mul	w24, w24, w21
	madd	w26, w19, w4, w7
	add	w27, w24, w9
	add	w28, w26, w11
	cmp	w28, w26
	ccmp	w27, w24, #8, ge
	csinc	w27, w12, wzr, ge
	tbnz	w27, #0, LBB3_64
; %bb.61:                               ;   in Loop: Header=BB3_60 Depth=1
	sxtw	x26, w26
	add	x27, x3, x26
	add	x26, x25, x26
	sbfiz	x24, x24, #2, #32
	add	x28, x10, x24
	add	x24, x22, x24
	cmp	x24, x27
	ccmp	x26, x28, #2, lo
	b.lo	LBB3_64
; %bb.62:                               ;   in Loop: Header=BB3_60 Depth=1
	cmp	w21, #17
	b.hs	LBB3_68
; %bb.63:                               ;   in Loop: Header=BB3_60 Depth=1
	mov	x28, #0                         ; =0x0
	b	LBB3_71
LBB3_64:                                ;   in Loop: Header=BB3_60 Depth=1
	mov	x27, #0                         ; =0x0
LBB3_65:                                ;   in Loop: Header=BB3_60 Depth=1
	add	w24, w5, w27
	add	w26, w27, w27, lsl #1
	add	w26, w23, w26
	sub	x27, x8, x27
LBB3_66:                                ;   Parent Loop BB3_60 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	b16, [x25, w26, sxtw]
	ucvtf	s16, s16
	fadd	s16, s16, s1
	fmul	s16, s16, s3
	str	s16, [x22, w24, sxtw #2]
	add	w24, w24, #1
	add	w26, w26, #3
	subs	x27, x27, #1
	b.ne	LBB3_66
; %bb.67:                               ;   in Loop: Header=BB3_60 Depth=1
	add	w4, w4, #1
	add	w5, w5, w21
	add	w23, w23, w19
	cmp	w4, w20
	b.ne	LBB3_60
	b	LBB3_42
LBB3_68:                                ;   in Loop: Header=BB3_60 Depth=1
	mov	x24, x23
	mov	x26, x5
	mov	x27, x14
LBB3_69:                                ;   Parent Loop BB3_60 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	add	x28, x25, w24, sxtw
	ld3.16b	{ v16, v17, v18 }, [x28]
	tbl.16b	v19, { v16 }, v6
	tbl.16b	v20, { v16 }, v7
	tbl.16b	v21, { v16 }, v4
	tbl.16b	v16, { v16 }, v5
	ucvtf.4s	v16, v16
	ucvtf.4s	v17, v21
	ucvtf.4s	v18, v20
	ucvtf.4s	v19, v19
	fadd.4s	v19, v19, v0
	fadd.4s	v18, v18, v0
	fadd.4s	v17, v17, v0
	fadd.4s	v16, v16, v0
	fmul.4s	v16, v16, v2
	fmul.4s	v18, v18, v2
	fmul.4s	v19, v19, v2
	add	x28, x22, w26, sxtw #2
	stp	q18, q19, [x28, #32]
	fmul.4s	v17, v17, v2
	stp	q16, q17, [x28]
	add	w26, w26, #16
	add	w24, w24, #48
	subs	x27, x27, #16
	b.ne	LBB3_69
; %bb.70:                               ;   in Loop: Header=BB3_60 Depth=1
	mov	x28, x14
	mov	x27, x14
	cmp	x13, #9
	b.lo	LBB3_65
LBB3_71:                                ;   in Loop: Header=BB3_60 Depth=1
	add	x24, x6, x28
	add	w26, w5, w28
	add	w27, w28, w28, lsl #1
	add	w27, w23, w27
LBB3_72:                                ;   Parent Loop BB3_60 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	add	x28, x25, w27, sxtw
	ld3.8b	{ v16, v17, v18 }, [x28]
	tbl.16b	v19, { v16 }, v4
	tbl.16b	v16, { v16 }, v5
	ucvtf.4s	v16, v16
	ucvtf.4s	v17, v19
	fadd.4s	v17, v17, v0
	fadd.4s	v16, v16, v0
	fmul.4s	v16, v16, v2
	fmul.4s	v17, v17, v2
	add	x28, x22, w26, sxtw #2
	stp	q16, q17, [x28]
	add	w26, w26, #8
	add	w27, w27, #24
	adds	x24, x24, #8
	b.ne	LBB3_72
; %bb.73:                               ;   in Loop: Header=BB3_60 Depth=1
	mov	x27, x15
	b	LBB3_65
LBB3_74:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp6:
Lloh6:
	adrp	x1, l_.str.1@PAGE
Lloh7:
	add	x1, x1, l_.str.1@PAGEOFF
	bl	__ZNSt16invalid_argumentC1B9nqe210106EPKc
Ltmp7:
; %bb.75:
	mov	x0, x19
	bl	__Z9referenceRKNSt3__16vectorIhNS_9allocatorIhEEEEiii.cold.1
LBB3_76:
	bl	__ZNSt3__16vectorIfNS_9allocatorIfEEE20__throw_length_errorB9nqe210106Ev
LBB3_77:
Ltmp8:
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x0, x20
	bl	__Unwind_Resume
	.loh AdrpAdd	Lloh6, Lloh7
Lfunc_end2:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table3:
Lexception2:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end2-Lcst_begin2
Lcst_begin2:
	.uleb128 Lfunc_begin2-Lfunc_begin2      ; >> Call Site 1 <<
	.uleb128 Ltmp6-Lfunc_begin2             ;   Call between Lfunc_begin2 and Ltmp6
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp6-Lfunc_begin2             ; >> Call Site 2 <<
	.uleb128 Ltmp7-Ltmp6                    ;   Call between Ltmp6 and Ltmp7
	.uleb128 Ltmp8-Lfunc_begin2             ;     jumps to Ltmp8
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp7-Lfunc_begin2             ; >> Call Site 3 <<
	.uleb128 Lfunc_end2-Ltmp7               ;   Call between Ltmp7 and Lfunc_end2
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end2:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__literal8,8byte_literals
	.p2align	3, 0x0                          ; -- Begin function main
lCPI4_0:
	.long	0                               ; 0x0
	.long	1                               ; 0x1
lCPI4_1:
	.byte	0                               ; 0x0
	.byte	10                              ; 0xa
	.byte	20                              ; 0x14
	.byte	30                              ; 0x1e
	.space	1
	.space	1
	.space	1
	.space	1
lCPI4_2:
	.long	9                               ; 0x9
	.long	641                             ; 0x281
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_main
	.p2align	2
_main:                                  ; @main
Lfunc_begin3:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception3
; %bb.0:
	sub	sp, sp, #304
	stp	d13, d12, [sp, #160]            ; 16-byte Folded Spill
	stp	d11, d10, [sp, #176]            ; 16-byte Folded Spill
	stp	d9, d8, [sp, #192]              ; 16-byte Folded Spill
	stp	x28, x27, [sp, #208]            ; 16-byte Folded Spill
	stp	x26, x25, [sp, #224]            ; 16-byte Folded Spill
	stp	x24, x23, [sp, #240]            ; 16-byte Folded Spill
	stp	x22, x21, [sp, #256]            ; 16-byte Folded Spill
	stp	x20, x19, [sp, #272]            ; 16-byte Folded Spill
	stp	x29, x30, [sp, #288]            ; 16-byte Folded Spill
	add	x29, sp, #288
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_offset w23, -56
	.cfi_offset w24, -64
	.cfi_offset w25, -72
	.cfi_offset w26, -80
	.cfi_offset w27, -88
	.cfi_offset w28, -96
	.cfi_offset b8, -104
	.cfi_offset b9, -112
	.cfi_offset b10, -120
	.cfi_offset b11, -128
	.cfi_offset b12, -136
	.cfi_offset b13, -144
	mov	x9, #0                          ; =0x0
Lloh8:
	adrp	x8, ___stack_chk_guard@GOTPAGE
Lloh9:
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
Lloh10:
	ldr	x8, [x8]
	str	x8, [sp, #144]
Lloh11:
	adrp	x8, lCPI4_0@PAGE
Lloh12:
	ldr	d8, [x8, lCPI4_0@PAGEOFF]
	add	x28, sp, #128
	mov	w26, #71                        ; =0x47
	b	LBB4_2
LBB4_1:                                 ;   in Loop: Header=BB4_2 Depth=1
	ldr	x9, [sp]                        ; 8-byte Folded Reload
	add	x9, x9, #4
	cmp	x9, #36
	b.eq	LBB4_72
LBB4_2:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB4_4 Depth 2
                                        ;       Child Loop BB4_8 Depth 3
                                        ;       Child Loop BB4_21 Depth 3
                                        ;       Child Loop BB4_26 Depth 3
                                        ;       Child Loop BB4_40 Depth 3
                                        ;       Child Loop BB4_53 Depth 3
                                        ;       Child Loop BB4_58 Depth 3
	mov	x27, #0                         ; =0x0
	str	x9, [sp]                        ; 8-byte Folded Spill
Lloh13:
	adrp	x8, l_constinit@PAGE
Lloh14:
	add	x8, x8, l_constinit@PAGEOFF
	ldrsw	x19, [x8, x9]
	str	d8, [sp, #128]
	mov	w8, #3                          ; =0x3
	str	w8, [sp, #136]
	add	x20, x19, x19, lsl #1
	add	w8, w20, #5
	sxtw	x22, w8
	b	LBB4_4
LBB4_3:                                 ;   in Loop: Header=BB4_4 Depth=2
	add	x27, x27, #4
	cmp	x27, #12
	b.eq	LBB4_1
LBB4_4:                                 ;   Parent Loop BB4_2 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB4_8 Depth 3
                                        ;       Child Loop BB4_21 Depth 3
                                        ;       Child Loop BB4_26 Depth 3
                                        ;       Child Loop BB4_40 Depth 3
                                        ;       Child Loop BB4_53 Depth 3
                                        ;       Child Loop BB4_58 Depth 3
	ldrsw	x23, [x28, x27]
	mul	x24, x20, x23
	stp	xzr, xzr, [sp, #104]
	str	xzr, [sp, #120]
	cbz	x24, LBB4_9
; %bb.5:                                ;   in Loop: Header=BB4_4 Depth=2
	tbnz	x24, #63, LBB4_70
; %bb.6:                                ;   in Loop: Header=BB4_4 Depth=2
Ltmp9:
	mov	x0, x24
	bl	__Znwm
Ltmp10:
; %bb.7:                                ;   in Loop: Header=BB4_4 Depth=2
	mov	x21, x0
	add	x25, x0, x24
	str	x0, [sp, #104]
	str	x25, [sp, #120]
	mov	x1, x24
	bl	_bzero
	mov	x8, #0                          ; =0x0
	str	x25, [sp, #112]
LBB4_8:                                 ;   Parent Loop BB4_2 Depth=1
                                        ;     Parent Loop BB4_4 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	mul	w9, w8, w26
	strb	w9, [x21, x8]
	add	x8, x8, #1
	ldp	x21, x9, [sp, #104]
	sub	x9, x9, x21
	cmp	x8, x9
	b.lo	LBB4_8
LBB4_9:                                 ;   in Loop: Header=BB4_4 Depth=2
Ltmp11:
	add	x8, sp, #80
	add	x0, sp, #104
	mov	x1, x19
	mov	x2, x23
	mov	x3, x20
	bl	__Z9referenceRKNSt3__16vectorIhNS_9allocatorIhEEEEiii
Ltmp12:
; %bb.10:                               ;   in Loop: Header=BB4_4 Depth=2
	ldp	x21, x8, [sp, #80]
	stp	xzr, xzr, [sp, #64]
	str	xzr, [sp, #56]
	subs	x24, x8, x21
	b.eq	LBB4_15
; %bb.11:                               ;   in Loop: Header=BB4_4 Depth=2
	tbnz	x24, #63, LBB4_71
; %bb.12:                               ;   in Loop: Header=BB4_4 Depth=2
Ltmp13:
	mov	x0, x24
	bl	__Znwm
Ltmp14:
; %bb.13:                               ;   in Loop: Header=BB4_4 Depth=2
	add	x25, x0, x24
	str	x0, [sp, #56]
	str	x25, [sp, #72]
	mov	x1, x24
	bl	_bzero
	str	x25, [sp, #64]
Ltmp15:
	mov	x0, x24
	bl	__Znwm
Ltmp16:
; %bb.14:                               ;   in Loop: Header=BB4_4 Depth=2
	add	x25, x0, x24
	str	x0, [sp, #32]
	str	x25, [sp, #48]
	mov	x1, x24
	bl	_bzero
	str	x25, [sp, #40]
	b	LBB4_16
LBB4_15:                                ;   in Loop: Header=BB4_4 Depth=2
	stp	xzr, xzr, [sp, #32]
	str	xzr, [sp, #48]
LBB4_16:                                ;   in Loop: Header=BB4_4 Depth=2
Ltmp17:
	add	x0, sp, #104
	add	x4, sp, #56
	mov	x1, x19
	mov	x2, x23
	mov	x3, x20
	bl	__Z7convertILb0EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp18:
; %bb.17:                               ;   in Loop: Header=BB4_4 Depth=2
Ltmp19:
	add	x0, sp, #104
	add	x4, sp, #32
	mov	x1, x19
	mov	x2, x23
	mov	x3, x20
	bl	__Z7convertILb1EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp20:
; %bb.18:                               ;   in Loop: Header=BB4_4 Depth=2
	ldp	x0, x8, [sp, #56]
	sub	x9, x8, x0
	cmp	x9, x24
	b.ne	LBB4_68
; %bb.19:                               ;   in Loop: Header=BB4_4 Depth=2
	cmp	x0, x8
	b.eq	LBB4_23
; %bb.20:                               ;   in Loop: Header=BB4_4 Depth=2
	mov	x9, x21
	mov	x10, x0
LBB4_21:                                ;   Parent Loop BB4_2 Depth=1
                                        ;     Parent Loop BB4_4 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	ldr	s0, [x10], #4
	ldr	s1, [x9], #4
	fcmp	s0, s1
	b.ne	LBB4_68
; %bb.22:                               ;   in Loop: Header=BB4_21 Depth=3
	cmp	x10, x8
	b.ne	LBB4_21
LBB4_23:                                ;   in Loop: Header=BB4_4 Depth=2
	ldp	x8, x9, [sp, #32]
	sub	x10, x9, x8
	cmp	x10, x24
	b.ne	LBB4_68
; %bb.24:                               ;   in Loop: Header=BB4_4 Depth=2
	cmp	x8, x9
	b.eq	LBB4_28
; %bb.25:                               ;   in Loop: Header=BB4_4 Depth=2
	mov	x10, x21
	mov	x11, x8
LBB4_26:                                ;   Parent Loop BB4_2 Depth=1
                                        ;     Parent Loop BB4_4 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	ldr	s0, [x11], #4
	ldr	s1, [x10], #4
	fcmp	s0, s1
	b.ne	LBB4_68
; %bb.27:                               ;   in Loop: Header=BB4_26 Depth=3
	cmp	x11, x9
	b.ne	LBB4_26
LBB4_28:                                ;   in Loop: Header=BB4_4 Depth=2
	cbz	x8, LBB4_30
; %bb.29:                               ;   in Loop: Header=BB4_4 Depth=2
	str	x8, [sp, #40]
	mov	x0, x8
	bl	__ZdlPv
	ldr	x0, [sp, #56]
LBB4_30:                                ;   in Loop: Header=BB4_4 Depth=2
	cbz	x0, LBB4_32
; %bb.31:                               ;   in Loop: Header=BB4_4 Depth=2
	str	x0, [sp, #64]
	bl	__ZdlPv
LBB4_32:                                ;   in Loop: Header=BB4_4 Depth=2
	cbz	x21, LBB4_34
; %bb.33:                               ;   in Loop: Header=BB4_4 Depth=2
	mov	x0, x21
	bl	__ZdlPv
LBB4_34:                                ;   in Loop: Header=BB4_4 Depth=2
	ldr	x0, [sp, #104]
	cbz	x0, LBB4_36
; %bb.35:                               ;   in Loop: Header=BB4_4 Depth=2
	str	x0, [sp, #112]
	bl	__ZdlPv
LBB4_36:                                ;   in Loop: Header=BB4_4 Depth=2
	smull	x24, w22, w23
	stp	xzr, xzr, [sp, #104]
	str	xzr, [sp, #120]
	cbz	x24, LBB4_41
; %bb.37:                               ;   in Loop: Header=BB4_4 Depth=2
	tbnz	x24, #63, LBB4_70
; %bb.38:                               ;   in Loop: Header=BB4_4 Depth=2
Ltmp21:
	mov	x0, x24
	bl	__Znwm
Ltmp22:
; %bb.39:                               ;   in Loop: Header=BB4_4 Depth=2
	mov	x21, x0
	add	x25, x0, x24
	str	x0, [sp, #104]
	str	x25, [sp, #120]
	mov	x1, x24
	bl	_bzero
	mov	x8, #0                          ; =0x0
	str	x25, [sp, #112]
LBB4_40:                                ;   Parent Loop BB4_2 Depth=1
                                        ;     Parent Loop BB4_4 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	mul	w9, w8, w26
	strb	w9, [x21, x8]
	add	x8, x8, #1
	ldp	x21, x9, [sp, #104]
	sub	x9, x9, x21
	cmp	x8, x9
	b.lo	LBB4_40
LBB4_41:                                ;   in Loop: Header=BB4_4 Depth=2
Ltmp27:
	add	x8, sp, #80
	add	x0, sp, #104
	mov	x1, x19
	mov	x2, x23
	mov	x3, x22
	bl	__Z9referenceRKNSt3__16vectorIhNS_9allocatorIhEEEEiii
Ltmp28:
; %bb.42:                               ;   in Loop: Header=BB4_4 Depth=2
	ldp	x21, x8, [sp, #80]
	stp	xzr, xzr, [sp, #64]
	str	xzr, [sp, #56]
	subs	x24, x8, x21
	b.eq	LBB4_47
; %bb.43:                               ;   in Loop: Header=BB4_4 Depth=2
	tbnz	x24, #63, LBB4_71
; %bb.44:                               ;   in Loop: Header=BB4_4 Depth=2
Ltmp30:
	mov	x0, x24
	bl	__Znwm
Ltmp31:
; %bb.45:                               ;   in Loop: Header=BB4_4 Depth=2
	add	x25, x0, x24
	str	x0, [sp, #56]
	str	x25, [sp, #72]
	mov	x1, x24
	bl	_bzero
	str	x25, [sp, #64]
Ltmp33:
	mov	x0, x24
	bl	__Znwm
Ltmp34:
; %bb.46:                               ;   in Loop: Header=BB4_4 Depth=2
	add	x25, x0, x24
	str	x0, [sp, #32]
	str	x25, [sp, #48]
	mov	x1, x24
	bl	_bzero
	str	x25, [sp, #40]
	b	LBB4_48
LBB4_47:                                ;   in Loop: Header=BB4_4 Depth=2
	stp	xzr, xzr, [sp, #32]
	str	xzr, [sp, #48]
LBB4_48:                                ;   in Loop: Header=BB4_4 Depth=2
Ltmp39:
	add	x0, sp, #104
	add	x4, sp, #56
	mov	x1, x19
	mov	x2, x23
	mov	x3, x22
	bl	__Z7convertILb0EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp40:
; %bb.49:                               ;   in Loop: Header=BB4_4 Depth=2
Ltmp41:
	add	x0, sp, #104
	add	x4, sp, #32
	mov	x1, x19
	mov	x2, x23
	mov	x3, x22
	bl	__Z7convertILb1EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp42:
; %bb.50:                               ;   in Loop: Header=BB4_4 Depth=2
	ldp	x0, x8, [sp, #56]
	sub	x9, x8, x0
	cmp	x9, x24
	b.ne	LBB4_68
; %bb.51:                               ;   in Loop: Header=BB4_4 Depth=2
	cmp	x0, x8
	b.eq	LBB4_55
; %bb.52:                               ;   in Loop: Header=BB4_4 Depth=2
	mov	x9, x21
	mov	x10, x0
LBB4_53:                                ;   Parent Loop BB4_2 Depth=1
                                        ;     Parent Loop BB4_4 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	ldr	s0, [x10], #4
	ldr	s1, [x9], #4
	fcmp	s0, s1
	b.ne	LBB4_68
; %bb.54:                               ;   in Loop: Header=BB4_53 Depth=3
	cmp	x10, x8
	b.ne	LBB4_53
LBB4_55:                                ;   in Loop: Header=BB4_4 Depth=2
	ldp	x8, x9, [sp, #32]
	sub	x10, x9, x8
	cmp	x10, x24
	b.ne	LBB4_68
; %bb.56:                               ;   in Loop: Header=BB4_4 Depth=2
	cmp	x8, x9
	b.eq	LBB4_60
; %bb.57:                               ;   in Loop: Header=BB4_4 Depth=2
	mov	x10, x21
	mov	x11, x8
LBB4_58:                                ;   Parent Loop BB4_2 Depth=1
                                        ;     Parent Loop BB4_4 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	ldr	s0, [x11], #4
	ldr	s1, [x10], #4
	fcmp	s0, s1
	b.ne	LBB4_68
; %bb.59:                               ;   in Loop: Header=BB4_58 Depth=3
	cmp	x11, x9
	b.ne	LBB4_58
LBB4_60:                                ;   in Loop: Header=BB4_4 Depth=2
	cbz	x8, LBB4_62
; %bb.61:                               ;   in Loop: Header=BB4_4 Depth=2
	str	x8, [sp, #40]
	mov	x0, x8
	bl	__ZdlPv
	ldr	x0, [sp, #56]
LBB4_62:                                ;   in Loop: Header=BB4_4 Depth=2
	cbz	x0, LBB4_64
; %bb.63:                               ;   in Loop: Header=BB4_4 Depth=2
	str	x0, [sp, #64]
	bl	__ZdlPv
LBB4_64:                                ;   in Loop: Header=BB4_4 Depth=2
	cbz	x21, LBB4_66
; %bb.65:                               ;   in Loop: Header=BB4_4 Depth=2
	mov	x0, x21
	bl	__ZdlPv
LBB4_66:                                ;   in Loop: Header=BB4_4 Depth=2
	ldr	x0, [sp, #104]
	cbz	x0, LBB4_3
; %bb.67:                               ;   in Loop: Header=BB4_4 Depth=2
	str	x0, [sp, #112]
	bl	__ZdlPv
	b	LBB4_3
LBB4_68:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x22, x0
Ltmp44:
Lloh15:
	adrp	x1, l_.str@PAGE
Lloh16:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp45:
; %bb.69:
Ltmp47:
Lloh17:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh18:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh19:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh20:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x22
	bl	___cxa_throw
Ltmp48:
	b	LBB4_356
LBB4_70:
Ltmp24:
	bl	__ZNSt3__16vectorIhNS_9allocatorIhEEE20__throw_length_errorB9nqe210106Ev
Ltmp25:
	b	LBB4_356
LBB4_71:
Ltmp36:
	bl	__ZNSt3__16vectorIfNS_9allocatorIfEEE20__throw_length_errorB9nqe210106Ev
Ltmp37:
	b	LBB4_356
LBB4_72:
Ltmp50:
	mov	w0, #3                          ; =0x3
	bl	__Znwm
Ltmp51:
; %bb.73:
	add	x8, x0, #3
	stp	x8, x8, [sp, #112]
	strh	wzr, [x0]
	strb	wzr, [x0, #2]
	mov	x21, x0
	str	x0, [sp, #104]
Ltmp53:
	add	x8, sp, #8
	add	x0, sp, #104
	mov	w1, #1                          ; =0x1
	mov	w2, #1                          ; =0x1
	mov	w3, #2                          ; =0x2
	bl	__Z9referenceRKNSt3__16vectorIhNS_9allocatorIhEEEEiii
Ltmp54:
; %bb.74:
	ldr	x0, [sp, #8]
	cbz	x0, LBB4_76
; %bb.75:
	str	x0, [sp, #16]
	bl	__ZdlPv
LBB4_76:
	mov	x0, x21
	bl	__ZdlPv
	mov	w22, #0                         ; =0x0
LBB4_77:
Ltmp58:
	mov	w0, #3                          ; =0x3
	bl	__Znwm
Ltmp59:
; %bb.78:
	mov	x21, x0
	add	x8, x0, #3
	stp	x8, x8, [sp, #112]
	strh	wzr, [x0]
	strb	wzr, [x0, #2]
	str	x0, [sp, #104]
Ltmp61:
	add	x8, sp, #8
	add	x0, sp, #104
	mov	w1, #1                          ; =0x1
	mov	w2, #1                          ; =0x1
	mov	w3, #4                          ; =0x4
	bl	__Z9referenceRKNSt3__16vectorIhNS_9allocatorIhEEEEiii
Ltmp62:
; %bb.79:
	ldr	x0, [sp, #8]
	cbz	x0, LBB4_81
; %bb.80:
	bl	__ZdlPv
LBB4_81:
	mov	x0, x21
	bl	__ZdlPv
LBB4_82:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x21, x0
Ltmp323:
Lloh21:
	adrp	x1, l_.str@PAGE
Lloh22:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp324:
; %bb.83:
Ltmp326:
Lloh23:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh24:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh25:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh26:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x21
	bl	___cxa_throw
Ltmp327:
	b	LBB4_356
LBB4_84:
Ltmp328:
	b	LBB4_425
LBB4_85:
Ltmp325:
	mov	x19, x1
	mov	x20, x0
	mov	x0, x21
	bl	___cxa_free_exception
	b	LBB4_439
LBB4_86:
Ltmp63:
	mov	x19, x1
	mov	x20, x0
	mov	x0, x21
	bl	__ZdlPv
	b	LBB4_88
LBB4_87:
Ltmp60:
	mov	x19, x1
	mov	x20, x0
LBB4_88:
	cmp	w19, #2
	b.ne	LBB4_439
; %bb.89:
	mov	x0, x20
	bl	___cxa_begin_catch
Ltmp64:
	bl	___cxa_end_catch
Ltmp65:
; %bb.90:
	tbz	w22, #0, LBB4_82
; %bb.91:
Ltmp67:
	mov	w0, #6                          ; =0x6
	bl	__Znwm
Ltmp68:
; %bb.92:
	mov	x21, x0
	add	x8, x0, #6
	stp	x8, x8, [sp, #112]
Lloh27:
	adrp	x9, lCPI4_1@PAGE
Lloh28:
	ldr	d0, [x9, lCPI4_1@PAGEOFF]
	str	s0, [x0]
	mov	w9, #12840                      ; =0x3228
	strh	w9, [x0, #4]
	str	x0, [sp, #104]
Ltmp70:
	add	x8, sp, #80
	add	x0, sp, #104
	mov	w1, #2                          ; =0x2
	mov	w2, #1                          ; =0x1
	mov	w3, #6                          ; =0x6
	bl	__Z9referenceRKNSt3__16vectorIhNS_9allocatorIhEEEEiii
Ltmp71:
; %bb.93:
	mov	x0, x21
	bl	__ZdlPv
Ltmp73:
Lloh29:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh30:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh31:
	adrp	x1, l_.str.2@PAGE
Lloh32:
	add	x1, x1, l_.str.2@PAGEOFF
	mov	w2, #9                          ; =0x9
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp74:
; %bb.94:
	ldp	x20, x21, [sp, #80]
	cmp	x20, x21
	b.eq	LBB4_99
; %bb.95:
	mov	w22, #32                        ; =0x20
Lloh33:
	adrp	x19, __ZNSt3__14coutE@GOTPAGE
Lloh34:
	ldr	x19, [x19, __ZNSt3__14coutE@GOTPAGEOFF]
LBB4_96:                                ; =>This Inner Loop Header: Depth=1
	ldr	s8, [x20], #4
	strb	w22, [sp, #104]
Ltmp75:
	add	x1, sp, #104
	mov	x0, x19
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp76:
; %bb.97:                               ;   in Loop: Header=BB4_96 Depth=1
Ltmp77:
	mov.16b	v0, v8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEf
Ltmp78:
; %bb.98:                               ;   in Loop: Header=BB4_96 Depth=1
	cmp	x20, x21
	b.ne	LBB4_96
LBB4_99:
Ltmp80:
Lloh35:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh36:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh37:
	adrp	x1, l_.str.3@PAGE
Lloh38:
	add	x1, x1, l_.str.3@PAGEOFF
	mov	w2, #13                         ; =0xd
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp81:
; %bb.100:
Ltmp82:
	mov	w1, #54                         ; =0x36
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEi
Ltmp83:
; %bb.101:
Ltmp84:
Lloh39:
	adrp	x1, l_.str.4@PAGE
Lloh40:
	add	x1, x1, l_.str.4@PAGEOFF
	mov	w2, #30                         ; =0x1e
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp85:
; %bb.102:
	mov	x21, #0                         ; =0x0
Lloh41:
	adrp	x8, lCPI4_2@PAGE
Lloh42:
	ldr	d0, [x8, lCPI4_2@PAGEOFF]
	str	d0, [sp, #128]
	fmov	d12, #5.00000000
	b	LBB4_104
LBB4_103:                               ;   in Loop: Header=BB4_104 Depth=1
	add	x21, x21, #4
	cmp	x21, #8
	b.eq	LBB4_337
LBB4_104:                               ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB4_119 Depth 2
                                        ;     Child Loop BB4_139 Depth 2
                                        ;     Child Loop BB4_189 Depth 2
                                        ;     Child Loop BB4_269 Depth 2
                                        ;     Child Loop BB4_316 Depth 2
	add	x8, sp, #128
	ldrsw	x27, [x8, x21]
	cmp	w27, #9
	mov	w8, #480                        ; =0x1e0
	mov	w9, #3                          ; =0x3
	csel	w26, w9, w8, eq
	add	x8, x27, x27, lsl #1
	stp	xzr, xzr, [sp, #56]
	str	xzr, [sp, #72]
	add	x28, x8, #5
	cbz	w28, LBB4_108
; %bb.105:                              ;   in Loop: Header=BB4_104 Depth=1
	mul	x19, x26, x28
	tbnz	x19, #63, LBB4_354
; %bb.106:                              ;   in Loop: Header=BB4_104 Depth=1
Ltmp87:
	mov	x0, x19
	bl	__Znwm
Ltmp88:
; %bb.107:                              ;   in Loop: Header=BB4_104 Depth=1
	add	x20, x0, x19
	str	x0, [sp, #56]
	str	x20, [sp, #72]
	mov	w1, #97                         ; =0x61
	mov	x2, x19
	bl	_memset
	str	x20, [sp, #64]
LBB4_108:                               ;   in Loop: Header=BB4_104 Depth=1
	stp	xzr, xzr, [sp, #32]
	str	xzr, [sp, #48]
	cbz	w27, LBB4_112
; %bb.109:                              ;   in Loop: Header=BB4_104 Depth=1
	smull	x8, w26, w27
	add	x20, x8, x8, lsl #1
	lsr	x8, x20, #62
	cbnz	x8, LBB4_355
; %bb.110:                              ;   in Loop: Header=BB4_104 Depth=1
	lsl	x19, x20, #2
Ltmp93:
	mov	x0, x19
	bl	__Znwm
Ltmp94:
; %bb.111:                              ;   in Loop: Header=BB4_104 Depth=1
	add	x8, x0, x20, lsl #2
	str	x0, [sp, #32]
	str	x8, [sp, #48]
	add	x20, x0, x19
	mov	x1, x19
	bl	_bzero
	str	x20, [sp, #40]
LBB4_112:                               ;   in Loop: Header=BB4_104 Depth=1
Ltmp99:
	str	x21, [sp]                       ; 8-byte Folded Spill
	add	x0, sp, #56
	add	x4, sp, #32
	mov	x1, x27
	mov	x2, x26
	mov	x3, x28
	bl	__Z7convertILb0EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp100:
; %bb.113:                              ;   in Loop: Header=BB4_104 Depth=1
Ltmp101:
	add	x0, sp, #56
	add	x4, sp, #32
	mov	x1, x27
	mov	x2, x26
	mov	x3, x28
	bl	__Z7convertILb0EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp102:
; %bb.114:                              ;   in Loop: Header=BB4_104 Depth=1
Ltmp103:
	add	x0, sp, #56
	add	x4, sp, #32
	mov	x1, x27
	mov	x2, x26
	mov	x3, x28
	bl	__Z7convertILb0EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp104:
; %bb.115:                              ;   in Loop: Header=BB4_104 Depth=1
Ltmp105:
	add	x0, sp, #56
	add	x4, sp, #32
	mov	x1, x27
	mov	x2, x26
	mov	x3, x28
	bl	__Z7convertILb0EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp106:
; %bb.116:                              ;   in Loop: Header=BB4_104 Depth=1
Ltmp107:
	add	x0, sp, #56
	add	x4, sp, #32
	mov	x1, x27
	mov	x2, x26
	mov	x3, x28
	bl	__Z7convertILb0EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp108:
; %bb.117:                              ;   in Loop: Header=BB4_104 Depth=1
	mov	x21, #0                         ; =0x0
	mov	x19, #0                         ; =0x0
	mov	x25, #0                         ; =0x0
	mov	w23, #31                        ; =0x1f
	b	LBB4_119
LBB4_118:                               ;   in Loop: Header=BB4_119 Depth=2
	str	d8, [x19], #8
	subs	w23, w23, #1
	b.eq	LBB4_131
LBB4_119:                               ;   Parent Loop BB4_104 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x20, x0
Ltmp110:
	add	x0, sp, #56
	add	x4, sp, #32
	mov	x1, x27
	mov	x2, x26
	mov	x3, x28
	bl	__Z7convertILb0EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp111:
; %bb.120:                              ;   in Loop: Header=BB4_119 Depth=2
	; InlineAsm Start
	; InlineAsm End
Ltmp112:
	add	x0, sp, #56
	add	x4, sp, #32
	mov	x1, x27
	mov	x2, x26
	mov	x3, x28
	bl	__Z7convertILb0EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp113:
; %bb.121:                              ;   in Loop: Header=BB4_119 Depth=2
	; InlineAsm Start
	; InlineAsm End
Ltmp114:
	add	x0, sp, #56
	add	x4, sp, #32
	mov	x1, x27
	mov	x2, x26
	mov	x3, x28
	bl	__Z7convertILb0EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp115:
; %bb.122:                              ;   in Loop: Header=BB4_119 Depth=2
	; InlineAsm Start
	; InlineAsm End
Ltmp116:
	add	x0, sp, #56
	add	x4, sp, #32
	mov	x1, x27
	mov	x2, x26
	mov	x3, x28
	bl	__Z7convertILb0EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp117:
; %bb.123:                              ;   in Loop: Header=BB4_119 Depth=2
	; InlineAsm Start
	; InlineAsm End
Ltmp118:
	add	x0, sp, #56
	add	x4, sp, #32
	mov	x1, x27
	mov	x2, x26
	mov	x3, x28
	bl	__Z7convertILb0EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp119:
; %bb.124:                              ;   in Loop: Header=BB4_119 Depth=2
	; InlineAsm Start
	; InlineAsm End
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	sub	x8, x0, x20
	scvtf	d0, x8
	mov	x8, #70368744177664             ; =0x400000000000
	movk	x8, #16527, lsl #48
	fmov	d1, x8
	fdiv	d0, d0, d1
	fdiv	d8, d0, d12
	cmp	x19, x25
	b.lo	LBB4_118
; %bb.125:                              ;   in Loop: Header=BB4_119 Depth=2
	sub	x20, x19, x21
	asr	x22, x20, #3
	add	x8, x22, #1
	lsr	x9, x8, #61
	cbnz	x9, LBB4_344
; %bb.126:                              ;   in Loop: Header=BB4_119 Depth=2
	sub	x9, x25, x21
	asr	x10, x9, #2
	cmp	x10, x8
	csel	x8, x10, x8, hi
	mov	x10, #9223372036854775800       ; =0x7ffffffffffffff8
	cmp	x9, x10
	mov	x9, #2305843009213693951        ; =0x1fffffffffffffff
	csel	x25, x8, x9, lo
	lsr	x8, x25, #61
	cbnz	x8, LBB4_345
; %bb.127:                              ;   in Loop: Header=BB4_119 Depth=2
	lsl	x0, x25, #3
Ltmp121:
	bl	__Znwm
Ltmp122:
; %bb.128:                              ;   in Loop: Header=BB4_119 Depth=2
	add	x19, x0, x20
	add	x25, x0, x25, lsl #3
	sub	x22, x19, x22, lsl #3
	str	d8, [x19], #8
	mov	x0, x22
	mov	x1, x21
	mov	x2, x20
	bl	_memcpy
	cbz	x21, LBB4_130
; %bb.129:                              ;   in Loop: Header=BB4_119 Depth=2
	mov	x0, x21
	bl	__ZdlPv
LBB4_130:                               ;   in Loop: Header=BB4_119 Depth=2
	mov	x21, x22
	subs	w23, w23, #1
	b.ne	LBB4_119
LBB4_131:                               ;   in Loop: Header=BB4_104 Depth=1
Ltmp129:
	add	x2, sp, #104
	mov	x0, x21
	mov	x1, x19
	bl	__ZNSt3__16__sortIRNS_6__lessIddEEPdEEvT0_S5_T_
Ltmp130:
; %bb.132:                              ;   in Loop: Header=BB4_104 Depth=1
	ldr	d8, [x21, #120]
	mov	x0, x21
	bl	__ZdlPv
Ltmp132:
	add	x0, sp, #56
	add	x4, sp, #32
	mov	x1, x27
	mov	x2, x26
	mov	x3, x28
	bl	__Z7convertILb1EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp133:
; %bb.133:                              ;   in Loop: Header=BB4_104 Depth=1
Ltmp134:
	add	x0, sp, #56
	add	x4, sp, #32
	mov	x1, x27
	mov	x2, x26
	mov	x3, x28
	bl	__Z7convertILb1EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp135:
; %bb.134:                              ;   in Loop: Header=BB4_104 Depth=1
Ltmp136:
	add	x0, sp, #56
	add	x4, sp, #32
	mov	x1, x27
	mov	x2, x26
	mov	x3, x28
	bl	__Z7convertILb1EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp137:
; %bb.135:                              ;   in Loop: Header=BB4_104 Depth=1
Ltmp138:
	add	x0, sp, #56
	add	x4, sp, #32
	mov	x1, x27
	mov	x2, x26
	mov	x3, x28
	bl	__Z7convertILb1EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp139:
; %bb.136:                              ;   in Loop: Header=BB4_104 Depth=1
Ltmp140:
	add	x0, sp, #56
	add	x4, sp, #32
	mov	x1, x27
	mov	x2, x26
	mov	x3, x28
	bl	__Z7convertILb1EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp141:
; %bb.137:                              ;   in Loop: Header=BB4_104 Depth=1
	mov	x21, #0                         ; =0x0
	mov	x19, #0                         ; =0x0
	mov	x25, #0                         ; =0x0
	mov	w23, #31                        ; =0x1f
	b	LBB4_139
LBB4_138:                               ;   in Loop: Header=BB4_139 Depth=2
	str	d9, [x19], #8
	subs	w23, w23, #1
	b.eq	LBB4_151
LBB4_139:                               ;   Parent Loop BB4_104 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x20, x0
Ltmp143:
	add	x0, sp, #56
	add	x4, sp, #32
	mov	x1, x27
	mov	x2, x26
	mov	x3, x28
	bl	__Z7convertILb1EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp144:
; %bb.140:                              ;   in Loop: Header=BB4_139 Depth=2
	; InlineAsm Start
	; InlineAsm End
Ltmp145:
	add	x0, sp, #56
	add	x4, sp, #32
	mov	x1, x27
	mov	x2, x26
	mov	x3, x28
	bl	__Z7convertILb1EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp146:
; %bb.141:                              ;   in Loop: Header=BB4_139 Depth=2
	; InlineAsm Start
	; InlineAsm End
Ltmp147:
	add	x0, sp, #56
	add	x4, sp, #32
	mov	x1, x27
	mov	x2, x26
	mov	x3, x28
	bl	__Z7convertILb1EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp148:
; %bb.142:                              ;   in Loop: Header=BB4_139 Depth=2
	; InlineAsm Start
	; InlineAsm End
Ltmp149:
	add	x0, sp, #56
	add	x4, sp, #32
	mov	x1, x27
	mov	x2, x26
	mov	x3, x28
	bl	__Z7convertILb1EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp150:
; %bb.143:                              ;   in Loop: Header=BB4_139 Depth=2
	; InlineAsm Start
	; InlineAsm End
Ltmp151:
	add	x0, sp, #56
	add	x4, sp, #32
	mov	x1, x27
	mov	x2, x26
	mov	x3, x28
	bl	__Z7convertILb1EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp152:
; %bb.144:                              ;   in Loop: Header=BB4_139 Depth=2
	; InlineAsm Start
	; InlineAsm End
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	sub	x8, x0, x20
	scvtf	d0, x8
	mov	x8, #70368744177664             ; =0x400000000000
	movk	x8, #16527, lsl #48
	fmov	d1, x8
	fdiv	d0, d0, d1
	fdiv	d9, d0, d12
	cmp	x19, x25
	b.lo	LBB4_138
; %bb.145:                              ;   in Loop: Header=BB4_139 Depth=2
	sub	x20, x19, x21
	asr	x22, x20, #3
	add	x8, x22, #1
	lsr	x9, x8, #61
	cbnz	x9, LBB4_346
; %bb.146:                              ;   in Loop: Header=BB4_139 Depth=2
	sub	x9, x25, x21
	asr	x10, x9, #2
	cmp	x10, x8
	csel	x8, x10, x8, hi
	mov	x10, #9223372036854775800       ; =0x7ffffffffffffff8
	cmp	x9, x10
	mov	x9, #2305843009213693951        ; =0x1fffffffffffffff
	csel	x25, x8, x9, lo
	lsr	x8, x25, #61
	cbnz	x8, LBB4_347
; %bb.147:                              ;   in Loop: Header=BB4_139 Depth=2
	lsl	x0, x25, #3
Ltmp154:
	bl	__Znwm
Ltmp155:
; %bb.148:                              ;   in Loop: Header=BB4_139 Depth=2
	add	x19, x0, x20
	add	x25, x0, x25, lsl #3
	sub	x22, x19, x22, lsl #3
	str	d9, [x19], #8
	mov	x0, x22
	mov	x1, x21
	mov	x2, x20
	bl	_memcpy
	cbz	x21, LBB4_150
; %bb.149:                              ;   in Loop: Header=BB4_139 Depth=2
	mov	x0, x21
	bl	__ZdlPv
LBB4_150:                               ;   in Loop: Header=BB4_139 Depth=2
	mov	x21, x22
	subs	w23, w23, #1
	b.ne	LBB4_139
LBB4_151:                               ;   in Loop: Header=BB4_104 Depth=1
Ltmp162:
	add	x2, sp, #104
	mov	x0, x21
	mov	x1, x19
	bl	__ZNSt3__16__sortIRNS_6__lessIddEEPdEEvT0_S5_T_
Ltmp163:
; %bb.152:                              ;   in Loop: Header=BB4_104 Depth=1
	ldr	d9, [x21, #120]
	mov	x0, x21
	bl	__ZdlPv
	ldp	x9, x8, [sp, #32]
	stp	xzr, xzr, [sp, #112]
	str	xzr, [sp, #104]
	subs	x19, x8, x9
	b.eq	LBB4_156
; %bb.153:                              ;   in Loop: Header=BB4_104 Depth=1
	tbnz	x19, #63, LBB4_352
; %bb.154:                              ;   in Loop: Header=BB4_104 Depth=1
Ltmp165:
	mov	x0, x19
	bl	__Znwm
Ltmp166:
; %bb.155:                              ;   in Loop: Header=BB4_104 Depth=1
	add	x20, x0, x19
	str	x0, [sp, #104]
	str	x20, [sp, #120]
	mov	x1, x19
	bl	_bzero
	str	x20, [sp, #112]
LBB4_156:                               ;   in Loop: Header=BB4_104 Depth=1
Ltmp167:
	add	x0, sp, #56
	add	x4, sp, #104
	mov	x1, x27
	mov	x2, x26
	mov	x3, x28
	bl	__Z7convertILb0EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp168:
; %bb.157:                              ;   in Loop: Header=BB4_104 Depth=1
	ldr	x8, [sp, #104]
	; InlineAsm Start
	; InlineAsm End
	ldr	x0, [sp, #104]
	cbz	x0, LBB4_159
; %bb.158:                              ;   in Loop: Header=BB4_104 Depth=1
	str	x0, [sp, #112]
	bl	__ZdlPv
LBB4_159:                               ;   in Loop: Header=BB4_104 Depth=1
	ldp	x9, x8, [sp, #32]
	stp	xzr, xzr, [sp, #112]
	str	xzr, [sp, #104]
	subs	x19, x8, x9
	b.eq	LBB4_163
; %bb.160:                              ;   in Loop: Header=BB4_104 Depth=1
	tbnz	x19, #63, LBB4_352
; %bb.161:                              ;   in Loop: Header=BB4_104 Depth=1
Ltmp169:
	mov	x0, x19
	bl	__Znwm
Ltmp170:
; %bb.162:                              ;   in Loop: Header=BB4_104 Depth=1
	add	x20, x0, x19
	str	x0, [sp, #104]
	str	x20, [sp, #120]
	mov	x1, x19
	bl	_bzero
	str	x20, [sp, #112]
LBB4_163:                               ;   in Loop: Header=BB4_104 Depth=1
Ltmp171:
	add	x0, sp, #56
	add	x4, sp, #104
	mov	x1, x27
	mov	x2, x26
	mov	x3, x28
	bl	__Z7convertILb0EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp172:
; %bb.164:                              ;   in Loop: Header=BB4_104 Depth=1
	ldr	x8, [sp, #104]
	; InlineAsm Start
	; InlineAsm End
	ldr	x0, [sp, #104]
	cbz	x0, LBB4_166
; %bb.165:                              ;   in Loop: Header=BB4_104 Depth=1
	str	x0, [sp, #112]
	bl	__ZdlPv
LBB4_166:                               ;   in Loop: Header=BB4_104 Depth=1
	ldp	x9, x8, [sp, #32]
	stp	xzr, xzr, [sp, #112]
	str	xzr, [sp, #104]
	subs	x19, x8, x9
	b.eq	LBB4_170
; %bb.167:                              ;   in Loop: Header=BB4_104 Depth=1
	tbnz	x19, #63, LBB4_352
; %bb.168:                              ;   in Loop: Header=BB4_104 Depth=1
Ltmp173:
	mov	x0, x19
	bl	__Znwm
Ltmp174:
; %bb.169:                              ;   in Loop: Header=BB4_104 Depth=1
	add	x20, x0, x19
	str	x0, [sp, #104]
	str	x20, [sp, #120]
	mov	x1, x19
	bl	_bzero
	str	x20, [sp, #112]
LBB4_170:                               ;   in Loop: Header=BB4_104 Depth=1
Ltmp175:
	add	x0, sp, #56
	add	x4, sp, #104
	mov	x1, x27
	mov	x2, x26
	mov	x3, x28
	bl	__Z7convertILb0EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp176:
; %bb.171:                              ;   in Loop: Header=BB4_104 Depth=1
	ldr	x8, [sp, #104]
	; InlineAsm Start
	; InlineAsm End
	ldr	x0, [sp, #104]
	cbz	x0, LBB4_173
; %bb.172:                              ;   in Loop: Header=BB4_104 Depth=1
	str	x0, [sp, #112]
	bl	__ZdlPv
LBB4_173:                               ;   in Loop: Header=BB4_104 Depth=1
	ldp	x9, x8, [sp, #32]
	stp	xzr, xzr, [sp, #112]
	str	xzr, [sp, #104]
	subs	x19, x8, x9
	b.eq	LBB4_177
; %bb.174:                              ;   in Loop: Header=BB4_104 Depth=1
	tbnz	x19, #63, LBB4_352
; %bb.175:                              ;   in Loop: Header=BB4_104 Depth=1
Ltmp177:
	mov	x0, x19
	bl	__Znwm
Ltmp178:
; %bb.176:                              ;   in Loop: Header=BB4_104 Depth=1
	add	x20, x0, x19
	str	x0, [sp, #104]
	str	x20, [sp, #120]
	mov	x1, x19
	bl	_bzero
	str	x20, [sp, #112]
LBB4_177:                               ;   in Loop: Header=BB4_104 Depth=1
Ltmp179:
	add	x0, sp, #56
	add	x4, sp, #104
	mov	x1, x27
	mov	x2, x26
	mov	x3, x28
	bl	__Z7convertILb0EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp180:
; %bb.178:                              ;   in Loop: Header=BB4_104 Depth=1
	ldr	x8, [sp, #104]
	; InlineAsm Start
	; InlineAsm End
	ldr	x0, [sp, #104]
	cbz	x0, LBB4_180
; %bb.179:                              ;   in Loop: Header=BB4_104 Depth=1
	str	x0, [sp, #112]
	bl	__ZdlPv
LBB4_180:                               ;   in Loop: Header=BB4_104 Depth=1
	ldp	x9, x8, [sp, #32]
	stp	xzr, xzr, [sp, #112]
	str	xzr, [sp, #104]
	subs	x19, x8, x9
	b.eq	LBB4_184
; %bb.181:                              ;   in Loop: Header=BB4_104 Depth=1
	tbnz	x19, #63, LBB4_352
; %bb.182:                              ;   in Loop: Header=BB4_104 Depth=1
Ltmp181:
	mov	x0, x19
	bl	__Znwm
Ltmp182:
; %bb.183:                              ;   in Loop: Header=BB4_104 Depth=1
	add	x20, x0, x19
	str	x0, [sp, #104]
	str	x20, [sp, #120]
	mov	x1, x19
	bl	_bzero
	str	x20, [sp, #112]
LBB4_184:                               ;   in Loop: Header=BB4_104 Depth=1
Ltmp187:
	add	x0, sp, #56
	add	x4, sp, #104
	mov	x1, x27
	mov	x2, x26
	mov	x3, x28
	bl	__Z7convertILb0EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp188:
; %bb.185:                              ;   in Loop: Header=BB4_104 Depth=1
	ldr	x8, [sp, #104]
	; InlineAsm Start
	; InlineAsm End
	ldr	x0, [sp, #104]
	cbz	x0, LBB4_187
; %bb.186:                              ;   in Loop: Header=BB4_104 Depth=1
	str	x0, [sp, #112]
	bl	__ZdlPv
LBB4_187:                               ;   in Loop: Header=BB4_104 Depth=1
	mov	x21, #0                         ; =0x0
	mov	x20, #0                         ; =0x0
	mov	x23, #0                         ; =0x0
	mov	w25, #31                        ; =0x1f
	b	LBB4_189
LBB4_188:                               ;   in Loop: Header=BB4_189 Depth=2
	str	d10, [x20], #8
	subs	w25, w25, #1
	b.eq	LBB4_231
LBB4_189:                               ;   Parent Loop BB4_104 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x19, x0
	ldp	x9, x8, [sp, #32]
	stp	xzr, xzr, [sp, #112]
	str	xzr, [sp, #104]
	subs	x22, x8, x9
	b.eq	LBB4_193
; %bb.190:                              ;   in Loop: Header=BB4_189 Depth=2
	tbnz	x22, #63, LBB4_340
; %bb.191:                              ;   in Loop: Header=BB4_189 Depth=2
Ltmp190:
	mov	x0, x22
	bl	__Znwm
Ltmp191:
; %bb.192:                              ;   in Loop: Header=BB4_189 Depth=2
	add	x24, x0, x22
	str	x0, [sp, #104]
	str	x24, [sp, #120]
	mov	x1, x22
	bl	_bzero
	str	x24, [sp, #112]
LBB4_193:                               ;   in Loop: Header=BB4_189 Depth=2
Ltmp192:
	add	x0, sp, #56
	add	x4, sp, #104
	mov	x1, x27
	mov	x2, x26
	mov	x3, x28
	bl	__Z7convertILb0EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp193:
; %bb.194:                              ;   in Loop: Header=BB4_189 Depth=2
	ldr	x8, [sp, #104]
	; InlineAsm Start
	; InlineAsm End
	ldr	x0, [sp, #104]
	cbz	x0, LBB4_196
; %bb.195:                              ;   in Loop: Header=BB4_189 Depth=2
	str	x0, [sp, #112]
	bl	__ZdlPv
LBB4_196:                               ;   in Loop: Header=BB4_189 Depth=2
	; InlineAsm Start
	; InlineAsm End
	ldp	x9, x8, [sp, #32]
	stp	xzr, xzr, [sp, #112]
	str	xzr, [sp, #104]
	subs	x22, x8, x9
	b.eq	LBB4_200
; %bb.197:                              ;   in Loop: Header=BB4_189 Depth=2
	tbnz	x22, #63, LBB4_340
; %bb.198:                              ;   in Loop: Header=BB4_189 Depth=2
Ltmp194:
	mov	x0, x22
	bl	__Znwm
Ltmp195:
; %bb.199:                              ;   in Loop: Header=BB4_189 Depth=2
	add	x24, x0, x22
	str	x0, [sp, #104]
	str	x24, [sp, #120]
	mov	x1, x22
	bl	_bzero
	str	x24, [sp, #112]
LBB4_200:                               ;   in Loop: Header=BB4_189 Depth=2
Ltmp196:
	add	x0, sp, #56
	add	x4, sp, #104
	mov	x1, x27
	mov	x2, x26
	mov	x3, x28
	bl	__Z7convertILb0EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp197:
; %bb.201:                              ;   in Loop: Header=BB4_189 Depth=2
	ldr	x8, [sp, #104]
	; InlineAsm Start
	; InlineAsm End
	ldr	x0, [sp, #104]
	cbz	x0, LBB4_203
; %bb.202:                              ;   in Loop: Header=BB4_189 Depth=2
	str	x0, [sp, #112]
	bl	__ZdlPv
LBB4_203:                               ;   in Loop: Header=BB4_189 Depth=2
	; InlineAsm Start
	; InlineAsm End
	ldp	x9, x8, [sp, #32]
	stp	xzr, xzr, [sp, #112]
	str	xzr, [sp, #104]
	subs	x22, x8, x9
	b.eq	LBB4_207
; %bb.204:                              ;   in Loop: Header=BB4_189 Depth=2
	tbnz	x22, #63, LBB4_340
; %bb.205:                              ;   in Loop: Header=BB4_189 Depth=2
Ltmp198:
	mov	x0, x22
	bl	__Znwm
Ltmp199:
; %bb.206:                              ;   in Loop: Header=BB4_189 Depth=2
	add	x24, x0, x22
	str	x0, [sp, #104]
	str	x24, [sp, #120]
	mov	x1, x22
	bl	_bzero
	str	x24, [sp, #112]
LBB4_207:                               ;   in Loop: Header=BB4_189 Depth=2
Ltmp200:
	add	x0, sp, #56
	add	x4, sp, #104
	mov	x1, x27
	mov	x2, x26
	mov	x3, x28
	bl	__Z7convertILb0EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp201:
; %bb.208:                              ;   in Loop: Header=BB4_189 Depth=2
	ldr	x8, [sp, #104]
	; InlineAsm Start
	; InlineAsm End
	ldr	x0, [sp, #104]
	cbz	x0, LBB4_210
; %bb.209:                              ;   in Loop: Header=BB4_189 Depth=2
	str	x0, [sp, #112]
	bl	__ZdlPv
LBB4_210:                               ;   in Loop: Header=BB4_189 Depth=2
	; InlineAsm Start
	; InlineAsm End
	ldp	x9, x8, [sp, #32]
	stp	xzr, xzr, [sp, #112]
	str	xzr, [sp, #104]
	subs	x22, x8, x9
	b.eq	LBB4_214
; %bb.211:                              ;   in Loop: Header=BB4_189 Depth=2
	tbnz	x22, #63, LBB4_340
; %bb.212:                              ;   in Loop: Header=BB4_189 Depth=2
Ltmp202:
	mov	x0, x22
	bl	__Znwm
Ltmp203:
; %bb.213:                              ;   in Loop: Header=BB4_189 Depth=2
	add	x24, x0, x22
	str	x0, [sp, #104]
	str	x24, [sp, #120]
	mov	x1, x22
	bl	_bzero
	str	x24, [sp, #112]
LBB4_214:                               ;   in Loop: Header=BB4_189 Depth=2
Ltmp204:
	add	x0, sp, #56
	add	x4, sp, #104
	mov	x1, x27
	mov	x2, x26
	mov	x3, x28
	bl	__Z7convertILb0EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp205:
; %bb.215:                              ;   in Loop: Header=BB4_189 Depth=2
	ldr	x8, [sp, #104]
	; InlineAsm Start
	; InlineAsm End
	ldr	x0, [sp, #104]
	cbz	x0, LBB4_217
; %bb.216:                              ;   in Loop: Header=BB4_189 Depth=2
	str	x0, [sp, #112]
	bl	__ZdlPv
LBB4_217:                               ;   in Loop: Header=BB4_189 Depth=2
	; InlineAsm Start
	; InlineAsm End
	ldp	x9, x8, [sp, #32]
	stp	xzr, xzr, [sp, #112]
	str	xzr, [sp, #104]
	subs	x22, x8, x9
	b.eq	LBB4_221
; %bb.218:                              ;   in Loop: Header=BB4_189 Depth=2
	tbnz	x22, #63, LBB4_340
; %bb.219:                              ;   in Loop: Header=BB4_189 Depth=2
Ltmp206:
	mov	x0, x22
	bl	__Znwm
Ltmp207:
; %bb.220:                              ;   in Loop: Header=BB4_189 Depth=2
	add	x24, x0, x22
	str	x0, [sp, #104]
	str	x24, [sp, #120]
	mov	x1, x22
	bl	_bzero
	str	x24, [sp, #112]
LBB4_221:                               ;   in Loop: Header=BB4_189 Depth=2
Ltmp212:
	add	x0, sp, #56
	add	x4, sp, #104
	mov	x1, x27
	mov	x2, x26
	mov	x3, x28
	bl	__Z7convertILb0EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp213:
; %bb.222:                              ;   in Loop: Header=BB4_189 Depth=2
	ldr	x8, [sp, #104]
	; InlineAsm Start
	; InlineAsm End
	ldr	x0, [sp, #104]
	cbz	x0, LBB4_224
; %bb.223:                              ;   in Loop: Header=BB4_189 Depth=2
	str	x0, [sp, #112]
	bl	__ZdlPv
LBB4_224:                               ;   in Loop: Header=BB4_189 Depth=2
	; InlineAsm Start
	; InlineAsm End
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	sub	x8, x0, x19
	scvtf	d0, x8
	mov	x8, #70368744177664             ; =0x400000000000
	movk	x8, #16527, lsl #48
	fmov	d1, x8
	fdiv	d0, d0, d1
	fdiv	d10, d0, d12
	cmp	x20, x23
	b.lo	LBB4_188
; %bb.225:                              ;   in Loop: Header=BB4_189 Depth=2
	sub	x19, x20, x21
	asr	x22, x19, #3
	add	x8, x22, #1
	lsr	x9, x8, #61
	cbnz	x9, LBB4_348
; %bb.226:                              ;   in Loop: Header=BB4_189 Depth=2
	sub	x9, x23, x21
	asr	x10, x9, #2
	cmp	x10, x8
	csel	x8, x10, x8, hi
	mov	x10, #9223372036854775800       ; =0x7ffffffffffffff8
	cmp	x9, x10
	mov	x9, #2305843009213693951        ; =0x1fffffffffffffff
	csel	x23, x8, x9, lo
	lsr	x8, x23, #61
	cbnz	x8, LBB4_349
; %bb.227:                              ;   in Loop: Header=BB4_189 Depth=2
	lsl	x0, x23, #3
Ltmp215:
	bl	__Znwm
Ltmp216:
; %bb.228:                              ;   in Loop: Header=BB4_189 Depth=2
	add	x20, x0, x19
	add	x23, x0, x23, lsl #3
	sub	x22, x20, x22, lsl #3
	str	d10, [x20], #8
	mov	x0, x22
	mov	x1, x21
	mov	x2, x19
	bl	_memcpy
	cbz	x21, LBB4_230
; %bb.229:                              ;   in Loop: Header=BB4_189 Depth=2
	mov	x0, x21
	bl	__ZdlPv
LBB4_230:                               ;   in Loop: Header=BB4_189 Depth=2
	mov	x21, x22
	subs	w25, w25, #1
	b.ne	LBB4_189
LBB4_231:                               ;   in Loop: Header=BB4_104 Depth=1
Ltmp223:
	add	x2, sp, #104
	mov	x0, x21
	mov	x1, x20
	bl	__ZNSt3__16__sortIRNS_6__lessIddEEPdEEvT0_S5_T_
Ltmp224:
; %bb.232:                              ;   in Loop: Header=BB4_104 Depth=1
	ldr	d10, [x21, #120]
	mov	x0, x21
	bl	__ZdlPv
	ldp	x9, x8, [sp, #32]
	stp	xzr, xzr, [sp, #112]
	str	xzr, [sp, #104]
	subs	x19, x8, x9
	b.eq	LBB4_236
; %bb.233:                              ;   in Loop: Header=BB4_104 Depth=1
	tbnz	x19, #63, LBB4_353
; %bb.234:                              ;   in Loop: Header=BB4_104 Depth=1
Ltmp226:
	mov	x0, x19
	bl	__Znwm
Ltmp227:
; %bb.235:                              ;   in Loop: Header=BB4_104 Depth=1
	add	x20, x0, x19
	str	x0, [sp, #104]
	str	x20, [sp, #120]
	mov	x1, x19
	bl	_bzero
	str	x20, [sp, #112]
LBB4_236:                               ;   in Loop: Header=BB4_104 Depth=1
Ltmp228:
	add	x0, sp, #56
	add	x4, sp, #104
	mov	x1, x27
	mov	x2, x26
	mov	x3, x28
	bl	__Z7convertILb1EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp229:
; %bb.237:                              ;   in Loop: Header=BB4_104 Depth=1
	ldr	x8, [sp, #104]
	; InlineAsm Start
	; InlineAsm End
	ldr	x0, [sp, #104]
	cbz	x0, LBB4_239
; %bb.238:                              ;   in Loop: Header=BB4_104 Depth=1
	str	x0, [sp, #112]
	bl	__ZdlPv
LBB4_239:                               ;   in Loop: Header=BB4_104 Depth=1
	ldp	x9, x8, [sp, #32]
	stp	xzr, xzr, [sp, #112]
	str	xzr, [sp, #104]
	subs	x19, x8, x9
	b.eq	LBB4_243
; %bb.240:                              ;   in Loop: Header=BB4_104 Depth=1
	tbnz	x19, #63, LBB4_353
; %bb.241:                              ;   in Loop: Header=BB4_104 Depth=1
Ltmp230:
	mov	x0, x19
	bl	__Znwm
Ltmp231:
; %bb.242:                              ;   in Loop: Header=BB4_104 Depth=1
	add	x20, x0, x19
	str	x0, [sp, #104]
	str	x20, [sp, #120]
	mov	x1, x19
	bl	_bzero
	str	x20, [sp, #112]
LBB4_243:                               ;   in Loop: Header=BB4_104 Depth=1
Ltmp232:
	add	x0, sp, #56
	add	x4, sp, #104
	mov	x1, x27
	mov	x2, x26
	mov	x3, x28
	bl	__Z7convertILb1EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp233:
; %bb.244:                              ;   in Loop: Header=BB4_104 Depth=1
	ldr	x8, [sp, #104]
	; InlineAsm Start
	; InlineAsm End
	ldr	x0, [sp, #104]
	cbz	x0, LBB4_246
; %bb.245:                              ;   in Loop: Header=BB4_104 Depth=1
	str	x0, [sp, #112]
	bl	__ZdlPv
LBB4_246:                               ;   in Loop: Header=BB4_104 Depth=1
	ldp	x9, x8, [sp, #32]
	stp	xzr, xzr, [sp, #112]
	str	xzr, [sp, #104]
	subs	x19, x8, x9
	b.eq	LBB4_250
; %bb.247:                              ;   in Loop: Header=BB4_104 Depth=1
	tbnz	x19, #63, LBB4_353
; %bb.248:                              ;   in Loop: Header=BB4_104 Depth=1
Ltmp234:
	mov	x0, x19
	bl	__Znwm
Ltmp235:
; %bb.249:                              ;   in Loop: Header=BB4_104 Depth=1
	add	x20, x0, x19
	str	x0, [sp, #104]
	str	x20, [sp, #120]
	mov	x1, x19
	bl	_bzero
	str	x20, [sp, #112]
LBB4_250:                               ;   in Loop: Header=BB4_104 Depth=1
Ltmp236:
	add	x0, sp, #56
	add	x4, sp, #104
	mov	x1, x27
	mov	x2, x26
	mov	x3, x28
	bl	__Z7convertILb1EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp237:
; %bb.251:                              ;   in Loop: Header=BB4_104 Depth=1
	ldr	x8, [sp, #104]
	; InlineAsm Start
	; InlineAsm End
	ldr	x0, [sp, #104]
	cbz	x0, LBB4_253
; %bb.252:                              ;   in Loop: Header=BB4_104 Depth=1
	str	x0, [sp, #112]
	bl	__ZdlPv
LBB4_253:                               ;   in Loop: Header=BB4_104 Depth=1
	ldp	x9, x8, [sp, #32]
	stp	xzr, xzr, [sp, #112]
	str	xzr, [sp, #104]
	subs	x19, x8, x9
	b.eq	LBB4_257
; %bb.254:                              ;   in Loop: Header=BB4_104 Depth=1
	tbnz	x19, #63, LBB4_353
; %bb.255:                              ;   in Loop: Header=BB4_104 Depth=1
Ltmp238:
	mov	x0, x19
	bl	__Znwm
Ltmp239:
; %bb.256:                              ;   in Loop: Header=BB4_104 Depth=1
	add	x20, x0, x19
	str	x0, [sp, #104]
	str	x20, [sp, #120]
	mov	x1, x19
	bl	_bzero
	str	x20, [sp, #112]
LBB4_257:                               ;   in Loop: Header=BB4_104 Depth=1
Ltmp240:
	add	x0, sp, #56
	add	x4, sp, #104
	mov	x1, x27
	mov	x2, x26
	mov	x3, x28
	bl	__Z7convertILb1EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp241:
; %bb.258:                              ;   in Loop: Header=BB4_104 Depth=1
	ldr	x8, [sp, #104]
	; InlineAsm Start
	; InlineAsm End
	ldr	x0, [sp, #104]
	cbz	x0, LBB4_260
; %bb.259:                              ;   in Loop: Header=BB4_104 Depth=1
	str	x0, [sp, #112]
	bl	__ZdlPv
LBB4_260:                               ;   in Loop: Header=BB4_104 Depth=1
	ldp	x9, x8, [sp, #32]
	stp	xzr, xzr, [sp, #112]
	str	xzr, [sp, #104]
	subs	x19, x8, x9
	b.eq	LBB4_264
; %bb.261:                              ;   in Loop: Header=BB4_104 Depth=1
	tbnz	x19, #63, LBB4_353
; %bb.262:                              ;   in Loop: Header=BB4_104 Depth=1
Ltmp242:
	mov	x0, x19
	bl	__Znwm
Ltmp243:
; %bb.263:                              ;   in Loop: Header=BB4_104 Depth=1
	add	x20, x0, x19
	str	x0, [sp, #104]
	str	x20, [sp, #120]
	mov	x1, x19
	bl	_bzero
	str	x20, [sp, #112]
LBB4_264:                               ;   in Loop: Header=BB4_104 Depth=1
Ltmp248:
	add	x0, sp, #56
	add	x4, sp, #104
	mov	x1, x27
	mov	x2, x26
	mov	x3, x28
	bl	__Z7convertILb1EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp249:
; %bb.265:                              ;   in Loop: Header=BB4_104 Depth=1
	ldr	x8, [sp, #104]
	; InlineAsm Start
	; InlineAsm End
	ldr	x0, [sp, #104]
	cbz	x0, LBB4_267
; %bb.266:                              ;   in Loop: Header=BB4_104 Depth=1
	str	x0, [sp, #112]
	bl	__ZdlPv
LBB4_267:                               ;   in Loop: Header=BB4_104 Depth=1
	mov	x21, #0                         ; =0x0
	mov	x20, #0                         ; =0x0
	mov	x23, #0                         ; =0x0
	mov	w25, #31                        ; =0x1f
	b	LBB4_269
LBB4_268:                               ;   in Loop: Header=BB4_269 Depth=2
	str	d11, [x20], #8
	subs	w25, w25, #1
	b.eq	LBB4_311
LBB4_269:                               ;   Parent Loop BB4_104 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x19, x0
	ldp	x9, x8, [sp, #32]
	stp	xzr, xzr, [sp, #112]
	str	xzr, [sp, #104]
	subs	x22, x8, x9
	b.eq	LBB4_273
; %bb.270:                              ;   in Loop: Header=BB4_269 Depth=2
	tbnz	x22, #63, LBB4_341
; %bb.271:                              ;   in Loop: Header=BB4_269 Depth=2
Ltmp251:
	mov	x0, x22
	bl	__Znwm
Ltmp252:
; %bb.272:                              ;   in Loop: Header=BB4_269 Depth=2
	add	x24, x0, x22
	str	x0, [sp, #104]
	str	x24, [sp, #120]
	mov	x1, x22
	bl	_bzero
	str	x24, [sp, #112]
LBB4_273:                               ;   in Loop: Header=BB4_269 Depth=2
Ltmp253:
	add	x0, sp, #56
	add	x4, sp, #104
	mov	x1, x27
	mov	x2, x26
	mov	x3, x28
	bl	__Z7convertILb1EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp254:
; %bb.274:                              ;   in Loop: Header=BB4_269 Depth=2
	ldr	x8, [sp, #104]
	; InlineAsm Start
	; InlineAsm End
	ldr	x0, [sp, #104]
	cbz	x0, LBB4_276
; %bb.275:                              ;   in Loop: Header=BB4_269 Depth=2
	str	x0, [sp, #112]
	bl	__ZdlPv
LBB4_276:                               ;   in Loop: Header=BB4_269 Depth=2
	; InlineAsm Start
	; InlineAsm End
	ldp	x9, x8, [sp, #32]
	stp	xzr, xzr, [sp, #112]
	str	xzr, [sp, #104]
	subs	x22, x8, x9
	b.eq	LBB4_280
; %bb.277:                              ;   in Loop: Header=BB4_269 Depth=2
	tbnz	x22, #63, LBB4_341
; %bb.278:                              ;   in Loop: Header=BB4_269 Depth=2
Ltmp255:
	mov	x0, x22
	bl	__Znwm
Ltmp256:
; %bb.279:                              ;   in Loop: Header=BB4_269 Depth=2
	add	x24, x0, x22
	str	x0, [sp, #104]
	str	x24, [sp, #120]
	mov	x1, x22
	bl	_bzero
	str	x24, [sp, #112]
LBB4_280:                               ;   in Loop: Header=BB4_269 Depth=2
Ltmp257:
	add	x0, sp, #56
	add	x4, sp, #104
	mov	x1, x27
	mov	x2, x26
	mov	x3, x28
	bl	__Z7convertILb1EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp258:
; %bb.281:                              ;   in Loop: Header=BB4_269 Depth=2
	ldr	x8, [sp, #104]
	; InlineAsm Start
	; InlineAsm End
	ldr	x0, [sp, #104]
	cbz	x0, LBB4_283
; %bb.282:                              ;   in Loop: Header=BB4_269 Depth=2
	str	x0, [sp, #112]
	bl	__ZdlPv
LBB4_283:                               ;   in Loop: Header=BB4_269 Depth=2
	; InlineAsm Start
	; InlineAsm End
	ldp	x9, x8, [sp, #32]
	stp	xzr, xzr, [sp, #112]
	str	xzr, [sp, #104]
	subs	x22, x8, x9
	b.eq	LBB4_287
; %bb.284:                              ;   in Loop: Header=BB4_269 Depth=2
	tbnz	x22, #63, LBB4_341
; %bb.285:                              ;   in Loop: Header=BB4_269 Depth=2
Ltmp259:
	mov	x0, x22
	bl	__Znwm
Ltmp260:
; %bb.286:                              ;   in Loop: Header=BB4_269 Depth=2
	add	x24, x0, x22
	str	x0, [sp, #104]
	str	x24, [sp, #120]
	mov	x1, x22
	bl	_bzero
	str	x24, [sp, #112]
LBB4_287:                               ;   in Loop: Header=BB4_269 Depth=2
Ltmp261:
	add	x0, sp, #56
	add	x4, sp, #104
	mov	x1, x27
	mov	x2, x26
	mov	x3, x28
	bl	__Z7convertILb1EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp262:
; %bb.288:                              ;   in Loop: Header=BB4_269 Depth=2
	ldr	x8, [sp, #104]
	; InlineAsm Start
	; InlineAsm End
	ldr	x0, [sp, #104]
	cbz	x0, LBB4_290
; %bb.289:                              ;   in Loop: Header=BB4_269 Depth=2
	str	x0, [sp, #112]
	bl	__ZdlPv
LBB4_290:                               ;   in Loop: Header=BB4_269 Depth=2
	; InlineAsm Start
	; InlineAsm End
	ldp	x9, x8, [sp, #32]
	stp	xzr, xzr, [sp, #112]
	str	xzr, [sp, #104]
	subs	x22, x8, x9
	b.eq	LBB4_294
; %bb.291:                              ;   in Loop: Header=BB4_269 Depth=2
	tbnz	x22, #63, LBB4_341
; %bb.292:                              ;   in Loop: Header=BB4_269 Depth=2
Ltmp263:
	mov	x0, x22
	bl	__Znwm
Ltmp264:
; %bb.293:                              ;   in Loop: Header=BB4_269 Depth=2
	add	x24, x0, x22
	str	x0, [sp, #104]
	str	x24, [sp, #120]
	mov	x1, x22
	bl	_bzero
	str	x24, [sp, #112]
LBB4_294:                               ;   in Loop: Header=BB4_269 Depth=2
Ltmp265:
	add	x0, sp, #56
	add	x4, sp, #104
	mov	x1, x27
	mov	x2, x26
	mov	x3, x28
	bl	__Z7convertILb1EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp266:
; %bb.295:                              ;   in Loop: Header=BB4_269 Depth=2
	ldr	x8, [sp, #104]
	; InlineAsm Start
	; InlineAsm End
	ldr	x0, [sp, #104]
	cbz	x0, LBB4_297
; %bb.296:                              ;   in Loop: Header=BB4_269 Depth=2
	str	x0, [sp, #112]
	bl	__ZdlPv
LBB4_297:                               ;   in Loop: Header=BB4_269 Depth=2
	; InlineAsm Start
	; InlineAsm End
	ldp	x9, x8, [sp, #32]
	stp	xzr, xzr, [sp, #112]
	str	xzr, [sp, #104]
	subs	x22, x8, x9
	b.eq	LBB4_301
; %bb.298:                              ;   in Loop: Header=BB4_269 Depth=2
	tbnz	x22, #63, LBB4_341
; %bb.299:                              ;   in Loop: Header=BB4_269 Depth=2
Ltmp267:
	mov	x0, x22
	bl	__Znwm
Ltmp268:
; %bb.300:                              ;   in Loop: Header=BB4_269 Depth=2
	add	x24, x0, x22
	str	x0, [sp, #104]
	str	x24, [sp, #120]
	mov	x1, x22
	bl	_bzero
	str	x24, [sp, #112]
LBB4_301:                               ;   in Loop: Header=BB4_269 Depth=2
Ltmp273:
	add	x0, sp, #56
	add	x4, sp, #104
	mov	x1, x27
	mov	x2, x26
	mov	x3, x28
	bl	__Z7convertILb1EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Ltmp274:
; %bb.302:                              ;   in Loop: Header=BB4_269 Depth=2
	ldr	x8, [sp, #104]
	; InlineAsm Start
	; InlineAsm End
	ldr	x0, [sp, #104]
	cbz	x0, LBB4_304
; %bb.303:                              ;   in Loop: Header=BB4_269 Depth=2
	str	x0, [sp, #112]
	bl	__ZdlPv
LBB4_304:                               ;   in Loop: Header=BB4_269 Depth=2
	; InlineAsm Start
	; InlineAsm End
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	sub	x8, x0, x19
	scvtf	d0, x8
	mov	x8, #70368744177664             ; =0x400000000000
	movk	x8, #16527, lsl #48
	fmov	d1, x8
	fdiv	d0, d0, d1
	fdiv	d11, d0, d12
	cmp	x20, x23
	b.lo	LBB4_268
; %bb.305:                              ;   in Loop: Header=BB4_269 Depth=2
	sub	x19, x20, x21
	asr	x22, x19, #3
	add	x8, x22, #1
	lsr	x9, x8, #61
	cbnz	x9, LBB4_350
; %bb.306:                              ;   in Loop: Header=BB4_269 Depth=2
	sub	x9, x23, x21
	asr	x10, x9, #2
	cmp	x10, x8
	csel	x8, x10, x8, hi
	mov	x10, #9223372036854775800       ; =0x7ffffffffffffff8
	cmp	x9, x10
	mov	x9, #2305843009213693951        ; =0x1fffffffffffffff
	csel	x23, x8, x9, lo
	lsr	x8, x23, #61
	cbnz	x8, LBB4_351
; %bb.307:                              ;   in Loop: Header=BB4_269 Depth=2
	lsl	x0, x23, #3
Ltmp276:
	bl	__Znwm
Ltmp277:
; %bb.308:                              ;   in Loop: Header=BB4_269 Depth=2
	add	x20, x0, x19
	add	x23, x0, x23, lsl #3
	sub	x22, x20, x22, lsl #3
	str	d11, [x20], #8
	mov	x0, x22
	mov	x1, x21
	mov	x2, x19
	bl	_memcpy
	cbz	x21, LBB4_310
; %bb.309:                              ;   in Loop: Header=BB4_269 Depth=2
	mov	x0, x21
	bl	__ZdlPv
LBB4_310:                               ;   in Loop: Header=BB4_269 Depth=2
	mov	x21, x22
	subs	w25, w25, #1
	b.ne	LBB4_269
LBB4_311:                               ;   in Loop: Header=BB4_104 Depth=1
Ltmp284:
	add	x2, sp, #104
	mov	x0, x21
	mov	x1, x20
	bl	__ZNSt3__16__sortIRNS_6__lessIddEEPdEEvT0_S5_T_
Ltmp285:
; %bb.312:                              ;   in Loop: Header=BB4_104 Depth=1
	ldr	d11, [x21, #120]
	mov	x0, x21
	bl	__ZdlPv
Ltmp287:
	add	x8, sp, #104
	add	x0, sp, #56
	mov	x1, x27
	mov	x2, x26
	mov	x3, x28
	bl	__Z9referenceRKNSt3__16vectorIhNS_9allocatorIhEEEEiii
Ltmp288:
; %bb.313:                              ;   in Loop: Header=BB4_104 Depth=1
	ldp	x9, x8, [sp, #32]
	sub	x10, x8, x9
	ldp	x0, x11, [sp, #104]
	sub	x11, x11, x0
	cmp	x10, x11
	ldr	x21, [sp]                       ; 8-byte Folded Reload
	b.ne	LBB4_342
; %bb.314:                              ;   in Loop: Header=BB4_104 Depth=1
	cmp	x9, x8
	b.eq	LBB4_318
; %bb.315:                              ;   in Loop: Header=BB4_104 Depth=1
	mov	x10, x0
LBB4_316:                               ;   Parent Loop BB4_104 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	s0, [x9], #4
	ldr	s1, [x10], #4
	fcmp	s0, s1
	b.ne	LBB4_342
; %bb.317:                              ;   in Loop: Header=BB4_316 Depth=2
	cmp	x9, x8
	b.ne	LBB4_316
LBB4_318:                               ;   in Loop: Header=BB4_104 Depth=1
	cbz	x0, LBB4_320
; %bb.319:                              ;   in Loop: Header=BB4_104 Depth=1
	bl	__ZdlPv
LBB4_320:                               ;   in Loop: Header=BB4_104 Depth=1
Ltmp296:
Lloh43:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh44:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh45:
	adrp	x1, l_.str.5@PAGE
Lloh46:
	add	x1, x1, l_.str.5@PAGEOFF
	mov	w2, #28                         ; =0x1c
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp297:
; %bb.321:                              ;   in Loop: Header=BB4_104 Depth=1
Ltmp298:
	mov	x1, x27
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEi
Ltmp299:
; %bb.322:                              ;   in Loop: Header=BB4_104 Depth=1
Ltmp300:
Lloh47:
	adrp	x1, l_.str.6@PAGE
Lloh48:
	add	x1, x1, l_.str.6@PAGEOFF
	mov	w2, #8                          ; =0x8
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp301:
; %bb.323:                              ;   in Loop: Header=BB4_104 Depth=1
Ltmp302:
	mov	x1, x26
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEi
Ltmp303:
; %bb.324:                              ;   in Loop: Header=BB4_104 Depth=1
Ltmp304:
Lloh49:
	adrp	x1, l_.str.7@PAGE
Lloh50:
	add	x1, x1, l_.str.7@PAGEOFF
	mov	w2, #7                          ; =0x7
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp305:
; %bb.325:                              ;   in Loop: Header=BB4_104 Depth=1
Ltmp306:
	mov.16b	v0, v8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp307:
; %bb.326:                              ;   in Loop: Header=BB4_104 Depth=1
Ltmp308:
Lloh51:
	adrp	x1, l_.str.8@PAGE
Lloh52:
	add	x1, x1, l_.str.8@PAGEOFF
	mov	w2, #7                          ; =0x7
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp309:
; %bb.327:                              ;   in Loop: Header=BB4_104 Depth=1
Ltmp310:
	mov.16b	v0, v9
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp311:
; %bb.328:                              ;   in Loop: Header=BB4_104 Depth=1
Ltmp312:
Lloh53:
	adrp	x1, l_.str.9@PAGE
Lloh54:
	add	x1, x1, l_.str.9@PAGEOFF
	mov	w2, #13                         ; =0xd
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp313:
; %bb.329:                              ;   in Loop: Header=BB4_104 Depth=1
Ltmp314:
	mov.16b	v0, v10
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp315:
; %bb.330:                              ;   in Loop: Header=BB4_104 Depth=1
Ltmp316:
Lloh55:
	adrp	x1, l_.str.10@PAGE
Lloh56:
	add	x1, x1, l_.str.10@PAGEOFF
	mov	w2, #13                         ; =0xd
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp317:
; %bb.331:                              ;   in Loop: Header=BB4_104 Depth=1
Ltmp318:
	mov.16b	v0, v11
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp319:
; %bb.332:                              ;   in Loop: Header=BB4_104 Depth=1
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #104]
Ltmp320:
	add	x1, sp, #104
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp321:
; %bb.333:                              ;   in Loop: Header=BB4_104 Depth=1
	ldr	x0, [sp, #32]
	cbz	x0, LBB4_335
; %bb.334:                              ;   in Loop: Header=BB4_104 Depth=1
	str	x0, [sp, #40]
	bl	__ZdlPv
LBB4_335:                               ;   in Loop: Header=BB4_104 Depth=1
	ldr	x0, [sp, #56]
	cbz	x0, LBB4_103
; %bb.336:                              ;   in Loop: Header=BB4_104 Depth=1
	str	x0, [sp, #64]
	bl	__ZdlPv
	b	LBB4_103
LBB4_337:
	ldr	x0, [sp, #80]
	cbz	x0, LBB4_339
; %bb.338:
	bl	__ZdlPv
LBB4_339:
	mov	w0, #0                          ; =0x0
	b	LBB4_444
LBB4_340:
Ltmp209:
	bl	__ZNSt3__16vectorIfNS_9allocatorIfEEE20__throw_length_errorB9nqe210106Ev
Ltmp210:
	b	LBB4_356
LBB4_341:
Ltmp270:
	bl	__ZNSt3__16vectorIfNS_9allocatorIfEEE20__throw_length_errorB9nqe210106Ev
Ltmp271:
	b	LBB4_356
LBB4_342:
	mov	x21, x0
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x22, x0
Ltmp290:
Lloh57:
	adrp	x1, l_.str@PAGE
Lloh58:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp291:
; %bb.343:
Ltmp293:
Lloh59:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh60:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh61:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh62:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x22
	bl	___cxa_throw
Ltmp294:
	b	LBB4_356
LBB4_344:
Ltmp126:
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_length_errorB9nqe210106Ev
Ltmp127:
	b	LBB4_356
LBB4_345:
Ltmp124:
	bl	__ZSt28__throw_bad_array_new_lengthB9nqe210106v
Ltmp125:
	b	LBB4_356
LBB4_346:
Ltmp159:
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_length_errorB9nqe210106Ev
Ltmp160:
	b	LBB4_356
LBB4_347:
Ltmp157:
	bl	__ZSt28__throw_bad_array_new_lengthB9nqe210106v
Ltmp158:
	b	LBB4_356
LBB4_348:
Ltmp220:
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_length_errorB9nqe210106Ev
Ltmp221:
	b	LBB4_356
LBB4_349:
Ltmp218:
	bl	__ZSt28__throw_bad_array_new_lengthB9nqe210106v
Ltmp219:
	b	LBB4_356
LBB4_350:
Ltmp281:
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_length_errorB9nqe210106Ev
Ltmp282:
	b	LBB4_356
LBB4_351:
Ltmp279:
	bl	__ZSt28__throw_bad_array_new_lengthB9nqe210106v
Ltmp280:
	b	LBB4_356
LBB4_352:
Ltmp184:
	bl	__ZNSt3__16vectorIfNS_9allocatorIfEEE20__throw_length_errorB9nqe210106Ev
Ltmp185:
	b	LBB4_356
LBB4_353:
Ltmp245:
	bl	__ZNSt3__16vectorIfNS_9allocatorIfEEE20__throw_length_errorB9nqe210106Ev
Ltmp246:
	b	LBB4_356
LBB4_354:
Ltmp90:
	bl	__ZNSt3__16vectorIhNS_9allocatorIhEEE20__throw_length_errorB9nqe210106Ev
Ltmp91:
	b	LBB4_356
LBB4_355:
Ltmp96:
	bl	__ZNSt3__16vectorIfNS_9allocatorIfEEE20__throw_length_errorB9nqe210106Ev
Ltmp97:
LBB4_356:
	brk	#0x1
LBB4_357:
Ltmp72:
	mov	x19, x1
	mov	x20, x0
	mov	x0, x21
	b	LBB4_438
LBB4_358:
Ltmp69:
	b	LBB4_425
LBB4_359:
Ltmp86:
	b	LBB4_371
LBB4_360:
Ltmp98:
	b	LBB4_385
LBB4_361:
Ltmp92:
	b	LBB4_363
LBB4_362:
Ltmp95:
LBB4_363:
	mov	x19, x1
	mov	x20, x0
	b	LBB4_410
LBB4_364:
Ltmp89:
	b	LBB4_371
LBB4_365:
Ltmp289:
	b	LBB4_385
LBB4_366:
Ltmp286:
	b	LBB4_398
LBB4_367:
Ltmp225:
	b	LBB4_398
LBB4_368:
Ltmp164:
	b	LBB4_405
LBB4_369:
Ltmp131:
	b	LBB4_405
LBB4_370:
Ltmp79:
LBB4_371:
	mov	x19, x1
	mov	x20, x0
	b	LBB4_412
LBB4_372:
Ltmp247:
	b	LBB4_385
LBB4_373:
Ltmp186:
	b	LBB4_385
LBB4_374:
Ltmp244:
	b	LBB4_385
LBB4_375:
Ltmp183:
	b	LBB4_385
LBB4_376:
Ltmp250:
	b	LBB4_378
LBB4_377:
Ltmp189:
LBB4_378:
	mov	x19, x1
	mov	x20, x0
	ldr	x0, [sp, #104]
	cbz	x0, LBB4_408
; %bb.379:
	str	x0, [sp, #112]
	b	LBB4_407
LBB4_380:
Ltmp142:
	b	LBB4_385
LBB4_381:
Ltmp109:
	b	LBB4_385
LBB4_382:
Ltmp295:
	b	LBB4_398
LBB4_383:
Ltmp292:
	mov	x19, x1
	mov	x20, x0
	mov	x0, x22
	bl	___cxa_free_exception
	b	LBB4_399
LBB4_384:
Ltmp322:
LBB4_385:
	mov	x19, x1
	mov	x20, x0
	b	LBB4_408
LBB4_386:
Ltmp278:
	b	LBB4_398
LBB4_387:
Ltmp217:
	b	LBB4_398
LBB4_388:
Ltmp156:
	b	LBB4_405
LBB4_389:
Ltmp123:
	b	LBB4_405
LBB4_390:
Ltmp283:
	b	LBB4_398
LBB4_391:
Ltmp222:
	b	LBB4_398
LBB4_392:
Ltmp161:
	b	LBB4_405
LBB4_393:
Ltmp128:
	b	LBB4_405
LBB4_394:
Ltmp272:
	b	LBB4_398
LBB4_395:
Ltmp269:
	b	LBB4_398
LBB4_396:
Ltmp211:
	b	LBB4_398
LBB4_397:
Ltmp208:
LBB4_398:
	mov	x19, x1
	mov	x20, x0
LBB4_399:
	cbnz	x21, LBB4_406
	b	LBB4_408
LBB4_400:
Ltmp275:
	mov	x19, x1
	mov	x20, x0
	ldr	x0, [sp, #104]
	cbnz	x0, LBB4_402
	b	LBB4_399
LBB4_401:
Ltmp214:
	mov	x19, x1
	mov	x20, x0
	ldr	x0, [sp, #104]
	cbz	x0, LBB4_399
LBB4_402:
	str	x0, [sp, #112]
	bl	__ZdlPv
	cbnz	x21, LBB4_406
	b	LBB4_408
LBB4_403:
Ltmp153:
	b	LBB4_405
LBB4_404:
Ltmp120:
LBB4_405:
	mov	x19, x1
	mov	x20, x0
	cbz	x21, LBB4_408
LBB4_406:
	mov	x0, x21
LBB4_407:
	bl	__ZdlPv
LBB4_408:
	ldr	x0, [sp, #32]
	cbz	x0, LBB4_410
; %bb.409:
	str	x0, [sp, #40]
	bl	__ZdlPv
LBB4_410:
	ldr	x0, [sp, #56]
	cbz	x0, LBB4_412
; %bb.411:
	str	x0, [sp, #64]
	bl	__ZdlPv
LBB4_412:
	ldr	x0, [sp, #80]
	cbnz	x0, LBB4_438
	b	LBB4_439
LBB4_413:
Ltmp55:
	mov	x19, x1
	mov	x20, x0
	mov	x0, x21
	bl	__ZdlPv
	b	LBB4_415
LBB4_414:
Ltmp52:
	mov	x19, x1
	mov	x20, x0
LBB4_415:
	cmp	w19, #2
	b.ne	LBB4_439
; %bb.416:
	mov	x0, x20
	bl	___cxa_begin_catch
Ltmp56:
	bl	___cxa_end_catch
Ltmp57:
; %bb.417:
	mov	w22, #1                         ; =0x1
	b	LBB4_77
LBB4_418:
Ltmp66:
	b	LBB4_425
LBB4_419:
Ltmp38:
	b	LBB4_421
LBB4_420:
Ltmp35:
LBB4_421:
	mov	x19, x1
	mov	x20, x0
	b	LBB4_432
LBB4_422:
Ltmp32:
	mov	x19, x1
	mov	x20, x0
	b	LBB4_434
LBB4_423:
Ltmp26:
	b	LBB4_427
LBB4_424:
Ltmp23:
LBB4_425:
	mov	x19, x1
	mov	x20, x0
	b	LBB4_439
LBB4_426:
Ltmp29:
LBB4_427:
	mov	x19, x1
	mov	x20, x0
	b	LBB4_436
LBB4_428:
Ltmp43:
	mov	x19, x1
	mov	x20, x0
	ldr	x0, [sp, #32]
	cbnz	x0, LBB4_431
	b	LBB4_432
LBB4_429:
Ltmp49:
	mov	x19, x1
	mov	x20, x0
	ldr	x0, [sp, #32]
	cbnz	x0, LBB4_431
	b	LBB4_432
LBB4_430:
Ltmp46:
	mov	x19, x1
	mov	x20, x0
	mov	x0, x22
	bl	___cxa_free_exception
	ldr	x0, [sp, #32]
	cbz	x0, LBB4_432
LBB4_431:
	str	x0, [sp, #40]
	bl	__ZdlPv
LBB4_432:
	ldr	x0, [sp, #56]
	cbz	x0, LBB4_434
; %bb.433:
	str	x0, [sp, #64]
	bl	__ZdlPv
LBB4_434:
	cbz	x21, LBB4_436
; %bb.435:
	str	x21, [sp, #88]
	mov	x0, x21
	bl	__ZdlPv
LBB4_436:
	ldr	x0, [sp, #104]
	cbz	x0, LBB4_439
; %bb.437:
	str	x0, [sp, #112]
LBB4_438:
	bl	__ZdlPv
LBB4_439:
	cmp	w19, #1
	b.ne	LBB4_450
; %bb.440:
	mov	x0, x20
	bl	___cxa_begin_catch
	ldr	x8, [x0]
	ldr	x8, [x8, #16]
	blr	x8
	mov	x19, x0
	bl	_strlen
	mov	x2, x0
Ltmp329:
Lloh63:
	adrp	x0, __ZNSt3__14cerrE@GOTPAGE
Lloh64:
	ldr	x0, [x0, __ZNSt3__14cerrE@GOTPAGEOFF]
	mov	x1, x19
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp330:
; %bb.441:
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #80]
Ltmp331:
	add	x1, sp, #80
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp332:
; %bb.442:
Ltmp337:
	bl	___cxa_end_catch
Ltmp338:
; %bb.443:
	mov	w0, #1                          ; =0x1
LBB4_444:
	ldr	x8, [sp, #144]
Lloh65:
	adrp	x9, ___stack_chk_guard@GOTPAGE
Lloh66:
	ldr	x9, [x9, ___stack_chk_guard@GOTPAGEOFF]
Lloh67:
	ldr	x9, [x9]
	cmp	x9, x8
	b.ne	LBB4_446
; %bb.445:
	ldp	x29, x30, [sp, #288]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #272]            ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #256]            ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #240]            ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #224]            ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #208]            ; 16-byte Folded Reload
	ldp	d9, d8, [sp, #192]              ; 16-byte Folded Reload
	ldp	d11, d10, [sp, #176]            ; 16-byte Folded Reload
	ldp	d13, d12, [sp, #160]            ; 16-byte Folded Reload
	add	sp, sp, #304
	ret
LBB4_446:
	bl	___stack_chk_fail
LBB4_447:
Ltmp339:
	bl	__Unwind_Resume
LBB4_448:
Ltmp333:
	mov	x20, x0
Ltmp334:
	bl	___cxa_end_catch
Ltmp335:
	b	LBB4_450
LBB4_449:
Ltmp336:
	mov	x20, x0
	cbnz	w1, LBB4_451
LBB4_450:
	mov	x0, x20
	bl	__Unwind_Resume
LBB4_451:
	mov	x0, x20
	bl	___clang_call_terminate
	.loh AdrpLdr	Lloh11, Lloh12
	.loh AdrpLdrGotLdr	Lloh8, Lloh9, Lloh10
	.loh AdrpAdd	Lloh13, Lloh14
	.loh AdrpAdd	Lloh15, Lloh16
	.loh AdrpLdrGot	Lloh19, Lloh20
	.loh AdrpLdrGot	Lloh17, Lloh18
	.loh AdrpAdd	Lloh21, Lloh22
	.loh AdrpLdrGot	Lloh25, Lloh26
	.loh AdrpLdrGot	Lloh23, Lloh24
	.loh AdrpLdr	Lloh27, Lloh28
	.loh AdrpAdd	Lloh31, Lloh32
	.loh AdrpLdrGot	Lloh29, Lloh30
	.loh AdrpLdrGot	Lloh33, Lloh34
	.loh AdrpAdd	Lloh37, Lloh38
	.loh AdrpLdrGot	Lloh35, Lloh36
	.loh AdrpAdd	Lloh39, Lloh40
	.loh AdrpLdr	Lloh41, Lloh42
	.loh AdrpAdd	Lloh45, Lloh46
	.loh AdrpLdrGot	Lloh43, Lloh44
	.loh AdrpAdd	Lloh47, Lloh48
	.loh AdrpAdd	Lloh49, Lloh50
	.loh AdrpAdd	Lloh51, Lloh52
	.loh AdrpAdd	Lloh53, Lloh54
	.loh AdrpAdd	Lloh55, Lloh56
	.loh AdrpAdd	Lloh57, Lloh58
	.loh AdrpLdrGot	Lloh61, Lloh62
	.loh AdrpLdrGot	Lloh59, Lloh60
	.loh AdrpLdrGot	Lloh63, Lloh64
	.loh AdrpLdrGotLdr	Lloh65, Lloh66, Lloh67
Lfunc_end3:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table4:
Lexception3:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase0-Lttbaseref0
Lttbaseref0:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end3-Lcst_begin3
Lcst_begin3:
	.uleb128 Ltmp9-Lfunc_begin3             ; >> Call Site 1 <<
	.uleb128 Ltmp10-Ltmp9                   ;   Call between Ltmp9 and Ltmp10
	.uleb128 Ltmp23-Lfunc_begin3            ;     jumps to Ltmp23
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp10-Lfunc_begin3            ; >> Call Site 2 <<
	.uleb128 Ltmp11-Ltmp10                  ;   Call between Ltmp10 and Ltmp11
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp11-Lfunc_begin3            ; >> Call Site 3 <<
	.uleb128 Ltmp12-Ltmp11                  ;   Call between Ltmp11 and Ltmp12
	.uleb128 Ltmp29-Lfunc_begin3            ;     jumps to Ltmp29
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp13-Lfunc_begin3            ; >> Call Site 4 <<
	.uleb128 Ltmp14-Ltmp13                  ;   Call between Ltmp13 and Ltmp14
	.uleb128 Ltmp32-Lfunc_begin3            ;     jumps to Ltmp32
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp14-Lfunc_begin3            ; >> Call Site 5 <<
	.uleb128 Ltmp15-Ltmp14                  ;   Call between Ltmp14 and Ltmp15
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp15-Lfunc_begin3            ; >> Call Site 6 <<
	.uleb128 Ltmp16-Ltmp15                  ;   Call between Ltmp15 and Ltmp16
	.uleb128 Ltmp35-Lfunc_begin3            ;     jumps to Ltmp35
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp16-Lfunc_begin3            ; >> Call Site 7 <<
	.uleb128 Ltmp17-Ltmp16                  ;   Call between Ltmp16 and Ltmp17
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp17-Lfunc_begin3            ; >> Call Site 8 <<
	.uleb128 Ltmp20-Ltmp17                  ;   Call between Ltmp17 and Ltmp20
	.uleb128 Ltmp43-Lfunc_begin3            ;     jumps to Ltmp43
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp21-Lfunc_begin3            ; >> Call Site 9 <<
	.uleb128 Ltmp22-Ltmp21                  ;   Call between Ltmp21 and Ltmp22
	.uleb128 Ltmp23-Lfunc_begin3            ;     jumps to Ltmp23
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp22-Lfunc_begin3            ; >> Call Site 10 <<
	.uleb128 Ltmp27-Ltmp22                  ;   Call between Ltmp22 and Ltmp27
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp27-Lfunc_begin3            ; >> Call Site 11 <<
	.uleb128 Ltmp28-Ltmp27                  ;   Call between Ltmp27 and Ltmp28
	.uleb128 Ltmp29-Lfunc_begin3            ;     jumps to Ltmp29
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp30-Lfunc_begin3            ; >> Call Site 12 <<
	.uleb128 Ltmp31-Ltmp30                  ;   Call between Ltmp30 and Ltmp31
	.uleb128 Ltmp32-Lfunc_begin3            ;     jumps to Ltmp32
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp31-Lfunc_begin3            ; >> Call Site 13 <<
	.uleb128 Ltmp33-Ltmp31                  ;   Call between Ltmp31 and Ltmp33
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp33-Lfunc_begin3            ; >> Call Site 14 <<
	.uleb128 Ltmp34-Ltmp33                  ;   Call between Ltmp33 and Ltmp34
	.uleb128 Ltmp35-Lfunc_begin3            ;     jumps to Ltmp35
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp34-Lfunc_begin3            ; >> Call Site 15 <<
	.uleb128 Ltmp39-Ltmp34                  ;   Call between Ltmp34 and Ltmp39
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp39-Lfunc_begin3            ; >> Call Site 16 <<
	.uleb128 Ltmp42-Ltmp39                  ;   Call between Ltmp39 and Ltmp42
	.uleb128 Ltmp43-Lfunc_begin3            ;     jumps to Ltmp43
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp42-Lfunc_begin3            ; >> Call Site 17 <<
	.uleb128 Ltmp44-Ltmp42                  ;   Call between Ltmp42 and Ltmp44
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp44-Lfunc_begin3            ; >> Call Site 18 <<
	.uleb128 Ltmp45-Ltmp44                  ;   Call between Ltmp44 and Ltmp45
	.uleb128 Ltmp46-Lfunc_begin3            ;     jumps to Ltmp46
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp47-Lfunc_begin3            ; >> Call Site 19 <<
	.uleb128 Ltmp48-Ltmp47                  ;   Call between Ltmp47 and Ltmp48
	.uleb128 Ltmp49-Lfunc_begin3            ;     jumps to Ltmp49
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp24-Lfunc_begin3            ; >> Call Site 20 <<
	.uleb128 Ltmp25-Ltmp24                  ;   Call between Ltmp24 and Ltmp25
	.uleb128 Ltmp26-Lfunc_begin3            ;     jumps to Ltmp26
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp36-Lfunc_begin3            ; >> Call Site 21 <<
	.uleb128 Ltmp37-Ltmp36                  ;   Call between Ltmp36 and Ltmp37
	.uleb128 Ltmp38-Lfunc_begin3            ;     jumps to Ltmp38
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp50-Lfunc_begin3            ; >> Call Site 22 <<
	.uleb128 Ltmp51-Ltmp50                  ;   Call between Ltmp50 and Ltmp51
	.uleb128 Ltmp52-Lfunc_begin3            ;     jumps to Ltmp52
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp53-Lfunc_begin3            ; >> Call Site 23 <<
	.uleb128 Ltmp54-Ltmp53                  ;   Call between Ltmp53 and Ltmp54
	.uleb128 Ltmp55-Lfunc_begin3            ;     jumps to Ltmp55
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp58-Lfunc_begin3            ; >> Call Site 24 <<
	.uleb128 Ltmp59-Ltmp58                  ;   Call between Ltmp58 and Ltmp59
	.uleb128 Ltmp60-Lfunc_begin3            ;     jumps to Ltmp60
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp61-Lfunc_begin3            ; >> Call Site 25 <<
	.uleb128 Ltmp62-Ltmp61                  ;   Call between Ltmp61 and Ltmp62
	.uleb128 Ltmp63-Lfunc_begin3            ;     jumps to Ltmp63
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp62-Lfunc_begin3            ; >> Call Site 26 <<
	.uleb128 Ltmp323-Ltmp62                 ;   Call between Ltmp62 and Ltmp323
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp323-Lfunc_begin3           ; >> Call Site 27 <<
	.uleb128 Ltmp324-Ltmp323                ;   Call between Ltmp323 and Ltmp324
	.uleb128 Ltmp325-Lfunc_begin3           ;     jumps to Ltmp325
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp326-Lfunc_begin3           ; >> Call Site 28 <<
	.uleb128 Ltmp327-Ltmp326                ;   Call between Ltmp326 and Ltmp327
	.uleb128 Ltmp328-Lfunc_begin3           ;     jumps to Ltmp328
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp327-Lfunc_begin3           ; >> Call Site 29 <<
	.uleb128 Ltmp64-Ltmp327                 ;   Call between Ltmp327 and Ltmp64
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp64-Lfunc_begin3            ; >> Call Site 30 <<
	.uleb128 Ltmp65-Ltmp64                  ;   Call between Ltmp64 and Ltmp65
	.uleb128 Ltmp66-Lfunc_begin3            ;     jumps to Ltmp66
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp67-Lfunc_begin3            ; >> Call Site 31 <<
	.uleb128 Ltmp68-Ltmp67                  ;   Call between Ltmp67 and Ltmp68
	.uleb128 Ltmp69-Lfunc_begin3            ;     jumps to Ltmp69
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp70-Lfunc_begin3            ; >> Call Site 32 <<
	.uleb128 Ltmp71-Ltmp70                  ;   Call between Ltmp70 and Ltmp71
	.uleb128 Ltmp72-Lfunc_begin3            ;     jumps to Ltmp72
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp73-Lfunc_begin3            ; >> Call Site 33 <<
	.uleb128 Ltmp74-Ltmp73                  ;   Call between Ltmp73 and Ltmp74
	.uleb128 Ltmp86-Lfunc_begin3            ;     jumps to Ltmp86
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp75-Lfunc_begin3            ; >> Call Site 34 <<
	.uleb128 Ltmp78-Ltmp75                  ;   Call between Ltmp75 and Ltmp78
	.uleb128 Ltmp79-Lfunc_begin3            ;     jumps to Ltmp79
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp80-Lfunc_begin3            ; >> Call Site 35 <<
	.uleb128 Ltmp85-Ltmp80                  ;   Call between Ltmp80 and Ltmp85
	.uleb128 Ltmp86-Lfunc_begin3            ;     jumps to Ltmp86
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp87-Lfunc_begin3            ; >> Call Site 36 <<
	.uleb128 Ltmp88-Ltmp87                  ;   Call between Ltmp87 and Ltmp88
	.uleb128 Ltmp89-Lfunc_begin3            ;     jumps to Ltmp89
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp88-Lfunc_begin3            ; >> Call Site 37 <<
	.uleb128 Ltmp93-Ltmp88                  ;   Call between Ltmp88 and Ltmp93
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp93-Lfunc_begin3            ; >> Call Site 38 <<
	.uleb128 Ltmp94-Ltmp93                  ;   Call between Ltmp93 and Ltmp94
	.uleb128 Ltmp95-Lfunc_begin3            ;     jumps to Ltmp95
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp94-Lfunc_begin3            ; >> Call Site 39 <<
	.uleb128 Ltmp99-Ltmp94                  ;   Call between Ltmp94 and Ltmp99
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp99-Lfunc_begin3            ; >> Call Site 40 <<
	.uleb128 Ltmp108-Ltmp99                 ;   Call between Ltmp99 and Ltmp108
	.uleb128 Ltmp109-Lfunc_begin3           ;     jumps to Ltmp109
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp110-Lfunc_begin3           ; >> Call Site 41 <<
	.uleb128 Ltmp119-Ltmp110                ;   Call between Ltmp110 and Ltmp119
	.uleb128 Ltmp120-Lfunc_begin3           ;     jumps to Ltmp120
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp121-Lfunc_begin3           ; >> Call Site 42 <<
	.uleb128 Ltmp122-Ltmp121                ;   Call between Ltmp121 and Ltmp122
	.uleb128 Ltmp123-Lfunc_begin3           ;     jumps to Ltmp123
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp122-Lfunc_begin3           ; >> Call Site 43 <<
	.uleb128 Ltmp129-Ltmp122                ;   Call between Ltmp122 and Ltmp129
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp129-Lfunc_begin3           ; >> Call Site 44 <<
	.uleb128 Ltmp130-Ltmp129                ;   Call between Ltmp129 and Ltmp130
	.uleb128 Ltmp131-Lfunc_begin3           ;     jumps to Ltmp131
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp132-Lfunc_begin3           ; >> Call Site 45 <<
	.uleb128 Ltmp141-Ltmp132                ;   Call between Ltmp132 and Ltmp141
	.uleb128 Ltmp142-Lfunc_begin3           ;     jumps to Ltmp142
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp143-Lfunc_begin3           ; >> Call Site 46 <<
	.uleb128 Ltmp152-Ltmp143                ;   Call between Ltmp143 and Ltmp152
	.uleb128 Ltmp153-Lfunc_begin3           ;     jumps to Ltmp153
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp154-Lfunc_begin3           ; >> Call Site 47 <<
	.uleb128 Ltmp155-Ltmp154                ;   Call between Ltmp154 and Ltmp155
	.uleb128 Ltmp156-Lfunc_begin3           ;     jumps to Ltmp156
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp155-Lfunc_begin3           ; >> Call Site 48 <<
	.uleb128 Ltmp162-Ltmp155                ;   Call between Ltmp155 and Ltmp162
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp162-Lfunc_begin3           ; >> Call Site 49 <<
	.uleb128 Ltmp163-Ltmp162                ;   Call between Ltmp162 and Ltmp163
	.uleb128 Ltmp164-Lfunc_begin3           ;     jumps to Ltmp164
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp165-Lfunc_begin3           ; >> Call Site 50 <<
	.uleb128 Ltmp166-Ltmp165                ;   Call between Ltmp165 and Ltmp166
	.uleb128 Ltmp183-Lfunc_begin3           ;     jumps to Ltmp183
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp166-Lfunc_begin3           ; >> Call Site 51 <<
	.uleb128 Ltmp167-Ltmp166                ;   Call between Ltmp166 and Ltmp167
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp167-Lfunc_begin3           ; >> Call Site 52 <<
	.uleb128 Ltmp168-Ltmp167                ;   Call between Ltmp167 and Ltmp168
	.uleb128 Ltmp189-Lfunc_begin3           ;     jumps to Ltmp189
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp169-Lfunc_begin3           ; >> Call Site 53 <<
	.uleb128 Ltmp170-Ltmp169                ;   Call between Ltmp169 and Ltmp170
	.uleb128 Ltmp183-Lfunc_begin3           ;     jumps to Ltmp183
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp170-Lfunc_begin3           ; >> Call Site 54 <<
	.uleb128 Ltmp171-Ltmp170                ;   Call between Ltmp170 and Ltmp171
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp171-Lfunc_begin3           ; >> Call Site 55 <<
	.uleb128 Ltmp172-Ltmp171                ;   Call between Ltmp171 and Ltmp172
	.uleb128 Ltmp189-Lfunc_begin3           ;     jumps to Ltmp189
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp173-Lfunc_begin3           ; >> Call Site 56 <<
	.uleb128 Ltmp174-Ltmp173                ;   Call between Ltmp173 and Ltmp174
	.uleb128 Ltmp183-Lfunc_begin3           ;     jumps to Ltmp183
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp174-Lfunc_begin3           ; >> Call Site 57 <<
	.uleb128 Ltmp175-Ltmp174                ;   Call between Ltmp174 and Ltmp175
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp175-Lfunc_begin3           ; >> Call Site 58 <<
	.uleb128 Ltmp176-Ltmp175                ;   Call between Ltmp175 and Ltmp176
	.uleb128 Ltmp189-Lfunc_begin3           ;     jumps to Ltmp189
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp177-Lfunc_begin3           ; >> Call Site 59 <<
	.uleb128 Ltmp178-Ltmp177                ;   Call between Ltmp177 and Ltmp178
	.uleb128 Ltmp183-Lfunc_begin3           ;     jumps to Ltmp183
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp178-Lfunc_begin3           ; >> Call Site 60 <<
	.uleb128 Ltmp179-Ltmp178                ;   Call between Ltmp178 and Ltmp179
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp179-Lfunc_begin3           ; >> Call Site 61 <<
	.uleb128 Ltmp180-Ltmp179                ;   Call between Ltmp179 and Ltmp180
	.uleb128 Ltmp189-Lfunc_begin3           ;     jumps to Ltmp189
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp181-Lfunc_begin3           ; >> Call Site 62 <<
	.uleb128 Ltmp182-Ltmp181                ;   Call between Ltmp181 and Ltmp182
	.uleb128 Ltmp183-Lfunc_begin3           ;     jumps to Ltmp183
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp182-Lfunc_begin3           ; >> Call Site 63 <<
	.uleb128 Ltmp187-Ltmp182                ;   Call between Ltmp182 and Ltmp187
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp187-Lfunc_begin3           ; >> Call Site 64 <<
	.uleb128 Ltmp188-Ltmp187                ;   Call between Ltmp187 and Ltmp188
	.uleb128 Ltmp189-Lfunc_begin3           ;     jumps to Ltmp189
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp190-Lfunc_begin3           ; >> Call Site 65 <<
	.uleb128 Ltmp191-Ltmp190                ;   Call between Ltmp190 and Ltmp191
	.uleb128 Ltmp208-Lfunc_begin3           ;     jumps to Ltmp208
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp191-Lfunc_begin3           ; >> Call Site 66 <<
	.uleb128 Ltmp192-Ltmp191                ;   Call between Ltmp191 and Ltmp192
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp192-Lfunc_begin3           ; >> Call Site 67 <<
	.uleb128 Ltmp193-Ltmp192                ;   Call between Ltmp192 and Ltmp193
	.uleb128 Ltmp214-Lfunc_begin3           ;     jumps to Ltmp214
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp194-Lfunc_begin3           ; >> Call Site 68 <<
	.uleb128 Ltmp195-Ltmp194                ;   Call between Ltmp194 and Ltmp195
	.uleb128 Ltmp208-Lfunc_begin3           ;     jumps to Ltmp208
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp195-Lfunc_begin3           ; >> Call Site 69 <<
	.uleb128 Ltmp196-Ltmp195                ;   Call between Ltmp195 and Ltmp196
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp196-Lfunc_begin3           ; >> Call Site 70 <<
	.uleb128 Ltmp197-Ltmp196                ;   Call between Ltmp196 and Ltmp197
	.uleb128 Ltmp214-Lfunc_begin3           ;     jumps to Ltmp214
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp198-Lfunc_begin3           ; >> Call Site 71 <<
	.uleb128 Ltmp199-Ltmp198                ;   Call between Ltmp198 and Ltmp199
	.uleb128 Ltmp208-Lfunc_begin3           ;     jumps to Ltmp208
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp199-Lfunc_begin3           ; >> Call Site 72 <<
	.uleb128 Ltmp200-Ltmp199                ;   Call between Ltmp199 and Ltmp200
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp200-Lfunc_begin3           ; >> Call Site 73 <<
	.uleb128 Ltmp201-Ltmp200                ;   Call between Ltmp200 and Ltmp201
	.uleb128 Ltmp214-Lfunc_begin3           ;     jumps to Ltmp214
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp202-Lfunc_begin3           ; >> Call Site 74 <<
	.uleb128 Ltmp203-Ltmp202                ;   Call between Ltmp202 and Ltmp203
	.uleb128 Ltmp208-Lfunc_begin3           ;     jumps to Ltmp208
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp203-Lfunc_begin3           ; >> Call Site 75 <<
	.uleb128 Ltmp204-Ltmp203                ;   Call between Ltmp203 and Ltmp204
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp204-Lfunc_begin3           ; >> Call Site 76 <<
	.uleb128 Ltmp205-Ltmp204                ;   Call between Ltmp204 and Ltmp205
	.uleb128 Ltmp214-Lfunc_begin3           ;     jumps to Ltmp214
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp206-Lfunc_begin3           ; >> Call Site 77 <<
	.uleb128 Ltmp207-Ltmp206                ;   Call between Ltmp206 and Ltmp207
	.uleb128 Ltmp208-Lfunc_begin3           ;     jumps to Ltmp208
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp207-Lfunc_begin3           ; >> Call Site 78 <<
	.uleb128 Ltmp212-Ltmp207                ;   Call between Ltmp207 and Ltmp212
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp212-Lfunc_begin3           ; >> Call Site 79 <<
	.uleb128 Ltmp213-Ltmp212                ;   Call between Ltmp212 and Ltmp213
	.uleb128 Ltmp214-Lfunc_begin3           ;     jumps to Ltmp214
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp215-Lfunc_begin3           ; >> Call Site 80 <<
	.uleb128 Ltmp216-Ltmp215                ;   Call between Ltmp215 and Ltmp216
	.uleb128 Ltmp217-Lfunc_begin3           ;     jumps to Ltmp217
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp216-Lfunc_begin3           ; >> Call Site 81 <<
	.uleb128 Ltmp223-Ltmp216                ;   Call between Ltmp216 and Ltmp223
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp223-Lfunc_begin3           ; >> Call Site 82 <<
	.uleb128 Ltmp224-Ltmp223                ;   Call between Ltmp223 and Ltmp224
	.uleb128 Ltmp225-Lfunc_begin3           ;     jumps to Ltmp225
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp226-Lfunc_begin3           ; >> Call Site 83 <<
	.uleb128 Ltmp227-Ltmp226                ;   Call between Ltmp226 and Ltmp227
	.uleb128 Ltmp244-Lfunc_begin3           ;     jumps to Ltmp244
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp227-Lfunc_begin3           ; >> Call Site 84 <<
	.uleb128 Ltmp228-Ltmp227                ;   Call between Ltmp227 and Ltmp228
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp228-Lfunc_begin3           ; >> Call Site 85 <<
	.uleb128 Ltmp229-Ltmp228                ;   Call between Ltmp228 and Ltmp229
	.uleb128 Ltmp250-Lfunc_begin3           ;     jumps to Ltmp250
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp230-Lfunc_begin3           ; >> Call Site 86 <<
	.uleb128 Ltmp231-Ltmp230                ;   Call between Ltmp230 and Ltmp231
	.uleb128 Ltmp244-Lfunc_begin3           ;     jumps to Ltmp244
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp231-Lfunc_begin3           ; >> Call Site 87 <<
	.uleb128 Ltmp232-Ltmp231                ;   Call between Ltmp231 and Ltmp232
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp232-Lfunc_begin3           ; >> Call Site 88 <<
	.uleb128 Ltmp233-Ltmp232                ;   Call between Ltmp232 and Ltmp233
	.uleb128 Ltmp250-Lfunc_begin3           ;     jumps to Ltmp250
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp234-Lfunc_begin3           ; >> Call Site 89 <<
	.uleb128 Ltmp235-Ltmp234                ;   Call between Ltmp234 and Ltmp235
	.uleb128 Ltmp244-Lfunc_begin3           ;     jumps to Ltmp244
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp235-Lfunc_begin3           ; >> Call Site 90 <<
	.uleb128 Ltmp236-Ltmp235                ;   Call between Ltmp235 and Ltmp236
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp236-Lfunc_begin3           ; >> Call Site 91 <<
	.uleb128 Ltmp237-Ltmp236                ;   Call between Ltmp236 and Ltmp237
	.uleb128 Ltmp250-Lfunc_begin3           ;     jumps to Ltmp250
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp238-Lfunc_begin3           ; >> Call Site 92 <<
	.uleb128 Ltmp239-Ltmp238                ;   Call between Ltmp238 and Ltmp239
	.uleb128 Ltmp244-Lfunc_begin3           ;     jumps to Ltmp244
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp239-Lfunc_begin3           ; >> Call Site 93 <<
	.uleb128 Ltmp240-Ltmp239                ;   Call between Ltmp239 and Ltmp240
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp240-Lfunc_begin3           ; >> Call Site 94 <<
	.uleb128 Ltmp241-Ltmp240                ;   Call between Ltmp240 and Ltmp241
	.uleb128 Ltmp250-Lfunc_begin3           ;     jumps to Ltmp250
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp242-Lfunc_begin3           ; >> Call Site 95 <<
	.uleb128 Ltmp243-Ltmp242                ;   Call between Ltmp242 and Ltmp243
	.uleb128 Ltmp244-Lfunc_begin3           ;     jumps to Ltmp244
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp243-Lfunc_begin3           ; >> Call Site 96 <<
	.uleb128 Ltmp248-Ltmp243                ;   Call between Ltmp243 and Ltmp248
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp248-Lfunc_begin3           ; >> Call Site 97 <<
	.uleb128 Ltmp249-Ltmp248                ;   Call between Ltmp248 and Ltmp249
	.uleb128 Ltmp250-Lfunc_begin3           ;     jumps to Ltmp250
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp251-Lfunc_begin3           ; >> Call Site 98 <<
	.uleb128 Ltmp252-Ltmp251                ;   Call between Ltmp251 and Ltmp252
	.uleb128 Ltmp269-Lfunc_begin3           ;     jumps to Ltmp269
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp252-Lfunc_begin3           ; >> Call Site 99 <<
	.uleb128 Ltmp253-Ltmp252                ;   Call between Ltmp252 and Ltmp253
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp253-Lfunc_begin3           ; >> Call Site 100 <<
	.uleb128 Ltmp254-Ltmp253                ;   Call between Ltmp253 and Ltmp254
	.uleb128 Ltmp275-Lfunc_begin3           ;     jumps to Ltmp275
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp255-Lfunc_begin3           ; >> Call Site 101 <<
	.uleb128 Ltmp256-Ltmp255                ;   Call between Ltmp255 and Ltmp256
	.uleb128 Ltmp269-Lfunc_begin3           ;     jumps to Ltmp269
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp256-Lfunc_begin3           ; >> Call Site 102 <<
	.uleb128 Ltmp257-Ltmp256                ;   Call between Ltmp256 and Ltmp257
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp257-Lfunc_begin3           ; >> Call Site 103 <<
	.uleb128 Ltmp258-Ltmp257                ;   Call between Ltmp257 and Ltmp258
	.uleb128 Ltmp275-Lfunc_begin3           ;     jumps to Ltmp275
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp259-Lfunc_begin3           ; >> Call Site 104 <<
	.uleb128 Ltmp260-Ltmp259                ;   Call between Ltmp259 and Ltmp260
	.uleb128 Ltmp269-Lfunc_begin3           ;     jumps to Ltmp269
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp260-Lfunc_begin3           ; >> Call Site 105 <<
	.uleb128 Ltmp261-Ltmp260                ;   Call between Ltmp260 and Ltmp261
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp261-Lfunc_begin3           ; >> Call Site 106 <<
	.uleb128 Ltmp262-Ltmp261                ;   Call between Ltmp261 and Ltmp262
	.uleb128 Ltmp275-Lfunc_begin3           ;     jumps to Ltmp275
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp263-Lfunc_begin3           ; >> Call Site 107 <<
	.uleb128 Ltmp264-Ltmp263                ;   Call between Ltmp263 and Ltmp264
	.uleb128 Ltmp269-Lfunc_begin3           ;     jumps to Ltmp269
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp264-Lfunc_begin3           ; >> Call Site 108 <<
	.uleb128 Ltmp265-Ltmp264                ;   Call between Ltmp264 and Ltmp265
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp265-Lfunc_begin3           ; >> Call Site 109 <<
	.uleb128 Ltmp266-Ltmp265                ;   Call between Ltmp265 and Ltmp266
	.uleb128 Ltmp275-Lfunc_begin3           ;     jumps to Ltmp275
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp267-Lfunc_begin3           ; >> Call Site 110 <<
	.uleb128 Ltmp268-Ltmp267                ;   Call between Ltmp267 and Ltmp268
	.uleb128 Ltmp269-Lfunc_begin3           ;     jumps to Ltmp269
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp268-Lfunc_begin3           ; >> Call Site 111 <<
	.uleb128 Ltmp273-Ltmp268                ;   Call between Ltmp268 and Ltmp273
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp273-Lfunc_begin3           ; >> Call Site 112 <<
	.uleb128 Ltmp274-Ltmp273                ;   Call between Ltmp273 and Ltmp274
	.uleb128 Ltmp275-Lfunc_begin3           ;     jumps to Ltmp275
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp276-Lfunc_begin3           ; >> Call Site 113 <<
	.uleb128 Ltmp277-Ltmp276                ;   Call between Ltmp276 and Ltmp277
	.uleb128 Ltmp278-Lfunc_begin3           ;     jumps to Ltmp278
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp277-Lfunc_begin3           ; >> Call Site 114 <<
	.uleb128 Ltmp284-Ltmp277                ;   Call between Ltmp277 and Ltmp284
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp284-Lfunc_begin3           ; >> Call Site 115 <<
	.uleb128 Ltmp285-Ltmp284                ;   Call between Ltmp284 and Ltmp285
	.uleb128 Ltmp286-Lfunc_begin3           ;     jumps to Ltmp286
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp287-Lfunc_begin3           ; >> Call Site 116 <<
	.uleb128 Ltmp288-Ltmp287                ;   Call between Ltmp287 and Ltmp288
	.uleb128 Ltmp289-Lfunc_begin3           ;     jumps to Ltmp289
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp296-Lfunc_begin3           ; >> Call Site 117 <<
	.uleb128 Ltmp321-Ltmp296                ;   Call between Ltmp296 and Ltmp321
	.uleb128 Ltmp322-Lfunc_begin3           ;     jumps to Ltmp322
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp209-Lfunc_begin3           ; >> Call Site 118 <<
	.uleb128 Ltmp210-Ltmp209                ;   Call between Ltmp209 and Ltmp210
	.uleb128 Ltmp211-Lfunc_begin3           ;     jumps to Ltmp211
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp270-Lfunc_begin3           ; >> Call Site 119 <<
	.uleb128 Ltmp271-Ltmp270                ;   Call between Ltmp270 and Ltmp271
	.uleb128 Ltmp272-Lfunc_begin3           ;     jumps to Ltmp272
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp271-Lfunc_begin3           ; >> Call Site 120 <<
	.uleb128 Ltmp290-Ltmp271                ;   Call between Ltmp271 and Ltmp290
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp290-Lfunc_begin3           ; >> Call Site 121 <<
	.uleb128 Ltmp291-Ltmp290                ;   Call between Ltmp290 and Ltmp291
	.uleb128 Ltmp292-Lfunc_begin3           ;     jumps to Ltmp292
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp293-Lfunc_begin3           ; >> Call Site 122 <<
	.uleb128 Ltmp294-Ltmp293                ;   Call between Ltmp293 and Ltmp294
	.uleb128 Ltmp295-Lfunc_begin3           ;     jumps to Ltmp295
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp126-Lfunc_begin3           ; >> Call Site 123 <<
	.uleb128 Ltmp125-Ltmp126                ;   Call between Ltmp126 and Ltmp125
	.uleb128 Ltmp128-Lfunc_begin3           ;     jumps to Ltmp128
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp159-Lfunc_begin3           ; >> Call Site 124 <<
	.uleb128 Ltmp158-Ltmp159                ;   Call between Ltmp159 and Ltmp158
	.uleb128 Ltmp161-Lfunc_begin3           ;     jumps to Ltmp161
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp220-Lfunc_begin3           ; >> Call Site 125 <<
	.uleb128 Ltmp219-Ltmp220                ;   Call between Ltmp220 and Ltmp219
	.uleb128 Ltmp222-Lfunc_begin3           ;     jumps to Ltmp222
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp281-Lfunc_begin3           ; >> Call Site 126 <<
	.uleb128 Ltmp280-Ltmp281                ;   Call between Ltmp281 and Ltmp280
	.uleb128 Ltmp283-Lfunc_begin3           ;     jumps to Ltmp283
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp184-Lfunc_begin3           ; >> Call Site 127 <<
	.uleb128 Ltmp185-Ltmp184                ;   Call between Ltmp184 and Ltmp185
	.uleb128 Ltmp186-Lfunc_begin3           ;     jumps to Ltmp186
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp245-Lfunc_begin3           ; >> Call Site 128 <<
	.uleb128 Ltmp246-Ltmp245                ;   Call between Ltmp245 and Ltmp246
	.uleb128 Ltmp247-Lfunc_begin3           ;     jumps to Ltmp247
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp90-Lfunc_begin3            ; >> Call Site 129 <<
	.uleb128 Ltmp91-Ltmp90                  ;   Call between Ltmp90 and Ltmp91
	.uleb128 Ltmp92-Lfunc_begin3            ;     jumps to Ltmp92
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp96-Lfunc_begin3            ; >> Call Site 130 <<
	.uleb128 Ltmp97-Ltmp96                  ;   Call between Ltmp96 and Ltmp97
	.uleb128 Ltmp98-Lfunc_begin3            ;     jumps to Ltmp98
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp97-Lfunc_begin3            ; >> Call Site 131 <<
	.uleb128 Ltmp56-Ltmp97                  ;   Call between Ltmp97 and Ltmp56
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp56-Lfunc_begin3            ; >> Call Site 132 <<
	.uleb128 Ltmp57-Ltmp56                  ;   Call between Ltmp56 and Ltmp57
	.uleb128 Ltmp66-Lfunc_begin3            ;     jumps to Ltmp66
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp57-Lfunc_begin3            ; >> Call Site 133 <<
	.uleb128 Ltmp329-Ltmp57                 ;   Call between Ltmp57 and Ltmp329
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp329-Lfunc_begin3           ; >> Call Site 134 <<
	.uleb128 Ltmp332-Ltmp329                ;   Call between Ltmp329 and Ltmp332
	.uleb128 Ltmp333-Lfunc_begin3           ;     jumps to Ltmp333
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp337-Lfunc_begin3           ; >> Call Site 135 <<
	.uleb128 Ltmp338-Ltmp337                ;   Call between Ltmp337 and Ltmp338
	.uleb128 Ltmp339-Lfunc_begin3           ;     jumps to Ltmp339
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp338-Lfunc_begin3           ; >> Call Site 136 <<
	.uleb128 Ltmp334-Ltmp338                ;   Call between Ltmp338 and Ltmp334
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp334-Lfunc_begin3           ; >> Call Site 137 <<
	.uleb128 Ltmp335-Ltmp334                ;   Call between Ltmp334 and Ltmp335
	.uleb128 Ltmp336-Lfunc_begin3           ;     jumps to Ltmp336
	.byte	9                               ;   On action: 5
	.uleb128 Ltmp335-Lfunc_begin3           ; >> Call Site 138 <<
	.uleb128 Lfunc_end3-Ltmp335             ;   Call between Ltmp335 and Lfunc_end3
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end3:
	.byte	0                               ; >> Action Record 1 <<
                                        ;   Cleanup
	.byte	0                               ;   No further actions
	.byte	0                               ; >> Action Record 2 <<
                                        ;   Cleanup
	.byte	125                             ;   Continue to action 1
	.byte	1                               ; >> Action Record 3 <<
                                        ;   Catch TypeInfo 1
	.byte	125                             ;   Continue to action 2
	.byte	2                               ; >> Action Record 4 <<
                                        ;   Catch TypeInfo 2
	.byte	125                             ;   Continue to action 3
	.byte	3                               ; >> Action Record 5 <<
                                        ;   Catch TypeInfo 3
	.byte	121                             ;   Continue to action 2
	.p2align	2, 0x0
                                        ; >> Catch TypeInfos <<
	.long	0                               ; TypeInfo 3
Ltmp380:                                ; TypeInfo 2
	.long	__ZTISt16invalid_argument@GOT-Ltmp380
Ltmp381:                                ; TypeInfo 1
	.long	__ZTISt9exception@GOT-Ltmp381
Lttbase0:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__literal16,16byte_literals
	.p2align	4, 0x0                          ; -- Begin function _Z7convertILb0EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
lCPI5_0:
	.byte	12                              ; 0xc
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	13                              ; 0xd
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	14                              ; 0xe
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	15                              ; 0xf
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
lCPI5_1:
	.byte	8                               ; 0x8
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	9                               ; 0x9
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	10                              ; 0xa
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	11                              ; 0xb
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
lCPI5_2:
	.byte	4                               ; 0x4
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	5                               ; 0x5
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	6                               ; 0x6
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	7                               ; 0x7
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
lCPI5_3:
	.byte	0                               ; 0x0
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	1                               ; 0x1
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	2                               ; 0x2
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	3                               ; 0x3
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__Z7convertILb0EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
	.weak_def_can_be_hidden	__Z7convertILb0EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
	.p2align	2
__Z7convertILb0EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE: ; @_Z7convertILb0EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Lfunc_begin4:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception4
; %bb.0:
	sub	sp, sp, #320
	stp	x28, x27, [sp, #224]            ; 16-byte Folded Spill
	stp	x26, x25, [sp, #240]            ; 16-byte Folded Spill
	stp	x24, x23, [sp, #256]            ; 16-byte Folded Spill
	stp	x22, x21, [sp, #272]            ; 16-byte Folded Spill
	stp	x20, x19, [sp, #288]            ; 16-byte Folded Spill
	stp	x29, x30, [sp, #304]            ; 16-byte Folded Spill
	add	x29, sp, #304
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_offset w23, -56
	.cfi_offset w24, -64
	.cfi_offset w25, -72
	.cfi_offset w26, -80
	.cfi_offset w27, -88
	.cfi_offset w28, -96
                                        ; kill: def $w2 killed $w2 def $x2
                                        ; kill: def $w1 killed $w1 def $x1
	cmp	w2, #1, lsl #12                 ; =4096
	b.gt	LBB5_92
; %bb.1:
	cmp	w1, #1, lsl #12                 ; =4096
	b.gt	LBB5_92
; %bb.2:
	orr	w8, w2, w1
	tbnz	w8, #31, LBB5_92
; %bb.3:
	add	w8, w1, w1, lsl #1
	cmp	w3, w8
	b.lt	LBB5_92
; %bb.4:
	ldp	x8, x9, [x0]
	umull	x10, w3, w2
	sub	x9, x9, x8
	cmp	x9, x10
	b.ne	LBB5_92
; %bb.5:
	ldp	x12, x9, [x4]
	sub	x9, x9, x12
	sxtw	x11, w1
	sxtw	x10, w2
	add	x13, x11, w1, sxtw #1
	str	x13, [sp, #80]                  ; 8-byte Folded Spill
	mul	x10, x13, x10
	cmp	x10, x9, asr #2
	b.ne	LBB5_93
; %bb.6:
	mul	w9, w2, w1
	str	x9, [sp, #136]                  ; 8-byte Folded Spill
	cmp	w2, #1
	b.lt	LBB5_51
; %bb.7:
	mov	w6, w3
	mov	w17, w2
	cmp	w1, #8
	b.ge	LBB5_18
; %bb.8:
	cmp	w1, #1
	b.lt	LBB5_51
; %bb.9:
	mov	w11, #0                         ; =0x0
	ldr	x9, [sp, #136]                  ; 8-byte Folded Reload
	lsl	w13, w9, #1
	add	x14, x8, #10
	ldr	x10, [sp, #136]                 ; 8-byte Folded Reload
	b	LBB5_11
LBB5_10:                                ;   in Loop: Header=BB5_11 Depth=1
	add	w11, w11, w1
	add	x14, x14, x6
	subs	x17, x17, #1
	b.eq	LBB5_51
LBB5_11:                                ; =>This Inner Loop Header: Depth=1
	ldur	b0, [x14, #-10]
	ucvtf	s0, s0
	str	s0, [x12, w11, sxtw #2]
	ldur	b0, [x14, #-9]
	ucvtf	s0, s0
	add	w8, w10, w11
	str	s0, [x12, w8, sxtw #2]
	ldur	b0, [x14, #-8]
	ucvtf	s0, s0
	add	w8, w13, w11
	str	s0, [x12, w8, sxtw #2]
	cmp	w1, #1
	b.eq	LBB5_10
; %bb.12:                               ;   in Loop: Header=BB5_11 Depth=1
	ldur	b0, [x14, #-7]
	ucvtf	s0, s0
	add	w8, w11, #1
	str	s0, [x12, w8, sxtw #2]
	ldur	b0, [x14, #-6]
	ucvtf	s0, s0
	add	w9, w8, w10
	str	s0, [x12, w9, sxtw #2]
	ldur	b0, [x14, #-5]
	ucvtf	s0, s0
	add	w8, w8, w13
	str	s0, [x12, w8, sxtw #2]
	cmp	w1, #2
	b.eq	LBB5_10
; %bb.13:                               ;   in Loop: Header=BB5_11 Depth=1
	ldur	b0, [x14, #-4]
	ucvtf	s0, s0
	add	w8, w11, #2
	str	s0, [x12, w8, sxtw #2]
	ldur	b0, [x14, #-3]
	ucvtf	s0, s0
	add	w9, w8, w10
	str	s0, [x12, w9, sxtw #2]
	ldur	b0, [x14, #-2]
	ucvtf	s0, s0
	add	w8, w8, w13
	str	s0, [x12, w8, sxtw #2]
	cmp	w1, #3
	b.eq	LBB5_10
; %bb.14:                               ;   in Loop: Header=BB5_11 Depth=1
	ldur	b0, [x14, #-1]
	ucvtf	s0, s0
	add	w8, w11, #3
	str	s0, [x12, w8, sxtw #2]
	ldr	b0, [x14]
	ucvtf	s0, s0
	add	w9, w8, w10
	str	s0, [x12, w9, sxtw #2]
	ldr	b0, [x14, #1]
	ucvtf	s0, s0
	add	w8, w8, w13
	str	s0, [x12, w8, sxtw #2]
	cmp	w1, #4
	b.eq	LBB5_10
; %bb.15:                               ;   in Loop: Header=BB5_11 Depth=1
	ldr	b0, [x14, #2]
	ucvtf	s0, s0
	add	w8, w11, #4
	str	s0, [x12, w8, sxtw #2]
	ldr	b0, [x14, #3]
	ucvtf	s0, s0
	add	w9, w8, w10
	str	s0, [x12, w9, sxtw #2]
	ldr	b0, [x14, #4]
	ucvtf	s0, s0
	add	w8, w8, w13
	str	s0, [x12, w8, sxtw #2]
	cmp	w1, #5
	b.eq	LBB5_10
; %bb.16:                               ;   in Loop: Header=BB5_11 Depth=1
	ldr	b0, [x14, #5]
	ucvtf	s0, s0
	add	w8, w11, #5
	str	s0, [x12, w8, sxtw #2]
	ldr	b0, [x14, #6]
	ucvtf	s0, s0
	add	w9, w8, w10
	str	s0, [x12, w9, sxtw #2]
	ldr	b0, [x14, #7]
	ucvtf	s0, s0
	add	w8, w8, w13
	str	s0, [x12, w8, sxtw #2]
	cmp	w1, #6
	b.eq	LBB5_10
; %bb.17:                               ;   in Loop: Header=BB5_11 Depth=1
	ldr	b0, [x14, #8]
	ucvtf	s0, s0
	add	w8, w11, #6
	str	s0, [x12, w8, sxtw #2]
	ldr	b0, [x14, #9]
	ucvtf	s0, s0
	add	w9, w8, w10
	str	s0, [x12, w9, sxtw #2]
	ldr	b0, [x14, #10]
	ucvtf	s0, s0
	add	w8, w8, w13
	str	s0, [x12, w8, sxtw #2]
	b	LBB5_10
LBB5_18:
	mov	x19, #0                         ; =0x0
	mov	w14, #0                         ; =0x0
	and	w21, w1, #0x7ffffff8
	ldr	x12, [sp, #136]                 ; 8-byte Folded Reload
	lsl	w16, w12, #1
	mvn	x9, x21
	add	x13, x9, x11
	add	w2, w12, w21
	add	w30, w16, w21
	sub	x9, x19, w21, uxtw #2
	str	x9, [sp, #64]                   ; 8-byte Folded Spill
	and	x9, x11, #0x7
	sub	x15, x11, x21
	sub	x9, x15, x9
	stp	x13, x15, [sp, #120]            ; 16-byte Folded Spill
	and	x15, x15, #0xfffffffffffffff0
	stp	x9, x15, [sp, #24]              ; 16-byte Folded Spill
	add	x15, x15, x21
	str	x15, [sp]                       ; 8-byte Folded Spill
	lsl	x15, x11, #2
	str	x15, [sp, #152]                 ; 8-byte Folded Spill
	add	x9, x9, x21
	str	x9, [sp, #16]                   ; 8-byte Folded Spill
	and	w9, w1, #0x7
	str	w9, [sp, #12]                   ; 4-byte Folded Spill
	ubfiz	x24, x12, #2, #32
	ubfiz	x25, x12, #3, #32
	ubfx	x8, x1, #3, #28
	add	x8, x8, x8, lsl #1
	lsl	x26, x8, #3
	lsr	x8, x13, #32
	str	x8, [sp, #72]                   ; 8-byte Folded Spill
Lloh68:
	adrp	x8, lCPI5_2@PAGE
Lloh69:
	ldr	q0, [x8, lCPI5_2@PAGEOFF]
Lloh70:
	adrp	x8, lCPI5_3@PAGE
Lloh71:
	ldr	q1, [x8, lCPI5_3@PAGEOFF]
Lloh72:
	adrp	x8, lCPI5_0@PAGE
Lloh73:
	ldr	q2, [x8, lCPI5_0@PAGEOFF]
Lloh74:
	adrp	x8, lCPI5_1@PAGE
Lloh75:
	ldr	q3, [x8, lCPI5_1@PAGEOFF]
	mov	x28, x12
	stp	x30, x2, [x29, #-144]           ; 16-byte Folded Spill
	mov	x15, x21
	mov	x13, #0                         ; =0x0
	mov	x22, #0                         ; =0x0
	add	x8, x21, w21, uxtw #1
	str	x8, [sp, #56]                   ; 8-byte Folded Spill
	mov	w8, w1
	str	x8, [sp, #144]                  ; 8-byte Folded Spill
	stp	x17, x6, [x29, #-128]           ; 16-byte Folded Spill
	stp	x21, x1, [sp, #40]              ; 16-byte Folded Spill
	b	LBB5_20
LBB5_19:                                ;   in Loop: Header=BB5_20 Depth=1
	add	x22, x22, #1
	ldp	x17, x6, [x29, #-128]           ; 16-byte Folded Reload
	add	x13, x13, x6
	ldp	x8, x9, [sp, #144]              ; 16-byte Folded Reload
	add	x19, x19, x9
	add	x15, x15, x8
	add	x26, x26, x6
	add	x2, x2, x8
	add	x30, x30, x8
	add	w28, w28, w1
	add	w14, w14, w1
	cmp	x22, x17
	b.eq	LBB5_51
LBB5_20:                                ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB5_21 Depth 2
                                        ;     Child Loop BB5_48 Depth 2
                                        ;     Child Loop BB5_45 Depth 2
                                        ;     Child Loop BB5_25 Depth 2
	mul	w8, w1, w22
	add	w9, w21, w8
	sbfiz	x12, x9, #2, #32
	stur	x12, [x29, #-104]               ; 8-byte Folded Spill
	add	x12, x11, w9, sxtw
	lsl	x10, x12, #2
	ldur	x12, [x29, #-136]               ; 8-byte Folded Reload
	add	w12, w12, w8
	sbfiz	x17, x12, #2, #32
	stur	x17, [x29, #-96]                ; 8-byte Folded Spill
	add	x17, x11, w12, sxtw
	lsl	x3, x17, #2
	ldur	x17, [x29, #-144]               ; 8-byte Folded Reload
	add	w5, w17, w8
	sbfiz	x7, x5, #2, #32
	add	x8, x11, w5, sxtw
	lsl	x8, x8, #2
	stur	x8, [x29, #-112]                ; 8-byte Folded Spill
	mul	x8, x22, x6
	mov	x23, x19
	mov	x27, x13
	mov	w17, #8                         ; =0x8
LBB5_21:                                ;   Parent Loop BB5_20 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	x20, [x0]
	add	x20, x20, x27
	ld3.8b	{ v4, v5, v6 }, [x20]
	ushll.8h	v7, v4, #0
	ushll.4s	v16, v7, #0
	ucvtf.4s	v16, v16
	ushll2.4s	v7, v7, #0
	ucvtf.4s	v7, v7
	ldr	x20, [x4]
	str	q16, [x20, x23]
	ldr	x20, [x4]
	add	x20, x20, x23
	str	q7, [x20, #16]
	ushll.8h	v7, v5, #0
	ushll.4s	v16, v7, #0
	ucvtf.4s	v16, v16
	ushll2.4s	v7, v7, #0
	ucvtf.4s	v7, v7
	ldr	x20, [x4]
	add	x20, x20, x24
	str	q16, [x20, x23]
	ldr	x20, [x4]
	add	x6, x24, x23
	add	x6, x20, x6
	str	q7, [x6, #16]
	ushll.8h	v4, v6, #0
	ushll.4s	v5, v4, #0
	ucvtf.4s	v5, v5
	ushll2.4s	v4, v4, #0
	ucvtf.4s	v4, v4
	ldr	x6, [x4]
	add	x6, x6, x25
	str	q5, [x6, x23]
	ldr	x6, [x4]
	add	x20, x25, x23
	add	x6, x6, x20
	str	q4, [x6, #16]
	add	x17, x17, #8
	add	x27, x27, #24
	add	x23, x23, #32
	cmp	x17, x11
	b.le	LBB5_21
; %bb.22:                               ;   in Loop: Header=BB5_20 Depth=1
	cmp	w21, w1
	b.eq	LBB5_19
; %bb.23:                               ;   in Loop: Header=BB5_20 Depth=1
	ldr	x20, [x0]
	ldr	x27, [x4]
	mov	x23, x21
	ldr	x17, [sp, #128]                 ; 8-byte Folded Reload
	cmp	x17, #7
	b.hi	LBB5_26
LBB5_24:                                ;   in Loop: Header=BB5_20 Depth=1
	sub	x8, x11, x23
	add	w9, w28, w23
	add	x12, x23, x23, lsl #1
	add	x12, x13, x12
	add	x12, x20, x12
	add	w17, w14, w23
LBB5_25:                                ;   Parent Loop BB5_20 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	b4, [x12]
	ucvtf	s4, s4
	str	s4, [x27, w17, sxtw #2]
	ldr	b4, [x12, #1]
	ucvtf	s4, s4
	str	s4, [x27, w9, sxtw #2]
	ldr	b4, [x12, #2]
	ucvtf	s4, s4
	add	w3, w16, w17
	str	s4, [x27, w3, sxtw #2]
	add	w9, w9, #1
	add	x12, x12, #3
	add	w17, w17, #1
	subs	x8, x8, #1
	b.ne	LBB5_25
	b	LBB5_19
LBB5_26:                                ;   in Loop: Header=BB5_20 Depth=1
	ldr	x17, [sp, #120]                 ; 8-byte Folded Reload
	add	w17, w5, w17
	cmp	w17, w5
	mov	x23, x21
	b.lt	LBB5_24
; %bb.27:                               ;   in Loop: Header=BB5_20 Depth=1
	ldr	x17, [sp, #120]                 ; 8-byte Folded Reload
	add	w17, w9, w17
	cmp	w17, w9
	mov	x23, x21
	b.lt	LBB5_24
; %bb.28:                               ;   in Loop: Header=BB5_20 Depth=1
	ldr	x9, [sp, #120]                  ; 8-byte Folded Reload
	add	w9, w12, w9
	cmp	w9, w12
	mov	x23, x21
	b.lt	LBB5_24
; %bb.29:                               ;   in Loop: Header=BB5_20 Depth=1
	mov	x23, x21
	ldr	x9, [sp, #72]                   ; 8-byte Folded Reload
	cbnz	x9, LBB5_24
; %bb.30:                               ;   in Loop: Header=BB5_20 Depth=1
	ldr	x9, [sp, #80]                   ; 8-byte Folded Reload
	add	x9, x20, x9
	add	x23, x9, x8
	mov	x5, x10
	sub	x10, x23, #2
	ldur	x9, [x29, #-104]                ; 8-byte Folded Reload
	add	x12, x27, x9
	ldr	x9, [sp, #64]                   ; 8-byte Folded Reload
	add	x17, x27, x9
	add	x5, x17, x5
	add	x3, x17, x3
	add	x7, x27, x7
	ldr	x9, [sp, #56]                   ; 8-byte Folded Reload
	add	x6, x20, x9
	add	x6, x6, x8
	add	x9, x6, #1
	sub	x1, x23, #1
	stur	x20, [x29, #-104]               ; 8-byte Folded Spill
	add	x20, x6, #2
	str	x20, [sp, #112]                 ; 8-byte Folded Spill
	ldur	x8, [x29, #-112]                ; 8-byte Folded Reload
	add	x17, x17, x8
	cmp	x12, x17
	ccmp	x7, x5, #2, lo
	cset	w8, lo
	stur	w8, [x29, #-112]                ; 4-byte Folded Spill
	cmp	x12, x10
	ccmp	x6, x5, #2, lo
	cset	w8, lo
	str	w8, [sp, #108]                  ; 4-byte Folded Spill
	cmp	x12, x1
	ccmp	x9, x5, #2, lo
	cset	w8, lo
	str	w8, [sp, #104]                  ; 4-byte Folded Spill
	cmp	x12, x23
	ccmp	x20, x5, #2, lo
	cset	w8, lo
	str	w8, [sp, #100]                  ; 4-byte Folded Spill
	ldur	x8, [x29, #-96]                 ; 8-byte Folded Reload
	add	x8, x27, x8
	cmp	x8, x17
	ccmp	x7, x3, #2, lo
	cset	w20, lo
	stur	w20, [x29, #-96]                ; 4-byte Folded Spill
	cmp	x8, x10
	ccmp	x6, x3, #2, lo
	cset	w20, lo
	str	w20, [sp, #96]                  ; 4-byte Folded Spill
	cmp	x8, x1
	ccmp	x9, x3, #2, lo
	cset	w20, lo
	str	w20, [sp, #92]                  ; 4-byte Folded Spill
	cmp	x8, x23
	ldr	x21, [sp, #112]                 ; 8-byte Folded Reload
	ccmp	x21, x3, #2, lo
	cset	w20, lo
	str	w20, [sp, #88]                  ; 4-byte Folded Spill
	cmp	x7, x10
	ccmp	x6, x17, #2, lo
	cset	w6, lo
	cmp	x7, x1
	ccmp	x9, x17, #2, lo
	cset	w10, lo
	cmp	x7, x23
	ccmp	x21, x17, #2, lo
	ldp	x21, x1, [sp, #40]              ; 16-byte Folded Reload
	ldur	x20, [x29, #-104]               ; 8-byte Folded Reload
	cset	w9, lo
	cmp	x8, x5
	ccmp	x12, x3, #2, lo
	mov	x23, x21
	b.lo	LBB5_24
; %bb.31:                               ;   in Loop: Header=BB5_20 Depth=1
	mov	x23, x21
	ldur	w8, [x29, #-112]                ; 4-byte Folded Reload
	tbnz	w8, #0, LBB5_24
; %bb.32:                               ;   in Loop: Header=BB5_20 Depth=1
	mov	x23, x21
	ldr	w8, [sp, #108]                  ; 4-byte Folded Reload
	tbnz	w8, #0, LBB5_24
; %bb.33:                               ;   in Loop: Header=BB5_20 Depth=1
	mov	x23, x21
	ldr	w8, [sp, #104]                  ; 4-byte Folded Reload
	tbnz	w8, #0, LBB5_24
; %bb.34:                               ;   in Loop: Header=BB5_20 Depth=1
	mov	x23, x21
	ldr	w8, [sp, #100]                  ; 4-byte Folded Reload
	tbnz	w8, #0, LBB5_24
; %bb.35:                               ;   in Loop: Header=BB5_20 Depth=1
	mov	x23, x21
	ldur	w8, [x29, #-96]                 ; 4-byte Folded Reload
	tbnz	w8, #0, LBB5_24
; %bb.36:                               ;   in Loop: Header=BB5_20 Depth=1
	mov	x23, x21
	ldr	w8, [sp, #96]                   ; 4-byte Folded Reload
	tbnz	w8, #0, LBB5_24
; %bb.37:                               ;   in Loop: Header=BB5_20 Depth=1
	mov	x23, x21
	ldr	w8, [sp, #92]                   ; 4-byte Folded Reload
	tbnz	w8, #0, LBB5_24
; %bb.38:                               ;   in Loop: Header=BB5_20 Depth=1
	mov	x23, x21
	ldr	w8, [sp, #88]                   ; 4-byte Folded Reload
	tbnz	w8, #0, LBB5_24
; %bb.39:                               ;   in Loop: Header=BB5_20 Depth=1
	mov	x23, x21
	tbnz	w6, #0, LBB5_24
; %bb.40:                               ;   in Loop: Header=BB5_20 Depth=1
	mov	x23, x21
	tbnz	w10, #0, LBB5_24
; %bb.41:                               ;   in Loop: Header=BB5_20 Depth=1
	mov	x23, x21
	tbnz	w9, #0, LBB5_24
; %bb.42:                               ;   in Loop: Header=BB5_20 Depth=1
	ldr	x8, [sp, #128]                  ; 8-byte Folded Reload
	cmp	x8, #16
	b.hs	LBB5_47
; %bb.43:                               ;   in Loop: Header=BB5_20 Depth=1
	mov	x8, #0                          ; =0x0
LBB5_44:                                ;   in Loop: Header=BB5_20 Depth=1
	add	x9, x8, x8, lsl #1
	add	x9, x20, x9
	ldr	x17, [sp, #24]                  ; 8-byte Folded Reload
LBB5_45:                                ;   Parent Loop BB5_20 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	add	x12, x9, x26
	ld3.8b	{ v4, v5, v6 }, [x12]
	add	w12, w15, w8
	tbl.16b	v7, { v4 }, v0
	tbl.16b	v16, { v4 }, v1
	ucvtf.4s	v16, v16
	ucvtf.4s	v7, v7
	add	x12, x27, w12, sxtw #2
	stp	q16, q7, [x12]
	tbl.16b	v7, { v5 }, v0
	tbl.16b	v16, { v5 }, v1
	ucvtf.4s	v16, v16
	ucvtf.4s	v7, v7
	add	w12, w2, w8
	add	x12, x27, w12, sxtw #2
	stp	q16, q7, [x12]
	tbl.16b	v7, { v6 }, v0
	tbl.16b	v4, { v6 }, v1
	ucvtf.4s	v4, v4
	ucvtf.4s	v5, v7
	add	w12, w30, w8
	add	x12, x27, w12, sxtw #2
	stp	q4, q5, [x12]
	add	x8, x8, #8
	add	x9, x9, #24
	cmp	x17, x8
	b.ne	LBB5_45
; %bb.46:                               ;   in Loop: Header=BB5_20 Depth=1
	ldr	x23, [sp, #16]                  ; 8-byte Folded Reload
	ldr	w8, [sp, #12]                   ; 4-byte Folded Reload
	cbnz	w8, LBB5_24
	b	LBB5_19
LBB5_47:                                ;   in Loop: Header=BB5_20 Depth=1
	add	x8, x20, x26
	ldr	x9, [sp, #32]                   ; 8-byte Folded Reload
	mov	x12, x15
	ldr	x3, [sp, #136]                  ; 8-byte Folded Reload
LBB5_48:                                ;   Parent Loop BB5_20 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ld3.16b	{ v4, v5, v6 }, [x8], #48
	tbl.16b	v7, { v4 }, v2
	tbl.16b	v16, { v4 }, v3
	tbl.16b	v17, { v4 }, v0
	tbl.16b	v18, { v4 }, v1
	ucvtf.4s	v18, v18
	ucvtf.4s	v17, v17
	ucvtf.4s	v16, v16
	ucvtf.4s	v7, v7
	add	x17, x27, w12, sxtw #2
	stp	q16, q7, [x17, #32]
	stp	q18, q17, [x17]
	tbl.16b	v7, { v5 }, v2
	tbl.16b	v16, { v5 }, v3
	tbl.16b	v17, { v5 }, v0
	tbl.16b	v18, { v5 }, v1
	ucvtf.4s	v18, v18
	ucvtf.4s	v16, v16
	ucvtf.4s	v7, v7
	add	w17, w3, w12
	add	x17, x27, w17, sxtw #2
	stp	q16, q7, [x17, #32]
	ucvtf.4s	v7, v17
	stp	q18, q7, [x17]
	tbl.16b	v7, { v6 }, v2
	add	w17, w16, w12
	add	x17, x27, w17, sxtw #2
	tbl.16b	v16, { v6 }, v3
	ucvtf.4s	v16, v16
	ucvtf.4s	v7, v7
	stp	q16, q7, [x17, #32]
	tbl.16b	v7, { v6 }, v0
	tbl.16b	v4, { v6 }, v1
	ucvtf.4s	v4, v4
	ucvtf.4s	v5, v7
	stp	q4, q5, [x17]
	add	w12, w12, #16
	subs	x9, x9, #16
	b.ne	LBB5_48
; %bb.49:                               ;   in Loop: Header=BB5_20 Depth=1
	ldr	x8, [sp, #128]                  ; 8-byte Folded Reload
	ldr	x9, [sp, #32]                   ; 8-byte Folded Reload
	cmp	x8, x9
	b.eq	LBB5_19
; %bb.50:                               ;   in Loop: Header=BB5_20 Depth=1
	ldr	x23, [sp]                       ; 8-byte Folded Reload
	ldr	x8, [sp, #32]                   ; 8-byte Folded Reload
	ldr	x9, [sp, #128]                  ; 8-byte Folded Reload
	tbz	w9, #3, LBB5_24
	b	LBB5_44
LBB5_51:
	ldr	x14, [sp, #136]                 ; 8-byte Folded Reload
	cmp	w14, #1
	b.lt	LBB5_91
; %bb.52:
	ldr	x9, [x4]
	cmp	w14, #4
	b.hs	LBB5_54
; %bb.53:
	mov	x8, #0                          ; =0x0
	b	LBB5_63
LBB5_54:
	cmp	w14, #16
	b.hs	LBB5_56
; %bb.55:
	mov	x8, #0                          ; =0x0
	b	LBB5_60
LBB5_56:
	and	x8, x14, #0x7ffffff0
	add	x10, x9, #32
	mov	w11, #-1024065536               ; =0xc2f60000
	dup.4s	v0, w11
	mov	w11, #15819                     ; =0x3dcb
	movk	w11, #15501, lsl #16
	dup.4s	v1, w11
	mov	x11, x8
LBB5_57:                                ; =>This Inner Loop Header: Depth=1
	ldp	q2, q3, [x10, #-32]
	ldp	q4, q5, [x10]
	fadd.4s	v2, v2, v0
	fadd.4s	v3, v3, v0
	fadd.4s	v4, v4, v0
	fadd.4s	v5, v5, v0
	fmul.4s	v2, v2, v1
	fmul.4s	v3, v3, v1
	fmul.4s	v4, v4, v1
	fmul.4s	v5, v5, v1
	stp	q2, q3, [x10, #-32]
	stp	q4, q5, [x10], #64
	subs	x11, x11, #16
	b.ne	LBB5_57
; %bb.58:
	cmp	x8, x14
	b.eq	LBB5_65
; %bb.59:
	tst	x14, #0xc
	b.eq	LBB5_63
LBB5_60:
	mov	x11, x8
	and	x8, x14, #0x7ffffffc
	sub	x10, x11, x8
	add	x11, x9, x11, lsl #2
	mov	w12, #-1024065536               ; =0xc2f60000
	dup.4s	v0, w12
	mov	w12, #15819                     ; =0x3dcb
	movk	w12, #15501, lsl #16
	dup.4s	v1, w12
LBB5_61:                                ; =>This Inner Loop Header: Depth=1
	ldr	q2, [x11]
	fadd.4s	v2, v2, v0
	fmul.4s	v2, v2, v1
	str	q2, [x11], #16
	adds	x10, x10, #4
	b.ne	LBB5_61
; %bb.62:
	cmp	x8, x14
	b.eq	LBB5_65
LBB5_63:
	add	x10, x9, x8, lsl #2
	sub	x8, x14, x8
	mov	w11, #-1024065536               ; =0xc2f60000
	fmov	s0, w11
	mov	w11, #15819                     ; =0x3dcb
	movk	w11, #15501, lsl #16
	fmov	s1, w11
LBB5_64:                                ; =>This Inner Loop Header: Depth=1
	ldr	s2, [x10]
	fadd	s2, s2, s0
	fmul	s2, s2, s1
	str	s2, [x10], #4
	subs	x8, x8, #1
	b.ne	LBB5_64
LBB5_65:
	cmp	w14, #4
	b.hs	LBB5_67
; %bb.66:
	mov	x8, #0                          ; =0x0
	b	LBB5_76
LBB5_67:
	cmp	w14, #16
	b.hs	LBB5_69
; %bb.68:
	mov	x8, #0                          ; =0x0
	b	LBB5_73
LBB5_69:
	and	x8, x14, #0x7ffffff0
	add	x10, x9, x14, lsl #2
	add	x10, x10, #32
	mov	w11, #-1024851968               ; =0xc2ea0000
	dup.4s	v0, w11
	mov	w11, #47140                     ; =0xb824
	movk	w11, #15503, lsl #16
	dup.4s	v1, w11
	mov	x11, x8
LBB5_70:                                ; =>This Inner Loop Header: Depth=1
	ldp	q2, q3, [x10, #-32]
	ldp	q4, q5, [x10]
	fadd.4s	v2, v2, v0
	fadd.4s	v3, v3, v0
	fadd.4s	v4, v4, v0
	fadd.4s	v5, v5, v0
	fmul.4s	v2, v2, v1
	fmul.4s	v3, v3, v1
	fmul.4s	v4, v4, v1
	fmul.4s	v5, v5, v1
	stp	q2, q3, [x10, #-32]
	stp	q4, q5, [x10], #64
	subs	x11, x11, #16
	b.ne	LBB5_70
; %bb.71:
	cmp	x8, x14
	b.eq	LBB5_78
; %bb.72:
	tst	x14, #0xc
	b.eq	LBB5_76
LBB5_73:
	mov	x11, x8
	and	x8, x14, #0x7ffffffc
	sub	x10, x11, x8
	lsl	x11, x11, #2
	add	x11, x11, x14, lsl #2
	add	x11, x9, x11
	mov	w12, #-1024851968               ; =0xc2ea0000
	dup.4s	v0, w12
	mov	w12, #47140                     ; =0xb824
	movk	w12, #15503, lsl #16
	dup.4s	v1, w12
LBB5_74:                                ; =>This Inner Loop Header: Depth=1
	ldr	q2, [x11]
	fadd.4s	v2, v2, v0
	fmul.4s	v2, v2, v1
	str	q2, [x11], #16
	adds	x10, x10, #4
	b.ne	LBB5_74
; %bb.75:
	cmp	x8, x14
	b.eq	LBB5_78
LBB5_76:
	lsl	x10, x8, #2
	add	x10, x10, x14, lsl #2
	add	x10, x9, x10
	sub	x8, x14, x8
	mov	w11, #-1024851968               ; =0xc2ea0000
	fmov	s0, w11
	mov	w11, #47140                     ; =0xb824
	movk	w11, #15503, lsl #16
	fmov	s1, w11
LBB5_77:                                ; =>This Inner Loop Header: Depth=1
	ldr	s2, [x10]
	fadd	s2, s2, s0
	fmul	s2, s2, s1
	str	s2, [x10], #4
	subs	x8, x8, #1
	b.ne	LBB5_77
LBB5_78:
	lsl	x8, x14, #3
	cmp	w14, #4
	b.hs	LBB5_80
; %bb.79:
	mov	x10, #0                         ; =0x0
	b	LBB5_89
LBB5_80:
	cmp	w14, #16
	b.hs	LBB5_82
; %bb.81:
	mov	x10, #0                         ; =0x0
	b	LBB5_86
LBB5_82:
	and	x10, x14, #0x7ffffff0
	add	x11, x8, x9
	add	x11, x11, #32
	mov	w12, #-1026555904               ; =0xc2d00000
	dup.4s	v0, w12
	mov	w12, #55539                     ; =0xd8f3
	movk	w12, #15498, lsl #16
	dup.4s	v1, w12
	mov	x12, x10
LBB5_83:                                ; =>This Inner Loop Header: Depth=1
	ldp	q2, q3, [x11, #-32]
	ldp	q4, q5, [x11]
	fadd.4s	v2, v2, v0
	fadd.4s	v3, v3, v0
	fadd.4s	v4, v4, v0
	fadd.4s	v5, v5, v0
	fmul.4s	v2, v2, v1
	fmul.4s	v3, v3, v1
	fmul.4s	v4, v4, v1
	fmul.4s	v5, v5, v1
	stp	q2, q3, [x11, #-32]
	stp	q4, q5, [x11], #64
	subs	x12, x12, #16
	b.ne	LBB5_83
; %bb.84:
	cmp	x10, x14
	b.eq	LBB5_91
; %bb.85:
	tst	x14, #0xc
	b.eq	LBB5_89
LBB5_86:
	mov	x12, x10
	and	x10, x14, #0x7ffffffc
	sub	x11, x12, x10
	add	x12, x8, x12, lsl #2
	add	x12, x9, x12
	mov	w13, #-1026555904               ; =0xc2d00000
	dup.4s	v0, w13
	mov	w13, #55539                     ; =0xd8f3
	movk	w13, #15498, lsl #16
	dup.4s	v1, w13
LBB5_87:                                ; =>This Inner Loop Header: Depth=1
	ldr	q2, [x12]
	fadd.4s	v2, v2, v0
	fmul.4s	v2, v2, v1
	str	q2, [x12], #16
	adds	x11, x11, #4
	b.ne	LBB5_87
; %bb.88:
	cmp	x10, x14
	b.eq	LBB5_91
LBB5_89:
	add	x8, x8, x10, lsl #2
	add	x8, x9, x8
	sub	x9, x14, x10
	mov	w10, #-1026555904               ; =0xc2d00000
	fmov	s0, w10
	mov	w10, #55539                     ; =0xd8f3
	movk	w10, #15498, lsl #16
	fmov	s1, w10
LBB5_90:                                ; =>This Inner Loop Header: Depth=1
	ldr	s2, [x8]
	fadd	s2, s2, s0
	fmul	s2, s2, s1
	str	s2, [x8], #4
	subs	x9, x9, #1
	b.ne	LBB5_90
LBB5_91:
	ldp	x29, x30, [sp, #304]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #288]            ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #272]            ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #256]            ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #240]            ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #224]            ; 16-byte Folded Reload
	add	sp, sp, #320
	ret
LBB5_92:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp343:
Lloh76:
	adrp	x1, l_.str.1@PAGE
Lloh77:
	add	x1, x1, l_.str.1@PAGEOFF
	bl	__ZNSt16invalid_argumentC1B9nqe210106EPKc
Ltmp344:
	b	LBB5_94
LBB5_93:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp340:
Lloh78:
	adrp	x1, l_.str.12@PAGE
Lloh79:
	add	x1, x1, l_.str.12@PAGEOFF
	bl	__ZNSt16invalid_argumentC1B9nqe210106EPKc
Ltmp341:
LBB5_94:
Lloh80:
	adrp	x1, __ZTISt16invalid_argument@GOTPAGE
Lloh81:
	ldr	x1, [x1, __ZTISt16invalid_argument@GOTPAGEOFF]
Lloh82:
	adrp	x2, __ZNSt16invalid_argumentD1Ev@GOTPAGE
Lloh83:
	ldr	x2, [x2, __ZNSt16invalid_argumentD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
LBB5_95:
Ltmp342:
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x0, x20
	bl	__Unwind_Resume
LBB5_96:
Ltmp345:
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x0, x20
	bl	__Unwind_Resume
	.loh AdrpLdr	Lloh74, Lloh75
	.loh AdrpAdrp	Lloh72, Lloh74
	.loh AdrpLdr	Lloh72, Lloh73
	.loh AdrpAdrp	Lloh70, Lloh72
	.loh AdrpLdr	Lloh70, Lloh71
	.loh AdrpAdrp	Lloh68, Lloh70
	.loh AdrpLdr	Lloh68, Lloh69
	.loh AdrpAdd	Lloh76, Lloh77
	.loh AdrpAdd	Lloh78, Lloh79
	.loh AdrpLdrGot	Lloh82, Lloh83
	.loh AdrpLdrGot	Lloh80, Lloh81
Lfunc_end4:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table5:
Lexception4:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end4-Lcst_begin4
Lcst_begin4:
	.uleb128 Lfunc_begin4-Lfunc_begin4      ; >> Call Site 1 <<
	.uleb128 Ltmp343-Lfunc_begin4           ;   Call between Lfunc_begin4 and Ltmp343
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp343-Lfunc_begin4           ; >> Call Site 2 <<
	.uleb128 Ltmp344-Ltmp343                ;   Call between Ltmp343 and Ltmp344
	.uleb128 Ltmp345-Lfunc_begin4           ;     jumps to Ltmp345
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp344-Lfunc_begin4           ; >> Call Site 3 <<
	.uleb128 Ltmp340-Ltmp344                ;   Call between Ltmp344 and Ltmp340
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp340-Lfunc_begin4           ; >> Call Site 4 <<
	.uleb128 Ltmp341-Ltmp340                ;   Call between Ltmp340 and Ltmp341
	.uleb128 Ltmp342-Lfunc_begin4           ;     jumps to Ltmp342
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp341-Lfunc_begin4           ; >> Call Site 5 <<
	.uleb128 Lfunc_end4-Ltmp341             ;   Call between Ltmp341 and Lfunc_end4
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end4:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__literal16,16byte_literals
	.p2align	4, 0x0                          ; -- Begin function _Z7convertILb1EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
lCPI6_0:
	.byte	12                              ; 0xc
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	13                              ; 0xd
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	14                              ; 0xe
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	15                              ; 0xf
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
lCPI6_1:
	.byte	8                               ; 0x8
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	9                               ; 0x9
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	10                              ; 0xa
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	11                              ; 0xb
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
lCPI6_2:
	.byte	4                               ; 0x4
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	5                               ; 0x5
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	6                               ; 0x6
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	7                               ; 0x7
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
lCPI6_3:
	.byte	0                               ; 0x0
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	1                               ; 0x1
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	2                               ; 0x2
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	3                               ; 0x3
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__Z7convertILb1EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
	.weak_def_can_be_hidden	__Z7convertILb1EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
	.p2align	2
__Z7convertILb1EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE: ; @_Z7convertILb1EEvRKNSt3__16vectorIhNS0_9allocatorIhEEEEiiiRNS1_IfNS2_IfEEEE
Lfunc_begin5:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception5
; %bb.0:
	sub	sp, sp, #384
	stp	x28, x27, [sp, #288]            ; 16-byte Folded Spill
	stp	x26, x25, [sp, #304]            ; 16-byte Folded Spill
	stp	x24, x23, [sp, #320]            ; 16-byte Folded Spill
	stp	x22, x21, [sp, #336]            ; 16-byte Folded Spill
	stp	x20, x19, [sp, #352]            ; 16-byte Folded Spill
	stp	x29, x30, [sp, #368]            ; 16-byte Folded Spill
	add	x29, sp, #368
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_offset w23, -56
	.cfi_offset w24, -64
	.cfi_offset w25, -72
	.cfi_offset w26, -80
	.cfi_offset w27, -88
	.cfi_offset w28, -96
                                        ; kill: def $w2 killed $w2 def $x2
                                        ; kill: def $w1 killed $w1 def $x1
	cmp	w2, #1, lsl #12                 ; =4096
	b.gt	LBB6_52
; %bb.1:
	cmp	w1, #1, lsl #12                 ; =4096
	b.gt	LBB6_52
; %bb.2:
	orr	w8, w2, w1
	tbnz	w8, #31, LBB6_52
; %bb.3:
	add	w8, w1, w1, lsl #1
	cmp	w3, w8
	b.lt	LBB6_52
; %bb.4:
	ldp	x8, x9, [x0]
	umull	x10, w3, w2
	sub	x9, x9, x8
	cmp	x9, x10
	b.ne	LBB6_52
; %bb.5:
	ldp	x12, x9, [x4]
	sub	x9, x9, x12
	sxtw	x11, w1
	sxtw	x10, w2
	add	x13, x11, w1, sxtw #1
	str	x13, [sp, #72]                  ; 8-byte Folded Spill
	mul	x10, x13, x10
	cmp	x10, x9, asr #2
	b.ne	LBB6_53
; %bb.6:
	cmp	w2, #1
	b.lt	LBB6_51
; %bb.7:
	mov	w20, w3
	mul	w10, w2, w1
	mov	w6, w2
	cmp	w1, #8
	str	x10, [sp, #152]                 ; 8-byte Folded Spill
	b.ge	LBB6_18
; %bb.8:
	cmp	w1, #1
	b.lt	LBB6_51
; %bb.9:
	mov	w11, #0                         ; =0x0
	mov	w9, #-1024065536                ; =0xc2f60000
	fmov	s0, w9
	mov	w9, #15819                      ; =0x3dcb
	movk	w9, #15501, lsl #16
	fmov	s1, w9
	mov	w9, #-1024851968                ; =0xc2ea0000
	fmov	s2, w9
	mov	w9, #47140                      ; =0xb824
	movk	w9, #15503, lsl #16
	fmov	s3, w9
	mov	w9, #-1026555904                ; =0xc2d00000
	fmov	s4, w9
	mov	w9, #55539                      ; =0xd8f3
	movk	w9, #15498, lsl #16
	fmov	s5, w9
	ldr	x9, [sp, #152]                  ; 8-byte Folded Reload
	lsl	w13, w9, #1
	add	x14, x8, #10
	ldr	x10, [sp, #152]                 ; 8-byte Folded Reload
	b	LBB6_11
LBB6_10:                                ;   in Loop: Header=BB6_11 Depth=1
	add	w11, w11, w1
	add	x14, x14, x20
	subs	x6, x6, #1
	b.eq	LBB6_51
LBB6_11:                                ; =>This Inner Loop Header: Depth=1
	ldur	b6, [x14, #-10]
	ucvtf	s6, s6
	fadd	s6, s6, s0
	fmul	s6, s6, s1
	str	s6, [x12, w11, sxtw #2]
	ldur	b6, [x14, #-9]
	ucvtf	s6, s6
	fadd	s6, s6, s2
	fmul	s6, s6, s3
	add	w8, w10, w11
	str	s6, [x12, w8, sxtw #2]
	ldur	b6, [x14, #-8]
	ucvtf	s6, s6
	fadd	s6, s6, s4
	fmul	s6, s6, s5
	add	w8, w13, w11
	str	s6, [x12, w8, sxtw #2]
	cmp	w1, #1
	b.eq	LBB6_10
; %bb.12:                               ;   in Loop: Header=BB6_11 Depth=1
	ldur	b6, [x14, #-7]
	ucvtf	s6, s6
	fadd	s6, s6, s0
	fmul	s6, s6, s1
	add	w8, w11, #1
	str	s6, [x12, w8, sxtw #2]
	ldur	b6, [x14, #-6]
	ucvtf	s6, s6
	fadd	s6, s6, s2
	fmul	s6, s6, s3
	add	w9, w8, w10
	str	s6, [x12, w9, sxtw #2]
	ldur	b6, [x14, #-5]
	ucvtf	s6, s6
	fadd	s6, s6, s4
	fmul	s6, s6, s5
	add	w8, w8, w13
	str	s6, [x12, w8, sxtw #2]
	cmp	w1, #2
	b.eq	LBB6_10
; %bb.13:                               ;   in Loop: Header=BB6_11 Depth=1
	ldur	b6, [x14, #-4]
	ucvtf	s6, s6
	fadd	s6, s6, s0
	fmul	s6, s6, s1
	add	w8, w11, #2
	str	s6, [x12, w8, sxtw #2]
	ldur	b6, [x14, #-3]
	ucvtf	s6, s6
	fadd	s6, s6, s2
	fmul	s6, s6, s3
	add	w9, w8, w10
	str	s6, [x12, w9, sxtw #2]
	ldur	b6, [x14, #-2]
	ucvtf	s6, s6
	fadd	s6, s6, s4
	fmul	s6, s6, s5
	add	w8, w8, w13
	str	s6, [x12, w8, sxtw #2]
	cmp	w1, #3
	b.eq	LBB6_10
; %bb.14:                               ;   in Loop: Header=BB6_11 Depth=1
	ldur	b6, [x14, #-1]
	ucvtf	s6, s6
	fadd	s6, s6, s0
	fmul	s6, s6, s1
	add	w8, w11, #3
	str	s6, [x12, w8, sxtw #2]
	ldr	b6, [x14]
	ucvtf	s6, s6
	fadd	s6, s6, s2
	fmul	s6, s6, s3
	add	w9, w8, w10
	str	s6, [x12, w9, sxtw #2]
	ldr	b6, [x14, #1]
	ucvtf	s6, s6
	fadd	s6, s6, s4
	fmul	s6, s6, s5
	add	w8, w8, w13
	str	s6, [x12, w8, sxtw #2]
	cmp	w1, #4
	b.eq	LBB6_10
; %bb.15:                               ;   in Loop: Header=BB6_11 Depth=1
	ldr	b6, [x14, #2]
	ucvtf	s6, s6
	fadd	s6, s6, s0
	fmul	s6, s6, s1
	add	w8, w11, #4
	str	s6, [x12, w8, sxtw #2]
	ldr	b6, [x14, #3]
	ucvtf	s6, s6
	fadd	s6, s6, s2
	fmul	s6, s6, s3
	add	w9, w8, w10
	str	s6, [x12, w9, sxtw #2]
	ldr	b6, [x14, #4]
	ucvtf	s6, s6
	fadd	s6, s6, s4
	fmul	s6, s6, s5
	add	w8, w8, w13
	str	s6, [x12, w8, sxtw #2]
	cmp	w1, #5
	b.eq	LBB6_10
; %bb.16:                               ;   in Loop: Header=BB6_11 Depth=1
	ldr	b6, [x14, #5]
	ucvtf	s6, s6
	fadd	s6, s6, s0
	fmul	s6, s6, s1
	add	w8, w11, #5
	str	s6, [x12, w8, sxtw #2]
	ldr	b6, [x14, #6]
	ucvtf	s6, s6
	fadd	s6, s6, s2
	fmul	s6, s6, s3
	add	w9, w8, w10
	str	s6, [x12, w9, sxtw #2]
	ldr	b6, [x14, #7]
	ucvtf	s6, s6
	fadd	s6, s6, s4
	fmul	s6, s6, s5
	add	w8, w8, w13
	str	s6, [x12, w8, sxtw #2]
	cmp	w1, #6
	b.eq	LBB6_10
; %bb.17:                               ;   in Loop: Header=BB6_11 Depth=1
	ldr	b6, [x14, #8]
	ucvtf	s6, s6
	fadd	s6, s6, s0
	fmul	s6, s6, s1
	add	w8, w11, #6
	str	s6, [x12, w8, sxtw #2]
	ldr	b6, [x14, #9]
	ucvtf	s6, s6
	fadd	s6, s6, s2
	fmul	s6, s6, s3
	add	w9, w8, w10
	str	s6, [x12, w9, sxtw #2]
	ldr	b6, [x14, #10]
	ucvtf	s6, s6
	fadd	s6, s6, s4
	fmul	s6, s6, s5
	add	w8, w8, w13
	str	s6, [x12, w8, sxtw #2]
	b	LBB6_10
LBB6_18:
	mov	x17, #0                         ; =0x0
	mov	w14, #0                         ; =0x0
	and	w12, w1, #0x7ffffff8
	lsl	w16, w10, #1
	mvn	x9, x12
	add	x13, x9, x11
	add	w2, w10, w12
	add	w3, w16, w12
	and	x9, x11, #0x7
	sub	x15, x11, x12
	sub	x9, x15, x9
	str	x15, [sp, #144]                 ; 8-byte Folded Spill
	and	x15, x15, #0xfffffffffffffff0
	stp	x9, x15, [sp, #24]              ; 16-byte Folded Spill
	add	x15, x15, x12
	str	x15, [sp]                       ; 8-byte Folded Spill
	add	x9, x9, x12
	str	x9, [sp, #16]                   ; 8-byte Folded Spill
	and	w9, w1, #0x7
	str	w9, [sp, #12]                   ; 4-byte Folded Spill
	lsl	x9, x11, #2
	str	x9, [sp, #168]                  ; 8-byte Folded Spill
	ubfiz	x23, x10, #2, #32
	ubfiz	x24, x10, #3, #32
	ubfx	x8, x1, #3, #28
	add	x8, x8, x8, lsl #1
	lsl	x25, x8, #3
	mov	w26, #15819                     ; =0x3dcb
	movk	w26, #15501, lsl #16
	dup.4s	v0, w26
	mvni.4h	v1, #122
	mvni.4h	v2, #116
	mov	w27, #47140                     ; =0xb824
	movk	w27, #15503, lsl #16
	dup.4s	v3, w27
	mvni.4h	v4, #103
	mov	w28, #55539                     ; =0xd8f3
	movk	w28, #15498, lsl #16
	dup.4s	v5, w28
	mov	w30, #-1024065536               ; =0xc2f60000
	mov	w19, #-1024851968               ; =0xc2ea0000
	mov	w21, #-1026555904               ; =0xc2d00000
	str	x13, [sp, #136]                 ; 8-byte Folded Spill
	lsr	x8, x13, #32
	str	x8, [sp, #64]                   ; 8-byte Folded Spill
	sub	x8, x17, w12, uxtw #2
	str	x8, [sp, #48]                   ; 8-byte Folded Spill
Lloh84:
	adrp	x8, lCPI6_2@PAGE
Lloh85:
	ldr	q6, [x8, lCPI6_2@PAGEOFF]
Lloh86:
	adrp	x8, lCPI6_3@PAGE
Lloh87:
	ldr	q7, [x8, lCPI6_3@PAGEOFF]
	dup.4s	v16, w30
	dup.4s	v17, w19
	dup.4s	v18, w21
Lloh88:
	adrp	x8, lCPI6_0@PAGE
Lloh89:
	ldr	q19, [x8, lCPI6_0@PAGEOFF]
Lloh90:
	adrp	x8, lCPI6_1@PAGE
Lloh91:
	ldr	q20, [x8, lCPI6_1@PAGEOFF]
	mov	x7, x10
	stp	x3, x2, [sp, #176]              ; 16-byte Folded Spill
	mov	x15, x12
	mov	x22, #0                         ; =0x0
	mov	x5, #0                          ; =0x0
	stur	x12, [x29, #-96]                ; 8-byte Folded Spill
	add	x8, x12, w12, uxtw #1
	str	x8, [sp, #40]                   ; 8-byte Folded Spill
	mov	w8, w1
	str	x8, [sp, #160]                  ; 8-byte Folded Spill
	str	x1, [sp, #56]                   ; 8-byte Folded Spill
	stp	x6, x20, [x29, #-176]           ; 16-byte Folded Spill
	b	LBB6_20
LBB6_19:                                ;   in Loop: Header=BB6_20 Depth=1
	add	x5, x5, #1
	ldp	x6, x20, [x29, #-176]           ; 16-byte Folded Reload
	add	x22, x22, x20
	ldp	x8, x9, [sp, #160]              ; 16-byte Folded Reload
	add	x17, x17, x9
	add	x15, x15, x8
	add	x25, x25, x20
	add	x2, x2, x8
	add	x3, x3, x8
	add	w7, w7, w1
	add	w14, w14, w1
	cmp	x5, x6
	b.eq	LBB6_51
LBB6_20:                                ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB6_21 Depth 2
                                        ;     Child Loop BB6_48 Depth 2
                                        ;     Child Loop BB6_45 Depth 2
                                        ;     Child Loop BB6_25 Depth 2
	stur	w14, [x29, #-100]               ; 4-byte Folded Spill
	mul	w8, w1, w5
	ldur	x9, [x29, #-96]                 ; 8-byte Folded Reload
	add	w12, w9, w8
	sbfiz	x10, x12, #2, #32
	add	x9, x11, w12, sxtw
	lsl	x9, x9, #2
	stp	x9, x10, [x29, #-128]           ; 16-byte Folded Spill
	ldr	x9, [sp, #184]                  ; 8-byte Folded Reload
	add	w6, w9, w8
	sbfiz	x9, x6, #2, #32
	stur	x9, [x29, #-112]                ; 8-byte Folded Spill
	add	x9, x11, w6, sxtw
	lsl	x9, x9, #2
	stur	x9, [x29, #-144]                ; 8-byte Folded Spill
	ldr	x9, [sp, #176]                  ; 8-byte Folded Reload
	add	w10, w9, w8
	sbfiz	x8, x10, #2, #32
	stur	x8, [x29, #-152]                ; 8-byte Folded Spill
	add	x8, x11, w10, sxtw
	lsl	x8, x8, #2
	stur	x8, [x29, #-136]                ; 8-byte Folded Spill
	mul	x8, x5, x20
	stur	x8, [x29, #-160]                ; 8-byte Folded Spill
	mov	x20, x17
	mov	x13, x22
	mov	w9, #8                          ; =0x8
LBB6_21:                                ;   Parent Loop BB6_20 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	x8, [x0]
	add	x8, x8, x13
	ld3.8b	{ v21, v22, v23 }, [x8]
	ushll.8h	v24, v21, #0
	ext.16b	v24, v24, v24, #8
	uaddw.8h	v25, v1, v21
	sshll.4s	v25, v25, #0
	scvtf.4s	v25, v25
	fmul.4s	v25, v25, v0
	add.4h	v24, v24, v1
	sshll.4s	v24, v24, #0
	scvtf.4s	v24, v24
	fmul.4s	v24, v24, v0
	ldr	x8, [x4]
	str	q25, [x8, x20]
	ldr	x8, [x4]
	add	x8, x8, x20
	str	q24, [x8, #16]
	ushll.8h	v24, v22, #0
	ext.16b	v24, v24, v24, #8
	uaddw.8h	v25, v2, v22
	sshll.4s	v25, v25, #0
	scvtf.4s	v25, v25
	fmul.4s	v25, v25, v3
	add.4h	v24, v24, v2
	sshll.4s	v24, v24, #0
	scvtf.4s	v24, v24
	fmul.4s	v24, v24, v3
	ldr	x8, [x4]
	add	x8, x8, x23
	str	q25, [x8, x20]
	ldr	x8, [x4]
	add	x14, x23, x20
	add	x8, x8, x14
	str	q24, [x8, #16]
	ushll.8h	v24, v23, #0
	ext.16b	v24, v24, v24, #8
	uaddw.8h	v21, v4, v23
	sshll.4s	v21, v21, #0
	scvtf.4s	v21, v21
	fmul.4s	v21, v21, v5
	add.4h	v22, v24, v4
	sshll.4s	v22, v22, #0
	scvtf.4s	v22, v22
	fmul.4s	v22, v22, v5
	ldr	x8, [x4]
	add	x8, x8, x24
	str	q21, [x8, x20]
	ldr	x8, [x4]
	add	x14, x24, x20
	add	x8, x8, x14
	str	q22, [x8, #16]
	add	x9, x9, #8
	add	x13, x13, #24
	add	x20, x20, #32
	cmp	x9, x11
	b.le	LBB6_21
; %bb.22:                               ;   in Loop: Header=BB6_20 Depth=1
	ldur	x8, [x29, #-96]                 ; 8-byte Folded Reload
	cmp	w8, w1
	ldur	w14, [x29, #-100]               ; 4-byte Folded Reload
	b.eq	LBB6_19
; %bb.23:                               ;   in Loop: Header=BB6_20 Depth=1
	ldr	x13, [x0]
	ldr	x20, [x4]
	ldur	x9, [x29, #-96]                 ; 8-byte Folded Reload
	ldr	x8, [sp, #144]                  ; 8-byte Folded Reload
	cmp	x8, #7
	b.hi	LBB6_26
LBB6_24:                                ;   in Loop: Header=BB6_20 Depth=1
	sub	x8, x11, x9
	add	w10, w7, w9
	add	x12, x9, x9, lsl #1
	add	x12, x22, x12
	add	x12, x13, x12
	add	w9, w14, w9
LBB6_25:                                ;   Parent Loop BB6_20 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	b21, [x12]
	ucvtf	s21, s21
	fmov	s22, w30
	fadd	s21, s21, s22
	fmov	s22, w26
	fmul	s21, s21, s22
	str	s21, [x20, w9, sxtw #2]
	ldr	b21, [x12, #1]
	ucvtf	s21, s21
	fmov	s22, w19
	fadd	s21, s21, s22
	fmov	s22, w27
	fmul	s21, s21, s22
	str	s21, [x20, w10, sxtw #2]
	ldr	b21, [x12, #2]
	ucvtf	s21, s21
	fmov	s22, w21
	fadd	s21, s21, s22
	fmov	s22, w28
	fmul	s21, s21, s22
	add	w13, w16, w9
	str	s21, [x20, w13, sxtw #2]
	add	w10, w10, #1
	add	x12, x12, #3
	add	w9, w9, #1
	subs	x8, x8, #1
	b.ne	LBB6_25
	b	LBB6_19
LBB6_26:                                ;   in Loop: Header=BB6_20 Depth=1
	ldr	x8, [sp, #136]                  ; 8-byte Folded Reload
	add	w9, w10, w8
	cmp	w9, w10
	ldur	x9, [x29, #-96]                 ; 8-byte Folded Reload
	b.lt	LBB6_24
; %bb.27:                               ;   in Loop: Header=BB6_20 Depth=1
	ldr	x8, [sp, #136]                  ; 8-byte Folded Reload
	add	w9, w12, w8
	cmp	w9, w12
	ldur	x9, [x29, #-96]                 ; 8-byte Folded Reload
	b.lt	LBB6_24
; %bb.28:                               ;   in Loop: Header=BB6_20 Depth=1
	ldr	x8, [sp, #136]                  ; 8-byte Folded Reload
	add	w9, w6, w8
	cmp	w9, w6
	ldur	x9, [x29, #-96]                 ; 8-byte Folded Reload
	b.lt	LBB6_24
; %bb.29:                               ;   in Loop: Header=BB6_20 Depth=1
	ldur	x9, [x29, #-96]                 ; 8-byte Folded Reload
	ldr	x8, [sp, #64]                   ; 8-byte Folded Reload
	cbnz	x8, LBB6_24
; %bb.30:                               ;   in Loop: Header=BB6_20 Depth=1
	ldr	x8, [sp, #72]                   ; 8-byte Folded Reload
	add	x9, x13, x8
	ldur	x10, [x29, #-160]               ; 8-byte Folded Reload
	add	x8, x9, x10
	sub	x9, x8, #2
	str	x9, [sp, #120]                  ; 8-byte Folded Spill
	mov	x9, x8
	str	x8, [sp, #104]                  ; 8-byte Folded Spill
	ldur	x8, [x29, #-120]                ; 8-byte Folded Reload
	add	x8, x20, x8
	str	x8, [sp, #112]                  ; 8-byte Folded Spill
	ldr	x8, [sp, #48]                   ; 8-byte Folded Reload
	str	x13, [sp, #128]                 ; 8-byte Folded Spill
	add	x13, x20, x8
	ldur	x8, [x29, #-128]                ; 8-byte Folded Reload
	add	x6, x13, x8
	ldur	x8, [x29, #-144]                ; 8-byte Folded Reload
	add	x8, x13, x8
	str	x8, [sp, #96]                   ; 8-byte Folded Spill
	ldur	x12, [x29, #-152]               ; 8-byte Folded Reload
	add	x1, x20, x12
	ldr	x12, [sp, #40]                  ; 8-byte Folded Reload
	ldr	x14, [sp, #128]                 ; 8-byte Folded Reload
	add	x12, x14, x12
	add	x12, x12, x10
	stur	x17, [x29, #-144]               ; 8-byte Folded Spill
	add	x17, x12, #1
	sub	x8, x9, #1
	add	x10, x12, #2
	stp	x8, x10, [x29, #-128]           ; 16-byte Folded Spill
	ldur	x14, [x29, #-136]               ; 8-byte Folded Reload
	add	x13, x13, x14
	ldr	x10, [sp, #112]                 ; 8-byte Folded Reload
	cmp	x10, x13
	ccmp	x1, x6, #2, lo
	cset	w14, lo
	stur	w14, [x29, #-136]               ; 4-byte Folded Spill
	ldr	x14, [sp, #120]                 ; 8-byte Folded Reload
	cmp	x10, x14
	ccmp	x12, x6, #2, lo
	cset	w14, lo
	stur	w14, [x29, #-152]               ; 4-byte Folded Spill
	cmp	x10, x8
	ccmp	x17, x6, #2, lo
	cset	w14, lo
	stur	w14, [x29, #-160]               ; 4-byte Folded Spill
	cmp	x10, x9
	ldur	x8, [x29, #-120]                ; 8-byte Folded Reload
	ccmp	x8, x6, #2, lo
	cset	w9, lo
	str	w9, [sp, #92]                   ; 4-byte Folded Spill
	ldur	x14, [x29, #-112]               ; 8-byte Folded Reload
	add	x14, x20, x14
	cmp	x14, x13
	ldr	x8, [sp, #96]                   ; 8-byte Folded Reload
	ccmp	x1, x8, #2, lo
	cset	w9, lo
	stur	w9, [x29, #-112]                ; 4-byte Folded Spill
	ldr	x10, [sp, #120]                 ; 8-byte Folded Reload
	cmp	x14, x10
	ccmp	x12, x8, #2, lo
	cset	w9, lo
	str	w9, [sp, #88]                   ; 4-byte Folded Spill
	ldur	x9, [x29, #-128]                ; 8-byte Folded Reload
	cmp	x14, x9
	ccmp	x17, x8, #2, lo
	cset	w9, lo
	str	w9, [sp, #84]                   ; 4-byte Folded Spill
	ldr	x9, [sp, #104]                  ; 8-byte Folded Reload
	cmp	x14, x9
	ldur	x9, [x29, #-120]                ; 8-byte Folded Reload
	ccmp	x9, x8, #2, lo
	cset	w9, lo
	str	w9, [sp, #80]                   ; 4-byte Folded Spill
	cmp	x1, x10
	ccmp	x12, x13, #2, lo
	cset	w12, lo
	str	w12, [sp, #120]                 ; 4-byte Folded Spill
	ldur	x9, [x29, #-128]                ; 8-byte Folded Reload
	cmp	x1, x9
	ccmp	x17, x13, #2, lo
	ldur	x17, [x29, #-144]               ; 8-byte Folded Reload
	cset	w12, lo
	ldr	x9, [sp, #104]                  ; 8-byte Folded Reload
	cmp	x1, x9
	ldr	x1, [sp, #56]                   ; 8-byte Folded Reload
	ldur	x9, [x29, #-120]                ; 8-byte Folded Reload
	ccmp	x9, x13, #2, lo
	ldr	x13, [sp, #128]                 ; 8-byte Folded Reload
	cset	w9, lo
	stur	w9, [x29, #-120]                ; 4-byte Folded Spill
	cmp	x14, x6
	ldur	w14, [x29, #-100]               ; 4-byte Folded Reload
	ldr	x9, [sp, #112]                  ; 8-byte Folded Reload
	ccmp	x9, x8, #2, lo
	ldur	x9, [x29, #-96]                 ; 8-byte Folded Reload
	b.lo	LBB6_24
; %bb.31:                               ;   in Loop: Header=BB6_20 Depth=1
	ldur	x9, [x29, #-96]                 ; 8-byte Folded Reload
	ldur	w8, [x29, #-136]                ; 4-byte Folded Reload
	tbnz	w8, #0, LBB6_24
; %bb.32:                               ;   in Loop: Header=BB6_20 Depth=1
	ldur	x9, [x29, #-96]                 ; 8-byte Folded Reload
	ldur	w8, [x29, #-152]                ; 4-byte Folded Reload
	tbnz	w8, #0, LBB6_24
; %bb.33:                               ;   in Loop: Header=BB6_20 Depth=1
	ldur	x9, [x29, #-96]                 ; 8-byte Folded Reload
	ldur	w8, [x29, #-160]                ; 4-byte Folded Reload
	tbnz	w8, #0, LBB6_24
; %bb.34:                               ;   in Loop: Header=BB6_20 Depth=1
	ldur	x9, [x29, #-96]                 ; 8-byte Folded Reload
	ldr	w8, [sp, #92]                   ; 4-byte Folded Reload
	tbnz	w8, #0, LBB6_24
; %bb.35:                               ;   in Loop: Header=BB6_20 Depth=1
	ldur	x9, [x29, #-96]                 ; 8-byte Folded Reload
	ldur	w8, [x29, #-112]                ; 4-byte Folded Reload
	tbnz	w8, #0, LBB6_24
; %bb.36:                               ;   in Loop: Header=BB6_20 Depth=1
	ldur	x9, [x29, #-96]                 ; 8-byte Folded Reload
	ldr	w8, [sp, #88]                   ; 4-byte Folded Reload
	tbnz	w8, #0, LBB6_24
; %bb.37:                               ;   in Loop: Header=BB6_20 Depth=1
	ldur	x9, [x29, #-96]                 ; 8-byte Folded Reload
	ldr	w8, [sp, #84]                   ; 4-byte Folded Reload
	tbnz	w8, #0, LBB6_24
; %bb.38:                               ;   in Loop: Header=BB6_20 Depth=1
	ldur	x9, [x29, #-96]                 ; 8-byte Folded Reload
	ldr	w8, [sp, #80]                   ; 4-byte Folded Reload
	tbnz	w8, #0, LBB6_24
; %bb.39:                               ;   in Loop: Header=BB6_20 Depth=1
	ldur	x9, [x29, #-96]                 ; 8-byte Folded Reload
	ldr	w8, [sp, #120]                  ; 4-byte Folded Reload
	tbnz	w8, #0, LBB6_24
; %bb.40:                               ;   in Loop: Header=BB6_20 Depth=1
	ldur	x9, [x29, #-96]                 ; 8-byte Folded Reload
	tbnz	w12, #0, LBB6_24
; %bb.41:                               ;   in Loop: Header=BB6_20 Depth=1
	ldur	x9, [x29, #-96]                 ; 8-byte Folded Reload
	ldur	w8, [x29, #-120]                ; 4-byte Folded Reload
	tbnz	w8, #0, LBB6_24
; %bb.42:                               ;   in Loop: Header=BB6_20 Depth=1
	ldr	x8, [sp, #144]                  ; 8-byte Folded Reload
	cmp	x8, #16
	b.hs	LBB6_47
; %bb.43:                               ;   in Loop: Header=BB6_20 Depth=1
	mov	x8, #0                          ; =0x0
LBB6_44:                                ;   in Loop: Header=BB6_20 Depth=1
	add	x9, x8, x8, lsl #1
	add	x9, x13, x9
	ldr	x12, [sp, #24]                  ; 8-byte Folded Reload
LBB6_45:                                ;   Parent Loop BB6_20 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	add	x10, x9, x25
	ld3.8b	{ v21, v22, v23 }, [x10]
	add	w10, w15, w8
	tbl.16b	v24, { v21 }, v6
	tbl.16b	v25, { v21 }, v7
	ucvtf.4s	v25, v25
	ucvtf.4s	v24, v24
	fadd.4s	v24, v24, v16
	fadd.4s	v25, v25, v16
	fmul.4s	v25, v25, v0
	fmul.4s	v24, v24, v0
	add	x10, x20, w10, sxtw #2
	stp	q25, q24, [x10]
	tbl.16b	v24, { v22 }, v6
	tbl.16b	v25, { v22 }, v7
	ucvtf.4s	v25, v25
	ucvtf.4s	v24, v24
	fadd.4s	v24, v24, v17
	fadd.4s	v25, v25, v17
	fmul.4s	v25, v25, v3
	fmul.4s	v24, v24, v3
	add	w10, w2, w8
	add	x10, x20, w10, sxtw #2
	stp	q25, q24, [x10]
	tbl.16b	v24, { v23 }, v6
	tbl.16b	v21, { v23 }, v7
	ucvtf.4s	v21, v21
	ucvtf.4s	v22, v24
	fadd.4s	v22, v22, v18
	fadd.4s	v21, v21, v18
	fmul.4s	v21, v21, v5
	fmul.4s	v22, v22, v5
	add	w10, w3, w8
	add	x10, x20, w10, sxtw #2
	stp	q21, q22, [x10]
	add	x8, x8, #8
	add	x9, x9, #24
	cmp	x12, x8
	b.ne	LBB6_45
; %bb.46:                               ;   in Loop: Header=BB6_20 Depth=1
	ldr	x9, [sp, #16]                   ; 8-byte Folded Reload
	ldr	w8, [sp, #12]                   ; 4-byte Folded Reload
	cbnz	w8, LBB6_24
	b	LBB6_19
LBB6_47:                                ;   in Loop: Header=BB6_20 Depth=1
	add	x8, x13, x25
	ldr	x9, [sp, #32]                   ; 8-byte Folded Reload
	mov	x10, x15
	ldr	x13, [sp, #152]                 ; 8-byte Folded Reload
LBB6_48:                                ;   Parent Loop BB6_20 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ld3.16b	{ v21, v22, v23 }, [x8], #48
	tbl.16b	v24, { v21 }, v19
	tbl.16b	v25, { v21 }, v20
	tbl.16b	v26, { v21 }, v6
	tbl.16b	v27, { v21 }, v7
	ucvtf.4s	v27, v27
	ucvtf.4s	v26, v26
	ucvtf.4s	v25, v25
	ucvtf.4s	v24, v24
	fadd.4s	v24, v24, v16
	fadd.4s	v25, v25, v16
	fadd.4s	v26, v26, v16
	fadd.4s	v27, v27, v16
	fmul.4s	v27, v27, v0
	fmul.4s	v26, v26, v0
	fmul.4s	v25, v25, v0
	fmul.4s	v24, v24, v0
	add	x12, x20, w10, sxtw #2
	stp	q25, q24, [x12, #32]
	stp	q27, q26, [x12]
	tbl.16b	v24, { v22 }, v19
	tbl.16b	v25, { v22 }, v20
	tbl.16b	v26, { v22 }, v6
	tbl.16b	v27, { v22 }, v7
	ucvtf.4s	v27, v27
	ucvtf.4s	v26, v26
	ucvtf.4s	v25, v25
	ucvtf.4s	v24, v24
	fadd.4s	v24, v24, v17
	fadd.4s	v25, v25, v17
	fadd.4s	v26, v26, v17
	fadd.4s	v27, v27, v17
	fmul.4s	v27, v27, v3
	fmul.4s	v26, v26, v3
	fmul.4s	v25, v25, v3
	fmul.4s	v24, v24, v3
	add	w12, w13, w10
	add	x12, x20, w12, sxtw #2
	stp	q25, q24, [x12, #32]
	stp	q27, q26, [x12]
	tbl.16b	v24, { v23 }, v19
	tbl.16b	v25, { v23 }, v20
	tbl.16b	v26, { v23 }, v6
	tbl.16b	v21, { v23 }, v7
	ucvtf.4s	v21, v21
	ucvtf.4s	v22, v26
	ucvtf.4s	v23, v25
	ucvtf.4s	v24, v24
	fadd.4s	v24, v24, v18
	add	w12, w16, w10
	add	x12, x20, w12, sxtw #2
	fadd.4s	v23, v23, v18
	fmul.4s	v23, v23, v5
	fmul.4s	v24, v24, v5
	stp	q23, q24, [x12, #32]
	fadd.4s	v22, v22, v18
	fadd.4s	v21, v21, v18
	fmul.4s	v21, v21, v5
	fmul.4s	v22, v22, v5
	stp	q21, q22, [x12]
	add	w10, w10, #16
	subs	x9, x9, #16
	b.ne	LBB6_48
; %bb.49:                               ;   in Loop: Header=BB6_20 Depth=1
	ldr	x8, [sp, #144]                  ; 8-byte Folded Reload
	ldr	x9, [sp, #32]                   ; 8-byte Folded Reload
	cmp	x8, x9
	ldr	x13, [sp, #128]                 ; 8-byte Folded Reload
	b.eq	LBB6_19
; %bb.50:                               ;   in Loop: Header=BB6_20 Depth=1
	ldr	x9, [sp]                        ; 8-byte Folded Reload
	ldr	x8, [sp, #32]                   ; 8-byte Folded Reload
	ldr	x10, [sp, #144]                 ; 8-byte Folded Reload
	tbz	w10, #3, LBB6_24
	b	LBB6_44
LBB6_51:
	ldp	x29, x30, [sp, #368]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #352]            ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #336]            ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #320]            ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #304]            ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #288]            ; 16-byte Folded Reload
	add	sp, sp, #384
	ret
LBB6_52:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp349:
Lloh92:
	adrp	x1, l_.str.1@PAGE
Lloh93:
	add	x1, x1, l_.str.1@PAGEOFF
	bl	__ZNSt16invalid_argumentC1B9nqe210106EPKc
Ltmp350:
	b	LBB6_54
LBB6_53:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp346:
Lloh94:
	adrp	x1, l_.str.12@PAGE
Lloh95:
	add	x1, x1, l_.str.12@PAGEOFF
	bl	__ZNSt16invalid_argumentC1B9nqe210106EPKc
Ltmp347:
LBB6_54:
Lloh96:
	adrp	x1, __ZTISt16invalid_argument@GOTPAGE
Lloh97:
	ldr	x1, [x1, __ZTISt16invalid_argument@GOTPAGEOFF]
Lloh98:
	adrp	x2, __ZNSt16invalid_argumentD1Ev@GOTPAGE
Lloh99:
	ldr	x2, [x2, __ZNSt16invalid_argumentD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
LBB6_55:
Ltmp348:
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x0, x20
	bl	__Unwind_Resume
LBB6_56:
Ltmp351:
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x0, x20
	bl	__Unwind_Resume
	.loh AdrpLdr	Lloh90, Lloh91
	.loh AdrpAdrp	Lloh88, Lloh90
	.loh AdrpLdr	Lloh88, Lloh89
	.loh AdrpAdrp	Lloh86, Lloh88
	.loh AdrpLdr	Lloh86, Lloh87
	.loh AdrpAdrp	Lloh84, Lloh86
	.loh AdrpLdr	Lloh84, Lloh85
	.loh AdrpAdd	Lloh92, Lloh93
	.loh AdrpAdd	Lloh94, Lloh95
	.loh AdrpLdrGot	Lloh98, Lloh99
	.loh AdrpLdrGot	Lloh96, Lloh97
Lfunc_end5:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table6:
Lexception5:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end5-Lcst_begin5
Lcst_begin5:
	.uleb128 Lfunc_begin5-Lfunc_begin5      ; >> Call Site 1 <<
	.uleb128 Ltmp349-Lfunc_begin5           ;   Call between Lfunc_begin5 and Ltmp349
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp349-Lfunc_begin5           ; >> Call Site 2 <<
	.uleb128 Ltmp350-Ltmp349                ;   Call between Ltmp349 and Ltmp350
	.uleb128 Ltmp351-Lfunc_begin5           ;     jumps to Ltmp351
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp350-Lfunc_begin5           ; >> Call Site 3 <<
	.uleb128 Ltmp346-Ltmp350                ;   Call between Ltmp350 and Ltmp346
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp346-Lfunc_begin5           ; >> Call Site 4 <<
	.uleb128 Ltmp347-Ltmp346                ;   Call between Ltmp346 and Ltmp347
	.uleb128 Ltmp348-Lfunc_begin5           ;     jumps to Ltmp348
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp347-Lfunc_begin5           ; >> Call Site 5 <<
	.uleb128 Lfunc_end5-Ltmp347             ;   Call between Ltmp347 and Lfunc_end5
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end5:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.private_extern	___clang_call_terminate ; -- Begin function __clang_call_terminate
	.globl	___clang_call_terminate
	.weak_def_can_be_hidden	___clang_call_terminate
	.p2align	2
___clang_call_terminate:                ; @__clang_call_terminate
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	___cxa_begin_catch
	bl	__ZSt9terminatev
	.cfi_endproc
                                        ; -- End function
	.private_extern	__ZNSt3__16vectorIfNS_9allocatorIfEEE20__throw_length_errorB9nqe210106Ev ; -- Begin function _ZNSt3__16vectorIfNS_9allocatorIfEEE20__throw_length_errorB9nqe210106Ev
	.globl	__ZNSt3__16vectorIfNS_9allocatorIfEEE20__throw_length_errorB9nqe210106Ev
	.weak_def_can_be_hidden	__ZNSt3__16vectorIfNS_9allocatorIfEEE20__throw_length_errorB9nqe210106Ev
	.p2align	2
__ZNSt3__16vectorIfNS_9allocatorIfEEE20__throw_length_errorB9nqe210106Ev: ; @_ZNSt3__16vectorIfNS_9allocatorIfEEE20__throw_length_errorB9nqe210106Ev
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh100:
	adrp	x0, l_.str.11@PAGE
Lloh101:
	add	x0, x0, l_.str.11@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh100, Lloh101
	.cfi_endproc
                                        ; -- End function
	.private_extern	__ZNSt3__120__throw_length_errorB9nqe210106EPKc ; -- Begin function _ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.globl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.weak_def_can_be_hidden	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.p2align	2
__ZNSt3__120__throw_length_errorB9nqe210106EPKc: ; @_ZNSt3__120__throw_length_errorB9nqe210106EPKc
Lfunc_begin6:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception6
; %bb.0:
	stp	x20, x19, [sp, #-32]!           ; 16-byte Folded Spill
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	mov	x20, x0
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp352:
	mov	x1, x20
	bl	__ZNSt12length_errorC1B9nqe210106EPKc
Ltmp353:
; %bb.1:
Lloh102:
	adrp	x1, __ZTISt12length_error@GOTPAGE
Lloh103:
	ldr	x1, [x1, __ZTISt12length_error@GOTPAGEOFF]
Lloh104:
	adrp	x2, __ZNSt12length_errorD1Ev@GOTPAGE
Lloh105:
	ldr	x2, [x2, __ZNSt12length_errorD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
LBB9_2:
Ltmp354:
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x0, x20
	bl	__Unwind_Resume
	.loh AdrpLdrGot	Lloh104, Lloh105
	.loh AdrpLdrGot	Lloh102, Lloh103
Lfunc_end6:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table9:
Lexception6:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end6-Lcst_begin6
Lcst_begin6:
	.uleb128 Lfunc_begin6-Lfunc_begin6      ; >> Call Site 1 <<
	.uleb128 Ltmp352-Lfunc_begin6           ;   Call between Lfunc_begin6 and Ltmp352
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp352-Lfunc_begin6           ; >> Call Site 2 <<
	.uleb128 Ltmp353-Ltmp352                ;   Call between Ltmp352 and Ltmp353
	.uleb128 Ltmp354-Lfunc_begin6           ;     jumps to Ltmp354
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp353-Lfunc_begin6           ; >> Call Site 3 <<
	.uleb128 Lfunc_end6-Ltmp353             ;   Call between Ltmp353 and Lfunc_end6
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end6:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.private_extern	__ZNSt12length_errorC1B9nqe210106EPKc ; -- Begin function _ZNSt12length_errorC1B9nqe210106EPKc
	.globl	__ZNSt12length_errorC1B9nqe210106EPKc
	.weak_def_can_be_hidden	__ZNSt12length_errorC1B9nqe210106EPKc
	.p2align	2
__ZNSt12length_errorC1B9nqe210106EPKc:  ; @_ZNSt12length_errorC1B9nqe210106EPKc
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZNSt11logic_errorC2EPKc
Lloh106:
	adrp	x8, __ZTVSt12length_error@GOTPAGE
Lloh107:
	ldr	x8, [x8, __ZTVSt12length_error@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x0]
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
	.loh AdrpLdrGot	Lloh106, Lloh107
	.cfi_endproc
                                        ; -- End function
	.private_extern	__ZSt28__throw_bad_array_new_lengthB9nqe210106v ; -- Begin function _ZSt28__throw_bad_array_new_lengthB9nqe210106v
	.globl	__ZSt28__throw_bad_array_new_lengthB9nqe210106v
	.weak_def_can_be_hidden	__ZSt28__throw_bad_array_new_lengthB9nqe210106v
	.p2align	2
__ZSt28__throw_bad_array_new_lengthB9nqe210106v: ; @_ZSt28__throw_bad_array_new_lengthB9nqe210106v
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	w0, #8                          ; =0x8
	bl	___cxa_allocate_exception
	bl	__ZNSt20bad_array_new_lengthC1Ev
Lloh108:
	adrp	x1, __ZTISt20bad_array_new_length@GOTPAGE
Lloh109:
	ldr	x1, [x1, __ZTISt20bad_array_new_length@GOTPAGEOFF]
Lloh110:
	adrp	x2, __ZNSt20bad_array_new_lengthD1Ev@GOTPAGE
Lloh111:
	ldr	x2, [x2, __ZNSt20bad_array_new_lengthD1Ev@GOTPAGEOFF]
	bl	___cxa_throw
	.loh AdrpLdrGot	Lloh110, Lloh111
	.loh AdrpLdrGot	Lloh108, Lloh109
	.cfi_endproc
                                        ; -- End function
	.private_extern	__ZNSt3__16vectorIhNS_9allocatorIhEEE20__throw_length_errorB9nqe210106Ev ; -- Begin function _ZNSt3__16vectorIhNS_9allocatorIhEEE20__throw_length_errorB9nqe210106Ev
	.globl	__ZNSt3__16vectorIhNS_9allocatorIhEEE20__throw_length_errorB9nqe210106Ev
	.weak_def_can_be_hidden	__ZNSt3__16vectorIhNS_9allocatorIhEEE20__throw_length_errorB9nqe210106Ev
	.p2align	2
__ZNSt3__16vectorIhNS_9allocatorIhEEE20__throw_length_errorB9nqe210106Ev: ; @_ZNSt3__16vectorIhNS_9allocatorIhEEE20__throw_length_errorB9nqe210106Ev
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh112:
	adrp	x0, l_.str.11@PAGE
Lloh113:
	add	x0, x0, l_.str.11@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh112, Lloh113
	.cfi_endproc
                                        ; -- End function
	.private_extern	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m ; -- Begin function _ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
	.globl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
	.weak_def_can_be_hidden	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
	.p2align	2
__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m: ; @_ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Lfunc_begin7:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception7
; %bb.0:
	sub	sp, sp, #112
	stp	x26, x25, [sp, #32]             ; 16-byte Folded Spill
	stp	x24, x23, [sp, #48]             ; 16-byte Folded Spill
	stp	x22, x21, [sp, #64]             ; 16-byte Folded Spill
	stp	x20, x19, [sp, #80]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #96]             ; 16-byte Folded Spill
	add	x29, sp, #96
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_offset w23, -56
	.cfi_offset w24, -64
	.cfi_offset w25, -72
	.cfi_offset w26, -80
	mov	x21, x2
	mov	x20, x1
	mov	x19, x0
Ltmp355:
	add	x0, sp, #8
	mov	x1, x19
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryC1ERS3_
Ltmp356:
; %bb.1:
	ldrb	w8, [sp, #8]
	cmp	w8, #1
	b.ne	LBB13_10
; %bb.2:
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
	add	x4, x19, x8
	ldr	x22, [x4, #40]
	ldr	w24, [x4, #8]
	ldr	w23, [x4, #144]
	cmn	w23, #1
	b.ne	LBB13_7
; %bb.3:
Ltmp358:
	add	x8, sp, #24
	mov	x25, x4
	mov	x0, x4
	bl	__ZNKSt3__18ios_base6getlocEv
Ltmp359:
; %bb.4:
Ltmp360:
Lloh114:
	adrp	x1, __ZNSt3__15ctypeIcE2idE@GOTPAGE
Lloh115:
	ldr	x1, [x1, __ZNSt3__15ctypeIcE2idE@GOTPAGEOFF]
	add	x0, sp, #24
	bl	__ZNKSt3__16locale9use_facetERNS0_2idE
Ltmp361:
; %bb.5:
	ldr	x8, [x0]
	ldr	x8, [x8, #56]
Ltmp362:
	mov	w1, #32                         ; =0x20
	blr	x8
Ltmp363:
; %bb.6:
	mov	x23, x0
	add	x0, sp, #24
	bl	__ZNSt3__16localeD1Ev
	mov	x4, x25
	str	w23, [x25, #144]
LBB13_7:
	mov	w8, #176                        ; =0xb0
	and	w8, w24, w8
	add	x3, x20, x21
	cmp	w8, #32
	csel	x2, x3, x20, eq
Ltmp365:
	sxtb	w5, w23
	mov	x0, x22
	mov	x1, x20
	bl	__ZNSt3__116__pad_and_outputB9nqe210106IcNS_11char_traitsIcEEEENS_19ostreambuf_iteratorIT_T0_EES6_PKS4_S8_S8_RNS_8ios_baseES4_
Ltmp366:
; %bb.8:
	cbnz	x0, LBB13_10
; %bb.9:
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
	add	x0, x19, x8
	ldr	w8, [x0, #32]
	mov	w9, #5                          ; =0x5
Ltmp368:
	orr	w1, w8, w9
	bl	__ZNSt3__18ios_base5clearEj
Ltmp369:
LBB13_10:
	add	x0, sp, #8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryD1Ev
LBB13_11:
	mov	x0, x19
	ldp	x29, x30, [sp, #96]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #80]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #64]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #48]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #112
	ret
LBB13_12:
Ltmp370:
	b	LBB13_15
LBB13_13:
Ltmp364:
	mov	x20, x0
	add	x0, sp, #24
	bl	__ZNSt3__16localeD1Ev
	b	LBB13_16
LBB13_14:
Ltmp367:
LBB13_15:
	mov	x20, x0
LBB13_16:
	add	x0, sp, #8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryD1Ev
	b	LBB13_18
LBB13_17:
Ltmp357:
	mov	x20, x0
LBB13_18:
	mov	x0, x20
	bl	___cxa_begin_catch
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
Ltmp371:
	add	x0, x19, x8
	bl	__ZNSt3__18ios_base33__set_badbit_and_consider_rethrowEv
Ltmp372:
; %bb.19:
	bl	___cxa_end_catch
	b	LBB13_11
LBB13_20:
Ltmp373:
	mov	x19, x0
Ltmp374:
	bl	___cxa_end_catch
Ltmp375:
; %bb.21:
	mov	x0, x19
	bl	__Unwind_Resume
LBB13_22:
Ltmp376:
	bl	___clang_call_terminate
	.loh AdrpLdrGot	Lloh114, Lloh115
Lfunc_end7:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table13:
Lexception7:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase1-Lttbaseref1
Lttbaseref1:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end7-Lcst_begin7
Lcst_begin7:
	.uleb128 Ltmp355-Lfunc_begin7           ; >> Call Site 1 <<
	.uleb128 Ltmp356-Ltmp355                ;   Call between Ltmp355 and Ltmp356
	.uleb128 Ltmp357-Lfunc_begin7           ;     jumps to Ltmp357
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp358-Lfunc_begin7           ; >> Call Site 2 <<
	.uleb128 Ltmp359-Ltmp358                ;   Call between Ltmp358 and Ltmp359
	.uleb128 Ltmp367-Lfunc_begin7           ;     jumps to Ltmp367
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp360-Lfunc_begin7           ; >> Call Site 3 <<
	.uleb128 Ltmp363-Ltmp360                ;   Call between Ltmp360 and Ltmp363
	.uleb128 Ltmp364-Lfunc_begin7           ;     jumps to Ltmp364
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp365-Lfunc_begin7           ; >> Call Site 4 <<
	.uleb128 Ltmp366-Ltmp365                ;   Call between Ltmp365 and Ltmp366
	.uleb128 Ltmp367-Lfunc_begin7           ;     jumps to Ltmp367
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp368-Lfunc_begin7           ; >> Call Site 5 <<
	.uleb128 Ltmp369-Ltmp368                ;   Call between Ltmp368 and Ltmp369
	.uleb128 Ltmp370-Lfunc_begin7           ;     jumps to Ltmp370
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp369-Lfunc_begin7           ; >> Call Site 6 <<
	.uleb128 Ltmp371-Ltmp369                ;   Call between Ltmp369 and Ltmp371
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp371-Lfunc_begin7           ; >> Call Site 7 <<
	.uleb128 Ltmp372-Ltmp371                ;   Call between Ltmp371 and Ltmp372
	.uleb128 Ltmp373-Lfunc_begin7           ;     jumps to Ltmp373
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp372-Lfunc_begin7           ; >> Call Site 8 <<
	.uleb128 Ltmp374-Ltmp372                ;   Call between Ltmp372 and Ltmp374
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp374-Lfunc_begin7           ; >> Call Site 9 <<
	.uleb128 Ltmp375-Ltmp374                ;   Call between Ltmp374 and Ltmp375
	.uleb128 Ltmp376-Lfunc_begin7           ;     jumps to Ltmp376
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp375-Lfunc_begin7           ; >> Call Site 10 <<
	.uleb128 Lfunc_end7-Ltmp375             ;   Call between Ltmp375 and Lfunc_end7
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end7:
	.byte	1                               ; >> Action Record 1 <<
                                        ;   Catch TypeInfo 1
	.byte	0                               ;   No further actions
	.p2align	2, 0x0
                                        ; >> Catch TypeInfos <<
	.long	0                               ; TypeInfo 1
Lttbase1:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.private_extern	__ZNSt3__116__pad_and_outputB9nqe210106IcNS_11char_traitsIcEEEENS_19ostreambuf_iteratorIT_T0_EES6_PKS4_S8_S8_RNS_8ios_baseES4_ ; -- Begin function _ZNSt3__116__pad_and_outputB9nqe210106IcNS_11char_traitsIcEEEENS_19ostreambuf_iteratorIT_T0_EES6_PKS4_S8_S8_RNS_8ios_baseES4_
	.globl	__ZNSt3__116__pad_and_outputB9nqe210106IcNS_11char_traitsIcEEEENS_19ostreambuf_iteratorIT_T0_EES6_PKS4_S8_S8_RNS_8ios_baseES4_
	.weak_def_can_be_hidden	__ZNSt3__116__pad_and_outputB9nqe210106IcNS_11char_traitsIcEEEENS_19ostreambuf_iteratorIT_T0_EES6_PKS4_S8_S8_RNS_8ios_baseES4_
	.p2align	2
__ZNSt3__116__pad_and_outputB9nqe210106IcNS_11char_traitsIcEEEENS_19ostreambuf_iteratorIT_T0_EES6_PKS4_S8_S8_RNS_8ios_baseES4_: ; @_ZNSt3__116__pad_and_outputB9nqe210106IcNS_11char_traitsIcEEEENS_19ostreambuf_iteratorIT_T0_EES6_PKS4_S8_S8_RNS_8ios_baseES4_
Lfunc_begin8:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception8
; %bb.0:
	sub	sp, sp, #112
	stp	x26, x25, [sp, #32]             ; 16-byte Folded Spill
	stp	x24, x23, [sp, #48]             ; 16-byte Folded Spill
	stp	x22, x21, [sp, #64]             ; 16-byte Folded Spill
	stp	x20, x19, [sp, #80]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #96]             ; 16-byte Folded Spill
	add	x29, sp, #96
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_offset w23, -56
	.cfi_offset w24, -64
	.cfi_offset w25, -72
	.cfi_offset w26, -80
	mov	x19, x0
	cbz	x0, LBB14_16
; %bb.1:
	mov	x23, x5
	mov	x20, x4
	mov	x22, x3
	mov	x21, x2
	mov	x24, x1
	ldr	x26, [x4, #24]
	sub	x25, x2, x1
	cmp	x25, #1
	b.lt	LBB14_3
; %bb.2:
	ldr	x8, [x19]
	ldr	x8, [x8, #96]
	mov	x0, x19
	mov	x1, x24
	mov	x2, x25
	blr	x8
	cmp	x0, x25
	b.ne	LBB14_15
LBB14_3:
	sub	x8, x22, x24
	cmp	x26, x8
	b.le	LBB14_12
; %bb.4:
	mov	x9, #-9                         ; =0xfffffffffffffff7
	movk	x9, #32767, lsl #48
	sub	x24, x26, x8
	cmp	x24, x9
	b.hs	LBB14_17
; %bb.5:
	cmp	x24, #23
	b.hs	LBB14_7
; %bb.6:
	strb	w24, [sp, #31]
	add	x25, sp, #8
	b	LBB14_8
LBB14_7:
	orr	x8, x24, #0x7
	cmp	x8, #23
	mov	w9, #25                         ; =0x19
	csinc	x26, x9, x8, eq
	mov	x0, x26
	bl	__Znwm
	mov	x25, x0
	orr	x8, x26, #0x8000000000000000
	stp	x24, x8, [sp, #16]
	str	x0, [sp, #8]
LBB14_8:
	mov	x0, x25
	mov	x1, x23
	mov	x2, x24
	bl	_memset
	strb	wzr, [x25, x24]
	ldrsb	w8, [sp, #31]
	ldr	x9, [sp, #8]
	cmp	w8, #0
	add	x8, sp, #8
	csel	x1, x9, x8, lt
	ldr	x8, [x19]
	ldr	x8, [x8, #96]
Ltmp377:
	mov	x0, x19
	mov	x2, x24
	blr	x8
Ltmp378:
; %bb.9:
	ldrsb	w8, [sp, #31]
	tbnz	w8, #31, LBB14_11
; %bb.10:
	cmp	x0, x24
	b.ne	LBB14_15
	b	LBB14_12
LBB14_11:
	ldr	x8, [sp, #8]
	mov	x23, x0
	mov	x0, x8
	bl	__ZdlPv
	cmp	x23, x24
	b.ne	LBB14_15
LBB14_12:
	sub	x22, x22, x21
	cmp	x22, #1
	b.lt	LBB14_14
; %bb.13:
	ldr	x8, [x19]
	ldr	x8, [x8, #96]
	mov	x0, x19
	mov	x1, x21
	mov	x2, x22
	blr	x8
	cmp	x0, x22
	b.ne	LBB14_15
LBB14_14:
	str	xzr, [x20, #24]
	b	LBB14_16
LBB14_15:
	mov	x19, #0                         ; =0x0
LBB14_16:
	mov	x0, x19
	ldp	x29, x30, [sp, #96]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #80]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #64]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #48]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #112
	ret
LBB14_17:
	bl	__ZNSt3__112basic_stringIcNS_11char_traitsIcEENS_9allocatorIcEEE20__throw_length_errorB9nqe210106Ev
LBB14_18:
Ltmp379:
	mov	x19, x0
	ldrsb	w8, [sp, #31]
	tbz	w8, #31, LBB14_20
; %bb.19:
	ldr	x0, [sp, #8]
	bl	__ZdlPv
LBB14_20:
	mov	x0, x19
	bl	__Unwind_Resume
Lfunc_end8:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table14:
Lexception8:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end8-Lcst_begin8
Lcst_begin8:
	.uleb128 Lfunc_begin8-Lfunc_begin8      ; >> Call Site 1 <<
	.uleb128 Ltmp377-Lfunc_begin8           ;   Call between Lfunc_begin8 and Ltmp377
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp377-Lfunc_begin8           ; >> Call Site 2 <<
	.uleb128 Ltmp378-Ltmp377                ;   Call between Ltmp377 and Ltmp378
	.uleb128 Ltmp379-Lfunc_begin8           ;     jumps to Ltmp379
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp378-Lfunc_begin8           ; >> Call Site 3 <<
	.uleb128 Lfunc_end8-Ltmp378             ;   Call between Ltmp378 and Lfunc_end8
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end8:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.private_extern	__ZNSt3__112basic_stringIcNS_11char_traitsIcEENS_9allocatorIcEEE20__throw_length_errorB9nqe210106Ev ; -- Begin function _ZNSt3__112basic_stringIcNS_11char_traitsIcEENS_9allocatorIcEEE20__throw_length_errorB9nqe210106Ev
	.globl	__ZNSt3__112basic_stringIcNS_11char_traitsIcEENS_9allocatorIcEEE20__throw_length_errorB9nqe210106Ev
	.weak_def_can_be_hidden	__ZNSt3__112basic_stringIcNS_11char_traitsIcEENS_9allocatorIcEEE20__throw_length_errorB9nqe210106Ev
	.p2align	2
__ZNSt3__112basic_stringIcNS_11char_traitsIcEENS_9allocatorIcEEE20__throw_length_errorB9nqe210106Ev: ; @_ZNSt3__112basic_stringIcNS_11char_traitsIcEENS_9allocatorIcEEE20__throw_length_errorB9nqe210106Ev
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh116:
	adrp	x0, l_.str.13@PAGE
Lloh117:
	add	x0, x0, l_.str.13@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh116, Lloh117
	.cfi_endproc
                                        ; -- End function
	.private_extern	__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_length_errorB9nqe210106Ev ; -- Begin function _ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_length_errorB9nqe210106Ev
	.globl	__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_length_errorB9nqe210106Ev
	.weak_def_can_be_hidden	__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_length_errorB9nqe210106Ev
	.p2align	2
__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_length_errorB9nqe210106Ev: ; @_ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_length_errorB9nqe210106Ev
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh118:
	adrp	x0, l_.str.11@PAGE
Lloh119:
	add	x0, x0, l_.str.11@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh118, Lloh119
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _Z5checkb.cold.1
__Z5checkb.cold.1:                      ; @_Z5checkb.cold.1
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh120:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh121:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh122:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh123:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	bl	___cxa_throw
	.loh AdrpLdrGot	Lloh122, Lloh123
	.loh AdrpLdrGot	Lloh120, Lloh121
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _Z8validateRKNSt3__16vectorIhNS_9allocatorIhEEEEiii.cold.1
__Z8validateRKNSt3__16vectorIhNS_9allocatorIhEEEEiii.cold.1: ; @_Z8validateRKNSt3__16vectorIhNS_9allocatorIhEEEEiii.cold.1
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	_OUTLINED_FUNCTION_0
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _Z9referenceRKNSt3__16vectorIhNS_9allocatorIhEEEEiii.cold.1
__Z9referenceRKNSt3__16vectorIhNS_9allocatorIhEEEEiii.cold.1: ; @_Z9referenceRKNSt3__16vectorIhNS_9allocatorIhEEEEiii.cold.1
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	_OUTLINED_FUNCTION_0
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function OUTLINED_FUNCTION_0
_OUTLINED_FUNCTION_0:                   ; @OUTLINED_FUNCTION_0 Thunk
	.cfi_startproc
; %bb.0:
	adrp	x1, __ZTISt16invalid_argument@GOTPAGE
	ldr	x1, [x1, __ZTISt16invalid_argument@GOTPAGEOFF]
	adrp	x2, __ZNSt16invalid_argumentD1Ev@GOTPAGE
	ldr	x2, [x2, __ZNSt16invalid_argumentD1Ev@GOTPAGEOFF]
	b	___cxa_throw
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"check failed"

l_.str.1:                               ; @.str.1
	.asciz	"shape/stride/storage"

	.section	__TEXT,__const
	.p2align	2, 0x0                          ; @constinit
l_constinit:
	.long	0                               ; 0x0
	.long	1                               ; 0x1
	.long	7                               ; 0x7
	.long	8                               ; 0x8
	.long	9                               ; 0x9
	.long	15                              ; 0xf
	.long	16                              ; 0x10
	.long	17                              ; 0x11
	.long	641                             ; 0x281

	.section	__TEXT,__cstring,cstring_literals
l_.str.2:                               ; @.str.2
	.asciz	"lane CHW:"

l_.str.3:                               ; @.str.3
	.asciz	"\nPASS shapes="

l_.str.4:                               ; @.str.4
	.asciz	" rejects=2 bitwise_equal=true\n"

l_.str.5:                               ; @.str.5
	.asciz	"CPU batch_mean_p50_us width="

l_.str.6:                               ; @.str.6
	.asciz	" height="

l_.str.7:                               ; @.str.7
	.asciz	" split="

l_.str.8:                               ; @.str.8
	.asciz	" fused="

l_.str.9:                               ; @.str.9
	.asciz	" alloc_split="

l_.str.10:                              ; @.str.10
	.asciz	" alloc_fused="

l_.str.11:                              ; @.str.11
	.asciz	"vector"

l_.str.12:                              ; @.str.12
	.asciz	"output size"

l_.str.13:                              ; @.str.13
	.asciz	"basic_string"

.subsections_via_symbols
