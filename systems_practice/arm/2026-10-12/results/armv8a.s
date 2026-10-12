	.build_version macos, 26, 0	sdk_version 26, 5
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_observe                        ; -- Begin function observe
	.p2align	2
_observe:                               ; @observe
	.cfi_startproc
; %bb.0:
	ldapr	w0, [x0]
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_publish                        ; -- Begin function publish
	.p2align	2
_publish:                               ; @publish
	.cfi_startproc
; %bb.0:
	stlr	w1, [x0]
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_ticket                         ; -- Begin function ticket
	.p2align	2
_ticket:                                ; @ticket
	.cfi_startproc
; %bb.0:
	mov	w8, #1                          ; =0x1
	ldadd	w8, w0, [x0]
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__Z8transferbi                  ; -- Begin function _Z8transferbi
	.p2align	2
__Z8transferbi:                         ; @_Z8transferbi
Lfunc_begin0:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception0
; %bb.0:
	sub	sp, sp, #128
	stp	x20, x19, [sp, #96]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #112]            ; 16-byte Folded Spill
	add	x29, sp, #112
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	sturb	w0, [x29, #-25]
	stp	wzr, w1, [x29, #-36]
	sturb	wzr, [x29, #-37]
	stur	xzr, [x29, #-48]
	sub	x8, x29, #25
	sub	x9, x29, #36
	stp	x9, x8, [sp, #32]
	stp	x9, xzr, [sp, #48]
	str	x8, [sp, #24]
	mov	w0, #8                          ; =0x8
	bl	__Znwm
	mov	x19, x0
Ltmp0:
	bl	__ZNSt3__115__thread_structC1Ev
Ltmp1:
; %bb.1:
	str	x19, [sp]
Ltmp3:
	mov	w0, #56                         ; =0x38
	bl	__Znwm
Ltmp4:
; %bb.2:
	mov	x3, x0
	str	xzr, [sp]
	sub	x8, x29, #32
	stp	x19, x8, [x0]
	add	x8, sp, #40
	sub	x9, x29, #37
	stp	x8, x9, [x0, #16]
	sub	x8, x29, #48
	add	x9, sp, #56
	stp	x8, x9, [x0, #32]
	add	x8, sp, #24
	str	x8, [x0, #48]
	stur	x0, [x29, #-24]
Ltmp6:
Lloh0:
	adrp	x2, __ZNSt3__114__thread_proxyB9nqe210106INS_5tupleIJNS_10unique_ptrINS_15__thread_structENS_14default_deleteIS3_EEEEZ8transferbiE3$_2EEEEEPvS9_@PAGE
Lloh1:
	add	x2, x2, __ZNSt3__114__thread_proxyB9nqe210106INS_5tupleIJNS_10unique_ptrINS_15__thread_structENS_14default_deleteIS3_EEEEZ8transferbiE3$_2EEEEEPvS9_@PAGEOFF
	add	x0, sp, #16
	mov	x1, #0                          ; =0x0
	bl	_pthread_create
Ltmp7:
; %bb.3:
	cbnz	w0, LBB3_22
; %bb.4:
	add	x0, sp, #16
	sub	x8, x29, #37
	stp	x0, x8, [sp]
	ldur	w9, [x29, #-32]
	cmp	w9, #1
	b.lt	LBB3_17
; %bb.5:
	mov	w19, #1                         ; =0x1
	mov	w20, #42330                     ; =0xa55a
	movk	w20, #42330, lsl #16
	b	LBB3_8
LBB3_6:                                 ;   in Loop: Header=BB3_8 Depth=1
	bl	_observe
	cmp	w0, #1
	b.eq	LBB3_10
LBB3_7:                                 ;   in Loop: Header=BB3_8 Depth=1
Ltmp11:
	bl	_sched_yield
Ltmp12:
LBB3_8:                                 ; =>This Inner Loop Header: Depth=1
	ldp	x8, x0, [sp, #40]
	ldrb	w8, [x8]
	cmp	w8, #1
	b.ne	LBB3_6
; %bb.9:                                ;   in Loop: Header=BB3_8 Depth=1
	ldar	w0, [x0]
	cmp	w0, #1
	b.ne	LBB3_7
LBB3_10:                                ;   in Loop: Header=BB3_8 Depth=1
	ldur	x8, [x29, #-48]
	cmp	x8, x19
	b.ne	LBB3_20
; %bb.11:                               ;   in Loop: Header=BB3_8 Depth=1
	ldr	x8, [sp, #56]
	eor	x8, x8, x19
	cmp	x8, x20
	b.ne	LBB3_20
; %bb.12:                               ;   in Loop: Header=BB3_8 Depth=1
	ldp	x8, x0, [sp, #24]
	ldrb	w8, [x8]
	cmp	w8, #1
	b.ne	LBB3_14
; %bb.13:                               ;   in Loop: Header=BB3_8 Depth=1
	stlr	wzr, [x0]
	b	LBB3_15
LBB3_14:                                ;   in Loop: Header=BB3_8 Depth=1
	mov	w1, #0                          ; =0x0
	bl	_publish
LBB3_15:                                ;   in Loop: Header=BB3_8 Depth=1
	ldursw	x8, [x29, #-32]
	cmp	x19, x8
	add	x19, x19, #1
	b.lt	LBB3_8
; %bb.16:
	ldp	x0, x8, [sp]
LBB3_17:
	mov	w9, #1                          ; =0x1
	stlrb	w9, [x8]
	ldr	x8, [x0]
	cbz	x8, LBB3_19
; %bb.18:
Ltmp20:
	bl	__ZNSt3__16thread4joinEv
Ltmp21:
LBB3_19:
	add	x0, sp, #16
	bl	__ZNSt3__16threadD1Ev
	ldp	x29, x30, [sp, #112]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #96]             ; 16-byte Folded Reload
	add	sp, sp, #128
	ret
LBB3_20:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x20, x0
Ltmp14:
Lloh2:
	adrp	x1, l_.str@PAGE
Lloh3:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp15:
; %bb.21:
Ltmp17:
Lloh4:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh5:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh6:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh7:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x20
	bl	___cxa_throw
Ltmp18:
	b	LBB3_23
LBB3_22:
Ltmp8:
Lloh8:
	adrp	x1, l_.str.5@PAGE
Lloh9:
	add	x1, x1, l_.str.5@PAGEOFF
	bl	__ZNSt3__120__throw_system_errorEiPKc
Ltmp9:
LBB3_23:
	brk	#0x1
LBB3_24:
Ltmp22:
	bl	___clang_call_terminate
LBB3_25:
Ltmp5:
	mov	x19, x0
	b	LBB3_28
LBB3_26:
Ltmp2:
	mov	x8, x19
	mov	x19, x0
	mov	x0, x8
	bl	__ZdlPv
	mov	x0, x19
	bl	__Unwind_Resume
LBB3_27:
Ltmp10:
	mov	x19, x0
	sub	x0, x29, #24
	bl	__ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ8transferbiE3$_2EEENS3_IS7_EEED1B9nqe210106Ev
LBB3_28:
	mov	x0, sp
	bl	__ZNSt3__110unique_ptrINS_15__thread_structENS_14default_deleteIS1_EEED1B9nqe210106Ev
	mov	x0, x19
	bl	__Unwind_Resume
LBB3_29:
Ltmp19:
	mov	x19, x0
	b	LBB3_31
LBB3_30:
Ltmp16:
	mov	x19, x0
	mov	x0, x20
	bl	___cxa_free_exception
LBB3_31:
	mov	x0, sp
	bl	__ZN4JoinD1Ev
	add	x0, sp, #16
	bl	__ZNSt3__16threadD1Ev
	mov	x0, x19
	bl	__Unwind_Resume
LBB3_32:
Ltmp13:
	bl	___clang_call_terminate
	.loh AdrpAdd	Lloh0, Lloh1
	.loh AdrpAdd	Lloh2, Lloh3
	.loh AdrpLdrGot	Lloh6, Lloh7
	.loh AdrpLdrGot	Lloh4, Lloh5
	.loh AdrpAdd	Lloh8, Lloh9
Lfunc_end0:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table3:
Lexception0:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase0-Lttbaseref0
Lttbaseref0:
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
	.uleb128 Ltmp3-Lfunc_begin0             ; >> Call Site 3 <<
	.uleb128 Ltmp4-Ltmp3                    ;   Call between Ltmp3 and Ltmp4
	.uleb128 Ltmp5-Lfunc_begin0             ;     jumps to Ltmp5
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp6-Lfunc_begin0             ; >> Call Site 4 <<
	.uleb128 Ltmp7-Ltmp6                    ;   Call between Ltmp6 and Ltmp7
	.uleb128 Ltmp10-Lfunc_begin0            ;     jumps to Ltmp10
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp11-Lfunc_begin0            ; >> Call Site 5 <<
	.uleb128 Ltmp12-Ltmp11                  ;   Call between Ltmp11 and Ltmp12
	.uleb128 Ltmp13-Lfunc_begin0            ;     jumps to Ltmp13
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp20-Lfunc_begin0            ; >> Call Site 6 <<
	.uleb128 Ltmp21-Ltmp20                  ;   Call between Ltmp20 and Ltmp21
	.uleb128 Ltmp22-Lfunc_begin0            ;     jumps to Ltmp22
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp21-Lfunc_begin0            ; >> Call Site 7 <<
	.uleb128 Ltmp14-Ltmp21                  ;   Call between Ltmp21 and Ltmp14
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp14-Lfunc_begin0            ; >> Call Site 8 <<
	.uleb128 Ltmp15-Ltmp14                  ;   Call between Ltmp14 and Ltmp15
	.uleb128 Ltmp16-Lfunc_begin0            ;     jumps to Ltmp16
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp17-Lfunc_begin0            ; >> Call Site 9 <<
	.uleb128 Ltmp18-Ltmp17                  ;   Call between Ltmp17 and Ltmp18
	.uleb128 Ltmp19-Lfunc_begin0            ;     jumps to Ltmp19
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp8-Lfunc_begin0             ; >> Call Site 10 <<
	.uleb128 Ltmp9-Ltmp8                    ;   Call between Ltmp8 and Ltmp9
	.uleb128 Ltmp10-Lfunc_begin0            ;     jumps to Ltmp10
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp9-Lfunc_begin0             ; >> Call Site 11 <<
	.uleb128 Lfunc_end0-Ltmp9               ;   Call between Ltmp9 and Lfunc_end0
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end0:
	.byte	1                               ; >> Action Record 1 <<
                                        ;   Catch TypeInfo 1
	.byte	0                               ;   No further actions
	.p2align	2, 0x0
                                        ; >> Catch TypeInfos <<
	.long	0                               ; TypeInfo 1
Lttbase0:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__ZN4JoinD1Ev                   ; -- Begin function _ZN4JoinD1Ev
	.weak_def_can_be_hidden	__ZN4JoinD1Ev
	.p2align	2
__ZN4JoinD1Ev:                          ; @_ZN4JoinD1Ev
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
	mov	x19, x0
	ldr	x8, [x0, #8]
	mov	w9, #1                          ; =0x1
	stlrb	w9, [x8]
	ldr	x0, [x0]
	ldr	x8, [x0]
	cbz	x8, LBB4_2
; %bb.1:
Ltmp23:
	bl	__ZNSt3__16thread4joinEv
Ltmp24:
LBB4_2:
	mov	x0, x19
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
	ret
LBB4_3:
Ltmp25:
	bl	___clang_call_terminate
Lfunc_end1:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table4:
Lexception1:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase1-Lttbaseref1
Lttbaseref1:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end1-Lcst_begin1
Lcst_begin1:
	.uleb128 Ltmp23-Lfunc_begin1            ; >> Call Site 1 <<
	.uleb128 Ltmp24-Ltmp23                  ;   Call between Ltmp23 and Ltmp24
	.uleb128 Ltmp25-Lfunc_begin1            ;     jumps to Ltmp25
	.byte	1                               ;   On action: 1
Lcst_end1:
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
	.globl	_main                           ; -- Begin function main
	.p2align	2
_main:                                  ; @main
Lfunc_begin2:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception2
; %bb.0:
	sub	sp, sp, #64
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
Ltmp26:
	mov	w0, #1                          ; =0x1
	mov	w1, #0                          ; =0x0
	bl	__Z8transferbi
Ltmp27:
; %bb.1:
Ltmp28:
	mov	w0, #0                          ; =0x0
	mov	w1, #0                          ; =0x0
	bl	__Z8transferbi
Ltmp29:
; %bb.2:
Ltmp30:
	mov	w0, #1                          ; =0x1
	mov	w1, #1                          ; =0x1
	bl	__Z8transferbi
Ltmp31:
; %bb.3:
Ltmp32:
	mov	w0, #0                          ; =0x0
	mov	w1, #1                          ; =0x1
	bl	__Z8transferbi
Ltmp33:
; %bb.4:
Ltmp34:
	mov	w0, #1                          ; =0x1
	mov	w1, #10000                      ; =0x2710
	bl	__Z8transferbi
Ltmp35:
; %bb.5:
Ltmp36:
	mov	w0, #0                          ; =0x0
	mov	w1, #10000                      ; =0x2710
	bl	__Z8transferbi
Ltmp37:
; %bb.6:
	mov	w19, #0                         ; =0x0
	str	wzr, [sp, #8]
LBB5_7:                                 ; =>This Inner Loop Header: Depth=1
	add	x0, sp, #8
	bl	_ticket
	cmp	w19, w0
	b.ne	LBB5_16
; %bb.8:                                ;   in Loop: Header=BB5_7 Depth=1
	add	w19, w19, #1
	cmp	w19, #1000
	b.ne	LBB5_7
; %bb.9:
Ltmp45:
Lloh10:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh11:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh12:
	adrp	x1, l_.str.2@PAGE
Lloh13:
	add	x1, x1, l_.str.2@PAGEOFF
	mov	w2, #75                         ; =0x4b
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp46:
; %bb.10:
Ltmp47:
Lloh14:
	adrp	x1, l_.str.3@PAGE
Lloh15:
	add	x1, x1, l_.str.3@PAGEOFF
	mov	w2, #69                         ; =0x45
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp48:
; %bb.11:
Ltmp49:
	mov	w1, #1                          ; =0x1
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEb
Ltmp50:
; %bb.12:
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #14]
Ltmp51:
	add	x1, sp, #14
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp52:
; %bb.13:
Ltmp53:
Lloh16:
	adrp	x1, l_.str.4@PAGE
Lloh17:
	add	x1, x1, l_.str.4@PAGEOFF
	mov	w2, #78                         ; =0x4e
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp54:
; %bb.14:
	mov	w0, #0                          ; =0x0
LBB5_15:
	ldp	x29, x30, [sp, #48]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #32]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #64
	ret
LBB5_16:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x21, x0
Ltmp39:
Lloh18:
	adrp	x1, l_.str.1@PAGE
Lloh19:
	add	x1, x1, l_.str.1@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp40:
; %bb.17:
Ltmp42:
Lloh20:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh21:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh22:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh23:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x21
	bl	___cxa_throw
Ltmp43:
; %bb.18:
	brk	#0x1
LBB5_19:
Ltmp55:
	b	LBB5_22
LBB5_20:
Ltmp38:
	b	LBB5_22
LBB5_21:
Ltmp44:
LBB5_22:
	mov	x20, x1
	mov	x19, x0
	b	LBB5_24
LBB5_23:
Ltmp41:
	mov	x20, x1
	mov	x19, x0
	mov	x0, x21
	bl	___cxa_free_exception
LBB5_24:
	cmp	w20, #1
	b.ne	LBB5_29
; %bb.25:
	mov	x0, x19
	bl	___cxa_begin_catch
	ldr	x8, [x0]
	ldr	x8, [x8, #16]
	blr	x8
	mov	x19, x0
	bl	_strlen
	mov	x2, x0
Ltmp56:
Lloh24:
	adrp	x0, __ZNSt3__14cerrE@GOTPAGE
Lloh25:
	ldr	x0, [x0, __ZNSt3__14cerrE@GOTPAGEOFF]
	mov	x1, x19
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp57:
; %bb.26:
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #15]
Ltmp58:
	add	x1, sp, #15
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp59:
; %bb.27:
	bl	___cxa_end_catch
	mov	w0, #1                          ; =0x1
	b	LBB5_15
LBB5_28:
Ltmp60:
	mov	x19, x0
Ltmp61:
	bl	___cxa_end_catch
Ltmp62:
LBB5_29:
	mov	x0, x19
	bl	__Unwind_Resume
LBB5_30:
Ltmp63:
	bl	___clang_call_terminate
	.loh AdrpAdd	Lloh12, Lloh13
	.loh AdrpLdrGot	Lloh10, Lloh11
	.loh AdrpAdd	Lloh14, Lloh15
	.loh AdrpAdd	Lloh16, Lloh17
	.loh AdrpAdd	Lloh18, Lloh19
	.loh AdrpLdrGot	Lloh22, Lloh23
	.loh AdrpLdrGot	Lloh20, Lloh21
	.loh AdrpLdrGot	Lloh24, Lloh25
Lfunc_end2:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table5:
Lexception2:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase2-Lttbaseref2
Lttbaseref2:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end2-Lcst_begin2
Lcst_begin2:
	.uleb128 Ltmp26-Lfunc_begin2            ; >> Call Site 1 <<
	.uleb128 Ltmp37-Ltmp26                  ;   Call between Ltmp26 and Ltmp37
	.uleb128 Ltmp38-Lfunc_begin2            ;     jumps to Ltmp38
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp45-Lfunc_begin2            ; >> Call Site 2 <<
	.uleb128 Ltmp54-Ltmp45                  ;   Call between Ltmp45 and Ltmp54
	.uleb128 Ltmp55-Lfunc_begin2            ;     jumps to Ltmp55
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp54-Lfunc_begin2            ; >> Call Site 3 <<
	.uleb128 Ltmp39-Ltmp54                  ;   Call between Ltmp54 and Ltmp39
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp39-Lfunc_begin2            ; >> Call Site 4 <<
	.uleb128 Ltmp40-Ltmp39                  ;   Call between Ltmp39 and Ltmp40
	.uleb128 Ltmp41-Lfunc_begin2            ;     jumps to Ltmp41
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp42-Lfunc_begin2            ; >> Call Site 5 <<
	.uleb128 Ltmp43-Ltmp42                  ;   Call between Ltmp42 and Ltmp43
	.uleb128 Ltmp44-Lfunc_begin2            ;     jumps to Ltmp44
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp43-Lfunc_begin2            ; >> Call Site 6 <<
	.uleb128 Ltmp56-Ltmp43                  ;   Call between Ltmp43 and Ltmp56
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp56-Lfunc_begin2            ; >> Call Site 7 <<
	.uleb128 Ltmp59-Ltmp56                  ;   Call between Ltmp56 and Ltmp59
	.uleb128 Ltmp60-Lfunc_begin2            ;     jumps to Ltmp60
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp59-Lfunc_begin2            ; >> Call Site 8 <<
	.uleb128 Ltmp61-Ltmp59                  ;   Call between Ltmp59 and Ltmp61
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp61-Lfunc_begin2            ; >> Call Site 9 <<
	.uleb128 Ltmp62-Ltmp61                  ;   Call between Ltmp61 and Ltmp62
	.uleb128 Ltmp63-Lfunc_begin2            ;     jumps to Ltmp63
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp62-Lfunc_begin2            ; >> Call Site 10 <<
	.uleb128 Lfunc_end2-Ltmp62              ;   Call between Ltmp62 and Lfunc_end2
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
	.byte	0                               ;   No further actions
	.p2align	2, 0x0
                                        ; >> Catch TypeInfos <<
	.long	0                               ; TypeInfo 2
Ltmp100:                                ; TypeInfo 1
	.long	__ZTISt9exception@GOT-Ltmp100
Lttbase2:
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
	.p2align	2                               ; -- Begin function _ZNSt3__114__thread_proxyB9nqe210106INS_5tupleIJNS_10unique_ptrINS_15__thread_structENS_14default_deleteIS3_EEEEZ8transferbiE3$_2EEEEEPvS9_
__ZNSt3__114__thread_proxyB9nqe210106INS_5tupleIJNS_10unique_ptrINS_15__thread_structENS_14default_deleteIS3_EEEEZ8transferbiE3$_2EEEEEPvS9_: ; @"_ZNSt3__114__thread_proxyB9nqe210106INS_5tupleIJNS_10unique_ptrINS_15__thread_structENS_14default_deleteIS3_EEEEZ8transferbiE3$_2EEEEEPvS9_"
Lfunc_begin3:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception3
; %bb.0:
	sub	sp, sp, #64
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
	mov	x19, x0
	str	x0, [sp, #8]
Ltmp64:
	bl	__ZNSt3__119__thread_local_dataEv
Ltmp65:
; %bb.1:
	ldr	x1, [x19]
	str	xzr, [x19]
	ldr	x0, [x0]
Ltmp66:
	bl	_pthread_setspecific
Ltmp67:
; %bb.2:
	ldr	x8, [x19, #8]
	ldr	w8, [x8]
	cmp	w8, #1
	b.lt	LBB7_15
; %bb.3:
	mov	w20, #1                         ; =0x1
	mov	w21, #42330                     ; =0xa55a
	movk	w21, #42330, lsl #16
	mov	w22, #1                         ; =0x1
LBB7_4:                                 ; =>This Inner Loop Header: Depth=1
	ldr	x8, [x19, #16]
	ldp	x9, x0, [x8]
	ldrb	w8, [x9]
	cmp	w8, #1
	b.ne	LBB7_6
; %bb.5:                                ;   in Loop: Header=BB7_4 Depth=1
	ldar	w0, [x0]
	b	LBB7_7
LBB7_6:                                 ;   in Loop: Header=BB7_4 Depth=1
	bl	_observe
LBB7_7:                                 ;   in Loop: Header=BB7_4 Depth=1
	ldr	x8, [x19, #24]
	ldarb	w8, [x8]
	cbz	w0, LBB7_10
; %bb.8:                                ;   in Loop: Header=BB7_4 Depth=1
	tbnz	w8, #0, LBB7_15
; %bb.9:                                ;   in Loop: Header=BB7_4 Depth=1
Ltmp69:
	bl	_sched_yield
Ltmp70:
	b	LBB7_4
LBB7_10:                                ;   in Loop: Header=BB7_4 Depth=1
	tbnz	w8, #0, LBB7_15
; %bb.11:                               ;   in Loop: Header=BB7_4 Depth=1
	ldp	x8, x9, [x19, #32]
	str	x22, [x8]
	eor	x8, x22, x21
	str	x8, [x9]
	ldr	x8, [x19, #48]
	ldp	x9, x0, [x8]
	ldrb	w8, [x9]
	cmp	w8, #1
	b.ne	LBB7_13
; %bb.12:                               ;   in Loop: Header=BB7_4 Depth=1
	stlr	w20, [x0]
	b	LBB7_14
LBB7_13:                                ;   in Loop: Header=BB7_4 Depth=1
	mov	w1, #1                          ; =0x1
	bl	_publish
LBB7_14:                                ;   in Loop: Header=BB7_4 Depth=1
	ldr	x8, [x19, #8]
	ldrsw	x8, [x8]
	cmp	x22, x8
	add	x22, x22, #1
	b.lt	LBB7_4
LBB7_15:
	ldr	x19, [sp, #8]
	cbz	x19, LBB7_19
; %bb.16:
	ldr	x0, [x19]
	str	xzr, [x19]
	cbz	x0, LBB7_18
; %bb.17:
	bl	__ZNSt3__115__thread_structD1Ev
	bl	__ZdlPv
LBB7_18:
	mov	x0, x19
	bl	__ZdlPv
LBB7_19:
	mov	x0, #0                          ; =0x0
	ldp	x29, x30, [sp, #48]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #32]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #64
	ret
LBB7_20:
Ltmp68:
	mov	x19, x0
	add	x0, sp, #8
	bl	__ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ8transferbiE3$_2EEENS3_IS7_EEED1B9nqe210106Ev
	mov	x0, x19
	bl	__Unwind_Resume
LBB7_21:
Ltmp71:
	bl	___clang_call_terminate
Lfunc_end3:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table7:
Lexception3:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase3-Lttbaseref3
Lttbaseref3:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end3-Lcst_begin3
Lcst_begin3:
	.uleb128 Ltmp64-Lfunc_begin3            ; >> Call Site 1 <<
	.uleb128 Ltmp67-Ltmp64                  ;   Call between Ltmp64 and Ltmp67
	.uleb128 Ltmp68-Lfunc_begin3            ;     jumps to Ltmp68
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp69-Lfunc_begin3            ; >> Call Site 2 <<
	.uleb128 Ltmp70-Ltmp69                  ;   Call between Ltmp69 and Ltmp70
	.uleb128 Ltmp71-Lfunc_begin3            ;     jumps to Ltmp71
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp70-Lfunc_begin3            ; >> Call Site 3 <<
	.uleb128 Lfunc_end3-Ltmp70              ;   Call between Ltmp70 and Lfunc_end3
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end3:
	.byte	1                               ; >> Action Record 1 <<
                                        ;   Catch TypeInfo 1
	.byte	0                               ;   No further actions
	.p2align	2, 0x0
                                        ; >> Catch TypeInfos <<
	.long	0                               ; TypeInfo 1
Lttbase3:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2                               ; -- Begin function _ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ8transferbiE3$_2EEENS3_IS7_EEED1B9nqe210106Ev
__ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ8transferbiE3$_2EEENS3_IS7_EEED1B9nqe210106Ev: ; @"_ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ8transferbiE3$_2EEENS3_IS7_EEED1B9nqe210106Ev"
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
	ldr	x19, [x0]
	str	xzr, [x0]
	cbz	x19, LBB8_4
; %bb.1:
	mov	x20, x0
	ldr	x0, [x19]
	str	xzr, [x19]
	cbz	x0, LBB8_3
; %bb.2:
	bl	__ZNSt3__115__thread_structD1Ev
	bl	__ZdlPv
LBB8_3:
	mov	x0, x19
	bl	__ZdlPv
	mov	x0, x20
LBB8_4:
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
	ret
	.cfi_endproc
                                        ; -- End function
	.private_extern	__ZNSt3__110unique_ptrINS_15__thread_structENS_14default_deleteIS1_EEED1B9nqe210106Ev ; -- Begin function _ZNSt3__110unique_ptrINS_15__thread_structENS_14default_deleteIS1_EEED1B9nqe210106Ev
	.globl	__ZNSt3__110unique_ptrINS_15__thread_structENS_14default_deleteIS1_EEED1B9nqe210106Ev
	.weak_def_can_be_hidden	__ZNSt3__110unique_ptrINS_15__thread_structENS_14default_deleteIS1_EEED1B9nqe210106Ev
	.p2align	2
__ZNSt3__110unique_ptrINS_15__thread_structENS_14default_deleteIS1_EEED1B9nqe210106Ev: ; @_ZNSt3__110unique_ptrINS_15__thread_structENS_14default_deleteIS1_EEED1B9nqe210106Ev
	.cfi_startproc
; %bb.0:
	mov	x8, x0
	ldr	x0, [x0]
	str	xzr, [x8]
	cbz	x0, LBB9_2
; %bb.1:
	stp	x20, x19, [sp, #-32]!           ; 16-byte Folded Spill
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	mov	x19, x8
	bl	__ZNSt3__115__thread_structD1Ev
	bl	__ZdlPv
	mov	x8, x19
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
LBB9_2:
	mov	x0, x8
	ret
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
Ltmp72:
	add	x0, sp, #8
	mov	x1, x19
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryC1ERS3_
Ltmp73:
; %bb.1:
	ldrb	w8, [sp, #8]
	cmp	w8, #1
	b.ne	LBB10_10
; %bb.2:
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
	add	x4, x19, x8
	ldr	x22, [x4, #40]
	ldr	w24, [x4, #8]
	ldr	w23, [x4, #144]
	cmn	w23, #1
	b.ne	LBB10_7
; %bb.3:
Ltmp75:
	add	x8, sp, #24
	mov	x25, x4
	mov	x0, x4
	bl	__ZNKSt3__18ios_base6getlocEv
Ltmp76:
; %bb.4:
Ltmp77:
Lloh26:
	adrp	x1, __ZNSt3__15ctypeIcE2idE@GOTPAGE
Lloh27:
	ldr	x1, [x1, __ZNSt3__15ctypeIcE2idE@GOTPAGEOFF]
	add	x0, sp, #24
	bl	__ZNKSt3__16locale9use_facetERNS0_2idE
Ltmp78:
; %bb.5:
	ldr	x8, [x0]
	ldr	x8, [x8, #56]
Ltmp79:
	mov	w1, #32                         ; =0x20
	blr	x8
Ltmp80:
; %bb.6:
	mov	x23, x0
	add	x0, sp, #24
	bl	__ZNSt3__16localeD1Ev
	mov	x4, x25
	str	w23, [x25, #144]
LBB10_7:
	mov	w8, #176                        ; =0xb0
	and	w8, w24, w8
	add	x3, x20, x21
	cmp	w8, #32
	csel	x2, x3, x20, eq
Ltmp82:
	sxtb	w5, w23
	mov	x0, x22
	mov	x1, x20
	bl	__ZNSt3__116__pad_and_outputB9nqe210106IcNS_11char_traitsIcEEEENS_19ostreambuf_iteratorIT_T0_EES6_PKS4_S8_S8_RNS_8ios_baseES4_
Ltmp83:
; %bb.8:
	cbnz	x0, LBB10_10
; %bb.9:
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
	add	x0, x19, x8
	ldr	w8, [x0, #32]
	mov	w9, #5                          ; =0x5
Ltmp85:
	orr	w1, w8, w9
	bl	__ZNSt3__18ios_base5clearEj
Ltmp86:
LBB10_10:
	add	x0, sp, #8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryD1Ev
LBB10_11:
	mov	x0, x19
	ldp	x29, x30, [sp, #96]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #80]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #64]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #48]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #112
	ret
LBB10_12:
Ltmp87:
	b	LBB10_15
LBB10_13:
Ltmp81:
	mov	x20, x0
	add	x0, sp, #24
	bl	__ZNSt3__16localeD1Ev
	b	LBB10_16
LBB10_14:
Ltmp84:
LBB10_15:
	mov	x20, x0
LBB10_16:
	add	x0, sp, #8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryD1Ev
	b	LBB10_18
LBB10_17:
Ltmp74:
	mov	x20, x0
LBB10_18:
	mov	x0, x20
	bl	___cxa_begin_catch
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
Ltmp88:
	add	x0, x19, x8
	bl	__ZNSt3__18ios_base33__set_badbit_and_consider_rethrowEv
Ltmp89:
; %bb.19:
	bl	___cxa_end_catch
	b	LBB10_11
LBB10_20:
Ltmp90:
	mov	x19, x0
Ltmp91:
	bl	___cxa_end_catch
Ltmp92:
; %bb.21:
	mov	x0, x19
	bl	__Unwind_Resume
LBB10_22:
Ltmp93:
	bl	___clang_call_terminate
	.loh AdrpLdrGot	Lloh26, Lloh27
Lfunc_end4:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table10:
Lexception4:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase4-Lttbaseref4
Lttbaseref4:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end4-Lcst_begin4
Lcst_begin4:
	.uleb128 Ltmp72-Lfunc_begin4            ; >> Call Site 1 <<
	.uleb128 Ltmp73-Ltmp72                  ;   Call between Ltmp72 and Ltmp73
	.uleb128 Ltmp74-Lfunc_begin4            ;     jumps to Ltmp74
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp75-Lfunc_begin4            ; >> Call Site 2 <<
	.uleb128 Ltmp76-Ltmp75                  ;   Call between Ltmp75 and Ltmp76
	.uleb128 Ltmp84-Lfunc_begin4            ;     jumps to Ltmp84
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp77-Lfunc_begin4            ; >> Call Site 3 <<
	.uleb128 Ltmp80-Ltmp77                  ;   Call between Ltmp77 and Ltmp80
	.uleb128 Ltmp81-Lfunc_begin4            ;     jumps to Ltmp81
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp82-Lfunc_begin4            ; >> Call Site 4 <<
	.uleb128 Ltmp83-Ltmp82                  ;   Call between Ltmp82 and Ltmp83
	.uleb128 Ltmp84-Lfunc_begin4            ;     jumps to Ltmp84
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp85-Lfunc_begin4            ; >> Call Site 5 <<
	.uleb128 Ltmp86-Ltmp85                  ;   Call between Ltmp85 and Ltmp86
	.uleb128 Ltmp87-Lfunc_begin4            ;     jumps to Ltmp87
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp86-Lfunc_begin4            ; >> Call Site 6 <<
	.uleb128 Ltmp88-Ltmp86                  ;   Call between Ltmp86 and Ltmp88
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp88-Lfunc_begin4            ; >> Call Site 7 <<
	.uleb128 Ltmp89-Ltmp88                  ;   Call between Ltmp88 and Ltmp89
	.uleb128 Ltmp90-Lfunc_begin4            ;     jumps to Ltmp90
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp89-Lfunc_begin4            ; >> Call Site 8 <<
	.uleb128 Ltmp91-Ltmp89                  ;   Call between Ltmp89 and Ltmp91
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp91-Lfunc_begin4            ; >> Call Site 9 <<
	.uleb128 Ltmp92-Ltmp91                  ;   Call between Ltmp91 and Ltmp92
	.uleb128 Ltmp93-Lfunc_begin4            ;     jumps to Ltmp93
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp92-Lfunc_begin4            ; >> Call Site 10 <<
	.uleb128 Lfunc_end4-Ltmp92              ;   Call between Ltmp92 and Lfunc_end4
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end4:
	.byte	1                               ; >> Action Record 1 <<
                                        ;   Catch TypeInfo 1
	.byte	0                               ;   No further actions
	.p2align	2, 0x0
                                        ; >> Catch TypeInfos <<
	.long	0                               ; TypeInfo 1
Lttbase4:
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
	cbz	x0, LBB11_16
; %bb.1:
	mov	x23, x5
	mov	x20, x4
	mov	x22, x3
	mov	x21, x2
	mov	x24, x1
	ldr	x26, [x4, #24]
	sub	x25, x2, x1
	cmp	x25, #1
	b.lt	LBB11_3
; %bb.2:
	ldr	x8, [x19]
	ldr	x8, [x8, #96]
	mov	x0, x19
	mov	x1, x24
	mov	x2, x25
	blr	x8
	cmp	x0, x25
	b.ne	LBB11_15
LBB11_3:
	sub	x8, x22, x24
	cmp	x26, x8
	b.le	LBB11_12
; %bb.4:
	mov	x9, #-9                         ; =0xfffffffffffffff7
	movk	x9, #32767, lsl #48
	sub	x24, x26, x8
	cmp	x24, x9
	b.hs	LBB11_17
; %bb.5:
	cmp	x24, #23
	b.hs	LBB11_7
; %bb.6:
	strb	w24, [sp, #31]
	add	x25, sp, #8
	b	LBB11_8
LBB11_7:
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
LBB11_8:
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
Ltmp94:
	mov	x0, x19
	mov	x2, x24
	blr	x8
Ltmp95:
; %bb.9:
	ldrsb	w8, [sp, #31]
	tbnz	w8, #31, LBB11_11
; %bb.10:
	cmp	x0, x24
	b.ne	LBB11_15
	b	LBB11_12
LBB11_11:
	ldr	x8, [sp, #8]
	mov	x23, x0
	mov	x0, x8
	bl	__ZdlPv
	mov	x0, x23
	cmp	x0, x24
	b.ne	LBB11_15
LBB11_12:
	sub	x22, x22, x21
	cmp	x22, #1
	b.lt	LBB11_14
; %bb.13:
	ldr	x8, [x19]
	ldr	x8, [x8, #96]
	mov	x0, x19
	mov	x1, x21
	mov	x2, x22
	blr	x8
	cmp	x0, x22
	b.ne	LBB11_15
LBB11_14:
	str	xzr, [x20, #24]
	b	LBB11_16
LBB11_15:
	mov	x19, #0                         ; =0x0
LBB11_16:
	mov	x0, x19
	ldp	x29, x30, [sp, #96]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #80]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #64]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #48]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #112
	ret
LBB11_17:
	bl	__ZNSt3__112basic_stringIcNS_11char_traitsIcEENS_9allocatorIcEEE20__throw_length_errorB9nqe210106Ev
LBB11_18:
Ltmp96:
	mov	x19, x0
	ldrsb	w8, [sp, #31]
	tbz	w8, #31, LBB11_20
; %bb.19:
	ldr	x0, [sp, #8]
	bl	__ZdlPv
LBB11_20:
	mov	x0, x19
	bl	__Unwind_Resume
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
	.uleb128 Ltmp94-Lfunc_begin5            ;   Call between Lfunc_begin5 and Ltmp94
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp94-Lfunc_begin5            ; >> Call Site 2 <<
	.uleb128 Ltmp95-Ltmp94                  ;   Call between Ltmp94 and Ltmp95
	.uleb128 Ltmp96-Lfunc_begin5            ;     jumps to Ltmp96
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp95-Lfunc_begin5            ; >> Call Site 3 <<
	.uleb128 Lfunc_end5-Ltmp95              ;   Call between Ltmp95 and Lfunc_end5
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
Lloh28:
	adrp	x0, l_.str.6@PAGE
Lloh29:
	add	x0, x0, l_.str.6@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh28, Lloh29
	.cfi_endproc
                                        ; -- End function
	.private_extern	__ZNSt3__120__throw_length_errorB9nqe210106EPKc ; -- Begin function _ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.globl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.weak_def_can_be_hidden	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.p2align	2
__ZNSt3__120__throw_length_errorB9nqe210106EPKc: ; @_ZNSt3__120__throw_length_errorB9nqe210106EPKc
Lfunc_begin6:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception6
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
Ltmp97:
	mov	x1, x20
	bl	__ZNSt12length_errorC1B9nqe210106EPKc
Ltmp98:
; %bb.1:
Lloh30:
	adrp	x1, __ZTISt12length_error@GOTPAGE
Lloh31:
	ldr	x1, [x1, __ZTISt12length_error@GOTPAGEOFF]
Lloh32:
	adrp	x2, __ZNSt12length_errorD1Ev@GOTPAGE
Lloh33:
	ldr	x2, [x2, __ZNSt12length_errorD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
LBB13_2:
Ltmp99:
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x0, x20
	bl	__Unwind_Resume
	.loh AdrpLdrGot	Lloh32, Lloh33
	.loh AdrpLdrGot	Lloh30, Lloh31
Lfunc_end6:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table13:
Lexception6:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end6-Lcst_begin6
Lcst_begin6:
	.uleb128 Lfunc_begin6-Lfunc_begin6      ; >> Call Site 1 <<
	.uleb128 Ltmp97-Lfunc_begin6            ;   Call between Lfunc_begin6 and Ltmp97
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp97-Lfunc_begin6            ; >> Call Site 2 <<
	.uleb128 Ltmp98-Ltmp97                  ;   Call between Ltmp97 and Ltmp98
	.uleb128 Ltmp99-Lfunc_begin6            ;     jumps to Ltmp99
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp98-Lfunc_begin6            ; >> Call Site 3 <<
	.uleb128 Lfunc_end6-Ltmp98              ;   Call between Ltmp98 and Lfunc_end6
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end6:
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
Lloh34:
	adrp	x8, __ZTVSt12length_error@GOTPAGE
Lloh35:
	ldr	x8, [x8, __ZTVSt12length_error@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x0]
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
	.loh AdrpLdrGot	Lloh34, Lloh35
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"publication or reuse failure"

l_.str.1:                               ; @.str.1
	.asciz	"RMW old value"

l_.str.2:                               ; @.str.2
	.asciz	"PASS seq_cst/acquire_release transfers=20002 zero=2 ticket_old_values=1000\n"

l_.str.3:                               ; @.str.3
	.asciz	"relaxed_payload_configuration=rejected; no racy execution; lock_free="

l_.str.4:                               ; @.str.4
	.asciz	"No timing; TSan is evidence for this execution, not an ARM memory-model proof\n"

l_.str.5:                               ; @.str.5
	.asciz	"thread constructor failed"

l_.str.6:                               ; @.str.6
	.asciz	"basic_string"

.subsections_via_symbols
