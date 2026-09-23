	.build_version macos, 26, 0	sdk_version 26, 5
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__Z8neon_dotPKaS0_m             ; -- Begin function _Z8neon_dotPKaS0_m
	.p2align	2
__Z8neon_dotPKaS0_m:                    ; @_Z8neon_dotPKaS0_m
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
	cmp	x2, #32
	b.hi	LBB0_21
; %bb.1:
	movi.2d	v0, #0000000000000000
	cbz	x2, LBB0_5
; %bb.2:
	cbz	x0, LBB0_21
; %bb.3:
	cbz	x1, LBB0_21
; %bb.4:
	cmp	x2, #16
	b.hs	LBB0_8
LBB0_5:
	mov	x11, #0                         ; =0x0
	addv.4s	s2, v0
	fmov	w8, s2
	subs	x9, x2, x11
	b.ls	LBB0_16
LBB0_6:
	cmp	x9, #4
	b.hs	LBB0_10
; %bb.7:
	mov	x9, x11
	b	LBB0_14
LBB0_8:
	ldr	q1, [x0]
	ldr	q2, [x1]
	smull.8h	v0, v1, v2
	saddlp.4s	v0, v0
	smull2.8h	v1, v1, v2
	sadalp.4s	v0, v1
	cmp	x2, #32
	b.ne	LBB0_17
