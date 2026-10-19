	.build_version macos, 26, 0	sdk_version 26, 5
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_dot_optional                   ; -- Begin function dot_optional
	.p2align	2
_dot_optional:                          ; @dot_optional
	.cfi_startproc
; %bb.0:
	cmp	x2, #16
	b.hs	LBB0_2
; %bb.1:
	mov	x16, #0                         ; =0x0
	movi.2d	v0, #0000000000000000
	b	LBB0_4
LBB0_2:
	mov	x8, #0                          ; =0x0
	movi.2d	v0, #0000000000000000
LBB0_3:                                 ; =>This Inner Loop Header: Depth=1
	ldr	q1, [x0, x8]
	ldr	q2, [x1, x8]
	sdot.4s	v0, v1, v2
	add	x16, x8, #16
	add	x9, x8, #32
	mov	x8, x16
	cmp	x9, x2
	b.ls	LBB0_3
LBB0_4:
	addv.4s	s0, v0
	smov.s	x8, v0[0]
	subs	x9, x2, x16
	b.ls	LBB0_13
; %bb.5:
	stp	x20, x19, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	.cfi_offset w19, -8
	.cfi_offset w20, -16
	cmp	x9, #4
	b.hs	LBB0_7
; %bb.6:
	mov	x9, x16
	b	LBB0_10
LBB0_7:
	mov	x11, #0                         ; =0x0
	mov	x12, #0                         ; =0x0
	mov	x13, #0                         ; =0x0
	and	x10, x2, #0x3
	sub	x9, x9, x10
	add	x9, x16, x9
	add	x14, x16, x10
	sub	x14, x14, x2
	add	x15, x16, x0
	add	x15, x15, #1
	add	x16, x16, x1
	add	x16, x16, #3
LBB0_8:                                 ; =>This Inner Loop Header: Depth=1
	ldursb	x17, [x15, #-1]
	ldrsb	x3, [x15]
	ldrsb	x4, [x15, #1]
	ldrsb	x5, [x15, #2]
	ldursb	x6, [x16, #-3]
	ldursb	x7, [x16, #-2]
	ldursb	x19, [x16, #-1]
	ldrsb	x20, [x16]
	smaddl	x8, w6, w17, x8
	smaddl	x11, w7, w3, x11
	smaddl	x12, w19, w4, x12
	smaddl	x13, w20, w5, x13
	add	x15, x15, #4
	add	x16, x16, #4
	adds	x14, x14, #4
	b.ne	LBB0_8
; %bb.9:
	add	x8, x11, x8
	add	x11, x13, x12
	add	x8, x11, x8
	cbz	x10, LBB0_12
LBB0_10:
	sub	x10, x2, x9
	add	x11, x1, x9
	add	x9, x0, x9
LBB0_11:                                ; =>This Inner Loop Header: Depth=1
	ldrsb	x12, [x9], #1
	ldrsb	x13, [x11], #1
	smaddl	x8, w13, w12, x8
	subs	x10, x10, #1
	b.ne	LBB0_11
LBB0_12:
	ldp	x20, x19, [sp], #16             ; 16-byte Folded Reload
LBB0_13:
	mov	x0, x8
	ret
	.cfi_endproc
                                        ; -- End function
.subsections_via_symbols
