	.build_version macos, 26, 0	sdk_version 26, 5
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__Z4packRKNSt3__16vectorIfNS_9allocatorIfEEEEmmRS3_ ; -- Begin function _Z4packRKNSt3__16vectorIfNS_9allocatorIfEEEEmmRS3_
	.p2align	2
__Z4packRKNSt3__16vectorIfNS_9allocatorIfEEEEmmRS3_: ; @_Z4packRKNSt3__16vectorIfNS_9allocatorIfEEEEmmRS3_
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
	cmp	x2, x1
	b.lo	LBB0_20
; %bb.1:
	ldp	x9, x8, [x0]
	sub	x8, x8, x9
	asr	x8, x8, #2
	cmp	x2, x8, lsr #2
	b.hi	LBB0_20
; %bb.2:
	ldp	x9, x8, [x3]
	sub	x8, x8, x9
	asr	x8, x8, #2
	cmp	x1, x8, lsr #2
	b.hi	LBB0_20
; %bb.3:
	lsl	x8, x2, #3
	add	x9, x2, x2, lsl #1
	cmp	x1, #4
	b.hs	LBB0_5
; %bb.4:
	mov	x12, #0                         ; =0x0
	b	LBB0_7
LBB0_5:
	mov	x10, #0                         ; =0x0
	mov	x11, #0                         ; =0x0
	mov	x16, #0                         ; =0x0
	lsl	x13, x9, #2
	lsl	x14, x2, #2
	mov	x15, x8
LBB0_6:                                 ; =>This Inner Loop Header: Depth=1
	ldr	x12, [x0]
	add	x17, x12, x10
	ldr	q0, [x17]
	ldr	q1, [x17, x14]
	ldr	q2, [x12, x15]
	ldr	q3, [x12, x13]
	ldr	x12, [x3]
	add	x12, x12, x11
	st4.4s	{ v0, v1, v2, v3 }, [x12]
	add	x12, x16, #4
	add	x17, x16, #8
	add	x11, x11, #64
	add	x13, x13, #16
	add	x15, x15, #16
	add	x10, x10, #16
	mov	x16, x12
	cmp	x17, x1
	b.ls	LBB0_6
LBB0_7:
	subs	x14, x1, x12
	b.ls	LBB0_12
; %bb.8:
	ldr	x11, [x0]
	ldr	x10, [x3]
	lsl	x9, x9, #2
	cmp	x14, #16
	b.hs	LBB0_13
LBB0_9:
	mov	x14, x12
LBB0_10:
	sub	x12, x1, x14
	add	x11, x11, x14, lsl #2
	add	x10, x10, x14, lsl #4
	add	x10, x10, #8
