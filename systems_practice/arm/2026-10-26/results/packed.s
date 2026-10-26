; Actual Apple Clang21 AArch64 assembly excerpts; not a standalone translation unit.
__Z6scalarPKfPfii:                      ; @_Z6scalarPKfPfii
	.cfi_startproc
; %bb.0:
                                        ; kill: def $w3 killed $w3 def $x3
	cmp	w2, #1
	b.lt	LBB2_8
; %bb.1:
	mov	x8, #0                          ; =0x0
	scvtf	s0, w3
	mov	w9, w3
	ubfiz	x10, x3, #2, #32
	mov	w11, #50604                     ; =0xc5ac
	movk	w11, #14119, lsl #16
	fmov	s1, #1.00000000
	movi.2d	v2, #0000000000000000
	mov	w12, w2
	b	LBB2_3
LBB2_2:                                 ;   in Loop: Header=BB2_3 Depth=1
	add	x8, x8, #1
	add	x0, x0, x10
	add	x1, x1, x10
	cmp	x8, x12
	b.eq	LBB2_8
LBB2_3:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB2_5 Depth 2
                                        ;     Child Loop BB2_7 Depth 2
	cmp	w3, #1
	b.lt	LBB2_2
; %bb.4:                                ;   in Loop: Header=BB2_3 Depth=1
	movi.2d	v3, #0000000000000000
	mov	x13, x9
	mov	x14, x0
LBB2_5:                                 ;   Parent Loop BB2_3 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	s4, [x14], #4
	fmadd	s3, s4, s4, s3
	subs	x13, x13, #1
	b.ne	LBB2_5
; %bb.6:                                ;   in Loop: Header=BB2_3 Depth=1
	fdiv	s3, s3, s0
	fmov	s4, w11
	fadd	s3, s3, s4
	fsqrt	s3, s3
	fdiv	s3, s1, s3
LBB2_7:                                 ;   Parent Loop BB2_3 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	s4, [x0, x13]
	fmul	s4, s3, s4
	fmaxnm	s4, s4, s2
	str	s4, [x1, x13]
	add	x13, x13, #4
	cmp	x10, x13
	b.ne	LBB2_7
	b	LBB2_2
LBB2_8:
	ret
	.cfi_endproc

__Z11packed_reluPKfPfii:                ; @_Z11packed_reluPKfPfii
	.cfi_startproc
; %bb.0:
                                        ; kill: def $w3 killed $w3 def $x3
	cmp	w2, #1
	b.lt	LBB4_9
; %bb.1:
	mov	x8, #0                          ; =0x0
	mov	x9, #0                          ; =0x0
	scvtf	s0, w3
	dup.4s	v0, v0[0]
	mov	w10, w2
	mov	w11, w3
	sbfiz	x12, x3, #4, #32
	sbfiz	x13, x3, #2, #32
	ubfiz	x14, x3, #4, #32
	mov	w15, #50604                     ; =0xc5ac
	movk	w15, #14119, lsl #16
	dup.4s	v1, w15
	movi.2d	v2, #0000000000000000
	b	LBB4_3
LBB4_2:                                 ;   in Loop: Header=BB4_3 Depth=1
	add	x9, x9, #4
	add	x0, x0, x12
	add	x8, x8, x13
	cmp	x9, x10
	b.hs	LBB4_9
LBB4_3:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB4_5 Depth 2
                                        ;     Child Loop BB4_8 Depth 2
	movi.2d	v3, #0000000000000000
	cmp	w3, #1
	b.lt	LBB4_6
; %bb.4:                                ;   in Loop: Header=BB4_3 Depth=1
	mov	x15, x11
	mov	x16, x0
LBB4_5:                                 ;   Parent Loop BB4_3 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	q4, [x16], #16
	fmla.4s	v3, v4, v4
	subs	x15, x15, #1
	b.ne	LBB4_5
LBB4_6:                                 ;   in Loop: Header=BB4_3 Depth=1
	cmp	w3, #1
	b.lt	LBB4_2
; %bb.7:                                ;   in Loop: Header=BB4_3 Depth=1
	mov	x15, #0                         ; =0x0
	fdiv.4s	v3, v3, v0
	fadd.4s	v3, v3, v1
	frsqrte.4s	v4, v3
	fmul.4s	v5, v3, v4
	frsqrts.4s	v5, v5, v4
	fmul.4s	v4, v4, v5
	fmul.4s	v3, v3, v4
	frsqrts.4s	v3, v3, v4
	fmul.4s	v3, v4, v3
	mov	x16, x8
LBB4_8:                                 ;   Parent Loop BB4_3 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	q4, [x0, x15]
	fmul.4s	v4, v3, v4
	fmax.4s	v4, v4, v2
	and	x17, x16, #0xfffffffc
	lsl	x17, x17, #2
	str	q4, [x1, x17]
	add	x15, x15, #16
	add	x16, x16, #4
	cmp	x14, x15
	b.ne	LBB4_8
	b	LBB4_2
LBB4_9:
	ret
	.cfi_endproc
