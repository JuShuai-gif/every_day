	.build_version macos, 26, 0	sdk_version 26, 5
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__Z3dotPKfS0_m                  ; -- Begin function _Z3dotPKfS0_m
	.p2align	2
__Z3dotPKfS0_m:                         ; @_Z3dotPKfS0_m
	.cfi_startproc
; %bb.0:
	cmp	x2, #4
	b.hs	LBB0_2
; %bb.1:
	mov	x8, #0                          ; =0x0
	movi.2d	v0, #0000000000000000
	b	LBB0_4
LBB0_2:
	mov	x10, #0                         ; =0x0
	movi.2d	v0, #0000000000000000
	mov	x9, x1
	mov	x11, x0
LBB0_3:                                 ; =>This Inner Loop Header: Depth=1
	ldr	q1, [x11], #16
	ldr	q2, [x9], #16
	fmla.4s	v0, v2, v1
	add	x8, x10, #4
	add	x12, x10, #8
	mov	x10, x8
	cmp	x12, x2
	b.ls	LBB0_3
LBB0_4:
	faddp.4s	v0, v0, v0
	faddp.2s	s0, v0
	subs	x9, x2, x8
	b.ls	LBB0_18
; %bb.5:
	cmp	x9, #4
	b.hs	LBB0_7
; %bb.6:
	mov	x9, x8
	b	LBB0_16
LBB0_7:
	cmp	x9, #16
	b.hs	LBB0_9
; %bb.8:
	mov	x10, #0                         ; =0x0
	b	LBB0_13
LBB0_9:
	and	x10, x9, #0xfffffffffffffff0
	lsl	x11, x8, #2
	add	x12, x11, #32
	add	x11, x0, x12
	add	x12, x1, x12
	mov	x13, x10
LBB0_10:                                ; =>This Inner Loop Header: Depth=1
	ldp	q1, q2, [x11, #-32]
	ldp	q3, q4, [x11], #64
	ldp	q5, q6, [x12, #-32]
	ldp	q7, q16, [x12], #64
	fmul.4s	v1, v1, v5
	mov	s5, v1[3]
	mov	s17, v1[2]
	mov	s18, v1[1]
	fmul.4s	v2, v2, v6
	mov	s6, v2[3]
	mov	s19, v2[2]
	mov	s20, v2[1]
	fmul.4s	v3, v3, v7
	mov	s7, v3[3]
	mov	s21, v3[2]
	mov	s22, v3[1]
	fmul.4s	v4, v4, v16
	mov	s16, v4[3]
	mov	s23, v4[2]
	mov	s24, v4[1]
	fadd	s0, s0, s1
	fadd	s0, s0, s18
	fadd	s0, s0, s17
	fadd	s0, s0, s5
	fadd	s0, s0, s2
	fadd	s0, s0, s20
	fadd	s0, s0, s19
	fadd	s0, s0, s6
	fadd	s0, s0, s3
	fadd	s0, s0, s22
	fadd	s0, s0, s21
	fadd	s0, s0, s7
	fadd	s0, s0, s4
	fadd	s0, s0, s24
	fadd	s0, s0, s23
	fadd	s0, s0, s16
	subs	x13, x13, #16
	b.ne	LBB0_10
; %bb.11:
	cmp	x9, x10
	b.eq	LBB0_18
; %bb.12:
	tst	x9, #0xc
	b.eq	LBB0_19
LBB0_13:
	and	x11, x2, #0x3
	sub	x9, x9, x11
	add	x9, x8, x9
	add	x10, x10, x8
	add	x8, x10, x11
	sub	x8, x8, x2
	lsl	x12, x10, #2
	add	x10, x1, x12
	add	x12, x0, x12
LBB0_14:                                ; =>This Inner Loop Header: Depth=1
	ldr	q1, [x12], #16
	ldr	q2, [x10], #16
	fmul.4s	v1, v1, v2
	mov	s2, v1[3]
	mov	s3, v1[2]
	mov	s4, v1[1]
	fadd	s0, s0, s1
	fadd	s0, s0, s4
	fadd	s0, s0, s3
	fadd	s0, s0, s2
	adds	x8, x8, #4
	b.ne	LBB0_14
; %bb.15:
	cbz	x11, LBB0_18
LBB0_16:
	sub	x8, x2, x9
	lsl	x10, x9, #2
	add	x9, x1, x10
	add	x10, x0, x10
LBB0_17:                                ; =>This Inner Loop Header: Depth=1
	ldr	s1, [x10], #4
	ldr	s2, [x9], #4
	fmadd	s0, s1, s2, s0
	subs	x8, x8, #1
	b.ne	LBB0_17
LBB0_18:
	ret
LBB0_19:
	add	x9, x8, x10
	b	LBB0_16
	.cfi_endproc
