	.build_version macos, 26, 0	sdk_version 26, 5
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__Z2ckbPKc                      ; -- Begin function _Z2ckbPKc
	.p2align	2
__Z2ckbPKc:                             ; @_Z2ckbPKc
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
	mov	x20, x1
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp0:
	mov	x1, x20
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp1:
; %bb.3:
	mov	x0, x19
	bl	__Z2ckbPKc.cold.1
LBB0_4:
Ltmp2:
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x0, x20
	bl	__Unwind_Resume
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
	.globl	__Z8validateRKNSt3__16vectorIfNS_9allocatorIfEEEES5_ ; -- Begin function _Z8validateRKNSt3__16vectorIfNS_9allocatorIfEEEES5_
	.p2align	2
__Z8validateRKNSt3__16vectorIfNS_9allocatorIfEEEES5_: ; @_Z8validateRKNSt3__16vectorIfNS_9allocatorIfEEEES5_
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
	ldp	x8, x11, [x0]
	sub	x12, x11, x8
	asr	x9, x12, #2
	ldp	x10, x13, [x1]
	sub	x13, x13, x10
	cmp	x9, #1, lsl #12                 ; =4096
	ccmp	x12, x13, #0, ls
	b.ne	LBB1_9
; %bb.1:
	cmp	x11, x8
	b.eq	LBB1_6
; %bb.2:
	mov	w11, #2139095039                ; =0x7f7fffff
	mov	w12, #761                       ; =0x2f9
	movk	w12, #20501, lsl #16
LBB1_3:                                 ; =>This Inner Loop Header: Depth=1
	ldr	s0, [x8], #4
	fmov	w13, s0
	and	w13, w13, #0x7fffffff
	cmp	w13, w11
	b.gt	LBB1_7
; %bb.4:                                ;   in Loop: Header=BB1_3 Depth=1
	fabs	s0, s0
	ldr	s1, [x10], #4
	fabs	s2, s1
	fmov	w13, s1
	and	w13, w13, #0x7fffffff
	cmp	w13, w11
	cset	w13, gt
	fmov	s1, w12
	fcmp	s2, s1
	fccmp	s0, s1, #0, le
	ccmp	w13, #0, #0, le
	b.ne	LBB1_7
; %bb.5:                                ;   in Loop: Header=BB1_3 Depth=1
	subs	x9, x9, #1
	b.ne	LBB1_3
LBB1_6:
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
	ret
LBB1_7:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp3:
Lloh0:
	adrp	x1, l_.str.1@PAGE
Lloh1:
	add	x1, x1, l_.str.1@PAGEOFF
	bl	__ZNSt16invalid_argumentC1B9nqe210106EPKc
Ltmp4:
; %bb.8:
	mov	x0, x19
	bl	__Z8validateRKNSt3__16vectorIfNS_9allocatorIfEEEES5_.cold.1
LBB1_9:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp6:
Lloh2:
	adrp	x1, l_.str@PAGE
Lloh3:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt16invalid_argumentC1B9nqe210106EPKc
Ltmp7:
; %bb.10:
	mov	x0, x19
	bl	__Z8validateRKNSt3__16vectorIfNS_9allocatorIfEEEES5_.cold.2
LBB1_11:
Ltmp8:
	b	LBB1_13
LBB1_12:
Ltmp5:
LBB1_13:
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x0, x20
	bl	__Unwind_Resume
	.loh AdrpAdd	Lloh0, Lloh1
	.loh AdrpAdd	Lloh2, Lloh3
Lfunc_end1:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table1:
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
Lloh4:
	adrp	x8, __ZTVSt16invalid_argument@GOTPAGE
Lloh5:
	ldr	x8, [x8, __ZTVSt16invalid_argument@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x0]
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
	.loh AdrpLdrGot	Lloh4, Lloh5
	.cfi_endproc
                                        ; -- End function
	.globl	__Z6scalarPKfS0_m               ; -- Begin function _Z6scalarPKfS0_m
	.p2align	2
__Z6scalarPKfS0_m:                      ; @_Z6scalarPKfS0_m
	.cfi_startproc
; %bb.0:
	movi.2d	v0, #0000000000000000
	cbz	x2, LBB3_2
LBB3_1:                                 ; =>This Inner Loop Header: Depth=1
	ldr	s1, [x0], #4
	ldr	s2, [x1], #4
	fmul	s1, s1, s2
	fadd	s0, s0, s1
	subs	x2, x2, #1
	b.ne	LBB3_1
LBB3_2:
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__Z5fusedPKfS0_m                ; -- Begin function _Z5fusedPKfS0_m
	.p2align	2
__Z5fusedPKfS0_m:                       ; @_Z5fusedPKfS0_m
	.cfi_startproc
; %bb.0:
	movi.2d	v0, #0000000000000000
	cbz	x2, LBB4_2
LBB4_1:                                 ; =>This Inner Loop Header: Depth=1
	ldr	s1, [x0], #4
	ldr	s2, [x1], #4
	fmadd	s0, s1, s2, s0
	subs	x2, x2, #1
	b.ne	LBB4_1
LBB4_2:
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__Z4neonPKfS0_m                 ; -- Begin function _Z4neonPKfS0_m
	.p2align	2
__Z4neonPKfS0_m:                        ; @_Z4neonPKfS0_m
	.cfi_startproc
; %bb.0:
	cmp	x2, #4
	b.hs	LBB5_2
; %bb.1:
	mov	x9, #0                          ; =0x0
	movi.2d	v0, #0000000000000000
	b	LBB5_4
LBB5_2:
	mov	x10, #0                         ; =0x0
	movi.2d	v0, #0000000000000000
	mov	x8, x1
	mov	x11, x0
LBB5_3:                                 ; =>This Inner Loop Header: Depth=1
	ldr	q1, [x11], #16
	ldr	q2, [x8], #16
	fmla.4s	v0, v2, v1
	add	x9, x10, #4
	add	x12, x10, #8
	mov	x10, x9
	cmp	x12, x2
	b.ls	LBB5_3
LBB5_4:
	faddp.4s	v0, v0, v0
	faddp.2s	s0, v0
	subs	x8, x2, x9
	b.ls	LBB5_7
; %bb.5:
	lsl	x10, x9, #2
	add	x9, x1, x10
	add	x10, x0, x10
LBB5_6:                                 ; =>This Inner Loop Header: Depth=1
	ldr	s1, [x10], #4
	ldr	s2, [x9], #4
	fmadd	s0, s1, s2, s0
	subs	x8, x8, #1
	b.ne	LBB5_6
