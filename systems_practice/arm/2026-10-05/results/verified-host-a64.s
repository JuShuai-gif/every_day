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
	.globl	__Z6scalarPKDhS0_m              ; -- Begin function _Z6scalarPKDhS0_m
	.p2align	2
__Z6scalarPKDhS0_m:                     ; @_Z6scalarPKDhS0_m
	.cfi_startproc
; %bb.0:
	movi.2d	v0, #0000000000000000
	cbz	x2, LBB1_2
LBB1_1:                                 ; =>This Inner Loop Header: Depth=1
	ldr	h1, [x0], #2
	fcvt	s1, h1
	ldr	h2, [x1], #2
	fcvt	s2, h2
	fmadd	s0, s1, s2, s0
	subs	x2, x2, #1
	b.ne	LBB1_1
LBB1_2:
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__Z7widenedPKDhS0_m             ; -- Begin function _Z7widenedPKDhS0_m
	.p2align	2
__Z7widenedPKDhS0_m:                    ; @_Z7widenedPKDhS0_m
	.cfi_startproc
; %bb.0:
	cmp	x2, #4
	b.hs	LBB2_2
; %bb.1:
	mov	x10, #0                         ; =0x0
	movi.2d	v0, #0000000000000000
	b	LBB2_4
LBB2_2:
	mov	x9, #0                          ; =0x0
	movi.2d	v0, #0000000000000000
	mov	x8, x1
	mov	x11, x0
LBB2_3:                                 ; =>This Inner Loop Header: Depth=1
	ldr	d1, [x11], #8
	fcvtl	v1.4s, v1.4h
	ldr	d2, [x8], #8
	fcvtl	v2.4s, v2.4h
	fmla.4s	v0, v2, v1
	add	x10, x9, #4
	add	x12, x9, #8
	mov	x9, x10
	cmp	x12, x2
	b.ls	LBB2_3
LBB2_4:
	faddp.4s	v0, v0, v0
	faddp.2s	s0, v0
	subs	x8, x2, x10
	b.ls	LBB2_7
; %bb.5:
	lsl	x10, x10, #1
	add	x9, x1, x10
	add	x10, x0, x10
LBB2_6:                                 ; =>This Inner Loop Header: Depth=1
	ldr	h1, [x10], #2
	fcvt	s1, h1
	ldr	h2, [x9], #2
	fcvt	s2, h2
	fmadd	s0, s1, s2, s0
	subs	x8, x8, #1
	b.ne	LBB2_6
LBB2_7:
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__Z6narrowPKDhS0_m              ; -- Begin function _Z6narrowPKDhS0_m
	.p2align	2
__Z6narrowPKDhS0_m:                     ; @_Z6narrowPKDhS0_m
	.cfi_startproc
; %bb.0:
	cmp	x2, #8
	b.hs	LBB3_2
; %bb.1:
	mov	x8, #0                          ; =0x0
	movi.2d	v0, #0000000000000000
	b	LBB3_4
LBB3_2:
	mov	x10, #0                         ; =0x0
	movi.2d	v0, #0000000000000000
	mov	x9, x1
	mov	x11, x0
LBB3_3:                                 ; =>This Inner Loop Header: Depth=1
	ldr	q1, [x11], #16
	ldr	q2, [x9], #16
	fmla.8h	v0, v2, v1
	add	x8, x10, #8
	add	x12, x10, #16
	mov	x10, x8
	cmp	x12, x2
	b.ls	LBB3_3
LBB3_4:
	fcvt	s1, h0
	movi.2d	v2, #0000000000000000
	fadd	s1, s1, s2
	mov	h2, v0[1]
	fcvt	s2, h2
	fadd	s1, s1, s2
	mov	h2, v0[2]
	fcvt	s2, h2
	fadd	s1, s1, s2
	mov	h2, v0[3]
	fcvt	s2, h2
	fadd	s1, s1, s2
	mov	h2, v0[4]
	fcvt	s2, h2
	fadd	s1, s1, s2
	mov	h2, v0[5]
	fcvt	s2, h2
	fadd	s1, s1, s2
	mov	h2, v0[6]
	fcvt	s2, h2
	fadd	s1, s1, s2
	mov	h0, v0[7]
	fcvt	s0, h0
	fadd	s0, s1, s0
	subs	x9, x2, x8
	b.ls	LBB3_7
; %bb.5:
	lsl	x10, x8, #1
	add	x8, x1, x10
	add	x10, x0, x10
LBB3_6:                                 ; =>This Inner Loop Header: Depth=1
	ldr	h1, [x10], #2
	fcvt	s1, h1
	ldr	h2, [x8], #2
	fcvt	s2, h2
	fmadd	s0, s1, s2, s0
	subs	x9, x9, #1
	b.ne	LBB3_6
LBB3_7:
	ret
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__literal8,8byte_literals
	.p2align	3, 0x0                          ; -- Begin function main
lCPI4_0:
	.long	17                              ; 0x11
	.long	4096                            ; 0x1000
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_main
	.p2align	2
