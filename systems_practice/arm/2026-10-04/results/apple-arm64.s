	.build_version macos, 26, 0	sdk_version 26, 5
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__Z6scalarPKhPh5Image           ; -- Begin function _Z6scalarPKhPh5Image
	.p2align	2
__Z6scalarPKhPh5Image:                  ; @_Z6scalarPKhPh5Image
	.cfi_startproc
; %bb.0:
	ldr	x10, [x2, #8]
	cbz	x10, LBB0_7
; %bb.1:
	mov	x8, #0                          ; =0x0
	ldr	x9, [x2]
	b	LBB0_3
LBB0_2:                                 ;   in Loop: Header=BB0_3 Depth=1
	add	x8, x8, #1
	cmp	x8, x10
	b.hs	LBB0_7
LBB0_3:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB0_5 Depth 2
	cbz	x9, LBB0_2
; %bb.4:                                ;   in Loop: Header=BB0_3 Depth=1
	mov	x10, #0                         ; =0x0
	mov	x11, x0
LBB0_5:                                 ;   Parent Loop BB0_3 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	x12, [x2, #16]
	madd	x12, x8, x12, x11
	ldrb	w13, [x12]
	ldrb	w14, [x12, #1]
	add	w13, w13, w14, lsl #1
	ldrb	w12, [x12, #2]
	add	w12, w13, w12
	lsr	w12, w12, #2
	madd	x9, x8, x9, x1
	strb	w12, [x9, x10]
	add	x10, x10, #1
	ldr	x9, [x2]
	add	x11, x11, #3
	cmp	x10, x9
	b.lo	LBB0_5
; %bb.6:                                ;   in Loop: Header=BB0_3 Depth=1
	ldr	x10, [x2, #8]
	b	LBB0_2
LBB0_7:
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__Z8weighted17__simd128_uint8_tS_S_ ; -- Begin function _Z8weighted17__simd128_uint8_tS_S_
	.p2align	2
__Z8weighted17__simd128_uint8_tS_S_:    ; @_Z8weighted17__simd128_uint8_tS_S_
	.cfi_startproc
; %bb.0:
	uaddl.8h	v3, v2, v0
	uaddl2.8h	v0, v2, v0
	ushll.8h	v2, v1, #1
	ushll2.8h	v1, v1, #1
	add.8h	v1, v0, v1
	add.8h	v0, v3, v2
	shrn.8b	v0, v0, #2
	shrn2.16b	v0, v1, #2
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__Z6directPKhPh5Image           ; -- Begin function _Z6directPKhPh5Image
	.p2align	2
__Z6directPKhPh5Image:                  ; @_Z6directPKhPh5Image
	.cfi_startproc
; %bb.0:
	ldr	x8, [x2, #8]
	cbz	x8, LBB2_10
; %bb.1:
	mov	x8, #0                          ; =0x0
	ldr	x10, [x2]
	add	x9, x0, #2
	b	LBB2_3
LBB2_2:                                 ;   in Loop: Header=BB2_3 Depth=1
	add	x8, x8, #1
	ldr	x11, [x2, #8]
	cmp	x8, x11
	b.hs	LBB2_10
LBB2_3:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB2_6 Depth 2
                                        ;     Child Loop BB2_9 Depth 2
	ldr	x11, [x2, #16]
	cmp	x10, #16
	b.hs	LBB2_5
; %bb.4:                                ;   in Loop: Header=BB2_3 Depth=1
	mov	x12, #0                         ; =0x0
	b	LBB2_7
LBB2_5:                                 ;   in Loop: Header=BB2_3 Depth=1
	mov	x14, #0                         ; =0x0
	madd	x13, x11, x8, x0
LBB2_6:                                 ;   Parent Loop BB2_3 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ld3.16b	{ v0, v1, v2 }, [x13], #48
	uaddl.8h	v3, v2, v0
	uaddl2.8h	v4, v2, v0
	ushll.8h	v5, v1, #1
	ushll2.8h	v0, v1, #1
	add.8h	v0, v4, v0
	add.8h	v1, v3, v5
	shrn.8b	v1, v1, #2
	shrn2.16b	v1, v0, #2
	madd	x10, x8, x10, x1
	str	q1, [x10, x14]
	ldr	x10, [x2]
	add	x12, x14, #16
	add	x15, x14, #32
	mov	x14, x12
	cmp	x15, x10
	b.ls	LBB2_6
LBB2_7:                                 ;   in Loop: Header=BB2_3 Depth=1
	cmp	x12, x10
	b.hs	LBB2_2
; %bb.8:                                ;   in Loop: Header=BB2_3 Depth=1
	add	x13, x12, x12, lsl #1
	madd	x11, x11, x8, x13
	add	x11, x9, x11
LBB2_9:                                 ;   Parent Loop BB2_3 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldurb	w13, [x11, #-2]
	ldurb	w14, [x11, #-1]
	add	w13, w13, w14, lsl #1
	ldrb	w14, [x11], #3
	add	w13, w13, w14
	lsr	w13, w13, #2
	madd	x10, x8, x10, x1
	strb	w13, [x10, x12]
	add	x12, x12, #1
	ldr	x10, [x2]
	cmp	x12, x10
	b.lo	LBB2_9
	b	LBB2_2
LBB2_10:
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__Z4packPKhPh5Image             ; -- Begin function _Z4packPKhPh5Image
	.p2align	2
__Z4packPKhPh5Image:                    ; @_Z4packPKhPh5Image
	.cfi_startproc
; %bb.0:
	ldr	x9, [x2, #8]
	cbz	x9, LBB3_10
; %bb.1:
	mov	x8, #0                          ; =0x0
	ldr	x11, [x2]
	mul	x10, x9, x11
	add	x9, x1, x10
	add	x10, x1, x10, lsl #1
	b	LBB3_3
LBB3_2:                                 ;   in Loop: Header=BB3_3 Depth=1
	add	x8, x8, #1
	ldr	x12, [x2, #8]
	cmp	x8, x12
	b.hs	LBB3_10
LBB3_3:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB3_6 Depth 2
                                        ;     Child Loop BB3_9 Depth 2
	cmp	x11, #16
	b.hs	LBB3_5
; %bb.4:                                ;   in Loop: Header=BB3_3 Depth=1
	mov	x12, #0                         ; =0x0
	b	LBB3_7
LBB3_5:                                 ;   in Loop: Header=BB3_3 Depth=1
	mov	x14, #0                         ; =0x0
	mov	x13, x0
LBB3_6:                                 ;   Parent Loop BB3_3 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	x12, [x2, #16]
	madd	x12, x8, x12, x13
	ld3.16b	{ v0, v1, v2 }, [x12]
	madd	x11, x8, x11, x1
	str	q0, [x11, x14]
	ldr	x11, [x2]
	madd	x11, x8, x11, x9
	str	q1, [x11, x14]
	ldr	x11, [x2]
	madd	x11, x8, x11, x10
	str	q2, [x11, x14]
	ldr	x11, [x2]
	add	x12, x14, #16
	add	x13, x13, #48
	add	x15, x14, #32
	mov	x14, x12
	cmp	x15, x11
	b.ls	LBB3_6
LBB3_7:                                 ;   in Loop: Header=BB3_3 Depth=1
	cmp	x12, x11
	b.hs	LBB3_2
; %bb.8:                                ;   in Loop: Header=BB3_3 Depth=1
	add	x13, x12, x12, lsl #1
	add	x13, x0, x13
LBB3_9:                                 ;   Parent Loop BB3_3 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	x14, [x2, #16]
	mul	x14, x8, x14
	ldrb	w14, [x13, x14]
	madd	x11, x8, x11, x1
	strb	w14, [x11, x12]
	ldr	x11, [x2, #16]
	madd	x11, x8, x11, x13
	ldrb	w11, [x11, #1]
	ldr	x14, [x2]
	madd	x14, x8, x14, x9
	strb	w11, [x14, x12]
	ldr	x11, [x2, #16]
	madd	x11, x8, x11, x13
	ldrb	w11, [x11, #2]
	ldr	x14, [x2]
	madd	x14, x8, x14, x10
	strb	w11, [x14, x12]
	add	x12, x12, #1
	ldr	x11, [x2]
	add	x13, x13, #3
	cmp	x12, x11
	b.lo	LBB3_9
	b	LBB3_2
LBB3_10:
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__Z3soaPKhPhm                   ; -- Begin function _Z3soaPKhPhm
	.p2align	2
__Z3soaPKhPhm:                          ; @_Z3soaPKhPhm
	.cfi_startproc
; %bb.0:
	cmp	x2, #16
	b.hs	LBB4_2
; %bb.1:
	mov	x9, #0                          ; =0x0
	b	LBB4_4
LBB4_2:
	mov	x11, #0                         ; =0x0
	add	x8, x0, x2
	add	x10, x0, x2, lsl #1
LBB4_3:                                 ; =>This Inner Loop Header: Depth=1
	ldr	q0, [x0, x11]
	ldr	q1, [x8, x11]
	ldr	q2, [x10, x11]
	uaddl.8h	v3, v2, v0
	uaddl2.8h	v0, v2, v0
	ushll.8h	v2, v1, #1
	ushll2.8h	v1, v1, #1
	add.8h	v0, v0, v1
	add.8h	v1, v3, v2
	shrn.8b	v1, v1, #2
	shrn2.16b	v1, v0, #2
	str	q1, [x1, x11]
	add	x9, x11, #16
	add	x12, x11, #32
	mov	x11, x9
	cmp	x12, x2
	b.ls	LBB4_3
LBB4_4:
	subs	x10, x2, x9
	b.ls	LBB4_9
; %bb.5:
	lsl	x8, x2, #1
	cmp	x10, #7
	b.hi	LBB4_10
LBB4_6:
	mov	x10, x9
LBB4_7:
	sub	x9, x2, x10
	add	x11, x1, x10
	add	x10, x0, x10
LBB4_8:                                 ; =>This Inner Loop Header: Depth=1
	ldrb	w12, [x10]
	ldrb	w13, [x10, x2]
	add	w12, w12, w13, lsl #1
	ldrb	w13, [x10, x8]
	add	w12, w12, w13
	lsr	w12, w12, #2
	strb	w12, [x11], #1
	add	x10, x10, #1
	subs	x9, x9, #1
	b.ne	LBB4_8
LBB4_9:
	ret
LBB4_10:
	sub	x11, x1, x0
	sub	x11, x11, x8
	cmp	x11, #64
	b.lo	LBB4_6
; %bb.11:
	add	x11, x2, x0
	sub	x11, x1, x11
	cmp	x11, #64
	b.lo	LBB4_6
; %bb.12:
	sub	x11, x1, x0
	cmp	x11, #64
	b.lo	LBB4_6
; %bb.13:
	cmp	x10, #64
	b.hs	LBB4_15
; %bb.14:
	mov	x11, #0                         ; =0x0
	b	LBB4_19
LBB4_15:
	and	x11, x10, #0xffffffffffffffc0
	add	x14, x9, #32
	add	x12, x0, x14
	add	x13, x9, x2
	add	x13, x13, x0
	add	x13, x13, #32
	add	x14, x1, x14
	add	x15, x9, x8
	add	x15, x15, x0
	add	x15, x15, #32
	mov	x16, x11
LBB4_16:                                ; =>This Inner Loop Header: Depth=1
	ldp	q0, q1, [x12, #-32]
	ldp	q2, q3, [x12], #64
	ldp	q4, q5, [x13, #-32]
	ldp	q6, q7, [x13], #64
	ushll2.8h	v16, v4, #1
	ushll.8h	v4, v4, #1
	ushll2.8h	v17, v5, #1
	ushll.8h	v5, v5, #1
	ushll2.8h	v18, v6, #1
	ushll.8h	v6, v6, #1
	ushll2.8h	v19, v7, #1
	ushll.8h	v7, v7, #1
	uaddw.8h	v4, v4, v0
	uaddw2.8h	v0, v16, v0
	uaddw.8h	v5, v5, v1
	uaddw2.8h	v1, v17, v1
	uaddw.8h	v6, v6, v2
	uaddw2.8h	v2, v18, v2
	uaddw.8h	v7, v7, v3
	uaddw2.8h	v3, v19, v3
	ldp	q16, q17, [x15, #-32]
	ldp	q18, q19, [x15], #64
	uaddw2.8h	v0, v0, v16
	uaddw.8h	v4, v4, v16
	uaddw2.8h	v1, v1, v17
	uaddw.8h	v5, v5, v17
	uaddw2.8h	v2, v2, v18
	uaddw.8h	v6, v6, v18
	uaddw2.8h	v3, v3, v19
	uaddw.8h	v7, v7, v19
	shrn.8b	v4, v4, #2
	shrn2.16b	v4, v0, #2
	shrn.8b	v0, v5, #2
	shrn2.16b	v0, v1, #2
	shrn.8b	v1, v6, #2
	shrn2.16b	v1, v2, #2
	shrn.8b	v2, v7, #2
	shrn2.16b	v2, v3, #2
	stp	q4, q0, [x14, #-32]
	stp	q1, q2, [x14], #64
	subs	x16, x16, #64
	b.ne	LBB4_16
; %bb.17:
	cmp	x10, x11
	b.eq	LBB4_9
; %bb.18:
	tst	x10, #0x38
	b.eq	LBB4_22
LBB4_19:
	and	x12, x2, #0x7
	sub	x10, x10, x12
	add	x10, x9, x10
	sub	x13, x2, x11
	sub	x13, x13, x12
	add	x14, x1, x11
	add	x15, x0, x11
	add	x16, x15, x8
	add	x11, x11, x2
	add	x11, x0, x11
LBB4_20:                                ; =>This Inner Loop Header: Depth=1
	ldr	d0, [x15, x9]
	ldr	d1, [x11, x9]
	ushll.8h	v1, v1, #1
	uaddw.8h	v0, v1, v0
	ldr	d1, [x16, x9]
	uaddw.8h	v0, v0, v1
	shrn.8b	v0, v0, #2
	str	d0, [x14, x9]
	sub	x13, x13, #8
	add	x14, x14, #8
	add	x16, x16, #8
	add	x11, x11, #8
	add	x15, x15, #8
	cmp	x9, x13
	b.ne	LBB4_20
; %bb.21:
	cbnz	x12, LBB4_7
	b	LBB4_9
LBB4_22:
	add	x10, x9, x11
	b	LBB4_7
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__literal16,16byte_literals
	.p2align	4, 0x0                          ; -- Begin function main
lCPI5_0:
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
	.section	__TEXT,__literal8,8byte_literals
	.p2align	3, 0x0
lCPI5_1:
	.byte	0                               ; 0x0
	.byte	1                               ; 0x1
	.byte	2                               ; 0x2
	.byte	3                               ; 0x3
	.byte	4                               ; 0x4
	.byte	5                               ; 0x5
	.byte	6                               ; 0x6
	.byte	7                               ; 0x7
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_main
	.p2align	2
_main:                                  ; @main
Lfunc_begin0:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception0
; %bb.0:
	sub	sp, sp, #272
	stp	d11, d10, [sp, #144]            ; 16-byte Folded Spill
	stp	d9, d8, [sp, #160]              ; 16-byte Folded Spill
	stp	x28, x27, [sp, #176]            ; 16-byte Folded Spill
	stp	x26, x25, [sp, #192]            ; 16-byte Folded Spill
	stp	x24, x23, [sp, #208]            ; 16-byte Folded Spill
	stp	x22, x21, [sp, #224]            ; 16-byte Folded Spill
	stp	x20, x19, [sp, #240]            ; 16-byte Folded Spill
	stp	x29, x30, [sp, #256]            ; 16-byte Folded Spill
	add	x29, sp, #256
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
	mov	x26, #0                         ; =0x0
	mov	x27, #0                         ; =0x0
	movi.8b	v9, #13
	movi.8b	v10, #8
	mov	w8, #40                         ; =0x28
	str	x8, [sp, #64]                   ; 8-byte Folded Spill
	mov	w8, #8                          ; =0x8
	str	x8, [sp, #80]                   ; 8-byte Folded Spill
	mov	w8, #63                         ; =0x3f
	str	x8, [sp, #56]                   ; 8-byte Folded Spill
	mov	w8, #15                         ; =0xf
	str	x8, [sp, #72]                   ; 8-byte Folded Spill
Lloh0:
	adrp	x8, lCPI5_1@PAGE
Lloh1:
	ldr	d8, [x8, lCPI5_1@PAGEOFF]
	mov	w21, #13                        ; =0xd
	mov	w28, #14                        ; =0xe
Lloh2:
	adrp	x8, lCPI5_0@PAGE
Lloh3:
	ldr	q0, [x8, lCPI5_0@PAGEOFF]
	str	q0, [sp]                        ; 16-byte Folded Spill
LBB5_1:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB5_12 Depth 2
                                        ;     Child Loop BB5_16 Depth 2
                                        ;     Child Loop BB5_18 Depth 2
                                        ;     Child Loop BB5_24 Depth 2
                                        ;     Child Loop BB5_28 Depth 2
                                        ;     Child Loop BB5_31 Depth 2
                                        ;     Child Loop BB5_37 Depth 2
                                        ;     Child Loop BB5_41 Depth 2
                                        ;     Child Loop BB5_44 Depth 2
	cmp	x26, #1
	csinc	x19, x26, xzr, hi
	add	x23, x27, x27, lsl #1
	cmp	x23, #1
	csinc	x25, x23, xzr, hi
	add	x24, x27, x27, lsl #3
Ltmp0:
	add	x0, x24, #22
	bl	__Znwm
Ltmp1:
; %bb.2:                                ;   in Loop: Header=BB5_1 Depth=1
	add	x2, x24, #22
	str	x0, [sp, #96]                   ; 8-byte Folded Spill
	mov	w1, #239                        ; =0xef
	bl	_memset
Ltmp3:
	add	x0, x23, #1
	bl	__Znwm
Ltmp4:
; %bb.3:                                ;   in Loop: Header=BB5_1 Depth=1
	mov	x20, x0
	add	x2, x23, #1
	mov	w1, #213                        ; =0xd5
	bl	_memset
Ltmp6:
	add	x0, x23, #1
	bl	__Znwm
Ltmp7:
; %bb.4:                                ;   in Loop: Header=BB5_1 Depth=1
	add	x2, x23, #1
	str	x0, [sp, #88]                   ; 8-byte Folded Spill
	mov	w1, #213                        ; =0xd5
	bl	_memset
Ltmp9:
	add	x0, x23, #1
	bl	__Znwm
Ltmp10:
; %bb.5:                                ;   in Loop: Header=BB5_1 Depth=1
	mov	x22, x0
	add	x2, x23, #1
	mov	w1, #213                        ; =0xd5
	bl	_memset
	add	x24, x24, #1
Ltmp12:
	mov	x0, x24
	bl	__Znwm
Ltmp13:
; %bb.6:                                ;   in Loop: Header=BB5_1 Depth=1
	str	x22, [sp, #48]                  ; 8-byte Folded Spill
	stp	x26, x0, [sp, #24]              ; 16-byte Folded Spill
	mov	w1, #221                        ; =0xdd
	mov	x2, x24
	bl	_memset
	ldr	x13, [sp, #96]                  ; 8-byte Folded Reload
	add	x26, x13, #1
	cbz	x27, LBB5_45
; %bb.7:                                ;   in Loop: Header=BB5_1 Depth=1
	and	x8, x19, #0xfffffffffffffff8
	and	x9, x19, #0xffffffffffffffc0
	cmp	x27, #2
	b.hi	LBB5_9
; %bb.8:                                ;   in Loop: Header=BB5_1 Depth=1
	mov	x10, #0                         ; =0x0
	movi.16b	v5, #13
	mov	w15, #7                         ; =0x7
	movi.16b	v18, #64
	movi.16b	v6, #7
	movi.16b	v7, #215
	movi.16b	v16, #167
	movi.16b	v17, #119
	b	LBB5_18
LBB5_9:                                 ;   in Loop: Header=BB5_1 Depth=1
	cmp	x27, #22
	movi.16b	v5, #13
	mov	w15, #7                         ; =0x7
	movi.16b	v18, #64
	movi.16b	v6, #7
	movi.16b	v7, #215
	movi.16b	v16, #167
	movi.16b	v17, #119
	movi.16b	v19, #208
	movi.16b	v20, #160
	movi.16b	v21, #112
	b.hs	LBB5_11
; %bb.10:                               ;   in Loop: Header=BB5_1 Depth=1
	mov	x10, #0                         ; =0x0
	b	LBB5_15
LBB5_11:                                ;   in Loop: Header=BB5_1 Depth=1
	and	x10, x25, #0x7fffffffffffffc0
	add	x11, x13, #33
	mov	x12, x9
	ldr	q0, [sp]                        ; 16-byte Folded Reload
LBB5_12:                                ;   Parent Loop BB5_1 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	mul.16b	v1, v0, v5
	add.16b	v2, v1, v19
	add.16b	v3, v1, v20
	add.16b	v4, v1, v21
	stp	q1, q2, [x11, #-32]
	stp	q3, q4, [x11], #64
	add.16b	v0, v0, v18
	subs	x12, x12, #64
	b.ne	LBB5_12
; %bb.13:                               ;   in Loop: Header=BB5_1 Depth=1
	cmp	x23, x10
	b.eq	LBB5_19
; %bb.14:                               ;   in Loop: Header=BB5_1 Depth=1
	tst	x25, #0x38
	b.eq	LBB5_18
LBB5_15:                                ;   in Loop: Header=BB5_1 Depth=1
	dup.8b	v0, w10
	sub	x11, x10, x8
	add	x12, x13, x10
	and	x10, x25, #0x7ffffffffffffff8
	orr.8b	v0, v0, v8
	add	x12, x12, #1
LBB5_16:                                ;   Parent Loop BB5_1 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	mul.8b	v1, v0, v9
	str	d1, [x12], #8
	add.8b	v0, v0, v10
	adds	x11, x11, #8
	b.ne	LBB5_16
; %bb.17:                               ;   in Loop: Header=BB5_1 Depth=1
	cmp	x23, x10
	b.eq	LBB5_19
LBB5_18:                                ;   Parent Loop BB5_1 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	mul	w11, w10, w21
	strb	w11, [x26, x10]
	add	x10, x10, #1
	cmp	x19, x10
	b.ne	LBB5_18
LBB5_19:                                ;   in Loop: Header=BB5_1 Depth=1
	cmp	x27, #3
	b.hs	LBB5_21
; %bb.20:                               ;   in Loop: Header=BB5_1 Depth=1
	mov	x10, #0                         ; =0x0
	b	LBB5_30
LBB5_21:                                ;   in Loop: Header=BB5_1 Depth=1
	cmp	x27, #22
	b.hs	LBB5_23
; %bb.22:                               ;   in Loop: Header=BB5_1 Depth=1
	mov	x10, #0                         ; =0x0
	b	LBB5_27
LBB5_23:                                ;   in Loop: Header=BB5_1 Depth=1
	and	x10, x25, #0x7fffffffffffffc0
	ldr	x11, [sp, #64]                  ; 8-byte Folded Reload
	add	x11, x13, x11
	mov	x12, x9
	ldr	q0, [sp]                        ; 16-byte Folded Reload
LBB5_24:                                ;   Parent Loop BB5_1 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	mul.16b	v1, v0, v5
	add.16b	v2, v1, v6
	add.16b	v3, v1, v7
	add.16b	v4, v1, v16
	add.16b	v1, v1, v17
	stp	q2, q3, [x11, #-32]
	stp	q4, q1, [x11], #64
	add.16b	v0, v0, v18
	subs	x12, x12, #64
	b.ne	LBB5_24
; %bb.25:                               ;   in Loop: Header=BB5_1 Depth=1
	cmp	x23, x10
	b.eq	LBB5_32
; %bb.26:                               ;   in Loop: Header=BB5_1 Depth=1
	tst	x25, #0x38
	b.eq	LBB5_30
LBB5_27:                                ;   in Loop: Header=BB5_1 Depth=1
	mov	x12, x10
	dup.8b	v0, w12
	sub	x11, x10, x8
	and	x10, x25, #0x7ffffffffffffff8
	orr.8b	v0, v0, v8
	ldr	x14, [sp, #80]                  ; 8-byte Folded Reload
	add	x12, x12, x14
	add	x12, x13, x12
LBB5_28:                                ;   Parent Loop BB5_1 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	movi.8b	v1, #7
	mla.8b	v1, v0, v9
	str	d1, [x12], #8
	add.8b	v0, v0, v10
	adds	x11, x11, #8
	b.ne	LBB5_28
; %bb.29:                               ;   in Loop: Header=BB5_1 Depth=1
	cmp	x23, x10
	b.eq	LBB5_32
LBB5_30:                                ;   in Loop: Header=BB5_1 Depth=1
	ldr	x11, [sp, #80]                  ; 8-byte Folded Reload
	add	x11, x13, x11
LBB5_31:                                ;   Parent Loop BB5_1 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	madd	w12, w10, w21, w15
	strb	w12, [x11, x10]
	add	x10, x10, #1
	cmp	x19, x10
	b.ne	LBB5_31
LBB5_32:                                ;   in Loop: Header=BB5_1 Depth=1
	cmp	x27, #3
	b.hs	LBB5_34
; %bb.33:                               ;   in Loop: Header=BB5_1 Depth=1
	mov	x10, #0                         ; =0x0
	b	LBB5_43
LBB5_34:                                ;   in Loop: Header=BB5_1 Depth=1
	cmp	x27, #22
	b.hs	LBB5_36
; %bb.35:                               ;   in Loop: Header=BB5_1 Depth=1
	mov	x10, #0                         ; =0x0
	b	LBB5_40
LBB5_36:                                ;   in Loop: Header=BB5_1 Depth=1
	and	x10, x25, #0x7fffffffffffffc0
	ldr	x11, [sp, #56]                  ; 8-byte Folded Reload
	add	x11, x13, x11
	ldr	q0, [sp]                        ; 16-byte Folded Reload
	movi.16b	v6, #14
	movi.16b	v7, #222
	movi.16b	v16, #174
	movi.16b	v17, #126
LBB5_37:                                ;   Parent Loop BB5_1 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	mul.16b	v1, v0, v5
	add.16b	v2, v1, v6
	add.16b	v3, v1, v7
	add.16b	v4, v1, v16
	add.16b	v1, v1, v17
	stp	q2, q3, [x11, #-48]
	stp	q4, q1, [x11, #-16]
	add.16b	v0, v0, v18
	add	x11, x11, #64
	subs	x9, x9, #64
	b.ne	LBB5_37
; %bb.38:                               ;   in Loop: Header=BB5_1 Depth=1
	cmp	x23, x10
	b.eq	LBB5_45
; %bb.39:                               ;   in Loop: Header=BB5_1 Depth=1
	tst	x25, #0x38
	b.eq	LBB5_43
LBB5_40:                                ;   in Loop: Header=BB5_1 Depth=1
	mov	x9, x10
	dup.8b	v0, w9
	sub	x8, x10, x8
	and	x10, x25, #0x7ffffffffffffff8
	orr.8b	v0, v0, v8
	ldr	x11, [sp, #72]                  ; 8-byte Folded Reload
	add	x9, x9, x11
	add	x9, x13, x9
LBB5_41:                                ;   Parent Loop BB5_1 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	movi.8b	v1, #14
	mla.8b	v1, v0, v9
	str	d1, [x9], #8
	add.8b	v0, v0, v10
	adds	x8, x8, #8
	b.ne	LBB5_41
; %bb.42:                               ;   in Loop: Header=BB5_1 Depth=1
	cmp	x23, x10
	b.eq	LBB5_45
LBB5_43:                                ;   in Loop: Header=BB5_1 Depth=1
	ldr	x8, [sp, #72]                   ; 8-byte Folded Reload
	add	x8, x13, x8
LBB5_44:                                ;   Parent Loop BB5_1 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	madd	w9, w10, w21, w28
	strb	w9, [x8, x10]
	add	x10, x10, #1
	cmp	x19, x10
	b.ne	LBB5_44
LBB5_45:                                ;   in Loop: Header=BB5_1 Depth=1
	add	x19, x23, #7
	mov	w28, #3                         ; =0x3
	stp	x27, x28, [sp, #104]
	str	x19, [sp, #120]
	add	x2, sp, #104
	mov	x0, x26
	mov	x1, x20
	bl	__Z6scalarPKhPh5Image
	stp	x27, x28, [sp, #104]
	str	x19, [sp, #120]
	add	x2, sp, #104
	mov	x0, x26
	mov	x22, x20
	ldr	x20, [sp, #88]                  ; 8-byte Folded Reload
	mov	x1, x20
	bl	__Z6directPKhPh5Image
	stp	x27, x28, [sp, #104]
	str	x19, [sp, #120]
	add	x2, sp, #104
	mov	x0, x26
	ldr	x28, [sp, #32]                  ; 8-byte Folded Reload
	mov	x1, x28
	bl	__Z4packPKhPh5Image
	mov	x0, x28
	ldr	x19, [sp, #48]                  ; 8-byte Folded Reload
	mov	x1, x19
	mov	x2, x23
	bl	__Z3soaPKhPhm
	add	x2, x23, #1
	mov	x0, x22
	mov	x1, x20
	mov	x20, x22
	mov	x22, x19
	bl	_memcmp
	cbnz	w0, LBB5_51
; %bb.46:                               ;   in Loop: Header=BB5_1 Depth=1
	add	x2, x23, #1
	mov	x0, x20
	mov	x1, x22
	bl	_memcmp
	cbnz	w0, LBB5_51
; %bb.47:                               ;   in Loop: Header=BB5_1 Depth=1
	add	x8, x28, x24
	ldurb	w8, [x8, #-1]
	cmp	w8, #221
	b.ne	LBB5_51
; %bb.48:                               ;   in Loop: Header=BB5_1 Depth=1
	add	x27, x27, #1
	mov	x0, x28
	bl	__ZdlPv
	mov	x0, x22
	bl	__ZdlPv
	ldr	x0, [sp, #88]                   ; 8-byte Folded Reload
	bl	__ZdlPv
	mov	x0, x20
	bl	__ZdlPv
	ldr	x0, [sp, #96]                   ; 8-byte Folded Reload
	bl	__ZdlPv
	ldr	x26, [sp, #24]                  ; 8-byte Folded Reload
	add	x26, x26, #3
	ldr	x8, [sp, #64]                   ; 8-byte Folded Reload
	add	x9, x8, #3
	ldr	x8, [sp, #80]                   ; 8-byte Folded Reload
	add	x10, x8, #3
	ldr	x8, [sp, #56]                   ; 8-byte Folded Reload
	add	x8, x8, #6
	stp	x8, x9, [sp, #56]               ; 16-byte Folded Spill
	ldr	x8, [sp, #72]                   ; 8-byte Folded Reload
	add	x8, x8, #6
	stp	x8, x10, [sp, #72]              ; 16-byte Folded Spill
	cmp	x27, #66
	mov	w28, #14                        ; =0xe
	b.ne	LBB5_1
; %bb.49:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp21:
Lloh4:
	adrp	x1, l_.str.10@PAGE
Lloh5:
	add	x1, x1, l_.str.10@PAGEOFF
	bl	__ZNSt11logic_errorC2EPKc
Ltmp22:
; %bb.50:
Lloh6:
	adrp	x8, __ZTVSt16invalid_argument@GOTPAGE
Lloh7:
	ldr	x8, [x8, __ZTVSt16invalid_argument@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x19]
Ltmp24:
Lloh8:
	adrp	x1, __ZTISt16invalid_argument@GOTPAGE
Lloh9:
	ldr	x1, [x1, __ZTISt16invalid_argument@GOTPAGEOFF]
Lloh10:
	adrp	x2, __ZNSt16invalid_argumentD1Ev@GOTPAGE
Lloh11:
	ldr	x2, [x2, __ZNSt16invalid_argumentD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
Ltmp25:
	b	LBB5_189
LBB5_51:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x26, x0
Ltmp15:
Lloh12:
	adrp	x1, l_.str@PAGE
Lloh13:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp16:
; %bb.52:
Ltmp18:
Lloh14:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh15:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh16:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh17:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x26
	bl	___cxa_throw
Ltmp19:
	b	LBB5_189
LBB5_53:
Ltmp26:
	mov	x23, x1
	mov	x25, x0
	cmp	w23, #2
	b.eq	LBB5_55
	b	LBB5_236
LBB5_54:
Ltmp23:
	mov	x23, x1
	mov	x25, x0
	mov	x0, x19
	bl	___cxa_free_exception
	cmp	w23, #2
	b.ne	LBB5_236
LBB5_55:
	mov	x0, x25
	bl	___cxa_begin_catch
Ltmp27:
	bl	___cxa_end_catch
Ltmp28:
; %bb.56:
Ltmp30:
Lloh18:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh19:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh20:
	adrp	x1, l_.str.2@PAGE
Lloh21:
	add	x1, x1, l_.str.2@PAGEOFF
	mov	w2, #5                          ; =0x5
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp31:
; %bb.57:
Ltmp32:
	mov	w1, #66                         ; =0x42
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEi
Ltmp33:
; %bb.58:
Ltmp34:
Lloh22:
	adrp	x1, l_.str.3@PAGE
Lloh23:
	add	x1, x1, l_.str.3@PAGEOFF
	mov	w2, #60                         ; =0x3c
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp35:
; %bb.59:
	mov	x22, #0                         ; =0x0
	adrp	x26, _sink@PAGE
	movi.8b	v9, #17
	movi.8b	v10, #8
Lloh24:
	adrp	x8, lCPI5_0@PAGE
Lloh25:
	ldr	q0, [x8, lCPI5_0@PAGEOFF]
	str	q0, [sp, #32]                   ; 16-byte Folded Spill
	b	LBB5_61
LBB5_60:                                ;   in Loop: Header=BB5_61 Depth=1
	add	x22, x22, #24
	cmp	x22, #48
	b.eq	LBB5_177
LBB5_61:                                ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB5_77 Depth 2
                                        ;     Child Loop BB5_81 Depth 2
                                        ;     Child Loop BB5_92 Depth 2
                                        ;     Child Loop BB5_96 Depth 2
                                        ;       Child Loop BB5_97 Depth 3
                                        ;     Child Loop BB5_113 Depth 2
                                        ;     Child Loop BB5_117 Depth 2
                                        ;       Child Loop BB5_118 Depth 3
                                        ;     Child Loop BB5_136 Depth 2
                                        ;       Child Loop BB5_137 Depth 3
                                        ;     Child Loop BB5_153 Depth 2
                                        ;     Child Loop BB5_157 Depth 2
                                        ;       Child Loop BB5_158 Depth 3
Lloh26:
	adrp	x8, l_constinit@PAGE
Lloh27:
	add	x8, x8, l_constinit@PAGEOFF
	add	x8, x8, x22
	ldp	x25, x28, [x8]
	ldr	x23, [x8, #16]
	mul	x20, x23, x28
	str	x22, [sp, #48]                  ; 8-byte Folded Spill
	cbz	x20, LBB5_70
; %bb.62:                               ;   in Loop: Header=BB5_61 Depth=1
	tbnz	x20, #63, LBB5_186
; %bb.63:                               ;   in Loop: Header=BB5_61 Depth=1
Ltmp37:
	mov	x0, x20
	bl	__Znwm
Ltmp38:
; %bb.64:                               ;   in Loop: Header=BB5_61 Depth=1
	mov	x19, x0
	add	x27, x0, x20
	mov	w1, #17                         ; =0x11
	mov	x2, x20
	bl	_memset
	mul	x22, x28, x25
	cbz	x22, LBB5_71
LBB5_65:                                ;   in Loop: Header=BB5_61 Depth=1
	tbnz	x22, #63, LBB5_187
; %bb.66:                               ;   in Loop: Header=BB5_61 Depth=1
Ltmp43:
	mov	x0, x22
	bl	__Znwm
Ltmp44:
; %bb.67:                               ;   in Loop: Header=BB5_61 Depth=1
	mov	x20, x0
	mov	x1, x22
	bl	_bzero
	adds	x24, x22, x22, lsl #1
	b.mi	LBB5_188
; %bb.68:                               ;   in Loop: Header=BB5_61 Depth=1
Ltmp46:
	mov	x0, x24
	bl	__Znwm
Ltmp47:
; %bb.69:                               ;   in Loop: Header=BB5_61 Depth=1
	mov	x21, x0
	add	x22, x20, x22
	mov	x1, x24
	bl	_bzero
	subs	x8, x27, x19
	b.ne	LBB5_72
	b	LBB5_84
LBB5_70:                                ;   in Loop: Header=BB5_61 Depth=1
	mov	x27, #0                         ; =0x0
	mov	x19, #0                         ; =0x0
	mul	x22, x28, x25
	cbnz	x22, LBB5_65
LBB5_71:                                ;   in Loop: Header=BB5_61 Depth=1
	mov	x20, #0                         ; =0x0
	mov	x21, #0                         ; =0x0
	subs	x8, x27, x19
	b.eq	LBB5_84
LBB5_72:                                ;   in Loop: Header=BB5_61 Depth=1
	cmp	x8, #7
	b.hi	LBB5_74
; %bb.73:                               ;   in Loop: Header=BB5_61 Depth=1
	mov	x9, #0                          ; =0x0
	b	LBB5_82
LBB5_74:                                ;   in Loop: Header=BB5_61 Depth=1
	cmp	x8, #64
	b.hs	LBB5_76
; %bb.75:                               ;   in Loop: Header=BB5_61 Depth=1
	mov	x9, #0                          ; =0x0
	b	LBB5_80
LBB5_76:                                ;   in Loop: Header=BB5_61 Depth=1
	and	x9, x8, #0xffffffffffffffc0
	add	x10, x19, #32
	mov	x11, x9
	ldr	q0, [sp, #32]                   ; 16-byte Folded Reload
	movi.16b	v5, #17
	movi.16b	v6, #16
	movi.16b	v7, #32
	movi.16b	v16, #48
	movi.16b	v17, #64
LBB5_77:                                ;   Parent Loop BB5_61 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	mul.16b	v1, v0, v5
	add.16b	v2, v1, v6
	add.16b	v3, v1, v7
	add.16b	v4, v1, v16
	stp	q1, q2, [x10, #-32]
	stp	q3, q4, [x10], #64
	add.16b	v0, v0, v17
	subs	x11, x11, #64
	b.ne	LBB5_77
; %bb.78:                               ;   in Loop: Header=BB5_61 Depth=1
	cmp	x8, x9
	b.eq	LBB5_84
; %bb.79:                               ;   in Loop: Header=BB5_61 Depth=1
	tst	x8, #0x38
	b.eq	LBB5_82
LBB5_80:                                ;   in Loop: Header=BB5_61 Depth=1
	mov	x11, x9
	and	x9, x8, #0xfffffffffffffff8
	dup.8b	v0, w11
	orr.8b	v0, v0, v8
	sub	x10, x11, x9
	add	x11, x19, x11
LBB5_81:                                ;   Parent Loop BB5_61 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	mul.8b	v1, v0, v9
	str	d1, [x11], #8
	add.8b	v0, v0, v10
	adds	x10, x10, #8
	b.ne	LBB5_81
	b	LBB5_83
LBB5_82:                                ;   in Loop: Header=BB5_61 Depth=1
	add	w10, w9, w9, lsl #4
	strb	w10, [x19, x9]
	add	x9, x9, #1
LBB5_83:                                ;   in Loop: Header=BB5_61 Depth=1
	cmp	x8, x9
	b.ne	LBB5_82
LBB5_84:                                ;   in Loop: Header=BB5_61 Depth=1
	stp	x25, x28, [sp, #104]
	str	x23, [sp, #120]
	add	x2, sp, #104
	mov	x0, x19
	mov	x1, x21
	bl	__Z4packPKhPh5Image
Ltmp55:
Lloh28:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh29:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh30:
	adrp	x1, l_.str.4@PAGE
Lloh31:
	add	x1, x1, l_.str.4@PAGEOFF
	mov	w2, #6                          ; =0x6
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp56:
; %bb.85:                               ;   in Loop: Header=BB5_61 Depth=1
Ltmp57:
	mov	x1, x25
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp58:
; %bb.86:                               ;   in Loop: Header=BB5_61 Depth=1
	mov	w8, #120                        ; =0x78
	sturb	w8, [x29, #-121]
Ltmp59:
	sub	x1, x29, #121
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp60:
; %bb.87:                               ;   in Loop: Header=BB5_61 Depth=1
Ltmp61:
	mov	x1, x28
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp62:
; %bb.88:                               ;   in Loop: Header=BB5_61 Depth=1
Ltmp63:
Lloh32:
	adrp	x1, l_.str.5@PAGE
Lloh33:
	add	x1, x1, l_.str.5@PAGEOFF
	mov	w2, #8                          ; =0x8
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp64:
; %bb.89:                               ;   in Loop: Header=BB5_61 Depth=1
Ltmp65:
	mov	x1, x23
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp66:
; %bb.90:                               ;   in Loop: Header=BB5_61 Depth=1
	mov	w8, #10                         ; =0xa
	sturb	w8, [x29, #-121]
Ltmp67:
	sub	x1, x29, #121
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp68:
; %bb.91:                               ;   in Loop: Header=BB5_61 Depth=1
	mov	w24, #20                        ; =0x14
LBB5_92:                                ;   Parent Loop BB5_61 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	stp	x25, x28, [sp, #104]
	str	x23, [sp, #120]
	add	x2, sp, #104
	mov	x0, x19
	mov	x1, x20
	bl	__Z6scalarPKhPh5Image
	subs	w24, w24, #1
	b.ne	LBB5_92
; %bb.93:                               ;   in Loop: Header=BB5_61 Depth=1
	mov	x27, #0                         ; =0x0
	mov	x9, #0                          ; =0x0
	str	xzr, [sp, #64]                  ; 8-byte Folded Spill
	stp	xzr, xzr, [sp, #88]             ; 16-byte Folded Spill
	sub	x24, x22, x20
	b	LBB5_96
LBB5_94:                                ;   in Loop: Header=BB5_96 Depth=2
	str	d11, [x8], #8
	str	x8, [sp, #96]                   ; 8-byte Folded Spill
LBB5_95:                                ;   in Loop: Header=BB5_96 Depth=2
	ldr	x9, [sp, #72]                   ; 8-byte Folded Reload
	add	x8, x27, #1
	cmp	x8, x24
	csinc	x27, xzr, x27, eq
	add	x9, x9, #1
	cmp	x9, #31
	b.eq	LBB5_105
LBB5_96:                                ;   Parent Loop BB5_61 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB5_97 Depth 3
	str	x9, [sp, #72]                   ; 8-byte Folded Spill
	mov	w22, #16                        ; =0x10
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	str	x0, [sp, #80]                   ; 8-byte Folded Spill
LBB5_97:                                ;   Parent Loop BB5_61 Depth=1
                                        ;     Parent Loop BB5_96 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	stp	x25, x28, [sp, #104]
	str	x23, [sp, #120]
	add	x2, sp, #104
	mov	x0, x19
	mov	x1, x20
	bl	__Z6scalarPKhPh5Image
	ldrb	w8, [x20, x27]
	ldr	x9, [x26, _sink@PAGEOFF]
	add	x8, x9, x8
	str	x8, [x26, _sink@PAGEOFF]
	subs	w22, w22, #1
	b.ne	LBB5_97
; %bb.98:                               ;   in Loop: Header=BB5_96 Depth=2
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	ldp	x8, x9, [sp, #80]               ; 16-byte Folded Reload
	sub	x8, x0, x8
	scvtf	d0, x8
	mov	x8, #70368744177664             ; =0x400000000000
	movk	x8, #16527, lsl #48
	fmov	d1, x8
	fdiv	d0, d0, d1
	mov	x8, #4589168020290535424        ; =0x3fb0000000000000
	fmov	d1, x8
	fmul	d11, d0, d1
	ldr	x8, [sp, #96]                   ; 8-byte Folded Reload
	cmp	x8, x9
	b.lo	LBB5_94
; %bb.99:                               ;   in Loop: Header=BB5_96 Depth=2
	ldr	x10, [sp, #64]                  ; 8-byte Folded Reload
	sub	x11, x8, x10
	asr	x12, x11, #3
	add	x8, x12, #1
	lsr	x9, x8, #61
	cbnz	x9, LBB5_178
; %bb.100:                              ;   in Loop: Header=BB5_96 Depth=2
	str	x12, [sp, #96]                  ; 8-byte Folded Spill
	str	x11, [sp, #80]                  ; 8-byte Folded Spill
	ldr	x9, [sp, #88]                   ; 8-byte Folded Reload
	sub	x9, x9, x10
	asr	x10, x9, #2
	cmp	x10, x8
	csel	x8, x10, x8, hi
	mov	x10, #9223372036854775800       ; =0x7ffffffffffffff8
	cmp	x9, x10
	mov	x9, #2305843009213693951        ; =0x1fffffffffffffff
	csel	x22, x8, x9, lo
	lsr	x8, x22, #61
	cbnz	x8, LBB5_179
; %bb.101:                              ;   in Loop: Header=BB5_96 Depth=2
	lsl	x0, x22, #3
Ltmp70:
	bl	__Znwm
Ltmp71:
; %bb.102:                              ;   in Loop: Header=BB5_96 Depth=2
	ldr	x2, [sp, #80]                   ; 8-byte Folded Reload
	add	x8, x0, x2
	add	x10, x0, x22, lsl #3
	ldr	x9, [sp, #96]                   ; 8-byte Folded Reload
	sub	x0, x8, x9, lsl #3
	str	d11, [x8], #8
	stp	x10, x8, [sp, #88]              ; 16-byte Folded Spill
	str	x0, [sp, #56]                   ; 8-byte Folded Spill
	ldr	x22, [sp, #64]                  ; 8-byte Folded Reload
	mov	x1, x22
	bl	_memcpy
	cbz	x22, LBB5_104
; %bb.103:                              ;   in Loop: Header=BB5_96 Depth=2
	mov	x0, x22
	bl	__ZdlPv
LBB5_104:                               ;   in Loop: Header=BB5_96 Depth=2
	ldr	x8, [sp, #56]                   ; 8-byte Folded Reload
	str	x8, [sp, #64]                   ; 8-byte Folded Spill
	b	LBB5_95
LBB5_105:                               ;   in Loop: Header=BB5_61 Depth=1
Ltmp78:
	sub	x2, x29, #121
	ldr	x22, [sp, #64]                  ; 8-byte Folded Reload
	mov	x0, x22
	ldr	x1, [sp, #96]                   ; 8-byte Folded Reload
	bl	__ZNSt3__16__sortIRNS_6__lessIddEEPdEEvT0_S5_T_
Ltmp79:
; %bb.106:                              ;   in Loop: Header=BB5_61 Depth=1
Ltmp80:
Lloh34:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh35:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh36:
	adrp	x1, l_.str.6@PAGE
Lloh37:
	add	x1, x1, l_.str.6@PAGEOFF
	mov	w2, #14                         ; =0xe
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp81:
; %bb.107:                              ;   in Loop: Header=BB5_61 Depth=1
Ltmp82:
Lloh38:
	adrp	x1, l_.str.13@PAGE
Lloh39:
	add	x1, x1, l_.str.13@PAGEOFF
	mov	w2, #23                         ; =0x17
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp83:
; %bb.108:                              ;   in Loop: Header=BB5_61 Depth=1
	ldr	d0, [x22, #120]
Ltmp84:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp85:
; %bb.109:                              ;   in Loop: Header=BB5_61 Depth=1
Ltmp86:
Lloh40:
	adrp	x1, l_.str.14@PAGE
Lloh41:
	add	x1, x1, l_.str.14@PAGEOFF
	mov	w2, #5                          ; =0x5
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp87:
; %bb.110:                              ;   in Loop: Header=BB5_61 Depth=1
	ldr	d0, [x22, #232]
Ltmp88:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp89:
; %bb.111:                              ;   in Loop: Header=BB5_61 Depth=1
	mov	w8, #10                         ; =0xa
	sturb	w8, [x29, #-121]
Ltmp90:
	sub	x1, x29, #121
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp91:
; %bb.112:                              ;   in Loop: Header=BB5_61 Depth=1
	mov	x0, x22
	bl	__ZdlPv
	mov	w22, #20                        ; =0x14
LBB5_113:                               ;   Parent Loop BB5_61 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	stp	x25, x28, [sp, #104]
	str	x23, [sp, #120]
	add	x2, sp, #104
	mov	x0, x19
	mov	x1, x20
	bl	__Z6directPKhPh5Image
	subs	w22, w22, #1
	b.ne	LBB5_113
; %bb.114:                              ;   in Loop: Header=BB5_61 Depth=1
	mov	x27, #0                         ; =0x0
	mov	x9, #0                          ; =0x0
	mov	x22, #0                         ; =0x0
	stp	xzr, xzr, [sp, #80]             ; 16-byte Folded Spill
	b	LBB5_117
LBB5_115:                               ;   in Loop: Header=BB5_117 Depth=2
	str	d11, [x8], #8
	str	x8, [sp, #88]                   ; 8-byte Folded Spill
	ldr	x22, [sp, #96]                  ; 8-byte Folded Reload
LBB5_116:                               ;   in Loop: Header=BB5_117 Depth=2
	ldr	x9, [sp, #64]                   ; 8-byte Folded Reload
	add	x8, x27, #1
	cmp	x8, x24
	csinc	x27, xzr, x27, eq
	add	x9, x9, #1
	cmp	x9, #31
	b.eq	LBB5_126
LBB5_117:                               ;   Parent Loop BB5_61 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB5_118 Depth 3
	str	x9, [sp, #64]                   ; 8-byte Folded Spill
	str	x22, [sp, #96]                  ; 8-byte Folded Spill
	mov	w22, #16                        ; =0x10
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	str	x0, [sp, #72]                   ; 8-byte Folded Spill
LBB5_118:                               ;   Parent Loop BB5_61 Depth=1
                                        ;     Parent Loop BB5_117 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	stp	x25, x28, [sp, #104]
	str	x23, [sp, #120]
	add	x2, sp, #104
	mov	x0, x19
	mov	x1, x20
	bl	__Z6directPKhPh5Image
	ldrb	w8, [x20, x27]
	ldr	x9, [x26, _sink@PAGEOFF]
	add	x8, x9, x8
	str	x8, [x26, _sink@PAGEOFF]
	subs	w22, w22, #1
	b.ne	LBB5_118
; %bb.119:                              ;   in Loop: Header=BB5_117 Depth=2
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	ldp	x8, x9, [sp, #72]               ; 16-byte Folded Reload
	sub	x8, x0, x8
	scvtf	d0, x8
	mov	x8, #70368744177664             ; =0x400000000000
	movk	x8, #16527, lsl #48
	fmov	d1, x8
	fdiv	d0, d0, d1
	mov	x8, #4589168020290535424        ; =0x3fb0000000000000
	fmov	d1, x8
	fmul	d11, d0, d1
	ldr	x8, [sp, #88]                   ; 8-byte Folded Reload
	cmp	x8, x9
	b.lo	LBB5_115
; %bb.120:                              ;   in Loop: Header=BB5_117 Depth=2
	ldr	x10, [sp, #96]                  ; 8-byte Folded Reload
	sub	x11, x8, x10
	asr	x12, x11, #3
	add	x8, x12, #1
	lsr	x9, x8, #61
	cbnz	x9, LBB5_180
; %bb.121:                              ;   in Loop: Header=BB5_117 Depth=2
	str	x12, [sp, #88]                  ; 8-byte Folded Spill
	str	x11, [sp, #72]                  ; 8-byte Folded Spill
	ldr	x9, [sp, #80]                   ; 8-byte Folded Reload
	sub	x9, x9, x10
	asr	x10, x9, #2
	cmp	x10, x8
	csel	x8, x10, x8, hi
	mov	x10, #9223372036854775800       ; =0x7ffffffffffffff8
	cmp	x9, x10
	mov	x9, #2305843009213693951        ; =0x1fffffffffffffff
	csel	x22, x8, x9, lo
	lsr	x8, x22, #61
	cbnz	x8, LBB5_181
; %bb.122:                              ;   in Loop: Header=BB5_117 Depth=2
	lsl	x0, x22, #3
Ltmp93:
	bl	__Znwm
Ltmp94:
; %bb.123:                              ;   in Loop: Header=BB5_117 Depth=2
	ldr	x2, [sp, #72]                   ; 8-byte Folded Reload
	add	x8, x0, x2
	add	x10, x0, x22, lsl #3
	ldp	x9, x22, [sp, #88]              ; 16-byte Folded Reload
	sub	x0, x8, x9, lsl #3
	str	d11, [x8], #8
	stp	x10, x8, [sp, #80]              ; 16-byte Folded Spill
	str	x0, [sp, #56]                   ; 8-byte Folded Spill
	mov	x1, x22
	bl	_memcpy
	cbz	x22, LBB5_125
; %bb.124:                              ;   in Loop: Header=BB5_117 Depth=2
	mov	x0, x22
	bl	__ZdlPv
LBB5_125:                               ;   in Loop: Header=BB5_117 Depth=2
	ldr	x22, [sp, #56]                  ; 8-byte Folded Reload
	b	LBB5_116
LBB5_126:                               ;   in Loop: Header=BB5_61 Depth=1
Ltmp101:
	sub	x2, x29, #121
	mov	x0, x22
	ldr	x1, [sp, #88]                   ; 8-byte Folded Reload
	bl	__ZNSt3__16__sortIRNS_6__lessIddEEPdEEvT0_S5_T_
Ltmp102:
; %bb.127:                              ;   in Loop: Header=BB5_61 Depth=1
Ltmp103:
Lloh42:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh43:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh44:
	adrp	x1, l_.str.7@PAGE
Lloh45:
	add	x1, x1, l_.str.7@PAGEOFF
	mov	w2, #14                         ; =0xe
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp104:
; %bb.128:                              ;   in Loop: Header=BB5_61 Depth=1
Ltmp105:
Lloh46:
	adrp	x1, l_.str.13@PAGE
Lloh47:
	add	x1, x1, l_.str.13@PAGEOFF
	mov	w2, #23                         ; =0x17
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp106:
; %bb.129:                              ;   in Loop: Header=BB5_61 Depth=1
	ldr	d0, [x22, #120]
Ltmp107:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp108:
; %bb.130:                              ;   in Loop: Header=BB5_61 Depth=1
Ltmp109:
Lloh48:
	adrp	x1, l_.str.14@PAGE
Lloh49:
	add	x1, x1, l_.str.14@PAGEOFF
	mov	w2, #5                          ; =0x5
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp110:
; %bb.131:                              ;   in Loop: Header=BB5_61 Depth=1
	ldr	d0, [x22, #232]
Ltmp111:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp112:
; %bb.132:                              ;   in Loop: Header=BB5_61 Depth=1
	mov	w8, #10                         ; =0xa
	sturb	w8, [x29, #-121]
Ltmp113:
	sub	x1, x29, #121
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp114:
; %bb.133:                              ;   in Loop: Header=BB5_61 Depth=1
	mov	x0, x22
	bl	__ZdlPv
	mov	x0, x21
	mov	x1, x20
	mov	x2, x24
	bl	__Z3soaPKhPhm
	mov	x0, x21
	mov	x1, x20
	mov	x2, x24
	bl	__Z3soaPKhPhm
	mov	x0, x21
	mov	x1, x20
	mov	x2, x24
	bl	__Z3soaPKhPhm
	mov	x0, x21
	mov	x1, x20
	mov	x2, x24
	bl	__Z3soaPKhPhm
	mov	x0, x21
	mov	x1, x20
	mov	x2, x24
	bl	__Z3soaPKhPhm
	mov	x0, x21
	mov	x1, x20
	mov	x2, x24
	bl	__Z3soaPKhPhm
	mov	x0, x21
	mov	x1, x20
	mov	x2, x24
	bl	__Z3soaPKhPhm
	mov	x0, x21
	mov	x1, x20
	mov	x2, x24
	bl	__Z3soaPKhPhm
	mov	x0, x21
	mov	x1, x20
	mov	x2, x24
	bl	__Z3soaPKhPhm
	mov	x0, x21
	mov	x1, x20
	mov	x2, x24
	bl	__Z3soaPKhPhm
	mov	x0, x21
	mov	x1, x20
	mov	x2, x24
	bl	__Z3soaPKhPhm
	mov	x0, x21
	mov	x1, x20
	mov	x2, x24
	bl	__Z3soaPKhPhm
	mov	x0, x21
	mov	x1, x20
	mov	x2, x24
	bl	__Z3soaPKhPhm
	mov	x0, x21
	mov	x1, x20
	mov	x2, x24
	bl	__Z3soaPKhPhm
	mov	x0, x21
	mov	x1, x20
	mov	x2, x24
	bl	__Z3soaPKhPhm
	mov	x0, x21
	mov	x1, x20
	mov	x2, x24
	bl	__Z3soaPKhPhm
	mov	x0, x21
	mov	x1, x20
	mov	x2, x24
	bl	__Z3soaPKhPhm
	mov	x0, x21
	mov	x1, x20
	mov	x2, x24
	bl	__Z3soaPKhPhm
	mov	x0, x21
	mov	x1, x20
	mov	x2, x24
	bl	__Z3soaPKhPhm
	mov	x0, x21
	mov	x1, x20
	mov	x2, x24
	bl	__Z3soaPKhPhm
	mov	x27, #0                         ; =0x0
	mov	x9, #0                          ; =0x0
	mov	x22, #0                         ; =0x0
	stp	xzr, xzr, [sp, #80]             ; 16-byte Folded Spill
	b	LBB5_136
LBB5_134:                               ;   in Loop: Header=BB5_136 Depth=2
	str	d11, [x8], #8
	str	x8, [sp, #88]                   ; 8-byte Folded Spill
	ldr	x22, [sp, #96]                  ; 8-byte Folded Reload
LBB5_135:                               ;   in Loop: Header=BB5_136 Depth=2
	ldr	x9, [sp, #64]                   ; 8-byte Folded Reload
	add	x8, x27, #1
	cmp	x8, x24
	csinc	x27, xzr, x27, eq
	add	x9, x9, #1
	cmp	x9, #31
	b.eq	LBB5_145
LBB5_136:                               ;   Parent Loop BB5_61 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB5_137 Depth 3
	str	x9, [sp, #64]                   ; 8-byte Folded Spill
	str	x22, [sp, #96]                  ; 8-byte Folded Spill
	mov	w22, #16                        ; =0x10
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	str	x0, [sp, #72]                   ; 8-byte Folded Spill
LBB5_137:                               ;   Parent Loop BB5_61 Depth=1
                                        ;     Parent Loop BB5_136 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	mov	x0, x21
	mov	x1, x20
	mov	x2, x24
	bl	__Z3soaPKhPhm
	ldrb	w8, [x20, x27]
	ldr	x9, [x26, _sink@PAGEOFF]
	add	x8, x9, x8
	str	x8, [x26, _sink@PAGEOFF]
	subs	w22, w22, #1
	b.ne	LBB5_137
; %bb.138:                              ;   in Loop: Header=BB5_136 Depth=2
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	ldp	x8, x9, [sp, #72]               ; 16-byte Folded Reload
	sub	x8, x0, x8
	scvtf	d0, x8
	mov	x8, #70368744177664             ; =0x400000000000
	movk	x8, #16527, lsl #48
	fmov	d1, x8
	fdiv	d0, d0, d1
	mov	x8, #4589168020290535424        ; =0x3fb0000000000000
	fmov	d1, x8
	fmul	d11, d0, d1
	ldr	x8, [sp, #88]                   ; 8-byte Folded Reload
	cmp	x8, x9
	b.lo	LBB5_134
; %bb.139:                              ;   in Loop: Header=BB5_136 Depth=2
	ldr	x10, [sp, #96]                  ; 8-byte Folded Reload
	sub	x11, x8, x10
	asr	x12, x11, #3
	add	x8, x12, #1
	lsr	x9, x8, #61
	cbnz	x9, LBB5_182
; %bb.140:                              ;   in Loop: Header=BB5_136 Depth=2
	str	x12, [sp, #88]                  ; 8-byte Folded Spill
	str	x11, [sp, #72]                  ; 8-byte Folded Spill
	ldr	x9, [sp, #80]                   ; 8-byte Folded Reload
	sub	x9, x9, x10
	asr	x10, x9, #2
	cmp	x10, x8
	csel	x8, x10, x8, hi
	mov	x10, #9223372036854775800       ; =0x7ffffffffffffff8
	cmp	x9, x10
	mov	x9, #2305843009213693951        ; =0x1fffffffffffffff
	csel	x22, x8, x9, lo
	lsr	x8, x22, #61
	cbnz	x8, LBB5_183
; %bb.141:                              ;   in Loop: Header=BB5_136 Depth=2
	lsl	x0, x22, #3
Ltmp116:
	bl	__Znwm
Ltmp117:
; %bb.142:                              ;   in Loop: Header=BB5_136 Depth=2
	ldr	x2, [sp, #72]                   ; 8-byte Folded Reload
	add	x8, x0, x2
	add	x10, x0, x22, lsl #3
	ldp	x9, x22, [sp, #88]              ; 16-byte Folded Reload
	sub	x0, x8, x9, lsl #3
	str	d11, [x8], #8
	stp	x10, x8, [sp, #80]              ; 16-byte Folded Spill
	str	x0, [sp, #56]                   ; 8-byte Folded Spill
	mov	x1, x22
	bl	_memcpy
	cbz	x22, LBB5_144
; %bb.143:                              ;   in Loop: Header=BB5_136 Depth=2
	mov	x0, x22
	bl	__ZdlPv
LBB5_144:                               ;   in Loop: Header=BB5_136 Depth=2
	ldr	x22, [sp, #56]                  ; 8-byte Folded Reload
	b	LBB5_135
LBB5_145:                               ;   in Loop: Header=BB5_61 Depth=1
Ltmp124:
	sub	x2, x29, #121
	mov	x0, x22
	ldr	x1, [sp, #88]                   ; 8-byte Folded Reload
	bl	__ZNSt3__16__sortIRNS_6__lessIddEEPdEEvT0_S5_T_
Ltmp125:
; %bb.146:                              ;   in Loop: Header=BB5_61 Depth=1
Ltmp126:
Lloh50:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh51:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh52:
	adrp	x1, l_.str.8@PAGE
Lloh53:
	add	x1, x1, l_.str.8@PAGEOFF
	mov	w2, #10                         ; =0xa
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp127:
; %bb.147:                              ;   in Loop: Header=BB5_61 Depth=1
Ltmp128:
Lloh54:
	adrp	x1, l_.str.13@PAGE
Lloh55:
	add	x1, x1, l_.str.13@PAGEOFF
	mov	w2, #23                         ; =0x17
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp129:
; %bb.148:                              ;   in Loop: Header=BB5_61 Depth=1
	ldr	d0, [x22, #120]
Ltmp130:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp131:
; %bb.149:                              ;   in Loop: Header=BB5_61 Depth=1
Ltmp132:
Lloh56:
	adrp	x1, l_.str.14@PAGE
Lloh57:
	add	x1, x1, l_.str.14@PAGEOFF
	mov	w2, #5                          ; =0x5
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp133:
; %bb.150:                              ;   in Loop: Header=BB5_61 Depth=1
	ldr	d0, [x22, #232]
Ltmp134:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp135:
; %bb.151:                              ;   in Loop: Header=BB5_61 Depth=1
	mov	w8, #10                         ; =0xa
	sturb	w8, [x29, #-121]
Ltmp136:
	sub	x1, x29, #121
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp137:
; %bb.152:                              ;   in Loop: Header=BB5_61 Depth=1
	mov	x0, x22
	bl	__ZdlPv
	mov	w22, #20                        ; =0x14
LBB5_153:                               ;   Parent Loop BB5_61 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	stp	x25, x28, [sp, #104]
	str	x23, [sp, #120]
	add	x2, sp, #104
	mov	x0, x19
	mov	x1, x21
	bl	__Z4packPKhPh5Image
	mov	x0, x21
	mov	x1, x20
	mov	x2, x24
	bl	__Z3soaPKhPhm
	subs	w22, w22, #1
	b.ne	LBB5_153
; %bb.154:                              ;   in Loop: Header=BB5_61 Depth=1
	mov	x27, #0                         ; =0x0
	mov	x9, #0                          ; =0x0
	mov	x22, #0                         ; =0x0
	stp	xzr, xzr, [sp, #80]             ; 16-byte Folded Spill
	b	LBB5_157
LBB5_155:                               ;   in Loop: Header=BB5_157 Depth=2
	str	d11, [x8], #8
	str	x8, [sp, #88]                   ; 8-byte Folded Spill
	ldr	x22, [sp, #96]                  ; 8-byte Folded Reload
LBB5_156:                               ;   in Loop: Header=BB5_157 Depth=2
	ldr	x9, [sp, #64]                   ; 8-byte Folded Reload
	add	x8, x27, #1
	cmp	x8, x24
	csinc	x27, xzr, x27, eq
	add	x9, x9, #1
	cmp	x9, #31
	b.eq	LBB5_166
LBB5_157:                               ;   Parent Loop BB5_61 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB5_158 Depth 3
	str	x9, [sp, #64]                   ; 8-byte Folded Spill
	str	x22, [sp, #96]                  ; 8-byte Folded Spill
	mov	w22, #16                        ; =0x10
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	str	x0, [sp, #72]                   ; 8-byte Folded Spill
LBB5_158:                               ;   Parent Loop BB5_61 Depth=1
                                        ;     Parent Loop BB5_157 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	stp	x25, x28, [sp, #104]
	str	x23, [sp, #120]
	add	x2, sp, #104
	mov	x0, x19
	mov	x1, x21
	bl	__Z4packPKhPh5Image
	mov	x0, x21
	mov	x1, x20
	mov	x2, x24
	bl	__Z3soaPKhPhm
	ldrb	w8, [x20, x27]
	ldr	x9, [x26, _sink@PAGEOFF]
	add	x8, x9, x8
	str	x8, [x26, _sink@PAGEOFF]
	subs	w22, w22, #1
	b.ne	LBB5_158
; %bb.159:                              ;   in Loop: Header=BB5_157 Depth=2
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	ldp	x8, x9, [sp, #72]               ; 16-byte Folded Reload
	sub	x8, x0, x8
	scvtf	d0, x8
	mov	x8, #70368744177664             ; =0x400000000000
	movk	x8, #16527, lsl #48
	fmov	d1, x8
	fdiv	d0, d0, d1
	mov	x8, #4589168020290535424        ; =0x3fb0000000000000
	fmov	d1, x8
	fmul	d11, d0, d1
	ldr	x8, [sp, #88]                   ; 8-byte Folded Reload
	cmp	x8, x9
	b.lo	LBB5_155
; %bb.160:                              ;   in Loop: Header=BB5_157 Depth=2
	ldr	x10, [sp, #96]                  ; 8-byte Folded Reload
	sub	x11, x8, x10
	asr	x12, x11, #3
	add	x8, x12, #1
	lsr	x9, x8, #61
	cbnz	x9, LBB5_184
; %bb.161:                              ;   in Loop: Header=BB5_157 Depth=2
	str	x12, [sp, #88]                  ; 8-byte Folded Spill
	str	x11, [sp, #72]                  ; 8-byte Folded Spill
	ldr	x9, [sp, #80]                   ; 8-byte Folded Reload
	sub	x9, x9, x10
	asr	x10, x9, #2
	cmp	x10, x8
	csel	x8, x10, x8, hi
	mov	x10, #9223372036854775800       ; =0x7ffffffffffffff8
	cmp	x9, x10
	mov	x9, #2305843009213693951        ; =0x1fffffffffffffff
	csel	x22, x8, x9, lo
	lsr	x8, x22, #61
	cbnz	x8, LBB5_185
; %bb.162:                              ;   in Loop: Header=BB5_157 Depth=2
	lsl	x0, x22, #3
Ltmp139:
	bl	__Znwm
Ltmp140:
; %bb.163:                              ;   in Loop: Header=BB5_157 Depth=2
	ldr	x2, [sp, #72]                   ; 8-byte Folded Reload
	add	x8, x0, x2
	add	x10, x0, x22, lsl #3
	ldp	x9, x22, [sp, #88]              ; 16-byte Folded Reload
	sub	x0, x8, x9, lsl #3
	str	d11, [x8], #8
	stp	x10, x8, [sp, #80]              ; 16-byte Folded Spill
	str	x0, [sp, #56]                   ; 8-byte Folded Spill
	mov	x1, x22
	bl	_memcpy
	cbz	x22, LBB5_165
; %bb.164:                              ;   in Loop: Header=BB5_157 Depth=2
	mov	x0, x22
	bl	__ZdlPv
LBB5_165:                               ;   in Loop: Header=BB5_157 Depth=2
	ldr	x22, [sp, #56]                  ; 8-byte Folded Reload
	b	LBB5_156
LBB5_166:                               ;   in Loop: Header=BB5_61 Depth=1
Ltmp147:
	sub	x2, x29, #121
	mov	x0, x22
	ldr	x1, [sp, #88]                   ; 8-byte Folded Reload
	bl	__ZNSt3__16__sortIRNS_6__lessIddEEPdEEvT0_S5_T_
Ltmp148:
; %bb.167:                              ;   in Loop: Header=BB5_61 Depth=1
Ltmp149:
Lloh58:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh59:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh60:
	adrp	x1, l_.str.9@PAGE
Lloh61:
	add	x1, x1, l_.str.9@PAGEOFF
	mov	w2, #8                          ; =0x8
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp150:
; %bb.168:                              ;   in Loop: Header=BB5_61 Depth=1
Ltmp151:
Lloh62:
	adrp	x1, l_.str.13@PAGE
Lloh63:
	add	x1, x1, l_.str.13@PAGEOFF
	mov	w2, #23                         ; =0x17
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp152:
; %bb.169:                              ;   in Loop: Header=BB5_61 Depth=1
	ldr	d0, [x22, #120]
Ltmp153:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp154:
; %bb.170:                              ;   in Loop: Header=BB5_61 Depth=1
Ltmp155:
Lloh64:
	adrp	x1, l_.str.14@PAGE
Lloh65:
	add	x1, x1, l_.str.14@PAGEOFF
	mov	w2, #5                          ; =0x5
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp156:
; %bb.171:                              ;   in Loop: Header=BB5_61 Depth=1
	ldr	d0, [x22, #232]
Ltmp157:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp158:
; %bb.172:                              ;   in Loop: Header=BB5_61 Depth=1
	mov	w8, #10                         ; =0xa
	sturb	w8, [x29, #-121]
Ltmp159:
	sub	x1, x29, #121
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp160:
; %bb.173:                              ;   in Loop: Header=BB5_61 Depth=1
	mov	x0, x22
	bl	__ZdlPv
	ldr	x22, [sp, #48]                  ; 8-byte Folded Reload
	cbz	x21, LBB5_175
; %bb.174:                              ;   in Loop: Header=BB5_61 Depth=1
	mov	x0, x21
	bl	__ZdlPv
LBB5_175:                               ;   in Loop: Header=BB5_61 Depth=1
	mov	x0, x20
	bl	__ZdlPv
	cbz	x19, LBB5_60
; %bb.176:                              ;   in Loop: Header=BB5_61 Depth=1
	mov	x0, x19
	bl	__ZdlPv
	b	LBB5_60
LBB5_177:
	mov	w0, #0                          ; =0x0
	b	LBB5_240
LBB5_178:
Ltmp75:
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_length_errorB9nqe210106Ev
Ltmp76:
	b	LBB5_189
LBB5_179:
Ltmp73:
	bl	__ZSt28__throw_bad_array_new_lengthB9nqe210106v
Ltmp74:
	b	LBB5_189
LBB5_180:
Ltmp98:
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_length_errorB9nqe210106Ev
Ltmp99:
	b	LBB5_189
LBB5_181:
Ltmp96:
	bl	__ZSt28__throw_bad_array_new_lengthB9nqe210106v
Ltmp97:
	b	LBB5_189
LBB5_182:
Ltmp121:
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_length_errorB9nqe210106Ev
Ltmp122:
	b	LBB5_189
LBB5_183:
Ltmp119:
	bl	__ZSt28__throw_bad_array_new_lengthB9nqe210106v
Ltmp120:
	b	LBB5_189
LBB5_184:
Ltmp144:
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_length_errorB9nqe210106Ev
Ltmp145:
	b	LBB5_189
LBB5_185:
Ltmp142:
	bl	__ZSt28__throw_bad_array_new_lengthB9nqe210106v
Ltmp143:
	b	LBB5_189
LBB5_186:
Ltmp40:
	bl	__ZNSt3__16vectorIhNS_9allocatorIhEEE20__throw_length_errorB9nqe210106Ev
Ltmp41:
	b	LBB5_189
LBB5_187:
Ltmp52:
	bl	__ZNSt3__16vectorIhNS_9allocatorIhEEE20__throw_length_errorB9nqe210106Ev
Ltmp53:
	b	LBB5_189
LBB5_188:
Ltmp49:
	bl	__ZNSt3__16vectorIhNS_9allocatorIhEEE20__throw_length_errorB9nqe210106Ev
Ltmp50:
LBB5_189:
	brk	#0x1
LBB5_190:
Ltmp29:
	b	LBB5_227
LBB5_191:
Ltmp36:
	b	LBB5_227
LBB5_192:
Ltmp51:
	b	LBB5_196
LBB5_193:
Ltmp54:
	b	LBB5_198
LBB5_194:
Ltmp42:
	b	LBB5_227
LBB5_195:
Ltmp48:
LBB5_196:
	mov	x23, x1
	mov	x25, x0
	b	LBB5_217
LBB5_197:
Ltmp45:
LBB5_198:
	mov	x23, x1
	mov	x25, x0
	b	LBB5_218
LBB5_199:
Ltmp39:
	b	LBB5_227
LBB5_200:
Ltmp161:
	str	x22, [sp, #96]                  ; 8-byte Folded Spill
	b	LBB5_212
LBB5_201:
Ltmp138:
	str	x22, [sp, #96]                  ; 8-byte Folded Spill
	b	LBB5_212
LBB5_202:
Ltmp115:
	str	x22, [sp, #96]                  ; 8-byte Folded Spill
	b	LBB5_212
LBB5_203:
Ltmp92:
	b	LBB5_221
LBB5_204:
Ltmp69:
	mov	x23, x1
	mov	x25, x0
	b	LBB5_214
LBB5_205:
Ltmp141:
	b	LBB5_212
LBB5_206:
Ltmp118:
	b	LBB5_212
LBB5_207:
Ltmp95:
	b	LBB5_212
LBB5_208:
Ltmp72:
	b	LBB5_221
LBB5_209:
Ltmp146:
	b	LBB5_212
LBB5_210:
Ltmp123:
	b	LBB5_212
LBB5_211:
Ltmp100:
LBB5_212:
	mov	x23, x1
	mov	x25, x0
	ldr	x0, [sp, #96]                   ; 8-byte Folded Reload
	cbz	x0, LBB5_214
LBB5_213:
	bl	__ZdlPv
LBB5_214:
	cbz	x21, LBB5_216
; %bb.215:
	mov	x0, x21
	bl	__ZdlPv
LBB5_216:
	cbz	x20, LBB5_218
LBB5_217:
	mov	x0, x20
	bl	__ZdlPv
LBB5_218:
	cbz	x19, LBB5_236
; %bb.219:
	mov	x0, x19
	b	LBB5_235
LBB5_220:
Ltmp77:
LBB5_221:
	mov	x23, x1
	mov	x25, x0
	ldr	x0, [sp, #64]                   ; 8-byte Folded Reload
	cbnz	x0, LBB5_213
	b	LBB5_214
LBB5_222:
Ltmp14:
	mov	x23, x1
	mov	x25, x0
	b	LBB5_231
LBB5_223:
Ltmp11:
	mov	x23, x1
	mov	x25, x0
	b	LBB5_232
LBB5_224:
Ltmp8:
	mov	x23, x1
	mov	x25, x0
	b	LBB5_233
LBB5_225:
Ltmp5:
	mov	x23, x1
	mov	x25, x0
	b	LBB5_234
LBB5_226:
Ltmp2:
LBB5_227:
	mov	x23, x1
	mov	x25, x0
	b	LBB5_236
LBB5_228:
Ltmp20:
	mov	x23, x1
	mov	x25, x0
	b	LBB5_230
LBB5_229:
Ltmp17:
	mov	x23, x1
	mov	x25, x0
	mov	x0, x26
	bl	___cxa_free_exception
LBB5_230:
	mov	x0, x28
	bl	__ZdlPv
LBB5_231:
	mov	x0, x22
	bl	__ZdlPv
LBB5_232:
	ldr	x0, [sp, #88]                   ; 8-byte Folded Reload
	bl	__ZdlPv
LBB5_233:
	mov	x0, x20
	bl	__ZdlPv
LBB5_234:
	ldr	x0, [sp, #96]                   ; 8-byte Folded Reload
LBB5_235:
	bl	__ZdlPv
LBB5_236:
	cmp	w23, #1
	b.ne	LBB5_242
; %bb.237:
	mov	x0, x25
	bl	___cxa_begin_catch
	ldr	x8, [x0]
	ldr	x8, [x8, #16]
	blr	x8
	mov	x19, x0
	bl	_strlen
	mov	x2, x0
Ltmp162:
Lloh66:
	adrp	x0, __ZNSt3__14cerrE@GOTPAGE
Lloh67:
	ldr	x0, [x0, __ZNSt3__14cerrE@GOTPAGEOFF]
	mov	x1, x19
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp163:
; %bb.238:
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #104]
Ltmp164:
	add	x1, sp, #104
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp165:
; %bb.239:
	bl	___cxa_end_catch
	mov	w0, #1                          ; =0x1
LBB5_240:
	ldp	x29, x30, [sp, #256]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #240]            ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #224]            ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #208]            ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #192]            ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #176]            ; 16-byte Folded Reload
	ldp	d9, d8, [sp, #160]              ; 16-byte Folded Reload
	ldp	d11, d10, [sp, #144]            ; 16-byte Folded Reload
	add	sp, sp, #272
	ret
LBB5_241:
Ltmp166:
	mov	x25, x0
Ltmp167:
	bl	___cxa_end_catch
Ltmp168:
LBB5_242:
	mov	x0, x25
	bl	__Unwind_Resume
LBB5_243:
Ltmp169:
	bl	___clang_call_terminate
	.loh AdrpLdr	Lloh2, Lloh3
	.loh AdrpAdrp	Lloh0, Lloh2
	.loh AdrpLdr	Lloh0, Lloh1
	.loh AdrpAdd	Lloh4, Lloh5
	.loh AdrpLdrGot	Lloh10, Lloh11
	.loh AdrpLdrGot	Lloh8, Lloh9
	.loh AdrpLdrGot	Lloh6, Lloh7
	.loh AdrpAdd	Lloh12, Lloh13
	.loh AdrpLdrGot	Lloh16, Lloh17
	.loh AdrpLdrGot	Lloh14, Lloh15
	.loh AdrpAdd	Lloh20, Lloh21
	.loh AdrpLdrGot	Lloh18, Lloh19
	.loh AdrpAdd	Lloh22, Lloh23
	.loh AdrpLdr	Lloh24, Lloh25
	.loh AdrpAdd	Lloh26, Lloh27
	.loh AdrpAdd	Lloh30, Lloh31
	.loh AdrpLdrGot	Lloh28, Lloh29
	.loh AdrpAdd	Lloh32, Lloh33
	.loh AdrpAdd	Lloh36, Lloh37
	.loh AdrpLdrGot	Lloh34, Lloh35
	.loh AdrpAdd	Lloh38, Lloh39
	.loh AdrpAdd	Lloh40, Lloh41
	.loh AdrpAdd	Lloh44, Lloh45
	.loh AdrpLdrGot	Lloh42, Lloh43
	.loh AdrpAdd	Lloh46, Lloh47
	.loh AdrpAdd	Lloh48, Lloh49
	.loh AdrpAdd	Lloh52, Lloh53
	.loh AdrpLdrGot	Lloh50, Lloh51
	.loh AdrpAdd	Lloh54, Lloh55
	.loh AdrpAdd	Lloh56, Lloh57
	.loh AdrpAdd	Lloh60, Lloh61
	.loh AdrpLdrGot	Lloh58, Lloh59
	.loh AdrpAdd	Lloh62, Lloh63
	.loh AdrpAdd	Lloh64, Lloh65
	.loh AdrpLdrGot	Lloh66, Lloh67
Lfunc_end0:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table5:
Lexception0:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase0-Lttbaseref0
Lttbaseref0:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end0-Lcst_begin0
Lcst_begin0:
	.uleb128 Ltmp0-Lfunc_begin0             ; >> Call Site 1 <<
	.uleb128 Ltmp1-Ltmp0                    ;   Call between Ltmp0 and Ltmp1
	.uleb128 Ltmp2-Lfunc_begin0             ;     jumps to Ltmp2
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp1-Lfunc_begin0             ; >> Call Site 2 <<
	.uleb128 Ltmp3-Ltmp1                    ;   Call between Ltmp1 and Ltmp3
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp3-Lfunc_begin0             ; >> Call Site 3 <<
	.uleb128 Ltmp4-Ltmp3                    ;   Call between Ltmp3 and Ltmp4
	.uleb128 Ltmp5-Lfunc_begin0             ;     jumps to Ltmp5
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp4-Lfunc_begin0             ; >> Call Site 4 <<
	.uleb128 Ltmp6-Ltmp4                    ;   Call between Ltmp4 and Ltmp6
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp6-Lfunc_begin0             ; >> Call Site 5 <<
	.uleb128 Ltmp7-Ltmp6                    ;   Call between Ltmp6 and Ltmp7
	.uleb128 Ltmp8-Lfunc_begin0             ;     jumps to Ltmp8
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp7-Lfunc_begin0             ; >> Call Site 6 <<
	.uleb128 Ltmp9-Ltmp7                    ;   Call between Ltmp7 and Ltmp9
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp9-Lfunc_begin0             ; >> Call Site 7 <<
	.uleb128 Ltmp10-Ltmp9                   ;   Call between Ltmp9 and Ltmp10
	.uleb128 Ltmp11-Lfunc_begin0            ;     jumps to Ltmp11
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp10-Lfunc_begin0            ; >> Call Site 8 <<
	.uleb128 Ltmp12-Ltmp10                  ;   Call between Ltmp10 and Ltmp12
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp12-Lfunc_begin0            ; >> Call Site 9 <<
	.uleb128 Ltmp13-Ltmp12                  ;   Call between Ltmp12 and Ltmp13
	.uleb128 Ltmp14-Lfunc_begin0            ;     jumps to Ltmp14
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp13-Lfunc_begin0            ; >> Call Site 10 <<
	.uleb128 Ltmp21-Ltmp13                  ;   Call between Ltmp13 and Ltmp21
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp21-Lfunc_begin0            ; >> Call Site 11 <<
	.uleb128 Ltmp22-Ltmp21                  ;   Call between Ltmp21 and Ltmp22
	.uleb128 Ltmp23-Lfunc_begin0            ;     jumps to Ltmp23
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp24-Lfunc_begin0            ; >> Call Site 12 <<
	.uleb128 Ltmp25-Ltmp24                  ;   Call between Ltmp24 and Ltmp25
	.uleb128 Ltmp26-Lfunc_begin0            ;     jumps to Ltmp26
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp25-Lfunc_begin0            ; >> Call Site 13 <<
	.uleb128 Ltmp15-Ltmp25                  ;   Call between Ltmp25 and Ltmp15
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp15-Lfunc_begin0            ; >> Call Site 14 <<
	.uleb128 Ltmp16-Ltmp15                  ;   Call between Ltmp15 and Ltmp16
	.uleb128 Ltmp17-Lfunc_begin0            ;     jumps to Ltmp17
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp18-Lfunc_begin0            ; >> Call Site 15 <<
	.uleb128 Ltmp19-Ltmp18                  ;   Call between Ltmp18 and Ltmp19
	.uleb128 Ltmp20-Lfunc_begin0            ;     jumps to Ltmp20
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp19-Lfunc_begin0            ; >> Call Site 16 <<
	.uleb128 Ltmp27-Ltmp19                  ;   Call between Ltmp19 and Ltmp27
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp27-Lfunc_begin0            ; >> Call Site 17 <<
	.uleb128 Ltmp28-Ltmp27                  ;   Call between Ltmp27 and Ltmp28
	.uleb128 Ltmp29-Lfunc_begin0            ;     jumps to Ltmp29
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp30-Lfunc_begin0            ; >> Call Site 18 <<
	.uleb128 Ltmp35-Ltmp30                  ;   Call between Ltmp30 and Ltmp35
	.uleb128 Ltmp36-Lfunc_begin0            ;     jumps to Ltmp36
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp37-Lfunc_begin0            ; >> Call Site 19 <<
	.uleb128 Ltmp38-Ltmp37                  ;   Call between Ltmp37 and Ltmp38
	.uleb128 Ltmp39-Lfunc_begin0            ;     jumps to Ltmp39
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp38-Lfunc_begin0            ; >> Call Site 20 <<
	.uleb128 Ltmp43-Ltmp38                  ;   Call between Ltmp38 and Ltmp43
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp43-Lfunc_begin0            ; >> Call Site 21 <<
	.uleb128 Ltmp44-Ltmp43                  ;   Call between Ltmp43 and Ltmp44
	.uleb128 Ltmp45-Lfunc_begin0            ;     jumps to Ltmp45
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp44-Lfunc_begin0            ; >> Call Site 22 <<
	.uleb128 Ltmp46-Ltmp44                  ;   Call between Ltmp44 and Ltmp46
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp46-Lfunc_begin0            ; >> Call Site 23 <<
	.uleb128 Ltmp47-Ltmp46                  ;   Call between Ltmp46 and Ltmp47
	.uleb128 Ltmp48-Lfunc_begin0            ;     jumps to Ltmp48
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp47-Lfunc_begin0            ; >> Call Site 24 <<
	.uleb128 Ltmp55-Ltmp47                  ;   Call between Ltmp47 and Ltmp55
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp55-Lfunc_begin0            ; >> Call Site 25 <<
	.uleb128 Ltmp68-Ltmp55                  ;   Call between Ltmp55 and Ltmp68
	.uleb128 Ltmp69-Lfunc_begin0            ;     jumps to Ltmp69
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp70-Lfunc_begin0            ; >> Call Site 26 <<
	.uleb128 Ltmp71-Ltmp70                  ;   Call between Ltmp70 and Ltmp71
	.uleb128 Ltmp72-Lfunc_begin0            ;     jumps to Ltmp72
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp71-Lfunc_begin0            ; >> Call Site 27 <<
	.uleb128 Ltmp78-Ltmp71                  ;   Call between Ltmp71 and Ltmp78
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp78-Lfunc_begin0            ; >> Call Site 28 <<
	.uleb128 Ltmp91-Ltmp78                  ;   Call between Ltmp78 and Ltmp91
	.uleb128 Ltmp92-Lfunc_begin0            ;     jumps to Ltmp92
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp93-Lfunc_begin0            ; >> Call Site 29 <<
	.uleb128 Ltmp94-Ltmp93                  ;   Call between Ltmp93 and Ltmp94
	.uleb128 Ltmp95-Lfunc_begin0            ;     jumps to Ltmp95
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp94-Lfunc_begin0            ; >> Call Site 30 <<
	.uleb128 Ltmp101-Ltmp94                 ;   Call between Ltmp94 and Ltmp101
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp101-Lfunc_begin0           ; >> Call Site 31 <<
	.uleb128 Ltmp114-Ltmp101                ;   Call between Ltmp101 and Ltmp114
	.uleb128 Ltmp115-Lfunc_begin0           ;     jumps to Ltmp115
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp116-Lfunc_begin0           ; >> Call Site 32 <<
	.uleb128 Ltmp117-Ltmp116                ;   Call between Ltmp116 and Ltmp117
	.uleb128 Ltmp118-Lfunc_begin0           ;     jumps to Ltmp118
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp117-Lfunc_begin0           ; >> Call Site 33 <<
	.uleb128 Ltmp124-Ltmp117                ;   Call between Ltmp117 and Ltmp124
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp124-Lfunc_begin0           ; >> Call Site 34 <<
	.uleb128 Ltmp137-Ltmp124                ;   Call between Ltmp124 and Ltmp137
	.uleb128 Ltmp138-Lfunc_begin0           ;     jumps to Ltmp138
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp139-Lfunc_begin0           ; >> Call Site 35 <<
	.uleb128 Ltmp140-Ltmp139                ;   Call between Ltmp139 and Ltmp140
	.uleb128 Ltmp141-Lfunc_begin0           ;     jumps to Ltmp141
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp140-Lfunc_begin0           ; >> Call Site 36 <<
	.uleb128 Ltmp147-Ltmp140                ;   Call between Ltmp140 and Ltmp147
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp147-Lfunc_begin0           ; >> Call Site 37 <<
	.uleb128 Ltmp160-Ltmp147                ;   Call between Ltmp147 and Ltmp160
	.uleb128 Ltmp161-Lfunc_begin0           ;     jumps to Ltmp161
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp75-Lfunc_begin0            ; >> Call Site 38 <<
	.uleb128 Ltmp74-Ltmp75                  ;   Call between Ltmp75 and Ltmp74
	.uleb128 Ltmp77-Lfunc_begin0            ;     jumps to Ltmp77
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp98-Lfunc_begin0            ; >> Call Site 39 <<
	.uleb128 Ltmp97-Ltmp98                  ;   Call between Ltmp98 and Ltmp97
	.uleb128 Ltmp100-Lfunc_begin0           ;     jumps to Ltmp100
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp121-Lfunc_begin0           ; >> Call Site 40 <<
	.uleb128 Ltmp120-Ltmp121                ;   Call between Ltmp121 and Ltmp120
	.uleb128 Ltmp123-Lfunc_begin0           ;     jumps to Ltmp123
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp144-Lfunc_begin0           ; >> Call Site 41 <<
	.uleb128 Ltmp143-Ltmp144                ;   Call between Ltmp144 and Ltmp143
	.uleb128 Ltmp146-Lfunc_begin0           ;     jumps to Ltmp146
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp40-Lfunc_begin0            ; >> Call Site 42 <<
	.uleb128 Ltmp41-Ltmp40                  ;   Call between Ltmp40 and Ltmp41
	.uleb128 Ltmp42-Lfunc_begin0            ;     jumps to Ltmp42
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp52-Lfunc_begin0            ; >> Call Site 43 <<
	.uleb128 Ltmp53-Ltmp52                  ;   Call between Ltmp52 and Ltmp53
	.uleb128 Ltmp54-Lfunc_begin0            ;     jumps to Ltmp54
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp49-Lfunc_begin0            ; >> Call Site 44 <<
	.uleb128 Ltmp50-Ltmp49                  ;   Call between Ltmp49 and Ltmp50
	.uleb128 Ltmp51-Lfunc_begin0            ;     jumps to Ltmp51
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp50-Lfunc_begin0            ; >> Call Site 45 <<
	.uleb128 Ltmp162-Ltmp50                 ;   Call between Ltmp50 and Ltmp162
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp162-Lfunc_begin0           ; >> Call Site 46 <<
	.uleb128 Ltmp165-Ltmp162                ;   Call between Ltmp162 and Ltmp165
	.uleb128 Ltmp166-Lfunc_begin0           ;     jumps to Ltmp166
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp165-Lfunc_begin0           ; >> Call Site 47 <<
	.uleb128 Ltmp167-Ltmp165                ;   Call between Ltmp165 and Ltmp167
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp167-Lfunc_begin0           ; >> Call Site 48 <<
	.uleb128 Ltmp168-Ltmp167                ;   Call between Ltmp167 and Ltmp168
	.uleb128 Ltmp169-Lfunc_begin0           ;     jumps to Ltmp169
	.byte	9                               ;   On action: 5
	.uleb128 Ltmp168-Lfunc_begin0           ; >> Call Site 49 <<
	.uleb128 Lfunc_end0-Ltmp168             ;   Call between Ltmp168 and Lfunc_end0
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end0:
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
Ltmp198:                                ; TypeInfo 2
	.long	__ZTISt16invalid_argument@GOT-Ltmp198
Ltmp199:                                ; TypeInfo 1
	.long	__ZTISt9exception@GOT-Ltmp199
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
Lloh68:
	adrp	x0, l_.str.11@PAGE
Lloh69:
	add	x0, x0, l_.str.11@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh68, Lloh69
	.cfi_endproc
                                        ; -- End function
	.private_extern	__ZNSt3__120__throw_length_errorB9nqe210106EPKc ; -- Begin function _ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.globl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.weak_def_can_be_hidden	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.p2align	2
__ZNSt3__120__throw_length_errorB9nqe210106EPKc: ; @_ZNSt3__120__throw_length_errorB9nqe210106EPKc
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
	mov	x20, x0
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp170:
	mov	x1, x20
	bl	__ZNSt12length_errorC1B9nqe210106EPKc
Ltmp171:
; %bb.1:
Lloh70:
	adrp	x1, __ZTISt12length_error@GOTPAGE
Lloh71:
	ldr	x1, [x1, __ZTISt12length_error@GOTPAGEOFF]
Lloh72:
	adrp	x2, __ZNSt12length_errorD1Ev@GOTPAGE
Lloh73:
	ldr	x2, [x2, __ZNSt12length_errorD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
LBB8_2:
Ltmp172:
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x0, x20
	bl	__Unwind_Resume
	.loh AdrpLdrGot	Lloh72, Lloh73
	.loh AdrpLdrGot	Lloh70, Lloh71
Lfunc_end1:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table8:
Lexception1:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end1-Lcst_begin1
Lcst_begin1:
	.uleb128 Lfunc_begin1-Lfunc_begin1      ; >> Call Site 1 <<
	.uleb128 Ltmp170-Lfunc_begin1           ;   Call between Lfunc_begin1 and Ltmp170
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp170-Lfunc_begin1           ; >> Call Site 2 <<
	.uleb128 Ltmp171-Ltmp170                ;   Call between Ltmp170 and Ltmp171
	.uleb128 Ltmp172-Lfunc_begin1           ;     jumps to Ltmp172
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp171-Lfunc_begin1           ; >> Call Site 3 <<
	.uleb128 Lfunc_end1-Ltmp171             ;   Call between Ltmp171 and Lfunc_end1
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end1:
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
Lloh74:
	adrp	x8, __ZTVSt12length_error@GOTPAGE
Lloh75:
	ldr	x8, [x8, __ZTVSt12length_error@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x0]
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
	.loh AdrpLdrGot	Lloh74, Lloh75
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
Lloh76:
	adrp	x1, __ZTISt20bad_array_new_length@GOTPAGE
Lloh77:
	ldr	x1, [x1, __ZTISt20bad_array_new_length@GOTPAGEOFF]
Lloh78:
	adrp	x2, __ZNSt20bad_array_new_lengthD1Ev@GOTPAGE
Lloh79:
	ldr	x2, [x2, __ZNSt20bad_array_new_lengthD1Ev@GOTPAGEOFF]
	bl	___cxa_throw
	.loh AdrpLdrGot	Lloh78, Lloh79
	.loh AdrpLdrGot	Lloh76, Lloh77
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
Ltmp173:
	add	x0, sp, #8
	mov	x1, x19
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryC1ERS3_
Ltmp174:
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
Ltmp176:
	add	x8, sp, #24
	mov	x25, x4
	mov	x0, x4
	bl	__ZNKSt3__18ios_base6getlocEv
Ltmp177:
; %bb.4:
Ltmp178:
Lloh80:
	adrp	x1, __ZNSt3__15ctypeIcE2idE@GOTPAGE
Lloh81:
	ldr	x1, [x1, __ZNSt3__15ctypeIcE2idE@GOTPAGEOFF]
	add	x0, sp, #24
	bl	__ZNKSt3__16locale9use_facetERNS0_2idE
Ltmp179:
; %bb.5:
	ldr	x8, [x0]
	ldr	x8, [x8, #56]
Ltmp180:
	mov	w1, #32                         ; =0x20
	blr	x8
Ltmp181:
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
Ltmp183:
	sxtb	w5, w23
	mov	x0, x22
	mov	x1, x20
	bl	__ZNSt3__116__pad_and_outputB9nqe210106IcNS_11char_traitsIcEEEENS_19ostreambuf_iteratorIT_T0_EES6_PKS4_S8_S8_RNS_8ios_baseES4_
Ltmp184:
; %bb.8:
	cbnz	x0, LBB11_10
; %bb.9:
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
	add	x0, x19, x8
	ldr	w8, [x0, #32]
	mov	w9, #5                          ; =0x5
Ltmp186:
	orr	w1, w8, w9
	bl	__ZNSt3__18ios_base5clearEj
Ltmp187:
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
Ltmp188:
	b	LBB11_15
LBB11_13:
Ltmp182:
	mov	x20, x0
	add	x0, sp, #24
	bl	__ZNSt3__16localeD1Ev
	b	LBB11_16
LBB11_14:
Ltmp185:
LBB11_15:
	mov	x20, x0
LBB11_16:
	add	x0, sp, #8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryD1Ev
	b	LBB11_18
LBB11_17:
Ltmp175:
	mov	x20, x0
LBB11_18:
	mov	x0, x20
	bl	___cxa_begin_catch
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
Ltmp189:
	add	x0, x19, x8
	bl	__ZNSt3__18ios_base33__set_badbit_and_consider_rethrowEv
Ltmp190:
; %bb.19:
	bl	___cxa_end_catch
	b	LBB11_11
LBB11_20:
Ltmp191:
	mov	x19, x0
Ltmp192:
	bl	___cxa_end_catch
Ltmp193:
; %bb.21:
	mov	x0, x19
	bl	__Unwind_Resume
LBB11_22:
Ltmp194:
	bl	___clang_call_terminate
	.loh AdrpLdrGot	Lloh80, Lloh81
Lfunc_end2:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table11:
Lexception2:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase1-Lttbaseref1
Lttbaseref1:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end2-Lcst_begin2
Lcst_begin2:
	.uleb128 Ltmp173-Lfunc_begin2           ; >> Call Site 1 <<
	.uleb128 Ltmp174-Ltmp173                ;   Call between Ltmp173 and Ltmp174
	.uleb128 Ltmp175-Lfunc_begin2           ;     jumps to Ltmp175
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp176-Lfunc_begin2           ; >> Call Site 2 <<
	.uleb128 Ltmp177-Ltmp176                ;   Call between Ltmp176 and Ltmp177
	.uleb128 Ltmp185-Lfunc_begin2           ;     jumps to Ltmp185
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp178-Lfunc_begin2           ; >> Call Site 3 <<
	.uleb128 Ltmp181-Ltmp178                ;   Call between Ltmp178 and Ltmp181
	.uleb128 Ltmp182-Lfunc_begin2           ;     jumps to Ltmp182
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp183-Lfunc_begin2           ; >> Call Site 4 <<
	.uleb128 Ltmp184-Ltmp183                ;   Call between Ltmp183 and Ltmp184
	.uleb128 Ltmp185-Lfunc_begin2           ;     jumps to Ltmp185
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp186-Lfunc_begin2           ; >> Call Site 5 <<
	.uleb128 Ltmp187-Ltmp186                ;   Call between Ltmp186 and Ltmp187
	.uleb128 Ltmp188-Lfunc_begin2           ;     jumps to Ltmp188
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp187-Lfunc_begin2           ; >> Call Site 6 <<
	.uleb128 Ltmp189-Ltmp187                ;   Call between Ltmp187 and Ltmp189
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp189-Lfunc_begin2           ; >> Call Site 7 <<
	.uleb128 Ltmp190-Ltmp189                ;   Call between Ltmp189 and Ltmp190
	.uleb128 Ltmp191-Lfunc_begin2           ;     jumps to Ltmp191
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp190-Lfunc_begin2           ; >> Call Site 8 <<
	.uleb128 Ltmp192-Ltmp190                ;   Call between Ltmp190 and Ltmp192
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp192-Lfunc_begin2           ; >> Call Site 9 <<
	.uleb128 Ltmp193-Ltmp192                ;   Call between Ltmp192 and Ltmp193
	.uleb128 Ltmp194-Lfunc_begin2           ;     jumps to Ltmp194
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp193-Lfunc_begin2           ; >> Call Site 10 <<
	.uleb128 Lfunc_end2-Ltmp193             ;   Call between Ltmp193 and Lfunc_end2
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
Ltmp195:
	mov	x0, x19
	mov	x2, x24
	blr	x8
Ltmp196:
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
	mov	x0, x23
	cmp	x0, x24
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
Ltmp197:
	mov	x19, x0
	ldrsb	w8, [sp, #31]
	tbz	w8, #31, LBB12_20
; %bb.19:
	ldr	x0, [sp, #8]
	bl	__ZdlPv
LBB12_20:
	mov	x0, x19
	bl	__Unwind_Resume
Lfunc_end3:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table12:
Lexception3:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end3-Lcst_begin3
Lcst_begin3:
	.uleb128 Lfunc_begin3-Lfunc_begin3      ; >> Call Site 1 <<
	.uleb128 Ltmp195-Lfunc_begin3           ;   Call between Lfunc_begin3 and Ltmp195
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp195-Lfunc_begin3           ; >> Call Site 2 <<
	.uleb128 Ltmp196-Ltmp195                ;   Call between Ltmp195 and Ltmp196
	.uleb128 Ltmp197-Lfunc_begin3           ;     jumps to Ltmp197
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp196-Lfunc_begin3           ; >> Call Site 3 <<
	.uleb128 Lfunc_end3-Ltmp196             ;   Call between Ltmp196 and Lfunc_end3
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
Lloh82:
	adrp	x0, l_.str.12@PAGE
Lloh83:
	add	x0, x0, l_.str.12@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh82, Lloh83
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
Lloh84:
	adrp	x0, l_.str.11@PAGE
Lloh85:
	add	x0, x0, l_.str.11@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh84, Lloh85
	.cfi_endproc
                                        ; -- End function
	.globl	_sink                           ; @sink
.zerofill __DATA,__common,_sink,8,3
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"layout/tail failed"

l_.str.2:                               ; @.str.2
	.asciz	"PASS "

l_.str.3:                               ; @.str.3
	.asciz	" shapes, offset1, odd stride, tails, guards, invalid stride\n"

	.section	__TEXT,__const
	.p2align	3, 0x0                          ; @constinit
l_constinit:
	.quad	17                              ; 0x11
	.quad	1                               ; 0x1
	.quad	58                              ; 0x3a
	.quad	641                             ; 0x281
	.quad	480                             ; 0x1e0
	.quad	1930                            ; 0x78a

	.section	__TEXT,__cstring,cstring_literals
l_.str.4:                               ; @.str.4
	.asciz	"shape="

l_.str.5:                               ; @.str.5
	.asciz	" stride="

l_.str.6:                               ; @.str.6
	.asciz	"scalar/autovec"

l_.str.7:                               ; @.str.7
	.asciz	"AoS LD3 direct"

l_.str.8:                               ; @.str.8
	.asciz	"SoA reused"

l_.str.9:                               ; @.str.9
	.asciz	"pack+SoA"

l_.str.10:                              ; @.str.10
	.asciz	"invalid shape/stride"

l_.str.11:                              ; @.str.11
	.asciz	"vector"

l_.str.12:                              ; @.str.12
	.asciz	"basic_string"

l_.str.13:                              ; @.str.13
	.asciz	" CPU batch_mean_us P50="

l_.str.14:                              ; @.str.14
	.asciz	" P95="

.subsections_via_symbols
