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
	.globl	__Z6scalarPKaS0_m               ; -- Begin function _Z6scalarPKaS0_m
	.p2align	2
__Z6scalarPKaS0_m:                      ; @_Z6scalarPKaS0_m
	.cfi_startproc
; %bb.0:
	mov	w8, #0                          ; =0x0
	cbz	x2, LBB1_2
LBB1_1:                                 ; =>This Inner Loop Header: Depth=1
	ldrsb	w9, [x0], #1
	ldrsb	w10, [x1], #1
	madd	w8, w10, w9, w8
	subs	x2, x2, #1
	b.ne	LBB1_1
LBB1_2:
	mov	x0, x8
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__Z8wideningPKaS0_m             ; -- Begin function _Z8wideningPKaS0_m
	.p2align	2
__Z8wideningPKaS0_m:                    ; @_Z8wideningPKaS0_m
	.cfi_startproc
; %bb.0:
	cmp	x2, #16
	b.hs	LBB2_2
; %bb.1:
	mov	x10, #0                         ; =0x0
	movi.2d	v0, #0000000000000000
	b	LBB2_4
LBB2_2:
	mov	x8, #0                          ; =0x0
	movi.2d	v0, #0000000000000000
LBB2_3:                                 ; =>This Inner Loop Header: Depth=1
	ldr	q1, [x0, x8]
	ldr	q2, [x1, x8]
	smull.8h	v3, v1, v2
	sadalp.4s	v0, v3
	smull2.8h	v1, v1, v2
	sadalp.4s	v0, v1
	add	x10, x8, #16
	add	x9, x8, #32
	mov	x8, x10
	cmp	x9, x2
	b.ls	LBB2_3
LBB2_4:
	addv.4s	s0, v0
	fmov	w8, s0
	subs	x9, x2, x10
	b.ls	LBB2_7
; %bb.5:
	add	x11, x1, x10
	add	x10, x0, x10
LBB2_6:                                 ; =>This Inner Loop Header: Depth=1
	ldrsb	w12, [x10], #1
	ldrsb	w13, [x11], #1
	madd	w8, w13, w12, w8
	subs	x9, x9, #1
	b.ne	LBB2_6
LBB2_7:
	mov	x0, x8
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__Z7dotprodPKaS0_m              ; -- Begin function _Z7dotprodPKaS0_m
	.p2align	2
__Z7dotprodPKaS0_m:                     ; @_Z7dotprodPKaS0_m
	.cfi_startproc
; %bb.0:
	cmp	x2, #16
	b.hs	LBB3_2
; %bb.1:
	mov	x10, #0                         ; =0x0
	movi.2d	v0, #0000000000000000
	b	LBB3_4
LBB3_2:
	mov	x8, #0                          ; =0x0
	movi.2d	v0, #0000000000000000
LBB3_3:                                 ; =>This Inner Loop Header: Depth=1
	ldr	q1, [x0, x8]
	ldr	q2, [x1, x8]
	sdot.4s	v0, v1, v2
	add	x10, x8, #16
	add	x9, x8, #32
	mov	x8, x10
	cmp	x9, x2
	b.ls	LBB3_3
LBB3_4:
	addv.4s	s0, v0
	fmov	w8, s0
	subs	x9, x2, x10
	b.ls	LBB3_7
; %bb.5:
	add	x11, x1, x10
	add	x10, x0, x10
LBB3_6:                                 ; =>This Inner Loop Header: Depth=1
	ldrsb	w12, [x10], #1
	ldrsb	w13, [x11], #1
	madd	w8, w13, w12, w8
	subs	x9, x9, #1
	b.ne	LBB3_6
LBB3_7:
	mov	x0, x8
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__Z7has_dotv                    ; -- Begin function _Z7has_dotv
	.p2align	2
