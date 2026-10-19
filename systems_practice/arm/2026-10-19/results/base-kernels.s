// Apple clang21 -O3 -march=armv8-a -fno-vectorize -fno-slp-vectorize
_scalar:                                ; @scalar
	.cfi_startproc
; %bb.0:
	mov	x8, #0                          ; =0x0
	cbz	x2, LBB2_2
LBB2_1:                                 ; =>This Inner Loop Header: Depth=1
	ldrsb	x9, [x0], #1
	ldrsb	x10, [x1], #1
	smaddl	x8, w10, w9, x8
	subs	x2, x2, #1
	b.ne	LBB2_1
LBB2_2:
	mov	x0, x8
	ret
	.cfi_endproc

_neon:                                  ; @neon
	.cfi_startproc
; %bb.0:
	cmp	x2, #16
	b.hs	LBB3_2
; %bb.1:
	mov	x11, #0                         ; =0x0
	movi.2d	v0, #0000000000000000
	b	LBB3_4
LBB3_2:
	mov	x8, #0                          ; =0x0
	movi.2d	v0, #0000000000000000
LBB3_3:                                 ; =>This Inner Loop Header: Depth=1
	ldr	q1, [x0, x8]
	ldr	q2, [x1, x8]
	smull.8h	v3, v1, v2
	sadalp.4s	v0, v3
	smull2.8h	v1, v1, v2
	sadalp.4s	v0, v1
	add	x11, x8, #16
	add	x9, x8, #32
	mov	x8, x11
	cmp	x9, x2
	b.ls	LBB3_3
LBB3_4:
	addv.4s	s0, v0
	smov.s	x8, v0[0]
	subs	x9, x2, x11
	b.ls	LBB3_7
; %bb.5:
	add	x10, x1, x11
	add	x11, x0, x11
LBB3_6:                                 ; =>This Inner Loop Header: Depth=1
	ldrsb	x12, [x11], #1
	ldrsb	x13, [x10], #1
	smaddl	x8, w13, w12, x8
	subs	x9, x9, #1
	b.ne	LBB3_6
LBB3_7:
	mov	x0, x8
	ret
	.cfi_endproc
