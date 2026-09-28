	.build_version macos, 26, 0	sdk_version 26, 5
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__Z8sum_rowsPKtmmmm             ; -- Begin function _Z8sum_rowsPKtmmmm
	.p2align	2
__Z8sum_rowsPKtmmmm:                    ; @_Z8sum_rowsPKtmmmm
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
	cmp	x2, x3
	b.hi	LBB0_12
; %bb.1:
	cbz	x1, LBB0_10
; %bb.2:
	umulh	x8, x1, x3
	cmp	xzr, x8
	b.ne	LBB0_12
; %bb.3:
	mul	x8, x3, x1
	cmp	x8, x4
	b.hi	LBB0_12
; %bb.4:
	cbnz	x0, LBB0_6
; %bb.5:
	cbnz	x2, LBB0_12
LBB0_6:
	mov	x9, #0                          ; =0x0
	mov	x8, #0                          ; =0x0
	lsl	x10, x3, #1
	b	LBB0_8
LBB0_7:                                 ;   in Loop: Header=BB0_8 Depth=1
	add	x9, x9, #1
	add	x0, x0, x10
	cmp	x9, x1
	b.eq	LBB0_11
LBB0_8:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB0_9 Depth 2
	mov	x11, x0
	mov	x12, x2
	cbz	x2, LBB0_7
LBB0_9:                                 ;   Parent Loop BB0_8 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldrh	w13, [x11], #2
	add	x8, x8, x13
	subs	x12, x12, #1
	b.ne	LBB0_9
	b	LBB0_7
LBB0_10:
	mov	x8, #0                          ; =0x0
LBB0_11:
	mov	x0, x8
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
	ret
LBB0_12:
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
; %bb.13:
Lloh2:
	adrp	x1, __ZTISt16invalid_argument@GOTPAGE
Lloh3:
	ldr	x1, [x1, __ZTISt16invalid_argument@GOTPAGEOFF]
Lloh4:
	adrp	x2, __ZNSt16invalid_argumentD1Ev@GOTPAGE
