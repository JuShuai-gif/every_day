	.build_version macos, 26, 0	sdk_version 26, 5
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__Z7requirebPKc                 ; -- Begin function _Z7requirebPKc
	.p2align	2
__Z7requirebPKc:                        ; @_Z7requirebPKc
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
	bl	__Z7requirebPKc.cold.1
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
	.globl	__Z6oracleff                    ; -- Begin function _Z6oracleff
	.p2align	2
__Z6oracleff:                           ; @_Z6oracleff
	.cfi_startproc
; %bb.0:
	fmul	s0, s0, s1
	fcmp	s0, s0
	b.vs	LBB1_6
; %bb.1:
	mov	w8, #1123942400                 ; =0x42fe0000
	fmov	s1, w8
	fcmp	s0, s1
	b.ge	LBB1_4
; %bb.2:
	mov	w8, #-1023541248                ; =0xc2fe0000
	fmov	s1, w8
	fcmp	s0, s1
	b.ls	LBB1_5
; %bb.3:
	fcvt	d1, s0
	fmov	d2, #0.50000000
	fadd	d2, d1, d2
	frintm	d2, d2
	fmov	d3, #-0.50000000
	fadd	d1, d1, d3
	frintp	d1, d1
	fcmp	s0, #0.0
	fcsel	d0, d1, d2, lt
	fcvtzs	w0, d0
	ret
LBB1_4:
	mov	w0, #127                        ; =0x7f
	ret
LBB1_5:
	mov	w0, #-127                       ; =0xffffff81
	ret
LBB1_6:
	mov	w0, #0                          ; =0x0
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__Z7measurePFvPKfPamfERKNSt3__16vectorIfNS4_9allocatorIfEEEERNS5_IaNS6_IaEEEEm ; -- Begin function _Z7measurePFvPKfPamfERKNSt3__16vectorIfNS4_9allocatorIfEEEERNS5_IaNS6_IaEEEEm
	.p2align	2
__Z7measurePFvPKfPamfERKNSt3__16vectorIfNS4_9allocatorIfEEEERNS5_IaNS6_IaEEEEm: ; @_Z7measurePFvPKfPamfERKNSt3__16vectorIfNS4_9allocatorIfEEEERNS5_IaNS6_IaEEEEm
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
	mov	x19, x3
	mov	x20, x2
	mov	x22, x1
	mov	x23, x0
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x21, x0
	cbz	x19, LBB2_3
; %bb.1:
	mov	x24, x19
LBB2_2:                                 ; =>This Inner Loop Header: Depth=1
	ldr	x1, [x20]
	ldp	x0, x8, [x22]
	sub	x8, x8, x0
	asr	x2, x8, #2
	fmov	s0, #1.25000000
	blr	x23
	ldr	x8, [x20]
	; InlineAsm Start
	; InlineAsm End
	subs	x24, x24, #1
	b.ne	LBB2_2
