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
	.globl	__Z10percentileNSt3__16vectorIdNS_9allocatorIdEEEEd ; -- Begin function _Z10percentileNSt3__16vectorIdNS_9allocatorIdEEEEd
	.p2align	2
__Z10percentileNSt3__16vectorIdNS_9allocatorIdEEEEd: ; @_Z10percentileNSt3__16vectorIdNS_9allocatorIdEEEEd
Lfunc_begin1:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception1
; %bb.0:
	sub	sp, sp, #64
	stp	d9, d8, [sp, #16]               ; 16-byte Folded Spill
	stp	x20, x19, [sp, #32]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #48]             ; 16-byte Folded Spill
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset b8, -40
	.cfi_offset b9, -48
	mov	x19, x0
	ldr	x0, [x0]
	ldr	x1, [x19, #8]
	cmp	x0, x1
	b.eq	LBB1_3
; %bb.1:
	mov.16b	v8, v0
	add	x2, sp, #15
	bl	__ZNSt3__16__sortIRNS_6__lessIddEEPdEEvT0_S5_T_
	ldp	x8, x9, [x19]
	sub	x9, x9, x8
	asr	x10, x9, #3
	ucvtf	d0, x10
	fmul	d0, d8, d0
	fcvtpu	x9, d0
	sub	x9, x9, #1
	cmp	x9, x10
	b.hs	LBB1_5
; %bb.2:
	ldr	d0, [x8, x9, lsl #3]
	ldp	x29, x30, [sp, #48]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #32]             ; 16-byte Folded Reload
	ldp	d9, d8, [sp, #16]               ; 16-byte Folded Reload
	add	sp, sp, #64
	ret
LBB1_3:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp3:
Lloh2:
	adrp	x1, l_.str@PAGE
Lloh3:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp4:
; %bb.4:
	mov	x0, x19
	bl	__Z10percentileNSt3__16vectorIdNS_9allocatorIdEEEEd.cold.1
LBB1_5:
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_out_of_rangeB9nqe210106Ev
LBB1_6:
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
	.globl	_main                           ; -- Begin function main
	.p2align	2
_main:                                  ; @main
Lfunc_begin2:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception2
; %bb.0:
	sub	sp, sp, #384
	stp	d13, d12, [sp, #240]            ; 16-byte Folded Spill
	stp	d11, d10, [sp, #256]            ; 16-byte Folded Spill
	stp	d9, d8, [sp, #272]              ; 16-byte Folded Spill
	stp	x28, x27, [sp, #288]            ; 16-byte Folded Spill
	stp	x26, x25, [sp, #304]            ; 16-byte Folded Spill
	stp	x24, x23, [sp, #320]            ; 16-byte Folded Spill
	stp	x22, x21, [sp, #336]            ; 16-byte Folded Spill
	stp	x20, x19, [sp, #352]            ; 16-byte Folded Spill
	stp	x29, x30, [sp, #368]            ; 16-byte Folded Spill
	add	x29, sp, #368
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
	cmp	w0, #4
	b.ge	LBB2_118
; %bb.1:
	mov	x21, x0
	mov	w19, #3                         ; =0x3
	movk	w19, #1, lsl #16
	cmp	w0, #2
	b.lt	LBB2_5
; %bb.2:
	mov	x20, x1
	mov	x26, #-10                       ; =0xfffffffffffffff6
	movk	x26, #32767, lsl #48
	ldr	x23, [x1, #8]
	mov	x0, x23
	bl	_strlen
	cmp	x0, x26
	b.hi	LBB2_126
; %bb.3:
	mov	x22, x0
	cmp	x0, #23
	b.hs	LBB2_6
; %bb.4:
	strb	w22, [sp, #135]
	add	x24, sp, #112
	cbnz	x22, LBB2_8
	b	LBB2_9
LBB2_5:
	mov	w24, #2                         ; =0x2
	b	LBB2_22
LBB2_6:
	orr	x8, x22, #0x7
	cmp	x8, #23
	mov	w9, #25                         ; =0x19
	csinc	x25, x9, x8, eq
Ltmp6:
	mov	x0, x25
	bl	__Znwm
Ltmp7:
; %bb.7:
	mov	x24, x0
	orr	x8, x25, #0x8000000000000000
	stp	x22, x8, [sp, #120]
	str	x0, [sp, #112]
LBB2_8:
	mov	x0, x24
	mov	x1, x23
	mov	x2, x22
	bl	_memmove
LBB2_9:
	strb	wzr, [x24, x22]
Ltmp8:
	add	x0, sp, #112
	mov	x1, #0                          ; =0x0
	mov	w2, #10                         ; =0xa
	bl	__ZNSt3__14stoiERKNS_12basic_stringIcNS_11char_traitsIcEENS_9allocatorIcEEEEPmi
Ltmp9:
; %bb.10:
	mov	x24, x0
	ldrsb	w8, [sp, #135]
	tbnz	w8, #31, LBB2_12
; %bb.11:
	cmp	w21, #3
	b.eq	LBB2_13
	b	LBB2_22
LBB2_12:
	ldr	x0, [sp, #112]
	bl	__ZdlPv
	cmp	w21, #3
	b.ne	LBB2_22
LBB2_13:
	ldr	x20, [x20, #16]
	mov	x0, x20
	bl	_strlen
	cmp	x0, x26
	b.hi	LBB2_127
; %bb.14:
	mov	x19, x0
	cmp	x0, #23
	b.hs	LBB2_16
; %bb.15:
	strb	w19, [sp, #135]
	add	x21, sp, #112
	cbnz	x19, LBB2_18
	b	LBB2_19
LBB2_16:
	orr	x8, x19, #0x7
	cmp	x8, #23
	mov	w9, #25                         ; =0x19
	csinc	x23, x9, x8, eq
Ltmp11:
	mov	x0, x23
	bl	__Znwm
Ltmp12:
; %bb.17:
	mov	x21, x0
	orr	x8, x23, #0x8000000000000000
	stp	x19, x8, [sp, #120]
	str	x0, [sp, #112]
LBB2_18:
	mov	x0, x21
	mov	x1, x20
	mov	x2, x19
	bl	_memmove
LBB2_19:
	strb	wzr, [x21, x19]
Ltmp13:
	add	x0, sp, #112
	mov	x1, #0                          ; =0x0
	mov	w2, #10                         ; =0xa
	bl	__ZNSt3__15stollERKNS_12basic_stringIcNS_11char_traitsIcEENS_9allocatorIcEEEEPmi
Ltmp14:
; %bb.20:
	mov	x19, x0
	ldrsb	w8, [sp, #135]
	tbz	w8, #31, LBB2_22
; %bb.21:
	ldr	x0, [sp, #112]
	bl	__ZdlPv
LBB2_22:
	sub	w8, w24, #601
	cmn	w8, #600
	b.lo	LBB2_120
; %bb.23:
	mov	w8, #2                          ; =0x2
	movk	w8, #16, lsl #16
	cmp	x19, x8
	b.hs	LBB2_120
; %bb.24:
	stp	xzr, x19, [x29, #-160]
	stp	xzr, xzr, [x29, #-176]
	cbz	x19, LBB2_30
; %bb.25:
	lsl	x21, x19, #2
Ltmp16:
	mov	x0, x21
	bl	__Znwm
Ltmp17:
; %bb.26:
	mov	x20, x0
	add	x8, x0, x19, lsl #2
	stur	x0, [x29, #-176]
	stur	x8, [x29, #-160]
	add	x23, x0, x21
	mov	x1, x21
	bl	_bzero
	stur	x23, [x29, #-168]
Ltmp19:
	mov	x0, x19
	bl	__Znwm
Ltmp20:
; %bb.27:
	mov	x21, x0
	add	x23, x0, x19
	str	x0, [sp, #168]
	str	x23, [sp, #184]
	mov	x1, x19
	bl	_bzero
	str	x23, [sp, #176]
Ltmp22:
	mov	x0, x19
	bl	__Znwm
Ltmp23:
; %bb.28:
	add	x23, x0, x19
	str	x0, [sp, #144]
	str	x23, [sp, #160]
	mov	x1, x19
	bl	_bzero
	str	x23, [sp, #152]
	mov	x8, #1027                       ; =0x403
	movk	x8, #4104, lsl #16
	movk	x8, #16416, lsl #32
	movk	x8, #128, lsl #48
	cmp	x19, #4
	b.hs	LBB2_31
; %bb.29:
	mov	x9, #0                          ; =0x0
	b	LBB2_34
LBB2_30:
	mov	x20, #0                         ; =0x0
	mov	x21, #0                         ; =0x0
	stp	xzr, xzr, [sp, #168]
	str	xzr, [sp, #184]
	stp	xzr, xzr, [sp, #144]
	str	xzr, [sp, #160]
	b	LBB2_36
LBB2_31:
	mov	x10, #0                         ; =0x0
	and	x9, x19, #0x1ffffc
	add	x11, x20, #8
	mov	w12, #-252                      ; =0xffffff04
	mov	w13, #-253                      ; =0xffffff03
	mov	w14, #-254                      ; =0xffffff02
	mov	w15, #-255                      ; =0xffffff01
	mov	w16, #3                         ; =0x3
	mov	w17, #2                         ; =0x2
	mov	w0, #1                          ; =0x1
	mov	x1, x9
LBB2_32:                                ; =>This Inner Loop Header: Depth=1
	umulh	x2, x16, x8
	sub	x3, x16, x2
	add	x2, x2, x3, lsr #1
	lsr	x2, x2, #8
	sub	w2, w2, w2, lsl #9
	add	w2, w12, w2
	umulh	x3, x17, x8
	sub	x4, x17, x3
	add	x3, x3, x4, lsr #1
	lsr	x3, x3, #8
	sub	w3, w3, w3, lsl #9
	add	w3, w13, w3
	umulh	x4, x0, x8
	sub	x5, x0, x4
	add	x4, x4, x5, lsr #1
	lsr	x4, x4, #8
	sub	w4, w4, w4, lsl #9
	add	w4, w14, w4
	umulh	x5, x10, x8
	sub	x6, x10, x5
	add	x5, x5, x6, lsr #1
	lsr	x5, x5, #8
	sub	w5, w5, w5, lsl #9
	add	w5, w15, w5
	scvtf	s0, w5, #1
	scvtf	s1, w4, #1
	scvtf	s2, w3, #1
	scvtf	s3, w2, #1
	add	x10, x10, #4
	add	w12, w12, #4
	stp	s0, s1, [x11, #-8]
	add	x16, x16, #4
	add	w13, w13, #4
	add	x17, x17, #4
	add	w14, w14, #4
	stp	s2, s3, [x11], #16
	add	x0, x0, #4
	add	w15, w15, #4
	subs	x1, x1, #4
	b.ne	LBB2_32
; %bb.33:
	cmp	x19, x9
	b.eq	LBB2_36
LBB2_34:
	sub	x10, x19, x9
	sub	w11, w9, #255
	lsl	x12, x9, #2
LBB2_35:                                ; =>This Inner Loop Header: Depth=1
	umulh	x13, x9, x8
	sub	x14, x9, x13
	add	x13, x13, x14, lsr #1
	lsr	x13, x13, #8
	sub	w13, w13, w13, lsl #9
	add	w13, w11, w13
	scvtf	s0, w13, #1
	str	s0, [x20, x12]
	add	x9, x9, #1
	add	w11, w11, #1
	add	x12, x12, #4
	subs	x10, x10, #1
	b.ne	LBB2_35
LBB2_36:
Ltmp25:
	fmov	s0, #1.25000000
	mov	x0, x20
	mov	x1, x21
	mov	x2, x19
	bl	__ZN8practice6scalarEPKfPamf
Ltmp26:
; %bb.37:
	mov	w19, #20                        ; =0x14
LBB2_38:                                ; =>This Inner Loop Header: Depth=1
	ldur	x0, [x29, #-176]
	ldr	x1, [sp, #144]
	ldur	x2, [x29, #-152]
Ltmp28:
	fmov	s0, #1.25000000
	bl	__ZN8practice4neonEPKfPamf
Ltmp29:
; %bb.39:                               ;   in Loop: Header=BB2_38 Depth=1
	subs	w19, w19, #1
	b.ne	LBB2_38
; %bb.40:
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x23, x0
Ltmp31:
	mov	x28, #0                         ; =0x0
	mov	x22, #0                         ; =0x0
Lloh4:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh5:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh6:
	adrp	x1, l_.str.3@PAGE
Lloh7:
	add	x1, x1, l_.str.3@PAGEOFF
	mov	w2, #28                         ; =0x1c
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp32:
; %bb.41:
	mov	x26, #0                         ; =0x0
	stp	xzr, xzr, [sp]                  ; 16-byte Folded Spill
	mov	x19, #0                         ; =0x0
	mov	x27, #0                         ; =0x0
	mov	x22, #0                         ; =0x0
	mov	x21, #0                         ; =0x0
	ucvtf	d10, w24
	fmov	d0, #3.00000000
	fdiv	d11, d10, d0
	lsl	w8, w24, #1
	ucvtf	d1, w8
	mov	x28, #225833675390976           ; =0xcd6500000000
	movk	x28, #16845, lsl #48
	fdiv	d12, d1, d0
	b	LBB2_43
LBB2_42:                                ;   in Loop: Header=BB2_43 Depth=1
	add	x21, x21, #1
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	sub	x8, x0, x23
	scvtf	d0, x8
	fmov	d1, x28
	fdiv	d0, d0, d1
	fcmp	d0, d10
	b.pl	LBB2_76
LBB2_43:                                ; =>This Inner Loop Header: Depth=1
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x24, x0
	sub	x8, x29, #176
	str	x8, [sp, #112]
	add	x8, sp, #144
	str	x8, [sp, #120]
	sub	x8, x29, #152
	str	x8, [sp, #128]
	add	x8, sp, #168
	str	x8, [sp, #136]
	tbnz	w21, #0, LBB2_47
; %bb.44:                               ;   in Loop: Header=BB2_43 Depth=1
Ltmp37:
	add	x0, sp, #112
	mov	w1, #0                          ; =0x0
	bl	__ZZ4mainENK3$_0clEb
Ltmp38:
; %bb.45:                               ;   in Loop: Header=BB2_43 Depth=1
Ltmp39:
	mov.16b	v9, v0
	add	x0, sp, #112
	mov	w1, #1                          ; =0x1
	bl	__ZZ4mainENK3$_0clEb
Ltmp40:
; %bb.46:                               ;   in Loop: Header=BB2_43 Depth=1
	mov.16b	v8, v0
	b	LBB2_50
LBB2_47:                                ;   in Loop: Header=BB2_43 Depth=1
Ltmp33:
	add	x0, sp, #112
	mov	w1, #1                          ; =0x1
	bl	__ZZ4mainENK3$_0clEb
Ltmp34:
; %bb.48:                               ;   in Loop: Header=BB2_43 Depth=1
Ltmp35:
	mov.16b	v8, v0
	add	x0, sp, #112
	mov	w1, #0                          ; =0x0
	bl	__ZZ4mainENK3$_0clEb
Ltmp36:
; %bb.49:                               ;   in Loop: Header=BB2_43 Depth=1
	mov.16b	v9, v0
LBB2_50:                                ;   in Loop: Header=BB2_43 Depth=1
	sub	x8, x24, x23
	scvtf	d0, x8
	fmov	d1, x28
	fdiv	d0, d0, d1
	fcmp	d0, d11
	b.pl	LBB2_54
; %bb.51:                               ;   in Loop: Header=BB2_43 Depth=1
	sub	x24, x27, x22
	asr	x25, x24, #3
	mov	w8, #34464                      ; =0x86a0
	movk	w8, #1, lsl #16
	cmp	x25, x8
	b.hs	LBB2_68
; %bb.52:                               ;   in Loop: Header=BB2_43 Depth=1
	cmp	x27, x19
	b.hs	LBB2_58
; %bb.53:                               ;   in Loop: Header=BB2_43 Depth=1
	str	d8, [x27], #8
	b	LBB2_68
LBB2_54:                                ;   in Loop: Header=BB2_43 Depth=1
	fcmp	d0, d12
	b.lt	LBB2_68
; %bb.55:                               ;   in Loop: Header=BB2_43 Depth=1
	ldp	x9, x8, [sp]                    ; 16-byte Folded Reload
	sub	x24, x9, x8
	asr	x25, x24, #3
	mov	w8, #34464                      ; =0x86a0
	movk	w8, #1, lsl #16
	cmp	x25, x8
	b.hs	LBB2_68
; %bb.56:                               ;   in Loop: Header=BB2_43 Depth=1
	cmp	x9, x26
	b.hs	LBB2_63
; %bb.57:                               ;   in Loop: Header=BB2_43 Depth=1
	str	d8, [x9], #8
	str	x9, [sp]                        ; 8-byte Folded Spill
	b	LBB2_68
LBB2_58:                                ;   in Loop: Header=BB2_43 Depth=1
	add	x8, x25, #1
	mov	x20, x22
	sub	x9, x19, x22
	asr	x10, x9, #2
	cmp	x10, x8
	csinc	x8, x10, x25, hi
	mov	x10, #9223372036854775800       ; =0x7ffffffffffffff8
	cmp	x9, x10
	mov	x9, #2305843009213693951        ; =0x1fffffffffffffff
	csel	x19, x8, x9, lo
	lsr	x8, x19, #61
	cbnz	x8, LBB2_117
; %bb.59:                               ;   in Loop: Header=BB2_43 Depth=1
	mov.16b	v13, v0
	lsl	x0, x19, #3
Ltmp44:
	bl	__Znwm
Ltmp45:
; %bb.60:                               ;   in Loop: Header=BB2_43 Depth=1
	add	x27, x0, x24
	add	x19, x0, x19, lsl #3
	sub	x22, x27, x25, lsl #3
	str	d8, [x27], #8
	mov	x0, x22
	mov	x1, x20
	mov	x2, x24
	bl	_memcpy
	cbz	x20, LBB2_62
; %bb.61:                               ;   in Loop: Header=BB2_43 Depth=1
	mov	x0, x20
	bl	__ZdlPv
LBB2_62:                                ;   in Loop: Header=BB2_43 Depth=1
	mov.16b	v0, v13
	b	LBB2_68
LBB2_63:                                ;   in Loop: Header=BB2_43 Depth=1
	mov	x20, x22
	add	x8, x25, #1
	ldr	x9, [sp, #8]                    ; 8-byte Folded Reload
	sub	x9, x26, x9
	asr	x10, x9, #2
	cmp	x10, x8
	csinc	x8, x10, x25, hi
	mov	x10, #9223372036854775800       ; =0x7ffffffffffffff8
	cmp	x9, x10
	mov	x9, #2305843009213693951        ; =0x1fffffffffffffff
	csel	x22, x8, x9, lo
	lsr	x8, x22, #61
	cbnz	x8, LBB2_117
; %bb.64:                               ;   in Loop: Header=BB2_43 Depth=1
	mov.16b	v13, v0
	lsl	x0, x22, #3
Ltmp42:
	bl	__Znwm
Ltmp43:
; %bb.65:                               ;   in Loop: Header=BB2_43 Depth=1
	add	x8, x0, x24
	add	x26, x0, x22, lsl #3
	sub	x25, x8, x25, lsl #3
	str	d8, [x8], #8
	str	x8, [sp]                        ; 8-byte Folded Spill
	mov	x0, x25
	ldr	x22, [sp, #8]                   ; 8-byte Folded Reload
	mov	x1, x22
	mov	x2, x24
	bl	_memcpy
	cbz	x22, LBB2_67
; %bb.66:                               ;   in Loop: Header=BB2_43 Depth=1
	mov	x0, x22
	bl	__ZdlPv
LBB2_67:                                ;   in Loop: Header=BB2_43 Depth=1
	str	x25, [sp, #8]                   ; 8-byte Folded Spill
	mov.16b	v0, v13
	mov	x22, x20
LBB2_68:                                ;   in Loop: Header=BB2_43 Depth=1
	lsr	x8, x21, #3
	mov	x9, #63439                      ; =0xf7cf
	movk	x9, #58195, lsl #16
	movk	x9, #39845, lsl #32
	movk	x9, #8388, lsl #48
	umulh	x8, x8, x9
	lsr	x8, x8, #4
	mov	w9, #1000                       ; =0x3e8
	mul	x8, x8, x9
	cmp	x8, x21
	b.ne	LBB2_42
; %bb.69:                               ;   in Loop: Header=BB2_43 Depth=1
Ltmp49:
	mov	x20, x22
Lloh8:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh9:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp50:
; %bb.70:                               ;   in Loop: Header=BB2_43 Depth=1
	mov	w8, #44                         ; =0x2c
	sturb	w8, [x29, #-137]
Ltmp51:
	sub	x1, x29, #137
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp52:
; %bb.71:                               ;   in Loop: Header=BB2_43 Depth=1
Ltmp53:
	mov.16b	v0, v9
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp54:
; %bb.72:                               ;   in Loop: Header=BB2_43 Depth=1
	mov	w8, #44                         ; =0x2c
	sturb	w8, [x29, #-137]
Ltmp55:
	sub	x1, x29, #137
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp56:
; %bb.73:                               ;   in Loop: Header=BB2_43 Depth=1
Ltmp57:
	mov.16b	v0, v8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp58:
; %bb.74:                               ;   in Loop: Header=BB2_43 Depth=1
	mov	w8, #10                         ; =0xa
	sturb	w8, [x29, #-137]
Ltmp59:
	sub	x1, x29, #137
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp60:
; %bb.75:                               ;   in Loop: Header=BB2_43 Depth=1
	mov	x22, x20
	b	LBB2_42
LBB2_76:
	cmp	x22, x27
	ldp	x19, x28, [sp]                  ; 16-byte Folded Reload
	b.eq	LBB2_122
; %bb.77:
	cmp	x28, x19
	b.eq	LBB2_122
; %bb.78:
Ltmp67:
Lloh10:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh11:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh12:
	adrp	x1, l_.str.4@PAGE
Lloh13:
	add	x1, x1, l_.str.4@PAGEOFF
	mov	w2, #7                          ; =0x7
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp68:
; %bb.79:
	ldur	x1, [x29, #-152]
Ltmp69:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp70:
; %bb.80:
Ltmp71:
Lloh14:
	adrp	x1, l_.str.5@PAGE
Lloh15:
	add	x1, x1, l_.str.5@PAGEOFF
	mov	w2, #10                         ; =0xa
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp72:
; %bb.81:
Ltmp73:
	mov	x1, x21
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp74:
; %bb.82:
Ltmp75:
Lloh16:
	adrp	x1, l_.str.6@PAGE
Lloh17:
	add	x1, x1, l_.str.6@PAGEOFF
	mov	w2, #9                          ; =0x9
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp76:
; %bb.83:
	sub	x23, x27, x22
	asr	x1, x23, #3
Ltmp77:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp78:
; %bb.84:
Ltmp79:
Lloh18:
	adrp	x1, l_.str.7@PAGE
Lloh19:
	add	x1, x1, l_.str.7@PAGEOFF
	mov	w2, #8                          ; =0x8
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp80:
; %bb.85:
	sub	x20, x19, x28
	asr	x1, x20, #3
Ltmp81:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp82:
; %bb.86:
Ltmp83:
Lloh20:
	adrp	x1, l_.str.8@PAGE
Lloh21:
	add	x1, x1, l_.str.8@PAGEOFF
	mov	w2, #14                         ; =0xe
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp84:
; %bb.87:
	stp	xzr, xzr, [sp, #88]
	str	xzr, [sp, #104]
	tbnz	x23, #63, LBB2_124
; %bb.88:
Ltmp86:
	mov	x24, x0
	mov	x0, x23
	bl	__Znwm
Ltmp87:
; %bb.89:
	mov	x21, x0
	stp	x0, x0, [sp, #88]
	add	x19, x0, x23
	str	x19, [sp, #104]
	mov	x1, x22
	mov	x2, x23
	bl	_memcpy
	str	x19, [sp, #96]
Ltmp88:
	add	x0, sp, #88
	fmov	d0, #0.50000000
	bl	__Z10percentileNSt3__16vectorIdNS_9allocatorIdEEEEd
Ltmp89:
; %bb.90:
Ltmp90:
	mov	x0, x24
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp91:
; %bb.91:
Ltmp92:
Lloh22:
	adrp	x1, l_.str.9@PAGE
Lloh23:
	add	x1, x1, l_.str.9@PAGEOFF
	mov	w2, #14                         ; =0xe
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp93:
; %bb.92:
	mov	x25, x0
	stp	xzr, xzr, [sp, #64]
	str	xzr, [sp, #80]
Ltmp95:
	mov	x0, x23
	bl	__Znwm
Ltmp96:
; %bb.93:
	mov	x24, x0
	stp	x0, x0, [sp, #64]
	add	x19, x0, x23
	str	x19, [sp, #80]
	mov	x1, x22
	mov	x2, x23
	bl	_memcpy
	str	x19, [sp, #72]
Ltmp98:
	mov	x8, #7378697629483820646        ; =0x6666666666666666
	movk	x8, #16366, lsl #48
	fmov	d0, x8
	add	x0, sp, #64
	bl	__Z10percentileNSt3__16vectorIdNS_9allocatorIdEEEEd
Ltmp99:
; %bb.94:
Ltmp100:
	mov	x0, x25
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp101:
; %bb.95:
Ltmp102:
Lloh24:
	adrp	x1, l_.str.10@PAGE
Lloh25:
	add	x1, x1, l_.str.10@PAGEOFF
	mov	w2, #13                         ; =0xd
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp103:
; %bb.96:
	stp	xzr, xzr, [sp, #40]
	str	xzr, [sp, #56]
	tbnz	x20, #63, LBB2_125
; %bb.97:
Ltmp105:
	mov	x23, x0
	mov	x0, x20
	bl	__Znwm
Ltmp106:
; %bb.98:
	mov	x25, x0
	stp	x0, x0, [sp, #40]
	add	x19, x0, x20
	str	x19, [sp, #56]
	mov	x1, x28
	mov	x2, x20
	bl	_memcpy
	str	x19, [sp, #48]
Ltmp107:
	add	x0, sp, #40
	fmov	d0, #0.50000000
	bl	__Z10percentileNSt3__16vectorIdNS_9allocatorIdEEEEd
Ltmp108:
; %bb.99:
Ltmp109:
	mov	x0, x23
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp110:
; %bb.100:
Ltmp111:
Lloh26:
	adrp	x1, l_.str.11@PAGE
Lloh27:
	add	x1, x1, l_.str.11@PAGEOFF
	mov	w2, #13                         ; =0xd
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp112:
; %bb.101:
	mov	x26, x0
	stp	xzr, xzr, [sp, #16]
	str	xzr, [sp, #32]
Ltmp114:
	mov	x0, x20
	bl	__Znwm
Ltmp115:
; %bb.102:
	mov	x23, x0
	stp	x0, x0, [sp, #16]
	add	x19, x0, x20
	str	x19, [sp, #32]
	mov	x1, x28
	mov	x2, x20
	bl	_memcpy
	str	x19, [sp, #24]
Ltmp117:
	mov	x8, #7378697629483820646        ; =0x6666666666666666
	movk	x8, #16366, lsl #48
	fmov	d0, x8
	add	x0, sp, #16
	bl	__Z10percentileNSt3__16vectorIdNS_9allocatorIdEEEEd
Ltmp118:
; %bb.103:
Ltmp119:
	mov	x0, x26
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp120:
; %bb.104:
Ltmp121:
Lloh28:
	adrp	x1, l_.str.12@PAGE
Lloh29:
	add	x1, x1, l_.str.12@PAGEOFF
	mov	w2, #59                         ; =0x3b
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp122:
; %bb.105:
	str	x23, [sp, #24]
	mov	x0, x23
	bl	__ZdlPv
	str	x25, [sp, #48]
	mov	x0, x25
	bl	__ZdlPv
	str	x24, [sp, #72]
	mov	x0, x24
	bl	__ZdlPv
	str	x21, [sp, #96]
	mov	x0, x21
	bl	__ZdlPv
	cbz	x28, LBB2_107
; %bb.106:
	mov	x0, x28
	bl	__ZdlPv
LBB2_107:
	cbz	x22, LBB2_109
; %bb.108:
	mov	x0, x22
	bl	__ZdlPv
LBB2_109:
	ldr	x0, [sp, #144]
	cbz	x0, LBB2_111
; %bb.110:
	str	x0, [sp, #152]
	bl	__ZdlPv
LBB2_111:
	ldr	x0, [sp, #168]
	cbz	x0, LBB2_113
; %bb.112:
	str	x0, [sp, #176]
	bl	__ZdlPv
LBB2_113:
	ldur	x0, [x29, #-176]
	cbz	x0, LBB2_115
; %bb.114:
	stur	x0, [x29, #-168]
	bl	__ZdlPv
LBB2_115:
	mov	w0, #0                          ; =0x0
LBB2_116:
	ldp	x29, x30, [sp, #368]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #352]            ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #336]            ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #320]            ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #304]            ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #288]            ; 16-byte Folded Reload
	ldp	d9, d8, [sp, #272]              ; 16-byte Folded Reload
	ldp	d11, d10, [sp, #256]            ; 16-byte Folded Reload
	ldp	d13, d12, [sp, #240]            ; 16-byte Folded Reload
	add	sp, sp, #384
	ret
LBB2_117:
Ltmp46:
	bl	__ZSt28__throw_bad_array_new_lengthB9nqe210106v
Ltmp47:
	b	LBB2_128
LBB2_118:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp142:
Lloh30:
	adrp	x1, l_.str.1@PAGE
Lloh31:
	add	x1, x1, l_.str.1@PAGEOFF
	bl	__ZNSt11logic_errorC2EPKc
Ltmp143:
; %bb.119:
Lloh32:
	adrp	x8, __ZTVSt16invalid_argument@GOTPAGE
Lloh33:
	ldr	x8, [x8, __ZTVSt16invalid_argument@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x19]
Ltmp145:
Lloh34:
	adrp	x1, __ZTISt16invalid_argument@GOTPAGE
Lloh35:
	ldr	x1, [x1, __ZTISt16invalid_argument@GOTPAGEOFF]
Lloh36:
	adrp	x2, __ZNSt16invalid_argumentD1Ev@GOTPAGE
Lloh37:
	ldr	x2, [x2, __ZNSt16invalid_argumentD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
Ltmp146:
	b	LBB2_128
LBB2_120:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp130:
Lloh38:
	adrp	x1, l_.str.2@PAGE
Lloh39:
	add	x1, x1, l_.str.2@PAGEOFF
	bl	__ZNSt11logic_errorC2EPKc
Ltmp131:
; %bb.121:
Lloh40:
	adrp	x8, __ZTVSt16invalid_argument@GOTPAGE
Lloh41:
	ldr	x8, [x8, __ZTVSt16invalid_argument@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x19]
Ltmp133:
Lloh42:
	adrp	x1, __ZTISt16invalid_argument@GOTPAGE
Lloh43:
	ldr	x1, [x1, __ZTISt16invalid_argument@GOTPAGEOFF]
Lloh44:
	adrp	x2, __ZNSt16invalid_argumentD1Ev@GOTPAGE
Lloh45:
	ldr	x2, [x2, __ZNSt16invalid_argumentD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
Ltmp134:
	b	LBB2_128
LBB2_122:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x21, x0
Ltmp62:
Lloh46:
	adrp	x1, l_.str@PAGE
Lloh47:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp63:
; %bb.123:
Ltmp65:
Lloh48:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh49:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh50:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh51:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x21
	ldr	x28, [sp, #8]                   ; 8-byte Folded Reload
	bl	___cxa_throw
Ltmp66:
	b	LBB2_128
LBB2_124:
Ltmp127:
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_length_errorB9nqe210106Ev
Ltmp128:
	b	LBB2_128
LBB2_125:
Ltmp124:
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_length_errorB9nqe210106Ev
Ltmp125:
	b	LBB2_128
LBB2_126:
Ltmp139:
	bl	__ZNSt3__112basic_stringIcNS_11char_traitsIcEENS_9allocatorIcEEE20__throw_length_errorB9nqe210106Ev
Ltmp140:
	b	LBB2_128
LBB2_127:
Ltmp136:
	bl	__ZNSt3__112basic_stringIcNS_11char_traitsIcEENS_9allocatorIcEEE20__throw_length_errorB9nqe210106Ev
Ltmp137:
LBB2_128:
	brk	#0x1
LBB2_129:
Ltmp15:
	b	LBB2_135
LBB2_130:
Ltmp138:
	b	LBB2_144
LBB2_131:
Ltmp64:
	mov	x26, x1
	mov	x23, x0
	mov	x0, x21
	bl	___cxa_free_exception
	b	LBB2_168
LBB2_132:
Ltmp135:
	b	LBB2_144
LBB2_133:
Ltmp132:
	b	LBB2_139
LBB2_134:
Ltmp10:
LBB2_135:
	mov	x26, x1
	mov	x23, x0
	ldrsb	w8, [sp, #135]
	tbz	w8, #31, LBB2_179
; %bb.136:
	ldr	x0, [sp, #112]
	b	LBB2_178
LBB2_137:
Ltmp147:
	b	LBB2_144
LBB2_138:
Ltmp144:
LBB2_139:
	mov	x26, x1
	mov	x23, x0
	mov	x0, x19
	bl	___cxa_free_exception
	b	LBB2_179
LBB2_140:
Ltmp24:
	mov	x26, x1
	mov	x23, x0
	b	LBB2_174
LBB2_141:
Ltmp21:
	mov	x26, x1
	mov	x23, x0
	b	LBB2_176
LBB2_142:
Ltmp18:
	b	LBB2_144
LBB2_143:
Ltmp141:
LBB2_144:
	mov	x26, x1
	mov	x23, x0
	b	LBB2_179
LBB2_145:
Ltmp116:
	b	LBB2_152
LBB2_146:
Ltmp97:
	b	LBB2_158
LBB2_147:
Ltmp27:
	b	LBB2_163
LBB2_148:
Ltmp126:
	b	LBB2_155
LBB2_149:
Ltmp129:
	b	LBB2_165
LBB2_150:
Ltmp123:
	mov	x26, x1
	mov	x8, x23
	mov	x23, x0
	str	x8, [sp, #24]
	mov	x0, x8
	bl	__ZdlPv
	b	LBB2_153
LBB2_151:
Ltmp113:
LBB2_152:
	mov	x26, x1
	mov	x23, x0
LBB2_153:
	str	x25, [sp, #48]
	mov	x0, x25
	bl	__ZdlPv
	b	LBB2_156
LBB2_154:
Ltmp104:
LBB2_155:
	mov	x26, x1
	mov	x23, x0
LBB2_156:
	str	x24, [sp, #72]
	mov	x0, x24
	bl	__ZdlPv
	b	LBB2_159
LBB2_157:
Ltmp94:
LBB2_158:
	mov	x26, x1
	mov	x23, x0
LBB2_159:
	str	x21, [sp, #96]
	mov	x0, x21
	bl	__ZdlPv
	b	LBB2_168
LBB2_160:
Ltmp48:
	b	LBB2_167
LBB2_161:
Ltmp85:
	str	x28, [sp, #8]                   ; 8-byte Folded Spill
	b	LBB2_165
LBB2_162:
Ltmp30:
LBB2_163:
	mov	x26, x1
	mov	x23, x0
	b	LBB2_172
LBB2_164:
Ltmp41:
LBB2_165:
	mov	x26, x1
	mov	x23, x0
	b	LBB2_168
LBB2_166:
Ltmp61:
LBB2_167:
	mov	x26, x1
	mov	x23, x0
	mov	x22, x20
LBB2_168:
	ldr	x0, [sp, #8]                    ; 8-byte Folded Reload
	cbz	x0, LBB2_170
; %bb.169:
	bl	__ZdlPv
LBB2_170:
	cbz	x22, LBB2_172
; %bb.171:
	mov	x0, x22
	bl	__ZdlPv
LBB2_172:
	ldr	x0, [sp, #144]
	cbz	x0, LBB2_174
; %bb.173:
	str	x0, [sp, #152]
	bl	__ZdlPv
LBB2_174:
	ldr	x0, [sp, #168]
	cbz	x0, LBB2_176
; %bb.175:
	str	x0, [sp, #176]
	bl	__ZdlPv
LBB2_176:
	ldur	x0, [x29, #-176]
	cbz	x0, LBB2_179
; %bb.177:
	stur	x0, [x29, #-168]
LBB2_178:
	bl	__ZdlPv
LBB2_179:
	cmp	w26, #1
	b.ne	LBB2_184
; %bb.180:
	mov	x0, x23
	bl	___cxa_begin_catch
	ldr	x8, [x0]
	ldr	x8, [x8, #16]
	blr	x8
	mov	x19, x0
	bl	_strlen
	mov	x2, x0
Ltmp148:
Lloh52:
	adrp	x0, __ZNSt3__14cerrE@GOTPAGE
Lloh53:
	ldr	x0, [x0, __ZNSt3__14cerrE@GOTPAGEOFF]
	mov	x1, x19
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp149:
; %bb.181:
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #112]
Ltmp150:
	add	x1, sp, #112
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp151:
; %bb.182:
	bl	___cxa_end_catch
	mov	w0, #1                          ; =0x1
	b	LBB2_116
LBB2_183:
Ltmp152:
	mov	x23, x0
Ltmp153:
	bl	___cxa_end_catch
Ltmp154:
LBB2_184:
	mov	x0, x23
	bl	__Unwind_Resume
LBB2_185:
Ltmp155:
	bl	___clang_call_terminate
	.loh AdrpAdd	Lloh6, Lloh7
	.loh AdrpLdrGot	Lloh4, Lloh5
	.loh AdrpLdrGot	Lloh8, Lloh9
	.loh AdrpAdd	Lloh12, Lloh13
	.loh AdrpLdrGot	Lloh10, Lloh11
	.loh AdrpAdd	Lloh14, Lloh15
	.loh AdrpAdd	Lloh16, Lloh17
	.loh AdrpAdd	Lloh18, Lloh19
	.loh AdrpAdd	Lloh20, Lloh21
	.loh AdrpAdd	Lloh22, Lloh23
	.loh AdrpAdd	Lloh24, Lloh25
	.loh AdrpAdd	Lloh26, Lloh27
	.loh AdrpAdd	Lloh28, Lloh29
	.loh AdrpAdd	Lloh30, Lloh31
	.loh AdrpLdrGot	Lloh36, Lloh37
	.loh AdrpLdrGot	Lloh34, Lloh35
	.loh AdrpLdrGot	Lloh32, Lloh33
	.loh AdrpAdd	Lloh38, Lloh39
	.loh AdrpLdrGot	Lloh44, Lloh45
	.loh AdrpLdrGot	Lloh42, Lloh43
	.loh AdrpLdrGot	Lloh40, Lloh41
	.loh AdrpAdd	Lloh46, Lloh47
	.loh AdrpLdrGot	Lloh50, Lloh51
	.loh AdrpLdrGot	Lloh48, Lloh49
	.loh AdrpLdrGot	Lloh52, Lloh53
Lfunc_end2:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table2:
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
	.uleb128 Ltmp141-Lfunc_begin2           ;     jumps to Ltmp141
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp7-Lfunc_begin2             ; >> Call Site 2 <<
	.uleb128 Ltmp8-Ltmp7                    ;   Call between Ltmp7 and Ltmp8
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp8-Lfunc_begin2             ; >> Call Site 3 <<
	.uleb128 Ltmp9-Ltmp8                    ;   Call between Ltmp8 and Ltmp9
	.uleb128 Ltmp10-Lfunc_begin2            ;     jumps to Ltmp10
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp11-Lfunc_begin2            ; >> Call Site 4 <<
	.uleb128 Ltmp12-Ltmp11                  ;   Call between Ltmp11 and Ltmp12
	.uleb128 Ltmp138-Lfunc_begin2           ;     jumps to Ltmp138
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp12-Lfunc_begin2            ; >> Call Site 5 <<
	.uleb128 Ltmp13-Ltmp12                  ;   Call between Ltmp12 and Ltmp13
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp13-Lfunc_begin2            ; >> Call Site 6 <<
	.uleb128 Ltmp14-Ltmp13                  ;   Call between Ltmp13 and Ltmp14
	.uleb128 Ltmp15-Lfunc_begin2            ;     jumps to Ltmp15
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp16-Lfunc_begin2            ; >> Call Site 7 <<
	.uleb128 Ltmp17-Ltmp16                  ;   Call between Ltmp16 and Ltmp17
	.uleb128 Ltmp18-Lfunc_begin2            ;     jumps to Ltmp18
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp17-Lfunc_begin2            ; >> Call Site 8 <<
	.uleb128 Ltmp19-Ltmp17                  ;   Call between Ltmp17 and Ltmp19
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp19-Lfunc_begin2            ; >> Call Site 9 <<
	.uleb128 Ltmp20-Ltmp19                  ;   Call between Ltmp19 and Ltmp20
	.uleb128 Ltmp21-Lfunc_begin2            ;     jumps to Ltmp21
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp20-Lfunc_begin2            ; >> Call Site 10 <<
	.uleb128 Ltmp22-Ltmp20                  ;   Call between Ltmp20 and Ltmp22
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp22-Lfunc_begin2            ; >> Call Site 11 <<
	.uleb128 Ltmp23-Ltmp22                  ;   Call between Ltmp22 and Ltmp23
	.uleb128 Ltmp24-Lfunc_begin2            ;     jumps to Ltmp24
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp23-Lfunc_begin2            ; >> Call Site 12 <<
	.uleb128 Ltmp25-Ltmp23                  ;   Call between Ltmp23 and Ltmp25
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp25-Lfunc_begin2            ; >> Call Site 13 <<
	.uleb128 Ltmp26-Ltmp25                  ;   Call between Ltmp25 and Ltmp26
	.uleb128 Ltmp27-Lfunc_begin2            ;     jumps to Ltmp27
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp28-Lfunc_begin2            ; >> Call Site 14 <<
	.uleb128 Ltmp29-Ltmp28                  ;   Call between Ltmp28 and Ltmp29
	.uleb128 Ltmp30-Lfunc_begin2            ;     jumps to Ltmp30
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp31-Lfunc_begin2            ; >> Call Site 15 <<
	.uleb128 Ltmp32-Ltmp31                  ;   Call between Ltmp31 and Ltmp32
	.uleb128 Ltmp85-Lfunc_begin2            ;     jumps to Ltmp85
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp37-Lfunc_begin2            ; >> Call Site 16 <<
	.uleb128 Ltmp36-Ltmp37                  ;   Call between Ltmp37 and Ltmp36
	.uleb128 Ltmp41-Lfunc_begin2            ;     jumps to Ltmp41
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp44-Lfunc_begin2            ; >> Call Site 17 <<
	.uleb128 Ltmp45-Ltmp44                  ;   Call between Ltmp44 and Ltmp45
	.uleb128 Ltmp61-Lfunc_begin2            ;     jumps to Ltmp61
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp45-Lfunc_begin2            ; >> Call Site 18 <<
	.uleb128 Ltmp42-Ltmp45                  ;   Call between Ltmp45 and Ltmp42
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp42-Lfunc_begin2            ; >> Call Site 19 <<
	.uleb128 Ltmp43-Ltmp42                  ;   Call between Ltmp42 and Ltmp43
	.uleb128 Ltmp61-Lfunc_begin2            ;     jumps to Ltmp61
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp43-Lfunc_begin2            ; >> Call Site 20 <<
	.uleb128 Ltmp49-Ltmp43                  ;   Call between Ltmp43 and Ltmp49
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp49-Lfunc_begin2            ; >> Call Site 21 <<
	.uleb128 Ltmp60-Ltmp49                  ;   Call between Ltmp49 and Ltmp60
	.uleb128 Ltmp61-Lfunc_begin2            ;     jumps to Ltmp61
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp67-Lfunc_begin2            ; >> Call Site 22 <<
	.uleb128 Ltmp84-Ltmp67                  ;   Call between Ltmp67 and Ltmp84
	.uleb128 Ltmp85-Lfunc_begin2            ;     jumps to Ltmp85
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp86-Lfunc_begin2            ; >> Call Site 23 <<
	.uleb128 Ltmp87-Ltmp86                  ;   Call between Ltmp86 and Ltmp87
	.uleb128 Ltmp129-Lfunc_begin2           ;     jumps to Ltmp129
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp87-Lfunc_begin2            ; >> Call Site 24 <<
	.uleb128 Ltmp88-Ltmp87                  ;   Call between Ltmp87 and Ltmp88
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp88-Lfunc_begin2            ; >> Call Site 25 <<
	.uleb128 Ltmp93-Ltmp88                  ;   Call between Ltmp88 and Ltmp93
	.uleb128 Ltmp94-Lfunc_begin2            ;     jumps to Ltmp94
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp95-Lfunc_begin2            ; >> Call Site 26 <<
	.uleb128 Ltmp96-Ltmp95                  ;   Call between Ltmp95 and Ltmp96
	.uleb128 Ltmp97-Lfunc_begin2            ;     jumps to Ltmp97
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp96-Lfunc_begin2            ; >> Call Site 27 <<
	.uleb128 Ltmp98-Ltmp96                  ;   Call between Ltmp96 and Ltmp98
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp98-Lfunc_begin2            ; >> Call Site 28 <<
	.uleb128 Ltmp103-Ltmp98                 ;   Call between Ltmp98 and Ltmp103
	.uleb128 Ltmp104-Lfunc_begin2           ;     jumps to Ltmp104
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp105-Lfunc_begin2           ; >> Call Site 29 <<
	.uleb128 Ltmp106-Ltmp105                ;   Call between Ltmp105 and Ltmp106
	.uleb128 Ltmp126-Lfunc_begin2           ;     jumps to Ltmp126
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp106-Lfunc_begin2           ; >> Call Site 30 <<
	.uleb128 Ltmp107-Ltmp106                ;   Call between Ltmp106 and Ltmp107
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp107-Lfunc_begin2           ; >> Call Site 31 <<
	.uleb128 Ltmp112-Ltmp107                ;   Call between Ltmp107 and Ltmp112
	.uleb128 Ltmp113-Lfunc_begin2           ;     jumps to Ltmp113
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp114-Lfunc_begin2           ; >> Call Site 32 <<
	.uleb128 Ltmp115-Ltmp114                ;   Call between Ltmp114 and Ltmp115
	.uleb128 Ltmp116-Lfunc_begin2           ;     jumps to Ltmp116
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp115-Lfunc_begin2           ; >> Call Site 33 <<
	.uleb128 Ltmp117-Ltmp115                ;   Call between Ltmp115 and Ltmp117
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp117-Lfunc_begin2           ; >> Call Site 34 <<
	.uleb128 Ltmp122-Ltmp117                ;   Call between Ltmp117 and Ltmp122
	.uleb128 Ltmp123-Lfunc_begin2           ;     jumps to Ltmp123
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp46-Lfunc_begin2            ; >> Call Site 35 <<
	.uleb128 Ltmp47-Ltmp46                  ;   Call between Ltmp46 and Ltmp47
	.uleb128 Ltmp48-Lfunc_begin2            ;     jumps to Ltmp48
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp47-Lfunc_begin2            ; >> Call Site 36 <<
	.uleb128 Ltmp142-Ltmp47                 ;   Call between Ltmp47 and Ltmp142
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp142-Lfunc_begin2           ; >> Call Site 37 <<
	.uleb128 Ltmp143-Ltmp142                ;   Call between Ltmp142 and Ltmp143
	.uleb128 Ltmp144-Lfunc_begin2           ;     jumps to Ltmp144
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp145-Lfunc_begin2           ; >> Call Site 38 <<
	.uleb128 Ltmp146-Ltmp145                ;   Call between Ltmp145 and Ltmp146
	.uleb128 Ltmp147-Lfunc_begin2           ;     jumps to Ltmp147
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp146-Lfunc_begin2           ; >> Call Site 39 <<
	.uleb128 Ltmp130-Ltmp146                ;   Call between Ltmp146 and Ltmp130
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp130-Lfunc_begin2           ; >> Call Site 40 <<
	.uleb128 Ltmp131-Ltmp130                ;   Call between Ltmp130 and Ltmp131
	.uleb128 Ltmp132-Lfunc_begin2           ;     jumps to Ltmp132
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp133-Lfunc_begin2           ; >> Call Site 41 <<
	.uleb128 Ltmp134-Ltmp133                ;   Call between Ltmp133 and Ltmp134
	.uleb128 Ltmp135-Lfunc_begin2           ;     jumps to Ltmp135
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp134-Lfunc_begin2           ; >> Call Site 42 <<
	.uleb128 Ltmp62-Ltmp134                 ;   Call between Ltmp134 and Ltmp62
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp62-Lfunc_begin2            ; >> Call Site 43 <<
	.uleb128 Ltmp63-Ltmp62                  ;   Call between Ltmp62 and Ltmp63
	.uleb128 Ltmp64-Lfunc_begin2            ;     jumps to Ltmp64
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp65-Lfunc_begin2            ; >> Call Site 44 <<
	.uleb128 Ltmp66-Ltmp65                  ;   Call between Ltmp65 and Ltmp66
	.uleb128 Ltmp85-Lfunc_begin2            ;     jumps to Ltmp85
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp127-Lfunc_begin2           ; >> Call Site 45 <<
	.uleb128 Ltmp128-Ltmp127                ;   Call between Ltmp127 and Ltmp128
	.uleb128 Ltmp129-Lfunc_begin2           ;     jumps to Ltmp129
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp124-Lfunc_begin2           ; >> Call Site 46 <<
	.uleb128 Ltmp125-Ltmp124                ;   Call between Ltmp124 and Ltmp125
	.uleb128 Ltmp126-Lfunc_begin2           ;     jumps to Ltmp126
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp139-Lfunc_begin2           ; >> Call Site 47 <<
	.uleb128 Ltmp140-Ltmp139                ;   Call between Ltmp139 and Ltmp140
	.uleb128 Ltmp141-Lfunc_begin2           ;     jumps to Ltmp141
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp136-Lfunc_begin2           ; >> Call Site 48 <<
	.uleb128 Ltmp137-Ltmp136                ;   Call between Ltmp136 and Ltmp137
	.uleb128 Ltmp138-Lfunc_begin2           ;     jumps to Ltmp138
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp137-Lfunc_begin2           ; >> Call Site 49 <<
	.uleb128 Ltmp148-Ltmp137                ;   Call between Ltmp137 and Ltmp148
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp148-Lfunc_begin2           ; >> Call Site 50 <<
	.uleb128 Ltmp151-Ltmp148                ;   Call between Ltmp148 and Ltmp151
	.uleb128 Ltmp152-Lfunc_begin2           ;     jumps to Ltmp152
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp151-Lfunc_begin2           ; >> Call Site 51 <<
	.uleb128 Ltmp153-Ltmp151                ;   Call between Ltmp151 and Ltmp153
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp153-Lfunc_begin2           ; >> Call Site 52 <<
	.uleb128 Ltmp154-Ltmp153                ;   Call between Ltmp153 and Ltmp154
	.uleb128 Ltmp155-Lfunc_begin2           ;     jumps to Ltmp155
	.byte	9                               ;   On action: 5
	.uleb128 Ltmp154-Lfunc_begin2           ; >> Call Site 53 <<
	.uleb128 Lfunc_end2-Ltmp154             ;   Call between Ltmp154 and Lfunc_end2
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
	.byte	1                               ; >> Action Record 4 <<
                                        ;   Catch TypeInfo 1
	.byte	0                               ;   No further actions
	.byte	2                               ; >> Action Record 5 <<
                                        ;   Catch TypeInfo 2
	.byte	0                               ;   No further actions
	.p2align	2, 0x0
                                        ; >> Catch TypeInfos <<
	.long	0                               ; TypeInfo 2
Ltmp190:                                ; TypeInfo 1
	.long	__ZTISt9exception@GOT-Ltmp190
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
	cbz	x2, LBB3_3
; %bb.1:
	movi.2d	v1, #0000000000000000
	mov	w8, #1123942400                 ; =0x42fe0000
	fmov	s2, w8
	mov	w8, #-1023541248                ; =0xc2fe0000
	fmov	s3, w8
LBB3_2:                                 ; =>This Inner Loop Header: Depth=1
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
	b.ne	LBB3_2
LBB3_3:
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
	b.lo	LBB4_4
; %bb.1:
	mov	x8, #0                          ; =0x0
	add	x9, x0, #16
	mov	w10, #1123942400                ; =0x42fe0000
	dup.4s	v1, w10
	mov	w10, #-1023541248               ; =0xc2fe0000
	dup.4s	v2, w10
	mov	x10, x2
LBB4_2:                                 ; =>This Inner Loop Header: Depth=1
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
	b.hi	LBB4_2
; %bb.3:
	subs	x9, x2, x8
	b.hi	LBB4_5
	b	LBB4_11
LBB4_4:
	mov	x8, #0                          ; =0x0
	subs	x9, x2, x8
	b.ls	LBB4_11
LBB4_5:
	cmp	x9, #3
	b.ls	LBB4_8
; %bb.6:
	add	x11, x0, x8, lsl #2
	add	x10, x0, x2, lsl #2
	add	x12, x1, x8
	cmp	x12, x10
	b.hs	LBB4_12
; %bb.7:
	add	x10, x1, x2
	cmp	x11, x10
	b.hs	LBB4_12
LBB4_8:
	mov	x11, x8
LBB4_9:
	sub	x8, x2, x11
	add	x9, x1, x11
	add	x10, x0, x11, lsl #2
	movi.2d	v1, #0000000000000000
	mov	w11, #1123942400                ; =0x42fe0000
	fmov	s2, w11
	mov	w11, #-1023541248               ; =0xc2fe0000
	fmov	s3, w11
LBB4_10:                                ; =>This Inner Loop Header: Depth=1
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
	b.ne	LBB4_10
LBB4_11:
	ret
LBB4_12:
	cmp	x9, #16
	b.hs	LBB4_14
; %bb.13:
	mov	x10, #0                         ; =0x0
	b	LBB4_18
LBB4_14:
	and	x10, x9, #0xfffffffffffffff0
	add	x11, x11, #32
	add	x12, x8, x1
	add	x12, x12, #8
	mov	w13, #-1023541248               ; =0xc2fe0000
	dup.4s	v1, w13
	mov	w13, #1123942400                ; =0x42fe0000
	dup.4s	v2, w13
	mov	x13, x10
LBB4_15:                                ; =>This Inner Loop Header: Depth=1
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
	b.ne	LBB4_15
; %bb.16:
	cmp	x9, x10
	b.eq	LBB4_11
; %bb.17:
	tst	x9, #0xc
	b.eq	LBB4_21
LBB4_18:
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
LBB4_19:                                ; =>This Inner Loop Header: Depth=1
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
	b.ne	LBB4_19
; %bb.20:
	cmp	x9, x12
	b.ne	LBB4_9
	b	LBB4_11
LBB4_21:
	add	x11, x8, x10
	b	LBB4_9
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZZ4mainENK3$_0clEb
__ZZ4mainENK3$_0clEb:                   ; @"_ZZ4mainENK3$_0clEb"
Lfunc_begin3:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception3
; %bb.0:
	stp	x22, x21, [sp, #-48]!           ; 16-byte Folded Spill
	stp	x20, x19, [sp, #16]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	mov	x21, x1
	mov	x20, x0
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x19, x0
	ldp	x8, x9, [x20]
	ldr	x0, [x8]
	ldr	x1, [x9]
	ldr	x8, [x20, #16]
	ldr	x2, [x8]
	fmov	s0, #1.25000000
	cbz	w21, LBB5_2
; %bb.1:
	bl	__ZN8practice4neonEPKfPamf
	b	LBB5_3
LBB5_2:
	bl	__ZN8practice6scalarEPKfPamf
LBB5_3:
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x21, x0
	ldr	x8, [x20, #8]
	ldr	x9, [x20, #24]
	ldp	x0, x10, [x8]
	sub	x2, x10, x0
	ldp	x1, x8, [x9]
	sub	x8, x8, x1
	cmp	x2, x8
	b.ne	LBB5_6
; %bb.4:
	bl	_memcmp
	cbnz	w0, LBB5_6
; %bb.5:
	sub	x8, x21, x19
	scvtf	d0, x8
	mov	x8, #70368744177664             ; =0x400000000000
	movk	x8, #16527, lsl #48
	fmov	d1, x8
	fdiv	d0, d0, d1
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #16]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp], #48             ; 16-byte Folded Reload
	ret
LBB5_6:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp156:
Lloh54:
	adrp	x1, l_.str@PAGE
Lloh55:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp157:
; %bb.7:
	mov	x0, x19
	bl	__ZZ4mainENK3$_0clEb.cold.1
LBB5_8:
Ltmp158:
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x0, x20
	bl	__Unwind_Resume
	.loh AdrpAdd	Lloh54, Lloh55
Lfunc_end3:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table5:
Lexception3:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end3-Lcst_begin3
Lcst_begin3:
	.uleb128 Lfunc_begin3-Lfunc_begin3      ; >> Call Site 1 <<
	.uleb128 Ltmp156-Lfunc_begin3           ;   Call between Lfunc_begin3 and Ltmp156
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp156-Lfunc_begin3           ; >> Call Site 2 <<
	.uleb128 Ltmp157-Ltmp156                ;   Call between Ltmp156 and Ltmp157
	.uleb128 Ltmp158-Lfunc_begin3           ;     jumps to Ltmp158
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp157-Lfunc_begin3           ; >> Call Site 3 <<
	.uleb128 Lfunc_end3-Ltmp157             ;   Call between Ltmp157 and Lfunc_end3
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end3:
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
	.private_extern	__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_out_of_rangeB9nqe210106Ev ; -- Begin function _ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_out_of_rangeB9nqe210106Ev
	.globl	__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_out_of_rangeB9nqe210106Ev
	.weak_def_can_be_hidden	__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_out_of_rangeB9nqe210106Ev
	.p2align	2
__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_out_of_rangeB9nqe210106Ev: ; @_ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_out_of_rangeB9nqe210106Ev
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh56:
	adrp	x0, l_.str.13@PAGE
Lloh57:
	add	x0, x0, l_.str.13@PAGEOFF
	bl	__ZNSt3__120__throw_out_of_rangeB9nqe210106EPKc
	.loh AdrpAdd	Lloh56, Lloh57
	.cfi_endproc
                                        ; -- End function
	.private_extern	__ZNSt3__120__throw_out_of_rangeB9nqe210106EPKc ; -- Begin function _ZNSt3__120__throw_out_of_rangeB9nqe210106EPKc
	.globl	__ZNSt3__120__throw_out_of_rangeB9nqe210106EPKc
	.weak_def_can_be_hidden	__ZNSt3__120__throw_out_of_rangeB9nqe210106EPKc
	.p2align	2
__ZNSt3__120__throw_out_of_rangeB9nqe210106EPKc: ; @_ZNSt3__120__throw_out_of_rangeB9nqe210106EPKc
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
Ltmp159:
	mov	x1, x20
	bl	__ZNSt12out_of_rangeC1B9nqe210106EPKc
Ltmp160:
; %bb.1:
Lloh58:
	adrp	x1, __ZTISt12out_of_range@GOTPAGE
Lloh59:
	ldr	x1, [x1, __ZTISt12out_of_range@GOTPAGEOFF]
Lloh60:
	adrp	x2, __ZNSt12out_of_rangeD1Ev@GOTPAGE
Lloh61:
	ldr	x2, [x2, __ZNSt12out_of_rangeD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
LBB8_2:
Ltmp161:
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x0, x20
	bl	__Unwind_Resume
	.loh AdrpLdrGot	Lloh60, Lloh61
	.loh AdrpLdrGot	Lloh58, Lloh59
Lfunc_end4:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table8:
Lexception4:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end4-Lcst_begin4
Lcst_begin4:
	.uleb128 Lfunc_begin4-Lfunc_begin4      ; >> Call Site 1 <<
	.uleb128 Ltmp159-Lfunc_begin4           ;   Call between Lfunc_begin4 and Ltmp159
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp159-Lfunc_begin4           ; >> Call Site 2 <<
	.uleb128 Ltmp160-Ltmp159                ;   Call between Ltmp159 and Ltmp160
	.uleb128 Ltmp161-Lfunc_begin4           ;     jumps to Ltmp161
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp160-Lfunc_begin4           ; >> Call Site 3 <<
	.uleb128 Lfunc_end4-Ltmp160             ;   Call between Ltmp160 and Lfunc_end4
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end4:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.private_extern	__ZNSt12out_of_rangeC1B9nqe210106EPKc ; -- Begin function _ZNSt12out_of_rangeC1B9nqe210106EPKc
	.globl	__ZNSt12out_of_rangeC1B9nqe210106EPKc
	.weak_def_can_be_hidden	__ZNSt12out_of_rangeC1B9nqe210106EPKc
	.p2align	2
__ZNSt12out_of_rangeC1B9nqe210106EPKc:  ; @_ZNSt12out_of_rangeC1B9nqe210106EPKc
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__ZNSt11logic_errorC2EPKc
Lloh62:
	adrp	x8, __ZTVSt12out_of_range@GOTPAGE
Lloh63:
	ldr	x8, [x8, __ZTVSt12out_of_range@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x0]
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
	.loh AdrpLdrGot	Lloh62, Lloh63
	.cfi_endproc
                                        ; -- End function
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
	adrp	x0, l_.str.14@PAGE
Lloh65:
	add	x0, x0, l_.str.14@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh64, Lloh65
	.cfi_endproc
                                        ; -- End function
	.private_extern	__ZNSt3__120__throw_length_errorB9nqe210106EPKc ; -- Begin function _ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.globl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.weak_def_can_be_hidden	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.p2align	2
__ZNSt3__120__throw_length_errorB9nqe210106EPKc: ; @_ZNSt3__120__throw_length_errorB9nqe210106EPKc
Lfunc_begin5:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception5
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
Ltmp162:
	mov	x1, x20
	bl	__ZNSt12length_errorC1B9nqe210106EPKc
Ltmp163:
; %bb.1:
Lloh66:
	adrp	x1, __ZTISt12length_error@GOTPAGE
Lloh67:
	ldr	x1, [x1, __ZTISt12length_error@GOTPAGEOFF]
Lloh68:
	adrp	x2, __ZNSt12length_errorD1Ev@GOTPAGE
Lloh69:
	ldr	x2, [x2, __ZNSt12length_errorD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
LBB11_2:
Ltmp164:
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x0, x20
	bl	__Unwind_Resume
	.loh AdrpLdrGot	Lloh68, Lloh69
	.loh AdrpLdrGot	Lloh66, Lloh67
Lfunc_end5:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table11:
Lexception5:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end5-Lcst_begin5
Lcst_begin5:
	.uleb128 Lfunc_begin5-Lfunc_begin5      ; >> Call Site 1 <<
	.uleb128 Ltmp162-Lfunc_begin5           ;   Call between Lfunc_begin5 and Ltmp162
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp162-Lfunc_begin5           ; >> Call Site 2 <<
	.uleb128 Ltmp163-Ltmp162                ;   Call between Ltmp162 and Ltmp163
	.uleb128 Ltmp164-Lfunc_begin5           ;     jumps to Ltmp164
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp163-Lfunc_begin5           ; >> Call Site 3 <<
	.uleb128 Lfunc_end5-Ltmp163             ;   Call between Ltmp163 and Lfunc_end5
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end5:
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
Lloh70:
	adrp	x8, __ZTVSt12length_error@GOTPAGE
Lloh71:
	ldr	x8, [x8, __ZTVSt12length_error@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x0]
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
	.loh AdrpLdrGot	Lloh70, Lloh71
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
Lloh72:
	adrp	x1, __ZTISt20bad_array_new_length@GOTPAGE
Lloh73:
	ldr	x1, [x1, __ZTISt20bad_array_new_length@GOTPAGEOFF]
Lloh74:
	adrp	x2, __ZNSt20bad_array_new_lengthD1Ev@GOTPAGE
Lloh75:
	ldr	x2, [x2, __ZNSt20bad_array_new_lengthD1Ev@GOTPAGEOFF]
	bl	___cxa_throw
	.loh AdrpLdrGot	Lloh74, Lloh75
	.loh AdrpLdrGot	Lloh72, Lloh73
	.cfi_endproc
                                        ; -- End function
	.private_extern	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m ; -- Begin function _ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
	.globl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
	.weak_def_can_be_hidden	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
	.p2align	2
__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m: ; @_ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
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
	mov	x21, x2
	mov	x20, x1
	mov	x19, x0
Ltmp165:
	add	x0, sp, #8
	mov	x1, x19
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryC1ERS3_
Ltmp166:
; %bb.1:
	ldrb	w8, [sp, #8]
	cmp	w8, #1
	b.ne	LBB14_10
; %bb.2:
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
	add	x4, x19, x8
	ldr	x22, [x4, #40]
	ldr	w24, [x4, #8]
	ldr	w23, [x4, #144]
	cmn	w23, #1
	b.ne	LBB14_7
; %bb.3:
Ltmp168:
	add	x8, sp, #24
	mov	x25, x4
	mov	x0, x4
	bl	__ZNKSt3__18ios_base6getlocEv
Ltmp169:
; %bb.4:
Ltmp170:
Lloh76:
	adrp	x1, __ZNSt3__15ctypeIcE2idE@GOTPAGE
Lloh77:
	ldr	x1, [x1, __ZNSt3__15ctypeIcE2idE@GOTPAGEOFF]
	add	x0, sp, #24
	bl	__ZNKSt3__16locale9use_facetERNS0_2idE
Ltmp171:
; %bb.5:
	ldr	x8, [x0]
	ldr	x8, [x8, #56]
Ltmp172:
	mov	w1, #32                         ; =0x20
	blr	x8
Ltmp173:
; %bb.6:
	mov	x23, x0
	add	x0, sp, #24
	bl	__ZNSt3__16localeD1Ev
	mov	x4, x25
	str	w23, [x25, #144]
LBB14_7:
	mov	w8, #176                        ; =0xb0
	and	w8, w24, w8
	add	x3, x20, x21
	cmp	w8, #32
	csel	x2, x3, x20, eq
Ltmp175:
	sxtb	w5, w23
	mov	x0, x22
	mov	x1, x20
	bl	__ZNSt3__116__pad_and_outputB9nqe210106IcNS_11char_traitsIcEEEENS_19ostreambuf_iteratorIT_T0_EES6_PKS4_S8_S8_RNS_8ios_baseES4_
Ltmp176:
; %bb.8:
	cbnz	x0, LBB14_10
; %bb.9:
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
	add	x0, x19, x8
	ldr	w8, [x0, #32]
	mov	w9, #5                          ; =0x5
Ltmp178:
	orr	w1, w8, w9
	bl	__ZNSt3__18ios_base5clearEj
Ltmp179:
LBB14_10:
	add	x0, sp, #8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryD1Ev
LBB14_11:
	mov	x0, x19
	ldp	x29, x30, [sp, #96]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #80]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #64]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #48]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #112
	ret
LBB14_12:
Ltmp180:
	b	LBB14_15
LBB14_13:
Ltmp174:
	mov	x20, x0
	add	x0, sp, #24
	bl	__ZNSt3__16localeD1Ev
	b	LBB14_16
LBB14_14:
Ltmp177:
LBB14_15:
	mov	x20, x0
LBB14_16:
	add	x0, sp, #8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryD1Ev
	b	LBB14_18
LBB14_17:
Ltmp167:
	mov	x20, x0
LBB14_18:
	mov	x0, x20
	bl	___cxa_begin_catch
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
Ltmp181:
	add	x0, x19, x8
	bl	__ZNSt3__18ios_base33__set_badbit_and_consider_rethrowEv
Ltmp182:
; %bb.19:
	bl	___cxa_end_catch
	b	LBB14_11
LBB14_20:
Ltmp183:
	mov	x19, x0
Ltmp184:
	bl	___cxa_end_catch
Ltmp185:
; %bb.21:
	mov	x0, x19
	bl	__Unwind_Resume
LBB14_22:
Ltmp186:
	bl	___clang_call_terminate
	.loh AdrpLdrGot	Lloh76, Lloh77
Lfunc_end6:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table14:
Lexception6:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase1-Lttbaseref1
Lttbaseref1:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end6-Lcst_begin6
Lcst_begin6:
	.uleb128 Ltmp165-Lfunc_begin6           ; >> Call Site 1 <<
	.uleb128 Ltmp166-Ltmp165                ;   Call between Ltmp165 and Ltmp166
	.uleb128 Ltmp167-Lfunc_begin6           ;     jumps to Ltmp167
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp168-Lfunc_begin6           ; >> Call Site 2 <<
	.uleb128 Ltmp169-Ltmp168                ;   Call between Ltmp168 and Ltmp169
	.uleb128 Ltmp177-Lfunc_begin6           ;     jumps to Ltmp177
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp170-Lfunc_begin6           ; >> Call Site 3 <<
	.uleb128 Ltmp173-Ltmp170                ;   Call between Ltmp170 and Ltmp173
	.uleb128 Ltmp174-Lfunc_begin6           ;     jumps to Ltmp174
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp175-Lfunc_begin6           ; >> Call Site 4 <<
	.uleb128 Ltmp176-Ltmp175                ;   Call between Ltmp175 and Ltmp176
	.uleb128 Ltmp177-Lfunc_begin6           ;     jumps to Ltmp177
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp178-Lfunc_begin6           ; >> Call Site 5 <<
	.uleb128 Ltmp179-Ltmp178                ;   Call between Ltmp178 and Ltmp179
	.uleb128 Ltmp180-Lfunc_begin6           ;     jumps to Ltmp180
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp179-Lfunc_begin6           ; >> Call Site 6 <<
	.uleb128 Ltmp181-Ltmp179                ;   Call between Ltmp179 and Ltmp181
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp181-Lfunc_begin6           ; >> Call Site 7 <<
	.uleb128 Ltmp182-Ltmp181                ;   Call between Ltmp181 and Ltmp182
	.uleb128 Ltmp183-Lfunc_begin6           ;     jumps to Ltmp183
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp182-Lfunc_begin6           ; >> Call Site 8 <<
	.uleb128 Ltmp184-Ltmp182                ;   Call between Ltmp182 and Ltmp184
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp184-Lfunc_begin6           ; >> Call Site 9 <<
	.uleb128 Ltmp185-Ltmp184                ;   Call between Ltmp184 and Ltmp185
	.uleb128 Ltmp186-Lfunc_begin6           ;     jumps to Ltmp186
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp185-Lfunc_begin6           ; >> Call Site 10 <<
	.uleb128 Lfunc_end6-Ltmp185             ;   Call between Ltmp185 and Lfunc_end6
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end6:
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
Lfunc_begin7:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception7
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
	cbz	x0, LBB15_16
; %bb.1:
	mov	x23, x5
	mov	x20, x4
	mov	x22, x3
	mov	x21, x2
	mov	x24, x1
	ldr	x26, [x4, #24]
	sub	x25, x2, x1
	cmp	x25, #1
	b.lt	LBB15_3
; %bb.2:
	ldr	x8, [x19]
	ldr	x8, [x8, #96]
	mov	x0, x19
	mov	x1, x24
	mov	x2, x25
	blr	x8
	cmp	x0, x25
	b.ne	LBB15_15
LBB15_3:
	sub	x8, x22, x24
	cmp	x26, x8
	b.le	LBB15_12
; %bb.4:
	mov	x9, #-9                         ; =0xfffffffffffffff7
	movk	x9, #32767, lsl #48
	sub	x24, x26, x8
	cmp	x24, x9
	b.hs	LBB15_17
; %bb.5:
	cmp	x24, #23
	b.hs	LBB15_7
; %bb.6:
	strb	w24, [sp, #31]
	add	x25, sp, #8
	b	LBB15_8
LBB15_7:
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
LBB15_8:
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
Ltmp187:
	mov	x0, x19
	mov	x2, x24
	blr	x8
Ltmp188:
; %bb.9:
	ldrsb	w8, [sp, #31]
	tbnz	w8, #31, LBB15_11
; %bb.10:
	cmp	x0, x24
	b.ne	LBB15_15
	b	LBB15_12
LBB15_11:
	ldr	x8, [sp, #8]
	mov	x23, x0
	mov	x0, x8
	bl	__ZdlPv
	mov	x0, x23
	cmp	x0, x24
	b.ne	LBB15_15
LBB15_12:
	sub	x22, x22, x21
	cmp	x22, #1
	b.lt	LBB15_14
; %bb.13:
	ldr	x8, [x19]
	ldr	x8, [x8, #96]
	mov	x0, x19
	mov	x1, x21
	mov	x2, x22
	blr	x8
	cmp	x0, x22
	b.ne	LBB15_15
LBB15_14:
	str	xzr, [x20, #24]
	b	LBB15_16
LBB15_15:
	mov	x19, #0                         ; =0x0
LBB15_16:
	mov	x0, x19
	ldp	x29, x30, [sp, #96]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #80]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #64]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #48]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #112
	ret
LBB15_17:
	bl	__ZNSt3__112basic_stringIcNS_11char_traitsIcEENS_9allocatorIcEEE20__throw_length_errorB9nqe210106Ev
LBB15_18:
Ltmp189:
	mov	x19, x0
	ldrsb	w8, [sp, #31]
	tbz	w8, #31, LBB15_20
; %bb.19:
	ldr	x0, [sp, #8]
	bl	__ZdlPv
LBB15_20:
	mov	x0, x19
	bl	__Unwind_Resume
Lfunc_end7:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table15:
Lexception7:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end7-Lcst_begin7
Lcst_begin7:
	.uleb128 Lfunc_begin7-Lfunc_begin7      ; >> Call Site 1 <<
	.uleb128 Ltmp187-Lfunc_begin7           ;   Call between Lfunc_begin7 and Ltmp187
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp187-Lfunc_begin7           ; >> Call Site 2 <<
	.uleb128 Ltmp188-Ltmp187                ;   Call between Ltmp187 and Ltmp188
	.uleb128 Ltmp189-Lfunc_begin7           ;     jumps to Ltmp189
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp188-Lfunc_begin7           ; >> Call Site 3 <<
	.uleb128 Lfunc_end7-Ltmp188             ;   Call between Ltmp188 and Lfunc_end7
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end7:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
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
Lloh78:
	adrp	x0, l_.str.13@PAGE
Lloh79:
	add	x0, x0, l_.str.13@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh78, Lloh79
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
	bl	_OUTLINED_FUNCTION_0
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _Z10percentileNSt3__16vectorIdNS_9allocatorIdEEEEd.cold.1
__Z10percentileNSt3__16vectorIdNS_9allocatorIdEEEEd.cold.1: ; @_Z10percentileNSt3__16vectorIdNS_9allocatorIdEEEEd.cold.1
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
	.p2align	2                               ; -- Begin function _ZZ4mainENK3$_0clEb.cold.1
__ZZ4mainENK3$_0clEb.cold.1:            ; @"_ZZ4mainENK3$_0clEb.cold.1"
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
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	b	___cxa_throw
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"verification failed"

l_.str.1:                               ; @.str.1
	.asciz	"usage: app [seconds 1..600] [n 0..1048577]"

l_.str.2:                               ; @.str.2
	.asciz	"bounds"

l_.str.3:                               ; @.str.3
	.asciz	"elapsed_s,scalar_us,neon_us\n"

l_.str.4:                               ; @.str.4
	.asciz	"PASS n="

l_.str.5:                               ; @.str.5
	.asciz	" requests="

l_.str.6:                               ; @.str.6
	.asciz	" early_n="

l_.str.7:                               ; @.str.7
	.asciz	" late_n="

l_.str.8:                               ; @.str.8
	.asciz	" early_p50_us="

l_.str.9:                               ; @.str.9
	.asciz	" early_p95_us="

l_.str.10:                              ; @.str.10
	.asciz	" late_p50_us="

l_.str.11:                              ; @.str.11
	.asciz	" late_p95_us="

l_.str.12:                              ; @.str.12
	.asciz	" thermal_cause=UNVERIFIED energy=UNMEASURED e2e=UNMEASURED\n"

l_.str.13:                              ; @.str.13
	.asciz	"vector"

l_.str.14:                              ; @.str.14
	.asciz	"basic_string"

.subsections_via_symbols