LBB0_11:                                ; =>This Inner Loop Header: Depth=1
	ldr	s0, [x11]
	stur	s0, [x10, #-8]
	ldr	s0, [x11, x2, lsl #2]
	stur	s0, [x10, #-4]
	ldr	s0, [x11, x8]
	str	s0, [x10]
	ldr	s0, [x11, x9]
	str	s0, [x10, #4]
	add	x11, x11, #4
	add	x10, x10, #16
	subs	x12, x12, #1
	b.ne	LBB0_11
LBB0_12:
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
	ret
LBB0_13:
	add	x13, x10, x12, lsl #4
	add	x0, x10, x1, lsl #4
	lsl	x15, x12, #2
	add	x16, x11, x9
	add	x3, x16, x15
	lsl	x17, x1, #2
	add	x4, x16, x17
	add	x16, x11, x8
	add	x5, x16, x15
	add	x6, x12, x2
	add	x6, x11, x6, lsl #2
	add	x7, x2, x1
	add	x7, x11, x7, lsl #2
	add	x19, x11, x15
	add	x15, x16, x17
	cmp	x13, x15
	ccmp	x5, x0, #2, lo
	cset	w15, lo
	cmp	x13, x7
	ccmp	x6, x0, #2, lo
	cset	w16, lo
	add	x17, x11, x17
	cmp	x13, x17
	ccmp	x19, x0, #2, lo
	cset	w17, lo
	cmp	x3, x0
	ccmp	x13, x4, #2, lo
	b.lo	LBB0_9
; %bb.14:
	tbnz	w15, #0, LBB0_9
; %bb.15:
	tbnz	w16, #0, LBB0_9
; %bb.16:
	tbnz	w17, #0, LBB0_9
; %bb.17:
	and	x15, x1, #0x3
	sub	x14, x14, x15
	add	x14, x12, x14
	add	x16, x12, x15
	sub	x16, x16, x1
	add	x12, x11, x12, lsl #2
	lsl	x17, x2, #2
LBB0_18:                                ; =>This Inner Loop Header: Depth=1
	ldr	q0, [x12]
	ldr	q1, [x12, x17]
	ldr	q2, [x12, x8]
	ldr	q3, [x12, x9]
	st4.4s	{ v0, v1, v2, v3 }, [x13], #64
	add	x12, x12, #16
	adds	x16, x16, #4
	b.ne	LBB0_18
; %bb.19:
	cbnz	x15, LBB0_10
	b	LBB0_12
LBB0_20:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp0:
Lloh0:
	adrp	x1, l_.str@PAGE
Lloh1:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt16invalid_argumentC1B9nqe210106EPKc
Ltmp1:
; %bb.21:
	mov	x0, x19
	bl	__Z4packRKNSt3__16vectorIfNS_9allocatorIfEEEEmmRS3_.cold.1
LBB0_22:
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
Lloh2:
	adrp	x8, __ZTVSt16invalid_argument@GOTPAGE
Lloh3:
	ldr	x8, [x8, __ZTVSt16invalid_argument@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x0]
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
	.loh AdrpLdrGot	Lloh2, Lloh3
	.cfi_endproc
                                        ; -- End function
	.globl	_main                           ; -- Begin function main
	.p2align	2
_main:                                  ; @main
Lfunc_begin1:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception1
; %bb.0:
	sub	sp, sp, #208
	stp	x28, x27, [sp, #112]            ; 16-byte Folded Spill
	stp	x26, x25, [sp, #128]            ; 16-byte Folded Spill
	stp	x24, x23, [sp, #144]            ; 16-byte Folded Spill
	stp	x22, x21, [sp, #160]            ; 16-byte Folded Spill
	stp	x20, x19, [sp, #176]            ; 16-byte Folded Spill
	stp	x29, x30, [sp, #192]            ; 16-byte Folded Spill
	add	x29, sp, #192
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
	mov	x23, #0                         ; =0x0
	add	x8, sp, #80
	add	x8, x8, #16
	str	x8, [sp, #8]                    ; 8-byte Folded Spill
	mov	x28, #16913                     ; =0x4211
	movk	x28, #8456, lsl #16
	movk	x28, #4228, lsl #32
	movk	x28, #2114, lsl #48
	b	LBB2_2
LBB2_1:                                 ;   in Loop: Header=BB2_2 Depth=1
	add	x23, x23, #4
	cmp	x23, #28
	b.eq	LBB2_96
LBB2_2:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB2_8 Depth 2
                                        ;     Child Loop BB2_41 Depth 2
                                        ;     Child Loop BB2_45 Depth 2
                                        ;     Child Loop BB2_49 Depth 2
                                        ;     Child Loop BB2_53 Depth 2
                                        ;     Child Loop BB2_71 Depth 2
Lloh4:
	adrp	x8, l_constinit@PAGE
Lloh5:
	add	x8, x8, l_constinit@PAGEOFF
	ldrsw	x20, [x8, x23]
Ltmp3:
	add	x0, sp, #80
	mov	x1, x20
	bl	__ZN4PoolC2Em
Ltmp4:
; %bb.3:                                ;   in Loop: Header=BB2_2 Depth=1
	lsl	x27, x20, #2
	stp	xzr, xzr, [sp, #56]
	str	xzr, [sp, #72]
	cbz	w20, LBB2_10
; %bb.4:                                ;   in Loop: Header=BB2_2 Depth=1
	lsr	x8, x27, #62
	cbnz	x8, LBB2_98
; %bb.5:                                ;   in Loop: Header=BB2_2 Depth=1
	lsl	x19, x20, #4
Ltmp6:
	mov	x0, x19
	bl	__Znwm
Ltmp7:
; %bb.6:                                ;   in Loop: Header=BB2_2 Depth=1
	mov	x21, x0
	add	x8, x0, x27, lsl #2
	str	x0, [sp, #56]
	str	x8, [sp, #72]
	add	x22, x0, x19
	mov	x1, x19
	bl	_bzero
	str	x22, [sp, #64]
Ltmp9:
	mov	x0, x19
	bl	__Znwm
Ltmp10:
; %bb.7:                                ;   in Loop: Header=BB2_2 Depth=1
	mov	x22, x0
	add	x8, x0, x27, lsl #2
	str	x0, [sp, #32]
	str	x8, [sp, #48]
	add	x24, x0, x19
	mov	x1, x19
	bl	_bzero
	mov	x8, #0                          ; =0x0
	add	x9, x21, #8
	str	x24, [sp, #40]
	add	x10, x22, #8
	mov	w11, #1                         ; =0x1
	mov	w12, #2                         ; =0x2
	mov	w13, #3                         ; =0x3
LBB2_8:                                 ;   Parent Loop BB2_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	umulh	x14, x13, x28
	sub	x15, x13, x14
	add	x14, x14, x15, lsr #1
	lsr	x14, x14, #4
	sub	x14, x14, x14, lsl #5
	umulh	x15, x8, x28
	sub	x16, x8, x15
	add	x15, x15, x16, lsr #1
	lsr	x15, x15, #4
	sub	x15, x15, x15, lsl #5
	umulh	x16, x12, x28
	sub	x17, x12, x16
	add	x16, x16, x17, lsr #1
	lsr	x16, x16, #4
	umulh	x17, x11, x28
	sub	x0, x11, x17
	add	x17, x17, x0, lsr #1
	lsr	x17, x17, #4
	add	x15, x8, x15
	sub	x17, x17, x17, lsl #5
	add	x17, x8, x17
	add	x0, x17, #101
	add	x17, x17, #1
	sub	x16, x16, x16, lsl #5
	add	x16, x8, x16
	add	x1, x16, #102
	add	x16, x16, #2
	add	x14, x8, x14
	ucvtf	s0, x15
	ucvtf	s1, x17
	add	x17, x14, #3
	ucvtf	s2, x16
	ucvtf	s3, x17
	stp	s0, s1, [x9, #-8]
	add	x15, x15, #100
	ucvtf	s0, x15
	ucvtf	s1, x0
	add	x14, x14, #103
	ucvtf	s4, x1
	ucvtf	s5, x14
	stp	s2, s3, [x9], #16
	stp	s0, s1, [x10, #-8]
	stp	s4, s5, [x10], #16
	add	x8, x8, #4
	add	x13, x13, #4
	add	x12, x12, #4
	add	x11, x11, #4
	cmp	x27, x8
	b.ne	LBB2_8
; %bb.9:                                ;   in Loop: Header=BB2_2 Depth=1
	ldr	x8, [sp, #88]
	cbnz	x8, LBB2_11
	b	LBB2_12
LBB2_10:                                ;   in Loop: Header=BB2_2 Depth=1
	stp	xzr, xzr, [sp, #32]
	str	xzr, [sp, #48]
	ldr	x8, [sp, #88]
	cbz	x8, LBB2_12
LBB2_11:                                ;   in Loop: Header=BB2_2 Depth=1
	ldr	x8, [x8, #8]
	cbz	x8, LBB2_15
LBB2_12:                                ;   in Loop: Header=BB2_2 Depth=1
	ldr	x8, [sp, #104]
	cbz	x8, LBB2_14
; %bb.13:                               ;   in Loop: Header=BB2_2 Depth=1
	ldr	x8, [x8, #8]
	ldr	x19, [sp, #8]                   ; 8-byte Folded Reload
	cbz	x8, LBB2_16
LBB2_14:                                ;   in Loop: Header=BB2_2 Depth=1
	mov	x25, #0                         ; =0x0
	mov	x21, #0                         ; =0x0
	b	LBB2_19
LBB2_15:                                ;   in Loop: Header=BB2_2 Depth=1
	add	x19, sp, #80
LBB2_16:                                ;   in Loop: Header=BB2_2 Depth=1
	ldr	x3, [x19]
Ltmp15:
	add	x0, sp, #56
	mov	x1, x20
	mov	x2, x20
	bl	__Z4packRKNSt3__16vectorIfNS_9allocatorIfEEEEmmRS3_
Ltmp16:
; %bb.17:                               ;   in Loop: Header=BB2_2 Depth=1
	ldp	x25, x21, [x19]
	cbz	x21, LBB2_19
; %bb.18:                               ;   in Loop: Header=BB2_2 Depth=1
	add	x8, x21, #8
	mov	w9, #1                          ; =0x1
	ldadd	x9, x8, [x8]
LBB2_19:                                ;   in Loop: Header=BB2_2 Depth=1
	ldr	x8, [sp, #88]
	cbz	x8, LBB2_21
; %bb.20:                               ;   in Loop: Header=BB2_2 Depth=1
	ldr	x8, [x8, #8]
	cbz	x8, LBB2_23
LBB2_21:                                ;   in Loop: Header=BB2_2 Depth=1
	ldr	x8, [sp, #104]
	cbz	x8, LBB2_93
; %bb.22:                               ;   in Loop: Header=BB2_2 Depth=1
	ldr	x8, [x8, #8]
	ldr	x19, [sp, #8]                   ; 8-byte Folded Reload
	cbz	x8, LBB2_24
	b	LBB2_93
LBB2_23:                                ;   in Loop: Header=BB2_2 Depth=1
	add	x19, sp, #80
LBB2_24:                                ;   in Loop: Header=BB2_2 Depth=1
	ldr	x3, [x19]
Ltmp18:
	add	x0, sp, #32
	mov	x1, x20
	mov	x2, x20
	bl	__Z4packRKNSt3__16vectorIfNS_9allocatorIfEEEEmmRS3_
Ltmp19:
; %bb.25:                               ;   in Loop: Header=BB2_2 Depth=1
	ldp	x26, x19, [x19]
	cbz	x19, LBB2_27
; %bb.26:                               ;   in Loop: Header=BB2_2 Depth=1
	add	x8, x19, #8
	mov	w9, #1                          ; =0x1
	ldadd	x9, x8, [x8]
LBB2_27:                                ;   in Loop: Header=BB2_2 Depth=1
	cbz	x25, LBB2_94
; %bb.28:                               ;   in Loop: Header=BB2_2 Depth=1
	cbz	x26, LBB2_94
; %bb.29:                               ;   in Loop: Header=BB2_2 Depth=1
	ldr	x8, [sp, #88]
	cbz	x8, LBB2_31
; %bb.30:                               ;   in Loop: Header=BB2_2 Depth=1
	ldr	x8, [x8, #8]
	cbz	x8, LBB2_33
LBB2_31:                                ;   in Loop: Header=BB2_2 Depth=1
	ldr	x8, [sp, #104]
	cbz	x8, LBB2_39
; %bb.32:                               ;   in Loop: Header=BB2_2 Depth=1
	ldr	x8, [x8, #8]
	ldr	x22, [sp, #8]                   ; 8-byte Folded Reload
	cbnz	x8, LBB2_39
	b	LBB2_34
LBB2_33:                                ;   in Loop: Header=BB2_2 Depth=1
	add	x22, sp, #80
LBB2_34:                                ;   in Loop: Header=BB2_2 Depth=1
	ldr	x3, [x22]
Ltmp21:
	add	x0, sp, #56
	mov	x1, x20
	mov	x2, x20
	bl	__Z4packRKNSt3__16vectorIfNS_9allocatorIfEEEEmmRS3_
Ltmp22:
; %bb.35:                               ;   in Loop: Header=BB2_2 Depth=1
	ldp	x24, x22, [x22]
	cbz	x22, LBB2_37
; %bb.36:                               ;   in Loop: Header=BB2_2 Depth=1
	add	x8, x22, #8
	mov	w9, #1                          ; =0x1
	ldadd	x9, x9, [x8]
	mov	x9, #-1                         ; =0xffffffffffffffff
	ldaddal	x9, x8, [x8]
	cbz	x8, LBB2_38
LBB2_37:                                ;   in Loop: Header=BB2_2 Depth=1
	cbz	x24, LBB2_39
	b	LBB2_94
LBB2_38:                                ;   in Loop: Header=BB2_2 Depth=1
	ldr	x8, [x22]
	ldr	x8, [x8, #16]
	mov	x0, x22
	blr	x8
	mov	x0, x22
	bl	__ZNSt3__119__shared_weak_count14__release_weakEv
	cbnz	x24, LBB2_94
LBB2_39:                                ;   in Loop: Header=BB2_2 Depth=1
	cbz	w20, LBB2_56
; %bb.40:                               ;   in Loop: Header=BB2_2 Depth=1
	mov	x10, #0                         ; =0x0
	ldr	x8, [sp, #56]
	ldr	x9, [sp, #32]
	mov	x11, x20
	ldr	x12, [x25]
LBB2_41:                                ;   Parent Loop BB2_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	s0, [x12, x10, lsl #2]
	ldr	s1, [x8, x10]
	fcmp	s0, s1
	b.ne	LBB2_89
; %bb.42:                               ;   in Loop: Header=BB2_41 Depth=2
	ldr	x13, [x26]
	ldr	s0, [x13, x10, lsl #2]
	ldr	s1, [x9, x10]
	fcmp	s0, s1
	b.ne	LBB2_89
; %bb.43:                               ;   in Loop: Header=BB2_41 Depth=2
	add	x10, x10, #4
	subs	x11, x11, #1
	b.ne	LBB2_41
; %bb.44:                               ;   in Loop: Header=BB2_2 Depth=1
	mov	x10, #0                         ; =0x0
	ldr	x13, [x25]
	add	x11, x9, x27
	add	x12, x8, x27
	add	x13, x13, #4
	mov	x14, x20
LBB2_45:                                ;   Parent Loop BB2_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	s0, [x13, x10, lsl #2]
	ldr	s1, [x12, x10]
	fcmp	s0, s1
	b.ne	LBB2_89
; %bb.46:                               ;   in Loop: Header=BB2_45 Depth=2
	ldr	x15, [x26]
	add	x15, x15, x10, lsl #2
	ldr	s0, [x15, #4]
	ldr	s1, [x11, x10]
	fcmp	s0, s1
	b.ne	LBB2_89
; %bb.47:                               ;   in Loop: Header=BB2_45 Depth=2
	add	x10, x10, #4
	subs	x14, x14, #1
	b.ne	LBB2_45
; %bb.48:                               ;   in Loop: Header=BB2_2 Depth=1
	mov	x10, #0                         ; =0x0
	lsl	x12, x20, #3
	ldr	x13, [x25]
	add	x11, x9, x12
	add	x12, x8, x12
	add	x13, x13, #8
	mov	x14, x20
LBB2_49:                                ;   Parent Loop BB2_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	s0, [x13, x10, lsl #2]
	ldr	s1, [x12, x10]
	fcmp	s0, s1
	b.ne	LBB2_89
; %bb.50:                               ;   in Loop: Header=BB2_49 Depth=2
	ldr	x15, [x26]
	add	x15, x15, x10, lsl #2
	ldr	s0, [x15, #8]
	ldr	s1, [x11, x10]
	fcmp	s0, s1
	b.ne	LBB2_89
; %bb.51:                               ;   in Loop: Header=BB2_49 Depth=2
	add	x10, x10, #4
	subs	x14, x14, #1
	b.ne	LBB2_49
; %bb.52:                               ;   in Loop: Header=BB2_2 Depth=1
	mov	x10, #0                         ; =0x0
	add	x11, x20, x20, lsl #1
	lsl	x11, x11, #2
	ldr	x12, [x25]
	add	x9, x9, x11
	add	x8, x8, x11
	add	x11, x12, #12
	mov	x12, x20
LBB2_53:                                ;   Parent Loop BB2_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	s0, [x11, x10, lsl #2]
	ldr	s1, [x8, x10]
	fcmp	s0, s1
	b.ne	LBB2_89
; %bb.54:                               ;   in Loop: Header=BB2_53 Depth=2
	ldr	x13, [x26]
	add	x13, x13, x10, lsl #2
	ldr	s0, [x13, #12]
	ldr	s1, [x9, x10]
	fcmp	s0, s1
	b.ne	LBB2_89
; %bb.55:                               ;   in Loop: Header=BB2_53 Depth=2
	add	x10, x10, #4
	subs	x12, x12, #1
	b.ne	LBB2_53
LBB2_56:                                ;   in Loop: Header=BB2_2 Depth=1
	mov	x22, #-1                        ; =0xffffffffffffffff
	cbz	x21, LBB2_58
; %bb.57:                               ;   in Loop: Header=BB2_2 Depth=1
	add	x8, x21, #8
	ldaddal	x22, x8, [x8]
	cbz	x8, LBB2_63
LBB2_58:                                ;   in Loop: Header=BB2_2 Depth=1
	ldr	x8, [sp, #88]
	cbz	x8, LBB2_60
LBB2_59:                                ;   in Loop: Header=BB2_2 Depth=1
	ldr	x8, [x8, #8]
	cbz	x8, LBB2_64
LBB2_60:                                ;   in Loop: Header=BB2_2 Depth=1
	ldr	x8, [sp, #104]
	cbz	x8, LBB2_62
; %bb.61:                               ;   in Loop: Header=BB2_2 Depth=1
	ldr	x8, [x8, #8]
	ldr	x21, [sp, #8]                   ; 8-byte Folded Reload
	cbz	x8, LBB2_65
LBB2_62:                                ;   in Loop: Header=BB2_2 Depth=1
	mov	x20, #0                         ; =0x0
	mov	x9, #0                          ; =0x0
	stp	xzr, xzr, [sp, #16]
	b	LBB2_68
LBB2_63:                                ;   in Loop: Header=BB2_2 Depth=1
	ldr	x8, [x21]
	ldr	x8, [x8, #16]
	mov	x0, x21
	blr	x8
	mov	x0, x21
	bl	__ZNSt3__119__shared_weak_count14__release_weakEv
	ldr	x8, [sp, #88]
	cbnz	x8, LBB2_59
	b	LBB2_60
LBB2_64:                                ;   in Loop: Header=BB2_2 Depth=1
	add	x21, sp, #80
LBB2_65:                                ;   in Loop: Header=BB2_2 Depth=1
	ldr	x3, [x21]
Ltmp30:
	add	x0, sp, #32
	mov	x1, x20
	mov	x2, x20
	bl	__Z4packRKNSt3__16vectorIfNS_9allocatorIfEEEEmmRS3_
Ltmp31:
; %bb.66:                               ;   in Loop: Header=BB2_2 Depth=1
	ldr	x20, [x21, #8]
	ldr	q0, [x21]
	str	q0, [sp, #16]
	fmov	x9, d0
	cbz	x20, LBB2_68
; %bb.67:                               ;   in Loop: Header=BB2_2 Depth=1
	add	x8, x20, #8
	mov	w10, #1                         ; =0x1
	ldadd	x10, x8, [x8]
LBB2_68:                                ;   in Loop: Header=BB2_2 Depth=1
	cmp	x9, x25
	b.ne	LBB2_91
; %bb.69:                               ;   in Loop: Header=BB2_2 Depth=1
	ldp	x9, x8, [x9]
	sub	x11, x8, x9
	ldp	x10, x12, [x26]
	sub	x12, x12, x10
	cmp	x11, x12
	b.ne	LBB2_91
; %bb.70:                               ;   in Loop: Header=BB2_2 Depth=1
	cmp	x9, x8
	b.eq	LBB2_73
LBB2_71:                                ;   Parent Loop BB2_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	s0, [x9], #4
	ldr	s1, [x10], #4
	fcmp	s0, s1
	b.ne	LBB2_91
; %bb.72:                               ;   in Loop: Header=BB2_71 Depth=2
	cmp	x9, x8
	b.ne	LBB2_71
LBB2_73:                                ;   in Loop: Header=BB2_2 Depth=1
	cbz	x20, LBB2_75
; %bb.74:                               ;   in Loop: Header=BB2_2 Depth=1
	add	x8, x20, #8
	ldaddal	x22, x8, [x8]
	cbz	x8, LBB2_78
LBB2_75:                                ;   in Loop: Header=BB2_2 Depth=1
	cbz	x19, LBB2_79
LBB2_76:                                ;   in Loop: Header=BB2_2 Depth=1
	add	x8, x19, #8
	ldaddal	x22, x8, [x8]
	cbnz	x8, LBB2_79
; %bb.77:                               ;   in Loop: Header=BB2_2 Depth=1
	ldr	x8, [x19]
	ldr	x8, [x8, #16]
	mov	x0, x19
	blr	x8
	mov	x0, x19
	bl	__ZNSt3__119__shared_weak_count14__release_weakEv
	b	LBB2_79
LBB2_78:                                ;   in Loop: Header=BB2_2 Depth=1
	ldr	x8, [x20]
	ldr	x8, [x8, #16]
	mov	x0, x20
	blr	x8
	mov	x0, x20
	bl	__ZNSt3__119__shared_weak_count14__release_weakEv
	cbnz	x19, LBB2_76
LBB2_79:                                ;   in Loop: Header=BB2_2 Depth=1
	ldr	x0, [sp, #32]
	cbz	x0, LBB2_81
; %bb.80:                               ;   in Loop: Header=BB2_2 Depth=1
	bl	__ZdlPv
LBB2_81:                                ;   in Loop: Header=BB2_2 Depth=1
	ldr	x0, [sp, #56]
	cbz	x0, LBB2_83
; %bb.82:                               ;   in Loop: Header=BB2_2 Depth=1
	bl	__ZdlPv
LBB2_83:                                ;   in Loop: Header=BB2_2 Depth=1
	ldr	x19, [sp, #104]
	cbz	x19, LBB2_85
; %bb.84:                               ;   in Loop: Header=BB2_2 Depth=1
	add	x8, x19, #8
	ldaddal	x22, x8, [x8]
	cbz	x8, LBB2_88
LBB2_85:                                ;   in Loop: Header=BB2_2 Depth=1
	ldr	x19, [sp, #88]
	cbz	x19, LBB2_1
LBB2_86:                                ;   in Loop: Header=BB2_2 Depth=1
	add	x8, x19, #8
	ldaddal	x22, x8, [x8]
	cbnz	x8, LBB2_1
; %bb.87:                               ;   in Loop: Header=BB2_2 Depth=1
	ldr	x8, [x19]
	ldr	x8, [x8, #16]
	mov	x0, x19
	blr	x8
	mov	x0, x19
	bl	__ZNSt3__119__shared_weak_count14__release_weakEv
	b	LBB2_1
LBB2_88:                                ;   in Loop: Header=BB2_2 Depth=1
	ldr	x8, [x19]
	ldr	x8, [x8, #16]
	mov	x0, x19
	blr	x8
	mov	x0, x19
	bl	__ZNSt3__119__shared_weak_count14__release_weakEv
	ldr	x19, [sp, #88]
	cbnz	x19, LBB2_86
	b	LBB2_1
LBB2_89:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x22, x0
Ltmp24:
Lloh6:
	adrp	x1, l_.str.2@PAGE
Lloh7:
	add	x1, x1, l_.str.2@PAGEOFF
	bl	__ZNSt11logic_errorC1EPKc
Ltmp25:
; %bb.90:
Ltmp27:
Lloh8:
	adrp	x1, __ZTISt11logic_error@GOTPAGE
Lloh9:
	ldr	x1, [x1, __ZTISt11logic_error@GOTPAGEOFF]
Lloh10:
	adrp	x2, __ZNSt11logic_errorD1Ev@GOTPAGE
Lloh11:
	ldr	x2, [x2, __ZNSt11logic_errorD1Ev@GOTPAGEOFF]
	mov	x0, x22
	bl	___cxa_throw
Ltmp28:
	b	LBB2_99
LBB2_91:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x21, x0
Ltmp33:
Lloh12:
	adrp	x1, l_.str.3@PAGE
Lloh13:
	add	x1, x1, l_.str.3@PAGEOFF
	bl	__ZNSt11logic_errorC1EPKc
Ltmp34:
; %bb.92:
Ltmp36:
Lloh14:
	adrp	x1, __ZTISt11logic_error@GOTPAGE
Lloh15:
	ldr	x1, [x1, __ZTISt11logic_error@GOTPAGEOFF]
Lloh16:
	adrp	x2, __ZNSt11logic_errorD1Ev@GOTPAGE
Lloh17:
	ldr	x2, [x2, __ZNSt11logic_errorD1Ev@GOTPAGEOFF]
	mov	x0, x21
	bl	___cxa_throw
Ltmp37:
	b	LBB2_99
LBB2_93:
	mov	x19, #0                         ; =0x0
LBB2_94:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x22, x0
Ltmp64:
Lloh18:
	adrp	x1, l_.str.1@PAGE
Lloh19:
	add	x1, x1, l_.str.1@PAGEOFF
	bl	__ZNSt11logic_errorC1EPKc
Ltmp65:
; %bb.95:
Ltmp67:
Lloh20:
	adrp	x1, __ZTISt11logic_error@GOTPAGE
Lloh21:
	ldr	x1, [x1, __ZTISt11logic_error@GOTPAGEOFF]
Lloh22:
	adrp	x2, __ZNSt11logic_errorD1Ev@GOTPAGE
Lloh23:
	ldr	x2, [x2, __ZNSt11logic_errorD1Ev@GOTPAGEOFF]
	mov	x0, x22
	bl	___cxa_throw
Ltmp68:
	b	LBB2_99
LBB2_96:
	movi.2d	v0, #0000000000000000
	stp	q0, q0, [sp, #80]
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp39:
Lloh24:
	adrp	x1, l_.str.6@PAGE
Lloh25:
	add	x1, x1, l_.str.6@PAGEOFF
	bl	__ZNSt11logic_errorC2EPKc
Ltmp40:
; %bb.97:
Lloh26:
	adrp	x8, __ZTVSt16invalid_argument@GOTPAGE
Lloh27:
	ldr	x8, [x8, __ZTVSt16invalid_argument@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x19]
Ltmp42:
Lloh28:
	adrp	x1, __ZTISt16invalid_argument@GOTPAGE
Lloh29:
	ldr	x1, [x1, __ZTISt16invalid_argument@GOTPAGEOFF]
Lloh30:
	adrp	x2, __ZNSt16invalid_argumentD1Ev@GOTPAGE
Lloh31:
	ldr	x2, [x2, __ZNSt16invalid_argumentD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
Ltmp43:
	b	LBB2_99
LBB2_98:
Ltmp12:
	bl	__ZNSt3__16vectorIfNS_9allocatorIfEEE20__throw_length_errorB9nqe210106Ev
Ltmp13:
LBB2_99:
	brk	#0x1
LBB2_100:
Ltmp32:
	mov	x20, x0
	mov	x22, x1
	b	LBB2_150
LBB2_101:
Ltmp23:
	b	LBB2_152
LBB2_102:
Ltmp17:
	mov	x20, x0
	mov	x22, x1
	b	LBB2_160
LBB2_103:
Ltmp44:
	mov	x20, x0
	mov	x22, x1
	b	LBB2_105
LBB2_104:
Ltmp41:
	mov	x22, x1
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
                                        ; kill: def $w22 killed $w22 killed $x22 def $x22
LBB2_105:
	add	x0, sp, #80
	bl	__ZNSt3__15arrayINS_10shared_ptrINS_6vectorIfNS_9allocatorIfEEEEEELm2EED1Ev
	cmp	w22, #2
	b.ne	LBB2_170
; %bb.106:
	mov	x0, x20
	bl	___cxa_begin_catch
Ltmp45:
	bl	___cxa_end_catch
Ltmp46:
; %bb.107:
Ltmp48:
	add	x0, sp, #80
	mov	w1, #1                          ; =0x1
	bl	__ZN4PoolC2Em
Ltmp49:
; %bb.108:
	stp	xzr, xzr, [sp, #56]
	str	xzr, [sp, #72]
	ldr	x8, [sp, #88]
	cbz	x8, LBB2_110
; %bb.109:
	ldr	x8, [x8, #8]
	cbz	x8, LBB2_113
LBB2_110:
	ldr	x8, [sp, #104]
	cbz	x8, LBB2_118
; %bb.111:
	ldr	x8, [x8, #8]
	cbnz	x8, LBB2_118
; %bb.112:
	add	x8, sp, #80
	add	x19, x8, #16
	b	LBB2_114
LBB2_113:
	add	x19, sp, #80
LBB2_114:
	ldr	x3, [x19]
Ltmp51:
	add	x0, sp, #56
	mov	w1, #1                          ; =0x1
	mov	w2, #1                          ; =0x1
	bl	__Z4packRKNSt3__16vectorIfNS_9allocatorIfEEEEmmRS3_
Ltmp52:
; %bb.115:
	ldr	x19, [x19, #8]
	cbz	x19, LBB2_118
; %bb.116:
	add	x8, x19, #8
	mov	w9, #1                          ; =0x1
	ldadd	x9, x9, [x8]
	mov	x9, #-1                         ; =0xffffffffffffffff
	ldaddal	x9, x8, [x8]
	cbnz	x8, LBB2_118
; %bb.117:
	ldr	x8, [x19]
	ldr	x8, [x8, #16]
	mov	x0, x19
	blr	x8
	mov	x0, x19
	bl	__ZNSt3__119__shared_weak_count14__release_weakEv
LBB2_118:
	ldr	x0, [sp, #56]
	cbz	x0, LBB2_120
; %bb.119:
	bl	__ZdlPv
LBB2_120:
	ldr	x19, [sp, #104]
	cbz	x19, LBB2_123
; %bb.121:
	add	x8, x19, #8
	mov	x9, #-1                         ; =0xffffffffffffffff
	ldaddal	x9, x8, [x8]
	cbnz	x8, LBB2_123
; %bb.122:
	ldr	x8, [x19]
	ldr	x8, [x8, #16]
	mov	x0, x19
	blr	x8
	mov	x0, x19
	bl	__ZNSt3__119__shared_weak_count14__release_weakEv
LBB2_123:
	ldr	x19, [sp, #88]
	cbz	x19, LBB2_174
; %bb.124:
	add	x8, x19, #8
	mov	x9, #-1                         ; =0xffffffffffffffff
	ldaddal	x9, x8, [x8]
	cbnz	x8, LBB2_174
; %bb.125:
	ldr	x8, [x19]
	ldr	x8, [x8, #16]
	mov	x0, x19
	blr	x8
	mov	x0, x19
	bl	__ZNSt3__119__shared_weak_count14__release_weakEv
	b	LBB2_174
LBB2_126:
Ltmp53:
	mov	x19, x1
	mov	x20, x0
	add	x0, sp, #80
	bl	__ZN4PoolD1Ev
	mov	x1, x19
	b	LBB2_128
LBB2_127:
Ltmp50:
	mov	x20, x0
LBB2_128:
	cmp	w1, w22
	b.ne	LBB2_134
; %bb.129:
	mov	x0, x20
	bl	___cxa_begin_catch
Ltmp54:
	bl	___cxa_end_catch
Ltmp55:
; %bb.130:
Ltmp57:
Lloh32:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh33:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh34:
	adrp	x1, l_.str.4@PAGE
Lloh35:
	add	x1, x1, l_.str.4@PAGEOFF
	mov	w2, #5                          ; =0x5
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp58:
; %bb.131:
Ltmp59:
	mov	w1, #7                          ; =0x7
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEi
Ltmp60:
; %bb.132:
Ltmp61:
Lloh36:
	adrp	x1, l_.str.5@PAGE
Lloh37:
	add	x1, x1, l_.str.5@PAGEOFF
	mov	w2, #76                         ; =0x4c
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp62:
; %bb.133:
	mov	w0, #0                          ; =0x0
	b	LBB2_175
LBB2_134:
	mov	x22, x1
	b	LBB2_170
LBB2_135:
Ltmp63:
	mov	x22, x1
	mov	x20, x0
	b	LBB2_170
LBB2_136:
Ltmp56:
	b	LBB2_144
LBB2_137:
Ltmp47:
	b	LBB2_144
LBB2_138:
Ltmp11:
	mov	x20, x0
	mov	x22, x1
	b	LBB2_162
LBB2_139:
Ltmp8:
	b	LBB2_141
LBB2_140:
Ltmp14:
LBB2_141:
	mov	x20, x0
	mov	x22, x1
	b	LBB2_164
LBB2_142:
Ltmp20:
	mov	x20, x0
	mov	x22, x1
	b	LBB2_157
LBB2_143:
Ltmp5:
LBB2_144:
	mov	x20, x0
	mov	x22, x1
	b	LBB2_170
LBB2_145:
Ltmp69:
	b	LBB2_152
LBB2_146:
Ltmp66:
	b	LBB2_154
LBB2_147:
Ltmp38:
	mov	x20, x0
	mov	x22, x1
	b	LBB2_149
LBB2_148:
Ltmp35:
	mov	x22, x1
	mov	x20, x0
	mov	x0, x21
	bl	___cxa_free_exception
                                        ; kill: def $w22 killed $w22 killed $x22 def $x22
LBB2_149:
	add	x0, sp, #16
	bl	__ZNSt3__110shared_ptrIKNS_6vectorIfNS_9allocatorIfEEEEED1B9nqe210106Ev
LBB2_150:
	mov	x21, #0                         ; =0x0
	cbnz	x19, LBB2_155
	b	LBB2_157
LBB2_151:
Ltmp29:
LBB2_152:
	mov	x20, x0
	mov	x22, x1
	cbnz	x19, LBB2_155
	b	LBB2_157
LBB2_153:
Ltmp26:
LBB2_154:
	mov	x23, x1
	mov	x20, x0
	mov	x0, x22
	bl	___cxa_free_exception
	mov	x22, x23
	cbz	x19, LBB2_157
LBB2_155:
	add	x8, x19, #8
	mov	x9, #-1                         ; =0xffffffffffffffff
	ldaddal	x9, x8, [x8]
	cbnz	x8, LBB2_157
; %bb.156:
	ldr	x8, [x19]
	ldr	x8, [x8, #16]
	mov	x0, x19
	blr	x8
	mov	x0, x19
	bl	__ZNSt3__119__shared_weak_count14__release_weakEv
LBB2_157:
	cbz	x21, LBB2_160
; %bb.158:
	add	x8, x21, #8
	mov	x9, #-1                         ; =0xffffffffffffffff
	ldaddal	x9, x8, [x8]
	cbnz	x8, LBB2_160
; %bb.159:
	ldr	x8, [x21]
	ldr	x8, [x8, #16]
	mov	x0, x21
	blr	x8
	mov	x0, x21
	bl	__ZNSt3__119__shared_weak_count14__release_weakEv
LBB2_160:
	ldr	x0, [sp, #32]
	cbz	x0, LBB2_162
; %bb.161:
	bl	__ZdlPv
LBB2_162:
	ldr	x0, [sp, #56]
	cbz	x0, LBB2_164
; %bb.163:
	bl	__ZdlPv
LBB2_164:
	ldr	x19, [sp, #104]
	cbz	x19, LBB2_167
; %bb.165:
	add	x8, x19, #8
	mov	x9, #-1                         ; =0xffffffffffffffff
	ldaddal	x9, x8, [x8]
	cbnz	x8, LBB2_167
; %bb.166:
	ldr	x8, [x19]
	ldr	x8, [x8, #16]
	mov	x0, x19
	blr	x8
	mov	x0, x19
	bl	__ZNSt3__119__shared_weak_count14__release_weakEv
LBB2_167:
	ldr	x19, [sp, #88]
	cbz	x19, LBB2_170
; %bb.168:
	add	x8, x19, #8
	mov	x9, #-1                         ; =0xffffffffffffffff
	ldaddal	x9, x8, [x8]
	cbnz	x8, LBB2_170
; %bb.169:
	ldr	x8, [x19]
	ldr	x8, [x8, #16]
	mov	x0, x19
	blr	x8
	mov	x0, x19
	bl	__ZNSt3__119__shared_weak_count14__release_weakEv
LBB2_170:
	cmp	w22, #1
	b.ne	LBB2_177
; %bb.171:
	mov	x0, x20
	bl	___cxa_begin_catch
	ldr	x8, [x0]
	ldr	x8, [x8, #16]
	blr	x8
	mov	x19, x0
	bl	_strlen
	mov	x2, x0
Ltmp70:
Lloh38:
	adrp	x0, __ZNSt3__14cerrE@GOTPAGE
Lloh39:
	ldr	x0, [x0, __ZNSt3__14cerrE@GOTPAGEOFF]
	mov	x1, x19
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp71:
; %bb.172:
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #80]
Ltmp72:
	add	x1, sp, #80
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp73:
; %bb.173:
	bl	___cxa_end_catch
LBB2_174:
	mov	w0, #1                          ; =0x1
LBB2_175:
	ldp	x29, x30, [sp, #192]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #176]            ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #160]            ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #144]            ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #128]            ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #112]            ; 16-byte Folded Reload
	add	sp, sp, #208
	ret
LBB2_176:
Ltmp74:
	mov	x20, x0
Ltmp75:
	bl	___cxa_end_catch
Ltmp76:
LBB2_177:
	mov	x0, x20
	bl	__Unwind_Resume
LBB2_178:
Ltmp77:
	bl	___clang_call_terminate
	.loh AdrpAdd	Lloh4, Lloh5
	.loh AdrpAdd	Lloh6, Lloh7
	.loh AdrpLdrGot	Lloh10, Lloh11
	.loh AdrpLdrGot	Lloh8, Lloh9
	.loh AdrpAdd	Lloh12, Lloh13
	.loh AdrpLdrGot	Lloh16, Lloh17
	.loh AdrpLdrGot	Lloh14, Lloh15
	.loh AdrpAdd	Lloh18, Lloh19
	.loh AdrpLdrGot	Lloh22, Lloh23
	.loh AdrpLdrGot	Lloh20, Lloh21
	.loh AdrpAdd	Lloh24, Lloh25
	.loh AdrpLdrGot	Lloh30, Lloh31
	.loh AdrpLdrGot	Lloh28, Lloh29
	.loh AdrpLdrGot	Lloh26, Lloh27
	.loh AdrpAdd	Lloh34, Lloh35
	.loh AdrpLdrGot	Lloh32, Lloh33
	.loh AdrpAdd	Lloh36, Lloh37
	.loh AdrpLdrGot	Lloh38, Lloh39
Lfunc_end1:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table2:
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
	.uleb128 Ltmp6-Lfunc_begin1             ; >> Call Site 2 <<
	.uleb128 Ltmp7-Ltmp6                    ;   Call between Ltmp6 and Ltmp7
	.uleb128 Ltmp8-Lfunc_begin1             ;     jumps to Ltmp8
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp7-Lfunc_begin1             ; >> Call Site 3 <<
	.uleb128 Ltmp9-Ltmp7                    ;   Call between Ltmp7 and Ltmp9
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp9-Lfunc_begin1             ; >> Call Site 4 <<
	.uleb128 Ltmp10-Ltmp9                   ;   Call between Ltmp9 and Ltmp10
	.uleb128 Ltmp11-Lfunc_begin1            ;     jumps to Ltmp11
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp10-Lfunc_begin1            ; >> Call Site 5 <<
	.uleb128 Ltmp15-Ltmp10                  ;   Call between Ltmp10 and Ltmp15
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp15-Lfunc_begin1            ; >> Call Site 6 <<
	.uleb128 Ltmp16-Ltmp15                  ;   Call between Ltmp15 and Ltmp16
	.uleb128 Ltmp17-Lfunc_begin1            ;     jumps to Ltmp17
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp18-Lfunc_begin1            ; >> Call Site 7 <<
	.uleb128 Ltmp19-Ltmp18                  ;   Call between Ltmp18 and Ltmp19
	.uleb128 Ltmp20-Lfunc_begin1            ;     jumps to Ltmp20
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp21-Lfunc_begin1            ; >> Call Site 8 <<
	.uleb128 Ltmp22-Ltmp21                  ;   Call between Ltmp21 and Ltmp22
	.uleb128 Ltmp23-Lfunc_begin1            ;     jumps to Ltmp23
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp22-Lfunc_begin1            ; >> Call Site 9 <<
	.uleb128 Ltmp30-Ltmp22                  ;   Call between Ltmp22 and Ltmp30
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp30-Lfunc_begin1            ; >> Call Site 10 <<
	.uleb128 Ltmp31-Ltmp30                  ;   Call between Ltmp30 and Ltmp31
	.uleb128 Ltmp32-Lfunc_begin1            ;     jumps to Ltmp32
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp31-Lfunc_begin1            ; >> Call Site 11 <<
	.uleb128 Ltmp24-Ltmp31                  ;   Call between Ltmp31 and Ltmp24
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp24-Lfunc_begin1            ; >> Call Site 12 <<
	.uleb128 Ltmp25-Ltmp24                  ;   Call between Ltmp24 and Ltmp25
	.uleb128 Ltmp26-Lfunc_begin1            ;     jumps to Ltmp26
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp27-Lfunc_begin1            ; >> Call Site 13 <<
	.uleb128 Ltmp28-Ltmp27                  ;   Call between Ltmp27 and Ltmp28
	.uleb128 Ltmp29-Lfunc_begin1            ;     jumps to Ltmp29
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp28-Lfunc_begin1            ; >> Call Site 14 <<
	.uleb128 Ltmp33-Ltmp28                  ;   Call between Ltmp28 and Ltmp33
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp33-Lfunc_begin1            ; >> Call Site 15 <<
	.uleb128 Ltmp34-Ltmp33                  ;   Call between Ltmp33 and Ltmp34
	.uleb128 Ltmp35-Lfunc_begin1            ;     jumps to Ltmp35
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp36-Lfunc_begin1            ; >> Call Site 16 <<
	.uleb128 Ltmp37-Ltmp36                  ;   Call between Ltmp36 and Ltmp37
	.uleb128 Ltmp38-Lfunc_begin1            ;     jumps to Ltmp38
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp37-Lfunc_begin1            ; >> Call Site 17 <<
	.uleb128 Ltmp64-Ltmp37                  ;   Call between Ltmp37 and Ltmp64
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp64-Lfunc_begin1            ; >> Call Site 18 <<
	.uleb128 Ltmp65-Ltmp64                  ;   Call between Ltmp64 and Ltmp65
	.uleb128 Ltmp66-Lfunc_begin1            ;     jumps to Ltmp66
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp67-Lfunc_begin1            ; >> Call Site 19 <<
	.uleb128 Ltmp68-Ltmp67                  ;   Call between Ltmp67 and Ltmp68
	.uleb128 Ltmp69-Lfunc_begin1            ;     jumps to Ltmp69
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp68-Lfunc_begin1            ; >> Call Site 20 <<
	.uleb128 Ltmp39-Ltmp68                  ;   Call between Ltmp68 and Ltmp39
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp39-Lfunc_begin1            ; >> Call Site 21 <<
	.uleb128 Ltmp40-Ltmp39                  ;   Call between Ltmp39 and Ltmp40
	.uleb128 Ltmp41-Lfunc_begin1            ;     jumps to Ltmp41
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp42-Lfunc_begin1            ; >> Call Site 22 <<
	.uleb128 Ltmp43-Ltmp42                  ;   Call between Ltmp42 and Ltmp43
	.uleb128 Ltmp44-Lfunc_begin1            ;     jumps to Ltmp44
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp12-Lfunc_begin1            ; >> Call Site 23 <<
	.uleb128 Ltmp13-Ltmp12                  ;   Call between Ltmp12 and Ltmp13
	.uleb128 Ltmp14-Lfunc_begin1            ;     jumps to Ltmp14
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp13-Lfunc_begin1            ; >> Call Site 24 <<
	.uleb128 Ltmp45-Ltmp13                  ;   Call between Ltmp13 and Ltmp45
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp45-Lfunc_begin1            ; >> Call Site 25 <<
	.uleb128 Ltmp46-Ltmp45                  ;   Call between Ltmp45 and Ltmp46
	.uleb128 Ltmp47-Lfunc_begin1            ;     jumps to Ltmp47
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp48-Lfunc_begin1            ; >> Call Site 26 <<
	.uleb128 Ltmp49-Ltmp48                  ;   Call between Ltmp48 and Ltmp49
	.uleb128 Ltmp50-Lfunc_begin1            ;     jumps to Ltmp50
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp51-Lfunc_begin1            ; >> Call Site 27 <<
	.uleb128 Ltmp52-Ltmp51                  ;   Call between Ltmp51 and Ltmp52
	.uleb128 Ltmp53-Lfunc_begin1            ;     jumps to Ltmp53
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp52-Lfunc_begin1            ; >> Call Site 28 <<
	.uleb128 Ltmp54-Ltmp52                  ;   Call between Ltmp52 and Ltmp54
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp54-Lfunc_begin1            ; >> Call Site 29 <<
	.uleb128 Ltmp55-Ltmp54                  ;   Call between Ltmp54 and Ltmp55
	.uleb128 Ltmp56-Lfunc_begin1            ;     jumps to Ltmp56
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp57-Lfunc_begin1            ; >> Call Site 30 <<
	.uleb128 Ltmp62-Ltmp57                  ;   Call between Ltmp57 and Ltmp62
	.uleb128 Ltmp63-Lfunc_begin1            ;     jumps to Ltmp63
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp62-Lfunc_begin1            ; >> Call Site 31 <<
	.uleb128 Ltmp70-Ltmp62                  ;   Call between Ltmp62 and Ltmp70
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp70-Lfunc_begin1            ; >> Call Site 32 <<
	.uleb128 Ltmp73-Ltmp70                  ;   Call between Ltmp70 and Ltmp73
	.uleb128 Ltmp74-Lfunc_begin1            ;     jumps to Ltmp74
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp73-Lfunc_begin1            ; >> Call Site 33 <<
	.uleb128 Ltmp75-Ltmp73                  ;   Call between Ltmp73 and Ltmp75
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp75-Lfunc_begin1            ; >> Call Site 34 <<
	.uleb128 Ltmp76-Ltmp75                  ;   Call between Ltmp75 and Ltmp76
	.uleb128 Ltmp77-Lfunc_begin1            ;     jumps to Ltmp77
	.byte	9                               ;   On action: 5
	.uleb128 Ltmp76-Lfunc_begin1            ; >> Call Site 35 <<
	.uleb128 Lfunc_end1-Ltmp76              ;   Call between Ltmp76 and Lfunc_end1
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
	.byte	0                               ;   No further actions
	.p2align	2, 0x0
                                        ; >> Catch TypeInfos <<
	.long	0                               ; TypeInfo 3
Ltmp122:                                ; TypeInfo 2
	.long	__ZTISt16invalid_argument@GOT-Ltmp122
Ltmp123:                                ; TypeInfo 1
	.long	__ZTISt9exception@GOT-Ltmp123
Lttbase0:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.private_extern	__ZNSt3__110shared_ptrIKNS_6vectorIfNS_9allocatorIfEEEEED1B9nqe210106Ev ; -- Begin function _ZNSt3__110shared_ptrIKNS_6vectorIfNS_9allocatorIfEEEEED1B9nqe210106Ev
	.globl	__ZNSt3__110shared_ptrIKNS_6vectorIfNS_9allocatorIfEEEEED1B9nqe210106Ev
	.weak_def_can_be_hidden	__ZNSt3__110shared_ptrIKNS_6vectorIfNS_9allocatorIfEEEEED1B9nqe210106Ev
	.p2align	2
__ZNSt3__110shared_ptrIKNS_6vectorIfNS_9allocatorIfEEEEED1B9nqe210106Ev: ; @_ZNSt3__110shared_ptrIKNS_6vectorIfNS_9allocatorIfEEEEED1B9nqe210106Ev
	.cfi_startproc
; %bb.0:
	stp	x20, x19, [sp, #-32]!           ; 16-byte Folded Spill
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	ldr	x19, [x0, #8]
	cbz	x19, LBB3_3
; %bb.1:
	add	x8, x19, #8
	mov	x9, #-1                         ; =0xffffffffffffffff
	ldaddal	x9, x8, [x8]
	cbnz	x8, LBB3_3
; %bb.2:
	ldr	x8, [x19]
	ldr	x8, [x8, #16]
	mov	x20, x0
	mov	x0, x19
	blr	x8
	mov	x0, x19
	bl	__ZNSt3__119__shared_weak_count14__release_weakEv
	mov	x0, x20
LBB3_3:
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__ZN4PoolD1Ev                   ; -- Begin function _ZN4PoolD1Ev
	.weak_def_can_be_hidden	__ZN4PoolD1Ev
	.p2align	2
__ZN4PoolD1Ev:                          ; @_ZN4PoolD1Ev
	.cfi_startproc
; %bb.0:
	stp	x20, x19, [sp, #-32]!           ; 16-byte Folded Spill
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	ldr	x19, [x0, #24]
	cbz	x19, LBB4_3
; %bb.1:
	add	x8, x19, #8
	mov	x9, #-1                         ; =0xffffffffffffffff
	ldaddal	x9, x8, [x8]
	cbnz	x8, LBB4_3
; %bb.2:
	ldr	x8, [x19]
	ldr	x8, [x8, #16]
	mov	x20, x0
	mov	x0, x19
	blr	x8
	mov	x0, x19
	bl	__ZNSt3__119__shared_weak_count14__release_weakEv
	mov	x0, x20
LBB4_3:
	ldr	x19, [x0, #8]
	cbz	x19, LBB4_6
; %bb.4:
	add	x8, x19, #8
	mov	x9, #-1                         ; =0xffffffffffffffff
	ldaddal	x9, x8, [x8]
	cbnz	x8, LBB4_6
; %bb.5:
	ldr	x8, [x19]
	ldr	x8, [x8, #16]
	mov	x20, x0
	mov	x0, x19
	blr	x8
	mov	x0, x19
	bl	__ZNSt3__119__shared_weak_count14__release_weakEv
	mov	x0, x20
LBB4_6:
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
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
	.globl	__ZN4PoolC2Em                   ; -- Begin function _ZN4PoolC2Em
	.weak_def_can_be_hidden	__ZN4PoolC2Em
	.p2align	2
__ZN4PoolC2Em:                          ; @_ZN4PoolC2Em
Lfunc_begin2:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception2
; %bb.0:
	sub	sp, sp, #96
	stp	x22, x21, [sp, #48]             ; 16-byte Folded Spill
	stp	x20, x19, [sp, #64]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #80]             ; 16-byte Folded Spill
	add	x29, sp, #80
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	mov	x19, x0
	movi.2d	v0, #0000000000000000
	stp	q0, q0, [x0]
	mov	w8, #8193                       ; =0x2001
	cmp	x1, x8
	b.hi	LBB6_16
; %bb.1:
	lsl	x21, x1, #2
	str	x21, [sp, #8]
Ltmp78:
	add	x8, sp, #16
	sub	x0, x29, #33
	add	x1, sp, #8
	bl	__ZNSt3__115allocate_sharedB9nqe210106INS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEJmELi0EEENS_10shared_ptrIT_EERKT0_DpOT1_
Ltmp79:
; %bb.2:
	ldr	q0, [sp, #16]
	stp	xzr, xzr, [sp, #16]
	ldr	x20, [x19, #8]
	str	q0, [x19]
	cbz	x20, LBB6_5
; %bb.3:
	add	x8, x20, #8
	mov	x9, #-1                         ; =0xffffffffffffffff
	ldaddal	x9, x8, [x8]
	cbnz	x8, LBB6_5
; %bb.4:
	ldr	x8, [x20]
	ldr	x8, [x8, #16]
	mov	x0, x20
	blr	x8
	mov	x0, x20
	bl	__ZNSt3__119__shared_weak_count14__release_weakEv
LBB6_5:
	ldr	x20, [sp, #24]
	cbz	x20, LBB6_8
; %bb.6:
	add	x8, x20, #8
	mov	x9, #-1                         ; =0xffffffffffffffff
	ldaddal	x9, x8, [x8]
	cbnz	x8, LBB6_8
; %bb.7:
	ldr	x8, [x20]
	ldr	x8, [x8, #16]
	mov	x0, x20
	blr	x8
	mov	x0, x20
	bl	__ZNSt3__119__shared_weak_count14__release_weakEv
LBB6_8:
	str	x21, [sp, #8]
Ltmp80:
	add	x8, sp, #16
	sub	x0, x29, #33
	add	x1, sp, #8
	bl	__ZNSt3__115allocate_sharedB9nqe210106INS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEJmELi0EEENS_10shared_ptrIT_EERKT0_DpOT1_
Ltmp81:
; %bb.9:
	ldr	q0, [sp, #16]
	stp	xzr, xzr, [sp, #16]
	ldr	x20, [x19, #24]
	str	q0, [x19, #16]
	cbz	x20, LBB6_12
; %bb.10:
	add	x8, x20, #8
	mov	x9, #-1                         ; =0xffffffffffffffff
	ldaddal	x9, x8, [x8]
	cbnz	x8, LBB6_12
; %bb.11:
	ldr	x8, [x20]
	ldr	x8, [x8, #16]
	mov	x0, x20
	blr	x8
	mov	x0, x20
	bl	__ZNSt3__119__shared_weak_count14__release_weakEv
LBB6_12:
	ldr	x20, [sp, #24]
	cbz	x20, LBB6_15
; %bb.13:
	add	x8, x20, #8
	mov	x9, #-1                         ; =0xffffffffffffffff
	ldaddal	x9, x8, [x8]
	cbnz	x8, LBB6_15
; %bb.14:
	ldr	x8, [x20]
	ldr	x8, [x8, #16]
	mov	x0, x20
	blr	x8
	mov	x0, x20
	bl	__ZNSt3__119__shared_weak_count14__release_weakEv
LBB6_15:
	mov	x0, x19
	ldp	x29, x30, [sp, #80]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #64]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #48]             ; 16-byte Folded Reload
	add	sp, sp, #96
	ret
LBB6_16:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x20, x0
Ltmp83:
Lloh40:
	adrp	x1, l_.str.6@PAGE
Lloh41:
	add	x1, x1, l_.str.6@PAGEOFF
	bl	__ZNSt11logic_errorC2EPKc
Ltmp84:
; %bb.17:
Lloh42:
	adrp	x8, __ZTVSt16invalid_argument@GOTPAGE
Lloh43:
	ldr	x8, [x8, __ZTVSt16invalid_argument@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x20]
Ltmp86:
Lloh44:
	adrp	x1, __ZTISt16invalid_argument@GOTPAGE
Lloh45:
	ldr	x1, [x1, __ZTISt16invalid_argument@GOTPAGEOFF]
Lloh46:
	adrp	x2, __ZNSt16invalid_argumentD1Ev@GOTPAGE
Lloh47:
	ldr	x2, [x2, __ZNSt16invalid_argumentD1Ev@GOTPAGEOFF]
	mov	x0, x20
	bl	___cxa_throw
Ltmp87:
; %bb.18:
	brk	#0x1
LBB6_19:
Ltmp88:
	b	LBB6_22
LBB6_20:
Ltmp85:
	mov	x21, x0
	mov	x0, x20
	bl	___cxa_free_exception
	b	LBB6_23
LBB6_21:
Ltmp82:
LBB6_22:
	mov	x21, x0
LBB6_23:
	mov	x0, x19
	bl	__ZNSt3__15arrayINS_10shared_ptrINS_6vectorIfNS_9allocatorIfEEEEEELm2EED1Ev
	mov	x0, x21
	bl	__Unwind_Resume
	.loh AdrpAdd	Lloh40, Lloh41
	.loh AdrpLdrGot	Lloh46, Lloh47
	.loh AdrpLdrGot	Lloh44, Lloh45
	.loh AdrpLdrGot	Lloh42, Lloh43
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
	.uleb128 Ltmp78-Lfunc_begin2            ; >> Call Site 1 <<
	.uleb128 Ltmp79-Ltmp78                  ;   Call between Ltmp78 and Ltmp79
	.uleb128 Ltmp82-Lfunc_begin2            ;     jumps to Ltmp82
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp79-Lfunc_begin2            ; >> Call Site 2 <<
	.uleb128 Ltmp80-Ltmp79                  ;   Call between Ltmp79 and Ltmp80
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp80-Lfunc_begin2            ; >> Call Site 3 <<
	.uleb128 Ltmp81-Ltmp80                  ;   Call between Ltmp80 and Ltmp81
	.uleb128 Ltmp82-Lfunc_begin2            ;     jumps to Ltmp82
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp81-Lfunc_begin2            ; >> Call Site 4 <<
	.uleb128 Ltmp83-Ltmp81                  ;   Call between Ltmp81 and Ltmp83
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp83-Lfunc_begin2            ; >> Call Site 5 <<
	.uleb128 Ltmp84-Ltmp83                  ;   Call between Ltmp83 and Ltmp84
	.uleb128 Ltmp85-Lfunc_begin2            ;     jumps to Ltmp85
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp86-Lfunc_begin2            ; >> Call Site 6 <<
	.uleb128 Ltmp87-Ltmp86                  ;   Call between Ltmp86 and Ltmp87
	.uleb128 Ltmp88-Lfunc_begin2            ;     jumps to Ltmp88
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp87-Lfunc_begin2            ; >> Call Site 7 <<
	.uleb128 Lfunc_end2-Ltmp87              ;   Call between Ltmp87 and Lfunc_end2
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end2:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__ZNSt3__15arrayINS_10shared_ptrINS_6vectorIfNS_9allocatorIfEEEEEELm2EED1Ev ; -- Begin function _ZNSt3__15arrayINS_10shared_ptrINS_6vectorIfNS_9allocatorIfEEEEEELm2EED1Ev
	.weak_def_can_be_hidden	__ZNSt3__15arrayINS_10shared_ptrINS_6vectorIfNS_9allocatorIfEEEEEELm2EED1Ev
	.p2align	2
__ZNSt3__15arrayINS_10shared_ptrINS_6vectorIfNS_9allocatorIfEEEEEELm2EED1Ev: ; @_ZNSt3__15arrayINS_10shared_ptrINS_6vectorIfNS_9allocatorIfEEEEEELm2EED1Ev
	.cfi_startproc
; %bb.0:
	stp	x20, x19, [sp, #-32]!           ; 16-byte Folded Spill
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	ldr	x19, [x0, #24]
	cbz	x19, LBB7_3
; %bb.1:
	add	x8, x19, #8
	mov	x9, #-1                         ; =0xffffffffffffffff
	ldaddal	x9, x8, [x8]
	cbnz	x8, LBB7_3
; %bb.2:
	ldr	x8, [x19]
	ldr	x8, [x8, #16]
	mov	x20, x0
	mov	x0, x19
	blr	x8
	mov	x0, x19
	bl	__ZNSt3__119__shared_weak_count14__release_weakEv
	mov	x0, x20
LBB7_3:
	ldr	x19, [x0, #8]
	cbz	x19, LBB7_6
; %bb.4:
	add	x8, x19, #8
	mov	x9, #-1                         ; =0xffffffffffffffff
	ldaddal	x9, x8, [x8]
	cbnz	x8, LBB7_6
; %bb.5:
	ldr	x8, [x19]
	ldr	x8, [x8, #16]
	mov	x20, x0
	mov	x0, x19
	blr	x8
	mov	x0, x19
	bl	__ZNSt3__119__shared_weak_count14__release_weakEv
	mov	x0, x20
LBB7_6:
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
	ret
	.cfi_endproc
                                        ; -- End function
	.private_extern	__ZNSt3__115allocate_sharedB9nqe210106INS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEJmELi0EEENS_10shared_ptrIT_EERKT0_DpOT1_ ; -- Begin function _ZNSt3__115allocate_sharedB9nqe210106INS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEJmELi0EEENS_10shared_ptrIT_EERKT0_DpOT1_
	.globl	__ZNSt3__115allocate_sharedB9nqe210106INS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEJmELi0EEENS_10shared_ptrIT_EERKT0_DpOT1_
	.weak_def_can_be_hidden	__ZNSt3__115allocate_sharedB9nqe210106INS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEJmELi0EEENS_10shared_ptrIT_EERKT0_DpOT1_
	.p2align	2
__ZNSt3__115allocate_sharedB9nqe210106INS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEJmELi0EEENS_10shared_ptrIT_EERKT0_DpOT1_: ; @_ZNSt3__115allocate_sharedB9nqe210106INS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEJmELi0EEENS_10shared_ptrIT_EERKT0_DpOT1_
Lfunc_begin3:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception3
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
	mov	x21, x1
	mov	x20, x8
	mov	w0, #48                         ; =0x30
	bl	__Znwm
	mov	x19, x0
	str	xzr, [x0, #16]
	mov	x22, x0
	str	xzr, [x22, #24]!
Lloh48:
	adrp	x8, __ZTVNSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEEE@GOTPAGE
Lloh49:
	ldr	x8, [x8, __ZTVNSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEEE@GOTPAGEOFF]
	add	x8, x8, #16
	stp	x8, xzr, [x0]
	ldr	x23, [x21]
	stp	xzr, xzr, [x0, #32]
	cbz	x23, LBB8_4
; %bb.1:
	lsr	x8, x23, #62
	cbnz	x8, LBB8_5
; %bb.2:
	lsl	x21, x23, #2
Ltmp89:
	mov	x0, x21
	bl	__Znwm
Ltmp90:
; %bb.3:
	str	x0, [x19, #24]
	add	x8, x0, x23, lsl #2
	str	x8, [x19, #40]
	add	x23, x0, x21
	mov	x1, x21
	bl	_bzero
	str	x23, [x19, #32]
LBB8_4:
	stp	x22, x19, [x20]
	ldp	x29, x30, [sp, #48]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #32]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #16]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp], #64             ; 16-byte Folded Reload
	ret
LBB8_5:
Ltmp91:
	bl	__ZNSt3__16vectorIfNS_9allocatorIfEEE20__throw_length_errorB9nqe210106Ev
Ltmp92:
; %bb.6:
	brk	#0x1
LBB8_7:
Ltmp93:
	mov	x20, x0
	ldr	x0, [x22]
	cbz	x0, LBB8_9
; %bb.8:
	str	x0, [x19, #32]
	bl	__ZdlPv
LBB8_9:
	mov	x0, x19
	bl	__ZNSt3__119__shared_weak_countD2Ev
	bl	__ZdlPv
	mov	x0, x20
	bl	__Unwind_Resume
	.loh AdrpLdrGot	Lloh48, Lloh49
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
	.uleb128 Ltmp89-Lfunc_begin3            ;   Call between Lfunc_begin3 and Ltmp89
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp89-Lfunc_begin3            ; >> Call Site 2 <<
	.uleb128 Ltmp90-Ltmp89                  ;   Call between Ltmp89 and Ltmp90
	.uleb128 Ltmp93-Lfunc_begin3            ;     jumps to Ltmp93
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp90-Lfunc_begin3            ; >> Call Site 3 <<
	.uleb128 Ltmp91-Ltmp90                  ;   Call between Ltmp90 and Ltmp91
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp91-Lfunc_begin3            ; >> Call Site 4 <<
	.uleb128 Ltmp92-Ltmp91                  ;   Call between Ltmp91 and Ltmp92
	.uleb128 Ltmp93-Lfunc_begin3            ;     jumps to Ltmp93
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp92-Lfunc_begin3            ; >> Call Site 5 <<
	.uleb128 Lfunc_end3-Ltmp92              ;   Call between Ltmp92 and Lfunc_end3
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end3:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__ZNSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEED1Ev ; -- Begin function _ZNSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEED1Ev
	.weak_def_can_be_hidden	__ZNSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEED1Ev
	.p2align	2
__ZNSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEED1Ev: ; @_ZNSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEED1Ev
	.cfi_startproc
; %bb.0:
Lloh50:
	adrp	x8, __ZTVNSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEEE@GOTPAGE
Lloh51:
	ldr	x8, [x8, __ZTVNSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEEE@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x0]
	b	__ZNSt3__119__shared_weak_countD2Ev
	.loh AdrpLdrGot	Lloh50, Lloh51
	.cfi_endproc
                                        ; -- End function
	.globl	__ZNSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEED0Ev ; -- Begin function _ZNSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEED0Ev
	.weak_def_can_be_hidden	__ZNSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEED0Ev
	.p2align	2
__ZNSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEED0Ev: ; @_ZNSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEED0Ev
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh52:
	adrp	x8, __ZTVNSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEEE@GOTPAGE
Lloh53:
	ldr	x8, [x8, __ZTVNSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEEE@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x0]
	bl	__ZNSt3__119__shared_weak_countD2Ev
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	b	__ZdlPv
	.loh AdrpLdrGot	Lloh52, Lloh53
	.cfi_endproc
                                        ; -- End function
	.private_extern	__ZNSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEE16__on_zero_sharedEv ; -- Begin function _ZNSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEE16__on_zero_sharedEv
	.globl	__ZNSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEE16__on_zero_sharedEv
	.weak_def_can_be_hidden	__ZNSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEE16__on_zero_sharedEv
	.p2align	2
__ZNSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEE16__on_zero_sharedEv: ; @_ZNSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEE16__on_zero_sharedEv
	.cfi_startproc
; %bb.0:
	mov	x8, x0
	ldr	x0, [x0, #24]
	cbz	x0, LBB11_2
; %bb.1:
	str	x0, [x8, #32]
	b	__ZdlPv
LBB11_2:
	ret
	.cfi_endproc
                                        ; -- End function
	.private_extern	__ZNSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEE21__on_zero_shared_weakEv ; -- Begin function _ZNSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEE21__on_zero_shared_weakEv
	.globl	__ZNSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEE21__on_zero_shared_weakEv
	.weak_def_can_be_hidden	__ZNSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEE21__on_zero_shared_weakEv
	.p2align	2
__ZNSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEE21__on_zero_shared_weakEv: ; @_ZNSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEE21__on_zero_shared_weakEv
	.cfi_startproc
; %bb.0:
	b	__ZdlPv
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
Lloh54:
	adrp	x0, l_.str.7@PAGE
Lloh55:
	add	x0, x0, l_.str.7@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh54, Lloh55
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
Ltmp94:
	mov	x1, x20
	bl	__ZNSt12length_errorC1B9nqe210106EPKc
Ltmp95:
; %bb.1:
Lloh56:
	adrp	x1, __ZTISt12length_error@GOTPAGE
Lloh57:
	ldr	x1, [x1, __ZTISt12length_error@GOTPAGEOFF]
Lloh58:
	adrp	x2, __ZNSt12length_errorD1Ev@GOTPAGE
Lloh59:
	ldr	x2, [x2, __ZNSt12length_errorD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
LBB14_2:
Ltmp96:
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x0, x20
	bl	__Unwind_Resume
	.loh AdrpLdrGot	Lloh58, Lloh59
	.loh AdrpLdrGot	Lloh56, Lloh57
Lfunc_end4:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table14:
Lexception4:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end4-Lcst_begin4
Lcst_begin4:
	.uleb128 Lfunc_begin4-Lfunc_begin4      ; >> Call Site 1 <<
	.uleb128 Ltmp94-Lfunc_begin4            ;   Call between Lfunc_begin4 and Ltmp94
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp94-Lfunc_begin4            ; >> Call Site 2 <<
	.uleb128 Ltmp95-Ltmp94                  ;   Call between Ltmp94 and Ltmp95
	.uleb128 Ltmp96-Lfunc_begin4            ;     jumps to Ltmp96
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp95-Lfunc_begin4            ; >> Call Site 3 <<
	.uleb128 Lfunc_end4-Ltmp95              ;   Call between Ltmp95 and Lfunc_end4
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
Lloh60:
	adrp	x8, __ZTVSt12length_error@GOTPAGE
Lloh61:
	ldr	x8, [x8, __ZTVSt12length_error@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x0]
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
	.loh AdrpLdrGot	Lloh60, Lloh61
	.cfi_endproc
                                        ; -- End function
	.private_extern	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m ; -- Begin function _ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
	.globl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
	.weak_def_can_be_hidden	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
	.p2align	2
__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m: ; @_ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
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
	mov	x21, x2
	mov	x20, x1
	mov	x19, x0
Ltmp97:
	add	x0, sp, #8
	mov	x1, x19
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryC1ERS3_
Ltmp98:
; %bb.1:
	ldrb	w8, [sp, #8]
	cmp	w8, #1
	b.ne	LBB16_10
; %bb.2:
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
	add	x4, x19, x8
	ldr	x22, [x4, #40]
	ldr	w24, [x4, #8]
	ldr	w23, [x4, #144]
	cmn	w23, #1
	b.ne	LBB16_7
; %bb.3:
Ltmp100:
	add	x8, sp, #24
	mov	x25, x4
	mov	x0, x4
	bl	__ZNKSt3__18ios_base6getlocEv
Ltmp101:
; %bb.4:
Ltmp102:
Lloh62:
	adrp	x1, __ZNSt3__15ctypeIcE2idE@GOTPAGE
Lloh63:
	ldr	x1, [x1, __ZNSt3__15ctypeIcE2idE@GOTPAGEOFF]
	add	x0, sp, #24
	bl	__ZNKSt3__16locale9use_facetERNS0_2idE
Ltmp103:
; %bb.5:
	ldr	x8, [x0]
	ldr	x8, [x8, #56]
Ltmp104:
	mov	w1, #32                         ; =0x20
	blr	x8
Ltmp105:
; %bb.6:
	mov	x23, x0
	add	x0, sp, #24
	bl	__ZNSt3__16localeD1Ev
	mov	x4, x25
	str	w23, [x25, #144]
LBB16_7:
	mov	w8, #176                        ; =0xb0
	and	w8, w24, w8
	add	x3, x20, x21
	cmp	w8, #32
	csel	x2, x3, x20, eq
Ltmp107:
	sxtb	w5, w23
	mov	x0, x22
	mov	x1, x20
	bl	__ZNSt3__116__pad_and_outputB9nqe210106IcNS_11char_traitsIcEEEENS_19ostreambuf_iteratorIT_T0_EES6_PKS4_S8_S8_RNS_8ios_baseES4_
Ltmp108:
; %bb.8:
	cbnz	x0, LBB16_10
; %bb.9:
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
	add	x0, x19, x8
	ldr	w8, [x0, #32]
	mov	w9, #5                          ; =0x5
Ltmp110:
	orr	w1, w8, w9
	bl	__ZNSt3__18ios_base5clearEj
Ltmp111:
LBB16_10:
	add	x0, sp, #8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryD1Ev
LBB16_11:
	mov	x0, x19
	ldp	x29, x30, [sp, #96]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #80]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #64]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #48]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #112
	ret
LBB16_12:
Ltmp112:
	b	LBB16_15
LBB16_13:
Ltmp106:
	mov	x20, x0
	add	x0, sp, #24
	bl	__ZNSt3__16localeD1Ev
	b	LBB16_16
LBB16_14:
Ltmp109:
LBB16_15:
	mov	x20, x0
LBB16_16:
	add	x0, sp, #8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryD1Ev
	b	LBB16_18
LBB16_17:
Ltmp99:
	mov	x20, x0
LBB16_18:
	mov	x0, x20
	bl	___cxa_begin_catch
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
Ltmp113:
	add	x0, x19, x8
	bl	__ZNSt3__18ios_base33__set_badbit_and_consider_rethrowEv
Ltmp114:
; %bb.19:
	bl	___cxa_end_catch
	b	LBB16_11
LBB16_20:
Ltmp115:
	mov	x19, x0
Ltmp116:
	bl	___cxa_end_catch
Ltmp117:
; %bb.21:
	mov	x0, x19
	bl	__Unwind_Resume
LBB16_22:
Ltmp118:
	bl	___clang_call_terminate
	.loh AdrpLdrGot	Lloh62, Lloh63
Lfunc_end5:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table16:
Lexception5:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase1-Lttbaseref1
Lttbaseref1:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end5-Lcst_begin5
Lcst_begin5:
	.uleb128 Ltmp97-Lfunc_begin5            ; >> Call Site 1 <<
	.uleb128 Ltmp98-Ltmp97                  ;   Call between Ltmp97 and Ltmp98
	.uleb128 Ltmp99-Lfunc_begin5            ;     jumps to Ltmp99
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp100-Lfunc_begin5           ; >> Call Site 2 <<
	.uleb128 Ltmp101-Ltmp100                ;   Call between Ltmp100 and Ltmp101
	.uleb128 Ltmp109-Lfunc_begin5           ;     jumps to Ltmp109
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp102-Lfunc_begin5           ; >> Call Site 3 <<
	.uleb128 Ltmp105-Ltmp102                ;   Call between Ltmp102 and Ltmp105
	.uleb128 Ltmp106-Lfunc_begin5           ;     jumps to Ltmp106
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp107-Lfunc_begin5           ; >> Call Site 4 <<
	.uleb128 Ltmp108-Ltmp107                ;   Call between Ltmp107 and Ltmp108
	.uleb128 Ltmp109-Lfunc_begin5           ;     jumps to Ltmp109
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp110-Lfunc_begin5           ; >> Call Site 5 <<
	.uleb128 Ltmp111-Ltmp110                ;   Call between Ltmp110 and Ltmp111
	.uleb128 Ltmp112-Lfunc_begin5           ;     jumps to Ltmp112
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp111-Lfunc_begin5           ; >> Call Site 6 <<
	.uleb128 Ltmp113-Ltmp111                ;   Call between Ltmp111 and Ltmp113
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp113-Lfunc_begin5           ; >> Call Site 7 <<
	.uleb128 Ltmp114-Ltmp113                ;   Call between Ltmp113 and Ltmp114
	.uleb128 Ltmp115-Lfunc_begin5           ;     jumps to Ltmp115
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp114-Lfunc_begin5           ; >> Call Site 8 <<
	.uleb128 Ltmp116-Ltmp114                ;   Call between Ltmp114 and Ltmp116
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp116-Lfunc_begin5           ; >> Call Site 9 <<
	.uleb128 Ltmp117-Ltmp116                ;   Call between Ltmp116 and Ltmp117
	.uleb128 Ltmp118-Lfunc_begin5           ;     jumps to Ltmp118
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp117-Lfunc_begin5           ; >> Call Site 10 <<
	.uleb128 Lfunc_end5-Ltmp117             ;   Call between Ltmp117 and Lfunc_end5
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end5:
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
Lfunc_begin6:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception6
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
	cbz	x0, LBB17_16
; %bb.1:
	mov	x23, x5
	mov	x20, x4
	mov	x22, x3
	mov	x21, x2
	mov	x24, x1
	ldr	x26, [x4, #24]
	sub	x25, x2, x1
	cmp	x25, #1
	b.lt	LBB17_3
; %bb.2:
	ldr	x8, [x19]
	ldr	x8, [x8, #96]
	mov	x0, x19
	mov	x1, x24
	mov	x2, x25
	blr	x8
	cmp	x0, x25
	b.ne	LBB17_15
LBB17_3:
	sub	x8, x22, x24
	cmp	x26, x8
	b.le	LBB17_12
; %bb.4:
	mov	x9, #-9                         ; =0xfffffffffffffff7
	movk	x9, #32767, lsl #48
	sub	x24, x26, x8
	cmp	x24, x9
	b.hs	LBB17_17
; %bb.5:
	cmp	x24, #23
	b.hs	LBB17_7
; %bb.6:
	strb	w24, [sp, #31]
	add	x25, sp, #8
	b	LBB17_8
LBB17_7:
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
LBB17_8:
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
Ltmp119:
	mov	x0, x19
	mov	x2, x24
	blr	x8
Ltmp120:
; %bb.9:
	ldrsb	w8, [sp, #31]
	tbnz	w8, #31, LBB17_11
; %bb.10:
	cmp	x0, x24
	b.ne	LBB17_15
	b	LBB17_12
LBB17_11:
	ldr	x8, [sp, #8]
	mov	x23, x0
	mov	x0, x8
	bl	__ZdlPv
	mov	x0, x23
	cmp	x0, x24
	b.ne	LBB17_15
LBB17_12:
	sub	x22, x22, x21
	cmp	x22, #1
	b.lt	LBB17_14
; %bb.13:
	ldr	x8, [x19]
	ldr	x8, [x8, #96]
	mov	x0, x19
	mov	x1, x21
	mov	x2, x22
	blr	x8
	cmp	x0, x22
	b.ne	LBB17_15
LBB17_14:
	str	xzr, [x20, #24]
	b	LBB17_16
LBB17_15:
	mov	x19, #0                         ; =0x0
LBB17_16:
	mov	x0, x19
	ldp	x29, x30, [sp, #96]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #80]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #64]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #48]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #112
	ret
LBB17_17:
	bl	__ZNSt3__112basic_stringIcNS_11char_traitsIcEENS_9allocatorIcEEE20__throw_length_errorB9nqe210106Ev
LBB17_18:
Ltmp121:
	mov	x19, x0
	ldrsb	w8, [sp, #31]
	tbz	w8, #31, LBB17_20
; %bb.19:
	ldr	x0, [sp, #8]
	bl	__ZdlPv
LBB17_20:
	mov	x0, x19
	bl	__Unwind_Resume
Lfunc_end6:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table17:
Lexception6:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end6-Lcst_begin6
Lcst_begin6:
	.uleb128 Lfunc_begin6-Lfunc_begin6      ; >> Call Site 1 <<
	.uleb128 Ltmp119-Lfunc_begin6           ;   Call between Lfunc_begin6 and Ltmp119
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp119-Lfunc_begin6           ; >> Call Site 2 <<
	.uleb128 Ltmp120-Ltmp119                ;   Call between Ltmp119 and Ltmp120
	.uleb128 Ltmp121-Lfunc_begin6           ;     jumps to Ltmp121
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp120-Lfunc_begin6           ; >> Call Site 3 <<
	.uleb128 Lfunc_end6-Ltmp120             ;   Call between Ltmp120 and Lfunc_end6
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end6:
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
Lloh64:
	adrp	x0, l_.str.8@PAGE
Lloh65:
	add	x0, x0, l_.str.8@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh64, Lloh65
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _Z4packRKNSt3__16vectorIfNS_9allocatorIfEEEEmmRS3_.cold.1
__Z4packRKNSt3__16vectorIfNS_9allocatorIfEEEEmmRS3_.cold.1: ; @_Z4packRKNSt3__16vectorIfNS_9allocatorIfEEEEmmRS3_.cold.1
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh66:
	adrp	x1, __ZTISt16invalid_argument@GOTPAGE
Lloh67:
	ldr	x1, [x1, __ZTISt16invalid_argument@GOTPAGEOFF]
Lloh68:
	adrp	x2, __ZNSt16invalid_argumentD1Ev@GOTPAGE
Lloh69:
	ldr	x2, [x2, __ZNSt16invalid_argumentD1Ev@GOTPAGEOFF]
	bl	___cxa_throw
	.loh AdrpLdrGot	Lloh68, Lloh69
	.loh AdrpLdrGot	Lloh66, Lloh67
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"short buffer"

	.section	__TEXT,__const
	.p2align	2, 0x0                          ; @constinit
l_constinit:
	.long	0                               ; 0x0
	.long	1                               ; 0x1
	.long	3                               ; 0x3
	.long	4                               ; 0x4
	.long	5                               ; 0x5
	.long	17                              ; 0x11
	.long	8193                            ; 0x2001

	.section	__TEXT,__cstring,cstring_literals
l_.str.1:                               ; @.str.1
	.asciz	"capacity lease"

l_.str.2:                               ; @.str.2
	.asciz	"oracle"

l_.str.3:                               ; @.str.3
	.asciz	"reclamation"

l_.str.4:                               ; @.str.4
	.asciz	"PASS "

l_.str.5:                               ; @.str.5
	.asciz	" widths: two leases, busy rejection, reclaim, NEON oracle; 2 invalid inputs\n"

l_.str.6:                               ; @.str.6
	.asciz	"capacity"

	.section	__DATA,__const
	.globl	__ZTVNSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEEE ; @_ZTVNSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEEE
	.weak_def_can_be_hidden	__ZTVNSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEEE
	.p2align	3, 0x0
__ZTVNSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEEE:
	.quad	0
	.quad	__ZTINSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEEE
	.quad	__ZNSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEED1Ev
	.quad	__ZNSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEED0Ev
	.quad	__ZNSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEE16__on_zero_sharedEv
	.quad	__ZNKSt3__119__shared_weak_count13__get_deleterERKSt9type_info
	.quad	__ZNSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEE21__on_zero_shared_weakEv

	.private_extern	__ZTINSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEEE ; @_ZTINSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEEE
	.globl	__ZTINSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEEE
	.weak_definition	__ZTINSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEEE
	.p2align	3, 0x0
__ZTINSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEEE:
	.quad	__ZTVN10__cxxabiv120__si_class_type_infoE+16
	.quad	__ZTSNSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEEE-9223372036854775808
	.quad	__ZTINSt3__119__shared_weak_countE

	.private_extern	__ZTSNSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEEE ; @_ZTSNSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEEE
	.section	__TEXT,__const
	.globl	__ZTSNSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEEE
	.weak_definition	__ZTSNSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEEE
__ZTSNSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEEE:
	.asciz	"NSt3__120__shared_ptr_emplaceINS_6vectorIfNS_9allocatorIfEEEENS2_IS4_EEEE"

	.section	__TEXT,__cstring,cstring_literals
l_.str.7:                               ; @.str.7
	.asciz	"vector"

l_.str.8:                               ; @.str.8
	.asciz	"basic_string"

.subsections_via_symbols