__Z7has_dotv:                           ; @_Z7has_dotv
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	wzr, [x29, #-4]
	mov	w8, #4                          ; =0x4
	str	x8, [sp]
Lloh2:
	adrp	x0, l_.str.1@PAGE
Lloh3:
	add	x0, x0, l_.str.1@PAGEOFF
	sub	x1, x29, #4
	mov	x2, sp
	mov	x3, #0                          ; =0x0
	mov	x4, #0                          ; =0x0
	bl	_sysctlbyname
	cmp	w0, #0
	ldur	w8, [x29, #-4]
	ccmp	w8, #0, #4, eq
	cset	w0, ne
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #32
	ret
	.loh AdrpAdd	Lloh2, Lloh3
	.cfi_endproc
                                        ; -- End function
	.globl	__Z8validateRK5Input            ; -- Begin function _Z8validateRK5Input
	.p2align	2
__Z8validateRK5Input:                   ; @_Z8validateRK5Input
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
	ldr	x10, [x0, #96]
	mov	x8, #-4097                      ; =0xffffffffffffefff
	add	x8, x10, x8
	cmn	x8, #1, lsl #12                 ; =4096
	b.lo	LBB5_14
; %bb.1:
	ldp	x9, x8, [x0]
	sub	x12, x8, x9
	ldp	x9, x8, [x0, #24]
	sub	x8, x8, x9
	cmp	x12, x8
	b.ne	LBB5_14
; %bb.2:
	ldp	x8, x11, [x0, #48]
	sub	x13, x11, x8
	asr	x9, x13, #2
	udiv	x14, x12, x10
	msub	x10, x14, x10, x12
	cmp	x10, #0
	cinc	x10, x14, ne
	cmp	x9, x10
	b.ne	LBB5_14
; %bb.3:
	ldp	x10, x12, [x0, #72]
	sub	x12, x12, x10
	cmp	x12, x13
	b.ne	LBB5_14
; %bb.4:
	cmp	x11, x8
	b.eq	LBB5_11
; %bb.5:
	mov	w11, #2139095039                ; =0x7f7fffff
LBB5_6:                                 ; =>This Inner Loop Header: Depth=1
	ldr	s0, [x8], #4
	fmov	w12, s0
	and	w12, w12, #0x7fffffff
	cmp	w12, w11
	b.gt	LBB5_12
; %bb.7:                                ;   in Loop: Header=BB5_6 Depth=1
	ldr	s1, [x10], #4
	fmov	w12, s1
	and	w12, w12, #0x7fffffff
	cmp	w12, w11
	b.gt	LBB5_12
; %bb.8:                                ;   in Loop: Header=BB5_6 Depth=1
	fcmp	s0, #0.0
	b.mi	LBB5_12
; %bb.9:                                ;   in Loop: Header=BB5_6 Depth=1
	fcmp	s1, #0.0
	b.mi	LBB5_12
; %bb.10:                               ;   in Loop: Header=BB5_6 Depth=1
	subs	x9, x9, #1
	b.ne	LBB5_6
LBB5_11:
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
	ret
LBB5_12:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp3:
Lloh4:
	adrp	x1, l_.str.3@PAGE
Lloh5:
	add	x1, x1, l_.str.3@PAGEOFF
	bl	__ZNSt16invalid_argumentC1B9nqe210106EPKc
Ltmp4:
; %bb.13:
	mov	x0, x19
	bl	__Z8validateRK5Input.cold.1
LBB5_14:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp6:
Lloh6:
	adrp	x1, l_.str.2@PAGE
Lloh7:
	add	x1, x1, l_.str.2@PAGEOFF
	bl	__ZNSt16invalid_argumentC1B9nqe210106EPKc
Ltmp7:
; %bb.15:
	mov	x0, x19
	bl	__Z8validateRK5Input.cold.2
LBB5_16:
Ltmp8:
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x0, x20
	bl	__Unwind_Resume
LBB5_17:
Ltmp5:
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x0, x20
	bl	__Unwind_Resume
	.loh AdrpAdd	Lloh4, Lloh5
	.loh AdrpAdd	Lloh6, Lloh7
Lfunc_end1:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table5:
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
	.uleb128 Ltmp6-Ltmp4                    ;   Call between Ltmp4 and Ltmp6
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp6-Lfunc_begin1             ; >> Call Site 4 <<
	.uleb128 Ltmp7-Ltmp6                    ;   Call between Ltmp6 and Ltmp7
	.uleb128 Ltmp8-Lfunc_begin1             ;     jumps to Ltmp8
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp7-Lfunc_begin1             ; >> Call Site 5 <<
	.uleb128 Lfunc_end1-Ltmp7               ;   Call between Ltmp7 and Lfunc_end1
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
	.globl	__Z7groupedRK5InputPFiPKaS3_mE  ; -- Begin function _Z7groupedRK5InputPFiPKaS3_mE
	.p2align	2
__Z7groupedRK5InputPFiPKaS3_mE:         ; @_Z7groupedRK5InputPFiPKaS3_mE
	.cfi_startproc
; %bb.0:
	stp	d9, d8, [sp, #-64]!             ; 16-byte Folded Spill
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
	.cfi_offset b8, -56
	.cfi_offset b9, -64
	ldp	x8, x9, [x0]
	subs	x10, x9, x8
	b.eq	LBB7_4
; %bb.1:
	mov	x19, x1
	mov	x20, x0
	mov	x21, #0                         ; =0x0
	mov	x22, #0                         ; =0x0
	ldr	x9, [x0, #96]
	movi.2d	v8, #0000000000000000
LBB7_2:                                 ; =>This Inner Loop Header: Depth=1
	sub	x10, x10, x22
	cmp	x10, x9
	csel	x2, x10, x9, lo
	ldr	x9, [x20, #24]
	add	x0, x8, x22
	add	x1, x9, x22
	blr	x19
	scvtf	d0, w0
	ldr	x8, [x20, #48]
	ldr	s1, [x8, x21]
	fcvt	d1, s1
	fmul	d0, d0, d1
	ldr	x8, [x20, #72]
	ldr	s1, [x8, x21]
	fcvt	d1, s1
	fmadd	d8, d0, d1, d8
	ldr	x9, [x20, #96]
	add	x22, x9, x22
	ldp	x8, x10, [x20]
	add	x21, x21, #4
	sub	x10, x10, x8
	cmp	x22, x10
	b.lo	LBB7_2
; %bb.3:
	mov.16b	v0, v8
	ldp	x29, x30, [sp, #48]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #32]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #16]             ; 16-byte Folded Reload
	ldp	d9, d8, [sp], #64               ; 16-byte Folded Reload
	ret
LBB7_4:
	movi.2d	v8, #0000000000000000
	mov.16b	v0, v8
	ldp	x29, x30, [sp, #48]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #32]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #16]             ; 16-byte Folded Reload
	ldp	d9, d8, [sp], #64               ; 16-byte Folded Reload
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__Z6oracleRK5Input              ; -- Begin function _Z6oracleRK5Input
	.p2align	2
__Z6oracleRK5Input:                     ; @_Z6oracleRK5Input
	.cfi_startproc
; %bb.0:
	ldp	x8, x9, [x0]
	subs	x9, x9, x8
	b.eq	LBB8_4
; %bb.1:
	mov	x10, #0                         ; =0x0
	ldr	x11, [x0, #24]
	ldr	x12, [x0, #96]
	ldr	x13, [x0, #48]
	movi.2d	v0, #0000000000000000
	ldr	x14, [x0, #72]
LBB8_2:                                 ; =>This Inner Loop Header: Depth=1
	ldrsb	w15, [x8, x10]
	scvtf	d1, w15
	ldrsb	w15, [x11, x10]
	scvtf	d2, w15
	fmul	d1, d1, d2
	udiv	x15, x10, x12
	ldr	s2, [x13, x15, lsl #2]
	fcvt	d2, s2
	fmul	d1, d1, d2
	ldr	s2, [x14, x15, lsl #2]
	fcvt	d2, s2
	fmadd	d0, d1, d2, d0
	add	x10, x10, #1
	cmp	x9, x10
	b.ne	LBB8_2
; %bb.3:
	ret
LBB8_4:
	movi.2d	v0, #0000000000000000
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__Z5benchRK5InputPFiPKaS3_mEPKc ; -- Begin function _Z5benchRK5InputPFiPKaS3_mEPKc
	.p2align	2
__Z5benchRK5InputPFiPKaS3_mEPKc:        ; @_Z5benchRK5InputPFiPKaS3_mEPKc
Lfunc_begin2:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception2
; %bb.0:
	sub	sp, sp, #128
	stp	d9, d8, [sp, #16]               ; 16-byte Folded Spill
	stp	x28, x27, [sp, #32]             ; 16-byte Folded Spill
	stp	x26, x25, [sp, #48]             ; 16-byte Folded Spill
	stp	x24, x23, [sp, #64]             ; 16-byte Folded Spill
	stp	x22, x21, [sp, #80]             ; 16-byte Folded Spill
	stp	x20, x19, [sp, #96]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #112]            ; 16-byte Folded Spill
	add	x29, sp, #112
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
	str	x2, [sp]                        ; 8-byte Folded Spill
	mov	x22, x1
	mov	x21, x0
	bl	__Z7groupedRK5InputPFiPKaS3_mE
	adrp	x26, _sink@PAGE
	str	d0, [x26, _sink@PAGEOFF]
	mov	x0, x21
	mov	x1, x22
	bl	__Z7groupedRK5InputPFiPKaS3_mE
	str	d0, [x26, _sink@PAGEOFF]
	mov	x0, x21
	mov	x1, x22
	bl	__Z7groupedRK5InputPFiPKaS3_mE
	str	d0, [x26, _sink@PAGEOFF]
	mov	x0, x21
	mov	x1, x22
	bl	__Z7groupedRK5InputPFiPKaS3_mE
	str	d0, [x26, _sink@PAGEOFF]
	mov	x0, x21
	mov	x1, x22
	bl	__Z7groupedRK5InputPFiPKaS3_mE
	str	d0, [x26, _sink@PAGEOFF]
	mov	x0, x21
	mov	x1, x22
	bl	__Z7groupedRK5InputPFiPKaS3_mE
	str	d0, [x26, _sink@PAGEOFF]
	mov	x0, x21
	mov	x1, x22
	bl	__Z7groupedRK5InputPFiPKaS3_mE
	str	d0, [x26, _sink@PAGEOFF]
	mov	x0, x21
	mov	x1, x22
	bl	__Z7groupedRK5InputPFiPKaS3_mE
	str	d0, [x26, _sink@PAGEOFF]
	mov	x0, x21
	mov	x1, x22
	bl	__Z7groupedRK5InputPFiPKaS3_mE
	str	d0, [x26, _sink@PAGEOFF]
	mov	x0, x21
	mov	x1, x22
	bl	__Z7groupedRK5InputPFiPKaS3_mE
	str	d0, [x26, _sink@PAGEOFF]
	mov	x0, x21
	mov	x1, x22
	bl	__Z7groupedRK5InputPFiPKaS3_mE
	str	d0, [x26, _sink@PAGEOFF]
	mov	x0, x21
	mov	x1, x22
	bl	__Z7groupedRK5InputPFiPKaS3_mE
	str	d0, [x26, _sink@PAGEOFF]
	mov	x0, x21
	mov	x1, x22
	bl	__Z7groupedRK5InputPFiPKaS3_mE
	str	d0, [x26, _sink@PAGEOFF]
	mov	x0, x21
	mov	x1, x22
	bl	__Z7groupedRK5InputPFiPKaS3_mE
	str	d0, [x26, _sink@PAGEOFF]
	mov	x0, x21
	mov	x1, x22
	bl	__Z7groupedRK5InputPFiPKaS3_mE
	str	d0, [x26, _sink@PAGEOFF]
	mov	x0, x21
	mov	x1, x22
	bl	__Z7groupedRK5InputPFiPKaS3_mE
	str	d0, [x26, _sink@PAGEOFF]
	mov	x0, x21
	mov	x1, x22
	bl	__Z7groupedRK5InputPFiPKaS3_mE
	str	d0, [x26, _sink@PAGEOFF]
	mov	x0, x21
	mov	x1, x22
	bl	__Z7groupedRK5InputPFiPKaS3_mE
	str	d0, [x26, _sink@PAGEOFF]
	mov	x0, x21
	mov	x1, x22
	bl	__Z7groupedRK5InputPFiPKaS3_mE
	str	d0, [x26, _sink@PAGEOFF]
	mov	x0, x21
	mov	x1, x22
	bl	__Z7groupedRK5InputPFiPKaS3_mE
	mov	w27, #0                         ; =0x0
	mov	x20, #0                         ; =0x0
	mov	x23, #0                         ; =0x0
	mov	x28, #0                         ; =0x0
	str	d0, [x26, _sink@PAGEOFF]
	mov	x19, #4636737291354636288       ; =0x4059000000000000
	b	LBB9_2
LBB9_1:                                 ;   in Loop: Header=BB9_2 Depth=1
	str	d8, [x23], #8
	add	w27, w27, #1
	cmp	w27, #41
	b.eq	LBB9_12
LBB9_2:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB9_3 Depth 2
	mov	w25, #100                       ; =0x64
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x24, x0
LBB9_3:                                 ;   Parent Loop BB9_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
Ltmp9:
	mov	x0, x21
	mov	x1, x22
	bl	__Z7groupedRK5InputPFiPKaS3_mE
Ltmp10:
; %bb.4:                                ;   in Loop: Header=BB9_3 Depth=2
	str	d0, [x26, _sink@PAGEOFF]
	subs	w25, w25, #1
	b.ne	LBB9_3
; %bb.5:                                ;   in Loop: Header=BB9_2 Depth=1
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	sub	x8, x0, x24
	scvtf	d0, x8
	mov	x8, #70368744177664             ; =0x400000000000
	movk	x8, #16527, lsl #48
	fmov	d1, x8
	fdiv	d0, d0, d1
	fmov	d1, x19
	fdiv	d8, d0, d1
	cmp	x23, x28
	b.lo	LBB9_1
; %bb.6:                                ;   in Loop: Header=BB9_2 Depth=1
	sub	x24, x23, x20
	asr	x25, x24, #3
	add	x8, x25, #1
	lsr	x9, x8, #61
	cbnz	x9, LBB9_25
; %bb.7:                                ;   in Loop: Header=BB9_2 Depth=1
	sub	x9, x28, x20
	asr	x10, x9, #2
	cmp	x10, x8
	csel	x8, x10, x8, hi
	mov	x10, #9223372036854775800       ; =0x7ffffffffffffff8
	cmp	x9, x10
	mov	x9, #2305843009213693951        ; =0x1fffffffffffffff
	csel	x28, x8, x9, lo
	lsr	x8, x28, #61
	cbnz	x8, LBB9_26
; %bb.8:                                ;   in Loop: Header=BB9_2 Depth=1
	lsl	x0, x28, #3
Ltmp12:
	bl	__Znwm
Ltmp13:
; %bb.9:                                ;   in Loop: Header=BB9_2 Depth=1
	add	x23, x0, x24
	add	x28, x0, x28, lsl #3
	sub	x25, x23, x25, lsl #3
	str	d8, [x23], #8
	mov	x0, x25
	mov	x1, x20
	mov	x2, x24
	bl	_memcpy
	cbz	x20, LBB9_11
; %bb.10:                               ;   in Loop: Header=BB9_2 Depth=1
	mov	x0, x20
	bl	__ZdlPv
LBB9_11:                                ;   in Loop: Header=BB9_2 Depth=1
	mov	x20, x25
	add	w27, w27, #1
	cmp	w27, #41
	b.ne	LBB9_2
LBB9_12:
Ltmp20:
	add	x2, sp, #15
	mov	x0, x20
	mov	x1, x23
	bl	__ZNSt3__16__sortIRNS_6__lessIddEEPdEEvT0_S5_T_
Ltmp21:
; %bb.13:
Ltmp22:
Lloh10:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh11:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh12:
	adrp	x1, l_.str.4@PAGE
Lloh13:
	add	x1, x1, l_.str.4@PAGEOFF
	mov	w2, #2                          ; =0x2
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp23:
; %bb.14:
	ldp	x9, x8, [x21]
	sub	x1, x8, x9
Ltmp24:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp25:
; %bb.15:
Ltmp26:
Lloh14:
	adrp	x1, l_.str.5@PAGE
Lloh15:
	add	x1, x1, l_.str.5@PAGEOFF
	mov	w2, #7                          ; =0x7
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp27:
; %bb.16:
	ldr	x1, [x21, #96]
Ltmp28:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp29:
; %bb.17:
Ltmp30:
Lloh16:
	adrp	x1, l_.str.6@PAGE
Lloh17:
	add	x1, x1, l_.str.6@PAGEOFF
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp31:
; %bb.18:
	mov	x21, x0
	ldr	x19, [sp]                       ; 8-byte Folded Reload
	mov	x0, x19
	bl	_strlen
	mov	x2, x0
Ltmp32:
	mov	x0, x21
	mov	x1, x19
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp33:
; %bb.19:
Ltmp34:
Lloh18:
	adrp	x1, l_.str.7@PAGE
Lloh19:
	add	x1, x1, l_.str.7@PAGEOFF
	mov	w2, #23                         ; =0x17
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp35:
; %bb.20:
	ldr	d0, [x20, #160]
Ltmp36:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp37:
; %bb.21:
Ltmp38:
Lloh20:
	adrp	x1, l_.str.8@PAGE
Lloh21:
	add	x1, x1, l_.str.8@PAGEOFF
	mov	w2, #5                          ; =0x5
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp39:
; %bb.22:
	ldr	d0, [x20, #304]
Ltmp40:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp41:
; %bb.23:
Ltmp42:
Lloh22:
	adrp	x1, l_.str.9@PAGE
Lloh23:
	add	x1, x1, l_.str.9@PAGEOFF
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp43:
; %bb.24:
	mov	x0, x20
	bl	__ZdlPv
	ldp	x29, x30, [sp, #112]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #96]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #80]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #64]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #48]             ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #32]             ; 16-byte Folded Reload
	ldp	d9, d8, [sp, #16]               ; 16-byte Folded Reload
	add	sp, sp, #128
	ret
LBB9_25:
Ltmp17:
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_length_errorB9nqe210106Ev
Ltmp18:
	b	LBB9_27
LBB9_26:
Ltmp15:
	bl	__ZSt28__throw_bad_array_new_lengthB9nqe210106v
Ltmp16:
LBB9_27:
	brk	#0x1
LBB9_28:
Ltmp44:
	b	LBB9_32
LBB9_29:
Ltmp14:
	b	LBB9_32
LBB9_30:
Ltmp19:
	b	LBB9_32
LBB9_31:
Ltmp11:
LBB9_32:
	cbz	x20, LBB9_34
; %bb.33:
	mov	x19, x0
	mov	x0, x20
	bl	__ZdlPv
	mov	x0, x19
LBB9_34:
	bl	__Unwind_Resume
	.loh AdrpAdd	Lloh12, Lloh13
	.loh AdrpLdrGot	Lloh10, Lloh11
	.loh AdrpAdd	Lloh14, Lloh15
	.loh AdrpAdd	Lloh16, Lloh17
	.loh AdrpAdd	Lloh18, Lloh19
	.loh AdrpAdd	Lloh20, Lloh21
	.loh AdrpAdd	Lloh22, Lloh23
Lfunc_end2:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table9:
Lexception2:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end2-Lcst_begin2
Lcst_begin2:
	.uleb128 Lfunc_begin2-Lfunc_begin2      ; >> Call Site 1 <<
	.uleb128 Ltmp9-Lfunc_begin2             ;   Call between Lfunc_begin2 and Ltmp9
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp9-Lfunc_begin2             ; >> Call Site 2 <<
	.uleb128 Ltmp10-Ltmp9                   ;   Call between Ltmp9 and Ltmp10
	.uleb128 Ltmp11-Lfunc_begin2            ;     jumps to Ltmp11
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp12-Lfunc_begin2            ; >> Call Site 3 <<
	.uleb128 Ltmp13-Ltmp12                  ;   Call between Ltmp12 and Ltmp13
	.uleb128 Ltmp14-Lfunc_begin2            ;     jumps to Ltmp14
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp13-Lfunc_begin2            ; >> Call Site 4 <<
	.uleb128 Ltmp20-Ltmp13                  ;   Call between Ltmp13 and Ltmp20
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp20-Lfunc_begin2            ; >> Call Site 5 <<
	.uleb128 Ltmp43-Ltmp20                  ;   Call between Ltmp20 and Ltmp43
	.uleb128 Ltmp44-Lfunc_begin2            ;     jumps to Ltmp44
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp17-Lfunc_begin2            ; >> Call Site 6 <<
	.uleb128 Ltmp16-Ltmp17                  ;   Call between Ltmp17 and Ltmp16
	.uleb128 Ltmp19-Lfunc_begin2            ;     jumps to Ltmp19
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp16-Lfunc_begin2            ; >> Call Site 7 <<
	.uleb128 Lfunc_end2-Ltmp16              ;   Call between Ltmp16 and Lfunc_end2
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end2:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_main                           ; -- Begin function main
	.p2align	2
_main:                                  ; @main
Lfunc_begin3:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception3
; %bb.0:
	sub	sp, sp, #336
	stp	d9, d8, [sp, #224]              ; 16-byte Folded Spill
	stp	x28, x27, [sp, #240]            ; 16-byte Folded Spill
	stp	x26, x25, [sp, #256]            ; 16-byte Folded Spill
	stp	x24, x23, [sp, #272]            ; 16-byte Folded Spill
	stp	x22, x21, [sp, #288]            ; 16-byte Folded Spill
	stp	x20, x19, [sp, #304]            ; 16-byte Folded Spill
	stp	x29, x30, [sp, #320]            ; 16-byte Folded Spill
	add	x29, sp, #320
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
Lloh24:
	adrp	x8, ___stack_chk_guard@GOTPAGE
Lloh25:
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
Lloh26:
	ldr	x8, [x8]
	stur	x8, [x29, #-112]
	str	wzr, [sp, #104]
	mov	w8, #4                          ; =0x4
	str	x8, [sp]
Ltmp45:
Lloh27:
	adrp	x0, l_.str.1@PAGE
Lloh28:
	add	x0, x0, l_.str.1@PAGEOFF
	add	x1, sp, #104
	mov	x2, sp
	mov	x3, #0                          ; =0x0
	mov	x4, #0                          ; =0x0
	bl	_sysctlbyname
Ltmp46:
; %bb.1:
	cmp	w0, #0
	ldr	w8, [sp, #104]
	ccmp	w8, #0, #4, eq
	cset	w19, ne
Ltmp48:
Lloh29:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh30:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh31:
	adrp	x1, l_.str.10@PAGE
Lloh32:
	add	x1, x1, l_.str.10@PAGEOFF
	mov	w2, #16                         ; =0x10
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp49:
; %bb.2:
Ltmp50:
	mov	x1, x19
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEb
Ltmp51:
; %bb.3:
Ltmp52:
Lloh33:
	adrp	x1, l_.str.9@PAGE
Lloh34:
	add	x1, x1, l_.str.9@PAGEOFF
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp53:
; %bb.4:
	mov	x25, #0                         ; =0x0
Lloh35:
	adrp	x26, l_constinit@PAGE
Lloh36:
	add	x26, x26, l_constinit@PAGEOFF
Lloh37:
	adrp	x20, __Z6scalarPKaS0_m@PAGE
Lloh38:
	add	x20, x20, __Z6scalarPKaS0_m@PAGEOFF
	mov	x27, #-4097                     ; =0xffffffffffffefff
Lloh39:
	adrp	x21, __Z8wideningPKaS0_m@PAGE
Lloh40:
	add	x21, x21, __Z8wideningPKaS0_m@PAGEOFF
	mov	w28, #2139095039                ; =0x7f7fffff
Lloh41:
	adrp	x22, __Z7dotprodPKaS0_m@PAGE
Lloh42:
	add	x22, x22, __Z7dotprodPKaS0_m@PAGEOFF
	b	LBB10_6
LBB10_5:                                ;   in Loop: Header=BB10_6 Depth=1
	add	x25, x25, #4
	cmp	x25, #32
	b.eq	LBB10_45
LBB10_6:                                ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB10_8 Depth 2
                                        ;       Child Loop BB10_14 Depth 3
                                        ;       Child Loop BB10_21 Depth 3
	mov	x23, #0                         ; =0x0
	ldr	w24, [x26, x25]
	b	LBB10_8
LBB10_7:                                ;   in Loop: Header=BB10_8 Depth=2
	add	x23, x23, #1
	cmp	x23, #514
	b.eq	LBB10_5
LBB10_8:                                ;   Parent Loop BB10_6 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB10_14 Depth 3
                                        ;       Child Loop BB10_21 Depth 3
Ltmp55:
	mov	x0, sp
	mov	x1, x23
	mov	x2, x24
	bl	__ZN5InputC2Emm
Ltmp56:
; %bb.9:                                ;   in Loop: Header=BB10_8 Depth=2
	ldr	x8, [sp, #96]
	add	x9, x8, x27
	cmn	x9, #1, lsl #12                 ; =4096
	b.lo	LBB10_40
; %bb.10:                               ;   in Loop: Header=BB10_8 Depth=2
	ldp	x9, x14, [sp]
	sub	x10, x14, x9
	ldp	x11, x12, [sp, #24]
	sub	x12, x12, x11
	cmp	x10, x12
	b.ne	LBB10_40
; %bb.11:                               ;   in Loop: Header=BB10_8 Depth=2
	ldp	x12, x0, [sp, #48]
	sub	x16, x0, x12
	asr	x15, x16, #2
	udiv	x13, x10, x8
	msub	x17, x13, x8, x10
	cmp	x17, #0
	cinc	x13, x13, ne
	cmp	x15, x13
	b.ne	LBB10_40
; %bb.12:                               ;   in Loop: Header=BB10_8 Depth=2
	ldp	x13, x17, [sp, #72]
	sub	x17, x17, x13
	cmp	x17, x16
	b.ne	LBB10_40
; %bb.13:                               ;   in Loop: Header=BB10_8 Depth=2
	mov	x16, x12
	mov	x17, x13
	cmp	x0, x12
	b.eq	LBB10_19
LBB10_14:                               ;   Parent Loop BB10_6 Depth=1
                                        ;     Parent Loop BB10_8 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	ldr	s0, [x16], #4
	fmov	w0, s0
	and	w0, w0, #0x7fffffff
	cmp	w0, w28
	b.gt	LBB10_38
; %bb.15:                               ;   in Loop: Header=BB10_14 Depth=3
	ldr	s1, [x17], #4
	fmov	w0, s1
	and	w0, w0, #0x7fffffff
	cmp	w0, w28
	b.gt	LBB10_38
; %bb.16:                               ;   in Loop: Header=BB10_14 Depth=3
	fcmp	s0, #0.0
	b.mi	LBB10_38
; %bb.17:                               ;   in Loop: Header=BB10_14 Depth=3
	fcmp	s1, #0.0
	b.mi	LBB10_38
; %bb.18:                               ;   in Loop: Header=BB10_14 Depth=3
	subs	x15, x15, #1
	b.ne	LBB10_14
LBB10_19:                               ;   in Loop: Header=BB10_8 Depth=2
	cmp	x14, x9
	b.eq	LBB10_22
; %bb.20:                               ;   in Loop: Header=BB10_8 Depth=2
	mov	x14, #0                         ; =0x0
	movi.2d	v8, #0000000000000000
LBB10_21:                               ;   Parent Loop BB10_6 Depth=1
                                        ;     Parent Loop BB10_8 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	ldrsb	w15, [x9, x14]
	scvtf	d0, w15
	ldrsb	w15, [x11, x14]
	scvtf	d1, w15
	fmul	d0, d0, d1
	udiv	x15, x14, x8
	ldr	s1, [x12, x15, lsl #2]
	fcvt	d1, s1
	fmul	d0, d0, d1
	ldr	s1, [x13, x15, lsl #2]
	fcvt	d1, s1
	fmadd	d8, d0, d1, d8
	add	x14, x14, #1
	cmp	x10, x14
	b.ne	LBB10_21
	b	LBB10_23
LBB10_22:                               ;   in Loop: Header=BB10_8 Depth=2
	movi.2d	v8, #0000000000000000
LBB10_23:                               ;   in Loop: Header=BB10_8 Depth=2
Ltmp61:
	mov	x0, sp
	mov	x1, x20
	bl	__Z7groupedRK5InputPFiPKaS3_mE
Ltmp62:
; %bb.24:                               ;   in Loop: Header=BB10_8 Depth=2
	fcmp	d0, d8
	b.ne	LBB10_41
; %bb.25:                               ;   in Loop: Header=BB10_8 Depth=2
Ltmp66:
	mov	x0, sp
	mov	x1, x21
	bl	__Z7groupedRK5InputPFiPKaS3_mE
Ltmp67:
; %bb.26:                               ;   in Loop: Header=BB10_8 Depth=2
	fcmp	d0, d8
	b.ne	LBB10_42
; %bb.27:                               ;   in Loop: Header=BB10_8 Depth=2
	cbz	w19, LBB10_30
; %bb.28:                               ;   in Loop: Header=BB10_8 Depth=2
Ltmp71:
	mov	x0, sp
	mov	x1, x22
	bl	__Z7groupedRK5InputPFiPKaS3_mE
Ltmp72:
; %bb.29:                               ;   in Loop: Header=BB10_8 Depth=2
	fcmp	d0, d8
	b.ne	LBB10_43
LBB10_30:                               ;   in Loop: Header=BB10_8 Depth=2
	ldr	x0, [sp, #72]
	cbz	x0, LBB10_32
; %bb.31:                               ;   in Loop: Header=BB10_8 Depth=2
	str	x0, [sp, #80]
	bl	__ZdlPv
LBB10_32:                               ;   in Loop: Header=BB10_8 Depth=2
	ldr	x0, [sp, #48]
	cbz	x0, LBB10_34
; %bb.33:                               ;   in Loop: Header=BB10_8 Depth=2
	str	x0, [sp, #56]
	bl	__ZdlPv
LBB10_34:                               ;   in Loop: Header=BB10_8 Depth=2
	ldr	x0, [sp, #24]
	cbz	x0, LBB10_36
; %bb.35:                               ;   in Loop: Header=BB10_8 Depth=2
	str	x0, [sp, #32]
	bl	__ZdlPv
LBB10_36:                               ;   in Loop: Header=BB10_8 Depth=2
	ldr	x0, [sp]
	cbz	x0, LBB10_7
; %bb.37:                               ;   in Loop: Header=BB10_8 Depth=2
	str	x0, [sp, #8]
	bl	__ZdlPv
	b	LBB10_7
LBB10_38:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x21, x0
Ltmp58:
Lloh43:
	adrp	x1, l_.str.3@PAGE
Lloh44:
	add	x1, x1, l_.str.3@PAGEOFF
	bl	__ZNSt11logic_errorC2EPKc
Ltmp59:
LBB10_39:
Lloh45:
	adrp	x8, __ZTVSt16invalid_argument@GOTPAGE
Lloh46:
	ldr	x8, [x8, __ZTVSt16invalid_argument@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x21]
Ltmp199:
Lloh47:
	adrp	x1, __ZTISt16invalid_argument@GOTPAGE
Lloh48:
	ldr	x1, [x1, __ZTISt16invalid_argument@GOTPAGEOFF]
Lloh49:
	adrp	x2, __ZNSt16invalid_argumentD1Ev@GOTPAGE
Lloh50:
	ldr	x2, [x2, __ZNSt16invalid_argumentD1Ev@GOTPAGEOFF]
	mov	x0, x21
	bl	___cxa_throw
Ltmp200:
	b	LBB10_216
LBB10_40:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x21, x0
Ltmp196:
Lloh51:
	adrp	x1, l_.str.2@PAGE
Lloh52:
	add	x1, x1, l_.str.2@PAGEOFF
	bl	__ZNSt11logic_errorC2EPKc
Ltmp197:
	b	LBB10_39
LBB10_41:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x21, x0
Ltmp63:
Lloh53:
	adrp	x1, l_.str@PAGE
Lloh54:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp64:
	b	LBB10_44
LBB10_42:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x21, x0
Ltmp68:
Lloh55:
	adrp	x1, l_.str@PAGE
Lloh56:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp69:
	b	LBB10_44
LBB10_43:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x21, x0
Ltmp74:
Lloh57:
	adrp	x1, l_.str@PAGE
Lloh58:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp75:
LBB10_44:
Ltmp77:
Lloh59:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh60:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh61:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh62:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x21
	bl	___cxa_throw
Ltmp78:
	b	LBB10_216
LBB10_45:
	mov	x22, #0                         ; =0x0
	mov	x8, #4095                       ; =0xfff
	movk	x8, #4096, lsl #32
	mov	x9, #4097                       ; =0x1001
	movk	x9, #2, lsl #48
	stp	x8, x9, [sp, #104]
	add	x23, sp, #104
Lloh63:
	adrp	x20, __Z8wideningPKaS0_m@PAGE
Lloh64:
	add	x20, x20, __Z8wideningPKaS0_m@PAGEOFF
Lloh65:
	adrp	x21, __Z7dotprodPKaS0_m@PAGE
Lloh66:
	add	x21, x21, __Z7dotprodPKaS0_m@PAGEOFF
	b	LBB10_47
LBB10_46:                               ;   in Loop: Header=BB10_47 Depth=1
	add	x22, x22, #4
	cmp	x22, #16
	b.eq	LBB10_74
LBB10_47:                               ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB10_55 Depth 2
                                        ;     Child Loop BB10_62 Depth 2
	ldr	w1, [x23, x22]
Ltmp80:
	mov	x0, sp
	mov	w2, #4096                       ; =0x1000
	bl	__ZN5InputC2Emm
Ltmp81:
; %bb.48:                               ;   in Loop: Header=BB10_47 Depth=1
	ldp	x0, x8, [sp]
	sub	x2, x8, x0
	cmp	x2, #1
	b.lt	LBB10_50
; %bb.49:                               ;   in Loop: Header=BB10_47 Depth=1
	mov	w1, #128                        ; =0x80
	bl	_memset
LBB10_50:                               ;   in Loop: Header=BB10_47 Depth=1
	ldp	x0, x8, [sp, #24]
	sub	x2, x8, x0
	cmp	x2, #1
	b.lt	LBB10_52
; %bb.51:                               ;   in Loop: Header=BB10_47 Depth=1
	mov	w1, #128                        ; =0x80
	bl	_memset
LBB10_52:                               ;   in Loop: Header=BB10_47 Depth=1
Ltmp83:
	mov	x0, sp
	mov	x1, x20
	bl	__Z7groupedRK5InputPFiPKaS3_mE
Ltmp84:
; %bb.53:                               ;   in Loop: Header=BB10_47 Depth=1
	ldp	x8, x9, [sp]
	subs	x9, x9, x8
	b.eq	LBB10_57
; %bb.54:                               ;   in Loop: Header=BB10_47 Depth=1
	mov	x10, #0                         ; =0x0
	ldr	x11, [sp, #24]
	ldr	x12, [sp, #48]
	movi.2d	v1, #0000000000000000
	ldr	x13, [sp, #96]
	ldr	x14, [sp, #72]
LBB10_55:                               ;   Parent Loop BB10_47 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldrsb	w15, [x8, x10]
	scvtf	d2, w15
	ldrsb	w15, [x11, x10]
	scvtf	d3, w15
	fmul	d2, d2, d3
	udiv	x15, x10, x13
	ldr	s3, [x12, x15, lsl #2]
	fcvt	d3, s3
	fmul	d2, d2, d3
	ldr	s3, [x14, x15, lsl #2]
	fcvt	d3, s3
	fmadd	d1, d2, d3, d1
	add	x10, x10, #1
	cmp	x9, x10
	b.ne	LBB10_55
; %bb.56:                               ;   in Loop: Header=BB10_47 Depth=1
	fcmp	d0, d1
	b.eq	LBB10_58
	b	LBB10_73
LBB10_57:                               ;   in Loop: Header=BB10_47 Depth=1
	movi.2d	v1, #0000000000000000
	fcmp	d0, d1
	b.ne	LBB10_73
LBB10_58:                               ;   in Loop: Header=BB10_47 Depth=1
	cbz	w19, LBB10_65
; %bb.59:                               ;   in Loop: Header=BB10_47 Depth=1
Ltmp88:
	mov	x0, sp
	mov	x1, x21
	bl	__Z7groupedRK5InputPFiPKaS3_mE
Ltmp89:
; %bb.60:                               ;   in Loop: Header=BB10_47 Depth=1
	ldp	x8, x9, [sp]
	subs	x9, x9, x8
	b.eq	LBB10_64
; %bb.61:                               ;   in Loop: Header=BB10_47 Depth=1
	mov	x10, #0                         ; =0x0
	ldr	x11, [sp, #24]
	ldr	x12, [sp, #48]
	movi.2d	v1, #0000000000000000
	ldr	x13, [sp, #96]
	ldr	x14, [sp, #72]
LBB10_62:                               ;   Parent Loop BB10_47 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldrsb	w15, [x8, x10]
	scvtf	d2, w15
	ldrsb	w15, [x11, x10]
	scvtf	d3, w15
	fmul	d2, d2, d3
	udiv	x15, x10, x13
	ldr	s3, [x12, x15, lsl #2]
	fcvt	d3, s3
	fmul	d2, d2, d3
	ldr	s3, [x14, x15, lsl #2]
	fcvt	d3, s3
	fmadd	d1, d2, d3, d1
	add	x10, x10, #1
	cmp	x9, x10
	b.ne	LBB10_62
; %bb.63:                               ;   in Loop: Header=BB10_47 Depth=1
	fcmp	d0, d1
	b.eq	LBB10_65
	b	LBB10_88
LBB10_64:                               ;   in Loop: Header=BB10_47 Depth=1
	movi.2d	v1, #0000000000000000
	fcmp	d0, d1
	b.ne	LBB10_88
LBB10_65:                               ;   in Loop: Header=BB10_47 Depth=1
	ldr	x0, [sp, #72]
	cbz	x0, LBB10_67
; %bb.66:                               ;   in Loop: Header=BB10_47 Depth=1
	str	x0, [sp, #80]
	bl	__ZdlPv
LBB10_67:                               ;   in Loop: Header=BB10_47 Depth=1
	ldr	x0, [sp, #48]
	cbz	x0, LBB10_69
; %bb.68:                               ;   in Loop: Header=BB10_47 Depth=1
	str	x0, [sp, #56]
	bl	__ZdlPv
LBB10_69:                               ;   in Loop: Header=BB10_47 Depth=1
	ldr	x0, [sp, #24]
	cbz	x0, LBB10_71
; %bb.70:                               ;   in Loop: Header=BB10_47 Depth=1
	str	x0, [sp, #32]
	bl	__ZdlPv
LBB10_71:                               ;   in Loop: Header=BB10_47 Depth=1
	ldr	x0, [sp]
	cbz	x0, LBB10_46
; %bb.72:                               ;   in Loop: Header=BB10_47 Depth=1
	str	x0, [sp, #8]
	bl	__ZdlPv
	b	LBB10_46
LBB10_73:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x21, x0
Ltmp85:
Lloh67:
	adrp	x1, l_.str@PAGE
Lloh68:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp86:
	b	LBB10_89
LBB10_74:
Ltmp97:
	mov	x0, sp
	mov	w1, #33                         ; =0x21
	mov	w2, #32                         ; =0x20
	bl	__ZN5InputC2Emm
Ltmp98:
; %bb.75:
	str	xzr, [sp, #96]
Ltmp100:
	mov	x0, sp
	bl	__Z8validateRK5Input
Ltmp101:
; %bb.76:
	ldr	x0, [sp, #72]
	cbnz	x0, LBB10_90
; %bb.77:
	ldr	x0, [sp, #48]
	cbnz	x0, LBB10_91
LBB10_78:
	ldr	x0, [sp, #24]
	cbnz	x0, LBB10_92
LBB10_79:
	ldr	x0, [sp]
	cbz	x0, LBB10_81
LBB10_80:
	str	x0, [sp, #8]
	bl	__ZdlPv
LBB10_81:
	mov	w22, #0                         ; =0x0
LBB10_82:
Ltmp105:
	mov	x0, sp
	mov	w1, #33                         ; =0x21
	mov	w2, #32                         ; =0x20
	bl	__ZN5InputC2Emm
Ltmp106:
; %bb.83:
	ldr	x8, [sp, #32]
	sub	x8, x8, #1
	str	x8, [sp, #32]
Ltmp108:
	mov	x0, sp
	bl	__Z8validateRK5Input
Ltmp109:
; %bb.84:
	ldr	x0, [sp, #72]
	cbnz	x0, LBB10_93
; %bb.85:
	ldr	x0, [sp, #48]
	cbnz	x0, LBB10_94
LBB10_86:
	ldr	x0, [sp, #24]
	cbnz	x0, LBB10_95
LBB10_87:
	ldr	x0, [sp]
	cbnz	x0, LBB10_96
	b	LBB10_97
LBB10_88:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x21, x0
Ltmp91:
Lloh69:
	adrp	x1, l_.str@PAGE
Lloh70:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp92:
LBB10_89:
Ltmp94:
Lloh71:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh72:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh73:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh74:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x21
	bl	___cxa_throw
Ltmp95:
	b	LBB10_216
LBB10_90:
	str	x0, [sp, #80]
	bl	__ZdlPv
	ldr	x0, [sp, #48]
	cbz	x0, LBB10_78
LBB10_91:
	str	x0, [sp, #56]
	bl	__ZdlPv
	ldr	x0, [sp, #24]
	cbz	x0, LBB10_79
LBB10_92:
	str	x0, [sp, #32]
	bl	__ZdlPv
	ldr	x0, [sp]
	cbnz	x0, LBB10_80
	b	LBB10_81
LBB10_93:
	str	x0, [sp, #80]
	bl	__ZdlPv
	ldr	x0, [sp, #48]
	cbz	x0, LBB10_86
LBB10_94:
	str	x0, [sp, #56]
	bl	__ZdlPv
	ldr	x0, [sp, #24]
	cbz	x0, LBB10_87
LBB10_95:
	str	x0, [sp, #32]
	bl	__ZdlPv
	ldr	x0, [sp]
	cbz	x0, LBB10_97
LBB10_96:
	str	x0, [sp, #8]
	bl	__ZdlPv
LBB10_97:
Ltmp113:
	mov	x0, sp
	mov	w1, #33                         ; =0x21
	mov	w2, #32                         ; =0x20
	bl	__ZN5InputC2Emm
Ltmp114:
; %bb.98:
	ldr	x8, [sp, #48]
	mov	w9, #2143289344                 ; =0x7fc00000
	str	w9, [x8]
Ltmp116:
	mov	x0, sp
	bl	__Z8validateRK5Input
Ltmp117:
; %bb.99:
	ldr	x0, [sp, #72]
	cbnz	x0, LBB10_103
; %bb.100:
	ldr	x0, [sp, #48]
	cbnz	x0, LBB10_104
LBB10_101:
	ldr	x0, [sp, #24]
	cbnz	x0, LBB10_105
LBB10_102:
	ldr	x0, [sp]
	cbnz	x0, LBB10_106
	b	LBB10_107
LBB10_103:
	str	x0, [sp, #80]
	bl	__ZdlPv
	ldr	x0, [sp, #48]
	cbz	x0, LBB10_101
LBB10_104:
	str	x0, [sp, #56]
	bl	__ZdlPv
	ldr	x0, [sp, #24]
	cbz	x0, LBB10_102
LBB10_105:
	str	x0, [sp, #32]
	bl	__ZdlPv
	ldr	x0, [sp]
	cbz	x0, LBB10_107
LBB10_106:
	str	x0, [sp, #8]
	bl	__ZdlPv
LBB10_107:
Ltmp121:
	mov	x0, sp
	mov	w1, #33                         ; =0x21
	mov	w2, #32                         ; =0x20
	bl	__ZN5InputC2Emm
Ltmp122:
; %bb.108:
	ldr	x8, [sp, #72]
	mov	w9, #-1082130432                ; =0xbf800000
	str	w9, [x8]
Ltmp124:
	mov	x0, sp
	bl	__Z8validateRK5Input
Ltmp125:
; %bb.109:
	ldr	x0, [sp, #72]
	cbnz	x0, LBB10_113
; %bb.110:
	ldr	x0, [sp, #48]
	cbnz	x0, LBB10_114
LBB10_111:
	ldr	x0, [sp, #24]
	cbnz	x0, LBB10_115
LBB10_112:
	ldr	x0, [sp]
	cbnz	x0, LBB10_116
	b	LBB10_117
LBB10_113:
	str	x0, [sp, #80]
	bl	__ZdlPv
	ldr	x0, [sp, #48]
	cbz	x0, LBB10_111
LBB10_114:
	str	x0, [sp, #56]
	bl	__ZdlPv
	ldr	x0, [sp, #24]
	cbz	x0, LBB10_112
LBB10_115:
	str	x0, [sp, #32]
	bl	__ZdlPv
	ldr	x0, [sp]
	cbz	x0, LBB10_117
LBB10_116:
	str	x0, [sp, #8]
	bl	__ZdlPv
LBB10_117:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x20, x0
Ltmp190:
Lloh75:
	adrp	x1, l_.str@PAGE
Lloh76:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp191:
; %bb.118:
Ltmp193:
Lloh77:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh78:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh79:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh80:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x20
	bl	___cxa_throw
Ltmp194:
	b	LBB10_216
LBB10_119:
Ltmp195:
	mov	x19, x1
	b	LBB10_261
LBB10_120:
Ltmp192:
	mov	x19, x1
	mov	x21, x0
	mov	x0, x20
	bl	___cxa_free_exception
	mov	x0, x21
	b	LBB10_261
LBB10_121:
Ltmp126:
	mov	x20, x1
	mov	x21, x0
	mov	x0, sp
	bl	__ZN5InputD1Ev
	b	LBB10_123
LBB10_122:
Ltmp123:
	mov	x20, x1
	mov	x21, x0
LBB10_123:
	cmp	w20, #2
	b.ne	LBB10_239
; %bb.124:
	mov	x0, x21
	bl	___cxa_begin_catch
Ltmp127:
	bl	___cxa_end_catch
Ltmp128:
; %bb.125:
	cmp	w22, #3
	b.ne	LBB10_117
; %bb.126:
Ltmp130:
	mov	x0, sp
	mov	w1, #64                         ; =0x40
	mov	w2, #32                         ; =0x20
	bl	__ZN5InputC2Emm
Ltmp131:
; %bb.127:
	ldp	x0, x8, [sp]
	sub	x2, x8, x0
	cmp	x2, #1
	b.lt	LBB10_129
; %bb.128:
	mov	w1, #1                          ; =0x1
	bl	_memset
LBB10_129:
	ldp	x0, x8, [sp, #24]
	sub	x2, x8, x0
	cmp	x2, #1
	b.lt	LBB10_131
; %bb.130:
	mov	w1, #1                          ; =0x1
	bl	_memset
LBB10_131:
	mov	x8, #1065353216                 ; =0x3f800000
	movk	x8, #16672, lsl #48
	str	x8, [sp, #104]
	ldr	x8, [sp, #64]
	ldr	x20, [sp, #48]
	sub	x9, x8, x20
	cmp	x9, #5
	b.hs	LBB10_137
; %bb.132:
	cbz	x20, LBB10_134
; %bb.133:
	mov	x21, sp
	str	x20, [sp, #56]
	mov	x0, x20
	bl	__ZdlPv
	mov	x8, #0                          ; =0x0
	stp	xzr, xzr, [x21, #48]
	stur	xzr, [x21, #64]
LBB10_134:
	asr	x9, x8, #1
	mov	w10, #2                         ; =0x2
	cmp	x9, #2
	csel	x9, x9, x10, hi
	mov	x10, #9223372036854775804       ; =0x7ffffffffffffffc
	mov	x11, #4611686018427387903       ; =0x3fffffffffffffff
	cmp	x8, x10
	csel	x20, x9, x11, lo
	lsr	x8, x20, #62
	cbnz	x8, LBB10_211
; %bb.135:
	lsl	x0, x20, #2
Ltmp133:
	bl	__Znwm
Ltmp134:
; %bb.136:
	add	x9, x0, x20, lsl #2
	str	x0, [sp, #48]
	ldr	x8, [sp, #104]
	str	x8, [x0], #8
	stp	x0, x9, [sp, #56]
	b	LBB10_143
LBB10_137:
	ldr	x23, [sp, #56]
	sub	x21, x23, x20
	cmp	x21, #4
	b.hi	LBB10_140
; %bb.138:
	cmp	x23, x20
	b.eq	LBB10_141
; %bb.139:
	add	x1, sp, #104
	mov	x0, x20
	mov	x2, x21
	bl	_memcpy
	ldr	x22, [sp, #56]
	b	LBB10_142
LBB10_140:
	ldr	x8, [sp, #104]
	str	x8, [x20], #8
	str	x20, [sp, #56]
	b	LBB10_143
LBB10_141:
	mov	x22, x23
LBB10_142:
	add	x8, sp, #104
	sub	x9, x20, x23
	add	x9, x9, #4
	and	x9, x9, #0xfffffffffffffffc
	add	x20, x9, #4
	add	x1, x8, x21
	mov	x0, x22
	mov	x2, x20
	bl	_memcpy
	add	x8, x22, x20
	sub	x8, x8, x22
	add	x8, x22, x8
	str	x8, [sp, #56]
LBB10_143:
	mov	x8, #1065353216                 ; =0x3f800000
	movk	x8, #16384, lsl #48
	str	x8, [sp, #104]
	ldr	x8, [sp, #88]
	ldr	x20, [sp, #72]
	sub	x9, x8, x20
	cmp	x9, #5
	b.hs	LBB10_149
; %bb.144:
	cbz	x20, LBB10_146
; %bb.145:
	mov	x21, sp
	str	x20, [sp, #80]
	mov	x0, x20
	bl	__ZdlPv
	mov	x8, #0                          ; =0x0
	stp	xzr, xzr, [x21, #72]
	stur	xzr, [x21, #88]
LBB10_146:
	asr	x9, x8, #1
	mov	w10, #2                         ; =0x2
	cmp	x9, #2
	csel	x9, x9, x10, hi
	mov	x10, #9223372036854775804       ; =0x7ffffffffffffffc
	mov	x11, #4611686018427387903       ; =0x3fffffffffffffff
	cmp	x8, x10
	csel	x20, x9, x11, lo
	lsr	x8, x20, #62
	cbnz	x8, LBB10_212
; %bb.147:
	lsl	x0, x20, #2
Ltmp135:
	bl	__Znwm
Ltmp136:
; %bb.148:
	add	x9, x0, x20, lsl #2
	str	x0, [sp, #72]
	ldr	x8, [sp, #104]
	str	x8, [x0], #8
	stp	x0, x9, [sp, #80]
	b	LBB10_155
LBB10_149:
	ldr	x23, [sp, #80]
	sub	x21, x23, x20
	cmp	x21, #4
	b.hi	LBB10_152
; %bb.150:
	cmp	x23, x20
	b.eq	LBB10_153
; %bb.151:
	add	x1, sp, #104
	mov	x0, x20
	mov	x2, x21
	bl	_memcpy
	ldr	x22, [sp, #80]
	b	LBB10_154
LBB10_152:
	ldr	x8, [sp, #104]
	str	x8, [x20], #8
	str	x20, [sp, #80]
	b	LBB10_155
LBB10_153:
	mov	x22, x23
LBB10_154:
	add	x8, sp, #104
	sub	x9, x20, x23
	add	x9, x9, #4
	and	x9, x9, #0xfffffffffffffffc
	add	x20, x9, #4
	add	x1, x8, x21
	mov	x0, x22
	mov	x2, x20
	bl	_memcpy
	add	x8, x22, x20
	sub	x8, x8, x22
	add	x8, x22, x8
	str	x8, [sp, #80]
LBB10_155:
Ltmp137:
Lloh81:
	adrp	x1, __Z8wideningPKaS0_m@PAGE
Lloh82:
	add	x1, x1, __Z8wideningPKaS0_m@PAGEOFF
	mov	x0, sp
	bl	__Z7groupedRK5InputPFiPKaS3_mE
Ltmp138:
; %bb.156:
	mov	x8, #4649122190329905152        ; =0x4085000000000000
	fmov	d1, x8
	fcmp	d0, d1
	b.ne	LBB10_213
; %bb.157:
	ldr	x0, [sp]
	ldr	x1, [sp, #24]
	mov	w2, #64                         ; =0x40
	bl	__Z6scalarPKaS0_m
	cmp	w0, #64
	b.ne	LBB10_214
; %bb.158:
Ltmp147:
Lloh83:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh84:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh85:
	adrp	x1, l_.str.11@PAGE
Lloh86:
	add	x1, x1, l_.str.11@PAGEOFF
	mov	w2, #11                         ; =0xb
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp148:
; %bb.159:
Ltmp149:
	mov	w1, #4116                       ; =0x1014
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp150:
; %bb.160:
Ltmp151:
Lloh87:
	adrp	x1, l_.str.12@PAGE
Lloh88:
	add	x1, x1, l_.str.12@PAGEOFF
	mov	w2, #10                         ; =0xa
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp152:
; %bb.161:
Ltmp153:
	mov	w1, #4                          ; =0x4
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEi
Ltmp154:
; %bb.162:
Ltmp155:
Lloh89:
	adrp	x1, l_.str.13@PAGE
Lloh90:
	add	x1, x1, l_.str.13@PAGEOFF
	mov	w2, #32                         ; =0x20
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp156:
; %bb.163:
Ltmp158:
	add	x0, sp, #104
	mov	w1, #17                         ; =0x11
	mov	w2, #32                         ; =0x20
	bl	__ZN5InputC2Emm
Ltmp159:
; %bb.164:
Ltmp160:
Lloh91:
	adrp	x1, __Z6scalarPKaS0_m@PAGE
Lloh92:
	add	x1, x1, __Z6scalarPKaS0_m@PAGEOFF
Lloh93:
	adrp	x2, l_.str.14@PAGE
Lloh94:
	add	x2, x2, l_.str.14@PAGEOFF
	add	x0, sp, #104
	bl	__Z5benchRK5InputPFiPKaS3_mEPKc
Ltmp161:
; %bb.165:
Ltmp162:
Lloh95:
	adrp	x1, __Z8wideningPKaS0_m@PAGE
Lloh96:
	add	x1, x1, __Z8wideningPKaS0_m@PAGEOFF
Lloh97:
	adrp	x2, l_.str.15@PAGE
Lloh98:
	add	x2, x2, l_.str.15@PAGEOFF
	add	x0, sp, #104
	bl	__Z5benchRK5InputPFiPKaS3_mEPKc
Ltmp163:
; %bb.166:
	cbz	w19, LBB10_168
; %bb.167:
Ltmp164:
Lloh99:
	adrp	x1, __Z7dotprodPKaS0_m@PAGE
Lloh100:
	add	x1, x1, __Z7dotprodPKaS0_m@PAGEOFF
Lloh101:
	adrp	x2, l_.str.16@PAGE
Lloh102:
	add	x2, x2, l_.str.16@PAGEOFF
	add	x0, sp, #104
	bl	__Z5benchRK5InputPFiPKaS3_mEPKc
Ltmp165:
LBB10_168:
	ldr	x0, [sp, #176]
	cbz	x0, LBB10_170
; %bb.169:
	str	x0, [sp, #184]
	bl	__ZdlPv
LBB10_170:
	ldr	x0, [sp, #152]
	cbz	x0, LBB10_172
; %bb.171:
	str	x0, [sp, #160]
	bl	__ZdlPv
LBB10_172:
	ldr	x0, [sp, #128]
	cbz	x0, LBB10_174
; %bb.173:
	str	x0, [sp, #136]
	bl	__ZdlPv
LBB10_174:
	ldr	x0, [sp, #104]
	cbz	x0, LBB10_176
; %bb.175:
	str	x0, [sp, #112]
	bl	__ZdlPv
LBB10_176:
Ltmp166:
	add	x0, sp, #104
	mov	w1, #4099                       ; =0x1003
	mov	w2, #32                         ; =0x20
	bl	__ZN5InputC2Emm
Ltmp167:
; %bb.177:
Ltmp168:
Lloh103:
	adrp	x1, __Z6scalarPKaS0_m@PAGE
Lloh104:
	add	x1, x1, __Z6scalarPKaS0_m@PAGEOFF
Lloh105:
	adrp	x2, l_.str.14@PAGE
Lloh106:
	add	x2, x2, l_.str.14@PAGEOFF
	add	x0, sp, #104
	bl	__Z5benchRK5InputPFiPKaS3_mEPKc
Ltmp169:
; %bb.178:
Ltmp170:
Lloh107:
	adrp	x1, __Z8wideningPKaS0_m@PAGE
Lloh108:
	add	x1, x1, __Z8wideningPKaS0_m@PAGEOFF
Lloh109:
	adrp	x2, l_.str.15@PAGE
Lloh110:
	add	x2, x2, l_.str.15@PAGEOFF
	add	x0, sp, #104
	bl	__Z5benchRK5InputPFiPKaS3_mEPKc
Ltmp171:
; %bb.179:
	cbz	w19, LBB10_181
; %bb.180:
Ltmp172:
Lloh111:
	adrp	x1, __Z7dotprodPKaS0_m@PAGE
Lloh112:
	add	x1, x1, __Z7dotprodPKaS0_m@PAGEOFF
Lloh113:
	adrp	x2, l_.str.16@PAGE
Lloh114:
	add	x2, x2, l_.str.16@PAGEOFF
	add	x0, sp, #104
	bl	__Z5benchRK5InputPFiPKaS3_mEPKc
Ltmp173:
LBB10_181:
	ldr	x0, [sp, #176]
	cbz	x0, LBB10_183
; %bb.182:
	str	x0, [sp, #184]
	bl	__ZdlPv
LBB10_183:
	ldr	x0, [sp, #152]
	cbz	x0, LBB10_185
; %bb.184:
	str	x0, [sp, #160]
	bl	__ZdlPv
LBB10_185:
	ldr	x0, [sp, #128]
	cbz	x0, LBB10_187
; %bb.186:
	str	x0, [sp, #136]
	bl	__ZdlPv
LBB10_187:
	ldr	x0, [sp, #104]
	cbz	x0, LBB10_189
; %bb.188:
	str	x0, [sp, #112]
	bl	__ZdlPv
LBB10_189:
Ltmp174:
	add	x0, sp, #104
	mov	w1, #3                          ; =0x3
	movk	w1, #1, lsl #16
	mov	w2, #32                         ; =0x20
	bl	__ZN5InputC2Emm
Ltmp175:
; %bb.190:
Ltmp177:
Lloh115:
	adrp	x1, __Z6scalarPKaS0_m@PAGE
Lloh116:
	add	x1, x1, __Z6scalarPKaS0_m@PAGEOFF
Lloh117:
	adrp	x2, l_.str.14@PAGE
Lloh118:
	add	x2, x2, l_.str.14@PAGEOFF
	add	x0, sp, #104
	bl	__Z5benchRK5InputPFiPKaS3_mEPKc
Ltmp178:
; %bb.191:
Ltmp179:
Lloh119:
	adrp	x1, __Z8wideningPKaS0_m@PAGE
Lloh120:
	add	x1, x1, __Z8wideningPKaS0_m@PAGEOFF
Lloh121:
	adrp	x2, l_.str.15@PAGE
Lloh122:
	add	x2, x2, l_.str.15@PAGEOFF
	add	x0, sp, #104
	bl	__Z5benchRK5InputPFiPKaS3_mEPKc
Ltmp180:
; %bb.192:
	cbz	w19, LBB10_194
; %bb.193:
Ltmp181:
Lloh123:
	adrp	x1, __Z7dotprodPKaS0_m@PAGE
Lloh124:
	add	x1, x1, __Z7dotprodPKaS0_m@PAGEOFF
Lloh125:
	adrp	x2, l_.str.16@PAGE
Lloh126:
	add	x2, x2, l_.str.16@PAGEOFF
	add	x0, sp, #104
	bl	__Z5benchRK5InputPFiPKaS3_mEPKc
Ltmp182:
LBB10_194:
	ldr	x0, [sp, #176]
	cbz	x0, LBB10_196
; %bb.195:
	str	x0, [sp, #184]
	bl	__ZdlPv
LBB10_196:
	ldr	x0, [sp, #152]
	cbz	x0, LBB10_198
; %bb.197:
	str	x0, [sp, #160]
	bl	__ZdlPv
LBB10_198:
	ldr	x0, [sp, #128]
	cbz	x0, LBB10_200
; %bb.199:
	str	x0, [sp, #136]
	bl	__ZdlPv
LBB10_200:
	ldr	x0, [sp, #104]
	cbz	x0, LBB10_202
; %bb.201:
	str	x0, [sp, #112]
	bl	__ZdlPv
LBB10_202:
	ldr	x0, [sp, #72]
	cbz	x0, LBB10_204
; %bb.203:
	str	x0, [sp, #80]
	bl	__ZdlPv
LBB10_204:
	ldr	x0, [sp, #48]
	cbz	x0, LBB10_206
; %bb.205:
	str	x0, [sp, #56]
	bl	__ZdlPv
LBB10_206:
	ldr	x0, [sp, #24]
	cbz	x0, LBB10_208
; %bb.207:
	str	x0, [sp, #32]
	bl	__ZdlPv
LBB10_208:
	ldr	x0, [sp]
	cbz	x0, LBB10_210
; %bb.209:
	str	x0, [sp, #8]
	bl	__ZdlPv
LBB10_210:
	mov	w0, #0                          ; =0x0
	b	LBB10_269
LBB10_211:
Ltmp187:
	bl	__ZNSt3__16vectorIfNS_9allocatorIfEEE20__throw_length_errorB9nqe210106Ev
Ltmp188:
	b	LBB10_216
LBB10_212:
Ltmp184:
	bl	__ZNSt3__16vectorIfNS_9allocatorIfEEE20__throw_length_errorB9nqe210106Ev
Ltmp185:
	b	LBB10_216
LBB10_213:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x21, x0
Ltmp139:
Lloh127:
	adrp	x1, l_.str@PAGE
Lloh128:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp140:
	b	LBB10_215
LBB10_214:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x21, x0
Ltmp142:
Lloh129:
	adrp	x1, l_.str@PAGE
Lloh130:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp143:
LBB10_215:
Ltmp145:
Lloh131:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh132:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh133:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh134:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x21
	bl	___cxa_throw
Ltmp146:
LBB10_216:
	brk	#0x1
LBB10_217:
Ltmp157:
	b	LBB10_258
LBB10_218:
Ltmp144:
	b	LBB10_256
LBB10_219:
Ltmp141:
	b	LBB10_256
LBB10_220:
Ltmp186:
	b	LBB10_258
LBB10_221:
Ltmp189:
	b	LBB10_258
LBB10_222:
Ltmp183:
	mov	x19, x1
	mov	x20, x0
	add	x0, sp, #104
	bl	__ZN5InputD1Ev
	b	LBB10_259
LBB10_223:
Ltmp176:
	b	LBB10_258
LBB10_224:
Ltmp132:
	b	LBB10_246
LBB10_225:
Ltmp118:
	mov	x20, x1
	mov	x21, x0
	mov	x0, sp
	bl	__ZN5InputD1Ev
	b	LBB10_227
LBB10_226:
Ltmp115:
	mov	x20, x1
	mov	x21, x0
LBB10_227:
	cmp	w20, #2
	b.ne	LBB10_239
; %bb.228:
	mov	x0, x21
	bl	___cxa_begin_catch
Ltmp119:
	bl	___cxa_end_catch
Ltmp120:
; %bb.229:
	add	w22, w22, #1
	b	LBB10_107
LBB10_230:
Ltmp110:
	mov	x20, x1
	mov	x21, x0
	mov	x0, sp
	bl	__ZN5InputD1Ev
	b	LBB10_232
LBB10_231:
Ltmp107:
	mov	x20, x1
	mov	x21, x0
LBB10_232:
	cmp	w20, #2
	b.ne	LBB10_239
; %bb.233:
	mov	x0, x21
	bl	___cxa_begin_catch
Ltmp111:
	bl	___cxa_end_catch
Ltmp112:
; %bb.234:
	add	w22, w22, #1
	b	LBB10_97
LBB10_235:
Ltmp93:
	b	LBB10_256
LBB10_236:
Ltmp102:
	mov	x20, x1
	mov	x21, x0
	mov	x0, sp
	bl	__ZN5InputD1Ev
	b	LBB10_238
LBB10_237:
Ltmp99:
	mov	x20, x1
	mov	x21, x0
LBB10_238:
	cmp	w20, #2
	b.eq	LBB10_240
LBB10_239:
	mov	x0, x21
	mov	x1, x20
	b	LBB10_264
LBB10_240:
	mov	x0, x21
	bl	___cxa_begin_catch
Ltmp103:
	bl	___cxa_end_catch
Ltmp104:
; %bb.241:
	mov	w22, #1                         ; =0x1
	b	LBB10_82
LBB10_242:
Ltmp129:
	b	LBB10_264
LBB10_243:
Ltmp87:
	b	LBB10_256
LBB10_244:
Ltmp96:
	b	LBB10_258
LBB10_245:
Ltmp82:
LBB10_246:
	mov	x19, x1
	mov	x20, x0
	b	LBB10_260
LBB10_247:
Ltmp90:
	b	LBB10_258
LBB10_248:
Ltmp76:
	b	LBB10_256
LBB10_249:
Ltmp70:
	b	LBB10_256
LBB10_250:
Ltmp65:
	b	LBB10_256
LBB10_251:
Ltmp57:
	b	LBB10_264
LBB10_252:
Ltmp79:
	b	LBB10_258
LBB10_253:
Ltmp198:
	b	LBB10_256
LBB10_254:
Ltmp73:
	b	LBB10_258
LBB10_255:
Ltmp60:
LBB10_256:
	mov	x19, x1
	mov	x20, x0
	mov	x0, x21
	bl	___cxa_free_exception
	b	LBB10_259
LBB10_257:
Ltmp201:
LBB10_258:
	mov	x19, x1
	mov	x20, x0
LBB10_259:
	mov	x0, sp
	bl	__ZN5InputD1Ev
LBB10_260:
	mov	x0, x20
LBB10_261:
	mov	x1, x19
	b	LBB10_264
LBB10_262:
Ltmp54:
	b	LBB10_264
LBB10_263:
Ltmp47:
LBB10_264:
	cmp	w1, #1
	b.ne	LBB10_273
; %bb.265:
	bl	___cxa_begin_catch
	ldr	x8, [x0]
	ldr	x8, [x8, #16]
	blr	x8
	mov	x19, x0
	bl	_strlen
	mov	x2, x0
Ltmp202:
Lloh135:
	adrp	x0, __ZNSt3__14cerrE@GOTPAGE
Lloh136:
	ldr	x0, [x0, __ZNSt3__14cerrE@GOTPAGEOFF]
	mov	x1, x19
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp203:
; %bb.266:
Ltmp204:
Lloh137:
	adrp	x1, l_.str.9@PAGE
Lloh138:
	add	x1, x1, l_.str.9@PAGEOFF
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp205:
; %bb.267:
Ltmp210:
	bl	___cxa_end_catch
Ltmp211:
; %bb.268:
	mov	w0, #1                          ; =0x1
LBB10_269:
	ldur	x8, [x29, #-112]
Lloh139:
	adrp	x9, ___stack_chk_guard@GOTPAGE
Lloh140:
	ldr	x9, [x9, ___stack_chk_guard@GOTPAGEOFF]
Lloh141:
	ldr	x9, [x9]
	cmp	x9, x8
	b.ne	LBB10_271
; %bb.270:
	ldp	x29, x30, [sp, #320]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #304]            ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #288]            ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #272]            ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #256]            ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #240]            ; 16-byte Folded Reload
	ldp	d9, d8, [sp, #224]              ; 16-byte Folded Reload
	add	sp, sp, #336
	ret
LBB10_271:
	bl	___stack_chk_fail
LBB10_272:
Ltmp212:
LBB10_273:
	bl	__Unwind_Resume
LBB10_274:
Ltmp206:
	mov	x19, x0
Ltmp207:
	bl	___cxa_end_catch
Ltmp208:
	b	LBB10_276
LBB10_275:
Ltmp209:
	mov	x19, x0
	cbnz	w1, LBB10_277
LBB10_276:
	mov	x0, x19
	bl	__Unwind_Resume
LBB10_277:
	mov	x0, x19
	bl	___clang_call_terminate
	.loh AdrpAdd	Lloh27, Lloh28
	.loh AdrpLdrGotLdr	Lloh24, Lloh25, Lloh26
	.loh AdrpAdd	Lloh31, Lloh32
	.loh AdrpLdrGot	Lloh29, Lloh30
	.loh AdrpAdd	Lloh33, Lloh34
	.loh AdrpAdd	Lloh41, Lloh42
	.loh AdrpAdd	Lloh39, Lloh40
	.loh AdrpAdd	Lloh37, Lloh38
	.loh AdrpAdd	Lloh35, Lloh36
	.loh AdrpAdd	Lloh43, Lloh44
	.loh AdrpLdrGot	Lloh49, Lloh50
	.loh AdrpLdrGot	Lloh47, Lloh48
	.loh AdrpLdrGot	Lloh45, Lloh46
	.loh AdrpAdd	Lloh51, Lloh52
	.loh AdrpAdd	Lloh53, Lloh54
	.loh AdrpAdd	Lloh55, Lloh56
	.loh AdrpAdd	Lloh57, Lloh58
	.loh AdrpLdrGot	Lloh61, Lloh62
	.loh AdrpLdrGot	Lloh59, Lloh60
	.loh AdrpAdd	Lloh65, Lloh66
	.loh AdrpAdd	Lloh63, Lloh64
	.loh AdrpAdd	Lloh67, Lloh68
	.loh AdrpAdd	Lloh69, Lloh70
	.loh AdrpLdrGot	Lloh73, Lloh74
	.loh AdrpLdrGot	Lloh71, Lloh72
	.loh AdrpAdd	Lloh75, Lloh76
	.loh AdrpLdrGot	Lloh79, Lloh80
	.loh AdrpLdrGot	Lloh77, Lloh78
	.loh AdrpAdd	Lloh81, Lloh82
	.loh AdrpAdd	Lloh85, Lloh86
	.loh AdrpLdrGot	Lloh83, Lloh84
	.loh AdrpAdd	Lloh87, Lloh88
	.loh AdrpAdd	Lloh89, Lloh90
	.loh AdrpAdd	Lloh93, Lloh94
	.loh AdrpAdd	Lloh91, Lloh92
	.loh AdrpAdd	Lloh97, Lloh98
	.loh AdrpAdd	Lloh95, Lloh96
	.loh AdrpAdd	Lloh101, Lloh102
	.loh AdrpAdd	Lloh99, Lloh100
	.loh AdrpAdd	Lloh105, Lloh106
	.loh AdrpAdd	Lloh103, Lloh104
	.loh AdrpAdd	Lloh109, Lloh110
	.loh AdrpAdd	Lloh107, Lloh108
	.loh AdrpAdd	Lloh113, Lloh114
	.loh AdrpAdd	Lloh111, Lloh112
	.loh AdrpAdd	Lloh117, Lloh118
	.loh AdrpAdd	Lloh115, Lloh116
	.loh AdrpAdd	Lloh121, Lloh122
	.loh AdrpAdd	Lloh119, Lloh120
	.loh AdrpAdd	Lloh125, Lloh126
	.loh AdrpAdd	Lloh123, Lloh124
	.loh AdrpAdd	Lloh127, Lloh128
	.loh AdrpAdd	Lloh129, Lloh130
	.loh AdrpLdrGot	Lloh133, Lloh134
	.loh AdrpLdrGot	Lloh131, Lloh132
	.loh AdrpLdrGot	Lloh135, Lloh136
	.loh AdrpAdd	Lloh137, Lloh138
	.loh AdrpLdrGotLdr	Lloh139, Lloh140, Lloh141
Lfunc_end3:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table10:
Lexception3:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase0-Lttbaseref0
Lttbaseref0:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end3-Lcst_begin3
Lcst_begin3:
	.uleb128 Ltmp45-Lfunc_begin3            ; >> Call Site 1 <<
	.uleb128 Ltmp46-Ltmp45                  ;   Call between Ltmp45 and Ltmp46
	.uleb128 Ltmp47-Lfunc_begin3            ;     jumps to Ltmp47
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp48-Lfunc_begin3            ; >> Call Site 2 <<
	.uleb128 Ltmp53-Ltmp48                  ;   Call between Ltmp48 and Ltmp53
	.uleb128 Ltmp54-Lfunc_begin3            ;     jumps to Ltmp54
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp55-Lfunc_begin3            ; >> Call Site 3 <<
	.uleb128 Ltmp56-Ltmp55                  ;   Call between Ltmp55 and Ltmp56
	.uleb128 Ltmp57-Lfunc_begin3            ;     jumps to Ltmp57
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp61-Lfunc_begin3            ; >> Call Site 4 <<
	.uleb128 Ltmp72-Ltmp61                  ;   Call between Ltmp61 and Ltmp72
	.uleb128 Ltmp73-Lfunc_begin3            ;     jumps to Ltmp73
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp72-Lfunc_begin3            ; >> Call Site 5 <<
	.uleb128 Ltmp58-Ltmp72                  ;   Call between Ltmp72 and Ltmp58
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp58-Lfunc_begin3            ; >> Call Site 6 <<
	.uleb128 Ltmp59-Ltmp58                  ;   Call between Ltmp58 and Ltmp59
	.uleb128 Ltmp60-Lfunc_begin3            ;     jumps to Ltmp60
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp199-Lfunc_begin3           ; >> Call Site 7 <<
	.uleb128 Ltmp200-Ltmp199                ;   Call between Ltmp199 and Ltmp200
	.uleb128 Ltmp201-Lfunc_begin3           ;     jumps to Ltmp201
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp200-Lfunc_begin3           ; >> Call Site 8 <<
	.uleb128 Ltmp196-Ltmp200                ;   Call between Ltmp200 and Ltmp196
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp196-Lfunc_begin3           ; >> Call Site 9 <<
	.uleb128 Ltmp197-Ltmp196                ;   Call between Ltmp196 and Ltmp197
	.uleb128 Ltmp198-Lfunc_begin3           ;     jumps to Ltmp198
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp197-Lfunc_begin3           ; >> Call Site 10 <<
	.uleb128 Ltmp63-Ltmp197                 ;   Call between Ltmp197 and Ltmp63
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp63-Lfunc_begin3            ; >> Call Site 11 <<
	.uleb128 Ltmp64-Ltmp63                  ;   Call between Ltmp63 and Ltmp64
	.uleb128 Ltmp65-Lfunc_begin3            ;     jumps to Ltmp65
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp64-Lfunc_begin3            ; >> Call Site 12 <<
	.uleb128 Ltmp68-Ltmp64                  ;   Call between Ltmp64 and Ltmp68
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp68-Lfunc_begin3            ; >> Call Site 13 <<
	.uleb128 Ltmp69-Ltmp68                  ;   Call between Ltmp68 and Ltmp69
	.uleb128 Ltmp70-Lfunc_begin3            ;     jumps to Ltmp70
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp69-Lfunc_begin3            ; >> Call Site 14 <<
	.uleb128 Ltmp74-Ltmp69                  ;   Call between Ltmp69 and Ltmp74
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp74-Lfunc_begin3            ; >> Call Site 15 <<
	.uleb128 Ltmp75-Ltmp74                  ;   Call between Ltmp74 and Ltmp75
	.uleb128 Ltmp76-Lfunc_begin3            ;     jumps to Ltmp76
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp77-Lfunc_begin3            ; >> Call Site 16 <<
	.uleb128 Ltmp78-Ltmp77                  ;   Call between Ltmp77 and Ltmp78
	.uleb128 Ltmp79-Lfunc_begin3            ;     jumps to Ltmp79
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp80-Lfunc_begin3            ; >> Call Site 17 <<
	.uleb128 Ltmp81-Ltmp80                  ;   Call between Ltmp80 and Ltmp81
	.uleb128 Ltmp82-Lfunc_begin3            ;     jumps to Ltmp82
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp81-Lfunc_begin3            ; >> Call Site 18 <<
	.uleb128 Ltmp83-Ltmp81                  ;   Call between Ltmp81 and Ltmp83
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp83-Lfunc_begin3            ; >> Call Site 19 <<
	.uleb128 Ltmp89-Ltmp83                  ;   Call between Ltmp83 and Ltmp89
	.uleb128 Ltmp90-Lfunc_begin3            ;     jumps to Ltmp90
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp89-Lfunc_begin3            ; >> Call Site 20 <<
	.uleb128 Ltmp85-Ltmp89                  ;   Call between Ltmp89 and Ltmp85
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp85-Lfunc_begin3            ; >> Call Site 21 <<
	.uleb128 Ltmp86-Ltmp85                  ;   Call between Ltmp85 and Ltmp86
	.uleb128 Ltmp87-Lfunc_begin3            ;     jumps to Ltmp87
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp97-Lfunc_begin3            ; >> Call Site 22 <<
	.uleb128 Ltmp98-Ltmp97                  ;   Call between Ltmp97 and Ltmp98
	.uleb128 Ltmp99-Lfunc_begin3            ;     jumps to Ltmp99
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp100-Lfunc_begin3           ; >> Call Site 23 <<
	.uleb128 Ltmp101-Ltmp100                ;   Call between Ltmp100 and Ltmp101
	.uleb128 Ltmp102-Lfunc_begin3           ;     jumps to Ltmp102
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp105-Lfunc_begin3           ; >> Call Site 24 <<
	.uleb128 Ltmp106-Ltmp105                ;   Call between Ltmp105 and Ltmp106
	.uleb128 Ltmp107-Lfunc_begin3           ;     jumps to Ltmp107
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp108-Lfunc_begin3           ; >> Call Site 25 <<
	.uleb128 Ltmp109-Ltmp108                ;   Call between Ltmp108 and Ltmp109
	.uleb128 Ltmp110-Lfunc_begin3           ;     jumps to Ltmp110
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp109-Lfunc_begin3           ; >> Call Site 26 <<
	.uleb128 Ltmp91-Ltmp109                 ;   Call between Ltmp109 and Ltmp91
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp91-Lfunc_begin3            ; >> Call Site 27 <<
	.uleb128 Ltmp92-Ltmp91                  ;   Call between Ltmp91 and Ltmp92
	.uleb128 Ltmp93-Lfunc_begin3            ;     jumps to Ltmp93
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp94-Lfunc_begin3            ; >> Call Site 28 <<
	.uleb128 Ltmp95-Ltmp94                  ;   Call between Ltmp94 and Ltmp95
	.uleb128 Ltmp96-Lfunc_begin3            ;     jumps to Ltmp96
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp113-Lfunc_begin3           ; >> Call Site 29 <<
	.uleb128 Ltmp114-Ltmp113                ;   Call between Ltmp113 and Ltmp114
	.uleb128 Ltmp115-Lfunc_begin3           ;     jumps to Ltmp115
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp116-Lfunc_begin3           ; >> Call Site 30 <<
	.uleb128 Ltmp117-Ltmp116                ;   Call between Ltmp116 and Ltmp117
	.uleb128 Ltmp118-Lfunc_begin3           ;     jumps to Ltmp118
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp121-Lfunc_begin3           ; >> Call Site 31 <<
	.uleb128 Ltmp122-Ltmp121                ;   Call between Ltmp121 and Ltmp122
	.uleb128 Ltmp123-Lfunc_begin3           ;     jumps to Ltmp123
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp124-Lfunc_begin3           ; >> Call Site 32 <<
	.uleb128 Ltmp125-Ltmp124                ;   Call between Ltmp124 and Ltmp125
	.uleb128 Ltmp126-Lfunc_begin3           ;     jumps to Ltmp126
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp125-Lfunc_begin3           ; >> Call Site 33 <<
	.uleb128 Ltmp190-Ltmp125                ;   Call between Ltmp125 and Ltmp190
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp190-Lfunc_begin3           ; >> Call Site 34 <<
	.uleb128 Ltmp191-Ltmp190                ;   Call between Ltmp190 and Ltmp191
	.uleb128 Ltmp192-Lfunc_begin3           ;     jumps to Ltmp192
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp193-Lfunc_begin3           ; >> Call Site 35 <<
	.uleb128 Ltmp194-Ltmp193                ;   Call between Ltmp193 and Ltmp194
	.uleb128 Ltmp195-Lfunc_begin3           ;     jumps to Ltmp195
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp194-Lfunc_begin3           ; >> Call Site 36 <<
	.uleb128 Ltmp127-Ltmp194                ;   Call between Ltmp194 and Ltmp127
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp127-Lfunc_begin3           ; >> Call Site 37 <<
	.uleb128 Ltmp128-Ltmp127                ;   Call between Ltmp127 and Ltmp128
	.uleb128 Ltmp129-Lfunc_begin3           ;     jumps to Ltmp129
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp130-Lfunc_begin3           ; >> Call Site 38 <<
	.uleb128 Ltmp131-Ltmp130                ;   Call between Ltmp130 and Ltmp131
	.uleb128 Ltmp132-Lfunc_begin3           ;     jumps to Ltmp132
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp131-Lfunc_begin3           ; >> Call Site 39 <<
	.uleb128 Ltmp133-Ltmp131                ;   Call between Ltmp131 and Ltmp133
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp133-Lfunc_begin3           ; >> Call Site 40 <<
	.uleb128 Ltmp134-Ltmp133                ;   Call between Ltmp133 and Ltmp134
	.uleb128 Ltmp189-Lfunc_begin3           ;     jumps to Ltmp189
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp134-Lfunc_begin3           ; >> Call Site 41 <<
	.uleb128 Ltmp135-Ltmp134                ;   Call between Ltmp134 and Ltmp135
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp135-Lfunc_begin3           ; >> Call Site 42 <<
	.uleb128 Ltmp136-Ltmp135                ;   Call between Ltmp135 and Ltmp136
	.uleb128 Ltmp186-Lfunc_begin3           ;     jumps to Ltmp186
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp136-Lfunc_begin3           ; >> Call Site 43 <<
	.uleb128 Ltmp137-Ltmp136                ;   Call between Ltmp136 and Ltmp137
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp137-Lfunc_begin3           ; >> Call Site 44 <<
	.uleb128 Ltmp156-Ltmp137                ;   Call between Ltmp137 and Ltmp156
	.uleb128 Ltmp157-Lfunc_begin3           ;     jumps to Ltmp157
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp158-Lfunc_begin3           ; >> Call Site 45 <<
	.uleb128 Ltmp159-Ltmp158                ;   Call between Ltmp158 and Ltmp159
	.uleb128 Ltmp176-Lfunc_begin3           ;     jumps to Ltmp176
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp160-Lfunc_begin3           ; >> Call Site 46 <<
	.uleb128 Ltmp165-Ltmp160                ;   Call between Ltmp160 and Ltmp165
	.uleb128 Ltmp183-Lfunc_begin3           ;     jumps to Ltmp183
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp166-Lfunc_begin3           ; >> Call Site 47 <<
	.uleb128 Ltmp167-Ltmp166                ;   Call between Ltmp166 and Ltmp167
	.uleb128 Ltmp176-Lfunc_begin3           ;     jumps to Ltmp176
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp168-Lfunc_begin3           ; >> Call Site 48 <<
	.uleb128 Ltmp173-Ltmp168                ;   Call between Ltmp168 and Ltmp173
	.uleb128 Ltmp183-Lfunc_begin3           ;     jumps to Ltmp183
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp174-Lfunc_begin3           ; >> Call Site 49 <<
	.uleb128 Ltmp175-Ltmp174                ;   Call between Ltmp174 and Ltmp175
	.uleb128 Ltmp176-Lfunc_begin3           ;     jumps to Ltmp176
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp177-Lfunc_begin3           ; >> Call Site 50 <<
	.uleb128 Ltmp182-Ltmp177                ;   Call between Ltmp177 and Ltmp182
	.uleb128 Ltmp183-Lfunc_begin3           ;     jumps to Ltmp183
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp187-Lfunc_begin3           ; >> Call Site 51 <<
	.uleb128 Ltmp188-Ltmp187                ;   Call between Ltmp187 and Ltmp188
	.uleb128 Ltmp189-Lfunc_begin3           ;     jumps to Ltmp189
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp184-Lfunc_begin3           ; >> Call Site 52 <<
	.uleb128 Ltmp185-Ltmp184                ;   Call between Ltmp184 and Ltmp185
	.uleb128 Ltmp186-Lfunc_begin3           ;     jumps to Ltmp186
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp185-Lfunc_begin3           ; >> Call Site 53 <<
	.uleb128 Ltmp139-Ltmp185                ;   Call between Ltmp185 and Ltmp139
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp139-Lfunc_begin3           ; >> Call Site 54 <<
	.uleb128 Ltmp140-Ltmp139                ;   Call between Ltmp139 and Ltmp140
	.uleb128 Ltmp141-Lfunc_begin3           ;     jumps to Ltmp141
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp140-Lfunc_begin3           ; >> Call Site 55 <<
	.uleb128 Ltmp142-Ltmp140                ;   Call between Ltmp140 and Ltmp142
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp142-Lfunc_begin3           ; >> Call Site 56 <<
	.uleb128 Ltmp143-Ltmp142                ;   Call between Ltmp142 and Ltmp143
	.uleb128 Ltmp144-Lfunc_begin3           ;     jumps to Ltmp144
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp145-Lfunc_begin3           ; >> Call Site 57 <<
	.uleb128 Ltmp146-Ltmp145                ;   Call between Ltmp145 and Ltmp146
	.uleb128 Ltmp157-Lfunc_begin3           ;     jumps to Ltmp157
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp146-Lfunc_begin3           ; >> Call Site 58 <<
	.uleb128 Ltmp119-Ltmp146                ;   Call between Ltmp146 and Ltmp119
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp119-Lfunc_begin3           ; >> Call Site 59 <<
	.uleb128 Ltmp120-Ltmp119                ;   Call between Ltmp119 and Ltmp120
	.uleb128 Ltmp129-Lfunc_begin3           ;     jumps to Ltmp129
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp120-Lfunc_begin3           ; >> Call Site 60 <<
	.uleb128 Ltmp111-Ltmp120                ;   Call between Ltmp120 and Ltmp111
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp111-Lfunc_begin3           ; >> Call Site 61 <<
	.uleb128 Ltmp112-Ltmp111                ;   Call between Ltmp111 and Ltmp112
	.uleb128 Ltmp129-Lfunc_begin3           ;     jumps to Ltmp129
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp112-Lfunc_begin3           ; >> Call Site 62 <<
	.uleb128 Ltmp103-Ltmp112                ;   Call between Ltmp112 and Ltmp103
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp103-Lfunc_begin3           ; >> Call Site 63 <<
	.uleb128 Ltmp104-Ltmp103                ;   Call between Ltmp103 and Ltmp104
	.uleb128 Ltmp129-Lfunc_begin3           ;     jumps to Ltmp129
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp104-Lfunc_begin3           ; >> Call Site 64 <<
	.uleb128 Ltmp202-Ltmp104                ;   Call between Ltmp104 and Ltmp202
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp202-Lfunc_begin3           ; >> Call Site 65 <<
	.uleb128 Ltmp205-Ltmp202                ;   Call between Ltmp202 and Ltmp205
	.uleb128 Ltmp206-Lfunc_begin3           ;     jumps to Ltmp206
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp210-Lfunc_begin3           ; >> Call Site 66 <<
	.uleb128 Ltmp211-Ltmp210                ;   Call between Ltmp210 and Ltmp211
	.uleb128 Ltmp212-Lfunc_begin3           ;     jumps to Ltmp212
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp211-Lfunc_begin3           ; >> Call Site 67 <<
	.uleb128 Ltmp207-Ltmp211                ;   Call between Ltmp211 and Ltmp207
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp207-Lfunc_begin3           ; >> Call Site 68 <<
	.uleb128 Ltmp208-Ltmp207                ;   Call between Ltmp207 and Ltmp208
	.uleb128 Ltmp209-Lfunc_begin3           ;     jumps to Ltmp209
	.byte	9                               ;   On action: 5
	.uleb128 Ltmp208-Lfunc_begin3           ; >> Call Site 69 <<
	.uleb128 Lfunc_end3-Ltmp208             ;   Call between Ltmp208 and Lfunc_end3
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
Ltmp259:                                ; TypeInfo 2
	.long	__ZTISt16invalid_argument@GOT-Ltmp259
Ltmp260:                                ; TypeInfo 1
	.long	__ZTISt9exception@GOT-Ltmp260
Lttbase0:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__ZN5InputD1Ev                  ; -- Begin function _ZN5InputD1Ev
	.weak_def_can_be_hidden	__ZN5InputD1Ev
	.p2align	2
__ZN5InputD1Ev:                         ; @_ZN5InputD1Ev
	.cfi_startproc
; %bb.0:
	stp	x20, x19, [sp, #-32]!           ; 16-byte Folded Spill
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	mov	x19, x0
	ldr	x0, [x0, #72]
	cbz	x0, LBB11_2
; %bb.1:
	str	x0, [x19, #80]
	bl	__ZdlPv
LBB11_2:
	ldr	x0, [x19, #48]
	cbz	x0, LBB11_4
; %bb.3:
	str	x0, [x19, #56]
	bl	__ZdlPv
LBB11_4:
	ldr	x0, [x19, #24]
	cbz	x0, LBB11_6
; %bb.5:
	str	x0, [x19, #32]
	bl	__ZdlPv
LBB11_6:
	ldr	x0, [x19]
	cbz	x0, LBB11_8
; %bb.7:
	str	x0, [x19, #8]
	bl	__ZdlPv
LBB11_8:
	mov	x0, x19
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
	ret
	.cfi_endproc
                                        ; -- End function
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
	.globl	__ZN5InputC2Emm                 ; -- Begin function _ZN5InputC2Emm
	.weak_def_can_be_hidden	__ZN5InputC2Emm
	.p2align	2
__ZN5InputC2Emm:                        ; @_ZN5InputC2Emm
Lfunc_begin4:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception4
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
	mov	x22, x2
	mov	x20, x1
	mov	x19, x0
	stp	xzr, xzr, [x0]
	str	xzr, [x0, #16]
	cbz	x1, LBB13_5
; %bb.1:
	tbnz	x20, #63, LBB13_23
; %bb.2:
Ltmp213:
	mov	x0, x20
	bl	__Znwm
Ltmp214:
; %bb.3:
	str	x0, [x19]
	add	x21, x0, x20
	str	x21, [x19, #16]
	mov	x1, x20
	bl	_bzero
	mov	x23, x19
	str	xzr, [x23, #24]!
	stur	x21, [x23, #-16]
	stp	xzr, xzr, [x23, #8]
Ltmp215:
	mov	x0, x20
	bl	__Znwm
Ltmp216:
; %bb.4:
	str	x0, [x19, #24]
	add	x21, x0, x20
	str	x21, [x19, #40]
	mov	x1, x20
	bl	_bzero
	mov	x24, x19
	str	x21, [x24, #32]!
	b	LBB13_6
LBB13_5:
	mov	x23, x19
	str	xzr, [x23, #24]!
	mov	x24, x23
	str	xzr, [x24, #8]!
	str	xzr, [x23, #16]
LBB13_6:
	movi.2d	v0, #0000000000000000
	mov	x21, x19
	str	q0, [x21, #48]!
	stp	q0, q0, [x21, #16]
	str	x22, [x21, #48]
	mov	x8, #-4097                      ; =0xffffffffffffefff
	add	x8, x22, x8
	cmn	x8, #1, lsl #12                 ; =4096
	b.lo	LBB13_21
; %bb.7:
	udiv	x8, x20, x22
	msub	x9, x8, x22, x20
	cmp	x9, #0
	cinc	x1, x8, ne
	cbz	x1, LBB13_11
; %bb.8:
Ltmp221:
	mov	x0, x21
	bl	__ZNSt3__16vectorIfNS_9allocatorIfEEE8__appendEm
Ltmp222:
; %bb.9:
	ldp	x11, x9, [x19, #48]
	ldp	x8, x10, [x19, #72]
	sub	x9, x9, x11
	asr	x11, x9, #2
	sub	x10, x10, x8
	asr	x10, x10, #2
	subs	x1, x11, x10
	b.ls	LBB13_12
LBB13_10:
Ltmp223:
	add	x0, x21, #24
	bl	__ZNSt3__16vectorIfNS_9allocatorIfEEE8__appendEm
Ltmp224:
	b	LBB13_14
LBB13_11:
	mov	x8, #0                          ; =0x0
	mov	x10, #0                         ; =0x0
	mov	x9, #0                          ; =0x0
	asr	x11, x9, #2
	sub	x10, x10, x8
	asr	x10, x10, #2
	subs	x1, x11, x10
	b.hi	LBB13_10
LBB13_12:
	b.hs	LBB13_14
; %bb.13:
	add	x8, x8, x9
	str	x8, [x19, #80]
LBB13_14:
	cbz	x20, LBB13_17
; %bb.15:
	mov	x8, #0                          ; =0x0
LBB13_16:                               ; =>This Inner Loop Header: Depth=1
	add	w9, w8, w8, lsl #4
	eor	w9, w9, #0x80
	ldr	x10, [x19]
	strb	w9, [x10, x8]
	lsl	w9, w8, #5
	sub	w9, w9, w8
	eor	w9, w9, #0x80
	ldr	x10, [x19, #24]
	strb	w9, [x10, x8]
	add	x8, x8, #1
	cmp	x20, x8
	b.ne	LBB13_16
LBB13_17:
	ldp	x8, x9, [x19, #48]
	subs	x10, x9, x8
	b.eq	LBB13_20
; %bb.18:
	mov	x9, #0                          ; =0x0
	asr	x10, x10, #2
	ldur	x11, [x21, #24]
	mov	w12, #1                         ; =0x1
	mov	x13, #35747                     ; =0x8ba3
	movk	x13, #47662, lsl #16
	movk	x13, #41704, lsl #32
	movk	x13, #11915, lsl #48
	mov	w14, #11                        ; =0xb
	mov	x15, #9363                      ; =0x2493
	movk	x15, #37449, lsl #16
	movk	x15, #18724, lsl #32
	movk	x15, #9362, lsl #48
LBB13_19:                               ; =>This Inner Loop Header: Depth=1
	umulh	x16, x9, x13
	lsr	x16, x16, #1
	msub	x16, x16, x14, x12
	umulh	x17, x9, x15
	sub	x0, x9, x17
	add	x17, x17, x0, lsr #1
	lsr	x17, x17, #2
	sub	x17, x17, x17, lsl #3
	add	x17, x12, x17
	ucvtf	s0, x17, #7
	str	s0, [x8], #4
	ucvtf	s0, x16, #6
	str	s0, [x11], #4
	add	x9, x9, #1
	add	x12, x12, #1
	subs	x10, x10, #1
	b.ne	LBB13_19
LBB13_20:
	mov	x0, x19
	ldp	x29, x30, [sp, #48]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #32]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #16]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp], #64             ; 16-byte Folded Reload
	ret
LBB13_21:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x22, x0
Ltmp225:
Lloh142:
	adrp	x1, l_.str.17@PAGE
Lloh143:
	add	x1, x1, l_.str.17@PAGEOFF
	bl	__ZNSt11logic_errorC2EPKc
Ltmp226:
; %bb.22:
Lloh144:
	adrp	x8, __ZTVSt16invalid_argument@GOTPAGE
Lloh145:
	ldr	x8, [x8, __ZTVSt16invalid_argument@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x22]
Ltmp228:
Lloh146:
	adrp	x1, __ZTISt16invalid_argument@GOTPAGE
Lloh147:
	ldr	x1, [x1, __ZTISt16invalid_argument@GOTPAGEOFF]
Lloh148:
	adrp	x2, __ZNSt16invalid_argumentD1Ev@GOTPAGE
Lloh149:
	ldr	x2, [x2, __ZNSt16invalid_argumentD1Ev@GOTPAGEOFF]
	mov	x0, x22
	bl	___cxa_throw
Ltmp229:
	b	LBB13_24
LBB13_23:
Ltmp218:
	bl	__ZNSt3__16vectorIaNS_9allocatorIaEEE20__throw_length_errorB9nqe210106Ev
Ltmp219:
LBB13_24:
	brk	#0x1
LBB13_25:
Ltmp227:
	mov	x20, x0
	mov	x0, x22
	bl	___cxa_free_exception
	b	LBB13_30
LBB13_26:
Ltmp217:
	b	LBB13_28
LBB13_27:
Ltmp220:
LBB13_28:
	mov	x20, x0
	ldr	x0, [x19]
	cbnz	x0, LBB13_34
	b	LBB13_35
LBB13_29:
Ltmp230:
	mov	x20, x0
LBB13_30:
	ldur	x0, [x21, #24]
	cbnz	x0, LBB13_36
; %bb.31:
	ldr	x0, [x21]
	cbnz	x0, LBB13_37
LBB13_32:
	ldr	x0, [x23]
	cbnz	x0, LBB13_38
LBB13_33:
	ldr	x0, [x19]
	cbz	x0, LBB13_35
LBB13_34:
	str	x0, [x19, #8]
	bl	__ZdlPv
LBB13_35:
	mov	x0, x20
	bl	__Unwind_Resume
LBB13_36:
	str	x0, [x19, #80]
	bl	__ZdlPv
	ldr	x0, [x21]
	cbz	x0, LBB13_32
LBB13_37:
	str	x0, [x19, #56]
	bl	__ZdlPv
	ldr	x0, [x23]
	cbz	x0, LBB13_33
LBB13_38:
	str	x0, [x24]
	bl	__ZdlPv
	ldr	x0, [x19]
	cbnz	x0, LBB13_34
	b	LBB13_35
	.loh AdrpAdd	Lloh142, Lloh143
	.loh AdrpLdrGot	Lloh148, Lloh149
	.loh AdrpLdrGot	Lloh146, Lloh147
	.loh AdrpLdrGot	Lloh144, Lloh145
Lfunc_end4:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table13:
Lexception4:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end4-Lcst_begin4
Lcst_begin4:
	.uleb128 Ltmp213-Lfunc_begin4           ; >> Call Site 1 <<
	.uleb128 Ltmp214-Ltmp213                ;   Call between Ltmp213 and Ltmp214
	.uleb128 Ltmp220-Lfunc_begin4           ;     jumps to Ltmp220
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp214-Lfunc_begin4           ; >> Call Site 2 <<
	.uleb128 Ltmp215-Ltmp214                ;   Call between Ltmp214 and Ltmp215
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp215-Lfunc_begin4           ; >> Call Site 3 <<
	.uleb128 Ltmp216-Ltmp215                ;   Call between Ltmp215 and Ltmp216
	.uleb128 Ltmp217-Lfunc_begin4           ;     jumps to Ltmp217
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp216-Lfunc_begin4           ; >> Call Site 4 <<
	.uleb128 Ltmp221-Ltmp216                ;   Call between Ltmp216 and Ltmp221
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp221-Lfunc_begin4           ; >> Call Site 5 <<
	.uleb128 Ltmp224-Ltmp221                ;   Call between Ltmp221 and Ltmp224
	.uleb128 Ltmp230-Lfunc_begin4           ;     jumps to Ltmp230
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp224-Lfunc_begin4           ; >> Call Site 6 <<
	.uleb128 Ltmp225-Ltmp224                ;   Call between Ltmp224 and Ltmp225
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp225-Lfunc_begin4           ; >> Call Site 7 <<
	.uleb128 Ltmp226-Ltmp225                ;   Call between Ltmp225 and Ltmp226
	.uleb128 Ltmp227-Lfunc_begin4           ;     jumps to Ltmp227
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp228-Lfunc_begin4           ; >> Call Site 8 <<
	.uleb128 Ltmp229-Ltmp228                ;   Call between Ltmp228 and Ltmp229
	.uleb128 Ltmp230-Lfunc_begin4           ;     jumps to Ltmp230
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp218-Lfunc_begin4           ; >> Call Site 9 <<
	.uleb128 Ltmp219-Ltmp218                ;   Call between Ltmp218 and Ltmp219
	.uleb128 Ltmp220-Lfunc_begin4           ;     jumps to Ltmp220
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp219-Lfunc_begin4           ; >> Call Site 10 <<
	.uleb128 Lfunc_end4-Ltmp219             ;   Call between Ltmp219 and Lfunc_end4
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end4:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
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
Lloh150:
	adrp	x0, l_.str.18@PAGE
Lloh151:
	add	x0, x0, l_.str.18@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh150, Lloh151
	.cfi_endproc
                                        ; -- End function
	.private_extern	__ZNSt3__120__throw_length_errorB9nqe210106EPKc ; -- Begin function _ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.globl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.weak_def_can_be_hidden	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.p2align	2
__ZNSt3__120__throw_length_errorB9nqe210106EPKc: ; @_ZNSt3__120__throw_length_errorB9nqe210106EPKc
Lfunc_begin5:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception5
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
Ltmp231:
	mov	x1, x20
	bl	__ZNSt12length_errorC1B9nqe210106EPKc
Ltmp232:
; %bb.1:
Lloh152:
	adrp	x1, __ZTISt12length_error@GOTPAGE
Lloh153:
	ldr	x1, [x1, __ZTISt12length_error@GOTPAGEOFF]
Lloh154:
	adrp	x2, __ZNSt12length_errorD1Ev@GOTPAGE
Lloh155:
	ldr	x2, [x2, __ZNSt12length_errorD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
LBB15_2:
Ltmp233:
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x0, x20
	bl	__Unwind_Resume
	.loh AdrpLdrGot	Lloh154, Lloh155
	.loh AdrpLdrGot	Lloh152, Lloh153
Lfunc_end5:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table15:
Lexception5:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end5-Lcst_begin5
Lcst_begin5:
	.uleb128 Lfunc_begin5-Lfunc_begin5      ; >> Call Site 1 <<
	.uleb128 Ltmp231-Lfunc_begin5           ;   Call between Lfunc_begin5 and Ltmp231
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp231-Lfunc_begin5           ; >> Call Site 2 <<
	.uleb128 Ltmp232-Ltmp231                ;   Call between Ltmp231 and Ltmp232
	.uleb128 Ltmp233-Lfunc_begin5           ;     jumps to Ltmp233
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp232-Lfunc_begin5           ; >> Call Site 3 <<
	.uleb128 Lfunc_end5-Ltmp232             ;   Call between Ltmp232 and Lfunc_end5
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end5:
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
Lloh156:
	adrp	x8, __ZTVSt12length_error@GOTPAGE
Lloh157:
	ldr	x8, [x8, __ZTVSt12length_error@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x0]
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
	.loh AdrpLdrGot	Lloh156, Lloh157
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
Lloh158:
	adrp	x1, __ZTISt20bad_array_new_length@GOTPAGE
Lloh159:
	ldr	x1, [x1, __ZTISt20bad_array_new_length@GOTPAGEOFF]
Lloh160:
	adrp	x2, __ZNSt20bad_array_new_lengthD1Ev@GOTPAGE
Lloh161:
	ldr	x2, [x2, __ZNSt20bad_array_new_lengthD1Ev@GOTPAGEOFF]
	bl	___cxa_throw
	.loh AdrpLdrGot	Lloh160, Lloh161
	.loh AdrpLdrGot	Lloh158, Lloh159
	.cfi_endproc
                                        ; -- End function
	.private_extern	__ZNSt3__16vectorIfNS_9allocatorIfEEE8__appendEm ; -- Begin function _ZNSt3__16vectorIfNS_9allocatorIfEEE8__appendEm
	.globl	__ZNSt3__16vectorIfNS_9allocatorIfEEE8__appendEm
	.weak_def_can_be_hidden	__ZNSt3__16vectorIfNS_9allocatorIfEEE8__appendEm
	.p2align	2
__ZNSt3__16vectorIfNS_9allocatorIfEEE8__appendEm: ; @_ZNSt3__16vectorIfNS_9allocatorIfEEE8__appendEm
	.cfi_startproc
; %bb.0:
	stp	x26, x25, [sp, #-80]!           ; 16-byte Folded Spill
	stp	x24, x23, [sp, #16]             ; 16-byte Folded Spill
	stp	x22, x21, [sp, #32]             ; 16-byte Folded Spill
	stp	x20, x19, [sp, #48]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #64]             ; 16-byte Folded Spill
	add	x29, sp, #64
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
	ldp	x0, x8, [x0, #8]
	sub	x9, x8, x0
	cmp	x1, x9, asr #2
	b.ls	LBB18_5
; %bb.1:
	ldr	x20, [x19]
	sub	x21, x0, x20
	asr	x23, x21, #2
	add	x9, x23, x1
	lsr	x10, x9, #62
	cbnz	x10, LBB18_12
; %bb.2:
	mov	x10, #9223372036854775804       ; =0x7ffffffffffffffc
	sub	x8, x8, x20
	asr	x11, x8, #1
	cmp	x11, x9
	csel	x9, x11, x9, hi
	cmp	x8, x10
	mov	x8, #4611686018427387903        ; =0x3fffffffffffffff
	csel	x22, x9, x8, lo
	cbz	x22, LBB18_8
; %bb.3:
	lsr	x8, x22, #62
	cbnz	x8, LBB18_13
; %bb.4:
	mov	x24, x1
	lsl	x0, x22, #2
	bl	__Znwm
	mov	x1, x24
	b	LBB18_9
LBB18_5:
	cbz	x1, LBB18_7
; %bb.6:
	lsl	x1, x1, #2
	add	x20, x0, x1
	bl	_bzero
	mov	x0, x20
LBB18_7:
	str	x0, [x19, #8]
	b	LBB18_11
LBB18_8:
	mov	x0, #0                          ; =0x0
LBB18_9:
	add	x24, x0, x22, lsl #2
	lsl	x1, x1, #2
	add	x22, x0, x21
	add	x25, x22, x1
	mov	x0, x22
	bl	_bzero
	sub	x22, x22, x23, lsl #2
	mov	x0, x22
	mov	x1, x20
	mov	x2, x21
	bl	_memcpy
	stp	x22, x25, [x19]
	str	x24, [x19, #16]
	cbz	x20, LBB18_11
; %bb.10:
	mov	x0, x20
	ldp	x29, x30, [sp, #64]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #48]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #32]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #16]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp], #80             ; 16-byte Folded Reload
	b	__ZdlPv
LBB18_11:
	ldp	x29, x30, [sp, #64]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #48]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #32]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #16]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp], #80             ; 16-byte Folded Reload
	ret
LBB18_12:
	bl	__ZNSt3__16vectorIfNS_9allocatorIfEEE20__throw_length_errorB9nqe210106Ev
LBB18_13:
	bl	__ZSt28__throw_bad_array_new_lengthB9nqe210106v
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
Lloh162:
	adrp	x0, l_.str.18@PAGE
Lloh163:
	add	x0, x0, l_.str.18@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh162, Lloh163
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
Lloh164:
	adrp	x0, l_.str.18@PAGE
Lloh165:
	add	x0, x0, l_.str.18@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh164, Lloh165
	.cfi_endproc
                                        ; -- End function
	.private_extern	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m ; -- Begin function _ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
	.globl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
	.weak_def_can_be_hidden	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
	.p2align	2
__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m: ; @_ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Lfunc_begin6:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception6
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
Ltmp234:
	add	x0, sp, #8
	mov	x1, x19
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryC1ERS3_
Ltmp235:
; %bb.1:
	ldrb	w8, [sp, #8]
	cmp	w8, #1
	b.ne	LBB21_10
; %bb.2:
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
	add	x4, x19, x8
	ldr	x22, [x4, #40]
	ldr	w24, [x4, #8]
	ldr	w23, [x4, #144]
	cmn	w23, #1
	b.ne	LBB21_7
; %bb.3:
Ltmp237:
	add	x8, sp, #24
	mov	x25, x4
	mov	x0, x4
	bl	__ZNKSt3__18ios_base6getlocEv
Ltmp238:
; %bb.4:
Ltmp239:
Lloh166:
	adrp	x1, __ZNSt3__15ctypeIcE2idE@GOTPAGE
Lloh167:
	ldr	x1, [x1, __ZNSt3__15ctypeIcE2idE@GOTPAGEOFF]
	add	x0, sp, #24
	bl	__ZNKSt3__16locale9use_facetERNS0_2idE
Ltmp240:
; %bb.5:
	ldr	x8, [x0]
	ldr	x8, [x8, #56]
Ltmp241:
	mov	w1, #32                         ; =0x20
	blr	x8
Ltmp242:
; %bb.6:
	mov	x23, x0
	add	x0, sp, #24
	bl	__ZNSt3__16localeD1Ev
	mov	x4, x25
	str	w23, [x25, #144]
LBB21_7:
	mov	w8, #176                        ; =0xb0
	and	w8, w24, w8
	add	x3, x20, x21
	cmp	w8, #32
	csel	x2, x3, x20, eq
Ltmp244:
	sxtb	w5, w23
	mov	x0, x22
	mov	x1, x20
	bl	__ZNSt3__116__pad_and_outputB9nqe210106IcNS_11char_traitsIcEEEENS_19ostreambuf_iteratorIT_T0_EES6_PKS4_S8_S8_RNS_8ios_baseES4_
Ltmp245:
; %bb.8:
	cbnz	x0, LBB21_10
; %bb.9:
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
	add	x0, x19, x8
	ldr	w8, [x0, #32]
	mov	w9, #5                          ; =0x5
Ltmp247:
	orr	w1, w8, w9
	bl	__ZNSt3__18ios_base5clearEj
Ltmp248:
LBB21_10:
	add	x0, sp, #8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryD1Ev
LBB21_11:
	mov	x0, x19
	ldp	x29, x30, [sp, #96]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #80]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #64]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #48]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #112
	ret
LBB21_12:
Ltmp249:
	b	LBB21_15
LBB21_13:
Ltmp243:
	mov	x20, x0
	add	x0, sp, #24
	bl	__ZNSt3__16localeD1Ev
	b	LBB21_16
LBB21_14:
Ltmp246:
LBB21_15:
	mov	x20, x0
LBB21_16:
	add	x0, sp, #8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryD1Ev
	b	LBB21_18
LBB21_17:
Ltmp236:
	mov	x20, x0
LBB21_18:
	mov	x0, x20
	bl	___cxa_begin_catch
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
Ltmp250:
	add	x0, x19, x8
	bl	__ZNSt3__18ios_base33__set_badbit_and_consider_rethrowEv
Ltmp251:
; %bb.19:
	bl	___cxa_end_catch
	b	LBB21_11
LBB21_20:
Ltmp252:
	mov	x19, x0
Ltmp253:
	bl	___cxa_end_catch
Ltmp254:
; %bb.21:
	mov	x0, x19
	bl	__Unwind_Resume
LBB21_22:
Ltmp255:
	bl	___clang_call_terminate
	.loh AdrpLdrGot	Lloh166, Lloh167
Lfunc_end6:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table21:
Lexception6:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase1-Lttbaseref1
Lttbaseref1:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end6-Lcst_begin6
Lcst_begin6:
	.uleb128 Ltmp234-Lfunc_begin6           ; >> Call Site 1 <<
	.uleb128 Ltmp235-Ltmp234                ;   Call between Ltmp234 and Ltmp235
	.uleb128 Ltmp236-Lfunc_begin6           ;     jumps to Ltmp236
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp237-Lfunc_begin6           ; >> Call Site 2 <<
	.uleb128 Ltmp238-Ltmp237                ;   Call between Ltmp237 and Ltmp238
	.uleb128 Ltmp246-Lfunc_begin6           ;     jumps to Ltmp246
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp239-Lfunc_begin6           ; >> Call Site 3 <<
	.uleb128 Ltmp242-Ltmp239                ;   Call between Ltmp239 and Ltmp242
	.uleb128 Ltmp243-Lfunc_begin6           ;     jumps to Ltmp243
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp244-Lfunc_begin6           ; >> Call Site 4 <<
	.uleb128 Ltmp245-Ltmp244                ;   Call between Ltmp244 and Ltmp245
	.uleb128 Ltmp246-Lfunc_begin6           ;     jumps to Ltmp246
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp247-Lfunc_begin6           ; >> Call Site 5 <<
	.uleb128 Ltmp248-Ltmp247                ;   Call between Ltmp247 and Ltmp248
	.uleb128 Ltmp249-Lfunc_begin6           ;     jumps to Ltmp249
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp248-Lfunc_begin6           ; >> Call Site 6 <<
	.uleb128 Ltmp250-Ltmp248                ;   Call between Ltmp248 and Ltmp250
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp250-Lfunc_begin6           ; >> Call Site 7 <<
	.uleb128 Ltmp251-Ltmp250                ;   Call between Ltmp250 and Ltmp251
	.uleb128 Ltmp252-Lfunc_begin6           ;     jumps to Ltmp252
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp251-Lfunc_begin6           ; >> Call Site 8 <<
	.uleb128 Ltmp253-Ltmp251                ;   Call between Ltmp251 and Ltmp253
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp253-Lfunc_begin6           ; >> Call Site 9 <<
	.uleb128 Ltmp254-Ltmp253                ;   Call between Ltmp253 and Ltmp254
	.uleb128 Ltmp255-Lfunc_begin6           ;     jumps to Ltmp255
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp254-Lfunc_begin6           ; >> Call Site 10 <<
	.uleb128 Lfunc_end6-Ltmp254             ;   Call between Ltmp254 and Lfunc_end6
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end6:
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
	mov	x19, x0
	cbz	x0, LBB22_16
; %bb.1:
	mov	x23, x5
	mov	x20, x4
	mov	x22, x3
	mov	x21, x2
	mov	x24, x1
	ldr	x26, [x4, #24]
	sub	x25, x2, x1
	cmp	x25, #1
	b.lt	LBB22_3
; %bb.2:
	ldr	x8, [x19]
	ldr	x8, [x8, #96]
	mov	x0, x19
	mov	x1, x24
	mov	x2, x25
	blr	x8
	cmp	x0, x25
	b.ne	LBB22_15
LBB22_3:
	sub	x8, x22, x24
	cmp	x26, x8
	b.le	LBB22_12
; %bb.4:
	mov	x9, #-9                         ; =0xfffffffffffffff7
	movk	x9, #32767, lsl #48
	sub	x24, x26, x8
	cmp	x24, x9
	b.hs	LBB22_17
; %bb.5:
	cmp	x24, #23
	b.hs	LBB22_7
; %bb.6:
	strb	w24, [sp, #31]
	add	x25, sp, #8
	b	LBB22_8
LBB22_7:
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
LBB22_8:
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
Ltmp256:
	mov	x0, x19
	mov	x2, x24
	blr	x8
Ltmp257:
; %bb.9:
	ldrsb	w8, [sp, #31]
	tbnz	w8, #31, LBB22_11
; %bb.10:
	cmp	x0, x24
	b.ne	LBB22_15
	b	LBB22_12
LBB22_11:
	ldr	x8, [sp, #8]
	mov	x23, x0
	mov	x0, x8
	bl	__ZdlPv
	cmp	x23, x24
	b.ne	LBB22_15
LBB22_12:
	sub	x22, x22, x21
	cmp	x22, #1
	b.lt	LBB22_14
; %bb.13:
	ldr	x8, [x19]
	ldr	x8, [x8, #96]
	mov	x0, x19
	mov	x1, x21
	mov	x2, x22
	blr	x8
	cmp	x0, x22
	b.ne	LBB22_15
LBB22_14:
	str	xzr, [x20, #24]
	b	LBB22_16
LBB22_15:
	mov	x19, #0                         ; =0x0
LBB22_16:
	mov	x0, x19
	ldp	x29, x30, [sp, #96]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #80]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #64]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #48]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #112
	ret
LBB22_17:
	bl	__ZNSt3__112basic_stringIcNS_11char_traitsIcEENS_9allocatorIcEEE20__throw_length_errorB9nqe210106Ev
LBB22_18:
Ltmp258:
	mov	x19, x0
	ldrsb	w8, [sp, #31]
	tbz	w8, #31, LBB22_20
; %bb.19:
	ldr	x0, [sp, #8]
	bl	__ZdlPv
LBB22_20:
	mov	x0, x19
	bl	__Unwind_Resume
Lfunc_end7:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table22:
Lexception7:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end7-Lcst_begin7
Lcst_begin7:
	.uleb128 Lfunc_begin7-Lfunc_begin7      ; >> Call Site 1 <<
	.uleb128 Ltmp256-Lfunc_begin7           ;   Call between Lfunc_begin7 and Ltmp256
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp256-Lfunc_begin7           ; >> Call Site 2 <<
	.uleb128 Ltmp257-Ltmp256                ;   Call between Ltmp256 and Ltmp257
	.uleb128 Ltmp258-Lfunc_begin7           ;     jumps to Ltmp258
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp257-Lfunc_begin7           ; >> Call Site 3 <<
	.uleb128 Lfunc_end7-Ltmp257             ;   Call between Ltmp257 and Lfunc_end7
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end7:
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
Lloh168:
	adrp	x0, l_.str.19@PAGE
Lloh169:
	add	x0, x0, l_.str.19@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh168, Lloh169
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
Lloh170:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh171:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh172:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh173:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	bl	___cxa_throw
	.loh AdrpLdrGot	Lloh172, Lloh173
	.loh AdrpLdrGot	Lloh170, Lloh171
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _Z8validateRK5Input.cold.1
__Z8validateRK5Input.cold.1:            ; @_Z8validateRK5Input.cold.1
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
	.p2align	2                               ; -- Begin function _Z8validateRK5Input.cold.2
__Z8validateRK5Input.cold.2:            ; @_Z8validateRK5Input.cold.2
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
	.asciz	"contract failed"

l_.str.1:                               ; @.str.1
	.asciz	"hw.optional.arm.FEAT_DotProd"

l_.str.2:                               ; @.str.2
	.asciz	"shape"

l_.str.3:                               ; @.str.3
	.asciz	"scale"

	.globl	_sink                           ; @sink
.zerofill __DATA,__common,_sink,8,3
l_.str.4:                               ; @.str.4
	.asciz	"K="

l_.str.5:                               ; @.str.5
	.asciz	" group="

l_.str.6:                               ; @.str.6
	.asciz	" "

l_.str.7:                               ; @.str.7
	.asciz	" CPU batch_mean_us p50="

l_.str.8:                               ; @.str.8
	.asciz	" p95="

l_.str.9:                               ; @.str.9
	.asciz	"\n"

l_.str.10:                              ; @.str.10
	.asciz	"runtime_dotprod="

	.section	__TEXT,__const
	.p2align	2, 0x0                          ; @constinit
l_constinit:
	.long	1                               ; 0x1
	.long	15                              ; 0xf
	.long	16                              ; 0x10
	.long	31                              ; 0x1f
	.long	32                              ; 0x20
	.long	33                              ; 0x21
	.long	256                             ; 0x100
	.long	4096                            ; 0x1000

	.section	__TEXT,__cstring,cstring_literals
l_.str.11:                              ; @.str.11
	.asciz	"PASS cases="

l_.str.12:                              ; @.str.12
	.asciz	" rejected="

l_.str.13:                              ; @.str.13
	.asciz	" hand=672 wrong_global_scale=64\n"

l_.str.14:                              ; @.str.14
	.asciz	"scalar"

l_.str.15:                              ; @.str.15
	.asciz	"widening"

l_.str.16:                              ; @.str.16
	.asciz	"dotprod"

l_.str.17:                              ; @.str.17
	.asciz	"group outside [1,4096]"

l_.str.18:                              ; @.str.18
	.asciz	"vector"

l_.str.19:                              ; @.str.19
	.asciz	"basic_string"

.subsections_via_symbols
