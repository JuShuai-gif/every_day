	.build_version macos, 26, 0	sdk_version 26, 5
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_chase                          ; -- Begin function chase
	.p2align	2
_chase:                                 ; @chase
	.cfi_startproc
; %bb.0:
	cbz	x2, LBB0_2
LBB0_1:                                 ; =>This Inner Loop Header: Depth=1
	lsl	x8, x1, #7
	ldr	x1, [x0, x8]
	subs	x2, x2, #1
	b.ne	LBB0_1
LBB0_2:
	mov	x0, x1
	ret
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__literal16,16byte_literals
	.p2align	4, 0x0                          ; -- Begin function _Z9make_ringmb
lCPI1_0:
	.quad	0                               ; 0x0
	.quad	1                               ; 0x1
lCPI1_1:
	.quad	0                               ; 0x0
	.quad	9223372036854775807             ; 0x7fffffffffffffff
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__Z9make_ringmb
	.p2align	2
__Z9make_ringmb:                        ; @_Z9make_ringmb
Lfunc_begin0:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception0
; %bb.0:
	stp	x28, x27, [sp, #-96]!           ; 16-byte Folded Spill
	stp	x26, x25, [sp, #16]             ; 16-byte Folded Spill
	stp	x24, x23, [sp, #32]             ; 16-byte Folded Spill
	stp	x22, x21, [sp, #48]             ; 16-byte Folded Spill
	stp	x20, x19, [sp, #64]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #80]             ; 16-byte Folded Spill
	add	x29, sp, #80
	sub	sp, sp, #2544
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
	cbz	x0, LBB1_41
; %bb.1:
	mov	x22, x0
	mov	x19, x8
	stp	xzr, xzr, [x8]
	lsr	x8, x0, #57
	str	xzr, [x19, #16]
	cbnz	x8, LBB1_43
; %bb.2:
	mov	x23, x1
	lsl	x21, x22, #7
	mov	x0, x21
	mov	w1, #128                        ; =0x80
	bl	__ZnwmSt11align_val_t
	mov	x20, x0
	str	x0, [x19]
	add	x24, x0, x21
	str	x24, [x19, #16]
	mov	x1, x21
	bl	_bzero
	str	x24, [x19, #8]
	lsl	x24, x22, #3
Ltmp0:
	mov	x0, x24
	bl	__Znwm
Ltmp1:
; %bb.3:
	mov	x21, x0
	add	x25, x0, x24
	mov	x1, x24
	bl	_bzero
	sub	x8, x24, #8
	cmp	x8, #56
	b.hs	LBB1_5
; %bb.4:
	mov	x8, #0                          ; =0x0
	mov	x9, x21
	b	LBB1_8
LBB1_5:
	lsr	x8, x8, #3
	add	x10, x8, #1
	and	x8, x10, #0x3ffffffffffffff8
	add	x9, x21, x8, lsl #3
Lloh0:
	adrp	x11, lCPI1_0@PAGE
Lloh1:
	ldr	q0, [x11, lCPI1_0@PAGEOFF]
	add	x11, x21, #32
	mov	w12, #2                         ; =0x2
	dup.2d	v1, x12
	mov	w12, #4                         ; =0x4
	dup.2d	v2, x12
	mov	w12, #6                         ; =0x6
	dup.2d	v3, x12
	mov	w12, #8                         ; =0x8
	dup.2d	v4, x12
	mov	x12, x8
LBB1_6:                                 ; =>This Inner Loop Header: Depth=1
	add.2d	v5, v0, v1
	add.2d	v6, v0, v2
	add.2d	v7, v0, v3
	stp	q0, q5, [x11, #-32]
	stp	q6, q7, [x11], #64
	add.2d	v0, v0, v4
	subs	x12, x12, #8
	b.ne	LBB1_6
; %bb.7:
	cmp	x10, x8
	b.eq	LBB1_9
LBB1_8:                                 ; =>This Inner Loop Header: Depth=1
	str	x8, [x9], #8
	add	x8, x8, #1
	cmp	x9, x25
	b.ne	LBB1_8
LBB1_9:
	mov	w8, #7                          ; =0x7
	str	w8, [sp, #24]
	mov	w9, #1                          ; =0x1
	mov	w10, #35173                     ; =0x8965
	movk	w10, #27655, lsl #16
	add	x11, sp, #24
LBB1_10:                                ; =>This Inner Loop Header: Depth=1
	eor	w8, w8, w8, lsr #30
	madd	w8, w8, w10, w9
	str	w8, [x11, x9, lsl #2]
	add	x9, x9, #1
	cmp	x9, #624
	b.ne	LBB1_10
; %bb.11:
	str	xzr, [sp, #2520]
	cbz	w23, LBB1_13
; %bb.12:
	subs	x23, x22, #1
	b.ne	LBB1_31
LBB1_13:
	cmp	x22, #4
	b.hs	LBB1_15
; %bb.14:
	mov	x8, #0                          ; =0x0
	b	LBB1_18
LBB1_15:
	and	x8, x22, #0x1fffffffffffffc
	neg	x9, x8
	neg	x10, x22
	add	x11, x21, #16
	mov	w12, #4                         ; =0x4
LBB1_16:                                ; =>This Inner Loop Header: Depth=1
	add	x13, x10, x12
	sub	x14, x12, #3
	sub	x15, x12, #2
	sub	x16, x12, #1
	cmp	x13, #3
	csel	x14, xzr, x14, eq
	cmp	x13, #2
	csel	x15, xzr, x15, eq
	cmp	x13, #1
	csel	x13, xzr, x16, eq
	cmp	x22, x12
	csel	x16, xzr, x12, eq
	ldr	x14, [x21, x14, lsl #3]
	ldr	x15, [x21, x15, lsl #3]
	ldr	x13, [x21, x13, lsl #3]
	ldr	x16, [x21, x16, lsl #3]
	ldp	x17, x0, [x11, #-16]
	lsl	x17, x17, #7
	lsl	x0, x0, #7
	ldp	x1, x2, [x11], #32
	lsl	x1, x1, #7
	lsl	x2, x2, #7
	str	x14, [x20, x17]
	str	x15, [x20, x0]
	str	x13, [x20, x1]
	str	x16, [x20, x2]
	add	x12, x12, #4
	add	x13, x9, x12
	cmp	x13, #4
	b.ne	LBB1_16
; %bb.17:
	cmp	x22, x8
	b.eq	LBB1_20
LBB1_18:
	sub	x9, x22, x8
	add	x10, x8, #1
	add	x8, x21, x8, lsl #3
LBB1_19:                                ; =>This Inner Loop Header: Depth=1
	subs	x9, x9, #1
	csel	x11, xzr, x10, eq
	ldr	x11, [x21, x11, lsl #3]
	ldr	x12, [x8], #8
	lsl	x12, x12, #7
	str	x11, [x20, x12]
	add	x10, x10, #1
	cbnz	x9, LBB1_19
LBB1_20:
	sub	x8, x22, #1
	lsr	x8, x8, #6
	add	x23, x8, #1
	lsl	x0, x23, #3
Ltmp6:
	bl	__Znwm
Ltmp7:
; %bb.21:
	stp	x0, xzr, [sp]
	str	x23, [sp, #16]
Ltmp8:
	mov	x0, sp
	mov	x1, x22
	mov	w2, #0                          ; =0x0
	bl	__ZNSt3__16vectorIbNS_9allocatorIbEEE18__construct_at_endB9nqe210106Emb
Ltmp9:
; %bb.22:
	mov	x8, #0                          ; =0x0
	ldr	x9, [sp]
	mov	w10, #1                         ; =0x1
	mov	x11, x22
LBB1_23:                                ; =>This Inner Loop Header: Depth=1
	cmp	x8, x22
	b.hs	LBB1_36
; %bb.24:                               ;   in Loop: Header=BB1_23 Depth=1
	lsr	x12, x8, #6
	lsl	x13, x10, x8
	ldr	x14, [x9, x12, lsl #3]
	tst	x14, x13
	b.ne	LBB1_36
; %bb.25:                               ;   in Loop: Header=BB1_23 Depth=1
	orr	x13, x14, x13
	str	x13, [x9, x12, lsl #3]
	lsl	x8, x8, #7
	ldr	x8, [x20, x8]
	subs	x11, x11, #1
	b.ne	LBB1_23
; %bb.26:
	cbnz	x8, LBB1_38
; %bb.27:
	mov	x0, x20
	mov	x1, #0                          ; =0x0
	mov	x2, x22
	bl	_chase
	cbnz	x0, LBB1_38
; %bb.28:
	ldr	x0, [sp]
	cbz	x0, LBB1_30
; %bb.29:
	bl	__ZdlPv
LBB1_30:
	mov	x0, x21
	bl	__ZdlPv
	add	sp, sp, #2544
	ldp	x29, x30, [sp, #80]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #64]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #48]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #32]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #16]             ; 16-byte Folded Reload
	ldp	x28, x27, [sp], #96             ; 16-byte Folded Reload
	ret
LBB1_31:
Lloh2:
	adrp	x8, lCPI1_1@PAGE
Lloh3:
	ldr	q0, [x8, lCPI1_1@PAGEOFF]
	str	q0, [sp]
	sub	x24, x25, #8
	mov	x25, x21
	mov	x26, x21
	b	LBB1_33
LBB1_32:                                ;   in Loop: Header=BB1_33 Depth=1
	add	x26, x26, #8
	sub	x23, x23, #1
	add	x25, x25, #8
	cmp	x26, x24
	b.hs	LBB1_13
LBB1_33:                                ; =>This Inner Loop Header: Depth=1
	stp	xzr, x23, [x29, #-96]
Ltmp3:
	mov	x0, sp
	add	x1, sp, #24
	sub	x2, x29, #96
	bl	__ZNSt3__124uniform_int_distributionIlEclINS_23mersenne_twister_engineIjLm32ELm624ELm397ELm31ELj2567483615ELm11ELj4294967295ELm7ELj2636928640ELm15ELj4022730752ELm18ELj1812433253EEEEElRT_RKNS1_10param_typeE
Ltmp4:
; %bb.34:                               ;   in Loop: Header=BB1_33 Depth=1
	cbz	x0, LBB1_32
; %bb.35:                               ;   in Loop: Header=BB1_33 Depth=1
	ldr	x8, [x26]
	ldr	x9, [x25, x0, lsl #3]
	str	x9, [x26]
	str	x8, [x25, x0, lsl #3]
	b	LBB1_32
LBB1_36:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x23, x0
Ltmp11:
Lloh4:
	adrp	x1, l_.str.1@PAGE
Lloh5:
	add	x1, x1, l_.str.1@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp12:
; %bb.37:
Ltmp14:
Lloh6:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh7:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh8:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh9:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x23
	bl	___cxa_throw
Ltmp15:
	b	LBB1_40
LBB1_38:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x23, x0
Ltmp17:
Lloh10:
	adrp	x1, l_.str.2@PAGE
Lloh11:
	add	x1, x1, l_.str.2@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp18:
; %bb.39:
Ltmp20:
Lloh12:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh13:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh14:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh15:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x23
	bl	___cxa_throw
Ltmp21:
LBB1_40:
	brk	#0x1
LBB1_41:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp23:
Lloh16:
	adrp	x1, l_.str@PAGE
Lloh17:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt16invalid_argumentC1B9nqe210106EPKc
Ltmp24:
; %bb.42:
	mov	x0, x19
	bl	__Z9make_ringmb.cold.1
LBB1_43:
	bl	__ZNSt3__16vectorI4NodeNS_9allocatorIS1_EEE20__throw_length_errorB9nqe210106Ev
LBB1_44:
Ltmp25:
	mov	x22, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x0, x22
	bl	__Unwind_Resume
LBB1_45:
Ltmp22:
	b	LBB1_51
LBB1_46:
Ltmp19:
	b	LBB1_53
LBB1_47:
Ltmp2:
	mov	x22, x0
	str	x20, [x19, #8]
	mov	x0, x20
	mov	w1, #128                        ; =0x80
	bl	__ZdlPvSt11align_val_t
	mov	x0, x22
	bl	__Unwind_Resume
LBB1_48:
Ltmp10:
	mov	x22, x0
	b	LBB1_56
LBB1_49:
Ltmp5:
	mov	x22, x0
	b	LBB1_56
LBB1_50:
Ltmp16:
LBB1_51:
	mov	x22, x0
	b	LBB1_54
LBB1_52:
Ltmp13:
LBB1_53:
	mov	x22, x0
	mov	x0, x23
	bl	___cxa_free_exception
LBB1_54:
	ldr	x0, [sp]
	cbz	x0, LBB1_56
; %bb.55:
	bl	__ZdlPv
LBB1_56:
	mov	x0, x21
	bl	__ZdlPv
	str	x20, [x19, #8]
	mov	x0, x20
	mov	w1, #128                        ; =0x80
	bl	__ZdlPvSt11align_val_t
	mov	x0, x22
	bl	__Unwind_Resume
	.loh AdrpLdr	Lloh0, Lloh1
	.loh AdrpLdr	Lloh2, Lloh3
	.loh AdrpAdd	Lloh4, Lloh5
	.loh AdrpLdrGot	Lloh8, Lloh9
	.loh AdrpLdrGot	Lloh6, Lloh7
	.loh AdrpAdd	Lloh10, Lloh11
	.loh AdrpLdrGot	Lloh14, Lloh15
	.loh AdrpLdrGot	Lloh12, Lloh13
	.loh AdrpAdd	Lloh16, Lloh17
Lfunc_end0:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table1:
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
	.uleb128 Ltmp6-Ltmp1                    ;   Call between Ltmp1 and Ltmp6
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp6-Lfunc_begin0             ; >> Call Site 4 <<
	.uleb128 Ltmp9-Ltmp6                    ;   Call between Ltmp6 and Ltmp9
	.uleb128 Ltmp10-Lfunc_begin0            ;     jumps to Ltmp10
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp3-Lfunc_begin0             ; >> Call Site 5 <<
	.uleb128 Ltmp4-Ltmp3                    ;   Call between Ltmp3 and Ltmp4
	.uleb128 Ltmp5-Lfunc_begin0             ;     jumps to Ltmp5
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp4-Lfunc_begin0             ; >> Call Site 6 <<
	.uleb128 Ltmp11-Ltmp4                   ;   Call between Ltmp4 and Ltmp11
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp11-Lfunc_begin0            ; >> Call Site 7 <<
	.uleb128 Ltmp12-Ltmp11                  ;   Call between Ltmp11 and Ltmp12
	.uleb128 Ltmp13-Lfunc_begin0            ;     jumps to Ltmp13
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp14-Lfunc_begin0            ; >> Call Site 8 <<
	.uleb128 Ltmp15-Ltmp14                  ;   Call between Ltmp14 and Ltmp15
	.uleb128 Ltmp16-Lfunc_begin0            ;     jumps to Ltmp16
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp15-Lfunc_begin0            ; >> Call Site 9 <<
	.uleb128 Ltmp17-Ltmp15                  ;   Call between Ltmp15 and Ltmp17
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp17-Lfunc_begin0            ; >> Call Site 10 <<
	.uleb128 Ltmp18-Ltmp17                  ;   Call between Ltmp17 and Ltmp18
	.uleb128 Ltmp19-Lfunc_begin0            ;     jumps to Ltmp19
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp20-Lfunc_begin0            ; >> Call Site 11 <<
	.uleb128 Ltmp21-Ltmp20                  ;   Call between Ltmp20 and Ltmp21
	.uleb128 Ltmp22-Lfunc_begin0            ;     jumps to Ltmp22
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp21-Lfunc_begin0            ; >> Call Site 12 <<
	.uleb128 Ltmp23-Ltmp21                  ;   Call between Ltmp21 and Ltmp23
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp23-Lfunc_begin0            ; >> Call Site 13 <<
	.uleb128 Ltmp24-Ltmp23                  ;   Call between Ltmp23 and Ltmp24
	.uleb128 Ltmp25-Lfunc_begin0            ;     jumps to Ltmp25
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp24-Lfunc_begin0            ; >> Call Site 14 <<
	.uleb128 Lfunc_end0-Ltmp24              ;   Call between Ltmp24 and Lfunc_end0
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
Lloh18:
	adrp	x8, __ZTVSt16invalid_argument@GOTPAGE
Lloh19:
	ldr	x8, [x8, __ZTVSt16invalid_argument@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x0]
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
	.loh AdrpLdrGot	Lloh18, Lloh19
	.cfi_endproc
                                        ; -- End function
	.globl	_main                           ; -- Begin function main
	.p2align	2
_main:                                  ; @main
Lfunc_begin1:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception1
; %bb.0:
	sub	sp, sp, #208
	stp	d9, d8, [sp, #96]               ; 16-byte Folded Spill
	stp	x28, x27, [sp, #112]            ; 16-byte Folded Spill
	stp	x26, x25, [sp, #128]            ; 16-byte Folded Spill
	stp	x24, x23, [sp, #144]            ; 16-byte Folded Spill
	stp	x22, x21, [sp, #160]            ; 16-byte Folded Spill
	stp	x20, x19, [sp, #176]            ; 16-byte Folded Spill
	stp	x29, x30, [sp, #192]            ; 16-byte Folded Spill
	add	x29, sp, #192
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
	mov	x19, x0
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x20, x0
Ltmp26:
Lloh20:
	adrp	x1, l_.str@PAGE
Lloh21:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt11logic_errorC2EPKc
Ltmp27:
; %bb.1:
Lloh22:
	adrp	x8, __ZTVSt16invalid_argument@GOTPAGE
Lloh23:
	ldr	x8, [x8, __ZTVSt16invalid_argument@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x20]
Ltmp29:
Lloh24:
	adrp	x1, __ZTISt16invalid_argument@GOTPAGE
Lloh25:
	ldr	x1, [x1, __ZTISt16invalid_argument@GOTPAGEOFF]
Lloh26:
	adrp	x2, __ZNSt16invalid_argumentD1Ev@GOTPAGE
Lloh27:
	ldr	x2, [x2, __ZNSt16invalid_argumentD1Ev@GOTPAGEOFF]
	mov	x0, x20
	bl	___cxa_throw
Ltmp30:
; %bb.2:
	brk	#0x1
LBB3_3:
Ltmp31:
	mov	x21, x1
	cmp	w21, #2
	b.eq	LBB3_5
	b	LBB3_95
LBB3_4:
Ltmp28:
	mov	x21, x1
	mov	x22, x0
	mov	x0, x20
	bl	___cxa_free_exception
	mov	x0, x22
	cmp	w21, #2
	b.ne	LBB3_95
LBB3_5:
	bl	___cxa_begin_catch
Ltmp32:
	bl	___cxa_end_catch
Ltmp33:
; %bb.6:
Ltmp35:
	add	x8, sp, #72
	mov	w0, #1                          ; =0x1
	mov	w1, #0                          ; =0x0
	bl	__Z9make_ringmb
Ltmp36:
; %bb.7:
	ldr	x0, [sp, #72]
	cbz	x0, LBB3_9
; %bb.8:
	str	x0, [sp, #80]
	mov	w1, #128                        ; =0x80
	bl	__ZdlPvSt11align_val_t
LBB3_9:
Ltmp37:
	add	x8, sp, #72
	mov	w0, #1                          ; =0x1
	mov	w1, #1                          ; =0x1
	bl	__Z9make_ringmb
Ltmp38:
; %bb.10:
	ldr	x0, [sp, #72]
	cbz	x0, LBB3_12
; %bb.11:
	str	x0, [sp, #80]
	mov	w1, #128                        ; =0x80
	bl	__ZdlPvSt11align_val_t
LBB3_12:
Ltmp39:
	add	x8, sp, #72
	mov	w0, #2                          ; =0x2
	mov	w1, #0                          ; =0x0
	bl	__Z9make_ringmb
Ltmp40:
; %bb.13:
	ldr	x0, [sp, #72]
	cbz	x0, LBB3_15
; %bb.14:
	str	x0, [sp, #80]
	mov	w1, #128                        ; =0x80
	bl	__ZdlPvSt11align_val_t
LBB3_15:
Ltmp41:
	add	x8, sp, #72
	mov	w0, #2                          ; =0x2
	mov	w1, #1                          ; =0x1
	bl	__Z9make_ringmb
Ltmp42:
; %bb.16:
	ldr	x0, [sp, #72]
	cbz	x0, LBB3_18
; %bb.17:
	str	x0, [sp, #80]
	mov	w1, #128                        ; =0x80
	bl	__ZdlPvSt11align_val_t
LBB3_18:
Ltmp43:
	add	x8, sp, #72
	mov	w0, #3                          ; =0x3
	mov	w1, #0                          ; =0x0
	bl	__Z9make_ringmb
Ltmp44:
; %bb.19:
	ldr	x0, [sp, #72]
	cbz	x0, LBB3_21
; %bb.20:
	str	x0, [sp, #80]
	mov	w1, #128                        ; =0x80
	bl	__ZdlPvSt11align_val_t
LBB3_21:
Ltmp45:
	add	x8, sp, #72
	mov	w0, #3                          ; =0x3
	mov	w1, #1                          ; =0x1
	bl	__Z9make_ringmb
Ltmp46:
; %bb.22:
	ldr	x0, [sp, #72]
	cbz	x0, LBB3_24
; %bb.23:
	str	x0, [sp, #80]
	mov	w1, #128                        ; =0x80
	bl	__ZdlPvSt11align_val_t
LBB3_24:
Ltmp47:
	add	x8, sp, #72
	mov	w0, #31                         ; =0x1f
	mov	w1, #0                          ; =0x0
	bl	__Z9make_ringmb
Ltmp48:
; %bb.25:
	ldr	x0, [sp, #72]
	cbz	x0, LBB3_27
; %bb.26:
	str	x0, [sp, #80]
	mov	w1, #128                        ; =0x80
	bl	__ZdlPvSt11align_val_t
LBB3_27:
Ltmp49:
	add	x8, sp, #72
	mov	w0, #31                         ; =0x1f
	mov	w1, #1                          ; =0x1
	bl	__Z9make_ringmb
Ltmp50:
; %bb.28:
	ldr	x0, [sp, #72]
	cbz	x0, LBB3_30
; %bb.29:
	str	x0, [sp, #80]
	mov	w1, #128                        ; =0x80
	bl	__ZdlPvSt11align_val_t
LBB3_30:
Ltmp51:
	add	x8, sp, #72
	mov	w0, #32                         ; =0x20
	mov	w1, #0                          ; =0x0
	bl	__Z9make_ringmb
Ltmp52:
; %bb.31:
	ldr	x0, [sp, #72]
	cbz	x0, LBB3_33
; %bb.32:
	str	x0, [sp, #80]
	mov	w1, #128                        ; =0x80
	bl	__ZdlPvSt11align_val_t
LBB3_33:
Ltmp53:
	add	x8, sp, #72
	mov	w0, #32                         ; =0x20
	mov	w1, #1                          ; =0x1
	bl	__Z9make_ringmb
Ltmp54:
; %bb.34:
	ldr	x0, [sp, #72]
	cbz	x0, LBB3_36
; %bb.35:
	str	x0, [sp, #80]
	mov	w1, #128                        ; =0x80
	bl	__ZdlPvSt11align_val_t
LBB3_36:
Ltmp55:
	add	x8, sp, #72
	mov	w0, #33                         ; =0x21
	mov	w1, #0                          ; =0x0
	bl	__Z9make_ringmb
Ltmp56:
; %bb.37:
	ldr	x0, [sp, #72]
	cbz	x0, LBB3_39
; %bb.38:
	str	x0, [sp, #80]
	mov	w1, #128                        ; =0x80
	bl	__ZdlPvSt11align_val_t
LBB3_39:
Ltmp57:
	add	x8, sp, #72
	mov	w0, #33                         ; =0x21
	mov	w1, #1                          ; =0x1
	bl	__Z9make_ringmb
Ltmp58:
; %bb.40:
	ldr	x0, [sp, #72]
	cbz	x0, LBB3_42
; %bb.41:
	str	x0, [sp, #80]
	mov	w1, #128                        ; =0x80
	bl	__ZdlPvSt11align_val_t
LBB3_42:
Ltmp59:
	add	x8, sp, #72
	mov	w0, #1025                       ; =0x401
	mov	w1, #0                          ; =0x0
	bl	__Z9make_ringmb
Ltmp60:
; %bb.43:
	ldr	x0, [sp, #72]
	cbz	x0, LBB3_45
; %bb.44:
	str	x0, [sp, #80]
	mov	w1, #128                        ; =0x80
	bl	__ZdlPvSt11align_val_t
LBB3_45:
Ltmp61:
	add	x8, sp, #72
	mov	w0, #1025                       ; =0x401
	mov	w1, #1                          ; =0x1
	bl	__Z9make_ringmb
Ltmp62:
; %bb.46:
	ldr	x0, [sp, #72]
	cbz	x0, LBB3_48
; %bb.47:
	str	x0, [sp, #80]
	mov	w1, #128                        ; =0x80
	bl	__ZdlPvSt11align_val_t
LBB3_48:
	cmp	w19, #1
	b.le	LBB3_50
; %bb.49:
Ltmp117:
Lloh28:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh29:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh30:
	adrp	x1, l_.str.3@PAGE
Lloh31:
	add	x1, x1, l_.str.3@PAGEOFF
	mov	w2, #39                         ; =0x27
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp118:
	b	LBB3_83
LBB3_50:
Ltmp64:
Lloh32:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh33:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh34:
	adrp	x1, l_.str.4@PAGE
Lloh35:
	add	x1, x1, l_.str.4@PAGEOFF
	mov	w2, #66                         ; =0x42
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp65:
; %bb.51:
	mov	x8, #0                          ; =0x0
	adrp	x27, _sink@PAGE
	mov	w28, #44                        ; =0x2c
	b	LBB3_53
LBB3_52:                                ;   in Loop: Header=BB3_53 Depth=1
	ldr	x8, [sp]                        ; 8-byte Folded Reload
	add	x8, x8, #4
	cmp	x8, #24
	b.eq	LBB3_80
LBB3_53:                                ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB3_55 Depth 2
	mov	x19, #0                         ; =0x0
	str	x8, [sp]                        ; 8-byte Folded Spill
Lloh36:
	adrp	x9, l_constinit.5@PAGE
Lloh37:
	add	x9, x9, l_constinit.5@PAGEOFF
	ldrsw	x21, [x9, x8]
	mov	w8, #256                        ; =0x100
	strh	w8, [sp, #70]
	lsr	x22, x21, #7
	b	LBB3_55
LBB3_54:                                ;   in Loop: Header=BB3_55 Depth=2
	add	x19, x19, #1
	cmp	x19, #2
	b.eq	LBB3_52
LBB3_55:                                ;   Parent Loop BB3_53 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	add	x8, sp, #70
	ldrb	w23, [x8, x19]
Ltmp66:
	add	x8, sp, #40
	mov	x0, x22
	mov	x1, x23
	bl	__Z9make_ringmb
Ltmp67:
; %bb.56:                               ;   in Loop: Header=BB3_55 Depth=2
	ldp	x20, x8, [sp, #40]
	sub	x8, x8, x20
	asr	x8, x8, #6
	cmp	x8, #64, lsl #12                ; =262144
	mov	w9, #262144                     ; =0x40000
	csel	x24, x8, x9, hi
	mov	x0, x20
	mov	x1, #0                          ; =0x0
	mov	x2, x24
	bl	_chase
	str	x0, [x27, _sink@PAGEOFF]
	stp	xzr, xzr, [sp, #16]
	str	xzr, [sp, #32]
	ucvtf	d8, x24
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x25, x0
	mov	x0, x20
	mov	x1, #0                          ; =0x0
	mov	x2, x24
	bl	_chase
	mov	x26, x0
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	str	x26, [x27, _sink@PAGEOFF]
	sub	x8, x0, x25
	scvtf	d0, x8
	fdiv	d0, d0, d8
	str	d0, [sp, #8]
Ltmp69:
	add	x0, sp, #16
	add	x1, sp, #8
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE9push_backB9nqe210106EOd
Ltmp70:
; %bb.57:                               ;   in Loop: Header=BB3_55 Depth=2
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x25, x0
	mov	x0, x20
	mov	x1, #0                          ; =0x0
	mov	x2, x24
	bl	_chase
	mov	x26, x0
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	str	x26, [x27, _sink@PAGEOFF]
	sub	x8, x0, x25
	scvtf	d0, x8
	fdiv	d0, d0, d8
	str	d0, [sp, #8]
Ltmp71:
	add	x0, sp, #16
	add	x1, sp, #8
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE9push_backB9nqe210106EOd
Ltmp72:
; %bb.58:                               ;   in Loop: Header=BB3_55 Depth=2
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x25, x0
	mov	x0, x20
	mov	x1, #0                          ; =0x0
	mov	x2, x24
	bl	_chase
	mov	x26, x0
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	str	x26, [x27, _sink@PAGEOFF]
	sub	x8, x0, x25
	scvtf	d0, x8
	fdiv	d0, d0, d8
	str	d0, [sp, #8]
Ltmp73:
	add	x0, sp, #16
	add	x1, sp, #8
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE9push_backB9nqe210106EOd
Ltmp74:
; %bb.59:                               ;   in Loop: Header=BB3_55 Depth=2
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x25, x0
	mov	x0, x20
	mov	x1, #0                          ; =0x0
	mov	x2, x24
	bl	_chase
	mov	x26, x0
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	str	x26, [x27, _sink@PAGEOFF]
	sub	x8, x0, x25
	scvtf	d0, x8
	fdiv	d0, d0, d8
	str	d0, [sp, #8]
Ltmp75:
	add	x0, sp, #16
	add	x1, sp, #8
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE9push_backB9nqe210106EOd
Ltmp76:
; %bb.60:                               ;   in Loop: Header=BB3_55 Depth=2
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x25, x0
	mov	x0, x20
	mov	x1, #0                          ; =0x0
	mov	x2, x24
	bl	_chase
	mov	x26, x0
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	str	x26, [x27, _sink@PAGEOFF]
	sub	x8, x0, x25
	scvtf	d0, x8
	fdiv	d0, d0, d8
	str	d0, [sp, #8]
Ltmp77:
	add	x0, sp, #16
	add	x1, sp, #8
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE9push_backB9nqe210106EOd
Ltmp78:
; %bb.61:                               ;   in Loop: Header=BB3_55 Depth=2
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x25, x0
	mov	x0, x20
	mov	x1, #0                          ; =0x0
	mov	x2, x24
	bl	_chase
	mov	x26, x0
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	str	x26, [x27, _sink@PAGEOFF]
	sub	x8, x0, x25
	scvtf	d0, x8
	fdiv	d0, d0, d8
	str	d0, [sp, #8]
Ltmp79:
	add	x0, sp, #16
	add	x1, sp, #8
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE9push_backB9nqe210106EOd
Ltmp80:
; %bb.62:                               ;   in Loop: Header=BB3_55 Depth=2
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x25, x0
	mov	x0, x20
	mov	x1, #0                          ; =0x0
	mov	x2, x24
	bl	_chase
	mov	x26, x0
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	str	x26, [x27, _sink@PAGEOFF]
	sub	x8, x0, x25
	scvtf	d0, x8
	fdiv	d0, d0, d8
	str	d0, [sp, #8]
Ltmp81:
	add	x0, sp, #16
	add	x1, sp, #8
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE9push_backB9nqe210106EOd
Ltmp82:
; %bb.63:                               ;   in Loop: Header=BB3_55 Depth=2
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x25, x0
	mov	x0, x20
	mov	x1, #0                          ; =0x0
	mov	x2, x24
	bl	_chase
	mov	x26, x0
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	str	x26, [x27, _sink@PAGEOFF]
	sub	x8, x0, x25
	scvtf	d0, x8
	fdiv	d0, d0, d8
	str	d0, [sp, #8]
Ltmp83:
	add	x0, sp, #16
	add	x1, sp, #8
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE9push_backB9nqe210106EOd
Ltmp84:
; %bb.64:                               ;   in Loop: Header=BB3_55 Depth=2
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x25, x0
	mov	x0, x20
	mov	x1, #0                          ; =0x0
	mov	x2, x24
	bl	_chase
	mov	x26, x0
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	str	x26, [x27, _sink@PAGEOFF]
	sub	x8, x0, x25
	scvtf	d0, x8
	fdiv	d0, d0, d8
	str	d0, [sp, #8]
Ltmp85:
	add	x0, sp, #16
	add	x1, sp, #8
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE9push_backB9nqe210106EOd
Ltmp86:
; %bb.65:                               ;   in Loop: Header=BB3_55 Depth=2
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x25, x0
	mov	x0, x20
	mov	x1, #0                          ; =0x0
	mov	x2, x24
	bl	_chase
	mov	x26, x0
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	str	x26, [x27, _sink@PAGEOFF]
	sub	x8, x0, x25
	scvtf	d0, x8
	fdiv	d0, d0, d8
	str	d0, [sp, #8]
Ltmp87:
	add	x0, sp, #16
	add	x1, sp, #8
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE9push_backB9nqe210106EOd
Ltmp88:
; %bb.66:                               ;   in Loop: Header=BB3_55 Depth=2
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x25, x0
	mov	x0, x20
	mov	x1, #0                          ; =0x0
	mov	x2, x24
	bl	_chase
	mov	x24, x0
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	str	x24, [x27, _sink@PAGEOFF]
	sub	x8, x0, x25
	scvtf	d0, x8
	fdiv	d0, d0, d8
	str	d0, [sp, #8]
Ltmp89:
	add	x0, sp, #16
	add	x1, sp, #8
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE9push_backB9nqe210106EOd
Ltmp90:
; %bb.67:                               ;   in Loop: Header=BB3_55 Depth=2
	ldp	x0, x1, [sp, #16]
Ltmp92:
	add	x2, sp, #8
	bl	__ZNSt3__16__sortIRNS_6__lessIddEEPdEEvT0_S5_T_
Ltmp93:
	mov	w24, #10                        ; =0xa
; %bb.68:                               ;   in Loop: Header=BB3_55 Depth=2
Ltmp94:
Lloh38:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh39:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
	mov	x1, x21
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp95:
; %bb.69:                               ;   in Loop: Header=BB3_55 Depth=2
	strb	w28, [sp, #8]
Ltmp96:
	add	x1, sp, #8
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp97:
; %bb.70:                               ;   in Loop: Header=BB3_55 Depth=2
	cmp	w23, #0
Lloh40:
	adrp	x8, l_.str.7@PAGE
Lloh41:
	add	x8, x8, l_.str.7@PAGEOFF
Lloh42:
	adrp	x9, l_.str.6@PAGE
Lloh43:
	add	x9, x9, l_.str.6@PAGEOFF
	csel	x1, x9, x8, ne
	mov	w8, #6                          ; =0x6
	csel	x2, x8, x24, ne
Ltmp98:
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp99:
; %bb.71:                               ;   in Loop: Header=BB3_55 Depth=2
	strb	w28, [sp, #8]
Ltmp100:
	add	x1, sp, #8
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp101:
; %bb.72:                               ;   in Loop: Header=BB3_55 Depth=2
	ldr	x8, [sp, #16]
	ldr	d0, [x8, #40]
Ltmp102:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp103:
; %bb.73:                               ;   in Loop: Header=BB3_55 Depth=2
	strb	w28, [sp, #8]
Ltmp104:
	add	x1, sp, #8
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp105:
; %bb.74:                               ;   in Loop: Header=BB3_55 Depth=2
	ldr	x8, [sp, #16]
	ldr	d0, [x8, #80]
Ltmp106:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp107:
; %bb.75:                               ;   in Loop: Header=BB3_55 Depth=2
	strb	w24, [sp, #8]
Ltmp108:
	add	x1, sp, #8
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp109:
; %bb.76:                               ;   in Loop: Header=BB3_55 Depth=2
	ldr	x0, [sp, #16]
	cbz	x0, LBB3_78
; %bb.77:                               ;   in Loop: Header=BB3_55 Depth=2
	str	x0, [sp, #24]
	bl	__ZdlPv
LBB3_78:                                ;   in Loop: Header=BB3_55 Depth=2
	cbz	x20, LBB3_54
; %bb.79:                               ;   in Loop: Header=BB3_55 Depth=2
	mov	x0, x20
	mov	w1, #128                        ; =0x80
	bl	__ZdlPvSt11align_val_t
	b	LBB3_54
LBB3_80:
Ltmp111:
Lloh44:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh45:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh46:
	adrp	x1, l_.str.8@PAGE
Lloh47:
	add	x1, x1, l_.str.8@PAGEOFF
	mov	w2, #44                         ; =0x2c
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp112:
; %bb.81:
	ldr	x1, [x27, _sink@PAGEOFF]
Ltmp113:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp114:
; %bb.82:
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #16]
Ltmp115:
	add	x1, sp, #16
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp116:
LBB3_83:
	mov	w0, #0                          ; =0x0
	b	LBB3_99
LBB3_84:
Ltmp34:
	b	LBB3_88
LBB3_85:
Ltmp119:
	b	LBB3_88
LBB3_86:
Ltmp63:
	b	LBB3_88
LBB3_87:
Ltmp68:
LBB3_88:
	mov	x21, x1
	b	LBB3_95
LBB3_89:
Ltmp110:
	b	LBB3_91
LBB3_90:
Ltmp91:
LBB3_91:
	mov	x21, x1
	ldr	x8, [sp, #16]
	cbz	x8, LBB3_93
; %bb.92:
	str	x8, [sp, #24]
	mov	x19, x0
	mov	x0, x8
	bl	__ZdlPv
	mov	x0, x19
LBB3_93:
	cbz	x20, LBB3_95
; %bb.94:
	mov	x19, x0
	mov	x0, x20
	mov	w1, #128                        ; =0x80
	bl	__ZdlPvSt11align_val_t
	mov	x0, x19
LBB3_95:
	cmp	w21, #1
	b.ne	LBB3_100
; %bb.96:
	bl	___cxa_begin_catch
	ldr	x8, [x0]
	ldr	x8, [x8, #16]
	blr	x8
	mov	x19, x0
	bl	_strlen
	mov	x2, x0
Ltmp120:
Lloh48:
	adrp	x0, __ZNSt3__14cerrE@GOTPAGE
Lloh49:
	ldr	x0, [x0, __ZNSt3__14cerrE@GOTPAGEOFF]
	mov	x1, x19
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp121:
; %bb.97:
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #40]
Ltmp122:
	add	x1, sp, #40
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp123:
; %bb.98:
	bl	___cxa_end_catch
	mov	w0, #1                          ; =0x1
LBB3_99:
	ldp	x29, x30, [sp, #192]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #176]            ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #160]            ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #144]            ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #128]            ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #112]            ; 16-byte Folded Reload
	ldp	d9, d8, [sp, #96]               ; 16-byte Folded Reload
	add	sp, sp, #208
	ret
LBB3_100:
	bl	__Unwind_Resume
LBB3_101:
Ltmp124:
	mov	x19, x0
Ltmp125:
	bl	___cxa_end_catch
Ltmp126:
; %bb.102:
	mov	x0, x19
	bl	__Unwind_Resume
LBB3_103:
Ltmp127:
	bl	___clang_call_terminate
	.loh AdrpAdd	Lloh20, Lloh21
	.loh AdrpLdrGot	Lloh26, Lloh27
	.loh AdrpLdrGot	Lloh24, Lloh25
	.loh AdrpLdrGot	Lloh22, Lloh23
	.loh AdrpAdd	Lloh30, Lloh31
	.loh AdrpLdrGot	Lloh28, Lloh29
	.loh AdrpAdd	Lloh34, Lloh35
	.loh AdrpLdrGot	Lloh32, Lloh33
	.loh AdrpAdd	Lloh36, Lloh37
	.loh AdrpLdrGot	Lloh38, Lloh39
	.loh AdrpAdd	Lloh42, Lloh43
	.loh AdrpAdd	Lloh40, Lloh41
	.loh AdrpAdd	Lloh46, Lloh47
	.loh AdrpLdrGot	Lloh44, Lloh45
	.loh AdrpLdrGot	Lloh48, Lloh49
Lfunc_end1:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table3:
Lexception1:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase0-Lttbaseref0
Lttbaseref0:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end1-Lcst_begin1
Lcst_begin1:
	.uleb128 Lfunc_begin1-Lfunc_begin1      ; >> Call Site 1 <<
	.uleb128 Ltmp26-Lfunc_begin1            ;   Call between Lfunc_begin1 and Ltmp26
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp26-Lfunc_begin1            ; >> Call Site 2 <<
	.uleb128 Ltmp27-Ltmp26                  ;   Call between Ltmp26 and Ltmp27
	.uleb128 Ltmp28-Lfunc_begin1            ;     jumps to Ltmp28
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp29-Lfunc_begin1            ; >> Call Site 3 <<
	.uleb128 Ltmp30-Ltmp29                  ;   Call between Ltmp29 and Ltmp30
	.uleb128 Ltmp31-Lfunc_begin1            ;     jumps to Ltmp31
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp30-Lfunc_begin1            ; >> Call Site 4 <<
	.uleb128 Ltmp32-Ltmp30                  ;   Call between Ltmp30 and Ltmp32
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp32-Lfunc_begin1            ; >> Call Site 5 <<
	.uleb128 Ltmp33-Ltmp32                  ;   Call between Ltmp32 and Ltmp33
	.uleb128 Ltmp34-Lfunc_begin1            ;     jumps to Ltmp34
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp35-Lfunc_begin1            ; >> Call Site 6 <<
	.uleb128 Ltmp62-Ltmp35                  ;   Call between Ltmp35 and Ltmp62
	.uleb128 Ltmp63-Lfunc_begin1            ;     jumps to Ltmp63
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp117-Lfunc_begin1           ; >> Call Site 7 <<
	.uleb128 Ltmp65-Ltmp117                 ;   Call between Ltmp117 and Ltmp65
	.uleb128 Ltmp119-Lfunc_begin1           ;     jumps to Ltmp119
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp66-Lfunc_begin1            ; >> Call Site 8 <<
	.uleb128 Ltmp67-Ltmp66                  ;   Call between Ltmp66 and Ltmp67
	.uleb128 Ltmp68-Lfunc_begin1            ;     jumps to Ltmp68
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp69-Lfunc_begin1            ; >> Call Site 9 <<
	.uleb128 Ltmp90-Ltmp69                  ;   Call between Ltmp69 and Ltmp90
	.uleb128 Ltmp91-Lfunc_begin1            ;     jumps to Ltmp91
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp92-Lfunc_begin1            ; >> Call Site 10 <<
	.uleb128 Ltmp109-Ltmp92                 ;   Call between Ltmp92 and Ltmp109
	.uleb128 Ltmp110-Lfunc_begin1           ;     jumps to Ltmp110
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp111-Lfunc_begin1           ; >> Call Site 11 <<
	.uleb128 Ltmp116-Ltmp111                ;   Call between Ltmp111 and Ltmp116
	.uleb128 Ltmp119-Lfunc_begin1           ;     jumps to Ltmp119
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp116-Lfunc_begin1           ; >> Call Site 12 <<
	.uleb128 Ltmp120-Ltmp116                ;   Call between Ltmp116 and Ltmp120
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp120-Lfunc_begin1           ; >> Call Site 13 <<
	.uleb128 Ltmp123-Ltmp120                ;   Call between Ltmp120 and Ltmp123
	.uleb128 Ltmp124-Lfunc_begin1           ;     jumps to Ltmp124
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp123-Lfunc_begin1           ; >> Call Site 14 <<
	.uleb128 Ltmp125-Ltmp123                ;   Call between Ltmp123 and Ltmp125
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp125-Lfunc_begin1           ; >> Call Site 15 <<
	.uleb128 Ltmp126-Ltmp125                ;   Call between Ltmp125 and Ltmp126
	.uleb128 Ltmp127-Lfunc_begin1           ;     jumps to Ltmp127
	.byte	9                               ;   On action: 5
	.uleb128 Ltmp126-Lfunc_begin1           ; >> Call Site 16 <<
	.uleb128 Lfunc_end1-Ltmp126             ;   Call between Ltmp126 and Lfunc_end1
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
Ltmp156:                                ; TypeInfo 2
	.long	__ZTISt16invalid_argument@GOT-Ltmp156
Ltmp157:                                ; TypeInfo 1
	.long	__ZTISt9exception@GOT-Ltmp157
Lttbase0:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.private_extern	__ZNSt3__16vectorIdNS_9allocatorIdEEE9push_backB9nqe210106EOd ; -- Begin function _ZNSt3__16vectorIdNS_9allocatorIdEEE9push_backB9nqe210106EOd
	.globl	__ZNSt3__16vectorIdNS_9allocatorIdEEE9push_backB9nqe210106EOd
	.weak_def_can_be_hidden	__ZNSt3__16vectorIdNS_9allocatorIdEEE9push_backB9nqe210106EOd
	.p2align	2
__ZNSt3__16vectorIdNS_9allocatorIdEEE9push_backB9nqe210106EOd: ; @_ZNSt3__16vectorIdNS_9allocatorIdEEE9push_backB9nqe210106EOd
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
	mov	x21, x1
	mov	x19, x0
	ldp	x24, x8, [x0, #8]
	cmp	x24, x8
	b.hs	LBB4_2
; %bb.1:
	ldr	d0, [x21]
	str	d0, [x24], #8
	b	LBB4_6
LBB4_2:
	ldr	x20, [x19]
	sub	x22, x24, x20
	asr	x25, x22, #3
	add	x9, x25, #1
	lsr	x10, x9, #61
	cbnz	x10, LBB4_7
; %bb.3:
	mov	x10, #9223372036854775800       ; =0x7ffffffffffffff8
	sub	x8, x8, x20
	asr	x11, x8, #2
	cmp	x11, x9
	csel	x9, x11, x9, hi
	cmp	x8, x10
	mov	x8, #2305843009213693951        ; =0x1fffffffffffffff
	csel	x8, x9, x8, lo
	lsr	x9, x8, #61
	cbnz	x9, LBB4_8
; %bb.4:
	lsl	x23, x8, #3
	mov	x0, x23
	bl	__Znwm
	add	x24, x0, x22
	add	x23, x0, x23
	ldr	d0, [x21]
	sub	x21, x24, x25, lsl #3
	str	d0, [x24], #8
	mov	x0, x21
	mov	x1, x20
	mov	x2, x22
	bl	_memcpy
	stp	x21, x24, [x19]
	str	x23, [x19, #16]
	cbz	x20, LBB4_6
; %bb.5:
	mov	x0, x20
	bl	__ZdlPv
LBB4_6:
	str	x24, [x19, #8]
	ldp	x29, x30, [sp, #64]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #48]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #32]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #16]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp], #80             ; 16-byte Folded Reload
	ret
LBB4_7:
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_length_errorB9nqe210106Ev
LBB4_8:
	bl	__ZSt28__throw_bad_array_new_lengthB9nqe210106v
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
	.private_extern	__ZNSt3__16vectorI4NodeNS_9allocatorIS1_EEE20__throw_length_errorB9nqe210106Ev ; -- Begin function _ZNSt3__16vectorI4NodeNS_9allocatorIS1_EEE20__throw_length_errorB9nqe210106Ev
	.globl	__ZNSt3__16vectorI4NodeNS_9allocatorIS1_EEE20__throw_length_errorB9nqe210106Ev
	.weak_def_can_be_hidden	__ZNSt3__16vectorI4NodeNS_9allocatorIS1_EEE20__throw_length_errorB9nqe210106Ev
	.p2align	2
__ZNSt3__16vectorI4NodeNS_9allocatorIS1_EEE20__throw_length_errorB9nqe210106Ev: ; @_ZNSt3__16vectorI4NodeNS_9allocatorIS1_EEE20__throw_length_errorB9nqe210106Ev
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh50:
	adrp	x0, l_.str.9@PAGE
Lloh51:
	add	x0, x0, l_.str.9@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh50, Lloh51
	.cfi_endproc
                                        ; -- End function
	.private_extern	__ZNSt3__120__throw_length_errorB9nqe210106EPKc ; -- Begin function _ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.globl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.weak_def_can_be_hidden	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.p2align	2
__ZNSt3__120__throw_length_errorB9nqe210106EPKc: ; @_ZNSt3__120__throw_length_errorB9nqe210106EPKc
Lfunc_begin2:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception2
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
Ltmp128:
	mov	x1, x20
	bl	__ZNSt12length_errorC1B9nqe210106EPKc
Ltmp129:
; %bb.1:
Lloh52:
	adrp	x1, __ZTISt12length_error@GOTPAGE
Lloh53:
	ldr	x1, [x1, __ZTISt12length_error@GOTPAGEOFF]
Lloh54:
	adrp	x2, __ZNSt12length_errorD1Ev@GOTPAGE
Lloh55:
	ldr	x2, [x2, __ZNSt12length_errorD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
LBB7_2:
Ltmp130:
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x0, x20
	bl	__Unwind_Resume
	.loh AdrpLdrGot	Lloh54, Lloh55
	.loh AdrpLdrGot	Lloh52, Lloh53
Lfunc_end2:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table7:
Lexception2:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end2-Lcst_begin2
Lcst_begin2:
	.uleb128 Lfunc_begin2-Lfunc_begin2      ; >> Call Site 1 <<
	.uleb128 Ltmp128-Lfunc_begin2           ;   Call between Lfunc_begin2 and Ltmp128
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp128-Lfunc_begin2           ; >> Call Site 2 <<
	.uleb128 Ltmp129-Ltmp128                ;   Call between Ltmp128 and Ltmp129
	.uleb128 Ltmp130-Lfunc_begin2           ;     jumps to Ltmp130
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp129-Lfunc_begin2           ; >> Call Site 3 <<
	.uleb128 Lfunc_end2-Ltmp129             ;   Call between Ltmp129 and Lfunc_end2
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end2:
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
Lloh56:
	adrp	x8, __ZTVSt12length_error@GOTPAGE
Lloh57:
	ldr	x8, [x8, __ZTVSt12length_error@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x0]
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
	.loh AdrpLdrGot	Lloh56, Lloh57
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
Lloh58:
	adrp	x1, __ZTISt20bad_array_new_length@GOTPAGE
Lloh59:
	ldr	x1, [x1, __ZTISt20bad_array_new_length@GOTPAGEOFF]
Lloh60:
	adrp	x2, __ZNSt20bad_array_new_lengthD1Ev@GOTPAGE
Lloh61:
	ldr	x2, [x2, __ZNSt20bad_array_new_lengthD1Ev@GOTPAGEOFF]
	bl	___cxa_throw
	.loh AdrpLdrGot	Lloh60, Lloh61
	.loh AdrpLdrGot	Lloh58, Lloh59
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__literal16,16byte_literals
	.p2align	4, 0x0                          ; -- Begin function _ZNSt3__124uniform_int_distributionIlEclINS_23mersenne_twister_engineIjLm32ELm624ELm397ELm31ELj2567483615ELm11ELj4294967295ELm7ELj2636928640ELm15ELj4022730752ELm18ELj1812433253EEEEElRT_RKNS1_10param_typeE
lCPI10_0:
	.quad	64                              ; 0x40
	.quad	32                              ; 0x20
lCPI10_1:
	.quad	4294967296                      ; 0x100000000
	.quad	0                               ; 0x0
	.section	__TEXT,__text,regular,pure_instructions
	.private_extern	__ZNSt3__124uniform_int_distributionIlEclINS_23mersenne_twister_engineIjLm32ELm624ELm397ELm31ELj2567483615ELm11ELj4294967295ELm7ELj2636928640ELm15ELj4022730752ELm18ELj1812433253EEEEElRT_RKNS1_10param_typeE
	.globl	__ZNSt3__124uniform_int_distributionIlEclINS_23mersenne_twister_engineIjLm32ELm624ELm397ELm31ELj2567483615ELm11ELj4294967295ELm7ELj2636928640ELm15ELj4022730752ELm18ELj1812433253EEEEElRT_RKNS1_10param_typeE
	.weak_def_can_be_hidden	__ZNSt3__124uniform_int_distributionIlEclINS_23mersenne_twister_engineIjLm32ELm624ELm397ELm31ELj2567483615ELm11ELj4294967295ELm7ELj2636928640ELm15ELj4022730752ELm18ELj1812433253EEEEElRT_RKNS1_10param_typeE
	.p2align	2
__ZNSt3__124uniform_int_distributionIlEclINS_23mersenne_twister_engineIjLm32ELm624ELm397ELm31ELj2567483615ELm11ELj4294967295ELm7ELj2636928640ELm15ELj4022730752ELm18ELj1812433253EEEEElRT_RKNS1_10param_typeE: ; @_ZNSt3__124uniform_int_distributionIlEclINS_23mersenne_twister_engineIjLm32ELm624ELm397ELm31ELj2567483615ELm11ELj4294967295ELm7ELj2636928640ELm15ELj4022730752ELm18ELj1812433253EEEEElRT_RKNS1_10param_typeE
	.cfi_startproc
; %bb.0:
	ldp	x8, x0, [x2]
	subs	x8, x0, x8
	b.eq	LBB10_14
; %bb.1:
	sub	sp, sp, #96
	stp	x20, x19, [sp, #64]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #80]             ; 16-byte Folded Spill
	add	x29, sp, #80
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	add	x19, x8, #1
	cbz	x19, LBB10_7
; %bb.2:
	clz	x8, x19
	lsl	x9, x19, x8
	tst	x9, #0x7fffffffffffffff
	mov	w9, #63                         ; =0x3f
	cinc	x9, x9, ne
	sub	x10, x9, x8
	stp	x1, x10, [sp]
	add	x8, x10, #31
	lsr	x9, x8, #5
	udiv	w8, w10, w9
	stp	x8, x9, [sp, #16]
	mov	x11, #-1                        ; =0xffffffffffffffff
	lsl	x11, x11, x8
	and	x11, x11, #0x100000000
	cmp	w8, #64
	csel	x11, x11, xzr, lo
	str	x11, [sp, #40]
	eor	x12, x11, #0x100000000
	udiv	x11, x11, x9
	cmp	x12, x11
	b.ls	LBB10_5
; %bb.3:
	add	x9, x9, #1
	and	w8, w10, #0xff
	and	w11, w9, #0xff
	udiv	w8, w8, w11
	stp	x8, x9, [sp, #16]
	cmp	w8, #63
	b.hi	LBB10_8
; %bb.4:
	mov	x11, #-1                        ; =0xffffffffffffffff
	lsl	x11, x11, x8
	and	x11, x11, #0x100000000
	str	x11, [sp, #40]
LBB10_5:
	and	w11, w9, #0xff
	and	w10, w10, #0xff
	udiv	w12, w10, w11
	msub	w10, w12, w11, w10
	sub	x9, x9, x10
	str	x9, [sp, #32]
	mov	x20, x2
	cmp	x8, #63
	b.hs	LBB10_9
; %bb.6:
	add	x9, x8, #1
	mov	w10, #-2147483648               ; =0x80000000
	lsr	x10, x10, x8
	lsl	x9, x10, x9
	str	x9, [sp, #48]
	neg	w9, w8
	mov	w10, #-1                        ; =0xffffffff
	lsr	w9, w10, w9
	cmp	x8, #0
	csel	w9, wzr, w9, eq
	str	w9, [sp, #56]
	mvn	w9, w8
	lsr	w9, w10, w9
	cmp	x8, #31
	csinv	w8, w9, wzr, lo
	b	LBB10_10
LBB10_7:
	str	x1, [sp]
Lloh62:
	adrp	x8, lCPI10_0@PAGE
Lloh63:
	ldr	q0, [x8, lCPI10_0@PAGEOFF]
	stur	q0, [sp, #8]
	mov	w8, #2                          ; =0x2
	dup.2d	v0, x8
	stur	q0, [sp, #24]
Lloh64:
	adrp	x8, lCPI10_1@PAGE
Lloh65:
	ldr	q0, [x8, lCPI10_1@PAGEOFF]
	stur	q0, [sp, #40]
	movi.2d	v0, #0xffffffffffffffff
	str	d0, [sp, #56]
	mov	x0, sp
	bl	__ZNSt3__125__independent_bits_engineINS_23mersenne_twister_engineIjLm32ELm624ELm397ELm31ELj2567483615ELm11ELj4294967295ELm7ELj2636928640ELm15ELj4022730752ELm18ELj1812433253EEEmE6__evalENS_17integral_constantIbLb1EEE
	b	LBB10_13
LBB10_8:
	mov	x20, x2
	msub	w8, w8, w9, w10
	sub	x8, x9, w8, uxtb
	stp	x8, xzr, [sp, #32]
	mov	w8, #64                         ; =0x40
LBB10_9:
	str	xzr, [sp, #48]
	neg	w9, w8
	mov	w8, #-1                         ; =0xffffffff
	lsr	w9, w8, w9
	str	w9, [sp, #56]
LBB10_10:
	str	w8, [sp, #60]
LBB10_11:                               ; =>This Inner Loop Header: Depth=1
	mov	x0, sp
	bl	__ZNSt3__125__independent_bits_engineINS_23mersenne_twister_engineIjLm32ELm624ELm397ELm31ELj2567483615ELm11ELj4294967295ELm7ELj2636928640ELm15ELj4022730752ELm18ELj1812433253EEEmE6__evalENS_17integral_constantIbLb1EEE
	cmp	x0, x19
	b.hs	LBB10_11
; %bb.12:
	ldr	x8, [x20]
	add	x0, x8, x0
LBB10_13:
	ldp	x29, x30, [sp, #80]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #64]             ; 16-byte Folded Reload
	add	sp, sp, #96
LBB10_14:
	ret
	.loh AdrpLdr	Lloh64, Lloh65
	.loh AdrpLdr	Lloh62, Lloh63
	.cfi_endproc
                                        ; -- End function
	.private_extern	__ZNSt3__125__independent_bits_engineINS_23mersenne_twister_engineIjLm32ELm624ELm397ELm31ELj2567483615ELm11ELj4294967295ELm7ELj2636928640ELm15ELj4022730752ELm18ELj1812433253EEEmE6__evalENS_17integral_constantIbLb1EEE ; -- Begin function _ZNSt3__125__independent_bits_engineINS_23mersenne_twister_engineIjLm32ELm624ELm397ELm31ELj2567483615ELm11ELj4294967295ELm7ELj2636928640ELm15ELj4022730752ELm18ELj1812433253EEEmE6__evalENS_17integral_constantIbLb1EEE
	.globl	__ZNSt3__125__independent_bits_engineINS_23mersenne_twister_engineIjLm32ELm624ELm397ELm31ELj2567483615ELm11ELj4294967295ELm7ELj2636928640ELm15ELj4022730752ELm18ELj1812433253EEEmE6__evalENS_17integral_constantIbLb1EEE
	.weak_def_can_be_hidden	__ZNSt3__125__independent_bits_engineINS_23mersenne_twister_engineIjLm32ELm624ELm397ELm31ELj2567483615ELm11ELj4294967295ELm7ELj2636928640ELm15ELj4022730752ELm18ELj1812433253EEEmE6__evalENS_17integral_constantIbLb1EEE
	.p2align	2
__ZNSt3__125__independent_bits_engineINS_23mersenne_twister_engineIjLm32ELm624ELm397ELm31ELj2567483615ELm11ELj4294967295ELm7ELj2636928640ELm15ELj4022730752ELm18ELj1812433253EEEmE6__evalENS_17integral_constantIbLb1EEE: ; @_ZNSt3__125__independent_bits_engineINS_23mersenne_twister_engineIjLm32ELm624ELm397ELm31ELj2567483615ELm11ELj4294967295ELm7ELj2636928640ELm15ELj4022730752ELm18ELj1812433253EEEmE6__evalENS_17integral_constantIbLb1EEE
	.cfi_startproc
; %bb.0:
	mov	w9, #-272236544                 ; =0xefc60000
	mov	w10, #22144                     ; =0x5680
	movk	w10, #40236, lsl #16
	mov	w11, #45279                     ; =0xb0df
	movk	w11, #39176, lsl #16
	ldr	x12, [x0, #32]
	cbz	x12, LBB11_5
; %bb.1:
	ldr	x13, [x0]
	ldr	x14, [x0, #40]
	ldr	x16, [x0, #16]
	ldr	x15, [x13, #2496]
	cmp	x16, #64
	b.hs	LBB11_7
; %bb.2:
	mov	x8, #0                          ; =0x0
	mov	x17, #0                         ; =0x0
	mov	x1, #3361                       ; =0xd21
	movk	x1, #8402, lsl #16
	movk	x1, #53773, lsl #32
	movk	x1, #3360, lsl #48
	mov	w2, #624                        ; =0x270
LBB11_3:                                ; =>This Inner Loop Header: Depth=1
	mov	x3, x15
	add	x15, x15, #1
	lsr	x4, x15, #4
	umulh	x4, x4, x1
	lsr	x4, x4, #1
	msub	x15, x4, x2, x15
	ldr	w4, [x13, x3, lsl #2]
	and	w4, w4, #0x80000000
	ldr	w5, [x13, x15, lsl #2]
	and	w6, w5, #0x7ffffffe
	orr	w4, w6, w4
	add	x6, x3, #397
	lsr	x7, x6, #4
	umulh	x7, x7, x1
	lsr	x7, x7, #1
	msub	x6, x7, x2, x6
	ldr	w6, [x13, x6, lsl #2]
	tst	w5, #0x1
	csel	w5, w11, wzr, ne
	eor	w5, w5, w6
	eor	w4, w5, w4, lsr #1
	str	w4, [x13, x3, lsl #2]
	eor	w3, w4, w4, lsr #11
	and	w4, w10, w3, lsl #7
	eor	w3, w4, w3
	and	w4, w9, w3, lsl #15
	eor	w3, w4, w3
	eor	w3, w3, w3, lsr #18
	cmp	x14, x3
	b.ls	LBB11_3
; %bb.4:                                ;   in Loop: Header=BB11_3 Depth=1
	lsl	x8, x8, x16
	ldr	w4, [x0, #56]
	and	w3, w4, w3
	add	x8, x8, x3
	add	x17, x17, #1
	cmp	x17, x12
	b.ne	LBB11_3
	b	LBB11_11
LBB11_5:
	mov	x8, #0                          ; =0x0
	ldr	x14, [x0, #24]
	cmp	x12, x14
	b.lo	LBB11_12
LBB11_6:
	mov	x0, x8
	ret
LBB11_7:
	mov	x8, #0                          ; =0x0
	mov	x16, #3361                      ; =0xd21
	movk	x16, #8402, lsl #16
	movk	x16, #53773, lsl #32
	movk	x16, #3360, lsl #48
	mov	w17, #624                       ; =0x270
LBB11_8:                                ; =>This Inner Loop Header: Depth=1
	mov	x1, x15
	add	x15, x15, #1
	lsr	x2, x15, #4
	umulh	x2, x2, x16
	lsr	x2, x2, #1
	msub	x15, x2, x17, x15
	ldr	w2, [x13, x1, lsl #2]
	and	w2, w2, #0x80000000
	ldr	w3, [x13, x15, lsl #2]
	and	w4, w3, #0x7ffffffe
	orr	w2, w4, w2
	add	x4, x1, #397
	lsr	x5, x4, #4
	umulh	x5, x5, x16
	lsr	x5, x5, #1
	msub	x4, x5, x17, x4
	ldr	w4, [x13, x4, lsl #2]
	tst	w3, #0x1
	csel	w3, w11, wzr, ne
	eor	w3, w3, w4
	eor	w2, w3, w2, lsr #1
	str	w2, [x13, x1, lsl #2]
	eor	w1, w2, w2, lsr #11
	and	w2, w10, w1, lsl #7
	eor	w1, w2, w1
	and	w2, w9, w1, lsl #15
	eor	w1, w2, w1
	eor	w1, w1, w1, lsr #18
	cmp	x14, x1
	b.ls	LBB11_8
; %bb.9:                                ;   in Loop: Header=BB11_8 Depth=1
	add	x8, x8, #1
	cmp	x8, x12
	b.ne	LBB11_8
; %bb.10:
	ldr	w8, [x0, #56]
	and	w8, w8, w1
LBB11_11:
	str	x15, [x13, #2496]
	ldr	x14, [x0, #24]
	cmp	x12, x14
	b.hs	LBB11_6
LBB11_12:
	ldr	x13, [x0]
	ldr	x15, [x0, #48]
	ldr	x17, [x0, #16]
	ldr	x16, [x13, #2496]
	cmp	x17, #63
	b.hs	LBB11_17
; %bb.13:
	add	x17, x17, #1
	mov	x1, #3361                       ; =0xd21
	movk	x1, #8402, lsl #16
	movk	x1, #53773, lsl #32
	movk	x1, #3360, lsl #48
	mov	w2, #624                        ; =0x270
LBB11_14:                               ; =>This Inner Loop Header: Depth=1
	mov	x3, x16
	add	x16, x16, #1
	lsr	x4, x16, #4
	umulh	x4, x4, x1
	lsr	x4, x4, #1
	msub	x16, x4, x2, x16
	ldr	w4, [x13, x3, lsl #2]
	and	w4, w4, #0x80000000
	ldr	w5, [x13, x16, lsl #2]
	and	w6, w5, #0x7ffffffe
	orr	w4, w6, w4
	add	x6, x3, #397
	lsr	x7, x6, #4
	umulh	x7, x7, x1
	lsr	x7, x7, #1
	msub	x6, x7, x2, x6
	ldr	w6, [x13, x6, lsl #2]
	tst	w5, #0x1
	csel	w5, w11, wzr, ne
	eor	w5, w5, w6
	eor	w4, w5, w4, lsr #1
	str	w4, [x13, x3, lsl #2]
	eor	w3, w4, w4, lsr #11
	and	w4, w10, w3, lsl #7
	eor	w3, w4, w3
	and	w4, w9, w3, lsl #15
	eor	w3, w4, w3
	eor	w3, w3, w3, lsr #18
	cmp	x15, x3
	b.ls	LBB11_14
; %bb.15:                               ;   in Loop: Header=BB11_14 Depth=1
	lsl	x8, x8, x17
	ldr	w4, [x0, #60]
	and	w3, w4, w3
	add	x8, x8, x3
	add	x12, x12, #1
	cmp	x12, x14
	b.ne	LBB11_14
; %bb.16:
	str	x16, [x13, #2496]
	mov	x0, x8
	ret
LBB11_17:
	mov	x8, #3361                       ; =0xd21
	movk	x8, #8402, lsl #16
	movk	x8, #53773, lsl #32
	movk	x8, #3360, lsl #48
	mov	w17, #624                       ; =0x270
LBB11_18:                               ; =>This Inner Loop Header: Depth=1
	mov	x1, x16
	add	x16, x16, #1
	lsr	x2, x16, #4
	umulh	x2, x2, x8
	lsr	x2, x2, #1
	msub	x16, x2, x17, x16
	ldr	w2, [x13, x1, lsl #2]
	and	w2, w2, #0x80000000
	ldr	w3, [x13, x16, lsl #2]
	and	w4, w3, #0x7ffffffe
	orr	w2, w4, w2
	add	x4, x1, #397
	lsr	x5, x4, #4
	umulh	x5, x5, x8
	lsr	x5, x5, #1
	msub	x4, x5, x17, x4
	ldr	w4, [x13, x4, lsl #2]
	tst	w3, #0x1
	csel	w3, w11, wzr, ne
	eor	w3, w3, w4
	eor	w2, w3, w2, lsr #1
	str	w2, [x13, x1, lsl #2]
	eor	w1, w2, w2, lsr #11
	and	w2, w10, w1, lsl #7
	eor	w1, w2, w1
	and	w2, w9, w1, lsl #15
	eor	w1, w2, w1
	eor	w1, w1, w1, lsr #18
	cmp	x15, x1
	b.ls	LBB11_18
; %bb.19:                               ;   in Loop: Header=BB11_18 Depth=1
	add	x12, x12, #1
	cmp	x12, x14
	b.ne	LBB11_18
; %bb.20:
	ldr	w8, [x0, #60]
	and	w8, w8, w1
	str	x16, [x13, #2496]
	mov	x0, x8
	ret
	.cfi_endproc
                                        ; -- End function
	.private_extern	__ZNSt3__16vectorIbNS_9allocatorIbEEE18__construct_at_endB9nqe210106Emb ; -- Begin function _ZNSt3__16vectorIbNS_9allocatorIbEEE18__construct_at_endB9nqe210106Emb
	.globl	__ZNSt3__16vectorIbNS_9allocatorIbEEE18__construct_at_endB9nqe210106Emb
	.weak_def_can_be_hidden	__ZNSt3__16vectorIbNS_9allocatorIbEEE18__construct_at_endB9nqe210106Emb
	.p2align	2
__ZNSt3__16vectorIbNS_9allocatorIbEEE18__construct_at_endB9nqe210106Emb: ; @_ZNSt3__16vectorIbNS_9allocatorIbEEE18__construct_at_endB9nqe210106Emb
	.cfi_startproc
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
	ldr	x20, [x0]
	cbz	x1, LBB12_13
; %bb.1:
	ldr	x8, [x0, #8]
	lsr	x9, x8, #6
	add	x19, x20, x9, lsl #3
	and	w9, w8, #0x3f
	cbz	w2, LBB12_7
; %bb.2:
	cbz	w9, LBB12_17
; %bb.3:
	mov	w10, #64                        ; =0x40
	sub	w9, w10, w9
	cmp	x1, x9
	csel	x10, x1, x9, lo
	sub	w9, w9, w10
	mov	x11, #-1                        ; =0xffffffffffffffff
	lsl	x8, x11, x8
	lsr	x9, x11, x9
	and	x8, x9, x8
	ldr	x9, [x19]
	orr	x8, x9, x8
	str	x8, [x19], #8
	sub	x22, x1, x10
	lsr	x21, x22, #6
	cmp	x22, #64
	b.lo	LBB12_5
LBB12_4:
	lsl	x2, x21, #3
	mov	x23, x0
	mov	x0, x19
	mov	x24, x1
	mov	w1, #255                        ; =0xff
	bl	_memset
	mov	x1, x24
	mov	x0, x23
LBB12_5:
	ands	x8, x22, #0x3f
	b.eq	LBB12_13
; %bb.6:
	neg	x8, x8
	mov	x9, #-1                         ; =0xffffffffffffffff
	lsr	x8, x9, x8
	ldr	x9, [x19, x21, lsl #3]
	orr	x8, x9, x8
	b	LBB12_12
LBB12_7:
	cbz	w9, LBB12_18
; %bb.8:
	mov	w10, #64                        ; =0x40
	sub	w9, w10, w9
	cmp	x1, x9
	csel	x10, x1, x9, lo
	sub	w9, w9, w10
	mov	x11, #-1                        ; =0xffffffffffffffff
	lsl	x8, x11, x8
	lsr	x9, x11, x9
	and	x8, x9, x8
	ldr	x9, [x19]
	bic	x8, x9, x8
	str	x8, [x19], #8
	sub	x22, x1, x10
	lsr	x21, x22, #6
	cmp	x22, #64
	b.lo	LBB12_10
LBB12_9:
	lsl	x8, x21, #3
	mov	x23, x0
	mov	x0, x19
	mov	x24, x1
	mov	x1, x8
	bl	_bzero
	mov	x1, x24
	mov	x0, x23
LBB12_10:
	ands	x8, x22, #0x3f
	b.eq	LBB12_13
; %bb.11:
	neg	x8, x8
	mov	x9, #-1                         ; =0xffffffffffffffff
	lsr	x8, x9, x8
	ldr	x9, [x19, x21, lsl #3]
	bic	x8, x9, x8
LBB12_12:
	str	x8, [x19, x21, lsl #3]
LBB12_13:
	ldr	x8, [x0, #8]
	add	x9, x8, x1
	str	x9, [x0, #8]
	ands	w8, w9, #0x3f
	b.eq	LBB12_16
; %bb.14:
	lsr	x9, x9, #6
	add	x9, x20, x9, lsl #3
	orr	w10, w8, #0xffffffc0
	mov	w11, #1                         ; =0x1
	mov	w12, #8                         ; =0x8
LBB12_15:                               ; =>This Inner Loop Header: Depth=1
	lsl	x13, x11, x8
	ldr	x14, [x9]
	bic	x13, x14, x13
	str	x13, [x9]
	cmp	w8, #63
	csel	x13, x12, xzr, eq
	add	x9, x9, x13
	csinc	w8, wzr, w8, eq
	adds	w10, w10, #1
	b.lo	LBB12_15
LBB12_16:
	ldp	x29, x30, [sp, #48]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #32]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #16]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp], #64             ; 16-byte Folded Reload
	ret
LBB12_17:
	mov	x22, x1
	lsr	x21, x1, #6
	cmp	x1, #64
	b.hs	LBB12_4
	b	LBB12_5
LBB12_18:
	mov	x22, x1
	lsr	x21, x1, #6
	cmp	x1, #64
	b.hs	LBB12_9
	b	LBB12_10
	.cfi_endproc
                                        ; -- End function
	.private_extern	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m ; -- Begin function _ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
	.globl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
	.weak_def_can_be_hidden	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
	.p2align	2
__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m: ; @_ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Lfunc_begin3:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception3
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
Ltmp131:
	add	x0, sp, #8
	mov	x1, x19
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryC1ERS3_
Ltmp132:
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
Ltmp134:
	add	x8, sp, #24
	mov	x25, x4
	mov	x0, x4
	bl	__ZNKSt3__18ios_base6getlocEv
Ltmp135:
; %bb.4:
Ltmp136:
Lloh66:
	adrp	x1, __ZNSt3__15ctypeIcE2idE@GOTPAGE
Lloh67:
	ldr	x1, [x1, __ZNSt3__15ctypeIcE2idE@GOTPAGEOFF]
	add	x0, sp, #24
	bl	__ZNKSt3__16locale9use_facetERNS0_2idE
Ltmp137:
; %bb.5:
	ldr	x8, [x0]
	ldr	x8, [x8, #56]
Ltmp138:
	mov	w1, #32                         ; =0x20
	blr	x8
Ltmp139:
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
Ltmp141:
	sxtb	w5, w23
	mov	x0, x22
	mov	x1, x20
	bl	__ZNSt3__116__pad_and_outputB9nqe210106IcNS_11char_traitsIcEEEENS_19ostreambuf_iteratorIT_T0_EES6_PKS4_S8_S8_RNS_8ios_baseES4_
Ltmp142:
; %bb.8:
	cbnz	x0, LBB13_10
; %bb.9:
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
	add	x0, x19, x8
	ldr	w8, [x0, #32]
	mov	w9, #5                          ; =0x5
Ltmp144:
	orr	w1, w8, w9
	bl	__ZNSt3__18ios_base5clearEj
Ltmp145:
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
Ltmp146:
	b	LBB13_15
LBB13_13:
Ltmp140:
	mov	x20, x0
	add	x0, sp, #24
	bl	__ZNSt3__16localeD1Ev
	b	LBB13_16
LBB13_14:
Ltmp143:
LBB13_15:
	mov	x20, x0
LBB13_16:
	add	x0, sp, #8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryD1Ev
	b	LBB13_18
LBB13_17:
Ltmp133:
	mov	x20, x0
LBB13_18:
	mov	x0, x20
	bl	___cxa_begin_catch
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
Ltmp147:
	add	x0, x19, x8
	bl	__ZNSt3__18ios_base33__set_badbit_and_consider_rethrowEv
Ltmp148:
; %bb.19:
	bl	___cxa_end_catch
	b	LBB13_11
LBB13_20:
Ltmp149:
	mov	x19, x0
Ltmp150:
	bl	___cxa_end_catch
Ltmp151:
; %bb.21:
	mov	x0, x19
	bl	__Unwind_Resume
LBB13_22:
Ltmp152:
	bl	___clang_call_terminate
	.loh AdrpLdrGot	Lloh66, Lloh67
Lfunc_end3:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table13:
Lexception3:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase1-Lttbaseref1
Lttbaseref1:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end3-Lcst_begin3
Lcst_begin3:
	.uleb128 Ltmp131-Lfunc_begin3           ; >> Call Site 1 <<
	.uleb128 Ltmp132-Ltmp131                ;   Call between Ltmp131 and Ltmp132
	.uleb128 Ltmp133-Lfunc_begin3           ;     jumps to Ltmp133
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp134-Lfunc_begin3           ; >> Call Site 2 <<
	.uleb128 Ltmp135-Ltmp134                ;   Call between Ltmp134 and Ltmp135
	.uleb128 Ltmp143-Lfunc_begin3           ;     jumps to Ltmp143
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp136-Lfunc_begin3           ; >> Call Site 3 <<
	.uleb128 Ltmp139-Ltmp136                ;   Call between Ltmp136 and Ltmp139
	.uleb128 Ltmp140-Lfunc_begin3           ;     jumps to Ltmp140
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp141-Lfunc_begin3           ; >> Call Site 4 <<
	.uleb128 Ltmp142-Ltmp141                ;   Call between Ltmp141 and Ltmp142
	.uleb128 Ltmp143-Lfunc_begin3           ;     jumps to Ltmp143
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp144-Lfunc_begin3           ; >> Call Site 5 <<
	.uleb128 Ltmp145-Ltmp144                ;   Call between Ltmp144 and Ltmp145
	.uleb128 Ltmp146-Lfunc_begin3           ;     jumps to Ltmp146
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp145-Lfunc_begin3           ; >> Call Site 6 <<
	.uleb128 Ltmp147-Ltmp145                ;   Call between Ltmp145 and Ltmp147
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp147-Lfunc_begin3           ; >> Call Site 7 <<
	.uleb128 Ltmp148-Ltmp147                ;   Call between Ltmp147 and Ltmp148
	.uleb128 Ltmp149-Lfunc_begin3           ;     jumps to Ltmp149
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp148-Lfunc_begin3           ; >> Call Site 8 <<
	.uleb128 Ltmp150-Ltmp148                ;   Call between Ltmp148 and Ltmp150
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp150-Lfunc_begin3           ; >> Call Site 9 <<
	.uleb128 Ltmp151-Ltmp150                ;   Call between Ltmp150 and Ltmp151
	.uleb128 Ltmp152-Lfunc_begin3           ;     jumps to Ltmp152
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp151-Lfunc_begin3           ; >> Call Site 10 <<
	.uleb128 Lfunc_end3-Ltmp151             ;   Call between Ltmp151 and Lfunc_end3
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end3:
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
Ltmp153:
	mov	x0, x19
	mov	x2, x24
	blr	x8
Ltmp154:
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
Ltmp155:
	mov	x19, x0
	ldrsb	w8, [sp, #31]
	tbz	w8, #31, LBB14_20
; %bb.19:
	ldr	x0, [sp, #8]
	bl	__ZdlPv
LBB14_20:
	mov	x0, x19
	bl	__Unwind_Resume
Lfunc_end4:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table14:
Lexception4:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end4-Lcst_begin4
Lcst_begin4:
	.uleb128 Lfunc_begin4-Lfunc_begin4      ; >> Call Site 1 <<
	.uleb128 Ltmp153-Lfunc_begin4           ;   Call between Lfunc_begin4 and Ltmp153
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp153-Lfunc_begin4           ; >> Call Site 2 <<
	.uleb128 Ltmp154-Ltmp153                ;   Call between Ltmp153 and Ltmp154
	.uleb128 Ltmp155-Lfunc_begin4           ;     jumps to Ltmp155
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp154-Lfunc_begin4           ; >> Call Site 3 <<
	.uleb128 Lfunc_end4-Ltmp154             ;   Call between Ltmp154 and Lfunc_end4
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end4:
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
Lloh68:
	adrp	x0, l_.str.10@PAGE
Lloh69:
	add	x0, x0, l_.str.10@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh68, Lloh69
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
Lloh70:
	adrp	x0, l_.str.9@PAGE
Lloh71:
	add	x0, x0, l_.str.9@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh70, Lloh71
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _Z9make_ringmb.cold.1
__Z9make_ringmb.cold.1:                 ; @_Z9make_ringmb.cold.1
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh72:
	adrp	x1, __ZTISt16invalid_argument@GOTPAGE
Lloh73:
	ldr	x1, [x1, __ZTISt16invalid_argument@GOTPAGEOFF]
Lloh74:
	adrp	x2, __ZNSt16invalid_argumentD1Ev@GOTPAGE
Lloh75:
	ldr	x2, [x2, __ZNSt16invalid_argumentD1Ev@GOTPAGEOFF]
	bl	___cxa_throw
	.loh AdrpLdrGot	Lloh74, Lloh75
	.loh AdrpLdrGot	Lloh72, Lloh73
	.cfi_endproc
                                        ; -- End function
	.globl	_sink                           ; @sink
.zerofill __DATA,__common,_sink,8,3
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"empty ring"

l_.str.1:                               ; @.str.1
	.asciz	"not one cycle"

l_.str.2:                               ; @.str.2
	.asciz	"cycle oracle"

l_.str.3:                               ; @.str.3
	.asciz	"PASS boundary_rings=14 zero_rejected=1\n"

l_.str.4:                               ; @.str.4
	.asciz	"bytes,pattern,p50_ns_per_dependent_load,p95_ns_per_dependent_load\n"

	.section	__TEXT,__const
	.p2align	2, 0x0                          ; @constinit.5
l_constinit.5:
	.long	4096                            ; 0x1000
	.long	32768                           ; 0x8000
	.long	131072                          ; 0x20000
	.long	1048576                         ; 0x100000
	.long	8388608                         ; 0x800000
	.long	33554432                        ; 0x2000000

	.section	__TEXT,__cstring,cstring_literals
l_.str.6:                               ; @.str.6
	.asciz	"random"

l_.str.7:                               ; @.str.7
	.asciz	"sequential"

l_.str.8:                               ; @.str.8
	.asciz	"PASS boundary_rings=14 zero_rejected=1 sink="

l_.str.9:                               ; @.str.9
	.asciz	"vector"

l_.str.10:                              ; @.str.10
	.asciz	"basic_string"

.subsections_via_symbols
