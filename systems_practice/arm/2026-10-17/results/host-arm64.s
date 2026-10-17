	.build_version macos, 26, 0	sdk_version 26, 5
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__Z4packRKNSt3__16vectorIaNS_9allocatorIaEEEE ; -- Begin function _Z4packRKNSt3__16vectorIaNS_9allocatorIaEEEE
	.p2align	2
__Z4packRKNSt3__16vectorIaNS_9allocatorIaEEEE: ; @_Z4packRKNSt3__16vectorIaNS_9allocatorIaEEEE
Lfunc_begin0:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception0
; %bb.0:
	stp	x24, x23, [sp, #-64]!           ; 16-byte Folded Spill
	stp	x22, x21, [sp, #16]             ; 16-byte Folded Spill
	stp	x20, x19, [sp, #32]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #48]             ; 16-byte Folded Spill
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_offset w23, -56
	.cfi_offset w24, -64
	mov	x19, x8
	ldp	x22, x8, [x0]
	cmp	x22, x8
	b.eq	LBB0_19
; %bb.1:
	sub	x23, x8, x22
	add	x8, x23, #31
	stp	xzr, xzr, [x19]
	str	xzr, [x19, #16]
	cmp	x8, #32
	b.lo	LBB0_15
; %bb.2:
	lsr	x24, x8, #5
	add	x8, x24, x24, lsl #2
	lsl	x21, x8, #2
	mov	x0, x21
	bl	__Znwm
	mov	x20, x0
	str	x0, [x19]
	add	x9, x0, x21
	str	x9, [x19, #16]
	mov	w8, #1065353216                 ; =0x3f800000
	mov	x10, x0
LBB0_3:                                 ; =>This Inner Loop Header: Depth=1
	stp	xzr, xzr, [x10]
	str	w8, [x10, #16]
	add	x10, x10, #20
	cmp	x10, x9
	b.ne	LBB0_3
; %bb.4:
	mov	x8, #0                          ; =0x0
	str	x9, [x19, #8]
	mov	w9, #16                         ; =0x10
	mov	x10, #-6148914691236517206      ; =0xaaaaaaaaaaaaaaaa
	movk	x10, #43691
	mov	w11, #20                        ; =0x14
	mov	x12, x20
LBB0_5:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB0_6 Depth 2
	umulh	x13, x8, x10
	lsr	x13, x13, #1
	add	x13, x13, x13, lsl #1
	sub	x13, x8, x13
	add	x13, x13, #1
	ucvtf	s0, x13, #3
	madd	x13, x8, x11, x20
	str	s0, [x13, #16]
	mov	w13, #16                        ; =0x10
	mov	x14, x9
	mov	x15, x12
LBB0_6:                                 ;   Parent Loop BB0_5 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	sub	x16, x14, #16
	cmp	x16, x23
	b.hs	LBB0_9
; %bb.7:                                ;   in Loop: Header=BB0_6 Depth=2
	add	x16, x22, x14
	ldursb	w16, [x16, #-16]
	cmp	x14, x23
	b.lo	LBB0_10
LBB0_8:                                 ;   in Loop: Header=BB0_6 Depth=2
	mov	w17, #0                         ; =0x0
	b	LBB0_11
LBB0_9:                                 ;   in Loop: Header=BB0_6 Depth=2
	mov	w16, #0                         ; =0x0
	cmp	x14, x23
	b.hs	LBB0_8
LBB0_10:                                ;   in Loop: Header=BB0_6 Depth=2
	ldrsb	w17, [x22, x14]
LBB0_11:                                ;   in Loop: Header=BB0_6 Depth=2
	sub	w0, w16, #8
	cmn	w0, #16
	b.lo	LBB0_16
; %bb.12:                               ;   in Loop: Header=BB0_6 Depth=2
	sub	w0, w17, #8
	cmn	w0, #17
	b.ls	LBB0_16
; %bb.13:                               ;   in Loop: Header=BB0_6 Depth=2
	add	w16, w16, #8
	lsl	w17, w17, #4
	eor	w17, w17, #0x80
	orr	w16, w17, w16
	strb	w16, [x15], #1
	add	x14, x14, #1
	subs	x13, x13, #1
	b.ne	LBB0_6
; %bb.14:                               ;   in Loop: Header=BB0_5 Depth=1
	add	x8, x8, #1
	add	x12, x12, #20
	add	x9, x9, #32
	cmp	x8, x24
	b.ne	LBB0_5
LBB0_15:
	ldp	x29, x30, [sp, #48]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #32]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #16]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp], #64             ; 16-byte Folded Reload
	ret
LBB0_16:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x22, x0
Ltmp0:
Lloh0:
	adrp	x1, l_.str.1@PAGE
Lloh1:
	add	x1, x1, l_.str.1@PAGEOFF
	bl	__ZNSt11logic_errorC2EPKc
Ltmp1:
; %bb.17:
Lloh2:
	adrp	x8, __ZTVSt16invalid_argument@GOTPAGE
Lloh3:
	ldr	x8, [x8, __ZTVSt16invalid_argument@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x22]
Ltmp3:
Lloh4:
	adrp	x1, __ZTISt16invalid_argument@GOTPAGE
Lloh5:
	ldr	x1, [x1, __ZTISt16invalid_argument@GOTPAGEOFF]
Lloh6:
	adrp	x2, __ZNSt16invalid_argumentD1Ev@GOTPAGE
Lloh7:
	ldr	x2, [x2, __ZNSt16invalid_argumentD1Ev@GOTPAGEOFF]
	mov	x0, x22
	bl	___cxa_throw
Ltmp4:
; %bb.18:
	brk	#0x1
LBB0_19:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp6:
Lloh8:
	adrp	x1, l_.str@PAGE
Lloh9:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt16invalid_argumentC1B9nqe210106EPKc
Ltmp7:
; %bb.20:
	mov	x0, x19
	bl	__Z4packRKNSt3__16vectorIaNS_9allocatorIaEEEE.cold.1
LBB0_21:
Ltmp8:
	mov	x21, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x0, x21
	bl	__Unwind_Resume
LBB0_22:
Ltmp5:
	mov	x21, x0
	b	LBB0_24
LBB0_23:
Ltmp2:
	mov	x21, x0
	mov	x0, x22
	bl	___cxa_free_exception
LBB0_24:
	str	x20, [x19, #8]
	mov	x0, x20
	bl	__ZdlPv
	mov	x0, x21
	bl	__Unwind_Resume
	.loh AdrpAdd	Lloh0, Lloh1
	.loh AdrpLdrGot	Lloh6, Lloh7
	.loh AdrpLdrGot	Lloh4, Lloh5
	.loh AdrpLdrGot	Lloh2, Lloh3
	.loh AdrpAdd	Lloh8, Lloh9
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
	.uleb128 Ltmp3-Lfunc_begin0             ; >> Call Site 3 <<
	.uleb128 Ltmp4-Ltmp3                    ;   Call between Ltmp3 and Ltmp4
	.uleb128 Ltmp5-Lfunc_begin0             ;     jumps to Ltmp5
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp4-Lfunc_begin0             ; >> Call Site 4 <<
	.uleb128 Ltmp6-Ltmp4                    ;   Call between Ltmp4 and Ltmp6
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp6-Lfunc_begin0             ; >> Call Site 5 <<
	.uleb128 Ltmp7-Ltmp6                    ;   Call between Ltmp6 and Ltmp7
	.uleb128 Ltmp8-Lfunc_begin0             ;     jumps to Ltmp8
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp7-Lfunc_begin0             ; >> Call Site 6 <<
	.uleb128 Lfunc_end0-Ltmp7               ;   Call between Ltmp7 and Lfunc_end0
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end0:
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
Lloh10:
	adrp	x8, __ZTVSt16invalid_argument@GOTPAGE
Lloh11:
	ldr	x8, [x8, __ZTVSt16invalid_argument@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x0]
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
	.loh AdrpLdrGot	Lloh10, Lloh11
	.cfi_endproc
                                        ; -- End function
	.globl	__Z6decodeRKNSt3__16vectorI5BlockNS_9allocatorIS1_EEEERNS0_IfNS2_IfEEEE ; -- Begin function _Z6decodeRKNSt3__16vectorI5BlockNS_9allocatorIS1_EEEERNS0_IfNS2_IfEEEE
	.p2align	2
__Z6decodeRKNSt3__16vectorI5BlockNS_9allocatorIS1_EEEERNS0_IfNS2_IfEEEE: ; @_Z6decodeRKNSt3__16vectorI5BlockNS_9allocatorIS1_EEEERNS0_IfNS2_IfEEEE
	.cfi_startproc
; %bb.0:
	ldp	x8, x9, [x1]
	subs	x10, x9, x8
	b.eq	LBB2_3
; %bb.1:
	mov	x9, #0                          ; =0x0
	asr	x10, x10, #2
	ldr	x11, [x0]
	mov	w12, #20                        ; =0x14
LBB2_2:                                 ; =>This Inner Loop Header: Depth=1
	lsr	x13, x9, #5
	madd	x13, x13, x12, x11
	and	x14, x9, #0xf
	ldrb	w14, [x13, x14]
	and	w15, w14, #0xf
	lsr	w14, w14, #4
	tst	x9, #0x10
	csel	w14, w15, w14, eq
	sub	w14, w14, #8
	scvtf	s0, w14
	ldr	s1, [x13, #16]
	fmul	s0, s1, s0
	str	s0, [x8, x9, lsl #2]
	add	x9, x9, #1
	cmp	x10, x9
	b.ne	LBB2_2
LBB2_3:
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__Z9separatedRKNSt3__16vectorI5BlockNS_9allocatorIS1_EEEERKNS0_IfNS2_IfEEEERS8_ ; -- Begin function _Z9separatedRKNSt3__16vectorI5BlockNS_9allocatorIS1_EEEERKNS0_IfNS2_IfEEEERS8_
	.p2align	2
__Z9separatedRKNSt3__16vectorI5BlockNS_9allocatorIS1_EEEERKNS0_IfNS2_IfEEEERS8_: ; @_Z9separatedRKNSt3__16vectorI5BlockNS_9allocatorIS1_EEEERKNS0_IfNS2_IfEEEERS8_
	.cfi_startproc
; %bb.0:
	ldp	x8, x9, [x2]
	subs	x10, x9, x8
	b.eq	LBB3_3
; %bb.1:
	mov	x9, #0                          ; =0x0
	asr	x10, x10, #2
	ldr	x11, [x0]
	mov	w12, #20                        ; =0x14
LBB3_2:                                 ; =>This Inner Loop Header: Depth=1
	lsr	x13, x9, #5
	madd	x13, x13, x12, x11
	and	x14, x9, #0xf
	ldrb	w14, [x13, x14]
	and	w15, w14, #0xf
	lsr	w14, w14, #4
	tst	x9, #0x10
	csel	w14, w15, w14, eq
	sub	w14, w14, #8
	scvtf	s0, w14
	ldr	s1, [x13, #16]
	fmul	s0, s1, s0
	str	s0, [x8, x9, lsl #2]
	add	x9, x9, #1
	cmp	x10, x9
	b.ne	LBB3_2
LBB3_3:
	ldp	x9, x10, [x1]
	sub	x10, x10, x9
	asr	x10, x10, #2
	cmp	x10, #4
	b.hs	LBB3_5
; %bb.4:
	mov	x11, #0                         ; =0x0
	movi.2d	v0, #0000000000000000
	b	LBB3_7
LBB3_5:
	mov	x12, #0                         ; =0x0
	movi.2d	v0, #0000000000000000
	mov	x13, x8
	mov	x14, x9
LBB3_6:                                 ; =>This Inner Loop Header: Depth=1
	ldr	q1, [x14], #16
	ldr	q2, [x13], #16
	fmla.4s	v0, v2, v1
	add	x11, x12, #4
	add	x15, x12, #8
	mov	x12, x11
	cmp	x15, x10
	b.ls	LBB3_6
LBB3_7:
	faddp.4s	v0, v0, v0
	faddp.2s	s0, v0
	subs	x10, x10, x11
	b.ls	LBB3_10
; %bb.8:
	lsl	x11, x11, #2
	add	x9, x9, x11
	add	x8, x8, x11
LBB3_9:                                 ; =>This Inner Loop Header: Depth=1
	ldr	s1, [x9], #4
	ldr	s2, [x8], #4
	fmadd	s0, s1, s2, s0
	subs	x10, x10, #1
	b.ne	LBB3_9
LBB3_10:
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__Z5fusedRKNSt3__16vectorI5BlockNS_9allocatorIS1_EEEERKNS0_IfNS2_IfEEEE ; -- Begin function _Z5fusedRKNSt3__16vectorI5BlockNS_9allocatorIS1_EEEERKNS0_IfNS2_IfEEEE
	.p2align	2
__Z5fusedRKNSt3__16vectorI5BlockNS_9allocatorIS1_EEEERKNS0_IfNS2_IfEEEE: ; @_Z5fusedRKNSt3__16vectorI5BlockNS_9allocatorIS1_EEEERKNS0_IfNS2_IfEEEE
	.cfi_startproc
; %bb.0:
	ldp	x8, x9, [x1]
	sub	x9, x9, x8
	asr	x9, x9, #2
	cmp	x9, #32
	b.hs	LBB4_2
; %bb.1:
	mov	x14, #0                         ; =0x0
	movi.2d	v0, #0000000000000000
	b	LBB4_4
LBB4_2:
	mov	x12, #0                         ; =0x0
	ldr	x10, [x0]
	add	x11, x8, #64
	movi.2d	v0, #0000000000000000
	mov	w13, #20                        ; =0x14
	movi.16b	v1, #15
	movi.16b	v2, #248
LBB4_3:                                 ; =>This Inner Loop Header: Depth=1
	lsr	x14, x12, #5
	madd	x14, x14, x13, x10
	ldr	q3, [x14]
	and.16b	v4, v3, v1
	add.16b	v4, v4, v2
	movi.16b	v5, #248
	usra.16b	v5, v3, #4
	sshll.8h	v3, v4, #0
	sshll2.8h	v4, v4, #0
	ldr	s6, [x14, #16]
	sshll.4s	v7, v3, #0
	scvtf.4s	v7, v7
	fmul.4s	v7, v7, v6[0]
	ldp	q16, q17, [x11, #-64]
	fmla.4s	v0, v16, v7
	sshll.8h	v7, v5, #0
	sshll2.8h	v5, v5, #0
	sshll2.4s	v3, v3, #0
	scvtf.4s	v3, v3
	fmul.4s	v3, v3, v6[0]
	fmla.4s	v0, v17, v3
	sshll.4s	v3, v4, #0
	scvtf.4s	v3, v3
	fmul.4s	v3, v3, v6[0]
	sshll2.4s	v4, v4, #0
	scvtf.4s	v4, v4
	fmul.4s	v4, v4, v6[0]
	ldp	q16, q17, [x11, #-32]
	fmla.4s	v0, v16, v3
	fmla.4s	v0, v17, v4
	sshll.4s	v3, v7, #0
	scvtf.4s	v3, v3
	fmul.4s	v3, v3, v6[0]
	sshll2.4s	v4, v7, #0
	scvtf.4s	v4, v4
	fmul.4s	v4, v4, v6[0]
	ldp	q7, q16, [x11]
	fmla.4s	v0, v7, v3
	fmla.4s	v0, v16, v4
	sshll.4s	v3, v5, #0
	scvtf.4s	v3, v3
	fmul.4s	v3, v3, v6[0]
	sshll2.4s	v4, v5, #0
	scvtf.4s	v4, v4
	fmul.4s	v4, v4, v6[0]
	ldp	q5, q6, [x11, #32]
	fmla.4s	v0, v5, v3
	fmla.4s	v0, v6, v4
	add	x14, x12, #32
	add	x15, x12, #64
	add	x11, x11, #128
	mov	x12, x14
	cmp	x15, x9
	b.ls	LBB4_3
LBB4_4:
	faddp.4s	v0, v0, v0
	faddp.2s	s0, v0
	cmp	x14, x9
	b.hs	LBB4_7
; %bb.5:
	ldr	x10, [x0]
	mov	w11, #20                        ; =0x14
LBB4_6:                                 ; =>This Inner Loop Header: Depth=1
	lsr	x12, x14, #5
	madd	x12, x12, x11, x10
	and	x13, x14, #0xf
	ldrb	w13, [x12, x13]
	and	w15, w13, #0xf
	lsr	w13, w13, #4
	tst	x14, #0x10
	csel	w13, w15, w13, eq
	sub	w13, w13, #8
	scvtf	s1, w13
	ldr	s2, [x12, #16]
	fmul	s1, s2, s1
	ldr	s2, [x8, x14, lsl #2]
	fmadd	s0, s1, s2, s0
	add	x14, x14, #1
	cmp	x9, x14
	b.ne	LBB4_6
LBB4_7:
	ret
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__literal16,16byte_literals
	.p2align	4, 0x0                          ; -- Begin function main
lCPI5_0:
	.long	12                              ; 0xc
	.long	13                              ; 0xd
	.long	14                              ; 0xe
	.long	15                              ; 0xf
lCPI5_1:
	.long	8                               ; 0x8
	.long	9                               ; 0x9
	.long	10                              ; 0xa
	.long	11                              ; 0xb
lCPI5_2:
	.long	4                               ; 0x4
	.long	5                               ; 0x5
	.long	6                               ; 0x6
	.long	7                               ; 0x7
lCPI5_3:
	.long	0                               ; 0x0
	.long	1                               ; 0x1
	.long	2                               ; 0x2
	.long	3                               ; 0x3
lCPI5_4:
	.byte	0                               ; 0x0
	.byte	1                               ; 0x1
	.byte	2                               ; 0x2
	.byte	3                               ; 0x3
	.byte	4                               ; 0x4
	.byte	5                               ; 0x5
	.byte	6                               ; 0x6
	.byte	7                               ; 0x7
	.byte	8                               ; 0x8
	.byte	9                               ; 0x9
	.byte	10                              ; 0xa
	.byte	11                              ; 0xb
	.byte	12                              ; 0xc
	.byte	13                              ; 0xd
	.byte	14                              ; 0xe
	.byte	15                              ; 0xf
lCPI5_6:
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
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
lCPI5_7:
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
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
lCPI5_8:
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
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
lCPI5_9:
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
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
	.section	__TEXT,__literal8,8byte_literals
	.p2align	3, 0x0
lCPI5_5:
	.short	0                               ; 0x0
	.short	1                               ; 0x1
	.short	2                               ; 0x2
	.short	3                               ; 0x3
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_main
	.p2align	2
_main:                                  ; @main
Lfunc_begin1:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception1
; %bb.0:
	sub	sp, sp, #384
	stp	d13, d12, [sp, #240]            ; 16-byte Folded Spill
	stp	d11, d10, [sp, #256]            ; 16-byte Folded Spill
	stp	d9, d8, [sp, #272]              ; 16-byte Folded Spill
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
	.cfi_offset b8, -104
	.cfi_offset b9, -112
	.cfi_offset b10, -120
	.cfi_offset b11, -128
	.cfi_offset b12, -136
	.cfi_offset b13, -144
	mov	x19, #0                         ; =0x0
	adrp	x24, _sink@PAGE
	mov	w23, #20                        ; =0x14
Lloh12:
	adrp	x8, lCPI5_9@PAGE
Lloh13:
	ldr	q0, [x8, lCPI5_9@PAGEOFF]
	str	q0, [sp, #48]                   ; 16-byte Folded Spill
Lloh14:
	adrp	x8, lCPI5_6@PAGE
Lloh15:
	ldr	q0, [x8, lCPI5_6@PAGEOFF]
	str	q0, [sp, #32]                   ; 16-byte Folded Spill
Lloh16:
	adrp	x8, lCPI5_7@PAGE
Lloh17:
	ldr	q0, [x8, lCPI5_7@PAGEOFF]
	str	q0, [sp, #16]                   ; 16-byte Folded Spill
Lloh18:
	adrp	x8, lCPI5_8@PAGE
Lloh19:
	ldr	q0, [x8, lCPI5_8@PAGEOFF]
	str	q0, [sp]                        ; 16-byte Folded Spill
	movi.4h	v9, #15
	movi.4h	v10, #248
	movi.4h	v11, #4
	b	LBB5_2
LBB5_1:                                 ;   in Loop: Header=BB5_2 Depth=1
	add	x19, x19, #4
	cmp	x19, #48
	b.eq	LBB5_125
LBB5_2:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB5_13 Depth 2
                                        ;     Child Loop BB5_17 Depth 2
                                        ;     Child Loop BB5_20 Depth 2
                                        ;     Child Loop BB5_29 Depth 2
                                        ;     Child Loop BB5_33 Depth 2
                                        ;     Child Loop BB5_35 Depth 2
                                        ;     Child Loop BB5_38 Depth 2
                                        ;     Child Loop BB5_42 Depth 2
                                        ;     Child Loop BB5_45 Depth 2
                                        ;     Child Loop BB5_61 Depth 2
                                        ;       Child Loop BB5_63 Depth 3
                                        ;       Child Loop BB5_67 Depth 3
                                        ;       Child Loop BB5_70 Depth 3
                                        ;     Child Loop BB5_74 Depth 2
                                        ;       Child Loop BB5_76 Depth 3
                                        ;         Child Loop BB5_78 Depth 4
                                        ;         Child Loop BB5_82 Depth 4
                                        ;         Child Loop BB5_85 Depth 4
                                        ;     Child Loop BB5_99 Depth 2
                                        ;       Child Loop BB5_100 Depth 3
Lloh20:
	adrp	x8, l_constinit@PAGE
Lloh21:
	add	x8, x8, l_constinit@PAGEOFF
	ldrsw	x28, [x8, x19]
	mov	w22, w28
	stp	xzr, xzr, [x29, #-168]
	stur	xzr, [x29, #-152]
	str	x19, [sp, #80]                  ; 8-byte Folded Spill
	cbz	w28, LBB5_9
; %bb.3:                                ;   in Loop: Header=BB5_2 Depth=1
	tbnz	w28, #31, LBB5_137
; %bb.4:                                ;   in Loop: Header=BB5_2 Depth=1
Ltmp9:
	mov	x0, x28
	bl	__Znwm
Ltmp10:
; %bb.5:                                ;   in Loop: Header=BB5_2 Depth=1
	mov	x20, x0
	add	x19, x0, x28
	stur	x0, [x29, #-168]
	stur	x19, [x29, #-152]
	mov	x1, x28
	bl	_bzero
	stur	x19, [x29, #-160]
	lsl	x21, x28, #2
Ltmp12:
	mov	x0, x21
	bl	__Znwm
Ltmp13:
; %bb.6:                                ;   in Loop: Header=BB5_2 Depth=1
	mov	x27, x0
	add	x8, x0, x28, lsl #2
	str	x0, [sp, #176]
	str	x8, [sp, #192]
	add	x26, x0, x21
	mov	x1, x21
	bl	_bzero
	str	x26, [sp, #184]
Ltmp15:
	mov	x0, x21
	bl	__Znwm
Ltmp16:
; %bb.7:                                ;   in Loop: Header=BB5_2 Depth=1
	mov	x19, x0
	add	x25, x0, x21
	mov	x1, x21
	bl	_bzero
	cmp	w22, #3
	b.hi	LBB5_10
; %bb.8:                                ;   in Loop: Header=BB5_2 Depth=1
	mov	x8, #0                          ; =0x0
	b	LBB5_19
LBB5_9:                                 ;   in Loop: Header=BB5_2 Depth=1
	mov	x25, #0                         ; =0x0
	mov	x19, #0                         ; =0x0
	mov	x20, #0                         ; =0x0
	mov	x27, #0                         ; =0x0
	mov	x26, #0                         ; =0x0
	stp	xzr, xzr, [sp, #176]
	str	xzr, [sp, #192]
	b	LBB5_21
LBB5_10:                                ;   in Loop: Header=BB5_2 Depth=1
	mov	w8, #17097                      ; =0x42c9
	movk	w8, #45590, lsl #16
	dup.4s	v0, w8
	mov	w8, #1031798784                 ; =0x3d800000
	dup.4s	v1, w8
	cmp	w22, #16
	b.hs	LBB5_12
; %bb.11:                               ;   in Loop: Header=BB5_2 Depth=1
	mov	x8, #0                          ; =0x0
	b	LBB5_16
LBB5_12:                                ;   in Loop: Header=BB5_2 Depth=1
	mov	x9, #0                          ; =0x0
	and	x8, x22, #0x7ffffff0
Lloh22:
	adrp	x10, lCPI5_0@PAGE
Lloh23:
	ldr	q2, [x10, lCPI5_0@PAGEOFF]
Lloh24:
	adrp	x10, lCPI5_1@PAGE
Lloh25:
	ldr	q3, [x10, lCPI5_1@PAGEOFF]
Lloh26:
	adrp	x10, lCPI5_2@PAGE
Lloh27:
	ldr	q4, [x10, lCPI5_2@PAGEOFF]
Lloh28:
	adrp	x10, lCPI5_3@PAGE
Lloh29:
	ldr	q5, [x10, lCPI5_3@PAGEOFF]
	lsl	x10, x22, #2
	and	x10, x10, #0x1ffffffc0
	mov	x11, x20
Lloh30:
	adrp	x12, lCPI5_4@PAGE
Lloh31:
	ldr	q6, [x12, lCPI5_4@PAGEOFF]
	movi.4s	v21, #7
	movi.4s	v22, #23
	mvni.4s	v23, #10
	movi.16b	v24, #15
	movi.16b	v25, #248
	movi.16b	v26, #16
	movi.4s	v27, #16
LBB5_13:                                ;   Parent Loop BB5_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	and.16b	v7, v6, v24
	add.16b	v7, v7, v25
	str	q7, [x11], #16
	mul.4s	v7, v2, v21
	mul.4s	v16, v3, v21
	mul.4s	v17, v4, v21
	mul.4s	v18, v5, v21
	umull2.2d	v19, v18, v0
	umull.2d	v20, v18, v0
	uzp2.4s	v19, v20, v19
	ushr.4s	v19, v19, #4
	mls.4s	v18, v19, v22
	umull2.2d	v19, v17, v0
	umull.2d	v20, v17, v0
	uzp2.4s	v19, v20, v19
	ushr.4s	v19, v19, #4
	mls.4s	v17, v19, v22
	umull2.2d	v19, v16, v0
	umull.2d	v20, v16, v0
	uzp2.4s	v19, v20, v19
	ushr.4s	v19, v19, #4
	mls.4s	v16, v19, v22
	umull2.2d	v19, v7, v0
	umull.2d	v20, v7, v0
	uzp2.4s	v19, v20, v19
	ushr.4s	v19, v19, #4
	mls.4s	v7, v19, v22
	add.4s	v7, v7, v23
	add.4s	v16, v16, v23
	add.4s	v17, v17, v23
	add.4s	v18, v18, v23
	scvtf.4s	v18, v18
	scvtf.4s	v17, v17
	scvtf.4s	v16, v16
	scvtf.4s	v7, v7
	fmul.4s	v7, v7, v1
	fmul.4s	v16, v16, v1
	fmul.4s	v17, v17, v1
	fmul.4s	v18, v18, v1
	add	x12, x27, x9
	stp	q18, q17, [x12]
	stp	q16, q7, [x12, #32]
	add.16b	v6, v6, v26
	add.4s	v5, v5, v27
	add.4s	v4, v4, v27
	add.4s	v3, v3, v27
	add.4s	v2, v2, v27
	add	x9, x9, #64
	cmp	x10, x9
	b.ne	LBB5_13
; %bb.14:                               ;   in Loop: Header=BB5_2 Depth=1
	cmp	x8, x22
	b.eq	LBB5_21
; %bb.15:                               ;   in Loop: Header=BB5_2 Depth=1
	tst	x22, #0xc
	b.eq	LBB5_19
LBB5_16:                                ;   in Loop: Header=BB5_2 Depth=1
	mov	x9, x8
	and	x8, x22, #0x7ffffffc
	dup.4h	v2, w9
Lloh32:
	adrp	x10, lCPI5_5@PAGE
Lloh33:
	ldr	d3, [x10, lCPI5_5@PAGEOFF]
	orr.8b	v2, v2, v3
	dup.4s	v3, w9
Lloh34:
	adrp	x10, lCPI5_3@PAGE
Lloh35:
	ldr	q4, [x10, lCPI5_3@PAGEOFF]
	orr.16b	v3, v3, v4
	lsl	x10, x9, #2
	movi.4s	v7, #7
	movi.4s	v16, #23
	mvni.4s	v17, #10
	movi.4s	v18, #4
LBB5_17:                                ;   Parent Loop BB5_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	and.8b	v4, v2, v9
	add.4h	v4, v4, v10
	uzp1.8b	v4, v4, v0
	str	s4, [x20, x9]
	mul.4s	v4, v3, v7
	umull2.2d	v5, v4, v0
	umull.2d	v6, v4, v0
	uzp2.4s	v5, v6, v5
	ushr.4s	v5, v5, #4
	mls.4s	v4, v5, v16
	add.4s	v4, v4, v17
	scvtf.4s	v4, v4
	fmul.4s	v4, v4, v1
	str	q4, [x27, x10]
	add	x9, x9, #4
	add.4h	v2, v2, v11
	add.4s	v3, v3, v18
	add	x10, x10, #16
	cmp	x8, x9
	b.ne	LBB5_17
; %bb.18:                               ;   in Loop: Header=BB5_2 Depth=1
	cmp	x8, x22
	b.eq	LBB5_21
LBB5_19:                                ;   in Loop: Header=BB5_2 Depth=1
	lsl	w9, w8, #3
	sub	w9, w9, w8
	sub	w10, w9, #11
	mov	w13, #17097                     ; =0x42c9
	movk	w13, #45590, lsl #16
	mov	w14, #23                        ; =0x17
LBB5_20:                                ;   Parent Loop BB5_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	umull	x11, w9, w13
	lsr	x11, x11, #36
	msub	w11, w11, w14, w10
	and	w12, w8, #0xf
	sub	w12, w12, #8
	strb	w12, [x20, x8]
	scvtf	s0, w11, #4
	str	s0, [x27, x8, lsl #2]
	add	x8, x8, #1
	add	w10, w10, #7
	add	w9, w9, #7
	cmp	x22, x8
	b.ne	LBB5_20
LBB5_21:                                ;   in Loop: Header=BB5_2 Depth=1
Ltmp21:
	add	x8, sp, #152
	sub	x0, x29, #168
	bl	__Z4packRKNSt3__16vectorIaNS_9allocatorIaEEEE
Ltmp22:
; %bb.22:                               ;   in Loop: Header=BB5_2 Depth=1
	cbz	w22, LBB5_25
; %bb.23:                               ;   in Loop: Header=BB5_2 Depth=1
	ldr	x8, [sp, #152]
	cmp	w22, #3
	b.hi	LBB5_26
; %bb.24:                               ;   in Loop: Header=BB5_2 Depth=1
	mov	x9, #0                          ; =0x0
	movi.2d	v8, #0000000000000000
	b	LBB5_35
LBB5_25:                                ;   in Loop: Header=BB5_2 Depth=1
	movi.2d	v8, #0000000000000000
	b	LBB5_36
LBB5_26:                                ;   in Loop: Header=BB5_2 Depth=1
	cmp	w28, #32
	b.hs	LBB5_28
; %bb.27:                               ;   in Loop: Header=BB5_2 Depth=1
	mov	x9, #0                          ; =0x0
	movi.2d	v8, #0000000000000000
	b	LBB5_32
LBB5_28:                                ;   in Loop: Header=BB5_2 Depth=1
	mov	x10, #0                         ; =0x0
	and	x9, x22, #0x7fffffe0
	add	x11, x27, #64
	add	x12, x20, #16
	movi.2d	v8, #0000000000000000
	mov	x13, x9
	ldp	q27, q26, [sp, #32]             ; 32-byte Folded Reload
	ldp	q29, q28, [sp]                  ; 32-byte Folded Reload
LBB5_29:                                ;   Parent Loop BB5_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldp	q0, q1, [x12, #-16]
	tbl.16b	v2, { v0 }, v27
	tbl.16b	v3, { v0 }, v28
	tbl.16b	v4, { v0 }, v29
	tbl.16b	v0, { v0 }, v26
	scvtf.4s	v0, v0, #24
	scvtf.4s	v4, v4, #24
	scvtf.4s	v3, v3, #24
	scvtf.4s	v2, v2, #24
	tbl.16b	v5, { v1 }, v27
	tbl.16b	v6, { v1 }, v28
	tbl.16b	v7, { v1 }, v29
	tbl.16b	v1, { v1 }, v26
	scvtf.4s	v16, v1, #24
	scvtf.4s	v1, v7, #24
	scvtf.4s	v6, v6, #24
	scvtf.4s	v5, v5, #24
	and	x14, x10, #0x7ffffff
	umaddl	x14, w14, w23, x8
	ldr	s7, [x14, #16]
	fmul.4s	v2, v2, v7[0]
	fmul.4s	v3, v3, v7[0]
	fmul.4s	v17, v4, v7[0]
	fmul.4s	v18, v0, v7[0]
	fmul.4s	v20, v5, v7[0]
	fmul.4s	v6, v6, v7[0]
	fmul.4s	v1, v1, v7[0]
	fmul.4s	v0, v16, v7[0]
	fcvtl	v4.2d, v18.2s
	fcvtl2	v7.2d, v18.4s
	fcvtl	v18.2d, v17.2s
	fcvtl2	v21.2d, v17.4s
	fcvtl	v23.2d, v3.2s
	fcvtl2	v17.2d, v3.4s
	fcvtl	v24.2d, v2.2s
	fcvtl2	v2.2d, v2.4s
	fcvtl2	v3.2d, v1.4s
	fcvtl	v5.2d, v6.2s
	fcvtl2	v16.2d, v6.4s
	fcvtl	v19.2d, v20.2s
	fcvtl2	v22.2d, v20.4s
	ldp	q20, q6, [x11, #-32]
	fcvtl2	v25.2d, v6.4s
	fmul.2d	v2, v2, v25
	fcvtl2	v25.2d, v20.4s
	fcvtl	v6.2d, v6.2s
	fmul.2d	v6, v24, v6
	fmul.2d	v17, v17, v25
	ldp	q25, q24, [x11, #-64]
	fcvtl	v20.2d, v20.2s
	fmul.2d	v20, v23, v20
	fcvtl2	v23.2d, v24.4s
	fmul.2d	v21, v21, v23
	fcvtl2	v23.2d, v25.4s
	fcvtl	v24.2d, v24.2s
	fmul.2d	v18, v18, v24
	fmul.2d	v23, v7, v23
	ldp	q24, q7, [x11, #32]
	fcvtl	v25.2d, v25.2s
	fmul.2d	v25, v4, v25
	fcvtl2	v4.2d, v7.4s
	fmul.2d	v4, v22, v4
	fcvtl2	v22.2d, v24.4s
	fcvtl	v7.2d, v7.2s
	fmul.2d	v7, v19, v7
	fmul.2d	v16, v16, v22
	ldp	q22, q19, [x11], #128
	fcvtl	v24.2d, v24.2s
	fmul.2d	v5, v5, v24
	fcvtl2	v24.2d, v19.4s
	fmul.2d	v3, v3, v24
	fcvtl2	v24.2d, v0.4s
	fcvtl	v1.2d, v1.2s
	fcvtl	v19.2d, v19.2s
	fmul.2d	v1, v1, v19
	fcvtl2	v19.2d, v22.4s
	fmul.2d	v19, v24, v19
	fcvtl	v0.2d, v0.2s
	fcvtl	v22.2d, v22.2s
	fmul.2d	v0, v0, v22
	fadd	d22, d8, d25
	mov	d24, v25[1]
	fadd	d22, d22, d24
	fadd	d22, d22, d23
	mov	d23, v23[1]
	fadd	d22, d22, d23
	fadd	d22, d22, d18
	mov	d18, v18[1]
	fadd	d18, d22, d18
	fadd	d18, d18, d21
	mov	d21, v21[1]
	fadd	d18, d18, d21
	fadd	d18, d18, d20
	mov	d20, v20[1]
	fadd	d18, d18, d20
	fadd	d18, d18, d17
	mov	d17, v17[1]
	fadd	d17, d18, d17
	fadd	d17, d17, d6
	mov	d6, v6[1]
	fadd	d6, d17, d6
	fadd	d6, d6, d2
	mov	d2, v2[1]
	fadd	d2, d6, d2
	fadd	d2, d2, d0
	mov	d0, v0[1]
	fadd	d0, d2, d0
	fadd	d0, d0, d19
	mov	d2, v19[1]
	fadd	d0, d0, d2
	fadd	d0, d0, d1
	mov	d1, v1[1]
	fadd	d0, d0, d1
	fadd	d0, d0, d3
	mov	d1, v3[1]
	fadd	d0, d0, d1
	fadd	d0, d0, d5
	mov	d1, v5[1]
	fadd	d0, d0, d1
	fadd	d0, d0, d16
	mov	d1, v16[1]
	fadd	d0, d0, d1
	fadd	d0, d0, d7
	mov	d1, v7[1]
	fadd	d0, d0, d1
	fadd	d0, d0, d4
	mov	d1, v4[1]
	fadd	d8, d0, d1
	add	x10, x10, #1
	add	x12, x12, #32
	subs	x13, x13, #32
	b.ne	LBB5_29
; %bb.30:                               ;   in Loop: Header=BB5_2 Depth=1
	cmp	x9, x22
	b.eq	LBB5_36
; %bb.31:                               ;   in Loop: Header=BB5_2 Depth=1
	tst	x22, #0x1c
	b.eq	LBB5_35
LBB5_32:                                ;   in Loop: Header=BB5_2 Depth=1
	mov	x10, x9
	and	x9, x22, #0x7ffffffc
	add	x11, x27, x10, lsl #2
	ldr	q4, [sp, #48]                   ; 16-byte Folded Reload
LBB5_33:                                ;   Parent Loop BB5_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	s0, [x20, x10]
	tbl.16b	v0, { v0 }, v4
	scvtf.4s	v0, v0, #24
	lsr	w12, w10, #5
	umaddl	x12, w12, w23, x8
	ldr	s1, [x12, #16]
	fmul.4s	v0, v0, v1[0]
	fcvtl	v1.2d, v0.2s
	fcvtl2	v0.2d, v0.4s
	ldr	q2, [x11], #16
	fcvtl	v3.2d, v2.2s
	fcvtl2	v2.2d, v2.4s
	fmul.2d	v0, v0, v2
	mov	d2, v0[1]
	fmul.2d	v1, v1, v3
	mov	d3, v1[1]
	fadd	d1, d8, d1
	fadd	d1, d1, d3
	fadd	d0, d1, d0
	fadd	d8, d0, d2
	add	x10, x10, #4
	cmp	x9, x10
	b.ne	LBB5_33
; %bb.34:                               ;   in Loop: Header=BB5_2 Depth=1
	cmp	x9, x22
	b.eq	LBB5_36
LBB5_35:                                ;   Parent Loop BB5_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	b0, [x20, x9]
	sshll.8h	v0, v0, #0
	sshll.4s	v0, v0, #0
	scvtf	s0, s0
	lsr	w10, w9, #5
	umaddl	x10, w10, w23, x8
	ldr	s1, [x10, #16]
	fmul	s0, s1, s0
	fcvt	d0, s0
	ldr	s1, [x27, x9, lsl #2]
	fcvt	d1, s1
	fmadd	d8, d0, d1, d8
	add	x9, x9, #1
	cmp	x22, x9
	b.ne	LBB5_35
LBB5_36:                                ;   in Loop: Header=BB5_2 Depth=1
	subs	x14, x25, x19
	b.eq	LBB5_39
; %bb.37:                               ;   in Loop: Header=BB5_2 Depth=1
	mov	x8, #0                          ; =0x0
	asr	x9, x14, #2
	ldr	x10, [sp, #152]
LBB5_38:                                ;   Parent Loop BB5_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsr	x11, x8, #5
	madd	x11, x11, x23, x10
	and	x12, x8, #0xf
	ldrb	w12, [x11, x12]
	and	w13, w12, #0xf
	lsr	w12, w12, #4
	tst	x8, #0x10
	csel	w12, w13, w12, eq
	sub	w12, w12, #8
	scvtf	s0, w12
	ldr	s1, [x11, #16]
	fmul	s0, s1, s0
	str	s0, [x19, x8, lsl #2]
	add	x8, x8, #1
	cmp	x9, x8
	b.ne	LBB5_38
LBB5_39:                                ;   in Loop: Header=BB5_2 Depth=1
	str	x14, [sp, #96]                  ; 8-byte Folded Spill
	sub	x8, x26, x27
	asr	x21, x8, #2
	cmp	x21, #4
	b.hs	LBB5_41
; %bb.40:                               ;   in Loop: Header=BB5_2 Depth=1
	mov	x9, #0                          ; =0x0
	movi.2d	v0, #0000000000000000
	b	LBB5_43
LBB5_41:                                ;   in Loop: Header=BB5_2 Depth=1
	mov	x10, #0                         ; =0x0
	movi.2d	v0, #0000000000000000
	mov	x8, x27
	mov	x11, x19
LBB5_42:                                ;   Parent Loop BB5_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	q1, [x8], #16
	ldr	q2, [x11], #16
	fmla.4s	v0, v2, v1
	add	x9, x10, #4
	add	x12, x10, #8
	mov	x10, x9
	cmp	x12, x21
	b.ls	LBB5_42
LBB5_43:                                ;   in Loop: Header=BB5_2 Depth=1
	faddp.4s	v0, v0, v0
	faddp.2s	s0, v0
	subs	x8, x21, x9
	b.ls	LBB5_46
; %bb.44:                               ;   in Loop: Header=BB5_2 Depth=1
	lsl	x10, x9, #2
	add	x9, x19, x10
	add	x10, x27, x10
LBB5_45:                                ;   Parent Loop BB5_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	s1, [x10], #4
	ldr	s2, [x9], #4
	fmadd	s0, s1, s2, s0
	subs	x8, x8, #1
	b.ne	LBB5_45
LBB5_46:                                ;   in Loop: Header=BB5_2 Depth=1
	fabs	d1, d8
	mov	x8, #17197                      ; =0x432d
	movk	x8, #60188, lsl #16
	movk	x8, #14050, lsl #32
	movk	x8, #16154, lsl #48
	fmov	d2, x8
	mov	x8, #26865                      ; =0x68f1
	movk	x8, #35043, lsl #16
	movk	x8, #63669, lsl #32
	movk	x8, #16116, lsl #48
	fmov	d3, x8
	fmadd	d12, d1, d3, d2
	fcvt	d0, s0
	fabd	d0, d0, d8
	fcmp	d0, d12
	b.gt	LBB5_123
; %bb.47:                               ;   in Loop: Header=BB5_2 Depth=1
	add	x0, sp, #152
	add	x1, sp, #176
	bl	__Z5fusedRKNSt3__16vectorI5BlockNS_9allocatorIS1_EEEERKNS0_IfNS2_IfEEEE
	fcvt	d0, s0
	fabd	d0, d0, d8
	fcmp	d0, d12
	b.gt	LBB5_123
; %bb.48:                               ;   in Loop: Header=BB5_2 Depth=1
	cmp	w22, #33
	b.eq	LBB5_50
; %bb.49:                               ;   in Loop: Header=BB5_2 Depth=1
	mov	w8, #3                          ; =0x3
	movk	w8, #1, lsl #16
	cmp	w22, w8
	b.ne	LBB5_111
LBB5_50:                                ;   in Loop: Header=BB5_2 Depth=1
Ltmp24:
Lloh36:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh37:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh38:
	adrp	x1, l_.str.3@PAGE
Lloh39:
	add	x1, x1, l_.str.3@PAGEOFF
	mov	w2, #2                          ; =0x2
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp25:
; %bb.51:                               ;   in Loop: Header=BB5_2 Depth=1
Ltmp26:
	mov	x1, x28
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEi
Ltmp27:
; %bb.52:                               ;   in Loop: Header=BB5_2 Depth=1
Ltmp28:
Lloh40:
	adrp	x1, l_.str.4@PAGE
Lloh41:
	add	x1, x1, l_.str.4@PAGEOFF
	mov	w2, #26                         ; =0x1a
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp29:
; %bb.53:                               ;   in Loop: Header=BB5_2 Depth=1
	ldp	x26, x8, [sp, #152]
	sub	x20, x8, x26
Ltmp30:
	mov	x1, x20
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp31:
; %bb.54:                               ;   in Loop: Header=BB5_2 Depth=1
Ltmp32:
Lloh42:
	adrp	x1, l_.str.5@PAGE
Lloh43:
	add	x1, x1, l_.str.5@PAGEOFF
	mov	w2, #14                         ; =0xe
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp33:
; %bb.55:                               ;   in Loop: Header=BB5_2 Depth=1
Ltmp34:
	mov	x1, x20
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp35:
; %bb.56:                               ;   in Loop: Header=BB5_2 Depth=1
Ltmp36:
Lloh44:
	adrp	x1, l_.str.6@PAGE
Lloh45:
	add	x1, x1, l_.str.6@PAGEOFF
	mov	w2, #19                         ; =0x13
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp37:
; %bb.57:                               ;   in Loop: Header=BB5_2 Depth=1
	lsl	w1, w22, #2
Ltmp38:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEi
Ltmp39:
; %bb.58:                               ;   in Loop: Header=BB5_2 Depth=1
Ltmp40:
Lloh46:
	adrp	x1, l_.str.7@PAGE
Lloh47:
	add	x1, x1, l_.str.7@PAGEOFF
	mov	w2, #33                         ; =0x21
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp41:
; %bb.59:                               ;   in Loop: Header=BB5_2 Depth=1
	str	x0, [sp, #72]                   ; 8-byte Folded Spill
	mov	w8, #0                          ; =0x0
	ldr	x9, [sp, #96]                   ; 8-byte Folded Reload
	asr	x20, x9, #2
	b	LBB5_61
LBB5_60:                                ;   in Loop: Header=BB5_61 Depth=2
	str	s0, [x24, _sink@PAGEOFF]
	add	w8, w8, #1
	cmp	w8, #10
	b.eq	LBB5_71
LBB5_61:                                ;   Parent Loop BB5_2 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB5_63 Depth 3
                                        ;       Child Loop BB5_67 Depth 3
                                        ;       Child Loop BB5_70 Depth 3
	; InlineAsm Start
	; InlineAsm End
	cmp	x25, x19
	b.eq	LBB5_64
; %bb.62:                               ;   in Loop: Header=BB5_61 Depth=2
	mov	x9, #0                          ; =0x0
LBB5_63:                                ;   Parent Loop BB5_2 Depth=1
                                        ;     Parent Loop BB5_61 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	lsr	x10, x9, #5
	madd	x10, x10, x23, x26
	and	x11, x9, #0xf
	ldrb	w11, [x10, x11]
	and	w12, w11, #0xf
	lsr	w11, w11, #4
	tst	x9, #0x10
	csel	w11, w12, w11, eq
	sub	w11, w11, #8
	scvtf	s0, w11
	ldr	s1, [x10, #16]
	fmul	s0, s1, s0
	str	s0, [x19, x9, lsl #2]
	add	x9, x9, #1
	cmp	x20, x9
	b.ne	LBB5_63
LBB5_64:                                ;   in Loop: Header=BB5_61 Depth=2
	cmp	x21, #4
	b.hs	LBB5_66
; %bb.65:                               ;   in Loop: Header=BB5_61 Depth=2
	mov	x10, #0                         ; =0x0
	movi.2d	v0, #0000000000000000
	b	LBB5_68
LBB5_66:                                ;   in Loop: Header=BB5_61 Depth=2
	mov	x11, #0                         ; =0x0
	movi.2d	v0, #0000000000000000
	mov	x9, x27
	mov	x12, x19
LBB5_67:                                ;   Parent Loop BB5_2 Depth=1
                                        ;     Parent Loop BB5_61 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	ldr	q1, [x9], #16
	ldr	q2, [x12], #16
	fmla.4s	v0, v2, v1
	add	x10, x11, #4
	add	x13, x11, #8
	mov	x11, x10
	cmp	x13, x21
	b.ls	LBB5_67
LBB5_68:                                ;   in Loop: Header=BB5_61 Depth=2
	faddp.4s	v0, v0, v0
	faddp.2s	s0, v0
	subs	x9, x21, x10
	b.ls	LBB5_60
; %bb.69:                               ;   in Loop: Header=BB5_61 Depth=2
	lsl	x11, x10, #2
	add	x10, x19, x11
	add	x11, x27, x11
LBB5_70:                                ;   Parent Loop BB5_2 Depth=1
                                        ;     Parent Loop BB5_61 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	ldr	s1, [x11], #4
	ldr	s2, [x10], #4
	fmadd	s0, s1, s2, s0
	subs	x9, x9, #1
	b.ne	LBB5_70
	b	LBB5_60
LBB5_71:                                ;   in Loop: Header=BB5_2 Depth=1
	mov	w26, #0                         ; =0x0
	mov	x22, #0                         ; =0x0
	mov	x27, #0                         ; =0x0
	mov	x28, #0                         ; =0x0
	b	LBB5_74
LBB5_72:                                ;   in Loop: Header=BB5_74 Depth=2
	str	d8, [x27], #8
LBB5_73:                                ;   in Loop: Header=BB5_74 Depth=2
	add	w26, w26, #1
	cmp	w26, #31
	b.eq	LBB5_93
LBB5_74:                                ;   Parent Loop BB5_2 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB5_76 Depth 3
                                        ;         Child Loop BB5_78 Depth 4
                                        ;         Child Loop BB5_82 Depth 4
                                        ;         Child Loop BB5_85 Depth 4
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x21, x0
	mov	w8, #0                          ; =0x0
	ldr	x9, [sp, #152]
	ldp	x10, x11, [sp, #176]
	sub	x11, x11, x10
	asr	x11, x11, #2
	b	LBB5_76
LBB5_75:                                ;   in Loop: Header=BB5_76 Depth=3
	str	s0, [x24, _sink@PAGEOFF]
	add	w8, w8, #1
	cmp	w8, #100
	b.eq	LBB5_86
LBB5_76:                                ;   Parent Loop BB5_2 Depth=1
                                        ;     Parent Loop BB5_74 Depth=2
                                        ; =>    This Loop Header: Depth=3
                                        ;         Child Loop BB5_78 Depth 4
                                        ;         Child Loop BB5_82 Depth 4
                                        ;         Child Loop BB5_85 Depth 4
	; InlineAsm Start
	; InlineAsm End
	cmp	x25, x19
	b.eq	LBB5_79
; %bb.77:                               ;   in Loop: Header=BB5_76 Depth=3
	mov	x12, #0                         ; =0x0
LBB5_78:                                ;   Parent Loop BB5_2 Depth=1
                                        ;     Parent Loop BB5_74 Depth=2
                                        ;       Parent Loop BB5_76 Depth=3
                                        ; =>      This Inner Loop Header: Depth=4
	lsr	x13, x12, #5
	madd	x13, x13, x23, x9
	and	x14, x12, #0xf
	ldrb	w14, [x13, x14]
	and	w15, w14, #0xf
	lsr	w14, w14, #4
	tst	x12, #0x10
	csel	w14, w15, w14, eq
	sub	w14, w14, #8
	scvtf	s0, w14
	ldr	s1, [x13, #16]
	fmul	s0, s1, s0
	str	s0, [x19, x12, lsl #2]
	add	x12, x12, #1
	cmp	x20, x12
	b.ne	LBB5_78
LBB5_79:                                ;   in Loop: Header=BB5_76 Depth=3
	cmp	x11, #4
	b.hs	LBB5_81
; %bb.80:                               ;   in Loop: Header=BB5_76 Depth=3
	mov	x13, #0                         ; =0x0
	movi.2d	v0, #0000000000000000
	b	LBB5_83
LBB5_81:                                ;   in Loop: Header=BB5_76 Depth=3
	mov	x14, #0                         ; =0x0
	movi.2d	v0, #0000000000000000
	mov	x12, x10
	mov	x15, x19
LBB5_82:                                ;   Parent Loop BB5_2 Depth=1
                                        ;     Parent Loop BB5_74 Depth=2
                                        ;       Parent Loop BB5_76 Depth=3
                                        ; =>      This Inner Loop Header: Depth=4
	ldr	q1, [x12], #16
	ldr	q2, [x15], #16
	fmla.4s	v0, v2, v1
	add	x13, x14, #4
	add	x16, x14, #8
	mov	x14, x13
	cmp	x16, x11
	b.ls	LBB5_82
LBB5_83:                                ;   in Loop: Header=BB5_76 Depth=3
	faddp.4s	v0, v0, v0
	faddp.2s	s0, v0
	subs	x12, x11, x13
	b.ls	LBB5_75
; %bb.84:                               ;   in Loop: Header=BB5_76 Depth=3
	lsl	x14, x13, #2
	add	x13, x19, x14
	add	x14, x10, x14
LBB5_85:                                ;   Parent Loop BB5_2 Depth=1
                                        ;     Parent Loop BB5_74 Depth=2
                                        ;       Parent Loop BB5_76 Depth=3
                                        ; =>      This Inner Loop Header: Depth=4
	ldr	s1, [x14], #4
	ldr	s2, [x13], #4
	fmadd	s0, s1, s2, s0
	subs	x12, x12, #1
	b.ne	LBB5_85
	b	LBB5_75
LBB5_86:                                ;   in Loop: Header=BB5_74 Depth=2
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	sub	x8, x0, x21
	scvtf	d0, x8
	mov	x8, #70368744177664             ; =0x400000000000
	movk	x8, #16527, lsl #48
	fmov	d1, x8
	fdiv	d0, d0, d1
	mov	x8, #4636737291354636288        ; =0x4059000000000000
	fmov	d1, x8
	fdiv	d8, d0, d1
	cmp	x27, x28
	b.lo	LBB5_72
; %bb.87:                               ;   in Loop: Header=BB5_74 Depth=2
	sub	x21, x27, x22
	asr	x27, x21, #3
	add	x8, x27, #1
	lsr	x9, x8, #61
	cbnz	x9, LBB5_119
; %bb.88:                               ;   in Loop: Header=BB5_74 Depth=2
	mov	x9, x28
	mov	x28, x24
	mov	x24, x22
	sub	x9, x9, x22
	asr	x10, x9, #2
	cmp	x10, x8
	csel	x8, x10, x8, hi
	mov	x10, #9223372036854775800       ; =0x7ffffffffffffff8
	cmp	x9, x10
	mov	x9, #2305843009213693951        ; =0x1fffffffffffffff
	csel	x22, x8, x9, lo
	lsr	x8, x22, #61
	cbnz	x8, LBB5_120
; %bb.89:                               ;   in Loop: Header=BB5_74 Depth=2
	lsl	x0, x22, #3
Ltmp42:
	bl	__Znwm
Ltmp43:
; %bb.90:                               ;   in Loop: Header=BB5_74 Depth=2
	add	x8, x0, x21
	add	x9, x0, x22, lsl #3
	sub	x27, x8, x27, lsl #3
	str	d8, [x8], #8
	stp	x9, x8, [sp, #88]               ; 16-byte Folded Spill
	mov	x0, x27
	mov	x1, x24
	mov	x2, x21
	bl	_memcpy
	cbz	x24, LBB5_92
; %bb.91:                               ;   in Loop: Header=BB5_74 Depth=2
	mov	x0, x24
	bl	__ZdlPv
LBB5_92:                                ;   in Loop: Header=BB5_74 Depth=2
	mov	x22, x27
	mov	x24, x28
	ldp	x28, x27, [sp, #88]             ; 16-byte Folded Reload
	b	LBB5_73
LBB5_93:                                ;   in Loop: Header=BB5_2 Depth=1
Ltmp50:
	sub	x2, x29, #137
	mov	x0, x22
	mov	x1, x27
	bl	__ZNSt3__16__sortIRNS_6__lessIddEEPdEEvT0_S5_T_
Ltmp51:
; %bb.94:                               ;   in Loop: Header=BB5_2 Depth=1
	ldr	d8, [x22, #120]
	mov	x0, x22
	bl	__ZdlPv
Ltmp53:
	ldr	x0, [sp, #72]                   ; 8-byte Folded Reload
	mov.16b	v0, v8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp54:
; %bb.95:                               ;   in Loop: Header=BB5_2 Depth=1
Ltmp55:
Lloh48:
	adrp	x1, l_.str.8@PAGE
Lloh49:
	add	x1, x1, l_.str.8@PAGEOFF
	mov	w2, #7                          ; =0x7
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp56:
; %bb.96:                               ;   in Loop: Header=BB5_2 Depth=1
	mov	x20, x0
	; InlineAsm Start
	; InlineAsm End
	add	x0, sp, #152
	add	x1, sp, #176
	bl	__Z5fusedRKNSt3__16vectorI5BlockNS_9allocatorIS1_EEEERKNS0_IfNS2_IfEEEE
	str	s0, [x24, _sink@PAGEOFF]
	; InlineAsm Start
	; InlineAsm End
	add	x0, sp, #152
	add	x1, sp, #176
	bl	__Z5fusedRKNSt3__16vectorI5BlockNS_9allocatorIS1_EEEERKNS0_IfNS2_IfEEEE
	str	s0, [x24, _sink@PAGEOFF]
	; InlineAsm Start
	; InlineAsm End
	add	x0, sp, #152
	add	x1, sp, #176
	bl	__Z5fusedRKNSt3__16vectorI5BlockNS_9allocatorIS1_EEEERKNS0_IfNS2_IfEEEE
	str	s0, [x24, _sink@PAGEOFF]
	; InlineAsm Start
	; InlineAsm End
	add	x0, sp, #152
	add	x1, sp, #176
	bl	__Z5fusedRKNSt3__16vectorI5BlockNS_9allocatorIS1_EEEERKNS0_IfNS2_IfEEEE
	str	s0, [x24, _sink@PAGEOFF]
	; InlineAsm Start
	; InlineAsm End
	add	x0, sp, #152
	add	x1, sp, #176
	bl	__Z5fusedRKNSt3__16vectorI5BlockNS_9allocatorIS1_EEEERKNS0_IfNS2_IfEEEE
	str	s0, [x24, _sink@PAGEOFF]
	; InlineAsm Start
	; InlineAsm End
	add	x0, sp, #152
	add	x1, sp, #176
	bl	__Z5fusedRKNSt3__16vectorI5BlockNS_9allocatorIS1_EEEERKNS0_IfNS2_IfEEEE
	str	s0, [x24, _sink@PAGEOFF]
	; InlineAsm Start
	; InlineAsm End
	add	x0, sp, #152
	add	x1, sp, #176
	bl	__Z5fusedRKNSt3__16vectorI5BlockNS_9allocatorIS1_EEEERKNS0_IfNS2_IfEEEE
	str	s0, [x24, _sink@PAGEOFF]
	; InlineAsm Start
	; InlineAsm End
	add	x0, sp, #152
	add	x1, sp, #176
	bl	__Z5fusedRKNSt3__16vectorI5BlockNS_9allocatorIS1_EEEERKNS0_IfNS2_IfEEEE
	str	s0, [x24, _sink@PAGEOFF]
	; InlineAsm Start
	; InlineAsm End
	add	x0, sp, #152
	add	x1, sp, #176
	bl	__Z5fusedRKNSt3__16vectorI5BlockNS_9allocatorIS1_EEEERKNS0_IfNS2_IfEEEE
	str	s0, [x24, _sink@PAGEOFF]
	; InlineAsm Start
	; InlineAsm End
	add	x0, sp, #152
	add	x1, sp, #176
	bl	__Z5fusedRKNSt3__16vectorI5BlockNS_9allocatorIS1_EEEERKNS0_IfNS2_IfEEEE
	mov	w25, #0                         ; =0x0
	mov	x27, #0                         ; =0x0
	mov	x21, #0                         ; =0x0
	mov	x26, #0                         ; =0x0
	str	s0, [x24, _sink@PAGEOFF]
	b	LBB5_99
LBB5_97:                                ;   in Loop: Header=BB5_99 Depth=2
	str	d8, [x21], #8
LBB5_98:                                ;   in Loop: Header=BB5_99 Depth=2
	add	w25, w25, #1
	cmp	w25, #31
	b.eq	LBB5_108
LBB5_99:                                ;   Parent Loop BB5_2 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB5_100 Depth 3
	mov	w22, #100                       ; =0x64
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x28, x0
LBB5_100:                               ;   Parent Loop BB5_2 Depth=1
                                        ;     Parent Loop BB5_99 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	; InlineAsm Start
	; InlineAsm End
	add	x0, sp, #152
	add	x1, sp, #176
	bl	__Z5fusedRKNSt3__16vectorI5BlockNS_9allocatorIS1_EEEERKNS0_IfNS2_IfEEEE
	str	s0, [x24, _sink@PAGEOFF]
	subs	w22, w22, #1
	b.ne	LBB5_100
; %bb.101:                              ;   in Loop: Header=BB5_99 Depth=2
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	sub	x8, x0, x28
	scvtf	d0, x8
	mov	x8, #70368744177664             ; =0x400000000000
	movk	x8, #16527, lsl #48
	fmov	d1, x8
	fdiv	d0, d0, d1
	mov	x8, #4636737291354636288        ; =0x4059000000000000
	fmov	d1, x8
	fdiv	d8, d0, d1
	cmp	x21, x26
	b.lo	LBB5_97
; %bb.102:                              ;   in Loop: Header=BB5_99 Depth=2
	sub	x28, x21, x27
	asr	x22, x28, #3
	add	x8, x22, #1
	lsr	x9, x8, #61
	cbnz	x9, LBB5_121
; %bb.103:                              ;   in Loop: Header=BB5_99 Depth=2
	sub	x9, x26, x27
	asr	x10, x9, #2
	cmp	x10, x8
	csel	x8, x10, x8, hi
	mov	x10, #9223372036854775800       ; =0x7ffffffffffffff8
	cmp	x9, x10
	mov	x9, #2305843009213693951        ; =0x1fffffffffffffff
	csel	x26, x8, x9, lo
	lsr	x8, x26, #61
	cbnz	x8, LBB5_122
; %bb.104:                              ;   in Loop: Header=BB5_99 Depth=2
	lsl	x0, x26, #3
Ltmp57:
	bl	__Znwm
Ltmp58:
; %bb.105:                              ;   in Loop: Header=BB5_99 Depth=2
	add	x21, x0, x28
	add	x26, x0, x26, lsl #3
	sub	x22, x21, x22, lsl #3
	str	d8, [x21], #8
	mov	x0, x22
	mov	x1, x27
	mov	x2, x28
	bl	_memcpy
	cbz	x27, LBB5_107
; %bb.106:                              ;   in Loop: Header=BB5_99 Depth=2
	mov	x0, x27
	bl	__ZdlPv
LBB5_107:                               ;   in Loop: Header=BB5_99 Depth=2
	mov	x27, x22
	b	LBB5_98
LBB5_108:                               ;   in Loop: Header=BB5_2 Depth=1
Ltmp65:
	sub	x2, x29, #137
	mov	x0, x27
	mov	x1, x21
	bl	__ZNSt3__16__sortIRNS_6__lessIddEEPdEEvT0_S5_T_
Ltmp66:
; %bb.109:                              ;   in Loop: Header=BB5_2 Depth=1
	ldr	d8, [x27, #120]
	mov	x0, x27
	bl	__ZdlPv
Ltmp68:
	mov	x0, x20
	mov.16b	v0, v8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp69:
; %bb.110:                              ;   in Loop: Header=BB5_2 Depth=1
	mov	w8, #10                         ; =0xa
	sturb	w8, [x29, #-137]
Ltmp70:
	sub	x1, x29, #137
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp71:
LBB5_111:                               ;   in Loop: Header=BB5_2 Depth=1
	ldr	x0, [sp, #152]
	cbz	x0, LBB5_113
; %bb.112:                              ;   in Loop: Header=BB5_2 Depth=1
	bl	__ZdlPv
LBB5_113:                               ;   in Loop: Header=BB5_2 Depth=1
	cbz	x19, LBB5_115
; %bb.114:                              ;   in Loop: Header=BB5_2 Depth=1
	mov	x0, x19
	bl	__ZdlPv
LBB5_115:                               ;   in Loop: Header=BB5_2 Depth=1
	ldr	x0, [sp, #176]
	cbz	x0, LBB5_117
; %bb.116:                              ;   in Loop: Header=BB5_2 Depth=1
	bl	__ZdlPv
LBB5_117:                               ;   in Loop: Header=BB5_2 Depth=1
	ldur	x0, [x29, #-168]
	ldr	x19, [sp, #80]                  ; 8-byte Folded Reload
	cbz	x0, LBB5_1
; %bb.118:                              ;   in Loop: Header=BB5_2 Depth=1
	bl	__ZdlPv
	b	LBB5_1
LBB5_119:
Ltmp47:
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_length_errorB9nqe210106Ev
Ltmp48:
	b	LBB5_138
LBB5_120:
Ltmp45:
	mov	x22, x24
	bl	__ZSt28__throw_bad_array_new_lengthB9nqe210106v
Ltmp46:
	b	LBB5_138
LBB5_121:
Ltmp62:
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_length_errorB9nqe210106Ev
Ltmp63:
	b	LBB5_138
LBB5_122:
Ltmp60:
	bl	__ZSt28__throw_bad_array_new_lengthB9nqe210106v
Ltmp61:
	b	LBB5_138
LBB5_123:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x22, x0
Ltmp104:
Lloh50:
	adrp	x1, l_.str.2@PAGE
Lloh51:
	add	x1, x1, l_.str.2@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp105:
; %bb.124:
Ltmp107:
Lloh52:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh53:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh54:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh55:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x22
	bl	___cxa_throw
Ltmp108:
	b	LBB5_138
LBB5_125:
	stp	xzr, xzr, [x29, #-168]
	stur	xzr, [x29, #-152]
Ltmp73:
	add	x8, sp, #128
	sub	x0, x29, #168
	bl	__Z4packRKNSt3__16vectorIaNS_9allocatorIaEEEE
Ltmp74:
; %bb.126:
	ldr	x0, [sp, #128]
	cbz	x0, LBB5_128
; %bb.127:
	bl	__ZdlPv
LBB5_128:
	mov	w19, #0                         ; =0x0
LBB5_129:
	mov	w8, #8                          ; =0x8
	strb	w8, [sp, #176]
Ltmp79:
	sub	x0, x29, #168
	add	x1, sp, #176
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__16vectorIaNS_9allocatorIaEEEC1B9nqe210106ESt16initializer_listIaE
Ltmp80:
; %bb.130:
Ltmp82:
	add	x8, sp, #104
	bl	__Z4packRKNSt3__16vectorIaNS_9allocatorIaEEEE
Ltmp83:
; %bb.131:
	ldr	x0, [sp, #104]
	cbz	x0, LBB5_133
; %bb.132:
	bl	__ZdlPv
LBB5_133:
	ldur	x0, [x29, #-168]
	cbz	x0, LBB5_135
; %bb.134:
	stur	x0, [x29, #-160]
	bl	__ZdlPv
LBB5_135:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp98:
Lloh56:
	adrp	x1, l_.str.9@PAGE
Lloh57:
	add	x1, x1, l_.str.9@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp99:
; %bb.136:
Ltmp101:
Lloh58:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh59:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh60:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh61:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
Ltmp102:
	b	LBB5_138
LBB5_137:
Ltmp18:
	bl	__ZNSt3__16vectorIaNS_9allocatorIaEEE20__throw_length_errorB9nqe210106Ev
Ltmp19:
LBB5_138:
	brk	#0x1
LBB5_139:
Ltmp100:
	mov	x21, x1
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	b	LBB5_187
LBB5_140:
Ltmp84:
	mov	x21, x1
	mov	x20, x0
	ldur	x0, [x29, #-168]
	cbz	x0, LBB5_143
; %bb.141:
	stur	x0, [x29, #-160]
	bl	__ZdlPv
	b	LBB5_143
LBB5_142:
Ltmp81:
	mov	x21, x1
	mov	x20, x0
LBB5_143:
	cmp	w21, #2
	b.ne	LBB5_187
; %bb.144:
	mov	x0, x20
	bl	___cxa_begin_catch
Ltmp85:
	bl	___cxa_end_catch
Ltmp86:
; %bb.145:
	tbz	w19, #0, LBB5_135
; %bb.146:
Ltmp88:
Lloh62:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh63:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh64:
	adrp	x1, l_.str.10@PAGE
Lloh65:
	add	x1, x1, l_.str.10@PAGEOFF
	mov	w2, #13                         ; =0xd
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp89:
; %bb.147:
Ltmp90:
	mov	w1, #12                         ; =0xc
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEi
Ltmp91:
; %bb.148:
Ltmp92:
Lloh66:
	adrp	x1, l_.str.11@PAGE
Lloh67:
	add	x1, x1, l_.str.11@PAGEOFF
	mov	w2, #10                         ; =0xa
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp93:
; %bb.149:
Ltmp94:
	mov	w1, #2                          ; =0x2
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEi
Ltmp95:
; %bb.150:
Ltmp96:
Lloh68:
	adrp	x1, l_.str.12@PAGE
Lloh69:
	add	x1, x1, l_.str.12@PAGEOFF
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp97:
; %bb.151:
	mov	w0, #0                          ; =0x0
	b	LBB5_191
LBB5_152:
Ltmp87:
	b	LBB5_162
LBB5_153:
Ltmp103:
	b	LBB5_162
LBB5_154:
Ltmp75:
	mov	x21, x1
	mov	x20, x0
	cmp	w21, #2
	b.ne	LBB5_187
; %bb.155:
	mov	x0, x20
	bl	___cxa_begin_catch
Ltmp76:
	bl	___cxa_end_catch
Ltmp77:
; %bb.156:
	mov	w19, #1                         ; =0x1
	b	LBB5_129
LBB5_157:
Ltmp78:
	b	LBB5_162
LBB5_158:
Ltmp17:
	mov	x21, x1
	mov	x20, x0
	b	LBB5_183
LBB5_159:
Ltmp14:
	mov	x21, x1
	mov	x20, x0
	b	LBB5_185
LBB5_160:
Ltmp20:
	b	LBB5_162
LBB5_161:
Ltmp11:
LBB5_162:
	mov	x21, x1
	mov	x20, x0
	b	LBB5_187
LBB5_163:
Ltmp67:
	b	LBB5_173
LBB5_164:
Ltmp52:
	b	LBB5_176
LBB5_165:
Ltmp109:
	b	LBB5_169
LBB5_166:
Ltmp106:
	mov	x21, x1
	mov	x20, x0
	mov	x0, x22
	bl	___cxa_free_exception
	b	LBB5_179
LBB5_167:
Ltmp23:
	mov	x21, x1
	mov	x20, x0
	b	LBB5_181
LBB5_168:
Ltmp72:
LBB5_169:
	mov	x21, x1
	mov	x20, x0
	b	LBB5_179
LBB5_170:
Ltmp59:
	b	LBB5_173
LBB5_171:
Ltmp44:
	mov	x21, x1
	mov	x20, x0
	mov	x22, x24
	cbnz	x22, LBB5_177
	b	LBB5_179
LBB5_172:
Ltmp64:
LBB5_173:
	mov	x21, x1
	mov	x20, x0
	cbz	x27, LBB5_179
; %bb.174:
	mov	x0, x27
	b	LBB5_178
LBB5_175:
Ltmp49:
LBB5_176:
	mov	x21, x1
	mov	x20, x0
	cbz	x22, LBB5_179
LBB5_177:
	mov	x0, x22
LBB5_178:
	bl	__ZdlPv
LBB5_179:
	ldr	x0, [sp, #152]
	cbz	x0, LBB5_181
; %bb.180:
	bl	__ZdlPv
LBB5_181:
	cbz	x19, LBB5_183
; %bb.182:
	mov	x0, x19
	bl	__ZdlPv
LBB5_183:
	ldr	x0, [sp, #176]
	cbz	x0, LBB5_185
; %bb.184:
	bl	__ZdlPv
LBB5_185:
	ldur	x0, [x29, #-168]
	cbz	x0, LBB5_187
; %bb.186:
	bl	__ZdlPv
LBB5_187:
	cmp	w21, #1
	b.ne	LBB5_193
; %bb.188:
	mov	x0, x20
	bl	___cxa_begin_catch
	ldr	x8, [x0]
	ldr	x8, [x8, #16]
	blr	x8
	mov	x19, x0
	bl	_strlen
	mov	x2, x0
Ltmp110:
Lloh70:
	adrp	x0, __ZNSt3__14cerrE@GOTPAGE
Lloh71:
	ldr	x0, [x0, __ZNSt3__14cerrE@GOTPAGEOFF]
	mov	x1, x19
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp111:
; %bb.189:
	mov	w8, #10                         ; =0xa
	sturb	w8, [x29, #-168]
Ltmp112:
	sub	x1, x29, #168
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp113:
; %bb.190:
	bl	___cxa_end_catch
	mov	w0, #1                          ; =0x1
LBB5_191:
	ldp	x29, x30, [sp, #368]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #352]            ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #336]            ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #320]            ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #304]            ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #288]            ; 16-byte Folded Reload
	ldp	d9, d8, [sp, #272]              ; 16-byte Folded Reload
	ldp	d11, d10, [sp, #256]            ; 16-byte Folded Reload
	ldp	d13, d12, [sp, #240]            ; 16-byte Folded Reload
	add	sp, sp, #384
	ret
LBB5_192:
Ltmp114:
	mov	x20, x0
Ltmp115:
	bl	___cxa_end_catch
Ltmp116:
LBB5_193:
	mov	x0, x20
	bl	__Unwind_Resume
LBB5_194:
Ltmp117:
	bl	___clang_call_terminate
	.loh AdrpLdr	Lloh18, Lloh19
	.loh AdrpAdrp	Lloh16, Lloh18
	.loh AdrpLdr	Lloh16, Lloh17
	.loh AdrpAdrp	Lloh14, Lloh16
	.loh AdrpLdr	Lloh14, Lloh15
	.loh AdrpAdrp	Lloh12, Lloh14
	.loh AdrpLdr	Lloh12, Lloh13
	.loh AdrpAdd	Lloh20, Lloh21
	.loh AdrpLdr	Lloh30, Lloh31
	.loh AdrpLdr	Lloh28, Lloh29
	.loh AdrpAdrp	Lloh26, Lloh28
	.loh AdrpLdr	Lloh26, Lloh27
	.loh AdrpAdrp	Lloh24, Lloh26
	.loh AdrpLdr	Lloh24, Lloh25
	.loh AdrpAdrp	Lloh22, Lloh24
	.loh AdrpLdr	Lloh22, Lloh23
	.loh AdrpLdr	Lloh34, Lloh35
	.loh AdrpAdrp	Lloh32, Lloh34
	.loh AdrpLdr	Lloh32, Lloh33
	.loh AdrpAdd	Lloh38, Lloh39
	.loh AdrpLdrGot	Lloh36, Lloh37
	.loh AdrpAdd	Lloh40, Lloh41
	.loh AdrpAdd	Lloh42, Lloh43
	.loh AdrpAdd	Lloh44, Lloh45
	.loh AdrpAdd	Lloh46, Lloh47
	.loh AdrpAdd	Lloh48, Lloh49
	.loh AdrpAdd	Lloh50, Lloh51
	.loh AdrpLdrGot	Lloh54, Lloh55
	.loh AdrpLdrGot	Lloh52, Lloh53
	.loh AdrpAdd	Lloh56, Lloh57
	.loh AdrpLdrGot	Lloh60, Lloh61
	.loh AdrpLdrGot	Lloh58, Lloh59
	.loh AdrpAdd	Lloh64, Lloh65
	.loh AdrpLdrGot	Lloh62, Lloh63
	.loh AdrpAdd	Lloh66, Lloh67
	.loh AdrpAdd	Lloh68, Lloh69
	.loh AdrpLdrGot	Lloh70, Lloh71
Lfunc_end1:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table5:
Lexception1:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase0-Lttbaseref0
Lttbaseref0:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end1-Lcst_begin1
Lcst_begin1:
	.uleb128 Ltmp9-Lfunc_begin1             ; >> Call Site 1 <<
	.uleb128 Ltmp10-Ltmp9                   ;   Call between Ltmp9 and Ltmp10
	.uleb128 Ltmp11-Lfunc_begin1            ;     jumps to Ltmp11
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp10-Lfunc_begin1            ; >> Call Site 2 <<
	.uleb128 Ltmp12-Ltmp10                  ;   Call between Ltmp10 and Ltmp12
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp12-Lfunc_begin1            ; >> Call Site 3 <<
	.uleb128 Ltmp13-Ltmp12                  ;   Call between Ltmp12 and Ltmp13
	.uleb128 Ltmp14-Lfunc_begin1            ;     jumps to Ltmp14
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp13-Lfunc_begin1            ; >> Call Site 4 <<
	.uleb128 Ltmp15-Ltmp13                  ;   Call between Ltmp13 and Ltmp15
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp15-Lfunc_begin1            ; >> Call Site 5 <<
	.uleb128 Ltmp16-Ltmp15                  ;   Call between Ltmp15 and Ltmp16
	.uleb128 Ltmp17-Lfunc_begin1            ;     jumps to Ltmp17
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp16-Lfunc_begin1            ; >> Call Site 6 <<
	.uleb128 Ltmp21-Ltmp16                  ;   Call between Ltmp16 and Ltmp21
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp21-Lfunc_begin1            ; >> Call Site 7 <<
	.uleb128 Ltmp22-Ltmp21                  ;   Call between Ltmp21 and Ltmp22
	.uleb128 Ltmp23-Lfunc_begin1            ;     jumps to Ltmp23
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp24-Lfunc_begin1            ; >> Call Site 8 <<
	.uleb128 Ltmp41-Ltmp24                  ;   Call between Ltmp24 and Ltmp41
	.uleb128 Ltmp72-Lfunc_begin1            ;     jumps to Ltmp72
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp42-Lfunc_begin1            ; >> Call Site 9 <<
	.uleb128 Ltmp43-Ltmp42                  ;   Call between Ltmp42 and Ltmp43
	.uleb128 Ltmp44-Lfunc_begin1            ;     jumps to Ltmp44
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp43-Lfunc_begin1            ; >> Call Site 10 <<
	.uleb128 Ltmp50-Ltmp43                  ;   Call between Ltmp43 and Ltmp50
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp50-Lfunc_begin1            ; >> Call Site 11 <<
	.uleb128 Ltmp51-Ltmp50                  ;   Call between Ltmp50 and Ltmp51
	.uleb128 Ltmp52-Lfunc_begin1            ;     jumps to Ltmp52
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp53-Lfunc_begin1            ; >> Call Site 12 <<
	.uleb128 Ltmp56-Ltmp53                  ;   Call between Ltmp53 and Ltmp56
	.uleb128 Ltmp72-Lfunc_begin1            ;     jumps to Ltmp72
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp57-Lfunc_begin1            ; >> Call Site 13 <<
	.uleb128 Ltmp58-Ltmp57                  ;   Call between Ltmp57 and Ltmp58
	.uleb128 Ltmp59-Lfunc_begin1            ;     jumps to Ltmp59
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp58-Lfunc_begin1            ; >> Call Site 14 <<
	.uleb128 Ltmp65-Ltmp58                  ;   Call between Ltmp58 and Ltmp65
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp65-Lfunc_begin1            ; >> Call Site 15 <<
	.uleb128 Ltmp66-Ltmp65                  ;   Call between Ltmp65 and Ltmp66
	.uleb128 Ltmp67-Lfunc_begin1            ;     jumps to Ltmp67
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp68-Lfunc_begin1            ; >> Call Site 16 <<
	.uleb128 Ltmp71-Ltmp68                  ;   Call between Ltmp68 and Ltmp71
	.uleb128 Ltmp72-Lfunc_begin1            ;     jumps to Ltmp72
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp47-Lfunc_begin1            ; >> Call Site 17 <<
	.uleb128 Ltmp46-Ltmp47                  ;   Call between Ltmp47 and Ltmp46
	.uleb128 Ltmp49-Lfunc_begin1            ;     jumps to Ltmp49
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp62-Lfunc_begin1            ; >> Call Site 18 <<
	.uleb128 Ltmp61-Ltmp62                  ;   Call between Ltmp62 and Ltmp61
	.uleb128 Ltmp64-Lfunc_begin1            ;     jumps to Ltmp64
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp61-Lfunc_begin1            ; >> Call Site 19 <<
	.uleb128 Ltmp104-Ltmp61                 ;   Call between Ltmp61 and Ltmp104
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp104-Lfunc_begin1           ; >> Call Site 20 <<
	.uleb128 Ltmp105-Ltmp104                ;   Call between Ltmp104 and Ltmp105
	.uleb128 Ltmp106-Lfunc_begin1           ;     jumps to Ltmp106
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp107-Lfunc_begin1           ; >> Call Site 21 <<
	.uleb128 Ltmp108-Ltmp107                ;   Call between Ltmp107 and Ltmp108
	.uleb128 Ltmp109-Lfunc_begin1           ;     jumps to Ltmp109
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp73-Lfunc_begin1            ; >> Call Site 22 <<
	.uleb128 Ltmp74-Ltmp73                  ;   Call between Ltmp73 and Ltmp74
	.uleb128 Ltmp75-Lfunc_begin1            ;     jumps to Ltmp75
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp79-Lfunc_begin1            ; >> Call Site 23 <<
	.uleb128 Ltmp80-Ltmp79                  ;   Call between Ltmp79 and Ltmp80
	.uleb128 Ltmp81-Lfunc_begin1            ;     jumps to Ltmp81
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp82-Lfunc_begin1            ; >> Call Site 24 <<
	.uleb128 Ltmp83-Ltmp82                  ;   Call between Ltmp82 and Ltmp83
	.uleb128 Ltmp84-Lfunc_begin1            ;     jumps to Ltmp84
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp83-Lfunc_begin1            ; >> Call Site 25 <<
	.uleb128 Ltmp98-Ltmp83                  ;   Call between Ltmp83 and Ltmp98
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp98-Lfunc_begin1            ; >> Call Site 26 <<
	.uleb128 Ltmp99-Ltmp98                  ;   Call between Ltmp98 and Ltmp99
	.uleb128 Ltmp100-Lfunc_begin1           ;     jumps to Ltmp100
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp101-Lfunc_begin1           ; >> Call Site 27 <<
	.uleb128 Ltmp102-Ltmp101                ;   Call between Ltmp101 and Ltmp102
	.uleb128 Ltmp103-Lfunc_begin1           ;     jumps to Ltmp103
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp18-Lfunc_begin1            ; >> Call Site 28 <<
	.uleb128 Ltmp19-Ltmp18                  ;   Call between Ltmp18 and Ltmp19
	.uleb128 Ltmp20-Lfunc_begin1            ;     jumps to Ltmp20
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp19-Lfunc_begin1            ; >> Call Site 29 <<
	.uleb128 Ltmp85-Ltmp19                  ;   Call between Ltmp19 and Ltmp85
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp85-Lfunc_begin1            ; >> Call Site 30 <<
	.uleb128 Ltmp86-Ltmp85                  ;   Call between Ltmp85 and Ltmp86
	.uleb128 Ltmp87-Lfunc_begin1            ;     jumps to Ltmp87
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp88-Lfunc_begin1            ; >> Call Site 31 <<
	.uleb128 Ltmp97-Ltmp88                  ;   Call between Ltmp88 and Ltmp97
	.uleb128 Ltmp103-Lfunc_begin1           ;     jumps to Ltmp103
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp97-Lfunc_begin1            ; >> Call Site 32 <<
	.uleb128 Ltmp76-Ltmp97                  ;   Call between Ltmp97 and Ltmp76
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp76-Lfunc_begin1            ; >> Call Site 33 <<
	.uleb128 Ltmp77-Ltmp76                  ;   Call between Ltmp76 and Ltmp77
	.uleb128 Ltmp78-Lfunc_begin1            ;     jumps to Ltmp78
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp77-Lfunc_begin1            ; >> Call Site 34 <<
	.uleb128 Ltmp110-Ltmp77                 ;   Call between Ltmp77 and Ltmp110
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp110-Lfunc_begin1           ; >> Call Site 35 <<
	.uleb128 Ltmp113-Ltmp110                ;   Call between Ltmp110 and Ltmp113
	.uleb128 Ltmp114-Lfunc_begin1           ;     jumps to Ltmp114
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp113-Lfunc_begin1           ; >> Call Site 36 <<
	.uleb128 Ltmp115-Ltmp113                ;   Call between Ltmp113 and Ltmp115
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp115-Lfunc_begin1           ; >> Call Site 37 <<
	.uleb128 Ltmp116-Ltmp115                ;   Call between Ltmp115 and Ltmp116
	.uleb128 Ltmp117-Lfunc_begin1           ;     jumps to Ltmp117
	.byte	9                               ;   On action: 5
	.uleb128 Ltmp116-Lfunc_begin1           ; >> Call Site 38 <<
	.uleb128 Lfunc_end1-Ltmp116             ;   Call between Ltmp116 and Lfunc_end1
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end1:
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
	.byte	0                               ;   No further actions
	.p2align	2, 0x0
                                        ; >> Catch TypeInfos <<
	.long	0                               ; TypeInfo 3
Ltmp151:                                ; TypeInfo 2
	.long	__ZTISt16invalid_argument@GOT-Ltmp151
Ltmp152:                                ; TypeInfo 1
	.long	__ZTISt9exception@GOT-Ltmp152
Lttbase0:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.private_extern	__ZNSt3__16vectorIaNS_9allocatorIaEEEC1B9nqe210106ESt16initializer_listIaE ; -- Begin function _ZNSt3__16vectorIaNS_9allocatorIaEEEC1B9nqe210106ESt16initializer_listIaE
	.globl	__ZNSt3__16vectorIaNS_9allocatorIaEEEC1B9nqe210106ESt16initializer_listIaE
	.weak_def_can_be_hidden	__ZNSt3__16vectorIaNS_9allocatorIaEEEC1B9nqe210106ESt16initializer_listIaE
	.p2align	2
__ZNSt3__16vectorIaNS_9allocatorIaEEEC1B9nqe210106ESt16initializer_listIaE: ; @_ZNSt3__16vectorIaNS_9allocatorIaEEEC1B9nqe210106ESt16initializer_listIaE
Lfunc_begin2:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception2
; %bb.0:
	stp	x22, x21, [sp, #-48]!           ; 16-byte Folded Spill
	stp	x20, x19, [sp, #16]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	mov	x19, x0
	stp	xzr, xzr, [x0]
	str	xzr, [x0, #16]
	cbz	x2, LBB6_4
; %bb.1:
	mov	x21, x2
	tbnz	x2, #63, LBB6_5
; %bb.2:
Ltmp118:
	mov	x20, x1
	mov	x0, x21
	bl	__Znwm
Ltmp119:
; %bb.3:
	mov	x22, x0
	stp	x0, x0, [x19]
	add	x8, x0, x21
	str	x8, [x19, #16]
	add	x8, x20, x21
	sub	x21, x8, x20
	mov	x1, x20
	mov	x2, x21
	bl	_memcpy
	add	x8, x22, x21
	str	x8, [x19, #8]
LBB6_4:
	mov	x0, x19
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #16]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp], #48             ; 16-byte Folded Reload
	ret
LBB6_5:
Ltmp120:
	bl	__ZNSt3__16vectorIaNS_9allocatorIaEEE20__throw_length_errorB9nqe210106Ev
Ltmp121:
; %bb.6:
	brk	#0x1
LBB6_7:
Ltmp122:
	mov	x20, x0
	ldr	x0, [x19]
	cbz	x0, LBB6_9
; %bb.8:
	str	x0, [x19, #8]
	bl	__ZdlPv
LBB6_9:
	mov	x0, x20
	bl	__Unwind_Resume
Lfunc_end2:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table6:
Lexception2:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end2-Lcst_begin2
Lcst_begin2:
	.uleb128 Ltmp118-Lfunc_begin2           ; >> Call Site 1 <<
	.uleb128 Ltmp119-Ltmp118                ;   Call between Ltmp118 and Ltmp119
	.uleb128 Ltmp122-Lfunc_begin2           ;     jumps to Ltmp122
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp119-Lfunc_begin2           ; >> Call Site 2 <<
	.uleb128 Ltmp120-Ltmp119                ;   Call between Ltmp119 and Ltmp120
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp120-Lfunc_begin2           ; >> Call Site 3 <<
	.uleb128 Ltmp121-Ltmp120                ;   Call between Ltmp120 and Ltmp121
	.uleb128 Ltmp122-Lfunc_begin2           ;     jumps to Ltmp122
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp121-Lfunc_begin2           ; >> Call Site 4 <<
	.uleb128 Lfunc_end2-Ltmp121             ;   Call between Ltmp121 and Lfunc_end2
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end2:
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
	.private_extern	__ZNSt3__120__throw_length_errorB9nqe210106EPKc ; -- Begin function _ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.globl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.weak_def_can_be_hidden	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.p2align	2
__ZNSt3__120__throw_length_errorB9nqe210106EPKc: ; @_ZNSt3__120__throw_length_errorB9nqe210106EPKc
Lfunc_begin3:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception3
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
Ltmp123:
	mov	x1, x20
	bl	__ZNSt12length_errorC1B9nqe210106EPKc
Ltmp124:
; %bb.1:
Lloh72:
	adrp	x1, __ZTISt12length_error@GOTPAGE
Lloh73:
	ldr	x1, [x1, __ZTISt12length_error@GOTPAGEOFF]
Lloh74:
	adrp	x2, __ZNSt12length_errorD1Ev@GOTPAGE
Lloh75:
	ldr	x2, [x2, __ZNSt12length_errorD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
LBB8_2:
Ltmp125:
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x0, x20
	bl	__Unwind_Resume
	.loh AdrpLdrGot	Lloh74, Lloh75
	.loh AdrpLdrGot	Lloh72, Lloh73
Lfunc_end3:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table8:
Lexception3:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end3-Lcst_begin3
Lcst_begin3:
	.uleb128 Lfunc_begin3-Lfunc_begin3      ; >> Call Site 1 <<
	.uleb128 Ltmp123-Lfunc_begin3           ;   Call between Lfunc_begin3 and Ltmp123
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp123-Lfunc_begin3           ; >> Call Site 2 <<
	.uleb128 Ltmp124-Ltmp123                ;   Call between Ltmp123 and Ltmp124
	.uleb128 Ltmp125-Lfunc_begin3           ;     jumps to Ltmp125
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp124-Lfunc_begin3           ; >> Call Site 3 <<
	.uleb128 Lfunc_end3-Ltmp124             ;   Call between Ltmp124 and Lfunc_end3
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end3:
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
Lloh76:
	adrp	x8, __ZTVSt12length_error@GOTPAGE
Lloh77:
	ldr	x8, [x8, __ZTVSt12length_error@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x0]
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
	.loh AdrpLdrGot	Lloh76, Lloh77
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
Lloh78:
	adrp	x1, __ZTISt20bad_array_new_length@GOTPAGE
Lloh79:
	ldr	x1, [x1, __ZTISt20bad_array_new_length@GOTPAGEOFF]
Lloh80:
	adrp	x2, __ZNSt20bad_array_new_lengthD1Ev@GOTPAGE
Lloh81:
	ldr	x2, [x2, __ZNSt20bad_array_new_lengthD1Ev@GOTPAGEOFF]
	bl	___cxa_throw
	.loh AdrpLdrGot	Lloh80, Lloh81
	.loh AdrpLdrGot	Lloh78, Lloh79
	.cfi_endproc
                                        ; -- End function
	.private_extern	__ZNSt3__16vectorIaNS_9allocatorIaEEE20__throw_length_errorB9nqe210106Ev ; -- Begin function _ZNSt3__16vectorIaNS_9allocatorIaEEE20__throw_length_errorB9nqe210106Ev
	.globl	__ZNSt3__16vectorIaNS_9allocatorIaEEE20__throw_length_errorB9nqe210106Ev
	.weak_def_can_be_hidden	__ZNSt3__16vectorIaNS_9allocatorIaEEE20__throw_length_errorB9nqe210106Ev
	.p2align	2
__ZNSt3__16vectorIaNS_9allocatorIaEEE20__throw_length_errorB9nqe210106Ev: ; @_ZNSt3__16vectorIaNS_9allocatorIaEEE20__throw_length_errorB9nqe210106Ev
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh82:
	adrp	x0, l_.str.13@PAGE
Lloh83:
	add	x0, x0, l_.str.13@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh82, Lloh83
	.cfi_endproc
                                        ; -- End function
	.private_extern	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m ; -- Begin function _ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
	.globl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
	.weak_def_can_be_hidden	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
	.p2align	2
__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m: ; @_ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Lfunc_begin4:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception4
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
Ltmp126:
	add	x0, sp, #8
	mov	x1, x19
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryC1ERS3_
Ltmp127:
; %bb.1:
	ldrb	w8, [sp, #8]
	cmp	w8, #1
	b.ne	LBB12_10
; %bb.2:
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
	add	x4, x19, x8
	ldr	x22, [x4, #40]
	ldr	w24, [x4, #8]
	ldr	w23, [x4, #144]
	cmn	w23, #1
	b.ne	LBB12_7
; %bb.3:
Ltmp129:
	add	x8, sp, #24
	mov	x25, x4
	mov	x0, x4
	bl	__ZNKSt3__18ios_base6getlocEv
Ltmp130:
; %bb.4:
Ltmp131:
Lloh84:
	adrp	x1, __ZNSt3__15ctypeIcE2idE@GOTPAGE
Lloh85:
	ldr	x1, [x1, __ZNSt3__15ctypeIcE2idE@GOTPAGEOFF]
	add	x0, sp, #24
	bl	__ZNKSt3__16locale9use_facetERNS0_2idE
Ltmp132:
; %bb.5:
	ldr	x8, [x0]
	ldr	x8, [x8, #56]
Ltmp133:
	mov	w1, #32                         ; =0x20
	blr	x8
Ltmp134:
; %bb.6:
	mov	x23, x0
	add	x0, sp, #24
	bl	__ZNSt3__16localeD1Ev
	mov	x4, x25
	str	w23, [x25, #144]
LBB12_7:
	mov	w8, #176                        ; =0xb0
	and	w8, w24, w8
	add	x3, x20, x21
	cmp	w8, #32
	csel	x2, x3, x20, eq
Ltmp136:
	sxtb	w5, w23
	mov	x0, x22
	mov	x1, x20
	bl	__ZNSt3__116__pad_and_outputB9nqe210106IcNS_11char_traitsIcEEEENS_19ostreambuf_iteratorIT_T0_EES6_PKS4_S8_S8_RNS_8ios_baseES4_
Ltmp137:
; %bb.8:
	cbnz	x0, LBB12_10
; %bb.9:
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
	add	x0, x19, x8
	ldr	w8, [x0, #32]
	mov	w9, #5                          ; =0x5
Ltmp139:
	orr	w1, w8, w9
	bl	__ZNSt3__18ios_base5clearEj
Ltmp140:
LBB12_10:
	add	x0, sp, #8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryD1Ev
LBB12_11:
	mov	x0, x19
	ldp	x29, x30, [sp, #96]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #80]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #64]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #48]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #112
	ret
LBB12_12:
Ltmp141:
	b	LBB12_15
LBB12_13:
Ltmp135:
	mov	x20, x0
	add	x0, sp, #24
	bl	__ZNSt3__16localeD1Ev
	b	LBB12_16
LBB12_14:
Ltmp138:
LBB12_15:
	mov	x20, x0
LBB12_16:
	add	x0, sp, #8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryD1Ev
	b	LBB12_18
LBB12_17:
Ltmp128:
	mov	x20, x0
LBB12_18:
	mov	x0, x20
	bl	___cxa_begin_catch
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
Ltmp142:
	add	x0, x19, x8
	bl	__ZNSt3__18ios_base33__set_badbit_and_consider_rethrowEv
Ltmp143:
; %bb.19:
	bl	___cxa_end_catch
	b	LBB12_11
LBB12_20:
Ltmp144:
	mov	x19, x0
Ltmp145:
	bl	___cxa_end_catch
Ltmp146:
; %bb.21:
	mov	x0, x19
	bl	__Unwind_Resume
LBB12_22:
Ltmp147:
	bl	___clang_call_terminate
	.loh AdrpLdrGot	Lloh84, Lloh85
Lfunc_end4:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table12:
Lexception4:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase1-Lttbaseref1
Lttbaseref1:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end4-Lcst_begin4
Lcst_begin4:
	.uleb128 Ltmp126-Lfunc_begin4           ; >> Call Site 1 <<
	.uleb128 Ltmp127-Ltmp126                ;   Call between Ltmp126 and Ltmp127
	.uleb128 Ltmp128-Lfunc_begin4           ;     jumps to Ltmp128
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp129-Lfunc_begin4           ; >> Call Site 2 <<
	.uleb128 Ltmp130-Ltmp129                ;   Call between Ltmp129 and Ltmp130
	.uleb128 Ltmp138-Lfunc_begin4           ;     jumps to Ltmp138
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp131-Lfunc_begin4           ; >> Call Site 3 <<
	.uleb128 Ltmp134-Ltmp131                ;   Call between Ltmp131 and Ltmp134
	.uleb128 Ltmp135-Lfunc_begin4           ;     jumps to Ltmp135
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp136-Lfunc_begin4           ; >> Call Site 4 <<
	.uleb128 Ltmp137-Ltmp136                ;   Call between Ltmp136 and Ltmp137
	.uleb128 Ltmp138-Lfunc_begin4           ;     jumps to Ltmp138
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp139-Lfunc_begin4           ; >> Call Site 5 <<
	.uleb128 Ltmp140-Ltmp139                ;   Call between Ltmp139 and Ltmp140
	.uleb128 Ltmp141-Lfunc_begin4           ;     jumps to Ltmp141
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp140-Lfunc_begin4           ; >> Call Site 6 <<
	.uleb128 Ltmp142-Ltmp140                ;   Call between Ltmp140 and Ltmp142
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp142-Lfunc_begin4           ; >> Call Site 7 <<
	.uleb128 Ltmp143-Ltmp142                ;   Call between Ltmp142 and Ltmp143
	.uleb128 Ltmp144-Lfunc_begin4           ;     jumps to Ltmp144
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp143-Lfunc_begin4           ; >> Call Site 8 <<
	.uleb128 Ltmp145-Ltmp143                ;   Call between Ltmp143 and Ltmp145
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp145-Lfunc_begin4           ; >> Call Site 9 <<
	.uleb128 Ltmp146-Ltmp145                ;   Call between Ltmp145 and Ltmp146
	.uleb128 Ltmp147-Lfunc_begin4           ;     jumps to Ltmp147
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp146-Lfunc_begin4           ; >> Call Site 10 <<
	.uleb128 Lfunc_end4-Ltmp146             ;   Call between Ltmp146 and Lfunc_end4
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end4:
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
Lfunc_begin5:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception5
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
	cbz	x0, LBB13_16
; %bb.1:
	mov	x23, x5
	mov	x20, x4
	mov	x22, x3
	mov	x21, x2
	mov	x24, x1
	ldr	x26, [x4, #24]
	sub	x25, x2, x1
	cmp	x25, #1
	b.lt	LBB13_3
; %bb.2:
	ldr	x8, [x19]
	ldr	x8, [x8, #96]
	mov	x0, x19
	mov	x1, x24
	mov	x2, x25
	blr	x8
	cmp	x0, x25
	b.ne	LBB13_15
LBB13_3:
	sub	x8, x22, x24
	cmp	x26, x8
	b.le	LBB13_12
; %bb.4:
	mov	x9, #-9                         ; =0xfffffffffffffff7
	movk	x9, #32767, lsl #48
	sub	x24, x26, x8
	cmp	x24, x9
	b.hs	LBB13_17
; %bb.5:
	cmp	x24, #23
	b.hs	LBB13_7
; %bb.6:
	strb	w24, [sp, #31]
	add	x25, sp, #8
	b	LBB13_8
LBB13_7:
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
LBB13_8:
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
Ltmp148:
	mov	x0, x19
	mov	x2, x24
	blr	x8
Ltmp149:
; %bb.9:
	ldrsb	w8, [sp, #31]
	tbnz	w8, #31, LBB13_11
; %bb.10:
	cmp	x0, x24
	b.ne	LBB13_15
	b	LBB13_12
LBB13_11:
	ldr	x8, [sp, #8]
	mov	x23, x0
	mov	x0, x8
	bl	__ZdlPv
	mov	x0, x23
	cmp	x0, x24
	b.ne	LBB13_15
LBB13_12:
	sub	x22, x22, x21
	cmp	x22, #1
	b.lt	LBB13_14
; %bb.13:
	ldr	x8, [x19]
	ldr	x8, [x8, #96]
	mov	x0, x19
	mov	x1, x21
	mov	x2, x22
	blr	x8
	cmp	x0, x22
	b.ne	LBB13_15
LBB13_14:
	str	xzr, [x20, #24]
	b	LBB13_16
LBB13_15:
	mov	x19, #0                         ; =0x0
LBB13_16:
	mov	x0, x19
	ldp	x29, x30, [sp, #96]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #80]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #64]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #48]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #112
	ret
LBB13_17:
	bl	__ZNSt3__112basic_stringIcNS_11char_traitsIcEENS_9allocatorIcEEE20__throw_length_errorB9nqe210106Ev
LBB13_18:
Ltmp150:
	mov	x19, x0
	ldrsb	w8, [sp, #31]
	tbz	w8, #31, LBB13_20
; %bb.19:
	ldr	x0, [sp, #8]
	bl	__ZdlPv
LBB13_20:
	mov	x0, x19
	bl	__Unwind_Resume
Lfunc_end5:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table13:
Lexception5:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end5-Lcst_begin5
Lcst_begin5:
	.uleb128 Lfunc_begin5-Lfunc_begin5      ; >> Call Site 1 <<
	.uleb128 Ltmp148-Lfunc_begin5           ;   Call between Lfunc_begin5 and Ltmp148
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp148-Lfunc_begin5           ; >> Call Site 2 <<
	.uleb128 Ltmp149-Ltmp148                ;   Call between Ltmp148 and Ltmp149
	.uleb128 Ltmp150-Lfunc_begin5           ;     jumps to Ltmp150
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp149-Lfunc_begin5           ; >> Call Site 3 <<
	.uleb128 Lfunc_end5-Ltmp149             ;   Call between Ltmp149 and Lfunc_end5
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end5:
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
Lloh86:
	adrp	x0, l_.str.14@PAGE
Lloh87:
	add	x0, x0, l_.str.14@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh86, Lloh87
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
Lloh88:
	adrp	x0, l_.str.13@PAGE
Lloh89:
	add	x0, x0, l_.str.13@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh88, Lloh89
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _Z4packRKNSt3__16vectorIaNS_9allocatorIaEEEE.cold.1
__Z4packRKNSt3__16vectorIaNS_9allocatorIaEEEE.cold.1: ; @_Z4packRKNSt3__16vectorIaNS_9allocatorIaEEEE.cold.1
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh90:
	adrp	x1, __ZTISt16invalid_argument@GOTPAGE
Lloh91:
	ldr	x1, [x1, __ZTISt16invalid_argument@GOTPAGEOFF]
Lloh92:
	adrp	x2, __ZNSt16invalid_argumentD1Ev@GOTPAGE
Lloh93:
	ldr	x2, [x2, __ZNSt16invalid_argumentD1Ev@GOTPAGEOFF]
	bl	___cxa_throw
	.loh AdrpLdrGot	Lloh92, Lloh93
	.loh AdrpLdrGot	Lloh90, Lloh91
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"empty"

l_.str.1:                               ; @.str.1
	.asciz	"int4 range"

	.globl	_sink                           ; @sink
.zerofill __DATA,__common,_sink,4,2
	.section	__TEXT,__const
	.p2align	2, 0x0                          ; @constinit
l_constinit:
	.long	1                               ; 0x1
	.long	15                              ; 0xf
	.long	16                              ; 0x10
	.long	17                              ; 0x11
	.long	31                              ; 0x1f
	.long	32                              ; 0x20
	.long	33                              ; 0x21
	.long	63                              ; 0x3f
	.long	64                              ; 0x40
	.long	65                              ; 0x41
	.long	4097                            ; 0x1001
	.long	65539                           ; 0x10003

	.section	__TEXT,__cstring,cstring_literals
l_.str.2:                               ; @.str.2
	.asciz	"dot mismatch"

l_.str.3:                               ; @.str.3
	.asciz	"N="

l_.str.4:                               ; @.str.4
	.asciz	" payload_with_scale_bytes="

l_.str.5:                               ; @.str.5
	.asciz	" object_bytes="

l_.str.6:                               ; @.str.6
	.asciz	" FP32_weight_bytes="

l_.str.7:                               ; @.str.7
	.asciz	" CPU_batch_mean_P50_us separated="

l_.str.8:                               ; @.str.8
	.asciz	" fused="

l_.str.9:                               ; @.str.9
	.asciz	"reject"

l_.str.10:                              ; @.str.10
	.asciz	"PASS lengths="

l_.str.11:                              ; @.str.11
	.asciz	" rejected="

l_.str.12:                              ; @.str.12
	.asciz	"\n"

l_.str.13:                              ; @.str.13
	.asciz	"vector"

l_.str.14:                              ; @.str.14
	.asciz	"basic_string"

.subsections_via_symbols
