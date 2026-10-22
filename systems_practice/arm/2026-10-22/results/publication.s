	.build_version macos, 26, 0	sdk_version 26, 5
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__Z7publishRNSt3__16atomicIiEEi ; -- Begin function _Z7publishRNSt3__16atomicIiEEi
	.p2align	2
__Z7publishRNSt3__16atomicIiEEi:        ; @_Z7publishRNSt3__16atomicIiEEi
	.cfi_startproc
; %bb.0:
	stlr	w1, [x0]
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__Z7acquireRKNSt3__16atomicIiEE ; -- Begin function _Z7acquireRKNSt3__16atomicIiEE
	.p2align	2
__Z7acquireRKNSt3__16atomicIiEE:        ; @_Z7acquireRKNSt3__16atomicIiEE
	.cfi_startproc
; %bb.0:
	ldapr	w0, [x0]
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_main                           ; -- Begin function main
	.p2align	2
_main:                                  ; @main
Lfunc_begin0:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception0
; %bb.0:
	sub	sp, sp, #112
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
	str	wzr, [sp, #44]
Ltmp0:
	mov	w0, #68                         ; =0x44
	bl	__Znwm
Ltmp1:
; %bb.1:
	add	x8, x0, #68
	stp	x8, x8, [sp, #24]
	movi.2d	v0, #0000000000000000
	stp	q0, q0, [x0]
	stp	q0, q0, [x0, #32]
	str	wzr, [x0, #64]
	str	x0, [sp, #16]
Ltmp3:
	mov	w0, #8                          ; =0x8
	bl	__Znwm
Ltmp4:
; %bb.2:
Ltmp6:
	mov	x19, x0
	bl	__ZNSt3__115__thread_structC1Ev
Ltmp7:
; %bb.3:
	stur	x19, [x29, #-40]
Ltmp9:
	mov	w0, #24                         ; =0x18
	bl	__Znwm
Ltmp10:
; %bb.4:
	mov	x3, x0
	stur	xzr, [x29, #-40]
	add	x8, sp, #44
	stp	x19, x8, [x0]
	add	x8, sp, #16
	str	x8, [x0, #16]
	str	x0, [sp, #48]
Ltmp12:
Lloh0:
	adrp	x2, __ZNSt3__114__thread_proxyB9nqe210106INS_5tupleIJNS_10unique_ptrINS_15__thread_structENS_14default_deleteIS3_EEEEZ4mainE3$_0EEEEEPvS9_@PAGE
Lloh1:
	add	x2, x2, __ZNSt3__114__thread_proxyB9nqe210106INS_5tupleIJNS_10unique_ptrINS_15__thread_structENS_14default_deleteIS3_EEEEZ4mainE3$_0EEEEEPvS9_@PAGEOFF
	add	x0, sp, #8
	mov	x1, #0                          ; =0x0
	bl	_pthread_create
Ltmp13:
; %bb.5:
	cbnz	w0, LBB2_33
; %bb.6:
	mov	w21, #0                         ; =0x0
	mov	w19, #1                         ; =0x1
	mov	w20, #10001                     ; =0x2711
	b	LBB2_8
LBB2_7:                                 ;   in Loop: Header=BB2_8 Depth=1
Ltmp17:
	bl	_sched_yield
Ltmp18:
LBB2_8:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB2_15 Depth 2
                                        ;     Child Loop BB2_20 Depth 2
                                        ;     Child Loop BB2_24 Depth 2
	add	x0, sp, #44
	bl	__Z7acquireRKNSt3__16atomicIiEE
	cmp	w0, #1
	b.ne	LBB2_7
; %bb.9:                                ;   in Loop: Header=BB2_8 Depth=1
	ldp	x10, x8, [sp, #16]
	cmp	x10, x8
	b.eq	LBB2_25
; %bb.10:                               ;   in Loop: Header=BB2_8 Depth=1
	sub	x9, x8, x10
	sub	x11, x9, #4
	cmp	x11, #11
	b.hi	LBB2_12
; %bb.11:                               ;   in Loop: Header=BB2_8 Depth=1
	mov	x14, x21
	mov	x12, x10
	b	LBB2_23
LBB2_12:                                ;   in Loop: Header=BB2_8 Depth=1
	lsr	x9, x11, #2
	add	x9, x9, #1
	dup.4s	v0, w19
	cmp	x11, #252
	b.hs	LBB2_14
; %bb.13:                               ;   in Loop: Header=BB2_8 Depth=1
	mov	x11, #0                         ; =0x0
	mov	x14, x21
	b	LBB2_19
LBB2_14:                                ;   in Loop: Header=BB2_8 Depth=1
	and	x11, x9, #0x7fffffffffffffc0
	add	x12, x10, #128
	movi.2d	v1, #0000000000000000
	mov	x13, x11
	movi.2d	v2, #0000000000000000
	movi.2d	v3, #0000000000000000
	movi.2d	v4, #0000000000000000
LBB2_15:                                ;   Parent Loop BB2_8 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldp	q6, q5, [x12, #-96]
	ldp	q7, q16, [x12, #-128]
	ldp	q18, q17, [x12, #-32]
	ldp	q19, q20, [x12, #-64]
	ldp	q22, q21, [x12, #32]
	ldp	q23, q24, [x12]
	ldp	q26, q25, [x12, #96]
	cmeq.4s	v16, v16, v0
	cmeq.4s	v7, v7, v0
	uzp1.8h	v7, v7, v16
	cmeq.4s	v6, v6, v0
	cmeq.4s	v5, v5, v0
	ldp	q16, q27, [x12, #64]
	uzp1.8h	v5, v6, v5
	uzp1.16b	v5, v7, v5
	cmeq.4s	v6, v20, v0
	cmeq.4s	v7, v19, v0
	uzp1.8h	v6, v7, v6
	cmeq.4s	v7, v18, v0
	cmeq.4s	v17, v17, v0
	uzp1.8h	v7, v7, v17
	uzp1.16b	v6, v6, v7
	cmeq.4s	v7, v24, v0
	cmeq.4s	v17, v23, v0
	uzp1.8h	v7, v17, v7
	cmeq.4s	v17, v22, v0
	cmeq.4s	v18, v21, v0
	uzp1.8h	v17, v17, v18
	uzp1.16b	v7, v7, v17
	cmeq.4s	v17, v27, v0
	cmeq.4s	v16, v16, v0
	uzp1.8h	v16, v16, v17
	cmeq.4s	v17, v26, v0
	cmeq.4s	v18, v25, v0
	uzp1.8h	v17, v17, v18
	uzp1.16b	v16, v16, v17
	orn.16b	v1, v1, v5
	orn.16b	v2, v2, v6
	orn.16b	v3, v3, v7
	orn.16b	v4, v4, v16
	add	x12, x12, #256
	subs	x13, x13, #64
	b.ne	LBB2_15
; %bb.16:                               ;   in Loop: Header=BB2_8 Depth=1
	orr.16b	v1, v2, v1
	orr.16b	v2, v4, v3
	orr.16b	v1, v2, v1
	shl.16b	v1, v1, #7
	cmlt.16b	v1, v1, #0
	umaxv.16b	b1, v1
	fmov	w12, s1
	orr	w14, w12, w21
	cmp	x9, x11
	b.ne	LBB2_18
; %bb.17:                               ;   in Loop: Header=BB2_8 Depth=1
	mov	x21, x14
	b	LBB2_25
LBB2_18:                                ;   in Loop: Header=BB2_8 Depth=1
	tst	x9, #0x3c
	b.eq	LBB2_22
LBB2_19:                                ;   in Loop: Header=BB2_8 Depth=1
	eor	w14, w14, w21
	and	x13, x9, #0x7ffffffffffffffc
	add	x12, x10, x13, lsl #2
	dup.4h	v1, w14
	add	x10, x10, x11, lsl #2
	sub	x11, x11, x13
LBB2_20:                                ;   Parent Loop BB2_8 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	q2, [x10], #16
	cmeq.4s	v2, v2, v0
	mvn.16b	v2, v2
	xtn.4h	v2, v2
	orr.8b	v1, v1, v2
	adds	x11, x11, #4
	b.ne	LBB2_20
; %bb.21:                               ;   in Loop: Header=BB2_8 Depth=1
	shl.4h	v0, v1, #15
	cmlt.4h	v0, v0, #0
	umaxv.4h	h0, v0
	fmov	w10, s0
	orr	w14, w10, w21
	mov	x21, x14
	cmp	x9, x13
	b.ne	LBB2_23
	b	LBB2_25
LBB2_22:                                ;   in Loop: Header=BB2_8 Depth=1
	add	x12, x10, x11, lsl #2
LBB2_23:                                ;   in Loop: Header=BB2_8 Depth=1
	mov	x21, x14
LBB2_24:                                ;   Parent Loop BB2_8 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	w9, [x12], #4
	cmp	w9, w19
	cset	w9, ne
	orr	w21, w9, w21
	cmp	x12, x8
	b.ne	LBB2_24
LBB2_25:                                ;   in Loop: Header=BB2_8 Depth=1
	add	x0, sp, #44
	mov	w1, #0                          ; =0x0
	bl	__Z7publishRNSt3__16atomicIiEEi
	add	w19, w19, #1
	cmp	w19, w20
	b.ne	LBB2_8
; %bb.26:
Ltmp20:
	add	x0, sp, #8
	bl	__ZNSt3__16thread4joinEv
Ltmp21:
; %bb.27:
	tbnz	w21, #0, LBB2_34
; %bb.28:
Ltmp22:
Lloh2:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh3:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh4:
	adrp	x1, l_.str.3@PAGE
Lloh5:
	add	x1, x1, l_.str.3@PAGEOFF
	mov	w2, #112                        ; =0x70
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp23:
; %bb.29:
	add	x0, sp, #8
	bl	__ZNSt3__16threadD1Ev
	ldr	x0, [sp, #16]
	cbz	x0, LBB2_31
; %bb.30:
	str	x0, [sp, #24]
	bl	__ZdlPv
LBB2_31:
	mov	w0, #0                          ; =0x0
LBB2_32:
	ldp	x29, x30, [sp, #96]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #80]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #64]             ; 16-byte Folded Reload
	add	sp, sp, #112
	ret
LBB2_33:
Ltmp14:
Lloh6:
	adrp	x1, l_.str.5@PAGE
Lloh7:
	add	x1, x1, l_.str.5@PAGEOFF
	bl	__ZNSt3__120__throw_system_errorEiPKc
Ltmp15:
	b	LBB2_36
LBB2_34:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x21, x0
Ltmp25:
Lloh8:
	adrp	x1, l_.str@PAGE
Lloh9:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp26:
; %bb.35:
Ltmp28:
Lloh10:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh11:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh12:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh13:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x21
	bl	___cxa_throw
Ltmp29:
LBB2_36:
	brk	#0x1
LBB2_37:
Ltmp27:
	mov	x20, x1
	mov	x19, x0
	mov	x0, x21
	bl	___cxa_free_exception
	b	LBB2_45
LBB2_38:
Ltmp24:
	b	LBB2_44
LBB2_39:
Ltmp11:
	mov	x20, x1
	mov	x19, x0
	b	LBB2_47
LBB2_40:
Ltmp8:
	mov	x20, x1
	mov	x8, x19
	mov	x19, x0
	mov	x0, x8
	bl	__ZdlPv
	b	LBB2_48
LBB2_41:
Ltmp5:
	mov	x20, x1
	mov	x19, x0
	b	LBB2_48
LBB2_42:
Ltmp2:
	mov	x20, x1
	mov	x19, x0
	b	LBB2_50
LBB2_43:
Ltmp30:
LBB2_44:
	mov	x20, x1
	mov	x19, x0
LBB2_45:
	add	x0, sp, #8
	bl	__ZNSt3__16threadD1Ev
	b	LBB2_48
LBB2_46:
Ltmp16:
	mov	x20, x1
	mov	x19, x0
	add	x0, sp, #48
	bl	__ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ4mainE3$_0EEENS3_IS7_EEED1B9nqe210106Ev
LBB2_47:
	sub	x0, x29, #40
	bl	__ZNSt3__110unique_ptrINS_15__thread_structENS_14default_deleteIS1_EEED1B9nqe210106Ev
LBB2_48:
	ldr	x0, [sp, #16]
	cbz	x0, LBB2_50
; %bb.49:
	str	x0, [sp, #24]
	bl	__ZdlPv
LBB2_50:
	cmp	w20, #1
	b.ne	LBB2_55
; %bb.51:
	mov	x0, x19
	bl	___cxa_begin_catch
	ldr	x8, [x0]
	ldr	x8, [x8, #16]
	blr	x8
	mov	x19, x0
	bl	_strlen
	mov	x2, x0
Ltmp31:
Lloh14:
	adrp	x0, __ZNSt3__14cerrE@GOTPAGE
Lloh15:
	ldr	x0, [x0, __ZNSt3__14cerrE@GOTPAGEOFF]
	mov	x1, x19
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp32:
; %bb.52:
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #16]
Ltmp33:
	add	x1, sp, #16
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp34:
; %bb.53:
	bl	___cxa_end_catch
	mov	w0, #1                          ; =0x1
	b	LBB2_32
LBB2_54:
Ltmp35:
	mov	x19, x0
Ltmp36:
	bl	___cxa_end_catch
Ltmp37:
LBB2_55:
	mov	x0, x19
	bl	__Unwind_Resume
LBB2_56:
Ltmp38:
	bl	___clang_call_terminate
LBB2_57:
Ltmp19:
	bl	___clang_call_terminate
	.loh AdrpAdd	Lloh0, Lloh1
	.loh AdrpAdd	Lloh4, Lloh5
	.loh AdrpLdrGot	Lloh2, Lloh3
	.loh AdrpAdd	Lloh6, Lloh7
	.loh AdrpAdd	Lloh8, Lloh9
	.loh AdrpLdrGot	Lloh12, Lloh13
	.loh AdrpLdrGot	Lloh10, Lloh11
	.loh AdrpLdrGot	Lloh14, Lloh15
Lfunc_end0:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table2:
Lexception0:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase0-Lttbaseref0
Lttbaseref0:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end0-Lcst_begin0
Lcst_begin0:
	.uleb128 Ltmp0-Lfunc_begin0             ; >> Call Site 1 <<
	.uleb128 Ltmp1-Ltmp0                    ;   Call between Ltmp0 and Ltmp1
	.uleb128 Ltmp2-Lfunc_begin0             ;     jumps to Ltmp2
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp3-Lfunc_begin0             ; >> Call Site 2 <<
	.uleb128 Ltmp4-Ltmp3                    ;   Call between Ltmp3 and Ltmp4
	.uleb128 Ltmp5-Lfunc_begin0             ;     jumps to Ltmp5
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp6-Lfunc_begin0             ; >> Call Site 3 <<
	.uleb128 Ltmp7-Ltmp6                    ;   Call between Ltmp6 and Ltmp7
	.uleb128 Ltmp8-Lfunc_begin0             ;     jumps to Ltmp8
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp9-Lfunc_begin0             ; >> Call Site 4 <<
	.uleb128 Ltmp10-Ltmp9                   ;   Call between Ltmp9 and Ltmp10
	.uleb128 Ltmp11-Lfunc_begin0            ;     jumps to Ltmp11
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp12-Lfunc_begin0            ; >> Call Site 5 <<
	.uleb128 Ltmp13-Ltmp12                  ;   Call between Ltmp12 and Ltmp13
	.uleb128 Ltmp16-Lfunc_begin0            ;     jumps to Ltmp16
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp17-Lfunc_begin0            ; >> Call Site 6 <<
	.uleb128 Ltmp18-Ltmp17                  ;   Call between Ltmp17 and Ltmp18
	.uleb128 Ltmp19-Lfunc_begin0            ;     jumps to Ltmp19
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp20-Lfunc_begin0            ; >> Call Site 7 <<
	.uleb128 Ltmp21-Ltmp20                  ;   Call between Ltmp20 and Ltmp21
	.uleb128 Ltmp30-Lfunc_begin0            ;     jumps to Ltmp30
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp22-Lfunc_begin0            ; >> Call Site 8 <<
	.uleb128 Ltmp23-Ltmp22                  ;   Call between Ltmp22 and Ltmp23
	.uleb128 Ltmp24-Lfunc_begin0            ;     jumps to Ltmp24
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp14-Lfunc_begin0            ; >> Call Site 9 <<
	.uleb128 Ltmp15-Ltmp14                  ;   Call between Ltmp14 and Ltmp15
	.uleb128 Ltmp16-Lfunc_begin0            ;     jumps to Ltmp16
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp15-Lfunc_begin0            ; >> Call Site 10 <<
	.uleb128 Ltmp25-Ltmp15                  ;   Call between Ltmp15 and Ltmp25
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp25-Lfunc_begin0            ; >> Call Site 11 <<
	.uleb128 Ltmp26-Ltmp25                  ;   Call between Ltmp25 and Ltmp26
	.uleb128 Ltmp27-Lfunc_begin0            ;     jumps to Ltmp27
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp28-Lfunc_begin0            ; >> Call Site 12 <<
	.uleb128 Ltmp29-Ltmp28                  ;   Call between Ltmp28 and Ltmp29
	.uleb128 Ltmp30-Lfunc_begin0            ;     jumps to Ltmp30
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp29-Lfunc_begin0            ; >> Call Site 13 <<
	.uleb128 Ltmp31-Ltmp29                  ;   Call between Ltmp29 and Ltmp31
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp31-Lfunc_begin0            ; >> Call Site 14 <<
	.uleb128 Ltmp34-Ltmp31                  ;   Call between Ltmp31 and Ltmp34
	.uleb128 Ltmp35-Lfunc_begin0            ;     jumps to Ltmp35
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp34-Lfunc_begin0            ; >> Call Site 15 <<
	.uleb128 Ltmp36-Ltmp34                  ;   Call between Ltmp34 and Ltmp36
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp36-Lfunc_begin0            ; >> Call Site 16 <<
	.uleb128 Ltmp37-Ltmp36                  ;   Call between Ltmp36 and Ltmp37
	.uleb128 Ltmp38-Lfunc_begin0            ;     jumps to Ltmp38
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp37-Lfunc_begin0            ; >> Call Site 17 <<
	.uleb128 Lfunc_end0-Ltmp37              ;   Call between Ltmp37 and Lfunc_end0
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end0:
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
Ltmp75:                                 ; TypeInfo 1
	.long	__ZTISt9exception@GOT-Ltmp75
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
	mov	x20, x0
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp39:
	mov	x1, x20
	bl	__ZNSt12length_errorC1B9nqe210106EPKc
Ltmp40:
; %bb.1:
Lloh16:
	adrp	x1, __ZTISt12length_error@GOTPAGE
Lloh17:
	ldr	x1, [x1, __ZTISt12length_error@GOTPAGEOFF]
Lloh18:
	adrp	x2, __ZNSt12length_errorD1Ev@GOTPAGE
Lloh19:
	ldr	x2, [x2, __ZNSt12length_errorD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
LBB4_2:
Ltmp41:
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x0, x20
	bl	__Unwind_Resume
	.loh AdrpLdrGot	Lloh18, Lloh19
	.loh AdrpLdrGot	Lloh16, Lloh17
Lfunc_end1:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table4:
Lexception1:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end1-Lcst_begin1
Lcst_begin1:
	.uleb128 Lfunc_begin1-Lfunc_begin1      ; >> Call Site 1 <<
	.uleb128 Ltmp39-Lfunc_begin1            ;   Call between Lfunc_begin1 and Ltmp39
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp39-Lfunc_begin1            ; >> Call Site 2 <<
	.uleb128 Ltmp40-Ltmp39                  ;   Call between Ltmp39 and Ltmp40
	.uleb128 Ltmp41-Lfunc_begin1            ;     jumps to Ltmp41
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp40-Lfunc_begin1            ; >> Call Site 3 <<
	.uleb128 Lfunc_end1-Ltmp40              ;   Call between Ltmp40 and Lfunc_end1
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end1:
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
Lloh20:
	adrp	x8, __ZTVSt12length_error@GOTPAGE
Lloh21:
	ldr	x8, [x8, __ZTVSt12length_error@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x0]
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
	.loh AdrpLdrGot	Lloh20, Lloh21
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZNSt3__114__thread_proxyB9nqe210106INS_5tupleIJNS_10unique_ptrINS_15__thread_structENS_14default_deleteIS3_EEEEZ4mainE3$_0EEEEEPvS9_
__ZNSt3__114__thread_proxyB9nqe210106INS_5tupleIJNS_10unique_ptrINS_15__thread_structENS_14default_deleteIS3_EEEEZ4mainE3$_0EEEEEPvS9_: ; @"_ZNSt3__114__thread_proxyB9nqe210106INS_5tupleIJNS_10unique_ptrINS_15__thread_structENS_14default_deleteIS3_EEEEZ4mainE3$_0EEEEEPvS9_"
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
	mov	x19, x0
	str	x0, [sp, #8]
Ltmp42:
	bl	__ZNSt3__119__thread_local_dataEv
Ltmp43:
; %bb.1:
	ldr	x1, [x19]
	str	xzr, [x19]
	ldr	x0, [x0]
Ltmp44:
	bl	_pthread_setspecific
Ltmp45:
; %bb.2:
	mov	w21, #1                         ; =0x1
	mov	w22, #10001                     ; =0x2711
	b	LBB6_4
LBB6_3:                                 ;   in Loop: Header=BB6_4 Depth=1
Ltmp47:
	bl	_sched_yield
Ltmp48:
LBB6_4:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB6_10 Depth 2
                                        ;     Child Loop BB6_14 Depth 2
                                        ;     Child Loop BB6_17 Depth 2
	ldr	x20, [x19, #8]
	mov	x0, x20
	bl	__Z7acquireRKNSt3__16atomicIiEE
	cbnz	w0, LBB6_3
; %bb.5:                                ;   in Loop: Header=BB6_4 Depth=1
	ldr	x8, [x19, #16]
	ldp	x10, x8, [x8]
	cmp	x10, x8
	b.eq	LBB6_18
; %bb.6:                                ;   in Loop: Header=BB6_4 Depth=1
	sub	x9, x8, x10
	sub	x12, x9, #4
	mov	x11, x10
	cmp	x12, #11
	b.ls	LBB6_17
; %bb.7:                                ;   in Loop: Header=BB6_4 Depth=1
	lsr	x9, x12, #2
	add	x9, x9, #1
	dup.4s	v0, w21
	cmp	x12, #60
	b.hs	LBB6_9
; %bb.8:                                ;   in Loop: Header=BB6_4 Depth=1
	mov	x12, #0                         ; =0x0
	b	LBB6_13
LBB6_9:                                 ;   in Loop: Header=BB6_4 Depth=1
	and	x12, x9, #0x7ffffffffffffff0
	add	x11, x10, #32
	mov	x13, x12
LBB6_10:                                ;   Parent Loop BB6_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	stp	q0, q0, [x11, #-32]
	stp	q0, q0, [x11], #64
	subs	x13, x13, #16
	b.ne	LBB6_10
; %bb.11:                               ;   in Loop: Header=BB6_4 Depth=1
	cmp	x9, x12
	b.eq	LBB6_18
; %bb.12:                               ;   in Loop: Header=BB6_4 Depth=1
	tst	x9, #0xc
	b.eq	LBB6_16
LBB6_13:                                ;   in Loop: Header=BB6_4 Depth=1
	and	x13, x9, #0x7ffffffffffffffc
	add	x11, x10, x13, lsl #2
	add	x10, x10, x12, lsl #2
	sub	x12, x12, x13
LBB6_14:                                ;   Parent Loop BB6_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	str	q0, [x10], #16
	adds	x12, x12, #4
	b.ne	LBB6_14
; %bb.15:                               ;   in Loop: Header=BB6_4 Depth=1
	cmp	x9, x13
	b.ne	LBB6_17
	b	LBB6_18
LBB6_16:                                ;   in Loop: Header=BB6_4 Depth=1
	add	x11, x10, x12, lsl #2
LBB6_17:                                ;   Parent Loop BB6_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	str	w21, [x11], #4
	cmp	x11, x8
	b.ne	LBB6_17
LBB6_18:                                ;   in Loop: Header=BB6_4 Depth=1
	mov	x0, x20
	mov	w1, #1                          ; =0x1
	bl	__Z7publishRNSt3__16atomicIiEEi
	add	w21, w21, #1
	cmp	w21, w22
	b.ne	LBB6_4
; %bb.19:
	ldr	x0, [x19]
	str	xzr, [x19]
	cbz	x0, LBB6_21
; %bb.20:
	bl	__ZNSt3__115__thread_structD1Ev
	bl	__ZdlPv
LBB6_21:
	mov	x0, x19
	bl	__ZdlPv
	mov	x0, #0                          ; =0x0
	ldp	x29, x30, [sp, #48]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #32]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #64
	ret
LBB6_22:
Ltmp46:
	mov	x19, x0
	add	x0, sp, #8
	bl	__ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ4mainE3$_0EEENS3_IS7_EEED1B9nqe210106Ev
	mov	x0, x19
	bl	__Unwind_Resume
LBB6_23:
Ltmp49:
	bl	___clang_call_terminate
Lfunc_end2:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table6:
Lexception2:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase1-Lttbaseref1
Lttbaseref1:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end2-Lcst_begin2
Lcst_begin2:
	.uleb128 Ltmp42-Lfunc_begin2            ; >> Call Site 1 <<
	.uleb128 Ltmp45-Ltmp42                  ;   Call between Ltmp42 and Ltmp45
	.uleb128 Ltmp46-Lfunc_begin2            ;     jumps to Ltmp46
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp47-Lfunc_begin2            ; >> Call Site 2 <<
	.uleb128 Ltmp48-Ltmp47                  ;   Call between Ltmp47 and Ltmp48
	.uleb128 Ltmp49-Lfunc_begin2            ;     jumps to Ltmp49
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp48-Lfunc_begin2            ; >> Call Site 3 <<
	.uleb128 Lfunc_end2-Ltmp48              ;   Call between Ltmp48 and Lfunc_end2
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end2:
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
	.p2align	2                               ; -- Begin function _ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ4mainE3$_0EEENS3_IS7_EEED1B9nqe210106Ev
__ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ4mainE3$_0EEENS3_IS7_EEED1B9nqe210106Ev: ; @"_ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ4mainE3$_0EEENS3_IS7_EEED1B9nqe210106Ev"
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
	cbz	x19, LBB7_4
; %bb.1:
	mov	x20, x0
	ldr	x0, [x19]
	str	xzr, [x19]
	cbz	x0, LBB7_3
; %bb.2:
	bl	__ZNSt3__115__thread_structD1Ev
	bl	__ZdlPv
LBB7_3:
	mov	x0, x19
	bl	__ZdlPv
	mov	x0, x20
LBB7_4:
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
	cbz	x0, LBB8_2
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
LBB8_2:
	mov	x0, x8
	ret
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
Ltmp50:
	add	x0, sp, #8
	mov	x1, x19
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryC1ERS3_
Ltmp51:
; %bb.1:
	ldrb	w8, [sp, #8]
	cmp	w8, #1
	b.ne	LBB9_10
; %bb.2:
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
	add	x4, x19, x8
	ldr	x22, [x4, #40]
	ldr	w24, [x4, #8]
	ldr	w23, [x4, #144]
	cmn	w23, #1
	b.ne	LBB9_7
; %bb.3:
Ltmp53:
	add	x8, sp, #24
	mov	x25, x4
	mov	x0, x4
	bl	__ZNKSt3__18ios_base6getlocEv
Ltmp54:
; %bb.4:
Ltmp55:
Lloh22:
	adrp	x1, __ZNSt3__15ctypeIcE2idE@GOTPAGE
Lloh23:
	ldr	x1, [x1, __ZNSt3__15ctypeIcE2idE@GOTPAGEOFF]
	add	x0, sp, #24
	bl	__ZNKSt3__16locale9use_facetERNS0_2idE
Ltmp56:
; %bb.5:
	ldr	x8, [x0]
	ldr	x8, [x8, #56]
Ltmp57:
	mov	w1, #32                         ; =0x20
	blr	x8
Ltmp58:
; %bb.6:
	mov	x23, x0
	add	x0, sp, #24
	bl	__ZNSt3__16localeD1Ev
	mov	x4, x25
	str	w23, [x25, #144]
LBB9_7:
	mov	w8, #176                        ; =0xb0
	and	w8, w24, w8
	add	x3, x20, x21
	cmp	w8, #32
	csel	x2, x3, x20, eq
Ltmp60:
	sxtb	w5, w23
	mov	x0, x22
	mov	x1, x20
	bl	__ZNSt3__116__pad_and_outputB9nqe210106IcNS_11char_traitsIcEEEENS_19ostreambuf_iteratorIT_T0_EES6_PKS4_S8_S8_RNS_8ios_baseES4_
Ltmp61:
; %bb.8:
	cbnz	x0, LBB9_10
; %bb.9:
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
	add	x0, x19, x8
	ldr	w8, [x0, #32]
	mov	w9, #5                          ; =0x5
Ltmp63:
	orr	w1, w8, w9
	bl	__ZNSt3__18ios_base5clearEj
Ltmp64:
LBB9_10:
	add	x0, sp, #8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryD1Ev
LBB9_11:
	mov	x0, x19
	ldp	x29, x30, [sp, #96]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #80]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #64]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #48]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #112
	ret
LBB9_12:
Ltmp65:
	b	LBB9_15
LBB9_13:
Ltmp59:
	mov	x20, x0
	add	x0, sp, #24
	bl	__ZNSt3__16localeD1Ev
	b	LBB9_16
LBB9_14:
Ltmp62:
LBB9_15:
	mov	x20, x0
LBB9_16:
	add	x0, sp, #8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryD1Ev
	b	LBB9_18
LBB9_17:
Ltmp52:
	mov	x20, x0
LBB9_18:
	mov	x0, x20
	bl	___cxa_begin_catch
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
Ltmp66:
	add	x0, x19, x8
	bl	__ZNSt3__18ios_base33__set_badbit_and_consider_rethrowEv
Ltmp67:
; %bb.19:
	bl	___cxa_end_catch
	b	LBB9_11
LBB9_20:
Ltmp68:
	mov	x19, x0
Ltmp69:
	bl	___cxa_end_catch
Ltmp70:
; %bb.21:
	mov	x0, x19
	bl	__Unwind_Resume
LBB9_22:
Ltmp71:
	bl	___clang_call_terminate
	.loh AdrpLdrGot	Lloh22, Lloh23
Lfunc_end3:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table9:
Lexception3:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase2-Lttbaseref2
Lttbaseref2:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end3-Lcst_begin3
Lcst_begin3:
	.uleb128 Ltmp50-Lfunc_begin3            ; >> Call Site 1 <<
	.uleb128 Ltmp51-Ltmp50                  ;   Call between Ltmp50 and Ltmp51
	.uleb128 Ltmp52-Lfunc_begin3            ;     jumps to Ltmp52
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp53-Lfunc_begin3            ; >> Call Site 2 <<
	.uleb128 Ltmp54-Ltmp53                  ;   Call between Ltmp53 and Ltmp54
	.uleb128 Ltmp62-Lfunc_begin3            ;     jumps to Ltmp62
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp55-Lfunc_begin3            ; >> Call Site 3 <<
	.uleb128 Ltmp58-Ltmp55                  ;   Call between Ltmp55 and Ltmp58
	.uleb128 Ltmp59-Lfunc_begin3            ;     jumps to Ltmp59
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp60-Lfunc_begin3            ; >> Call Site 4 <<
	.uleb128 Ltmp61-Ltmp60                  ;   Call between Ltmp60 and Ltmp61
	.uleb128 Ltmp62-Lfunc_begin3            ;     jumps to Ltmp62
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp63-Lfunc_begin3            ; >> Call Site 5 <<
	.uleb128 Ltmp64-Ltmp63                  ;   Call between Ltmp63 and Ltmp64
	.uleb128 Ltmp65-Lfunc_begin3            ;     jumps to Ltmp65
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp64-Lfunc_begin3            ; >> Call Site 6 <<
	.uleb128 Ltmp66-Ltmp64                  ;   Call between Ltmp64 and Ltmp66
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp66-Lfunc_begin3            ; >> Call Site 7 <<
	.uleb128 Ltmp67-Ltmp66                  ;   Call between Ltmp66 and Ltmp67
	.uleb128 Ltmp68-Lfunc_begin3            ;     jumps to Ltmp68
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp67-Lfunc_begin3            ; >> Call Site 8 <<
	.uleb128 Ltmp69-Ltmp67                  ;   Call between Ltmp67 and Ltmp69
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp69-Lfunc_begin3            ; >> Call Site 9 <<
	.uleb128 Ltmp70-Ltmp69                  ;   Call between Ltmp69 and Ltmp70
	.uleb128 Ltmp71-Lfunc_begin3            ;     jumps to Ltmp71
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp70-Lfunc_begin3            ; >> Call Site 10 <<
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
Lttbase2:
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
	cbz	x0, LBB10_16
; %bb.1:
	mov	x23, x5
	mov	x20, x4
	mov	x22, x3
	mov	x21, x2
	mov	x24, x1
	ldr	x26, [x4, #24]
	sub	x25, x2, x1
	cmp	x25, #1
	b.lt	LBB10_3
; %bb.2:
	ldr	x8, [x19]
	ldr	x8, [x8, #96]
	mov	x0, x19
	mov	x1, x24
	mov	x2, x25
	blr	x8
	cmp	x0, x25
	b.ne	LBB10_15
LBB10_3:
	sub	x8, x22, x24
	cmp	x26, x8
	b.le	LBB10_12
; %bb.4:
	mov	x9, #-9                         ; =0xfffffffffffffff7
	movk	x9, #32767, lsl #48
	sub	x24, x26, x8
	cmp	x24, x9
	b.hs	LBB10_17
; %bb.5:
	cmp	x24, #23
	b.hs	LBB10_7
; %bb.6:
	strb	w24, [sp, #31]
	add	x25, sp, #8
	b	LBB10_8
LBB10_7:
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
LBB10_8:
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
Ltmp72:
	mov	x0, x19
	mov	x2, x24
	blr	x8
Ltmp73:
; %bb.9:
	ldrsb	w8, [sp, #31]
	tbnz	w8, #31, LBB10_11
; %bb.10:
	cmp	x0, x24
	b.ne	LBB10_15
	b	LBB10_12
LBB10_11:
	ldr	x8, [sp, #8]
	mov	x23, x0
	mov	x0, x8
	bl	__ZdlPv
	mov	x0, x23
	cmp	x0, x24
	b.ne	LBB10_15
LBB10_12:
	sub	x22, x22, x21
	cmp	x22, #1
	b.lt	LBB10_14
; %bb.13:
	ldr	x8, [x19]
	ldr	x8, [x8, #96]
	mov	x0, x19
	mov	x1, x21
	mov	x2, x22
	blr	x8
	cmp	x0, x22
	b.ne	LBB10_15
LBB10_14:
	str	xzr, [x20, #24]
	b	LBB10_16
LBB10_15:
	mov	x19, #0                         ; =0x0
LBB10_16:
	mov	x0, x19
	ldp	x29, x30, [sp, #96]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #80]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #64]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #48]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #112
	ret
LBB10_17:
	bl	__ZNSt3__112basic_stringIcNS_11char_traitsIcEENS_9allocatorIcEEE20__throw_length_errorB9nqe210106Ev
LBB10_18:
Ltmp74:
	mov	x19, x0
	ldrsb	w8, [sp, #31]
	tbz	w8, #31, LBB10_20
; %bb.19:
	ldr	x0, [sp, #8]
	bl	__ZdlPv
LBB10_20:
	mov	x0, x19
	bl	__Unwind_Resume
Lfunc_end4:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table10:
Lexception4:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end4-Lcst_begin4
Lcst_begin4:
	.uleb128 Lfunc_begin4-Lfunc_begin4      ; >> Call Site 1 <<
	.uleb128 Ltmp72-Lfunc_begin4            ;   Call between Lfunc_begin4 and Ltmp72
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp72-Lfunc_begin4            ; >> Call Site 2 <<
	.uleb128 Ltmp73-Ltmp72                  ;   Call between Ltmp72 and Ltmp73
	.uleb128 Ltmp74-Lfunc_begin4            ;     jumps to Ltmp74
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp73-Lfunc_begin4            ; >> Call Site 3 <<
	.uleb128 Lfunc_end4-Ltmp73              ;   Call between Ltmp73 and Lfunc_end4
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
Lloh24:
	adrp	x0, l_.str.6@PAGE
Lloh25:
	add	x0, x0, l_.str.6@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh24, Lloh25
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"CPU publication mismatch"

l_.str.3:                               ; @.str.3
	.asciz	"PASS CPU frames=10000 elements=17 bidirectional publication; early-reuse counterexample; device simulation only\n"

l_.str.5:                               ; @.str.5
	.asciz	"thread constructor failed"

l_.str.6:                               ; @.str.6
	.asciz	"basic_string"

.subsections_via_symbols
