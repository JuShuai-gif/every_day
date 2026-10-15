	.build_version macos, 26, 0	sdk_version 26, 5
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__Z7requireb                    ; -- Begin function _Z7requireb
	.p2align	2
__Z7requireb:                           ; @_Z7requireb
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
	bl	__Z7requireb.cold.1
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
	.globl	__Z4packRKNSt3__16vectorIfNS_9allocatorIfEEEEii ; -- Begin function _Z4packRKNSt3__16vectorIfNS_9allocatorIfEEEEii
	.p2align	2
__Z4packRKNSt3__16vectorIfNS_9allocatorIfEEEEii: ; @_Z4packRKNSt3__16vectorIfNS_9allocatorIfEEEEii
Lfunc_begin1:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception1
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
	cmp	w1, #1
	b.lt	LBB1_13
; %bb.1:
	subs	w22, w2, #1
	b.lt	LBB1_13
; %bb.2:
	mov	x20, x8
	ldp	x23, x8, [x0]
	sub	x8, x8, x23
	umull	x9, w2, w1
	cmp	x9, x8, asr #2
	b.ne	LBB1_13
; %bb.3:
	mov	w24, w1
	mov	w25, w2
	add	w8, w1, #3
	lsr	w8, w8, #2
	umull	x8, w25, w8
	stp	xzr, xzr, [x20]
	str	xzr, [x20, #16]
	lsl	x21, x8, #4
	mov	x0, x21
	bl	__Znwm
	mov	x19, x0
	str	x0, [x20]
	add	x26, x0, x21
	str	x26, [x20, #16]
	mov	x1, x21
	bl	_bzero
	mov	x8, #0                          ; =0x0
	str	x26, [x20, #8]
	and	x9, x25, #0x7
	and	x10, x25, #0x7ffffff8
	neg	x10, x10
	add	x11, x19, #64
	lsl	x12, x25, #4
	add	x13, x23, #16
	lsl	x14, x25, #2
	b	LBB1_5
LBB1_4:                                 ;   in Loop: Header=BB1_5 Depth=1
	add	x8, x8, #1
	add	x13, x13, x14
	add	x23, x23, x14
	cmp	x8, x24
	b.eq	LBB1_12
LBB1_5:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB1_8 Depth 2
                                        ;     Child Loop BB1_11 Depth 2
	lsr	x16, x8, #2
	ubfiz	x15, x8, #2, #2
	cmp	w22, #7
	b.hs	LBB1_7
; %bb.6:                                ;   in Loop: Header=BB1_5 Depth=1
	mov	x17, #0                         ; =0x0
	cbnz	x9, LBB1_10
	b	LBB1_4
LBB1_7:                                 ;   in Loop: Header=BB1_5 Depth=1
	mov	x17, #0                         ; =0x0
	madd	x0, x12, x16, x15
	add	x0, x11, x0
	mov	x1, x13
LBB1_8:                                 ;   Parent Loop BB1_5 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldur	s0, [x1, #-16]
	stur	s0, [x0, #-64]
	ldur	s0, [x1, #-12]
	stur	s0, [x0, #-48]
	ldur	s0, [x1, #-8]
	stur	s0, [x0, #-32]
	ldur	s0, [x1, #-4]
	stur	s0, [x0, #-16]
	ldr	s0, [x1]
	str	s0, [x0]
	ldr	s0, [x1, #4]
	str	s0, [x0, #16]
	ldr	s0, [x1, #8]
	str	s0, [x0, #32]
	ldr	s0, [x1, #12]
	str	s0, [x0, #48]
	sub	x17, x17, #8
	add	x0, x0, #128
	add	x1, x1, #32
	cmp	x10, x17
	b.ne	LBB1_8
; %bb.9:                                ;   in Loop: Header=BB1_5 Depth=1
	neg	x17, x17
	cbz	x9, LBB1_4
LBB1_10:                                ;   in Loop: Header=BB1_5 Depth=1
	mul	x16, x12, x16
	add	x16, x16, x17, lsl #4
	add	x15, x19, x15
	add	x15, x15, x16
	add	x16, x23, x17, lsl #2
	mov	x17, x9
LBB1_11:                                ;   Parent Loop BB1_5 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	s0, [x16], #4
	str	s0, [x15], #16
	subs	x17, x17, #1
	b.ne	LBB1_11
	b	LBB1_4
LBB1_12:
	ldp	x29, x30, [sp, #64]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #48]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #32]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #16]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp], #80             ; 16-byte Folded Reload
	ret
LBB1_13:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp3:
Lloh2:
	adrp	x1, l_.str.1@PAGE
Lloh3:
	add	x1, x1, l_.str.1@PAGEOFF
	bl	__ZNSt16invalid_argumentC1B9nqe210106EPKc
Ltmp4:
; %bb.14:
	mov	x0, x19
	bl	__Z4packRKNSt3__16vectorIfNS_9allocatorIfEEEEii.cold.1
LBB1_15:
Ltmp5:
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x0, x20
	bl	__Unwind_Resume
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
	.uleb128 Lfunc_end1-Ltmp4               ;   Call between Ltmp4 and Lfunc_end1
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
	.globl	__Z6scalarRKNSt3__16vectorIfNS_9allocatorIfEEEES5_RS3_iii ; -- Begin function _Z6scalarRKNSt3__16vectorIfNS_9allocatorIfEEEES5_RS3_iii
	.p2align	2
__Z6scalarRKNSt3__16vectorIfNS_9allocatorIfEEEES5_RS3_iii: ; @_Z6scalarRKNSt3__16vectorIfNS_9allocatorIfEEEES5_RS3_iii
	.cfi_startproc
; %bb.0:
                                        ; kill: def $w5 killed $w5 def $x5
                                        ; kill: def $w4 killed $w4 def $x4
	cmp	w3, #1
	b.lt	LBB3_9
; %bb.1:
	cmp	w4, #1
	b.lt	LBB3_9
; %bb.2:
	ldr	x8, [x2]
	cmp	w5, #0
	b.le	LBB3_10
; %bb.3:
	mov	x9, #0                          ; =0x0
	mov	x10, #0                         ; =0x0
	sxtw	x14, w5
	sxtw	x11, w4
	mov	w12, w3
	mov	w13, w4
	lsl	x14, x14, #2
	mov	w15, w5
LBB3_4:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB3_5 Depth 2
                                        ;       Child Loop BB3_6 Depth 3
	mov	x16, #0                         ; =0x0
	ldr	x3, [x0]
	ldr	x17, [x1]
	mul	x2, x10, x11
	add	x2, x8, x2, lsl #2
	add	x3, x3, x9
LBB3_5:                                 ;   Parent Loop BB3_4 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB3_6 Depth 3
	movi.2d	v0, #0000000000000000
	mov	x4, x15
	mov	x5, x17
	mov	x6, x3
LBB3_6:                                 ;   Parent Loop BB3_4 Depth=1
                                        ;     Parent Loop BB3_5 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	ldr	s1, [x6], #4
	ldr	s2, [x5], #4
	fmadd	s0, s1, s2, s0
	subs	x4, x4, #1
	b.ne	LBB3_6
; %bb.7:                                ;   in Loop: Header=BB3_5 Depth=2
	str	s0, [x2, x16, lsl #2]
	add	x16, x16, #1
	add	x17, x17, x14
	cmp	x16, x13
	b.ne	LBB3_5
; %bb.8:                                ;   in Loop: Header=BB3_4 Depth=1
	add	x10, x10, #1
	add	x9, x9, x14
	cmp	x10, x12
	b.ne	LBB3_4
LBB3_9:
	ret
LBB3_10:
	umull	x9, w4, w3
	lsl	x1, x9, #2
	mov	x0, x8
	b	_bzero
	.cfi_endproc
                                        ; -- End function
	.globl	__Z4neonRKNSt3__16vectorIfNS_9allocatorIfEEEES5_RS3_iiii ; -- Begin function _Z4neonRKNSt3__16vectorIfNS_9allocatorIfEEEES5_RS3_iiii
	.p2align	2
__Z4neonRKNSt3__16vectorIfNS_9allocatorIfEEEES5_RS3_iiii: ; @_Z4neonRKNSt3__16vectorIfNS_9allocatorIfEEEES5_RS3_iiii
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #272
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
                                        ; kill: def $w5 killed $w5 def $x5
	str	x2, [sp, #80]                   ; 8-byte Folded Spill
	stp	x0, x1, [sp, #56]               ; 16-byte Folded Spill
	cmp	w3, #1
	b.lt	LBB4_45
; %bb.1:
	mov	x19, x4
	subs	w8, w4, #1
	b.lt	LBB4_45
; %bb.2:
	mov	x28, x6
	sxtw	x25, w19
	cmp	w5, #1
	str	w3, [sp, #72]                   ; 4-byte Folded Spill
	b.lt	LBB4_19
; %bb.3:
	mov	x10, x28
	sxtw	x28, w5
	sbfiz	x26, x5, #4, #32
	mov	w27, w5
	cmp	w10, #2
	b.ne	LBB4_31
; %bb.4:
	mov	x12, #0                         ; =0x0
	mov	x10, #0                         ; =0x0
	mov	x13, #0                         ; =0x0
	lsl	x11, x25, #3
	lsl	x9, x25, #2
	str	x9, [sp, #8]                    ; 8-byte Folded Spill
	lsr	w8, w8, #2
	add	w14, w8, #1
	lsl	x8, x28, #3
	stp	x8, x11, [sp, #16]              ; 16-byte Folded Spill
	mov	w15, #4                         ; =0x4
	stur	x14, [x29, #-120]               ; 8-byte Folded Spill
	str	x27, [sp, #88]                  ; 8-byte Folded Spill
	b	LBB4_6
LBB4_5:                                 ;   in Loop: Header=BB4_6 Depth=1
	ldp	x13, x10, [sp, #32]             ; 16-byte Folded Reload
	add	x10, x10, #2
	add	x13, x13, #1
	ldr	x12, [sp, #48]                  ; 8-byte Folded Reload
	ldr	x8, [sp, #16]                   ; 8-byte Folded Reload
	add	x12, x12, x8
	ldr	w3, [sp, #72]                   ; 4-byte Folded Reload
	cmp	w3, w10
	b.le	LBB4_45
LBB4_6:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB4_15 Depth 2
                                        ;       Child Loop BB4_16 Depth 3
                                        ;     Child Loop BB4_9 Depth 2
                                        ;       Child Loop BB4_10 Depth 3
	ldr	x8, [sp, #24]                   ; 8-byte Folded Reload
	mul	x8, x8, x13
	ldp	x9, x11, [sp, #56]              ; 16-byte Folded Reload
	ldr	x23, [x11]
	ldr	x9, [x9]
	stp	x10, x12, [sp, #40]             ; 16-byte Folded Spill
	orr	w11, w10, #0x1
	ldr	x10, [sp, #80]                  ; 8-byte Folded Reload
	ldr	x10, [x10]
	cmp	w3, w11
	str	x13, [sp, #32]                  ; 8-byte Folded Spill
	b.le	LBB4_13
; %bb.7:                                ;   in Loop: Header=BB4_6 Depth=1
	mov	x22, #0                         ; =0x0
	mov	x20, #0                         ; =0x0
	mov	w11, #1                         ; =0x1
	bfi	x11, x13, #1, #31
	ldr	x13, [sp, #8]                   ; 8-byte Folded Reload
	madd	x11, x13, x11, x10
	add	x8, x10, x8
	stp	x8, x11, [sp, #96]              ; 16-byte Folded Spill
	add	x11, x9, x12
	b	LBB4_9
LBB4_8:                                 ;   in Loop: Header=BB4_9 Depth=2
	add	x22, x22, #4
	add	x20, x20, #1
	add	x23, x23, x26
	cmp	x20, x14
	b.eq	LBB4_5
LBB4_9:                                 ;   Parent Loop BB4_6 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB4_10 Depth 3
	lsl	x24, x20, #4
	sub	w8, w19, w20, lsl #2
	cmp	w8, #1
	csinc	w8, w8, wzr, gt
	cmp	w8, #4
	csel	w8, w8, w15, lt
	lsl	w21, w8, #2
	movi.2d	v0, #0000000000000000
	mov	x8, x27
	mov	x9, x11
	mov	x10, x23
	movi.2d	v3, #0000000000000000
LBB4_10:                                ;   Parent Loop BB4_6 Depth=1
                                        ;     Parent Loop BB4_9 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	ldr	q1, [x10], #16
	ldr	s2, [x9]
	fmla.4s	v0, v1, v2[0]
	ldr	s2, [x9, x28, lsl #2]
	fmla.4s	v3, v1, v2[0]
	add	x9, x9, #4
	subs	x8, x8, #1
	b.ne	LBB4_10
; %bb.11:                               ;   in Loop: Header=BB4_9 Depth=2
	stur	q0, [x29, #-112]
	cmp	x22, x25
	b.ge	LBB4_8
; %bb.12:                               ;   in Loop: Header=BB4_9 Depth=2
	ldr	x8, [sp, #96]                   ; 8-byte Folded Reload
	add	x0, x8, x24
	sub	x1, x29, #112
	mov	x2, x21
	mov	x27, x26
	mov	x26, x19
	mov	x19, x25
	mov	x25, x11
	str	q3, [sp, #112]                  ; 16-byte Folded Spill
	bl	_memcpy
	ldr	q0, [sp, #112]                  ; 16-byte Folded Reload
	stur	q0, [x29, #-112]
	ldr	x8, [sp, #104]                  ; 8-byte Folded Reload
	add	x0, x8, x24
	sub	x1, x29, #112
	mov	x2, x21
	bl	_memcpy
	mov	x11, x25
	mov	x25, x19
	mov	x19, x26
	mov	x26, x27
	ldr	x27, [sp, #88]                  ; 8-byte Folded Reload
	mov	w15, #4                         ; =0x4
	ldur	x14, [x29, #-120]               ; 8-byte Folded Reload
	b	LBB4_8
LBB4_13:                                ;   in Loop: Header=BB4_6 Depth=1
	mov	x20, #0                         ; =0x0
	mov	x21, #0                         ; =0x0
	add	x22, x10, x8
	add	x24, x9, x12
	b	LBB4_15
LBB4_14:                                ;   in Loop: Header=BB4_15 Depth=2
	add	x20, x20, #4
	add	x21, x21, #1
	add	x23, x23, x26
	cmp	x21, x14
	b.eq	LBB4_5
LBB4_15:                                ;   Parent Loop BB4_6 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB4_16 Depth 3
	sub	w8, w19, w21, lsl #2
	cmp	w8, #1
	csinc	w8, w8, wzr, gt
	cmp	w8, #4
	csel	w8, w8, w15, lt
	lsl	w2, w8, #2
	add	x0, x22, x21, lsl #4
	movi.2d	v0, #0000000000000000
	mov	x8, x27
	mov	x9, x24
	mov	x10, x23
LBB4_16:                                ;   Parent Loop BB4_6 Depth=1
                                        ;     Parent Loop BB4_15 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	ldr	q1, [x10], #16
	ldr	s2, [x9], #4
	fmla.4s	v0, v1, v2[0]
	subs	x8, x8, #1
	b.ne	LBB4_16
; %bb.17:                               ;   in Loop: Header=BB4_15 Depth=2
	stur	q0, [x29, #-112]
	cmp	x20, x25
	b.ge	LBB4_14
; %bb.18:                               ;   in Loop: Header=BB4_15 Depth=2
	sub	x1, x29, #112
	bl	_memcpy
	mov	w15, #4                         ; =0x4
	ldur	x14, [x29, #-120]               ; 8-byte Folded Reload
	b	LBB4_14
LBB4_19:
	cmp	w28, #2
	b.ne	LBB4_39
; %bb.20:
	mov	x20, #0                         ; =0x0
	mov	w21, #0                         ; =0x0
	lsl	x9, x25, #3
	stur	x9, [x29, #-120]                ; 8-byte Folded Spill
	lsl	x25, x25, #2
	and	x8, x8, #0xfffffffc
	add	x26, x8, #4
	mov	w27, #4                         ; =0x4
	b	LBB4_22
LBB4_21:                                ;   in Loop: Header=BB4_22 Depth=1
	add	w21, w21, #2
	ldur	x8, [x29, #-120]                ; 8-byte Folded Reload
	add	x20, x20, x8
	ldr	w3, [sp, #72]                   ; 4-byte Folded Reload
	cmp	w21, w3
	b.ge	LBB4_45
LBB4_22:                                ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB4_29 Depth 2
                                        ;     Child Loop BB4_25 Depth 2
	ldr	x8, [sp, #80]                   ; 8-byte Folded Reload
	ldr	x8, [x8]
	orr	w9, w21, #0x1
	cmp	w9, w3
	b.ge	LBB4_27
; %bb.23:                               ;   in Loop: Header=BB4_22 Depth=1
	mov	x28, #0                         ; =0x0
	add	x22, x8, x20
	mov	x24, x19
	b	LBB4_25
LBB4_24:                                ;   in Loop: Header=BB4_25 Depth=2
	sub	w24, w24, #4
	add	x22, x22, #16
	add	x28, x28, #4
	cmp	x26, x28
	b.eq	LBB4_21
LBB4_25:                                ;   Parent Loop BB4_22 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	stp	xzr, xzr, [x29, #-112]
	cmp	w19, w28
	b.le	LBB4_24
; %bb.26:                               ;   in Loop: Header=BB4_25 Depth=2
	cmp	w24, #1
	csinc	w8, w24, wzr, gt
	cmp	w8, #4
	csel	w8, w8, w27, lt
	lsl	w23, w8, #2
	sub	x1, x29, #112
	mov	x0, x22
	mov	x2, x23
	bl	_memcpy
	stp	xzr, xzr, [x29, #-112]
	add	x0, x22, x25
	sub	x1, x29, #112
	mov	x2, x23
	bl	_memcpy
	b	LBB4_24
LBB4_27:                                ;   in Loop: Header=BB4_22 Depth=1
	mov	x23, #0                         ; =0x0
	add	x22, x8, x20
	mov	x24, x19
	b	LBB4_29
LBB4_28:                                ;   in Loop: Header=BB4_29 Depth=2
	sub	w24, w24, #4
	add	x22, x22, #16
	add	x23, x23, #4
	cmp	x26, x23
	b.eq	LBB4_21
LBB4_29:                                ;   Parent Loop BB4_22 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	stp	xzr, xzr, [x29, #-112]
	cmp	w19, w23
	b.le	LBB4_28
; %bb.30:                               ;   in Loop: Header=BB4_29 Depth=2
	cmp	w24, #1
	csinc	w8, w24, wzr, gt
	cmp	w8, #4
	csel	w8, w8, w27, lt
	lsl	w2, w8, #2
	sub	x1, x29, #112
	mov	x0, x22
	bl	_memcpy
	b	LBB4_28
LBB4_31:
	mov	x11, #0                         ; =0x0
	mov	x12, #0                         ; =0x0
	mov	x13, #0                         ; =0x0
	sxtw	x9, w10
	str	x9, [sp, #96]                   ; 8-byte Folded Spill
	smull	x9, w25, w10
	lsl	x9, x9, #2
	str	x9, [sp, #72]                   ; 8-byte Folded Spill
	lsr	w8, w8, #2
	add	w23, w8, #1
	mov	w9, w3
	smull	x8, w28, w10
	lsl	x8, x8, #2
	stp	x8, x9, [sp, #40]               ; 16-byte Folded Spill
	mov	w14, #4                         ; =0x4
	b	LBB4_33
LBB4_32:                                ;   in Loop: Header=BB4_33 Depth=1
	ldp	x13, x12, [sp, #104]            ; 16-byte Folded Reload
	add	x13, x13, #1
	ldur	x11, [x29, #-120]               ; 8-byte Folded Reload
	ldr	x8, [sp, #40]                   ; 8-byte Folded Reload
	add	x11, x11, x8
	ldr	x8, [sp, #96]                   ; 8-byte Folded Reload
	add	x12, x12, x8
	ldr	x8, [sp, #48]                   ; 8-byte Folded Reload
	cmp	x12, x8
	b.ge	LBB4_45
LBB4_33:                                ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB4_35 Depth 2
                                        ;       Child Loop BB4_36 Depth 3
	stp	x13, x12, [sp, #104]            ; 16-byte Folded Spill
	mov	x28, #0                         ; =0x0
	mov	x20, #0                         ; =0x0
	ldp	x8, x9, [sp, #56]               ; 16-byte Folded Reload
	ldr	x21, [x9]
	ldr	x8, [x8]
	ldp	x10, x9, [sp, #72]              ; 16-byte Folded Reload
	ldr	x9, [x9]
	madd	x22, x10, x13, x9
	stur	x11, [x29, #-120]               ; 8-byte Folded Spill
	add	x24, x8, x11
	b	LBB4_35
LBB4_34:                                ;   in Loop: Header=BB4_35 Depth=2
	add	x28, x28, #4
	add	x20, x20, #1
	add	x21, x21, x26
	cmp	x20, x23
	b.eq	LBB4_32
LBB4_35:                                ;   Parent Loop BB4_33 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB4_36 Depth 3
	sub	w8, w19, w20, lsl #2
	cmp	w8, #1
	csinc	w8, w8, wzr, gt
	cmp	w8, #4
	csel	w8, w8, w14, lt
	lsl	w2, w8, #2
	add	x0, x22, x20, lsl #4
	movi.2d	v0, #0000000000000000
	mov	x8, x27
	mov	x9, x24
	mov	x10, x21
LBB4_36:                                ;   Parent Loop BB4_33 Depth=1
                                        ;     Parent Loop BB4_35 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	ldr	q1, [x10], #16
	ldr	s2, [x9], #4
	fmla.4s	v0, v1, v2[0]
	subs	x8, x8, #1
	b.ne	LBB4_36
; %bb.37:                               ;   in Loop: Header=BB4_35 Depth=2
	stur	q0, [x29, #-112]
	cmp	x28, x25
	b.ge	LBB4_34
; %bb.38:                               ;   in Loop: Header=BB4_35 Depth=2
	sub	x1, x29, #112
	bl	_memcpy
	mov	w14, #4                         ; =0x4
	b	LBB4_34
LBB4_39:
	mov	x20, #0                         ; =0x0
	mov	w21, #0                         ; =0x0
	smull	x9, w25, w28
	lsl	x23, x9, #2
	and	x8, x8, #0xfffffffc
	add	x24, x8, #4
	mov	w25, #4                         ; =0x4
	b	LBB4_41
LBB4_40:                                ;   in Loop: Header=BB4_41 Depth=1
	add	x20, x20, x23
	add	w21, w21, w28
	ldr	w8, [sp, #72]                   ; 4-byte Folded Reload
	cmp	w21, w8
	b.ge	LBB4_45
LBB4_41:                                ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB4_43 Depth 2
	mov	x26, #0                         ; =0x0
	ldr	x8, [sp, #80]                   ; 8-byte Folded Reload
	ldr	x8, [x8]
	add	x22, x8, x20
	mov	x27, x19
	b	LBB4_43
LBB4_42:                                ;   in Loop: Header=BB4_43 Depth=2
	sub	w27, w27, #4
	add	x22, x22, #16
	add	x26, x26, #4
	cmp	x24, x26
	b.eq	LBB4_40
LBB4_43:                                ;   Parent Loop BB4_41 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	stp	xzr, xzr, [x29, #-112]
	cmp	w19, w26
	b.le	LBB4_42
; %bb.44:                               ;   in Loop: Header=BB4_43 Depth=2
	cmp	w27, #1
	csinc	w8, w27, wzr, gt
	cmp	w8, #4
	csel	w8, w8, w25, lt
	lsl	w2, w8, #2
	sub	x1, x29, #112
	mov	x0, x22
	bl	_memcpy
	b	LBB4_42
LBB4_45:
	ldp	x29, x30, [sp, #256]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #240]            ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #224]            ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #208]            ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #192]            ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #176]            ; 16-byte Folded Reload
	add	sp, sp, #272
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
	sub	sp, sp, #400
	stp	d11, d10, [sp, #272]            ; 16-byte Folded Spill
	stp	d9, d8, [sp, #288]              ; 16-byte Folded Spill
	stp	x28, x27, [sp, #304]            ; 16-byte Folded Spill
	stp	x26, x25, [sp, #320]            ; 16-byte Folded Spill
	stp	x24, x23, [sp, #336]            ; 16-byte Folded Spill
	stp	x22, x21, [sp, #352]            ; 16-byte Folded Spill
	stp	x20, x19, [sp, #368]            ; 16-byte Folded Spill
	stp	x29, x30, [sp, #384]            ; 16-byte Folded Spill
	add	x29, sp, #384
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
	mov	x11, #0                         ; =0x0
Lloh6:
	adrp	x8, ___stack_chk_guard@GOTPAGE
Lloh7:
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
Lloh8:
	ldr	x8, [x8]
	mov	x9, #1                          ; =0x1
	movk	x9, #2, lsl #32
	mov	x10, #3                         ; =0x3
	movk	x10, #8, lsl #32
	stur	x8, [x29, #-128]
	stp	x9, x10, [x29, #-144]
	fmov	s8, #1.00000000
	mov	w8, #46871                      ; =0xb717
	movk	w8, #14673, lsl #16
	fmov	s9, w8
	mov	x21, #16913                     ; =0x4211
	movk	x21, #8456, lsl #16
	movk	x21, #4228, lsl #32
	movk	x21, #2114, lsl #48
	fmov	s10, #19.00000000
	mov	x19, #17097                     ; =0x42c9
	movk	x19, #45590, lsl #16
	movk	x19, #34192, lsl #32
	movk	x19, #25644, lsl #48
	mov	w25, #23                        ; =0x17
	b	LBB5_2
LBB5_1:                                 ;   in Loop: Header=BB5_2 Depth=1
	ldr	x11, [sp]                       ; 8-byte Folded Reload
	add	x11, x11, #4
	cmp	x11, #16
	b.eq	LBB5_60
LBB5_2:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB5_4 Depth 2
                                        ;       Child Loop BB5_6 Depth 3
                                        ;         Child Loop BB5_21 Depth 4
                                        ;         Child Loop BB5_24 Depth 4
                                        ;         Child Loop BB5_31 Depth 4
                                        ;           Child Loop BB5_34 Depth 5
                                        ;           Child Loop BB5_37 Depth 5
                                        ;         Child Loop BB5_39 Depth 4
                                        ;         Child Loop BB5_42 Depth 4
	mov	x9, #0                          ; =0x0
	str	x11, [sp]                       ; 8-byte Folded Spill
	sub	x8, x29, #144
	ldr	w28, [x8, x11]
	mov	x8, #1                          ; =0x1
	movk	x8, #7, lsl #32
	stur	x8, [x29, #-160]
	mov	x8, #32                         ; =0x20
	movk	x8, #65, lsl #32
	stur	x8, [x29, #-152]
	str	w28, [sp, #28]                  ; 4-byte Folded Spill
	b	LBB5_4
LBB5_3:                                 ;   in Loop: Header=BB5_4 Depth=2
	ldr	x9, [sp, #8]                    ; 8-byte Folded Reload
	add	x9, x9, #4
	cmp	x9, #16
	b.eq	LBB5_1
LBB5_4:                                 ;   Parent Loop BB5_2 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB5_6 Depth 3
                                        ;         Child Loop BB5_21 Depth 4
                                        ;         Child Loop BB5_24 Depth 4
                                        ;         Child Loop BB5_31 Depth 4
                                        ;           Child Loop BB5_34 Depth 5
                                        ;           Child Loop BB5_37 Depth 5
                                        ;         Child Loop BB5_39 Depth 4
                                        ;         Child Loop BB5_42 Depth 4
	mov	x27, #0                         ; =0x0
	sub	x8, x29, #160
	ldr	w23, [x8, x9]
	mov	x8, #1                          ; =0x1
	movk	x8, #15, lsl #32
	stur	x8, [x29, #-176]
	mov	x8, #64                         ; =0x40
	movk	x8, #129, lsl #32
	stur	x8, [x29, #-168]
	mul	w8, w23, w28
	sxtw	x26, w8
	str	x8, [sp, #56]                   ; 8-byte Folded Spill
	sbfiz	x8, x8, #2, #32
	stp	x9, x8, [sp, #8]                ; 16-byte Folded Spill
	lsl	x8, x23, #2
	add	x8, x8, #12
	and	x8, x8, #0x7fffffff0
	stp	x8, x26, [sp, #32]              ; 16-byte Folded Spill
	b	LBB5_6
LBB5_5:                                 ;   in Loop: Header=BB5_6 Depth=3
	add	x27, x27, #4
	cmp	x27, #16
	b.eq	LBB5_3
LBB5_6:                                 ;   Parent Loop BB5_2 Depth=1
                                        ;     Parent Loop BB5_4 Depth=2
                                        ; =>    This Loop Header: Depth=3
                                        ;         Child Loop BB5_21 Depth 4
                                        ;         Child Loop BB5_24 Depth 4
                                        ;         Child Loop BB5_31 Depth 4
                                        ;           Child Loop BB5_34 Depth 5
                                        ;           Child Loop BB5_37 Depth 5
                                        ;         Child Loop BB5_39 Depth 4
                                        ;         Child Loop BB5_42 Depth 4
	sub	x8, x29, #176
	ldr	w26, [x8, x27]
	mul	w8, w26, w28
	stp	xzr, xzr, [sp, #184]
	str	xzr, [sp, #200]
	str	x27, [sp, #48]                  ; 8-byte Folded Spill
	cbz	w8, LBB5_17
; %bb.7:                                ;   in Loop: Header=BB5_6 Depth=3
	sxtw	x22, w8
	tbnz	w22, #31, LBB5_59
; %bb.8:                                ;   in Loop: Header=BB5_6 Depth=3
	lsl	x20, x22, #2
Ltmp6:
	mov	x0, x20
	bl	__Znwm
Ltmp7:
; %bb.9:                                ;   in Loop: Header=BB5_6 Depth=3
	mov	x28, x0
	add	x8, x0, x22, lsl #2
	str	x0, [sp, #184]
	str	x8, [sp, #200]
	add	x27, x0, x20
	mov	x1, x20
	bl	_bzero
	str	x27, [sp, #192]
	mov	x22, x28
	mul	w8, w26, w23
	stp	xzr, xzr, [sp, #160]
	str	xzr, [sp, #176]
	str	x28, [sp, #64]                  ; 8-byte Folded Spill
	cbz	w8, LBB5_18
LBB5_10:                                ;   in Loop: Header=BB5_6 Depth=3
	sxtw	x28, w8
	tbnz	w28, #31, LBB5_57
; %bb.11:                               ;   in Loop: Header=BB5_6 Depth=3
	lsl	x22, x28, #2
Ltmp12:
	mov	x0, x22
	bl	__Znwm
Ltmp13:
; %bb.12:                               ;   in Loop: Header=BB5_6 Depth=3
	mov	x20, x0
	add	x8, x0, x28, lsl #2
	str	x0, [sp, #160]
	str	x8, [sp, #176]
	add	x28, x0, x22
	mov	x1, x22
	bl	_bzero
	str	x28, [sp, #168]
	ldp	x8, x22, [sp, #56]              ; 16-byte Folded Reload
	stp	xzr, xzr, [sp, #136]
	str	xzr, [sp, #152]
	cbz	w8, LBB5_19
LBB5_13:                                ;   in Loop: Header=BB5_6 Depth=3
	ldr	x8, [sp, #40]                   ; 8-byte Folded Reload
	tbnz	w8, #31, LBB5_58
; %bb.14:                               ;   in Loop: Header=BB5_6 Depth=3
Ltmp18:
	ldr	x24, [sp, #16]                  ; 8-byte Folded Reload
	mov	x0, x24
	bl	__Znwm
Ltmp19:
; %bb.15:                               ;   in Loop: Header=BB5_6 Depth=3
	mov	x25, x20
	ldr	x20, [sp, #40]                  ; 8-byte Folded Reload
	add	x8, x0, x20, lsl #2
	str	x0, [sp, #136]
	str	x8, [sp, #152]
	add	x22, x0, x24
	str	x0, [sp, #72]                   ; 8-byte Folded Spill
	mov	x1, x24
	bl	_bzero
	str	x22, [sp, #144]
Ltmp21:
	mov	x0, x24
	bl	__Znwm
Ltmp22:
; %bb.16:                               ;   in Loop: Header=BB5_6 Depth=3
	add	x8, x0, x20, lsl #2
	str	x0, [sp, #112]
	str	x8, [sp, #128]
	add	x22, x0, x24
	str	x0, [sp, #80]                   ; 8-byte Folded Spill
	mov	x1, x24
	bl	_bzero
	str	x22, [sp, #120]
	ldr	x22, [sp, #64]                  ; 8-byte Folded Reload
	mov	x20, x25
	mov	w25, #23                        ; =0x17
	subs	x9, x27, x22
	b.ne	LBB5_20
	b	LBB5_22
LBB5_17:                                ;   in Loop: Header=BB5_6 Depth=3
	mov	x22, #0                         ; =0x0
	mov	x27, #0                         ; =0x0
	mul	w8, w26, w23
	stp	xzr, xzr, [sp, #160]
	str	xzr, [sp, #176]
	str	x22, [sp, #64]                  ; 8-byte Folded Spill
	cbnz	w8, LBB5_10
LBB5_18:                                ;   in Loop: Header=BB5_6 Depth=3
	mov	x20, #0                         ; =0x0
	mov	x28, #0                         ; =0x0
	stp	xzr, xzr, [sp, #136]
	str	xzr, [sp, #152]
	ldr	x8, [sp, #56]                   ; 8-byte Folded Reload
	cbnz	w8, LBB5_13
LBB5_19:                                ;   in Loop: Header=BB5_6 Depth=3
	stp	xzr, xzr, [sp, #72]             ; 16-byte Folded Spill
	stp	xzr, xzr, [sp, #112]
	str	xzr, [sp, #128]
	subs	x9, x27, x22
	b.eq	LBB5_22
LBB5_20:                                ;   in Loop: Header=BB5_6 Depth=3
	mov	x8, #0                          ; =0x0
	asr	x9, x9, #2
	mov	w10, #-11                       ; =0xfffffff5
	mov	x11, x22
LBB5_21:                                ;   Parent Loop BB5_2 Depth=1
                                        ;     Parent Loop BB5_4 Depth=2
                                        ;       Parent Loop BB5_6 Depth=3
                                        ; =>      This Inner Loop Header: Depth=4
	umulh	x12, x8, x19
	sub	x13, x8, x12
	add	x12, x12, x13, lsr #1
	lsr	x12, x12, #4
	msub	w12, w12, w25, w10
	scvtf	s0, w12, #4
	str	s0, [x11], #4
	add	x8, x8, #1
	add	w10, w10, #1
	subs	x9, x9, #1
	b.ne	LBB5_21
LBB5_22:                                ;   in Loop: Header=BB5_6 Depth=3
	subs	x8, x28, x20
	asr	x8, x8, #2
	b.eq	LBB5_25
; %bb.23:                               ;   in Loop: Header=BB5_6 Depth=3
	mov	x9, #0                          ; =0x0
	mov	w10, #-15                       ; =0xfffffff1
	mov	x11, x20
	mov	x12, x8
LBB5_24:                                ;   Parent Loop BB5_2 Depth=1
                                        ;     Parent Loop BB5_4 Depth=2
                                        ;       Parent Loop BB5_6 Depth=3
                                        ; =>      This Inner Loop Header: Depth=4
	umulh	x13, x9, x21
	sub	x14, x9, x13
	add	x13, x13, x14, lsr #1
	lsr	x13, x13, #4
	sub	w13, w13, w13, lsl #5
	add	w13, w10, w13
	scvtf	s0, w13
	fdiv	s0, s0, s10
	str	s0, [x11], #4
	add	x9, x9, #1
	add	w10, w10, #1
	subs	x12, x12, #1
	b.ne	LBB5_24
LBB5_25:                                ;   in Loop: Header=BB5_6 Depth=3
	cmp	w23, #1
	b.lt	LBB5_55
; %bb.26:                               ;   in Loop: Header=BB5_6 Depth=3
	cmp	w26, #1
	b.lt	LBB5_55
; %bb.27:                               ;   in Loop: Header=BB5_6 Depth=3
	umull	x9, w26, w23
	cmp	x8, x9
	b.ne	LBB5_55
; %bb.28:                               ;   in Loop: Header=BB5_6 Depth=3
	ldr	x8, [sp, #32]                   ; 8-byte Folded Reload
	mul	x28, x8, x26
Ltmp27:
	mov	x0, x28
	bl	__Znwm
Ltmp28:
; %bb.29:                               ;   in Loop: Header=BB5_6 Depth=3
	mov	x27, x0
	add	x22, x0, x28
	str	x0, [sp, #88]
	str	x22, [sp, #104]
	mov	x1, x28
	bl	_bzero
	mov	x8, #0                          ; =0x0
	and	x9, x26, #0x7
	str	x22, [sp, #96]
	sub	w10, w26, #1
	and	x11, x26, #0x7ffffff8
	neg	x11, x11
	add	x12, x27, #64
	lsl	x13, x26, #4
	add	x14, x20, #16
	lsl	x15, x26, #2
	mov	x16, x20
	ldr	w28, [sp, #28]                  ; 4-byte Folded Reload
	ldr	x22, [sp, #80]                  ; 8-byte Folded Reload
	b	LBB5_31
LBB5_30:                                ;   in Loop: Header=BB5_31 Depth=4
	add	x8, x8, #1
	add	x14, x14, x15
	add	x16, x16, x15
	cmp	x8, x23
	b.eq	LBB5_38
LBB5_31:                                ;   Parent Loop BB5_2 Depth=1
                                        ;     Parent Loop BB5_4 Depth=2
                                        ;       Parent Loop BB5_6 Depth=3
                                        ; =>      This Loop Header: Depth=4
                                        ;           Child Loop BB5_34 Depth 5
                                        ;           Child Loop BB5_37 Depth 5
	lsr	x0, x8, #2
	ubfiz	x17, x8, #2, #2
	cmp	w10, #7
	b.hs	LBB5_33
; %bb.32:                               ;   in Loop: Header=BB5_31 Depth=4
	mov	x1, #0                          ; =0x0
	cbnz	x9, LBB5_36
	b	LBB5_30
LBB5_33:                                ;   in Loop: Header=BB5_31 Depth=4
	mov	x1, #0                          ; =0x0
	madd	x2, x13, x0, x17
	add	x2, x12, x2
	mov	x3, x14
LBB5_34:                                ;   Parent Loop BB5_2 Depth=1
                                        ;     Parent Loop BB5_4 Depth=2
                                        ;       Parent Loop BB5_6 Depth=3
                                        ;         Parent Loop BB5_31 Depth=4
                                        ; =>        This Inner Loop Header: Depth=5
	ldp	s0, s1, [x3, #-16]
	stur	s0, [x2, #-64]
	stur	s1, [x2, #-48]
	ldp	s0, s1, [x3, #-8]
	stur	s0, [x2, #-32]
	stur	s1, [x2, #-16]
	ldp	s0, s1, [x3]
	str	s0, [x2]
	str	s1, [x2, #16]
	ldp	s0, s1, [x3, #8]
	str	s0, [x2, #32]
	sub	x1, x1, #8
	str	s1, [x2, #48]
	add	x2, x2, #128
	add	x3, x3, #32
	cmp	x11, x1
	b.ne	LBB5_34
; %bb.35:                               ;   in Loop: Header=BB5_31 Depth=4
	neg	x1, x1
	cbz	x9, LBB5_30
LBB5_36:                                ;   in Loop: Header=BB5_31 Depth=4
	mul	x0, x13, x0
	add	x0, x0, x1, lsl #4
	add	x17, x27, x17
	add	x17, x17, x0
	add	x0, x16, x1, lsl #2
	mov	x1, x9
LBB5_37:                                ;   Parent Loop BB5_2 Depth=1
                                        ;     Parent Loop BB5_4 Depth=2
                                        ;       Parent Loop BB5_6 Depth=3
                                        ;         Parent Loop BB5_31 Depth=4
                                        ; =>        This Inner Loop Header: Depth=5
	ldr	s0, [x0], #4
	str	s0, [x17], #16
	subs	x1, x1, #1
	b.ne	LBB5_37
	b	LBB5_30
LBB5_38:                                ;   in Loop: Header=BB5_6 Depth=3
	add	x0, sp, #184
	add	x1, sp, #160
	add	x2, sp, #136
	mov	x3, x28
	mov	x4, x23
	mov	x5, x26
	bl	__Z6scalarRKNSt3__16vectorIfNS_9allocatorIfEEEES5_RS3_iii
	add	x0, sp, #184
	add	x1, sp, #88
	add	x2, sp, #112
	mov	x3, x28
	mov	x4, x23
	mov	x5, x26
	mov	w6, #1                          ; =0x1
	bl	__Z4neonRKNSt3__16vectorIfNS_9allocatorIfEEEES5_RS3_iiii
	ldr	x11, [sp, #56]                  ; 8-byte Folded Reload
	mov	x8, x11
	mov	x10, x22
	cmp	w11, #1
	ldp	x22, x9, [sp, #64]              ; 16-byte Folded Reload
	mov	w11, #46871                     ; =0xb717
	movk	w11, #14673, lsl #16
	b.lt	LBB5_45
LBB5_39:                                ;   Parent Loop BB5_2 Depth=1
                                        ;     Parent Loop BB5_4 Depth=2
                                        ;       Parent Loop BB5_6 Depth=3
                                        ; =>      This Inner Loop Header: Depth=4
	ldr	s0, [x10], #4
	ldr	s1, [x9], #4
	fabd	s0, s0, s1
	fabs	s1, s1
	fadd	s1, s1, s8
	fmov	s2, w11
	fmul	s1, s1, s2
	fcmp	s0, s1
	b.hi	LBB5_53
; %bb.40:                               ;   in Loop: Header=BB5_39 Depth=4
	subs	x8, x8, #1
	b.ne	LBB5_39
; %bb.41:                               ;   in Loop: Header=BB5_6 Depth=3
	add	x0, sp, #184
	add	x1, sp, #88
	add	x2, sp, #112
	mov	x3, x28
	mov	x4, x23
	mov	x5, x26
	mov	w6, #2                          ; =0x2
	bl	__Z4neonRKNSt3__16vectorIfNS_9allocatorIfEEEES5_RS3_iiii
	ldp	x9, x8, [sp, #72]               ; 16-byte Folded Reload
	ldr	x10, [sp, #56]                  ; 8-byte Folded Reload
LBB5_42:                                ;   Parent Loop BB5_2 Depth=1
                                        ;     Parent Loop BB5_4 Depth=2
                                        ;       Parent Loop BB5_6 Depth=3
                                        ; =>      This Inner Loop Header: Depth=4
	ldr	s0, [x8], #4
	ldr	s1, [x9], #4
	fabd	s0, s0, s1
	fabs	s1, s1
	fadd	s1, s1, s8
	fmul	s1, s1, s9
	fcmp	s0, s1
	b.hi	LBB5_53
; %bb.43:                               ;   in Loop: Header=BB5_42 Depth=4
	subs	x10, x10, #1
	b.ne	LBB5_42
; %bb.44:                               ;   in Loop: Header=BB5_6 Depth=3
	mov	x0, x27
	bl	__ZdlPv
	b	LBB5_46
LBB5_45:                                ;   in Loop: Header=BB5_6 Depth=3
	add	x0, sp, #184
	add	x1, sp, #88
	add	x2, sp, #112
	mov	x3, x28
	mov	x4, x23
	mov	x5, x26
	mov	w6, #2                          ; =0x2
	bl	__Z4neonRKNSt3__16vectorIfNS_9allocatorIfEEEES5_RS3_iiii
	mov	x0, x27
	bl	__ZdlPv
	ldr	x8, [sp, #80]                   ; 8-byte Folded Reload
	cbz	x8, LBB5_47
LBB5_46:                                ;   in Loop: Header=BB5_6 Depth=3
	ldr	x0, [sp, #80]                   ; 8-byte Folded Reload
	bl	__ZdlPv
LBB5_47:                                ;   in Loop: Header=BB5_6 Depth=3
	ldr	x27, [sp, #48]                  ; 8-byte Folded Reload
	ldr	x0, [sp, #72]                   ; 8-byte Folded Reload
	cbz	x0, LBB5_49
; %bb.48:                               ;   in Loop: Header=BB5_6 Depth=3
	bl	__ZdlPv
LBB5_49:                                ;   in Loop: Header=BB5_6 Depth=3
	cbz	x20, LBB5_51
; %bb.50:                               ;   in Loop: Header=BB5_6 Depth=3
	mov	x0, x20
	bl	__ZdlPv
LBB5_51:                                ;   in Loop: Header=BB5_6 Depth=3
	cbz	x22, LBB5_5
; %bb.52:                               ;   in Loop: Header=BB5_6 Depth=3
	mov	x0, x22
	bl	__ZdlPv
	b	LBB5_5
LBB5_53:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x24, x0
Ltmp141:
Lloh9:
	adrp	x1, l_.str@PAGE
Lloh10:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp142:
; %bb.54:
Ltmp144:
Lloh11:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh12:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh13:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh14:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x24
	bl	___cxa_throw
Ltmp145:
	b	LBB5_176
LBB5_55:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x24, x0
Ltmp147:
Lloh15:
	adrp	x1, l_.str.1@PAGE
Lloh16:
	add	x1, x1, l_.str.1@PAGEOFF
	ldr	x21, [sp, #72]                  ; 8-byte Folded Reload
	bl	__ZNSt11logic_errorC2EPKc
Ltmp148:
; %bb.56:
Lloh17:
	adrp	x8, __ZTVSt16invalid_argument@GOTPAGE
Lloh18:
	ldr	x8, [x8, __ZTVSt16invalid_argument@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x24]
Ltmp150:
Lloh19:
	adrp	x1, __ZTISt16invalid_argument@GOTPAGE
Lloh20:
	ldr	x1, [x1, __ZTISt16invalid_argument@GOTPAGEOFF]
Lloh21:
	adrp	x2, __ZNSt16invalid_argumentD1Ev@GOTPAGE
Lloh22:
	ldr	x2, [x2, __ZNSt16invalid_argumentD1Ev@GOTPAGEOFF]
	mov	x0, x24
	bl	___cxa_throw
Ltmp151:
	b	LBB5_176
LBB5_57:
Ltmp15:
	bl	__ZNSt3__16vectorIfNS_9allocatorIfEEE20__throw_length_errorB9nqe210106Ev
Ltmp16:
	b	LBB5_176
LBB5_58:
Ltmp24:
	bl	__ZNSt3__16vectorIfNS_9allocatorIfEEE20__throw_length_errorB9nqe210106Ev
Ltmp25:
	b	LBB5_176
LBB5_59:
Ltmp9:
	bl	__ZNSt3__16vectorIfNS_9allocatorIfEEE20__throw_length_errorB9nqe210106Ev
Ltmp10:
	b	LBB5_176
LBB5_60:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp30:
Lloh23:
	adrp	x1, l_.str.1@PAGE
Lloh24:
	add	x1, x1, l_.str.1@PAGEOFF
	bl	__ZNSt11logic_errorC2EPKc
Ltmp31:
; %bb.61:
Lloh25:
	adrp	x8, __ZTVSt16invalid_argument@GOTPAGE
Lloh26:
	ldr	x8, [x8, __ZTVSt16invalid_argument@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x19]
Ltmp33:
Lloh27:
	adrp	x1, __ZTISt16invalid_argument@GOTPAGE
Lloh28:
	ldr	x1, [x1, __ZTISt16invalid_argument@GOTPAGEOFF]
Lloh29:
	adrp	x2, __ZNSt16invalid_argumentD1Ev@GOTPAGE
Lloh30:
	ldr	x2, [x2, __ZNSt16invalid_argumentD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
Ltmp34:
	b	LBB5_176
LBB5_62:
Ltmp35:
	mov	x23, x1
	mov	x26, x0
	b	LBB5_64
LBB5_63:
Ltmp32:
	mov	x23, x1
	mov	x26, x0
	mov	x0, x19
	bl	___cxa_free_exception
LBB5_64:
	cmp	w23, #2
	b.ne	LBB5_233
; %bb.65:
	mov	x0, x26
	bl	___cxa_begin_catch
Ltmp36:
	bl	___cxa_end_catch
Ltmp37:
; %bb.66:
Ltmp39:
Lloh31:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh32:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh33:
	adrp	x1, l_.str.2@PAGE
Lloh34:
	add	x1, x1, l_.str.2@PAGEOFF
	mov	w2, #11                         ; =0xb
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp40:
; %bb.67:
Ltmp41:
	mov	w1, #128                        ; =0x80
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEi
Ltmp42:
; %bb.68:
Ltmp43:
Lloh35:
	adrp	x1, l_.str.3@PAGE
Lloh36:
	add	x1, x1, l_.str.3@PAGEOFF
	mov	w2, #21                         ; =0x15
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp44:
; %bb.69:
	mov	x20, #0                         ; =0x0
	mov	x8, #1                          ; =0x1
	movk	x8, #2, lsl #32
	stur	x8, [x29, #-144]
	mov	w8, #8                          ; =0x8
	stur	w8, [x29, #-136]
	adrp	x24, _sink@PAGE
	b	LBB5_71
LBB5_70:                                ;   in Loop: Header=BB5_71 Depth=1
	add	x20, x20, #4
	cmp	x20, #12
	b.eq	LBB5_166
LBB5_71:                                ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB5_83 Depth 2
                                        ;       Child Loop BB5_84 Depth 3
                                        ;     Child Loop BB5_95 Depth 2
                                        ;       Child Loop BB5_96 Depth 3
                                        ;     Child Loop BB5_107 Depth 2
                                        ;       Child Loop BB5_108 Depth 3
                                        ;     Child Loop BB5_135 Depth 2
                                        ;       Child Loop BB5_136 Depth 3
                                        ;         Child Loop BB5_138 Depth 4
                                        ;           Child Loop BB5_139 Depth 5
	sub	x8, x29, #144
	ldr	w28, [x8, x20]
	stp	xzr, xzr, [sp, #160]
	str	xzr, [sp, #176]
	cbz	w28, LBB5_75
; %bb.72:                               ;   in Loop: Header=BB5_71 Depth=1
	tbnz	w28, #31, LBB5_175
; %bb.73:                               ;   in Loop: Header=BB5_71 Depth=1
	mov	x22, x20
	add	w8, w28, w28, lsl #7
	sxtw	x21, w8
	lsl	x19, x21, #2
Ltmp46:
	mov	x0, x19
	bl	__Znwm
Ltmp47:
; %bb.74:                               ;   in Loop: Header=BB5_71 Depth=1
	mov	x20, x0
	add	x8, x0, x21, lsl #2
	str	x0, [sp, #160]
	str	x8, [sp, #176]
Lloh37:
	adrp	x1, l_.memset_pattern.11@PAGE
Lloh38:
	add	x1, x1, l_.memset_pattern.11@PAGEOFF
	mov	x2, x19
	bl	_memset_pattern16
	add	x8, x20, x19
	str	x8, [sp, #168]
	mov	x20, x22
LBB5_75:                                ;   in Loop: Header=BB5_71 Depth=1
Ltmp52:
	mov	w0, #33540                      ; =0x8304
	bl	__Znwm
Ltmp53:
; %bb.76:                               ;   in Loop: Header=BB5_71 Depth=1
	mov	x19, x0
	str	x20, [sp, #64]                  ; 8-byte Folded Spill
	mov	w8, #33540                      ; =0x8304
	add	x20, x0, x8
	str	x0, [sp, #136]
	str	x20, [sp, #152]
Lloh39:
	adrp	x1, l_.memset_pattern@PAGE
Lloh40:
	add	x1, x1, l_.memset_pattern@PAGEOFF
	mov	w2, #33540                      ; =0x8304
	bl	_memset_pattern16
	str	x20, [sp, #144]
	stp	xzr, xzr, [sp, #112]
	str	xzr, [sp, #128]
	cbz	w28, LBB5_79
; %bb.77:                               ;   in Loop: Header=BB5_71 Depth=1
	add	w22, w28, w28, lsl #6
	lsl	x20, x22, #2
Ltmp55:
	mov	x0, x20
	bl	__Znwm
Ltmp56:
; %bb.78:                               ;   in Loop: Header=BB5_71 Depth=1
	mov	x21, x0
	add	x8, x0, x22, lsl #2
	str	x0, [sp, #112]
	str	x8, [sp, #128]
	add	x22, x0, x20
	mov	x1, x20
	bl	_bzero
	str	x22, [sp, #120]
	b	LBB5_80
LBB5_79:                                ;   in Loop: Header=BB5_71 Depth=1
	mov	x21, #0                         ; =0x0
LBB5_80:                                ;   in Loop: Header=BB5_71 Depth=1
Ltmp58:
	add	x8, sp, #88
	add	x0, sp, #136
	mov	w1, #65                         ; =0x41
	mov	w2, #129                        ; =0x81
	bl	__Z4packRKNSt3__16vectorIfNS_9allocatorIfEEEEii
Ltmp59:
; %bb.81:                               ;   in Loop: Header=BB5_71 Depth=1
	add	x0, sp, #160
	add	x1, sp, #136
	add	x2, sp, #112
	mov	x3, x28
	mov	w4, #65                         ; =0x41
	mov	w5, #129                        ; =0x81
	bl	__Z6scalarRKNSt3__16vectorIfNS_9allocatorIfEEEES5_RS3_iii
	ldr	s0, [x21]
	str	s0, [x24, _sink@PAGEOFF]
	add	x0, sp, #160
	add	x1, sp, #136
	add	x2, sp, #112
	mov	x3, x28
	mov	w4, #65                         ; =0x41
	mov	w5, #129                        ; =0x81
	bl	__Z6scalarRKNSt3__16vectorIfNS_9allocatorIfEEEES5_RS3_iii
	ldr	s0, [x21]
	str	s0, [x24, _sink@PAGEOFF]
	add	x0, sp, #160
	add	x1, sp, #136
	add	x2, sp, #112
	mov	x3, x28
	mov	w4, #65                         ; =0x41
	mov	w5, #129                        ; =0x81
	bl	__Z6scalarRKNSt3__16vectorIfNS_9allocatorIfEEEES5_RS3_iii
	ldr	s0, [x21]
	str	s0, [x24, _sink@PAGEOFF]
	add	x0, sp, #160
	add	x1, sp, #136
	add	x2, sp, #112
	mov	x3, x28
	mov	w4, #65                         ; =0x41
	mov	w5, #129                        ; =0x81
	bl	__Z6scalarRKNSt3__16vectorIfNS_9allocatorIfEEEES5_RS3_iii
	ldr	s0, [x21]
	str	s0, [x24, _sink@PAGEOFF]
	add	x0, sp, #160
	add	x1, sp, #136
	add	x2, sp, #112
	mov	x3, x28
	mov	w4, #65                         ; =0x41
	mov	w5, #129                        ; =0x81
	bl	__Z6scalarRKNSt3__16vectorIfNS_9allocatorIfEEEES5_RS3_iii
	mov	w25, #0                         ; =0x0
	mov	x27, #0                         ; =0x0
	mov	x20, #0                         ; =0x0
	mov	x26, #0                         ; =0x0
	ldr	s0, [x21]
	str	s0, [x24, _sink@PAGEOFF]
	b	LBB5_83
LBB5_82:                                ;   in Loop: Header=BB5_83 Depth=2
	str	d8, [x20], #8
	add	w25, w25, #1
	cmp	w25, #21
	b.eq	LBB5_92
LBB5_83:                                ;   Parent Loop BB5_71 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB5_84 Depth 3
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x21, x0
	mov	w22, #50                        ; =0x32
	ldr	x23, [sp, #112]
LBB5_84:                                ;   Parent Loop BB5_71 Depth=1
                                        ;     Parent Loop BB5_83 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	add	x0, sp, #160
	add	x1, sp, #136
	add	x2, sp, #112
	mov	x3, x28
	mov	w4, #65                         ; =0x41
	mov	w5, #129                        ; =0x81
	bl	__Z6scalarRKNSt3__16vectorIfNS_9allocatorIfEEEES5_RS3_iii
	ldr	s0, [x23]
	str	s0, [x24, _sink@PAGEOFF]
	subs	w22, w22, #1
	b.ne	LBB5_84
; %bb.85:                               ;   in Loop: Header=BB5_83 Depth=2
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	sub	x8, x0, x21
	scvtf	d0, x8
	mov	x8, #70368744177664             ; =0x400000000000
	movk	x8, #16527, lsl #48
	fmov	d1, x8
	fdiv	d0, d0, d1
	mov	x8, #4632233691727265792        ; =0x4049000000000000
	fmov	d1, x8
	fdiv	d8, d0, d1
	cmp	x20, x26
	b.lo	LBB5_82
; %bb.86:                               ;   in Loop: Header=BB5_83 Depth=2
	sub	x21, x20, x27
	asr	x22, x21, #3
	add	x8, x22, #1
	lsr	x9, x8, #61
	cbnz	x9, LBB5_167
; %bb.87:                               ;   in Loop: Header=BB5_83 Depth=2
	sub	x9, x26, x27
	asr	x10, x9, #2
	cmp	x10, x8
	csel	x8, x10, x8, hi
	mov	x10, #9223372036854775800       ; =0x7ffffffffffffff8
	cmp	x9, x10
	mov	x9, #2305843009213693951        ; =0x1fffffffffffffff
	csel	x23, x8, x9, lo
	lsr	x8, x23, #61
	cbnz	x8, LBB5_168
; %bb.88:                               ;   in Loop: Header=BB5_83 Depth=2
	lsl	x0, x23, #3
Ltmp61:
	bl	__Znwm
Ltmp62:
; %bb.89:                               ;   in Loop: Header=BB5_83 Depth=2
	add	x20, x0, x21
	add	x26, x0, x23, lsl #3
	sub	x22, x20, x22, lsl #3
	str	d8, [x20], #8
	mov	x0, x22
	mov	x1, x27
	mov	x2, x21
	bl	_memcpy
	cbz	x27, LBB5_91
; %bb.90:                               ;   in Loop: Header=BB5_83 Depth=2
	mov	x0, x27
	bl	__ZdlPv
LBB5_91:                                ;   in Loop: Header=BB5_83 Depth=2
	mov	x27, x22
	add	w25, w25, #1
	cmp	w25, #21
	b.ne	LBB5_83
LBB5_92:                                ;   in Loop: Header=BB5_71 Depth=1
Ltmp69:
	add	x2, sp, #184
	mov	x0, x27
	mov	x1, x20
	bl	__ZNSt3__16__sortIRNS_6__lessIddEEPdEEvT0_S5_T_
Ltmp70:
; %bb.93:                               ;   in Loop: Header=BB5_71 Depth=1
	ldr	d8, [x27, #80]
	mov	x0, x27
	bl	__ZdlPv
	add	x0, sp, #160
	add	x1, sp, #88
	add	x2, sp, #112
	mov	x3, x28
	mov	w4, #65                         ; =0x41
	mov	w5, #129                        ; =0x81
	mov	w6, #1                          ; =0x1
	bl	__Z4neonRKNSt3__16vectorIfNS_9allocatorIfEEEES5_RS3_iiii
	ldr	x21, [sp, #112]
	ldr	s0, [x21]
	str	s0, [x24, _sink@PAGEOFF]
	add	x0, sp, #160
	add	x1, sp, #88
	add	x2, sp, #112
	mov	x3, x28
	mov	w4, #65                         ; =0x41
	mov	w5, #129                        ; =0x81
	mov	w6, #1                          ; =0x1
	bl	__Z4neonRKNSt3__16vectorIfNS_9allocatorIfEEEES5_RS3_iiii
	ldr	s0, [x21]
	str	s0, [x24, _sink@PAGEOFF]
	add	x0, sp, #160
	add	x1, sp, #88
	add	x2, sp, #112
	mov	x3, x28
	mov	w4, #65                         ; =0x41
	mov	w5, #129                        ; =0x81
	mov	w6, #1                          ; =0x1
	bl	__Z4neonRKNSt3__16vectorIfNS_9allocatorIfEEEES5_RS3_iiii
	ldr	s0, [x21]
	str	s0, [x24, _sink@PAGEOFF]
	add	x0, sp, #160
	add	x1, sp, #88
	add	x2, sp, #112
	mov	x3, x28
	mov	w4, #65                         ; =0x41
	mov	w5, #129                        ; =0x81
	mov	w6, #1                          ; =0x1
	bl	__Z4neonRKNSt3__16vectorIfNS_9allocatorIfEEEES5_RS3_iiii
	ldr	s0, [x21]
	str	s0, [x24, _sink@PAGEOFF]
	add	x0, sp, #160
	add	x1, sp, #88
	add	x2, sp, #112
	mov	x3, x28
	mov	w4, #65                         ; =0x41
	mov	w5, #129                        ; =0x81
	mov	w6, #1                          ; =0x1
	bl	__Z4neonRKNSt3__16vectorIfNS_9allocatorIfEEEES5_RS3_iiii
	mov	w25, #0                         ; =0x0
	mov	x27, #0                         ; =0x0
	mov	x20, #0                         ; =0x0
	mov	x26, #0                         ; =0x0
	ldr	s0, [x21]
	str	s0, [x24, _sink@PAGEOFF]
	b	LBB5_95
LBB5_94:                                ;   in Loop: Header=BB5_95 Depth=2
	str	d9, [x20], #8
	add	w25, w25, #1
	cmp	w25, #21
	b.eq	LBB5_104
LBB5_95:                                ;   Parent Loop BB5_71 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB5_96 Depth 3
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x21, x0
	mov	w22, #50                        ; =0x32
	ldr	x23, [sp, #112]
LBB5_96:                                ;   Parent Loop BB5_71 Depth=1
                                        ;     Parent Loop BB5_95 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	add	x0, sp, #160
	add	x1, sp, #88
	add	x2, sp, #112
	mov	x3, x28
	mov	w4, #65                         ; =0x41
	mov	w5, #129                        ; =0x81
	mov	w6, #1                          ; =0x1
	bl	__Z4neonRKNSt3__16vectorIfNS_9allocatorIfEEEES5_RS3_iiii
	ldr	s0, [x23]
	str	s0, [x24, _sink@PAGEOFF]
	subs	w22, w22, #1
	b.ne	LBB5_96
; %bb.97:                               ;   in Loop: Header=BB5_95 Depth=2
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	sub	x8, x0, x21
	scvtf	d0, x8
	mov	x8, #70368744177664             ; =0x400000000000
	movk	x8, #16527, lsl #48
	fmov	d1, x8
	fdiv	d0, d0, d1
	mov	x8, #4632233691727265792        ; =0x4049000000000000
	fmov	d1, x8
	fdiv	d9, d0, d1
	cmp	x20, x26
	b.lo	LBB5_94
; %bb.98:                               ;   in Loop: Header=BB5_95 Depth=2
	sub	x21, x20, x27
	asr	x22, x21, #3
	add	x8, x22, #1
	lsr	x9, x8, #61
	cbnz	x9, LBB5_169
; %bb.99:                               ;   in Loop: Header=BB5_95 Depth=2
	sub	x9, x26, x27
	asr	x10, x9, #2
	cmp	x10, x8
	csel	x8, x10, x8, hi
	mov	x10, #9223372036854775800       ; =0x7ffffffffffffff8
	cmp	x9, x10
	mov	x9, #2305843009213693951        ; =0x1fffffffffffffff
	csel	x23, x8, x9, lo
	lsr	x8, x23, #61
	cbnz	x8, LBB5_170
; %bb.100:                              ;   in Loop: Header=BB5_95 Depth=2
	lsl	x0, x23, #3
Ltmp72:
	bl	__Znwm
Ltmp73:
; %bb.101:                              ;   in Loop: Header=BB5_95 Depth=2
	add	x20, x0, x21
	add	x26, x0, x23, lsl #3
	sub	x22, x20, x22, lsl #3
	str	d9, [x20], #8
	mov	x0, x22
	mov	x1, x27
	mov	x2, x21
	bl	_memcpy
	cbz	x27, LBB5_103
; %bb.102:                              ;   in Loop: Header=BB5_95 Depth=2
	mov	x0, x27
	bl	__ZdlPv
LBB5_103:                               ;   in Loop: Header=BB5_95 Depth=2
	mov	x27, x22
	add	w25, w25, #1
	cmp	w25, #21
	b.ne	LBB5_95
LBB5_104:                               ;   in Loop: Header=BB5_71 Depth=1
Ltmp80:
	add	x2, sp, #184
	mov	x0, x27
	mov	x1, x20
	bl	__ZNSt3__16__sortIRNS_6__lessIddEEPdEEvT0_S5_T_
Ltmp81:
; %bb.105:                              ;   in Loop: Header=BB5_71 Depth=1
	ldr	d9, [x27, #80]
	mov	x0, x27
	bl	__ZdlPv
	add	x0, sp, #160
	add	x1, sp, #88
	add	x2, sp, #112
	mov	x3, x28
	mov	w4, #65                         ; =0x41
	mov	w5, #129                        ; =0x81
	mov	w6, #2                          ; =0x2
	bl	__Z4neonRKNSt3__16vectorIfNS_9allocatorIfEEEES5_RS3_iiii
	ldr	x21, [sp, #112]
	ldr	s0, [x21]
	str	s0, [x24, _sink@PAGEOFF]
	add	x0, sp, #160
	add	x1, sp, #88
	add	x2, sp, #112
	mov	x3, x28
	mov	w4, #65                         ; =0x41
	mov	w5, #129                        ; =0x81
	mov	w6, #2                          ; =0x2
	bl	__Z4neonRKNSt3__16vectorIfNS_9allocatorIfEEEES5_RS3_iiii
	ldr	s0, [x21]
	str	s0, [x24, _sink@PAGEOFF]
	add	x0, sp, #160
	add	x1, sp, #88
	add	x2, sp, #112
	mov	x3, x28
	mov	w4, #65                         ; =0x41
	mov	w5, #129                        ; =0x81
	mov	w6, #2                          ; =0x2
	bl	__Z4neonRKNSt3__16vectorIfNS_9allocatorIfEEEES5_RS3_iiii
	ldr	s0, [x21]
	str	s0, [x24, _sink@PAGEOFF]
	add	x0, sp, #160
	add	x1, sp, #88
	add	x2, sp, #112
	mov	x3, x28
	mov	w4, #65                         ; =0x41
	mov	w5, #129                        ; =0x81
	mov	w6, #2                          ; =0x2
	bl	__Z4neonRKNSt3__16vectorIfNS_9allocatorIfEEEES5_RS3_iiii
	ldr	s0, [x21]
	str	s0, [x24, _sink@PAGEOFF]
	add	x0, sp, #160
	add	x1, sp, #88
	add	x2, sp, #112
	mov	x3, x28
	mov	w4, #65                         ; =0x41
	mov	w5, #129                        ; =0x81
	mov	w6, #2                          ; =0x2
	bl	__Z4neonRKNSt3__16vectorIfNS_9allocatorIfEEEES5_RS3_iiii
	mov	w25, #0                         ; =0x0
	mov	x27, #0                         ; =0x0
	mov	x20, #0                         ; =0x0
	mov	x26, #0                         ; =0x0
	ldr	s0, [x21]
	str	s0, [x24, _sink@PAGEOFF]
	b	LBB5_107
LBB5_106:                               ;   in Loop: Header=BB5_107 Depth=2
	str	d10, [x20], #8
	add	w25, w25, #1
	cmp	w25, #21
	b.eq	LBB5_116
LBB5_107:                               ;   Parent Loop BB5_71 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB5_108 Depth 3
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x21, x0
	mov	w22, #50                        ; =0x32
	ldr	x23, [sp, #112]
LBB5_108:                               ;   Parent Loop BB5_71 Depth=1
                                        ;     Parent Loop BB5_107 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	add	x0, sp, #160
	add	x1, sp, #88
	add	x2, sp, #112
	mov	x3, x28
	mov	w4, #65                         ; =0x41
	mov	w5, #129                        ; =0x81
	mov	w6, #2                          ; =0x2
	bl	__Z4neonRKNSt3__16vectorIfNS_9allocatorIfEEEES5_RS3_iiii
	ldr	s0, [x23]
	str	s0, [x24, _sink@PAGEOFF]
	subs	w22, w22, #1
	b.ne	LBB5_108
; %bb.109:                              ;   in Loop: Header=BB5_107 Depth=2
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	sub	x8, x0, x21
	scvtf	d0, x8
	mov	x8, #70368744177664             ; =0x400000000000
	movk	x8, #16527, lsl #48
	fmov	d1, x8
	fdiv	d0, d0, d1
	mov	x8, #4632233691727265792        ; =0x4049000000000000
	fmov	d1, x8
	fdiv	d10, d0, d1
	cmp	x20, x26
	b.lo	LBB5_106
; %bb.110:                              ;   in Loop: Header=BB5_107 Depth=2
	sub	x21, x20, x27
	asr	x22, x21, #3
	add	x8, x22, #1
	lsr	x9, x8, #61
	cbnz	x9, LBB5_171
; %bb.111:                              ;   in Loop: Header=BB5_107 Depth=2
	sub	x9, x26, x27
	asr	x10, x9, #2
	cmp	x10, x8
	csel	x8, x10, x8, hi
	mov	x10, #9223372036854775800       ; =0x7ffffffffffffff8
	cmp	x9, x10
	mov	x9, #2305843009213693951        ; =0x1fffffffffffffff
	csel	x23, x8, x9, lo
	lsr	x8, x23, #61
	cbnz	x8, LBB5_172
; %bb.112:                              ;   in Loop: Header=BB5_107 Depth=2
	lsl	x0, x23, #3
Ltmp83:
	bl	__Znwm
Ltmp84:
; %bb.113:                              ;   in Loop: Header=BB5_107 Depth=2
	add	x20, x0, x21
	add	x26, x0, x23, lsl #3
	sub	x22, x20, x22, lsl #3
	str	d10, [x20], #8
	mov	x0, x22
	mov	x1, x27
	mov	x2, x21
	bl	_memcpy
	cbz	x27, LBB5_115
; %bb.114:                              ;   in Loop: Header=BB5_107 Depth=2
	mov	x0, x27
	bl	__ZdlPv
LBB5_115:                               ;   in Loop: Header=BB5_107 Depth=2
	mov	x27, x22
	add	w25, w25, #1
	cmp	w25, #21
	b.ne	LBB5_107
LBB5_116:                               ;   in Loop: Header=BB5_71 Depth=1
Ltmp91:
	add	x2, sp, #184
	mov	x0, x27
	mov	x1, x20
	bl	__ZNSt3__16__sortIRNS_6__lessIddEEPdEEvT0_S5_T_
Ltmp92:
; %bb.117:                              ;   in Loop: Header=BB5_71 Depth=1
	ldr	d10, [x27, #80]
	mov	x0, x27
	bl	__ZdlPv
Ltmp94:
	add	x8, sp, #184
	add	x0, sp, #136
	mov	w1, #65                         ; =0x41
	mov	w2, #129                        ; =0x81
	bl	__Z4packRKNSt3__16vectorIfNS_9allocatorIfEEEEii
Ltmp95:
; %bb.118:                              ;   in Loop: Header=BB5_71 Depth=1
	add	x0, sp, #160
	add	x1, sp, #184
	add	x2, sp, #112
	mov	x3, x28
	mov	w4, #65                         ; =0x41
	mov	w5, #129                        ; =0x81
	mov	w6, #2                          ; =0x2
	bl	__Z4neonRKNSt3__16vectorIfNS_9allocatorIfEEEES5_RS3_iiii
	ldr	x0, [sp, #184]
	cbz	x0, LBB5_120
; %bb.119:                              ;   in Loop: Header=BB5_71 Depth=1
	bl	__ZdlPv
LBB5_120:                               ;   in Loop: Header=BB5_71 Depth=1
	ldr	x21, [sp, #112]
	ldr	s0, [x21]
	str	s0, [x24, _sink@PAGEOFF]
Ltmp96:
	add	x8, sp, #184
	add	x0, sp, #136
	mov	w1, #65                         ; =0x41
	mov	w2, #129                        ; =0x81
	bl	__Z4packRKNSt3__16vectorIfNS_9allocatorIfEEEEii
Ltmp97:
; %bb.121:                              ;   in Loop: Header=BB5_71 Depth=1
	add	x0, sp, #160
	add	x1, sp, #184
	add	x2, sp, #112
	mov	x3, x28
	mov	w4, #65                         ; =0x41
	mov	w5, #129                        ; =0x81
	mov	w6, #2                          ; =0x2
	bl	__Z4neonRKNSt3__16vectorIfNS_9allocatorIfEEEES5_RS3_iiii
	ldr	x0, [sp, #184]
	cbz	x0, LBB5_123
; %bb.122:                              ;   in Loop: Header=BB5_71 Depth=1
	bl	__ZdlPv
LBB5_123:                               ;   in Loop: Header=BB5_71 Depth=1
	ldr	s0, [x21]
	str	s0, [x24, _sink@PAGEOFF]
Ltmp98:
	add	x8, sp, #184
	add	x0, sp, #136
	mov	w1, #65                         ; =0x41
	mov	w2, #129                        ; =0x81
	bl	__Z4packRKNSt3__16vectorIfNS_9allocatorIfEEEEii
Ltmp99:
; %bb.124:                              ;   in Loop: Header=BB5_71 Depth=1
	add	x0, sp, #160
	add	x1, sp, #184
	add	x2, sp, #112
	mov	x3, x28
	mov	w4, #65                         ; =0x41
	mov	w5, #129                        ; =0x81
	mov	w6, #2                          ; =0x2
	bl	__Z4neonRKNSt3__16vectorIfNS_9allocatorIfEEEES5_RS3_iiii
	ldr	x0, [sp, #184]
	cbz	x0, LBB5_126
; %bb.125:                              ;   in Loop: Header=BB5_71 Depth=1
	bl	__ZdlPv
LBB5_126:                               ;   in Loop: Header=BB5_71 Depth=1
	ldr	s0, [x21]
	str	s0, [x24, _sink@PAGEOFF]
Ltmp100:
	add	x8, sp, #184
	add	x0, sp, #136
	mov	w1, #65                         ; =0x41
	mov	w2, #129                        ; =0x81
	bl	__Z4packRKNSt3__16vectorIfNS_9allocatorIfEEEEii
Ltmp101:
; %bb.127:                              ;   in Loop: Header=BB5_71 Depth=1
	add	x0, sp, #160
	add	x1, sp, #184
	add	x2, sp, #112
	mov	x3, x28
	mov	w4, #65                         ; =0x41
	mov	w5, #129                        ; =0x81
	mov	w6, #2                          ; =0x2
	bl	__Z4neonRKNSt3__16vectorIfNS_9allocatorIfEEEES5_RS3_iiii
	ldr	x0, [sp, #184]
	cbz	x0, LBB5_129
; %bb.128:                              ;   in Loop: Header=BB5_71 Depth=1
	bl	__ZdlPv
LBB5_129:                               ;   in Loop: Header=BB5_71 Depth=1
	ldr	s0, [x21]
	str	s0, [x24, _sink@PAGEOFF]
Ltmp102:
	add	x8, sp, #184
	add	x0, sp, #136
	mov	w1, #65                         ; =0x41
	mov	w2, #129                        ; =0x81
	bl	__Z4packRKNSt3__16vectorIfNS_9allocatorIfEEEEii
Ltmp103:
; %bb.130:                              ;   in Loop: Header=BB5_71 Depth=1
	add	x0, sp, #160
	add	x1, sp, #184
	add	x2, sp, #112
	mov	x3, x28
	mov	w4, #65                         ; =0x41
	mov	w5, #129                        ; =0x81
	mov	w6, #2                          ; =0x2
	bl	__Z4neonRKNSt3__16vectorIfNS_9allocatorIfEEEES5_RS3_iiii
	ldr	x0, [sp, #184]
	cbz	x0, LBB5_132
; %bb.131:                              ;   in Loop: Header=BB5_71 Depth=1
	bl	__ZdlPv
LBB5_132:                               ;   in Loop: Header=BB5_71 Depth=1
	mov	w25, #0                         ; =0x0
	mov	x22, #0                         ; =0x0
	mov	x20, #0                         ; =0x0
	mov	x23, #0                         ; =0x0
	ldr	s0, [x21]
	str	s0, [x24, _sink@PAGEOFF]
	b	LBB5_135
LBB5_133:                               ;   in Loop: Header=BB5_135 Depth=2
	str	d11, [x20], #8
	ldr	x22, [sp, #80]                  ; 8-byte Folded Reload
LBB5_134:                               ;   in Loop: Header=BB5_135 Depth=2
	add	w25, w25, #1
	cmp	w25, #21
	b.eq	LBB5_148
LBB5_135:                               ;   Parent Loop BB5_71 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB5_136 Depth 3
                                        ;         Child Loop BB5_138 Depth 4
                                        ;           Child Loop BB5_139 Depth 5
	stp	x23, x22, [sp, #72]             ; 16-byte Folded Spill
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x21, x0
	mov	w26, #0                         ; =0x0
	ldr	x27, [sp, #112]
LBB5_136:                               ;   Parent Loop BB5_71 Depth=1
                                        ;     Parent Loop BB5_135 Depth=2
                                        ; =>    This Loop Header: Depth=3
                                        ;         Child Loop BB5_138 Depth 4
                                        ;           Child Loop BB5_139 Depth 5
	stp	xzr, xzr, [sp, #184]
	str	xzr, [sp, #200]
Ltmp104:
	mov	w0, #35088                      ; =0x8910
	bl	__Znwm
Ltmp105:
; %bb.137:                              ;   in Loop: Header=BB5_136 Depth=3
	mov	x22, x0
	mov	w8, #35088                      ; =0x8910
	add	x23, x0, x8
	str	x0, [sp, #184]
	str	x23, [sp, #200]
	mov	w1, #35088                      ; =0x8910
	bl	_bzero
	mov	x8, #0                          ; =0x0
	str	x23, [sp, #192]
	mov	x9, x19
LBB5_138:                               ;   Parent Loop BB5_71 Depth=1
                                        ;     Parent Loop BB5_135 Depth=2
                                        ;       Parent Loop BB5_136 Depth=3
                                        ; =>      This Loop Header: Depth=4
                                        ;           Child Loop BB5_139 Depth 5
	mov	x10, #0                         ; =0x0
	lsr	x11, x8, #2
	add	x11, x11, x11, lsl #7
	ubfiz	x12, x8, #2, #2
	orr	x11, x12, x11, lsl #4
	add	x11, x22, x11
LBB5_139:                               ;   Parent Loop BB5_71 Depth=1
                                        ;     Parent Loop BB5_135 Depth=2
                                        ;       Parent Loop BB5_136 Depth=3
                                        ;         Parent Loop BB5_138 Depth=4
                                        ; =>        This Inner Loop Header: Depth=5
	ldr	s0, [x9, x10]
	str	s0, [x11, x10, lsl #2]
	add	x10, x10, #4
	cmp	x10, #516
	b.ne	LBB5_139
; %bb.140:                              ;   in Loop: Header=BB5_138 Depth=4
	add	x8, x8, #1
	add	x9, x9, #516
	cmp	x8, #65
	b.ne	LBB5_138
; %bb.141:                              ;   in Loop: Header=BB5_136 Depth=3
	add	x0, sp, #160
	add	x1, sp, #184
	add	x2, sp, #112
	mov	x3, x28
	mov	w4, #65                         ; =0x41
	mov	w5, #129                        ; =0x81
	mov	w6, #2                          ; =0x2
	bl	__Z4neonRKNSt3__16vectorIfNS_9allocatorIfEEEES5_RS3_iiii
	mov	x0, x22
	bl	__ZdlPv
	ldr	s0, [x27]
	str	s0, [x24, _sink@PAGEOFF]
	add	w26, w26, #1
	cmp	w26, #50
	b.ne	LBB5_136
; %bb.142:                              ;   in Loop: Header=BB5_135 Depth=2
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	sub	x8, x0, x21
	scvtf	d0, x8
	mov	x8, #70368744177664             ; =0x400000000000
	movk	x8, #16527, lsl #48
	fmov	d1, x8
	fdiv	d0, d0, d1
	mov	x8, #4632233691727265792        ; =0x4049000000000000
	fmov	d1, x8
	fdiv	d11, d0, d1
	ldr	x23, [sp, #72]                  ; 8-byte Folded Reload
	cmp	x20, x23
	b.lo	LBB5_133
; %bb.143:                              ;   in Loop: Header=BB5_135 Depth=2
	ldr	x26, [sp, #80]                  ; 8-byte Folded Reload
	sub	x21, x20, x26
	asr	x22, x21, #3
	add	x8, x22, #1
	lsr	x9, x8, #61
	cbnz	x9, LBB5_173
; %bb.144:                              ;   in Loop: Header=BB5_135 Depth=2
	sub	x9, x23, x26
	asr	x10, x9, #2
	cmp	x10, x8
	csel	x8, x10, x8, hi
	mov	x10, #9223372036854775800       ; =0x7ffffffffffffff8
	cmp	x9, x10
	mov	x9, #2305843009213693951        ; =0x1fffffffffffffff
	csel	x23, x8, x9, lo
	lsr	x8, x23, #61
	cbnz	x8, LBB5_174
; %bb.145:                              ;   in Loop: Header=BB5_135 Depth=2
	lsl	x0, x23, #3
Ltmp107:
	bl	__Znwm
Ltmp108:
; %bb.146:                              ;   in Loop: Header=BB5_135 Depth=2
	add	x20, x0, x21
	add	x23, x0, x23, lsl #3
	sub	x22, x20, x22, lsl #3
	str	d11, [x20], #8
	mov	x0, x22
	mov	x1, x26
	mov	x2, x21
	bl	_memcpy
	cbz	x26, LBB5_134
; %bb.147:                              ;   in Loop: Header=BB5_135 Depth=2
	mov	x0, x26
	bl	__ZdlPv
	b	LBB5_134
LBB5_148:                               ;   in Loop: Header=BB5_71 Depth=1
Ltmp115:
	add	x2, sp, #184
	mov	x0, x22
	mov	x1, x20
	bl	__ZNSt3__16__sortIRNS_6__lessIddEEPdEEvT0_S5_T_
Ltmp116:
; %bb.149:                              ;   in Loop: Header=BB5_71 Depth=1
	ldr	d11, [x22, #80]
	mov	x0, x22
	bl	__ZdlPv
Ltmp118:
Lloh41:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh42:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh43:
	adrp	x1, l_.str.4@PAGE
Lloh44:
	add	x1, x1, l_.str.4@PAGEOFF
	mov	w2, #2                          ; =0x2
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp119:
; %bb.150:                              ;   in Loop: Header=BB5_71 Depth=1
Ltmp120:
	mov	x1, x28
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEi
Ltmp121:
; %bb.151:                              ;   in Loop: Header=BB5_71 Depth=1
Ltmp122:
Lloh45:
	adrp	x1, l_.str.5@PAGE
Lloh46:
	add	x1, x1, l_.str.5@PAGEOFF
	mov	w2, #41                         ; =0x29
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp123:
; %bb.152:                              ;   in Loop: Header=BB5_71 Depth=1
Ltmp124:
	mov.16b	v0, v8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp125:
; %bb.153:                              ;   in Loop: Header=BB5_71 Depth=1
Ltmp126:
Lloh47:
	adrp	x1, l_.str.6@PAGE
Lloh48:
	add	x1, x1, l_.str.6@PAGEOFF
	mov	w2, #7                          ; =0x7
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp127:
; %bb.154:                              ;   in Loop: Header=BB5_71 Depth=1
Ltmp128:
	mov.16b	v0, v9
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp129:
; %bb.155:                              ;   in Loop: Header=BB5_71 Depth=1
Ltmp130:
Lloh49:
	adrp	x1, l_.str.7@PAGE
Lloh50:
	add	x1, x1, l_.str.7@PAGEOFF
	mov	w2, #7                          ; =0x7
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp131:
; %bb.156:                              ;   in Loop: Header=BB5_71 Depth=1
Ltmp132:
	mov.16b	v0, v10
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp133:
; %bb.157:                              ;   in Loop: Header=BB5_71 Depth=1
Ltmp134:
Lloh51:
	adrp	x1, l_.str.8@PAGE
Lloh52:
	add	x1, x1, l_.str.8@PAGEOFF
	mov	w2, #23                         ; =0x17
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp135:
; %bb.158:                              ;   in Loop: Header=BB5_71 Depth=1
Ltmp136:
	mov.16b	v0, v11
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp137:
; %bb.159:                              ;   in Loop: Header=BB5_71 Depth=1
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #184]
Ltmp138:
	add	x1, sp, #184
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp139:
; %bb.160:                              ;   in Loop: Header=BB5_71 Depth=1
	ldr	x0, [sp, #88]
	cbz	x0, LBB5_162
; %bb.161:                              ;   in Loop: Header=BB5_71 Depth=1
	bl	__ZdlPv
LBB5_162:                               ;   in Loop: Header=BB5_71 Depth=1
	ldr	x0, [sp, #112]
	ldr	x20, [sp, #64]                  ; 8-byte Folded Reload
	cbz	x0, LBB5_164
; %bb.163:                              ;   in Loop: Header=BB5_71 Depth=1
	bl	__ZdlPv
LBB5_164:                               ;   in Loop: Header=BB5_71 Depth=1
	mov	x0, x19
	bl	__ZdlPv
	ldr	x0, [sp, #160]
	cbz	x0, LBB5_70
; %bb.165:                              ;   in Loop: Header=BB5_71 Depth=1
	bl	__ZdlPv
	b	LBB5_70
LBB5_166:
	mov	w0, #0                          ; =0x0
	b	LBB5_238
LBB5_167:
Ltmp66:
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_length_errorB9nqe210106Ev
Ltmp67:
	b	LBB5_176
LBB5_168:
Ltmp64:
	bl	__ZSt28__throw_bad_array_new_lengthB9nqe210106v
Ltmp65:
	b	LBB5_176
LBB5_169:
Ltmp77:
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_length_errorB9nqe210106Ev
Ltmp78:
	b	LBB5_176
LBB5_170:
Ltmp75:
	bl	__ZSt28__throw_bad_array_new_lengthB9nqe210106v
Ltmp76:
	b	LBB5_176
LBB5_171:
Ltmp88:
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_length_errorB9nqe210106Ev
Ltmp89:
	b	LBB5_176
LBB5_172:
Ltmp86:
	bl	__ZSt28__throw_bad_array_new_lengthB9nqe210106v
Ltmp87:
	b	LBB5_176
LBB5_173:
Ltmp112:
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_length_errorB9nqe210106Ev
Ltmp113:
	b	LBB5_176
LBB5_174:
Ltmp110:
	bl	__ZSt28__throw_bad_array_new_lengthB9nqe210106v
Ltmp111:
	b	LBB5_176
LBB5_175:
Ltmp49:
	bl	__ZNSt3__16vectorIfNS_9allocatorIfEEE20__throw_length_errorB9nqe210106Ev
Ltmp50:
LBB5_176:
	brk	#0x1
LBB5_177:
Ltmp51:
	b	LBB5_216
LBB5_178:
Ltmp117:
	str	x22, [sp, #80]                  ; 8-byte Folded Spill
	b	LBB5_200
LBB5_179:
Ltmp93:
	b	LBB5_197
LBB5_180:
Ltmp82:
	b	LBB5_197
LBB5_181:
Ltmp71:
	b	LBB5_197
LBB5_182:
Ltmp60:
	mov	x23, x1
	mov	x26, x0
	b	LBB5_205
LBB5_183:
Ltmp57:
	mov	x23, x1
	mov	x26, x0
	b	LBB5_207
LBB5_184:
Ltmp54:
	mov	x23, x1
	mov	x26, x0
	b	LBB5_208
LBB5_185:
Ltmp48:
	b	LBB5_216
LBB5_186:
Ltmp45:
	b	LBB5_216
LBB5_187:
Ltmp38:
	b	LBB5_216
LBB5_188:
Ltmp140:
	mov	x23, x1
	mov	x26, x0
	b	LBB5_203
LBB5_189:
Ltmp109:
	b	LBB5_200
LBB5_190:
Ltmp85:
	b	LBB5_197
LBB5_191:
Ltmp74:
	b	LBB5_197
LBB5_192:
Ltmp63:
	b	LBB5_197
LBB5_193:
Ltmp114:
	b	LBB5_200
LBB5_194:
Ltmp90:
	b	LBB5_197
LBB5_195:
Ltmp79:
	b	LBB5_197
LBB5_196:
Ltmp68:
LBB5_197:
	mov	x23, x1
	mov	x26, x0
	cbz	x27, LBB5_203
; %bb.198:
	mov	x0, x27
	b	LBB5_202
LBB5_199:
Ltmp106:
LBB5_200:
	mov	x23, x1
	mov	x26, x0
	ldr	x8, [sp, #80]                   ; 8-byte Folded Reload
	cbz	x8, LBB5_203
; %bb.201:
	ldr	x0, [sp, #80]                   ; 8-byte Folded Reload
LBB5_202:
	bl	__ZdlPv
LBB5_203:
	ldr	x0, [sp, #88]
	cbz	x0, LBB5_205
; %bb.204:
	bl	__ZdlPv
LBB5_205:
	ldr	x0, [sp, #112]
	cbz	x0, LBB5_207
; %bb.206:
	bl	__ZdlPv
LBB5_207:
	mov	x0, x19
	bl	__ZdlPv
LBB5_208:
	ldr	x0, [sp, #160]
	cbnz	x0, LBB5_232
	b	LBB5_233
LBB5_209:
Ltmp11:
	b	LBB5_216
LBB5_210:
Ltmp26:
	b	LBB5_214
LBB5_211:
Ltmp14:
	mov	x23, x1
	mov	x26, x0
	ldr	x22, [sp, #64]                  ; 8-byte Folded Reload
	b	LBB5_230
LBB5_212:
Ltmp17:
	mov	x23, x1
	mov	x26, x0
	b	LBB5_230
LBB5_213:
Ltmp20:
LBB5_214:
	mov	x23, x1
	mov	x26, x0
	b	LBB5_228
LBB5_215:
Ltmp8:
LBB5_216:
	mov	x23, x1
	mov	x26, x0
	b	LBB5_233
LBB5_217:
Ltmp23:
	mov	x23, x1
	mov	x26, x0
	ldp	x22, x21, [sp, #64]             ; 16-byte Folded Reload
	mov	x20, x25
	b	LBB5_227
LBB5_218:
Ltmp29:
	mov	x23, x1
	mov	x26, x0
	ldr	x21, [sp, #72]                  ; 8-byte Folded Reload
	b	LBB5_221
LBB5_219:
Ltmp152:
	mov	x23, x1
	mov	x26, x0
	b	LBB5_221
LBB5_220:
Ltmp149:
	mov	x23, x1
	mov	x26, x0
	mov	x0, x24
	bl	___cxa_free_exception
LBB5_221:
	ldr	x8, [sp, #80]                   ; 8-byte Folded Reload
	cbnz	x8, LBB5_225
	b	LBB5_226
LBB5_222:
Ltmp146:
	mov	x23, x1
	mov	x26, x0
	b	LBB5_224
LBB5_223:
Ltmp143:
	mov	x23, x1
	mov	x26, x0
	mov	x0, x24
	bl	___cxa_free_exception
LBB5_224:
	ldr	x21, [sp, #72]                  ; 8-byte Folded Reload
	mov	x0, x27
	bl	__ZdlPv
LBB5_225:
	ldr	x0, [sp, #80]                   ; 8-byte Folded Reload
	bl	__ZdlPv
LBB5_226:
	cbz	x21, LBB5_228
LBB5_227:
	mov	x0, x21
	bl	__ZdlPv
LBB5_228:
	cbz	x20, LBB5_230
; %bb.229:
	mov	x0, x20
	bl	__ZdlPv
LBB5_230:
	cbz	x22, LBB5_233
; %bb.231:
	mov	x0, x22
LBB5_232:
	bl	__ZdlPv
LBB5_233:
	cmp	w23, #1
	b.ne	LBB5_244
; %bb.234:
	mov	x0, x26
	bl	___cxa_begin_catch
	ldr	x8, [x0]
	ldr	x8, [x8, #16]
	blr	x8
	mov	x19, x0
	bl	_strlen
	mov	x2, x0
Ltmp153:
Lloh53:
	adrp	x0, __ZNSt3__14cerrE@GOTPAGE
Lloh54:
	ldr	x0, [x0, __ZNSt3__14cerrE@GOTPAGEOFF]
	mov	x1, x19
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp154:
; %bb.235:
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #160]
Ltmp155:
	add	x1, sp, #160
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp156:
; %bb.236:
Ltmp161:
	bl	___cxa_end_catch
Ltmp162:
; %bb.237:
	mov	w0, #1                          ; =0x1
LBB5_238:
	ldur	x8, [x29, #-128]
Lloh55:
	adrp	x9, ___stack_chk_guard@GOTPAGE
Lloh56:
	ldr	x9, [x9, ___stack_chk_guard@GOTPAGEOFF]
Lloh57:
	ldr	x9, [x9]
	cmp	x9, x8
	b.ne	LBB5_240
; %bb.239:
	ldp	x29, x30, [sp, #384]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #368]            ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #352]            ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #336]            ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #320]            ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #304]            ; 16-byte Folded Reload
	ldp	d9, d8, [sp, #288]              ; 16-byte Folded Reload
	ldp	d11, d10, [sp, #272]            ; 16-byte Folded Reload
	add	sp, sp, #400
	ret
LBB5_240:
	bl	___stack_chk_fail
LBB5_241:
Ltmp163:
	bl	__Unwind_Resume
LBB5_242:
Ltmp157:
	mov	x26, x0
Ltmp158:
	bl	___cxa_end_catch
Ltmp159:
	b	LBB5_244
LBB5_243:
Ltmp160:
	mov	x26, x0
	cbnz	w1, LBB5_245
LBB5_244:
	mov	x0, x26
	bl	__Unwind_Resume
LBB5_245:
	mov	x0, x26
	bl	___clang_call_terminate
	.loh AdrpLdrGotLdr	Lloh6, Lloh7, Lloh8
	.loh AdrpAdd	Lloh9, Lloh10
	.loh AdrpLdrGot	Lloh13, Lloh14
	.loh AdrpLdrGot	Lloh11, Lloh12
	.loh AdrpAdd	Lloh15, Lloh16
	.loh AdrpLdrGot	Lloh21, Lloh22
	.loh AdrpLdrGot	Lloh19, Lloh20
	.loh AdrpLdrGot	Lloh17, Lloh18
	.loh AdrpAdd	Lloh23, Lloh24
	.loh AdrpLdrGot	Lloh29, Lloh30
	.loh AdrpLdrGot	Lloh27, Lloh28
	.loh AdrpLdrGot	Lloh25, Lloh26
	.loh AdrpAdd	Lloh33, Lloh34
	.loh AdrpLdrGot	Lloh31, Lloh32
	.loh AdrpAdd	Lloh35, Lloh36
	.loh AdrpAdd	Lloh37, Lloh38
	.loh AdrpAdd	Lloh39, Lloh40
	.loh AdrpAdd	Lloh43, Lloh44
	.loh AdrpLdrGot	Lloh41, Lloh42
	.loh AdrpAdd	Lloh45, Lloh46
	.loh AdrpAdd	Lloh47, Lloh48
	.loh AdrpAdd	Lloh49, Lloh50
	.loh AdrpAdd	Lloh51, Lloh52
	.loh AdrpLdrGot	Lloh53, Lloh54
	.loh AdrpLdrGotLdr	Lloh55, Lloh56, Lloh57
Lfunc_end2:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table5:
Lexception2:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase0-Lttbaseref0
Lttbaseref0:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end2-Lcst_begin2
Lcst_begin2:
	.uleb128 Ltmp6-Lfunc_begin2             ; >> Call Site 1 <<
	.uleb128 Ltmp7-Ltmp6                    ;   Call between Ltmp6 and Ltmp7
	.uleb128 Ltmp8-Lfunc_begin2             ;     jumps to Ltmp8
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp7-Lfunc_begin2             ; >> Call Site 2 <<
	.uleb128 Ltmp12-Ltmp7                   ;   Call between Ltmp7 and Ltmp12
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp12-Lfunc_begin2            ; >> Call Site 3 <<
	.uleb128 Ltmp13-Ltmp12                  ;   Call between Ltmp12 and Ltmp13
	.uleb128 Ltmp14-Lfunc_begin2            ;     jumps to Ltmp14
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp13-Lfunc_begin2            ; >> Call Site 4 <<
	.uleb128 Ltmp18-Ltmp13                  ;   Call between Ltmp13 and Ltmp18
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp18-Lfunc_begin2            ; >> Call Site 5 <<
	.uleb128 Ltmp19-Ltmp18                  ;   Call between Ltmp18 and Ltmp19
	.uleb128 Ltmp20-Lfunc_begin2            ;     jumps to Ltmp20
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp19-Lfunc_begin2            ; >> Call Site 6 <<
	.uleb128 Ltmp21-Ltmp19                  ;   Call between Ltmp19 and Ltmp21
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp21-Lfunc_begin2            ; >> Call Site 7 <<
	.uleb128 Ltmp22-Ltmp21                  ;   Call between Ltmp21 and Ltmp22
	.uleb128 Ltmp23-Lfunc_begin2            ;     jumps to Ltmp23
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp22-Lfunc_begin2            ; >> Call Site 8 <<
	.uleb128 Ltmp27-Ltmp22                  ;   Call between Ltmp22 and Ltmp27
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp27-Lfunc_begin2            ; >> Call Site 9 <<
	.uleb128 Ltmp28-Ltmp27                  ;   Call between Ltmp27 and Ltmp28
	.uleb128 Ltmp29-Lfunc_begin2            ;     jumps to Ltmp29
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp28-Lfunc_begin2            ; >> Call Site 10 <<
	.uleb128 Ltmp141-Ltmp28                 ;   Call between Ltmp28 and Ltmp141
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp141-Lfunc_begin2           ; >> Call Site 11 <<
	.uleb128 Ltmp142-Ltmp141                ;   Call between Ltmp141 and Ltmp142
	.uleb128 Ltmp143-Lfunc_begin2           ;     jumps to Ltmp143
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp144-Lfunc_begin2           ; >> Call Site 12 <<
	.uleb128 Ltmp145-Ltmp144                ;   Call between Ltmp144 and Ltmp145
	.uleb128 Ltmp146-Lfunc_begin2           ;     jumps to Ltmp146
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp145-Lfunc_begin2           ; >> Call Site 13 <<
	.uleb128 Ltmp147-Ltmp145                ;   Call between Ltmp145 and Ltmp147
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp147-Lfunc_begin2           ; >> Call Site 14 <<
	.uleb128 Ltmp148-Ltmp147                ;   Call between Ltmp147 and Ltmp148
	.uleb128 Ltmp149-Lfunc_begin2           ;     jumps to Ltmp149
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp150-Lfunc_begin2           ; >> Call Site 15 <<
	.uleb128 Ltmp151-Ltmp150                ;   Call between Ltmp150 and Ltmp151
	.uleb128 Ltmp152-Lfunc_begin2           ;     jumps to Ltmp152
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp15-Lfunc_begin2            ; >> Call Site 16 <<
	.uleb128 Ltmp16-Ltmp15                  ;   Call between Ltmp15 and Ltmp16
	.uleb128 Ltmp17-Lfunc_begin2            ;     jumps to Ltmp17
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp24-Lfunc_begin2            ; >> Call Site 17 <<
	.uleb128 Ltmp25-Ltmp24                  ;   Call between Ltmp24 and Ltmp25
	.uleb128 Ltmp26-Lfunc_begin2            ;     jumps to Ltmp26
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp9-Lfunc_begin2             ; >> Call Site 18 <<
	.uleb128 Ltmp10-Ltmp9                   ;   Call between Ltmp9 and Ltmp10
	.uleb128 Ltmp11-Lfunc_begin2            ;     jumps to Ltmp11
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp10-Lfunc_begin2            ; >> Call Site 19 <<
	.uleb128 Ltmp30-Ltmp10                  ;   Call between Ltmp10 and Ltmp30
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp30-Lfunc_begin2            ; >> Call Site 20 <<
	.uleb128 Ltmp31-Ltmp30                  ;   Call between Ltmp30 and Ltmp31
	.uleb128 Ltmp32-Lfunc_begin2            ;     jumps to Ltmp32
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp33-Lfunc_begin2            ; >> Call Site 21 <<
	.uleb128 Ltmp34-Ltmp33                  ;   Call between Ltmp33 and Ltmp34
	.uleb128 Ltmp35-Lfunc_begin2            ;     jumps to Ltmp35
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp34-Lfunc_begin2            ; >> Call Site 22 <<
	.uleb128 Ltmp36-Ltmp34                  ;   Call between Ltmp34 and Ltmp36
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp36-Lfunc_begin2            ; >> Call Site 23 <<
	.uleb128 Ltmp37-Ltmp36                  ;   Call between Ltmp36 and Ltmp37
	.uleb128 Ltmp38-Lfunc_begin2            ;     jumps to Ltmp38
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp39-Lfunc_begin2            ; >> Call Site 24 <<
	.uleb128 Ltmp44-Ltmp39                  ;   Call between Ltmp39 and Ltmp44
	.uleb128 Ltmp45-Lfunc_begin2            ;     jumps to Ltmp45
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp46-Lfunc_begin2            ; >> Call Site 25 <<
	.uleb128 Ltmp47-Ltmp46                  ;   Call between Ltmp46 and Ltmp47
	.uleb128 Ltmp48-Lfunc_begin2            ;     jumps to Ltmp48
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp52-Lfunc_begin2            ; >> Call Site 26 <<
	.uleb128 Ltmp53-Ltmp52                  ;   Call between Ltmp52 and Ltmp53
	.uleb128 Ltmp54-Lfunc_begin2            ;     jumps to Ltmp54
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp55-Lfunc_begin2            ; >> Call Site 27 <<
	.uleb128 Ltmp56-Ltmp55                  ;   Call between Ltmp55 and Ltmp56
	.uleb128 Ltmp57-Lfunc_begin2            ;     jumps to Ltmp57
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp56-Lfunc_begin2            ; >> Call Site 28 <<
	.uleb128 Ltmp58-Ltmp56                  ;   Call between Ltmp56 and Ltmp58
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp58-Lfunc_begin2            ; >> Call Site 29 <<
	.uleb128 Ltmp59-Ltmp58                  ;   Call between Ltmp58 and Ltmp59
	.uleb128 Ltmp60-Lfunc_begin2            ;     jumps to Ltmp60
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp61-Lfunc_begin2            ; >> Call Site 30 <<
	.uleb128 Ltmp62-Ltmp61                  ;   Call between Ltmp61 and Ltmp62
	.uleb128 Ltmp63-Lfunc_begin2            ;     jumps to Ltmp63
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp62-Lfunc_begin2            ; >> Call Site 31 <<
	.uleb128 Ltmp69-Ltmp62                  ;   Call between Ltmp62 and Ltmp69
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp69-Lfunc_begin2            ; >> Call Site 32 <<
	.uleb128 Ltmp70-Ltmp69                  ;   Call between Ltmp69 and Ltmp70
	.uleb128 Ltmp71-Lfunc_begin2            ;     jumps to Ltmp71
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp72-Lfunc_begin2            ; >> Call Site 33 <<
	.uleb128 Ltmp73-Ltmp72                  ;   Call between Ltmp72 and Ltmp73
	.uleb128 Ltmp74-Lfunc_begin2            ;     jumps to Ltmp74
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp73-Lfunc_begin2            ; >> Call Site 34 <<
	.uleb128 Ltmp80-Ltmp73                  ;   Call between Ltmp73 and Ltmp80
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp80-Lfunc_begin2            ; >> Call Site 35 <<
	.uleb128 Ltmp81-Ltmp80                  ;   Call between Ltmp80 and Ltmp81
	.uleb128 Ltmp82-Lfunc_begin2            ;     jumps to Ltmp82
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp83-Lfunc_begin2            ; >> Call Site 36 <<
	.uleb128 Ltmp84-Ltmp83                  ;   Call between Ltmp83 and Ltmp84
	.uleb128 Ltmp85-Lfunc_begin2            ;     jumps to Ltmp85
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp84-Lfunc_begin2            ; >> Call Site 37 <<
	.uleb128 Ltmp91-Ltmp84                  ;   Call between Ltmp84 and Ltmp91
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp91-Lfunc_begin2            ; >> Call Site 38 <<
	.uleb128 Ltmp92-Ltmp91                  ;   Call between Ltmp91 and Ltmp92
	.uleb128 Ltmp93-Lfunc_begin2            ;     jumps to Ltmp93
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp94-Lfunc_begin2            ; >> Call Site 39 <<
	.uleb128 Ltmp103-Ltmp94                 ;   Call between Ltmp94 and Ltmp103
	.uleb128 Ltmp140-Lfunc_begin2           ;     jumps to Ltmp140
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp104-Lfunc_begin2           ; >> Call Site 40 <<
	.uleb128 Ltmp105-Ltmp104                ;   Call between Ltmp104 and Ltmp105
	.uleb128 Ltmp106-Lfunc_begin2           ;     jumps to Ltmp106
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp105-Lfunc_begin2           ; >> Call Site 41 <<
	.uleb128 Ltmp107-Ltmp105                ;   Call between Ltmp105 and Ltmp107
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp107-Lfunc_begin2           ; >> Call Site 42 <<
	.uleb128 Ltmp108-Ltmp107                ;   Call between Ltmp107 and Ltmp108
	.uleb128 Ltmp109-Lfunc_begin2           ;     jumps to Ltmp109
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp108-Lfunc_begin2           ; >> Call Site 43 <<
	.uleb128 Ltmp115-Ltmp108                ;   Call between Ltmp108 and Ltmp115
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp115-Lfunc_begin2           ; >> Call Site 44 <<
	.uleb128 Ltmp116-Ltmp115                ;   Call between Ltmp115 and Ltmp116
	.uleb128 Ltmp117-Lfunc_begin2           ;     jumps to Ltmp117
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp118-Lfunc_begin2           ; >> Call Site 45 <<
	.uleb128 Ltmp139-Ltmp118                ;   Call between Ltmp118 and Ltmp139
	.uleb128 Ltmp140-Lfunc_begin2           ;     jumps to Ltmp140
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp66-Lfunc_begin2            ; >> Call Site 46 <<
	.uleb128 Ltmp65-Ltmp66                  ;   Call between Ltmp66 and Ltmp65
	.uleb128 Ltmp68-Lfunc_begin2            ;     jumps to Ltmp68
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp77-Lfunc_begin2            ; >> Call Site 47 <<
	.uleb128 Ltmp76-Ltmp77                  ;   Call between Ltmp77 and Ltmp76
	.uleb128 Ltmp79-Lfunc_begin2            ;     jumps to Ltmp79
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp88-Lfunc_begin2            ; >> Call Site 48 <<
	.uleb128 Ltmp87-Ltmp88                  ;   Call between Ltmp88 and Ltmp87
	.uleb128 Ltmp90-Lfunc_begin2            ;     jumps to Ltmp90
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp112-Lfunc_begin2           ; >> Call Site 49 <<
	.uleb128 Ltmp111-Ltmp112                ;   Call between Ltmp112 and Ltmp111
	.uleb128 Ltmp114-Lfunc_begin2           ;     jumps to Ltmp114
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp49-Lfunc_begin2            ; >> Call Site 50 <<
	.uleb128 Ltmp50-Ltmp49                  ;   Call between Ltmp49 and Ltmp50
	.uleb128 Ltmp51-Lfunc_begin2            ;     jumps to Ltmp51
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp50-Lfunc_begin2            ; >> Call Site 51 <<
	.uleb128 Ltmp153-Ltmp50                 ;   Call between Ltmp50 and Ltmp153
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp153-Lfunc_begin2           ; >> Call Site 52 <<
	.uleb128 Ltmp156-Ltmp153                ;   Call between Ltmp153 and Ltmp156
	.uleb128 Ltmp157-Lfunc_begin2           ;     jumps to Ltmp157
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp161-Lfunc_begin2           ; >> Call Site 53 <<
	.uleb128 Ltmp162-Ltmp161                ;   Call between Ltmp161 and Ltmp162
	.uleb128 Ltmp163-Lfunc_begin2           ;     jumps to Ltmp163
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp162-Lfunc_begin2           ; >> Call Site 54 <<
	.uleb128 Ltmp158-Ltmp162                ;   Call between Ltmp162 and Ltmp158
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp158-Lfunc_begin2           ; >> Call Site 55 <<
	.uleb128 Ltmp159-Ltmp158                ;   Call between Ltmp158 and Ltmp159
	.uleb128 Ltmp160-Lfunc_begin2           ;     jumps to Ltmp160
	.byte	9                               ;   On action: 5
	.uleb128 Ltmp159-Lfunc_begin2           ; >> Call Site 56 <<
	.uleb128 Lfunc_end2-Ltmp159             ;   Call between Ltmp159 and Lfunc_end2
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
	.byte	121                             ;   Continue to action 2
	.p2align	2, 0x0
                                        ; >> Catch TypeInfos <<
	.long	0                               ; TypeInfo 3
Ltmp192:                                ; TypeInfo 2
	.long	__ZTISt16invalid_argument@GOT-Ltmp192
Ltmp193:                                ; TypeInfo 1
	.long	__ZTISt9exception@GOT-Ltmp193
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
Lloh58:
	adrp	x0, l_.str.9@PAGE
Lloh59:
	add	x0, x0, l_.str.9@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh58, Lloh59
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
Ltmp164:
	mov	x1, x20
	bl	__ZNSt12length_errorC1B9nqe210106EPKc
Ltmp165:
; %bb.1:
Lloh60:
	adrp	x1, __ZTISt12length_error@GOTPAGE
Lloh61:
	ldr	x1, [x1, __ZTISt12length_error@GOTPAGEOFF]
Lloh62:
	adrp	x2, __ZNSt12length_errorD1Ev@GOTPAGE
Lloh63:
	ldr	x2, [x2, __ZNSt12length_errorD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
LBB8_2:
Ltmp166:
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x0, x20
	bl	__Unwind_Resume
	.loh AdrpLdrGot	Lloh62, Lloh63
	.loh AdrpLdrGot	Lloh60, Lloh61
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
	.uleb128 Ltmp164-Lfunc_begin3           ;   Call between Lfunc_begin3 and Ltmp164
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp164-Lfunc_begin3           ; >> Call Site 2 <<
	.uleb128 Ltmp165-Ltmp164                ;   Call between Ltmp164 and Ltmp165
	.uleb128 Ltmp166-Lfunc_begin3           ;     jumps to Ltmp166
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp165-Lfunc_begin3           ; >> Call Site 3 <<
	.uleb128 Lfunc_end3-Ltmp165             ;   Call between Ltmp165 and Lfunc_end3
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
Lloh64:
	adrp	x8, __ZTVSt12length_error@GOTPAGE
Lloh65:
	ldr	x8, [x8, __ZTVSt12length_error@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x0]
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
	.loh AdrpLdrGot	Lloh64, Lloh65
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
Lloh66:
	adrp	x1, __ZTISt20bad_array_new_length@GOTPAGE
Lloh67:
	ldr	x1, [x1, __ZTISt20bad_array_new_length@GOTPAGEOFF]
Lloh68:
	adrp	x2, __ZNSt20bad_array_new_lengthD1Ev@GOTPAGE
Lloh69:
	ldr	x2, [x2, __ZNSt20bad_array_new_lengthD1Ev@GOTPAGEOFF]
	bl	___cxa_throw
	.loh AdrpLdrGot	Lloh68, Lloh69
	.loh AdrpLdrGot	Lloh66, Lloh67
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
Ltmp167:
	add	x0, sp, #8
	mov	x1, x19
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryC1ERS3_
Ltmp168:
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
Ltmp170:
	add	x8, sp, #24
	mov	x25, x4
	mov	x0, x4
	bl	__ZNKSt3__18ios_base6getlocEv
Ltmp171:
; %bb.4:
Ltmp172:
Lloh70:
	adrp	x1, __ZNSt3__15ctypeIcE2idE@GOTPAGE
Lloh71:
	ldr	x1, [x1, __ZNSt3__15ctypeIcE2idE@GOTPAGEOFF]
	add	x0, sp, #24
	bl	__ZNKSt3__16locale9use_facetERNS0_2idE
Ltmp173:
; %bb.5:
	ldr	x8, [x0]
	ldr	x8, [x8, #56]
Ltmp174:
	mov	w1, #32                         ; =0x20
	blr	x8
Ltmp175:
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
Ltmp177:
	sxtb	w5, w23
	mov	x0, x22
	mov	x1, x20
	bl	__ZNSt3__116__pad_and_outputB9nqe210106IcNS_11char_traitsIcEEEENS_19ostreambuf_iteratorIT_T0_EES6_PKS4_S8_S8_RNS_8ios_baseES4_
Ltmp178:
; %bb.8:
	cbnz	x0, LBB11_10
; %bb.9:
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
	add	x0, x19, x8
	ldr	w8, [x0, #32]
	mov	w9, #5                          ; =0x5
Ltmp180:
	orr	w1, w8, w9
	bl	__ZNSt3__18ios_base5clearEj
Ltmp181:
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
Ltmp182:
	b	LBB11_15
LBB11_13:
Ltmp176:
	mov	x20, x0
	add	x0, sp, #24
	bl	__ZNSt3__16localeD1Ev
	b	LBB11_16
LBB11_14:
Ltmp179:
LBB11_15:
	mov	x20, x0
LBB11_16:
	add	x0, sp, #8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryD1Ev
	b	LBB11_18
LBB11_17:
Ltmp169:
	mov	x20, x0
LBB11_18:
	mov	x0, x20
	bl	___cxa_begin_catch
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
Ltmp183:
	add	x0, x19, x8
	bl	__ZNSt3__18ios_base33__set_badbit_and_consider_rethrowEv
Ltmp184:
; %bb.19:
	bl	___cxa_end_catch
	b	LBB11_11
LBB11_20:
Ltmp185:
	mov	x19, x0
Ltmp186:
	bl	___cxa_end_catch
Ltmp187:
; %bb.21:
	mov	x0, x19
	bl	__Unwind_Resume
LBB11_22:
Ltmp188:
	bl	___clang_call_terminate
	.loh AdrpLdrGot	Lloh70, Lloh71
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
	.uleb128 Ltmp167-Lfunc_begin4           ; >> Call Site 1 <<
	.uleb128 Ltmp168-Ltmp167                ;   Call between Ltmp167 and Ltmp168
	.uleb128 Ltmp169-Lfunc_begin4           ;     jumps to Ltmp169
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp170-Lfunc_begin4           ; >> Call Site 2 <<
	.uleb128 Ltmp171-Ltmp170                ;   Call between Ltmp170 and Ltmp171
	.uleb128 Ltmp179-Lfunc_begin4           ;     jumps to Ltmp179
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp172-Lfunc_begin4           ; >> Call Site 3 <<
	.uleb128 Ltmp175-Ltmp172                ;   Call between Ltmp172 and Ltmp175
	.uleb128 Ltmp176-Lfunc_begin4           ;     jumps to Ltmp176
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp177-Lfunc_begin4           ; >> Call Site 4 <<
	.uleb128 Ltmp178-Ltmp177                ;   Call between Ltmp177 and Ltmp178
	.uleb128 Ltmp179-Lfunc_begin4           ;     jumps to Ltmp179
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp180-Lfunc_begin4           ; >> Call Site 5 <<
	.uleb128 Ltmp181-Ltmp180                ;   Call between Ltmp180 and Ltmp181
	.uleb128 Ltmp182-Lfunc_begin4           ;     jumps to Ltmp182
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp181-Lfunc_begin4           ; >> Call Site 6 <<
	.uleb128 Ltmp183-Ltmp181                ;   Call between Ltmp181 and Ltmp183
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp183-Lfunc_begin4           ; >> Call Site 7 <<
	.uleb128 Ltmp184-Ltmp183                ;   Call between Ltmp183 and Ltmp184
	.uleb128 Ltmp185-Lfunc_begin4           ;     jumps to Ltmp185
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp184-Lfunc_begin4           ; >> Call Site 8 <<
	.uleb128 Ltmp186-Ltmp184                ;   Call between Ltmp184 and Ltmp186
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp186-Lfunc_begin4           ; >> Call Site 9 <<
	.uleb128 Ltmp187-Ltmp186                ;   Call between Ltmp186 and Ltmp187
	.uleb128 Ltmp188-Lfunc_begin4           ;     jumps to Ltmp188
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp187-Lfunc_begin4           ; >> Call Site 10 <<
	.uleb128 Lfunc_end4-Ltmp187             ;   Call between Ltmp187 and Lfunc_end4
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
Ltmp189:
	mov	x0, x19
	mov	x2, x24
	blr	x8
Ltmp190:
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
Ltmp191:
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
	.uleb128 Ltmp189-Lfunc_begin5           ;   Call between Lfunc_begin5 and Ltmp189
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp189-Lfunc_begin5           ; >> Call Site 2 <<
	.uleb128 Ltmp190-Ltmp189                ;   Call between Ltmp189 and Ltmp190
	.uleb128 Ltmp191-Lfunc_begin5           ;     jumps to Ltmp191
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp190-Lfunc_begin5           ; >> Call Site 3 <<
	.uleb128 Lfunc_end5-Ltmp190             ;   Call between Ltmp190 and Lfunc_end5
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
Lloh72:
	adrp	x0, l_.str.10@PAGE
Lloh73:
	add	x0, x0, l_.str.10@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh72, Lloh73
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
Lloh74:
	adrp	x0, l_.str.9@PAGE
Lloh75:
	add	x0, x0, l_.str.9@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh74, Lloh75
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _Z7requireb.cold.1
__Z7requireb.cold.1:                    ; @_Z7requireb.cold.1
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh76:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh77:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh78:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh79:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	bl	___cxa_throw
	.loh AdrpLdrGot	Lloh78, Lloh79
	.loh AdrpLdrGot	Lloh76, Lloh77
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _Z4packRKNSt3__16vectorIfNS_9allocatorIfEEEEii.cold.1
__Z4packRKNSt3__16vectorIfNS_9allocatorIfEEEEii.cold.1: ; @_Z4packRKNSt3__16vectorIfNS_9allocatorIfEEEEii.cold.1
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh80:
	adrp	x1, __ZTISt16invalid_argument@GOTPAGE
Lloh81:
	ldr	x1, [x1, __ZTISt16invalid_argument@GOTPAGEOFF]
Lloh82:
	adrp	x2, __ZNSt16invalid_argumentD1Ev@GOTPAGE
Lloh83:
	ldr	x2, [x2, __ZNSt16invalid_argumentD1Ev@GOTPAGEOFF]
	bl	___cxa_throw
	.loh AdrpLdrGot	Lloh82, Lloh83
	.loh AdrpLdrGot	Lloh80, Lloh81
	.cfi_endproc
                                        ; -- End function
	.globl	_sink                           ; @sink
.zerofill __DATA,__common,_sink,4,2
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"validation failed"

l_.str.1:                               ; @.str.1
	.asciz	"shape"

l_.str.2:                               ; @.str.2
	.asciz	"PASS cases="

l_.str.3:                               ; @.str.3
	.asciz	" zero shape rejected\n"

l_.str.4:                               ; @.str.4
	.asciz	"M="

l_.str.5:                               ; @.str.5
	.asciz	" N=65 K=129 CPU_batch_mean_p50_us scalar="

l_.str.6:                               ; @.str.6
	.asciz	" neon1="

l_.str.7:                               ; @.str.7
	.asciz	" neon2="

l_.str.8:                               ; @.str.8
	.asciz	" pack_alloc_plus_neon2="

l_.str.9:                               ; @.str.9
	.asciz	"vector"

l_.str.10:                              ; @.str.10
	.asciz	"basic_string"

	.section	__TEXT,__literal16,16byte_literals
	.p2align	4, 0x0                          ; @.memset_pattern
l_.memset_pattern:
	.long	0x3e000000                      ; float 0.125
	.long	0x3e000000                      ; float 0.125
	.long	0x3e000000                      ; float 0.125
	.long	0x3e000000                      ; float 0.125

	.p2align	4, 0x0                          ; @.memset_pattern.11
l_.memset_pattern.11:
	.long	0x3e800000                      ; float 0.25
	.long	0x3e800000                      ; float 0.25
	.long	0x3e800000                      ; float 0.25
	.long	0x3e800000                      ; float 0.25

.subsections_via_symbols