; %bb.9:
	ldr	q1, [x0, #16]
	ldr	q2, [x1, #16]
	smull.8h	v3, v1, v2
	sadalp.4s	v0, v3
	smull2.8h	v1, v1, v2
	sadalp.4s	v0, v1
	mov	w11, #32                        ; =0x20
	addv.4s	s2, v0
	fmov	w8, s2
	subs	x9, x2, x11
	b.hi	LBB0_6
	b	LBB0_16
LBB0_10:
	cmp	x9, #32
	b.hs	LBB0_18
; %bb.11:
	and	x10, x2, #0x3
	sub	x8, x9, x10
	add	x9, x11, x8
	movi.2d	v0, #0000000000000000
	mov.s	v0[0], v2[0]
	add	x8, x11, x10
	sub	x8, x8, x2
	add	x12, x1, x11
	add	x11, x0, x11
LBB0_12:                                ; =>This Inner Loop Header: Depth=1
	ldr	s1, [x11], #4
	sshll.8h	v1, v1, #0
	ldr	s2, [x12], #4
	sshll.8h	v2, v2, #0
	smlal.4s	v0, v2, v1
	adds	x8, x8, #4
	b.ne	LBB0_12
; %bb.13:
	addv.4s	s0, v0
	fmov	w8, s0
	cbz	x10, LBB0_16
LBB0_14:
	sub	x10, x2, x9
	add	x11, x1, x9
	add	x9, x0, x9
LBB0_15:                                ; =>This Inner Loop Header: Depth=1
	ldrsb	w12, [x9], #1
	ldrsb	w13, [x11], #1
	madd	w8, w13, w12, w8
	subs	x10, x10, #1
	b.ne	LBB0_15
LBB0_16:
	mov	x0, x8
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
	ret
LBB0_17:
	mov	w11, #16                        ; =0x10
	addv.4s	s2, v0
	fmov	w8, s2
	subs	x9, x2, x11
	b.ls	LBB0_16
	b	LBB0_6
LBB0_18:
	and	x8, x9, #0x20
	movi.2d	v0, #0000000000000000
	movi.2d	v1, #0000000000000000
	mov.s	v1[0], v2[0]
	add	x10, x11, #16
	add	x9, x1, x10
	add	x10, x0, x10
LBB0_19:                                ; =>This Inner Loop Header: Depth=1
	ldp	q2, q3, [x10, #-16]
	ldp	q4, q5, [x9, #-16]
	sdot.4s	v1, v4, v2
	sdot.4s	v0, v5, v3
	add	x9, x9, #32
	add	x10, x10, #32
	subs	x8, x8, #32
	b.ne	LBB0_19
; %bb.20:
	add.4s	v0, v0, v1
	addv.4s	s0, v0
	fmov	w0, s0
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
	ret
LBB0_21:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp0:
Lloh0:
	adrp	x1, l_.str.2@PAGE
Lloh1:
	add	x1, x1, l_.str.2@PAGEOFF
	bl	__ZNSt16invalid_argumentC1B9nqe210106EPKc
Ltmp1:
; %bb.22:
	mov	x0, x19
	bl	__Z8neon_dotPKaS0_m.cold.1
LBB0_23:
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
	.globl	__Z12optional_dotPKaS0_m        ; -- Begin function _Z12optional_dotPKaS0_m
	.p2align	2
__Z12optional_dotPKaS0_m:               ; @_Z12optional_dotPKaS0_m
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
	cmp	x2, #32
	b.hi	LBB1_21
; %bb.1:
	movi.2d	v0, #0000000000000000
	cbz	x2, LBB1_5
; %bb.2:
	cbz	x0, LBB1_21
; %bb.3:
	cbz	x1, LBB1_21
; %bb.4:
	cmp	x2, #16
	b.hs	LBB1_8
LBB1_5:
	mov	x11, #0                         ; =0x0
	addv.4s	s2, v0
	fmov	w8, s2
	subs	x9, x2, x11
	b.ls	LBB1_16
LBB1_6:
	cmp	x9, #4
	b.hs	LBB1_10
; %bb.7:
	mov	x9, x11
	b	LBB1_14
LBB1_8:
	ldr	q1, [x0]
	ldr	q2, [x1]
	sdot.4s	v0, v1, v2
	cmp	x2, #32
	b.ne	LBB1_17
; %bb.9:
	ldr	q1, [x0, #16]
	ldr	q2, [x1, #16]
	sdot.4s	v0, v1, v2
	mov	w11, #32                        ; =0x20
	addv.4s	s2, v0
	fmov	w8, s2
	subs	x9, x2, x11
	b.hi	LBB1_6
	b	LBB1_16
LBB1_10:
	cmp	x9, #32
	b.hs	LBB1_18
; %bb.11:
	and	x10, x2, #0x3
	sub	x8, x9, x10
	add	x9, x11, x8
	movi.2d	v0, #0000000000000000
	mov.s	v0[0], v2[0]
	add	x8, x11, x10
	sub	x8, x8, x2
	add	x12, x1, x11
	add	x11, x0, x11
LBB1_12:                                ; =>This Inner Loop Header: Depth=1
	ldr	s1, [x11], #4
	sshll.8h	v1, v1, #0
	ldr	s2, [x12], #4
	sshll.8h	v2, v2, #0
	smlal.4s	v0, v2, v1
	adds	x8, x8, #4
	b.ne	LBB1_12
; %bb.13:
	addv.4s	s0, v0
	fmov	w8, s0
	cbz	x10, LBB1_16
LBB1_14:
	sub	x10, x2, x9
	add	x11, x1, x9
	add	x9, x0, x9
LBB1_15:                                ; =>This Inner Loop Header: Depth=1
	ldrsb	w12, [x9], #1
	ldrsb	w13, [x11], #1
	madd	w8, w13, w12, w8
	subs	x10, x10, #1
	b.ne	LBB1_15
LBB1_16:
	mov	x0, x8
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
	ret
LBB1_17:
	mov	w11, #16                        ; =0x10
	addv.4s	s2, v0
	fmov	w8, s2
	subs	x9, x2, x11
	b.ls	LBB1_16
	b	LBB1_6
LBB1_18:
	and	x8, x9, #0x20
	movi.2d	v0, #0000000000000000
	movi.2d	v1, #0000000000000000
	mov.s	v1[0], v2[0]
	add	x10, x11, #16
	add	x9, x1, x10
	add	x10, x0, x10
LBB1_19:                                ; =>This Inner Loop Header: Depth=1
	ldp	q2, q3, [x10, #-16]
	ldp	q4, q5, [x9, #-16]
	sdot.4s	v1, v4, v2
	sdot.4s	v0, v5, v3
	add	x9, x9, #32
	add	x10, x10, #32
	subs	x8, x8, #32
	b.ne	LBB1_19
; %bb.20:
	add.4s	v0, v0, v1
	addv.4s	s0, v0
	fmov	w0, s0
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
	ret
LBB1_21:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp3:
Lloh2:
	adrp	x1, l_.str.2@PAGE
Lloh3:
	add	x1, x1, l_.str.2@PAGEOFF
	bl	__ZNSt16invalid_argumentC1B9nqe210106EPKc
Ltmp4:
; %bb.22:
	mov	x0, x19
	bl	__Z12optional_dotPKaS0_m.cold.1
LBB1_23:
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
	.globl	__Z16has_compiled_dotv          ; -- Begin function _Z16has_compiled_dotv
	.p2align	2
__Z16has_compiled_dotv:                 ; @_Z16has_compiled_dotv
	.cfi_startproc
; %bb.0:
	mov	w0, #1                          ; =0x1
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__Z10scaled_dotPKaS0_PKfS2_mPFiS0_S0_mE ; -- Begin function _Z10scaled_dotPKaS0_PKfS2_mPFiS0_S0_mE
	.p2align	2
__Z10scaled_dotPKaS0_PKfS2_mPFiS0_S0_mE: ; @_Z10scaled_dotPKaS0_PKfS2_mPFiS0_S0_mE
Lfunc_begin2:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception2
; %bb.0:
	stp	d9, d8, [sp, #-112]!            ; 16-byte Folded Spill
	stp	x28, x27, [sp, #16]             ; 16-byte Folded Spill
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
	.cfi_offset w27, -88
	.cfi_offset w28, -96
	.cfi_offset b8, -104
	.cfi_offset b9, -112
	cbz	x5, LBB3_16
; %bb.1:
	mov	x20, x4
	cbz	x4, LBB3_12
; %bb.2:
	mov	x24, x0
	cbz	x0, LBB3_16
; %bb.3:
	mov	x23, x1
	cbz	x1, LBB3_16
; %bb.4:
	mov	x22, x2
	cbz	x2, LBB3_16
; %bb.5:
	mov	x21, x3
	cbz	x3, LBB3_16
; %bb.6:
	mov	x19, x5
	mov	x26, #0                         ; =0x0
	movi.2d	v8, #0000000000000000
	mov	w27, #2139095039                ; =0x7f7fffff
	mov	w28, #32                        ; =0x20
LBB3_7:                                 ; =>This Inner Loop Header: Depth=1
	ldr	s0, [x22]
	fmov	w8, s0
	and	w8, w8, #0x7fffffff
	cmp	w8, w27
	b.gt	LBB3_14
; %bb.8:                                ;   in Loop: Header=BB3_7 Depth=1
	ldr	s1, [x21]
	fmov	w8, s1
	and	w8, w8, #0x7fffffff
	cmp	w8, w27
	b.gt	LBB3_14
; %bb.9:                                ;   in Loop: Header=BB3_7 Depth=1
	fcmp	s0, #0.0
	b.mi	LBB3_14
; %bb.10:                               ;   in Loop: Header=BB3_7 Depth=1
	fcmp	s1, #0.0
	b.mi	LBB3_14
; %bb.11:                               ;   in Loop: Header=BB3_7 Depth=1
	sub	x8, x20, x26
	cmp	x8, #32
	csel	x25, x8, x28, lo
	add	x0, x24, x26
	add	x1, x23, x26
	mov	x2, x25
	blr	x19
	scvtf	s0, w0
	ldr	s1, [x22], #4
	ldr	s2, [x21], #4
	fmul	s1, s1, s2
	fmul	s0, s1, s0
	fadd	s8, s8, s0
	add	x26, x25, x26
	cmp	x26, x20
	b.lo	LBB3_7
	b	LBB3_13
LBB3_12:
	movi.2d	v8, #0000000000000000
LBB3_13:
	mov.16b	v0, v8
	ldp	x29, x30, [sp, #96]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #80]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #64]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #48]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #32]             ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #16]             ; 16-byte Folded Reload
	ldp	d9, d8, [sp], #112              ; 16-byte Folded Reload
	ret
LBB3_14:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp6:
Lloh4:
	adrp	x1, l_.str.1@PAGE
Lloh5:
	add	x1, x1, l_.str.1@PAGEOFF
	bl	__ZNSt16invalid_argumentC1B9nqe210106EPKc
Ltmp7:
; %bb.15:
	mov	x0, x19
	bl	__Z10scaled_dotPKaS0_PKfS2_mPFiS0_S0_mE.cold.1
LBB3_16:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp9:
Lloh6:
	adrp	x1, l_.str@PAGE
Lloh7:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt16invalid_argumentC1B9nqe210106EPKc
Ltmp10:
; %bb.17:
	mov	x0, x19
	bl	__Z10scaled_dotPKaS0_PKfS2_mPFiS0_S0_mE.cold.2
LBB3_18:
Ltmp11:
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x0, x20
	bl	__Unwind_Resume
LBB3_19:
Ltmp8:
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x0, x20
	bl	__Unwind_Resume
	.loh AdrpAdd	Lloh4, Lloh5
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
	.uleb128 Ltmp9-Ltmp7                    ;   Call between Ltmp7 and Ltmp9
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp9-Lfunc_begin2             ; >> Call Site 4 <<
	.uleb128 Ltmp10-Ltmp9                   ;   Call between Ltmp9 and Ltmp10
	.uleb128 Ltmp11-Lfunc_begin2            ;     jumps to Ltmp11
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp10-Lfunc_begin2            ; >> Call Site 5 <<
	.uleb128 Lfunc_end2-Ltmp10              ;   Call between Ltmp10 and Lfunc_end2
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end2:
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
Lloh8:
	adrp	x8, __ZTVSt16invalid_argument@GOTPAGE
Lloh9:
	ldr	x8, [x8, __ZTVSt16invalid_argument@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x0]
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
	.loh AdrpLdrGot	Lloh8, Lloh9
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _Z8neon_dotPKaS0_m.cold.1
__Z8neon_dotPKaS0_m.cold.1:             ; @_Z8neon_dotPKaS0_m.cold.1
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
	.p2align	2                               ; -- Begin function _Z12optional_dotPKaS0_m.cold.1
__Z12optional_dotPKaS0_m.cold.1:        ; @_Z12optional_dotPKaS0_m.cold.1
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
	.p2align	2                               ; -- Begin function _Z10scaled_dotPKaS0_PKfS2_mPFiS0_S0_mE.cold.1
__Z10scaled_dotPKaS0_PKfS2_mPFiS0_S0_mE.cold.1: ; @_Z10scaled_dotPKaS0_PKfS2_mPFiS0_S0_mE.cold.1
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
	.p2align	2                               ; -- Begin function _Z10scaled_dotPKaS0_PKfS2_mPFiS0_S0_mE.cold.2
__Z10scaled_dotPKaS0_PKfS2_mPFiS0_S0_mE.cold.2: ; @_Z10scaled_dotPKaS0_PKfS2_mPFiS0_S0_mE.cold.2
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
	.asciz	"invalid scaled dot input"

l_.str.1:                               ; @.str.1
	.asciz	"scales must be finite nonnegative values"

l_.str.2:                               ; @.str.2
	.asciz	"block needs valid pointers and n<=32"

.subsections_via_symbols