LBB2_3:
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	sub	x8, x0, x21
	scvtf	d0, x8
	mov	x8, #70368744177664             ; =0x400000000000
	movk	x8, #16527, lsl #48
	fmov	d1, x8
	fdiv	d0, d0, d1
	ucvtf	d1, x19
	fdiv	d0, d0, d1
	ldp	x29, x30, [sp, #48]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #32]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #16]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp], #64             ; 16-byte Folded Reload
	ret
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__literal8,8byte_literals
	.p2align	3, 0x0                          ; -- Begin function main
lCPI3_0:
	.long	0                               ; 0x0
	.long	1                               ; 0x1
lCPI3_1:
	.long	0x3f000000                      ; float 0.5
	.long	0x3f800000                      ; float 1
	.section	__TEXT,__literal16,16byte_literals
	.p2align	4, 0x0
lCPI3_2:
	.long	0xbf000000                      ; float -0.5
	.long	0x3f000000                      ; float 0.5
	.long	0xc2fd0000                      ; float -126.5
	.long	0x42fd0000                      ; float 126.5
lCPI3_3:
	.long	0x7f7fffff                      ; float 3.40282347E+38
	.long	0xff7fffff                      ; float -3.40282347E+38
	.long	0x7f800000                      ; float +Inf
	.long	0xff800000                      ; float -Inf
lCPI3_4:
	.long	7                               ; 0x7
	.long	65                              ; 0x41
	.long	4096                            ; 0x1000
	.long	1048576                         ; 0x100000
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_main
	.p2align	2
_main:                                  ; @main
Lfunc_begin1:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception1
; %bb.0:
	stp	d13, d12, [sp, #-144]!          ; 16-byte Folded Spill
	stp	d11, d10, [sp, #16]             ; 16-byte Folded Spill
	stp	d9, d8, [sp, #32]               ; 16-byte Folded Spill
	stp	x28, x27, [sp, #48]             ; 16-byte Folded Spill
	stp	x26, x25, [sp, #64]             ; 16-byte Folded Spill
	stp	x24, x23, [sp, #80]             ; 16-byte Folded Spill
	stp	x22, x21, [sp, #96]             ; 16-byte Folded Spill
	stp	x20, x19, [sp, #112]            ; 16-byte Folded Spill
	stp	x29, x30, [sp, #128]            ; 16-byte Folded Spill
	add	x29, sp, #128
	sub	sp, sp, #2768
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
Lloh0:
	adrp	x8, ___stack_chk_guard@GOTPAGE
Lloh1:
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
Lloh2:
	ldr	x8, [x8]
	stur	x8, [x29, #-152]
	mov	w8, #10397                      ; =0x289d
	movk	w8, #309, lsl #16
	str	w8, [sp, #152]
	mov	w9, #1                          ; =0x1
	mov	w10, #35173                     ; =0x8965
	movk	w10, #27655, lsl #16
	add	x11, sp, #152
LBB3_1:                                 ; =>This Inner Loop Header: Depth=1
	eor	w8, w8, w8, lsr #30
	madd	w8, w8, w10, w9
	str	w8, [x11, x9, lsl #2]
	add	x9, x9, #1
	cmp	x9, #624
	b.ne	LBB3_1
; %bb.2:
	mov	x24, #0                         ; =0x0
	mov	x9, #0                          ; =0x0
	mov	w20, #-272236544                ; =0xefc60000
	mov	w21, #22144                     ; =0x5680
	movk	w21, #40236, lsl #16
	mov	w22, #45279                     ; =0xb0df
	movk	w22, #39176, lsl #16
	str	xzr, [sp, #2648]
Lloh3:
	adrp	x8, lCPI3_0@PAGE
Lloh4:
	ldr	d9, [x8, lCPI3_0@PAGEOFF]
	mov	w10, #3                         ; =0x3
Lloh5:
	adrp	x8, lCPI3_1@PAGE
Lloh6:
	ldr	d10, [x8, lCPI3_1@PAGEOFF]
Lloh7:
	adrp	x8, lCPI3_2@PAGE
Lloh8:
	ldr	q0, [x8, lCPI3_2@PAGEOFF]
	str	q0, [sp, #64]                   ; 16-byte Folded Spill
	movi	d0, #0000000000000000
	fneg	d11, d0
Lloh9:
	adrp	x8, lCPI3_3@PAGE
Lloh10:
	ldr	q0, [x8, lCPI3_3@PAGEOFF]
	str	q0, [sp, #48]                   ; 16-byte Folded Spill
	mov	w27, #1123942400                ; =0x42fe0000
	fmov	d12, #0.50000000
	fmov	d13, #-0.50000000
	mov	x23, #3361                      ; =0xd21
	movk	x23, #8402, lsl #16
	movk	x23, #53773, lsl #32
	movk	x23, #3360, lsl #48
	mov	w26, #624                       ; =0x270
Lloh11:
	adrp	x8, l_constinit@PAGE
Lloh12:
	add	x8, x8, l_constinit@PAGEOFF
LBB3_3:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB3_5 Depth 2
                                        ;       Child Loop BB3_7 Depth 3
                                        ;         Child Loop BB3_12 Depth 4
                                        ;         Child Loop BB3_16 Depth 4
                                        ;           Child Loop BB3_19 Depth 5
                                        ;           Child Loop BB3_34 Depth 5
	str	x9, [sp, #8]                    ; 8-byte Folded Spill
	ldrsw	x8, [x8, x9]
	mov	x9, #0                          ; =0x0
	stur	d9, [x29, #-168]
	stur	w10, [x29, #-160]
	add	x10, x8, #2
	str	x10, [sp, #128]                 ; 8-byte Folded Spill
	str	x8, [sp, #144]                  ; 8-byte Folded Spill
	lsl	x8, x8, #2
	str	x8, [sp, #16]                   ; 8-byte Folded Spill
	b	LBB3_5
LBB3_4:                                 ;   in Loop: Header=BB3_5 Depth=2
	ldr	x9, [sp, #24]                   ; 8-byte Folded Reload
	add	x9, x9, #4
	cmp	x9, #12
	b.eq	LBB3_45
LBB3_5:                                 ;   Parent Loop BB3_3 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB3_7 Depth 3
                                        ;         Child Loop BB3_12 Depth 4
                                        ;         Child Loop BB3_16 Depth 4
                                        ;           Child Loop BB3_19 Depth 5
                                        ;           Child Loop BB3_34 Depth 5
	mov	x10, #0                         ; =0x0
	sub	x8, x29, #168
	str	x9, [sp, #24]                   ; 8-byte Folded Spill
	ldrsw	x9, [x8, x9]
	stur	d10, [x29, #-184]
	mov	w8, #1067450368                 ; =0x3fa00000
	stur	w8, [x29, #-176]
	ldr	x8, [sp, #144]                  ; 8-byte Folded Reload
	add	x8, x9, x8
	stp	x9, x8, [sp, #80]               ; 16-byte Folded Spill
	lsl	x11, x8, #2
	lsl	x9, x9, #2
	ldr	x8, [sp, #16]                   ; 8-byte Folded Reload
	str	x9, [sp, #120]                  ; 8-byte Folded Spill
	add	x8, x8, x9
	stp	x8, x11, [sp, #32]              ; 16-byte Folded Spill
	b	LBB3_7
LBB3_6:                                 ;   in Loop: Header=BB3_7 Depth=3
	ldp	x24, x10, [sp, #96]             ; 16-byte Folded Reload
	add	x10, x10, #4
	cmp	x10, #12
	mov	w20, #-272236544                ; =0xefc60000
	mov	w21, #22144                     ; =0x5680
	movk	w21, #40236, lsl #16
	mov	w22, #45279                     ; =0xb0df
	movk	w22, #39176, lsl #16
	mov	x23, #3361                      ; =0xd21
	movk	x23, #8402, lsl #16
	movk	x23, #53773, lsl #32
	movk	x23, #3360, lsl #48
	mov	w26, #624                       ; =0x270
	b.eq	LBB3_4
LBB3_7:                                 ;   Parent Loop BB3_3 Depth=1
                                        ;     Parent Loop BB3_5 Depth=2
                                        ; =>    This Loop Header: Depth=3
                                        ;         Child Loop BB3_12 Depth 4
                                        ;         Child Loop BB3_16 Depth 4
                                        ;           Child Loop BB3_19 Depth 5
                                        ;           Child Loop BB3_34 Depth 5
	sub	x8, x29, #184
	str	x10, [sp, #104]                 ; 8-byte Folded Spill
	ldr	s8, [x8, x10]
	fmov	w8, s8
	sub	w9, w8, #1
	and	w10, w8, #0x7fffffff
	sub	w10, w10, #2048, lsl #12        ; =8388608
	lsr	w10, w10, #24
	cmn	w8, #1
	mov	w8, #127                        ; =0x7f
	ccmp	w10, w8, #2, gt
	mov	w8, #8388607                    ; =0x7fffff
	ccmp	w9, w8, #0, hs
	b.hs	LBB3_54
; %bb.8:                                ;   in Loop: Header=BB3_7 Depth=3
	ldr	x8, [sp, #88]                   ; 8-byte Folded Reload
	cbz	x8, LBB3_13
; %bb.9:                                ;   in Loop: Header=BB3_7 Depth=3
	lsr	x8, x8, #62
	ldr	x28, [sp, #40]                  ; 8-byte Folded Reload
	cbnz	x8, LBB3_56
; %bb.10:                               ;   in Loop: Header=BB3_7 Depth=3
Ltmp9:
	mov	x0, x28
	bl	__Znwm
Ltmp10:
; %bb.11:                               ;   in Loop: Header=BB3_7 Depth=3
	mov	x19, x0
	mov	x1, x28
	bl	_bzero
	mov	x8, #0                          ; =0x0
	add	x14, sp, #152
	mov	w15, #-1018691584               ; =0xc3480000
	mov	w16, #1137180672                ; =0x43c80000
	ldr	x17, [sp, #32]                  ; 8-byte Folded Reload
LBB3_12:                                ;   Parent Loop BB3_3 Depth=1
                                        ;     Parent Loop BB3_5 Depth=2
                                        ;       Parent Loop BB3_7 Depth=3
                                        ; =>      This Inner Loop Header: Depth=4
	mov	x9, x24
	add	x10, x24, #1
	lsr	x11, x10, #4
	umulh	x11, x11, x23
	lsr	x11, x11, #1
	msub	x24, x11, x26, x10
	ldr	w10, [x14, x9, lsl #2]
	and	w10, w10, #0x80000000
	ldr	w11, [x14, x24, lsl #2]
	and	w12, w11, #0x7ffffffe
	orr	w10, w12, w10
	add	x12, x9, #397
	lsr	x13, x12, #4
	umulh	x13, x13, x23
	lsr	x13, x13, #1
	msub	x12, x13, x26, x12
	ldr	w12, [x14, x12, lsl #2]
	tst	w11, #0x1
	csel	w11, w22, wzr, ne
	eor	w11, w11, w12
	eor	w10, w11, w10, lsr #1
	str	w10, [x14, x9, lsl #2]
	eor	w9, w10, w10, lsr #11
	and	w10, w21, w9, lsl #7
	eor	w9, w10, w9
	and	w10, w20, w9, lsl #15
	eor	w9, w10, w9
	eor	w9, w9, w9, lsr #18
	ucvtf	s0, w9, #32
	fmov	s1, w15
	fmov	s2, w16
	fmadd	s0, s0, s2, s1
	str	s0, [x19, x8]
	add	x8, x8, #4
	cmp	x17, x8
	b.ne	LBB3_12
	b	LBB3_14
LBB3_13:                                ;   in Loop: Header=BB3_7 Depth=3
	mov	x19, #0                         ; =0x0
LBB3_14:                                ;   in Loop: Header=BB3_7 Depth=3
	str	x24, [sp, #96]                  ; 8-byte Folded Spill
	str	x24, [sp, #2648]
	sub	x20, x29, #240
	ldr	q0, [sp, #64]                   ; 16-byte Folded Reload
	str	q0, [x20]
	stur	d11, [x29, #-224]
	fmov	s0, #0.50000000
	movi.2d	v1, #0000000000000000
	bl	_nextafterf
	stur	s0, [x29, #-216]
	fmov	s0, #0.50000000
	fmov	s1, #1.00000000
	bl	_nextafterf
	mov	x22, #0                         ; =0x0
	stur	s0, [x29, #-212]
	ldr	q0, [sp, #48]                   ; 16-byte Folded Reload
	str	q0, [x20, #32]
	mov	w8, #2143289344                 ; =0x7fc00000
	stur	w8, [x29, #-192]
	ldr	x8, [sp, #80]                   ; 8-byte Folded Reload
	add	x8, x19, x8, lsl #2
	ldr	x20, [sp, #144]                 ; 8-byte Folded Reload
	cmp	w20, #0
	str	x8, [sp, #112]                  ; 8-byte Folded Spill
	csel	x28, xzr, x8, eq
	sub	x24, x29, #240
	ldr	x21, [sp, #128]                 ; 8-byte Folded Reload
	b	LBB3_16
LBB3_15:                                ;   in Loop: Header=BB3_16 Depth=4
	mov	x0, x24
	bl	__ZdlPv
	mov	x0, x23
	bl	__ZdlPv
	add	x22, x22, #1
	ldr	x24, [sp, #136]                 ; 8-byte Folded Reload
	add	x24, x24, #4
	cmp	x22, #13
	b.eq	LBB3_43
LBB3_16:                                ;   Parent Loop BB3_3 Depth=1
                                        ;     Parent Loop BB3_5 Depth=2
                                        ;       Parent Loop BB3_7 Depth=3
                                        ; =>      This Loop Header: Depth=4
                                        ;           Child Loop BB3_19 Depth 5
                                        ;           Child Loop BB3_34 Depth 5
	mov	x14, #20165                     ; =0x4ec5
	movk	x14, #50412, lsl #16
	movk	x14, #60494, lsl #32
	movk	x14, #20164, lsl #48
	mov	x15, #-52                       ; =0xffffffffffffffcc
	mov	x16, #-1085102592571150096      ; =0xf0f0f0f0f0f0f0f0
	movk	x16, #61681
	cbz	w20, LBB3_21
; %bb.17:                               ;   in Loop: Header=BB3_16 Depth=4
	mov	x8, #0                          ; =0x0
	ldr	x9, [sp, #112]                  ; 8-byte Folded Reload
	mov	x10, x22
	mov	x11, x24
	mov	x12, x20
	b	LBB3_19
LBB3_18:                                ;   in Loop: Header=BB3_19 Depth=5
	add	x8, x8, #1
	add	x11, x11, #4
	add	x10, x10, #1
	add	x9, x9, #4
	subs	x12, x12, #1
	b.eq	LBB3_21
LBB3_19:                                ;   Parent Loop BB3_3 Depth=1
                                        ;     Parent Loop BB3_5 Depth=2
                                        ;       Parent Loop BB3_7 Depth=3
                                        ;         Parent Loop BB3_16 Depth=4
                                        ; =>        This Inner Loop Header: Depth=5
	umulh	x13, x8, x16
	lsr	x13, x13, #4
	add	x13, x13, x13, lsl #4
	sub	x13, x8, x13
	cmp	x13, #12
	b.hi	LBB3_18
; %bb.20:                               ;   in Loop: Header=BB3_19 Depth=5
	umulh	x13, x10, x14
	lsr	x13, x13, #2
	mul	x13, x13, x15
	ldr	s0, [x11, x13]
	str	s0, [x9]
	b	LBB3_18
LBB3_21:                                ;   in Loop: Header=BB3_16 Depth=4
	str	x24, [sp, #136]                 ; 8-byte Folded Spill
	cbz	x21, LBB3_26
; %bb.22:                               ;   in Loop: Header=BB3_16 Depth=4
	cmn	w20, #3
	b.le	LBB3_53
; %bb.23:                               ;   in Loop: Header=BB3_16 Depth=4
Ltmp15:
	mov	x0, x21
	bl	__Znwm
Ltmp16:
; %bb.24:                               ;   in Loop: Header=BB3_16 Depth=4
	mov	x23, x0
	mov	w1, #42                         ; =0x2a
	mov	x2, x21
	bl	_memset
Ltmp18:
	mov	x0, x21
	bl	__Znwm
Ltmp19:
; %bb.25:                               ;   in Loop: Header=BB3_16 Depth=4
	mov	x24, x0
	add	x20, x23, x21
	mov	x2, x21
	add	x21, x0, x21
	mov	w1, #42                         ; =0x2a
	bl	_memset
	b	LBB3_27
LBB3_26:                                ;   in Loop: Header=BB3_16 Depth=4
	mov	x23, #0                         ; =0x0
	mov	x20, #0                         ; =0x0
	mov	x24, #0                         ; =0x0
LBB3_27:                                ;   in Loop: Header=BB3_16 Depth=4
Ltmp24:
	add	x1, x23, #1
	mov	x0, x28
	ldr	x25, [sp, #144]                 ; 8-byte Folded Reload
	mov	x2, x25
	mov.16b	v0, v8
	bl	__ZN8practice6scalarEPKfPamf
Ltmp25:
; %bb.28:                               ;   in Loop: Header=BB3_16 Depth=4
Ltmp27:
	add	x1, x24, #1
	mov	x26, x28
	mov	x0, x28
	mov	x2, x25
	mov.16b	v0, v8
	bl	__ZN8practice4neonEPKfPamf
Ltmp28:
; %bb.29:                               ;   in Loop: Header=BB3_16 Depth=4
	ldrb	w8, [x23]
	cmp	w8, #42
	b.ne	LBB3_51
; %bb.30:                               ;   in Loop: Header=BB3_16 Depth=4
	ldurb	w8, [x20, #-1]
	cmp	w8, #42
	b.ne	LBB3_51
; %bb.31:                               ;   in Loop: Header=BB3_16 Depth=4
	ldrb	w8, [x24]
	cmp	w8, #42
	b.ne	LBB3_51
; %bb.32:                               ;   in Loop: Header=BB3_16 Depth=4
	ldurb	w8, [x21, #-1]
	cmp	w8, #42
	b.ne	LBB3_51
; %bb.33:                               ;   in Loop: Header=BB3_16 Depth=4
	mov	w8, #1                          ; =0x1
	ldp	x9, x21, [sp, #120]             ; 16-byte Folded Reload
	ldr	x20, [sp, #144]                 ; 8-byte Folded Reload
	mov	x10, x20
	mov	w13, #-1023541248               ; =0xc2fe0000
	mov	x28, x26
LBB3_34:                                ;   Parent Loop BB3_3 Depth=1
                                        ;     Parent Loop BB3_5 Depth=2
                                        ;       Parent Loop BB3_7 Depth=3
                                        ;         Parent Loop BB3_16 Depth=4
                                        ; =>        This Inner Loop Header: Depth=5
	cbz	x10, LBB3_15
; %bb.35:                               ;   in Loop: Header=BB3_34 Depth=5
	ldr	s0, [x19, x9]
	fmul	s0, s8, s0
	fcmp	s0, s0
	b.vs	LBB3_42
; %bb.36:                               ;   in Loop: Header=BB3_34 Depth=5
	fmov	s1, w27
	fcmp	s0, s1
	b.ge	LBB3_39
; %bb.37:                               ;   in Loop: Header=BB3_34 Depth=5
	fmov	s1, w13
	fcmp	s0, s1
	b.ls	LBB3_40
; %bb.38:                               ;   in Loop: Header=BB3_34 Depth=5
	fcvt	d1, s0
	fadd	d2, d1, d12
	frintm	d2, d2
	fadd	d1, d1, d13
	frintp	d1, d1
	fcmp	s0, #0.0
	fcsel	d0, d1, d2, lt
	fcvtzs	w11, d0
	ldrsb	w12, [x23, x8]
	cmp	w11, w12
	b.eq	LBB3_41
	b	LBB3_49
LBB3_39:                                ;   in Loop: Header=BB3_34 Depth=5
	mov	w11, #127                       ; =0x7f
	ldrsb	w12, [x23, x8]
	cmp	w11, w12
	b.eq	LBB3_41
	b	LBB3_49
LBB3_40:                                ;   in Loop: Header=BB3_34 Depth=5
	mov	w11, #-127                      ; =0xffffff81
	ldrsb	w12, [x23, x8]
	cmp	w11, w12
	b.ne	LBB3_49
LBB3_41:                                ;   in Loop: Header=BB3_34 Depth=5
	ldrb	w11, [x24, x8]
	sub	x10, x10, #1
	add	x9, x9, #4
	add	x8, x8, #1
	cmp	w11, w12, uxtb
	b.eq	LBB3_34
	b	LBB3_48
LBB3_42:                                ;   in Loop: Header=BB3_34 Depth=5
	mov	w11, #0                         ; =0x0
	ldrsb	w12, [x23, x8]
	cmp	w11, w12
	b.eq	LBB3_41
	b	LBB3_49
LBB3_43:                                ;   in Loop: Header=BB3_7 Depth=3
	cbz	x19, LBB3_6
; %bb.44:                               ;   in Loop: Header=BB3_7 Depth=3
	mov	x0, x19
	bl	__ZdlPv
	b	LBB3_6
LBB3_45:                                ;   in Loop: Header=BB3_3 Depth=1
	ldr	x9, [sp, #8]                    ; 8-byte Folded Reload
	add	x9, x9, #4
	cmp	x9, #48
	mov	w10, #3                         ; =0x3
Lloh13:
	adrp	x8, l_constinit@PAGE
Lloh14:
	add	x8, x8, l_constinit@PAGEOFF
	b.ne	LBB3_3
; %bb.46:
	mov	w27, #45279                     ; =0xb0df
	movk	w27, #39176, lsl #16
	mov	w26, #22144                     ; =0x5680
	movk	w26, #40236, lsl #16
	mov	w28, #-272236544                ; =0xefc60000
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp45:
Lloh15:
	adrp	x1, l_.str.15@PAGE
Lloh16:
	add	x1, x1, l_.str.15@PAGEOFF
	bl	__ZNSt11logic_errorC2EPKc
Ltmp46:
; %bb.47:
Lloh17:
	adrp	x8, __ZTVSt16invalid_argument@GOTPAGE
Lloh18:
	ldr	x8, [x8, __ZTVSt16invalid_argument@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x19]
Ltmp48:
Lloh19:
	adrp	x1, __ZTISt16invalid_argument@GOTPAGE
Lloh20:
	ldr	x1, [x1, __ZTISt16invalid_argument@GOTPAGEOFF]
Lloh21:
	adrp	x2, __ZNSt16invalid_argumentD1Ev@GOTPAGE
Lloh22:
	ldr	x2, [x2, __ZNSt16invalid_argumentD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
Ltmp49:
	b	LBB3_185
LBB3_48:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x20, x0
Ltmp39:
Lloh23:
	adrp	x1, l_.str.2@PAGE
Lloh24:
	add	x1, x1, l_.str.2@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp40:
	b	LBB3_50
LBB3_49:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x20, x0
Ltmp36:
Lloh25:
	adrp	x1, l_.str.1@PAGE
Lloh26:
	add	x1, x1, l_.str.1@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp37:
LBB3_50:
Ltmp42:
Lloh27:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh28:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh29:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh30:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x20
	bl	___cxa_throw
Ltmp43:
	b	LBB3_185
LBB3_51:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x20, x0
Ltmp30:
Lloh31:
	adrp	x1, l_.str@PAGE
Lloh32:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp31:
; %bb.52:
Ltmp33:
Lloh33:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh34:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh35:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh36:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x20
	bl	___cxa_throw
Ltmp34:
	b	LBB3_185
LBB3_53:
Ltmp21:
	bl	__ZNSt3__16vectorIaNS_9allocatorIaEEE20__throw_length_errorB9nqe210106Ev
Ltmp22:
	b	LBB3_185
LBB3_54:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp3:
Lloh37:
	adrp	x1, l_.str.15@PAGE
Lloh38:
	add	x1, x1, l_.str.15@PAGEOFF
	bl	__ZNSt11logic_errorC2EPKc
Ltmp4:
; %bb.55:
Lloh39:
	adrp	x8, __ZTVSt16invalid_argument@GOTPAGE
Lloh40:
	ldr	x8, [x8, __ZTVSt16invalid_argument@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x19]
Ltmp6:
Lloh41:
	adrp	x1, __ZTISt16invalid_argument@GOTPAGE
Lloh42:
	ldr	x1, [x1, __ZTISt16invalid_argument@GOTPAGEOFF]
Lloh43:
	adrp	x2, __ZNSt16invalid_argumentD1Ev@GOTPAGE
Lloh44:
	ldr	x2, [x2, __ZNSt16invalid_argumentD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
Ltmp7:
	b	LBB3_185
LBB3_56:
Ltmp12:
	bl	__ZNSt3__16vectorIfNS_9allocatorIfEEE20__throw_length_errorB9nqe210106Ev
Ltmp13:
	b	LBB3_185
LBB3_57:
Ltmp50:
	mov	x21, x0
	mov	x25, x1
	b	LBB3_59
LBB3_58:
Ltmp47:
	mov	x25, x1
	mov	x21, x0
	mov	x0, x19
	bl	___cxa_free_exception
                                        ; kill: def $w25 killed $w25 killed $x25 def $x25
LBB3_59:
	cmp	w25, #2
	b.ne	LBB3_238
; %bb.60:
	mov	x0, x21
	bl	___cxa_begin_catch
Ltmp51:
	bl	___cxa_end_catch
Ltmp52:
; %bb.61:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp53:
Lloh45:
	adrp	x1, l_.str.15@PAGE
Lloh46:
	add	x1, x1, l_.str.15@PAGEOFF
	bl	__ZNSt11logic_errorC2EPKc
Ltmp54:
; %bb.62:
Lloh47:
	adrp	x8, __ZTVSt16invalid_argument@GOTPAGE
Lloh48:
	ldr	x8, [x8, __ZTVSt16invalid_argument@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x19]
Ltmp56:
Lloh49:
	adrp	x1, __ZTISt16invalid_argument@GOTPAGE
Lloh50:
	ldr	x1, [x1, __ZTISt16invalid_argument@GOTPAGEOFF]
Lloh51:
	adrp	x2, __ZNSt16invalid_argumentD1Ev@GOTPAGE
Lloh52:
	ldr	x2, [x2, __ZNSt16invalid_argumentD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
Ltmp57:
	b	LBB3_185
LBB3_63:
Ltmp58:
	mov	x21, x0
	mov	x25, x1
	b	LBB3_65
LBB3_64:
Ltmp55:
	mov	x25, x1
	mov	x21, x0
	mov	x0, x19
	bl	___cxa_free_exception
                                        ; kill: def $w25 killed $w25 killed $x25 def $x25
LBB3_65:
	mov	w20, #2                         ; =0x2
	cmp	w25, w20
	b.ne	LBB3_238
; %bb.66:
	mov	x0, x21
	bl	___cxa_begin_catch
Ltmp59:
	bl	___cxa_end_catch
Ltmp60:
; %bb.67:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp61:
Lloh53:
	adrp	x1, l_.str.15@PAGE
Lloh54:
	add	x1, x1, l_.str.15@PAGEOFF
	bl	__ZNSt11logic_errorC2EPKc
Ltmp62:
; %bb.68:
Lloh55:
	adrp	x8, __ZTVSt16invalid_argument@GOTPAGE
Lloh56:
	ldr	x8, [x8, __ZTVSt16invalid_argument@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x19]
Ltmp64:
Lloh57:
	adrp	x1, __ZTISt16invalid_argument@GOTPAGE
Lloh58:
	ldr	x1, [x1, __ZTISt16invalid_argument@GOTPAGEOFF]
Lloh59:
	adrp	x2, __ZNSt16invalid_argumentD1Ev@GOTPAGE
Lloh60:
	ldr	x2, [x2, __ZNSt16invalid_argumentD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
Ltmp65:
	b	LBB3_185
LBB3_69:
Ltmp66:
	mov	x21, x0
	mov	x25, x1
	b	LBB3_71
LBB3_70:
Ltmp63:
	mov	x25, x1
	mov	x21, x0
	mov	x0, x19
	bl	___cxa_free_exception
                                        ; kill: def $w25 killed $w25 killed $x25 def $x25
LBB3_71:
	cmp	w25, w20
	b.ne	LBB3_238
; %bb.72:
	mov	x0, x21
	bl	___cxa_begin_catch
Ltmp67:
	bl	___cxa_end_catch
Ltmp68:
; %bb.73:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp69:
Lloh61:
	adrp	x1, l_.str.15@PAGE
Lloh62:
	add	x1, x1, l_.str.15@PAGEOFF
	bl	__ZNSt11logic_errorC2EPKc
Ltmp70:
; %bb.74:
Lloh63:
	adrp	x8, __ZTVSt16invalid_argument@GOTPAGE
Lloh64:
	ldr	x8, [x8, __ZTVSt16invalid_argument@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x19]
Ltmp72:
Lloh65:
	adrp	x1, __ZTISt16invalid_argument@GOTPAGE
Lloh66:
	ldr	x1, [x1, __ZTISt16invalid_argument@GOTPAGEOFF]
Lloh67:
	adrp	x2, __ZNSt16invalid_argumentD1Ev@GOTPAGE
Lloh68:
	ldr	x2, [x2, __ZNSt16invalid_argumentD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
Ltmp73:
	b	LBB3_185
LBB3_75:
Ltmp74:
	mov	x21, x0
	mov	x25, x1
	b	LBB3_77
LBB3_76:
Ltmp71:
	mov	x25, x1
	mov	x21, x0
	mov	x0, x19
	bl	___cxa_free_exception
                                        ; kill: def $w25 killed $w25 killed $x25 def $x25
LBB3_77:
	cmp	w25, w20
	b.ne	LBB3_238
; %bb.78:
	mov	x0, x21
	bl	___cxa_begin_catch
Ltmp75:
	bl	___cxa_end_catch
Ltmp76:
; %bb.79:
Ltmp78:
Lloh69:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh70:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh71:
	adrp	x1, l_.str.5@PAGE
Lloh72:
	add	x1, x1, l_.str.5@PAGEOFF
	mov	w2, #11                         ; =0xb
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp79:
; %bb.80:
Ltmp80:
	mov	w1, #1404                       ; =0x57c
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp81:
; %bb.81:
Ltmp82:
Lloh73:
	adrp	x1, l_.str.6@PAGE
Lloh74:
	add	x1, x1, l_.str.6@PAGEOFF
	mov	w2, #16                         ; =0x10
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp83:
; %bb.82:
Ltmp84:
	mov	w1, #4                          ; =0x4
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEi
Ltmp85:
; %bb.83:
Ltmp86:
Lloh75:
	adrp	x1, l_.str.7@PAGE
Lloh76:
	add	x1, x1, l_.str.7@PAGEOFF
	mov	w2, #35                         ; =0x23
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp87:
; %bb.84:
	str	xzr, [sp, #88]                  ; 8-byte Folded Spill
Lloh77:
	adrp	x8, lCPI3_4@PAGE
Lloh78:
	ldr	q0, [x8, lCPI3_4@PAGEOFF]
	sub	x8, x29, #240
	str	q0, [x8]
LBB3_85:                                ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB3_89 Depth 2
                                        ;     Child Loop BB3_110 Depth 2
                                        ;       Child Loop BB3_116 Depth 3
                                        ;       Child Loop BB3_138 Depth 3
                                        ;       Child Loop BB3_112 Depth 3
                                        ;       Child Loop BB3_127 Depth 3
	ldr	x8, [sp, #88]                   ; 8-byte Folded Reload
	sub	x9, x29, #240
	ldrsw	x19, [x9, x8]
	cbz	w19, LBB3_92
; %bb.86:                               ;   in Loop: Header=BB3_85 Depth=1
	tbnz	w19, #31, LBB3_176
; %bb.87:                               ;   in Loop: Header=BB3_85 Depth=1
	lsl	x20, x19, #2
Ltmp89:
	mov	x0, x20
	bl	__Znwm
	str	x0, [sp, #144]                  ; 8-byte Folded Spill
Ltmp90:
; %bb.88:                               ;   in Loop: Header=BB3_85 Depth=1
	ldr	x0, [sp, #144]                  ; 8-byte Folded Reload
	add	x22, x0, x20
	mov	x1, x20
	bl	_bzero
	mov	x8, #0                          ; =0x0
	ldr	x9, [sp, #2648]
LBB3_89:                                ;   Parent Loop BB3_85 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	mov	x10, x9
	add	x9, x9, #1
	lsr	x11, x9, #4
	mov	x15, #3361                      ; =0xd21
	movk	x15, #8402, lsl #16
	movk	x15, #53773, lsl #32
	movk	x15, #3360, lsl #48
	umulh	x11, x11, x15
	lsr	x11, x11, #1
	mov	w16, #624                       ; =0x270
	msub	x9, x11, x16, x9
	add	x17, sp, #152
	ldr	w11, [x17, x10, lsl #2]
	and	w11, w11, #0x80000000
	ldr	w12, [x17, x9, lsl #2]
	and	w13, w12, #0x7ffffffe
	orr	w11, w13, w11
	add	x13, x10, #397
	lsr	x14, x13, #4
	umulh	x14, x14, x15
	lsr	x14, x14, #1
	msub	x13, x14, x16, x13
	ldr	w13, [x17, x13, lsl #2]
	tst	w12, #0x1
	csel	w12, w27, wzr, ne
	eor	w12, w12, w13
	eor	w11, w12, w11, lsr #1
	str	w11, [x17, x10, lsl #2]
	eor	w10, w11, w11, lsr #11
	and	w11, w26, w10, lsl #7
	eor	w10, w11, w10
	and	w11, w28, w10, lsl #15
	eor	w10, w11, w10
	eor	w10, w10, w10, lsr #18
	ucvtf	s0, w10, #32
	mov	w10, #-1018691584               ; =0xc3480000
	fmov	s1, w10
	mov	w10, #1137180672                ; =0x43c80000
	fmov	s2, w10
	fmadd	s0, s0, s2, s1
	ldr	x10, [sp, #144]                 ; 8-byte Folded Reload
	str	s0, [x10, x8]
	add	x8, x8, #4
	cmp	x20, x8
	b.ne	LBB3_89
; %bb.90:                               ;   in Loop: Header=BB3_85 Depth=1
	str	x9, [sp, #2648]
Ltmp92:
	mov	x0, x19
	bl	__Znwm
Ltmp93:
; %bb.91:                               ;   in Loop: Header=BB3_85 Depth=1
	mov	x20, x0
	mov	x1, x19
	bl	_bzero
	ldr	x23, [sp, #144]                 ; 8-byte Folded Reload
	b	LBB3_93
LBB3_92:                                ;   in Loop: Header=BB3_85 Depth=1
	str	xzr, [sp, #144]                 ; 8-byte Folded Spill
	mov	x23, #0                         ; =0x0
	mov	x22, #0                         ; =0x0
	mov	x20, #0                         ; =0x0
LBB3_93:                                ;   in Loop: Header=BB3_85 Depth=1
Ltmp98:
	fmov	s0, #1.25000000
	ldr	x0, [sp, #144]                  ; 8-byte Folded Reload
	mov	x1, x20
	mov	x2, x19
	bl	__ZN8practice6scalarEPKfPamf
Ltmp99:
; %bb.94:                               ;   in Loop: Header=BB3_85 Depth=1
Ltmp100:
	fmov	s0, #1.25000000
	ldr	x0, [sp, #144]                  ; 8-byte Folded Reload
	mov	x1, x20
	mov	x2, x19
	bl	__ZN8practice4neonEPKfPamf
Ltmp101:
; %bb.95:                               ;   in Loop: Header=BB3_85 Depth=1
Ltmp102:
	fmov	s0, #1.25000000
	ldr	x0, [sp, #144]                  ; 8-byte Folded Reload
	mov	x1, x20
	mov	x2, x19
	bl	__ZN8practice6scalarEPKfPamf
Ltmp103:
; %bb.96:                               ;   in Loop: Header=BB3_85 Depth=1
Ltmp104:
	fmov	s0, #1.25000000
	ldr	x0, [sp, #144]                  ; 8-byte Folded Reload
	mov	x1, x20
	mov	x2, x19
	bl	__ZN8practice4neonEPKfPamf
Ltmp105:
; %bb.97:                               ;   in Loop: Header=BB3_85 Depth=1
Ltmp106:
	fmov	s0, #1.25000000
	ldr	x0, [sp, #144]                  ; 8-byte Folded Reload
	mov	x1, x20
	mov	x2, x19
	bl	__ZN8practice6scalarEPKfPamf
Ltmp107:
; %bb.98:                               ;   in Loop: Header=BB3_85 Depth=1
Ltmp108:
	fmov	s0, #1.25000000
	ldr	x0, [sp, #144]                  ; 8-byte Folded Reload
	mov	x1, x20
	mov	x2, x19
	bl	__ZN8practice4neonEPKfPamf
Ltmp109:
; %bb.99:                               ;   in Loop: Header=BB3_85 Depth=1
Ltmp110:
	fmov	s0, #1.25000000
	ldr	x0, [sp, #144]                  ; 8-byte Folded Reload
	mov	x1, x20
	mov	x2, x19
	bl	__ZN8practice6scalarEPKfPamf
Ltmp111:
; %bb.100:                              ;   in Loop: Header=BB3_85 Depth=1
Ltmp112:
	fmov	s0, #1.25000000
	ldr	x0, [sp, #144]                  ; 8-byte Folded Reload
	mov	x1, x20
	mov	x2, x19
	bl	__ZN8practice4neonEPKfPamf
Ltmp113:
; %bb.101:                              ;   in Loop: Header=BB3_85 Depth=1
Ltmp114:
	fmov	s0, #1.25000000
	ldr	x0, [sp, #144]                  ; 8-byte Folded Reload
	mov	x1, x20
	mov	x2, x19
	bl	__ZN8practice6scalarEPKfPamf
Ltmp115:
; %bb.102:                              ;   in Loop: Header=BB3_85 Depth=1
Ltmp116:
	fmov	s0, #1.25000000
	ldr	x0, [sp, #144]                  ; 8-byte Folded Reload
	mov	x1, x20
	mov	x2, x19
	bl	__ZN8practice4neonEPKfPamf
Ltmp117:
; %bb.103:                              ;   in Loop: Header=BB3_85 Depth=1
Ltmp118:
	fmov	s0, #1.25000000
	ldr	x0, [sp, #144]                  ; 8-byte Folded Reload
	mov	x1, x20
	mov	x2, x19
	bl	__ZN8practice6scalarEPKfPamf
Ltmp119:
; %bb.104:                              ;   in Loop: Header=BB3_85 Depth=1
Ltmp120:
	fmov	s0, #1.25000000
	ldr	x0, [sp, #144]                  ; 8-byte Folded Reload
	mov	x1, x20
	mov	x2, x19
	bl	__ZN8practice4neonEPKfPamf
Ltmp121:
; %bb.105:                              ;   in Loop: Header=BB3_85 Depth=1
Ltmp122:
	fmov	s0, #1.25000000
	ldr	x0, [sp, #144]                  ; 8-byte Folded Reload
	mov	x1, x20
	mov	x2, x19
	bl	__ZN8practice6scalarEPKfPamf
Ltmp123:
; %bb.106:                              ;   in Loop: Header=BB3_85 Depth=1
Ltmp124:
	fmov	s0, #1.25000000
	ldr	x0, [sp, #144]                  ; 8-byte Folded Reload
	mov	x1, x20
	mov	x2, x19
	bl	__ZN8practice4neonEPKfPamf
Ltmp125:
; %bb.107:                              ;   in Loop: Header=BB3_85 Depth=1
Ltmp126:
	fmov	s0, #1.25000000
	ldr	x0, [sp, #144]                  ; 8-byte Folded Reload
	mov	x1, x20
	mov	x2, x19
	bl	__ZN8practice6scalarEPKfPamf
Ltmp127:
; %bb.108:                              ;   in Loop: Header=BB3_85 Depth=1
Ltmp128:
	fmov	s0, #1.25000000
	ldr	x0, [sp, #144]                  ; 8-byte Folded Reload
	mov	x1, x20
	mov	x2, x19
	bl	__ZN8practice4neonEPKfPamf
Ltmp129:
; %bb.109:                              ;   in Loop: Header=BB3_85 Depth=1
	str	wzr, [sp, #80]                  ; 4-byte Folded Spill
	stp	xzr, xzr, [sp, #120]            ; 16-byte Folded Spill
	mov	x25, #0                         ; =0x0
	mov	x21, #0                         ; =0x0
	str	xzr, [sp, #136]                 ; 8-byte Folded Spill
	mov	w8, #1048576                    ; =0x100000
	udiv	x8, x8, x19
	cmp	x8, #4
	mov	w9, #4                          ; =0x4
	csel	x9, x8, x9, hi
	sub	x8, x22, x23
	asr	x8, x8, #2
	str	x8, [sp, #96]                   ; 8-byte Folded Spill
	stp	x9, xzr, [sp, #104]             ; 16-byte Folded Spill
	ucvtf	d8, x9
LBB3_110:                               ;   Parent Loop BB3_85 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB3_116 Depth 3
                                        ;       Child Loop BB3_138 Depth 3
                                        ;       Child Loop BB3_112 Depth 3
                                        ;       Child Loop BB3_127 Depth 3
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x23, x0
	ldr	x22, [sp, #104]                 ; 8-byte Folded Reload
	ldr	w8, [sp, #80]                   ; 4-byte Folded Reload
	tbnz	w8, #0, LBB3_116
; %bb.111:                              ;   in Loop: Header=BB3_110 Depth=2
	ldr	x22, [sp, #104]                 ; 8-byte Folded Reload
LBB3_112:                               ;   Parent Loop BB3_85 Depth=1
                                        ;     Parent Loop BB3_110 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
Ltmp153:
	fmov	s0, #1.25000000
	ldr	x0, [sp, #144]                  ; 8-byte Folded Reload
	mov	x1, x20
	ldr	x2, [sp, #96]                   ; 8-byte Folded Reload
	bl	__ZN8practice6scalarEPKfPamf
Ltmp154:
; %bb.113:                              ;   in Loop: Header=BB3_112 Depth=3
	; InlineAsm Start
	; InlineAsm End
	subs	x22, x22, #1
	b.ne	LBB3_112
; %bb.114:                              ;   in Loop: Header=BB3_110 Depth=2
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	sub	x8, x0, x23
	scvtf	d0, x8
	mov	x8, #70368744177664             ; =0x400000000000
	movk	x8, #16527, lsl #48
	fmov	d1, x8
	fdiv	d0, d0, d1
	fdiv	d9, d0, d8
	ldr	x8, [sp, #112]                  ; 8-byte Folded Reload
	cmp	x21, x8
	b.hs	LBB3_120
; %bb.115:                              ;   in Loop: Header=BB3_110 Depth=2
	str	d9, [x21], #8
	b	LBB3_126
LBB3_116:                               ;   Parent Loop BB3_85 Depth=1
                                        ;     Parent Loop BB3_110 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
Ltmp131:
	fmov	s0, #1.25000000
	ldr	x0, [sp, #144]                  ; 8-byte Folded Reload
	mov	x1, x20
	ldr	x2, [sp, #96]                   ; 8-byte Folded Reload
	bl	__ZN8practice4neonEPKfPamf
Ltmp132:
; %bb.117:                              ;   in Loop: Header=BB3_116 Depth=3
	; InlineAsm Start
	; InlineAsm End
	subs	x22, x22, #1
	b.ne	LBB3_116
; %bb.118:                              ;   in Loop: Header=BB3_110 Depth=2
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	sub	x8, x0, x23
	scvtf	d0, x8
	mov	x8, #70368744177664             ; =0x400000000000
	movk	x8, #16527, lsl #48
	fmov	d1, x8
	fdiv	d0, d0, d1
	fdiv	d9, d0, d8
	ldr	x8, [sp, #120]                  ; 8-byte Folded Reload
	cmp	x25, x8
	b.hs	LBB3_131
; %bb.119:                              ;   in Loop: Header=BB3_110 Depth=2
	str	d9, [x25], #8
	b	LBB3_137
LBB3_120:                               ;   in Loop: Header=BB3_110 Depth=2
	ldr	x8, [sp, #136]                  ; 8-byte Folded Reload
	sub	x24, x21, x8
	asr	x22, x24, #3
	add	x8, x22, #1
	lsr	x9, x8, #61
	cbnz	x9, LBB3_177
; %bb.121:                              ;   in Loop: Header=BB3_110 Depth=2
	ldr	x9, [sp, #136]                  ; 8-byte Folded Reload
	ldr	x10, [sp, #112]                 ; 8-byte Folded Reload
	sub	x9, x10, x9
	asr	x10, x9, #2
	cmp	x10, x8
	csel	x8, x10, x8, hi
	mov	x10, #9223372036854775800       ; =0x7ffffffffffffff8
	cmp	x9, x10
	mov	x9, #2305843009213693951        ; =0x1fffffffffffffff
	csel	x23, x8, x9, lo
	lsr	x8, x23, #61
	cbnz	x8, LBB3_178
; %bb.122:                              ;   in Loop: Header=BB3_110 Depth=2
	lsl	x0, x23, #3
Ltmp156:
	bl	__Znwm
Ltmp157:
; %bb.123:                              ;   in Loop: Header=BB3_110 Depth=2
	add	x21, x0, x24
	add	x8, x0, x23, lsl #3
	str	x8, [sp, #112]                  ; 8-byte Folded Spill
	sub	x23, x21, x22, lsl #3
	str	d9, [x21], #8
	mov	x0, x23
	ldr	x22, [sp, #136]                 ; 8-byte Folded Reload
	mov	x1, x22
	mov	x2, x24
	bl	_memcpy
	cbz	x22, LBB3_125
; %bb.124:                              ;   in Loop: Header=BB3_110 Depth=2
	ldr	x0, [sp, #136]                  ; 8-byte Folded Reload
	bl	__ZdlPv
LBB3_125:                               ;   in Loop: Header=BB3_110 Depth=2
	str	x23, [sp, #136]                 ; 8-byte Folded Spill
LBB3_126:                               ;   in Loop: Header=BB3_110 Depth=2
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x23, x0
	ldr	x22, [sp, #104]                 ; 8-byte Folded Reload
LBB3_127:                               ;   Parent Loop BB3_85 Depth=1
                                        ;     Parent Loop BB3_110 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
Ltmp164:
	fmov	s0, #1.25000000
	ldr	x0, [sp, #144]                  ; 8-byte Folded Reload
	mov	x1, x20
	ldr	x2, [sp, #96]                   ; 8-byte Folded Reload
	bl	__ZN8practice4neonEPKfPamf
Ltmp165:
; %bb.128:                              ;   in Loop: Header=BB3_127 Depth=3
	; InlineAsm Start
	; InlineAsm End
	subs	x22, x22, #1
	b.ne	LBB3_127
; %bb.129:                              ;   in Loop: Header=BB3_110 Depth=2
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	sub	x8, x0, x23
	scvtf	d0, x8
	mov	x8, #70368744177664             ; =0x400000000000
	movk	x8, #16527, lsl #48
	fmov	d1, x8
	fdiv	d0, d0, d1
	fdiv	d9, d0, d8
	ldr	x8, [sp, #120]                  ; 8-byte Folded Reload
	cmp	x25, x8
	b.hs	LBB3_142
; %bb.130:                              ;   in Loop: Header=BB3_110 Depth=2
	str	d9, [x25], #8
	b	LBB3_154
LBB3_131:                               ;   in Loop: Header=BB3_110 Depth=2
	ldr	x8, [sp, #128]                  ; 8-byte Folded Reload
	sub	x24, x25, x8
	asr	x22, x24, #3
	add	x8, x22, #1
	lsr	x9, x8, #61
	cbnz	x9, LBB3_179
; %bb.132:                              ;   in Loop: Header=BB3_110 Depth=2
	ldp	x10, x9, [sp, #120]             ; 16-byte Folded Reload
	sub	x9, x10, x9
	asr	x10, x9, #2
	cmp	x10, x8
	csel	x8, x10, x8, hi
	mov	x10, #9223372036854775800       ; =0x7ffffffffffffff8
	cmp	x9, x10
	mov	x9, #2305843009213693951        ; =0x1fffffffffffffff
	csel	x23, x8, x9, lo
	lsr	x8, x23, #61
	cbnz	x8, LBB3_180
; %bb.133:                              ;   in Loop: Header=BB3_110 Depth=2
	lsl	x0, x23, #3
Ltmp134:
	bl	__Znwm
Ltmp135:
; %bb.134:                              ;   in Loop: Header=BB3_110 Depth=2
	add	x25, x0, x24
	add	x8, x0, x23, lsl #3
	str	x8, [sp, #120]                  ; 8-byte Folded Spill
	sub	x23, x25, x22, lsl #3
	str	d9, [x25], #8
	mov	x0, x23
	ldr	x22, [sp, #128]                 ; 8-byte Folded Reload
	mov	x1, x22
	mov	x2, x24
	bl	_memcpy
	cbz	x22, LBB3_136
; %bb.135:                              ;   in Loop: Header=BB3_110 Depth=2
	ldr	x0, [sp, #128]                  ; 8-byte Folded Reload
	bl	__ZdlPv
LBB3_136:                               ;   in Loop: Header=BB3_110 Depth=2
	str	x23, [sp, #128]                 ; 8-byte Folded Spill
LBB3_137:                               ;   in Loop: Header=BB3_110 Depth=2
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x23, x0
	ldr	x22, [sp, #104]                 ; 8-byte Folded Reload
LBB3_138:                               ;   Parent Loop BB3_85 Depth=1
                                        ;     Parent Loop BB3_110 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
Ltmp142:
	fmov	s0, #1.25000000
	ldr	x0, [sp, #144]                  ; 8-byte Folded Reload
	mov	x1, x20
	ldr	x2, [sp, #96]                   ; 8-byte Folded Reload
	bl	__ZN8practice6scalarEPKfPamf
Ltmp143:
; %bb.139:                              ;   in Loop: Header=BB3_138 Depth=3
	; InlineAsm Start
	; InlineAsm End
	subs	x22, x22, #1
	b.ne	LBB3_138
; %bb.140:                              ;   in Loop: Header=BB3_110 Depth=2
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	sub	x8, x0, x23
	scvtf	d0, x8
	mov	x8, #70368744177664             ; =0x400000000000
	movk	x8, #16527, lsl #48
	fmov	d1, x8
	fdiv	d0, d0, d1
	fdiv	d9, d0, d8
	ldr	x8, [sp, #112]                  ; 8-byte Folded Reload
	cmp	x21, x8
	b.hs	LBB3_148
; %bb.141:                              ;   in Loop: Header=BB3_110 Depth=2
	str	d9, [x21], #8
	b	LBB3_154
LBB3_142:                               ;   in Loop: Header=BB3_110 Depth=2
	ldr	x8, [sp, #128]                  ; 8-byte Folded Reload
	sub	x24, x25, x8
	asr	x22, x24, #3
	add	x8, x22, #1
	lsr	x9, x8, #61
	cbnz	x9, LBB3_181
; %bb.143:                              ;   in Loop: Header=BB3_110 Depth=2
	ldp	x10, x9, [sp, #120]             ; 16-byte Folded Reload
	sub	x9, x10, x9
	asr	x10, x9, #2
	cmp	x10, x8
	csel	x8, x10, x8, hi
	mov	x10, #9223372036854775800       ; =0x7ffffffffffffff8
	cmp	x9, x10
	mov	x9, #2305843009213693951        ; =0x1fffffffffffffff
	csel	x23, x8, x9, lo
	lsr	x8, x23, #61
	cbnz	x8, LBB3_182
; %bb.144:                              ;   in Loop: Header=BB3_110 Depth=2
	lsl	x0, x23, #3
Ltmp167:
	bl	__Znwm
Ltmp168:
; %bb.145:                              ;   in Loop: Header=BB3_110 Depth=2
	add	x25, x0, x24
	add	x8, x0, x23, lsl #3
	str	x8, [sp, #120]                  ; 8-byte Folded Spill
	sub	x23, x25, x22, lsl #3
	str	d9, [x25], #8
	mov	x0, x23
	ldr	x22, [sp, #128]                 ; 8-byte Folded Reload
	mov	x1, x22
	mov	x2, x24
	bl	_memcpy
	cbz	x22, LBB3_147
; %bb.146:                              ;   in Loop: Header=BB3_110 Depth=2
	ldr	x0, [sp, #128]                  ; 8-byte Folded Reload
	bl	__ZdlPv
LBB3_147:                               ;   in Loop: Header=BB3_110 Depth=2
	str	x23, [sp, #128]                 ; 8-byte Folded Spill
	b	LBB3_154
LBB3_148:                               ;   in Loop: Header=BB3_110 Depth=2
	ldr	x8, [sp, #136]                  ; 8-byte Folded Reload
	sub	x24, x21, x8
	asr	x22, x24, #3
	add	x8, x22, #1
	lsr	x9, x8, #61
	cbnz	x9, LBB3_183
; %bb.149:                              ;   in Loop: Header=BB3_110 Depth=2
	ldr	x9, [sp, #136]                  ; 8-byte Folded Reload
	ldr	x10, [sp, #112]                 ; 8-byte Folded Reload
	sub	x9, x10, x9
	asr	x10, x9, #2
	cmp	x10, x8
	csel	x8, x10, x8, hi
	mov	x10, #9223372036854775800       ; =0x7ffffffffffffff8
	cmp	x9, x10
	mov	x9, #2305843009213693951        ; =0x1fffffffffffffff
	csel	x23, x8, x9, lo
	lsr	x8, x23, #61
	cbnz	x8, LBB3_184
; %bb.150:                              ;   in Loop: Header=BB3_110 Depth=2
	lsl	x0, x23, #3
Ltmp145:
	bl	__Znwm
Ltmp146:
; %bb.151:                              ;   in Loop: Header=BB3_110 Depth=2
	add	x21, x0, x24
	add	x8, x0, x23, lsl #3
	str	x8, [sp, #112]                  ; 8-byte Folded Spill
	sub	x23, x21, x22, lsl #3
	str	d9, [x21], #8
	mov	x0, x23
	ldr	x22, [sp, #136]                 ; 8-byte Folded Reload
	mov	x1, x22
	mov	x2, x24
	bl	_memcpy
	cbz	x22, LBB3_153
; %bb.152:                              ;   in Loop: Header=BB3_110 Depth=2
	ldr	x0, [sp, #136]                  ; 8-byte Folded Reload
	bl	__ZdlPv
LBB3_153:                               ;   in Loop: Header=BB3_110 Depth=2
	str	x23, [sp, #136]                 ; 8-byte Folded Spill
LBB3_154:                               ;   in Loop: Header=BB3_110 Depth=2
	ldr	w8, [sp, #80]                   ; 4-byte Folded Reload
	add	w8, w8, #1
	str	w8, [sp, #80]                   ; 4-byte Folded Spill
	cmp	w8, #11
	b.ne	LBB3_110
; %bb.155:                              ;   in Loop: Header=BB3_85 Depth=1
Ltmp175:
	sub	x2, x29, #168
	ldr	x0, [sp, #136]                  ; 8-byte Folded Reload
	mov	x1, x21
	bl	__ZNSt3__16__sortIRNS_6__lessIddEEPdEEvT0_S5_T_
Ltmp176:
; %bb.156:                              ;   in Loop: Header=BB3_85 Depth=1
Ltmp177:
	sub	x2, x29, #168
	ldr	x0, [sp, #128]                  ; 8-byte Folded Reload
	mov	x1, x25
	bl	__ZNSt3__16__sortIRNS_6__lessIddEEPdEEvT0_S5_T_
Ltmp178:
; %bb.157:                              ;   in Loop: Header=BB3_85 Depth=1
Ltmp179:
Lloh79:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh80:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh81:
	adrp	x1, l_.str.8@PAGE
Lloh82:
	add	x1, x1, l_.str.8@PAGEOFF
	mov	w2, #20                         ; =0x14
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp180:
; %bb.158:                              ;   in Loop: Header=BB3_85 Depth=1
Ltmp181:
	mov	x1, x19
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp182:
; %bb.159:                              ;   in Loop: Header=BB3_85 Depth=1
Ltmp183:
Lloh83:
	adrp	x1, l_.str.9@PAGE
Lloh84:
	add	x1, x1, l_.str.9@PAGEOFF
	mov	w2, #9                          ; =0x9
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp184:
; %bb.160:                              ;   in Loop: Header=BB3_85 Depth=1
Ltmp185:
	ldr	x1, [sp, #104]                  ; 8-byte Folded Reload
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp186:
; %bb.161:                              ;   in Loop: Header=BB3_85 Depth=1
Ltmp187:
Lloh85:
	adrp	x1, l_.str.10@PAGE
Lloh86:
	add	x1, x1, l_.str.10@PAGEOFF
	mov	w2, #12                         ; =0xc
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp188:
; %bb.162:                              ;   in Loop: Header=BB3_85 Depth=1
	ldr	x8, [sp, #136]                  ; 8-byte Folded Reload
	ldr	d0, [x8, #40]
Ltmp189:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp190:
; %bb.163:                              ;   in Loop: Header=BB3_85 Depth=1
Ltmp191:
Lloh87:
	adrp	x1, l_.str.11@PAGE
Lloh88:
	add	x1, x1, l_.str.11@PAGEOFF
	mov	w2, #10                         ; =0xa
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp192:
; %bb.164:                              ;   in Loop: Header=BB3_85 Depth=1
	ldr	x8, [sp, #128]                  ; 8-byte Folded Reload
	ldr	d0, [x8, #40]
Ltmp193:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp194:
; %bb.165:                              ;   in Loop: Header=BB3_85 Depth=1
Ltmp195:
Lloh89:
	adrp	x1, l_.str.12@PAGE
Lloh90:
	add	x1, x1, l_.str.12@PAGEOFF
	mov	w2, #12                         ; =0xc
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp196:
; %bb.166:                              ;   in Loop: Header=BB3_85 Depth=1
	ldr	x8, [sp, #136]                  ; 8-byte Folded Reload
	ldr	d0, [x8, #80]
Ltmp197:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp198:
; %bb.167:                              ;   in Loop: Header=BB3_85 Depth=1
Ltmp199:
Lloh91:
	adrp	x1, l_.str.13@PAGE
Lloh92:
	add	x1, x1, l_.str.13@PAGEOFF
	mov	w2, #10                         ; =0xa
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp200:
; %bb.168:                              ;   in Loop: Header=BB3_85 Depth=1
	ldr	x8, [sp, #128]                  ; 8-byte Folded Reload
	ldr	d0, [x8, #80]
Ltmp201:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp202:
; %bb.169:                              ;   in Loop: Header=BB3_85 Depth=1
Ltmp203:
Lloh93:
	adrp	x1, l_.str.14@PAGE
Lloh94:
	add	x1, x1, l_.str.14@PAGEOFF
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp204:
; %bb.170:                              ;   in Loop: Header=BB3_85 Depth=1
	ldr	x0, [sp, #128]                  ; 8-byte Folded Reload
	bl	__ZdlPv
	ldr	x0, [sp, #136]                  ; 8-byte Folded Reload
	bl	__ZdlPv
	cbz	x20, LBB3_172
; %bb.171:                              ;   in Loop: Header=BB3_85 Depth=1
	mov	x0, x20
	bl	__ZdlPv
LBB3_172:                               ;   in Loop: Header=BB3_85 Depth=1
	ldr	x8, [sp, #144]                  ; 8-byte Folded Reload
	cbz	x8, LBB3_174
; %bb.173:                              ;   in Loop: Header=BB3_85 Depth=1
	ldr	x0, [sp, #144]                  ; 8-byte Folded Reload
	bl	__ZdlPv
LBB3_174:                               ;   in Loop: Header=BB3_85 Depth=1
	ldr	x8, [sp, #88]                   ; 8-byte Folded Reload
	add	x8, x8, #4
	str	x8, [sp, #88]                   ; 8-byte Folded Spill
	cmp	x8, #16
	b.ne	LBB3_85
; %bb.175:
	mov	w0, #0                          ; =0x0
	b	LBB3_243
LBB3_176:
Ltmp95:
	bl	__ZNSt3__16vectorIfNS_9allocatorIfEEE20__throw_length_errorB9nqe210106Ev
Ltmp96:
	b	LBB3_185
LBB3_177:
Ltmp161:
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_length_errorB9nqe210106Ev
Ltmp162:
	b	LBB3_185
LBB3_178:
Ltmp159:
	bl	__ZSt28__throw_bad_array_new_lengthB9nqe210106v
Ltmp160:
	b	LBB3_185
LBB3_179:
Ltmp139:
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_length_errorB9nqe210106Ev
Ltmp140:
	b	LBB3_185
LBB3_180:
Ltmp137:
	bl	__ZSt28__throw_bad_array_new_lengthB9nqe210106v
Ltmp138:
	b	LBB3_185
LBB3_181:
Ltmp172:
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_length_errorB9nqe210106Ev
Ltmp173:
	b	LBB3_185
LBB3_182:
Ltmp170:
	bl	__ZSt28__throw_bad_array_new_lengthB9nqe210106v
Ltmp171:
	b	LBB3_185
LBB3_183:
Ltmp150:
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_length_errorB9nqe210106Ev
Ltmp151:
	b	LBB3_185
LBB3_184:
Ltmp148:
	bl	__ZSt28__throw_bad_array_new_lengthB9nqe210106v
Ltmp149:
LBB3_185:
	brk	#0x1
LBB3_186:
Ltmp152:
	b	LBB3_200
LBB3_187:
Ltmp174:
	b	LBB3_200
LBB3_188:
Ltmp141:
	b	LBB3_200
LBB3_189:
Ltmp163:
	b	LBB3_200
LBB3_190:
Ltmp97:
	b	LBB3_219
LBB3_191:
Ltmp205:
	mov	x25, x1
	mov	x21, x0
	b	LBB3_201
LBB3_192:
Ltmp147:
	b	LBB3_200
LBB3_193:
Ltmp169:
	b	LBB3_200
LBB3_194:
Ltmp144:
	b	LBB3_200
LBB3_195:
Ltmp136:
	b	LBB3_200
LBB3_196:
Ltmp166:
	b	LBB3_200
LBB3_197:
Ltmp158:
	b	LBB3_200
LBB3_198:
Ltmp133:
	b	LBB3_200
LBB3_199:
Ltmp155:
LBB3_200:
	mov	x21, x0
	mov	x25, x1
LBB3_201:
	ldr	x8, [sp, #128]                  ; 8-byte Folded Reload
	cbz	x8, LBB3_203
; %bb.202:
	ldr	x0, [sp, #128]                  ; 8-byte Folded Reload
	bl	__ZdlPv
LBB3_203:
	ldr	x8, [sp, #136]                  ; 8-byte Folded Reload
	cbz	x8, LBB3_206
; %bb.204:
	ldr	x0, [sp, #136]                  ; 8-byte Folded Reload
	bl	__ZdlPv
	b	LBB3_206
LBB3_205:
Ltmp130:
	mov	x25, x1
	mov	x21, x0
LBB3_206:
	cbz	x20, LBB3_208
; %bb.207:
	mov	x0, x20
	bl	__ZdlPv
LBB3_208:
	ldr	x8, [sp, #144]                  ; 8-byte Folded Reload
	cbnz	x8, LBB3_210
	b	LBB3_238
LBB3_209:
Ltmp94:
	mov	x21, x0
	mov	x25, x1
LBB3_210:
	ldr	x0, [sp, #144]                  ; 8-byte Folded Reload
	b	LBB3_237
LBB3_211:
Ltmp91:
	b	LBB3_219
LBB3_212:
Ltmp88:
	b	LBB3_214
LBB3_213:
Ltmp77:
LBB3_214:
	mov	x25, x1
	mov	x21, x0
	b	LBB3_238
LBB3_215:
Ltmp8:
	b	LBB3_219
LBB3_216:
Ltmp5:
	mov	x25, x1
	mov	x21, x0
	mov	x0, x19
	bl	___cxa_free_exception
                                        ; kill: def $w25 killed $w25 killed $x25 def $x25
	b	LBB3_238
LBB3_217:
Ltmp11:
	b	LBB3_219
LBB3_218:
Ltmp14:
LBB3_219:
	mov	x21, x0
	mov	x25, x1
	b	LBB3_238
LBB3_220:
Ltmp20:
	mov	x21, x0
	mov	x25, x1
	b	LBB3_234
LBB3_221:
Ltmp23:
	b	LBB3_223
LBB3_222:
Ltmp17:
LBB3_223:
	mov	x21, x0
	mov	x25, x1
	b	LBB3_235
LBB3_224:
Ltmp29:
	b	LBB3_232
LBB3_225:
Ltmp26:
	mov	x21, x0
	mov	x25, x1
	cbnz	x24, LBB3_233
	b	LBB3_234
LBB3_226:
Ltmp35:
	b	LBB3_232
LBB3_227:
Ltmp32:
	b	LBB3_230
LBB3_228:
Ltmp38:
	b	LBB3_230
LBB3_229:
Ltmp41:
LBB3_230:
	mov	x25, x1
	mov	x21, x0
	mov	x0, x20
	bl	___cxa_free_exception
                                        ; kill: def $w25 killed $w25 killed $x25 def $x25
	b	LBB3_233
LBB3_231:
Ltmp44:
LBB3_232:
	mov	x21, x0
	mov	x25, x1
LBB3_233:
	mov	x0, x24
	bl	__ZdlPv
LBB3_234:
	mov	x0, x23
	bl	__ZdlPv
LBB3_235:
	cbz	x19, LBB3_238
; %bb.236:
	mov	x0, x19
LBB3_237:
	bl	__ZdlPv
LBB3_238:
	cmp	w25, #1
	b.ne	LBB3_249
; %bb.239:
	mov	x0, x21
	bl	___cxa_begin_catch
	ldr	x8, [x0]
	ldr	x8, [x8, #16]
	blr	x8
	mov	x19, x0
	bl	_strlen
	mov	x2, x0
Ltmp206:
Lloh95:
	adrp	x0, __ZNSt3__14cerrE@GOTPAGE
Lloh96:
	ldr	x0, [x0, __ZNSt3__14cerrE@GOTPAGEOFF]
	mov	x1, x19
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp207:
; %bb.240:
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #152]
Ltmp208:
	add	x1, sp, #152
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp209:
; %bb.241:
Ltmp214:
	bl	___cxa_end_catch
Ltmp215:
; %bb.242:
	mov	w0, #1                          ; =0x1
LBB3_243:
	ldur	x8, [x29, #-152]
Lloh97:
	adrp	x9, ___stack_chk_guard@GOTPAGE
Lloh98:
	ldr	x9, [x9, ___stack_chk_guard@GOTPAGEOFF]
Lloh99:
	ldr	x9, [x9]
	cmp	x9, x8
	b.ne	LBB3_245
; %bb.244:
	add	sp, sp, #2768
	ldp	x29, x30, [sp, #128]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #112]            ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #96]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #80]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #64]             ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #48]             ; 16-byte Folded Reload
	ldp	d9, d8, [sp, #32]               ; 16-byte Folded Reload
	ldp	d11, d10, [sp, #16]             ; 16-byte Folded Reload
	ldp	d13, d12, [sp], #144            ; 16-byte Folded Reload
	ret
LBB3_245:
	bl	___stack_chk_fail
LBB3_246:
Ltmp216:
	bl	__Unwind_Resume
LBB3_247:
Ltmp210:
	mov	x21, x0
Ltmp211:
	bl	___cxa_end_catch
Ltmp212:
	b	LBB3_249
LBB3_248:
Ltmp213:
	mov	x21, x0
	cbnz	w1, LBB3_250
LBB3_249:
	mov	x0, x21
	bl	__Unwind_Resume
LBB3_250:
	mov	x0, x21
	bl	___clang_call_terminate
	.loh AdrpLdrGotLdr	Lloh0, Lloh1, Lloh2
	.loh AdrpAdd	Lloh11, Lloh12
	.loh AdrpAdrp	Lloh9, Lloh11
	.loh AdrpLdr	Lloh9, Lloh10
	.loh AdrpAdrp	Lloh7, Lloh9
	.loh AdrpLdr	Lloh7, Lloh8
	.loh AdrpAdrp	Lloh5, Lloh7
	.loh AdrpLdr	Lloh5, Lloh6
	.loh AdrpAdrp	Lloh3, Lloh5
	.loh AdrpLdr	Lloh3, Lloh4
	.loh AdrpAdd	Lloh13, Lloh14
	.loh AdrpAdd	Lloh15, Lloh16
	.loh AdrpLdrGot	Lloh21, Lloh22
	.loh AdrpLdrGot	Lloh19, Lloh20
	.loh AdrpLdrGot	Lloh17, Lloh18
	.loh AdrpAdd	Lloh23, Lloh24
	.loh AdrpAdd	Lloh25, Lloh26
	.loh AdrpLdrGot	Lloh29, Lloh30
	.loh AdrpLdrGot	Lloh27, Lloh28
	.loh AdrpAdd	Lloh31, Lloh32
	.loh AdrpLdrGot	Lloh35, Lloh36
	.loh AdrpLdrGot	Lloh33, Lloh34
	.loh AdrpAdd	Lloh37, Lloh38
	.loh AdrpLdrGot	Lloh43, Lloh44
	.loh AdrpLdrGot	Lloh41, Lloh42
	.loh AdrpLdrGot	Lloh39, Lloh40
	.loh AdrpAdd	Lloh45, Lloh46
	.loh AdrpLdrGot	Lloh51, Lloh52
	.loh AdrpLdrGot	Lloh49, Lloh50
	.loh AdrpLdrGot	Lloh47, Lloh48
	.loh AdrpAdd	Lloh53, Lloh54
	.loh AdrpLdrGot	Lloh59, Lloh60
	.loh AdrpLdrGot	Lloh57, Lloh58
	.loh AdrpLdrGot	Lloh55, Lloh56
	.loh AdrpAdd	Lloh61, Lloh62
	.loh AdrpLdrGot	Lloh67, Lloh68
	.loh AdrpLdrGot	Lloh65, Lloh66
	.loh AdrpLdrGot	Lloh63, Lloh64
	.loh AdrpAdd	Lloh71, Lloh72
	.loh AdrpLdrGot	Lloh69, Lloh70
	.loh AdrpAdd	Lloh73, Lloh74
	.loh AdrpAdd	Lloh75, Lloh76
	.loh AdrpLdr	Lloh77, Lloh78
	.loh AdrpAdd	Lloh81, Lloh82
	.loh AdrpLdrGot	Lloh79, Lloh80
	.loh AdrpAdd	Lloh83, Lloh84
	.loh AdrpAdd	Lloh85, Lloh86
	.loh AdrpAdd	Lloh87, Lloh88
	.loh AdrpAdd	Lloh89, Lloh90
	.loh AdrpAdd	Lloh91, Lloh92
	.loh AdrpAdd	Lloh93, Lloh94
	.loh AdrpLdrGot	Lloh95, Lloh96
	.loh AdrpLdrGotLdr	Lloh97, Lloh98, Lloh99
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
	.uleb128 Ltmp9-Lfunc_begin1             ; >> Call Site 1 <<
	.uleb128 Ltmp10-Ltmp9                   ;   Call between Ltmp9 and Ltmp10
	.uleb128 Ltmp11-Lfunc_begin1            ;     jumps to Ltmp11
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp10-Lfunc_begin1            ; >> Call Site 2 <<
	.uleb128 Ltmp15-Ltmp10                  ;   Call between Ltmp10 and Ltmp15
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp15-Lfunc_begin1            ; >> Call Site 3 <<
	.uleb128 Ltmp16-Ltmp15                  ;   Call between Ltmp15 and Ltmp16
	.uleb128 Ltmp17-Lfunc_begin1            ;     jumps to Ltmp17
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp16-Lfunc_begin1            ; >> Call Site 4 <<
	.uleb128 Ltmp18-Ltmp16                  ;   Call between Ltmp16 and Ltmp18
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp18-Lfunc_begin1            ; >> Call Site 5 <<
	.uleb128 Ltmp19-Ltmp18                  ;   Call between Ltmp18 and Ltmp19
	.uleb128 Ltmp20-Lfunc_begin1            ;     jumps to Ltmp20
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp19-Lfunc_begin1            ; >> Call Site 6 <<
	.uleb128 Ltmp24-Ltmp19                  ;   Call between Ltmp19 and Ltmp24
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp24-Lfunc_begin1            ; >> Call Site 7 <<
	.uleb128 Ltmp25-Ltmp24                  ;   Call between Ltmp24 and Ltmp25
	.uleb128 Ltmp26-Lfunc_begin1            ;     jumps to Ltmp26
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp27-Lfunc_begin1            ; >> Call Site 8 <<
	.uleb128 Ltmp28-Ltmp27                  ;   Call between Ltmp27 and Ltmp28
	.uleb128 Ltmp29-Lfunc_begin1            ;     jumps to Ltmp29
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp28-Lfunc_begin1            ; >> Call Site 9 <<
	.uleb128 Ltmp45-Ltmp28                  ;   Call between Ltmp28 and Ltmp45
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp45-Lfunc_begin1            ; >> Call Site 10 <<
	.uleb128 Ltmp46-Ltmp45                  ;   Call between Ltmp45 and Ltmp46
	.uleb128 Ltmp47-Lfunc_begin1            ;     jumps to Ltmp47
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp48-Lfunc_begin1            ; >> Call Site 11 <<
	.uleb128 Ltmp49-Ltmp48                  ;   Call between Ltmp48 and Ltmp49
	.uleb128 Ltmp50-Lfunc_begin1            ;     jumps to Ltmp50
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp49-Lfunc_begin1            ; >> Call Site 12 <<
	.uleb128 Ltmp39-Ltmp49                  ;   Call between Ltmp49 and Ltmp39
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp39-Lfunc_begin1            ; >> Call Site 13 <<
	.uleb128 Ltmp40-Ltmp39                  ;   Call between Ltmp39 and Ltmp40
	.uleb128 Ltmp41-Lfunc_begin1            ;     jumps to Ltmp41
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp40-Lfunc_begin1            ; >> Call Site 14 <<
	.uleb128 Ltmp36-Ltmp40                  ;   Call between Ltmp40 and Ltmp36
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp36-Lfunc_begin1            ; >> Call Site 15 <<
	.uleb128 Ltmp37-Ltmp36                  ;   Call between Ltmp36 and Ltmp37
	.uleb128 Ltmp38-Lfunc_begin1            ;     jumps to Ltmp38
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp42-Lfunc_begin1            ; >> Call Site 16 <<
	.uleb128 Ltmp43-Ltmp42                  ;   Call between Ltmp42 and Ltmp43
	.uleb128 Ltmp44-Lfunc_begin1            ;     jumps to Ltmp44
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp43-Lfunc_begin1            ; >> Call Site 17 <<
	.uleb128 Ltmp30-Ltmp43                  ;   Call between Ltmp43 and Ltmp30
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp30-Lfunc_begin1            ; >> Call Site 18 <<
	.uleb128 Ltmp31-Ltmp30                  ;   Call between Ltmp30 and Ltmp31
	.uleb128 Ltmp32-Lfunc_begin1            ;     jumps to Ltmp32
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp33-Lfunc_begin1            ; >> Call Site 19 <<
	.uleb128 Ltmp34-Ltmp33                  ;   Call between Ltmp33 and Ltmp34
	.uleb128 Ltmp35-Lfunc_begin1            ;     jumps to Ltmp35
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp21-Lfunc_begin1            ; >> Call Site 20 <<
	.uleb128 Ltmp22-Ltmp21                  ;   Call between Ltmp21 and Ltmp22
	.uleb128 Ltmp23-Lfunc_begin1            ;     jumps to Ltmp23
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp22-Lfunc_begin1            ; >> Call Site 21 <<
	.uleb128 Ltmp3-Ltmp22                   ;   Call between Ltmp22 and Ltmp3
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp3-Lfunc_begin1             ; >> Call Site 22 <<
	.uleb128 Ltmp4-Ltmp3                    ;   Call between Ltmp3 and Ltmp4
	.uleb128 Ltmp5-Lfunc_begin1             ;     jumps to Ltmp5
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp6-Lfunc_begin1             ; >> Call Site 23 <<
	.uleb128 Ltmp7-Ltmp6                    ;   Call between Ltmp6 and Ltmp7
	.uleb128 Ltmp8-Lfunc_begin1             ;     jumps to Ltmp8
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp12-Lfunc_begin1            ; >> Call Site 24 <<
	.uleb128 Ltmp13-Ltmp12                  ;   Call between Ltmp12 and Ltmp13
	.uleb128 Ltmp14-Lfunc_begin1            ;     jumps to Ltmp14
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp13-Lfunc_begin1            ; >> Call Site 25 <<
	.uleb128 Ltmp51-Ltmp13                  ;   Call between Ltmp13 and Ltmp51
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp51-Lfunc_begin1            ; >> Call Site 26 <<
	.uleb128 Ltmp52-Ltmp51                  ;   Call between Ltmp51 and Ltmp52
	.uleb128 Ltmp77-Lfunc_begin1            ;     jumps to Ltmp77
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp52-Lfunc_begin1            ; >> Call Site 27 <<
	.uleb128 Ltmp53-Ltmp52                  ;   Call between Ltmp52 and Ltmp53
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp53-Lfunc_begin1            ; >> Call Site 28 <<
	.uleb128 Ltmp54-Ltmp53                  ;   Call between Ltmp53 and Ltmp54
	.uleb128 Ltmp55-Lfunc_begin1            ;     jumps to Ltmp55
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp56-Lfunc_begin1            ; >> Call Site 29 <<
	.uleb128 Ltmp57-Ltmp56                  ;   Call between Ltmp56 and Ltmp57
	.uleb128 Ltmp58-Lfunc_begin1            ;     jumps to Ltmp58
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp57-Lfunc_begin1            ; >> Call Site 30 <<
	.uleb128 Ltmp59-Ltmp57                  ;   Call between Ltmp57 and Ltmp59
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp59-Lfunc_begin1            ; >> Call Site 31 <<
	.uleb128 Ltmp60-Ltmp59                  ;   Call between Ltmp59 and Ltmp60
	.uleb128 Ltmp77-Lfunc_begin1            ;     jumps to Ltmp77
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp60-Lfunc_begin1            ; >> Call Site 32 <<
	.uleb128 Ltmp61-Ltmp60                  ;   Call between Ltmp60 and Ltmp61
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp61-Lfunc_begin1            ; >> Call Site 33 <<
	.uleb128 Ltmp62-Ltmp61                  ;   Call between Ltmp61 and Ltmp62
	.uleb128 Ltmp63-Lfunc_begin1            ;     jumps to Ltmp63
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp64-Lfunc_begin1            ; >> Call Site 34 <<
	.uleb128 Ltmp65-Ltmp64                  ;   Call between Ltmp64 and Ltmp65
	.uleb128 Ltmp66-Lfunc_begin1            ;     jumps to Ltmp66
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp65-Lfunc_begin1            ; >> Call Site 35 <<
	.uleb128 Ltmp67-Ltmp65                  ;   Call between Ltmp65 and Ltmp67
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp67-Lfunc_begin1            ; >> Call Site 36 <<
	.uleb128 Ltmp68-Ltmp67                  ;   Call between Ltmp67 and Ltmp68
	.uleb128 Ltmp77-Lfunc_begin1            ;     jumps to Ltmp77
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp68-Lfunc_begin1            ; >> Call Site 37 <<
	.uleb128 Ltmp69-Ltmp68                  ;   Call between Ltmp68 and Ltmp69
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp69-Lfunc_begin1            ; >> Call Site 38 <<
	.uleb128 Ltmp70-Ltmp69                  ;   Call between Ltmp69 and Ltmp70
	.uleb128 Ltmp71-Lfunc_begin1            ;     jumps to Ltmp71
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp72-Lfunc_begin1            ; >> Call Site 39 <<
	.uleb128 Ltmp73-Ltmp72                  ;   Call between Ltmp72 and Ltmp73
	.uleb128 Ltmp74-Lfunc_begin1            ;     jumps to Ltmp74
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp73-Lfunc_begin1            ; >> Call Site 40 <<
	.uleb128 Ltmp75-Ltmp73                  ;   Call between Ltmp73 and Ltmp75
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp75-Lfunc_begin1            ; >> Call Site 41 <<
	.uleb128 Ltmp76-Ltmp75                  ;   Call between Ltmp75 and Ltmp76
	.uleb128 Ltmp77-Lfunc_begin1            ;     jumps to Ltmp77
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp78-Lfunc_begin1            ; >> Call Site 42 <<
	.uleb128 Ltmp87-Ltmp78                  ;   Call between Ltmp78 and Ltmp87
	.uleb128 Ltmp88-Lfunc_begin1            ;     jumps to Ltmp88
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp89-Lfunc_begin1            ; >> Call Site 43 <<
	.uleb128 Ltmp90-Ltmp89                  ;   Call between Ltmp89 and Ltmp90
	.uleb128 Ltmp91-Lfunc_begin1            ;     jumps to Ltmp91
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp90-Lfunc_begin1            ; >> Call Site 44 <<
	.uleb128 Ltmp92-Ltmp90                  ;   Call between Ltmp90 and Ltmp92
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp92-Lfunc_begin1            ; >> Call Site 45 <<
	.uleb128 Ltmp93-Ltmp92                  ;   Call between Ltmp92 and Ltmp93
	.uleb128 Ltmp94-Lfunc_begin1            ;     jumps to Ltmp94
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp93-Lfunc_begin1            ; >> Call Site 46 <<
	.uleb128 Ltmp98-Ltmp93                  ;   Call between Ltmp93 and Ltmp98
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp98-Lfunc_begin1            ; >> Call Site 47 <<
	.uleb128 Ltmp129-Ltmp98                 ;   Call between Ltmp98 and Ltmp129
	.uleb128 Ltmp130-Lfunc_begin1           ;     jumps to Ltmp130
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp153-Lfunc_begin1           ; >> Call Site 48 <<
	.uleb128 Ltmp154-Ltmp153                ;   Call between Ltmp153 and Ltmp154
	.uleb128 Ltmp155-Lfunc_begin1           ;     jumps to Ltmp155
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp131-Lfunc_begin1           ; >> Call Site 49 <<
	.uleb128 Ltmp132-Ltmp131                ;   Call between Ltmp131 and Ltmp132
	.uleb128 Ltmp133-Lfunc_begin1           ;     jumps to Ltmp133
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp156-Lfunc_begin1           ; >> Call Site 50 <<
	.uleb128 Ltmp157-Ltmp156                ;   Call between Ltmp156 and Ltmp157
	.uleb128 Ltmp158-Lfunc_begin1           ;     jumps to Ltmp158
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp157-Lfunc_begin1           ; >> Call Site 51 <<
	.uleb128 Ltmp164-Ltmp157                ;   Call between Ltmp157 and Ltmp164
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp164-Lfunc_begin1           ; >> Call Site 52 <<
	.uleb128 Ltmp165-Ltmp164                ;   Call between Ltmp164 and Ltmp165
	.uleb128 Ltmp166-Lfunc_begin1           ;     jumps to Ltmp166
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp134-Lfunc_begin1           ; >> Call Site 53 <<
	.uleb128 Ltmp135-Ltmp134                ;   Call between Ltmp134 and Ltmp135
	.uleb128 Ltmp136-Lfunc_begin1           ;     jumps to Ltmp136
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp135-Lfunc_begin1           ; >> Call Site 54 <<
	.uleb128 Ltmp142-Ltmp135                ;   Call between Ltmp135 and Ltmp142
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp142-Lfunc_begin1           ; >> Call Site 55 <<
	.uleb128 Ltmp143-Ltmp142                ;   Call between Ltmp142 and Ltmp143
	.uleb128 Ltmp144-Lfunc_begin1           ;     jumps to Ltmp144
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp167-Lfunc_begin1           ; >> Call Site 56 <<
	.uleb128 Ltmp168-Ltmp167                ;   Call between Ltmp167 and Ltmp168
	.uleb128 Ltmp169-Lfunc_begin1           ;     jumps to Ltmp169
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp168-Lfunc_begin1           ; >> Call Site 57 <<
	.uleb128 Ltmp145-Ltmp168                ;   Call between Ltmp168 and Ltmp145
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp145-Lfunc_begin1           ; >> Call Site 58 <<
	.uleb128 Ltmp146-Ltmp145                ;   Call between Ltmp145 and Ltmp146
	.uleb128 Ltmp147-Lfunc_begin1           ;     jumps to Ltmp147
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp146-Lfunc_begin1           ; >> Call Site 59 <<
	.uleb128 Ltmp175-Ltmp146                ;   Call between Ltmp146 and Ltmp175
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp175-Lfunc_begin1           ; >> Call Site 60 <<
	.uleb128 Ltmp204-Ltmp175                ;   Call between Ltmp175 and Ltmp204
	.uleb128 Ltmp205-Lfunc_begin1           ;     jumps to Ltmp205
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp95-Lfunc_begin1            ; >> Call Site 61 <<
	.uleb128 Ltmp96-Ltmp95                  ;   Call between Ltmp95 and Ltmp96
	.uleb128 Ltmp97-Lfunc_begin1            ;     jumps to Ltmp97
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp161-Lfunc_begin1           ; >> Call Site 62 <<
	.uleb128 Ltmp160-Ltmp161                ;   Call between Ltmp161 and Ltmp160
	.uleb128 Ltmp163-Lfunc_begin1           ;     jumps to Ltmp163
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp139-Lfunc_begin1           ; >> Call Site 63 <<
	.uleb128 Ltmp138-Ltmp139                ;   Call between Ltmp139 and Ltmp138
	.uleb128 Ltmp141-Lfunc_begin1           ;     jumps to Ltmp141
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp172-Lfunc_begin1           ; >> Call Site 64 <<
	.uleb128 Ltmp171-Ltmp172                ;   Call between Ltmp172 and Ltmp171
	.uleb128 Ltmp174-Lfunc_begin1           ;     jumps to Ltmp174
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp150-Lfunc_begin1           ; >> Call Site 65 <<
	.uleb128 Ltmp149-Ltmp150                ;   Call between Ltmp150 and Ltmp149
	.uleb128 Ltmp152-Lfunc_begin1           ;     jumps to Ltmp152
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp149-Lfunc_begin1           ; >> Call Site 66 <<
	.uleb128 Ltmp206-Ltmp149                ;   Call between Ltmp149 and Ltmp206
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp206-Lfunc_begin1           ; >> Call Site 67 <<
	.uleb128 Ltmp209-Ltmp206                ;   Call between Ltmp206 and Ltmp209
	.uleb128 Ltmp210-Lfunc_begin1           ;     jumps to Ltmp210
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp214-Lfunc_begin1           ; >> Call Site 68 <<
	.uleb128 Ltmp215-Ltmp214                ;   Call between Ltmp214 and Ltmp215
	.uleb128 Ltmp216-Lfunc_begin1           ;     jumps to Ltmp216
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp215-Lfunc_begin1           ; >> Call Site 69 <<
	.uleb128 Ltmp211-Ltmp215                ;   Call between Ltmp215 and Ltmp211
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp211-Lfunc_begin1           ; >> Call Site 70 <<
	.uleb128 Ltmp212-Ltmp211                ;   Call between Ltmp211 and Ltmp212
	.uleb128 Ltmp213-Lfunc_begin1           ;     jumps to Ltmp213
	.byte	9                               ;   On action: 5
	.uleb128 Ltmp212-Lfunc_begin1           ; >> Call Site 71 <<
	.uleb128 Lfunc_end1-Ltmp212             ;   Call between Ltmp212 and Lfunc_end1
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
Ltmp245:                                ; TypeInfo 2
	.long	__ZTISt16invalid_argument@GOT-Ltmp245
Ltmp246:                                ; TypeInfo 1
	.long	__ZTISt9exception@GOT-Ltmp246
Lttbase0:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__ZN8practice6scalarEPKfPamf    ; -- Begin function _ZN8practice6scalarEPKfPamf
	.weak_def_can_be_hidden	__ZN8practice6scalarEPKfPamf
	.p2align	2
__ZN8practice6scalarEPKfPamf:           ; @_ZN8practice6scalarEPKfPamf
	.cfi_startproc
; %bb.0:
	cbz	x2, LBB4_3
; %bb.1:
	movi.2d	v1, #0000000000000000
	mov	w8, #1123942400                 ; =0x42fe0000
	fmov	s2, w8
	mov	w8, #-1023541248                ; =0xc2fe0000
	fmov	s3, w8
LBB4_2:                                 ; =>This Inner Loop Header: Depth=1
	ldr	s4, [x0], #4
	fmul	s4, s0, s4
	fcmp	s4, s4
	fcsel	s4, s4, s1, vc
	fcmp	s4, s2
	fcsel	s5, s2, s4, gt
	frinta	s5, s5
	fcmp	s4, s3
	fcsel	s4, s3, s5, mi
	fcvtzs	w8, s4
	strb	w8, [x1], #1
	subs	x2, x2, #1
	b.ne	LBB4_2
LBB4_3:
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__ZN8practice4neonEPKfPamf      ; -- Begin function _ZN8practice4neonEPKfPamf
	.weak_def_can_be_hidden	__ZN8practice4neonEPKfPamf
	.p2align	2
__ZN8practice4neonEPKfPamf:             ; @_ZN8practice4neonEPKfPamf
	.cfi_startproc
; %bb.0:
                                        ; kill: def $s0 killed $s0 def $q0
	cmp	x2, #8
	b.lo	LBB5_4
; %bb.1:
	mov	x8, #0                          ; =0x0
	add	x9, x0, #16
	mov	w10, #1123942400                ; =0x42fe0000
	dup.4s	v1, w10
	mov	w10, #-1023541248               ; =0xc2fe0000
	dup.4s	v2, w10
	mov	x10, x2
LBB5_2:                                 ; =>This Inner Loop Header: Depth=1
	ldp	q3, q4, [x9, #-16]
	fmul.4s	v3, v3, v0[0]
	fcmeq.4s	v5, v3, v3
	and.16b	v3, v5, v3
	fmin.4s	v3, v3, v1
	fmax.4s	v3, v3, v2
	fcvtas.4s	v3, v3
	sqxtn.4h	v3, v3
	fmul.4s	v4, v4, v0[0]
	fcmeq.4s	v5, v4, v4
	and.16b	v4, v5, v4
	fmin.4s	v4, v4, v1
	fmax.4s	v4, v4, v2
	fcvtas.4s	v4, v4
	sqxtn2.8h	v3, v4
	sqxtn.8b	v3, v3
	str	d3, [x1, x8]
	add	x8, x8, #8
	add	x9, x9, #32
	sub	x10, x10, #8
	cmp	x10, #7
	b.hi	LBB5_2
; %bb.3:
	subs	x9, x2, x8
	b.hi	LBB5_5
	b	LBB5_11
LBB5_4:
	mov	x8, #0                          ; =0x0
	subs	x9, x2, x8
	b.ls	LBB5_11
LBB5_5:
	cmp	x9, #3
	b.ls	LBB5_8
; %bb.6:
	add	x11, x0, x8, lsl #2
	add	x10, x0, x2, lsl #2
	add	x12, x1, x8
	cmp	x12, x10
	b.hs	LBB5_12
; %bb.7:
	add	x10, x1, x2
	cmp	x11, x10
	b.hs	LBB5_12
LBB5_8:
	mov	x11, x8
LBB5_9:
	sub	x8, x2, x11
	add	x9, x1, x11
	add	x10, x0, x11, lsl #2
	movi.2d	v1, #0000000000000000
	mov	w11, #1123942400                ; =0x42fe0000
	fmov	s2, w11
	mov	w11, #-1023541248               ; =0xc2fe0000
	fmov	s3, w11
LBB5_10:                                ; =>This Inner Loop Header: Depth=1
	ldr	s4, [x10], #4
	fmul	s4, s0, s4
	fcmp	s4, s4
	fcsel	s4, s4, s1, vc
	fcmp	s4, s2
	fcsel	s5, s2, s4, gt
	frinta	s5, s5
	fcmp	s4, s3
	fcsel	s4, s3, s5, mi
	fcvtzs	w11, s4
	strb	w11, [x9], #1
	subs	x8, x8, #1
	b.ne	LBB5_10
LBB5_11:
	ret
LBB5_12:
	cmp	x9, #16
	b.hs	LBB5_14
; %bb.13:
	mov	x10, #0                         ; =0x0
	b	LBB5_18
LBB5_14:
	and	x10, x9, #0xfffffffffffffff0
	add	x11, x11, #32
	add	x12, x8, x1
	add	x12, x12, #8
	mov	w13, #-1023541248               ; =0xc2fe0000
	dup.4s	v1, w13
	mov	w13, #1123942400                ; =0x42fe0000
	dup.4s	v2, w13
	mov	x13, x10
LBB5_15:                                ; =>This Inner Loop Header: Depth=1
	ldp	q3, q4, [x11, #-32]
	ldp	q5, q6, [x11], #64
	fmul.4s	v3, v3, v0[0]
	fmul.4s	v4, v4, v0[0]
	fmul.4s	v5, v5, v0[0]
	fcmeq.4s	v7, v3, v3
	fcmeq.4s	v16, v4, v4
	fmul.4s	v6, v6, v0[0]
	fcmeq.4s	v17, v5, v5
	fcmeq.4s	v18, v6, v6
	and.16b	v3, v7, v3
	and.16b	v4, v16, v4
	and.16b	v5, v17, v5
	and.16b	v6, v18, v6
	fcmgt.4s	v7, v1, v3
	fcmgt.4s	v16, v1, v4
	fcmgt.4s	v17, v1, v5
	fcmgt.4s	v18, v3, v2
	fcmgt.4s	v19, v4, v2
	fcmgt.4s	v20, v1, v6
	fcmgt.4s	v21, v5, v2
	fcmgt.4s	v22, v6, v2
	bit.16b	v3, v2, v18
	bit.16b	v4, v2, v19
	bit.16b	v5, v2, v21
	bit.16b	v6, v2, v22
	frinta.4s	v3, v3
	frinta.4s	v4, v4
	frinta.4s	v5, v5
	bit.16b	v3, v1, v7
	bit.16b	v4, v1, v16
	frinta.4s	v6, v6
	bit.16b	v5, v1, v17
	fcvtzs.4s	v3, v3
	xtn.4h	v3, v3
	fcvtzs.4s	v4, v4
	xtn.4h	v4, v4
	bit.16b	v6, v1, v20
	fcvtzs.4s	v5, v5
	xtn.4h	v5, v5
	fcvtzs.4s	v6, v6
	uzp1.8b	v3, v3, v0
	uzp1.8b	v4, v4, v0
	xtn.4h	v6, v6
	mov.s	v3[1], v4[0]
	uzp1.8b	v4, v5, v0
	mov.s	v3[2], v4[0]
	uzp1.8b	v4, v6, v0
	mov.s	v3[3], v4[0]
	stur	q3, [x12, #-8]
	add	x12, x12, #16
	subs	x13, x13, #16
	b.ne	LBB5_15
; %bb.16:
	cmp	x9, x10
	b.eq	LBB5_11
; %bb.17:
	tst	x9, #0xc
	b.eq	LBB5_21
LBB5_18:
	and	x12, x9, #0xfffffffffffffffc
	add	x11, x8, x12
	sub	x13, x10, x12
	add	x10, x10, x8
	add	x8, x1, x10
	mov	w14, #-1023541248               ; =0xc2fe0000
	dup.4s	v1, w14
	mov	w14, #1123942400                ; =0x42fe0000
	dup.4s	v2, w14
	add	x10, x0, x10, lsl #2
LBB5_19:                                ; =>This Inner Loop Header: Depth=1
	ldr	q3, [x10], #16
	fmul.4s	v3, v3, v0[0]
	fcmeq.4s	v4, v3, v3
	and.16b	v3, v4, v3
	fcmgt.4s	v4, v1, v3
	fcmgt.4s	v5, v3, v2
	bit.16b	v3, v2, v5
	frinta.4s	v3, v3
	bit.16b	v3, v1, v4
	fcvtzs.4s	v3, v3
	xtn.4h	v3, v3
	uzp1.8b	v3, v3, v0
	st1.s	{ v3 }[0], [x8], #4
	adds	x13, x13, #4
	b.ne	LBB5_19
; %bb.20:
	cmp	x9, x12
	b.ne	LBB5_9
	b	LBB5_11
LBB5_21:
	add	x11, x8, x10
	b	LBB5_9
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
Lloh100:
	adrp	x0, l_.str.16@PAGE
Lloh101:
	add	x0, x0, l_.str.16@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh100, Lloh101
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
Ltmp217:
	mov	x1, x20
	bl	__ZNSt12length_errorC1B9nqe210106EPKc
Ltmp218:
; %bb.1:
Lloh102:
	adrp	x1, __ZTISt12length_error@GOTPAGE
Lloh103:
	ldr	x1, [x1, __ZTISt12length_error@GOTPAGEOFF]
Lloh104:
	adrp	x2, __ZNSt12length_errorD1Ev@GOTPAGE
Lloh105:
	ldr	x2, [x2, __ZNSt12length_errorD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
LBB8_2:
Ltmp219:
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x0, x20
	bl	__Unwind_Resume
	.loh AdrpLdrGot	Lloh104, Lloh105
	.loh AdrpLdrGot	Lloh102, Lloh103
Lfunc_end2:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table8:
Lexception2:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end2-Lcst_begin2
Lcst_begin2:
	.uleb128 Lfunc_begin2-Lfunc_begin2      ; >> Call Site 1 <<
	.uleb128 Ltmp217-Lfunc_begin2           ;   Call between Lfunc_begin2 and Ltmp217
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp217-Lfunc_begin2           ; >> Call Site 2 <<
	.uleb128 Ltmp218-Ltmp217                ;   Call between Ltmp217 and Ltmp218
	.uleb128 Ltmp219-Lfunc_begin2           ;     jumps to Ltmp219
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp218-Lfunc_begin2           ; >> Call Site 3 <<
	.uleb128 Lfunc_end2-Ltmp218             ;   Call between Ltmp218 and Lfunc_end2
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
Lloh106:
	adrp	x8, __ZTVSt12length_error@GOTPAGE
Lloh107:
	ldr	x8, [x8, __ZTVSt12length_error@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x0]
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
	.loh AdrpLdrGot	Lloh106, Lloh107
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
Lloh108:
	adrp	x1, __ZTISt20bad_array_new_length@GOTPAGE
Lloh109:
	ldr	x1, [x1, __ZTISt20bad_array_new_length@GOTPAGEOFF]
Lloh110:
	adrp	x2, __ZNSt20bad_array_new_lengthD1Ev@GOTPAGE
Lloh111:
	ldr	x2, [x2, __ZNSt20bad_array_new_lengthD1Ev@GOTPAGEOFF]
	bl	___cxa_throw
	.loh AdrpLdrGot	Lloh110, Lloh111
	.loh AdrpLdrGot	Lloh108, Lloh109
	.cfi_endproc
                                        ; -- End function
	.private_extern	__ZNSt3__16vectorIaNS_9allocatorIaEEE20__throw_length_errorB9nqe210106Ev ; -- Begin function _ZNSt3__16vectorIaNS_9allocatorIaEEE20__throw_length_errorB9nqe210106Ev
	.globl	__ZNSt3__16vectorIaNS_9allocatorIaEEE20__throw_length_errorB9nqe210106Ev
	.weak_def_can_be_hidden	__ZNSt3__16vectorIaNS_9allocatorIaEEE20__throw_length_errorB9nqe210106Ev
	.p2align	2
__ZNSt3__16vectorIaNS_9allocatorIaEEE20__throw_length_errorB9nqe210106Ev: ; @_ZNSt3__16vectorIaNS_9allocatorIaEEE20__throw_length_errorB9nqe210106Ev
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh112:
	adrp	x0, l_.str.16@PAGE
Lloh113:
	add	x0, x0, l_.str.16@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh112, Lloh113
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
Ltmp220:
	add	x0, sp, #8
	mov	x1, x19
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryC1ERS3_
Ltmp221:
; %bb.1:
	ldrb	w8, [sp, #8]
	cmp	w8, #1
	b.ne	LBB12_10
; %bb.2:
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
	add	x4, x19, x8
	ldr	x22, [x4, #40]
	ldr	w24, [x4, #8]
	ldr	w23, [x4, #144]
	cmn	w23, #1
	b.ne	LBB12_7
; %bb.3:
Ltmp223:
	add	x8, sp, #24
	mov	x25, x4
	mov	x0, x4
	bl	__ZNKSt3__18ios_base6getlocEv
Ltmp224:
; %bb.4:
Ltmp225:
Lloh114:
	adrp	x1, __ZNSt3__15ctypeIcE2idE@GOTPAGE
Lloh115:
	ldr	x1, [x1, __ZNSt3__15ctypeIcE2idE@GOTPAGEOFF]
	add	x0, sp, #24
	bl	__ZNKSt3__16locale9use_facetERNS0_2idE
Ltmp226:
; %bb.5:
	ldr	x8, [x0]
	ldr	x8, [x8, #56]
Ltmp227:
	mov	w1, #32                         ; =0x20
	blr	x8
Ltmp228:
; %bb.6:
	mov	x23, x0
	add	x0, sp, #24
	bl	__ZNSt3__16localeD1Ev
	mov	x4, x25
	str	w23, [x25, #144]
LBB12_7:
	mov	w8, #176                        ; =0xb0
	and	w8, w24, w8
	add	x3, x20, x21
	cmp	w8, #32
	csel	x2, x3, x20, eq
Ltmp230:
	sxtb	w5, w23
	mov	x0, x22
	mov	x1, x20
	bl	__ZNSt3__116__pad_and_outputB9nqe210106IcNS_11char_traitsIcEEEENS_19ostreambuf_iteratorIT_T0_EES6_PKS4_S8_S8_RNS_8ios_baseES4_
Ltmp231:
; %bb.8:
	cbnz	x0, LBB12_10
; %bb.9:
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
	add	x0, x19, x8
	ldr	w8, [x0, #32]
	mov	w9, #5                          ; =0x5
Ltmp233:
	orr	w1, w8, w9
	bl	__ZNSt3__18ios_base5clearEj
Ltmp234:
LBB12_10:
	add	x0, sp, #8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryD1Ev
LBB12_11:
	mov	x0, x19
	ldp	x29, x30, [sp, #96]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #80]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #64]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #48]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #112
	ret
LBB12_12:
Ltmp235:
	b	LBB12_15
LBB12_13:
Ltmp229:
	mov	x20, x0
	add	x0, sp, #24
	bl	__ZNSt3__16localeD1Ev
	b	LBB12_16
LBB12_14:
Ltmp232:
LBB12_15:
	mov	x20, x0
LBB12_16:
	add	x0, sp, #8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryD1Ev
	b	LBB12_18
LBB12_17:
Ltmp222:
	mov	x20, x0
LBB12_18:
	mov	x0, x20
	bl	___cxa_begin_catch
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
Ltmp236:
	add	x0, x19, x8
	bl	__ZNSt3__18ios_base33__set_badbit_and_consider_rethrowEv
Ltmp237:
; %bb.19:
	bl	___cxa_end_catch
	b	LBB12_11
LBB12_20:
Ltmp238:
	mov	x19, x0
Ltmp239:
	bl	___cxa_end_catch
Ltmp240:
; %bb.21:
	mov	x0, x19
	bl	__Unwind_Resume
LBB12_22:
Ltmp241:
	bl	___clang_call_terminate
	.loh AdrpLdrGot	Lloh114, Lloh115
Lfunc_end3:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table12:
Lexception3:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase1-Lttbaseref1
Lttbaseref1:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end3-Lcst_begin3
Lcst_begin3:
	.uleb128 Ltmp220-Lfunc_begin3           ; >> Call Site 1 <<
	.uleb128 Ltmp221-Ltmp220                ;   Call between Ltmp220 and Ltmp221
	.uleb128 Ltmp222-Lfunc_begin3           ;     jumps to Ltmp222
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp223-Lfunc_begin3           ; >> Call Site 2 <<
	.uleb128 Ltmp224-Ltmp223                ;   Call between Ltmp223 and Ltmp224
	.uleb128 Ltmp232-Lfunc_begin3           ;     jumps to Ltmp232
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp225-Lfunc_begin3           ; >> Call Site 3 <<
	.uleb128 Ltmp228-Ltmp225                ;   Call between Ltmp225 and Ltmp228
	.uleb128 Ltmp229-Lfunc_begin3           ;     jumps to Ltmp229
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp230-Lfunc_begin3           ; >> Call Site 4 <<
	.uleb128 Ltmp231-Ltmp230                ;   Call between Ltmp230 and Ltmp231
	.uleb128 Ltmp232-Lfunc_begin3           ;     jumps to Ltmp232
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp233-Lfunc_begin3           ; >> Call Site 5 <<
	.uleb128 Ltmp234-Ltmp233                ;   Call between Ltmp233 and Ltmp234
	.uleb128 Ltmp235-Lfunc_begin3           ;     jumps to Ltmp235
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp234-Lfunc_begin3           ; >> Call Site 6 <<
	.uleb128 Ltmp236-Ltmp234                ;   Call between Ltmp234 and Ltmp236
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp236-Lfunc_begin3           ; >> Call Site 7 <<
	.uleb128 Ltmp237-Ltmp236                ;   Call between Ltmp236 and Ltmp237
	.uleb128 Ltmp238-Lfunc_begin3           ;     jumps to Ltmp238
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp237-Lfunc_begin3           ; >> Call Site 8 <<
	.uleb128 Ltmp239-Ltmp237                ;   Call between Ltmp237 and Ltmp239
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp239-Lfunc_begin3           ; >> Call Site 9 <<
	.uleb128 Ltmp240-Ltmp239                ;   Call between Ltmp239 and Ltmp240
	.uleb128 Ltmp241-Lfunc_begin3           ;     jumps to Ltmp241
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp240-Lfunc_begin3           ; >> Call Site 10 <<
	.uleb128 Lfunc_end3-Ltmp240             ;   Call between Ltmp240 and Lfunc_end3
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
	cbz	x0, LBB13_16
; %bb.1:
	mov	x23, x5
	mov	x20, x4
	mov	x22, x3
	mov	x21, x2
	mov	x24, x1
	ldr	x26, [x4, #24]
	sub	x25, x2, x1
	cmp	x25, #1
	b.lt	LBB13_3
; %bb.2:
	ldr	x8, [x19]
	ldr	x8, [x8, #96]
	mov	x0, x19
	mov	x1, x24
	mov	x2, x25
	blr	x8
	cmp	x0, x25
	b.ne	LBB13_15
LBB13_3:
	sub	x8, x22, x24
	cmp	x26, x8
	b.le	LBB13_12
; %bb.4:
	mov	x9, #-9                         ; =0xfffffffffffffff7
	movk	x9, #32767, lsl #48
	sub	x24, x26, x8
	cmp	x24, x9
	b.hs	LBB13_17
; %bb.5:
	cmp	x24, #23
	b.hs	LBB13_7
; %bb.6:
	strb	w24, [sp, #31]
	add	x25, sp, #8
	b	LBB13_8
LBB13_7:
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
LBB13_8:
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
Ltmp242:
	mov	x0, x19
	mov	x2, x24
	blr	x8
Ltmp243:
; %bb.9:
	ldrsb	w8, [sp, #31]
	tbnz	w8, #31, LBB13_11
; %bb.10:
	cmp	x0, x24
	b.ne	LBB13_15
	b	LBB13_12
LBB13_11:
	ldr	x8, [sp, #8]
	mov	x23, x0
	mov	x0, x8
	bl	__ZdlPv
	cmp	x23, x24
	b.ne	LBB13_15
LBB13_12:
	sub	x22, x22, x21
	cmp	x22, #1
	b.lt	LBB13_14
; %bb.13:
	ldr	x8, [x19]
	ldr	x8, [x8, #96]
	mov	x0, x19
	mov	x1, x21
	mov	x2, x22
	blr	x8
	cmp	x0, x22
	b.ne	LBB13_15
LBB13_14:
	str	xzr, [x20, #24]
	b	LBB13_16
LBB13_15:
	mov	x19, #0                         ; =0x0
LBB13_16:
	mov	x0, x19
	ldp	x29, x30, [sp, #96]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #80]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #64]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #48]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #112
	ret
LBB13_17:
	bl	__ZNSt3__112basic_stringIcNS_11char_traitsIcEENS_9allocatorIcEEE20__throw_length_errorB9nqe210106Ev
LBB13_18:
Ltmp244:
	mov	x19, x0
	ldrsb	w8, [sp, #31]
	tbz	w8, #31, LBB13_20
; %bb.19:
	ldr	x0, [sp, #8]
	bl	__ZdlPv
LBB13_20:
	mov	x0, x19
	bl	__Unwind_Resume
Lfunc_end4:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table13:
Lexception4:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end4-Lcst_begin4
Lcst_begin4:
	.uleb128 Lfunc_begin4-Lfunc_begin4      ; >> Call Site 1 <<
	.uleb128 Ltmp242-Lfunc_begin4           ;   Call between Lfunc_begin4 and Ltmp242
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp242-Lfunc_begin4           ; >> Call Site 2 <<
	.uleb128 Ltmp243-Ltmp242                ;   Call between Ltmp242 and Ltmp243
	.uleb128 Ltmp244-Lfunc_begin4           ;     jumps to Ltmp244
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp243-Lfunc_begin4           ; >> Call Site 3 <<
	.uleb128 Lfunc_end4-Ltmp243             ;   Call between Ltmp243 and Lfunc_end4
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
Lloh116:
	adrp	x0, l_.str.17@PAGE
Lloh117:
	add	x0, x0, l_.str.17@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh116, Lloh117
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
Lloh118:
	adrp	x0, l_.str.16@PAGE
Lloh119:
	add	x0, x0, l_.str.16@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh118, Lloh119
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _Z7requirebPKc.cold.1
__Z7requirebPKc.cold.1:                 ; @_Z7requirebPKc.cold.1
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh120:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh121:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh122:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh123:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	bl	___cxa_throw
	.loh AdrpLdrGot	Lloh122, Lloh123
	.loh AdrpLdrGot	Lloh120, Lloh121
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__const
	.p2align	2, 0x0                          ; @constinit
l_constinit:
	.long	0                               ; 0x0
	.long	1                               ; 0x1
	.long	3                               ; 0x3
	.long	7                               ; 0x7
	.long	8                               ; 0x8
	.long	9                               ; 0x9
	.long	15                              ; 0xf
	.long	16                              ; 0x10
	.long	17                              ; 0x11
	.long	31                              ; 0x1f
	.long	65                              ; 0x41
	.long	1025                            ; 0x401

	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"guard overwritten"

l_.str.1:                               ; @.str.1
	.asciz	"scalar oracle mismatch"

l_.str.2:                               ; @.str.2
	.asciz	"neon mismatch"

l_.str.5:                               ; @.str.5
	.asciz	"PASS cases="

l_.str.6:                               ; @.str.6
	.asciz	" invalid_scales="

l_.str.7:                               ; @.str.7
	.asciz	" ties/NaN/Inf/tails/offsets/guards\n"

l_.str.8:                               ; @.str.8
	.asciz	"CPU batch_mean_us n="

l_.str.9:                               ; @.str.9
	.asciz	" repeats="

l_.str.10:                              ; @.str.10
	.asciz	" scalar_p50="

l_.str.11:                              ; @.str.11
	.asciz	" neon_p50="

l_.str.12:                              ; @.str.12
	.asciz	" scalar_p95="

l_.str.13:                              ; @.str.13
	.asciz	" neon_p95="

l_.str.14:                              ; @.str.14
	.asciz	"\n"

l_.str.15:                              ; @.str.15
	.asciz	"inverse scale must be positive and finite"

l_.str.16:                              ; @.str.16
	.asciz	"vector"

l_.str.17:                              ; @.str.17
	.asciz	"basic_string"

.subsections_via_symbols
