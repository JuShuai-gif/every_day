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
	.globl	_main                           ; -- Begin function main
	.p2align	2
_main:                                  ; @main
Lfunc_begin1:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception1
; %bb.0:
	sub	sp, sp, #304
	stp	d15, d14, [sp, #144]            ; 16-byte Folded Spill
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
	.cfi_offset b14, -152
	.cfi_offset b15, -160
Ltmp3:
	mov	w0, #12                         ; =0xc
	movk	w0, #4, lsl #16
	bl	__Znwm
Ltmp4:
; %bb.1:
	mov	x19, x0
	mov	w1, #12                         ; =0xc
	movk	w1, #4, lsl #16
	bl	_bzero
Ltmp6:
	mov	w0, #12                         ; =0xc
	movk	w0, #4, lsl #16
	bl	__Znwm
Ltmp7:
; %bb.2:
	mov	x20, x0
	mov	w21, #12                        ; =0xc
	movk	w21, #4, lsl #16
	mov	w1, #12                         ; =0xc
	movk	w1, #4, lsl #16
	bl	_bzero
	mov	x8, #0                          ; =0x0
	mov	x9, #0                          ; =0x0
	mov	w10, #-35                       ; =0xffffffdd
	mov	w11, #-21                       ; =0xffffffeb
	mov	x12, #44307                     ; =0xad13
	movk	x12, #14768, lsl #16
	movk	x12, #26768, lsl #32
	movk	x12, #52613, lsl #48
	mov	w13, #71                        ; =0x47
	mov	x14, #41151                     ; =0xa0bf
	movk	x14, #59439, lsl #16
	movk	x14, #64011, lsl #32
	movk	x14, #48770, lsl #48
	mov	w15, #43                        ; =0x2b
LBB1_3:                                 ; =>This Inner Loop Header: Depth=1
	umulh	x16, x9, x12
	sub	x17, x9, x16
	add	x16, x16, x17, lsr #1
	lsr	x16, x16, #6
	msub	w16, w16, w13, w10
	umulh	x17, x9, x14
	lsr	x17, x17, #5
	msub	w17, w17, w15, w11
	scvtf	s0, w17, #5
	str	s0, [x19, x8]
	scvtf	s0, w16, #5
	str	s0, [x20, x8]
	add	x9, x9, #1
	add	x8, x8, #4
	add	w10, w10, #1
	add	w11, w11, #1
	cmp	x8, x21
	b.ne	LBB1_3
; %bb.4:
	mov	x21, #0                         ; =0x0
	add	x22, x19, #32
	add	x23, x20, #32
	movi.2d	v8, #0000000000000000
	mov	x8, #43516                      ; =0xa9fc
	movk	x8, #54001, lsl #16
	movk	x8, #25165, lsl #32
	movk	x8, #16208, lsl #48
	fmov	d9, x8
	mov	x8, #26865                      ; =0x68f1
	movk	x8, #35043, lsl #16
	movk	x8, #63669, lsl #32
	movk	x8, #16100, lsl #48
	fmov	d10, x8
LBB1_5:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB1_11 Depth 2
                                        ;     Child Loop BB1_15 Depth 2
	movi.2d	v11, #0000000000000000
	cbz	x21, LBB1_18
; %bb.6:                                ;   in Loop: Header=BB1_5 Depth=1
	cmp	x21, #3
	b.hi	LBB1_8
; %bb.7:                                ;   in Loop: Header=BB1_5 Depth=1
	mov	x8, #0                          ; =0x0
	b	LBB1_16
LBB1_8:                                 ;   in Loop: Header=BB1_5 Depth=1
	cmp	x21, #16
	b.hs	LBB1_10
; %bb.9:                                ;   in Loop: Header=BB1_5 Depth=1
	mov	x8, #0                          ; =0x0
	b	LBB1_14
LBB1_10:                                ;   in Loop: Header=BB1_5 Depth=1
	and	x9, x21, #0xfffffffffffffff0
	and	x8, x21, #0x7ffffffffffffff0
	mov	x10, x23
	mov	x11, x22
LBB1_11:                                ;   Parent Loop BB1_5 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldp	q0, q1, [x11, #-32]
	ldp	q2, q3, [x11], #64
	fcvtl	v4.2d, v0.2s
	fcvtl2	v0.2d, v0.4s
	fcvtl	v5.2d, v1.2s
	fcvtl2	v1.2d, v1.4s
	fcvtl	v6.2d, v2.2s
	fcvtl2	v2.2d, v2.4s
	fcvtl	v7.2d, v3.2s
	fcvtl2	v3.2d, v3.4s
	ldp	q16, q17, [x10, #-32]
	ldp	q18, q19, [x10], #64
	fcvtl	v20.2d, v16.2s
	fcvtl2	v16.2d, v16.4s
	fcvtl	v21.2d, v17.2s
	fcvtl2	v17.2d, v17.4s
	fcvtl	v22.2d, v18.2s
	fcvtl2	v18.2d, v18.4s
	fcvtl	v23.2d, v19.2s
	fcvtl2	v19.2d, v19.4s
	fmul.2d	v0, v0, v16
	mov	d16, v0[1]
	fmul.2d	v4, v4, v20
	mov	d20, v4[1]
	fmul.2d	v1, v1, v17
	mov	d17, v1[1]
	fmul.2d	v5, v5, v21
	mov	d21, v5[1]
	fmul.2d	v2, v2, v18
	mov	d18, v2[1]
	fmul.2d	v6, v6, v22
	mov	d22, v6[1]
	fmul.2d	v3, v3, v19
	mov	d19, v3[1]
	fmul.2d	v7, v7, v23
	mov	d23, v7[1]
	fadd	d4, d11, d4
	fadd	d4, d4, d20
	fadd	d0, d4, d0
	fadd	d0, d0, d16
	fadd	d0, d0, d5
	fadd	d0, d0, d21
	fadd	d0, d0, d1
	fadd	d0, d0, d17
	fadd	d0, d0, d6
	fadd	d0, d0, d22
	fadd	d0, d0, d2
	fadd	d0, d0, d18
	fadd	d0, d0, d7
	fadd	d0, d0, d23
	fadd	d0, d0, d3
	fadd	d11, d0, d19
	subs	x9, x9, #16
	b.ne	LBB1_11
; %bb.12:                               ;   in Loop: Header=BB1_5 Depth=1
	cmp	x21, x8
	b.eq	LBB1_18
; %bb.13:                               ;   in Loop: Header=BB1_5 Depth=1
	tst	x21, #0xc
	b.eq	LBB1_16
LBB1_14:                                ;   in Loop: Header=BB1_5 Depth=1
	and	x9, x21, #0xfffffffffffffffc
	sub	x9, x8, x9
	lsl	x11, x8, #2
	and	x8, x21, #0x7ffffffffffffffc
	add	x10, x20, x11
	add	x11, x19, x11
LBB1_15:                                ;   Parent Loop BB1_5 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	q0, [x11], #16
	fcvtl	v1.2d, v0.2s
	ldr	q2, [x10], #16
	fcvtl2	v0.2d, v0.4s
	fcvtl	v3.2d, v2.2s
	fcvtl2	v2.2d, v2.4s
	fmul.2d	v0, v0, v2
	mov	d2, v0[1]
	fmul.2d	v1, v1, v3
	mov	d3, v1[1]
	fadd	d1, d11, d1
	fadd	d1, d1, d3
	fadd	d0, d1, d0
	fadd	d11, d0, d2
	adds	x9, x9, #4
	b.ne	LBB1_15
	b	LBB1_17
LBB1_16:                                ;   in Loop: Header=BB1_5 Depth=1
	ldr	s0, [x19, x8, lsl #2]
	fcvt	d0, s0
	ldr	s1, [x20, x8, lsl #2]
	fcvt	d1, s1
	fmadd	d11, d0, d1, d11
	add	x8, x8, #1
LBB1_17:                                ;   in Loop: Header=BB1_5 Depth=1
	cmp	x21, x8
	b.ne	LBB1_16
LBB1_18:                                ;   in Loop: Header=BB1_5 Depth=1
Ltmp9:
	mov	x0, x19
	mov	x1, x20
	mov	x2, x21
	bl	__Z3dotILi1EEfPKfS1_m
Ltmp10:
; %bb.19:                               ;   in Loop: Header=BB1_5 Depth=1
	fabs	d1, d11
	fmadd	d13, d1, d10, d9
	fcvt	d0, s0
	fabd	d12, d0, d11
	fcmp	d12, d13
	b.pl	LBB1_130
; %bb.20:                               ;   in Loop: Header=BB1_5 Depth=1
	mov	x0, x19
	mov	x1, x20
	mov	x2, x21
	bl	__Z3dotILi4EEfPKfS1_m
	fcvt	d0, s0
	fabd	d14, d0, d11
	fcmp	d14, d13
	b.pl	LBB1_130
; %bb.21:                               ;   in Loop: Header=BB1_5 Depth=1
	mov	x0, x19
	mov	x1, x20
	mov	x2, x21
	bl	__Z3dotILi16EEfPKfS1_m
	fcvt	d0, s0
	fabd	d0, d0, d11
	fcmp	d0, d13
	b.pl	LBB1_130
; %bb.22:                               ;   in Loop: Header=BB1_5 Depth=1
	fcmp	d8, d12
	fcsel	d1, d12, d8, mi
	fcmp	d1, d14
	fcsel	d1, d14, d1, mi
	fcmp	d1, d0
	fcsel	d8, d0, d1, mi
	add	x21, x21, #1
	cmp	x21, #1027
	b.ne	LBB1_5
; %bb.23:
Ltmp18:
Lloh2:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh3:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh4:
	adrp	x1, l_.str.1@PAGE
Lloh5:
	add	x1, x1, l_.str.1@PAGEOFF
	mov	w2, #17                         ; =0x11
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp19:
; %bb.24:
Ltmp20:
	mov	w1, #3081                       ; =0xc09
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEi
Ltmp21:
; %bb.25:
Ltmp22:
Lloh6:
	adrp	x1, l_.str.2@PAGE
Lloh7:
	add	x1, x1, l_.str.2@PAGEOFF
	mov	w2, #15                         ; =0xf
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp23:
; %bb.26:
Ltmp24:
	mov.16b	v0, v8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp25:
; %bb.27:
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #135]
Ltmp26:
	add	x1, sp, #135
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp27:
; %bb.28:
	mov	x22, #0                         ; =0x0
	add	x9, x19, #32
	add	x8, x20, #32
	stp	x8, x9, [sp, #8]                ; 16-byte Folded Spill
	mov	x8, #43516                      ; =0xa9fc
	movk	x8, #54001, lsl #16
	movk	x8, #25165, lsl #32
	movk	x8, #16208, lsl #48
	fmov	d8, x8
	mov	x8, #26865                      ; =0x68f1
	movk	x8, #35043, lsl #16
	movk	x8, #63669, lsl #32
	movk	x8, #16100, lsl #48
	fmov	d9, x8
Lloh8:
	adrp	x25, l___const.main.f@PAGE
Lloh9:
	add	x25, x25, l___const.main.f@PAGEOFF
	adrp	x21, _sink@PAGE
LBB1_29:                                ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB1_36 Depth 2
                                        ;     Child Loop BB1_40 Depth 2
                                        ;     Child Loop BB1_43 Depth 2
                                        ;     Child Loop BB1_55 Depth 2
                                        ;       Child Loop BB1_62 Depth 3
                                        ;       Child Loop BB1_65 Depth 3
                                        ;       Child Loop BB1_68 Depth 3
                                        ;       Child Loop BB1_57 Depth 3
                                        ;       Child Loop BB1_77 Depth 3
                                        ;       Child Loop BB1_87 Depth 3
Lloh10:
	adrp	x8, l_constinit@PAGE
Lloh11:
	add	x8, x8, l_constinit@PAGEOFF
	ldr	x28, [x8, x22]
	cbz	x28, LBB1_32
; %bb.30:                               ;   in Loop: Header=BB1_29 Depth=1
	cmp	x28, #3
	b.hi	LBB1_33
; %bb.31:                               ;   in Loop: Header=BB1_29 Depth=1
	mov	x8, #0                          ; =0x0
	movi.2d	v10, #0000000000000000
	b	LBB1_42
LBB1_32:                                ;   in Loop: Header=BB1_29 Depth=1
	movi.2d	v10, #0000000000000000
	b	LBB1_44
LBB1_33:                                ;   in Loop: Header=BB1_29 Depth=1
	cmp	x28, #16
	b.hs	LBB1_35
; %bb.34:                               ;   in Loop: Header=BB1_29 Depth=1
	mov	x8, #0                          ; =0x0
	movi.2d	v10, #0000000000000000
	b	LBB1_39
LBB1_35:                                ;   in Loop: Header=BB1_29 Depth=1
	and	x8, x28, #0xfffffffffffffff0
	movi.2d	v10, #0000000000000000
	ldp	x9, x10, [sp, #8]               ; 16-byte Folded Reload
	mov	x11, x8
LBB1_36:                                ;   Parent Loop BB1_29 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldp	q0, q1, [x10, #-32]
	ldp	q2, q3, [x10], #64
	fcvtl	v4.2d, v0.2s
	fcvtl2	v0.2d, v0.4s
	fcvtl	v5.2d, v1.2s
	fcvtl2	v1.2d, v1.4s
	fcvtl	v6.2d, v2.2s
	fcvtl2	v2.2d, v2.4s
	fcvtl	v7.2d, v3.2s
	fcvtl2	v3.2d, v3.4s
	ldp	q16, q17, [x9, #-32]
	ldp	q18, q19, [x9], #64
	fcvtl	v20.2d, v16.2s
	fcvtl2	v16.2d, v16.4s
	fcvtl	v21.2d, v17.2s
	fcvtl2	v17.2d, v17.4s
	fcvtl	v22.2d, v18.2s
	fcvtl2	v18.2d, v18.4s
	fcvtl	v23.2d, v19.2s
	fcvtl2	v19.2d, v19.4s
	fmul.2d	v0, v0, v16
	mov	d16, v0[1]
	fmul.2d	v4, v4, v20
	mov	d20, v4[1]
	fmul.2d	v1, v1, v17
	mov	d17, v1[1]
	fmul.2d	v5, v5, v21
	mov	d21, v5[1]
	fmul.2d	v2, v2, v18
	mov	d18, v2[1]
	fmul.2d	v6, v6, v22
	mov	d22, v6[1]
	fmul.2d	v3, v3, v19
	mov	d19, v3[1]
	fmul.2d	v7, v7, v23
	mov	d23, v7[1]
	fadd	d4, d10, d4
	fadd	d4, d4, d20
	fadd	d0, d4, d0
	fadd	d0, d0, d16
	fadd	d0, d0, d5
	fadd	d0, d0, d21
	fadd	d0, d0, d1
	fadd	d0, d0, d17
	fadd	d0, d0, d6
	fadd	d0, d0, d22
	fadd	d0, d0, d2
	fadd	d0, d0, d18
	fadd	d0, d0, d7
	fadd	d0, d0, d23
	fadd	d0, d0, d3
	fadd	d10, d0, d19
	subs	x11, x11, #16
	b.ne	LBB1_36
; %bb.37:                               ;   in Loop: Header=BB1_29 Depth=1
	cmp	x28, x8
	b.eq	LBB1_44
; %bb.38:                               ;   in Loop: Header=BB1_29 Depth=1
	tst	x28, #0xc
	b.eq	LBB1_42
LBB1_39:                                ;   in Loop: Header=BB1_29 Depth=1
	mov	x10, x8
	and	x8, x28, #0xfffffffffffffffc
	sub	x9, x10, x8
	lsl	x11, x10, #2
	add	x10, x20, x11
	add	x11, x19, x11
LBB1_40:                                ;   Parent Loop BB1_29 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	q0, [x11], #16
	fcvtl	v1.2d, v0.2s
	ldr	q2, [x10], #16
	fcvtl2	v0.2d, v0.4s
	fcvtl	v3.2d, v2.2s
	fcvtl2	v2.2d, v2.4s
	fmul.2d	v0, v0, v2
	mov	d2, v0[1]
	fmul.2d	v1, v1, v3
	mov	d3, v1[1]
	fadd	d1, d10, d1
	fadd	d1, d1, d3
	fadd	d0, d1, d0
	fadd	d10, d0, d2
	adds	x9, x9, #4
	b.ne	LBB1_40
; %bb.41:                               ;   in Loop: Header=BB1_29 Depth=1
	cmp	x28, x8
	b.eq	LBB1_44
LBB1_42:                                ;   in Loop: Header=BB1_29 Depth=1
	sub	x9, x28, x8
	lsl	x10, x8, #2
	add	x8, x19, x10
	add	x10, x20, x10
LBB1_43:                                ;   Parent Loop BB1_29 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	s0, [x8], #4
	fcvt	d0, s0
	ldr	s1, [x10], #4
	fcvt	d1, s1
	fmadd	d10, d0, d1, d10
	subs	x9, x9, #1
	b.ne	LBB1_43
LBB1_44:                                ;   in Loop: Header=BB1_29 Depth=1
Ltmp29:
	mov	x0, x19
	mov	x1, x20
	mov	x2, x28
	bl	__Z3dotILi1EEfPKfS1_m
Ltmp30:
; %bb.45:                               ;   in Loop: Header=BB1_29 Depth=1
	fabs	d1, d10
	fmadd	d11, d1, d9, d8
	fcvt	d0, s0
	fabd	d0, d0, d10
	fcmp	d0, d11
	b.pl	LBB1_132
; %bb.46:                               ;   in Loop: Header=BB1_29 Depth=1
	mov	x0, x19
	mov	x1, x20
	mov	x2, x28
	bl	__Z3dotILi4EEfPKfS1_m
	fcvt	d0, s0
	fabd	d0, d0, d10
	fcmp	d0, d11
	b.pl	LBB1_132
; %bb.47:                               ;   in Loop: Header=BB1_29 Depth=1
	mov	x0, x19
	mov	x1, x20
	mov	x2, x28
	bl	__Z3dotILi16EEfPKfS1_m
	fcvt	d0, s0
	fabd	d0, d0, d10
	fcmp	d0, d11
	b.pl	LBB1_132
; %bb.48:                               ;   in Loop: Header=BB1_29 Depth=1
Ltmp38:
Lloh12:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh13:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh14:
	adrp	x1, l_.str.3@PAGE
Lloh15:
	add	x1, x1, l_.str.3@PAGEOFF
	mov	w2, #21                         ; =0x15
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp39:
; %bb.49:                               ;   in Loop: Header=BB1_29 Depth=1
Ltmp40:
	mov	x1, x28
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp41:
; %bb.50:                               ;   in Loop: Header=BB1_29 Depth=1
Ltmp42:
Lloh16:
	adrp	x1, l_.str.4@PAGE
Lloh17:
	add	x1, x1, l_.str.4@PAGEOFF
	mov	w2, #13                         ; =0xd
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp43:
; %bb.51:                               ;   in Loop: Header=BB1_29 Depth=1
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #135]
Ltmp44:
	add	x1, sp, #135
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp45:
; %bb.52:                               ;   in Loop: Header=BB1_29 Depth=1
	str	x22, [sp, #24]                  ; 8-byte Folded Spill
	str	xzr, [sp, #112]
	movi.2d	v0, #0000000000000000
	stp	q0, q0, [sp, #80]
	mov	w26, #-20                       ; =0xffffffec
	stp	q0, q0, [sp, #48]
	b	LBB1_55
LBB1_53:                                ;   in Loop: Header=BB1_55 Depth=2
	str	d10, [x26], #8
LBB1_54:                                ;   in Loop: Header=BB1_55 Depth=2
	str	x26, [x27, #8]
	ldr	w26, [sp, #44]                  ; 4-byte Folded Reload
	add	w26, w26, #1
	cmp	w26, #100
	b.eq	LBB1_95
LBB1_55:                                ;   Parent Loop BB1_29 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB1_62 Depth 3
                                        ;       Child Loop BB1_65 Depth 3
                                        ;       Child Loop BB1_68 Depth 3
                                        ;       Child Loop BB1_57 Depth 3
                                        ;       Child Loop BB1_77 Depth 3
                                        ;       Child Loop BB1_87 Depth 3
	add	w8, w26, #21
	mov	w9, #43691                      ; =0xaaab
	movk	w9, #43690, lsl #16
	umull	x9, w8, w9
	lsr	x9, x9, #33
	add	w9, w9, w9, lsl #1
	sub	w23, w8, w9
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	tbnz	w26, #31, LBB1_61
; %bb.56:                               ;   in Loop: Header=BB1_55 Depth=2
	mov	x22, x0
	mov	w24, #100                       ; =0x64
LBB1_57:                                ;   Parent Loop BB1_29 Depth=1
                                        ;     Parent Loop BB1_55 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	; InlineAsm Start
	; InlineAsm End
	ldr	x8, [x25, x23, lsl #3]
Ltmp56:
	mov	x0, x19
	mov	x1, x20
	mov	x2, x28
	blr	x8
Ltmp57:
; %bb.58:                               ;   in Loop: Header=BB1_57 Depth=3
	str	s0, [x21, _sink@PAGEOFF]
	subs	w24, w24, #1
	b.ne	LBB1_57
; %bb.59:                               ;   in Loop: Header=BB1_55 Depth=2
	str	w26, [sp, #44]                  ; 4-byte Folded Spill
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	sub	x8, x0, x22
	scvtf	d0, x8
	mov	x8, #70368744177664             ; =0x400000000000
	movk	x8, #16527, lsl #48
	fmov	d1, x8
	fdiv	d0, d0, d1
	mov	x8, #4636737291354636288        ; =0x4059000000000000
	fmov	d1, x8
	fdiv	d10, d0, d1
	mov	w8, #24                         ; =0x18
	add	x9, sp, #48
	umaddl	x27, w23, w8, x9
	ldp	x26, x8, [x27, #8]
	cmp	x26, x8
	b.hs	LBB1_71
; %bb.60:                               ;   in Loop: Header=BB1_55 Depth=2
	str	d10, [x26], #8
	b	LBB1_76
LBB1_61:                                ;   in Loop: Header=BB1_55 Depth=2
	mov	w22, #100                       ; =0x64
LBB1_62:                                ;   Parent Loop BB1_29 Depth=1
                                        ;     Parent Loop BB1_55 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	; InlineAsm Start
	; InlineAsm End
	ldr	x8, [x25, x23, lsl #3]
Ltmp47:
	mov	x0, x19
	mov	x1, x20
	mov	x2, x28
	blr	x8
Ltmp48:
; %bb.63:                               ;   in Loop: Header=BB1_62 Depth=3
	str	s0, [x21, _sink@PAGEOFF]
	subs	w22, w22, #1
	b.ne	LBB1_62
; %bb.64:                               ;   in Loop: Header=BB1_55 Depth=2
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	add	w8, w26, #22
	mov	w9, #43691                      ; =0xaaab
	movk	w9, #43690, lsl #16
	umull	x9, w8, w9
	lsr	x9, x9, #33
	add	w9, w9, w9, lsl #1
	sub	w22, w8, w9
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	w23, #100                       ; =0x64
LBB1_65:                                ;   Parent Loop BB1_29 Depth=1
                                        ;     Parent Loop BB1_55 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	; InlineAsm Start
	; InlineAsm End
	ldr	x8, [x25, w22, uxtw #3]
Ltmp50:
	mov	x0, x19
	mov	x1, x20
	mov	x2, x28
	blr	x8
Ltmp51:
; %bb.66:                               ;   in Loop: Header=BB1_65 Depth=3
	str	s0, [x21, _sink@PAGEOFF]
	subs	w23, w23, #1
	b.ne	LBB1_65
; %bb.67:                               ;   in Loop: Header=BB1_55 Depth=2
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	add	w8, w26, #23
	mov	w9, #43691                      ; =0xaaab
	movk	w9, #43690, lsl #16
	umull	x9, w8, w9
	lsr	x9, x9, #33
	add	w9, w9, w9, lsl #1
	sub	w22, w8, w9
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	w23, #100                       ; =0x64
LBB1_68:                                ;   Parent Loop BB1_29 Depth=1
                                        ;     Parent Loop BB1_55 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	; InlineAsm Start
	; InlineAsm End
	ldr	x8, [x25, w22, uxtw #3]
Ltmp53:
	mov	x0, x19
	mov	x1, x20
	mov	x2, x28
	blr	x8
Ltmp54:
; %bb.69:                               ;   in Loop: Header=BB1_68 Depth=3
	str	s0, [x21, _sink@PAGEOFF]
	subs	w23, w23, #1
	b.ne	LBB1_68
; %bb.70:                               ;   in Loop: Header=BB1_55 Depth=2
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	add	w26, w26, #1
	cmp	w26, #100
	b.ne	LBB1_55
	b	LBB1_95
LBB1_71:                                ;   in Loop: Header=BB1_55 Depth=2
	ldr	x22, [x27]
	sub	x23, x26, x22
	asr	x26, x23, #3
	add	x9, x26, #1
	lsr	x10, x9, #61
	cbnz	x10, LBB1_128
; %bb.72:                               ;   in Loop: Header=BB1_55 Depth=2
	sub	x8, x8, x22
	asr	x10, x8, #2
	cmp	x10, x9
	csel	x9, x10, x9, hi
	mov	x10, #9223372036854775800       ; =0x7ffffffffffffff8
	cmp	x8, x10
	mov	x8, #2305843009213693951        ; =0x1fffffffffffffff
	csel	x24, x9, x8, lo
	lsr	x8, x24, #61
	cbnz	x8, LBB1_129
; %bb.73:                               ;   in Loop: Header=BB1_55 Depth=2
	lsl	x0, x24, #3
Ltmp59:
	bl	__Znwm
Ltmp60:
; %bb.74:                               ;   in Loop: Header=BB1_55 Depth=2
	mov	x8, x26
	add	x26, x0, x23
	add	x9, x0, x24, lsl #3
	str	x9, [sp, #32]                   ; 8-byte Folded Spill
	sub	x24, x26, x8, lsl #3
	str	d10, [x26], #8
	mov	x0, x24
	mov	x1, x22
	mov	x2, x23
	bl	_memcpy
	str	x24, [x27]
	ldr	x8, [sp, #32]                   ; 8-byte Folded Reload
	str	x8, [x27, #16]
	cbz	x22, LBB1_76
; %bb.75:                               ;   in Loop: Header=BB1_55 Depth=2
	mov	x0, x22
	bl	__ZdlPv
LBB1_76:                                ;   in Loop: Header=BB1_55 Depth=2
	str	x26, [x27, #8]
	ldr	w8, [sp, #44]                   ; 4-byte Folded Reload
	add	w8, w8, #22
	mov	w9, #43691                      ; =0xaaab
	movk	w9, #43690, lsl #16
	umull	x9, w8, w9
	lsr	x9, x9, #33
	add	w9, w9, w9, lsl #1
	sub	w23, w8, w9
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x22, x0
	mov	w24, #100                       ; =0x64
LBB1_77:                                ;   Parent Loop BB1_29 Depth=1
                                        ;     Parent Loop BB1_55 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	; InlineAsm Start
	; InlineAsm End
	ldr	x8, [x25, x23, lsl #3]
Ltmp61:
	mov	x0, x19
	mov	x1, x20
	mov	x2, x28
	blr	x8
Ltmp62:
; %bb.78:                               ;   in Loop: Header=BB1_77 Depth=3
	str	s0, [x21, _sink@PAGEOFF]
	subs	w24, w24, #1
	b.ne	LBB1_77
; %bb.79:                               ;   in Loop: Header=BB1_55 Depth=2
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	sub	x8, x0, x22
	scvtf	d0, x8
	mov	x8, #70368744177664             ; =0x400000000000
	movk	x8, #16527, lsl #48
	fmov	d1, x8
	fdiv	d0, d0, d1
	mov	x8, #4636737291354636288        ; =0x4059000000000000
	fmov	d1, x8
	fdiv	d10, d0, d1
	mov	w8, #24                         ; =0x18
	add	x9, sp, #48
	umaddl	x27, w23, w8, x9
	ldp	x26, x8, [x27, #8]
	cmp	x26, x8
	b.hs	LBB1_81
; %bb.80:                               ;   in Loop: Header=BB1_55 Depth=2
	str	d10, [x26], #8
	b	LBB1_86
LBB1_81:                                ;   in Loop: Header=BB1_55 Depth=2
	ldr	x22, [x27]
	sub	x23, x26, x22
	asr	x26, x23, #3
	add	x9, x26, #1
	lsr	x10, x9, #61
	cbnz	x10, LBB1_128
; %bb.82:                               ;   in Loop: Header=BB1_55 Depth=2
	sub	x8, x8, x22
	asr	x10, x8, #2
	cmp	x10, x9
	csel	x9, x10, x9, hi
	mov	x10, #9223372036854775800       ; =0x7ffffffffffffff8
	cmp	x8, x10
	mov	x8, #2305843009213693951        ; =0x1fffffffffffffff
	csel	x24, x9, x8, lo
	lsr	x8, x24, #61
	cbnz	x8, LBB1_129
; %bb.83:                               ;   in Loop: Header=BB1_55 Depth=2
	lsl	x0, x24, #3
Ltmp64:
	bl	__Znwm
Ltmp65:
; %bb.84:                               ;   in Loop: Header=BB1_55 Depth=2
	mov	x8, x26
	add	x26, x0, x23
	add	x9, x0, x24, lsl #3
	str	x9, [sp, #32]                   ; 8-byte Folded Spill
	sub	x24, x26, x8, lsl #3
	str	d10, [x26], #8
	mov	x0, x24
	mov	x1, x22
	mov	x2, x23
	bl	_memcpy
	str	x24, [x27]
	ldr	x8, [sp, #32]                   ; 8-byte Folded Reload
	str	x8, [x27, #16]
	cbz	x22, LBB1_86
; %bb.85:                               ;   in Loop: Header=BB1_55 Depth=2
	mov	x0, x22
	bl	__ZdlPv
LBB1_86:                                ;   in Loop: Header=BB1_55 Depth=2
	str	x26, [x27, #8]
	ldr	w8, [sp, #44]                   ; 4-byte Folded Reload
	add	w8, w8, #23
	mov	w9, #43691                      ; =0xaaab
	movk	w9, #43690, lsl #16
	umull	x9, w8, w9
	lsr	x9, x9, #33
	add	w9, w9, w9, lsl #1
	sub	w23, w8, w9
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x22, x0
	mov	w24, #100                       ; =0x64
LBB1_87:                                ;   Parent Loop BB1_29 Depth=1
                                        ;     Parent Loop BB1_55 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	; InlineAsm Start
	; InlineAsm End
	ldr	x8, [x25, x23, lsl #3]
Ltmp66:
	mov	x0, x19
	mov	x1, x20
	mov	x2, x28
	blr	x8
Ltmp67:
; %bb.88:                               ;   in Loop: Header=BB1_87 Depth=3
	str	s0, [x21, _sink@PAGEOFF]
	subs	w24, w24, #1
	b.ne	LBB1_87
; %bb.89:                               ;   in Loop: Header=BB1_55 Depth=2
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	sub	x8, x0, x22
	scvtf	d0, x8
	mov	x8, #70368744177664             ; =0x400000000000
	movk	x8, #16527, lsl #48
	fmov	d1, x8
	fdiv	d0, d0, d1
	mov	x8, #4636737291354636288        ; =0x4059000000000000
	fmov	d1, x8
	fdiv	d10, d0, d1
	mov	w8, #24                         ; =0x18
	add	x9, sp, #48
	umaddl	x27, w23, w8, x9
	ldp	x26, x8, [x27, #8]
	cmp	x26, x8
	b.lo	LBB1_53
; %bb.90:                               ;   in Loop: Header=BB1_55 Depth=2
	ldr	x22, [x27]
	sub	x23, x26, x22
	asr	x26, x23, #3
	add	x9, x26, #1
	lsr	x10, x9, #61
	cbnz	x10, LBB1_128
; %bb.91:                               ;   in Loop: Header=BB1_55 Depth=2
	sub	x8, x8, x22
	asr	x10, x8, #2
	cmp	x10, x9
	csel	x9, x10, x9, hi
	mov	x10, #9223372036854775800       ; =0x7ffffffffffffff8
	cmp	x8, x10
	mov	x8, #2305843009213693951        ; =0x1fffffffffffffff
	csel	x24, x9, x8, lo
	lsr	x8, x24, #61
	cbnz	x8, LBB1_129
; %bb.92:                               ;   in Loop: Header=BB1_55 Depth=2
	lsl	x0, x24, #3
Ltmp69:
	bl	__Znwm
Ltmp70:
; %bb.93:                               ;   in Loop: Header=BB1_55 Depth=2
	mov	x8, x26
	add	x26, x0, x23
	add	x9, x0, x24, lsl #3
	str	x9, [sp, #32]                   ; 8-byte Folded Spill
	sub	x24, x26, x8, lsl #3
	str	d10, [x26], #8
	mov	x0, x24
	mov	x1, x22
	mov	x2, x23
	bl	_memcpy
	str	x24, [x27]
	ldr	x8, [sp, #32]                   ; 8-byte Folded Reload
	str	x8, [x27, #16]
	cbz	x22, LBB1_54
; %bb.94:                               ;   in Loop: Header=BB1_55 Depth=2
	mov	x0, x22
	bl	__ZdlPv
	str	x26, [x27, #8]
	ldr	w26, [sp, #44]                  ; 4-byte Folded Reload
	add	w26, w26, #1
	cmp	w26, #100
	b.ne	LBB1_55
LBB1_95:                                ;   in Loop: Header=BB1_29 Depth=1
	ldp	x22, x1, [sp, #48]
Ltmp77:
	add	x2, sp, #135
	mov	x0, x22
	bl	__ZNSt3__16__sortIRNS_6__lessIddEEPdEEvT0_S5_T_
Ltmp78:
; %bb.96:                               ;   in Loop: Header=BB1_29 Depth=1
Ltmp79:
Lloh18:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh19:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh20:
	adrp	x1, l_.str.5@PAGE
Lloh21:
	add	x1, x1, l_.str.5@PAGEOFF
	mov	w2, #2                          ; =0x2
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp80:
; %bb.97:                               ;   in Loop: Header=BB1_29 Depth=1
Ltmp81:
	mov	x1, x28
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp82:
; %bb.98:                               ;   in Loop: Header=BB1_29 Depth=1
Ltmp83:
Lloh22:
	adrp	x1, l_.str.6@PAGE
Lloh23:
	add	x1, x1, l_.str.6@PAGEOFF
	mov	w2, #14                         ; =0xe
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp84:
; %bb.99:                               ;   in Loop: Header=BB1_29 Depth=1
Ltmp85:
	mov	w1, #1                          ; =0x1
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEi
Ltmp86:
; %bb.100:                              ;   in Loop: Header=BB1_29 Depth=1
Ltmp87:
Lloh24:
	adrp	x1, l_.str.7@PAGE
Lloh25:
	add	x1, x1, l_.str.7@PAGEOFF
	mov	w2, #23                         ; =0x17
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp88:
; %bb.101:                              ;   in Loop: Header=BB1_29 Depth=1
	ldr	d0, [x22, #400]
Ltmp89:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp90:
; %bb.102:                              ;   in Loop: Header=BB1_29 Depth=1
Ltmp91:
Lloh26:
	adrp	x1, l_.str.8@PAGE
Lloh27:
	add	x1, x1, l_.str.8@PAGEOFF
	mov	w2, #8                          ; =0x8
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp92:
; %bb.103:                              ;   in Loop: Header=BB1_29 Depth=1
	ldr	d0, [x22, #752]
Ltmp93:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp94:
; %bb.104:                              ;   in Loop: Header=BB1_29 Depth=1
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #135]
Ltmp95:
	add	x1, sp, #135
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp96:
; %bb.105:                              ;   in Loop: Header=BB1_29 Depth=1
	ldp	x23, x1, [sp, #72]
Ltmp97:
	add	x2, sp, #135
	mov	x0, x23
	bl	__ZNSt3__16__sortIRNS_6__lessIddEEPdEEvT0_S5_T_
Ltmp98:
; %bb.106:                              ;   in Loop: Header=BB1_29 Depth=1
Ltmp99:
Lloh28:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh29:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh30:
	adrp	x1, l_.str.5@PAGE
Lloh31:
	add	x1, x1, l_.str.5@PAGEOFF
	mov	w2, #2                          ; =0x2
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp100:
; %bb.107:                              ;   in Loop: Header=BB1_29 Depth=1
Ltmp101:
	mov	x1, x28
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp102:
; %bb.108:                              ;   in Loop: Header=BB1_29 Depth=1
Ltmp103:
Lloh32:
	adrp	x1, l_.str.6@PAGE
Lloh33:
	add	x1, x1, l_.str.6@PAGEOFF
	mov	w2, #14                         ; =0xe
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp104:
; %bb.109:                              ;   in Loop: Header=BB1_29 Depth=1
Ltmp105:
	mov	w1, #4                          ; =0x4
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEi
Ltmp106:
; %bb.110:                              ;   in Loop: Header=BB1_29 Depth=1
Ltmp107:
Lloh34:
	adrp	x1, l_.str.7@PAGE
Lloh35:
	add	x1, x1, l_.str.7@PAGEOFF
	mov	w2, #23                         ; =0x17
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp108:
; %bb.111:                              ;   in Loop: Header=BB1_29 Depth=1
	ldr	d0, [x23, #400]
Ltmp109:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp110:
; %bb.112:                              ;   in Loop: Header=BB1_29 Depth=1
Ltmp111:
Lloh36:
	adrp	x1, l_.str.8@PAGE
Lloh37:
	add	x1, x1, l_.str.8@PAGEOFF
	mov	w2, #8                          ; =0x8
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp112:
; %bb.113:                              ;   in Loop: Header=BB1_29 Depth=1
	ldr	d0, [x23, #752]
Ltmp113:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp114:
; %bb.114:                              ;   in Loop: Header=BB1_29 Depth=1
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #135]
Ltmp115:
	add	x1, sp, #135
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp116:
; %bb.115:                              ;   in Loop: Header=BB1_29 Depth=1
	ldp	x24, x1, [sp, #96]
Ltmp117:
	add	x2, sp, #135
	mov	x0, x24
	bl	__ZNSt3__16__sortIRNS_6__lessIddEEPdEEvT0_S5_T_
Ltmp118:
; %bb.116:                              ;   in Loop: Header=BB1_29 Depth=1
Ltmp119:
Lloh38:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh39:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh40:
	adrp	x1, l_.str.5@PAGE
Lloh41:
	add	x1, x1, l_.str.5@PAGEOFF
	mov	w2, #2                          ; =0x2
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp120:
; %bb.117:                              ;   in Loop: Header=BB1_29 Depth=1
Ltmp121:
	mov	x1, x28
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp122:
; %bb.118:                              ;   in Loop: Header=BB1_29 Depth=1
Ltmp123:
Lloh42:
	adrp	x1, l_.str.6@PAGE
Lloh43:
	add	x1, x1, l_.str.6@PAGEOFF
	mov	w2, #14                         ; =0xe
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp124:
; %bb.119:                              ;   in Loop: Header=BB1_29 Depth=1
Ltmp126:
	mov	w1, #16                         ; =0x10
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEi
Ltmp127:
; %bb.120:                              ;   in Loop: Header=BB1_29 Depth=1
Ltmp128:
Lloh44:
	adrp	x1, l_.str.7@PAGE
Lloh45:
	add	x1, x1, l_.str.7@PAGEOFF
	mov	w2, #23                         ; =0x17
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp129:
; %bb.121:                              ;   in Loop: Header=BB1_29 Depth=1
	ldr	d0, [x24, #400]
Ltmp130:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp131:
; %bb.122:                              ;   in Loop: Header=BB1_29 Depth=1
Ltmp132:
Lloh46:
	adrp	x1, l_.str.8@PAGE
Lloh47:
	add	x1, x1, l_.str.8@PAGEOFF
	mov	w2, #8                          ; =0x8
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp133:
; %bb.123:                              ;   in Loop: Header=BB1_29 Depth=1
	ldr	d0, [x24, #752]
Ltmp134:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp135:
; %bb.124:                              ;   in Loop: Header=BB1_29 Depth=1
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #135]
Ltmp136:
	add	x1, sp, #135
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp137:
; %bb.125:                              ;   in Loop: Header=BB1_29 Depth=1
	mov	x0, x24
	bl	__ZdlPv
	mov	x0, x23
	bl	__ZdlPv
	mov	x0, x22
	bl	__ZdlPv
	ldr	x22, [sp, #24]                  ; 8-byte Folded Reload
	add	x22, x22, #8
	cmp	x22, #24
	b.ne	LBB1_29
; %bb.126:
	mov	x0, x20
	bl	__ZdlPv
	mov	x0, x19
	bl	__ZdlPv
	mov	w0, #0                          ; =0x0
LBB1_127:
	ldp	x29, x30, [sp, #288]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #272]            ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #256]            ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #240]            ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #224]            ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #208]            ; 16-byte Folded Reload
	ldp	d9, d8, [sp, #192]              ; 16-byte Folded Reload
	ldp	d11, d10, [sp, #176]            ; 16-byte Folded Reload
	ldp	d13, d12, [sp, #160]            ; 16-byte Folded Reload
	ldp	d15, d14, [sp, #144]            ; 16-byte Folded Reload
	add	sp, sp, #304
	ret
LBB1_128:
Ltmp74:
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_length_errorB9nqe210106Ev
Ltmp75:
	b	LBB1_134
LBB1_129:
Ltmp72:
	bl	__ZSt28__throw_bad_array_new_lengthB9nqe210106v
Ltmp73:
	b	LBB1_134
LBB1_130:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x23, x0
Ltmp12:
Lloh48:
	adrp	x1, l_.str@PAGE
Lloh49:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp13:
; %bb.131:
Ltmp15:
Lloh50:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh51:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh52:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh53:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x23
	bl	___cxa_throw
Ltmp16:
	b	LBB1_134
LBB1_132:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x23, x0
Ltmp32:
Lloh54:
	adrp	x1, l_.str@PAGE
Lloh55:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp33:
; %bb.133:
Ltmp35:
Lloh56:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh57:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh58:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh59:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x23
	bl	___cxa_throw
Ltmp36:
LBB1_134:
	brk	#0x1
LBB1_135:
Ltmp8:
	mov	x21, x1
	mov	x22, x0
	b	LBB1_164
LBB1_136:
Ltmp5:
	mov	x21, x1
	mov	x22, x0
	b	LBB1_165
LBB1_137:
Ltmp28:
	b	LBB1_146
LBB1_138:
Ltmp31:
	b	LBB1_146
LBB1_139:
Ltmp11:
	b	LBB1_146
LBB1_140:
Ltmp37:
	b	LBB1_146
LBB1_141:
Ltmp34:
	b	LBB1_144
LBB1_142:
Ltmp17:
	b	LBB1_146
LBB1_143:
Ltmp14:
LBB1_144:
	mov	x21, x1
	mov	x22, x0
	mov	x0, x23
	bl	___cxa_free_exception
	b	LBB1_163
LBB1_145:
Ltmp46:
LBB1_146:
	mov	x21, x1
	mov	x22, x0
	b	LBB1_163
LBB1_147:
Ltmp125:
	b	LBB1_157
LBB1_148:
Ltmp138:
	b	LBB1_157
LBB1_149:
Ltmp71:
	b	LBB1_157
LBB1_150:
Ltmp76:
	b	LBB1_157
LBB1_151:
Ltmp55:
	b	LBB1_157
LBB1_152:
Ltmp52:
	b	LBB1_157
LBB1_153:
Ltmp49:
	b	LBB1_157
LBB1_154:
Ltmp68:
	b	LBB1_157
LBB1_155:
Ltmp63:
	b	LBB1_157
LBB1_156:
Ltmp58:
LBB1_157:
	mov	x21, x1
	mov	x22, x0
	ldr	x0, [sp, #96]
	cbz	x0, LBB1_159
; %bb.158:
	bl	__ZdlPv
LBB1_159:
	ldr	x0, [sp, #72]
	cbz	x0, LBB1_161
; %bb.160:
	bl	__ZdlPv
LBB1_161:
	ldr	x0, [sp, #48]
	cbz	x0, LBB1_163
; %bb.162:
	bl	__ZdlPv
LBB1_163:
	mov	x0, x20
	bl	__ZdlPv
LBB1_164:
	mov	x0, x19
	bl	__ZdlPv
LBB1_165:
	cmp	w21, #1
	b.ne	LBB1_170
; %bb.166:
	mov	x0, x22
	bl	___cxa_begin_catch
	ldr	x8, [x0]
	ldr	x8, [x8, #16]
	blr	x8
	mov	x19, x0
	bl	_strlen
	mov	x2, x0
Ltmp139:
Lloh60:
	adrp	x0, __ZNSt3__14cerrE@GOTPAGE
Lloh61:
	ldr	x0, [x0, __ZNSt3__14cerrE@GOTPAGEOFF]
	mov	x1, x19
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp140:
; %bb.167:
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #48]
Ltmp141:
	add	x1, sp, #48
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp142:
; %bb.168:
	bl	___cxa_end_catch
	mov	w0, #1                          ; =0x1
	b	LBB1_127
LBB1_169:
Ltmp143:
	mov	x22, x0
Ltmp144:
	bl	___cxa_end_catch
Ltmp145:
LBB1_170:
	mov	x0, x22
	bl	__Unwind_Resume
LBB1_171:
Ltmp146:
	bl	___clang_call_terminate
	.loh AdrpAdd	Lloh4, Lloh5
	.loh AdrpLdrGot	Lloh2, Lloh3
	.loh AdrpAdd	Lloh6, Lloh7
	.loh AdrpAdd	Lloh8, Lloh9
	.loh AdrpAdd	Lloh10, Lloh11
	.loh AdrpAdd	Lloh14, Lloh15
	.loh AdrpLdrGot	Lloh12, Lloh13
	.loh AdrpAdd	Lloh16, Lloh17
	.loh AdrpAdd	Lloh20, Lloh21
	.loh AdrpLdrGot	Lloh18, Lloh19
	.loh AdrpAdd	Lloh22, Lloh23
	.loh AdrpAdd	Lloh24, Lloh25
	.loh AdrpAdd	Lloh26, Lloh27
	.loh AdrpAdd	Lloh30, Lloh31
	.loh AdrpLdrGot	Lloh28, Lloh29
	.loh AdrpAdd	Lloh32, Lloh33
	.loh AdrpAdd	Lloh34, Lloh35
	.loh AdrpAdd	Lloh36, Lloh37
	.loh AdrpAdd	Lloh40, Lloh41
	.loh AdrpLdrGot	Lloh38, Lloh39
	.loh AdrpAdd	Lloh42, Lloh43
	.loh AdrpAdd	Lloh44, Lloh45
	.loh AdrpAdd	Lloh46, Lloh47
	.loh AdrpAdd	Lloh48, Lloh49
	.loh AdrpLdrGot	Lloh52, Lloh53
	.loh AdrpLdrGot	Lloh50, Lloh51
	.loh AdrpAdd	Lloh54, Lloh55
	.loh AdrpLdrGot	Lloh58, Lloh59
	.loh AdrpLdrGot	Lloh56, Lloh57
	.loh AdrpLdrGot	Lloh60, Lloh61
Lfunc_end1:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table1:
Lexception1:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase0-Lttbaseref0
Lttbaseref0:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end1-Lcst_begin1
Lcst_begin1:
	.uleb128 Ltmp3-Lfunc_begin1             ; >> Call Site 1 <<
	.uleb128 Ltmp4-Ltmp3                    ;   Call between Ltmp3 and Ltmp4
	.uleb128 Ltmp5-Lfunc_begin1             ;     jumps to Ltmp5
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp4-Lfunc_begin1             ; >> Call Site 2 <<
	.uleb128 Ltmp6-Ltmp4                    ;   Call between Ltmp4 and Ltmp6
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp6-Lfunc_begin1             ; >> Call Site 3 <<
	.uleb128 Ltmp7-Ltmp6                    ;   Call between Ltmp6 and Ltmp7
	.uleb128 Ltmp8-Lfunc_begin1             ;     jumps to Ltmp8
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp7-Lfunc_begin1             ; >> Call Site 4 <<
	.uleb128 Ltmp9-Ltmp7                    ;   Call between Ltmp7 and Ltmp9
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp9-Lfunc_begin1             ; >> Call Site 5 <<
	.uleb128 Ltmp10-Ltmp9                   ;   Call between Ltmp9 and Ltmp10
	.uleb128 Ltmp11-Lfunc_begin1            ;     jumps to Ltmp11
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp18-Lfunc_begin1            ; >> Call Site 6 <<
	.uleb128 Ltmp27-Ltmp18                  ;   Call between Ltmp18 and Ltmp27
	.uleb128 Ltmp28-Lfunc_begin1            ;     jumps to Ltmp28
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp29-Lfunc_begin1            ; >> Call Site 7 <<
	.uleb128 Ltmp30-Ltmp29                  ;   Call between Ltmp29 and Ltmp30
	.uleb128 Ltmp31-Lfunc_begin1            ;     jumps to Ltmp31
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp38-Lfunc_begin1            ; >> Call Site 8 <<
	.uleb128 Ltmp45-Ltmp38                  ;   Call between Ltmp38 and Ltmp45
	.uleb128 Ltmp46-Lfunc_begin1            ;     jumps to Ltmp46
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp56-Lfunc_begin1            ; >> Call Site 9 <<
	.uleb128 Ltmp57-Ltmp56                  ;   Call between Ltmp56 and Ltmp57
	.uleb128 Ltmp58-Lfunc_begin1            ;     jumps to Ltmp58
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp47-Lfunc_begin1            ; >> Call Site 10 <<
	.uleb128 Ltmp48-Ltmp47                  ;   Call between Ltmp47 and Ltmp48
	.uleb128 Ltmp49-Lfunc_begin1            ;     jumps to Ltmp49
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp50-Lfunc_begin1            ; >> Call Site 11 <<
	.uleb128 Ltmp51-Ltmp50                  ;   Call between Ltmp50 and Ltmp51
	.uleb128 Ltmp52-Lfunc_begin1            ;     jumps to Ltmp52
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp53-Lfunc_begin1            ; >> Call Site 12 <<
	.uleb128 Ltmp54-Ltmp53                  ;   Call between Ltmp53 and Ltmp54
	.uleb128 Ltmp55-Lfunc_begin1            ;     jumps to Ltmp55
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp59-Lfunc_begin1            ; >> Call Site 13 <<
	.uleb128 Ltmp60-Ltmp59                  ;   Call between Ltmp59 and Ltmp60
	.uleb128 Ltmp71-Lfunc_begin1            ;     jumps to Ltmp71
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp60-Lfunc_begin1            ; >> Call Site 14 <<
	.uleb128 Ltmp61-Ltmp60                  ;   Call between Ltmp60 and Ltmp61
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp61-Lfunc_begin1            ; >> Call Site 15 <<
	.uleb128 Ltmp62-Ltmp61                  ;   Call between Ltmp61 and Ltmp62
	.uleb128 Ltmp63-Lfunc_begin1            ;     jumps to Ltmp63
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp64-Lfunc_begin1            ; >> Call Site 16 <<
	.uleb128 Ltmp65-Ltmp64                  ;   Call between Ltmp64 and Ltmp65
	.uleb128 Ltmp71-Lfunc_begin1            ;     jumps to Ltmp71
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp65-Lfunc_begin1            ; >> Call Site 17 <<
	.uleb128 Ltmp66-Ltmp65                  ;   Call between Ltmp65 and Ltmp66
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp66-Lfunc_begin1            ; >> Call Site 18 <<
	.uleb128 Ltmp67-Ltmp66                  ;   Call between Ltmp66 and Ltmp67
	.uleb128 Ltmp68-Lfunc_begin1            ;     jumps to Ltmp68
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp69-Lfunc_begin1            ; >> Call Site 19 <<
	.uleb128 Ltmp70-Ltmp69                  ;   Call between Ltmp69 and Ltmp70
	.uleb128 Ltmp71-Lfunc_begin1            ;     jumps to Ltmp71
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp70-Lfunc_begin1            ; >> Call Site 20 <<
	.uleb128 Ltmp77-Ltmp70                  ;   Call between Ltmp70 and Ltmp77
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp77-Lfunc_begin1            ; >> Call Site 21 <<
	.uleb128 Ltmp84-Ltmp77                  ;   Call between Ltmp77 and Ltmp84
	.uleb128 Ltmp125-Lfunc_begin1           ;     jumps to Ltmp125
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp85-Lfunc_begin1            ; >> Call Site 22 <<
	.uleb128 Ltmp96-Ltmp85                  ;   Call between Ltmp85 and Ltmp96
	.uleb128 Ltmp138-Lfunc_begin1           ;     jumps to Ltmp138
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp97-Lfunc_begin1            ; >> Call Site 23 <<
	.uleb128 Ltmp104-Ltmp97                 ;   Call between Ltmp97 and Ltmp104
	.uleb128 Ltmp125-Lfunc_begin1           ;     jumps to Ltmp125
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp105-Lfunc_begin1           ; >> Call Site 24 <<
	.uleb128 Ltmp116-Ltmp105                ;   Call between Ltmp105 and Ltmp116
	.uleb128 Ltmp138-Lfunc_begin1           ;     jumps to Ltmp138
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp117-Lfunc_begin1           ; >> Call Site 25 <<
	.uleb128 Ltmp124-Ltmp117                ;   Call between Ltmp117 and Ltmp124
	.uleb128 Ltmp125-Lfunc_begin1           ;     jumps to Ltmp125
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp126-Lfunc_begin1           ; >> Call Site 26 <<
	.uleb128 Ltmp137-Ltmp126                ;   Call between Ltmp126 and Ltmp137
	.uleb128 Ltmp138-Lfunc_begin1           ;     jumps to Ltmp138
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp74-Lfunc_begin1            ; >> Call Site 27 <<
	.uleb128 Ltmp73-Ltmp74                  ;   Call between Ltmp74 and Ltmp73
	.uleb128 Ltmp76-Lfunc_begin1            ;     jumps to Ltmp76
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp73-Lfunc_begin1            ; >> Call Site 28 <<
	.uleb128 Ltmp12-Ltmp73                  ;   Call between Ltmp73 and Ltmp12
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp12-Lfunc_begin1            ; >> Call Site 29 <<
	.uleb128 Ltmp13-Ltmp12                  ;   Call between Ltmp12 and Ltmp13
	.uleb128 Ltmp14-Lfunc_begin1            ;     jumps to Ltmp14
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp15-Lfunc_begin1            ; >> Call Site 30 <<
	.uleb128 Ltmp16-Ltmp15                  ;   Call between Ltmp15 and Ltmp16
	.uleb128 Ltmp17-Lfunc_begin1            ;     jumps to Ltmp17
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp16-Lfunc_begin1            ; >> Call Site 31 <<
	.uleb128 Ltmp32-Ltmp16                  ;   Call between Ltmp16 and Ltmp32
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp32-Lfunc_begin1            ; >> Call Site 32 <<
	.uleb128 Ltmp33-Ltmp32                  ;   Call between Ltmp32 and Ltmp33
	.uleb128 Ltmp34-Lfunc_begin1            ;     jumps to Ltmp34
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp35-Lfunc_begin1            ; >> Call Site 33 <<
	.uleb128 Ltmp36-Ltmp35                  ;   Call between Ltmp35 and Ltmp36
	.uleb128 Ltmp37-Lfunc_begin1            ;     jumps to Ltmp37
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp36-Lfunc_begin1            ; >> Call Site 34 <<
	.uleb128 Ltmp139-Ltmp36                 ;   Call between Ltmp36 and Ltmp139
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp139-Lfunc_begin1           ; >> Call Site 35 <<
	.uleb128 Ltmp142-Ltmp139                ;   Call between Ltmp139 and Ltmp142
	.uleb128 Ltmp143-Lfunc_begin1           ;     jumps to Ltmp143
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp142-Lfunc_begin1           ; >> Call Site 36 <<
	.uleb128 Ltmp144-Ltmp142                ;   Call between Ltmp142 and Ltmp144
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp144-Lfunc_begin1           ; >> Call Site 37 <<
	.uleb128 Ltmp145-Ltmp144                ;   Call between Ltmp144 and Ltmp145
	.uleb128 Ltmp146-Lfunc_begin1           ;     jumps to Ltmp146
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp145-Lfunc_begin1           ; >> Call Site 38 <<
	.uleb128 Lfunc_end1-Ltmp145             ;   Call between Ltmp145 and Lfunc_end1
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
	.byte	0                               ;   No further actions
	.p2align	2, 0x0
                                        ; >> Catch TypeInfos <<
	.long	0                               ; TypeInfo 2
Ltmp175:                                ; TypeInfo 1
	.long	__ZTISt9exception@GOT-Ltmp175
Lttbase0:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__Z3dotILi1EEfPKfS1_m           ; -- Begin function _Z3dotILi1EEfPKfS1_m
	.weak_definition	__Z3dotILi1EEfPKfS1_m
	.p2align	2
__Z3dotILi1EEfPKfS1_m:                  ; @_Z3dotILi1EEfPKfS1_m
	.cfi_startproc
; %bb.0:
	cmp	x2, #4
	b.lo	LBB2_4
; %bb.1:
	movi.2d	v0, #0000000000000000
	mov	x8, x2
	mov	x9, x1
	mov	x10, x0
LBB2_2:                                 ; =>This Inner Loop Header: Depth=1
	ldr	q1, [x10], #16
	ldr	q2, [x9], #16
	fmla.4s	v0, v2, v1
	sub	x8, x8, #4
	cmp	x8, #3
	b.hi	LBB2_2
; %bb.3:
	and	x9, x2, #0xfffffffffffffffc
	faddp.4s	v0, v0, v0
	faddp.2s	s0, v0
	subs	x8, x2, x9
	b.hi	LBB2_5
	b	LBB2_7
LBB2_4:
	mov	x9, #0                          ; =0x0
	movi.2d	v0, #0000000000000000
	faddp.4s	v0, v0, v0
	faddp.2s	s0, v0
	subs	x8, x2, x9
	b.ls	LBB2_7
LBB2_5:
	lsl	x10, x9, #2
	add	x9, x1, x10
	add	x10, x0, x10
LBB2_6:                                 ; =>This Inner Loop Header: Depth=1
	ldr	s1, [x10], #4
	ldr	s2, [x9], #4
	fmadd	s0, s1, s2, s0
	subs	x8, x8, #1
	b.ne	LBB2_6
LBB2_7:
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__Z3dotILi4EEfPKfS1_m           ; -- Begin function _Z3dotILi4EEfPKfS1_m
	.weak_definition	__Z3dotILi4EEfPKfS1_m
	.p2align	2
__Z3dotILi4EEfPKfS1_m:                  ; @_Z3dotILi4EEfPKfS1_m
	.cfi_startproc
; %bb.0:
	cmp	x2, #16
	b.lo	LBB3_4
; %bb.1:
	mov	x8, #0                          ; =0x0
	add	x9, x1, #32
	add	x10, x0, #32
	movi.2d	v0, #0000000000000000
	mov	x11, x2
	movi.2d	v1, #0000000000000000
	movi.2d	v2, #0000000000000000
	movi.2d	v3, #0000000000000000
LBB3_2:                                 ; =>This Inner Loop Header: Depth=1
	ldp	q4, q5, [x10, #-32]
	ldp	q6, q7, [x9, #-32]
	fmla.4s	v3, v6, v4
	fmla.4s	v2, v7, v5
	ldp	q4, q5, [x10], #64
	ldp	q6, q7, [x9], #64
	fmla.4s	v1, v6, v4
	fmla.4s	v0, v7, v5
	add	x8, x8, #16
	sub	x11, x11, #16
	cmp	x11, #15
	b.hi	LBB3_2
; %bb.3:
	fadd.4s	v2, v3, v2
	fadd.4s	v1, v2, v1
	fadd.4s	v0, v1, v0
	faddp.4s	v0, v0, v0
	faddp.2s	s0, v0
	subs	x9, x2, x8
	b.hi	LBB3_5
	b	LBB3_7
LBB3_4:
	mov	x8, #0                          ; =0x0
	movi.2d	v0, #0000000000000000
	faddp.4s	v0, v0, v0
	faddp.2s	s0, v0
	subs	x9, x2, x8
	b.ls	LBB3_7
LBB3_5:
	lsl	x10, x8, #2
	add	x8, x1, x10
	add	x10, x0, x10
LBB3_6:                                 ; =>This Inner Loop Header: Depth=1
	ldr	s1, [x10], #4
	ldr	s2, [x8], #4
	fmadd	s0, s1, s2, s0
	subs	x9, x9, #1
	b.ne	LBB3_6
LBB3_7:
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__Z3dotILi16EEfPKfS1_m          ; -- Begin function _Z3dotILi16EEfPKfS1_m
	.weak_definition	__Z3dotILi16EEfPKfS1_m
	.p2align	2
__Z3dotILi16EEfPKfS1_m:                 ; @_Z3dotILi16EEfPKfS1_m
	.cfi_startproc
; %bb.0:
	cmp	x2, #64
	b.lo	LBB4_4
; %bb.1:
	mov	x8, #0                          ; =0x0
	movi.2d	v0, #0000000000000000
	movi.2d	v1, #0000000000000000
	add	x9, x1, #128
	movi.2d	v2, #0000000000000000
	add	x10, x0, #128
	movi.2d	v3, #0000000000000000
	mov	x11, x2
	movi.2d	v4, #0000000000000000
	movi.2d	v5, #0000000000000000
	movi.2d	v6, #0000000000000000
	movi.2d	v7, #0000000000000000
	movi.2d	v16, #0000000000000000
	movi.2d	v17, #0000000000000000
	movi.2d	v18, #0000000000000000
	movi.2d	v19, #0000000000000000
	movi.2d	v20, #0000000000000000
	movi.2d	v21, #0000000000000000
	movi.2d	v22, #0000000000000000
	movi.2d	v23, #0000000000000000
LBB4_2:                                 ; =>This Inner Loop Header: Depth=1
	ldp	q24, q25, [x10, #-128]
	ldp	q26, q27, [x9, #-128]
	fmla.4s	v23, v26, v24
	fmla.4s	v22, v27, v25
	ldp	q24, q25, [x10, #-96]
	ldp	q26, q27, [x9, #-96]
	fmla.4s	v21, v26, v24
	fmla.4s	v20, v27, v25
	ldp	q24, q25, [x10, #-64]
	ldp	q26, q27, [x9, #-64]
	fmla.4s	v19, v26, v24
	fmla.4s	v18, v27, v25
	ldp	q24, q25, [x10, #-32]
	ldp	q26, q27, [x9, #-32]
	fmla.4s	v17, v26, v24
	fmla.4s	v16, v27, v25
	ldp	q24, q25, [x10]
	ldp	q26, q27, [x9]
	fmla.4s	v7, v26, v24
	fmla.4s	v6, v27, v25
	ldp	q24, q25, [x10, #32]
	ldp	q26, q27, [x9, #32]
	fmla.4s	v5, v26, v24
	fmla.4s	v4, v27, v25
	ldp	q24, q25, [x10, #64]
	ldp	q26, q27, [x9, #64]
	fmla.4s	v3, v26, v24
	fmla.4s	v2, v27, v25
	ldp	q24, q25, [x10, #96]
	ldp	q26, q27, [x9, #96]
	fmla.4s	v1, v26, v24
	fmla.4s	v0, v27, v25
	add	x8, x8, #64
	sub	x11, x11, #64
	add	x9, x9, #256
	add	x10, x10, #256
	cmp	x11, #63
	b.hi	LBB4_2
; %bb.3:
	fadd.4s	v22, v23, v22
	fadd.4s	v21, v22, v21
	fadd.4s	v20, v21, v20
	fadd.4s	v19, v20, v19
	fadd.4s	v18, v19, v18
	fadd.4s	v17, v18, v17
	fadd.4s	v16, v17, v16
	fadd.4s	v7, v16, v7
	fadd.4s	v6, v7, v6
	fadd.4s	v5, v6, v5
	fadd.4s	v4, v5, v4
	fadd.4s	v3, v4, v3
	fadd.4s	v2, v3, v2
	fadd.4s	v1, v2, v1
	fadd.4s	v0, v1, v0
	faddp.4s	v0, v0, v0
	faddp.2s	s0, v0
	subs	x9, x2, x8
	b.hi	LBB4_5
	b	LBB4_7
LBB4_4:
	mov	x8, #0                          ; =0x0
	movi.2d	v0, #0000000000000000
	faddp.4s	v0, v0, v0
	faddp.2s	s0, v0
	subs	x9, x2, x8
	b.ls	LBB4_7
LBB4_5:
	lsl	x10, x8, #2
	add	x8, x1, x10
	add	x10, x0, x10
LBB4_6:                                 ; =>This Inner Loop Header: Depth=1
	ldr	s1, [x10], #4
	ldr	s2, [x8], #4
	fmadd	s0, s1, s2, s0
	subs	x9, x9, #1
	b.ne	LBB4_6
LBB4_7:
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
Ltmp147:
	mov	x1, x20
	bl	__ZNSt12length_errorC1B9nqe210106EPKc
Ltmp148:
; %bb.1:
Lloh62:
	adrp	x1, __ZTISt12length_error@GOTPAGE
Lloh63:
	ldr	x1, [x1, __ZTISt12length_error@GOTPAGEOFF]
Lloh64:
	adrp	x2, __ZNSt12length_errorD1Ev@GOTPAGE
Lloh65:
	ldr	x2, [x2, __ZNSt12length_errorD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
LBB6_2:
Ltmp149:
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x0, x20
	bl	__Unwind_Resume
	.loh AdrpLdrGot	Lloh64, Lloh65
	.loh AdrpLdrGot	Lloh62, Lloh63
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
	.uleb128 Lfunc_begin2-Lfunc_begin2      ; >> Call Site 1 <<
	.uleb128 Ltmp147-Lfunc_begin2           ;   Call between Lfunc_begin2 and Ltmp147
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp147-Lfunc_begin2           ; >> Call Site 2 <<
	.uleb128 Ltmp148-Ltmp147                ;   Call between Ltmp147 and Ltmp148
	.uleb128 Ltmp149-Lfunc_begin2           ;     jumps to Ltmp149
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp148-Lfunc_begin2           ; >> Call Site 3 <<
	.uleb128 Lfunc_end2-Ltmp148             ;   Call between Ltmp148 and Lfunc_end2
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
Lloh66:
	adrp	x8, __ZTVSt12length_error@GOTPAGE
Lloh67:
	ldr	x8, [x8, __ZTVSt12length_error@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x0]
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
	.loh AdrpLdrGot	Lloh66, Lloh67
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
Lloh68:
	adrp	x1, __ZTISt20bad_array_new_length@GOTPAGE
Lloh69:
	ldr	x1, [x1, __ZTISt20bad_array_new_length@GOTPAGEOFF]
Lloh70:
	adrp	x2, __ZNSt20bad_array_new_lengthD1Ev@GOTPAGE
Lloh71:
	ldr	x2, [x2, __ZNSt20bad_array_new_lengthD1Ev@GOTPAGEOFF]
	bl	___cxa_throw
	.loh AdrpLdrGot	Lloh70, Lloh71
	.loh AdrpLdrGot	Lloh68, Lloh69
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
Ltmp150:
	add	x0, sp, #8
	mov	x1, x19
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryC1ERS3_
Ltmp151:
; %bb.1:
	ldrb	w8, [sp, #8]
	cmp	w8, #1
	b.ne	LBB9_10
; %bb.2:
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
	add	x4, x19, x8
	ldr	x22, [x4, #40]
	ldr	w24, [x4, #8]
	ldr	w23, [x4, #144]
	cmn	w23, #1
	b.ne	LBB9_7
; %bb.3:
Ltmp153:
	add	x8, sp, #24
	mov	x25, x4
	mov	x0, x4
	bl	__ZNKSt3__18ios_base6getlocEv
Ltmp154:
; %bb.4:
Ltmp155:
Lloh72:
	adrp	x1, __ZNSt3__15ctypeIcE2idE@GOTPAGE
Lloh73:
	ldr	x1, [x1, __ZNSt3__15ctypeIcE2idE@GOTPAGEOFF]
	add	x0, sp, #24
	bl	__ZNKSt3__16locale9use_facetERNS0_2idE
Ltmp156:
; %bb.5:
	ldr	x8, [x0]
	ldr	x8, [x8, #56]
Ltmp157:
	mov	w1, #32                         ; =0x20
	blr	x8
Ltmp158:
; %bb.6:
	mov	x23, x0
	add	x0, sp, #24
	bl	__ZNSt3__16localeD1Ev
	mov	x4, x25
	str	w23, [x25, #144]
LBB9_7:
	mov	w8, #176                        ; =0xb0
	and	w8, w24, w8
	add	x3, x20, x21
	cmp	w8, #32
	csel	x2, x3, x20, eq
Ltmp160:
	sxtb	w5, w23
	mov	x0, x22
	mov	x1, x20
	bl	__ZNSt3__116__pad_and_outputB9nqe210106IcNS_11char_traitsIcEEEENS_19ostreambuf_iteratorIT_T0_EES6_PKS4_S8_S8_RNS_8ios_baseES4_
Ltmp161:
; %bb.8:
	cbnz	x0, LBB9_10
; %bb.9:
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
	add	x0, x19, x8
	ldr	w8, [x0, #32]
	mov	w9, #5                          ; =0x5
Ltmp163:
	orr	w1, w8, w9
	bl	__ZNSt3__18ios_base5clearEj
Ltmp164:
LBB9_10:
	add	x0, sp, #8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryD1Ev
LBB9_11:
	mov	x0, x19
	ldp	x29, x30, [sp, #96]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #80]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #64]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #48]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #112
	ret
LBB9_12:
Ltmp165:
	b	LBB9_15
LBB9_13:
Ltmp159:
	mov	x20, x0
	add	x0, sp, #24
	bl	__ZNSt3__16localeD1Ev
	b	LBB9_16
LBB9_14:
Ltmp162:
LBB9_15:
	mov	x20, x0
LBB9_16:
	add	x0, sp, #8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryD1Ev
	b	LBB9_18
LBB9_17:
Ltmp152:
	mov	x20, x0
LBB9_18:
	mov	x0, x20
	bl	___cxa_begin_catch
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
Ltmp166:
	add	x0, x19, x8
	bl	__ZNSt3__18ios_base33__set_badbit_and_consider_rethrowEv
Ltmp167:
; %bb.19:
	bl	___cxa_end_catch
	b	LBB9_11
LBB9_20:
Ltmp168:
	mov	x19, x0
Ltmp169:
	bl	___cxa_end_catch
Ltmp170:
; %bb.21:
	mov	x0, x19
	bl	__Unwind_Resume
LBB9_22:
Ltmp171:
	bl	___clang_call_terminate
	.loh AdrpLdrGot	Lloh72, Lloh73
Lfunc_end3:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table9:
Lexception3:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase1-Lttbaseref1
Lttbaseref1:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end3-Lcst_begin3
Lcst_begin3:
	.uleb128 Ltmp150-Lfunc_begin3           ; >> Call Site 1 <<
	.uleb128 Ltmp151-Ltmp150                ;   Call between Ltmp150 and Ltmp151
	.uleb128 Ltmp152-Lfunc_begin3           ;     jumps to Ltmp152
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp153-Lfunc_begin3           ; >> Call Site 2 <<
	.uleb128 Ltmp154-Ltmp153                ;   Call between Ltmp153 and Ltmp154
	.uleb128 Ltmp162-Lfunc_begin3           ;     jumps to Ltmp162
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp155-Lfunc_begin3           ; >> Call Site 3 <<
	.uleb128 Ltmp158-Ltmp155                ;   Call between Ltmp155 and Ltmp158
	.uleb128 Ltmp159-Lfunc_begin3           ;     jumps to Ltmp159
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp160-Lfunc_begin3           ; >> Call Site 4 <<
	.uleb128 Ltmp161-Ltmp160                ;   Call between Ltmp160 and Ltmp161
	.uleb128 Ltmp162-Lfunc_begin3           ;     jumps to Ltmp162
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp163-Lfunc_begin3           ; >> Call Site 5 <<
	.uleb128 Ltmp164-Ltmp163                ;   Call between Ltmp163 and Ltmp164
	.uleb128 Ltmp165-Lfunc_begin3           ;     jumps to Ltmp165
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp164-Lfunc_begin3           ; >> Call Site 6 <<
	.uleb128 Ltmp166-Ltmp164                ;   Call between Ltmp164 and Ltmp166
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp166-Lfunc_begin3           ; >> Call Site 7 <<
	.uleb128 Ltmp167-Ltmp166                ;   Call between Ltmp166 and Ltmp167
	.uleb128 Ltmp168-Lfunc_begin3           ;     jumps to Ltmp168
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp167-Lfunc_begin3           ; >> Call Site 8 <<
	.uleb128 Ltmp169-Ltmp167                ;   Call between Ltmp167 and Ltmp169
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp169-Lfunc_begin3           ; >> Call Site 9 <<
	.uleb128 Ltmp170-Ltmp169                ;   Call between Ltmp169 and Ltmp170
	.uleb128 Ltmp171-Lfunc_begin3           ;     jumps to Ltmp171
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp170-Lfunc_begin3           ; >> Call Site 10 <<
	.uleb128 Lfunc_end3-Ltmp170             ;   Call between Ltmp170 and Lfunc_end3
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
	cbz	x0, LBB10_16
; %bb.1:
	mov	x23, x5
	mov	x20, x4
	mov	x22, x3
	mov	x21, x2
	mov	x24, x1
	ldr	x26, [x4, #24]
	sub	x25, x2, x1
	cmp	x25, #1
	b.lt	LBB10_3
; %bb.2:
	ldr	x8, [x19]
	ldr	x8, [x8, #96]
	mov	x0, x19
	mov	x1, x24
	mov	x2, x25
	blr	x8
	cmp	x0, x25
	b.ne	LBB10_15
LBB10_3:
	sub	x8, x22, x24
	cmp	x26, x8
	b.le	LBB10_12
; %bb.4:
	mov	x9, #-9                         ; =0xfffffffffffffff7
	movk	x9, #32767, lsl #48
	sub	x24, x26, x8
	cmp	x24, x9
	b.hs	LBB10_17
; %bb.5:
	cmp	x24, #23
	b.hs	LBB10_7
; %bb.6:
	strb	w24, [sp, #31]
	add	x25, sp, #8
	b	LBB10_8
LBB10_7:
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
LBB10_8:
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
Ltmp172:
	mov	x0, x19
	mov	x2, x24
	blr	x8
Ltmp173:
; %bb.9:
	ldrsb	w8, [sp, #31]
	tbnz	w8, #31, LBB10_11
; %bb.10:
	cmp	x0, x24
	b.ne	LBB10_15
	b	LBB10_12
LBB10_11:
	ldr	x8, [sp, #8]
	mov	x23, x0
	mov	x0, x8
	bl	__ZdlPv
	cmp	x23, x24
	b.ne	LBB10_15
LBB10_12:
	sub	x22, x22, x21
	cmp	x22, #1
	b.lt	LBB10_14
; %bb.13:
	ldr	x8, [x19]
	ldr	x8, [x8, #96]
	mov	x0, x19
	mov	x1, x21
	mov	x2, x22
	blr	x8
	cmp	x0, x22
	b.ne	LBB10_15
LBB10_14:
	str	xzr, [x20, #24]
	b	LBB10_16
LBB10_15:
	mov	x19, #0                         ; =0x0
LBB10_16:
	mov	x0, x19
	ldp	x29, x30, [sp, #96]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #80]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #64]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #48]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #112
	ret
LBB10_17:
	bl	__ZNSt3__112basic_stringIcNS_11char_traitsIcEENS_9allocatorIcEEE20__throw_length_errorB9nqe210106Ev
LBB10_18:
Ltmp174:
	mov	x19, x0
	ldrsb	w8, [sp, #31]
	tbz	w8, #31, LBB10_20
; %bb.19:
	ldr	x0, [sp, #8]
	bl	__ZdlPv
LBB10_20:
	mov	x0, x19
	bl	__Unwind_Resume
Lfunc_end4:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table10:
Lexception4:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end4-Lcst_begin4
Lcst_begin4:
	.uleb128 Lfunc_begin4-Lfunc_begin4      ; >> Call Site 1 <<
	.uleb128 Ltmp172-Lfunc_begin4           ;   Call between Lfunc_begin4 and Ltmp172
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp172-Lfunc_begin4           ; >> Call Site 2 <<
	.uleb128 Ltmp173-Ltmp172                ;   Call between Ltmp172 and Ltmp173
	.uleb128 Ltmp174-Lfunc_begin4           ;     jumps to Ltmp174
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp173-Lfunc_begin4           ; >> Call Site 3 <<
	.uleb128 Lfunc_end4-Ltmp173             ;   Call between Ltmp173 and Lfunc_end4
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
Lloh74:
	adrp	x0, l_.str.10@PAGE
Lloh75:
	add	x0, x0, l_.str.10@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh74, Lloh75
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
Lloh76:
	adrp	x0, l_.str.9@PAGE
Lloh77:
	add	x0, x0, l_.str.9@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh76, Lloh77
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
Lloh78:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh79:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh80:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh81:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	bl	___cxa_throw
	.loh AdrpLdrGot	Lloh80, Lloh81
	.loh AdrpLdrGot	Lloh78, Lloh79
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"ARM comparison failed"

	.globl	_sink                           ; @sink
.zerofill __DATA,__common,_sink,4,2
	.section	__DATA,__const
	.p2align	3, 0x0                          ; @__const.main.f
l___const.main.f:
	.quad	__Z3dotILi1EEfPKfS1_m
	.quad	__Z3dotILi4EEfPKfS1_m
	.quad	__Z3dotILi16EEfPKfS1_m

	.section	__TEXT,__cstring,cstring_literals
l_.str.1:                               ; @.str.1
	.asciz	"PASS comparisons="

l_.str.2:                               ; @.str.2
	.asciz	" max_abs_error="

	.section	__TEXT,__const
	.p2align	3, 0x0                          ; @constinit
l_constinit:
	.quad	7                               ; 0x7
	.quad	4096                            ; 0x1000
	.quad	65539                           ; 0x10003

	.section	__TEXT,__cstring,cstring_literals
l_.str.3:                               ; @.str.3
	.asciz	"PASS benchmark_shape="

l_.str.4:                               ; @.str.4
	.asciz	" candidates=3"

l_.str.5:                               ; @.str.5
	.asciz	"N="

l_.str.6:                               ; @.str.6
	.asciz	" accumulators="

l_.str.7:                               ; @.str.7
	.asciz	" CPU_batch_mean_p50_us="

l_.str.8:                               ; @.str.8
	.asciz	" p95_us="

l_.str.9:                               ; @.str.9
	.asciz	"vector"

l_.str.10:                              ; @.str.10
	.asciz	"basic_string"

.subsections_via_symbols
