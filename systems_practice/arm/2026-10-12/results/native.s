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
	stur	w1, [x29, #-32]
	tbnz	w1, #31, LBB3_23
; %bb.1:
	stur	wzr, [x29, #-36]
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
; %bb.2:
	str	x19, [sp]
Ltmp3:
	mov	w0, #56                         ; =0x38
	bl	__Znwm
Ltmp4:
; %bb.3:
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
; %bb.4:
	cbnz	w0, LBB3_25
; %bb.5:
	add	x0, sp, #16
	sub	x8, x29, #37
	stp	x0, x8, [sp]
	ldur	w9, [x29, #-32]
	cmp	w9, #1
	b.lt	LBB3_18
; %bb.6:
	mov	w19, #1                         ; =0x1
	mov	w20, #42330                     ; =0xa55a
	movk	w20, #42330, lsl #16
	b	LBB3_9
LBB3_7:                                 ;   in Loop: Header=BB3_9 Depth=1
	bl	_observe
	cmp	w0, #1
	b.eq	LBB3_11
LBB3_8:                                 ;   in Loop: Header=BB3_9 Depth=1
Ltmp11:
	bl	_sched_yield
Ltmp12:
LBB3_9:                                 ; =>This Inner Loop Header: Depth=1
	ldp	x8, x0, [sp, #40]
	ldrb	w8, [x8]
	cmp	w8, #1
	b.ne	LBB3_7
; %bb.10:                               ;   in Loop: Header=BB3_9 Depth=1
	ldar	w0, [x0]
	cmp	w0, #1
	b.ne	LBB3_8
LBB3_11:                                ;   in Loop: Header=BB3_9 Depth=1
	ldur	x8, [x29, #-48]
	cmp	x8, x19
	b.ne	LBB3_21
; %bb.12:                               ;   in Loop: Header=BB3_9 Depth=1
	ldr	x8, [sp, #56]
	eor	x8, x8, x19
	cmp	x8, x20
	b.ne	LBB3_21
; %bb.13:                               ;   in Loop: Header=BB3_9 Depth=1
	ldp	x8, x0, [sp, #24]
	ldrb	w8, [x8]
	cmp	w8, #1
	b.ne	LBB3_15
; %bb.14:                               ;   in Loop: Header=BB3_9 Depth=1
	stlr	wzr, [x0]
	b	LBB3_16
LBB3_15:                                ;   in Loop: Header=BB3_9 Depth=1
	mov	w1, #0                          ; =0x0
	bl	_publish
LBB3_16:                                ;   in Loop: Header=BB3_9 Depth=1
	ldursw	x8, [x29, #-32]
	cmp	x19, x8
	add	x19, x19, #1
	b.lt	LBB3_9
; %bb.17:
	ldp	x0, x8, [sp]
LBB3_18:
	mov	w9, #1                          ; =0x1
	stlrb	w9, [x8]
	ldr	x8, [x0]
	cbz	x8, LBB3_20
; %bb.19:
Ltmp20:
	bl	__ZNSt3__16thread4joinEv
Ltmp21:
LBB3_20:
	add	x0, sp, #16
	bl	__ZNSt3__16threadD1Ev
	ldp	x29, x30, [sp, #112]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #96]             ; 16-byte Folded Reload
	add	sp, sp, #128
	ret
LBB3_21:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x20, x0
Ltmp14:
Lloh2:
	adrp	x1, l_.str.1@PAGE
Lloh3:
	add	x1, x1, l_.str.1@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp15:
; %bb.22:
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
	b	LBB3_26
LBB3_23:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x20, x0
Ltmp23:
Lloh8:
	adrp	x1, l_.str@PAGE
Lloh9:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt16invalid_argumentC1B9nqe210106EPKc
Ltmp24:
; %bb.24:
	mov	x0, x20
	bl	__Z8transferbi.cold.1
LBB3_25:
Ltmp8:
Lloh10:
	adrp	x1, l_.str.7@PAGE
Lloh11:
	add	x1, x1, l_.str.7@PAGEOFF
	bl	__ZNSt3__120__throw_system_errorEiPKc
Ltmp9:
LBB3_26:
	brk	#0x1
LBB3_27:
Ltmp25:
	mov	x19, x0
	mov	x0, x20
	bl	___cxa_free_exception
	mov	x0, x19
	bl	__Unwind_Resume
LBB3_28:
Ltmp22:
	bl	___clang_call_terminate
LBB3_29:
Ltmp5:
	mov	x19, x0
	b	LBB3_32
LBB3_30:
Ltmp2:
	mov	x8, x19
	mov	x19, x0
	mov	x0, x8
	bl	__ZdlPv
	mov	x0, x19
	bl	__Unwind_Resume
LBB3_31:
Ltmp10:
	mov	x19, x0
	sub	x0, x29, #24
	bl	__ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ8transferbiE3$_2EEENS3_IS7_EEED1B9nqe210106Ev
LBB3_32:
	mov	x0, sp
	bl	__ZNSt3__110unique_ptrINS_15__thread_structENS_14default_deleteIS1_EEED1B9nqe210106Ev
	mov	x0, x19
	bl	__Unwind_Resume
LBB3_33:
Ltmp19:
	mov	x19, x0
	b	LBB3_35
LBB3_34:
Ltmp16:
	mov	x19, x0
	mov	x0, x20
	bl	___cxa_free_exception
LBB3_35:
	mov	x0, sp
	bl	__ZN4JoinD1Ev
	add	x0, sp, #16
	bl	__ZNSt3__16threadD1Ev
	mov	x0, x19
	bl	__Unwind_Resume
LBB3_36:
Ltmp13:
	bl	___clang_call_terminate
	.loh AdrpAdd	Lloh0, Lloh1
	.loh AdrpAdd	Lloh2, Lloh3
	.loh AdrpLdrGot	Lloh6, Lloh7
	.loh AdrpLdrGot	Lloh4, Lloh5
	.loh AdrpAdd	Lloh8, Lloh9
	.loh AdrpAdd	Lloh10, Lloh11
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
	.uleb128 Ltmp18-Lfunc_begin0            ; >> Call Site 10 <<
	.uleb128 Ltmp23-Ltmp18                  ;   Call between Ltmp18 and Ltmp23
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp23-Lfunc_begin0            ; >> Call Site 11 <<
	.uleb128 Ltmp24-Ltmp23                  ;   Call between Ltmp23 and Ltmp24
	.uleb128 Ltmp25-Lfunc_begin0            ;     jumps to Ltmp25
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp24-Lfunc_begin0            ; >> Call Site 12 <<
	.uleb128 Ltmp8-Ltmp24                   ;   Call between Ltmp24 and Ltmp8
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp8-Lfunc_begin0             ; >> Call Site 13 <<
	.uleb128 Ltmp9-Ltmp8                    ;   Call between Ltmp8 and Ltmp9
	.uleb128 Ltmp10-Lfunc_begin0            ;     jumps to Ltmp10
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp9-Lfunc_begin0             ; >> Call Site 14 <<
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
Lloh12:
	adrp	x8, __ZTVSt16invalid_argument@GOTPAGE
Lloh13:
	ldr	x8, [x8, __ZTVSt16invalid_argument@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x0]
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
	.loh AdrpLdrGot	Lloh12, Lloh13
	.cfi_endproc
                                        ; -- End function
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
	cbz	x8, LBB5_2
; %bb.1:
Ltmp26:
	bl	__ZNSt3__16thread4joinEv
Ltmp27:
LBB5_2:
	mov	x0, x19
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
	ret
LBB5_3:
Ltmp28:
	bl	___clang_call_terminate
Lfunc_end1:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table5:
Lexception1:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase1-Lttbaseref1
Lttbaseref1:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end1-Lcst_begin1
Lcst_begin1:
	.uleb128 Ltmp26-Lfunc_begin1            ; >> Call Site 1 <<
	.uleb128 Ltmp27-Ltmp26                  ;   Call between Ltmp26 and Ltmp27
	.uleb128 Ltmp28-Lfunc_begin1            ;     jumps to Ltmp28
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
Ltmp29:
	mov	w0, #1                          ; =0x1
	mov	w1, #0                          ; =0x0
	bl	__Z8transferbi
Ltmp30:
; %bb.1:
Ltmp31:
	mov	w0, #0                          ; =0x0
	mov	w1, #0                          ; =0x0
	bl	__Z8transferbi
Ltmp32:
; %bb.2:
Ltmp33:
	mov	w0, #1                          ; =0x1
	mov	w1, #1                          ; =0x1
	bl	__Z8transferbi
Ltmp34:
; %bb.3:
Ltmp35:
	mov	w0, #0                          ; =0x0
	mov	w1, #1                          ; =0x1
	bl	__Z8transferbi
Ltmp36:
; %bb.4:
Ltmp37:
	mov	w0, #1                          ; =0x1
	mov	w1, #10000                      ; =0x2710
	bl	__Z8transferbi
Ltmp38:
; %bb.5:
Ltmp39:
	mov	w0, #0                          ; =0x0
	mov	w1, #10000                      ; =0x2710
	bl	__Z8transferbi
Ltmp40:
; %bb.6:
	mov	w19, #0                         ; =0x0
	str	wzr, [sp, #8]
LBB6_7:                                 ; =>This Inner Loop Header: Depth=1
	add	x0, sp, #8
	bl	_ticket
	cmp	w19, w0
	b.ne	LBB6_11
; %bb.8:                                ;   in Loop: Header=BB6_7 Depth=1
	add	w19, w19, #1
	cmp	w19, #1000
	b.ne	LBB6_7
; %bb.9:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp48:
Lloh14:
	adrp	x1, l_.str@PAGE
Lloh15:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt11logic_errorC2EPKc
Ltmp49:
; %bb.10:
Lloh16:
	adrp	x8, __ZTVSt16invalid_argument@GOTPAGE
Lloh17:
	ldr	x8, [x8, __ZTVSt16invalid_argument@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x19]
Ltmp51:
Lloh18:
	adrp	x1, __ZTISt16invalid_argument@GOTPAGE
Lloh19:
	ldr	x1, [x1, __ZTISt16invalid_argument@GOTPAGEOFF]
Lloh20:
	adrp	x2, __ZNSt16invalid_argumentD1Ev@GOTPAGE
Lloh21:
	ldr	x2, [x2, __ZNSt16invalid_argumentD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
Ltmp52:
	b	LBB6_13
LBB6_11:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp42:
Lloh22:
	adrp	x1, l_.str.2@PAGE
Lloh23:
	add	x1, x1, l_.str.2@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp43:
; %bb.12:
Ltmp45:
Lloh24:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh25:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh26:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh27:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
Ltmp46:
LBB6_13:
	brk	#0x1
LBB6_14:
Ltmp53:
	b	LBB6_16
LBB6_15:
Ltmp50:
	mov	x20, x1
	mov	x21, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x1, x20
	mov	x0, x21
LBB6_16:
	cmp	w1, #2
	b.ne	LBB6_29
; %bb.17:
	bl	___cxa_begin_catch
Ltmp54:
	bl	___cxa_end_catch
Ltmp55:
; %bb.18:
Ltmp57:
Lloh28:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh29:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh30:
	adrp	x1, l_.str.4@PAGE
Lloh31:
	add	x1, x1, l_.str.4@PAGEOFF
	mov	w2, #75                         ; =0x4b
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp58:
; %bb.19:
Ltmp59:
Lloh32:
	adrp	x1, l_.str.5@PAGE
Lloh33:
	add	x1, x1, l_.str.5@PAGEOFF
	mov	w2, #56                         ; =0x38
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp60:
; %bb.20:
Ltmp61:
	mov	w1, #1                          ; =0x1
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEb
Ltmp62:
; %bb.21:
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #14]
Ltmp63:
	add	x1, sp, #14
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp64:
; %bb.22:
Ltmp65:
Lloh34:
	adrp	x1, l_.str.6@PAGE
Lloh35:
	add	x1, x1, l_.str.6@PAGEOFF
	mov	w2, #78                         ; =0x4e
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp66:
; %bb.23:
	mov	w0, #0                          ; =0x0
	b	LBB6_33
LBB6_24:
Ltmp56:
	b	LBB6_29
LBB6_25:
Ltmp67:
	b	LBB6_29
LBB6_26:
Ltmp47:
	b	LBB6_29
LBB6_27:
Ltmp44:
	mov	x20, x1
	mov	x21, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x1, x20
	mov	x0, x21
	b	LBB6_29
LBB6_28:
Ltmp41:
LBB6_29:
	cmp	w1, #1
	b.ne	LBB6_34
; %bb.30:
	bl	___cxa_begin_catch
	ldr	x8, [x0]
	ldr	x8, [x8, #16]
	blr	x8
	mov	x19, x0
	bl	_strlen
	mov	x2, x0
Ltmp68:
Lloh36:
	adrp	x0, __ZNSt3__14cerrE@GOTPAGE
Lloh37:
	ldr	x0, [x0, __ZNSt3__14cerrE@GOTPAGEOFF]
	mov	x1, x19
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp69:
; %bb.31:
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #15]
Ltmp70:
	add	x1, sp, #15
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp71:
; %bb.32:
	bl	___cxa_end_catch
	mov	w0, #1                          ; =0x1
LBB6_33:
	ldp	x29, x30, [sp, #48]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #32]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #64
	ret
LBB6_34:
	bl	__Unwind_Resume
LBB6_35:
Ltmp72:
	mov	x19, x0
Ltmp73:
	bl	___cxa_end_catch
Ltmp74:
; %bb.36:
	mov	x0, x19
	bl	__Unwind_Resume
LBB6_37:
Ltmp75:
	bl	___clang_call_terminate
	.loh AdrpAdd	Lloh14, Lloh15
	.loh AdrpLdrGot	Lloh20, Lloh21
	.loh AdrpLdrGot	Lloh18, Lloh19
	.loh AdrpLdrGot	Lloh16, Lloh17
	.loh AdrpAdd	Lloh22, Lloh23
	.loh AdrpLdrGot	Lloh26, Lloh27
	.loh AdrpLdrGot	Lloh24, Lloh25
	.loh AdrpAdd	Lloh30, Lloh31
	.loh AdrpLdrGot	Lloh28, Lloh29
	.loh AdrpAdd	Lloh32, Lloh33
	.loh AdrpAdd	Lloh34, Lloh35
	.loh AdrpLdrGot	Lloh36, Lloh37
Lfunc_end2:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table6:
Lexception2:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase2-Lttbaseref2
Lttbaseref2:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end2-Lcst_begin2
Lcst_begin2:
	.uleb128 Ltmp29-Lfunc_begin2            ; >> Call Site 1 <<
	.uleb128 Ltmp40-Ltmp29                  ;   Call between Ltmp29 and Ltmp40
	.uleb128 Ltmp41-Lfunc_begin2            ;     jumps to Ltmp41
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp40-Lfunc_begin2            ; >> Call Site 2 <<
	.uleb128 Ltmp48-Ltmp40                  ;   Call between Ltmp40 and Ltmp48
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp48-Lfunc_begin2            ; >> Call Site 3 <<
	.uleb128 Ltmp49-Ltmp48                  ;   Call between Ltmp48 and Ltmp49
	.uleb128 Ltmp50-Lfunc_begin2            ;     jumps to Ltmp50
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp51-Lfunc_begin2            ; >> Call Site 4 <<
	.uleb128 Ltmp52-Ltmp51                  ;   Call between Ltmp51 and Ltmp52
	.uleb128 Ltmp53-Lfunc_begin2            ;     jumps to Ltmp53
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp52-Lfunc_begin2            ; >> Call Site 5 <<
	.uleb128 Ltmp42-Ltmp52                  ;   Call between Ltmp52 and Ltmp42
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp42-Lfunc_begin2            ; >> Call Site 6 <<
	.uleb128 Ltmp43-Ltmp42                  ;   Call between Ltmp42 and Ltmp43
	.uleb128 Ltmp44-Lfunc_begin2            ;     jumps to Ltmp44
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp45-Lfunc_begin2            ; >> Call Site 7 <<
	.uleb128 Ltmp46-Ltmp45                  ;   Call between Ltmp45 and Ltmp46
	.uleb128 Ltmp47-Lfunc_begin2            ;     jumps to Ltmp47
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp46-Lfunc_begin2            ; >> Call Site 8 <<
	.uleb128 Ltmp54-Ltmp46                  ;   Call between Ltmp46 and Ltmp54
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp54-Lfunc_begin2            ; >> Call Site 9 <<
	.uleb128 Ltmp55-Ltmp54                  ;   Call between Ltmp54 and Ltmp55
	.uleb128 Ltmp56-Lfunc_begin2            ;     jumps to Ltmp56
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp57-Lfunc_begin2            ; >> Call Site 10 <<
	.uleb128 Ltmp66-Ltmp57                  ;   Call between Ltmp57 and Ltmp66
	.uleb128 Ltmp67-Lfunc_begin2            ;     jumps to Ltmp67
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp66-Lfunc_begin2            ; >> Call Site 11 <<
	.uleb128 Ltmp68-Ltmp66                  ;   Call between Ltmp66 and Ltmp68
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp68-Lfunc_begin2            ; >> Call Site 12 <<
	.uleb128 Ltmp71-Ltmp68                  ;   Call between Ltmp68 and Ltmp71
	.uleb128 Ltmp72-Lfunc_begin2            ;     jumps to Ltmp72
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp71-Lfunc_begin2            ; >> Call Site 13 <<
	.uleb128 Ltmp73-Ltmp71                  ;   Call between Ltmp71 and Ltmp73
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp73-Lfunc_begin2            ; >> Call Site 14 <<
	.uleb128 Ltmp74-Ltmp73                  ;   Call between Ltmp73 and Ltmp74
	.uleb128 Ltmp75-Lfunc_begin2            ;     jumps to Ltmp75
	.byte	9                               ;   On action: 5
	.uleb128 Ltmp74-Lfunc_begin2            ; >> Call Site 15 <<
	.uleb128 Lfunc_end2-Ltmp74              ;   Call between Ltmp74 and Lfunc_end2
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
Ltmp112:                                ; TypeInfo 2
	.long	__ZTISt16invalid_argument@GOT-Ltmp112
Ltmp113:                                ; TypeInfo 1
	.long	__ZTISt9exception@GOT-Ltmp113
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
Ltmp76:
	bl	__ZNSt3__119__thread_local_dataEv
Ltmp77:
; %bb.1:
	ldr	x1, [x19]
	str	xzr, [x19]
	ldr	x0, [x0]
Ltmp78:
	bl	_pthread_setspecific
Ltmp79:
; %bb.2:
	ldr	x8, [x19, #8]
	ldr	w8, [x8]
	cmp	w8, #1
	b.lt	LBB8_15
; %bb.3:
	mov	w20, #1                         ; =0x1
	mov	w21, #42330                     ; =0xa55a
	movk	w21, #42330, lsl #16
	mov	w22, #1                         ; =0x1
LBB8_4:                                 ; =>This Inner Loop Header: Depth=1
	ldr	x8, [x19, #16]
	ldp	x9, x0, [x8]
	ldrb	w8, [x9]
	cmp	w8, #1
	b.ne	LBB8_6
; %bb.5:                                ;   in Loop: Header=BB8_4 Depth=1
	ldar	w0, [x0]
	b	LBB8_7
LBB8_6:                                 ;   in Loop: Header=BB8_4 Depth=1
	bl	_observe
LBB8_7:                                 ;   in Loop: Header=BB8_4 Depth=1
	ldr	x8, [x19, #24]
	ldarb	w8, [x8]
	cbz	w0, LBB8_10
; %bb.8:                                ;   in Loop: Header=BB8_4 Depth=1
	tbnz	w8, #0, LBB8_15
; %bb.9:                                ;   in Loop: Header=BB8_4 Depth=1
Ltmp81:
	bl	_sched_yield
Ltmp82:
	b	LBB8_4
LBB8_10:                                ;   in Loop: Header=BB8_4 Depth=1
	tbnz	w8, #0, LBB8_15
; %bb.11:                               ;   in Loop: Header=BB8_4 Depth=1
	ldp	x8, x9, [x19, #32]
	str	x22, [x8]
	eor	x8, x22, x21
	str	x8, [x9]
	ldr	x8, [x19, #48]
	ldp	x9, x0, [x8]
	ldrb	w8, [x9]
	cmp	w8, #1
	b.ne	LBB8_13
; %bb.12:                               ;   in Loop: Header=BB8_4 Depth=1
	stlr	w20, [x0]
	b	LBB8_14
LBB8_13:                                ;   in Loop: Header=BB8_4 Depth=1
	mov	w1, #1                          ; =0x1
	bl	_publish
LBB8_14:                                ;   in Loop: Header=BB8_4 Depth=1
	ldr	x8, [x19, #8]
	ldrsw	x8, [x8]
	cmp	x22, x8
	add	x22, x22, #1
	b.lt	LBB8_4
LBB8_15:
	ldr	x19, [sp, #8]
	cbz	x19, LBB8_19
; %bb.16:
	ldr	x0, [x19]
	str	xzr, [x19]
	cbz	x0, LBB8_18
; %bb.17:
	bl	__ZNSt3__115__thread_structD1Ev
	bl	__ZdlPv
LBB8_18:
	mov	x0, x19
	bl	__ZdlPv
LBB8_19:
	mov	x0, #0                          ; =0x0
	ldp	x29, x30, [sp, #48]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #32]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #64
	ret
LBB8_20:
Ltmp80:
	mov	x19, x0
	add	x0, sp, #8
	bl	__ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ8transferbiE3$_2EEENS3_IS7_EEED1B9nqe210106Ev
	mov	x0, x19
	bl	__Unwind_Resume
LBB8_21:
Ltmp83:
	bl	___clang_call_terminate
Lfunc_end3:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table8:
Lexception3:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase3-Lttbaseref3
Lttbaseref3:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end3-Lcst_begin3
Lcst_begin3:
	.uleb128 Ltmp76-Lfunc_begin3            ; >> Call Site 1 <<
	.uleb128 Ltmp79-Ltmp76                  ;   Call between Ltmp76 and Ltmp79
	.uleb128 Ltmp80-Lfunc_begin3            ;     jumps to Ltmp80
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp81-Lfunc_begin3            ; >> Call Site 2 <<
	.uleb128 Ltmp82-Ltmp81                  ;   Call between Ltmp81 and Ltmp82
	.uleb128 Ltmp83-Lfunc_begin3            ;     jumps to Ltmp83
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp82-Lfunc_begin3            ; >> Call Site 3 <<
	.uleb128 Lfunc_end3-Ltmp82              ;   Call between Ltmp82 and Lfunc_end3
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
	cbz	x19, LBB9_4
; %bb.1:
	mov	x20, x0
	ldr	x0, [x19]
	str	xzr, [x19]
	cbz	x0, LBB9_3
; %bb.2:
	bl	__ZNSt3__115__thread_structD1Ev
	bl	__ZdlPv
LBB9_3:
	mov	x0, x19
	bl	__ZdlPv
	mov	x0, x20
LBB9_4:
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
	cbz	x0, LBB10_2
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
LBB10_2:
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
Ltmp84:
	add	x0, sp, #8
	mov	x1, x19
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryC1ERS3_
Ltmp85:
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
Ltmp87:
	add	x8, sp, #24
	mov	x25, x4
	mov	x0, x4
	bl	__ZNKSt3__18ios_base6getlocEv
Ltmp88:
; %bb.4:
Ltmp89:
Lloh38:
	adrp	x1, __ZNSt3__15ctypeIcE2idE@GOTPAGE
Lloh39:
	ldr	x1, [x1, __ZNSt3__15ctypeIcE2idE@GOTPAGEOFF]
	add	x0, sp, #24
	bl	__ZNKSt3__16locale9use_facetERNS0_2idE
Ltmp90:
; %bb.5:
	ldr	x8, [x0]
	ldr	x8, [x8, #56]
Ltmp91:
	mov	w1, #32                         ; =0x20
	blr	x8
Ltmp92:
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
Ltmp94:
	sxtb	w5, w23
	mov	x0, x22
	mov	x1, x20
	bl	__ZNSt3__116__pad_and_outputB9nqe210106IcNS_11char_traitsIcEEEENS_19ostreambuf_iteratorIT_T0_EES6_PKS4_S8_S8_RNS_8ios_baseES4_
Ltmp95:
; %bb.8:
	cbnz	x0, LBB11_10
; %bb.9:
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
	add	x0, x19, x8
	ldr	w8, [x0, #32]
	mov	w9, #5                          ; =0x5
Ltmp97:
	orr	w1, w8, w9
	bl	__ZNSt3__18ios_base5clearEj
Ltmp98:
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
Ltmp99:
	b	LBB11_15
LBB11_13:
Ltmp93:
	mov	x20, x0
	add	x0, sp, #24
	bl	__ZNSt3__16localeD1Ev
	b	LBB11_16
LBB11_14:
Ltmp96:
LBB11_15:
	mov	x20, x0
LBB11_16:
	add	x0, sp, #8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryD1Ev
	b	LBB11_18
LBB11_17:
Ltmp86:
	mov	x20, x0
LBB11_18:
	mov	x0, x20
	bl	___cxa_begin_catch
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
Ltmp100:
	add	x0, x19, x8
	bl	__ZNSt3__18ios_base33__set_badbit_and_consider_rethrowEv
Ltmp101:
; %bb.19:
	bl	___cxa_end_catch
	b	LBB11_11
LBB11_20:
Ltmp102:
	mov	x19, x0
Ltmp103:
	bl	___cxa_end_catch
Ltmp104:
; %bb.21:
	mov	x0, x19
	bl	__Unwind_Resume
LBB11_22:
Ltmp105:
	bl	___clang_call_terminate
	.loh AdrpLdrGot	Lloh38, Lloh39
Lfunc_end4:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table11:
Lexception4:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase4-Lttbaseref4
Lttbaseref4:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end4-Lcst_begin4
Lcst_begin4:
	.uleb128 Ltmp84-Lfunc_begin4            ; >> Call Site 1 <<
	.uleb128 Ltmp85-Ltmp84                  ;   Call between Ltmp84 and Ltmp85
	.uleb128 Ltmp86-Lfunc_begin4            ;     jumps to Ltmp86
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp87-Lfunc_begin4            ; >> Call Site 2 <<
	.uleb128 Ltmp88-Ltmp87                  ;   Call between Ltmp87 and Ltmp88
	.uleb128 Ltmp96-Lfunc_begin4            ;     jumps to Ltmp96
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp89-Lfunc_begin4            ; >> Call Site 3 <<
	.uleb128 Ltmp92-Ltmp89                  ;   Call between Ltmp89 and Ltmp92
	.uleb128 Ltmp93-Lfunc_begin4            ;     jumps to Ltmp93
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp94-Lfunc_begin4            ; >> Call Site 4 <<
	.uleb128 Ltmp95-Ltmp94                  ;   Call between Ltmp94 and Ltmp95
	.uleb128 Ltmp96-Lfunc_begin4            ;     jumps to Ltmp96
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp97-Lfunc_begin4            ; >> Call Site 5 <<
	.uleb128 Ltmp98-Ltmp97                  ;   Call between Ltmp97 and Ltmp98
	.uleb128 Ltmp99-Lfunc_begin4            ;     jumps to Ltmp99
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp98-Lfunc_begin4            ; >> Call Site 6 <<
	.uleb128 Ltmp100-Ltmp98                 ;   Call between Ltmp98 and Ltmp100
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp100-Lfunc_begin4           ; >> Call Site 7 <<
	.uleb128 Ltmp101-Ltmp100                ;   Call between Ltmp100 and Ltmp101
	.uleb128 Ltmp102-Lfunc_begin4           ;     jumps to Ltmp102
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp101-Lfunc_begin4           ; >> Call Site 8 <<
	.uleb128 Ltmp103-Ltmp101                ;   Call between Ltmp101 and Ltmp103
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp103-Lfunc_begin4           ; >> Call Site 9 <<
	.uleb128 Ltmp104-Ltmp103                ;   Call between Ltmp103 and Ltmp104
	.uleb128 Ltmp105-Lfunc_begin4           ;     jumps to Ltmp105
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp104-Lfunc_begin4           ; >> Call Site 10 <<
	.uleb128 Lfunc_end4-Ltmp104             ;   Call between Ltmp104 and Lfunc_end4
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
Ltmp106:
	mov	x0, x19
	mov	x2, x24
	blr	x8
Ltmp107:
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
Ltmp108:
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
	.uleb128 Ltmp106-Lfunc_begin5           ;   Call between Lfunc_begin5 and Ltmp106
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp106-Lfunc_begin5           ; >> Call Site 2 <<
	.uleb128 Ltmp107-Ltmp106                ;   Call between Ltmp106 and Ltmp107
	.uleb128 Ltmp108-Lfunc_begin5           ;     jumps to Ltmp108
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp107-Lfunc_begin5           ; >> Call Site 3 <<
	.uleb128 Lfunc_end5-Ltmp107             ;   Call between Ltmp107 and Lfunc_end5
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
Lloh40:
	adrp	x0, l_.str.8@PAGE
Lloh41:
	add	x0, x0, l_.str.8@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh40, Lloh41
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
Ltmp109:
	mov	x1, x20
	bl	__ZNSt12length_errorC1B9nqe210106EPKc
Ltmp110:
; %bb.1:
Lloh42:
	adrp	x1, __ZTISt12length_error@GOTPAGE
Lloh43:
	ldr	x1, [x1, __ZTISt12length_error@GOTPAGEOFF]
Lloh44:
	adrp	x2, __ZNSt12length_errorD1Ev@GOTPAGE
Lloh45:
	ldr	x2, [x2, __ZNSt12length_errorD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
LBB14_2:
Ltmp111:
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x0, x20
	bl	__Unwind_Resume
	.loh AdrpLdrGot	Lloh44, Lloh45
	.loh AdrpLdrGot	Lloh42, Lloh43
Lfunc_end6:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table14:
Lexception6:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end6-Lcst_begin6
Lcst_begin6:
	.uleb128 Lfunc_begin6-Lfunc_begin6      ; >> Call Site 1 <<
	.uleb128 Ltmp109-Lfunc_begin6           ;   Call between Lfunc_begin6 and Ltmp109
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp109-Lfunc_begin6           ; >> Call Site 2 <<
	.uleb128 Ltmp110-Ltmp109                ;   Call between Ltmp109 and Ltmp110
	.uleb128 Ltmp111-Lfunc_begin6           ;     jumps to Ltmp111
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp110-Lfunc_begin6           ; >> Call Site 3 <<
	.uleb128 Lfunc_end6-Ltmp110             ;   Call between Ltmp110 and Lfunc_end6
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
Lloh46:
	adrp	x8, __ZTVSt12length_error@GOTPAGE
Lloh47:
	ldr	x8, [x8, __ZTVSt12length_error@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x0]
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
	.loh AdrpLdrGot	Lloh46, Lloh47
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _Z8transferbi.cold.1
__Z8transferbi.cold.1:                  ; @_Z8transferbi.cold.1
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh48:
	adrp	x1, __ZTISt16invalid_argument@GOTPAGE
Lloh49:
	ldr	x1, [x1, __ZTISt16invalid_argument@GOTPAGEOFF]
Lloh50:
	adrp	x2, __ZNSt16invalid_argumentD1Ev@GOTPAGE
Lloh51:
	ldr	x2, [x2, __ZNSt16invalid_argumentD1Ev@GOTPAGEOFF]
	bl	___cxa_throw
	.loh AdrpLdrGot	Lloh50, Lloh51
	.loh AdrpLdrGot	Lloh48, Lloh49
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"negative transfer count"

l_.str.1:                               ; @.str.1
	.asciz	"publication or reuse failure"

l_.str.2:                               ; @.str.2
	.asciz	"RMW old value"

l_.str.4:                               ; @.str.4
	.asciz	"PASS seq_cst/acquire_release transfers=20002 zero=2 ticket_old_values=1000\n"

l_.str.5:                               ; @.str.5
	.asciz	"negative_count_rejected=1; no racy execution; lock_free="

l_.str.6:                               ; @.str.6
	.asciz	"No timing; TSan is evidence for this execution, not an ARM memory-model proof\n"

l_.str.7:                               ; @.str.7
	.asciz	"thread constructor failed"

l_.str.8:                               ; @.str.8
	.asciz	"basic_string"

.subsections_via_symbols