_main:                                  ; @main
Lfunc_begin1:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception1
; %bb.0:
	sub	sp, sp, #224
	stp	d11, d10, [sp, #96]             ; 16-byte Folded Spill
	stp	d9, d8, [sp, #112]              ; 16-byte Folded Spill
	stp	x28, x27, [sp, #128]            ; 16-byte Folded Spill
	stp	x26, x25, [sp, #144]            ; 16-byte Folded Spill
	stp	x24, x23, [sp, #160]            ; 16-byte Folded Spill
	stp	x22, x21, [sp, #176]            ; 16-byte Folded Spill
	stp	x20, x19, [sp, #192]            ; 16-byte Folded Spill
	stp	x29, x30, [sp, #208]            ; 16-byte Folded Spill
	add	x29, sp, #208
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
Lloh2:
	adrp	x8, ___stack_chk_guard@GOTPAGE
Lloh3:
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
Lloh4:
	ldr	x8, [x8]
	str	x8, [sp, #88]
Ltmp3:
Lloh5:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh6:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh7:
	adrp	x1, l_.str.1@PAGE
Lloh8:
	add	x1, x1, l_.str.1@PAGEOFF
	mov	w2, #11                         ; =0xb
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp4:
; %bb.1:
Ltmp5:
	mov	w1, #2                          ; =0x2
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp6:
; %bb.2:
Ltmp7:
Lloh9:
	adrp	x1, l_.str.2@PAGE
Lloh10:
	add	x1, x1, l_.str.2@PAGEOFF
	mov	w2, #13                         ; =0xd
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp8:
; %bb.3:
Ltmp9:
	mov	w1, #1                          ; =0x1
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEi
Ltmp10:
; %bb.4:
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #16]
Ltmp11:
	add	x1, sp, #16
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp12:
; %bb.5:
	mov	x20, #0                         ; =0x0
	mov	x23, #17197                     ; =0x432d
	movk	x23, #60188, lsl #16
	movk	x23, #14050, lsl #32
	movk	x23, #16154, lsl #48
	mov	x24, #20165                     ; =0x4ec5
	movk	x24, #50412, lsl #16
	movk	x24, #60494, lsl #32
	movk	x24, #20164, lsl #48
	mov	w25, #-13                       ; =0xfffffff3
	mov	x26, #17247                     ; =0x435f
	movk	x26, #3449, lsl #16
	movk	x26, #13797, lsl #32
	movk	x26, #55188, lsl #48
	mov	w27, #-19                       ; =0xffffffed
	b	LBB4_7
LBB4_6:                                 ;   in Loop: Header=BB4_7 Depth=1
	add	x20, x20, #1
	cmp	x20, #1026
	b.eq	LBB4_19
LBB4_7:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB4_11 Depth 2
	cbz	x20, LBB4_12
; %bb.8:                                ;   in Loop: Header=BB4_7 Depth=1
	lsl	x22, x20, #1
Ltmp14:
	mov	x0, x22
	bl	__Znwm
Ltmp15:
; %bb.9:                                ;   in Loop: Header=BB4_7 Depth=1
	mov	x19, x0
	mov	x1, x22
	bl	_bzero
Ltmp17:
	mov	x0, x22
	bl	__Znwm
Ltmp18:
; %bb.10:                               ;   in Loop: Header=BB4_7 Depth=1
	mov	x21, x0
	mov	x1, x22
	bl	_bzero
	mov	x8, #0                          ; =0x0
	movi.2d	v8, #0000000000000000
LBB4_11:                                ;   Parent Loop BB4_7 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	umulh	x9, x8, x24
	lsr	x9, x9, #2
	madd	w9, w9, w25, w8
	umulh	x10, x8, x26
	lsr	x10, x10, #4
	madd	w10, w10, w27, w8
	sub	w10, w10, #9
	scvtf	s0, w10, #4
	fcvt	h0, s0
	str	h0, [x19, x8, lsl #1]
	sub	w9, w9, #6
	scvtf	s1, w9, #3
	fcvt	h1, s1
	str	h1, [x21, x8, lsl #1]
	fcvt	d0, h0
	fcvt	d1, h1
	fmadd	d8, d0, d1, d8
	add	x8, x8, #1
	cmp	x20, x8
	b.ne	LBB4_11
	b	LBB4_13
LBB4_12:                                ;   in Loop: Header=BB4_7 Depth=1
	mov	x21, #0                         ; =0x0
	mov	x19, #0                         ; =0x0
	movi.2d	v8, #0000000000000000
LBB4_13:                                ;   in Loop: Header=BB4_7 Depth=1
	mov	x0, x19
	mov	x1, x21
	mov	x2, x20
	bl	__Z6scalarPKDhS0_m
	fcvt	d0, s0
	fabd	d0, d0, d8
	fmov	d1, x23
	fcmp	d0, d1
	b.pl	LBB4_94
; %bb.14:                               ;   in Loop: Header=BB4_7 Depth=1
	mov	x0, x19
	mov	x1, x21
	mov	x2, x20
	bl	__Z7widenedPKDhS0_m
	fcvt	d0, s0
	fabd	d0, d0, d8
	fmov	d1, x23
	fcmp	d0, d1
	b.pl	LBB4_95
; %bb.15:                               ;   in Loop: Header=BB4_7 Depth=1
	cbz	x21, LBB4_17
; %bb.16:                               ;   in Loop: Header=BB4_7 Depth=1
	mov	x0, x21
	bl	__ZdlPv
LBB4_17:                                ;   in Loop: Header=BB4_7 Depth=1
	cbz	x19, LBB4_6
; %bb.18:                               ;   in Loop: Header=BB4_7 Depth=1
	mov	x0, x19
	bl	__ZdlPv
	b	LBB4_6
LBB4_19:
	mov	w8, #47104                      ; =0xb800
	movk	w8, #18312, lsl #16
	str	w8, [sp, #68]
	ldr	s0, [sp, #68]
	fcvt	h0, s0
	fcvt	s8, h0
	fmov	w8, s8
	and	w8, w8, #0x7fffffff
	mov	w9, #2139095040                 ; =0x7f800000
	cmp	w8, w9
	b.ne	LBB4_97
; %bb.20:
	mov	w8, #4096                       ; =0x1000
	movk	w8, #16256, lsl #16
	str	w8, [sp, #64]
	ldr	s0, [sp, #64]
	fcvt	h9, s0
	fmov	h0, #1.00000000
	fcmp	h9, h0
	b.ne	LBB4_99
; %bb.21:
Ltmp41:
	mov	w0, #128                        ; =0x80
	bl	__Znwm
Ltmp42:
; %bb.22:
	mov	x19, x0
	add	x20, x0, #128
	str	x0, [sp, #40]
	str	x20, [sp, #56]
Lloh11:
	adrp	x1, l_.memset_pattern@PAGE
Lloh12:
	add	x1, x1, l_.memset_pattern@PAGEOFF
	mov	w2, #128                        ; =0x80
	bl	_memset_pattern16
	str	x20, [sp, #48]
Ltmp44:
	mov	w0, #128                        ; =0x80
	bl	__Znwm
Ltmp45:
; %bb.23:
	mov	x20, x0
	add	x21, x0, #128
	str	x0, [sp, #16]
	str	x21, [sp, #32]
Lloh13:
	adrp	x1, l_.memset_pattern@PAGE
Lloh14:
	add	x1, x1, l_.memset_pattern@PAGEOFF
	mov	w2, #128                        ; =0x80
	bl	_memset_pattern16
	str	x21, [sp, #24]
	mov	x0, x19
	mov	x1, x20
	mov	w2, #64                         ; =0x40
	bl	__Z7widenedPKDhS0_m
	mov	w8, #51200                      ; =0xc800
	movk	w8, #19119, lsl #16
	fmov	s1, w8
	fcmp	s0, s1
	b.ne	LBB4_101
; %bb.24:
Ltmp52:
Lloh15:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh16:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh17:
	adrp	x1, l_.str.3@PAGE
Lloh18:
	add	x1, x1, l_.str.3@PAGEOFF
	mov	w2, #11                         ; =0xb
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp53:
; %bb.25:
Ltmp54:
	mov	w1, #1026                       ; =0x402
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp55:
; %bb.26:
Ltmp56:
Lloh19:
	adrp	x1, l_.str.4@PAGE
Lloh20:
	add	x1, x1, l_.str.4@PAGEOFF
	mov	w2, #5                          ; =0x5
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp57:
; %bb.27:
Ltmp58:
	fcvt	s0, h9
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEf
Ltmp59:
; %bb.28:
Ltmp60:
Lloh21:
	adrp	x1, l_.str.5@PAGE
Lloh22:
	add	x1, x1, l_.str.5@PAGEOFF
	mov	w2, #18                         ; =0x12
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp61:
; %bb.29:
Ltmp62:
	mov.16b	v0, v8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEf
Ltmp63:
; %bb.30:
Ltmp64:
Lloh23:
	adrp	x1, l_.str.6@PAGE
Lloh24:
	add	x1, x1, l_.str.6@PAGEOFF
	mov	w2, #10                         ; =0xa
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp65:
; %bb.31:
Ltmp66:
	mov	w8, #51200                      ; =0xc800
	movk	w8, #19119, lsl #16
	fmov	s0, w8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEf
Ltmp67:
; %bb.32:
	ldr	x0, [sp, #40]
	ldr	x1, [sp, #16]
	mov	w2, #64                         ; =0x40
	bl	__Z6narrowPKDhS0_m
	mov.16b	v8, v0
	fmov	w8, s8
	and	w8, w8, #0x7fffffff
	mov	w9, #2139095040                 ; =0x7f800000
	cmp	w8, w9
	b.ne	LBB4_103
; %bb.33:
Ltmp74:
Lloh25:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh26:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh27:
	adrp	x1, l_.str.7@PAGE
Lloh28:
	add	x1, x1, l_.str.7@PAGEOFF
	mov	w2, #12                         ; =0xc
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp75:
; %bb.34:
Ltmp76:
	mov.16b	v0, v8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEf
Ltmp77:
; %bb.35:
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #72]
Ltmp78:
Lloh29:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh30:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
	add	x1, sp, #72
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp79:
; %bb.36:
	mov	x19, #0                         ; =0x0
Lloh31:
	adrp	x8, lCPI4_0@PAGE
Lloh32:
	ldr	d0, [x8, lCPI4_0@PAGEOFF]
	str	d0, [sp, #72]
	mov	w8, #3                          ; =0x3
	movk	w8, #1, lsl #16
	str	w8, [sp, #80]
	adrp	x22, _sink@PAGE
	fmov	h8, #0.25000000
	fmov	h9, #0.12500000
LBB4_37:                                ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB4_42 Depth 2
                                        ;       Child Loop BB4_43 Depth 3
                                        ;     Child Loop BB4_65 Depth 2
                                        ;       Child Loop BB4_66 Depth 3
	add	x8, sp, #72
	ldr	w25, [x8, x19]
	str	h8, [sp, #14]
Ltmp81:
	add	x0, sp, #40
	add	x2, sp, #14
	mov	x1, x25
	bl	__ZNSt3__16vectorIDhNS_9allocatorIDhEEE6assignEmRKDh
Ltmp82:
; %bb.38:                               ;   in Loop: Header=BB4_37 Depth=1
	str	x19, [sp]                       ; 8-byte Folded Spill
	str	h9, [sp, #14]
Ltmp84:
	add	x0, sp, #16
	add	x2, sp, #14
	mov	x1, x25
	bl	__ZNSt3__16vectorIDhNS_9allocatorIDhEEE6assignEmRKDh
Ltmp85:
; %bb.39:                               ;   in Loop: Header=BB4_37 Depth=1
	mov	x23, #0                         ; =0x0
	mov	x26, #0                         ; =0x0
	mov	x19, #0                         ; =0x0
	mov	w21, #-5                        ; =0xfffffffb
	b	LBB4_42
LBB4_40:                                ;   in Loop: Header=BB4_42 Depth=2
	str	d10, [x26], #8
LBB4_41:                                ;   in Loop: Header=BB4_42 Depth=2
	add	w21, w21, #1
	cmp	w21, #41
	b.eq	LBB4_52
LBB4_42:                                ;   Parent Loop BB4_37 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB4_43 Depth 3
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x27, x0
	ldr	x28, [sp, #40]
	mov	w24, #100                       ; =0x64
	ldr	x20, [sp, #16]
LBB4_43:                                ;   Parent Loop BB4_37 Depth=1
                                        ;     Parent Loop BB4_42 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	mov	x0, x28
	mov	x1, x20
	mov	x2, x25
	bl	__Z6scalarPKDhS0_m
	str	s0, [x22, _sink@PAGEOFF]
	subs	w24, w24, #1
	b.ne	LBB4_43
; %bb.44:                               ;   in Loop: Header=BB4_42 Depth=2
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	tbnz	w21, #31, LBB4_41
; %bb.45:                               ;   in Loop: Header=BB4_42 Depth=2
	sub	x8, x0, x27
	scvtf	d0, x8
	mov	x8, #70368744177664             ; =0x400000000000
	movk	x8, #16527, lsl #48
	fmov	d1, x8
	fdiv	d0, d0, d1
	mov	x8, #4636737291354636288        ; =0x4059000000000000
	fmov	d1, x8
	fdiv	d10, d0, d1
	cmp	x26, x23
	b.lo	LBB4_40
; %bb.46:                               ;   in Loop: Header=BB4_42 Depth=2
	sub	x27, x26, x19
	asr	x20, x27, #3
	add	x8, x20, #1
	lsr	x9, x8, #61
	cbnz	x9, LBB4_93
; %bb.47:                               ;   in Loop: Header=BB4_42 Depth=2
	sub	x9, x23, x19
	asr	x10, x9, #2
	cmp	x10, x8
	csel	x8, x10, x8, hi
	mov	x10, #9223372036854775800       ; =0x7ffffffffffffff8
	cmp	x9, x10
	mov	x9, #2305843009213693951        ; =0x1fffffffffffffff
	csel	x23, x8, x9, lo
	lsr	x8, x23, #61
	cbnz	x8, LBB4_92
; %bb.48:                               ;   in Loop: Header=BB4_42 Depth=2
	lsl	x0, x23, #3
Ltmp87:
	bl	__Znwm
Ltmp88:
; %bb.49:                               ;   in Loop: Header=BB4_42 Depth=2
	add	x26, x0, x27
	add	x23, x0, x23, lsl #3
	sub	x20, x26, x20, lsl #3
	str	d10, [x26], #8
	mov	x0, x20
	mov	x1, x19
	mov	x2, x27
	bl	_memcpy
	cbz	x19, LBB4_51
; %bb.50:                               ;   in Loop: Header=BB4_42 Depth=2
	mov	x0, x19
	bl	__ZdlPv
LBB4_51:                                ;   in Loop: Header=BB4_42 Depth=2
	mov	x19, x20
	b	LBB4_41
LBB4_52:                                ;   in Loop: Header=BB4_37 Depth=1
Ltmp90:
	add	x2, sp, #14
	mov	x0, x19
	mov	x1, x26
	bl	__ZNSt3__16__sortIRNS_6__lessIddEEPdEEvT0_S5_T_
Ltmp91:
; %bb.53:                               ;   in Loop: Header=BB4_37 Depth=1
Ltmp92:
Lloh33:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh34:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh35:
	adrp	x1, l_.str.8@PAGE
Lloh36:
	add	x1, x1, l_.str.8@PAGEOFF
	mov	w2, #2                          ; =0x2
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp93:
; %bb.54:                               ;   in Loop: Header=BB4_37 Depth=1
Ltmp94:
	mov	x1, x25
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp95:
; %bb.55:                               ;   in Loop: Header=BB4_37 Depth=1
Ltmp96:
Lloh37:
	adrp	x1, l_.str.9@PAGE
Lloh38:
	add	x1, x1, l_.str.9@PAGEOFF
	mov	w2, #6                          ; =0x6
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp97:
; %bb.56:                               ;   in Loop: Header=BB4_37 Depth=1
Ltmp98:
	mov	w1, #0                          ; =0x0
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEi
Ltmp99:
; %bb.57:                               ;   in Loop: Header=BB4_37 Depth=1
Ltmp100:
Lloh39:
	adrp	x1, l_.str.10@PAGE
Lloh40:
	add	x1, x1, l_.str.10@PAGEOFF
	mov	w2, #22                         ; =0x16
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp101:
; %bb.58:                               ;   in Loop: Header=BB4_37 Depth=1
	ldr	d0, [x19, #160]
Ltmp102:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp103:
; %bb.59:                               ;   in Loop: Header=BB4_37 Depth=1
Ltmp104:
Lloh41:
	adrp	x1, l_.str.11@PAGE
Lloh42:
	add	x1, x1, l_.str.11@PAGEOFF
	mov	w2, #5                          ; =0x5
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp105:
; %bb.60:                               ;   in Loop: Header=BB4_37 Depth=1
	ldr	d0, [x19, #304]
Ltmp106:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp107:
; %bb.61:                               ;   in Loop: Header=BB4_37 Depth=1
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #14]
Ltmp108:
	add	x1, sp, #14
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp109:
; %bb.62:                               ;   in Loop: Header=BB4_37 Depth=1
	mov	x0, x19
	bl	__ZdlPv
	mov	x23, #0                         ; =0x0
	mov	x26, #0                         ; =0x0
	mov	x19, #0                         ; =0x0
	mov	w21, #-5                        ; =0xfffffffb
	b	LBB4_65
LBB4_63:                                ;   in Loop: Header=BB4_65 Depth=2
	str	d10, [x26], #8
LBB4_64:                                ;   in Loop: Header=BB4_65 Depth=2
	add	w21, w21, #1
	cmp	w21, #41
	b.eq	LBB4_75
LBB4_65:                                ;   Parent Loop BB4_37 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB4_66 Depth 3
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x27, x0
	ldr	x28, [sp, #40]
	mov	w24, #100                       ; =0x64
	ldr	x20, [sp, #16]
LBB4_66:                                ;   Parent Loop BB4_37 Depth=1
                                        ;     Parent Loop BB4_65 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	mov	x0, x28
	mov	x1, x20
	mov	x2, x25
	bl	__Z7widenedPKDhS0_m
	str	s0, [x22, _sink@PAGEOFF]
	subs	w24, w24, #1
	b.ne	LBB4_66
; %bb.67:                               ;   in Loop: Header=BB4_65 Depth=2
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	tbnz	w21, #31, LBB4_64
; %bb.68:                               ;   in Loop: Header=BB4_65 Depth=2
	sub	x8, x0, x27
	scvtf	d0, x8
	mov	x8, #70368744177664             ; =0x400000000000
	movk	x8, #16527, lsl #48
	fmov	d1, x8
	fdiv	d0, d0, d1
	mov	x8, #4636737291354636288        ; =0x4059000000000000
	fmov	d1, x8
	fdiv	d10, d0, d1
	cmp	x26, x23
	b.lo	LBB4_63
; %bb.69:                               ;   in Loop: Header=BB4_65 Depth=2
	sub	x27, x26, x19
	asr	x20, x27, #3
	add	x8, x20, #1
	lsr	x9, x8, #61
	cbnz	x9, LBB4_93
; %bb.70:                               ;   in Loop: Header=BB4_65 Depth=2
	sub	x9, x23, x19
	asr	x10, x9, #2
	cmp	x10, x8
	csel	x8, x10, x8, hi
	mov	x10, #9223372036854775800       ; =0x7ffffffffffffff8
	cmp	x9, x10
	mov	x9, #2305843009213693951        ; =0x1fffffffffffffff
	csel	x23, x8, x9, lo
	lsr	x8, x23, #61
	cbnz	x8, LBB4_92
; %bb.71:                               ;   in Loop: Header=BB4_65 Depth=2
	lsl	x0, x23, #3
Ltmp110:
	bl	__Znwm
Ltmp111:
; %bb.72:                               ;   in Loop: Header=BB4_65 Depth=2
	add	x26, x0, x27
	add	x23, x0, x23, lsl #3
	sub	x20, x26, x20, lsl #3
	str	d10, [x26], #8
	mov	x0, x20
	mov	x1, x19
	mov	x2, x27
	bl	_memcpy
	cbz	x19, LBB4_74
; %bb.73:                               ;   in Loop: Header=BB4_65 Depth=2
	mov	x0, x19
	bl	__ZdlPv
LBB4_74:                                ;   in Loop: Header=BB4_65 Depth=2
	mov	x19, x20
	b	LBB4_64
LBB4_75:                                ;   in Loop: Header=BB4_37 Depth=1
Ltmp118:
	add	x2, sp, #14
	mov	x0, x19
	mov	x1, x26
	bl	__ZNSt3__16__sortIRNS_6__lessIddEEPdEEvT0_S5_T_
Ltmp119:
; %bb.76:                               ;   in Loop: Header=BB4_37 Depth=1
Ltmp120:
Lloh43:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh44:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh45:
	adrp	x1, l_.str.8@PAGE
Lloh46:
	add	x1, x1, l_.str.8@PAGEOFF
	mov	w2, #2                          ; =0x2
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp121:
; %bb.77:                               ;   in Loop: Header=BB4_37 Depth=1
Ltmp122:
	mov	x1, x25
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp123:
; %bb.78:                               ;   in Loop: Header=BB4_37 Depth=1
Ltmp124:
Lloh47:
	adrp	x1, l_.str.9@PAGE
Lloh48:
	add	x1, x1, l_.str.9@PAGEOFF
	mov	w2, #6                          ; =0x6
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp125:
; %bb.79:                               ;   in Loop: Header=BB4_37 Depth=1
Ltmp126:
	mov	w1, #1                          ; =0x1
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEi
Ltmp127:
; %bb.80:                               ;   in Loop: Header=BB4_37 Depth=1
Ltmp128:
Lloh49:
	adrp	x1, l_.str.10@PAGE
Lloh50:
	add	x1, x1, l_.str.10@PAGEOFF
	mov	w2, #22                         ; =0x16
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp129:
; %bb.81:                               ;   in Loop: Header=BB4_37 Depth=1
	ldr	d0, [x19, #160]
Ltmp130:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp131:
; %bb.82:                               ;   in Loop: Header=BB4_37 Depth=1
Ltmp132:
Lloh51:
	adrp	x1, l_.str.11@PAGE
Lloh52:
	add	x1, x1, l_.str.11@PAGEOFF
	mov	w2, #5                          ; =0x5
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp133:
; %bb.83:                               ;   in Loop: Header=BB4_37 Depth=1
	ldr	d0, [x19, #304]
Ltmp134:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp135:
; %bb.84:                               ;   in Loop: Header=BB4_37 Depth=1
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #14]
Ltmp136:
	add	x1, sp, #14
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp137:
; %bb.85:                               ;   in Loop: Header=BB4_37 Depth=1
	mov	x0, x19
	bl	__ZdlPv
	ldr	x19, [sp]                       ; 8-byte Folded Reload
	add	x19, x19, #4
	cmp	x19, #12
	b.ne	LBB4_37
; %bb.86:
	ldr	x0, [sp, #16]
	cbz	x0, LBB4_88
; %bb.87:
	str	x0, [sp, #24]
	bl	__ZdlPv
LBB4_88:
	ldr	x0, [sp, #40]
	cbz	x0, LBB4_90
; %bb.89:
	str	x0, [sp, #48]
	bl	__ZdlPv
LBB4_90:
	mov	w0, #0                          ; =0x0
	ldr	x8, [sp, #88]
Lloh53:
	adrp	x9, ___stack_chk_guard@GOTPAGE
Lloh54:
	ldr	x9, [x9, ___stack_chk_guard@GOTPAGEOFF]
Lloh55:
	ldr	x9, [x9]
	cmp	x9, x8
	b.ne	LBB4_149
LBB4_91:
	ldp	x29, x30, [sp, #208]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #192]            ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #176]            ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #160]            ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #144]            ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #128]            ; 16-byte Folded Reload
	ldp	d9, d8, [sp, #112]              ; 16-byte Folded Reload
	ldp	d11, d10, [sp, #96]             ; 16-byte Folded Reload
	add	sp, sp, #224
	ret
LBB4_92:
Ltmp113:
	bl	__ZSt28__throw_bad_array_new_lengthB9nqe210106v
Ltmp114:
	b	LBB4_105
LBB4_93:
Ltmp115:
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_length_errorB9nqe210106Ev
Ltmp116:
	b	LBB4_105
LBB4_94:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x22, x0
Ltmp20:
Lloh56:
	adrp	x1, l_.str@PAGE
Lloh57:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp21:
	b	LBB4_96
LBB4_95:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x22, x0
Ltmp23:
Lloh58:
	adrp	x1, l_.str@PAGE
Lloh59:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp24:
LBB4_96:
Ltmp26:
Lloh60:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh61:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh62:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh63:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x22
	bl	___cxa_throw
Ltmp27:
	b	LBB4_105
LBB4_97:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp29:
Lloh64:
	adrp	x1, l_.str@PAGE
Lloh65:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp30:
; %bb.98:
Ltmp32:
Lloh66:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh67:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh68:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh69:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
Ltmp33:
	b	LBB4_105
LBB4_99:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp35:
Lloh70:
	adrp	x1, l_.str@PAGE
Lloh71:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp36:
; %bb.100:
Ltmp38:
Lloh72:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh73:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh74:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh75:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
Ltmp39:
	b	LBB4_105
LBB4_101:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp47:
Lloh76:
	adrp	x1, l_.str@PAGE
Lloh77:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp48:
; %bb.102:
Ltmp50:
Lloh78:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh79:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh80:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh81:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
Ltmp51:
	b	LBB4_105
LBB4_103:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp69:
Lloh82:
	adrp	x1, l_.str@PAGE
Lloh83:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp70:
; %bb.104:
Ltmp72:
Lloh84:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh85:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh86:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh87:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
Ltmp73:
LBB4_105:
	brk	#0x1
LBB4_106:
Ltmp71:
	b	LBB4_108
LBB4_107:
Ltmp49:
LBB4_108:
	mov	x21, x1
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	b	LBB4_139
LBB4_109:
Ltmp40:
	b	LBB4_116
LBB4_110:
Ltmp37:
	b	LBB4_113
LBB4_111:
Ltmp34:
	b	LBB4_116
LBB4_112:
Ltmp31:
LBB4_113:
	mov	x21, x1
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	b	LBB4_143
LBB4_114:
Ltmp46:
	mov	x21, x1
	mov	x20, x0
	b	LBB4_141
LBB4_115:
Ltmp43:
LBB4_116:
	mov	x21, x1
	mov	x20, x0
	b	LBB4_143
LBB4_117:
Ltmp80:
	b	LBB4_127
LBB4_118:
Ltmp13:
	mov	x22, x1
	mov	x20, x0
	cbnz	w22, LBB4_144
	b	LBB4_153
LBB4_119:
Ltmp68:
	b	LBB4_127
LBB4_120:
Ltmp25:
	b	LBB4_122
LBB4_121:
Ltmp22:
LBB4_122:
	mov	x23, x1
	mov	x20, x0
	mov	x0, x22
	bl	___cxa_free_exception
	mov	x22, x23
	b	LBB4_129
LBB4_123:
Ltmp16:
	mov	x20, x0
	mov	x22, x1
	b	LBB4_144
LBB4_124:
Ltmp19:
	mov	x20, x0
	mov	x22, x1
	b	LBB4_132
LBB4_125:
Ltmp83:
	b	LBB4_127
LBB4_126:
Ltmp86:
LBB4_127:
	mov	x21, x1
	mov	x20, x0
	b	LBB4_139
LBB4_128:
Ltmp28:
	mov	x20, x0
	mov	x22, x1
LBB4_129:
	cbz	x21, LBB4_131
; %bb.130:
	mov	x0, x21
	bl	__ZdlPv
LBB4_131:
	cbz	x19, LBB4_144
LBB4_132:
	mov	x0, x19
	bl	__ZdlPv
	b	LBB4_144
LBB4_133:
Ltmp112:
	b	LBB4_137
LBB4_134:
Ltmp89:
	b	LBB4_137
LBB4_135:
Ltmp138:
	b	LBB4_137
LBB4_136:
Ltmp117:
LBB4_137:
	mov	x21, x1
	mov	x20, x0
	cbz	x19, LBB4_139
; %bb.138:
	mov	x0, x19
	bl	__ZdlPv
LBB4_139:
	ldr	x0, [sp, #16]
	cbz	x0, LBB4_141
; %bb.140:
	str	x0, [sp, #24]
	bl	__ZdlPv
LBB4_141:
	ldr	x0, [sp, #40]
	cbz	x0, LBB4_143
; %bb.142:
	str	x0, [sp, #48]
	bl	__ZdlPv
LBB4_143:
	mov	x22, x21
LBB4_144:
	cmp	w22, #1
	b.ne	LBB4_153
; %bb.145:
	mov	x0, x20
	bl	___cxa_begin_catch
	ldr	x8, [x0]
	ldr	x8, [x8, #16]
	blr	x8
	mov	x19, x0
	bl	_strlen
	mov	x2, x0
Ltmp139:
Lloh88:
	adrp	x0, __ZNSt3__14cerrE@GOTPAGE
Lloh89:
	ldr	x0, [x0, __ZNSt3__14cerrE@GOTPAGEOFF]
	mov	x1, x19
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp140:
; %bb.146:
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #40]
Ltmp141:
	add	x1, sp, #40
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp142:
; %bb.147:
Ltmp147:
	bl	___cxa_end_catch
Ltmp148:
; %bb.148:
	mov	w0, #1                          ; =0x1
	ldr	x8, [sp, #88]
Lloh90:
	adrp	x9, ___stack_chk_guard@GOTPAGE
Lloh91:
	ldr	x9, [x9, ___stack_chk_guard@GOTPAGEOFF]
Lloh92:
	ldr	x9, [x9]
	cmp	x9, x8
	b.eq	LBB4_91
LBB4_149:
	bl	___stack_chk_fail
LBB4_150:
Ltmp149:
	bl	__Unwind_Resume
LBB4_151:
Ltmp143:
	mov	x20, x0
Ltmp144:
	bl	___cxa_end_catch
Ltmp145:
	b	LBB4_153
LBB4_152:
Ltmp146:
	mov	x20, x0
	cbnz	w1, LBB4_154
LBB4_153:
	mov	x0, x20
	bl	__Unwind_Resume
LBB4_154:
	mov	x0, x20
	bl	___clang_call_terminate
	.loh AdrpAdd	Lloh7, Lloh8
	.loh AdrpLdrGot	Lloh5, Lloh6
	.loh AdrpLdrGotLdr	Lloh2, Lloh3, Lloh4
	.loh AdrpAdd	Lloh9, Lloh10
	.loh AdrpAdd	Lloh11, Lloh12
	.loh AdrpAdd	Lloh13, Lloh14
	.loh AdrpAdd	Lloh17, Lloh18
	.loh AdrpLdrGot	Lloh15, Lloh16
	.loh AdrpAdd	Lloh19, Lloh20
	.loh AdrpAdd	Lloh21, Lloh22
	.loh AdrpAdd	Lloh23, Lloh24
	.loh AdrpAdd	Lloh27, Lloh28
	.loh AdrpLdrGot	Lloh25, Lloh26
	.loh AdrpLdrGot	Lloh29, Lloh30
	.loh AdrpLdr	Lloh31, Lloh32
	.loh AdrpAdd	Lloh35, Lloh36
	.loh AdrpLdrGot	Lloh33, Lloh34
	.loh AdrpAdd	Lloh37, Lloh38
	.loh AdrpAdd	Lloh39, Lloh40
	.loh AdrpAdd	Lloh41, Lloh42
	.loh AdrpAdd	Lloh45, Lloh46
	.loh AdrpLdrGot	Lloh43, Lloh44
	.loh AdrpAdd	Lloh47, Lloh48
	.loh AdrpAdd	Lloh49, Lloh50
	.loh AdrpAdd	Lloh51, Lloh52
	.loh AdrpLdrGotLdr	Lloh53, Lloh54, Lloh55
	.loh AdrpAdd	Lloh56, Lloh57
	.loh AdrpAdd	Lloh58, Lloh59
	.loh AdrpLdrGot	Lloh62, Lloh63
	.loh AdrpLdrGot	Lloh60, Lloh61
	.loh AdrpAdd	Lloh64, Lloh65
	.loh AdrpLdrGot	Lloh68, Lloh69
	.loh AdrpLdrGot	Lloh66, Lloh67
	.loh AdrpAdd	Lloh70, Lloh71
	.loh AdrpLdrGot	Lloh74, Lloh75
	.loh AdrpLdrGot	Lloh72, Lloh73
	.loh AdrpAdd	Lloh76, Lloh77
	.loh AdrpLdrGot	Lloh80, Lloh81
	.loh AdrpLdrGot	Lloh78, Lloh79
	.loh AdrpAdd	Lloh82, Lloh83
	.loh AdrpLdrGot	Lloh86, Lloh87
	.loh AdrpLdrGot	Lloh84, Lloh85
	.loh AdrpLdrGot	Lloh88, Lloh89
	.loh AdrpLdrGotLdr	Lloh90, Lloh91, Lloh92
Lfunc_end1:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table4:
Lexception1:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase0-Lttbaseref0
Lttbaseref0:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end1-Lcst_begin1
Lcst_begin1:
	.uleb128 Ltmp3-Lfunc_begin1             ; >> Call Site 1 <<
	.uleb128 Ltmp12-Ltmp3                   ;   Call between Ltmp3 and Ltmp12
	.uleb128 Ltmp13-Lfunc_begin1            ;     jumps to Ltmp13
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp14-Lfunc_begin1            ; >> Call Site 2 <<
	.uleb128 Ltmp15-Ltmp14                  ;   Call between Ltmp14 and Ltmp15
	.uleb128 Ltmp16-Lfunc_begin1            ;     jumps to Ltmp16
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp15-Lfunc_begin1            ; >> Call Site 3 <<
	.uleb128 Ltmp17-Ltmp15                  ;   Call between Ltmp15 and Ltmp17
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp17-Lfunc_begin1            ; >> Call Site 4 <<
	.uleb128 Ltmp18-Ltmp17                  ;   Call between Ltmp17 and Ltmp18
	.uleb128 Ltmp19-Lfunc_begin1            ;     jumps to Ltmp19
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp18-Lfunc_begin1            ; >> Call Site 5 <<
	.uleb128 Ltmp41-Ltmp18                  ;   Call between Ltmp18 and Ltmp41
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp41-Lfunc_begin1            ; >> Call Site 6 <<
	.uleb128 Ltmp42-Ltmp41                  ;   Call between Ltmp41 and Ltmp42
	.uleb128 Ltmp43-Lfunc_begin1            ;     jumps to Ltmp43
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp44-Lfunc_begin1            ; >> Call Site 7 <<
	.uleb128 Ltmp45-Ltmp44                  ;   Call between Ltmp44 and Ltmp45
	.uleb128 Ltmp46-Lfunc_begin1            ;     jumps to Ltmp46
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp52-Lfunc_begin1            ; >> Call Site 8 <<
	.uleb128 Ltmp67-Ltmp52                  ;   Call between Ltmp52 and Ltmp67
	.uleb128 Ltmp68-Lfunc_begin1            ;     jumps to Ltmp68
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp74-Lfunc_begin1            ; >> Call Site 9 <<
	.uleb128 Ltmp79-Ltmp74                  ;   Call between Ltmp74 and Ltmp79
	.uleb128 Ltmp80-Lfunc_begin1            ;     jumps to Ltmp80
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp81-Lfunc_begin1            ; >> Call Site 10 <<
	.uleb128 Ltmp82-Ltmp81                  ;   Call between Ltmp81 and Ltmp82
	.uleb128 Ltmp83-Lfunc_begin1            ;     jumps to Ltmp83
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp84-Lfunc_begin1            ; >> Call Site 11 <<
	.uleb128 Ltmp85-Ltmp84                  ;   Call between Ltmp84 and Ltmp85
	.uleb128 Ltmp86-Lfunc_begin1            ;     jumps to Ltmp86
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp87-Lfunc_begin1            ; >> Call Site 12 <<
	.uleb128 Ltmp88-Ltmp87                  ;   Call between Ltmp87 and Ltmp88
	.uleb128 Ltmp89-Lfunc_begin1            ;     jumps to Ltmp89
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp88-Lfunc_begin1            ; >> Call Site 13 <<
	.uleb128 Ltmp90-Ltmp88                  ;   Call between Ltmp88 and Ltmp90
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp90-Lfunc_begin1            ; >> Call Site 14 <<
	.uleb128 Ltmp109-Ltmp90                 ;   Call between Ltmp90 and Ltmp109
	.uleb128 Ltmp138-Lfunc_begin1           ;     jumps to Ltmp138
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp110-Lfunc_begin1           ; >> Call Site 15 <<
	.uleb128 Ltmp111-Ltmp110                ;   Call between Ltmp110 and Ltmp111
	.uleb128 Ltmp112-Lfunc_begin1           ;     jumps to Ltmp112
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp111-Lfunc_begin1           ; >> Call Site 16 <<
	.uleb128 Ltmp118-Ltmp111                ;   Call between Ltmp111 and Ltmp118
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp118-Lfunc_begin1           ; >> Call Site 17 <<
	.uleb128 Ltmp137-Ltmp118                ;   Call between Ltmp118 and Ltmp137
	.uleb128 Ltmp138-Lfunc_begin1           ;     jumps to Ltmp138
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp113-Lfunc_begin1           ; >> Call Site 18 <<
	.uleb128 Ltmp116-Ltmp113                ;   Call between Ltmp113 and Ltmp116
	.uleb128 Ltmp117-Lfunc_begin1           ;     jumps to Ltmp117
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp116-Lfunc_begin1           ; >> Call Site 19 <<
	.uleb128 Ltmp20-Ltmp116                 ;   Call between Ltmp116 and Ltmp20
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp20-Lfunc_begin1            ; >> Call Site 20 <<
	.uleb128 Ltmp21-Ltmp20                  ;   Call between Ltmp20 and Ltmp21
	.uleb128 Ltmp22-Lfunc_begin1            ;     jumps to Ltmp22
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp21-Lfunc_begin1            ; >> Call Site 21 <<
	.uleb128 Ltmp23-Ltmp21                  ;   Call between Ltmp21 and Ltmp23
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp23-Lfunc_begin1            ; >> Call Site 22 <<
	.uleb128 Ltmp24-Ltmp23                  ;   Call between Ltmp23 and Ltmp24
	.uleb128 Ltmp25-Lfunc_begin1            ;     jumps to Ltmp25
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp26-Lfunc_begin1            ; >> Call Site 23 <<
	.uleb128 Ltmp27-Ltmp26                  ;   Call between Ltmp26 and Ltmp27
	.uleb128 Ltmp28-Lfunc_begin1            ;     jumps to Ltmp28
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp27-Lfunc_begin1            ; >> Call Site 24 <<
	.uleb128 Ltmp29-Ltmp27                  ;   Call between Ltmp27 and Ltmp29
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp29-Lfunc_begin1            ; >> Call Site 25 <<
	.uleb128 Ltmp30-Ltmp29                  ;   Call between Ltmp29 and Ltmp30
	.uleb128 Ltmp31-Lfunc_begin1            ;     jumps to Ltmp31
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp32-Lfunc_begin1            ; >> Call Site 26 <<
	.uleb128 Ltmp33-Ltmp32                  ;   Call between Ltmp32 and Ltmp33
	.uleb128 Ltmp34-Lfunc_begin1            ;     jumps to Ltmp34
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp33-Lfunc_begin1            ; >> Call Site 27 <<
	.uleb128 Ltmp35-Ltmp33                  ;   Call between Ltmp33 and Ltmp35
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp35-Lfunc_begin1            ; >> Call Site 28 <<
	.uleb128 Ltmp36-Ltmp35                  ;   Call between Ltmp35 and Ltmp36
	.uleb128 Ltmp37-Lfunc_begin1            ;     jumps to Ltmp37
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp38-Lfunc_begin1            ; >> Call Site 29 <<
	.uleb128 Ltmp39-Ltmp38                  ;   Call between Ltmp38 and Ltmp39
	.uleb128 Ltmp40-Lfunc_begin1            ;     jumps to Ltmp40
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp39-Lfunc_begin1            ; >> Call Site 30 <<
	.uleb128 Ltmp47-Ltmp39                  ;   Call between Ltmp39 and Ltmp47
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp47-Lfunc_begin1            ; >> Call Site 31 <<
	.uleb128 Ltmp48-Ltmp47                  ;   Call between Ltmp47 and Ltmp48
	.uleb128 Ltmp49-Lfunc_begin1            ;     jumps to Ltmp49
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp50-Lfunc_begin1            ; >> Call Site 32 <<
	.uleb128 Ltmp51-Ltmp50                  ;   Call between Ltmp50 and Ltmp51
	.uleb128 Ltmp68-Lfunc_begin1            ;     jumps to Ltmp68
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp51-Lfunc_begin1            ; >> Call Site 33 <<
	.uleb128 Ltmp69-Ltmp51                  ;   Call between Ltmp51 and Ltmp69
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp69-Lfunc_begin1            ; >> Call Site 34 <<
	.uleb128 Ltmp70-Ltmp69                  ;   Call between Ltmp69 and Ltmp70
	.uleb128 Ltmp71-Lfunc_begin1            ;     jumps to Ltmp71
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp72-Lfunc_begin1            ; >> Call Site 35 <<
	.uleb128 Ltmp73-Ltmp72                  ;   Call between Ltmp72 and Ltmp73
	.uleb128 Ltmp80-Lfunc_begin1            ;     jumps to Ltmp80
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp73-Lfunc_begin1            ; >> Call Site 36 <<
	.uleb128 Ltmp139-Ltmp73                 ;   Call between Ltmp73 and Ltmp139
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp139-Lfunc_begin1           ; >> Call Site 37 <<
	.uleb128 Ltmp142-Ltmp139                ;   Call between Ltmp139 and Ltmp142
	.uleb128 Ltmp143-Lfunc_begin1           ;     jumps to Ltmp143
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp147-Lfunc_begin1           ; >> Call Site 38 <<
	.uleb128 Ltmp148-Ltmp147                ;   Call between Ltmp147 and Ltmp148
	.uleb128 Ltmp149-Lfunc_begin1           ;     jumps to Ltmp149
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp148-Lfunc_begin1           ; >> Call Site 39 <<
	.uleb128 Ltmp144-Ltmp148                ;   Call between Ltmp148 and Ltmp144
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp144-Lfunc_begin1           ; >> Call Site 40 <<
	.uleb128 Ltmp145-Ltmp144                ;   Call between Ltmp144 and Ltmp145
	.uleb128 Ltmp146-Lfunc_begin1           ;     jumps to Ltmp146
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp145-Lfunc_begin1           ; >> Call Site 41 <<
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
	.byte	123                             ;   Continue to action 2
	.p2align	2, 0x0
                                        ; >> Catch TypeInfos <<
	.long	0                               ; TypeInfo 2
Ltmp178:                                ; TypeInfo 1
	.long	__ZTISt9exception@GOT-Ltmp178
Lttbase0:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.private_extern	__ZNSt3__16vectorIDhNS_9allocatorIDhEEE6assignEmRKDh ; -- Begin function _ZNSt3__16vectorIDhNS_9allocatorIDhEEE6assignEmRKDh
	.globl	__ZNSt3__16vectorIDhNS_9allocatorIDhEEE6assignEmRKDh
	.weak_def_can_be_hidden	__ZNSt3__16vectorIDhNS_9allocatorIDhEEE6assignEmRKDh
	.p2align	2
__ZNSt3__16vectorIDhNS_9allocatorIDhEEE6assignEmRKDh: ; @_ZNSt3__16vectorIDhNS_9allocatorIDhEEE6assignEmRKDh
	.cfi_startproc
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
	mov	x20, x2
	mov	x21, x1
	mov	x19, x0
	ldr	x8, [x0, #16]
	ldr	x9, [x0]
	mov	x0, x9
	sub	x10, x8, x9
	cmp	x1, x10, asr #1
	b.ls	LBB5_8
; %bb.1:
	cbz	x0, LBB5_3
; %bb.2:
	str	x0, [x19, #8]
	bl	__ZdlPv
	mov	x8, #0                          ; =0x0
	stp	xzr, xzr, [x19]
	str	xzr, [x19, #16]
LBB5_3:
	tbnz	x21, #63, LBB5_46
; %bb.4:
	cmp	x8, x21
	csel	x9, x8, x21, hi
	mov	x10, #9223372036854775806       ; =0x7ffffffffffffffe
	mov	x11, #9223372036854775807       ; =0x7fffffffffffffff
	cmp	x8, x10
	csel	x8, x9, x11, lo
	tbnz	x8, #63, LBB5_46
; %bb.5:
	lsl	x22, x8, #1
	mov	x0, x22
	bl	__Znwm
	str	x0, [x19]
	add	x8, x0, x22
	str	x8, [x19, #16]
	lsl	x9, x21, #1
	add	x8, x0, x9
	ldr	h0, [x20]
	sub	x11, x9, #2
	mov	x10, x0
	cmp	x11, #6
	b.lo	LBB5_27
; %bb.6:
	lsr	x9, x11, #1
	add	x9, x9, #1
	cmp	x11, #62
	b.hs	LBB5_12
; %bb.7:
	mov	x11, #0                         ; =0x0
	b	LBB5_16
LBB5_8:
	ldr	x8, [x19, #8]
	sub	x10, x8, x9
	asr	x11, x10, #1
	cmp	x11, x21
	csel	x12, x11, x21, lo
	cbz	x12, LBB5_30
; %bb.9:
	ldr	h0, [x20]
	mov	x13, x12
	cmp	x12, #4
	b.lo	LBB5_29
; %bb.10:
	cmp	x12, #32
	b.hs	LBB5_19
; %bb.11:
	mov	x14, #0                         ; =0x0
	b	LBB5_23
LBB5_12:
	and	x11, x9, #0x7fffffffffffffe0
	dup.8h	v1, v0[0]
	add	x10, x0, #32
	mov	x12, x11
LBB5_13:                                ; =>This Inner Loop Header: Depth=1
	stp	q1, q1, [x10, #-32]
	stp	q1, q1, [x10], #64
	subs	x12, x12, #32
	b.ne	LBB5_13
; %bb.14:
	cmp	x9, x11
	b.eq	LBB5_35
; %bb.15:
	tst	x9, #0x1c
	b.eq	LBB5_26
LBB5_16:
	and	x12, x9, #0x7ffffffffffffffc
	add	x10, x0, x12, lsl #1
	dup.4h	v1, v0[0]
	add	x13, x0, x11, lsl #1
	sub	x11, x11, x12
LBB5_17:                                ; =>This Inner Loop Header: Depth=1
	str	d1, [x13], #8
	adds	x11, x11, #4
	b.ne	LBB5_17
; %bb.18:
	cmp	x9, x12
	b.ne	LBB5_27
	b	LBB5_35
LBB5_19:
	and	x14, x12, #0xffffffffffffffe0
	dup.8h	v1, v0[0]
	add	x13, x9, #32
	mov	x15, x14
LBB5_20:                                ; =>This Inner Loop Header: Depth=1
	stp	q1, q1, [x13, #-32]
	stp	q1, q1, [x13], #64
	subs	x15, x15, #32
	b.ne	LBB5_20
; %bb.21:
	cmp	x12, x14
	b.eq	LBB5_30
; %bb.22:
	tst	x12, #0x1c
	b.eq	LBB5_28
LBB5_23:
	and	x15, x12, #0xfffffffffffffffc
	add	x0, x9, x15, lsl #1
	and	x13, x12, #0x3
	dup.4h	v1, v0[0]
	add	x16, x9, x14, lsl #1
	sub	x14, x14, x15
LBB5_24:                                ; =>This Inner Loop Header: Depth=1
	str	d1, [x16], #8
	adds	x14, x14, #4
	b.ne	LBB5_24
; %bb.25:
	cmp	x12, x15
	b.ne	LBB5_29
	b	LBB5_30
LBB5_26:
	add	x10, x0, x11, lsl #1
LBB5_27:                                ; =>This Inner Loop Header: Depth=1
	str	h0, [x10], #2
	cmp	x10, x8
	b.ne	LBB5_27
	b	LBB5_35
LBB5_28:
	add	x0, x9, x14, lsl #1
	and	x13, x12, #0x1f
LBB5_29:                                ; =>This Inner Loop Header: Depth=1
	str	h0, [x0], #2
	subs	x13, x13, #1
	b.ne	LBB5_29
LBB5_30:
	subs	x11, x21, x11
	b.ls	LBB5_34
; %bb.31:
	add	x9, x8, x11, lsl #1
	ldr	h0, [x20]
	lsl	x11, x21, #1
	sub	x10, x11, x10
	sub	x12, x10, #2
	mov	x11, x8
	cmp	x12, #6
	b.lo	LBB5_44
; %bb.32:
	lsr	x10, x12, #1
	add	x10, x10, #1
	cmp	x12, #62
	b.hs	LBB5_36
; %bb.33:
	mov	x12, #0                         ; =0x0
	b	LBB5_40
LBB5_34:
	add	x8, x9, x21, lsl #1
LBB5_35:
	str	x8, [x19, #8]
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #16]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp], #48             ; 16-byte Folded Reload
	ret
LBB5_36:
	and	x12, x10, #0xffffffffffffffe0
	dup.8h	v1, v0[0]
	add	x11, x8, #32
	mov	x13, x12
LBB5_37:                                ; =>This Inner Loop Header: Depth=1
	stp	q1, q1, [x11, #-32]
	stp	q1, q1, [x11], #64
	subs	x13, x13, #32
	b.ne	LBB5_37
; %bb.38:
	cmp	x10, x12
	b.eq	LBB5_45
; %bb.39:
	tst	x10, #0x1c
	b.eq	LBB5_43
LBB5_40:
	and	x13, x10, #0xfffffffffffffffc
	add	x11, x8, x13, lsl #1
	dup.4h	v1, v0[0]
	add	x8, x8, x12, lsl #1
	sub	x12, x12, x13
LBB5_41:                                ; =>This Inner Loop Header: Depth=1
	str	d1, [x8], #8
	adds	x12, x12, #4
	b.ne	LBB5_41
; %bb.42:
	cmp	x10, x13
	b.ne	LBB5_44
	b	LBB5_45
LBB5_43:
	add	x11, x8, x12, lsl #1
LBB5_44:                                ; =>This Inner Loop Header: Depth=1
	str	h0, [x11], #2
	cmp	x11, x9
	b.ne	LBB5_44
LBB5_45:
	str	x9, [x19, #8]
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #16]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp], #48             ; 16-byte Folded Reload
	ret
LBB5_46:
	bl	__ZNSt3__16vectorIDhNS_9allocatorIDhEEE20__throw_length_errorB9nqe210106Ev
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
	.private_extern	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m ; -- Begin function _ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
	.globl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
	.weak_def_can_be_hidden	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
	.p2align	2
__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m: ; @_ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Lfunc_begin2:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception2
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
	b.ne	LBB7_10
; %bb.2:
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
	add	x4, x19, x8
	ldr	x22, [x4, #40]
	ldr	w24, [x4, #8]
	ldr	w23, [x4, #144]
	cmn	w23, #1
	b.ne	LBB7_7
; %bb.3:
Ltmp153:
	add	x8, sp, #24
	mov	x25, x4
	mov	x0, x4
	bl	__ZNKSt3__18ios_base6getlocEv
Ltmp154:
; %bb.4:
Ltmp155:
Lloh93:
	adrp	x1, __ZNSt3__15ctypeIcE2idE@GOTPAGE
Lloh94:
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
LBB7_7:
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
	cbnz	x0, LBB7_10
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
LBB7_10:
	add	x0, sp, #8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryD1Ev
LBB7_11:
	mov	x0, x19
	ldp	x29, x30, [sp, #96]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #80]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #64]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #48]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #112
	ret
LBB7_12:
Ltmp165:
	b	LBB7_15
LBB7_13:
Ltmp159:
	mov	x20, x0
	add	x0, sp, #24
	bl	__ZNSt3__16localeD1Ev
	b	LBB7_16
LBB7_14:
Ltmp162:
LBB7_15:
	mov	x20, x0
LBB7_16:
	add	x0, sp, #8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryD1Ev
	b	LBB7_18
LBB7_17:
Ltmp152:
	mov	x20, x0
LBB7_18:
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
	b	LBB7_11
LBB7_20:
Ltmp168:
	mov	x19, x0
Ltmp169:
	bl	___cxa_end_catch
Ltmp170:
; %bb.21:
	mov	x0, x19
	bl	__Unwind_Resume
LBB7_22:
Ltmp171:
	bl	___clang_call_terminate
	.loh AdrpLdrGot	Lloh93, Lloh94
Lfunc_end2:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table7:
Lexception2:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase1-Lttbaseref1
Lttbaseref1:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end2-Lcst_begin2
Lcst_begin2:
	.uleb128 Ltmp150-Lfunc_begin2           ; >> Call Site 1 <<
	.uleb128 Ltmp151-Ltmp150                ;   Call between Ltmp150 and Ltmp151
	.uleb128 Ltmp152-Lfunc_begin2           ;     jumps to Ltmp152
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp153-Lfunc_begin2           ; >> Call Site 2 <<
	.uleb128 Ltmp154-Ltmp153                ;   Call between Ltmp153 and Ltmp154
	.uleb128 Ltmp162-Lfunc_begin2           ;     jumps to Ltmp162
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp155-Lfunc_begin2           ; >> Call Site 3 <<
	.uleb128 Ltmp158-Ltmp155                ;   Call between Ltmp155 and Ltmp158
	.uleb128 Ltmp159-Lfunc_begin2           ;     jumps to Ltmp159
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp160-Lfunc_begin2           ; >> Call Site 4 <<
	.uleb128 Ltmp161-Ltmp160                ;   Call between Ltmp160 and Ltmp161
	.uleb128 Ltmp162-Lfunc_begin2           ;     jumps to Ltmp162
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp163-Lfunc_begin2           ; >> Call Site 5 <<
	.uleb128 Ltmp164-Ltmp163                ;   Call between Ltmp163 and Ltmp164
	.uleb128 Ltmp165-Lfunc_begin2           ;     jumps to Ltmp165
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp164-Lfunc_begin2           ; >> Call Site 6 <<
	.uleb128 Ltmp166-Ltmp164                ;   Call between Ltmp164 and Ltmp166
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp166-Lfunc_begin2           ; >> Call Site 7 <<
	.uleb128 Ltmp167-Ltmp166                ;   Call between Ltmp166 and Ltmp167
	.uleb128 Ltmp168-Lfunc_begin2           ;     jumps to Ltmp168
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp167-Lfunc_begin2           ; >> Call Site 8 <<
	.uleb128 Ltmp169-Ltmp167                ;   Call between Ltmp167 and Ltmp169
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp169-Lfunc_begin2           ; >> Call Site 9 <<
	.uleb128 Ltmp170-Ltmp169                ;   Call between Ltmp169 and Ltmp170
	.uleb128 Ltmp171-Lfunc_begin2           ;     jumps to Ltmp171
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp170-Lfunc_begin2           ; >> Call Site 10 <<
	.uleb128 Lfunc_end2-Ltmp170             ;   Call between Ltmp170 and Lfunc_end2
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end2:
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
	mov	x19, x0
	cbz	x0, LBB8_16
; %bb.1:
	mov	x23, x5
	mov	x20, x4
	mov	x22, x3
	mov	x21, x2
	mov	x24, x1
	ldr	x26, [x4, #24]
	sub	x25, x2, x1
	cmp	x25, #1
	b.lt	LBB8_3
; %bb.2:
	ldr	x8, [x19]
	ldr	x8, [x8, #96]
	mov	x0, x19
	mov	x1, x24
	mov	x2, x25
	blr	x8
	cmp	x0, x25
	b.ne	LBB8_15
LBB8_3:
	sub	x8, x22, x24
	cmp	x26, x8
	b.le	LBB8_12
; %bb.4:
	mov	x9, #-9                         ; =0xfffffffffffffff7
	movk	x9, #32767, lsl #48
	sub	x24, x26, x8
	cmp	x24, x9
	b.hs	LBB8_17
; %bb.5:
	cmp	x24, #23
	b.hs	LBB8_7
; %bb.6:
	strb	w24, [sp, #31]
	add	x25, sp, #8
	b	LBB8_8
LBB8_7:
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
LBB8_8:
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
	tbnz	w8, #31, LBB8_11
; %bb.10:
	cmp	x0, x24
	b.ne	LBB8_15
	b	LBB8_12
LBB8_11:
	ldr	x8, [sp, #8]
	mov	x23, x0
	mov	x0, x8
	bl	__ZdlPv
	cmp	x23, x24
	b.ne	LBB8_15
LBB8_12:
	sub	x22, x22, x21
	cmp	x22, #1
	b.lt	LBB8_14
; %bb.13:
	ldr	x8, [x19]
	ldr	x8, [x8, #96]
	mov	x0, x19
	mov	x1, x21
	mov	x2, x22
	blr	x8
	cmp	x0, x22
	b.ne	LBB8_15
LBB8_14:
	str	xzr, [x20, #24]
	b	LBB8_16
LBB8_15:
	mov	x19, #0                         ; =0x0
LBB8_16:
	mov	x0, x19
	ldp	x29, x30, [sp, #96]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #80]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #64]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #48]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #112
	ret
LBB8_17:
	bl	__ZNSt3__112basic_stringIcNS_11char_traitsIcEENS_9allocatorIcEEE20__throw_length_errorB9nqe210106Ev
LBB8_18:
Ltmp174:
	mov	x19, x0
	ldrsb	w8, [sp, #31]
	tbz	w8, #31, LBB8_20
; %bb.19:
	ldr	x0, [sp, #8]
	bl	__ZdlPv
LBB8_20:
	mov	x0, x19
	bl	__Unwind_Resume
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
	.uleb128 Ltmp172-Lfunc_begin3           ;   Call between Lfunc_begin3 and Ltmp172
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp172-Lfunc_begin3           ; >> Call Site 2 <<
	.uleb128 Ltmp173-Ltmp172                ;   Call between Ltmp172 and Ltmp173
	.uleb128 Ltmp174-Lfunc_begin3           ;     jumps to Ltmp174
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp173-Lfunc_begin3           ; >> Call Site 3 <<
	.uleb128 Lfunc_end3-Ltmp173             ;   Call between Ltmp173 and Lfunc_end3
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end3:
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
Lloh95:
	adrp	x0, l_.str.12@PAGE
Lloh96:
	add	x0, x0, l_.str.12@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh95, Lloh96
	.cfi_endproc
                                        ; -- End function
	.private_extern	__ZNSt3__120__throw_length_errorB9nqe210106EPKc ; -- Begin function _ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.globl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.weak_def_can_be_hidden	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.p2align	2
__ZNSt3__120__throw_length_errorB9nqe210106EPKc: ; @_ZNSt3__120__throw_length_errorB9nqe210106EPKc
Lfunc_begin4:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception4
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
Ltmp175:
	mov	x1, x20
	bl	__ZNSt12length_errorC1B9nqe210106EPKc
Ltmp176:
; %bb.1:
Lloh97:
	adrp	x1, __ZTISt12length_error@GOTPAGE
Lloh98:
	ldr	x1, [x1, __ZTISt12length_error@GOTPAGEOFF]
Lloh99:
	adrp	x2, __ZNSt12length_errorD1Ev@GOTPAGE
Lloh100:
	ldr	x2, [x2, __ZNSt12length_errorD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
LBB10_2:
Ltmp177:
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x0, x20
	bl	__Unwind_Resume
	.loh AdrpLdrGot	Lloh99, Lloh100
	.loh AdrpLdrGot	Lloh97, Lloh98
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
	.uleb128 Ltmp175-Lfunc_begin4           ;   Call between Lfunc_begin4 and Ltmp175
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp175-Lfunc_begin4           ; >> Call Site 2 <<
	.uleb128 Ltmp176-Ltmp175                ;   Call between Ltmp175 and Ltmp176
	.uleb128 Ltmp177-Lfunc_begin4           ;     jumps to Ltmp177
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp176-Lfunc_begin4           ; >> Call Site 3 <<
	.uleb128 Lfunc_end4-Ltmp176             ;   Call between Ltmp176 and Lfunc_end4
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end4:
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
Lloh101:
	adrp	x8, __ZTVSt12length_error@GOTPAGE
Lloh102:
	ldr	x8, [x8, __ZTVSt12length_error@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x0]
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
	.loh AdrpLdrGot	Lloh101, Lloh102
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
Lloh103:
	adrp	x1, __ZTISt20bad_array_new_length@GOTPAGE
Lloh104:
	ldr	x1, [x1, __ZTISt20bad_array_new_length@GOTPAGEOFF]
Lloh105:
	adrp	x2, __ZNSt20bad_array_new_lengthD1Ev@GOTPAGE
Lloh106:
	ldr	x2, [x2, __ZNSt20bad_array_new_lengthD1Ev@GOTPAGEOFF]
	bl	___cxa_throw
	.loh AdrpLdrGot	Lloh105, Lloh106
	.loh AdrpLdrGot	Lloh103, Lloh104
	.cfi_endproc
                                        ; -- End function
	.private_extern	__ZNSt3__16vectorIDhNS_9allocatorIDhEEE20__throw_length_errorB9nqe210106Ev ; -- Begin function _ZNSt3__16vectorIDhNS_9allocatorIDhEEE20__throw_length_errorB9nqe210106Ev
	.globl	__ZNSt3__16vectorIDhNS_9allocatorIDhEEE20__throw_length_errorB9nqe210106Ev
	.weak_def_can_be_hidden	__ZNSt3__16vectorIDhNS_9allocatorIDhEEE20__throw_length_errorB9nqe210106Ev
	.p2align	2
__ZNSt3__16vectorIDhNS_9allocatorIDhEEE20__throw_length_errorB9nqe210106Ev: ; @_ZNSt3__16vectorIDhNS_9allocatorIDhEEE20__throw_length_errorB9nqe210106Ev
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh107:
	adrp	x0, l_.str.13@PAGE
Lloh108:
	add	x0, x0, l_.str.13@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh107, Lloh108
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
Lloh109:
	adrp	x0, l_.str.13@PAGE
Lloh110:
	add	x0, x0, l_.str.13@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh109, Lloh110
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
Lloh111:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh112:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh113:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh114:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	bl	___cxa_throw
	.loh AdrpLdrGot	Lloh113, Lloh114
	.loh AdrpLdrGot	Lloh111, Lloh112
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"numerical contract failed"

	.globl	_sink                           ; @sink
.zerofill __DATA,__common,_sink,4,2
l_.str.1:                               ; @.str.1
	.asciz	"half_bytes="

l_.str.2:                               ; @.str.2
	.asciz	" fp16_vector="

l_.str.3:                               ; @.str.3
	.asciz	"PASS cases="

l_.str.4:                               ; @.str.4
	.asciz	" tie="

l_.str.5:                               ; @.str.5
	.asciz	" storage_overflow="

l_.str.6:                               ; @.str.6
	.asciz	" wide_sum="

l_.str.7:                               ; @.str.7
	.asciz	" half_accum="

l_.str.8:                               ; @.str.8
	.asciz	"n="

l_.str.9:                               ; @.str.9
	.asciz	" mode="

l_.str.10:                              ; @.str.10
	.asciz	" cpu_batchmean_us_p50="

l_.str.11:                              ; @.str.11
	.asciz	" p95="

l_.str.12:                              ; @.str.12
	.asciz	"basic_string"

l_.str.13:                              ; @.str.13
	.asciz	"vector"

	.section	__TEXT,__literal16,16byte_literals
	.p2align	4, 0x0                          ; @.memset_pattern
l_.memset_pattern:
	.short	0x5cb0                          ; half 300
	.short	0x5cb0                          ; half 300
	.short	0x5cb0                          ; half 300
	.short	0x5cb0                          ; half 300
	.short	0x5cb0                          ; half 300
	.short	0x5cb0                          ; half 300
	.short	0x5cb0                          ; half 300
	.short	0x5cb0                          ; half 300

.subsections_via_symbols
