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
	.globl	__Z4packRK7Weights              ; -- Begin function _Z4packRK7Weights
	.p2align	2
__Z4packRK7Weights:                     ; @_Z4packRK7Weights
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
	mov	x20, x8
	ldp	w23, w24, [x0]
                                        ; kill: def $w24 killed $w24 def $x24
	sxtw	x24, w24
	adds	w8, w23, #3
	add	w9, w23, #6
	csel	w8, w9, w8, lt
	asr	w8, w8, #2
	stp	xzr, xzr, [x20, #8]
	smull	x8, w24, w8
	str	xzr, [x20]
	cbz	x8, LBB1_3
; %bb.1:
	lsl	x25, x8, #2
	lsr	x9, x25, #62
	cbnz	x9, LBB1_13
; %bb.2:
	lsl	x22, x8, #4
	mov	x0, x22
	bl	__Znwm
	mov	x21, x0
	str	x0, [x20]
	add	x8, x0, x25, lsl #2
	str	x8, [x20, #16]
	mov	x1, x22
	bl	_bzero
	add	x8, x21, x22
	str	x8, [x20, #8]
	cmp	w23, #1
	ccmp	w24, #1, #8, ge
	b.lt	LBB1_4
	b	LBB1_5
LBB1_3:
	mov	x21, #0                         ; =0x0
	cmp	w23, #1
	ccmp	w24, #1, #8, ge
	b.ge	LBB1_5
LBB1_4:
	ldp	x29, x30, [sp, #64]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #48]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #32]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #16]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp], #80             ; 16-byte Folded Reload
	ret
LBB1_5:
	mov	x8, #0                          ; =0x0
	ldrsw	x14, [x19, #8]
	ldr	x9, [x19, #16]
	add	x10, x21, #8
	mov	w13, #12                        ; =0xc
	lsl	x11, x14, #4
	add	x12, x9, x14, lsl #3
	smaddl	x13, w14, w13, x9
	add	x14, x9, x14, lsl #2
	lsl	x15, x24, #2
	lsl	x16, x24, #4
	b	LBB1_7
LBB1_6:                                 ;   in Loop: Header=BB1_7 Depth=1
	add	x8, x8, #4
	add	x13, x13, x11
	add	x12, x12, x11
	add	x14, x14, x11
	add	x9, x9, x11
	add	x10, x10, x16
	cmp	x8, x23
	b.hs	LBB1_4
LBB1_7:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB1_9 Depth 2
	mov	x17, #0                         ; =0x0
	orr	x0, x8, #0x1
	orr	x1, x8, #0x2
	orr	x2, x8, #0x3
	mov	x3, x10
	b	LBB1_9
LBB1_8:                                 ;   in Loop: Header=BB1_9 Depth=2
	add	x17, x17, #4
	add	x3, x3, #16
	cmp	x15, x17
	b.eq	LBB1_6
LBB1_9:                                 ;   Parent Loop BB1_7 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	s0, [x9, x17]
	stur	s0, [x3, #-8]
	cmp	x0, x23
	b.hs	LBB1_8
; %bb.10:                               ;   in Loop: Header=BB1_9 Depth=2
	ldr	s0, [x14, x17]
	stur	s0, [x3, #-4]
	cmp	x1, x23
	b.hs	LBB1_8
; %bb.11:                               ;   in Loop: Header=BB1_9 Depth=2
	ldr	s0, [x12, x17]
	str	s0, [x3]
	cmp	x2, x23
	b.hs	LBB1_8
; %bb.12:                               ;   in Loop: Header=BB1_9 Depth=2
	ldr	s0, [x13, x17]
	str	s0, [x3, #4]
	b	LBB1_8
LBB1_13:
	bl	__ZNSt3__16vectorIfNS_9allocatorIfEEE20__throw_length_errorB9nqe210106Ev
	.cfi_endproc
                                        ; -- End function
	.globl	__Z7computePKfiRK7WeightsS0_Pf  ; -- Begin function _Z7computePKfiRK7WeightsS0_Pf
	.p2align	2
__Z7computePKfiRK7WeightsS0_Pf:         ; @_Z7computePKfiRK7WeightsS0_Pf
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #176
	stp	x28, x27, [sp, #80]             ; 16-byte Folded Spill
	stp	x26, x25, [sp, #96]             ; 16-byte Folded Spill
	stp	x24, x23, [sp, #112]            ; 16-byte Folded Spill
	stp	x22, x21, [sp, #128]            ; 16-byte Folded Spill
	stp	x20, x19, [sp, #144]            ; 16-byte Folded Spill
	stp	x29, x30, [sp, #160]            ; 16-byte Folded Spill
	add	x29, sp, #160
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
	str	x0, [sp, #56]                   ; 8-byte Folded Spill
	str	w1, [sp, #40]                   ; 4-byte Folded Spill
	cmp	w1, #1
	b.lt	LBB2_14
; %bb.1:
	mov	x21, x2
	ldr	w24, [x2]
	cmp	w24, #1
	b.lt	LBB2_14
; %bb.2:
	mov	x19, x4
	ldr	w8, [x21, #4]
	str	x8, [sp, #48]                   ; 8-byte Folded Spill
	cmp	w8, #0
	b.le	LBB2_10
; %bb.3:
	mov	x9, #0                          ; =0x0
	mov	x22, x3
	cbz	x3, LBB2_15
; %bb.4:
	sub	w25, w24, #1
	lsr	w8, w25, #2
	ldr	w10, [sp, #40]                  ; 4-byte Folded Reload
	mov	w11, w10
	add	w26, w8, #1
	ldr	x8, [sp, #48]                   ; 8-byte Folded Reload
	lsl	x10, x8, #2
	stp	x10, x11, [sp, #24]             ; 16-byte Folded Spill
	lsl	w28, w8, #2
LBB2_5:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB2_6 Depth 2
                                        ;       Child Loop BB2_7 Depth 3
	mov	w27, #0                         ; =0x0
	mov	x21, #0                         ; =0x0
	mov	x23, #0                         ; =0x0
	str	x9, [sp, #40]                   ; 8-byte Folded Spill
	mul	w20, w24, w9
LBB2_6:                                 ;   Parent Loop BB2_5 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB2_7 Depth 3
	add	w8, w20, w21
	add	x0, x19, w8, uxtw #2
	sub	w8, w25, w23, lsl #2
	cmp	w8, #3
	mov	w9, #3                          ; =0x3
	csel	w8, w8, w9, lo
	lsl	w8, w8, #2
	add	w2, w8, #4
	movi.2d	v0, #0000000000000000
	ldp	x8, x10, [sp, #48]              ; 16-byte Folded Reload
	mov	x9, x27
LBB2_7:                                 ;   Parent Loop BB2_5 Depth=1
                                        ;     Parent Loop BB2_6 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	ubfiz	x11, x9, #2, #32
	ldr	q1, [x22, x11]
	ldr	s2, [x10], #4
	fmla.4s	v0, v1, v2[0]
	add	w9, w9, #4
	subs	x8, x8, #1
	b.ne	LBB2_7
; %bb.8:                                ;   in Loop: Header=BB2_6 Depth=2
	str	q0, [sp, #64]
	add	x1, sp, #64
	bl	_memcpy
	add	x21, x21, #4
	add	x23, x23, #1
	add	w27, w27, w28
	cmp	x23, x26
	b.ne	LBB2_6
; %bb.9:                                ;   in Loop: Header=BB2_5 Depth=1
	ldr	x9, [sp, #40]                   ; 8-byte Folded Reload
	add	x9, x9, #1
	ldr	x8, [sp, #56]                   ; 8-byte Folded Reload
	ldr	x10, [sp, #24]                  ; 8-byte Folded Reload
	add	x8, x8, x10
	str	x8, [sp, #56]                   ; 8-byte Folded Spill
	ldr	x8, [sp, #32]                   ; 8-byte Folded Reload
	cmp	x9, x8
	b.ne	LBB2_5
	b	LBB2_14
LBB2_10:
	mov	w23, #0                         ; =0x0
	mov	w21, #0                         ; =0x0
	sub	w22, w24, #1
	lsr	w8, w22, #2
	add	w25, w8, #1
	mov	w26, #3                         ; =0x3
LBB2_11:                                ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB2_12 Depth 2
	mov	x27, x25
	mov	x28, x22
	mov	x20, x23
LBB2_12:                                ;   Parent Loop BB2_11 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	stp	xzr, xzr, [sp, #64]
	cmp	w28, #3
	csel	w8, w28, w26, lo
	lsl	w8, w8, #2
	add	w2, w8, #4
	add	x0, x19, w20, uxtw #2
	add	x1, sp, #64
	bl	_memcpy
	add	w20, w20, #4
	sub	w28, w28, #4
	subs	x27, x27, #1
	b.ne	LBB2_12
; %bb.13:                               ;   in Loop: Header=BB2_11 Depth=1
	add	w21, w21, #1
	add	w23, w23, w24
	ldr	w8, [sp, #40]                   ; 4-byte Folded Reload
	cmp	w21, w8
	b.ne	LBB2_11
LBB2_14:
	ldp	x29, x30, [sp, #160]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #144]            ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #128]            ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #112]            ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #96]             ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #80]             ; 16-byte Folded Reload
	add	sp, sp, #176
	ret
LBB2_15:
	sub	w8, w24, #1
	mov	x20, x8
	lsr	w8, w8, #2
	add	w8, w8, #1
	str	x8, [sp, #32]                   ; 8-byte Folded Spill
	ldr	w8, [sp, #40]                   ; 4-byte Folded Reload
	mov	w10, w8
	ldr	x8, [sp, #48]                   ; 8-byte Folded Reload
	lsl	x8, x8, #2
	stp	x8, x10, [sp, #8]               ; 16-byte Folded Spill
	b	LBB2_17
LBB2_16:                                ;   in Loop: Header=BB2_17 Depth=1
	ldr	x9, [sp, #24]                   ; 8-byte Folded Reload
	add	x9, x9, #1
	ldr	x8, [sp, #56]                   ; 8-byte Folded Reload
	ldr	x10, [sp, #8]                   ; 8-byte Folded Reload
	add	x8, x8, x10
	str	x8, [sp, #56]                   ; 8-byte Folded Spill
	ldr	x8, [sp, #16]                   ; 8-byte Folded Reload
	cmp	x9, x8
	b.eq	LBB2_14
LBB2_17:                                ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB2_19 Depth 2
                                        ;       Child Loop BB2_21 Depth 3
	mov	x28, #0                         ; =0x0
	mov	x22, #0                         ; =0x0
	mov	x23, #0                         ; =0x0
	str	x9, [sp, #24]                   ; 8-byte Folded Spill
	mul	w8, w24, w9
	str	w8, [sp, #40]                   ; 4-byte Folded Spill
	mov	w27, #4                         ; =0x4
	mov	w26, #8                         ; =0x8
	mov	w25, #12                        ; =0xc
	b	LBB2_19
LBB2_18:                                ;   in Loop: Header=BB2_19 Depth=2
	str	q0, [sp, #64]
	add	x1, sp, #64
	bl	_memcpy
	add	x22, x22, #4
	add	x23, x23, #1
	add	x25, x25, #16
	add	x26, x26, #16
	add	x27, x27, #16
	add	x28, x28, #16
	ldr	x8, [sp, #32]                   ; 8-byte Folded Reload
	cmp	x23, x8
	b.eq	LBB2_16
LBB2_19:                                ;   Parent Loop BB2_17 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB2_21 Depth 3
	ldr	w8, [sp, #40]                   ; 4-byte Folded Reload
	add	w8, w8, w22
	add	x0, x19, w8, uxtw #2
	sub	w8, w20, w23, lsl #2
	cmp	w8, #3
	mov	w9, #3                          ; =0x3
	csel	w8, w8, w9, lo
	lsl	w8, w8, #2
	add	w2, w8, #4
	ldrsw	x14, [x21, #8]
	ldr	x15, [x21, #16]
	orr	x8, x22, #0x1
	orr	x9, x22, #0x2
	orr	x10, x22, #0x3
	madd	x11, x25, x14, x15
	madd	x12, x26, x14, x15
	madd	x13, x27, x14, x15
	madd	x14, x28, x14, x15
	movi.2d	v0, #0000000000000000
	ldp	x15, x16, [sp, #48]             ; 16-byte Folded Reload
	b	LBB2_21
LBB2_20:                                ;   in Loop: Header=BB2_21 Depth=3
	ldr	s2, [x16], #4
	fmla.4s	v0, v1, v2[0]
	add	x11, x11, #4
	add	x12, x12, #4
	add	x13, x13, #4
	subs	x15, x15, #1
	b.eq	LBB2_18
LBB2_21:                                ;   Parent Loop BB2_17 Depth=1
                                        ;     Parent Loop BB2_19 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	movi.2d	v1, #0000000000000000
	ld1.s	{ v1 }[0], [x14], #4
	cmp	x8, x24
	b.hs	LBB2_20
; %bb.22:                               ;   in Loop: Header=BB2_21 Depth=3
	ld1.s	{ v1 }[1], [x13]
	cmp	x9, x24
	b.hs	LBB2_20
; %bb.23:                               ;   in Loop: Header=BB2_21 Depth=3
	ld1.s	{ v1 }[2], [x12]
	cmp	x10, x24
	b.hs	LBB2_20
; %bb.24:                               ;   in Loop: Header=BB2_21 Depth=3
	ld1.s	{ v1 }[3], [x11]
	b	LBB2_20
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__literal8,8byte_literals
	.p2align	3, 0x0                          ; -- Begin function main
lCPI3_0:
	.long	0                               ; 0x0
	.long	1                               ; 0x1
lCPI3_1:
	.long	0                               ; 0x0
	.long	7                               ; 0x7
lCPI3_4:
	.long	17                              ; 0x11
	.long	128                             ; 0x80
lCPI3_5:
	.long	1                               ; 0x1
	.long	8                               ; 0x8
	.section	__TEXT,__literal16,16byte_literals
	.p2align	4, 0x0
lCPI3_2:
	.quad	2                               ; 0x2
	.quad	3                               ; 0x3
lCPI3_3:
	.quad	0                               ; 0x0
	.quad	1                               ; 0x1
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_main
	.p2align	2
_main:                                  ; @main
Lfunc_begin1:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception1
; %bb.0:
	stp	d11, d10, [sp, #-128]!          ; 16-byte Folded Spill
	stp	d9, d8, [sp, #16]               ; 16-byte Folded Spill
	stp	x28, x27, [sp, #32]             ; 16-byte Folded Spill
	stp	x26, x25, [sp, #48]             ; 16-byte Folded Spill
	stp	x24, x23, [sp, #64]             ; 16-byte Folded Spill
	stp	x22, x21, [sp, #80]             ; 16-byte Folded Spill
	stp	x20, x19, [sp, #96]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #112]            ; 16-byte Folded Spill
	add	x29, sp, #112
	sub	sp, sp, #448
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
	mov	x9, #0                          ; =0x0
Lloh2:
	adrp	x8, ___stack_chk_guard@GOTPAGE
Lloh3:
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
Lloh4:
	ldr	x8, [x8]
	stur	x8, [x29, #-128]
Lloh5:
	adrp	x8, lCPI3_0@PAGE
Lloh6:
	ldr	d0, [x8, lCPI3_0@PAGEOFF]
	stur	d0, [x29, #-152]
	mov	w8, #3                          ; =0x3
	stur	w8, [x29, #-144]
	sub	x10, x29, #152
Lloh7:
	adrp	x8, lCPI3_1@PAGE
Lloh8:
	ldr	d8, [x8, lCPI3_1@PAGEOFF]
	mov	w21, #17097                     ; =0x42c9
	movk	w21, #45590, lsl #16
	mov	w23, #23                        ; =0x17
Lloh9:
	adrp	x8, lCPI3_2@PAGE
Lloh10:
	ldr	q0, [x8, lCPI3_2@PAGEOFF]
	str	q0, [sp, #256]                  ; 16-byte Folded Spill
Lloh11:
	adrp	x8, lCPI3_3@PAGE
Lloh12:
	ldr	q1, [x8, lCPI3_3@PAGEOFF]
	dup.4s	v0, w21
	stp	q0, q1, [sp, #224]              ; 32-byte Folded Spill
	mov	w8, #1031798784                 ; =0x3d800000
	dup.4s	v1, w8
	mov	w8, #4                          ; =0x4
	dup.2d	v0, x8
	stp	q0, q1, [sp, #192]              ; 32-byte Folded Spill
	movi.2d	v9, #0000000000000000
	fmov	d10, #1.00000000
	mov	x8, #26865                      ; =0x68f1
	movk	x8, #35043, lsl #16
	movk	x8, #63669, lsl #32
	movk	x8, #16100, lsl #48
	fmov	d11, x8
LBB3_1:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB3_3 Depth 2
                                        ;       Child Loop BB3_6 Depth 3
                                        ;         Child Loop BB3_9 Depth 4
                                        ;           Child Loop BB3_18 Depth 5
                                        ;             Child Loop BB3_21 Depth 6
                                        ;             Child Loop BB3_24 Depth 6
                                        ;           Child Loop BB3_32 Depth 5
                                        ;             Child Loop BB3_45 Depth 6
                                        ;             Child Loop BB3_41 Depth 6
                                        ;             Child Loop BB3_48 Depth 6
                                        ;             Child Loop BB3_37 Depth 6
                                        ;             Child Loop BB3_40 Depth 6
                                        ;           Child Loop BB3_85 Depth 5
                                        ;             Child Loop BB3_86 Depth 6
                                        ;           Child Loop BB3_91 Depth 5
                                        ;             Child Loop BB3_92 Depth 6
                                        ;               Child Loop BB3_95 Depth 7
                                        ;               Child Loop BB3_99 Depth 7
                                        ;               Child Loop BB3_101 Depth 7
                                        ;           Child Loop BB3_65 Depth 5
                                        ;             Child Loop BB3_66 Depth 6
	mov	x11, #0                         ; =0x0
	str	x9, [sp]                        ; 8-byte Folded Spill
	ldr	w26, [x10, x9]
	sxtw	x8, w26
	str	x8, [sp, #144]                  ; 8-byte Folded Spill
	str	x26, [sp, #176]                 ; 8-byte Folded Spill
	b	LBB3_3
LBB3_2:                                 ;   in Loop: Header=BB3_3 Depth=2
	ldr	x11, [sp, #8]                   ; 8-byte Folded Reload
	add	x11, x11, #4
	cmp	x11, #24
	b.eq	LBB3_107
LBB3_3:                                 ;   Parent Loop BB3_1 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB3_6 Depth 3
                                        ;         Child Loop BB3_9 Depth 4
                                        ;           Child Loop BB3_18 Depth 5
                                        ;             Child Loop BB3_21 Depth 6
                                        ;             Child Loop BB3_24 Depth 6
                                        ;           Child Loop BB3_32 Depth 5
                                        ;             Child Loop BB3_45 Depth 6
                                        ;             Child Loop BB3_41 Depth 6
                                        ;             Child Loop BB3_48 Depth 6
                                        ;             Child Loop BB3_37 Depth 6
                                        ;             Child Loop BB3_40 Depth 6
                                        ;           Child Loop BB3_85 Depth 5
                                        ;             Child Loop BB3_86 Depth 6
                                        ;           Child Loop BB3_91 Depth 5
                                        ;             Child Loop BB3_92 Depth 6
                                        ;               Child Loop BB3_95 Depth 7
                                        ;               Child Loop BB3_99 Depth 7
                                        ;               Child Loop BB3_101 Depth 7
                                        ;           Child Loop BB3_65 Depth 5
                                        ;             Child Loop BB3_66 Depth 6
Lloh13:
	adrp	x8, l_constinit@PAGE
Lloh14:
	add	x8, x8, l_constinit@PAGEOFF
	str	x11, [sp, #8]                   ; 8-byte Folded Spill
	ldr	w22, [x8, x11]
	cmp	w22, #2048
	b.hi	LBB3_114
; %bb.4:                                ;   in Loop: Header=BB3_3 Depth=2
	mov	x9, #0                          ; =0x0
	add	w8, w22, #3
	lsr	w8, w8, #2
	str	w8, [sp, #28]                   ; 4-byte Folded Spill
	ldr	x8, [sp, #144]                  ; 8-byte Folded Reload
	mul	w25, w22, w8
	sbfiz	x8, x25, #2, #32
	str	x8, [sp, #80]                   ; 8-byte Folded Spill
	lsl	x8, x22, #2
	str	x8, [sp, #288]                  ; 8-byte Folded Spill
	sub	x8, x8, #4
	and	x10, x8, #0xfffffffffffffff0
	add	x11, x10, #16
	str	x11, [sp, #16]                  ; 8-byte Folded Spill
	orr	x11, x8, #0xc
	orr	x8, x10, #0x8
	stp	x8, x11, [sp, #48]              ; 16-byte Folded Spill
	str	x10, [sp, #64]                  ; 8-byte Folded Spill
	orr	x8, x10, #0x4
	str	x8, [sp, #40]                   ; 8-byte Folded Spill
	str	x25, [sp, #152]                 ; 8-byte Folded Spill
	b	LBB3_6
LBB3_5:                                 ;   in Loop: Header=BB3_6 Depth=3
	ldr	x9, [sp, #32]                   ; 8-byte Folded Reload
	add	x9, x9, #4
	cmp	x9, #28
	b.eq	LBB3_2
LBB3_6:                                 ;   Parent Loop BB3_1 Depth=1
                                        ;     Parent Loop BB3_3 Depth=2
                                        ; =>    This Loop Header: Depth=3
                                        ;         Child Loop BB3_9 Depth 4
                                        ;           Child Loop BB3_18 Depth 5
                                        ;             Child Loop BB3_21 Depth 6
                                        ;             Child Loop BB3_24 Depth 6
                                        ;           Child Loop BB3_32 Depth 5
                                        ;             Child Loop BB3_45 Depth 6
                                        ;             Child Loop BB3_41 Depth 6
                                        ;             Child Loop BB3_48 Depth 6
                                        ;             Child Loop BB3_37 Depth 6
                                        ;             Child Loop BB3_40 Depth 6
                                        ;           Child Loop BB3_85 Depth 5
                                        ;             Child Loop BB3_86 Depth 6
                                        ;           Child Loop BB3_91 Depth 5
                                        ;             Child Loop BB3_92 Depth 6
                                        ;               Child Loop BB3_95 Depth 7
                                        ;               Child Loop BB3_99 Depth 7
                                        ;               Child Loop BB3_101 Depth 7
                                        ;           Child Loop BB3_65 Depth 5
                                        ;             Child Loop BB3_66 Depth 6
	cmp	w22, #0
Lloh15:
	adrp	x8, l_constinit.1@PAGE
Lloh16:
	add	x8, x8, l_constinit.1@PAGEOFF
	str	x9, [sp, #32]                   ; 8-byte Folded Spill
	ldr	w20, [x8, x9]
	cset	w8, ne
	stur	d8, [x29, #-184]
	cmp	w20, #0
	csel	w9, wzr, w8, eq
	str	w9, [sp, #140]                  ; 4-byte Folded Spill
	csel	w8, wzr, w8, le
	str	w8, [sp, #132]                  ; 4-byte Folded Spill
	cmp	w20, #2048
	b.hi	LBB3_114
; %bb.7:                                ;   in Loop: Header=BB3_6 Depth=3
	mov	x19, #0                         ; =0x0
	ldr	w8, [sp, #28]                   ; 4-byte Folded Reload
	mul	w8, w20, w8
	str	w8, [sp, #136]                  ; 4-byte Folded Spill
	lsl	w8, w8, #4
	str	x8, [sp, #104]                  ; 8-byte Folded Spill
	ldr	x8, [sp, #144]                  ; 8-byte Folded Reload
	mul	x8, x20, x8
	str	x8, [sp, #120]                  ; 8-byte Folded Spill
	lsl	x8, x8, #2
	str	x8, [sp, #96]                   ; 8-byte Folded Spill
	sub	x8, x8, #4
	lsr	x8, x8, #2
	add	x8, x8, #1
	lsl	x9, x20, #2
	stur	x9, [x29, #-248]                ; 8-byte Folded Spill
	ldr	x9, [sp, #16]                   ; 8-byte Folded Reload
	mul	x9, x9, x20
	str	x9, [sp, #72]                   ; 8-byte Folded Spill
	lsl	x9, x20, #4
	str	x9, [sp, #296]                  ; 8-byte Folded Spill
	ubfx	x9, x20, #2, #10
	and	x28, x20, #0xffc
	and	x27, x20, #0xff0
	and	x10, x20, #0xc
	stur	x10, [x29, #-256]               ; 8-byte Folded Spill
	and	x10, x20, #0xffe
	neg	x24, x10
	lsl	x10, x9, #4
	str	x10, [sp, #112]                 ; 8-byte Folded Spill
	neg	x9, x9, lsl #2
	stur	x9, [x29, #-240]                ; 8-byte Folded Spill
	lsl	x8, x8, #2
	str	x8, [sp, #88]                   ; 8-byte Folded Spill
	b	LBB3_9
LBB3_8:                                 ;   in Loop: Header=BB3_9 Depth=4
	add	x19, x19, #4
	cmp	x19, #8
	b.eq	LBB3_5
LBB3_9:                                 ;   Parent Loop BB3_1 Depth=1
                                        ;     Parent Loop BB3_3 Depth=2
                                        ;       Parent Loop BB3_6 Depth=3
                                        ; =>      This Loop Header: Depth=4
                                        ;           Child Loop BB3_18 Depth 5
                                        ;             Child Loop BB3_21 Depth 6
                                        ;             Child Loop BB3_24 Depth 6
                                        ;           Child Loop BB3_32 Depth 5
                                        ;             Child Loop BB3_45 Depth 6
                                        ;             Child Loop BB3_41 Depth 6
                                        ;             Child Loop BB3_48 Depth 6
                                        ;             Child Loop BB3_37 Depth 6
                                        ;             Child Loop BB3_40 Depth 6
                                        ;           Child Loop BB3_85 Depth 5
                                        ;             Child Loop BB3_86 Depth 6
                                        ;           Child Loop BB3_91 Depth 5
                                        ;             Child Loop BB3_92 Depth 6
                                        ;               Child Loop BB3_95 Depth 7
                                        ;               Child Loop BB3_99 Depth 7
                                        ;               Child Loop BB3_101 Depth 7
                                        ;           Child Loop BB3_65 Depth 5
                                        ;             Child Loop BB3_66 Depth 6
	sub	x8, x29, #184
	ldr	w8, [x8, x19]
	add	w26, w8, w20
	stp	w22, w20, [x29, #-232]
	stur	w26, [x29, #-224]
	sub	x9, x29, #232
	stp	xzr, xzr, [x9, #24]
	stur	xzr, [x9, #16]
	tbnz	w8, #31, LBB3_114
; %bb.10:                               ;   in Loop: Header=BB3_9 Depth=4
	cmp	w26, #1, lsl #12                ; =4096
	b.gt	LBB3_114
; %bb.11:                               ;   in Loop: Header=BB3_9 Depth=4
	umull	x9, w22, w26
	str	x19, [sp, #160]                 ; 8-byte Folded Spill
	cbz	x9, LBB3_15
; %bb.12:                               ;   in Loop: Header=BB3_9 Depth=4
	lsr	x8, x9, #62
	cbnz	x8, LBB3_116
; %bb.13:                               ;   in Loop: Header=BB3_9 Depth=4
	str	x9, [sp, #280]                  ; 8-byte Folded Spill
	lsl	x25, x9, #2
Ltmp3:
	mov	x0, x25
	bl	__Znwm
Ltmp4:
; %bb.14:                               ;   in Loop: Header=BB3_9 Depth=4
	mov	x19, x0
	mov	x1, x25
	bl	_bzero
	add	x8, x19, x25
	ldr	x9, [sp, #280]                  ; 8-byte Folded Reload
	add	x9, x19, x9, lsl #2
	stp	x19, x8, [x29, #-216]
	stur	x9, [x29, #-200]
	ldr	x25, [sp, #152]                 ; 8-byte Folded Reload
	ldr	w8, [sp, #140]                  ; 4-byte Folded Reload
	cbnz	w8, LBB3_16
	b	LBB3_25
LBB3_15:                                ;   in Loop: Header=BB3_9 Depth=4
	mov	x19, #0                         ; =0x0
	ldr	w8, [sp, #140]                  ; 4-byte Folded Reload
	cbz	w8, LBB3_25
LBB3_16:                                ;   in Loop: Header=BB3_9 Depth=4
	mov	w8, #0                          ; =0x0
	mov	x9, #0                          ; =0x0
	lsl	x10, x26, #2
	mov	w11, #-11                       ; =0xfffffff5
	b	LBB3_18
LBB3_17:                                ;   in Loop: Header=BB3_18 Depth=5
	add	x9, x9, #1
	add	x19, x19, x10
	add	w11, w11, #7
	add	w8, w8, #7
	cmp	x9, x22
	b.eq	LBB3_25
LBB3_18:                                ;   Parent Loop BB3_1 Depth=1
                                        ;     Parent Loop BB3_3 Depth=2
                                        ;       Parent Loop BB3_6 Depth=3
                                        ;         Parent Loop BB3_9 Depth=4
                                        ; =>        This Loop Header: Depth=5
                                        ;             Child Loop BB3_21 Depth 6
                                        ;             Child Loop BB3_24 Depth 6
	cmp	w20, #4
	b.hs	LBB3_20
; %bb.19:                               ;   in Loop: Header=BB3_18 Depth=5
	mov	x12, #0                         ; =0x0
	b	LBB3_23
LBB3_20:                                ;   in Loop: Header=BB3_18 Depth=5
	lsl	x12, x9, #3
	sub	x12, x12, x9
	dup.2d	v0, x12
	mov	x12, x19
	mov	x13, x28
	ldp	q1, q2, [sp, #240]              ; 32-byte Folded Reload
	ldp	q17, q6, [sp, #208]             ; 32-byte Folded Reload
	movi.4s	v7, #23
	mvni.4s	v16, #10
	ldr	q18, [sp, #192]                 ; 16-byte Folded Reload
LBB3_21:                                ;   Parent Loop BB3_1 Depth=1
                                        ;     Parent Loop BB3_3 Depth=2
                                        ;       Parent Loop BB3_6 Depth=3
                                        ;         Parent Loop BB3_9 Depth=4
                                        ;           Parent Loop BB3_18 Depth=5
                                        ; =>          This Inner Loop Header: Depth=6
	mov.d	x14, v2[1]
	fmov	x15, d2
	add	w15, w15, w15, lsl #1
	fmov	d3, x15
	fmov	x15, d1
	add	w15, w15, w15, lsl #1
	add	w14, w14, w14, lsl #1
	fmov	d4, x15
	mov.d	x15, v1[1]
	add	w15, w15, w15, lsl #1
	mov.d	v3[1], x14
	mov.d	v4[1], x15
	add.2d	v4, v4, v0
	add.2d	v3, v3, v0
	uzp1.4s	v3, v4, v3
	umull2.2d	v4, v3, v6
	umull.2d	v5, v3, v6
	uzp2.4s	v4, v5, v4
	ushr.4s	v4, v4, #4
	mls.4s	v3, v4, v7
	add.4s	v3, v3, v16
	scvtf.4s	v3, v3
	fmul.4s	v3, v3, v17
	str	q3, [x12], #16
	add.2d	v2, v2, v18
	add.2d	v1, v1, v18
	subs	x13, x13, #4
	b.ne	LBB3_21
; %bb.22:                               ;   in Loop: Header=BB3_18 Depth=5
	mov	x12, x28
	cmp	x28, x20
	b.eq	LBB3_17
LBB3_23:                                ;   in Loop: Header=BB3_18 Depth=5
	add	w14, w12, w12, lsl #1
	add	w13, w11, w14
	add	w14, w8, w14
LBB3_24:                                ;   Parent Loop BB3_1 Depth=1
                                        ;     Parent Loop BB3_3 Depth=2
                                        ;       Parent Loop BB3_6 Depth=3
                                        ;         Parent Loop BB3_9 Depth=4
                                        ;           Parent Loop BB3_18 Depth=5
                                        ; =>          This Inner Loop Header: Depth=6
	umull	x15, w14, w21
	lsr	x15, x15, #36
	msub	w15, w15, w23, w13
	scvtf	s0, w15, #4
	str	s0, [x19, x12, lsl #2]
	add	x12, x12, #1
	add	w13, w13, #3
	add	w14, w14, #3
	cmp	x20, x12
	b.ne	LBB3_24
	b	LBB3_17
LBB3_25:                                ;   in Loop: Header=BB3_9 Depth=4
	ldr	w8, [sp, #136]                  ; 4-byte Folded Reload
	cbz	w8, LBB3_28
; %bb.26:                               ;   in Loop: Header=BB3_9 Depth=4
Ltmp9:
	ldr	x19, [sp, #104]                 ; 8-byte Folded Reload
	mov	x0, x19
	bl	__Znwm
Ltmp10:
; %bb.27:                               ;   in Loop: Header=BB3_9 Depth=4
	str	x0, [sp, #184]                  ; 8-byte Folded Spill
	mov	x1, x19
	bl	_bzero
	ldr	w8, [sp, #132]                  ; 4-byte Folded Reload
	cbnz	w8, LBB3_29
	b	LBB3_49
LBB3_28:                                ;   in Loop: Header=BB3_9 Depth=4
	str	xzr, [sp, #184]                 ; 8-byte Folded Spill
	ldr	w8, [sp, #132]                  ; 4-byte Folded Reload
	cbz	w8, LBB3_49
LBB3_29:                                ;   in Loop: Header=BB3_9 Depth=4
	mov	x8, #0                          ; =0x0
	mov	x9, #0                          ; =0x0
	cmp	w20, #4
	cset	w15, lo
	ldur	x10, [x29, #-216]
	ldr	x4, [sp, #184]                  ; 8-byte Folded Reload
	add	x11, x4, #4
	ldp	x3, x12, [sp, #64]              ; 16-byte Folded Reload
	add	x16, x4, x12
	mov	w12, #12                        ; =0xc
	umaddl	x12, w26, w12, x10
	ldur	x13, [x29, #-248]               ; 8-byte Folded Reload
	add	x17, x10, x13
	ldp	x14, x13, [sp, #48]             ; 16-byte Folded Reload
	madd	x0, x13, x26, x17
	add	x13, x10, x26, lsl #3
	madd	x1, x14, x26, x17
	add	x14, x10, x26, lsl #2
	ldr	x2, [sp, #40]                   ; 8-byte Folded Reload
	madd	x2, x2, x26, x17
	madd	x17, x3, x26, x17
	cmp	x4, x0
	ccmp	x12, x16, #2, lo
	cset	w0, lo
	cmp	x4, x1
	ccmp	x13, x16, #2, lo
	csinc	w0, w0, wzr, hs
	cmp	x4, x2
	ccmp	x14, x16, #2, lo
	csinc	w0, w0, wzr, hs
	cmp	x4, x17
	ccmp	x10, x16, #2, lo
	csinc	w16, w0, wzr, hs
	orr	w15, w15, w16
	add	x16, x4, #16
	add	x17, x10, #4
	lsl	x0, x26, #4
	add	x1, x4, #8
	mov	x2, x4
	mov	x3, x10
	b	LBB3_32
LBB3_30:                                ;   in Loop: Header=BB3_32 Depth=5
	lsr	x5, x9, #2
	mul	x5, x5, x20
	mul	x6, x9, x26
	add	x6, x10, x6, lsl #2
	add	x5, x4, x5
	ldr	s0, [x6, x4, lsl #2]
	lsl	x4, x5, #4
	ldr	x5, [sp, #184]                  ; 8-byte Folded Reload
	str	s0, [x5, x4]
LBB3_31:                                ;   in Loop: Header=BB3_32 Depth=5
	add	x9, x9, #4
	ldr	x4, [sp, #296]                  ; 8-byte Folded Reload
	add	x16, x16, x4
	add	x17, x17, x0
	add	x3, x3, x0
	add	x11, x11, x4
	add	x13, x13, x0
	add	x14, x14, x0
	add	x12, x12, x0
	add	x2, x2, x4
	add	x8, x8, x20
	cmp	x9, x22
	b.hs	LBB3_49
LBB3_32:                                ;   Parent Loop BB3_1 Depth=1
                                        ;     Parent Loop BB3_3 Depth=2
                                        ;       Parent Loop BB3_6 Depth=3
                                        ;         Parent Loop BB3_9 Depth=4
                                        ; =>        This Loop Header: Depth=5
                                        ;             Child Loop BB3_45 Depth 6
                                        ;             Child Loop BB3_41 Depth 6
                                        ;             Child Loop BB3_48 Depth 6
                                        ;             Child Loop BB3_37 Depth 6
                                        ;             Child Loop BB3_40 Depth 6
	orr	x4, x9, #0x1
	cmp	x4, x22
	b.hs	LBB3_42
; %bb.33:                               ;   in Loop: Header=BB3_32 Depth=5
	orr	x7, x9, #0x2
	mov	x4, x11
	mov	x5, x3
	mov	x6, x20
	cmp	x7, x22
	b.hs	LBB3_41
; %bb.34:                               ;   in Loop: Header=BB3_32 Depth=5
	orr	x4, x9, #0x3
	cmp	x4, x22
	b.hs	LBB3_47
; %bb.35:                               ;   in Loop: Header=BB3_32 Depth=5
	mov	x4, #0                          ; =0x0
	tbnz	w15, #0, LBB3_39
; %bb.36:                               ;   in Loop: Header=BB3_32 Depth=5
	mov	x5, x2
	ldr	x6, [sp, #112]                  ; 8-byte Folded Reload
LBB3_37:                                ;   Parent Loop BB3_1 Depth=1
                                        ;     Parent Loop BB3_3 Depth=2
                                        ;       Parent Loop BB3_6 Depth=3
                                        ;         Parent Loop BB3_9 Depth=4
                                        ;           Parent Loop BB3_32 Depth=5
                                        ; =>          This Inner Loop Header: Depth=6
	ldr	q0, [x3, x4]
	ldr	q1, [x14, x4]
	ldr	q2, [x13, x4]
	ldr	q3, [x12, x4]
	st4.4s	{ v0, v1, v2, v3 }, [x5], #64
	add	x4, x4, #16
	cmp	x6, x4
	b.ne	LBB3_37
; %bb.38:                               ;   in Loop: Header=BB3_32 Depth=5
	mov	x4, x28
	cmp	x28, x20
	b.eq	LBB3_31
LBB3_39:                                ;   in Loop: Header=BB3_32 Depth=5
	add	x5, x4, x8
	add	x5, x1, x5, lsl #4
LBB3_40:                                ;   Parent Loop BB3_1 Depth=1
                                        ;     Parent Loop BB3_3 Depth=2
                                        ;       Parent Loop BB3_6 Depth=3
                                        ;         Parent Loop BB3_9 Depth=4
                                        ;           Parent Loop BB3_32 Depth=5
                                        ; =>          This Inner Loop Header: Depth=6
	ldr	s0, [x3, x4, lsl #2]
	stur	s0, [x5, #-8]
	ldr	s0, [x14, x4, lsl #2]
	stur	s0, [x5, #-4]
	ldr	s0, [x13, x4, lsl #2]
	str	s0, [x5]
	ldr	s0, [x12, x4, lsl #2]
	str	s0, [x5, #4]
	add	x4, x4, #1
	add	x5, x5, #16
	cmp	x20, x4
	b.ne	LBB3_40
	b	LBB3_31
LBB3_41:                                ;   Parent Loop BB3_1 Depth=1
                                        ;     Parent Loop BB3_3 Depth=2
                                        ;       Parent Loop BB3_6 Depth=3
                                        ;         Parent Loop BB3_9 Depth=4
                                        ;           Parent Loop BB3_32 Depth=5
                                        ; =>          This Inner Loop Header: Depth=6
	ldr	s0, [x5]
	stur	s0, [x4, #-4]
	ldr	s0, [x5, x26, lsl #2]
	str	s0, [x4], #16
	add	x5, x5, #4
	subs	x6, x6, #1
	b.ne	LBB3_41
	b	LBB3_31
LBB3_42:                                ;   in Loop: Header=BB3_32 Depth=5
	cmp	w20, #1
	b.ne	LBB3_44
; %bb.43:                               ;   in Loop: Header=BB3_32 Depth=5
	mov	x4, #0                          ; =0x0
	tbz	w20, #0, LBB3_31
	b	LBB3_30
LBB3_44:                                ;   in Loop: Header=BB3_32 Depth=5
	mov	x4, #0                          ; =0x0
	mov	x5, x17
	mov	x6, x16
LBB3_45:                                ;   Parent Loop BB3_1 Depth=1
                                        ;     Parent Loop BB3_3 Depth=2
                                        ;       Parent Loop BB3_6 Depth=3
                                        ;         Parent Loop BB3_9 Depth=4
                                        ;           Parent Loop BB3_32 Depth=5
                                        ; =>          This Inner Loop Header: Depth=6
	ldur	s0, [x5, #-4]
	stur	s0, [x6, #-16]
	ldr	s0, [x5], #8
	str	s0, [x6], #32
	sub	x4, x4, #2
	cmp	x24, x4
	b.ne	LBB3_45
; %bb.46:                               ;   in Loop: Header=BB3_32 Depth=5
	neg	x4, x4
	tbz	w20, #0, LBB3_31
	b	LBB3_30
LBB3_47:                                ;   in Loop: Header=BB3_32 Depth=5
	mov	x4, #0                          ; =0x0
	mov	x5, x11
LBB3_48:                                ;   Parent Loop BB3_1 Depth=1
                                        ;     Parent Loop BB3_3 Depth=2
                                        ;       Parent Loop BB3_6 Depth=3
                                        ;         Parent Loop BB3_9 Depth=4
                                        ;           Parent Loop BB3_32 Depth=5
                                        ; =>          This Inner Loop Header: Depth=6
	ldr	s0, [x3, x4]
	stur	s0, [x5, #-4]
	ldr	s0, [x14, x4]
	str	s0, [x5]
	ldr	s0, [x13, x4]
	str	s0, [x5, #4]
	add	x4, x4, #4
	add	x5, x5, #16
	ldur	x6, [x29, #-248]                ; 8-byte Folded Reload
	cmp	x6, x4
	b.ne	LBB3_48
	b	LBB3_31
LBB3_49:                                ;   in Loop: Header=BB3_9 Depth=4
	ldr	x8, [sp, #120]                  ; 8-byte Folded Reload
	cbz	x8, LBB3_58
; %bb.50:                               ;   in Loop: Header=BB3_9 Depth=4
	lsr	x8, x8, #62
	cbnz	x8, LBB3_118
; %bb.51:                               ;   in Loop: Header=BB3_9 Depth=4
Ltmp12:
	ldr	x0, [sp, #96]                   ; 8-byte Folded Reload
	bl	__Znwm
Ltmp13:
; %bb.52:                               ;   in Loop: Header=BB3_9 Depth=4
	str	x0, [sp, #280]                  ; 8-byte Folded Spill
Lloh17:
	adrp	x1, l_.memset_pattern@PAGE
Lloh18:
	add	x1, x1, l_.memset_pattern@PAGEOFF
	ldr	x2, [sp, #88]                   ; 8-byte Folded Reload
	bl	_memset_pattern16
	cbz	w25, LBB3_59
LBB3_53:                                ;   in Loop: Header=BB3_9 Depth=4
	tbnz	w25, #31, LBB3_117
; %bb.54:                               ;   in Loop: Header=BB3_9 Depth=4
Ltmp18:
	ldr	x25, [sp, #80]                  ; 8-byte Folded Reload
	mov	x0, x25
	bl	__Znwm
Ltmp19:
; %bb.55:                               ;   in Loop: Header=BB3_9 Depth=4
	str	x0, [sp, #168]                  ; 8-byte Folded Spill
	mov	x1, x25
	bl	_bzero
Ltmp21:
	mov	x0, x25
	bl	__Znwm
Ltmp22:
; %bb.56:                               ;   in Loop: Header=BB3_9 Depth=4
	mov	x19, x0
	mov	x1, x25
	bl	_bzero
Ltmp24:
	mov	x0, x25
	bl	__Znwm
	mov	x1, x25
Ltmp25:
; %bb.57:                               ;   in Loop: Header=BB3_9 Depth=4
	mov	x25, x0
	bl	_bzero
	b	LBB3_60
LBB3_58:                                ;   in Loop: Header=BB3_9 Depth=4
	str	xzr, [sp, #280]                 ; 8-byte Folded Spill
	cbnz	w25, LBB3_53
LBB3_59:                                ;   in Loop: Header=BB3_9 Depth=4
	mov	x19, #0                         ; =0x0
	str	xzr, [sp, #168]                 ; 8-byte Folded Spill
	mov	x25, #0                         ; =0x0
LBB3_60:                                ;   in Loop: Header=BB3_9 Depth=4
	sub	x2, x29, #232
	ldr	x0, [sp, #280]                  ; 8-byte Folded Reload
	ldr	x1, [sp, #176]                  ; 8-byte Folded Reload
                                        ; kill: def $w1 killed $w1 killed $x1
	mov	x3, #0                          ; =0x0
	mov	x4, x25
	bl	__Z7computePKfiRK7WeightsS0_Pf
	sub	x2, x29, #232
	ldr	x0, [sp, #280]                  ; 8-byte Folded Reload
	ldr	x1, [sp, #144]                  ; 8-byte Folded Reload
                                        ; kill: def $w1 killed $w1 killed $x1
	ldr	x3, [sp, #184]                  ; 8-byte Folded Reload
	mov	x4, x19
	bl	__Z7computePKfiRK7WeightsS0_Pf
	ldr	x8, [sp, #176]                  ; 8-byte Folded Reload
	cmp	w8, #1
	b.lt	LBB3_73
; %bb.61:                               ;   in Loop: Header=BB3_9 Depth=4
	cmp	w22, #1
	b.lt	LBB3_73
; %bb.62:                               ;   in Loop: Header=BB3_9 Depth=4
	cmp	w20, #0
	b.le	LBB3_84
; %bb.63:                               ;   in Loop: Header=BB3_9 Depth=4
	ldur	x8, [x29, #-216]
	cmp	w20, #4
	b.hs	LBB3_90
; %bb.64:                               ;   in Loop: Header=BB3_9 Depth=4
	mov	x9, #0                          ; =0x0
	add	x8, x8, #8
	lsl	x10, x26, #2
	mov	x11, x19
	mov	x12, x25
	ldr	x26, [sp, #176]                 ; 8-byte Folded Reload
LBB3_65:                                ;   Parent Loop BB3_1 Depth=1
                                        ;     Parent Loop BB3_3 Depth=2
                                        ;       Parent Loop BB3_6 Depth=3
                                        ;         Parent Loop BB3_9 Depth=4
                                        ; =>        This Loop Header: Depth=5
                                        ;             Child Loop BB3_66 Depth 6
	mul	x13, x9, x20
	ldr	x14, [sp, #280]                 ; 8-byte Folded Reload
	add	x13, x14, x13, lsl #2
	ldr	s0, [x13]
	fcvt	d0, s0
	mov	x14, x8
	mov	x15, x11
	mov	x16, x12
	mov	x17, x22
LBB3_66:                                ;   Parent Loop BB3_1 Depth=1
                                        ;     Parent Loop BB3_3 Depth=2
                                        ;       Parent Loop BB3_6 Depth=3
                                        ;         Parent Loop BB3_9 Depth=4
                                        ;           Parent Loop BB3_65 Depth=5
                                        ; =>          This Inner Loop Header: Depth=6
	ldur	s1, [x14, #-8]
	fcvt	d1, s1
	fmadd	d1, d0, d1, d9
	cmp	w20, #1
	b.eq	LBB3_69
; %bb.67:                               ;   in Loop: Header=BB3_66 Depth=6
	ldr	s2, [x13, #4]
	fcvt	d2, s2
	ldur	s3, [x14, #-4]
	fcvt	d3, s3
	fmadd	d1, d2, d3, d1
	cmp	w20, #2
	b.eq	LBB3_69
; %bb.68:                               ;   in Loop: Header=BB3_66 Depth=6
	ldr	s2, [x13, #8]
	fcvt	d2, s2
	ldr	s3, [x14]
	fcvt	d3, s3
	fmadd	d1, d2, d3, d1
LBB3_69:                                ;   in Loop: Header=BB3_66 Depth=6
	ldr	s2, [x15], #4
	fcvt	d3, s2
	fabd	d3, d3, d1
	fabs	d1, d1
	fadd	d1, d1, d10
	fmul	d1, d1, d11
	fcmp	d3, d1
	b.hi	LBB3_112
; %bb.70:                               ;   in Loop: Header=BB3_66 Depth=6
	ldr	s1, [x16], #4
	fcmp	s2, s1
	b.ne	LBB3_110
; %bb.71:                               ;   in Loop: Header=BB3_66 Depth=6
	add	x14, x14, x10
	subs	x17, x17, #1
	b.ne	LBB3_66
; %bb.72:                               ;   in Loop: Header=BB3_65 Depth=5
	add	x9, x9, #1
	ldr	x13, [sp, #288]                 ; 8-byte Folded Reload
	add	x12, x12, x13
	add	x11, x11, x13
	cmp	x9, x26
	b.ne	LBB3_65
	b	LBB3_106
LBB3_73:                                ;   in Loop: Header=BB3_9 Depth=4
	cbnz	x25, LBB3_106
; %bb.74:                               ;   in Loop: Header=BB3_9 Depth=4
	cbz	x19, LBB3_76
LBB3_75:                                ;   in Loop: Header=BB3_9 Depth=4
	mov	x0, x19
	bl	__ZdlPv
LBB3_76:                                ;   in Loop: Header=BB3_9 Depth=4
	ldr	x25, [sp, #152]                 ; 8-byte Folded Reload
	ldr	x0, [sp, #168]                  ; 8-byte Folded Reload
	cbz	x0, LBB3_78
; %bb.77:                               ;   in Loop: Header=BB3_9 Depth=4
	bl	__ZdlPv
LBB3_78:                                ;   in Loop: Header=BB3_9 Depth=4
	ldr	x19, [sp, #160]                 ; 8-byte Folded Reload
	ldr	x0, [sp, #280]                  ; 8-byte Folded Reload
	cbz	x0, LBB3_80
; %bb.79:                               ;   in Loop: Header=BB3_9 Depth=4
	bl	__ZdlPv
LBB3_80:                                ;   in Loop: Header=BB3_9 Depth=4
	ldr	x0, [sp, #184]                  ; 8-byte Folded Reload
	cbz	x0, LBB3_82
; %bb.81:                               ;   in Loop: Header=BB3_9 Depth=4
	bl	__ZdlPv
LBB3_82:                                ;   in Loop: Header=BB3_9 Depth=4
	ldur	x0, [x29, #-216]
	cbz	x0, LBB3_8
; %bb.83:                               ;   in Loop: Header=BB3_9 Depth=4
	bl	__ZdlPv
	b	LBB3_8
LBB3_84:                                ;   in Loop: Header=BB3_9 Depth=4
	mov	x8, #0                          ; =0x0
	mov	x9, x19
	mov	x10, x25
	mov	x14, #26865                     ; =0x68f1
	movk	x14, #35043, lsl #16
	movk	x14, #63669, lsl #32
	movk	x14, #16100, lsl #48
	ldr	x26, [sp, #176]                 ; 8-byte Folded Reload
LBB3_85:                                ;   Parent Loop BB3_1 Depth=1
                                        ;     Parent Loop BB3_3 Depth=2
                                        ;       Parent Loop BB3_6 Depth=3
                                        ;         Parent Loop BB3_9 Depth=4
                                        ; =>        This Loop Header: Depth=5
                                        ;             Child Loop BB3_86 Depth 6
	mov	x11, x22
	mov	x12, x9
	mov	x13, x10
LBB3_86:                                ;   Parent Loop BB3_1 Depth=1
                                        ;     Parent Loop BB3_3 Depth=2
                                        ;       Parent Loop BB3_6 Depth=3
                                        ;         Parent Loop BB3_9 Depth=4
                                        ;           Parent Loop BB3_85 Depth=5
                                        ; =>          This Inner Loop Header: Depth=6
	ldr	s0, [x12], #4
	fabs	s1, s0
	fcvt	d1, s1
	fmov	d2, x14
	fcmp	d1, d2
	b.hi	LBB3_112
; %bb.87:                               ;   in Loop: Header=BB3_86 Depth=6
	ldr	s1, [x13], #4
	fcmp	s0, s1
	b.ne	LBB3_110
; %bb.88:                               ;   in Loop: Header=BB3_86 Depth=6
	subs	x11, x11, #1
	b.ne	LBB3_86
; %bb.89:                               ;   in Loop: Header=BB3_85 Depth=5
	add	x8, x8, #1
	ldr	x11, [sp, #288]                 ; 8-byte Folded Reload
	add	x10, x10, x11
	add	x9, x9, x11
	cmp	x8, x26
	b.ne	LBB3_85
	b	LBB3_106
LBB3_90:                                ;   in Loop: Header=BB3_9 Depth=4
	mov	x9, #0                          ; =0x0
	ldr	x13, [sp, #280]                 ; 8-byte Folded Reload
	add	x10, x13, #32
	add	x11, x8, #32
	lsl	x12, x26, #2
	ldr	x26, [sp, #176]                 ; 8-byte Folded Reload
LBB3_91:                                ;   Parent Loop BB3_1 Depth=1
                                        ;     Parent Loop BB3_3 Depth=2
                                        ;       Parent Loop BB3_6 Depth=3
                                        ;         Parent Loop BB3_9 Depth=4
                                        ; =>        This Loop Header: Depth=5
                                        ;             Child Loop BB3_92 Depth 6
                                        ;               Child Loop BB3_95 Depth 7
                                        ;               Child Loop BB3_99 Depth 7
                                        ;               Child Loop BB3_101 Depth 7
	mov	x14, #0                         ; =0x0
	mul	x15, x9, x22
	mov	x16, x8
	mov	x17, x11
LBB3_92:                                ;   Parent Loop BB3_1 Depth=1
                                        ;     Parent Loop BB3_3 Depth=2
                                        ;       Parent Loop BB3_6 Depth=3
                                        ;         Parent Loop BB3_9 Depth=4
                                        ;           Parent Loop BB3_91 Depth=5
                                        ; =>          This Loop Header: Depth=6
                                        ;               Child Loop BB3_95 Depth 7
                                        ;               Child Loop BB3_99 Depth 7
                                        ;               Child Loop BB3_101 Depth 7
	cmp	w20, #16
	b.hs	LBB3_94
; %bb.93:                               ;   in Loop: Header=BB3_92 Depth=6
	mov	x1, #0                          ; =0x0
	movi.2d	v0, #0000000000000000
	b	LBB3_98
LBB3_94:                                ;   in Loop: Header=BB3_92 Depth=6
	movi.2d	v0, #0000000000000000
	mov	x0, x17
	mov	x1, x10
	mov	x2, x27
LBB3_95:                                ;   Parent Loop BB3_1 Depth=1
                                        ;     Parent Loop BB3_3 Depth=2
                                        ;       Parent Loop BB3_6 Depth=3
                                        ;         Parent Loop BB3_9 Depth=4
                                        ;           Parent Loop BB3_91 Depth=5
                                        ;             Parent Loop BB3_92 Depth=6
                                        ; =>            This Inner Loop Header: Depth=7
	ldp	q1, q2, [x1, #-32]
	ldp	q3, q4, [x1], #64
	fcvtl	v5.2d, v1.2s
	fcvtl2	v1.2d, v1.4s
	fcvtl	v6.2d, v2.2s
	fcvtl2	v2.2d, v2.4s
	fcvtl	v7.2d, v3.2s
	fcvtl2	v3.2d, v3.4s
	fcvtl	v16.2d, v4.2s
	fcvtl2	v4.2d, v4.4s
	ldp	q17, q18, [x0, #-32]
	ldp	q19, q20, [x0], #64
	fcvtl	v21.2d, v17.2s
	fcvtl2	v17.2d, v17.4s
	fcvtl	v22.2d, v18.2s
	fcvtl2	v18.2d, v18.4s
	fcvtl	v23.2d, v19.2s
	fcvtl2	v19.2d, v19.4s
	fcvtl	v24.2d, v20.2s
	fcvtl2	v20.2d, v20.4s
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
	fmul.2d	v4, v4, v20
	mov	d20, v4[1]
	fmul.2d	v16, v16, v24
	mov	d24, v16[1]
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
	fadd	d0, d0, d19
	fadd	d0, d0, d16
	fadd	d0, d0, d24
	fadd	d0, d0, d4
	fadd	d0, d0, d20
	subs	x2, x2, #16
	b.ne	LBB3_95
; %bb.96:                               ;   in Loop: Header=BB3_92 Depth=6
	cmp	x27, x20
	b.eq	LBB3_102
; %bb.97:                               ;   in Loop: Header=BB3_92 Depth=6
	mov	x1, x27
	mov	x0, x27
	ldur	x2, [x29, #-256]                ; 8-byte Folded Reload
	cbz	x2, LBB3_101
LBB3_98:                                ;   in Loop: Header=BB3_92 Depth=6
	ldur	x0, [x29, #-240]                ; 8-byte Folded Reload
	add	x0, x0, x1
	lsl	x2, x1, #2
	add	x1, x16, x2
	add	x2, x13, x2
LBB3_99:                                ;   Parent Loop BB3_1 Depth=1
                                        ;     Parent Loop BB3_3 Depth=2
                                        ;       Parent Loop BB3_6 Depth=3
                                        ;         Parent Loop BB3_9 Depth=4
                                        ;           Parent Loop BB3_91 Depth=5
                                        ;             Parent Loop BB3_92 Depth=6
                                        ; =>            This Inner Loop Header: Depth=7
	ldr	q1, [x2], #16
	fcvtl	v2.2d, v1.2s
	ldr	q3, [x1], #16
	fcvtl2	v1.2d, v1.4s
	fcvtl	v4.2d, v3.2s
	fcvtl2	v3.2d, v3.4s
	fmul.2d	v1, v1, v3
	mov	d3, v1[1]
	fmul.2d	v2, v2, v4
	mov	d4, v2[1]
	fadd	d0, d0, d2
	fadd	d0, d0, d4
	fadd	d0, d0, d1
	fadd	d0, d0, d3
	adds	x0, x0, #4
	b.ne	LBB3_99
; %bb.100:                              ;   in Loop: Header=BB3_92 Depth=6
	mov	x0, x28
	cmp	x28, x20
	b.eq	LBB3_102
LBB3_101:                               ;   Parent Loop BB3_1 Depth=1
                                        ;     Parent Loop BB3_3 Depth=2
                                        ;       Parent Loop BB3_6 Depth=3
                                        ;         Parent Loop BB3_9 Depth=4
                                        ;           Parent Loop BB3_91 Depth=5
                                        ;             Parent Loop BB3_92 Depth=6
                                        ; =>            This Inner Loop Header: Depth=7
	ldr	s1, [x13, x0, lsl #2]
	fcvt	d1, s1
	ldr	s2, [x16, x0, lsl #2]
	fcvt	d2, s2
	fmadd	d0, d1, d2, d0
	add	x0, x0, #1
	cmp	x20, x0
	b.ne	LBB3_101
LBB3_102:                               ;   in Loop: Header=BB3_92 Depth=6
	add	x0, x14, x15
	ldr	s1, [x19, x0, lsl #2]
	fcvt	d2, s1
	fabd	d2, d2, d0
	fabs	d0, d0
	fadd	d0, d0, d10
	fmul	d0, d0, d11
	fcmp	d2, d0
	b.hi	LBB3_112
; %bb.103:                              ;   in Loop: Header=BB3_92 Depth=6
	ldr	s0, [x25, x0, lsl #2]
	fcmp	s1, s0
	b.ne	LBB3_110
; %bb.104:                              ;   in Loop: Header=BB3_92 Depth=6
	add	x14, x14, #1
	add	x17, x17, x12
	add	x16, x16, x12
	cmp	x14, x22
	b.ne	LBB3_92
; %bb.105:                              ;   in Loop: Header=BB3_91 Depth=5
	add	x9, x9, #1
	ldur	x14, [x29, #-248]               ; 8-byte Folded Reload
	add	x10, x10, x14
	add	x13, x13, x14
	cmp	x9, x26
	b.ne	LBB3_91
LBB3_106:                               ;   in Loop: Header=BB3_9 Depth=4
	mov	x0, x25
	bl	__ZdlPv
	cbnz	x19, LBB3_75
	b	LBB3_76
LBB3_107:                               ;   in Loop: Header=BB3_1 Depth=1
	ldr	x9, [sp]                        ; 8-byte Folded Reload
	add	x9, x9, #4
	cmp	x9, #12
	sub	x10, x29, #152
	b.ne	LBB3_1
; %bb.108:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp33:
Lloh19:
	adrp	x1, l_.str.16@PAGE
Lloh20:
	add	x1, x1, l_.str.16@PAGEOFF
	bl	__ZNSt11logic_errorC2EPKc
Ltmp34:
; %bb.109:
Lloh21:
	adrp	x8, __ZTVSt16invalid_argument@GOTPAGE
Lloh22:
	ldr	x8, [x8, __ZTVSt16invalid_argument@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x19]
Ltmp36:
Lloh23:
	adrp	x1, __ZTISt16invalid_argument@GOTPAGE
Lloh24:
	ldr	x1, [x1, __ZTISt16invalid_argument@GOTPAGEOFF]
Lloh25:
	adrp	x2, __ZNSt16invalid_argumentD1Ev@GOTPAGE
Lloh26:
	ldr	x2, [x2, __ZNSt16invalid_argumentD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
Ltmp37:
	b	LBB3_357
LBB3_110:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x20, x0
Ltmp30:
Lloh27:
	adrp	x1, l_.str@PAGE
Lloh28:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp31:
; %bb.111:
	ldr	x23, [sp, #168]                 ; 8-byte Folded Reload
	b	LBB3_113
LBB3_112:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x20, x0
Ltmp233:
Lloh29:
	adrp	x1, l_.str@PAGE
Lloh30:
	add	x1, x1, l_.str@PAGEOFF
	ldr	x23, [sp, #168]                 ; 8-byte Folded Reload
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp234:
LBB3_113:
Ltmp236:
Lloh31:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh32:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh33:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh34:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x20
	bl	___cxa_throw
Ltmp237:
	b	LBB3_357
LBB3_114:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp239:
Lloh35:
	adrp	x1, l_.str.16@PAGE
Lloh36:
	add	x1, x1, l_.str.16@PAGEOFF
	bl	__ZNSt11logic_errorC2EPKc
Ltmp240:
; %bb.115:
Lloh37:
	adrp	x8, __ZTVSt16invalid_argument@GOTPAGE
Lloh38:
	ldr	x8, [x8, __ZTVSt16invalid_argument@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x19]
Ltmp242:
Lloh39:
	adrp	x1, __ZTISt16invalid_argument@GOTPAGE
Lloh40:
	ldr	x1, [x1, __ZTISt16invalid_argument@GOTPAGEOFF]
Lloh41:
	adrp	x2, __ZNSt16invalid_argumentD1Ev@GOTPAGE
Lloh42:
	ldr	x2, [x2, __ZNSt16invalid_argumentD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
Ltmp243:
	b	LBB3_357
LBB3_116:
Ltmp6:
	bl	__ZNSt3__16vectorIfNS_9allocatorIfEEE20__throw_length_errorB9nqe210106Ev
Ltmp7:
	b	LBB3_357
LBB3_117:
Ltmp27:
	bl	__ZNSt3__16vectorIfNS_9allocatorIfEEE20__throw_length_errorB9nqe210106Ev
Ltmp28:
	b	LBB3_357
LBB3_118:
Ltmp15:
	bl	__ZNSt3__16vectorIfNS_9allocatorIfEEE20__throw_length_errorB9nqe210106Ev
Ltmp16:
	b	LBB3_357
LBB3_119:
Ltmp38:
	mov	x21, x1
	mov	x22, x0
	b	LBB3_121
LBB3_120:
Ltmp35:
	mov	x21, x1
	mov	x22, x0
	mov	x0, x19
	bl	___cxa_free_exception
LBB3_121:
	cmp	w21, #2
	b.ne	LBB3_430
; %bb.122:
	mov	x0, x22
	bl	___cxa_begin_catch
Ltmp39:
	bl	___cxa_end_catch
Ltmp40:
; %bb.123:
Ltmp42:
Lloh43:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh44:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh45:
	adrp	x1, l_.str.2@PAGE
Lloh46:
	add	x1, x1, l_.str.2@PAGEOFF
	mov	w2, #11                         ; =0xb
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp43:
; %bb.124:
Ltmp44:
	mov	w1, #252                        ; =0xfc
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEi
Ltmp45:
; %bb.125:
Ltmp46:
Lloh47:
	adrp	x1, l_.str.3@PAGE
Lloh48:
	add	x1, x1, l_.str.3@PAGEOFF
	mov	w2, #51                         ; =0x33
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp47:
; %bb.126:
	str	xzr, [sp, #176]                 ; 8-byte Folded Spill
Lloh49:
	adrp	x8, lCPI3_4@PAGE
Lloh50:
	ldr	d0, [x8, lCPI3_4@PAGEOFF]
	stur	d0, [x29, #-160]
	fmov	d8, #5.00000000
Lloh51:
	adrp	x8, lCPI3_5@PAGE
Lloh52:
	ldr	d9, [x8, lCPI3_5@PAGEOFF]
	b	LBB3_128
LBB3_127:                               ;   in Loop: Header=BB3_128 Depth=1
	ldr	x8, [sp, #176]                  ; 8-byte Folded Reload
	add	x8, x8, #4
	str	x8, [sp, #176]                  ; 8-byte Folded Spill
	cmp	x8, #8
	b.eq	LBB3_343
LBB3_128:                               ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB3_149 Depth 2
                                        ;     Child Loop BB3_165 Depth 2
                                        ;     Child Loop BB3_184 Depth 2
                                        ;       Child Loop BB3_186 Depth 3
                                        ;         Child Loop BB3_194 Depth 4
                                        ;           Child Loop BB3_203 Depth 5
                                        ;           Child Loop BB3_199 Depth 5
                                        ;           Child Loop BB3_208 Depth 5
                                        ;           Child Loop BB3_212 Depth 5
                                        ;           Child Loop BB3_215 Depth 5
                                        ;     Child Loop BB3_231 Depth 2
                                        ;       Child Loop BB3_235 Depth 3
                                        ;       Child Loop BB3_237 Depth 3
                                        ;       Child Loop BB3_239 Depth 3
                                        ;       Child Loop BB3_242 Depth 3
                                        ;         Child Loop BB3_244 Depth 4
                                        ;         Child Loop BB3_246 Depth 4
                                        ;         Child Loop BB3_248 Depth 4
                                        ;         Child Loop BB3_250 Depth 4
                                        ;         Child Loop BB3_252 Depth 4
                                        ;       Child Loop BB3_269 Depth 3
                                        ;       Child Loop BB3_275 Depth 3
                                        ;       Child Loop BB3_281 Depth 3
                                        ;       Child Loop BB3_287 Depth 3
                                        ;         Child Loop BB3_289 Depth 4
                                        ;           Child Loop BB3_301 Depth 5
                                        ;             Child Loop BB3_310 Depth 6
                                        ;             Child Loop BB3_306 Depth 6
                                        ;             Child Loop BB3_315 Depth 6
                                        ;             Child Loop BB3_319 Depth 6
                                        ;             Child Loop BB3_322 Depth 6
                                        ;           Child Loop BB3_296 Depth 5
	ldr	x8, [sp, #176]                  ; 8-byte Folded Reload
	sub	x9, x29, #160
	ldr	w24, [x9, x8]
Ltmp49:
	sub	x0, x29, #232
	mov	x1, x24
	mov	w2, #257                        ; =0x101
	mov	w3, #264                        ; =0x108
	bl	__ZN7WeightsC2Eiii
Ltmp50:
; %bb.129:                              ;   in Loop: Header=BB3_128 Depth=1
Ltmp52:
	sub	x8, x29, #184
	bl	__Z4packRK7Weights
Ltmp53:
; %bb.130:                              ;   in Loop: Header=BB3_128 Depth=1
Ltmp55:
	mov	w0, #4112                       ; =0x1010
	bl	__Znwm
	str	x0, [sp, #288]                  ; 8-byte Folded Spill
Ltmp56:
; %bb.131:                              ;   in Loop: Header=BB3_128 Depth=1
	ldr	x0, [sp, #288]                  ; 8-byte Folded Reload
Lloh53:
	adrp	x1, l_.memset_pattern@PAGE
Lloh54:
	add	x1, x1, l_.memset_pattern@PAGEOFF
	mov	w2, #4112                       ; =0x1010
	bl	_memset_pattern16
	cbz	w24, LBB3_135
; %bb.132:                              ;   in Loop: Header=BB3_128 Depth=1
	tbnz	w24, #31, LBB3_345
; %bb.133:                              ;   in Loop: Header=BB3_128 Depth=1
	lsl	w8, w24, #2
	lsl	x25, x8, #2
Ltmp58:
	mov	x0, x25
	bl	__Znwm
Ltmp59:
; %bb.134:                              ;   in Loop: Header=BB3_128 Depth=1
	mov	x20, x0
	mov	x1, x25
	bl	_bzero
	b	LBB3_136
LBB3_135:                               ;   in Loop: Header=BB3_128 Depth=1
	mov	x20, #0                         ; =0x0
LBB3_136:                               ;   in Loop: Header=BB3_128 Depth=1
Ltmp64:
Lloh55:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh56:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh57:
	adrp	x1, l_.str.4@PAGE
Lloh58:
	add	x1, x1, l_.str.4@PAGEOFF
	mov	w2, #2                          ; =0x2
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp65:
; %bb.137:                              ;   in Loop: Header=BB3_128 Depth=1
Ltmp66:
	mov	w1, #4                          ; =0x4
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEi
Ltmp67:
; %bb.138:                              ;   in Loop: Header=BB3_128 Depth=1
Ltmp68:
Lloh59:
	adrp	x1, l_.str.5@PAGE
Lloh60:
	add	x1, x1, l_.str.5@PAGEOFF
	mov	w2, #3                          ; =0x3
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp69:
; %bb.139:                              ;   in Loop: Header=BB3_128 Depth=1
Ltmp70:
	mov	x1, x24
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEi
Ltmp71:
; %bb.140:                              ;   in Loop: Header=BB3_128 Depth=1
Ltmp72:
Lloh61:
	adrp	x1, l_.str.6@PAGE
Lloh62:
	add	x1, x1, l_.str.6@PAGEOFF
	mov	w2, #3                          ; =0x3
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp73:
; %bb.141:                              ;   in Loop: Header=BB3_128 Depth=1
Ltmp74:
	mov	w1, #257                        ; =0x101
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEi
Ltmp75:
; %bb.142:                              ;   in Loop: Header=BB3_128 Depth=1
Ltmp76:
Lloh63:
	adrp	x1, l_.str.7@PAGE
Lloh64:
	add	x1, x1, l_.str.7@PAGEOFF
	mov	w2, #8                          ; =0x8
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp77:
; %bb.143:                              ;   in Loop: Header=BB3_128 Depth=1
	ldur	w1, [x29, #-224]
Ltmp78:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEi
Ltmp79:
; %bb.144:                              ;   in Loop: Header=BB3_128 Depth=1
Ltmp80:
Lloh65:
	adrp	x1, l_.str.8@PAGE
Lloh66:
	add	x1, x1, l_.str.8@PAGEOFF
	mov	w2, #14                         ; =0xe
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp81:
; %bb.145:                              ;   in Loop: Header=BB3_128 Depth=1
	ldp	x9, x8, [x29, #-184]
	sub	x1, x8, x9
Ltmp82:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp83:
; %bb.146:                              ;   in Loop: Header=BB3_128 Depth=1
	mov	w8, #10                         ; =0xa
	sturb	w8, [x29, #-152]
Ltmp84:
	sub	x1, x29, #152
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp85:
; %bb.147:                              ;   in Loop: Header=BB3_128 Depth=1
	sub	x2, x29, #232
	ldr	x19, [sp, #288]                 ; 8-byte Folded Reload
	mov	x0, x19
	mov	w1, #4                          ; =0x4
	mov	x3, #0                          ; =0x0
	mov	x4, x20
	bl	__Z7computePKfiRK7WeightsS0_Pf
	ldr	s0, [x20]
	fcvt	d0, s0
	adrp	x21, _sink@PAGE
	ldr	d1, [x21, _sink@PAGEOFF]
	fadd	d0, d1, d0
	str	d0, [x21, _sink@PAGEOFF]
	sub	x2, x29, #232
	mov	x0, x19
	mov	w1, #4                          ; =0x4
	mov	x3, #0                          ; =0x0
	mov	x4, x20
	bl	__Z7computePKfiRK7WeightsS0_Pf
	ldr	s0, [x20]
	fcvt	d0, s0
	ldr	d1, [x21, _sink@PAGEOFF]
	fadd	d0, d1, d0
	str	d0, [x21, _sink@PAGEOFF]
	sub	x2, x29, #232
	mov	x0, x19
	mov	w1, #4                          ; =0x4
	mov	x3, #0                          ; =0x0
	mov	x4, x20
	bl	__Z7computePKfiRK7WeightsS0_Pf
	mov	x25, #0                         ; =0x0
	mov	x24, #0                         ; =0x0
	mov	x22, #0                         ; =0x0
	ldr	s0, [x20]
	fcvt	d0, s0
	ldr	d1, [x21, _sink@PAGEOFF]
	fadd	d0, d1, d0
	str	d0, [x21, _sink@PAGEOFF]
	mov	w21, #21                        ; =0x15
	b	LBB3_149
LBB3_148:                               ;   in Loop: Header=BB3_149 Depth=2
	str	d10, [x24], #8
	subs	w21, w21, #1
	b.eq	LBB3_156
LBB3_149:                               ;   Parent Loop BB3_128 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x26, x0
	sub	x2, x29, #232
	ldr	x19, [sp, #288]                 ; 8-byte Folded Reload
	mov	x0, x19
	mov	w1, #4                          ; =0x4
	mov	x3, #0                          ; =0x0
	mov	x4, x20
	bl	__Z7computePKfiRK7WeightsS0_Pf
	ldr	s0, [x20]
	fcvt	d0, s0
	adrp	x23, _sink@PAGE
	ldr	d1, [x23, _sink@PAGEOFF]
	fadd	d0, d1, d0
	str	d0, [x23, _sink@PAGEOFF]
	sub	x2, x29, #232
	mov	x0, x19
	mov	w1, #4                          ; =0x4
	mov	x3, #0                          ; =0x0
	mov	x4, x20
	bl	__Z7computePKfiRK7WeightsS0_Pf
	ldr	s0, [x20]
	fcvt	d0, s0
	ldr	d1, [x23, _sink@PAGEOFF]
	fadd	d0, d1, d0
	str	d0, [x23, _sink@PAGEOFF]
	sub	x2, x29, #232
	mov	x0, x19
	mov	w1, #4                          ; =0x4
	mov	x3, #0                          ; =0x0
	mov	x4, x20
	bl	__Z7computePKfiRK7WeightsS0_Pf
	ldr	s0, [x20]
	fcvt	d0, s0
	ldr	d1, [x23, _sink@PAGEOFF]
	fadd	d0, d1, d0
	str	d0, [x23, _sink@PAGEOFF]
	sub	x2, x29, #232
	mov	x0, x19
	mov	w1, #4                          ; =0x4
	mov	x3, #0                          ; =0x0
	mov	x4, x20
	bl	__Z7computePKfiRK7WeightsS0_Pf
	ldr	s0, [x20]
	fcvt	d0, s0
	ldr	d1, [x23, _sink@PAGEOFF]
	fadd	d0, d1, d0
	str	d0, [x23, _sink@PAGEOFF]
	sub	x2, x29, #232
	mov	x0, x19
	mov	w1, #4                          ; =0x4
	mov	x3, #0                          ; =0x0
	mov	x4, x20
	bl	__Z7computePKfiRK7WeightsS0_Pf
	ldr	s0, [x20]
	fcvt	d0, s0
	ldr	d1, [x23, _sink@PAGEOFF]
	fadd	d0, d1, d0
	str	d0, [x23, _sink@PAGEOFF]
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	sub	x8, x0, x26
	scvtf	d0, x8
	mov	x8, #70368744177664             ; =0x400000000000
	movk	x8, #16527, lsl #48
	fmov	d1, x8
	fdiv	d0, d0, d1
	fdiv	d10, d0, d8
	cmp	x24, x22
	b.lo	LBB3_148
; %bb.150:                              ;   in Loop: Header=BB3_149 Depth=2
	sub	x26, x24, x25
	asr	x27, x26, #3
	add	x8, x27, #1
	lsr	x9, x8, #61
	cbnz	x9, LBB3_346
; %bb.151:                              ;   in Loop: Header=BB3_149 Depth=2
	sub	x9, x22, x25
	asr	x10, x9, #2
	cmp	x10, x8
	csel	x8, x10, x8, hi
	mov	x10, #9223372036854775800       ; =0x7ffffffffffffff8
	cmp	x9, x10
	mov	x9, #2305843009213693951        ; =0x1fffffffffffffff
	csel	x19, x8, x9, lo
	lsr	x8, x19, #61
	cbnz	x8, LBB3_347
; %bb.152:                              ;   in Loop: Header=BB3_149 Depth=2
	lsl	x0, x19, #3
Ltmp86:
	bl	__Znwm
Ltmp87:
; %bb.153:                              ;   in Loop: Header=BB3_149 Depth=2
	add	x24, x0, x26
	add	x22, x0, x19, lsl #3
	sub	x27, x24, x27, lsl #3
	str	d10, [x24], #8
	mov	x0, x27
	mov	x1, x25
	mov	x2, x26
	bl	_memcpy
	cbz	x25, LBB3_155
; %bb.154:                              ;   in Loop: Header=BB3_149 Depth=2
	mov	x0, x25
	bl	__ZdlPv
LBB3_155:                               ;   in Loop: Header=BB3_149 Depth=2
	mov	x25, x27
	subs	w21, w21, #1
	b.ne	LBB3_149
LBB3_156:                               ;   in Loop: Header=BB3_128 Depth=1
Ltmp94:
	sub	x2, x29, #152
	mov	x0, x25
	mov	x1, x24
	bl	__ZNSt3__16__sortIRNS_6__lessIddEEPdEEvT0_S5_T_
Ltmp95:
; %bb.157:                              ;   in Loop: Header=BB3_128 Depth=1
Ltmp96:
Lloh67:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh68:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh69:
	adrp	x1, l_.str.9@PAGE
Lloh70:
	add	x1, x1, l_.str.9@PAGEOFF
	mov	w2, #6                          ; =0x6
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp97:
; %bb.158:                              ;   in Loop: Header=BB3_128 Depth=1
Ltmp98:
Lloh71:
	adrp	x1, l_.str.19@PAGE
Lloh72:
	add	x1, x1, l_.str.19@PAGEOFF
	mov	w2, #23                         ; =0x17
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp99:
; %bb.159:                              ;   in Loop: Header=BB3_128 Depth=1
	ldr	d0, [x25, #80]
Ltmp100:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp101:
; %bb.160:                              ;   in Loop: Header=BB3_128 Depth=1
Ltmp102:
Lloh73:
	adrp	x1, l_.str.20@PAGE
Lloh74:
	add	x1, x1, l_.str.20@PAGEOFF
	mov	w2, #5                          ; =0x5
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp103:
; %bb.161:                              ;   in Loop: Header=BB3_128 Depth=1
	ldr	d0, [x25, #152]
Ltmp104:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp105:
; %bb.162:                              ;   in Loop: Header=BB3_128 Depth=1
	mov	w8, #10                         ; =0xa
	sturb	w8, [x29, #-152]
Ltmp106:
	sub	x1, x29, #152
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp107:
; %bb.163:                              ;   in Loop: Header=BB3_128 Depth=1
	mov	x0, x25
	bl	__ZdlPv
	ldur	x21, [x29, #-184]
	sub	x2, x29, #232
	ldr	x19, [sp, #288]                 ; 8-byte Folded Reload
	mov	x0, x19
	mov	w1, #4                          ; =0x4
	mov	x3, x21
	mov	x4, x20
	bl	__Z7computePKfiRK7WeightsS0_Pf
	ldr	s0, [x20]
	fcvt	d0, s0
	ldr	d1, [x23, _sink@PAGEOFF]
	fadd	d0, d1, d0
	str	d0, [x23, _sink@PAGEOFF]
	sub	x2, x29, #232
	mov	x0, x19
	mov	w1, #4                          ; =0x4
	mov	x3, x21
	mov	x4, x20
	bl	__Z7computePKfiRK7WeightsS0_Pf
	ldr	s0, [x20]
	fcvt	d0, s0
	ldr	d1, [x23, _sink@PAGEOFF]
	fadd	d0, d1, d0
	str	d0, [x23, _sink@PAGEOFF]
	sub	x2, x29, #232
	mov	x0, x19
	mov	w1, #4                          ; =0x4
	mov	x3, x21
	mov	x4, x20
	bl	__Z7computePKfiRK7WeightsS0_Pf
	mov	x25, #0                         ; =0x0
	mov	x24, #0                         ; =0x0
	mov	x22, #0                         ; =0x0
	ldr	s0, [x20]
	fcvt	d0, s0
	ldr	d1, [x23, _sink@PAGEOFF]
	fadd	d0, d1, d0
	str	d0, [x23, _sink@PAGEOFF]
	mov	w21, #21                        ; =0x15
	b	LBB3_165
LBB3_164:                               ;   in Loop: Header=BB3_165 Depth=2
	str	d10, [x24], #8
	subs	w21, w21, #1
	b.eq	LBB3_172
LBB3_165:                               ;   Parent Loop BB3_128 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x26, x0
	ldur	x27, [x29, #-184]
	sub	x2, x29, #232
	ldr	x19, [sp, #288]                 ; 8-byte Folded Reload
	mov	x0, x19
	mov	w1, #4                          ; =0x4
	mov	x3, x27
	mov	x4, x20
	bl	__Z7computePKfiRK7WeightsS0_Pf
	ldr	s0, [x20]
	fcvt	d0, s0
	adrp	x23, _sink@PAGE
	ldr	d1, [x23, _sink@PAGEOFF]
	fadd	d0, d1, d0
	str	d0, [x23, _sink@PAGEOFF]
	sub	x2, x29, #232
	mov	x0, x19
	mov	w1, #4                          ; =0x4
	mov	x3, x27
	mov	x4, x20
	bl	__Z7computePKfiRK7WeightsS0_Pf
	ldr	s0, [x20]
	fcvt	d0, s0
	ldr	d1, [x23, _sink@PAGEOFF]
	fadd	d0, d1, d0
	str	d0, [x23, _sink@PAGEOFF]
	sub	x2, x29, #232
	mov	x0, x19
	mov	w1, #4                          ; =0x4
	mov	x3, x27
	mov	x4, x20
	bl	__Z7computePKfiRK7WeightsS0_Pf
	ldr	s0, [x20]
	fcvt	d0, s0
	ldr	d1, [x23, _sink@PAGEOFF]
	fadd	d0, d1, d0
	str	d0, [x23, _sink@PAGEOFF]
	sub	x2, x29, #232
	mov	x0, x19
	mov	w1, #4                          ; =0x4
	mov	x3, x27
	mov	x4, x20
	bl	__Z7computePKfiRK7WeightsS0_Pf
	ldr	s0, [x20]
	fcvt	d0, s0
	ldr	d1, [x23, _sink@PAGEOFF]
	fadd	d0, d1, d0
	str	d0, [x23, _sink@PAGEOFF]
	sub	x2, x29, #232
	mov	x0, x19
	mov	w1, #4                          ; =0x4
	mov	x3, x27
	mov	x4, x20
	bl	__Z7computePKfiRK7WeightsS0_Pf
	ldr	s0, [x20]
	fcvt	d0, s0
	ldr	d1, [x23, _sink@PAGEOFF]
	fadd	d0, d1, d0
	str	d0, [x23, _sink@PAGEOFF]
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	sub	x8, x0, x26
	scvtf	d0, x8
	mov	x8, #70368744177664             ; =0x400000000000
	movk	x8, #16527, lsl #48
	fmov	d1, x8
	fdiv	d0, d0, d1
	fdiv	d10, d0, d8
	cmp	x24, x22
	b.lo	LBB3_164
; %bb.166:                              ;   in Loop: Header=BB3_165 Depth=2
	sub	x26, x24, x25
	asr	x27, x26, #3
	add	x8, x27, #1
	lsr	x9, x8, #61
	cbnz	x9, LBB3_348
; %bb.167:                              ;   in Loop: Header=BB3_165 Depth=2
	sub	x9, x22, x25
	asr	x10, x9, #2
	cmp	x10, x8
	csel	x8, x10, x8, hi
	mov	x10, #9223372036854775800       ; =0x7ffffffffffffff8
	cmp	x9, x10
	mov	x9, #2305843009213693951        ; =0x1fffffffffffffff
	csel	x19, x8, x9, lo
	lsr	x8, x19, #61
	cbnz	x8, LBB3_349
; %bb.168:                              ;   in Loop: Header=BB3_165 Depth=2
	lsl	x0, x19, #3
Ltmp109:
	bl	__Znwm
Ltmp110:
; %bb.169:                              ;   in Loop: Header=BB3_165 Depth=2
	add	x24, x0, x26
	add	x22, x0, x19, lsl #3
	sub	x27, x24, x27, lsl #3
	str	d10, [x24], #8
	mov	x0, x27
	mov	x1, x25
	mov	x2, x26
	bl	_memcpy
	cbz	x25, LBB3_171
; %bb.170:                              ;   in Loop: Header=BB3_165 Depth=2
	mov	x0, x25
	bl	__ZdlPv
LBB3_171:                               ;   in Loop: Header=BB3_165 Depth=2
	mov	x25, x27
	subs	w21, w21, #1
	b.ne	LBB3_165
LBB3_172:                               ;   in Loop: Header=BB3_128 Depth=1
Ltmp117:
	sub	x2, x29, #152
	mov	x0, x25
	mov	x1, x24
	bl	__ZNSt3__16__sortIRNS_6__lessIddEEPdEEvT0_S5_T_
Ltmp118:
; %bb.173:                              ;   in Loop: Header=BB3_128 Depth=1
Ltmp119:
Lloh75:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh76:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh77:
	adrp	x1, l_.str.10@PAGE
Lloh78:
	add	x1, x1, l_.str.10@PAGEOFF
	mov	w2, #13                         ; =0xd
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp120:
; %bb.174:                              ;   in Loop: Header=BB3_128 Depth=1
Ltmp121:
Lloh79:
	adrp	x1, l_.str.19@PAGE
Lloh80:
	add	x1, x1, l_.str.19@PAGEOFF
	mov	w2, #23                         ; =0x17
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp122:
; %bb.175:                              ;   in Loop: Header=BB3_128 Depth=1
	ldr	d0, [x25, #80]
Ltmp123:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp124:
; %bb.176:                              ;   in Loop: Header=BB3_128 Depth=1
Ltmp125:
Lloh81:
	adrp	x1, l_.str.20@PAGE
Lloh82:
	add	x1, x1, l_.str.20@PAGEOFF
	mov	w2, #5                          ; =0x5
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp126:
; %bb.177:                              ;   in Loop: Header=BB3_128 Depth=1
	ldr	d0, [x25, #152]
Ltmp127:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp128:
; %bb.178:                              ;   in Loop: Header=BB3_128 Depth=1
	mov	w8, #10                         ; =0xa
	sturb	w8, [x29, #-152]
Ltmp129:
	sub	x1, x29, #152
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp130:
; %bb.179:                              ;   in Loop: Header=BB3_128 Depth=1
	mov	x0, x25
	bl	__ZdlPv
Ltmp132:
	sub	x8, x29, #152
	sub	x0, x29, #232
	bl	__Z4packRK7Weights
Ltmp133:
; %bb.180:                              ;   in Loop: Header=BB3_128 Depth=1
	ldur	x0, [x29, #-152]
	ldr	s0, [x0]
	fcvt	d0, s0
	adrp	x8, _sink@PAGE
	ldr	d1, [x8, _sink@PAGEOFF]
	fadd	d0, d1, d0
	str	d0, [x8, _sink@PAGEOFF]
	bl	__ZdlPv
Ltmp134:
	sub	x8, x29, #152
	sub	x0, x29, #232
	bl	__Z4packRK7Weights
Ltmp135:
; %bb.181:                              ;   in Loop: Header=BB3_128 Depth=1
	ldur	x0, [x29, #-152]
	ldr	s0, [x0]
	fcvt	d0, s0
	adrp	x8, _sink@PAGE
	ldr	d1, [x8, _sink@PAGEOFF]
	fadd	d0, d1, d0
	str	d0, [x8, _sink@PAGEOFF]
	bl	__ZdlPv
Ltmp136:
	sub	x8, x29, #152
	sub	x0, x29, #232
	bl	__Z4packRK7Weights
Ltmp137:
; %bb.182:                              ;   in Loop: Header=BB3_128 Depth=1
	ldur	x0, [x29, #-152]
	ldr	s0, [x0]
	fcvt	d0, s0
	adrp	x8, _sink@PAGE
	ldr	d1, [x8, _sink@PAGEOFF]
	fadd	d0, d1, d0
	str	d0, [x8, _sink@PAGEOFF]
	bl	__ZdlPv
	str	wzr, [sp, #208]                 ; 4-byte Folded Spill
	str	xzr, [sp, #240]                 ; 8-byte Folded Spill
	str	xzr, [sp, #256]                 ; 8-byte Folded Spill
	str	xzr, [sp, #224]                 ; 8-byte Folded Spill
	b	LBB3_184
LBB3_183:                               ;   in Loop: Header=BB3_184 Depth=2
	ldr	x8, [sp, #256]                  ; 8-byte Folded Reload
	str	d10, [x8], #8
	str	x8, [sp, #256]                  ; 8-byte Folded Spill
	ldr	w8, [sp, #208]                  ; 4-byte Folded Reload
	add	w8, w8, #1
	str	w8, [sp, #208]                  ; 4-byte Folded Spill
	cmp	w8, #21
	b.eq	LBB3_223
LBB3_184:                               ;   Parent Loop BB3_128 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB3_186 Depth 3
                                        ;         Child Loop BB3_194 Depth 4
                                        ;           Child Loop BB3_203 Depth 5
                                        ;           Child Loop BB3_199 Depth 5
                                        ;           Child Loop BB3_208 Depth 5
                                        ;           Child Loop BB3_212 Depth 5
                                        ;           Child Loop BB3_215 Depth 5
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	str	x0, [sp, #192]                  ; 8-byte Folded Spill
	mov	w22, #0                         ; =0x0
	b	LBB3_186
LBB3_185:                               ;   in Loop: Header=BB3_186 Depth=3
	ldr	s0, [x21]
	fcvt	d0, s0
	adrp	x8, _sink@PAGE
	ldr	d1, [x8, _sink@PAGEOFF]
	fadd	d0, d1, d0
	str	d0, [x8, _sink@PAGEOFF]
	mov	x0, x21
	bl	__ZdlPv
	add	w22, w22, #1
	cmp	w22, #5
	b.eq	LBB3_216
LBB3_186:                               ;   Parent Loop BB3_128 Depth=1
                                        ;     Parent Loop BB3_184 Depth=2
                                        ; =>    This Loop Header: Depth=3
                                        ;         Child Loop BB3_194 Depth 4
                                        ;           Child Loop BB3_203 Depth 5
                                        ;           Child Loop BB3_199 Depth 5
                                        ;           Child Loop BB3_208 Depth 5
                                        ;           Child Loop BB3_212 Depth 5
                                        ;           Child Loop BB3_215 Depth 5
	ldp	w25, w26, [x29, #-232]
                                        ; kill: def $w26 killed $w26 def $x26
	sxtw	x26, w26
	adds	w8, w25, #3
	add	w9, w25, #6
	csel	w8, w9, w8, lt
	asr	w8, w8, #2
	smull	x8, w26, w8
	cbz	x8, LBB3_190
; %bb.187:                              ;   in Loop: Header=BB3_186 Depth=3
	tst	x8, #0x3000000000000000
	b.ne	LBB3_350
; %bb.188:                              ;   in Loop: Header=BB3_186 Depth=3
	lsl	x28, x8, #4
Ltmp142:
	mov	x0, x28
	bl	__Znwm
Ltmp143:
; %bb.189:                              ;   in Loop: Header=BB3_186 Depth=3
	mov	x21, x0
	mov	x1, x28
	bl	_bzero
	b	LBB3_191
LBB3_190:                               ;   in Loop: Header=BB3_186 Depth=3
	mov	x21, #0                         ; =0x0
LBB3_191:                               ;   in Loop: Header=BB3_186 Depth=3
	cmp	w25, #1
	ccmp	w26, #1, #8, ge
	b.lt	LBB3_185
; %bb.192:                              ;   in Loop: Header=BB3_186 Depth=3
	mov	x8, #0                          ; =0x0
	mov	x9, #0                          ; =0x0
	mov	x10, #0                         ; =0x0
	ldursw	x11, [x29, #-224]
	ldur	x14, [x29, #-216]
	add	x13, x21, #4
	sub	x7, x26, #1
	lsl	x15, x26, #4
	lsl	x12, x25, #2
	sub	x12, x12, #4
	and	x2, x12, #0xfffffffffffffff0
	madd	x16, x2, x26, x21
	add	x3, x16, x26, lsl #4
	mov	w16, #12                        ; =0xc
	smaddl	x16, w11, w16, x14
	orr	x12, x12, #0xc
	lsl	x17, x26, #2
	madd	x12, x12, x11, x14
	add	x0, x14, x11, lsl #3
	orr	x1, x2, #0x8
	madd	x4, x1, x11, x14
	add	x1, x14, x11, lsl #2
	orr	x5, x2, #0x4
	madd	x5, x5, x11, x14
	madd	x6, x2, x11, x14
	lsl	x2, x7, #4
	stp	x2, x7, [x29, #-248]            ; 16-byte Folded Spill
	add	x12, x12, x17
	cmp	x21, x12
	ccmp	x16, x3, #2, lo
	cset	w12, lo
	add	x4, x4, x17
	cmp	x21, x4
	ccmp	x0, x3, #2, lo
	ccmp	x11, #0, #8, hs
	csinc	w12, w12, wzr, ge
	add	x4, x5, x17
	cmp	x21, x4
	ccmp	x1, x3, #2, lo
	csinc	w12, w12, wzr, hs
	add	x4, x6, x17
	cmp	x21, x4
	ccmp	x14, x3, #2, lo
	csinc	w12, w12, wzr, hs
	stur	w12, [x29, #-256]               ; 4-byte Folded Spill
	and	x12, x26, #0x7ffffffc
	str	x12, [sp, #280]                 ; 8-byte Folded Spill
	and	x12, x26, #0x7ffffffe
	neg	x5, x12
	add	x6, x21, #16
	add	x7, x14, #4
	lsl	x28, x11, #4
	and	x30, x17, #0x1fffffff0
	add	x23, x21, #8
	mov	x24, x21
	mov	x3, x14
	str	w22, [sp, #296]                 ; 4-byte Folded Spill
	b	LBB3_194
LBB3_193:                               ;   in Loop: Header=BB3_194 Depth=4
	add	x10, x10, #4
	add	x9, x9, #1
	add	x6, x6, x15
	add	x7, x7, x28
	add	x3, x3, x28
	add	x13, x13, x15
	add	x0, x0, x28
	add	x1, x1, x28
	add	x16, x16, x28
	add	x24, x24, x15
	add	x8, x8, x26
	cmp	x10, x25
	b.hs	LBB3_185
LBB3_194:                               ;   Parent Loop BB3_128 Depth=1
                                        ;     Parent Loop BB3_184 Depth=2
                                        ;       Parent Loop BB3_186 Depth=3
                                        ; =>      This Loop Header: Depth=4
                                        ;           Child Loop BB3_203 Depth 5
                                        ;           Child Loop BB3_199 Depth 5
                                        ;           Child Loop BB3_208 Depth 5
                                        ;           Child Loop BB3_212 Depth 5
                                        ;           Child Loop BB3_215 Depth 5
	orr	x12, x10, #0x1
	cmp	x12, x25
	b.hs	LBB3_200
; %bb.195:                              ;   in Loop: Header=BB3_194 Depth=4
	orr	x19, x10, #0x2
	mov	x4, x13
	mov	x12, x3
	mov	x27, x26
	cmp	x19, x25
	b.hs	LBB3_199
; %bb.196:                              ;   in Loop: Header=BB3_194 Depth=4
	orr	x12, x10, #0x3
	cmp	x12, x25
	b.hs	LBB3_207
; %bb.197:                              ;   in Loop: Header=BB3_194 Depth=4
	cmp	w26, #16
	b.hs	LBB3_209
; %bb.198:                              ;   in Loop: Header=BB3_194 Depth=4
	mov	x4, #0                          ; =0x0
	b	LBB3_214
LBB3_199:                               ;   Parent Loop BB3_128 Depth=1
                                        ;     Parent Loop BB3_184 Depth=2
                                        ;       Parent Loop BB3_186 Depth=3
                                        ;         Parent Loop BB3_194 Depth=4
                                        ; =>        This Inner Loop Header: Depth=5
	ldr	s0, [x12]
	stur	s0, [x4, #-4]
	ldr	s0, [x12, x11, lsl #2]
	str	s0, [x4], #16
	add	x12, x12, #4
	subs	x27, x27, #1
	b.ne	LBB3_199
	b	LBB3_193
LBB3_200:                               ;   in Loop: Header=BB3_194 Depth=4
	cmp	w26, #1
	b.ne	LBB3_202
; %bb.201:                              ;   in Loop: Header=BB3_194 Depth=4
	mov	x12, #0                         ; =0x0
	b	LBB3_205
LBB3_202:                               ;   in Loop: Header=BB3_194 Depth=4
	mov	x4, #0                          ; =0x0
	mov	x12, x7
	mov	x19, x6
LBB3_203:                               ;   Parent Loop BB3_128 Depth=1
                                        ;     Parent Loop BB3_184 Depth=2
                                        ;       Parent Loop BB3_186 Depth=3
                                        ;         Parent Loop BB3_194 Depth=4
                                        ; =>        This Inner Loop Header: Depth=5
	ldur	s0, [x12, #-4]
	stur	s0, [x19, #-16]
	ldr	s0, [x12], #8
	str	s0, [x19], #32
	sub	x4, x4, #2
	cmp	x5, x4
	b.ne	LBB3_203
; %bb.204:                              ;   in Loop: Header=BB3_194 Depth=4
	neg	x12, x4
LBB3_205:                               ;   in Loop: Header=BB3_194 Depth=4
	tbz	w26, #0, LBB3_193
; %bb.206:                              ;   in Loop: Header=BB3_194 Depth=4
	lsr	x2, x10, #2
	mul	x2, x2, x26
	mul	x4, x10, x11
	add	x4, x14, x4, lsl #2
	add	x2, x12, x2
	ldr	s0, [x4, x12, lsl #2]
	lsl	x12, x2, #4
	str	s0, [x21, x12]
	b	LBB3_193
LBB3_207:                               ;   in Loop: Header=BB3_194 Depth=4
	mov	x12, #0                         ; =0x0
	mov	x4, x13
LBB3_208:                               ;   Parent Loop BB3_128 Depth=1
                                        ;     Parent Loop BB3_184 Depth=2
                                        ;       Parent Loop BB3_186 Depth=3
                                        ;         Parent Loop BB3_194 Depth=4
                                        ; =>        This Inner Loop Header: Depth=5
	ldr	s0, [x3, x12]
	stur	s0, [x4, #-4]
	ldr	s0, [x1, x12]
	str	s0, [x4]
	ldr	s0, [x0, x12]
	str	s0, [x4, #4]
	add	x12, x12, #4
	add	x4, x4, #16
	cmp	x17, x12
	b.ne	LBB3_208
	b	LBB3_193
LBB3_209:                               ;   in Loop: Header=BB3_194 Depth=4
	mov	x22, x23
	madd	x12, x15, x9, x21
	add	x4, x12, #4
	add	x19, x12, #8
	add	x12, x12, #12
	ldur	x23, [x29, #-248]               ; 8-byte Folded Reload
	add	x27, x4, x23
	add	x2, x19, x23
	cmp	x2, x19
	ccmp	x27, x4, #0, hs
	cset	w2, lo
	ldur	x4, [x29, #-240]                ; 8-byte Folded Reload
	tst	x4, #0xf000000000000000
	csinc	w2, w2, wzr, eq
	add	x4, x12, x23
	cmp	x4, x12
	csinc	w12, w2, wzr, hs
	ldur	w2, [x29, #-256]                ; 4-byte Folded Reload
	mov	x4, #0                          ; =0x0
	orr	w12, w12, w2
	tbz	w12, #0, LBB3_211
; %bb.210:                              ;   in Loop: Header=BB3_194 Depth=4
	mov	x23, x22
	ldr	w22, [sp, #296]                 ; 4-byte Folded Reload
	b	LBB3_214
LBB3_211:                               ;   in Loop: Header=BB3_194 Depth=4
	mov	x12, x24
	mov	x23, x22
LBB3_212:                               ;   Parent Loop BB3_128 Depth=1
                                        ;     Parent Loop BB3_184 Depth=2
                                        ;       Parent Loop BB3_186 Depth=3
                                        ;         Parent Loop BB3_194 Depth=4
                                        ; =>        This Inner Loop Header: Depth=5
	ldr	q0, [x3, x4]
	ldr	q1, [x1, x4]
	ldr	q2, [x0, x4]
	ldr	q3, [x16, x4]
	st4.4s	{ v0, v1, v2, v3 }, [x12], #64
	add	x4, x4, #16
	cmp	x30, x4
	b.ne	LBB3_212
; %bb.213:                              ;   in Loop: Header=BB3_194 Depth=4
	ldr	x12, [sp, #280]                 ; 8-byte Folded Reload
	mov	x4, x12
	cmp	x12, x26
	ldr	w22, [sp, #296]                 ; 4-byte Folded Reload
	b.eq	LBB3_193
LBB3_214:                               ;   in Loop: Header=BB3_194 Depth=4
	add	x12, x4, x8
	add	x12, x23, x12, lsl #4
LBB3_215:                               ;   Parent Loop BB3_128 Depth=1
                                        ;     Parent Loop BB3_184 Depth=2
                                        ;       Parent Loop BB3_186 Depth=3
                                        ;         Parent Loop BB3_194 Depth=4
                                        ; =>        This Inner Loop Header: Depth=5
	ldr	s0, [x3, x4, lsl #2]
	stur	s0, [x12, #-8]
	ldr	s0, [x1, x4, lsl #2]
	stur	s0, [x12, #-4]
	ldr	s0, [x0, x4, lsl #2]
	str	s0, [x12]
	ldr	s0, [x16, x4, lsl #2]
	str	s0, [x12, #4]
	add	x4, x4, #1
	add	x12, x12, #16
	cmp	x26, x4
	b.ne	LBB3_215
	b	LBB3_193
LBB3_216:                               ;   in Loop: Header=BB3_184 Depth=2
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	ldr	x8, [sp, #192]                  ; 8-byte Folded Reload
	sub	x8, x0, x8
	scvtf	d0, x8
	mov	x8, #70368744177664             ; =0x400000000000
	movk	x8, #16527, lsl #48
	fmov	d1, x8
	fdiv	d0, d0, d1
	fdiv	d10, d0, d8
	ldr	x8, [sp, #256]                  ; 8-byte Folded Reload
	ldr	x9, [sp, #224]                  ; 8-byte Folded Reload
	cmp	x8, x9
	b.lo	LBB3_183
; %bb.217:                              ;   in Loop: Header=BB3_184 Depth=2
	ldr	x8, [sp, #240]                  ; 8-byte Folded Reload
	ldr	x9, [sp, #256]                  ; 8-byte Folded Reload
	sub	x24, x9, x8
	asr	x21, x24, #3
	add	x8, x21, #1
	lsr	x9, x8, #61
	cbnz	x9, LBB3_351
; %bb.218:                              ;   in Loop: Header=BB3_184 Depth=2
	ldr	x9, [sp, #240]                  ; 8-byte Folded Reload
	ldr	x10, [sp, #224]                 ; 8-byte Folded Reload
	sub	x9, x10, x9
	asr	x10, x9, #2
	cmp	x10, x8
	csel	x8, x10, x8, hi
	mov	x10, #9223372036854775800       ; =0x7ffffffffffffff8
	cmp	x9, x10
	mov	x9, #2305843009213693951        ; =0x1fffffffffffffff
	csel	x19, x8, x9, lo
	lsr	x8, x19, #61
	cbnz	x8, LBB3_352
; %bb.219:                              ;   in Loop: Header=BB3_184 Depth=2
	lsl	x0, x19, #3
Ltmp145:
	bl	__Znwm
Ltmp146:
; %bb.220:                              ;   in Loop: Header=BB3_184 Depth=2
	add	x8, x0, x24
	add	x9, x0, x19, lsl #3
	str	x9, [sp, #224]                  ; 8-byte Folded Spill
	sub	x27, x8, x21, lsl #3
	str	d10, [x8], #8
	str	x8, [sp, #256]                  ; 8-byte Folded Spill
	mov	x0, x27
	ldr	x19, [sp, #240]                 ; 8-byte Folded Reload
	mov	x1, x19
	mov	x2, x24
	bl	_memcpy
	cbz	x19, LBB3_222
; %bb.221:                              ;   in Loop: Header=BB3_184 Depth=2
	ldr	x0, [sp, #240]                  ; 8-byte Folded Reload
	bl	__ZdlPv
LBB3_222:                               ;   in Loop: Header=BB3_184 Depth=2
	str	x27, [sp, #240]                 ; 8-byte Folded Spill
	ldr	w8, [sp, #208]                  ; 4-byte Folded Reload
	add	w8, w8, #1
	str	w8, [sp, #208]                  ; 4-byte Folded Spill
	cmp	w8, #21
	b.ne	LBB3_184
LBB3_223:                               ;   in Loop: Header=BB3_128 Depth=1
Ltmp153:
	sub	x2, x29, #152
	ldr	x0, [sp, #240]                  ; 8-byte Folded Reload
	ldr	x1, [sp, #256]                  ; 8-byte Folded Reload
	bl	__ZNSt3__16__sortIRNS_6__lessIddEEPdEEvT0_S5_T_
Ltmp154:
; %bb.224:                              ;   in Loop: Header=BB3_128 Depth=1
Ltmp155:
Lloh83:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh84:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh85:
	adrp	x1, l_.str.11@PAGE
Lloh86:
	add	x1, x1, l_.str.11@PAGEOFF
	mov	w2, #9                          ; =0x9
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp156:
; %bb.225:                              ;   in Loop: Header=BB3_128 Depth=1
Ltmp157:
Lloh87:
	adrp	x1, l_.str.19@PAGE
Lloh88:
	add	x1, x1, l_.str.19@PAGEOFF
	mov	w2, #23                         ; =0x17
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp158:
; %bb.226:                              ;   in Loop: Header=BB3_128 Depth=1
	ldr	x8, [sp, #240]                  ; 8-byte Folded Reload
	ldr	d0, [x8, #80]
Ltmp159:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp160:
; %bb.227:                              ;   in Loop: Header=BB3_128 Depth=1
Ltmp161:
Lloh89:
	adrp	x1, l_.str.20@PAGE
Lloh90:
	add	x1, x1, l_.str.20@PAGEOFF
	mov	w2, #5                          ; =0x5
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp162:
; %bb.228:                              ;   in Loop: Header=BB3_128 Depth=1
	ldr	x8, [sp, #240]                  ; 8-byte Folded Reload
	ldr	d0, [x8, #152]
Ltmp163:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp164:
; %bb.229:                              ;   in Loop: Header=BB3_128 Depth=1
	mov	w8, #10                         ; =0xa
	sturb	w8, [x29, #-152]
Ltmp165:
	sub	x1, x29, #152
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp166:
; %bb.230:                              ;   in Loop: Header=BB3_128 Depth=1
	ldr	x0, [sp, #240]                  ; 8-byte Folded Reload
	bl	__ZdlPv
	str	xzr, [sp, #184]                 ; 8-byte Folded Spill
	stur	d9, [x29, #-192]
LBB3_231:                               ;   Parent Loop BB3_128 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB3_235 Depth 3
                                        ;       Child Loop BB3_237 Depth 3
                                        ;       Child Loop BB3_239 Depth 3
                                        ;       Child Loop BB3_242 Depth 3
                                        ;         Child Loop BB3_244 Depth 4
                                        ;         Child Loop BB3_246 Depth 4
                                        ;         Child Loop BB3_248 Depth 4
                                        ;         Child Loop BB3_250 Depth 4
                                        ;         Child Loop BB3_252 Depth 4
                                        ;       Child Loop BB3_269 Depth 3
                                        ;       Child Loop BB3_275 Depth 3
                                        ;       Child Loop BB3_281 Depth 3
                                        ;       Child Loop BB3_287 Depth 3
                                        ;         Child Loop BB3_289 Depth 4
                                        ;           Child Loop BB3_301 Depth 5
                                        ;             Child Loop BB3_310 Depth 6
                                        ;             Child Loop BB3_306 Depth 6
                                        ;             Child Loop BB3_315 Depth 6
                                        ;             Child Loop BB3_319 Depth 6
                                        ;             Child Loop BB3_322 Depth 6
                                        ;           Child Loop BB3_296 Depth 5
	sub	x8, x29, #192
	ldr	x9, [sp, #184]                  ; 8-byte Folded Reload
	ldr	w8, [x8, x9]
	str	w8, [sp, #296]                  ; 4-byte Folded Spill
Ltmp168:
Lloh91:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh92:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh93:
	adrp	x1, l_.str.12@PAGE
Lloh94:
	add	x1, x1, l_.str.12@PAGEOFF
	mov	w2, #6                          ; =0x6
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp169:
; %bb.232:                              ;   in Loop: Header=BB3_231 Depth=2
Ltmp170:
	ldr	w1, [sp, #296]                  ; 4-byte Folded Reload
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEi
Ltmp171:
; %bb.233:                              ;   in Loop: Header=BB3_231 Depth=2
Ltmp172:
Lloh95:
	adrp	x1, l_.str.13@PAGE
Lloh96:
	add	x1, x1, l_.str.13@PAGEOFF
	mov	w2, #40                         ; =0x28
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp173:
; %bb.234:                              ;   in Loop: Header=BB3_231 Depth=2
	ldr	w8, [sp, #296]                  ; 4-byte Folded Reload
	mov	x21, x8
	cmp	w8, #1
	ldr	x23, [sp, #288]                 ; 8-byte Folded Reload
	adrp	x19, _sink@PAGE
	b.lt	LBB3_240
LBB3_235:                               ;   Parent Loop BB3_128 Depth=1
                                        ;     Parent Loop BB3_231 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	sub	x2, x29, #232
	mov	x0, x23
	mov	w1, #4                          ; =0x4
	mov	x3, #0                          ; =0x0
	mov	x4, x20
	bl	__Z7computePKfiRK7WeightsS0_Pf
	ldr	s0, [x20]
	fcvt	d0, s0
	ldr	d1, [x19, _sink@PAGEOFF]
	fadd	d0, d1, d0
	str	d0, [x19, _sink@PAGEOFF]
	subs	w21, w21, #1
	b.ne	LBB3_235
; %bb.236:                              ;   in Loop: Header=BB3_231 Depth=2
	ldr	w21, [sp, #296]                 ; 4-byte Folded Reload
LBB3_237:                               ;   Parent Loop BB3_128 Depth=1
                                        ;     Parent Loop BB3_231 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	sub	x2, x29, #232
	mov	x0, x23
	mov	w1, #4                          ; =0x4
	mov	x3, #0                          ; =0x0
	mov	x4, x20
	bl	__Z7computePKfiRK7WeightsS0_Pf
	ldr	s0, [x20]
	fcvt	d0, s0
	ldr	d1, [x19, _sink@PAGEOFF]
	fadd	d0, d1, d0
	str	d0, [x19, _sink@PAGEOFF]
	subs	w21, w21, #1
	b.ne	LBB3_237
; %bb.238:                              ;   in Loop: Header=BB3_231 Depth=2
	ldr	w21, [sp, #296]                 ; 4-byte Folded Reload
LBB3_239:                               ;   Parent Loop BB3_128 Depth=1
                                        ;     Parent Loop BB3_231 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	sub	x2, x29, #232
	mov	x0, x23
	mov	w1, #4                          ; =0x4
	mov	x3, #0                          ; =0x0
	mov	x4, x20
	bl	__Z7computePKfiRK7WeightsS0_Pf
	ldr	s0, [x20]
	fcvt	d0, s0
	ldr	d1, [x19, _sink@PAGEOFF]
	fadd	d0, d1, d0
	str	d0, [x19, _sink@PAGEOFF]
	subs	w21, w21, #1
	b.ne	LBB3_239
LBB3_240:                               ;   in Loop: Header=BB3_231 Depth=2
	mov	w21, #0                         ; =0x0
	mov	x24, #0                         ; =0x0
	mov	x26, #0                         ; =0x0
	mov	x22, #0                         ; =0x0
	b	LBB3_242
LBB3_241:                               ;   in Loop: Header=BB3_242 Depth=3
	str	d10, [x26], #8
	add	w21, w21, #1
	cmp	w21, #21
	b.eq	LBB3_260
LBB3_242:                               ;   Parent Loop BB3_128 Depth=1
                                        ;     Parent Loop BB3_231 Depth=2
                                        ; =>    This Loop Header: Depth=3
                                        ;         Child Loop BB3_244 Depth 4
                                        ;         Child Loop BB3_246 Depth 4
                                        ;         Child Loop BB3_248 Depth 4
                                        ;         Child Loop BB3_250 Depth 4
                                        ;         Child Loop BB3_252 Depth 4
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x27, x0
	ldr	w8, [sp, #296]                  ; 4-byte Folded Reload
	cmp	w8, #1
	b.lt	LBB3_253
; %bb.243:                              ;   in Loop: Header=BB3_242 Depth=3
	ldr	w25, [sp, #296]                 ; 4-byte Folded Reload
LBB3_244:                               ;   Parent Loop BB3_128 Depth=1
                                        ;     Parent Loop BB3_231 Depth=2
                                        ;       Parent Loop BB3_242 Depth=3
                                        ; =>      This Inner Loop Header: Depth=4
	sub	x2, x29, #232
	mov	x0, x23
	mov	w1, #4                          ; =0x4
	mov	x3, #0                          ; =0x0
	mov	x4, x20
	bl	__Z7computePKfiRK7WeightsS0_Pf
	ldr	s0, [x20]
	fcvt	d0, s0
	ldr	d1, [x19, _sink@PAGEOFF]
	fadd	d0, d1, d0
	str	d0, [x19, _sink@PAGEOFF]
	subs	w25, w25, #1
	b.ne	LBB3_244
; %bb.245:                              ;   in Loop: Header=BB3_242 Depth=3
	ldr	w25, [sp, #296]                 ; 4-byte Folded Reload
LBB3_246:                               ;   Parent Loop BB3_128 Depth=1
                                        ;     Parent Loop BB3_231 Depth=2
                                        ;       Parent Loop BB3_242 Depth=3
                                        ; =>      This Inner Loop Header: Depth=4
	sub	x2, x29, #232
	mov	x0, x23
	mov	w1, #4                          ; =0x4
	mov	x3, #0                          ; =0x0
	mov	x4, x20
	bl	__Z7computePKfiRK7WeightsS0_Pf
	ldr	s0, [x20]
	fcvt	d0, s0
	ldr	d1, [x19, _sink@PAGEOFF]
	fadd	d0, d1, d0
	str	d0, [x19, _sink@PAGEOFF]
	subs	w25, w25, #1
	b.ne	LBB3_246
; %bb.247:                              ;   in Loop: Header=BB3_242 Depth=3
	ldr	w25, [sp, #296]                 ; 4-byte Folded Reload
LBB3_248:                               ;   Parent Loop BB3_128 Depth=1
                                        ;     Parent Loop BB3_231 Depth=2
                                        ;       Parent Loop BB3_242 Depth=3
                                        ; =>      This Inner Loop Header: Depth=4
	sub	x2, x29, #232
	mov	x0, x23
	mov	w1, #4                          ; =0x4
	mov	x3, #0                          ; =0x0
	mov	x4, x20
	bl	__Z7computePKfiRK7WeightsS0_Pf
	ldr	s0, [x20]
	fcvt	d0, s0
	ldr	d1, [x19, _sink@PAGEOFF]
	fadd	d0, d1, d0
	str	d0, [x19, _sink@PAGEOFF]
	subs	w25, w25, #1
	b.ne	LBB3_248
; %bb.249:                              ;   in Loop: Header=BB3_242 Depth=3
	ldr	w25, [sp, #296]                 ; 4-byte Folded Reload
LBB3_250:                               ;   Parent Loop BB3_128 Depth=1
                                        ;     Parent Loop BB3_231 Depth=2
                                        ;       Parent Loop BB3_242 Depth=3
                                        ; =>      This Inner Loop Header: Depth=4
	sub	x2, x29, #232
	mov	x0, x23
	mov	w1, #4                          ; =0x4
	mov	x3, #0                          ; =0x0
	mov	x4, x20
	bl	__Z7computePKfiRK7WeightsS0_Pf
	ldr	s0, [x20]
	fcvt	d0, s0
	ldr	d1, [x19, _sink@PAGEOFF]
	fadd	d0, d1, d0
	str	d0, [x19, _sink@PAGEOFF]
	subs	w25, w25, #1
	b.ne	LBB3_250
; %bb.251:                              ;   in Loop: Header=BB3_242 Depth=3
	ldr	w25, [sp, #296]                 ; 4-byte Folded Reload
LBB3_252:                               ;   Parent Loop BB3_128 Depth=1
                                        ;     Parent Loop BB3_231 Depth=2
                                        ;       Parent Loop BB3_242 Depth=3
                                        ; =>      This Inner Loop Header: Depth=4
	sub	x2, x29, #232
	mov	x0, x23
	mov	w1, #4                          ; =0x4
	mov	x3, #0                          ; =0x0
	mov	x4, x20
	bl	__Z7computePKfiRK7WeightsS0_Pf
	ldr	s0, [x20]
	fcvt	d0, s0
	ldr	d1, [x19, _sink@PAGEOFF]
	fadd	d0, d1, d0
	str	d0, [x19, _sink@PAGEOFF]
	subs	w25, w25, #1
	b.ne	LBB3_252
LBB3_253:                               ;   in Loop: Header=BB3_242 Depth=3
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	sub	x8, x0, x27
	scvtf	d0, x8
	mov	x8, #70368744177664             ; =0x400000000000
	movk	x8, #16527, lsl #48
	fmov	d1, x8
	fdiv	d0, d0, d1
	fdiv	d10, d0, d8
	cmp	x26, x22
	b.lo	LBB3_241
; %bb.254:                              ;   in Loop: Header=BB3_242 Depth=3
	sub	x27, x26, x24
	asr	x25, x27, #3
	add	x8, x25, #1
	lsr	x9, x8, #61
	cbnz	x9, LBB3_353
; %bb.255:                              ;   in Loop: Header=BB3_242 Depth=3
	sub	x9, x22, x24
	asr	x10, x9, #2
	cmp	x10, x8
	csel	x8, x10, x8, hi
	mov	x10, #9223372036854775800       ; =0x7ffffffffffffff8
	cmp	x9, x10
	mov	x9, #2305843009213693951        ; =0x1fffffffffffffff
	csel	x19, x8, x9, lo
	lsr	x8, x19, #61
	cbnz	x8, LBB3_354
; %bb.256:                              ;   in Loop: Header=BB3_242 Depth=3
	lsl	x0, x19, #3
Ltmp174:
	bl	__Znwm
Ltmp175:
; %bb.257:                              ;   in Loop: Header=BB3_242 Depth=3
	add	x26, x0, x27
	add	x22, x0, x19, lsl #3
	sub	x28, x26, x25, lsl #3
	str	d10, [x26], #8
	mov	x0, x28
	mov	x1, x24
	mov	x2, x27
	bl	_memcpy
	cbz	x24, LBB3_259
; %bb.258:                              ;   in Loop: Header=BB3_242 Depth=3
	mov	x0, x24
	bl	__ZdlPv
LBB3_259:                               ;   in Loop: Header=BB3_242 Depth=3
	mov	x24, x28
	adrp	x19, _sink@PAGE
	add	w21, w21, #1
	cmp	w21, #21
	b.ne	LBB3_242
LBB3_260:                               ;   in Loop: Header=BB3_231 Depth=2
Ltmp182:
	sub	x2, x29, #152
	mov	x0, x24
	mov	x1, x26
	bl	__ZNSt3__16__sortIRNS_6__lessIddEEPdEEvT0_S5_T_
Ltmp183:
; %bb.261:                              ;   in Loop: Header=BB3_231 Depth=2
Ltmp184:
Lloh97:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh98:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh99:
	adrp	x1, l_.str.14@PAGE
Lloh100:
	add	x1, x1, l_.str.14@PAGEOFF
	mov	w2, #8                          ; =0x8
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp185:
; %bb.262:                              ;   in Loop: Header=BB3_231 Depth=2
Ltmp186:
Lloh101:
	adrp	x1, l_.str.19@PAGE
Lloh102:
	add	x1, x1, l_.str.19@PAGEOFF
	mov	w2, #23                         ; =0x17
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp187:
; %bb.263:                              ;   in Loop: Header=BB3_231 Depth=2
	ldr	d0, [x24, #80]
Ltmp188:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp189:
; %bb.264:                              ;   in Loop: Header=BB3_231 Depth=2
Ltmp190:
Lloh103:
	adrp	x1, l_.str.20@PAGE
Lloh104:
	add	x1, x1, l_.str.20@PAGEOFF
	mov	w2, #5                          ; =0x5
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp191:
; %bb.265:                              ;   in Loop: Header=BB3_231 Depth=2
	ldr	d0, [x24, #152]
Ltmp192:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp193:
; %bb.266:                              ;   in Loop: Header=BB3_231 Depth=2
	mov	w8, #10                         ; =0xa
	sturb	w8, [x29, #-152]
Ltmp194:
	sub	x1, x29, #152
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp195:
; %bb.267:                              ;   in Loop: Header=BB3_231 Depth=2
	mov	x0, x24
	bl	__ZdlPv
Ltmp197:
	sub	x8, x29, #152
	sub	x0, x29, #232
	bl	__Z4packRK7Weights
Ltmp198:
; %bb.268:                              ;   in Loop: Header=BB3_231 Depth=2
	ldur	x24, [x29, #-152]
	ldr	w8, [sp, #296]                  ; 4-byte Folded Reload
	mov	x21, x8
	cmp	w8, #1
	ldr	x19, [sp, #288]                 ; 8-byte Folded Reload
	adrp	x22, _sink@PAGE
	b.lt	LBB3_270
LBB3_269:                               ;   Parent Loop BB3_128 Depth=1
                                        ;     Parent Loop BB3_231 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	sub	x2, x29, #232
	mov	x0, x19
	mov	w1, #4                          ; =0x4
	mov	x3, x24
	mov	x4, x20
	bl	__Z7computePKfiRK7WeightsS0_Pf
	ldr	s0, [x20]
	fcvt	d0, s0
	ldr	d1, [x22, _sink@PAGEOFF]
	fadd	d0, d1, d0
	str	d0, [x22, _sink@PAGEOFF]
	subs	w21, w21, #1
	b.ne	LBB3_269
LBB3_270:                               ;   in Loop: Header=BB3_231 Depth=2
	cbz	x24, LBB3_272
; %bb.271:                              ;   in Loop: Header=BB3_231 Depth=2
	mov	x0, x24
	bl	__ZdlPv
LBB3_272:                               ;   in Loop: Header=BB3_231 Depth=2
Ltmp199:
	sub	x8, x29, #152
	sub	x0, x29, #232
	bl	__Z4packRK7Weights
Ltmp200:
; %bb.273:                              ;   in Loop: Header=BB3_231 Depth=2
	ldur	x24, [x29, #-152]
	ldr	w8, [sp, #296]                  ; 4-byte Folded Reload
	cmp	w8, #1
	ldr	x21, [sp, #288]                 ; 8-byte Folded Reload
	adrp	x22, _sink@PAGE
	b.lt	LBB3_276
; %bb.274:                              ;   in Loop: Header=BB3_231 Depth=2
	ldr	w19, [sp, #296]                 ; 4-byte Folded Reload
LBB3_275:                               ;   Parent Loop BB3_128 Depth=1
                                        ;     Parent Loop BB3_231 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	sub	x2, x29, #232
	mov	x0, x21
	mov	w1, #4                          ; =0x4
	mov	x3, x24
	mov	x4, x20
	bl	__Z7computePKfiRK7WeightsS0_Pf
	ldr	s0, [x20]
	fcvt	d0, s0
	ldr	d1, [x22, _sink@PAGEOFF]
	fadd	d0, d1, d0
	str	d0, [x22, _sink@PAGEOFF]
	subs	w19, w19, #1
	b.ne	LBB3_275
LBB3_276:                               ;   in Loop: Header=BB3_231 Depth=2
	cbz	x24, LBB3_278
; %bb.277:                              ;   in Loop: Header=BB3_231 Depth=2
	mov	x0, x24
	bl	__ZdlPv
LBB3_278:                               ;   in Loop: Header=BB3_231 Depth=2
Ltmp201:
	sub	x8, x29, #152
	sub	x0, x29, #232
	bl	__Z4packRK7Weights
Ltmp202:
; %bb.279:                              ;   in Loop: Header=BB3_231 Depth=2
	ldur	x24, [x29, #-152]
	ldr	w8, [sp, #296]                  ; 4-byte Folded Reload
	cmp	w8, #1
	ldr	x21, [sp, #288]                 ; 8-byte Folded Reload
	adrp	x22, _sink@PAGE
	b.lt	LBB3_282
; %bb.280:                              ;   in Loop: Header=BB3_231 Depth=2
	ldr	w19, [sp, #296]                 ; 4-byte Folded Reload
LBB3_281:                               ;   Parent Loop BB3_128 Depth=1
                                        ;     Parent Loop BB3_231 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	sub	x2, x29, #232
	mov	x0, x21
	mov	w1, #4                          ; =0x4
	mov	x3, x24
	mov	x4, x20
	bl	__Z7computePKfiRK7WeightsS0_Pf
	ldr	s0, [x20]
	fcvt	d0, s0
	ldr	d1, [x22, _sink@PAGEOFF]
	fadd	d0, d1, d0
	str	d0, [x22, _sink@PAGEOFF]
	subs	w19, w19, #1
	b.ne	LBB3_281
LBB3_282:                               ;   in Loop: Header=BB3_231 Depth=2
	cbz	x24, LBB3_284
; %bb.283:                              ;   in Loop: Header=BB3_231 Depth=2
	mov	x0, x24
	bl	__ZdlPv
LBB3_284:                               ;   in Loop: Header=BB3_231 Depth=2
	mov	w8, #0                          ; =0x0
	str	xzr, [sp, #256]                 ; 8-byte Folded Spill
	str	xzr, [sp, #240]                 ; 8-byte Folded Spill
	str	xzr, [sp, #224]                 ; 8-byte Folded Spill
	ldr	x23, [sp, #288]                 ; 8-byte Folded Reload
	b	LBB3_287
LBB3_285:                               ;   in Loop: Header=BB3_287 Depth=3
	str	d10, [x8], #8
	str	x8, [sp, #240]                  ; 8-byte Folded Spill
	ldr	x28, [sp, #256]                 ; 8-byte Folded Reload
LBB3_286:                               ;   in Loop: Header=BB3_287 Depth=3
	ldr	w8, [sp, #192]                  ; 4-byte Folded Reload
	str	x28, [sp, #256]                 ; 8-byte Folded Spill
	add	w8, w8, #1
	cmp	w8, #21
	b.eq	LBB3_329
LBB3_287:                               ;   Parent Loop BB3_128 Depth=1
                                        ;     Parent Loop BB3_231 Depth=2
                                        ; =>    This Loop Header: Depth=3
                                        ;         Child Loop BB3_289 Depth 4
                                        ;           Child Loop BB3_301 Depth 5
                                        ;             Child Loop BB3_310 Depth 6
                                        ;             Child Loop BB3_306 Depth 6
                                        ;             Child Loop BB3_315 Depth 6
                                        ;             Child Loop BB3_319 Depth 6
                                        ;             Child Loop BB3_322 Depth 6
                                        ;           Child Loop BB3_296 Depth 5
	str	w8, [sp, #192]                  ; 4-byte Folded Spill
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	str	x0, [sp, #208]                  ; 8-byte Folded Spill
	mov	w26, #0                         ; =0x0
	b	LBB3_289
LBB3_288:                               ;   in Loop: Header=BB3_289 Depth=4
	add	w26, w26, #1
	cmp	w26, #5
	b.eq	LBB3_323
LBB3_289:                               ;   Parent Loop BB3_128 Depth=1
                                        ;     Parent Loop BB3_231 Depth=2
                                        ;       Parent Loop BB3_287 Depth=3
                                        ; =>      This Loop Header: Depth=4
                                        ;           Child Loop BB3_301 Depth 5
                                        ;             Child Loop BB3_310 Depth 6
                                        ;             Child Loop BB3_306 Depth 6
                                        ;             Child Loop BB3_315 Depth 6
                                        ;             Child Loop BB3_319 Depth 6
                                        ;             Child Loop BB3_322 Depth 6
                                        ;           Child Loop BB3_296 Depth 5
	ldp	w28, w19, [x29, #-232]
                                        ; kill: def $w19 killed $w19 def $x19
	sxtw	x19, w19
	adds	w8, w28, #3
	add	w9, w28, #6
	csel	w8, w9, w8, lt
	asr	w8, w8, #2
	smull	x8, w19, w8
	cbz	x8, LBB3_293
; %bb.290:                              ;   in Loop: Header=BB3_289 Depth=4
	tst	x8, #0x3000000000000000
	b.ne	LBB3_344
; %bb.291:                              ;   in Loop: Header=BB3_289 Depth=4
	lsl	x21, x8, #4
Ltmp207:
	mov	x0, x21
	bl	__Znwm
Ltmp208:
; %bb.292:                              ;   in Loop: Header=BB3_289 Depth=4
	mov	x25, x0
	mov	x1, x21
	bl	_bzero
	b	LBB3_294
LBB3_293:                               ;   in Loop: Header=BB3_289 Depth=4
	mov	x25, #0                         ; =0x0
LBB3_294:                               ;   in Loop: Header=BB3_289 Depth=4
	cmp	w28, #1
	ccmp	w19, #1, #8, ge
	b.ge	LBB3_299
LBB3_295:                               ;   in Loop: Header=BB3_289 Depth=4
	ldr	w8, [sp, #296]                  ; 4-byte Folded Reload
	mov	x21, x8
	cmp	w8, #1
	adrp	x19, _sink@PAGE
	b.lt	LBB3_297
LBB3_296:                               ;   Parent Loop BB3_128 Depth=1
                                        ;     Parent Loop BB3_231 Depth=2
                                        ;       Parent Loop BB3_287 Depth=3
                                        ;         Parent Loop BB3_289 Depth=4
                                        ; =>        This Inner Loop Header: Depth=5
	sub	x2, x29, #232
	mov	x0, x23
	mov	w1, #4                          ; =0x4
	mov	x3, x25
	mov	x4, x20
	bl	__Z7computePKfiRK7WeightsS0_Pf
	ldr	s0, [x20]
	fcvt	d0, s0
	ldr	d1, [x19, _sink@PAGEOFF]
	fadd	d0, d1, d0
	str	d0, [x19, _sink@PAGEOFF]
	subs	w21, w21, #1
	b.ne	LBB3_296
LBB3_297:                               ;   in Loop: Header=BB3_289 Depth=4
	cbz	x25, LBB3_288
; %bb.298:                              ;   in Loop: Header=BB3_289 Depth=4
	mov	x0, x25
	bl	__ZdlPv
	b	LBB3_288
LBB3_299:                               ;   in Loop: Header=BB3_289 Depth=4
	mov	x8, #0                          ; =0x0
	mov	x9, #0                          ; =0x0
	mov	x10, #0                         ; =0x0
	ldursw	x11, [x29, #-224]
	ldur	x14, [x29, #-216]
	add	x13, x25, #4
	sub	x7, x19, #1
	lsl	x15, x19, #4
	lsl	x12, x28, #2
	sub	x12, x12, #4
	and	x2, x12, #0xfffffffffffffff0
	madd	x16, x2, x19, x25
	add	x3, x16, x19, lsl #4
	mov	w16, #12                        ; =0xc
	smaddl	x16, w11, w16, x14
	orr	x12, x12, #0xc
	lsl	x17, x19, #2
	madd	x12, x12, x11, x14
	add	x0, x14, x11, lsl #3
	orr	x1, x2, #0x8
	madd	x4, x1, x11, x14
	add	x1, x14, x11, lsl #2
	orr	x5, x2, #0x4
	madd	x5, x5, x11, x14
	madd	x6, x2, x11, x14
	stur	x7, [x29, #-248]                ; 8-byte Folded Spill
	lsl	x2, x7, #4
	add	x12, x12, x17
	cmp	x25, x12
	ccmp	x16, x3, #2, lo
	cset	w12, lo
	add	x4, x4, x17
	cmp	x25, x4
	ccmp	x0, x3, #2, lo
	ccmp	x11, #0, #8, hs
	csinc	w12, w12, wzr, ge
	add	x4, x5, x17
	cmp	x25, x4
	ccmp	x1, x3, #2, lo
	csinc	w12, w12, wzr, hs
	add	x4, x6, x17
	cmp	x25, x4
	ccmp	x14, x3, #2, lo
	csinc	w12, w12, wzr, hs
	stur	w12, [x29, #-256]               ; 4-byte Folded Spill
	and	x12, x19, #0x7ffffffc
	str	x12, [sp, #280]                 ; 8-byte Folded Spill
	and	x12, x19, #0x7ffffffe
	neg	x5, x12
	add	x6, x25, #16
	add	x7, x14, #4
	lsl	x21, x11, #4
	and	x30, x17, #0x1fffffff0
	add	x12, x25, #8
	stur	x12, [x29, #-240]               ; 8-byte Folded Spill
	mov	x24, x25
	mov	x3, x14
	b	LBB3_301
LBB3_300:                               ;   in Loop: Header=BB3_301 Depth=5
	add	x10, x10, #4
	add	x9, x9, #1
	add	x6, x6, x15
	add	x7, x7, x21
	add	x3, x3, x21
	add	x13, x13, x15
	add	x0, x0, x21
	add	x1, x1, x21
	add	x16, x16, x21
	add	x24, x24, x15
	add	x8, x8, x19
	cmp	x10, x28
	b.hs	LBB3_295
LBB3_301:                               ;   Parent Loop BB3_128 Depth=1
                                        ;     Parent Loop BB3_231 Depth=2
                                        ;       Parent Loop BB3_287 Depth=3
                                        ;         Parent Loop BB3_289 Depth=4
                                        ; =>        This Loop Header: Depth=5
                                        ;             Child Loop BB3_310 Depth 6
                                        ;             Child Loop BB3_306 Depth 6
                                        ;             Child Loop BB3_315 Depth 6
                                        ;             Child Loop BB3_319 Depth 6
                                        ;             Child Loop BB3_322 Depth 6
	orr	x12, x10, #0x1
	cmp	x12, x28
	b.hs	LBB3_307
; %bb.302:                              ;   in Loop: Header=BB3_301 Depth=5
	orr	x22, x10, #0x2
	mov	x4, x13
	mov	x12, x3
	mov	x27, x19
	cmp	x22, x28
	b.hs	LBB3_306
; %bb.303:                              ;   in Loop: Header=BB3_301 Depth=5
	orr	x12, x10, #0x3
	cmp	x12, x28
	b.hs	LBB3_314
; %bb.304:                              ;   in Loop: Header=BB3_301 Depth=5
	cmp	w19, #16
	b.hs	LBB3_316
; %bb.305:                              ;   in Loop: Header=BB3_301 Depth=5
	mov	x4, #0                          ; =0x0
	b	LBB3_321
LBB3_306:                               ;   Parent Loop BB3_128 Depth=1
                                        ;     Parent Loop BB3_231 Depth=2
                                        ;       Parent Loop BB3_287 Depth=3
                                        ;         Parent Loop BB3_289 Depth=4
                                        ;           Parent Loop BB3_301 Depth=5
                                        ; =>          This Inner Loop Header: Depth=6
	ldr	s0, [x12]
	stur	s0, [x4, #-4]
	ldr	s0, [x12, x11, lsl #2]
	str	s0, [x4], #16
	add	x12, x12, #4
	subs	x27, x27, #1
	b.ne	LBB3_306
	b	LBB3_300
LBB3_307:                               ;   in Loop: Header=BB3_301 Depth=5
	cmp	w19, #1
	b.ne	LBB3_309
; %bb.308:                              ;   in Loop: Header=BB3_301 Depth=5
	mov	x12, #0                         ; =0x0
	b	LBB3_312
LBB3_309:                               ;   in Loop: Header=BB3_301 Depth=5
	mov	x4, #0                          ; =0x0
	mov	x12, x7
	mov	x27, x6
LBB3_310:                               ;   Parent Loop BB3_128 Depth=1
                                        ;     Parent Loop BB3_231 Depth=2
                                        ;       Parent Loop BB3_287 Depth=3
                                        ;         Parent Loop BB3_289 Depth=4
                                        ;           Parent Loop BB3_301 Depth=5
                                        ; =>          This Inner Loop Header: Depth=6
	ldur	s0, [x12, #-4]
	stur	s0, [x27, #-16]
	ldr	s0, [x12], #8
	str	s0, [x27], #32
	sub	x4, x4, #2
	cmp	x5, x4
	b.ne	LBB3_310
; %bb.311:                              ;   in Loop: Header=BB3_301 Depth=5
	neg	x12, x4
LBB3_312:                               ;   in Loop: Header=BB3_301 Depth=5
	tbz	w19, #0, LBB3_300
; %bb.313:                              ;   in Loop: Header=BB3_301 Depth=5
	lsr	x4, x10, #2
	mul	x4, x4, x19
	mul	x22, x10, x11
	add	x22, x14, x22, lsl #2
	add	x4, x12, x4
	ldr	s0, [x22, x12, lsl #2]
	lsl	x12, x4, #4
	str	s0, [x25, x12]
	b	LBB3_300
LBB3_314:                               ;   in Loop: Header=BB3_301 Depth=5
	mov	x12, #0                         ; =0x0
	mov	x4, x13
LBB3_315:                               ;   Parent Loop BB3_128 Depth=1
                                        ;     Parent Loop BB3_231 Depth=2
                                        ;       Parent Loop BB3_287 Depth=3
                                        ;         Parent Loop BB3_289 Depth=4
                                        ;           Parent Loop BB3_301 Depth=5
                                        ; =>          This Inner Loop Header: Depth=6
	ldr	s0, [x3, x12]
	stur	s0, [x4, #-4]
	ldr	s0, [x1, x12]
	str	s0, [x4]
	ldr	s0, [x0, x12]
	str	s0, [x4, #4]
	add	x12, x12, #4
	add	x4, x4, #16
	cmp	x17, x12
	b.ne	LBB3_315
	b	LBB3_300
LBB3_316:                               ;   in Loop: Header=BB3_301 Depth=5
	madd	x12, x15, x9, x25
	add	x4, x12, #4
	add	x22, x12, #8
	add	x12, x12, #12
	add	x27, x4, x2
	add	x23, x22, x2
	cmp	x23, x22
	ccmp	x27, x4, #0, hs
	cset	w4, lo
	ldur	x22, [x29, #-248]               ; 8-byte Folded Reload
	tst	x22, #0xf000000000000000
	csinc	w4, w4, wzr, eq
	add	x22, x12, x2
	cmp	x22, x12
	csinc	w12, w4, wzr, hs
	ldur	w4, [x29, #-256]                ; 4-byte Folded Reload
	orr	w12, w12, w4
	tbz	w12, #0, LBB3_318
; %bb.317:                              ;   in Loop: Header=BB3_301 Depth=5
	mov	x4, #0                          ; =0x0
	ldr	x23, [sp, #288]                 ; 8-byte Folded Reload
	b	LBB3_321
LBB3_318:                               ;   in Loop: Header=BB3_301 Depth=5
	mov	x4, #0                          ; =0x0
	mov	x12, x24
	ldr	x23, [sp, #288]                 ; 8-byte Folded Reload
LBB3_319:                               ;   Parent Loop BB3_128 Depth=1
                                        ;     Parent Loop BB3_231 Depth=2
                                        ;       Parent Loop BB3_287 Depth=3
                                        ;         Parent Loop BB3_289 Depth=4
                                        ;           Parent Loop BB3_301 Depth=5
                                        ; =>          This Inner Loop Header: Depth=6
	ldr	q0, [x3, x4]
	ldr	q1, [x1, x4]
	ldr	q2, [x0, x4]
	ldr	q3, [x16, x4]
	st4.4s	{ v0, v1, v2, v3 }, [x12], #64
	add	x4, x4, #16
	cmp	x30, x4
	b.ne	LBB3_319
; %bb.320:                              ;   in Loop: Header=BB3_301 Depth=5
	ldr	x12, [sp, #280]                 ; 8-byte Folded Reload
	mov	x4, x12
	cmp	x12, x19
	b.eq	LBB3_300
LBB3_321:                               ;   in Loop: Header=BB3_301 Depth=5
	add	x12, x4, x8
	ldur	x22, [x29, #-240]               ; 8-byte Folded Reload
	add	x12, x22, x12, lsl #4
LBB3_322:                               ;   Parent Loop BB3_128 Depth=1
                                        ;     Parent Loop BB3_231 Depth=2
                                        ;       Parent Loop BB3_287 Depth=3
                                        ;         Parent Loop BB3_289 Depth=4
                                        ;           Parent Loop BB3_301 Depth=5
                                        ; =>          This Inner Loop Header: Depth=6
	ldr	s0, [x3, x4, lsl #2]
	stur	s0, [x12, #-8]
	ldr	s0, [x1, x4, lsl #2]
	stur	s0, [x12, #-4]
	ldr	s0, [x0, x4, lsl #2]
	str	s0, [x12]
	ldr	s0, [x16, x4, lsl #2]
	str	s0, [x12, #4]
	add	x4, x4, #1
	add	x12, x12, #16
	cmp	x19, x4
	b.ne	LBB3_322
	b	LBB3_300
LBB3_323:                               ;   in Loop: Header=BB3_287 Depth=3
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	ldr	x8, [sp, #208]                  ; 8-byte Folded Reload
	sub	x8, x0, x8
	scvtf	d0, x8
	mov	x8, #70368744177664             ; =0x400000000000
	movk	x8, #16527, lsl #48
	fmov	d1, x8
	fdiv	d0, d0, d1
	fdiv	d10, d0, d8
	ldr	x8, [sp, #240]                  ; 8-byte Folded Reload
	ldr	x9, [sp, #224]                  ; 8-byte Folded Reload
	cmp	x8, x9
	b.lo	LBB3_285
; %bb.324:                              ;   in Loop: Header=BB3_287 Depth=3
	ldr	x22, [sp, #256]                 ; 8-byte Folded Reload
	sub	x24, x8, x22
	asr	x21, x24, #3
	add	x8, x21, #1
	lsr	x9, x8, #61
	cbnz	x9, LBB3_355
; %bb.325:                              ;   in Loop: Header=BB3_287 Depth=3
	ldr	x9, [sp, #224]                  ; 8-byte Folded Reload
	sub	x9, x9, x22
	asr	x10, x9, #2
	cmp	x10, x8
	csel	x8, x10, x8, hi
	mov	x10, #9223372036854775800       ; =0x7ffffffffffffff8
	cmp	x9, x10
	mov	x9, #2305843009213693951        ; =0x1fffffffffffffff
	csel	x19, x8, x9, lo
	lsr	x8, x19, #61
	cbnz	x8, LBB3_356
; %bb.326:                              ;   in Loop: Header=BB3_287 Depth=3
	lsl	x0, x19, #3
Ltmp210:
	bl	__Znwm
Ltmp211:
; %bb.327:                              ;   in Loop: Header=BB3_287 Depth=3
	add	x8, x0, x24
	add	x9, x0, x19, lsl #3
	str	x9, [sp, #224]                  ; 8-byte Folded Spill
	sub	x28, x8, x21, lsl #3
	str	d10, [x8], #8
	str	x8, [sp, #240]                  ; 8-byte Folded Spill
	mov	x0, x28
	mov	x1, x22
	mov	x2, x24
	bl	_memcpy
	cbz	x22, LBB3_286
; %bb.328:                              ;   in Loop: Header=BB3_287 Depth=3
	mov	x0, x22
	bl	__ZdlPv
	b	LBB3_286
LBB3_329:                               ;   in Loop: Header=BB3_231 Depth=2
Ltmp218:
	sub	x2, x29, #152
	ldr	x0, [sp, #256]                  ; 8-byte Folded Reload
	ldr	x1, [sp, #240]                  ; 8-byte Folded Reload
	bl	__ZNSt3__16__sortIRNS_6__lessIddEEPdEEvT0_S5_T_
Ltmp219:
; %bb.330:                              ;   in Loop: Header=BB3_231 Depth=2
Ltmp220:
Lloh105:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh106:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh107:
	adrp	x1, l_.str.15@PAGE
Lloh108:
	add	x1, x1, l_.str.15@PAGEOFF
	mov	w2, #11                         ; =0xb
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp221:
; %bb.331:                              ;   in Loop: Header=BB3_231 Depth=2
Ltmp222:
Lloh109:
	adrp	x1, l_.str.19@PAGE
Lloh110:
	add	x1, x1, l_.str.19@PAGEOFF
	mov	w2, #23                         ; =0x17
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp223:
; %bb.332:                              ;   in Loop: Header=BB3_231 Depth=2
	ldr	x8, [sp, #256]                  ; 8-byte Folded Reload
	ldr	d0, [x8, #80]
Ltmp224:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp225:
; %bb.333:                              ;   in Loop: Header=BB3_231 Depth=2
Ltmp226:
Lloh111:
	adrp	x1, l_.str.20@PAGE
Lloh112:
	add	x1, x1, l_.str.20@PAGEOFF
	mov	w2, #5                          ; =0x5
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp227:
; %bb.334:                              ;   in Loop: Header=BB3_231 Depth=2
	ldr	x8, [sp, #256]                  ; 8-byte Folded Reload
	ldr	d0, [x8, #152]
Ltmp228:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp229:
; %bb.335:                              ;   in Loop: Header=BB3_231 Depth=2
	mov	w8, #10                         ; =0xa
	sturb	w8, [x29, #-152]
Ltmp230:
	sub	x1, x29, #152
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp231:
; %bb.336:                              ;   in Loop: Header=BB3_231 Depth=2
	ldr	x0, [sp, #256]                  ; 8-byte Folded Reload
	bl	__ZdlPv
	ldr	x8, [sp, #184]                  ; 8-byte Folded Reload
	add	x8, x8, #4
	str	x8, [sp, #184]                  ; 8-byte Folded Spill
	cmp	x8, #8
	b.ne	LBB3_231
; %bb.337:                              ;   in Loop: Header=BB3_128 Depth=1
	cbz	x20, LBB3_339
; %bb.338:                              ;   in Loop: Header=BB3_128 Depth=1
	mov	x0, x20
	bl	__ZdlPv
LBB3_339:                               ;   in Loop: Header=BB3_128 Depth=1
	ldr	x0, [sp, #288]                  ; 8-byte Folded Reload
	bl	__ZdlPv
	ldur	x0, [x29, #-184]
	cbz	x0, LBB3_341
; %bb.340:                              ;   in Loop: Header=BB3_128 Depth=1
	bl	__ZdlPv
LBB3_341:                               ;   in Loop: Header=BB3_128 Depth=1
	ldur	x0, [x29, #-216]
	cbz	x0, LBB3_127
; %bb.342:                              ;   in Loop: Header=BB3_128 Depth=1
	stur	x0, [x29, #-208]
	bl	__ZdlPv
	b	LBB3_127
LBB3_343:
	mov	w0, #0                          ; =0x0
	b	LBB3_435
LBB3_344:
Ltmp204:
	bl	__ZNSt3__16vectorIfNS_9allocatorIfEEE20__throw_length_errorB9nqe210106Ev
Ltmp205:
	b	LBB3_357
LBB3_345:
Ltmp61:
	bl	__ZNSt3__16vectorIfNS_9allocatorIfEEE20__throw_length_errorB9nqe210106Ev
Ltmp62:
	b	LBB3_357
LBB3_346:
Ltmp91:
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_length_errorB9nqe210106Ev
Ltmp92:
	b	LBB3_357
LBB3_347:
Ltmp89:
	bl	__ZSt28__throw_bad_array_new_lengthB9nqe210106v
Ltmp90:
	b	LBB3_357
LBB3_348:
Ltmp114:
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_length_errorB9nqe210106Ev
Ltmp115:
	b	LBB3_357
LBB3_349:
Ltmp112:
	bl	__ZSt28__throw_bad_array_new_lengthB9nqe210106v
Ltmp113:
	b	LBB3_357
LBB3_350:
Ltmp139:
	bl	__ZNSt3__16vectorIfNS_9allocatorIfEEE20__throw_length_errorB9nqe210106Ev
Ltmp140:
	b	LBB3_357
LBB3_351:
Ltmp150:
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_length_errorB9nqe210106Ev
Ltmp151:
	b	LBB3_357
LBB3_352:
Ltmp148:
	bl	__ZSt28__throw_bad_array_new_lengthB9nqe210106v
Ltmp149:
	b	LBB3_357
LBB3_353:
Ltmp179:
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_length_errorB9nqe210106Ev
Ltmp180:
	b	LBB3_357
LBB3_354:
Ltmp177:
	bl	__ZSt28__throw_bad_array_new_lengthB9nqe210106v
Ltmp178:
	b	LBB3_357
LBB3_355:
Ltmp215:
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_length_errorB9nqe210106Ev
Ltmp216:
	b	LBB3_357
LBB3_356:
Ltmp213:
	bl	__ZSt28__throw_bad_array_new_lengthB9nqe210106v
Ltmp214:
LBB3_357:
	brk	#0x1
LBB3_358:
Ltmp217:
	b	LBB3_394
LBB3_359:
Ltmp181:
	b	LBB3_370
LBB3_360:
Ltmp152:
	b	LBB3_375
LBB3_361:
Ltmp141:
	b	LBB3_375
LBB3_362:
Ltmp116:
	b	LBB3_383
LBB3_363:
Ltmp93:
	b	LBB3_383
LBB3_364:
Ltmp63:
	b	LBB3_386
LBB3_365:
Ltmp232:
	b	LBB3_394
LBB3_366:
Ltmp212:
	b	LBB3_394
LBB3_367:
Ltmp203:
	b	LBB3_378
LBB3_368:
Ltmp196:
	b	LBB3_370
LBB3_369:
Ltmp176:
LBB3_370:
	mov	x21, x1
	mov	x22, x0
	cbz	x24, LBB3_397
; %bb.371:
	mov	x0, x24
	b	LBB3_396
LBB3_372:
Ltmp167:
	b	LBB3_375
LBB3_373:
Ltmp147:
	b	LBB3_375
LBB3_374:
Ltmp144:
LBB3_375:
	mov	x21, x1
	mov	x22, x0
	ldr	x8, [sp, #240]                  ; 8-byte Folded Reload
	cbz	x8, LBB3_397
; %bb.376:
	ldr	x0, [sp, #240]                  ; 8-byte Folded Reload
	b	LBB3_396
LBB3_377:
Ltmp138:
LBB3_378:
	mov	x21, x1
	mov	x22, x0
	b	LBB3_397
LBB3_379:
Ltmp131:
	b	LBB3_383
LBB3_380:
Ltmp111:
	b	LBB3_383
LBB3_381:
Ltmp108:
	b	LBB3_383
LBB3_382:
Ltmp88:
LBB3_383:
	mov	x21, x1
	mov	x22, x0
	cbz	x25, LBB3_398
; %bb.384:
	mov	x0, x25
	bl	__ZdlPv
	b	LBB3_398
LBB3_385:
Ltmp60:
LBB3_386:
	mov	x21, x1
	mov	x22, x0
	b	LBB3_399
LBB3_387:
Ltmp57:
	mov	x21, x1
	mov	x22, x0
	b	LBB3_400
LBB3_388:
Ltmp54:
	mov	x21, x1
	mov	x22, x0
	b	LBB3_402
LBB3_389:
Ltmp51:
	b	LBB3_415
LBB3_390:
Ltmp48:
	b	LBB3_415
LBB3_391:
Ltmp41:
	b	LBB3_415
LBB3_392:
Ltmp206:
	b	LBB3_394
LBB3_393:
Ltmp209:
LBB3_394:
	mov	x21, x1
	mov	x22, x0
	ldr	x8, [sp, #256]                  ; 8-byte Folded Reload
	cbz	x8, LBB3_397
; %bb.395:
	ldr	x0, [sp, #256]                  ; 8-byte Folded Reload
LBB3_396:
	bl	__ZdlPv
LBB3_397:
	cbz	x20, LBB3_399
LBB3_398:
	mov	x0, x20
	bl	__ZdlPv
LBB3_399:
	ldr	x0, [sp, #288]                  ; 8-byte Folded Reload
	bl	__ZdlPv
LBB3_400:
	ldur	x0, [x29, #-184]
	cbz	x0, LBB3_402
; %bb.401:
	bl	__ZdlPv
LBB3_402:
	ldur	x0, [x29, #-216]
	cbz	x0, LBB3_430
; %bb.403:
	stur	x0, [x29, #-208]
	b	LBB3_429
LBB3_404:
Ltmp244:
	b	LBB3_415
LBB3_405:
Ltmp241:
	mov	x21, x1
	mov	x22, x0
	mov	x0, x19
	bl	___cxa_free_exception
	b	LBB3_430
LBB3_406:
Ltmp23:
	mov	x21, x1
	mov	x22, x0
	ldr	x23, [sp, #168]                 ; 8-byte Folded Reload
	b	LBB3_423
LBB3_407:
Ltmp11:
	mov	x21, x1
	mov	x22, x0
	b	LBB3_428
LBB3_408:
Ltmp14:
	b	LBB3_412
LBB3_409:
Ltmp26:
	mov	x21, x1
	mov	x22, x0
	mov	x0, x19
	bl	__ZdlPv
	ldr	x23, [sp, #168]                 ; 8-byte Folded Reload
	b	LBB3_423
LBB3_410:
Ltmp5:
	b	LBB3_415
LBB3_411:
Ltmp17:
LBB3_412:
	mov	x21, x1
	mov	x22, x0
	b	LBB3_426
LBB3_413:
Ltmp29:
	b	LBB3_417
LBB3_414:
Ltmp8:
LBB3_415:
	mov	x21, x1
	mov	x22, x0
	b	LBB3_430
LBB3_416:
Ltmp20:
LBB3_417:
	mov	x21, x1
	mov	x22, x0
	b	LBB3_424
LBB3_418:
Ltmp235:
	mov	x21, x1
	mov	x22, x0
	mov	x0, x20
	bl	___cxa_free_exception
	cbnz	x25, LBB3_421
	b	LBB3_422
LBB3_419:
Ltmp32:
	mov	x21, x1
	mov	x22, x0
	mov	x0, x20
	bl	___cxa_free_exception
	ldr	x23, [sp, #168]                 ; 8-byte Folded Reload
	b	LBB3_421
LBB3_420:
Ltmp238:
	mov	x21, x1
	mov	x22, x0
	cbz	x25, LBB3_422
LBB3_421:
	mov	x0, x25
	bl	__ZdlPv
LBB3_422:
	mov	x0, x19
	bl	__ZdlPv
	cbz	x23, LBB3_424
LBB3_423:
	mov	x0, x23
	bl	__ZdlPv
LBB3_424:
	ldr	x0, [sp, #280]                  ; 8-byte Folded Reload
	cbz	x0, LBB3_426
; %bb.425:
	bl	__ZdlPv
LBB3_426:
	ldr	x0, [sp, #184]                  ; 8-byte Folded Reload
	cbz	x0, LBB3_428
; %bb.427:
	bl	__ZdlPv
LBB3_428:
	ldur	x0, [x29, #-216]
	cbz	x0, LBB3_430
LBB3_429:
	bl	__ZdlPv
LBB3_430:
	cmp	w21, #1
	b.ne	LBB3_441
; %bb.431:
	mov	x0, x22
	bl	___cxa_begin_catch
	ldr	x8, [x0]
	ldr	x8, [x8, #16]
	blr	x8
	mov	x19, x0
	bl	_strlen
	mov	x2, x0
Ltmp245:
Lloh113:
	adrp	x0, __ZNSt3__14cerrE@GOTPAGE
Lloh114:
	ldr	x0, [x0, __ZNSt3__14cerrE@GOTPAGEOFF]
	mov	x1, x19
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp246:
; %bb.432:
	mov	w8, #10                         ; =0xa
	sturb	w8, [x29, #-232]
Ltmp247:
	sub	x1, x29, #232
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp248:
; %bb.433:
Ltmp253:
	bl	___cxa_end_catch
Ltmp254:
; %bb.434:
	mov	w0, #1                          ; =0x1
LBB3_435:
	ldur	x8, [x29, #-128]
Lloh115:
	adrp	x9, ___stack_chk_guard@GOTPAGE
Lloh116:
	ldr	x9, [x9, ___stack_chk_guard@GOTPAGEOFF]
Lloh117:
	ldr	x9, [x9]
	cmp	x9, x8
	b.ne	LBB3_437
; %bb.436:
	add	sp, sp, #448
	ldp	x29, x30, [sp, #112]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #96]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #80]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #64]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #48]             ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #32]             ; 16-byte Folded Reload
	ldp	d9, d8, [sp, #16]               ; 16-byte Folded Reload
	ldp	d11, d10, [sp], #128            ; 16-byte Folded Reload
	ret
LBB3_437:
	bl	___stack_chk_fail
LBB3_438:
Ltmp255:
	bl	__Unwind_Resume
LBB3_439:
Ltmp249:
	mov	x22, x0
Ltmp250:
	bl	___cxa_end_catch
Ltmp251:
	b	LBB3_441
LBB3_440:
Ltmp252:
	mov	x22, x0
	cbnz	w1, LBB3_442
LBB3_441:
	mov	x0, x22
	bl	__Unwind_Resume
LBB3_442:
	mov	x0, x22
	bl	___clang_call_terminate
	.loh AdrpLdr	Lloh11, Lloh12
	.loh AdrpAdrp	Lloh9, Lloh11
	.loh AdrpLdr	Lloh9, Lloh10
	.loh AdrpAdrp	Lloh7, Lloh9
	.loh AdrpLdr	Lloh7, Lloh8
	.loh AdrpLdr	Lloh5, Lloh6
	.loh AdrpLdrGotLdr	Lloh2, Lloh3, Lloh4
	.loh AdrpAdd	Lloh13, Lloh14
	.loh AdrpAdd	Lloh15, Lloh16
	.loh AdrpAdd	Lloh17, Lloh18
	.loh AdrpAdd	Lloh19, Lloh20
	.loh AdrpLdrGot	Lloh25, Lloh26
	.loh AdrpLdrGot	Lloh23, Lloh24
	.loh AdrpLdrGot	Lloh21, Lloh22
	.loh AdrpAdd	Lloh27, Lloh28
	.loh AdrpAdd	Lloh29, Lloh30
	.loh AdrpLdrGot	Lloh33, Lloh34
	.loh AdrpLdrGot	Lloh31, Lloh32
	.loh AdrpAdd	Lloh35, Lloh36
	.loh AdrpLdrGot	Lloh41, Lloh42
	.loh AdrpLdrGot	Lloh39, Lloh40
	.loh AdrpLdrGot	Lloh37, Lloh38
	.loh AdrpAdd	Lloh45, Lloh46
	.loh AdrpLdrGot	Lloh43, Lloh44
	.loh AdrpAdd	Lloh47, Lloh48
	.loh AdrpLdr	Lloh51, Lloh52
	.loh AdrpAdrp	Lloh49, Lloh51
	.loh AdrpLdr	Lloh49, Lloh50
	.loh AdrpAdd	Lloh53, Lloh54
	.loh AdrpAdd	Lloh57, Lloh58
	.loh AdrpLdrGot	Lloh55, Lloh56
	.loh AdrpAdd	Lloh59, Lloh60
	.loh AdrpAdd	Lloh61, Lloh62
	.loh AdrpAdd	Lloh63, Lloh64
	.loh AdrpAdd	Lloh65, Lloh66
	.loh AdrpAdd	Lloh69, Lloh70
	.loh AdrpLdrGot	Lloh67, Lloh68
	.loh AdrpAdd	Lloh71, Lloh72
	.loh AdrpAdd	Lloh73, Lloh74
	.loh AdrpAdd	Lloh77, Lloh78
	.loh AdrpLdrGot	Lloh75, Lloh76
	.loh AdrpAdd	Lloh79, Lloh80
	.loh AdrpAdd	Lloh81, Lloh82
	.loh AdrpAdd	Lloh85, Lloh86
	.loh AdrpLdrGot	Lloh83, Lloh84
	.loh AdrpAdd	Lloh87, Lloh88
	.loh AdrpAdd	Lloh89, Lloh90
	.loh AdrpAdd	Lloh93, Lloh94
	.loh AdrpLdrGot	Lloh91, Lloh92
	.loh AdrpAdd	Lloh95, Lloh96
	.loh AdrpAdd	Lloh99, Lloh100
	.loh AdrpLdrGot	Lloh97, Lloh98
	.loh AdrpAdd	Lloh101, Lloh102
	.loh AdrpAdd	Lloh103, Lloh104
	.loh AdrpAdd	Lloh107, Lloh108
	.loh AdrpLdrGot	Lloh105, Lloh106
	.loh AdrpAdd	Lloh109, Lloh110
	.loh AdrpAdd	Lloh111, Lloh112
	.loh AdrpLdrGot	Lloh113, Lloh114
	.loh AdrpLdrGotLdr	Lloh115, Lloh116, Lloh117
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
	.uleb128 Ltmp3-Lfunc_begin1             ; >> Call Site 1 <<
	.uleb128 Ltmp4-Ltmp3                    ;   Call between Ltmp3 and Ltmp4
	.uleb128 Ltmp5-Lfunc_begin1             ;     jumps to Ltmp5
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp4-Lfunc_begin1             ; >> Call Site 2 <<
	.uleb128 Ltmp9-Ltmp4                    ;   Call between Ltmp4 and Ltmp9
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp9-Lfunc_begin1             ; >> Call Site 3 <<
	.uleb128 Ltmp10-Ltmp9                   ;   Call between Ltmp9 and Ltmp10
	.uleb128 Ltmp11-Lfunc_begin1            ;     jumps to Ltmp11
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp10-Lfunc_begin1            ; >> Call Site 4 <<
	.uleb128 Ltmp12-Ltmp10                  ;   Call between Ltmp10 and Ltmp12
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp12-Lfunc_begin1            ; >> Call Site 5 <<
	.uleb128 Ltmp13-Ltmp12                  ;   Call between Ltmp12 and Ltmp13
	.uleb128 Ltmp14-Lfunc_begin1            ;     jumps to Ltmp14
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp18-Lfunc_begin1            ; >> Call Site 6 <<
	.uleb128 Ltmp19-Ltmp18                  ;   Call between Ltmp18 and Ltmp19
	.uleb128 Ltmp20-Lfunc_begin1            ;     jumps to Ltmp20
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp19-Lfunc_begin1            ; >> Call Site 7 <<
	.uleb128 Ltmp21-Ltmp19                  ;   Call between Ltmp19 and Ltmp21
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp21-Lfunc_begin1            ; >> Call Site 8 <<
	.uleb128 Ltmp22-Ltmp21                  ;   Call between Ltmp21 and Ltmp22
	.uleb128 Ltmp23-Lfunc_begin1            ;     jumps to Ltmp23
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp22-Lfunc_begin1            ; >> Call Site 9 <<
	.uleb128 Ltmp24-Ltmp22                  ;   Call between Ltmp22 and Ltmp24
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp24-Lfunc_begin1            ; >> Call Site 10 <<
	.uleb128 Ltmp25-Ltmp24                  ;   Call between Ltmp24 and Ltmp25
	.uleb128 Ltmp26-Lfunc_begin1            ;     jumps to Ltmp26
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp25-Lfunc_begin1            ; >> Call Site 11 <<
	.uleb128 Ltmp33-Ltmp25                  ;   Call between Ltmp25 and Ltmp33
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp33-Lfunc_begin1            ; >> Call Site 12 <<
	.uleb128 Ltmp34-Ltmp33                  ;   Call between Ltmp33 and Ltmp34
	.uleb128 Ltmp35-Lfunc_begin1            ;     jumps to Ltmp35
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp36-Lfunc_begin1            ; >> Call Site 13 <<
	.uleb128 Ltmp37-Ltmp36                  ;   Call between Ltmp36 and Ltmp37
	.uleb128 Ltmp38-Lfunc_begin1            ;     jumps to Ltmp38
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp37-Lfunc_begin1            ; >> Call Site 14 <<
	.uleb128 Ltmp30-Ltmp37                  ;   Call between Ltmp37 and Ltmp30
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp30-Lfunc_begin1            ; >> Call Site 15 <<
	.uleb128 Ltmp31-Ltmp30                  ;   Call between Ltmp30 and Ltmp31
	.uleb128 Ltmp32-Lfunc_begin1            ;     jumps to Ltmp32
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp31-Lfunc_begin1            ; >> Call Site 16 <<
	.uleb128 Ltmp233-Ltmp31                 ;   Call between Ltmp31 and Ltmp233
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp233-Lfunc_begin1           ; >> Call Site 17 <<
	.uleb128 Ltmp234-Ltmp233                ;   Call between Ltmp233 and Ltmp234
	.uleb128 Ltmp235-Lfunc_begin1           ;     jumps to Ltmp235
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp236-Lfunc_begin1           ; >> Call Site 18 <<
	.uleb128 Ltmp237-Ltmp236                ;   Call between Ltmp236 and Ltmp237
	.uleb128 Ltmp238-Lfunc_begin1           ;     jumps to Ltmp238
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp237-Lfunc_begin1           ; >> Call Site 19 <<
	.uleb128 Ltmp239-Ltmp237                ;   Call between Ltmp237 and Ltmp239
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp239-Lfunc_begin1           ; >> Call Site 20 <<
	.uleb128 Ltmp240-Ltmp239                ;   Call between Ltmp239 and Ltmp240
	.uleb128 Ltmp241-Lfunc_begin1           ;     jumps to Ltmp241
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp242-Lfunc_begin1           ; >> Call Site 21 <<
	.uleb128 Ltmp243-Ltmp242                ;   Call between Ltmp242 and Ltmp243
	.uleb128 Ltmp244-Lfunc_begin1           ;     jumps to Ltmp244
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp6-Lfunc_begin1             ; >> Call Site 22 <<
	.uleb128 Ltmp7-Ltmp6                    ;   Call between Ltmp6 and Ltmp7
	.uleb128 Ltmp8-Lfunc_begin1             ;     jumps to Ltmp8
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp27-Lfunc_begin1            ; >> Call Site 23 <<
	.uleb128 Ltmp28-Ltmp27                  ;   Call between Ltmp27 and Ltmp28
	.uleb128 Ltmp29-Lfunc_begin1            ;     jumps to Ltmp29
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp15-Lfunc_begin1            ; >> Call Site 24 <<
	.uleb128 Ltmp16-Ltmp15                  ;   Call between Ltmp15 and Ltmp16
	.uleb128 Ltmp17-Lfunc_begin1            ;     jumps to Ltmp17
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp16-Lfunc_begin1            ; >> Call Site 25 <<
	.uleb128 Ltmp39-Ltmp16                  ;   Call between Ltmp16 and Ltmp39
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp39-Lfunc_begin1            ; >> Call Site 26 <<
	.uleb128 Ltmp40-Ltmp39                  ;   Call between Ltmp39 and Ltmp40
	.uleb128 Ltmp41-Lfunc_begin1            ;     jumps to Ltmp41
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp42-Lfunc_begin1            ; >> Call Site 27 <<
	.uleb128 Ltmp47-Ltmp42                  ;   Call between Ltmp42 and Ltmp47
	.uleb128 Ltmp48-Lfunc_begin1            ;     jumps to Ltmp48
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp49-Lfunc_begin1            ; >> Call Site 28 <<
	.uleb128 Ltmp50-Ltmp49                  ;   Call between Ltmp49 and Ltmp50
	.uleb128 Ltmp51-Lfunc_begin1            ;     jumps to Ltmp51
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp52-Lfunc_begin1            ; >> Call Site 29 <<
	.uleb128 Ltmp53-Ltmp52                  ;   Call between Ltmp52 and Ltmp53
	.uleb128 Ltmp54-Lfunc_begin1            ;     jumps to Ltmp54
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp55-Lfunc_begin1            ; >> Call Site 30 <<
	.uleb128 Ltmp56-Ltmp55                  ;   Call between Ltmp55 and Ltmp56
	.uleb128 Ltmp57-Lfunc_begin1            ;     jumps to Ltmp57
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp58-Lfunc_begin1            ; >> Call Site 31 <<
	.uleb128 Ltmp59-Ltmp58                  ;   Call between Ltmp58 and Ltmp59
	.uleb128 Ltmp60-Lfunc_begin1            ;     jumps to Ltmp60
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp59-Lfunc_begin1            ; >> Call Site 32 <<
	.uleb128 Ltmp64-Ltmp59                  ;   Call between Ltmp59 and Ltmp64
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp64-Lfunc_begin1            ; >> Call Site 33 <<
	.uleb128 Ltmp85-Ltmp64                  ;   Call between Ltmp64 and Ltmp85
	.uleb128 Ltmp138-Lfunc_begin1           ;     jumps to Ltmp138
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp86-Lfunc_begin1            ; >> Call Site 34 <<
	.uleb128 Ltmp87-Ltmp86                  ;   Call between Ltmp86 and Ltmp87
	.uleb128 Ltmp88-Lfunc_begin1            ;     jumps to Ltmp88
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp87-Lfunc_begin1            ; >> Call Site 35 <<
	.uleb128 Ltmp94-Ltmp87                  ;   Call between Ltmp87 and Ltmp94
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp94-Lfunc_begin1            ; >> Call Site 36 <<
	.uleb128 Ltmp107-Ltmp94                 ;   Call between Ltmp94 and Ltmp107
	.uleb128 Ltmp108-Lfunc_begin1           ;     jumps to Ltmp108
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp109-Lfunc_begin1           ; >> Call Site 37 <<
	.uleb128 Ltmp110-Ltmp109                ;   Call between Ltmp109 and Ltmp110
	.uleb128 Ltmp111-Lfunc_begin1           ;     jumps to Ltmp111
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp110-Lfunc_begin1           ; >> Call Site 38 <<
	.uleb128 Ltmp117-Ltmp110                ;   Call between Ltmp110 and Ltmp117
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp117-Lfunc_begin1           ; >> Call Site 39 <<
	.uleb128 Ltmp130-Ltmp117                ;   Call between Ltmp117 and Ltmp130
	.uleb128 Ltmp131-Lfunc_begin1           ;     jumps to Ltmp131
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp132-Lfunc_begin1           ; >> Call Site 40 <<
	.uleb128 Ltmp137-Ltmp132                ;   Call between Ltmp132 and Ltmp137
	.uleb128 Ltmp138-Lfunc_begin1           ;     jumps to Ltmp138
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp142-Lfunc_begin1           ; >> Call Site 41 <<
	.uleb128 Ltmp143-Ltmp142                ;   Call between Ltmp142 and Ltmp143
	.uleb128 Ltmp144-Lfunc_begin1           ;     jumps to Ltmp144
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp143-Lfunc_begin1           ; >> Call Site 42 <<
	.uleb128 Ltmp145-Ltmp143                ;   Call between Ltmp143 and Ltmp145
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp145-Lfunc_begin1           ; >> Call Site 43 <<
	.uleb128 Ltmp146-Ltmp145                ;   Call between Ltmp145 and Ltmp146
	.uleb128 Ltmp147-Lfunc_begin1           ;     jumps to Ltmp147
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp146-Lfunc_begin1           ; >> Call Site 44 <<
	.uleb128 Ltmp153-Ltmp146                ;   Call between Ltmp146 and Ltmp153
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp153-Lfunc_begin1           ; >> Call Site 45 <<
	.uleb128 Ltmp166-Ltmp153                ;   Call between Ltmp153 and Ltmp166
	.uleb128 Ltmp167-Lfunc_begin1           ;     jumps to Ltmp167
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp168-Lfunc_begin1           ; >> Call Site 46 <<
	.uleb128 Ltmp173-Ltmp168                ;   Call between Ltmp168 and Ltmp173
	.uleb128 Ltmp203-Lfunc_begin1           ;     jumps to Ltmp203
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp174-Lfunc_begin1           ; >> Call Site 47 <<
	.uleb128 Ltmp175-Ltmp174                ;   Call between Ltmp174 and Ltmp175
	.uleb128 Ltmp176-Lfunc_begin1           ;     jumps to Ltmp176
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp175-Lfunc_begin1           ; >> Call Site 48 <<
	.uleb128 Ltmp182-Ltmp175                ;   Call between Ltmp175 and Ltmp182
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp182-Lfunc_begin1           ; >> Call Site 49 <<
	.uleb128 Ltmp195-Ltmp182                ;   Call between Ltmp182 and Ltmp195
	.uleb128 Ltmp196-Lfunc_begin1           ;     jumps to Ltmp196
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp197-Lfunc_begin1           ; >> Call Site 50 <<
	.uleb128 Ltmp202-Ltmp197                ;   Call between Ltmp197 and Ltmp202
	.uleb128 Ltmp203-Lfunc_begin1           ;     jumps to Ltmp203
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp207-Lfunc_begin1           ; >> Call Site 51 <<
	.uleb128 Ltmp208-Ltmp207                ;   Call between Ltmp207 and Ltmp208
	.uleb128 Ltmp209-Lfunc_begin1           ;     jumps to Ltmp209
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp208-Lfunc_begin1           ; >> Call Site 52 <<
	.uleb128 Ltmp210-Ltmp208                ;   Call between Ltmp208 and Ltmp210
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp210-Lfunc_begin1           ; >> Call Site 53 <<
	.uleb128 Ltmp211-Ltmp210                ;   Call between Ltmp210 and Ltmp211
	.uleb128 Ltmp212-Lfunc_begin1           ;     jumps to Ltmp212
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp211-Lfunc_begin1           ; >> Call Site 54 <<
	.uleb128 Ltmp218-Ltmp211                ;   Call between Ltmp211 and Ltmp218
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp218-Lfunc_begin1           ; >> Call Site 55 <<
	.uleb128 Ltmp231-Ltmp218                ;   Call between Ltmp218 and Ltmp231
	.uleb128 Ltmp232-Lfunc_begin1           ;     jumps to Ltmp232
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp204-Lfunc_begin1           ; >> Call Site 56 <<
	.uleb128 Ltmp205-Ltmp204                ;   Call between Ltmp204 and Ltmp205
	.uleb128 Ltmp206-Lfunc_begin1           ;     jumps to Ltmp206
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp61-Lfunc_begin1            ; >> Call Site 57 <<
	.uleb128 Ltmp62-Ltmp61                  ;   Call between Ltmp61 and Ltmp62
	.uleb128 Ltmp63-Lfunc_begin1            ;     jumps to Ltmp63
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp91-Lfunc_begin1            ; >> Call Site 58 <<
	.uleb128 Ltmp90-Ltmp91                  ;   Call between Ltmp91 and Ltmp90
	.uleb128 Ltmp93-Lfunc_begin1            ;     jumps to Ltmp93
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp114-Lfunc_begin1           ; >> Call Site 59 <<
	.uleb128 Ltmp113-Ltmp114                ;   Call between Ltmp114 and Ltmp113
	.uleb128 Ltmp116-Lfunc_begin1           ;     jumps to Ltmp116
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp139-Lfunc_begin1           ; >> Call Site 60 <<
	.uleb128 Ltmp140-Ltmp139                ;   Call between Ltmp139 and Ltmp140
	.uleb128 Ltmp141-Lfunc_begin1           ;     jumps to Ltmp141
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp150-Lfunc_begin1           ; >> Call Site 61 <<
	.uleb128 Ltmp149-Ltmp150                ;   Call between Ltmp150 and Ltmp149
	.uleb128 Ltmp152-Lfunc_begin1           ;     jumps to Ltmp152
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp179-Lfunc_begin1           ; >> Call Site 62 <<
	.uleb128 Ltmp178-Ltmp179                ;   Call between Ltmp179 and Ltmp178
	.uleb128 Ltmp181-Lfunc_begin1           ;     jumps to Ltmp181
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp215-Lfunc_begin1           ; >> Call Site 63 <<
	.uleb128 Ltmp214-Ltmp215                ;   Call between Ltmp215 and Ltmp214
	.uleb128 Ltmp217-Lfunc_begin1           ;     jumps to Ltmp217
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp214-Lfunc_begin1           ; >> Call Site 64 <<
	.uleb128 Ltmp245-Ltmp214                ;   Call between Ltmp214 and Ltmp245
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp245-Lfunc_begin1           ; >> Call Site 65 <<
	.uleb128 Ltmp248-Ltmp245                ;   Call between Ltmp245 and Ltmp248
	.uleb128 Ltmp249-Lfunc_begin1           ;     jumps to Ltmp249
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp253-Lfunc_begin1           ; >> Call Site 66 <<
	.uleb128 Ltmp254-Ltmp253                ;   Call between Ltmp253 and Ltmp254
	.uleb128 Ltmp255-Lfunc_begin1           ;     jumps to Ltmp255
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp254-Lfunc_begin1           ; >> Call Site 67 <<
	.uleb128 Ltmp250-Ltmp254                ;   Call between Ltmp254 and Ltmp250
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp250-Lfunc_begin1           ; >> Call Site 68 <<
	.uleb128 Ltmp251-Ltmp250                ;   Call between Ltmp250 and Ltmp251
	.uleb128 Ltmp252-Lfunc_begin1           ;     jumps to Ltmp252
	.byte	9                               ;   On action: 5
	.uleb128 Ltmp251-Lfunc_begin1           ; >> Call Site 69 <<
	.uleb128 Lfunc_end1-Ltmp251             ;   Call between Ltmp251 and Lfunc_end1
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
	.byte	121                             ;   Continue to action 2
	.p2align	2, 0x0
                                        ; >> Catch TypeInfos <<
	.long	0                               ; TypeInfo 3
Ltmp293:                                ; TypeInfo 2
	.long	__ZTISt16invalid_argument@GOT-Ltmp293
Ltmp294:                                ; TypeInfo 1
	.long	__ZTISt9exception@GOT-Ltmp294
Lttbase0:
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
	.section	__TEXT,__literal16,16byte_literals
	.p2align	4, 0x0                          ; -- Begin function _ZN7WeightsC2Eiii
lCPI5_0:
	.quad	2                               ; 0x2
	.quad	3                               ; 0x3
lCPI5_1:
	.quad	0                               ; 0x0
	.quad	1                               ; 0x1
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__ZN7WeightsC2Eiii
	.weak_def_can_be_hidden	__ZN7WeightsC2Eiii
	.p2align	2
__ZN7WeightsC2Eiii:                     ; @_ZN7WeightsC2Eiii
Lfunc_begin2:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception2
; %bb.0:
	sub	sp, sp, #64
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
	mov	x19, x0
	stp	w1, w2, [x0]
	str	w3, [x0, #8]
	mov	x20, x0
	str	xzr, [x20, #16]!
	stp	xzr, xzr, [x0, #24]
	tbnz	w1, #31, LBB5_28
; %bb.1:
	cmp	w1, #2048
	b.hi	LBB5_28
; %bb.2:
	cmp	w2, #2048
	b.hi	LBB5_28
; %bb.3:
	cmp	w3, w2
	b.lt	LBB5_28
; %bb.4:
	cmp	w3, #1, lsl #12                 ; =4096
	b.gt	LBB5_28
; %bb.5:
	umull	x8, w3, w1
	str	wzr, [sp, #12]
	cbz	x8, LBB5_8
; %bb.6:
Ltmp256:
	add	x2, sp, #12
	mov	x0, x20
	mov	x1, x8
	bl	__ZNSt3__16vectorIfNS_9allocatorIfEEE8__appendEmRKf
Ltmp257:
; %bb.7:
	ldr	w1, [x19]
LBB5_8:
	cmp	w1, #1
	b.lt	LBB5_27
; %bb.9:
	ldr	w10, [x19, #4]
	cmp	w10, #1
	b.lt	LBB5_27
; %bb.10:
	ldrsw	x13, [x19, #8]
	ldr	x9, [x19, #16]
	mov	w8, w1
	cmp	w10, #3
	b.hi	LBB5_16
; %bb.11:
	mov	w11, #0                         ; =0x0
	add	x9, x9, #8
	lsl	x12, x13, #2
	mov	w13, #-5                        ; =0xfffffffb
	mov	w14, #6                         ; =0x6
	mov	w15, #-8                        ; =0xfffffff8
	mov	w16, #3                         ; =0x3
	mov	w17, #-11                       ; =0xfffffff5
	mov	w0, #17097                      ; =0x42c9
	movk	w0, #45590, lsl #16
	mov	w1, #23                         ; =0x17
	b	LBB5_13
LBB5_12:                                ;   in Loop: Header=BB5_13 Depth=1
	add	x9, x9, x12
	add	w13, w13, #7
	add	w14, w14, #7
	add	w15, w15, #7
	add	w16, w16, #7
	add	w17, w17, #7
	add	w11, w11, #7
	subs	x8, x8, #1
	b.eq	LBB5_27
LBB5_13:                                ; =>This Inner Loop Header: Depth=1
	umull	x2, w11, w0
	lsr	x2, x2, #36
	msub	w2, w2, w1, w17
	scvtf	s0, w2, #4
	stur	s0, [x9, #-8]
	cmp	w10, #1
	b.eq	LBB5_12
; %bb.14:                               ;   in Loop: Header=BB5_13 Depth=1
	umull	x2, w16, w0
	lsr	x2, x2, #36
	msub	w2, w2, w1, w15
	scvtf	s0, w2, #4
	stur	s0, [x9, #-4]
	cmp	w10, #2
	b.eq	LBB5_12
; %bb.15:                               ;   in Loop: Header=BB5_13 Depth=1
	umull	x2, w14, w0
	lsr	x2, x2, #36
	msub	w2, w2, w1, w13
	scvtf	s0, w2, #4
	str	s0, [x9]
	b	LBB5_12
LBB5_16:
	and	x11, x10, #0x7ffffffc
	cmp	x11, x10
	b.ne	LBB5_21
; %bb.17:
	mov	x10, #0                         ; =0x0
	lsl	x12, x13, #2
Lloh118:
	adrp	x13, lCPI5_0@PAGE
Lloh119:
	ldr	q0, [x13, lCPI5_0@PAGEOFF]
Lloh120:
	adrp	x13, lCPI5_1@PAGE
Lloh121:
	ldr	q1, [x13, lCPI5_1@PAGEOFF]
	mov	w13, #17097                     ; =0x42c9
	movk	w13, #45590, lsl #16
	dup.4s	v2, w13
	movi.4s	v3, #23
	mvni.4s	v4, #10
	mov	w13, #1031798784                ; =0x3d800000
	dup.4s	v5, w13
	mov	w13, #4                         ; =0x4
	dup.2d	v6, x13
LBB5_18:                                ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB5_19 Depth 2
	lsl	x13, x10, #3
	sub	x13, x13, x10
	dup.2d	v7, x13
	mov	x13, x9
	mov	x14, x11
	mov.16b	v16, v1
	mov.16b	v17, v0
LBB5_19:                                ;   Parent Loop BB5_18 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	mov.d	x15, v17[1]
	fmov	x16, d17
	add	w16, w16, w16, lsl #1
	fmov	d18, x16
	fmov	x16, d16
	add	w16, w16, w16, lsl #1
	add	w15, w15, w15, lsl #1
	fmov	d19, x16
	mov.d	x16, v16[1]
	add	w16, w16, w16, lsl #1
	mov.d	v18[1], x15
	mov.d	v19[1], x16
	add.2d	v19, v19, v7
	add.2d	v18, v18, v7
	uzp1.4s	v18, v19, v18
	umull2.2d	v19, v18, v2
	umull.2d	v20, v18, v2
	uzp2.4s	v19, v20, v19
	ushr.4s	v19, v19, #4
	mls.4s	v18, v19, v3
	add.4s	v18, v18, v4
	scvtf.4s	v18, v18
	fmul.4s	v18, v18, v5
	str	q18, [x13], #16
	add.2d	v17, v17, v6
	add.2d	v16, v16, v6
	subs	x14, x14, #4
	b.ne	LBB5_19
; %bb.20:                               ;   in Loop: Header=BB5_18 Depth=1
	add	x10, x10, #1
	add	x9, x9, x12
	cmp	x10, x8
	b.ne	LBB5_18
	b	LBB5_27
LBB5_21:
	mov	x12, #0                         ; =0x0
	lsl	x13, x13, #2
	lsr	w14, w10, #2
	ubfx	w15, w10, #2, #29
	add	w14, w15, w14, lsl #1
	lsl	w14, w14, #2
	sub	w15, w14, #11
Lloh122:
	adrp	x16, lCPI5_0@PAGE
Lloh123:
	ldr	q0, [x16, lCPI5_0@PAGEOFF]
Lloh124:
	adrp	x16, lCPI5_1@PAGE
Lloh125:
	ldr	q1, [x16, lCPI5_1@PAGEOFF]
	mov	w16, #17097                     ; =0x42c9
	movk	w16, #45590, lsl #16
	dup.4s	v2, w16
	movi.4s	v3, #23
	mvni.4s	v4, #10
	mov	w17, #1031798784                ; =0x3d800000
	dup.4s	v5, w17
	mov	w17, #4                         ; =0x4
	dup.2d	v6, x17
	mov	w17, #23                        ; =0x17
LBB5_22:                                ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB5_23 Depth 2
                                        ;     Child Loop BB5_25 Depth 2
	lsl	x0, x12, #3
	sub	x0, x0, x12
	dup.2d	v7, x0
	mov	x0, x9
	mov	x1, x11
	mov.16b	v16, v1
	mov.16b	v17, v0
LBB5_23:                                ;   Parent Loop BB5_22 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	mov.d	x2, v17[1]
	fmov	x3, d17
	add	w3, w3, w3, lsl #1
	fmov	d18, x3
	fmov	x3, d16
	add	w3, w3, w3, lsl #1
	add	w2, w2, w2, lsl #1
	fmov	d19, x3
	mov.d	x3, v16[1]
	add	w3, w3, w3, lsl #1
	mov.d	v18[1], x2
	mov.d	v19[1], x3
	add.2d	v19, v19, v7
	add.2d	v18, v18, v7
	uzp1.4s	v18, v19, v18
	umull2.2d	v19, v18, v2
	umull.2d	v20, v18, v2
	uzp2.4s	v19, v20, v19
	ushr.4s	v19, v19, #4
	mls.4s	v18, v19, v3
	add.4s	v18, v18, v4
	scvtf.4s	v18, v18
	fmul.4s	v18, v18, v5
	str	q18, [x0], #16
	add.2d	v17, v17, v6
	add.2d	v16, v16, v6
	subs	x1, x1, #4
	b.ne	LBB5_23
; %bb.24:                               ;   in Loop: Header=BB5_22 Depth=1
	mov	x0, x14
	mov	x1, x15
	mov	x2, x11
LBB5_25:                                ;   Parent Loop BB5_22 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	umull	x3, w0, w16
	lsr	x3, x3, #36
	msub	w3, w3, w17, w1
	scvtf	s7, w3, #4
	str	s7, [x9, x2, lsl #2]
	add	x2, x2, #1
	add	w1, w1, #3
	add	w0, w0, #3
	cmp	x10, x2
	b.ne	LBB5_25
; %bb.26:                               ;   in Loop: Header=BB5_22 Depth=1
	add	x12, x12, #1
	add	x9, x9, x13
	add	w15, w15, #7
	add	w14, w14, #7
	cmp	x12, x8
	b.ne	LBB5_22
LBB5_27:
	mov	x0, x19
	ldp	x29, x30, [sp, #48]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #32]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #64
	ret
LBB5_28:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x22, x0
Ltmp259:
Lloh126:
	adrp	x1, l_.str.16@PAGE
Lloh127:
	add	x1, x1, l_.str.16@PAGEOFF
	bl	__ZNSt11logic_errorC2EPKc
Ltmp260:
; %bb.29:
Lloh128:
	adrp	x8, __ZTVSt16invalid_argument@GOTPAGE
Lloh129:
	ldr	x8, [x8, __ZTVSt16invalid_argument@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x22]
Ltmp262:
Lloh130:
	adrp	x1, __ZTISt16invalid_argument@GOTPAGE
Lloh131:
	ldr	x1, [x1, __ZTISt16invalid_argument@GOTPAGEOFF]
Lloh132:
	adrp	x2, __ZNSt16invalid_argumentD1Ev@GOTPAGE
Lloh133:
	ldr	x2, [x2, __ZNSt16invalid_argumentD1Ev@GOTPAGEOFF]
	mov	x0, x22
	bl	___cxa_throw
Ltmp263:
; %bb.30:
	brk	#0x1
LBB5_31:
Ltmp258:
	b	LBB5_33
LBB5_32:
Ltmp264:
LBB5_33:
	mov	x21, x0
	b	LBB5_35
LBB5_34:
Ltmp261:
	mov	x21, x0
	mov	x0, x22
	bl	___cxa_free_exception
LBB5_35:
	ldr	x0, [x20]
	cbz	x0, LBB5_37
; %bb.36:
	str	x0, [x19, #24]
	bl	__ZdlPv
LBB5_37:
	mov	x0, x21
	bl	__Unwind_Resume
	.loh AdrpLdr	Lloh120, Lloh121
	.loh AdrpAdrp	Lloh118, Lloh120
	.loh AdrpLdr	Lloh118, Lloh119
	.loh AdrpLdr	Lloh124, Lloh125
	.loh AdrpAdrp	Lloh122, Lloh124
	.loh AdrpLdr	Lloh122, Lloh123
	.loh AdrpAdd	Lloh126, Lloh127
	.loh AdrpLdrGot	Lloh132, Lloh133
	.loh AdrpLdrGot	Lloh130, Lloh131
	.loh AdrpLdrGot	Lloh128, Lloh129
Lfunc_end2:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table5:
Lexception2:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end2-Lcst_begin2
Lcst_begin2:
	.uleb128 Ltmp256-Lfunc_begin2           ; >> Call Site 1 <<
	.uleb128 Ltmp257-Ltmp256                ;   Call between Ltmp256 and Ltmp257
	.uleb128 Ltmp258-Lfunc_begin2           ;     jumps to Ltmp258
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp257-Lfunc_begin2           ; >> Call Site 2 <<
	.uleb128 Ltmp259-Ltmp257                ;   Call between Ltmp257 and Ltmp259
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp259-Lfunc_begin2           ; >> Call Site 3 <<
	.uleb128 Ltmp260-Ltmp259                ;   Call between Ltmp259 and Ltmp260
	.uleb128 Ltmp261-Lfunc_begin2           ;     jumps to Ltmp261
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp262-Lfunc_begin2           ; >> Call Site 4 <<
	.uleb128 Ltmp263-Ltmp262                ;   Call between Ltmp262 and Ltmp263
	.uleb128 Ltmp264-Lfunc_begin2           ;     jumps to Ltmp264
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp263-Lfunc_begin2           ; >> Call Site 5 <<
	.uleb128 Lfunc_end2-Ltmp263             ;   Call between Ltmp263 and Lfunc_end2
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end2:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.private_extern	__ZNSt3__16vectorIfNS_9allocatorIfEEE8__appendEmRKf ; -- Begin function _ZNSt3__16vectorIfNS_9allocatorIfEEE8__appendEmRKf
	.globl	__ZNSt3__16vectorIfNS_9allocatorIfEEE8__appendEmRKf
	.weak_def_can_be_hidden	__ZNSt3__16vectorIfNS_9allocatorIfEEE8__appendEmRKf
	.p2align	2
__ZNSt3__16vectorIfNS_9allocatorIfEEE8__appendEmRKf: ; @_ZNSt3__16vectorIfNS_9allocatorIfEEE8__appendEmRKf
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
	ldp	x22, x8, [x0, #8]
	sub	x9, x8, x22
	cmp	x1, x9, asr #2
	b.ls	LBB6_5
; %bb.1:
	ldr	x20, [x19]
	sub	x21, x22, x20
	asr	x23, x21, #2
	add	x9, x23, x1
	lsr	x10, x9, #62
	cbnz	x10, LBB6_36
; %bb.2:
	mov	x10, #9223372036854775804       ; =0x7ffffffffffffffc
	sub	x8, x8, x20
	asr	x11, x8, #1
	cmp	x11, x9
	csel	x9, x11, x9, hi
	cmp	x8, x10
	mov	x8, #4611686018427387903        ; =0x3fffffffffffffff
	csel	x24, x9, x8, lo
	cbz	x24, LBB6_9
; %bb.3:
	lsr	x8, x24, #62
	cbnz	x8, LBB6_37
; %bb.4:
	mov	x25, x1
	mov	x26, x2
	lsl	x0, x24, #2
	bl	__Znwm
	mov	x2, x26
	mov	x1, x25
	b	LBB6_10
LBB6_5:
	cbz	x1, LBB6_34
; %bb.6:
	lsl	x9, x1, #2
	add	x8, x22, x9
	ldr	s0, [x2]
	sub	x10, x9, #4
	cmp	x10, #12
	b.lo	LBB6_32
; %bb.7:
	lsr	x9, x10, #2
	add	x9, x9, #1
	cmp	x10, #60
	b.hs	LBB6_20
; %bb.8:
	mov	x10, #0                         ; =0x0
	b	LBB6_24
LBB6_9:
	mov	x0, #0                          ; =0x0
LBB6_10:
	lsl	x9, x1, #2
	add	x8, x0, x21
	add	x25, x8, x9
	ldr	s0, [x2]
	sub	x11, x9, #4
	mov	x10, x8
	cmp	x11, #12
	b.lo	LBB6_28
; %bb.11:
	lsr	x9, x11, #2
	add	x9, x9, #1
	cmp	x11, #60
	b.hs	LBB6_13
; %bb.12:
	mov	x11, #0                         ; =0x0
	b	LBB6_17
LBB6_13:
	and	x11, x9, #0x7ffffffffffffff0
	dup.4s	v1, v0[0]
	add	x10, x21, x0
	add	x10, x10, #32
	mov	x12, x11
LBB6_14:                                ; =>This Inner Loop Header: Depth=1
	stp	q1, q1, [x10, #-32]
	stp	q1, q1, [x10], #64
	subs	x12, x12, #16
	b.ne	LBB6_14
; %bb.15:
	cmp	x9, x11
	b.eq	LBB6_29
; %bb.16:
	tst	x9, #0xc
	b.eq	LBB6_27
LBB6_17:
	and	x12, x9, #0x7ffffffffffffffc
	add	x10, x8, x12, lsl #2
	dup.4s	v1, v0[0]
	add	x13, x22, x11, lsl #2
	sub	x13, x13, x20
	add	x13, x0, x13
	sub	x11, x11, x12
LBB6_18:                                ; =>This Inner Loop Header: Depth=1
	str	q1, [x13], #16
	adds	x11, x11, #4
	b.ne	LBB6_18
; %bb.19:
	cmp	x9, x12
	b.ne	LBB6_28
	b	LBB6_29
LBB6_20:
	and	x10, x9, #0x7ffffffffffffff0
	dup.4s	v1, v0[0]
	add	x11, x22, #32
	mov	x12, x10
LBB6_21:                                ; =>This Inner Loop Header: Depth=1
	stp	q1, q1, [x11, #-32]
	stp	q1, q1, [x11], #64
	subs	x12, x12, #16
	b.ne	LBB6_21
; %bb.22:
	cmp	x9, x10
	b.eq	LBB6_33
; %bb.23:
	tst	x9, #0xc
	b.eq	LBB6_31
LBB6_24:
	and	x11, x9, #0x7ffffffffffffffc
	add	x12, x22, x11, lsl #2
	dup.4s	v1, v0[0]
	add	x13, x22, x10, lsl #2
	sub	x10, x10, x11
LBB6_25:                                ; =>This Inner Loop Header: Depth=1
	str	q1, [x13], #16
	adds	x10, x10, #4
	b.ne	LBB6_25
; %bb.26:
	mov	x22, x12
	cmp	x9, x11
	b.ne	LBB6_32
	b	LBB6_33
LBB6_27:
	add	x10, x8, x11, lsl #2
LBB6_28:                                ; =>This Inner Loop Header: Depth=1
	str	s0, [x10], #4
	cmp	x10, x25
	b.ne	LBB6_28
LBB6_29:
	add	x24, x0, x24, lsl #2
	sub	x22, x8, x23, lsl #2
	mov	x0, x22
	mov	x1, x20
	mov	x2, x21
	bl	_memcpy
	stp	x22, x25, [x19]
	str	x24, [x19, #16]
	cbz	x20, LBB6_35
; %bb.30:
	mov	x0, x20
	ldp	x29, x30, [sp, #64]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #48]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #32]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #16]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp], #80             ; 16-byte Folded Reload
	b	__ZdlPv
LBB6_31:
	add	x22, x22, x10, lsl #2
LBB6_32:                                ; =>This Inner Loop Header: Depth=1
	str	s0, [x22], #4
	cmp	x22, x8
	b.ne	LBB6_32
LBB6_33:
	mov	x22, x8
LBB6_34:
	str	x22, [x19, #8]
LBB6_35:
	ldp	x29, x30, [sp, #64]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #48]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #32]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #16]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp], #80             ; 16-byte Folded Reload
	ret
LBB6_36:
	bl	__ZNSt3__16vectorIfNS_9allocatorIfEEE20__throw_length_errorB9nqe210106Ev
LBB6_37:
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
Lloh134:
	adrp	x0, l_.str.17@PAGE
Lloh135:
	add	x0, x0, l_.str.17@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh134, Lloh135
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
Ltmp265:
	mov	x1, x20
	bl	__ZNSt12length_errorC1B9nqe210106EPKc
Ltmp266:
; %bb.1:
Lloh136:
	adrp	x1, __ZTISt12length_error@GOTPAGE
Lloh137:
	ldr	x1, [x1, __ZTISt12length_error@GOTPAGEOFF]
Lloh138:
	adrp	x2, __ZNSt12length_errorD1Ev@GOTPAGE
Lloh139:
	ldr	x2, [x2, __ZNSt12length_errorD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
LBB8_2:
Ltmp267:
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x0, x20
	bl	__Unwind_Resume
	.loh AdrpLdrGot	Lloh138, Lloh139
	.loh AdrpLdrGot	Lloh136, Lloh137
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
	.uleb128 Ltmp265-Lfunc_begin3           ;   Call between Lfunc_begin3 and Ltmp265
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp265-Lfunc_begin3           ; >> Call Site 2 <<
	.uleb128 Ltmp266-Ltmp265                ;   Call between Ltmp265 and Ltmp266
	.uleb128 Ltmp267-Lfunc_begin3           ;     jumps to Ltmp267
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp266-Lfunc_begin3           ; >> Call Site 3 <<
	.uleb128 Lfunc_end3-Ltmp266             ;   Call between Ltmp266 and Lfunc_end3
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
Lloh140:
	adrp	x8, __ZTVSt12length_error@GOTPAGE
Lloh141:
	ldr	x8, [x8, __ZTVSt12length_error@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x0]
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
	.loh AdrpLdrGot	Lloh140, Lloh141
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
Lloh142:
	adrp	x1, __ZTISt20bad_array_new_length@GOTPAGE
Lloh143:
	ldr	x1, [x1, __ZTISt20bad_array_new_length@GOTPAGEOFF]
Lloh144:
	adrp	x2, __ZNSt20bad_array_new_lengthD1Ev@GOTPAGE
Lloh145:
	ldr	x2, [x2, __ZNSt20bad_array_new_lengthD1Ev@GOTPAGEOFF]
	bl	___cxa_throw
	.loh AdrpLdrGot	Lloh144, Lloh145
	.loh AdrpLdrGot	Lloh142, Lloh143
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
Ltmp268:
	add	x0, sp, #8
	mov	x1, x19
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryC1ERS3_
Ltmp269:
; %bb.1:
	ldrb	w8, [sp, #8]
	cmp	w8, #1
	b.ne	LBB11_10
; %bb.2:
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
	add	x4, x19, x8
	ldr	x22, [x4, #40]
	ldr	w24, [x4, #8]
	ldr	w23, [x4, #144]
	cmn	w23, #1
	b.ne	LBB11_7
; %bb.3:
Ltmp271:
	add	x8, sp, #24
	mov	x25, x4
	mov	x0, x4
	bl	__ZNKSt3__18ios_base6getlocEv
Ltmp272:
; %bb.4:
Ltmp273:
Lloh146:
	adrp	x1, __ZNSt3__15ctypeIcE2idE@GOTPAGE
Lloh147:
	ldr	x1, [x1, __ZNSt3__15ctypeIcE2idE@GOTPAGEOFF]
	add	x0, sp, #24
	bl	__ZNKSt3__16locale9use_facetERNS0_2idE
Ltmp274:
; %bb.5:
	ldr	x8, [x0]
	ldr	x8, [x8, #56]
Ltmp275:
	mov	w1, #32                         ; =0x20
	blr	x8
Ltmp276:
; %bb.6:
	mov	x23, x0
	add	x0, sp, #24
	bl	__ZNSt3__16localeD1Ev
	mov	x4, x25
	str	w23, [x25, #144]
LBB11_7:
	mov	w8, #176                        ; =0xb0
	and	w8, w24, w8
	add	x3, x20, x21
	cmp	w8, #32
	csel	x2, x3, x20, eq
Ltmp278:
	sxtb	w5, w23
	mov	x0, x22
	mov	x1, x20
	bl	__ZNSt3__116__pad_and_outputB9nqe210106IcNS_11char_traitsIcEEEENS_19ostreambuf_iteratorIT_T0_EES6_PKS4_S8_S8_RNS_8ios_baseES4_
Ltmp279:
; %bb.8:
	cbnz	x0, LBB11_10
; %bb.9:
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
	add	x0, x19, x8
	ldr	w8, [x0, #32]
	mov	w9, #5                          ; =0x5
Ltmp281:
	orr	w1, w8, w9
	bl	__ZNSt3__18ios_base5clearEj
Ltmp282:
LBB11_10:
	add	x0, sp, #8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryD1Ev
LBB11_11:
	mov	x0, x19
	ldp	x29, x30, [sp, #96]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #80]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #64]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #48]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #112
	ret
LBB11_12:
Ltmp283:
	b	LBB11_15
LBB11_13:
Ltmp277:
	mov	x20, x0
	add	x0, sp, #24
	bl	__ZNSt3__16localeD1Ev
	b	LBB11_16
LBB11_14:
Ltmp280:
LBB11_15:
	mov	x20, x0
LBB11_16:
	add	x0, sp, #8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryD1Ev
	b	LBB11_18
LBB11_17:
Ltmp270:
	mov	x20, x0
LBB11_18:
	mov	x0, x20
	bl	___cxa_begin_catch
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
Ltmp284:
	add	x0, x19, x8
	bl	__ZNSt3__18ios_base33__set_badbit_and_consider_rethrowEv
Ltmp285:
; %bb.19:
	bl	___cxa_end_catch
	b	LBB11_11
LBB11_20:
Ltmp286:
	mov	x19, x0
Ltmp287:
	bl	___cxa_end_catch
Ltmp288:
; %bb.21:
	mov	x0, x19
	bl	__Unwind_Resume
LBB11_22:
Ltmp289:
	bl	___clang_call_terminate
	.loh AdrpLdrGot	Lloh146, Lloh147
Lfunc_end4:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table11:
Lexception4:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase1-Lttbaseref1
Lttbaseref1:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end4-Lcst_begin4
Lcst_begin4:
	.uleb128 Ltmp268-Lfunc_begin4           ; >> Call Site 1 <<
	.uleb128 Ltmp269-Ltmp268                ;   Call between Ltmp268 and Ltmp269
	.uleb128 Ltmp270-Lfunc_begin4           ;     jumps to Ltmp270
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp271-Lfunc_begin4           ; >> Call Site 2 <<
	.uleb128 Ltmp272-Ltmp271                ;   Call between Ltmp271 and Ltmp272
	.uleb128 Ltmp280-Lfunc_begin4           ;     jumps to Ltmp280
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp273-Lfunc_begin4           ; >> Call Site 3 <<
	.uleb128 Ltmp276-Ltmp273                ;   Call between Ltmp273 and Ltmp276
	.uleb128 Ltmp277-Lfunc_begin4           ;     jumps to Ltmp277
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp278-Lfunc_begin4           ; >> Call Site 4 <<
	.uleb128 Ltmp279-Ltmp278                ;   Call between Ltmp278 and Ltmp279
	.uleb128 Ltmp280-Lfunc_begin4           ;     jumps to Ltmp280
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp281-Lfunc_begin4           ; >> Call Site 5 <<
	.uleb128 Ltmp282-Ltmp281                ;   Call between Ltmp281 and Ltmp282
	.uleb128 Ltmp283-Lfunc_begin4           ;     jumps to Ltmp283
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp282-Lfunc_begin4           ; >> Call Site 6 <<
	.uleb128 Ltmp284-Ltmp282                ;   Call between Ltmp282 and Ltmp284
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp284-Lfunc_begin4           ; >> Call Site 7 <<
	.uleb128 Ltmp285-Ltmp284                ;   Call between Ltmp284 and Ltmp285
	.uleb128 Ltmp286-Lfunc_begin4           ;     jumps to Ltmp286
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp285-Lfunc_begin4           ; >> Call Site 8 <<
	.uleb128 Ltmp287-Ltmp285                ;   Call between Ltmp285 and Ltmp287
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp287-Lfunc_begin4           ; >> Call Site 9 <<
	.uleb128 Ltmp288-Ltmp287                ;   Call between Ltmp287 and Ltmp288
	.uleb128 Ltmp289-Lfunc_begin4           ;     jumps to Ltmp289
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp288-Lfunc_begin4           ; >> Call Site 10 <<
	.uleb128 Lfunc_end4-Ltmp288             ;   Call between Ltmp288 and Lfunc_end4
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
	cbz	x0, LBB12_16
; %bb.1:
	mov	x23, x5
	mov	x20, x4
	mov	x22, x3
	mov	x21, x2
	mov	x24, x1
	ldr	x26, [x4, #24]
	sub	x25, x2, x1
	cmp	x25, #1
	b.lt	LBB12_3
; %bb.2:
	ldr	x8, [x19]
	ldr	x8, [x8, #96]
	mov	x0, x19
	mov	x1, x24
	mov	x2, x25
	blr	x8
	cmp	x0, x25
	b.ne	LBB12_15
LBB12_3:
	sub	x8, x22, x24
	cmp	x26, x8
	b.le	LBB12_12
; %bb.4:
	mov	x9, #-9                         ; =0xfffffffffffffff7
	movk	x9, #32767, lsl #48
	sub	x24, x26, x8
	cmp	x24, x9
	b.hs	LBB12_17
; %bb.5:
	cmp	x24, #23
	b.hs	LBB12_7
; %bb.6:
	strb	w24, [sp, #31]
	add	x25, sp, #8
	b	LBB12_8
LBB12_7:
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
LBB12_8:
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
Ltmp290:
	mov	x0, x19
	mov	x2, x24
	blr	x8
Ltmp291:
; %bb.9:
	ldrsb	w8, [sp, #31]
	tbnz	w8, #31, LBB12_11
; %bb.10:
	cmp	x0, x24
	b.ne	LBB12_15
	b	LBB12_12
LBB12_11:
	ldr	x8, [sp, #8]
	mov	x23, x0
	mov	x0, x8
	bl	__ZdlPv
	cmp	x23, x24
	b.ne	LBB12_15
LBB12_12:
	sub	x22, x22, x21
	cmp	x22, #1
	b.lt	LBB12_14
; %bb.13:
	ldr	x8, [x19]
	ldr	x8, [x8, #96]
	mov	x0, x19
	mov	x1, x21
	mov	x2, x22
	blr	x8
	cmp	x0, x22
	b.ne	LBB12_15
LBB12_14:
	str	xzr, [x20, #24]
	b	LBB12_16
LBB12_15:
	mov	x19, #0                         ; =0x0
LBB12_16:
	mov	x0, x19
	ldp	x29, x30, [sp, #96]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #80]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #64]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #48]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #112
	ret
LBB12_17:
	bl	__ZNSt3__112basic_stringIcNS_11char_traitsIcEENS_9allocatorIcEEE20__throw_length_errorB9nqe210106Ev
LBB12_18:
Ltmp292:
	mov	x19, x0
	ldrsb	w8, [sp, #31]
	tbz	w8, #31, LBB12_20
; %bb.19:
	ldr	x0, [sp, #8]
	bl	__ZdlPv
LBB12_20:
	mov	x0, x19
	bl	__Unwind_Resume
Lfunc_end5:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table12:
Lexception5:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end5-Lcst_begin5
Lcst_begin5:
	.uleb128 Lfunc_begin5-Lfunc_begin5      ; >> Call Site 1 <<
	.uleb128 Ltmp290-Lfunc_begin5           ;   Call between Lfunc_begin5 and Ltmp290
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp290-Lfunc_begin5           ; >> Call Site 2 <<
	.uleb128 Ltmp291-Ltmp290                ;   Call between Ltmp290 and Ltmp291
	.uleb128 Ltmp292-Lfunc_begin5           ;     jumps to Ltmp292
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp291-Lfunc_begin5           ; >> Call Site 3 <<
	.uleb128 Lfunc_end5-Ltmp291             ;   Call between Ltmp291 and Lfunc_end5
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
Lloh148:
	adrp	x0, l_.str.18@PAGE
Lloh149:
	add	x0, x0, l_.str.18@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh148, Lloh149
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
Lloh150:
	adrp	x0, l_.str.17@PAGE
Lloh151:
	add	x0, x0, l_.str.17@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh150, Lloh151
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
Lloh152:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh153:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh154:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh155:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	bl	___cxa_throw
	.loh AdrpLdrGot	Lloh154, Lloh155
	.loh AdrpLdrGot	Lloh152, Lloh153
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"packing contract"

	.globl	_sink                           ; @sink
.zerofill __DATA,__common,_sink,8,3
	.section	__TEXT,__const
	.p2align	2, 0x0                          ; @constinit
l_constinit:
	.long	0                               ; 0x0
	.long	1                               ; 0x1
	.long	3                               ; 0x3
	.long	4                               ; 0x4
	.long	5                               ; 0x5
	.long	17                              ; 0x11

	.p2align	2, 0x0                          ; @constinit.1
l_constinit.1:
	.long	0                               ; 0x0
	.long	1                               ; 0x1
	.long	3                               ; 0x3
	.long	4                               ; 0x4
	.long	5                               ; 0x5
	.long	31                              ; 0x1f
	.long	33                              ; 0x21

	.section	__TEXT,__cstring,cstring_literals
l_.str.2:                               ; @.str.2
	.asciz	"PASS cases="

l_.str.3:                               ; @.str.3
	.asciz	" stride reject; identical direct/packed NEON order\n"

l_.str.4:                               ; @.str.4
	.asciz	"M="

l_.str.5:                               ; @.str.5
	.asciz	" N="

l_.str.6:                               ; @.str.6
	.asciz	" K="

l_.str.7:                               ; @.str.7
	.asciz	" stride="

l_.str.8:                               ; @.str.8
	.asciz	" packed_bytes="

l_.str.9:                               ; @.str.9
	.asciz	"direct"

l_.str.10:                              ; @.str.10
	.asciz	"packed_reused"

l_.str.11:                              ; @.str.11
	.asciz	"pack_only"

l_.str.12:                              ; @.str.12
	.asciz	"reuse="

l_.str.13:                              ; @.str.13
	.asciz	" transaction (pack allocation included)\n"

l_.str.14:                              ; @.str.14
	.asciz	"direct_R"

l_.str.15:                              ; @.str.15
	.asciz	"pack_plus_R"

l_.str.16:                              ; @.str.16
	.asciz	"shape/stride"

l_.str.17:                              ; @.str.17
	.asciz	"vector"

l_.str.18:                              ; @.str.18
	.asciz	"basic_string"

l_.str.19:                              ; @.str.19
	.asciz	" CPU_batch_mean_us P50="

l_.str.20:                              ; @.str.20
	.asciz	" P95="

	.section	__TEXT,__literal16,16byte_literals
	.p2align	4, 0x0                          ; @.memset_pattern
l_.memset_pattern:
	.long	0x3ec00000                      ; float 0.375
	.long	0x3ec00000                      ; float 0.375
	.long	0x3ec00000                      ; float 0.375
	.long	0x3ec00000                      ; float 0.375

.subsections_via_symbols