Lloh5:
	ldr	x2, [x2, __ZNSt16invalid_argumentD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
LBB0_14:
Ltmp2:
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x0, x20
	bl	__Unwind_Resume
	.loh AdrpAdd	Lloh0, Lloh1
	.loh AdrpLdrGot	Lloh4, Lloh5
	.loh AdrpLdrGot	Lloh2, Lloh3
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
Lloh6:
	adrp	x8, __ZTVSt16invalid_argument@GOTPAGE
Lloh7:
	ldr	x8, [x8, __ZTVSt16invalid_argument@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x0]
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
	.loh AdrpLdrGot	Lloh6, Lloh7
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
	sub	sp, sp, #160
	stp	x28, x27, [sp, #64]             ; 16-byte Folded Spill
	stp	x26, x25, [sp, #80]             ; 16-byte Folded Spill
	stp	x24, x23, [sp, #96]             ; 16-byte Folded Spill
	stp	x22, x21, [sp, #112]            ; 16-byte Folded Spill
	stp	x20, x19, [sp, #128]            ; 16-byte Folded Spill
	stp	x29, x30, [sp, #144]            ; 16-byte Folded Spill
	add	x29, sp, #144
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
	mov	x9, #0                          ; =0x0
	mov	x10, #4294967296                ; =0x100000000
Lloh8:
	adrp	x8, ___stack_chk_guard@GOTPAGE
Lloh9:
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
Lloh10:
	ldr	x8, [x8]
	str	x8, [sp, #56]
	stur	x10, [sp, #44]
	mov	w8, #3                          ; =0x3
	str	w8, [sp, #52]
	mov	w28, #8                         ; =0x8
	add	x25, sp, #16
Lloh11:
	adrp	x19, l_.memset_pattern@PAGE
Lloh12:
	add	x19, x19, l_.memset_pattern@PAGEOFF
	b	LBB2_2
LBB2_1:                                 ;   in Loop: Header=BB2_2 Depth=1
	ldr	x9, [sp, #8]                    ; 8-byte Folded Reload
	add	x9, x9, #4
	cmp	x9, #12
	b.eq	LBB2_23
LBB2_2:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB2_4 Depth 2
                                        ;       Child Loop BB2_6 Depth 3
                                        ;         Child Loop BB2_12 Depth 4
                                        ;           Child Loop BB2_13 Depth 5
	mov	x26, #0                         ; =0x0
	str	x9, [sp, #8]                    ; 8-byte Folded Spill
	add	x8, sp, #44
	ldr	w21, [x8, x9]
	mov	x8, #4294967296                 ; =0x100000000
	stur	x8, [sp, #28]
	mov	x8, #7                          ; =0x7
	movk	x8, #17, lsl #32
	stur	x8, [sp, #36]
	b	LBB2_4
LBB2_3:                                 ;   in Loop: Header=BB2_4 Depth=2
	add	x26, x26, #4
	cmp	x26, #16
	b.eq	LBB2_1
LBB2_4:                                 ;   Parent Loop BB2_2 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB2_6 Depth 3
                                        ;         Child Loop BB2_12 Depth 4
                                        ;           Child Loop BB2_13 Depth 5
	mov	x27, #0                         ; =0x0
	add	x8, sp, #28
	ldr	w22, [x8, x26]
	mov	x8, #4294967296                 ; =0x100000000
	str	x8, [sp, #16]
	str	w28, [sp, #24]
	b	LBB2_6
LBB2_5:                                 ;   in Loop: Header=BB2_6 Depth=3
	add	x27, x27, #4
	cmp	x27, #12
	b.eq	LBB2_3
LBB2_6:                                 ;   Parent Loop BB2_2 Depth=1
                                        ;     Parent Loop BB2_4 Depth=2
                                        ; =>    This Loop Header: Depth=3
                                        ;         Child Loop BB2_12 Depth 4
                                        ;           Child Loop BB2_13 Depth 5
	ldr	w8, [x25, x27]
	add	x23, x8, x22
	mul	x8, x23, x21
	cbz	x8, LBB2_14
; %bb.7:                                ;   in Loop: Header=BB2_6 Depth=3
	tbnz	x8, #63, LBB2_22
; %bb.8:                                ;   in Loop: Header=BB2_6 Depth=3
	lsl	x24, x8, #1
Ltmp3:
	mov	x0, x24
	bl	__Znwm
Ltmp4:
; %bb.9:                                ;   in Loop: Header=BB2_6 Depth=3
	mov	x20, x0
	mov	x1, x19
	mov	x2, x24
	bl	_memset_pattern16
	add	x8, x20, x24
	cbz	w21, LBB2_15
LBB2_10:                                ;   in Loop: Header=BB2_6 Depth=3
	mov	x9, #0                          ; =0x0
	mov	x10, #0                         ; =0x0
	mov	x24, #0                         ; =0x0
	lsl	x11, x23, #1
	mov	x12, x20
	b	LBB2_12
LBB2_11:                                ;   in Loop: Header=BB2_12 Depth=4
	add	x10, x10, #1
	add	x9, x9, #20
	add	x12, x12, x11
	cmp	x10, x21
	b.eq	LBB2_16
LBB2_12:                                ;   Parent Loop BB2_2 Depth=1
                                        ;     Parent Loop BB2_4 Depth=2
                                        ;       Parent Loop BB2_6 Depth=3
                                        ; =>      This Loop Header: Depth=4
                                        ;           Child Loop BB2_13 Depth 5
	mov	x13, x12
	mov	x14, x9
	mov	x15, x22
	cbz	w22, LBB2_11
LBB2_13:                                ;   Parent Loop BB2_2 Depth=1
                                        ;     Parent Loop BB2_4 Depth=2
                                        ;       Parent Loop BB2_6 Depth=3
                                        ;         Parent Loop BB2_12 Depth=4
                                        ; =>        This Inner Loop Header: Depth=5
	strh	w14, [x13], #2
	add	x24, x24, w14, uxth
	add	x14, x14, #1
	subs	x15, x15, #1
	b.ne	LBB2_13
	b	LBB2_11
LBB2_14:                                ;   in Loop: Header=BB2_6 Depth=3
	mov	x20, #0                         ; =0x0
	cbnz	w21, LBB2_10
LBB2_15:                                ;   in Loop: Header=BB2_6 Depth=3
	mov	x24, #0                         ; =0x0
LBB2_16:                                ;   in Loop: Header=BB2_6 Depth=3
	sub	x8, x8, x20
	asr	x4, x8, #1
Ltmp9:
	mov	x0, x20
	mov	x1, x21
	mov	x2, x22
	mov	x3, x23
	bl	__Z8sum_rowsPKtmmmm
Ltmp10:
; %bb.17:                               ;   in Loop: Header=BB2_6 Depth=3
	cmp	x0, x24
	b.ne	LBB2_20
; %bb.18:                               ;   in Loop: Header=BB2_6 Depth=3
	cbz	x20, LBB2_5
; %bb.19:                               ;   in Loop: Header=BB2_6 Depth=3
	mov	x0, x20
	bl	__ZdlPv
	b	LBB2_5
LBB2_20:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x21, x0
Ltmp12:
Lloh13:
	adrp	x1, l_.str.1@PAGE
Lloh14:
	add	x1, x1, l_.str.1@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp13:
; %bb.21:
Ltmp15:
Lloh15:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh16:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh17:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh18:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x21
	bl	___cxa_throw
Ltmp16:
	b	LBB2_30
LBB2_22:
Ltmp6:
	bl	__ZNSt3__16vectorItNS_9allocatorItEEE20__throw_length_errorB9nqe210106Ev
Ltmp7:
	b	LBB2_30
LBB2_23:
Ltmp18:
	mov	x0, #0                          ; =0x0
	mov	w1, #1                          ; =0x1
	mov	w2, #1                          ; =0x1
	mov	w3, #1                          ; =0x1
	mov	w4, #1                          ; =0x1
	bl	__Z8sum_rowsPKtmmmm
Ltmp19:
; %bb.24:
	mov	w21, #0                         ; =0x0
LBB2_25:
Ltmp23:
	mov	x0, #0                          ; =0x0
	mov	w1, #1                          ; =0x1
	mov	w2, #2                          ; =0x2
	mov	w3, #1                          ; =0x1
	mov	w4, #1                          ; =0x1
	bl	__Z8sum_rowsPKtmmmm
Ltmp24:
LBB2_26:
Ltmp28:
	mov	w20, #1                         ; =0x1
	mov	x0, #0                          ; =0x0
	mov	w1, #2                          ; =0x2
	mov	w2, #1                          ; =0x1
	mov	x3, #-1                         ; =0xffffffffffffffff
	mov	x4, #0                          ; =0x0
	bl	__Z8sum_rowsPKtmmmm
Ltmp29:
LBB2_27:
	strh	w20, [sp, #28]
Ltmp34:
	add	x0, sp, #28
	mov	w1, #2                          ; =0x2
	mov	w2, #1                          ; =0x1
	mov	w3, #1                          ; =0x1
	mov	w4, #1                          ; =0x1
	bl	__Z8sum_rowsPKtmmmm
Ltmp35:
LBB2_28:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x21, x0
Ltmp49:
Lloh19:
	adrp	x1, l_.str.2@PAGE
Lloh20:
	add	x1, x1, l_.str.2@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp50:
; %bb.29:
Ltmp52:
Lloh21:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh22:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh23:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh24:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x21
	bl	___cxa_throw
Ltmp53:
LBB2_30:
	brk	#0x1
LBB2_31:
Ltmp51:
	mov	x19, x1
	mov	x20, x0
	mov	x0, x21
	bl	___cxa_free_exception
	b	LBB2_42
LBB2_32:
Ltmp36:
	mov	x19, x1
	mov	x20, x0
	cmp	w19, #2
	b.ne	LBB2_42
; %bb.33:
	mov	x0, x20
	bl	___cxa_begin_catch
Ltmp37:
	bl	___cxa_end_catch
Ltmp38:
; %bb.34:
	cmp	w21, #3
	b.ne	LBB2_28
; %bb.35:
Ltmp39:
Lloh25:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh26:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh27:
	adrp	x1, l_.str.3@PAGE
Lloh28:
	add	x1, x1, l_.str.3@PAGEOFF
	mov	w2, #13                         ; =0xd
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp40:
; %bb.36:
Ltmp41:
	mov	w1, #36                         ; =0x24
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp42:
; %bb.37:
Ltmp43:
Lloh29:
	adrp	x1, l_.str.4@PAGE
Lloh30:
	add	x1, x1, l_.str.4@PAGEOFF
	mov	w2, #9                          ; =0x9
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp44:
; %bb.38:
Ltmp45:
	mov	w1, #4                          ; =0x4
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEj
Ltmp46:
; %bb.39:
Ltmp47:
Lloh31:
	adrp	x1, l_.str.5@PAGE
Lloh32:
	add	x1, x1, l_.str.5@PAGEOFF
	mov	w2, #6                          ; =0x6
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp48:
; %bb.40:
	mov	w0, #0                          ; =0x0
	b	LBB2_65
LBB2_41:
Ltmp54:
	mov	x19, x1
	mov	x20, x0
LBB2_42:
	mov	x0, x20
	b	LBB2_60
LBB2_43:
Ltmp30:
	mov	x19, x1
	cmp	w19, #2
	b.ne	LBB2_60
; %bb.44:
	bl	___cxa_begin_catch
Ltmp31:
	bl	___cxa_end_catch
Ltmp32:
; %bb.45:
	add	w21, w21, #1
	b	LBB2_27
LBB2_46:
Ltmp25:
	mov	x19, x1
	cmp	w19, #2
	b.ne	LBB2_60
; %bb.47:
	bl	___cxa_begin_catch
Ltmp26:
	bl	___cxa_end_catch
Ltmp27:
; %bb.48:
	add	w21, w21, #1
	b	LBB2_26
LBB2_49:
Ltmp20:
	mov	x19, x1
	cmp	w19, #2
	b.ne	LBB2_60
; %bb.50:
	bl	___cxa_begin_catch
Ltmp21:
	bl	___cxa_end_catch
Ltmp22:
; %bb.51:
	mov	w21, #1                         ; =0x1
	b	LBB2_25
LBB2_52:
Ltmp33:
	mov	x19, x1
	b	LBB2_60
LBB2_53:
Ltmp17:
	b	LBB2_58
LBB2_54:
Ltmp14:
	mov	x19, x1
	mov	x22, x0
	mov	x0, x21
	bl	___cxa_free_exception
	mov	x0, x22
	cbnz	x20, LBB2_59
	b	LBB2_60
LBB2_55:
Ltmp5:
	mov	x19, x1
	b	LBB2_60
LBB2_56:
Ltmp8:
	mov	x19, x1
	b	LBB2_60
LBB2_57:
Ltmp11:
LBB2_58:
	mov	x19, x1
	cbz	x20, LBB2_60
LBB2_59:
	mov	x21, x0
	mov	x0, x20
	bl	__ZdlPv
	mov	x0, x21
LBB2_60:
	cmp	w19, #1
	b.ne	LBB2_69
; %bb.61:
	bl	___cxa_begin_catch
	ldr	x8, [x0]
	ldr	x8, [x8, #16]
	blr	x8
	mov	x19, x0
	bl	_strlen
	mov	x2, x0
Ltmp55:
Lloh33:
	adrp	x0, __ZNSt3__14cerrE@GOTPAGE
Lloh34:
	ldr	x0, [x0, __ZNSt3__14cerrE@GOTPAGEOFF]
	mov	x1, x19
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp56:
; %bb.62:
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #28]
Ltmp57:
	add	x1, sp, #28
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp58:
; %bb.63:
Ltmp63:
	bl	___cxa_end_catch
Ltmp64:
; %bb.64:
	mov	w0, #1                          ; =0x1
LBB2_65:
	ldr	x8, [sp, #56]
Lloh35:
	adrp	x9, ___stack_chk_guard@GOTPAGE
Lloh36:
	ldr	x9, [x9, ___stack_chk_guard@GOTPAGEOFF]
Lloh37:
	ldr	x9, [x9]
	cmp	x9, x8
	b.ne	LBB2_67
; %bb.66:
	ldp	x29, x30, [sp, #144]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #128]            ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #112]            ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #96]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #80]             ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #64]             ; 16-byte Folded Reload
	add	sp, sp, #160
	ret
LBB2_67:
	bl	___stack_chk_fail
LBB2_68:
Ltmp65:
LBB2_69:
	mov	x19, x0
	mov	x0, x19
	bl	__Unwind_Resume
LBB2_70:
Ltmp59:
	mov	x19, x0
Ltmp60:
	bl	___cxa_end_catch
Ltmp61:
	b	LBB2_72
LBB2_71:
Ltmp62:
	mov	x19, x0
	cbnz	w1, LBB2_73
LBB2_72:
	mov	x0, x19
	bl	__Unwind_Resume
LBB2_73:
	mov	x0, x19
	bl	___clang_call_terminate
	.loh AdrpAdd	Lloh11, Lloh12
	.loh AdrpLdrGotLdr	Lloh8, Lloh9, Lloh10
	.loh AdrpAdd	Lloh13, Lloh14
	.loh AdrpLdrGot	Lloh17, Lloh18
	.loh AdrpLdrGot	Lloh15, Lloh16
	.loh AdrpAdd	Lloh19, Lloh20
	.loh AdrpLdrGot	Lloh23, Lloh24
	.loh AdrpLdrGot	Lloh21, Lloh22
	.loh AdrpAdd	Lloh27, Lloh28
	.loh AdrpLdrGot	Lloh25, Lloh26
	.loh AdrpAdd	Lloh29, Lloh30
	.loh AdrpAdd	Lloh31, Lloh32
	.loh AdrpLdrGot	Lloh33, Lloh34
	.loh AdrpLdrGotLdr	Lloh35, Lloh36, Lloh37
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
	.uleb128 Ltmp9-Lfunc_begin1             ; >> Call Site 2 <<
	.uleb128 Ltmp10-Ltmp9                   ;   Call between Ltmp9 and Ltmp10
	.uleb128 Ltmp11-Lfunc_begin1            ;     jumps to Ltmp11
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp10-Lfunc_begin1            ; >> Call Site 3 <<
	.uleb128 Ltmp12-Ltmp10                  ;   Call between Ltmp10 and Ltmp12
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp12-Lfunc_begin1            ; >> Call Site 4 <<
	.uleb128 Ltmp13-Ltmp12                  ;   Call between Ltmp12 and Ltmp13
	.uleb128 Ltmp14-Lfunc_begin1            ;     jumps to Ltmp14
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp15-Lfunc_begin1            ; >> Call Site 5 <<
	.uleb128 Ltmp16-Ltmp15                  ;   Call between Ltmp15 and Ltmp16
	.uleb128 Ltmp17-Lfunc_begin1            ;     jumps to Ltmp17
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp6-Lfunc_begin1             ; >> Call Site 6 <<
	.uleb128 Ltmp7-Ltmp6                    ;   Call between Ltmp6 and Ltmp7
	.uleb128 Ltmp8-Lfunc_begin1             ;     jumps to Ltmp8
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp18-Lfunc_begin1            ; >> Call Site 7 <<
	.uleb128 Ltmp19-Ltmp18                  ;   Call between Ltmp18 and Ltmp19
	.uleb128 Ltmp20-Lfunc_begin1            ;     jumps to Ltmp20
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp23-Lfunc_begin1            ; >> Call Site 8 <<
	.uleb128 Ltmp24-Ltmp23                  ;   Call between Ltmp23 and Ltmp24
	.uleb128 Ltmp25-Lfunc_begin1            ;     jumps to Ltmp25
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp28-Lfunc_begin1            ; >> Call Site 9 <<
	.uleb128 Ltmp29-Ltmp28                  ;   Call between Ltmp28 and Ltmp29
	.uleb128 Ltmp30-Lfunc_begin1            ;     jumps to Ltmp30
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp34-Lfunc_begin1            ; >> Call Site 10 <<
	.uleb128 Ltmp35-Ltmp34                  ;   Call between Ltmp34 and Ltmp35
	.uleb128 Ltmp36-Lfunc_begin1            ;     jumps to Ltmp36
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp35-Lfunc_begin1            ; >> Call Site 11 <<
	.uleb128 Ltmp49-Ltmp35                  ;   Call between Ltmp35 and Ltmp49
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp49-Lfunc_begin1            ; >> Call Site 12 <<
	.uleb128 Ltmp50-Ltmp49                  ;   Call between Ltmp49 and Ltmp50
	.uleb128 Ltmp51-Lfunc_begin1            ;     jumps to Ltmp51
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp52-Lfunc_begin1            ; >> Call Site 13 <<
	.uleb128 Ltmp53-Ltmp52                  ;   Call between Ltmp52 and Ltmp53
	.uleb128 Ltmp54-Lfunc_begin1            ;     jumps to Ltmp54
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp53-Lfunc_begin1            ; >> Call Site 14 <<
	.uleb128 Ltmp37-Ltmp53                  ;   Call between Ltmp53 and Ltmp37
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp37-Lfunc_begin1            ; >> Call Site 15 <<
	.uleb128 Ltmp48-Ltmp37                  ;   Call between Ltmp37 and Ltmp48
	.uleb128 Ltmp54-Lfunc_begin1            ;     jumps to Ltmp54
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp48-Lfunc_begin1            ; >> Call Site 16 <<
	.uleb128 Ltmp31-Ltmp48                  ;   Call between Ltmp48 and Ltmp31
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp31-Lfunc_begin1            ; >> Call Site 17 <<
	.uleb128 Ltmp32-Ltmp31                  ;   Call between Ltmp31 and Ltmp32
	.uleb128 Ltmp33-Lfunc_begin1            ;     jumps to Ltmp33
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp32-Lfunc_begin1            ; >> Call Site 18 <<
	.uleb128 Ltmp26-Ltmp32                  ;   Call between Ltmp32 and Ltmp26
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp26-Lfunc_begin1            ; >> Call Site 19 <<
	.uleb128 Ltmp27-Ltmp26                  ;   Call between Ltmp26 and Ltmp27
	.uleb128 Ltmp33-Lfunc_begin1            ;     jumps to Ltmp33
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp27-Lfunc_begin1            ; >> Call Site 20 <<
	.uleb128 Ltmp21-Ltmp27                  ;   Call between Ltmp27 and Ltmp21
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp21-Lfunc_begin1            ; >> Call Site 21 <<
	.uleb128 Ltmp22-Ltmp21                  ;   Call between Ltmp21 and Ltmp22
	.uleb128 Ltmp33-Lfunc_begin1            ;     jumps to Ltmp33
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp22-Lfunc_begin1            ; >> Call Site 22 <<
	.uleb128 Ltmp55-Ltmp22                  ;   Call between Ltmp22 and Ltmp55
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp55-Lfunc_begin1            ; >> Call Site 23 <<
	.uleb128 Ltmp58-Ltmp55                  ;   Call between Ltmp55 and Ltmp58
	.uleb128 Ltmp59-Lfunc_begin1            ;     jumps to Ltmp59
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp63-Lfunc_begin1            ; >> Call Site 24 <<
	.uleb128 Ltmp64-Ltmp63                  ;   Call between Ltmp63 and Ltmp64
	.uleb128 Ltmp65-Lfunc_begin1            ;     jumps to Ltmp65
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp64-Lfunc_begin1            ; >> Call Site 25 <<
	.uleb128 Ltmp60-Ltmp64                  ;   Call between Ltmp64 and Ltmp60
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp60-Lfunc_begin1            ; >> Call Site 26 <<
	.uleb128 Ltmp61-Ltmp60                  ;   Call between Ltmp60 and Ltmp61
	.uleb128 Ltmp62-Lfunc_begin1            ;     jumps to Ltmp62
	.byte	9                               ;   On action: 5
	.uleb128 Ltmp61-Lfunc_begin1            ; >> Call Site 27 <<
	.uleb128 Lfunc_end1-Ltmp61              ;   Call between Ltmp61 and Lfunc_end1
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
Ltmp94:                                 ; TypeInfo 2
	.long	__ZTISt16invalid_argument@GOT-Ltmp94
Ltmp95:                                 ; TypeInfo 1
	.long	__ZTISt9exception@GOT-Ltmp95
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
	.private_extern	__ZNSt3__16vectorItNS_9allocatorItEEE20__throw_length_errorB9nqe210106Ev ; -- Begin function _ZNSt3__16vectorItNS_9allocatorItEEE20__throw_length_errorB9nqe210106Ev
	.globl	__ZNSt3__16vectorItNS_9allocatorItEEE20__throw_length_errorB9nqe210106Ev
	.weak_def_can_be_hidden	__ZNSt3__16vectorItNS_9allocatorItEEE20__throw_length_errorB9nqe210106Ev
	.p2align	2
__ZNSt3__16vectorItNS_9allocatorItEEE20__throw_length_errorB9nqe210106Ev: ; @_ZNSt3__16vectorItNS_9allocatorItEEE20__throw_length_errorB9nqe210106Ev
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh38:
	adrp	x0, l_.str.6@PAGE
Lloh39:
	add	x0, x0, l_.str.6@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh38, Lloh39
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
Ltmp66:
	mov	x1, x20
	bl	__ZNSt12length_errorC1B9nqe210106EPKc
Ltmp67:
; %bb.1:
Lloh40:
	adrp	x1, __ZTISt12length_error@GOTPAGE
Lloh41:
	ldr	x1, [x1, __ZTISt12length_error@GOTPAGEOFF]
Lloh42:
	adrp	x2, __ZNSt12length_errorD1Ev@GOTPAGE
Lloh43:
	ldr	x2, [x2, __ZNSt12length_errorD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
LBB5_2:
Ltmp68:
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x0, x20
	bl	__Unwind_Resume
	.loh AdrpLdrGot	Lloh42, Lloh43
	.loh AdrpLdrGot	Lloh40, Lloh41
Lfunc_end2:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table5:
Lexception2:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end2-Lcst_begin2
Lcst_begin2:
	.uleb128 Lfunc_begin2-Lfunc_begin2      ; >> Call Site 1 <<
	.uleb128 Ltmp66-Lfunc_begin2            ;   Call between Lfunc_begin2 and Ltmp66
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp66-Lfunc_begin2            ; >> Call Site 2 <<
	.uleb128 Ltmp67-Ltmp66                  ;   Call between Ltmp66 and Ltmp67
	.uleb128 Ltmp68-Lfunc_begin2            ;     jumps to Ltmp68
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp67-Lfunc_begin2            ; >> Call Site 3 <<
	.uleb128 Lfunc_end2-Ltmp67              ;   Call between Ltmp67 and Lfunc_end2
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
Lloh44:
	adrp	x8, __ZTVSt12length_error@GOTPAGE
Lloh45:
	ldr	x8, [x8, __ZTVSt12length_error@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x0]
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
	.loh AdrpLdrGot	Lloh44, Lloh45
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
Ltmp69:
	add	x0, sp, #8
	mov	x1, x19
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryC1ERS3_
Ltmp70:
; %bb.1:
	ldrb	w8, [sp, #8]
	cmp	w8, #1
	b.ne	LBB7_10
; %bb.2:
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
	add	x4, x19, x8
	ldr	x22, [x4, #40]
	ldr	w24, [x4, #8]
	ldr	w23, [x4, #144]
	cmn	w23, #1
	b.ne	LBB7_7
; %bb.3:
Ltmp72:
	add	x8, sp, #24
	mov	x25, x4
	mov	x0, x4
	bl	__ZNKSt3__18ios_base6getlocEv
Ltmp73:
; %bb.4:
Ltmp74:
Lloh46:
	adrp	x1, __ZNSt3__15ctypeIcE2idE@GOTPAGE
Lloh47:
	ldr	x1, [x1, __ZNSt3__15ctypeIcE2idE@GOTPAGEOFF]
	add	x0, sp, #24
	bl	__ZNKSt3__16locale9use_facetERNS0_2idE
Ltmp75:
; %bb.5:
	ldr	x8, [x0]
	ldr	x8, [x8, #56]
Ltmp76:
	mov	w1, #32                         ; =0x20
	blr	x8
Ltmp77:
; %bb.6:
	mov	x23, x0
	add	x0, sp, #24
	bl	__ZNSt3__16localeD1Ev
	mov	x4, x25
	str	w23, [x25, #144]
LBB7_7:
	mov	w8, #176                        ; =0xb0
	and	w8, w24, w8
	add	x3, x20, x21
	cmp	w8, #32
	csel	x2, x3, x20, eq
Ltmp79:
	sxtb	w5, w23
	mov	x0, x22
	mov	x1, x20
	bl	__ZNSt3__116__pad_and_outputB9nqe210106IcNS_11char_traitsIcEEEENS_19ostreambuf_iteratorIT_T0_EES6_PKS4_S8_S8_RNS_8ios_baseES4_
Ltmp80:
; %bb.8:
	cbnz	x0, LBB7_10
; %bb.9:
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
	add	x0, x19, x8
	ldr	w8, [x0, #32]
	mov	w9, #5                          ; =0x5
Ltmp82:
	orr	w1, w8, w9
	bl	__ZNSt3__18ios_base5clearEj
Ltmp83:
LBB7_10:
	add	x0, sp, #8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryD1Ev
LBB7_11:
	mov	x0, x19
	ldp	x29, x30, [sp, #96]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #80]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #64]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #48]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #112
	ret
LBB7_12:
Ltmp84:
	b	LBB7_15
LBB7_13:
Ltmp78:
	mov	x20, x0
	add	x0, sp, #24
	bl	__ZNSt3__16localeD1Ev
	b	LBB7_16
LBB7_14:
Ltmp81:
LBB7_15:
	mov	x20, x0
LBB7_16:
	add	x0, sp, #8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryD1Ev
	b	LBB7_18
LBB7_17:
Ltmp71:
	mov	x20, x0
LBB7_18:
	mov	x0, x20
	bl	___cxa_begin_catch
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
Ltmp85:
	add	x0, x19, x8
	bl	__ZNSt3__18ios_base33__set_badbit_and_consider_rethrowEv
Ltmp86:
; %bb.19:
	bl	___cxa_end_catch
	b	LBB7_11
LBB7_20:
Ltmp87:
	mov	x19, x0
Ltmp88:
	bl	___cxa_end_catch
Ltmp89:
; %bb.21:
	mov	x0, x19
	bl	__Unwind_Resume
LBB7_22:
Ltmp90:
	bl	___clang_call_terminate
	.loh AdrpLdrGot	Lloh46, Lloh47
Lfunc_end3:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table7:
Lexception3:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase1-Lttbaseref1
Lttbaseref1:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end3-Lcst_begin3
Lcst_begin3:
	.uleb128 Ltmp69-Lfunc_begin3            ; >> Call Site 1 <<
	.uleb128 Ltmp70-Ltmp69                  ;   Call between Ltmp69 and Ltmp70
	.uleb128 Ltmp71-Lfunc_begin3            ;     jumps to Ltmp71
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp72-Lfunc_begin3            ; >> Call Site 2 <<
	.uleb128 Ltmp73-Ltmp72                  ;   Call between Ltmp72 and Ltmp73
	.uleb128 Ltmp81-Lfunc_begin3            ;     jumps to Ltmp81
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp74-Lfunc_begin3            ; >> Call Site 3 <<
	.uleb128 Ltmp77-Ltmp74                  ;   Call between Ltmp74 and Ltmp77
	.uleb128 Ltmp78-Lfunc_begin3            ;     jumps to Ltmp78
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp79-Lfunc_begin3            ; >> Call Site 4 <<
	.uleb128 Ltmp80-Ltmp79                  ;   Call between Ltmp79 and Ltmp80
	.uleb128 Ltmp81-Lfunc_begin3            ;     jumps to Ltmp81
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp82-Lfunc_begin3            ; >> Call Site 5 <<
	.uleb128 Ltmp83-Ltmp82                  ;   Call between Ltmp82 and Ltmp83
	.uleb128 Ltmp84-Lfunc_begin3            ;     jumps to Ltmp84
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp83-Lfunc_begin3            ; >> Call Site 6 <<
	.uleb128 Ltmp85-Ltmp83                  ;   Call between Ltmp83 and Ltmp85
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp85-Lfunc_begin3            ; >> Call Site 7 <<
	.uleb128 Ltmp86-Ltmp85                  ;   Call between Ltmp85 and Ltmp86
	.uleb128 Ltmp87-Lfunc_begin3            ;     jumps to Ltmp87
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp86-Lfunc_begin3            ; >> Call Site 8 <<
	.uleb128 Ltmp88-Ltmp86                  ;   Call between Ltmp86 and Ltmp88
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp88-Lfunc_begin3            ; >> Call Site 9 <<
	.uleb128 Ltmp89-Ltmp88                  ;   Call between Ltmp88 and Ltmp89
	.uleb128 Ltmp90-Lfunc_begin3            ;     jumps to Ltmp90
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp89-Lfunc_begin3            ; >> Call Site 10 <<
	.uleb128 Lfunc_end3-Ltmp89              ;   Call between Ltmp89 and Lfunc_end3
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
	cbz	x0, LBB8_16
; %bb.1:
	mov	x23, x5
	mov	x20, x4
	mov	x22, x3
	mov	x21, x2
	mov	x24, x1
	ldr	x26, [x4, #24]
	sub	x25, x2, x1
	cmp	x25, #1
	b.lt	LBB8_3
; %bb.2:
	ldr	x8, [x19]
	ldr	x8, [x8, #96]
	mov	x0, x19
	mov	x1, x24
	mov	x2, x25
	blr	x8
	cmp	x0, x25
	b.ne	LBB8_15
LBB8_3:
	sub	x8, x22, x24
	cmp	x26, x8
	b.le	LBB8_12
; %bb.4:
	mov	x9, #-9                         ; =0xfffffffffffffff7
	movk	x9, #32767, lsl #48
	sub	x24, x26, x8
	cmp	x24, x9
	b.hs	LBB8_17
; %bb.5:
	cmp	x24, #23
	b.hs	LBB8_7
; %bb.6:
	strb	w24, [sp, #31]
	add	x25, sp, #8
	b	LBB8_8
LBB8_7:
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
LBB8_8:
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
Ltmp91:
	mov	x0, x19
	mov	x2, x24
	blr	x8
Ltmp92:
; %bb.9:
	ldrsb	w8, [sp, #31]
	tbnz	w8, #31, LBB8_11
; %bb.10:
	cmp	x0, x24
	b.ne	LBB8_15
	b	LBB8_12
LBB8_11:
	ldr	x8, [sp, #8]
	mov	x23, x0
	mov	x0, x8
	bl	__ZdlPv
	mov	x0, x23
	cmp	x0, x24
	b.ne	LBB8_15
LBB8_12:
	sub	x22, x22, x21
	cmp	x22, #1
	b.lt	LBB8_14
; %bb.13:
	ldr	x8, [x19]
	ldr	x8, [x8, #96]
	mov	x0, x19
	mov	x1, x21
	mov	x2, x22
	blr	x8
	cmp	x0, x22
	b.ne	LBB8_15
LBB8_14:
	str	xzr, [x20, #24]
	b	LBB8_16
LBB8_15:
	mov	x19, #0                         ; =0x0
LBB8_16:
	mov	x0, x19
	ldp	x29, x30, [sp, #96]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #80]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #64]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #48]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #112
	ret
LBB8_17:
	bl	__ZNSt3__112basic_stringIcNS_11char_traitsIcEENS_9allocatorIcEEE20__throw_length_errorB9nqe210106Ev
LBB8_18:
Ltmp93:
	mov	x19, x0
	ldrsb	w8, [sp, #31]
	tbz	w8, #31, LBB8_20
; %bb.19:
	ldr	x0, [sp, #8]
	bl	__ZdlPv
LBB8_20:
	mov	x0, x19
	bl	__Unwind_Resume
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
	.uleb128 Ltmp91-Lfunc_begin4            ;   Call between Lfunc_begin4 and Ltmp91
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp91-Lfunc_begin4            ; >> Call Site 2 <<
	.uleb128 Ltmp92-Ltmp91                  ;   Call between Ltmp91 and Ltmp92
	.uleb128 Ltmp93-Lfunc_begin4            ;     jumps to Ltmp93
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp92-Lfunc_begin4            ; >> Call Site 3 <<
	.uleb128 Lfunc_end4-Ltmp92              ;   Call between Ltmp92 and Lfunc_end4
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
Lloh48:
	adrp	x0, l_.str.7@PAGE
Lloh49:
	add	x0, x0, l_.str.7@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh48, Lloh49
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"invalid span/stride"

l_.str.1:                               ; @.str.1
	.asciz	"padding included or bad address"

l_.str.2:                               ; @.str.2
	.asciz	"invalid span accepted"

l_.str.3:                               ; @.str.3
	.asciz	"stride cases="

l_.str.4:                               ; @.str.4
	.asciz	" invalid="

l_.str.5:                               ; @.str.5
	.asciz	" PASS\n"

l_.str.6:                               ; @.str.6
	.asciz	"vector"

l_.str.7:                               ; @.str.7
	.asciz	"basic_string"

	.section	__TEXT,__literal16,16byte_literals
	.p2align	4, 0x0                          ; @.memset_pattern
l_.memset_pattern:
	.short	60000                           ; 0xea60
	.short	60000                           ; 0xea60
	.short	60000                           ; 0xea60
	.short	60000                           ; 0xea60
	.short	60000                           ; 0xea60
	.short	60000                           ; 0xea60
	.short	60000                           ; 0xea60
	.short	60000                           ; 0xea60

.subsections_via_symbols