LBB5_7:
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__Z8separatefff                 ; -- Begin function _Z8separatefff
	.p2align	2
__Z8separatefff:                        ; @_Z8separatefff
	.cfi_startproc
; %bb.0:
	fmul	s0, s0, s1
	fadd	s0, s0, s2
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_main                           ; -- Begin function main
	.p2align	2
_main:                                  ; @main
Lfunc_begin2:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception2
; %bb.0:
	sub	sp, sp, #272
	stp	d15, d14, [sp, #112]            ; 16-byte Folded Spill
	stp	d13, d12, [sp, #128]            ; 16-byte Folded Spill
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
	.cfi_offset b12, -136
	.cfi_offset b13, -144
	.cfi_offset b14, -152
	.cfi_offset b15, -160
	mov	x21, #0                         ; =0x0
	movi.2d	v8, #0000000000000000
	mov	x23, #60813                     ; =0xed8d
	movk	x23, #41141, lsl #16
	movk	x23, #50935, lsl #32
	movk	x23, #16048, lsl #48
	mov	w24, #60495                     ; =0xec4f
	movk	w24, #20164, lsl #16
	mov	w25, #13                        ; =0xd
	fmov	s9, #7.00000000
	mov	w26, #27595                     ; =0x6bcb
	movk	w26, #44840, lsl #16
	mov	w27, #19                        ; =0x13
	fmov	s10, #9.00000000
	b	LBB7_2
LBB7_1:                                 ;   in Loop: Header=BB7_2 Depth=1
	mov	x21, x22
	cmp	x22, #258
	b.eq	LBB7_20
LBB7_2:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB7_6 Depth 2
                                        ;     Child Loop BB7_11 Depth 2
	stp	xzr, xzr, [sp, #80]
	str	xzr, [sp, #96]
	cbz	x21, LBB7_7
; %bb.3:                                ;   in Loop: Header=BB7_2 Depth=1
	lsl	x22, x21, #2
Ltmp9:
	mov	x0, x22
	bl	__Znwm
Ltmp10:
; %bb.4:                                ;   in Loop: Header=BB7_2 Depth=1
	mov	x19, x0
	add	x8, x0, x21, lsl #2
	str	x0, [sp, #80]
	str	x8, [sp, #96]
	add	x20, x0, x22
	mov	x1, x22
	bl	_bzero
	str	x20, [sp, #88]
Ltmp12:
	mov	x0, x22
	bl	__Znwm
Ltmp13:
; %bb.5:                                ;   in Loop: Header=BB7_2 Depth=1
	mov	x20, x0
	add	x8, x0, x21, lsl #2
	str	x0, [sp, #56]
	str	x8, [sp, #72]
	add	x28, x0, x22
	mov	x1, x22
	bl	_bzero
	mov	x8, #0                          ; =0x0
	str	x28, [sp, #64]
	mov	w9, #-6                         ; =0xfffffffa
	mov	w10, #-9                        ; =0xfffffff7
LBB7_6:                                 ;   Parent Loop BB7_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	mov	w11, w8
	umull	x12, w11, w24
	lsr	x12, x12, #34
	msub	w12, w12, w25, w9
	umull	x11, w11, w26
	lsr	x11, x11, #32
	sub	w13, w8, w11
	add	w11, w11, w13, lsr #1
	lsr	w11, w11, #4
	msub	w11, w11, w27, w10
	scvtf	s0, w11
	fdiv	s0, s0, s9
	str	s0, [x19, x8, lsl #2]
	scvtf	s0, w12
	fdiv	s0, s0, s10
	str	s0, [x20, x8, lsl #2]
	add	x8, x8, #1
	add	w9, w9, #1
	add	w10, w10, #1
	cmp	x21, x8
	b.ne	LBB7_6
	b	LBB7_8
LBB7_7:                                 ;   in Loop: Header=BB7_2 Depth=1
	mov	x19, #0                         ; =0x0
	mov	x20, #0                         ; =0x0
	stp	xzr, xzr, [sp, #56]
	str	xzr, [sp, #72]
LBB7_8:                                 ;   in Loop: Header=BB7_2 Depth=1
Ltmp15:
	add	x0, sp, #80
	add	x1, sp, #56
	bl	__Z8validateRKNSt3__16vectorIfNS_9allocatorIfEEEES5_
Ltmp16:
; %bb.9:                                ;   in Loop: Header=BB7_2 Depth=1
	cbz	x21, LBB7_12
; %bb.10:                               ;   in Loop: Header=BB7_2 Depth=1
	mov	x8, #0                          ; =0x0
	movi.2d	v11, #0000000000000000
	movi.2d	v0, #0000000000000000
LBB7_11:                                ;   Parent Loop BB7_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	s1, [x19, x8, lsl #2]
	fcvt	d1, s1
	ldr	s2, [x20, x8, lsl #2]
	fcvt	d2, s2
	fmul	d1, d1, d2
	fadd	d11, d11, d1
	fabs	d1, d1
	fadd	d0, d0, d1
	add	x8, x8, #1
	cmp	x21, x8
	b.ne	LBB7_11
	b	LBB7_13
LBB7_12:                                ;   in Loop: Header=BB7_2 Depth=1
	movi.2d	v0, #0000000000000000
	movi.2d	v11, #0000000000000000
LBB7_13:                                ;   in Loop: Header=BB7_2 Depth=1
	add	x22, x21, #1
	lsl	w8, w22, #2
	ucvtf	s1, w8, #23
	fcvt	d1, s1
	fmul	d0, d0, d1
	fmov	d1, x23
	fadd	d12, d0, d1
	mov	x0, x19
	mov	x1, x20
	mov	x2, x21
	bl	__Z6scalarPKfS0_m
	fcvt	d0, s0
	fabd	d13, d0, d11
	fcmp	d13, d12
	b.hi	LBB7_54
; %bb.14:                               ;   in Loop: Header=BB7_2 Depth=1
	mov	x0, x19
	mov	x1, x20
	mov	x2, x21
	bl	__Z5fusedPKfS0_m
	fcvt	d0, s0
	fabd	d14, d0, d11
	fcmp	d14, d12
	b.hi	LBB7_54
; %bb.15:                               ;   in Loop: Header=BB7_2 Depth=1
	mov	x0, x19
	mov	x1, x20
	mov	x2, x21
	bl	__Z4neonPKfS0_m
	fcvt	d0, s0
	fabd	d0, d0, d11
	fcmp	d0, d12
	b.hi	LBB7_54
; %bb.16:                               ;   in Loop: Header=BB7_2 Depth=1
	fcmp	d8, d13
	fcsel	d1, d13, d8, mi
	fcmp	d1, d14
	fcsel	d1, d14, d1, mi
	fcmp	d1, d0
	fcsel	d8, d0, d1, mi
	cbz	x20, LBB7_18
; %bb.17:                               ;   in Loop: Header=BB7_2 Depth=1
	mov	x0, x20
	bl	__ZdlPv
LBB7_18:                                ;   in Loop: Header=BB7_2 Depth=1
	cbz	x19, LBB7_1
; %bb.19:                               ;   in Loop: Header=BB7_2 Depth=1
	mov	x0, x19
	bl	__ZdlPv
	b	LBB7_1
LBB7_20:
	mov	w8, #1                          ; =0x1
	movk	w8, #16256, lsl #16
	fmov	s0, w8
	mov	w8, #65534                      ; =0xfffe
	movk	w8, #16255, lsl #16
	fmov	s1, w8
	fmov	s2, #-1.00000000
	bl	__Z8separatefff
	fcmp	s0, #0.0
	b.ne	LBB7_56
; %bb.21:
Ltmp24:
	mov.16b	v9, v0
	mov	w0, #16                         ; =0x10
	bl	__Znwm
Ltmp25:
; %bb.22:
	mov	x19, x0
	add	x8, x0, #16
	stp	x8, x8, [sp, #88]
	mov	x9, #48160                      ; =0xbc20
	movk	x9, #19646, lsl #16
	movk	x9, #16256, lsl #48
	mov	x10, #48160                     ; =0xbc20
	movk	x10, #52414, lsl #16
	movk	x10, #16256, lsl #48
	stp	x9, x10, [x0]
	str	x0, [sp, #80]
Ltmp27:
	mov	w0, #16                         ; =0x10
	bl	__Znwm
Ltmp28:
; %bb.23:
	mov	x20, x0
	add	x21, x0, #16
	str	x0, [sp, #56]
	str	x21, [sp, #72]
Lloh6:
	adrp	x1, l_.memset_pattern@PAGE
Lloh7:
	add	x1, x1, l_.memset_pattern@PAGEOFF
	mov	w2, #16                         ; =0x10
	bl	_memset_pattern16
	str	x21, [sp, #64]
Ltmp30:
	add	x0, sp, #80
	add	x1, sp, #56
	bl	__Z8validateRKNSt3__16vectorIfNS_9allocatorIfEEEES5_
Ltmp31:
; %bb.24:
Ltmp32:
Lloh8:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh9:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh10:
	adrp	x1, l_.str.4@PAGE
Lloh11:
	add	x1, x1, l_.str.4@PAGEOFF
	mov	w2, #18                         ; =0x12
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp33:
; %bb.25:
	mov	x21, x0
	mov	x0, x19
	mov	x1, x20
	mov	w2, #4                          ; =0x4
	bl	__Z6scalarPKfS0_m
Ltmp34:
	mov	x0, x21
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEf
Ltmp35:
; %bb.26:
Ltmp36:
Lloh12:
	adrp	x1, l_.str.5@PAGE
Lloh13:
	add	x1, x1, l_.str.5@PAGEOFF
	mov	w2, #11                         ; =0xb
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp37:
; %bb.27:
	mov	x21, x0
	mov	x0, x19
	mov	x1, x20
	mov	w2, #4                          ; =0x4
	bl	__Z4neonPKfS0_m
Ltmp38:
	mov	x0, x21
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEf
Ltmp39:
; %bb.28:
Ltmp40:
Lloh14:
	adrp	x1, l_.str.6@PAGE
Lloh15:
	add	x1, x1, l_.str.6@PAGEOFF
	mov	w2, #17                         ; =0x11
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp41:
; %bb.29:
Ltmp43:
	mov	w0, #4                          ; =0x4
	bl	__Znwm
Ltmp44:
; %bb.30:
	mov	x22, x0
	mov	w8, #2139095040                 ; =0x7f800000
	mov	x9, x0
	str	w8, [x9], #4
	stp	x9, x9, [sp, #40]
	str	x0, [sp, #32]
Ltmp46:
	mov	w0, #4                          ; =0x4
	bl	__Znwm
Ltmp47:
; %bb.31:
	mov	x21, x0
	mov	w8, #1073741824                 ; =0x40000000
	mov	x9, x0
	str	w8, [x9], #4
	stp	x9, x9, [sp, #16]
	str	x0, [sp, #8]
Ltmp49:
	add	x0, sp, #32
	add	x1, sp, #8
	bl	__Z8validateRKNSt3__16vectorIfNS_9allocatorIfEEEES5_
Ltmp50:
; %bb.32:
	mov	x0, x21
	bl	__ZdlPv
	mov	x0, x22
	bl	__ZdlPv
	mov	w23, #0                         ; =0x0
LBB7_33:
Ltmp54:
	mov	w0, #4                          ; =0x4
	bl	__Znwm
Ltmp55:
; %bb.34:
	mov	x22, x0
	mov	w8, #2143289344                 ; =0x7fc00000
	mov	x9, x0
	str	w8, [x9], #4
	stp	x9, x9, [sp, #40]
	str	x0, [sp, #32]
Ltmp57:
	mov	w0, #4                          ; =0x4
	bl	__Znwm
Ltmp58:
; %bb.35:
	mov	x21, x0
	mov	w8, #1073741824                 ; =0x40000000
	mov	x9, x0
	str	w8, [x9], #4
	stp	x9, x9, [sp, #16]
	str	x0, [sp, #8]
Ltmp60:
	add	x0, sp, #32
	add	x1, sp, #8
	bl	__Z8validateRKNSt3__16vectorIfNS_9allocatorIfEEEES5_
Ltmp61:
; %bb.36:
	mov	x0, x21
	bl	__ZdlPv
	mov	x0, x22
	bl	__ZdlPv
LBB7_37:
Ltmp65:
	mov	w0, #4                          ; =0x4
	bl	__Znwm
Ltmp66:
; %bb.38:
	mov	x22, x0
	mov	w8, #2139095039                 ; =0x7f7fffff
	mov	x9, x0
	str	w8, [x9], #4
	stp	x9, x9, [sp, #40]
	str	x0, [sp, #32]
Ltmp68:
	mov	w0, #4                          ; =0x4
	bl	__Znwm
Ltmp69:
; %bb.39:
	mov	x21, x0
	mov	w8, #1073741824                 ; =0x40000000
	mov	x9, x0
	str	w8, [x9], #4
	stp	x9, x9, [sp, #16]
	str	x0, [sp, #8]
Ltmp71:
	add	x0, sp, #32
	add	x1, sp, #8
	bl	__Z8validateRKNSt3__16vectorIfNS_9allocatorIfEEEES5_
Ltmp72:
; %bb.40:
	mov	x0, x21
	bl	__ZdlPv
	mov	x0, x22
	bl	__ZdlPv
	cmp	w23, #3
	b.ne	LBB7_68
LBB7_41:
Ltmp82:
Lloh16:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh17:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh18:
	adrp	x1, l_.str.8@PAGE
Lloh19:
	add	x1, x1, l_.str.8@PAGEOFF
	mov	w2, #11                         ; =0xb
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp83:
; %bb.42:
Ltmp84:
	mov	w1, #774                        ; =0x306
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEi
Ltmp85:
; %bb.43:
Ltmp86:
Lloh20:
	adrp	x1, l_.str.9@PAGE
Lloh21:
	add	x1, x1, l_.str.9@PAGEOFF
	mov	w2, #17                         ; =0x11
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp87:
; %bb.44:
Ltmp88:
	mov.16b	v0, v8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp89:
; %bb.45:
Ltmp90:
Lloh22:
	adrp	x1, l_.str.10@PAGE
Lloh23:
	add	x1, x1, l_.str.10@PAGEOFF
	mov	w2, #10                         ; =0xa
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp91:
; %bb.46:
Ltmp92:
	mov.16b	v0, v9
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEf
Ltmp93:
; %bb.47:
Ltmp94:
Lloh24:
	adrp	x1, l_.str.11@PAGE
Lloh25:
	add	x1, x1, l_.str.11@PAGEOFF
	mov	w2, #5                          ; =0x5
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp95:
; %bb.48:
Ltmp96:
	mov	w8, #-1468006400                ; =0xa8800000
	fmov	s0, w8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEf
Ltmp97:
; %bb.49:
Ltmp98:
Lloh26:
	adrp	x1, l_.str.12@PAGE
Lloh27:
	add	x1, x1, l_.str.12@PAGEOFF
	mov	w2, #9                          ; =0x9
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp99:
; %bb.50:
Ltmp100:
	mov	w1, #3                          ; =0x3
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEi
Ltmp101:
; %bb.51:
Ltmp102:
Lloh28:
	adrp	x1, l_.str.13@PAGE
Lloh29:
	add	x1, x1, l_.str.13@PAGEOFF
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp103:
; %bb.52:
	mov	x0, x20
	bl	__ZdlPv
	mov	x0, x19
	bl	__ZdlPv
	mov	w0, #0                          ; =0x0
LBB7_53:
	ldp	x29, x30, [sp, #256]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #240]            ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #224]            ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #208]            ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #192]            ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #176]            ; 16-byte Folded Reload
	ldp	d9, d8, [sp, #160]              ; 16-byte Folded Reload
	ldp	d11, d10, [sp, #144]            ; 16-byte Folded Reload
	ldp	d13, d12, [sp, #128]            ; 16-byte Folded Reload
	ldp	d15, d14, [sp, #112]            ; 16-byte Folded Reload
	add	sp, sp, #272
	ret
LBB7_54:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x23, x0
Ltmp105:
Lloh30:
	adrp	x1, l_.str.2@PAGE
Lloh31:
	add	x1, x1, l_.str.2@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp106:
; %bb.55:
Ltmp108:
Lloh32:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh33:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh34:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh35:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x23
	bl	___cxa_throw
Ltmp109:
	b	LBB7_70
LBB7_56:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp18:
Lloh36:
	adrp	x1, l_.str.3@PAGE
Lloh37:
	add	x1, x1, l_.str.3@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp19:
; %bb.57:
Ltmp21:
Lloh38:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh39:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh40:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh41:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
Ltmp22:
	b	LBB7_70
LBB7_58:
Ltmp23:
	b	LBB7_96
LBB7_59:
Ltmp20:
	mov	x21, x1
	mov	x22, x0
	mov	x0, x19
	bl	___cxa_free_exception
	b	LBB7_105
LBB7_60:
Ltmp73:
	mov	x8, x21
	mov	x21, x1
	str	x0, [sp]                        ; 8-byte Folded Spill
	mov	x0, x8
	bl	__ZdlPv
	b	LBB7_62
LBB7_61:
Ltmp70:
	mov	x21, x1
	str	x0, [sp]                        ; 8-byte Folded Spill
LBB7_62:
	mov	x0, x22
	bl	__ZdlPv
	b	LBB7_65
LBB7_63:
Ltmp62:
	mov	x8, x21
	mov	x21, x1
	str	x0, [sp]                        ; 8-byte Folded Spill
	mov	x0, x8
	bl	__ZdlPv
	b	LBB7_73
LBB7_64:
Ltmp67:
	mov	x21, x1
	str	x0, [sp]                        ; 8-byte Folded Spill
LBB7_65:
	cmp	w21, #2
	b.ne	LBB7_91
; %bb.66:
	ldr	x0, [sp]                        ; 8-byte Folded Reload
	bl	___cxa_begin_catch
Ltmp74:
	bl	___cxa_end_catch
Ltmp75:
; %bb.67:
	add	w23, w23, #1
	cmp	w23, #3
	b.eq	LBB7_41
LBB7_68:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x22, x0
Ltmp77:
Lloh42:
	adrp	x1, l_.str.7@PAGE
Lloh43:
	add	x1, x1, l_.str.7@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp78:
; %bb.69:
Ltmp80:
Lloh44:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh45:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh46:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh47:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x22
	bl	___cxa_throw
Ltmp81:
LBB7_70:
	brk	#0x1
LBB7_71:
Ltmp79:
	mov	x21, x1
	str	x0, [sp]                        ; 8-byte Folded Spill
	mov	x0, x22
	bl	___cxa_free_exception
	b	LBB7_91
LBB7_72:
Ltmp59:
	mov	x21, x1
	str	x0, [sp]                        ; 8-byte Folded Spill
LBB7_73:
	mov	x0, x22
	bl	__ZdlPv
	b	LBB7_76
LBB7_74:
Ltmp51:
	mov	x8, x21
	mov	x21, x1
	str	x0, [sp]                        ; 8-byte Folded Spill
	mov	x0, x8
	bl	__ZdlPv
	b	LBB7_80
LBB7_75:
Ltmp56:
	mov	x21, x1
	str	x0, [sp]                        ; 8-byte Folded Spill
LBB7_76:
	cmp	w21, #2
	b.ne	LBB7_91
; %bb.77:
	ldr	x0, [sp]                        ; 8-byte Folded Reload
	bl	___cxa_begin_catch
Ltmp63:
	bl	___cxa_end_catch
Ltmp64:
; %bb.78:
	add	w23, w23, #1
	b	LBB7_37
LBB7_79:
Ltmp48:
	mov	x21, x1
	str	x0, [sp]                        ; 8-byte Folded Spill
LBB7_80:
	mov	x0, x22
	bl	__ZdlPv
	b	LBB7_82
LBB7_81:
Ltmp45:
	mov	x21, x1
	str	x0, [sp]                        ; 8-byte Folded Spill
LBB7_82:
	cmp	w21, #2
	b.ne	LBB7_91
; %bb.83:
	ldr	x0, [sp]                        ; 8-byte Folded Reload
	bl	___cxa_begin_catch
Ltmp52:
	bl	___cxa_end_catch
Ltmp53:
; %bb.84:
	mov	w23, #1                         ; =0x1
	b	LBB7_33
LBB7_85:
Ltmp76:
	b	LBB7_90
LBB7_86:
Ltmp29:
	mov	x21, x1
	str	x0, [sp]                        ; 8-byte Folded Spill
	b	LBB7_92
LBB7_87:
Ltmp26:
	mov	x21, x1
	str	x0, [sp]                        ; 8-byte Folded Spill
	b	LBB7_93
LBB7_88:
Ltmp42:
	b	LBB7_90
LBB7_89:
Ltmp104:
LBB7_90:
	mov	x21, x1
	str	x0, [sp]                        ; 8-byte Folded Spill
LBB7_91:
	mov	x0, x20
	bl	__ZdlPv
LBB7_92:
	mov	x0, x19
	bl	__ZdlPv
LBB7_93:
	ldr	x22, [sp]                       ; 8-byte Folded Reload
	b	LBB7_105
LBB7_94:
Ltmp14:
	mov	x21, x1
	mov	x22, x0
	b	LBB7_104
LBB7_95:
Ltmp11:
LBB7_96:
	mov	x21, x1
	mov	x22, x0
	b	LBB7_105
LBB7_97:
Ltmp17:
	b	LBB7_99
LBB7_98:
Ltmp110:
LBB7_99:
	mov	x21, x1
	mov	x22, x0
	b	LBB7_101
LBB7_100:
Ltmp107:
	mov	x21, x1
	mov	x22, x0
	mov	x0, x23
	bl	___cxa_free_exception
LBB7_101:
	cbz	x20, LBB7_103
; %bb.102:
	mov	x0, x20
	bl	__ZdlPv
LBB7_103:
	cbz	x19, LBB7_105
LBB7_104:
	mov	x0, x19
	bl	__ZdlPv
LBB7_105:
	cmp	w21, #1
	b.ne	LBB7_110
; %bb.106:
	mov	x0, x22
	bl	___cxa_begin_catch
	ldr	x8, [x0]
	ldr	x8, [x8, #16]
	blr	x8
	mov	x19, x0
	bl	_strlen
	mov	x2, x0
Ltmp111:
Lloh48:
	adrp	x0, __ZNSt3__14cerrE@GOTPAGE
Lloh49:
	ldr	x0, [x0, __ZNSt3__14cerrE@GOTPAGEOFF]
	mov	x1, x19
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp112:
; %bb.107:
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #80]
Ltmp113:
	add	x1, sp, #80
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp114:
; %bb.108:
	bl	___cxa_end_catch
	mov	w0, #1                          ; =0x1
	b	LBB7_53
LBB7_109:
Ltmp115:
	mov	x22, x0
Ltmp116:
	bl	___cxa_end_catch
Ltmp117:
LBB7_110:
	mov	x0, x22
	bl	__Unwind_Resume
LBB7_111:
Ltmp118:
	bl	___clang_call_terminate
	.loh AdrpAdd	Lloh6, Lloh7
	.loh AdrpAdd	Lloh10, Lloh11
	.loh AdrpLdrGot	Lloh8, Lloh9
	.loh AdrpAdd	Lloh12, Lloh13
	.loh AdrpAdd	Lloh14, Lloh15
	.loh AdrpAdd	Lloh18, Lloh19
	.loh AdrpLdrGot	Lloh16, Lloh17
	.loh AdrpAdd	Lloh20, Lloh21
	.loh AdrpAdd	Lloh22, Lloh23
	.loh AdrpAdd	Lloh24, Lloh25
	.loh AdrpAdd	Lloh26, Lloh27
	.loh AdrpAdd	Lloh28, Lloh29
	.loh AdrpAdd	Lloh30, Lloh31
	.loh AdrpLdrGot	Lloh34, Lloh35
	.loh AdrpLdrGot	Lloh32, Lloh33
	.loh AdrpAdd	Lloh36, Lloh37
	.loh AdrpLdrGot	Lloh40, Lloh41
	.loh AdrpLdrGot	Lloh38, Lloh39
	.loh AdrpAdd	Lloh42, Lloh43
	.loh AdrpLdrGot	Lloh46, Lloh47
	.loh AdrpLdrGot	Lloh44, Lloh45
	.loh AdrpLdrGot	Lloh48, Lloh49
Lfunc_end2:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table7:
Lexception2:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase0-Lttbaseref0
Lttbaseref0:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end2-Lcst_begin2
Lcst_begin2:
	.uleb128 Ltmp9-Lfunc_begin2             ; >> Call Site 1 <<
	.uleb128 Ltmp10-Ltmp9                   ;   Call between Ltmp9 and Ltmp10
	.uleb128 Ltmp11-Lfunc_begin2            ;     jumps to Ltmp11
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp10-Lfunc_begin2            ; >> Call Site 2 <<
	.uleb128 Ltmp12-Ltmp10                  ;   Call between Ltmp10 and Ltmp12
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp12-Lfunc_begin2            ; >> Call Site 3 <<
	.uleb128 Ltmp13-Ltmp12                  ;   Call between Ltmp12 and Ltmp13
	.uleb128 Ltmp14-Lfunc_begin2            ;     jumps to Ltmp14
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp13-Lfunc_begin2            ; >> Call Site 4 <<
	.uleb128 Ltmp15-Ltmp13                  ;   Call between Ltmp13 and Ltmp15
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp15-Lfunc_begin2            ; >> Call Site 5 <<
	.uleb128 Ltmp16-Ltmp15                  ;   Call between Ltmp15 and Ltmp16
	.uleb128 Ltmp17-Lfunc_begin2            ;     jumps to Ltmp17
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp24-Lfunc_begin2            ; >> Call Site 6 <<
	.uleb128 Ltmp25-Ltmp24                  ;   Call between Ltmp24 and Ltmp25
	.uleb128 Ltmp26-Lfunc_begin2            ;     jumps to Ltmp26
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp27-Lfunc_begin2            ; >> Call Site 7 <<
	.uleb128 Ltmp28-Ltmp27                  ;   Call between Ltmp27 and Ltmp28
	.uleb128 Ltmp29-Lfunc_begin2            ;     jumps to Ltmp29
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp30-Lfunc_begin2            ; >> Call Site 8 <<
	.uleb128 Ltmp41-Ltmp30                  ;   Call between Ltmp30 and Ltmp41
	.uleb128 Ltmp42-Lfunc_begin2            ;     jumps to Ltmp42
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp43-Lfunc_begin2            ; >> Call Site 9 <<
	.uleb128 Ltmp44-Ltmp43                  ;   Call between Ltmp43 and Ltmp44
	.uleb128 Ltmp45-Lfunc_begin2            ;     jumps to Ltmp45
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp46-Lfunc_begin2            ; >> Call Site 10 <<
	.uleb128 Ltmp47-Ltmp46                  ;   Call between Ltmp46 and Ltmp47
	.uleb128 Ltmp48-Lfunc_begin2            ;     jumps to Ltmp48
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp49-Lfunc_begin2            ; >> Call Site 11 <<
	.uleb128 Ltmp50-Ltmp49                  ;   Call between Ltmp49 and Ltmp50
	.uleb128 Ltmp51-Lfunc_begin2            ;     jumps to Ltmp51
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp54-Lfunc_begin2            ; >> Call Site 12 <<
	.uleb128 Ltmp55-Ltmp54                  ;   Call between Ltmp54 and Ltmp55
	.uleb128 Ltmp56-Lfunc_begin2            ;     jumps to Ltmp56
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp57-Lfunc_begin2            ; >> Call Site 13 <<
	.uleb128 Ltmp58-Ltmp57                  ;   Call between Ltmp57 and Ltmp58
	.uleb128 Ltmp59-Lfunc_begin2            ;     jumps to Ltmp59
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp60-Lfunc_begin2            ; >> Call Site 14 <<
	.uleb128 Ltmp61-Ltmp60                  ;   Call between Ltmp60 and Ltmp61
	.uleb128 Ltmp62-Lfunc_begin2            ;     jumps to Ltmp62
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp65-Lfunc_begin2            ; >> Call Site 15 <<
	.uleb128 Ltmp66-Ltmp65                  ;   Call between Ltmp65 and Ltmp66
	.uleb128 Ltmp67-Lfunc_begin2            ;     jumps to Ltmp67
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp68-Lfunc_begin2            ; >> Call Site 16 <<
	.uleb128 Ltmp69-Ltmp68                  ;   Call between Ltmp68 and Ltmp69
	.uleb128 Ltmp70-Lfunc_begin2            ;     jumps to Ltmp70
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp71-Lfunc_begin2            ; >> Call Site 17 <<
	.uleb128 Ltmp72-Ltmp71                  ;   Call between Ltmp71 and Ltmp72
	.uleb128 Ltmp73-Lfunc_begin2            ;     jumps to Ltmp73
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp82-Lfunc_begin2            ; >> Call Site 18 <<
	.uleb128 Ltmp103-Ltmp82                 ;   Call between Ltmp82 and Ltmp103
	.uleb128 Ltmp104-Lfunc_begin2           ;     jumps to Ltmp104
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp103-Lfunc_begin2           ; >> Call Site 19 <<
	.uleb128 Ltmp105-Ltmp103                ;   Call between Ltmp103 and Ltmp105
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp105-Lfunc_begin2           ; >> Call Site 20 <<
	.uleb128 Ltmp106-Ltmp105                ;   Call between Ltmp105 and Ltmp106
	.uleb128 Ltmp107-Lfunc_begin2           ;     jumps to Ltmp107
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp108-Lfunc_begin2           ; >> Call Site 21 <<
	.uleb128 Ltmp109-Ltmp108                ;   Call between Ltmp108 and Ltmp109
	.uleb128 Ltmp110-Lfunc_begin2           ;     jumps to Ltmp110
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp109-Lfunc_begin2           ; >> Call Site 22 <<
	.uleb128 Ltmp18-Ltmp109                 ;   Call between Ltmp109 and Ltmp18
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp18-Lfunc_begin2            ; >> Call Site 23 <<
	.uleb128 Ltmp19-Ltmp18                  ;   Call between Ltmp18 and Ltmp19
	.uleb128 Ltmp20-Lfunc_begin2            ;     jumps to Ltmp20
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp21-Lfunc_begin2            ; >> Call Site 24 <<
	.uleb128 Ltmp22-Ltmp21                  ;   Call between Ltmp21 and Ltmp22
	.uleb128 Ltmp23-Lfunc_begin2            ;     jumps to Ltmp23
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp22-Lfunc_begin2            ; >> Call Site 25 <<
	.uleb128 Ltmp74-Ltmp22                  ;   Call between Ltmp22 and Ltmp74
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp74-Lfunc_begin2            ; >> Call Site 26 <<
	.uleb128 Ltmp75-Ltmp74                  ;   Call between Ltmp74 and Ltmp75
	.uleb128 Ltmp76-Lfunc_begin2            ;     jumps to Ltmp76
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp75-Lfunc_begin2            ; >> Call Site 27 <<
	.uleb128 Ltmp77-Ltmp75                  ;   Call between Ltmp75 and Ltmp77
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp77-Lfunc_begin2            ; >> Call Site 28 <<
	.uleb128 Ltmp78-Ltmp77                  ;   Call between Ltmp77 and Ltmp78
	.uleb128 Ltmp79-Lfunc_begin2            ;     jumps to Ltmp79
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp80-Lfunc_begin2            ; >> Call Site 29 <<
	.uleb128 Ltmp81-Ltmp80                  ;   Call between Ltmp80 and Ltmp81
	.uleb128 Ltmp104-Lfunc_begin2           ;     jumps to Ltmp104
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp81-Lfunc_begin2            ; >> Call Site 30 <<
	.uleb128 Ltmp63-Ltmp81                  ;   Call between Ltmp81 and Ltmp63
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp63-Lfunc_begin2            ; >> Call Site 31 <<
	.uleb128 Ltmp64-Ltmp63                  ;   Call between Ltmp63 and Ltmp64
	.uleb128 Ltmp76-Lfunc_begin2            ;     jumps to Ltmp76
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp64-Lfunc_begin2            ; >> Call Site 32 <<
	.uleb128 Ltmp52-Ltmp64                  ;   Call between Ltmp64 and Ltmp52
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp52-Lfunc_begin2            ; >> Call Site 33 <<
	.uleb128 Ltmp53-Ltmp52                  ;   Call between Ltmp52 and Ltmp53
	.uleb128 Ltmp76-Lfunc_begin2            ;     jumps to Ltmp76
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp53-Lfunc_begin2            ; >> Call Site 34 <<
	.uleb128 Ltmp111-Ltmp53                 ;   Call between Ltmp53 and Ltmp111
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp111-Lfunc_begin2           ; >> Call Site 35 <<
	.uleb128 Ltmp114-Ltmp111                ;   Call between Ltmp111 and Ltmp114
	.uleb128 Ltmp115-Lfunc_begin2           ;     jumps to Ltmp115
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp114-Lfunc_begin2           ; >> Call Site 36 <<
	.uleb128 Ltmp116-Ltmp114                ;   Call between Ltmp114 and Ltmp116
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp116-Lfunc_begin2           ; >> Call Site 37 <<
	.uleb128 Ltmp117-Ltmp116                ;   Call between Ltmp116 and Ltmp117
	.uleb128 Ltmp118-Lfunc_begin2           ;     jumps to Ltmp118
	.byte	9                               ;   On action: 5
	.uleb128 Ltmp117-Lfunc_begin2           ; >> Call Site 38 <<
	.uleb128 Lfunc_end2-Ltmp117             ;   Call between Ltmp117 and Lfunc_end2
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end2:
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
Ltmp147:                                ; TypeInfo 2
	.long	__ZTISt16invalid_argument@GOT-Ltmp147
Ltmp148:                                ; TypeInfo 1
	.long	__ZTISt9exception@GOT-Ltmp148
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
Ltmp119:
	mov	x1, x20
	bl	__ZNSt12length_errorC1B9nqe210106EPKc
Ltmp120:
; %bb.1:
Lloh50:
	adrp	x1, __ZTISt12length_error@GOTPAGE
Lloh51:
	ldr	x1, [x1, __ZTISt12length_error@GOTPAGEOFF]
Lloh52:
	adrp	x2, __ZNSt12length_errorD1Ev@GOTPAGE
Lloh53:
	ldr	x2, [x2, __ZNSt12length_errorD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
LBB9_2:
Ltmp121:
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x0, x20
	bl	__Unwind_Resume
	.loh AdrpLdrGot	Lloh52, Lloh53
	.loh AdrpLdrGot	Lloh50, Lloh51
Lfunc_end3:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table9:
Lexception3:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end3-Lcst_begin3
Lcst_begin3:
	.uleb128 Lfunc_begin3-Lfunc_begin3      ; >> Call Site 1 <<
	.uleb128 Ltmp119-Lfunc_begin3           ;   Call between Lfunc_begin3 and Ltmp119
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp119-Lfunc_begin3           ; >> Call Site 2 <<
	.uleb128 Ltmp120-Ltmp119                ;   Call between Ltmp119 and Ltmp120
	.uleb128 Ltmp121-Lfunc_begin3           ;     jumps to Ltmp121
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp120-Lfunc_begin3           ; >> Call Site 3 <<
	.uleb128 Lfunc_end3-Ltmp120             ;   Call between Ltmp120 and Lfunc_end3
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
Lloh54:
	adrp	x8, __ZTVSt12length_error@GOTPAGE
Lloh55:
	ldr	x8, [x8, __ZTVSt12length_error@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x0]
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
	.loh AdrpLdrGot	Lloh54, Lloh55
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
Ltmp122:
	add	x0, sp, #8
	mov	x1, x19
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryC1ERS3_
Ltmp123:
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
Ltmp125:
	add	x8, sp, #24
	mov	x25, x4
	mov	x0, x4
	bl	__ZNKSt3__18ios_base6getlocEv
Ltmp126:
; %bb.4:
Ltmp127:
Lloh56:
	adrp	x1, __ZNSt3__15ctypeIcE2idE@GOTPAGE
Lloh57:
	ldr	x1, [x1, __ZNSt3__15ctypeIcE2idE@GOTPAGEOFF]
	add	x0, sp, #24
	bl	__ZNKSt3__16locale9use_facetERNS0_2idE
Ltmp128:
; %bb.5:
	ldr	x8, [x0]
	ldr	x8, [x8, #56]
Ltmp129:
	mov	w1, #32                         ; =0x20
	blr	x8
Ltmp130:
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
Ltmp132:
	sxtb	w5, w23
	mov	x0, x22
	mov	x1, x20
	bl	__ZNSt3__116__pad_and_outputB9nqe210106IcNS_11char_traitsIcEEEENS_19ostreambuf_iteratorIT_T0_EES6_PKS4_S8_S8_RNS_8ios_baseES4_
Ltmp133:
; %bb.8:
	cbnz	x0, LBB11_10
; %bb.9:
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
	add	x0, x19, x8
	ldr	w8, [x0, #32]
	mov	w9, #5                          ; =0x5
Ltmp135:
	orr	w1, w8, w9
	bl	__ZNSt3__18ios_base5clearEj
Ltmp136:
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
Ltmp137:
	b	LBB11_15
LBB11_13:
Ltmp131:
	mov	x20, x0
	add	x0, sp, #24
	bl	__ZNSt3__16localeD1Ev
	b	LBB11_16
LBB11_14:
Ltmp134:
LBB11_15:
	mov	x20, x0
LBB11_16:
	add	x0, sp, #8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryD1Ev
	b	LBB11_18
LBB11_17:
Ltmp124:
	mov	x20, x0
LBB11_18:
	mov	x0, x20
	bl	___cxa_begin_catch
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
Ltmp138:
	add	x0, x19, x8
	bl	__ZNSt3__18ios_base33__set_badbit_and_consider_rethrowEv
Ltmp139:
; %bb.19:
	bl	___cxa_end_catch
	b	LBB11_11
LBB11_20:
Ltmp140:
	mov	x19, x0
Ltmp141:
	bl	___cxa_end_catch
Ltmp142:
; %bb.21:
	mov	x0, x19
	bl	__Unwind_Resume
LBB11_22:
Ltmp143:
	bl	___clang_call_terminate
	.loh AdrpLdrGot	Lloh56, Lloh57
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
	.uleb128 Ltmp122-Lfunc_begin4           ; >> Call Site 1 <<
	.uleb128 Ltmp123-Ltmp122                ;   Call between Ltmp122 and Ltmp123
	.uleb128 Ltmp124-Lfunc_begin4           ;     jumps to Ltmp124
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp125-Lfunc_begin4           ; >> Call Site 2 <<
	.uleb128 Ltmp126-Ltmp125                ;   Call between Ltmp125 and Ltmp126
	.uleb128 Ltmp134-Lfunc_begin4           ;     jumps to Ltmp134
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp127-Lfunc_begin4           ; >> Call Site 3 <<
	.uleb128 Ltmp130-Ltmp127                ;   Call between Ltmp127 and Ltmp130
	.uleb128 Ltmp131-Lfunc_begin4           ;     jumps to Ltmp131
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp132-Lfunc_begin4           ; >> Call Site 4 <<
	.uleb128 Ltmp133-Ltmp132                ;   Call between Ltmp132 and Ltmp133
	.uleb128 Ltmp134-Lfunc_begin4           ;     jumps to Ltmp134
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp135-Lfunc_begin4           ; >> Call Site 5 <<
	.uleb128 Ltmp136-Ltmp135                ;   Call between Ltmp135 and Ltmp136
	.uleb128 Ltmp137-Lfunc_begin4           ;     jumps to Ltmp137
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp136-Lfunc_begin4           ; >> Call Site 6 <<
	.uleb128 Ltmp138-Ltmp136                ;   Call between Ltmp136 and Ltmp138
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp138-Lfunc_begin4           ; >> Call Site 7 <<
	.uleb128 Ltmp139-Ltmp138                ;   Call between Ltmp138 and Ltmp139
	.uleb128 Ltmp140-Lfunc_begin4           ;     jumps to Ltmp140
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp139-Lfunc_begin4           ; >> Call Site 8 <<
	.uleb128 Ltmp141-Ltmp139                ;   Call between Ltmp139 and Ltmp141
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp141-Lfunc_begin4           ; >> Call Site 9 <<
	.uleb128 Ltmp142-Ltmp141                ;   Call between Ltmp141 and Ltmp142
	.uleb128 Ltmp143-Lfunc_begin4           ;     jumps to Ltmp143
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp142-Lfunc_begin4           ; >> Call Site 10 <<
	.uleb128 Lfunc_end4-Ltmp142             ;   Call between Ltmp142 and Lfunc_end4
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
Ltmp144:
	mov	x0, x19
	mov	x2, x24
	blr	x8
Ltmp145:
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
Ltmp146:
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
	.uleb128 Ltmp144-Lfunc_begin5           ;   Call between Lfunc_begin5 and Ltmp144
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp144-Lfunc_begin5           ; >> Call Site 2 <<
	.uleb128 Ltmp145-Ltmp144                ;   Call between Ltmp144 and Ltmp145
	.uleb128 Ltmp146-Lfunc_begin5           ;     jumps to Ltmp146
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp145-Lfunc_begin5           ; >> Call Site 3 <<
	.uleb128 Lfunc_end5-Ltmp145             ;   Call between Ltmp145 and Lfunc_end5
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
Lloh58:
	adrp	x0, l_.str.15@PAGE
Lloh59:
	add	x0, x0, l_.str.15@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh58, Lloh59
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _Z2ckbPKc.cold.1
__Z2ckbPKc.cold.1:                      ; @_Z2ckbPKc.cold.1
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh60:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh61:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh62:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh63:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	bl	___cxa_throw
	.loh AdrpLdrGot	Lloh62, Lloh63
	.loh AdrpLdrGot	Lloh60, Lloh61
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _Z8validateRKNSt3__16vectorIfNS_9allocatorIfEEEES5_.cold.1
__Z8validateRKNSt3__16vectorIfNS_9allocatorIfEEEES5_.cold.1: ; @_Z8validateRKNSt3__16vectorIfNS_9allocatorIfEEEES5_.cold.1
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
	.p2align	2                               ; -- Begin function _Z8validateRKNSt3__16vectorIfNS_9allocatorIfEEEES5_.cold.2
__Z8validateRKNSt3__16vectorIfNS_9allocatorIfEEEES5_.cold.2: ; @_Z8validateRKNSt3__16vectorIfNS_9allocatorIfEEEES5_.cold.2
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
	.asciz	"shape"

l_.str.1:                               ; @.str.1
	.asciz	"range/nonfinite"

l_.str.2:                               ; @.str.2
	.asciz	"numeric contract"

l_.str.3:                               ; @.str.3
	.asciz	"fusion counterexample"

l_.str.4:                               ; @.str.4
	.asciz	"cancel sequential="

l_.str.5:                               ; @.str.5
	.asciz	" neon_tree="

l_.str.6:                               ; @.str.6
	.asciz	" double_oracle=2\n"

l_.str.7:                               ; @.str.7
	.asciz	"rejection"

l_.str.8:                               ; @.str.8
	.asciz	"PASS cases="

l_.str.9:                               ; @.str.9
	.asciz	" worst_abs_error="

l_.str.10:                              ; @.str.10
	.asciz	" separate="

l_.str.11:                              ; @.str.11
	.asciz	" fma="

l_.str.12:                              ; @.str.12
	.asciz	" invalid="

l_.str.13:                              ; @.str.13
	.asciz	"\n"

l_.str.15:                              ; @.str.15
	.asciz	"basic_string"

	.section	__TEXT,__literal16,16byte_literals
	.p2align	4, 0x0                          ; @.memset_pattern
l_.memset_pattern:
	.long	0x3f800000                      ; float 1
	.long	0x3f800000                      ; float 1
	.long	0x3f800000                      ; float 1
	.long	0x3f800000                      ; float 1

.subsections_via_symbols
