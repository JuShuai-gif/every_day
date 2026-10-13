	.build_version macos, 26, 0	sdk_version 26, 5
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_add_relaxed                    ; -- Begin function add_relaxed
	.p2align	2
_add_relaxed:                           ; @add_relaxed
	.cfi_startproc
; %bb.0:
	mov	w8, #1                          ; =0x1
	ldadd	x8, x8, [x0]
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
	sub	sp, sp, #80
	stp	x20, x19, [sp, #48]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #64]             ; 16-byte Folded Spill
	add	x29, sp, #64
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	mov	w8, #8                          ; =0x8
	stp	x8, xzr, [sp, #24]
Ltmp0:
Lloh0:
	adrp	x0, l_.str@PAGE
Lloh1:
	add	x0, x0, l_.str@PAGEOFF
	add	x1, sp, #32
	add	x2, sp, #24
	mov	x3, #0                          ; =0x0
	mov	x4, #0                          ; =0x0
	bl	_sysctlbyname
Ltmp1:
; %bb.1:
	cbnz	w0, LBB1_5
; %bb.2:
Ltmp4:
Lloh2:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh3:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh4:
	adrp	x1, l_.str.1@PAGE
Lloh5:
	add	x1, x1, l_.str.1@PAGEOFF
	mov	w2, #19                         ; =0x13
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp5:
; %bb.3:
	ldr	x1, [sp, #32]
Ltmp6:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp7:
; %bb.4:
	mov	w8, #10                         ; =0xa
	sturb	w8, [x29, #-17]
Ltmp8:
	sub	x1, x29, #17
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp9:
	b	LBB1_6
LBB1_5:
Ltmp2:
Lloh6:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh7:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh8:
	adrp	x1, l_.str.2@PAGE
Lloh9:
	add	x1, x1, l_.str.2@PAGEOFF
	mov	w2, #55                         ; =0x37
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp3:
LBB1_6:
Ltmp11:
Lloh10:
	adrp	x2, l_.str.3@PAGE
Lloh11:
	add	x2, x2, l_.str.3@PAGEOFF
	mov	w0, #1                          ; =0x1
	mov	w1, #0                          ; =0x0
	bl	__Z6reportI6PackedEviiPKc
Ltmp12:
; %bb.7:
Ltmp13:
Lloh12:
	adrp	x2, l_.str.4@PAGE
Lloh13:
	add	x2, x2, l_.str.4@PAGEOFF
	mov	w0, #1                          ; =0x1
	mov	w1, #0                          ; =0x0
	bl	__Z6reportI8IsolatedILi64EEEviiPKc
Ltmp14:
; %bb.8:
Ltmp15:
Lloh14:
	adrp	x2, l_.str.5@PAGE
Lloh15:
	add	x2, x2, l_.str.5@PAGEOFF
	mov	w0, #1                          ; =0x1
	mov	w1, #0                          ; =0x0
	bl	__Z6reportI8IsolatedILi128EEEviiPKc
Ltmp16:
; %bb.9:
Ltmp17:
Lloh16:
	adrp	x2, l_.str.6@PAGE
Lloh17:
	add	x2, x2, l_.str.6@PAGEOFF
	mov	w0, #1                          ; =0x1
	mov	w1, #0                          ; =0x0
	bl	__Z6reportI8IsolatedILi256EEEviiPKc
Ltmp18:
; %bb.10:
Ltmp19:
Lloh18:
	adrp	x2, l_.str.7@PAGE
Lloh19:
	add	x2, x2, l_.str.7@PAGEOFF
	mov	w0, #1                          ; =0x1
	mov	w1, #1                          ; =0x1
	bl	__Z6reportI8IsolatedILi128EEEviiPKc
Ltmp20:
; %bb.11:
Ltmp21:
Lloh20:
	adrp	x2, l_.str.8@PAGE
Lloh21:
	add	x2, x2, l_.str.8@PAGEOFF
	mov	w0, #1                          ; =0x1
	mov	w1, #2                          ; =0x2
	bl	__Z6reportI8IsolatedILi128EEEviiPKc
Ltmp22:
; %bb.12:
Ltmp23:
Lloh22:
	adrp	x2, l_.str.3@PAGE
Lloh23:
	add	x2, x2, l_.str.3@PAGEOFF
	mov	w0, #2                          ; =0x2
	mov	w1, #0                          ; =0x0
	bl	__Z6reportI6PackedEviiPKc
Ltmp24:
; %bb.13:
Ltmp25:
Lloh24:
	adrp	x2, l_.str.4@PAGE
Lloh25:
	add	x2, x2, l_.str.4@PAGEOFF
	mov	w0, #2                          ; =0x2
	mov	w1, #0                          ; =0x0
	bl	__Z6reportI8IsolatedILi64EEEviiPKc
Ltmp26:
; %bb.14:
Ltmp27:
Lloh26:
	adrp	x2, l_.str.5@PAGE
Lloh27:
	add	x2, x2, l_.str.5@PAGEOFF
	mov	w0, #2                          ; =0x2
	mov	w1, #0                          ; =0x0
	bl	__Z6reportI8IsolatedILi128EEEviiPKc
Ltmp28:
; %bb.15:
Ltmp29:
Lloh28:
	adrp	x2, l_.str.6@PAGE
Lloh29:
	add	x2, x2, l_.str.6@PAGEOFF
	mov	w0, #2                          ; =0x2
	mov	w1, #0                          ; =0x0
	bl	__Z6reportI8IsolatedILi256EEEviiPKc
Ltmp30:
; %bb.16:
Ltmp31:
Lloh30:
	adrp	x2, l_.str.7@PAGE
Lloh31:
	add	x2, x2, l_.str.7@PAGEOFF
	mov	w0, #2                          ; =0x2
	mov	w1, #1                          ; =0x1
	bl	__Z6reportI8IsolatedILi128EEEviiPKc
Ltmp32:
; %bb.17:
Ltmp33:
Lloh32:
	adrp	x2, l_.str.8@PAGE
Lloh33:
	add	x2, x2, l_.str.8@PAGEOFF
	mov	w0, #2                          ; =0x2
	mov	w1, #2                          ; =0x2
	bl	__Z6reportI8IsolatedILi128EEEviiPKc
Ltmp34:
; %bb.18:
Ltmp35:
Lloh34:
	adrp	x2, l_.str.3@PAGE
Lloh35:
	add	x2, x2, l_.str.3@PAGEOFF
	mov	w0, #4                          ; =0x4
	mov	w1, #0                          ; =0x0
	bl	__Z6reportI6PackedEviiPKc
Ltmp36:
; %bb.19:
Ltmp37:
Lloh36:
	adrp	x2, l_.str.4@PAGE
Lloh37:
	add	x2, x2, l_.str.4@PAGEOFF
	mov	w0, #4                          ; =0x4
	mov	w1, #0                          ; =0x0
	bl	__Z6reportI8IsolatedILi64EEEviiPKc
Ltmp38:
; %bb.20:
Ltmp39:
Lloh38:
	adrp	x2, l_.str.5@PAGE
Lloh39:
	add	x2, x2, l_.str.5@PAGEOFF
	mov	w0, #4                          ; =0x4
	mov	w1, #0                          ; =0x0
	bl	__Z6reportI8IsolatedILi128EEEviiPKc
Ltmp40:
; %bb.21:
Ltmp41:
Lloh40:
	adrp	x2, l_.str.6@PAGE
Lloh41:
	add	x2, x2, l_.str.6@PAGEOFF
	mov	w0, #4                          ; =0x4
	mov	w1, #0                          ; =0x0
	bl	__Z6reportI8IsolatedILi256EEEviiPKc
Ltmp42:
; %bb.22:
Ltmp43:
Lloh42:
	adrp	x2, l_.str.7@PAGE
Lloh43:
	add	x2, x2, l_.str.7@PAGEOFF
	mov	w0, #4                          ; =0x4
	mov	w1, #1                          ; =0x1
	bl	__Z6reportI8IsolatedILi128EEEviiPKc
Ltmp44:
; %bb.23:
Ltmp45:
Lloh44:
	adrp	x2, l_.str.8@PAGE
Lloh45:
	add	x2, x2, l_.str.8@PAGEOFF
	mov	w0, #4                          ; =0x4
	mov	w1, #2                          ; =0x2
	bl	__Z6reportI8IsolatedILi128EEEviiPKc
Ltmp46:
; %bb.24:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp48:
Lloh46:
	adrp	x1, l_.str.14@PAGE
Lloh47:
	add	x1, x1, l_.str.14@PAGEOFF
	bl	__ZNSt11logic_errorC2EPKc
Ltmp49:
; %bb.25:
Lloh48:
	adrp	x8, __ZTVSt16invalid_argument@GOTPAGE
Lloh49:
	ldr	x8, [x8, __ZTVSt16invalid_argument@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x19]
Ltmp51:
Lloh50:
	adrp	x1, __ZTISt16invalid_argument@GOTPAGE
Lloh51:
	ldr	x1, [x1, __ZTISt16invalid_argument@GOTPAGEOFF]
Lloh52:
	adrp	x2, __ZNSt16invalid_argumentD1Ev@GOTPAGE
Lloh53:
	ldr	x2, [x2, __ZNSt16invalid_argumentD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
Ltmp52:
; %bb.26:
	brk	#0x1
LBB1_27:
Ltmp53:
	stp	x0, x1, [sp, #8]                ; 16-byte Folded Spill
	b	LBB1_29
LBB1_28:
Ltmp50:
	stp	x0, x1, [sp, #8]                ; 16-byte Folded Spill
	mov	x0, x19
	bl	___cxa_free_exception
LBB1_29:
	ldr	x8, [sp, #16]                   ; 8-byte Folded Reload
	cmp	w8, #2
	b.ne	LBB1_33
; %bb.30:
	ldr	x0, [sp, #8]                    ; 8-byte Folded Reload
	bl	___cxa_begin_catch
Ltmp54:
	bl	___cxa_end_catch
Ltmp55:
; %bb.31:
Ltmp57:
Lloh54:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh55:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh56:
	adrp	x1, l_.str.9@PAGE
Lloh57:
	add	x1, x1, l_.str.9@PAGEOFF
	mov	w2, #55                         ; =0x37
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp58:
; %bb.32:
	mov	w0, #0                          ; =0x0
	b	LBB1_42
LBB1_33:
	ldp	x0, x1, [sp, #8]                ; 16-byte Folded Reload
	b	LBB1_38
LBB1_34:
Ltmp59:
	b	LBB1_38
LBB1_35:
Ltmp56:
	b	LBB1_38
LBB1_36:
Ltmp47:
	b	LBB1_38
LBB1_37:
Ltmp10:
LBB1_38:
	cmp	w1, #1
	b.ne	LBB1_43
; %bb.39:
	bl	___cxa_begin_catch
	ldr	x8, [x0]
	ldr	x8, [x8, #16]
	blr	x8
	mov	x19, x0
	bl	_strlen
	mov	x2, x0
Ltmp60:
Lloh58:
	adrp	x0, __ZNSt3__14cerrE@GOTPAGE
Lloh59:
	ldr	x0, [x0, __ZNSt3__14cerrE@GOTPAGEOFF]
	mov	x1, x19
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp61:
; %bb.40:
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #32]
Ltmp62:
	add	x1, sp, #32
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp63:
; %bb.41:
	bl	___cxa_end_catch
	mov	w0, #1                          ; =0x1
LBB1_42:
	ldp	x29, x30, [sp, #64]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #48]             ; 16-byte Folded Reload
	add	sp, sp, #80
	ret
LBB1_43:
	bl	__Unwind_Resume
LBB1_44:
Ltmp64:
	mov	x19, x0
Ltmp65:
	bl	___cxa_end_catch
Ltmp66:
; %bb.45:
	mov	x0, x19
	bl	__Unwind_Resume
LBB1_46:
Ltmp67:
	bl	___clang_call_terminate
	.loh AdrpAdd	Lloh0, Lloh1
	.loh AdrpAdd	Lloh4, Lloh5
	.loh AdrpLdrGot	Lloh2, Lloh3
	.loh AdrpAdd	Lloh8, Lloh9
	.loh AdrpLdrGot	Lloh6, Lloh7
	.loh AdrpAdd	Lloh10, Lloh11
	.loh AdrpAdd	Lloh12, Lloh13
	.loh AdrpAdd	Lloh14, Lloh15
	.loh AdrpAdd	Lloh16, Lloh17
	.loh AdrpAdd	Lloh18, Lloh19
	.loh AdrpAdd	Lloh20, Lloh21
	.loh AdrpAdd	Lloh22, Lloh23
	.loh AdrpAdd	Lloh24, Lloh25
	.loh AdrpAdd	Lloh26, Lloh27
	.loh AdrpAdd	Lloh28, Lloh29
	.loh AdrpAdd	Lloh30, Lloh31
	.loh AdrpAdd	Lloh32, Lloh33
	.loh AdrpAdd	Lloh34, Lloh35
	.loh AdrpAdd	Lloh36, Lloh37
	.loh AdrpAdd	Lloh38, Lloh39
	.loh AdrpAdd	Lloh40, Lloh41
	.loh AdrpAdd	Lloh42, Lloh43
	.loh AdrpAdd	Lloh44, Lloh45
	.loh AdrpAdd	Lloh46, Lloh47
	.loh AdrpLdrGot	Lloh52, Lloh53
	.loh AdrpLdrGot	Lloh50, Lloh51
	.loh AdrpLdrGot	Lloh48, Lloh49
	.loh AdrpAdd	Lloh56, Lloh57
	.loh AdrpLdrGot	Lloh54, Lloh55
	.loh AdrpLdrGot	Lloh58, Lloh59
Lfunc_end0:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table1:
Lexception0:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase0-Lttbaseref0
Lttbaseref0:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end0-Lcst_begin0
Lcst_begin0:
	.uleb128 Ltmp0-Lfunc_begin0             ; >> Call Site 1 <<
	.uleb128 Ltmp3-Ltmp0                    ;   Call between Ltmp0 and Ltmp3
	.uleb128 Ltmp10-Lfunc_begin0            ;     jumps to Ltmp10
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp11-Lfunc_begin0            ; >> Call Site 2 <<
	.uleb128 Ltmp46-Ltmp11                  ;   Call between Ltmp11 and Ltmp46
	.uleb128 Ltmp47-Lfunc_begin0            ;     jumps to Ltmp47
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp46-Lfunc_begin0            ; >> Call Site 3 <<
	.uleb128 Ltmp48-Ltmp46                  ;   Call between Ltmp46 and Ltmp48
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp48-Lfunc_begin0            ; >> Call Site 4 <<
	.uleb128 Ltmp49-Ltmp48                  ;   Call between Ltmp48 and Ltmp49
	.uleb128 Ltmp50-Lfunc_begin0            ;     jumps to Ltmp50
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp51-Lfunc_begin0            ; >> Call Site 5 <<
	.uleb128 Ltmp52-Ltmp51                  ;   Call between Ltmp51 and Ltmp52
	.uleb128 Ltmp53-Lfunc_begin0            ;     jumps to Ltmp53
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp52-Lfunc_begin0            ; >> Call Site 6 <<
	.uleb128 Ltmp54-Ltmp52                  ;   Call between Ltmp52 and Ltmp54
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp54-Lfunc_begin0            ; >> Call Site 7 <<
	.uleb128 Ltmp55-Ltmp54                  ;   Call between Ltmp54 and Ltmp55
	.uleb128 Ltmp56-Lfunc_begin0            ;     jumps to Ltmp56
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp57-Lfunc_begin0            ; >> Call Site 8 <<
	.uleb128 Ltmp58-Ltmp57                  ;   Call between Ltmp57 and Ltmp58
	.uleb128 Ltmp59-Lfunc_begin0            ;     jumps to Ltmp59
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp58-Lfunc_begin0            ; >> Call Site 9 <<
	.uleb128 Ltmp60-Ltmp58                  ;   Call between Ltmp58 and Ltmp60
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp60-Lfunc_begin0            ; >> Call Site 10 <<
	.uleb128 Ltmp63-Ltmp60                  ;   Call between Ltmp60 and Ltmp63
	.uleb128 Ltmp64-Lfunc_begin0            ;     jumps to Ltmp64
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp63-Lfunc_begin0            ; >> Call Site 11 <<
	.uleb128 Ltmp65-Ltmp63                  ;   Call between Ltmp63 and Ltmp65
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp65-Lfunc_begin0            ; >> Call Site 12 <<
	.uleb128 Ltmp66-Ltmp65                  ;   Call between Ltmp65 and Ltmp66
	.uleb128 Ltmp67-Lfunc_begin0            ;     jumps to Ltmp67
	.byte	9                               ;   On action: 5
	.uleb128 Ltmp66-Lfunc_begin0            ; >> Call Site 13 <<
	.uleb128 Lfunc_end0-Ltmp66              ;   Call between Ltmp66 and Lfunc_end0
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
	.byte	125                             ;   Continue to action 3
	.byte	3                               ; >> Action Record 5 <<
                                        ;   Catch TypeInfo 3
	.byte	0                               ;   No further actions
	.p2align	2, 0x0
                                        ; >> Catch TypeInfos <<
	.long	0                               ; TypeInfo 3
Ltmp476:                                ; TypeInfo 2
	.long	__ZTISt16invalid_argument@GOT-Ltmp476
Ltmp477:                                ; TypeInfo 1
	.long	__ZTISt9exception@GOT-Ltmp477
Lttbase0:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__Z6reportI6PackedEviiPKc       ; -- Begin function _Z6reportI6PackedEviiPKc
	.weak_def_can_be_hidden	__Z6reportI6PackedEviiPKc
	.p2align	2
__Z6reportI6PackedEviiPKc:              ; @_Z6reportI6PackedEviiPKc
Lfunc_begin1:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception1
; %bb.0:
	sub	sp, sp, #128
	stp	d9, d8, [sp, #16]               ; 16-byte Folded Spill
	stp	x28, x27, [sp, #32]             ; 16-byte Folded Spill
	stp	x26, x25, [sp, #48]             ; 16-byte Folded Spill
	stp	x24, x23, [sp, #64]             ; 16-byte Folded Spill
	stp	x22, x21, [sp, #80]             ; 16-byte Folded Spill
	stp	x20, x19, [sp, #96]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #112]            ; 16-byte Folded Spill
	add	x29, sp, #112
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
	str	x2, [sp]                        ; 8-byte Folded Spill
	mov	x22, x1
	mov	x23, x0
	mov	w2, #0                          ; =0x0
	bl	__Z5trialI6PackedEdiib
	mov	x0, x23
	mov	x1, x22
	mov	w2, #0                          ; =0x0
	bl	__Z5trialI6PackedEdiib
	mov	x0, x23
	mov	x1, x22
	mov	w2, #0                          ; =0x0
	bl	__Z5trialI6PackedEdiib
	mov	x19, #0                         ; =0x0
	mov	x20, #0                         ; =0x0
	mov	x21, #0                         ; =0x0
	mov	w26, #9                         ; =0x9
	mov	x27, #9223372036854775800       ; =0x7ffffffffffffff8
	mov	x28, #2305843009213693951       ; =0x1fffffffffffffff
	b	LBB2_2
LBB2_1:                                 ;   in Loop: Header=BB2_2 Depth=1
	str	d8, [x21], #8
	subs	w26, w26, #1
	b.eq	LBB2_10
LBB2_2:                                 ; =>This Inner Loop Header: Depth=1
	cmp	w26, #9
	cset	w2, eq
Ltmp68:
	mov	x0, x23
	mov	x1, x22
	bl	__Z5trialI6PackedEdiib
Ltmp69:
; %bb.3:                                ;   in Loop: Header=BB2_2 Depth=1
	mov.16b	v8, v0
	cmp	x21, x20
	b.lo	LBB2_1
; %bb.4:                                ;   in Loop: Header=BB2_2 Depth=1
	sub	x24, x21, x19
	asr	x25, x24, #3
	add	x8, x25, #1
	lsr	x9, x8, #61
	cbnz	x9, LBB2_18
; %bb.5:                                ;   in Loop: Header=BB2_2 Depth=1
	sub	x9, x20, x19
	asr	x10, x9, #2
	cmp	x10, x8
	csel	x8, x10, x8, hi
	cmp	x9, x27
	csel	x20, x8, x28, lo
	lsr	x8, x20, #61
	cbnz	x8, LBB2_19
; %bb.6:                                ;   in Loop: Header=BB2_2 Depth=1
	lsl	x0, x20, #3
Ltmp70:
	bl	__Znwm
Ltmp71:
; %bb.7:                                ;   in Loop: Header=BB2_2 Depth=1
	add	x21, x0, x24
	add	x20, x0, x20, lsl #3
	sub	x25, x21, x25, lsl #3
	str	d8, [x21], #8
	mov	x0, x25
	mov	x1, x19
	mov	x2, x24
	bl	_memcpy
	cbz	x19, LBB2_9
; %bb.8:                                ;   in Loop: Header=BB2_2 Depth=1
	mov	x0, x19
	bl	__ZdlPv
LBB2_9:                                 ;   in Loop: Header=BB2_2 Depth=1
	mov	x19, x25
	subs	w26, w26, #1
	b.ne	LBB2_2
LBB2_10:
Ltmp78:
	add	x2, sp, #14
	mov	x0, x19
	mov	x1, x21
	bl	__ZNSt3__16__sortIRNS_6__lessIddEEPdEEvT0_S5_T_
Ltmp79:
; %bb.11:
	ldr	x20, [sp]                       ; 8-byte Folded Reload
	mov	x0, x20
	bl	_strlen
	mov	x2, x0
Ltmp80:
Lloh60:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh61:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
	mov	x1, x20
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp81:
; %bb.12:
Ltmp82:
Lloh62:
	adrp	x1, l_.str.11@PAGE
Lloh63:
	add	x1, x1, l_.str.11@PAGEOFF
	mov	w2, #18                         ; =0x12
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp83:
; %bb.13:
	ldr	d0, [x19, #32]
Ltmp84:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp85:
; %bb.14:
Ltmp86:
Lloh64:
	adrp	x1, l_.str.12@PAGE
Lloh65:
	add	x1, x1, l_.str.12@PAGEOFF
	mov	w2, #6                          ; =0x6
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp87:
; %bb.15:
	ldur	d0, [x21, #-8]
Ltmp88:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp89:
; %bb.16:
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #15]
Ltmp90:
	add	x1, sp, #15
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp91:
; %bb.17:
	mov	x0, x19
	bl	__ZdlPv
	ldp	x29, x30, [sp, #112]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #96]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #80]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #64]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #48]             ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #32]             ; 16-byte Folded Reload
	ldp	d9, d8, [sp, #16]               ; 16-byte Folded Reload
	add	sp, sp, #128
	ret
LBB2_18:
Ltmp75:
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_length_errorB9nqe210106Ev
Ltmp76:
	b	LBB2_20
LBB2_19:
Ltmp73:
	bl	__ZSt28__throw_bad_array_new_lengthB9nqe210106v
Ltmp74:
LBB2_20:
	brk	#0x1
LBB2_21:
Ltmp92:
	b	LBB2_24
LBB2_22:
Ltmp77:
	b	LBB2_24
LBB2_23:
Ltmp72:
LBB2_24:
	mov	x20, x0
	cbz	x19, LBB2_26
; %bb.25:
	mov	x0, x19
	bl	__ZdlPv
LBB2_26:
	mov	x0, x20
	bl	__Unwind_Resume
	.loh AdrpLdrGot	Lloh60, Lloh61
	.loh AdrpAdd	Lloh62, Lloh63
	.loh AdrpAdd	Lloh64, Lloh65
Lfunc_end1:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table2:
Lexception1:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end1-Lcst_begin1
Lcst_begin1:
	.uleb128 Lfunc_begin1-Lfunc_begin1      ; >> Call Site 1 <<
	.uleb128 Ltmp68-Lfunc_begin1            ;   Call between Lfunc_begin1 and Ltmp68
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp68-Lfunc_begin1            ; >> Call Site 2 <<
	.uleb128 Ltmp71-Ltmp68                  ;   Call between Ltmp68 and Ltmp71
	.uleb128 Ltmp72-Lfunc_begin1            ;     jumps to Ltmp72
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp71-Lfunc_begin1            ; >> Call Site 3 <<
	.uleb128 Ltmp78-Ltmp71                  ;   Call between Ltmp71 and Ltmp78
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp78-Lfunc_begin1            ; >> Call Site 4 <<
	.uleb128 Ltmp91-Ltmp78                  ;   Call between Ltmp78 and Ltmp91
	.uleb128 Ltmp92-Lfunc_begin1            ;     jumps to Ltmp92
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp75-Lfunc_begin1            ; >> Call Site 5 <<
	.uleb128 Ltmp74-Ltmp75                  ;   Call between Ltmp75 and Ltmp74
	.uleb128 Ltmp77-Lfunc_begin1            ;     jumps to Ltmp77
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp74-Lfunc_begin1            ; >> Call Site 6 <<
	.uleb128 Lfunc_end1-Ltmp74              ;   Call between Ltmp74 and Lfunc_end1
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end1:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__Z6reportI8IsolatedILi64EEEviiPKc ; -- Begin function _Z6reportI8IsolatedILi64EEEviiPKc
	.weak_def_can_be_hidden	__Z6reportI8IsolatedILi64EEEviiPKc
	.p2align	2
__Z6reportI8IsolatedILi64EEEviiPKc:     ; @_Z6reportI8IsolatedILi64EEEviiPKc
Lfunc_begin2:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception2
; %bb.0:
	sub	sp, sp, #128
	stp	d9, d8, [sp, #16]               ; 16-byte Folded Spill
	stp	x28, x27, [sp, #32]             ; 16-byte Folded Spill
	stp	x26, x25, [sp, #48]             ; 16-byte Folded Spill
	stp	x24, x23, [sp, #64]             ; 16-byte Folded Spill
	stp	x22, x21, [sp, #80]             ; 16-byte Folded Spill
	stp	x20, x19, [sp, #96]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #112]            ; 16-byte Folded Spill
	add	x29, sp, #112
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
	str	x2, [sp]                        ; 8-byte Folded Spill
	mov	x22, x1
	mov	x23, x0
	mov	w2, #0                          ; =0x0
	bl	__Z5trialI8IsolatedILi64EEEdiib
	mov	x0, x23
	mov	x1, x22
	mov	w2, #0                          ; =0x0
	bl	__Z5trialI8IsolatedILi64EEEdiib
	mov	x0, x23
	mov	x1, x22
	mov	w2, #0                          ; =0x0
	bl	__Z5trialI8IsolatedILi64EEEdiib
	mov	x19, #0                         ; =0x0
	mov	x20, #0                         ; =0x0
	mov	x21, #0                         ; =0x0
	mov	w26, #9                         ; =0x9
	mov	x27, #9223372036854775800       ; =0x7ffffffffffffff8
	mov	x28, #2305843009213693951       ; =0x1fffffffffffffff
	b	LBB3_2
LBB3_1:                                 ;   in Loop: Header=BB3_2 Depth=1
	str	d8, [x21], #8
	subs	w26, w26, #1
	b.eq	LBB3_10
LBB3_2:                                 ; =>This Inner Loop Header: Depth=1
	cmp	w26, #9
	cset	w2, eq
Ltmp93:
	mov	x0, x23
	mov	x1, x22
	bl	__Z5trialI8IsolatedILi64EEEdiib
Ltmp94:
; %bb.3:                                ;   in Loop: Header=BB3_2 Depth=1
	mov.16b	v8, v0
	cmp	x21, x20
	b.lo	LBB3_1
; %bb.4:                                ;   in Loop: Header=BB3_2 Depth=1
	sub	x24, x21, x19
	asr	x25, x24, #3
	add	x8, x25, #1
	lsr	x9, x8, #61
	cbnz	x9, LBB3_18
; %bb.5:                                ;   in Loop: Header=BB3_2 Depth=1
	sub	x9, x20, x19
	asr	x10, x9, #2
	cmp	x10, x8
	csel	x8, x10, x8, hi
	cmp	x9, x27
	csel	x20, x8, x28, lo
	lsr	x8, x20, #61
	cbnz	x8, LBB3_19
; %bb.6:                                ;   in Loop: Header=BB3_2 Depth=1
	lsl	x0, x20, #3
Ltmp95:
	bl	__Znwm
Ltmp96:
; %bb.7:                                ;   in Loop: Header=BB3_2 Depth=1
	add	x21, x0, x24
	add	x20, x0, x20, lsl #3
	sub	x25, x21, x25, lsl #3
	str	d8, [x21], #8
	mov	x0, x25
	mov	x1, x19
	mov	x2, x24
	bl	_memcpy
	cbz	x19, LBB3_9
; %bb.8:                                ;   in Loop: Header=BB3_2 Depth=1
	mov	x0, x19
	bl	__ZdlPv
LBB3_9:                                 ;   in Loop: Header=BB3_2 Depth=1
	mov	x19, x25
	subs	w26, w26, #1
	b.ne	LBB3_2
LBB3_10:
Ltmp103:
	add	x2, sp, #14
	mov	x0, x19
	mov	x1, x21
	bl	__ZNSt3__16__sortIRNS_6__lessIddEEPdEEvT0_S5_T_
Ltmp104:
; %bb.11:
	ldr	x20, [sp]                       ; 8-byte Folded Reload
	mov	x0, x20
	bl	_strlen
	mov	x2, x0
Ltmp105:
Lloh66:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh67:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
	mov	x1, x20
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp106:
; %bb.12:
Ltmp107:
Lloh68:
	adrp	x1, l_.str.11@PAGE
Lloh69:
	add	x1, x1, l_.str.11@PAGEOFF
	mov	w2, #18                         ; =0x12
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp108:
; %bb.13:
	ldr	d0, [x19, #32]
Ltmp109:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp110:
; %bb.14:
Ltmp111:
Lloh70:
	adrp	x1, l_.str.12@PAGE
Lloh71:
	add	x1, x1, l_.str.12@PAGEOFF
	mov	w2, #6                          ; =0x6
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp112:
; %bb.15:
	ldur	d0, [x21, #-8]
Ltmp113:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp114:
; %bb.16:
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #15]
Ltmp115:
	add	x1, sp, #15
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp116:
; %bb.17:
	mov	x0, x19
	bl	__ZdlPv
	ldp	x29, x30, [sp, #112]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #96]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #80]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #64]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #48]             ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #32]             ; 16-byte Folded Reload
	ldp	d9, d8, [sp, #16]               ; 16-byte Folded Reload
	add	sp, sp, #128
	ret
LBB3_18:
Ltmp100:
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_length_errorB9nqe210106Ev
Ltmp101:
	b	LBB3_20
LBB3_19:
Ltmp98:
	bl	__ZSt28__throw_bad_array_new_lengthB9nqe210106v
Ltmp99:
LBB3_20:
	brk	#0x1
LBB3_21:
Ltmp117:
	b	LBB3_24
LBB3_22:
Ltmp102:
	b	LBB3_24
LBB3_23:
Ltmp97:
LBB3_24:
	mov	x20, x0
	cbz	x19, LBB3_26
; %bb.25:
	mov	x0, x19
	bl	__ZdlPv
LBB3_26:
	mov	x0, x20
	bl	__Unwind_Resume
	.loh AdrpLdrGot	Lloh66, Lloh67
	.loh AdrpAdd	Lloh68, Lloh69
	.loh AdrpAdd	Lloh70, Lloh71
Lfunc_end2:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table3:
Lexception2:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end2-Lcst_begin2
Lcst_begin2:
	.uleb128 Lfunc_begin2-Lfunc_begin2      ; >> Call Site 1 <<
	.uleb128 Ltmp93-Lfunc_begin2            ;   Call between Lfunc_begin2 and Ltmp93
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp93-Lfunc_begin2            ; >> Call Site 2 <<
	.uleb128 Ltmp96-Ltmp93                  ;   Call between Ltmp93 and Ltmp96
	.uleb128 Ltmp97-Lfunc_begin2            ;     jumps to Ltmp97
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp96-Lfunc_begin2            ; >> Call Site 3 <<
	.uleb128 Ltmp103-Ltmp96                 ;   Call between Ltmp96 and Ltmp103
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp103-Lfunc_begin2           ; >> Call Site 4 <<
	.uleb128 Ltmp116-Ltmp103                ;   Call between Ltmp103 and Ltmp116
	.uleb128 Ltmp117-Lfunc_begin2           ;     jumps to Ltmp117
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp100-Lfunc_begin2           ; >> Call Site 5 <<
	.uleb128 Ltmp99-Ltmp100                 ;   Call between Ltmp100 and Ltmp99
	.uleb128 Ltmp102-Lfunc_begin2           ;     jumps to Ltmp102
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp99-Lfunc_begin2            ; >> Call Site 6 <<
	.uleb128 Lfunc_end2-Ltmp99              ;   Call between Ltmp99 and Lfunc_end2
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end2:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__Z6reportI8IsolatedILi128EEEviiPKc ; -- Begin function _Z6reportI8IsolatedILi128EEEviiPKc
	.weak_def_can_be_hidden	__Z6reportI8IsolatedILi128EEEviiPKc
	.p2align	2
__Z6reportI8IsolatedILi128EEEviiPKc:    ; @_Z6reportI8IsolatedILi128EEEviiPKc
Lfunc_begin3:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception3
; %bb.0:
	sub	sp, sp, #128
	stp	d9, d8, [sp, #16]               ; 16-byte Folded Spill
	stp	x28, x27, [sp, #32]             ; 16-byte Folded Spill
	stp	x26, x25, [sp, #48]             ; 16-byte Folded Spill
	stp	x24, x23, [sp, #64]             ; 16-byte Folded Spill
	stp	x22, x21, [sp, #80]             ; 16-byte Folded Spill
	stp	x20, x19, [sp, #96]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #112]            ; 16-byte Folded Spill
	add	x29, sp, #112
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
	str	x2, [sp]                        ; 8-byte Folded Spill
	mov	x22, x1
	mov	x23, x0
	mov	w2, #0                          ; =0x0
	bl	__Z5trialI8IsolatedILi128EEEdiib
	mov	x0, x23
	mov	x1, x22
	mov	w2, #0                          ; =0x0
	bl	__Z5trialI8IsolatedILi128EEEdiib
	mov	x0, x23
	mov	x1, x22
	mov	w2, #0                          ; =0x0
	bl	__Z5trialI8IsolatedILi128EEEdiib
	mov	x19, #0                         ; =0x0
	mov	x20, #0                         ; =0x0
	mov	x21, #0                         ; =0x0
	mov	w26, #9                         ; =0x9
	mov	x27, #9223372036854775800       ; =0x7ffffffffffffff8
	mov	x28, #2305843009213693951       ; =0x1fffffffffffffff
	b	LBB4_2
LBB4_1:                                 ;   in Loop: Header=BB4_2 Depth=1
	str	d8, [x21], #8
	subs	w26, w26, #1
	b.eq	LBB4_10
LBB4_2:                                 ; =>This Inner Loop Header: Depth=1
	cmp	w26, #9
	cset	w2, eq
Ltmp118:
	mov	x0, x23
	mov	x1, x22
	bl	__Z5trialI8IsolatedILi128EEEdiib
Ltmp119:
; %bb.3:                                ;   in Loop: Header=BB4_2 Depth=1
	mov.16b	v8, v0
	cmp	x21, x20
	b.lo	LBB4_1
; %bb.4:                                ;   in Loop: Header=BB4_2 Depth=1
	sub	x24, x21, x19
	asr	x25, x24, #3
	add	x8, x25, #1
	lsr	x9, x8, #61
	cbnz	x9, LBB4_18
; %bb.5:                                ;   in Loop: Header=BB4_2 Depth=1
	sub	x9, x20, x19
	asr	x10, x9, #2
	cmp	x10, x8
	csel	x8, x10, x8, hi
	cmp	x9, x27
	csel	x20, x8, x28, lo
	lsr	x8, x20, #61
	cbnz	x8, LBB4_19
; %bb.6:                                ;   in Loop: Header=BB4_2 Depth=1
	lsl	x0, x20, #3
Ltmp120:
	bl	__Znwm
Ltmp121:
; %bb.7:                                ;   in Loop: Header=BB4_2 Depth=1
	add	x21, x0, x24
	add	x20, x0, x20, lsl #3
	sub	x25, x21, x25, lsl #3
	str	d8, [x21], #8
	mov	x0, x25
	mov	x1, x19
	mov	x2, x24
	bl	_memcpy
	cbz	x19, LBB4_9
; %bb.8:                                ;   in Loop: Header=BB4_2 Depth=1
	mov	x0, x19
	bl	__ZdlPv
LBB4_9:                                 ;   in Loop: Header=BB4_2 Depth=1
	mov	x19, x25
	subs	w26, w26, #1
	b.ne	LBB4_2
LBB4_10:
Ltmp128:
	add	x2, sp, #14
	mov	x0, x19
	mov	x1, x21
	bl	__ZNSt3__16__sortIRNS_6__lessIddEEPdEEvT0_S5_T_
Ltmp129:
; %bb.11:
	ldr	x20, [sp]                       ; 8-byte Folded Reload
	mov	x0, x20
	bl	_strlen
	mov	x2, x0
Ltmp130:
Lloh72:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh73:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
	mov	x1, x20
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp131:
; %bb.12:
Ltmp132:
Lloh74:
	adrp	x1, l_.str.11@PAGE
Lloh75:
	add	x1, x1, l_.str.11@PAGEOFF
	mov	w2, #18                         ; =0x12
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp133:
; %bb.13:
	ldr	d0, [x19, #32]
Ltmp134:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp135:
; %bb.14:
Ltmp136:
Lloh76:
	adrp	x1, l_.str.12@PAGE
Lloh77:
	add	x1, x1, l_.str.12@PAGEOFF
	mov	w2, #6                          ; =0x6
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp137:
; %bb.15:
	ldur	d0, [x21, #-8]
Ltmp138:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp139:
; %bb.16:
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #15]
Ltmp140:
	add	x1, sp, #15
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp141:
; %bb.17:
	mov	x0, x19
	bl	__ZdlPv
	ldp	x29, x30, [sp, #112]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #96]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #80]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #64]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #48]             ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #32]             ; 16-byte Folded Reload
	ldp	d9, d8, [sp, #16]               ; 16-byte Folded Reload
	add	sp, sp, #128
	ret
LBB4_18:
Ltmp125:
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_length_errorB9nqe210106Ev
Ltmp126:
	b	LBB4_20
LBB4_19:
Ltmp123:
	bl	__ZSt28__throw_bad_array_new_lengthB9nqe210106v
Ltmp124:
LBB4_20:
	brk	#0x1
LBB4_21:
Ltmp142:
	b	LBB4_24
LBB4_22:
Ltmp127:
	b	LBB4_24
LBB4_23:
Ltmp122:
LBB4_24:
	mov	x20, x0
	cbz	x19, LBB4_26
; %bb.25:
	mov	x0, x19
	bl	__ZdlPv
LBB4_26:
	mov	x0, x20
	bl	__Unwind_Resume
	.loh AdrpLdrGot	Lloh72, Lloh73
	.loh AdrpAdd	Lloh74, Lloh75
	.loh AdrpAdd	Lloh76, Lloh77
Lfunc_end3:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table4:
Lexception3:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end3-Lcst_begin3
Lcst_begin3:
	.uleb128 Lfunc_begin3-Lfunc_begin3      ; >> Call Site 1 <<
	.uleb128 Ltmp118-Lfunc_begin3           ;   Call between Lfunc_begin3 and Ltmp118
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp118-Lfunc_begin3           ; >> Call Site 2 <<
	.uleb128 Ltmp121-Ltmp118                ;   Call between Ltmp118 and Ltmp121
	.uleb128 Ltmp122-Lfunc_begin3           ;     jumps to Ltmp122
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp121-Lfunc_begin3           ; >> Call Site 3 <<
	.uleb128 Ltmp128-Ltmp121                ;   Call between Ltmp121 and Ltmp128
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp128-Lfunc_begin3           ; >> Call Site 4 <<
	.uleb128 Ltmp141-Ltmp128                ;   Call between Ltmp128 and Ltmp141
	.uleb128 Ltmp142-Lfunc_begin3           ;     jumps to Ltmp142
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp125-Lfunc_begin3           ; >> Call Site 5 <<
	.uleb128 Ltmp124-Ltmp125                ;   Call between Ltmp125 and Ltmp124
	.uleb128 Ltmp127-Lfunc_begin3           ;     jumps to Ltmp127
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp124-Lfunc_begin3           ; >> Call Site 6 <<
	.uleb128 Lfunc_end3-Ltmp124             ;   Call between Ltmp124 and Lfunc_end3
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end3:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__Z6reportI8IsolatedILi256EEEviiPKc ; -- Begin function _Z6reportI8IsolatedILi256EEEviiPKc
	.weak_def_can_be_hidden	__Z6reportI8IsolatedILi256EEEviiPKc
	.p2align	2
__Z6reportI8IsolatedILi256EEEviiPKc:    ; @_Z6reportI8IsolatedILi256EEEviiPKc
Lfunc_begin4:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception4
; %bb.0:
	sub	sp, sp, #128
	stp	d9, d8, [sp, #16]               ; 16-byte Folded Spill
	stp	x28, x27, [sp, #32]             ; 16-byte Folded Spill
	stp	x26, x25, [sp, #48]             ; 16-byte Folded Spill
	stp	x24, x23, [sp, #64]             ; 16-byte Folded Spill
	stp	x22, x21, [sp, #80]             ; 16-byte Folded Spill
	stp	x20, x19, [sp, #96]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #112]            ; 16-byte Folded Spill
	add	x29, sp, #112
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
	str	x2, [sp]                        ; 8-byte Folded Spill
	mov	x22, x1
	mov	x23, x0
	mov	w2, #0                          ; =0x0
	bl	__Z5trialI8IsolatedILi256EEEdiib
	mov	x0, x23
	mov	x1, x22
	mov	w2, #0                          ; =0x0
	bl	__Z5trialI8IsolatedILi256EEEdiib
	mov	x0, x23
	mov	x1, x22
	mov	w2, #0                          ; =0x0
	bl	__Z5trialI8IsolatedILi256EEEdiib
	mov	x19, #0                         ; =0x0
	mov	x20, #0                         ; =0x0
	mov	x21, #0                         ; =0x0
	mov	w26, #9                         ; =0x9
	mov	x27, #9223372036854775800       ; =0x7ffffffffffffff8
	mov	x28, #2305843009213693951       ; =0x1fffffffffffffff
	b	LBB5_2
LBB5_1:                                 ;   in Loop: Header=BB5_2 Depth=1
	str	d8, [x21], #8
	subs	w26, w26, #1
	b.eq	LBB5_10
LBB5_2:                                 ; =>This Inner Loop Header: Depth=1
	cmp	w26, #9
	cset	w2, eq
Ltmp143:
	mov	x0, x23
	mov	x1, x22
	bl	__Z5trialI8IsolatedILi256EEEdiib
Ltmp144:
; %bb.3:                                ;   in Loop: Header=BB5_2 Depth=1
	mov.16b	v8, v0
	cmp	x21, x20
	b.lo	LBB5_1
; %bb.4:                                ;   in Loop: Header=BB5_2 Depth=1
	sub	x24, x21, x19
	asr	x25, x24, #3
	add	x8, x25, #1
	lsr	x9, x8, #61
	cbnz	x9, LBB5_18
; %bb.5:                                ;   in Loop: Header=BB5_2 Depth=1
	sub	x9, x20, x19
	asr	x10, x9, #2
	cmp	x10, x8
	csel	x8, x10, x8, hi
	cmp	x9, x27
	csel	x20, x8, x28, lo
	lsr	x8, x20, #61
	cbnz	x8, LBB5_19
; %bb.6:                                ;   in Loop: Header=BB5_2 Depth=1
	lsl	x0, x20, #3
Ltmp145:
	bl	__Znwm
Ltmp146:
; %bb.7:                                ;   in Loop: Header=BB5_2 Depth=1
	add	x21, x0, x24
	add	x20, x0, x20, lsl #3
	sub	x25, x21, x25, lsl #3
	str	d8, [x21], #8
	mov	x0, x25
	mov	x1, x19
	mov	x2, x24
	bl	_memcpy
	cbz	x19, LBB5_9
; %bb.8:                                ;   in Loop: Header=BB5_2 Depth=1
	mov	x0, x19
	bl	__ZdlPv
LBB5_9:                                 ;   in Loop: Header=BB5_2 Depth=1
	mov	x19, x25
	subs	w26, w26, #1
	b.ne	LBB5_2
LBB5_10:
Ltmp153:
	add	x2, sp, #14
	mov	x0, x19
	mov	x1, x21
	bl	__ZNSt3__16__sortIRNS_6__lessIddEEPdEEvT0_S5_T_
Ltmp154:
; %bb.11:
	ldr	x20, [sp]                       ; 8-byte Folded Reload
	mov	x0, x20
	bl	_strlen
	mov	x2, x0
Ltmp155:
Lloh78:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh79:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
	mov	x1, x20
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp156:
; %bb.12:
Ltmp157:
Lloh80:
	adrp	x1, l_.str.11@PAGE
Lloh81:
	add	x1, x1, l_.str.11@PAGEOFF
	mov	w2, #18                         ; =0x12
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp158:
; %bb.13:
	ldr	d0, [x19, #32]
Ltmp159:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp160:
; %bb.14:
Ltmp161:
Lloh82:
	adrp	x1, l_.str.12@PAGE
Lloh83:
	add	x1, x1, l_.str.12@PAGEOFF
	mov	w2, #6                          ; =0x6
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp162:
; %bb.15:
	ldur	d0, [x21, #-8]
Ltmp163:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp164:
; %bb.16:
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #15]
Ltmp165:
	add	x1, sp, #15
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp166:
; %bb.17:
	mov	x0, x19
	bl	__ZdlPv
	ldp	x29, x30, [sp, #112]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #96]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #80]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #64]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #48]             ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #32]             ; 16-byte Folded Reload
	ldp	d9, d8, [sp, #16]               ; 16-byte Folded Reload
	add	sp, sp, #128
	ret
LBB5_18:
Ltmp150:
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_length_errorB9nqe210106Ev
Ltmp151:
	b	LBB5_20
LBB5_19:
Ltmp148:
	bl	__ZSt28__throw_bad_array_new_lengthB9nqe210106v
Ltmp149:
LBB5_20:
	brk	#0x1
LBB5_21:
Ltmp167:
	b	LBB5_24
LBB5_22:
Ltmp152:
	b	LBB5_24
LBB5_23:
Ltmp147:
LBB5_24:
	mov	x20, x0
	cbz	x19, LBB5_26
; %bb.25:
	mov	x0, x19
	bl	__ZdlPv
LBB5_26:
	mov	x0, x20
	bl	__Unwind_Resume
	.loh AdrpLdrGot	Lloh78, Lloh79
	.loh AdrpAdd	Lloh80, Lloh81
	.loh AdrpAdd	Lloh82, Lloh83
Lfunc_end4:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table5:
Lexception4:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end4-Lcst_begin4
Lcst_begin4:
	.uleb128 Lfunc_begin4-Lfunc_begin4      ; >> Call Site 1 <<
	.uleb128 Ltmp143-Lfunc_begin4           ;   Call between Lfunc_begin4 and Ltmp143
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp143-Lfunc_begin4           ; >> Call Site 2 <<
	.uleb128 Ltmp146-Ltmp143                ;   Call between Ltmp143 and Ltmp146
	.uleb128 Ltmp147-Lfunc_begin4           ;     jumps to Ltmp147
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp146-Lfunc_begin4           ; >> Call Site 3 <<
	.uleb128 Ltmp153-Ltmp146                ;   Call between Ltmp146 and Ltmp153
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp153-Lfunc_begin4           ; >> Call Site 4 <<
	.uleb128 Ltmp166-Ltmp153                ;   Call between Ltmp153 and Ltmp166
	.uleb128 Ltmp167-Lfunc_begin4           ;     jumps to Ltmp167
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp150-Lfunc_begin4           ; >> Call Site 5 <<
	.uleb128 Ltmp149-Ltmp150                ;   Call between Ltmp150 and Ltmp149
	.uleb128 Ltmp152-Lfunc_begin4           ;     jumps to Ltmp152
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp149-Lfunc_begin4           ; >> Call Site 6 <<
	.uleb128 Lfunc_end4-Ltmp149             ;   Call between Ltmp149 and Lfunc_end4
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end4:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__Z5trialI6PackedEdiib          ; -- Begin function _Z5trialI6PackedEdiib
	.weak_def_can_be_hidden	__Z5trialI6PackedEdiib
	.p2align	2
__Z5trialI6PackedEdiib:                 ; @_Z5trialI6PackedEdiib
Lfunc_begin5:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception5
; %bb.0:
	sub	sp, sp, #160
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
	stur	w1, [x29, #-68]
	sub	w8, w0, #9
	cmn	w8, #9
	b.ls	LBB6_42
; %bb.1:
	mov	x20, x2
	mov	x19, x0
	ubfiz	x21, x19, #3, #32
	mov	x0, x21
	bl	__Znwm
	add	x22, x0, x21
	str	x0, [sp, #48]
	str	x22, [sp, #64]
	mov	x1, x21
	bl	_bzero
	str	x22, [sp, #56]
	stp	xzr, xzr, [sp, #24]
	str	xzr, [sp, #40]
Ltmp168:
	mov	x0, x21
	bl	__Znwm
Ltmp169:
; %bb.2:
	mov	w22, w19
	add	x8, x0, x22, lsl #3
	stp	x0, x0, [sp, #24]
	str	x8, [sp, #40]
	tbz	w20, #0, LBB6_24
; %bb.3:
Ltmp170:
Lloh84:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh85:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh86:
	adrp	x1, l_.str.15@PAGE
Lloh87:
	add	x1, x1, l_.str.15@PAGEOFF
	mov	w2, #7                          ; =0x7
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp171:
; %bb.4:
Ltmp172:
	mov	w1, #8                          ; =0x8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp173:
; %bb.5:
Ltmp174:
Lloh88:
	adrp	x1, l_.str.16@PAGE
Lloh89:
	add	x1, x1, l_.str.16@PAGEOFF
	mov	w2, #9                          ; =0x9
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp175:
; %bb.6:
Ltmp176:
	mov	x1, x19
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEi
Ltmp177:
; %bb.7:
Ltmp178:
Lloh90:
	adrp	x1, l_.str.17@PAGE
Lloh91:
	add	x1, x1, l_.str.17@PAGEOFF
	mov	w2, #6                          ; =0x6
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp179:
; %bb.8:
	ldur	w1, [x29, #-68]
Ltmp180:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEi
Ltmp181:
; %bb.9:
Ltmp182:
Lloh92:
	adrp	x1, l_.str.18@PAGE
Lloh93:
	add	x1, x1, l_.str.18@PAGEOFF
	mov	w2, #10                         ; =0xa
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp183:
; %bb.10:
	ldp	x20, x23, [sp, #48]
	cmp	x20, x23
	b.eq	LBB6_15
; %bb.11:
	mov	w24, #32                        ; =0x20
Lloh94:
	adrp	x21, __ZNSt3__14coutE@GOTPAGE
Lloh95:
	ldr	x21, [x21, __ZNSt3__14coutE@GOTPAGEOFF]
LBB6_12:                                ; =>This Inner Loop Header: Depth=1
	strb	w24, [sp]
Ltmp184:
	mov	x1, sp
	mov	x0, x21
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp185:
; %bb.13:                               ;   in Loop: Header=BB6_12 Depth=1
Ltmp186:
	mov	x1, x20
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEPKv
Ltmp187:
; %bb.14:                               ;   in Loop: Header=BB6_12 Depth=1
	add	x20, x20, #8
	cmp	x20, x23
	b.ne	LBB6_12
LBB6_15:
	mov	w8, #10                         ; =0xa
	strb	w8, [sp]
Ltmp189:
Lloh96:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh97:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
	mov	x1, sp
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp190:
; %bb.16:
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x20, x0
	cmp	w19, #0
	b.gt	LBB6_25
; %bb.17:
	ldr	x21, [sp, #32]
LBB6_18:
	ldr	x19, [sp, #24]
	cmp	x19, x21
	b.eq	LBB6_21
LBB6_19:                                ; =>This Inner Loop Header: Depth=1
Ltmp207:
	mov	x0, x19
	bl	__ZNSt3__16thread4joinEv
Ltmp208:
; %bb.20:                               ;   in Loop: Header=BB6_19 Depth=1
	add	x19, x19, #8
	cmp	x19, x21
	b.ne	LBB6_19
LBB6_21:
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x19, x0
	ldp	x0, x9, [sp, #48]
	cmp	x0, x9
	b.eq	LBB6_32
; %bb.22:
	mov	x8, #0                          ; =0x0
	mov	x10, x0
LBB6_23:                                ; =>This Inner Loop Header: Depth=1
	ldr	x11, [x10], #8
	add	x8, x11, x8
	cmp	x10, x9
	b.ne	LBB6_23
	b	LBB6_33
LBB6_24:
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x20, x0
LBB6_25:
	mov	w23, #0                         ; =0x0
	ldr	x21, [sp, #32]
	sub	x24, x29, #68
	add	x25, sp, #48
	b	LBB6_27
LBB6_26:                                ;   in Loop: Header=BB6_27 Depth=1
	str	x21, [sp, #32]
	add	w23, w23, #1
	cmp	w19, w23
	b.eq	LBB6_18
LBB6_27:                                ; =>This Inner Loop Header: Depth=1
	str	w23, [sp]
	stp	x24, x25, [sp, #8]
	ldr	x8, [sp, #40]
	cmp	x21, x8
	b.hs	LBB6_30
; %bb.28:                               ;   in Loop: Header=BB6_27 Depth=1
Ltmp195:
	mov	x1, sp
	mov	x0, x21
	bl	__ZNSt3__16threadC2B9nqe210106IZ5trialI6PackedEdiibEUlvE_JELi0EEEOT_DpOT0_
Ltmp196:
; %bb.29:                               ;   in Loop: Header=BB6_27 Depth=1
	add	x21, x21, #8
	b	LBB6_26
LBB6_30:                                ;   in Loop: Header=BB6_27 Depth=1
Ltmp192:
	add	x0, sp, #24
	mov	x1, sp
	bl	__ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEE24__emplace_back_slow_pathIJZ5trialI6PackedEdiibEUlvE_EEEPS1_DpOT_
Ltmp193:
; %bb.31:                               ;   in Loop: Header=BB6_27 Depth=1
	mov	x21, x0
	b	LBB6_26
LBB6_32:
	mov	x8, #0                          ; =0x0
LBB6_33:
	mov	w9, #34464                      ; =0x86a0
	movk	w9, #1, lsl #16
	umull	x9, w22, w9
	cmp	x8, x9
	b.ne	LBB6_44
; %bb.34:
	ldr	x21, [sp, #24]
	cbz	x21, LBB6_39
; %bb.35:
	ldr	x0, [sp, #32]
	mov	x8, x21
	cmp	x21, x0
	b.eq	LBB6_38
LBB6_36:                                ; =>This Inner Loop Header: Depth=1
	sub	x0, x0, #8
	bl	__ZNSt3__16threadD1Ev
	cmp	x0, x21
	b.ne	LBB6_36
; %bb.37:
	ldr	x8, [sp, #24]
LBB6_38:
	str	x21, [sp, #32]
	mov	x0, x8
	bl	__ZdlPv
	ldr	x0, [sp, #48]
LBB6_39:
	cbz	x0, LBB6_41
; %bb.40:
	str	x0, [sp, #56]
	bl	__ZdlPv
LBB6_41:
	sub	x8, x19, x20
	scvtf	d0, x8
	mov	x8, #145685290680320            ; =0x848000000000
	movk	x8, #16686, lsl #48
	fmov	d1, x8
	fdiv	d0, d0, d1
	ldp	x29, x30, [sp, #144]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #128]            ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #112]            ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #96]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #80]             ; 16-byte Folded Reload
	add	sp, sp, #160
	ret
LBB6_42:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x20, x0
Ltmp216:
Lloh98:
	adrp	x1, l_.str.14@PAGE
Lloh99:
	add	x1, x1, l_.str.14@PAGEOFF
	bl	__ZNSt16invalid_argumentC1B9nqe210106EPKc
Ltmp217:
; %bb.43:
	mov	x0, x20
	bl	__Z5trialI6PackedEdiib.cold.1
LBB6_44:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x20, x0
Ltmp210:
Lloh100:
	adrp	x1, l_.str.19@PAGE
Lloh101:
	add	x1, x1, l_.str.19@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp211:
; %bb.45:
Ltmp213:
Lloh102:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh103:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh104:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh105:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x20
	bl	___cxa_throw
Ltmp214:
	b	LBB6_56
LBB6_46:
Ltmp215:
	b	LBB6_63
LBB6_47:
Ltmp212:
	mov	x19, x0
	mov	x0, x20
	bl	___cxa_free_exception
	b	LBB6_64
LBB6_48:
Ltmp218:
	mov	x19, x0
	mov	x0, x20
	bl	___cxa_free_exception
	mov	x0, x19
	bl	__Unwind_Resume
LBB6_49:
Ltmp191:
	b	LBB6_63
LBB6_50:
Ltmp194:
	b	LBB6_52
LBB6_51:
Ltmp197:
	str	x21, [sp, #32]
LBB6_52:
	bl	___cxa_begin_catch
	ldp	x19, x20, [sp, #24]
	cmp	x19, x20
	b.eq	LBB6_55
LBB6_53:                                ; =>This Inner Loop Header: Depth=1
Ltmp198:
	mov	x0, x19
	bl	__ZNSt3__16thread4joinEv
Ltmp199:
; %bb.54:                               ;   in Loop: Header=BB6_53 Depth=1
	add	x19, x19, #8
	cmp	x19, x20
	b.ne	LBB6_53
LBB6_55:
Ltmp201:
	bl	___cxa_rethrow
Ltmp202:
LBB6_56:
	brk	#0x1
LBB6_57:
Ltmp200:
	b	LBB6_59
LBB6_58:
Ltmp203:
LBB6_59:
	mov	x19, x0
Ltmp204:
	bl	___cxa_end_catch
Ltmp205:
	b	LBB6_64
LBB6_60:
Ltmp206:
	bl	___clang_call_terminate
LBB6_61:
Ltmp209:
	b	LBB6_63
LBB6_62:
Ltmp188:
LBB6_63:
	mov	x19, x0
LBB6_64:
	add	x0, sp, #24
	bl	__ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEED1B9nqe210106Ev
	ldr	x0, [sp, #48]
	cbnz	x0, LBB6_66
; %bb.65:
	mov	x0, x19
	bl	__Unwind_Resume
LBB6_66:
	str	x0, [sp, #56]
	bl	__ZdlPv
	mov	x0, x19
	bl	__Unwind_Resume
	.loh AdrpAdd	Lloh86, Lloh87
	.loh AdrpLdrGot	Lloh84, Lloh85
	.loh AdrpAdd	Lloh88, Lloh89
	.loh AdrpAdd	Lloh90, Lloh91
	.loh AdrpAdd	Lloh92, Lloh93
	.loh AdrpLdrGot	Lloh94, Lloh95
	.loh AdrpLdrGot	Lloh96, Lloh97
	.loh AdrpAdd	Lloh98, Lloh99
	.loh AdrpAdd	Lloh100, Lloh101
	.loh AdrpLdrGot	Lloh104, Lloh105
	.loh AdrpLdrGot	Lloh102, Lloh103
Lfunc_end5:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table6:
Lexception5:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase1-Lttbaseref1
Lttbaseref1:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end5-Lcst_begin5
Lcst_begin5:
	.uleb128 Lfunc_begin5-Lfunc_begin5      ; >> Call Site 1 <<
	.uleb128 Ltmp168-Lfunc_begin5           ;   Call between Lfunc_begin5 and Ltmp168
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp168-Lfunc_begin5           ; >> Call Site 2 <<
	.uleb128 Ltmp183-Ltmp168                ;   Call between Ltmp168 and Ltmp183
	.uleb128 Ltmp191-Lfunc_begin5           ;     jumps to Ltmp191
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp184-Lfunc_begin5           ; >> Call Site 3 <<
	.uleb128 Ltmp187-Ltmp184                ;   Call between Ltmp184 and Ltmp187
	.uleb128 Ltmp188-Lfunc_begin5           ;     jumps to Ltmp188
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp189-Lfunc_begin5           ; >> Call Site 4 <<
	.uleb128 Ltmp190-Ltmp189                ;   Call between Ltmp189 and Ltmp190
	.uleb128 Ltmp191-Lfunc_begin5           ;     jumps to Ltmp191
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp207-Lfunc_begin5           ; >> Call Site 5 <<
	.uleb128 Ltmp208-Ltmp207                ;   Call between Ltmp207 and Ltmp208
	.uleb128 Ltmp209-Lfunc_begin5           ;     jumps to Ltmp209
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp195-Lfunc_begin5           ; >> Call Site 6 <<
	.uleb128 Ltmp196-Ltmp195                ;   Call between Ltmp195 and Ltmp196
	.uleb128 Ltmp197-Lfunc_begin5           ;     jumps to Ltmp197
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp192-Lfunc_begin5           ; >> Call Site 7 <<
	.uleb128 Ltmp193-Ltmp192                ;   Call between Ltmp192 and Ltmp193
	.uleb128 Ltmp194-Lfunc_begin5           ;     jumps to Ltmp194
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp193-Lfunc_begin5           ; >> Call Site 8 <<
	.uleb128 Ltmp216-Ltmp193                ;   Call between Ltmp193 and Ltmp216
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp216-Lfunc_begin5           ; >> Call Site 9 <<
	.uleb128 Ltmp217-Ltmp216                ;   Call between Ltmp216 and Ltmp217
	.uleb128 Ltmp218-Lfunc_begin5           ;     jumps to Ltmp218
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp217-Lfunc_begin5           ; >> Call Site 10 <<
	.uleb128 Ltmp210-Ltmp217                ;   Call between Ltmp217 and Ltmp210
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp210-Lfunc_begin5           ; >> Call Site 11 <<
	.uleb128 Ltmp211-Ltmp210                ;   Call between Ltmp210 and Ltmp211
	.uleb128 Ltmp212-Lfunc_begin5           ;     jumps to Ltmp212
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp213-Lfunc_begin5           ; >> Call Site 12 <<
	.uleb128 Ltmp214-Ltmp213                ;   Call between Ltmp213 and Ltmp214
	.uleb128 Ltmp215-Lfunc_begin5           ;     jumps to Ltmp215
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp214-Lfunc_begin5           ; >> Call Site 13 <<
	.uleb128 Ltmp198-Ltmp214                ;   Call between Ltmp214 and Ltmp198
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp198-Lfunc_begin5           ; >> Call Site 14 <<
	.uleb128 Ltmp199-Ltmp198                ;   Call between Ltmp198 and Ltmp199
	.uleb128 Ltmp200-Lfunc_begin5           ;     jumps to Ltmp200
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp201-Lfunc_begin5           ; >> Call Site 15 <<
	.uleb128 Ltmp202-Ltmp201                ;   Call between Ltmp201 and Ltmp202
	.uleb128 Ltmp203-Lfunc_begin5           ;     jumps to Ltmp203
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp204-Lfunc_begin5           ; >> Call Site 16 <<
	.uleb128 Ltmp205-Ltmp204                ;   Call between Ltmp204 and Ltmp205
	.uleb128 Ltmp206-Lfunc_begin5           ;     jumps to Ltmp206
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp205-Lfunc_begin5           ; >> Call Site 17 <<
	.uleb128 Lfunc_end5-Ltmp205             ;   Call between Ltmp205 and Lfunc_end5
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
Ltmp219:
	add	x0, sp, #8
	mov	x1, x19
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryC1ERS3_
Ltmp220:
; %bb.1:
	ldrb	w8, [sp, #8]
	cmp	w8, #1
	b.ne	LBB8_10
; %bb.2:
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
	add	x4, x19, x8
	ldr	x22, [x4, #40]
	ldr	w24, [x4, #8]
	ldr	w23, [x4, #144]
	cmn	w23, #1
	b.ne	LBB8_7
; %bb.3:
Ltmp222:
	add	x8, sp, #24
	mov	x25, x4
	mov	x0, x4
	bl	__ZNKSt3__18ios_base6getlocEv
Ltmp223:
; %bb.4:
Ltmp224:
Lloh106:
	adrp	x1, __ZNSt3__15ctypeIcE2idE@GOTPAGE
Lloh107:
	ldr	x1, [x1, __ZNSt3__15ctypeIcE2idE@GOTPAGEOFF]
	add	x0, sp, #24
	bl	__ZNKSt3__16locale9use_facetERNS0_2idE
Ltmp225:
; %bb.5:
	ldr	x8, [x0]
	ldr	x8, [x8, #56]
Ltmp226:
	mov	w1, #32                         ; =0x20
	blr	x8
Ltmp227:
; %bb.6:
	mov	x23, x0
	add	x0, sp, #24
	bl	__ZNSt3__16localeD1Ev
	mov	x4, x25
	str	w23, [x25, #144]
LBB8_7:
	mov	w8, #176                        ; =0xb0
	and	w8, w24, w8
	add	x3, x20, x21
	cmp	w8, #32
	csel	x2, x3, x20, eq
Ltmp229:
	sxtb	w5, w23
	mov	x0, x22
	mov	x1, x20
	bl	__ZNSt3__116__pad_and_outputB9nqe210106IcNS_11char_traitsIcEEEENS_19ostreambuf_iteratorIT_T0_EES6_PKS4_S8_S8_RNS_8ios_baseES4_
Ltmp230:
; %bb.8:
	cbnz	x0, LBB8_10
; %bb.9:
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
	add	x0, x19, x8
	ldr	w8, [x0, #32]
	mov	w9, #5                          ; =0x5
Ltmp232:
	orr	w1, w8, w9
	bl	__ZNSt3__18ios_base5clearEj
Ltmp233:
LBB8_10:
	add	x0, sp, #8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryD1Ev
LBB8_11:
	mov	x0, x19
	ldp	x29, x30, [sp, #96]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #80]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #64]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #48]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #112
	ret
LBB8_12:
Ltmp234:
	b	LBB8_15
LBB8_13:
Ltmp228:
	mov	x20, x0
	add	x0, sp, #24
	bl	__ZNSt3__16localeD1Ev
	b	LBB8_16
LBB8_14:
Ltmp231:
LBB8_15:
	mov	x20, x0
LBB8_16:
	add	x0, sp, #8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryD1Ev
	b	LBB8_18
LBB8_17:
Ltmp221:
	mov	x20, x0
LBB8_18:
	mov	x0, x20
	bl	___cxa_begin_catch
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
Ltmp235:
	add	x0, x19, x8
	bl	__ZNSt3__18ios_base33__set_badbit_and_consider_rethrowEv
Ltmp236:
; %bb.19:
	bl	___cxa_end_catch
	b	LBB8_11
LBB8_20:
Ltmp237:
	mov	x19, x0
Ltmp238:
	bl	___cxa_end_catch
Ltmp239:
; %bb.21:
	mov	x0, x19
	bl	__Unwind_Resume
LBB8_22:
Ltmp240:
	bl	___clang_call_terminate
	.loh AdrpLdrGot	Lloh106, Lloh107
Lfunc_end6:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table8:
Lexception6:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase2-Lttbaseref2
Lttbaseref2:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end6-Lcst_begin6
Lcst_begin6:
	.uleb128 Ltmp219-Lfunc_begin6           ; >> Call Site 1 <<
	.uleb128 Ltmp220-Ltmp219                ;   Call between Ltmp219 and Ltmp220
	.uleb128 Ltmp221-Lfunc_begin6           ;     jumps to Ltmp221
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp222-Lfunc_begin6           ; >> Call Site 2 <<
	.uleb128 Ltmp223-Ltmp222                ;   Call between Ltmp222 and Ltmp223
	.uleb128 Ltmp231-Lfunc_begin6           ;     jumps to Ltmp231
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp224-Lfunc_begin6           ; >> Call Site 3 <<
	.uleb128 Ltmp227-Ltmp224                ;   Call between Ltmp224 and Ltmp227
	.uleb128 Ltmp228-Lfunc_begin6           ;     jumps to Ltmp228
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp229-Lfunc_begin6           ; >> Call Site 4 <<
	.uleb128 Ltmp230-Ltmp229                ;   Call between Ltmp229 and Ltmp230
	.uleb128 Ltmp231-Lfunc_begin6           ;     jumps to Ltmp231
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp232-Lfunc_begin6           ; >> Call Site 5 <<
	.uleb128 Ltmp233-Ltmp232                ;   Call between Ltmp232 and Ltmp233
	.uleb128 Ltmp234-Lfunc_begin6           ;     jumps to Ltmp234
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp233-Lfunc_begin6           ; >> Call Site 6 <<
	.uleb128 Ltmp235-Ltmp233                ;   Call between Ltmp233 and Ltmp235
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp235-Lfunc_begin6           ; >> Call Site 7 <<
	.uleb128 Ltmp236-Ltmp235                ;   Call between Ltmp235 and Ltmp236
	.uleb128 Ltmp237-Lfunc_begin6           ;     jumps to Ltmp237
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp236-Lfunc_begin6           ; >> Call Site 8 <<
	.uleb128 Ltmp238-Ltmp236                ;   Call between Ltmp236 and Ltmp238
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp238-Lfunc_begin6           ; >> Call Site 9 <<
	.uleb128 Ltmp239-Ltmp238                ;   Call between Ltmp238 and Ltmp239
	.uleb128 Ltmp240-Lfunc_begin6           ;     jumps to Ltmp240
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp239-Lfunc_begin6           ; >> Call Site 10 <<
	.uleb128 Lfunc_end6-Ltmp239             ;   Call between Ltmp239 and Lfunc_end6
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end6:
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
	cbz	x0, LBB9_16
; %bb.1:
	mov	x23, x5
	mov	x20, x4
	mov	x22, x3
	mov	x21, x2
	mov	x24, x1
	ldr	x26, [x4, #24]
	sub	x25, x2, x1
	cmp	x25, #1
	b.lt	LBB9_3
; %bb.2:
	ldr	x8, [x19]
	ldr	x8, [x8, #96]
	mov	x0, x19
	mov	x1, x24
	mov	x2, x25
	blr	x8
	cmp	x0, x25
	b.ne	LBB9_15
LBB9_3:
	sub	x8, x22, x24
	cmp	x26, x8
	b.le	LBB9_12
; %bb.4:
	mov	x9, #-9                         ; =0xfffffffffffffff7
	movk	x9, #32767, lsl #48
	sub	x24, x26, x8
	cmp	x24, x9
	b.hs	LBB9_17
; %bb.5:
	cmp	x24, #23
	b.hs	LBB9_7
; %bb.6:
	strb	w24, [sp, #31]
	add	x25, sp, #8
	b	LBB9_8
LBB9_7:
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
LBB9_8:
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
Ltmp241:
	mov	x0, x19
	mov	x2, x24
	blr	x8
Ltmp242:
; %bb.9:
	ldrsb	w8, [sp, #31]
	tbnz	w8, #31, LBB9_11
; %bb.10:
	cmp	x0, x24
	b.ne	LBB9_15
	b	LBB9_12
LBB9_11:
	ldr	x8, [sp, #8]
	mov	x23, x0
	mov	x0, x8
	bl	__ZdlPv
	mov	x0, x23
	cmp	x0, x24
	b.ne	LBB9_15
LBB9_12:
	sub	x22, x22, x21
	cmp	x22, #1
	b.lt	LBB9_14
; %bb.13:
	ldr	x8, [x19]
	ldr	x8, [x8, #96]
	mov	x0, x19
	mov	x1, x21
	mov	x2, x22
	blr	x8
	cmp	x0, x22
	b.ne	LBB9_15
LBB9_14:
	str	xzr, [x20, #24]
	b	LBB9_16
LBB9_15:
	mov	x19, #0                         ; =0x0
LBB9_16:
	mov	x0, x19
	ldp	x29, x30, [sp, #96]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #80]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #64]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #48]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #112
	ret
LBB9_17:
	bl	__ZNSt3__112basic_stringIcNS_11char_traitsIcEENS_9allocatorIcEEE20__throw_length_errorB9nqe210106Ev
LBB9_18:
Ltmp243:
	mov	x19, x0
	ldrsb	w8, [sp, #31]
	tbz	w8, #31, LBB9_20
; %bb.19:
	ldr	x0, [sp, #8]
	bl	__ZdlPv
LBB9_20:
	mov	x0, x19
	bl	__Unwind_Resume
Lfunc_end7:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table9:
Lexception7:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end7-Lcst_begin7
Lcst_begin7:
	.uleb128 Lfunc_begin7-Lfunc_begin7      ; >> Call Site 1 <<
	.uleb128 Ltmp241-Lfunc_begin7           ;   Call between Lfunc_begin7 and Ltmp241
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp241-Lfunc_begin7           ; >> Call Site 2 <<
	.uleb128 Ltmp242-Ltmp241                ;   Call between Ltmp241 and Ltmp242
	.uleb128 Ltmp243-Lfunc_begin7           ;     jumps to Ltmp243
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp242-Lfunc_begin7           ; >> Call Site 3 <<
	.uleb128 Lfunc_end7-Ltmp242             ;   Call between Ltmp242 and Lfunc_end7
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end7:
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
Lloh108:
	adrp	x0, l_.str.10@PAGE
Lloh109:
	add	x0, x0, l_.str.10@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh108, Lloh109
	.cfi_endproc
                                        ; -- End function
	.private_extern	__ZNSt3__120__throw_length_errorB9nqe210106EPKc ; -- Begin function _ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.globl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.weak_def_can_be_hidden	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.p2align	2
__ZNSt3__120__throw_length_errorB9nqe210106EPKc: ; @_ZNSt3__120__throw_length_errorB9nqe210106EPKc
Lfunc_begin8:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception8
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
Ltmp244:
	mov	x1, x20
	bl	__ZNSt12length_errorC1B9nqe210106EPKc
Ltmp245:
; %bb.1:
Lloh110:
	adrp	x1, __ZTISt12length_error@GOTPAGE
Lloh111:
	ldr	x1, [x1, __ZTISt12length_error@GOTPAGEOFF]
Lloh112:
	adrp	x2, __ZNSt12length_errorD1Ev@GOTPAGE
Lloh113:
	ldr	x2, [x2, __ZNSt12length_errorD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
LBB11_2:
Ltmp246:
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x0, x20
	bl	__Unwind_Resume
	.loh AdrpLdrGot	Lloh112, Lloh113
	.loh AdrpLdrGot	Lloh110, Lloh111
Lfunc_end8:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table11:
Lexception8:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end8-Lcst_begin8
Lcst_begin8:
	.uleb128 Lfunc_begin8-Lfunc_begin8      ; >> Call Site 1 <<
	.uleb128 Ltmp244-Lfunc_begin8           ;   Call between Lfunc_begin8 and Ltmp244
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp244-Lfunc_begin8           ; >> Call Site 2 <<
	.uleb128 Ltmp245-Ltmp244                ;   Call between Ltmp244 and Ltmp245
	.uleb128 Ltmp246-Lfunc_begin8           ;     jumps to Ltmp246
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp245-Lfunc_begin8           ; >> Call Site 3 <<
	.uleb128 Lfunc_end8-Ltmp245             ;   Call between Ltmp245 and Lfunc_end8
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end8:
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
Lloh114:
	adrp	x8, __ZTVSt12length_error@GOTPAGE
Lloh115:
	ldr	x8, [x8, __ZTVSt12length_error@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x0]
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
	.loh AdrpLdrGot	Lloh114, Lloh115
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
Lloh116:
	adrp	x1, __ZTISt20bad_array_new_length@GOTPAGE
Lloh117:
	ldr	x1, [x1, __ZTISt20bad_array_new_length@GOTPAGEOFF]
Lloh118:
	adrp	x2, __ZNSt20bad_array_new_lengthD1Ev@GOTPAGE
Lloh119:
	ldr	x2, [x2, __ZNSt20bad_array_new_lengthD1Ev@GOTPAGEOFF]
	bl	___cxa_throw
	.loh AdrpLdrGot	Lloh118, Lloh119
	.loh AdrpLdrGot	Lloh116, Lloh117
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
Lloh120:
	adrp	x0, l_.str.13@PAGE
Lloh121:
	add	x0, x0, l_.str.13@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh120, Lloh121
	.cfi_endproc
                                        ; -- End function
	.globl	__Z5trialI8IsolatedILi64EEEdiib ; -- Begin function _Z5trialI8IsolatedILi64EEEdiib
	.weak_def_can_be_hidden	__Z5trialI8IsolatedILi64EEEdiib
	.p2align	2
__Z5trialI8IsolatedILi64EEEdiib:        ; @_Z5trialI8IsolatedILi64EEEdiib
Lfunc_begin9:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception9
; %bb.0:
	sub	sp, sp, #160
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
	stur	w1, [x29, #-68]
	sub	w8, w0, #9
	cmn	w8, #9
	b.ls	LBB15_42
; %bb.1:
	mov	x20, x2
	mov	x19, x0
	ubfiz	x21, x19, #6, #32
	mov	x0, x21
	mov	w1, #64                         ; =0x40
	bl	__ZnwmSt11align_val_t
	add	x22, x0, x21
	str	x0, [sp, #48]
	str	x22, [sp, #64]
	mov	x1, x21
	bl	_bzero
	str	x22, [sp, #56]
	stp	xzr, xzr, [sp, #24]
	ubfiz	x0, x19, #3, #32
	str	xzr, [sp, #40]
Ltmp247:
	bl	__Znwm
Ltmp248:
; %bb.2:
	mov	w22, w19
	add	x8, x0, x22, lsl #3
	stp	x0, x0, [sp, #24]
	str	x8, [sp, #40]
	tbz	w20, #0, LBB15_24
; %bb.3:
Ltmp249:
Lloh122:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh123:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh124:
	adrp	x1, l_.str.15@PAGE
Lloh125:
	add	x1, x1, l_.str.15@PAGEOFF
	mov	w2, #7                          ; =0x7
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp250:
; %bb.4:
Ltmp251:
	mov	w1, #64                         ; =0x40
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp252:
; %bb.5:
Ltmp253:
Lloh126:
	adrp	x1, l_.str.16@PAGE
Lloh127:
	add	x1, x1, l_.str.16@PAGEOFF
	mov	w2, #9                          ; =0x9
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp254:
; %bb.6:
Ltmp255:
	mov	x1, x19
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEi
Ltmp256:
; %bb.7:
Ltmp257:
Lloh128:
	adrp	x1, l_.str.17@PAGE
Lloh129:
	add	x1, x1, l_.str.17@PAGEOFF
	mov	w2, #6                          ; =0x6
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp258:
; %bb.8:
	ldur	w1, [x29, #-68]
Ltmp259:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEi
Ltmp260:
; %bb.9:
Ltmp261:
Lloh130:
	adrp	x1, l_.str.18@PAGE
Lloh131:
	add	x1, x1, l_.str.18@PAGEOFF
	mov	w2, #10                         ; =0xa
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp262:
; %bb.10:
	ldp	x20, x23, [sp, #48]
	cmp	x20, x23
	b.eq	LBB15_15
; %bb.11:
	mov	w24, #32                        ; =0x20
Lloh132:
	adrp	x21, __ZNSt3__14coutE@GOTPAGE
Lloh133:
	ldr	x21, [x21, __ZNSt3__14coutE@GOTPAGEOFF]
LBB15_12:                               ; =>This Inner Loop Header: Depth=1
	strb	w24, [sp]
Ltmp263:
	mov	x1, sp
	mov	x0, x21
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp264:
; %bb.13:                               ;   in Loop: Header=BB15_12 Depth=1
Ltmp265:
	mov	x1, x20
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEPKv
Ltmp266:
; %bb.14:                               ;   in Loop: Header=BB15_12 Depth=1
	add	x20, x20, #64
	cmp	x20, x23
	b.ne	LBB15_12
LBB15_15:
	mov	w8, #10                         ; =0xa
	strb	w8, [sp]
Ltmp268:
Lloh134:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh135:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
	mov	x1, sp
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp269:
; %bb.16:
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x20, x0
	cmp	w19, #0
	b.gt	LBB15_25
; %bb.17:
	ldr	x21, [sp, #32]
LBB15_18:
	ldr	x19, [sp, #24]
	cmp	x19, x21
	b.eq	LBB15_21
LBB15_19:                               ; =>This Inner Loop Header: Depth=1
Ltmp286:
	mov	x0, x19
	bl	__ZNSt3__16thread4joinEv
Ltmp287:
; %bb.20:                               ;   in Loop: Header=BB15_19 Depth=1
	add	x19, x19, #8
	cmp	x19, x21
	b.ne	LBB15_19
LBB15_21:
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x19, x0
	ldp	x0, x9, [sp, #48]
	cmp	x0, x9
	b.eq	LBB15_32
; %bb.22:
	mov	x8, #0                          ; =0x0
	mov	x10, x0
LBB15_23:                               ; =>This Inner Loop Header: Depth=1
	ldr	x11, [x10], #64
	add	x8, x11, x8
	cmp	x10, x9
	b.ne	LBB15_23
	b	LBB15_33
LBB15_24:
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x20, x0
LBB15_25:
	mov	w23, #0                         ; =0x0
	ldr	x21, [sp, #32]
	sub	x24, x29, #68
	add	x25, sp, #48
	b	LBB15_27
LBB15_26:                               ;   in Loop: Header=BB15_27 Depth=1
	str	x21, [sp, #32]
	add	w23, w23, #1
	cmp	w19, w23
	b.eq	LBB15_18
LBB15_27:                               ; =>This Inner Loop Header: Depth=1
	str	w23, [sp]
	stp	x24, x25, [sp, #8]
	ldr	x8, [sp, #40]
	cmp	x21, x8
	b.hs	LBB15_30
; %bb.28:                               ;   in Loop: Header=BB15_27 Depth=1
Ltmp274:
	mov	x1, sp
	mov	x0, x21
	bl	__ZNSt3__16threadC2B9nqe210106IZ5trialI8IsolatedILi64EEEdiibEUlvE_JELi0EEEOT_DpOT0_
Ltmp275:
; %bb.29:                               ;   in Loop: Header=BB15_27 Depth=1
	add	x21, x21, #8
	b	LBB15_26
LBB15_30:                               ;   in Loop: Header=BB15_27 Depth=1
Ltmp271:
	add	x0, sp, #24
	mov	x1, sp
	bl	__ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEE24__emplace_back_slow_pathIJZ5trialI8IsolatedILi64EEEdiibEUlvE_EEEPS1_DpOT_
Ltmp272:
; %bb.31:                               ;   in Loop: Header=BB15_27 Depth=1
	mov	x21, x0
	b	LBB15_26
LBB15_32:
	mov	x8, #0                          ; =0x0
LBB15_33:
	mov	w9, #34464                      ; =0x86a0
	movk	w9, #1, lsl #16
	umull	x9, w22, w9
	cmp	x8, x9
	b.ne	LBB15_44
; %bb.34:
	ldr	x21, [sp, #24]
	cbz	x21, LBB15_39
; %bb.35:
	ldr	x0, [sp, #32]
	mov	x8, x21
	cmp	x21, x0
	b.eq	LBB15_38
LBB15_36:                               ; =>This Inner Loop Header: Depth=1
	sub	x0, x0, #8
	bl	__ZNSt3__16threadD1Ev
	cmp	x0, x21
	b.ne	LBB15_36
; %bb.37:
	ldr	x8, [sp, #24]
LBB15_38:
	str	x21, [sp, #32]
	mov	x0, x8
	bl	__ZdlPv
	ldr	x0, [sp, #48]
LBB15_39:
	cbz	x0, LBB15_41
; %bb.40:
	str	x0, [sp, #56]
	mov	w1, #64                         ; =0x40
	bl	__ZdlPvSt11align_val_t
LBB15_41:
	sub	x8, x19, x20
	scvtf	d0, x8
	mov	x8, #145685290680320            ; =0x848000000000
	movk	x8, #16686, lsl #48
	fmov	d1, x8
	fdiv	d0, d0, d1
	ldp	x29, x30, [sp, #144]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #128]            ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #112]            ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #96]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #80]             ; 16-byte Folded Reload
	add	sp, sp, #160
	ret
LBB15_42:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x20, x0
Ltmp295:
Lloh136:
	adrp	x1, l_.str.14@PAGE
Lloh137:
	add	x1, x1, l_.str.14@PAGEOFF
	bl	__ZNSt16invalid_argumentC1B9nqe210106EPKc
Ltmp296:
; %bb.43:
	mov	x0, x20
	bl	__Z5trialI8IsolatedILi64EEEdiib.cold.1
LBB15_44:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x20, x0
Ltmp289:
Lloh138:
	adrp	x1, l_.str.19@PAGE
Lloh139:
	add	x1, x1, l_.str.19@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp290:
; %bb.45:
Ltmp292:
Lloh140:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh141:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh142:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh143:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x20
	bl	___cxa_throw
Ltmp293:
	b	LBB15_56
LBB15_46:
Ltmp294:
	b	LBB15_63
LBB15_47:
Ltmp291:
	mov	x19, x0
	mov	x0, x20
	bl	___cxa_free_exception
	b	LBB15_64
LBB15_48:
Ltmp297:
	mov	x19, x0
	mov	x0, x20
	bl	___cxa_free_exception
	mov	x0, x19
	bl	__Unwind_Resume
LBB15_49:
Ltmp270:
	b	LBB15_63
LBB15_50:
Ltmp273:
	b	LBB15_52
LBB15_51:
Ltmp276:
	str	x21, [sp, #32]
LBB15_52:
	bl	___cxa_begin_catch
	ldp	x19, x20, [sp, #24]
	cmp	x19, x20
	b.eq	LBB15_55
LBB15_53:                               ; =>This Inner Loop Header: Depth=1
Ltmp277:
	mov	x0, x19
	bl	__ZNSt3__16thread4joinEv
Ltmp278:
; %bb.54:                               ;   in Loop: Header=BB15_53 Depth=1
	add	x19, x19, #8
	cmp	x19, x20
	b.ne	LBB15_53
LBB15_55:
Ltmp280:
	bl	___cxa_rethrow
Ltmp281:
LBB15_56:
	brk	#0x1
LBB15_57:
Ltmp279:
	b	LBB15_59
LBB15_58:
Ltmp282:
LBB15_59:
	mov	x19, x0
Ltmp283:
	bl	___cxa_end_catch
Ltmp284:
	b	LBB15_64
LBB15_60:
Ltmp285:
	bl	___clang_call_terminate
LBB15_61:
Ltmp288:
	b	LBB15_63
LBB15_62:
Ltmp267:
LBB15_63:
	mov	x19, x0
LBB15_64:
	add	x0, sp, #24
	bl	__ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEED1B9nqe210106Ev
	ldr	x0, [sp, #48]
	cbnz	x0, LBB15_66
; %bb.65:
	mov	x0, x19
	bl	__Unwind_Resume
LBB15_66:
	str	x0, [sp, #56]
	mov	w1, #64                         ; =0x40
	bl	__ZdlPvSt11align_val_t
	mov	x0, x19
	bl	__Unwind_Resume
	.loh AdrpAdd	Lloh124, Lloh125
	.loh AdrpLdrGot	Lloh122, Lloh123
	.loh AdrpAdd	Lloh126, Lloh127
	.loh AdrpAdd	Lloh128, Lloh129
	.loh AdrpAdd	Lloh130, Lloh131
	.loh AdrpLdrGot	Lloh132, Lloh133
	.loh AdrpLdrGot	Lloh134, Lloh135
	.loh AdrpAdd	Lloh136, Lloh137
	.loh AdrpAdd	Lloh138, Lloh139
	.loh AdrpLdrGot	Lloh142, Lloh143
	.loh AdrpLdrGot	Lloh140, Lloh141
Lfunc_end9:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table15:
Lexception9:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase3-Lttbaseref3
Lttbaseref3:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end9-Lcst_begin9
Lcst_begin9:
	.uleb128 Lfunc_begin9-Lfunc_begin9      ; >> Call Site 1 <<
	.uleb128 Ltmp247-Lfunc_begin9           ;   Call between Lfunc_begin9 and Ltmp247
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp247-Lfunc_begin9           ; >> Call Site 2 <<
	.uleb128 Ltmp262-Ltmp247                ;   Call between Ltmp247 and Ltmp262
	.uleb128 Ltmp270-Lfunc_begin9           ;     jumps to Ltmp270
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp263-Lfunc_begin9           ; >> Call Site 3 <<
	.uleb128 Ltmp266-Ltmp263                ;   Call between Ltmp263 and Ltmp266
	.uleb128 Ltmp267-Lfunc_begin9           ;     jumps to Ltmp267
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp268-Lfunc_begin9           ; >> Call Site 4 <<
	.uleb128 Ltmp269-Ltmp268                ;   Call between Ltmp268 and Ltmp269
	.uleb128 Ltmp270-Lfunc_begin9           ;     jumps to Ltmp270
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp286-Lfunc_begin9           ; >> Call Site 5 <<
	.uleb128 Ltmp287-Ltmp286                ;   Call between Ltmp286 and Ltmp287
	.uleb128 Ltmp288-Lfunc_begin9           ;     jumps to Ltmp288
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp274-Lfunc_begin9           ; >> Call Site 6 <<
	.uleb128 Ltmp275-Ltmp274                ;   Call between Ltmp274 and Ltmp275
	.uleb128 Ltmp276-Lfunc_begin9           ;     jumps to Ltmp276
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp271-Lfunc_begin9           ; >> Call Site 7 <<
	.uleb128 Ltmp272-Ltmp271                ;   Call between Ltmp271 and Ltmp272
	.uleb128 Ltmp273-Lfunc_begin9           ;     jumps to Ltmp273
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp272-Lfunc_begin9           ; >> Call Site 8 <<
	.uleb128 Ltmp295-Ltmp272                ;   Call between Ltmp272 and Ltmp295
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp295-Lfunc_begin9           ; >> Call Site 9 <<
	.uleb128 Ltmp296-Ltmp295                ;   Call between Ltmp295 and Ltmp296
	.uleb128 Ltmp297-Lfunc_begin9           ;     jumps to Ltmp297
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp296-Lfunc_begin9           ; >> Call Site 10 <<
	.uleb128 Ltmp289-Ltmp296                ;   Call between Ltmp296 and Ltmp289
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp289-Lfunc_begin9           ; >> Call Site 11 <<
	.uleb128 Ltmp290-Ltmp289                ;   Call between Ltmp289 and Ltmp290
	.uleb128 Ltmp291-Lfunc_begin9           ;     jumps to Ltmp291
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp292-Lfunc_begin9           ; >> Call Site 12 <<
	.uleb128 Ltmp293-Ltmp292                ;   Call between Ltmp292 and Ltmp293
	.uleb128 Ltmp294-Lfunc_begin9           ;     jumps to Ltmp294
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp293-Lfunc_begin9           ; >> Call Site 13 <<
	.uleb128 Ltmp277-Ltmp293                ;   Call between Ltmp293 and Ltmp277
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp277-Lfunc_begin9           ; >> Call Site 14 <<
	.uleb128 Ltmp278-Ltmp277                ;   Call between Ltmp277 and Ltmp278
	.uleb128 Ltmp279-Lfunc_begin9           ;     jumps to Ltmp279
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp280-Lfunc_begin9           ; >> Call Site 15 <<
	.uleb128 Ltmp281-Ltmp280                ;   Call between Ltmp280 and Ltmp281
	.uleb128 Ltmp282-Lfunc_begin9           ;     jumps to Ltmp282
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp283-Lfunc_begin9           ; >> Call Site 16 <<
	.uleb128 Ltmp284-Ltmp283                ;   Call between Ltmp283 and Ltmp284
	.uleb128 Ltmp285-Lfunc_begin9           ;     jumps to Ltmp285
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp284-Lfunc_begin9           ; >> Call Site 17 <<
	.uleb128 Lfunc_end9-Ltmp284             ;   Call between Ltmp284 and Lfunc_end9
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end9:
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
Lloh144:
	adrp	x8, __ZTVSt16invalid_argument@GOTPAGE
Lloh145:
	ldr	x8, [x8, __ZTVSt16invalid_argument@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x0]
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
	.loh AdrpLdrGot	Lloh144, Lloh145
	.cfi_endproc
                                        ; -- End function
	.private_extern	__ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEED1B9nqe210106Ev ; -- Begin function _ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEED1B9nqe210106Ev
	.globl	__ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEED1B9nqe210106Ev
	.weak_def_can_be_hidden	__ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEED1B9nqe210106Ev
	.p2align	2
__ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEED1B9nqe210106Ev: ; @_ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEED1B9nqe210106Ev
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
	mov	x19, x0
	ldr	x20, [x0]
	cbz	x20, LBB17_5
; %bb.1:
	ldr	x0, [x19, #8]
	mov	x8, x20
	cmp	x20, x0
	b.eq	LBB17_4
LBB17_2:                                ; =>This Inner Loop Header: Depth=1
	sub	x0, x0, #8
	bl	__ZNSt3__16threadD1Ev
	cmp	x0, x20
	b.ne	LBB17_2
; %bb.3:
	ldr	x8, [x19]
LBB17_4:
	str	x20, [x19, #8]
	mov	x0, x8
	bl	__ZdlPv
LBB17_5:
	mov	x0, x19
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
	ret
	.cfi_endproc
                                        ; -- End function
	.private_extern	__ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEE20__throw_length_errorB9nqe210106Ev ; -- Begin function _ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEE20__throw_length_errorB9nqe210106Ev
	.globl	__ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEE20__throw_length_errorB9nqe210106Ev
	.weak_def_can_be_hidden	__ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEE20__throw_length_errorB9nqe210106Ev
	.p2align	2
__ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEE20__throw_length_errorB9nqe210106Ev: ; @_ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEE20__throw_length_errorB9nqe210106Ev
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh146:
	adrp	x0, l_.str.13@PAGE
Lloh147:
	add	x0, x0, l_.str.13@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh146, Lloh147
	.cfi_endproc
                                        ; -- End function
	.private_extern	__ZNSt3__114__split_bufferINS_6threadERNS_9allocatorIS1_EEED1Ev ; -- Begin function _ZNSt3__114__split_bufferINS_6threadERNS_9allocatorIS1_EEED1Ev
	.globl	__ZNSt3__114__split_bufferINS_6threadERNS_9allocatorIS1_EEED1Ev
	.weak_def_can_be_hidden	__ZNSt3__114__split_bufferINS_6threadERNS_9allocatorIS1_EEED1Ev
	.p2align	2
__ZNSt3__114__split_bufferINS_6threadERNS_9allocatorIS1_EEED1Ev: ; @_ZNSt3__114__split_bufferINS_6threadERNS_9allocatorIS1_EEED1Ev
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
	mov	x19, x0
	ldp	x20, x8, [x0, #8]
	cmp	x20, x8
	b.eq	LBB19_2
LBB19_1:                                ; =>This Inner Loop Header: Depth=1
	sub	x0, x8, #8
	str	x0, [x19, #16]
	bl	__ZNSt3__16threadD1Ev
	ldr	x8, [x19, #16]
	cmp	x20, x8
	b.ne	LBB19_1
LBB19_2:
	ldr	x0, [x19]
	cbz	x0, LBB19_4
; %bb.3:
	bl	__ZdlPv
LBB19_4:
	mov	x0, x19
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEE24__emplace_back_slow_pathIJZ5trialI8IsolatedILi64EEEdiibEUlvE_EEEPS1_DpOT_ ; -- Begin function _ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEE24__emplace_back_slow_pathIJZ5trialI8IsolatedILi64EEEdiibEUlvE_EEEPS1_DpOT_
	.weak_def_can_be_hidden	__ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEE24__emplace_back_slow_pathIJZ5trialI8IsolatedILi64EEEdiibEUlvE_EEEPS1_DpOT_
	.p2align	2
__ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEE24__emplace_back_slow_pathIJZ5trialI8IsolatedILi64EEEdiibEUlvE_EEEPS1_DpOT_: ; @_ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEE24__emplace_back_slow_pathIJZ5trialI8IsolatedILi64EEEdiibEUlvE_EEEPS1_DpOT_
Lfunc_begin10:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception10
; %bb.0:
	sub	sp, sp, #144
	stp	x28, x27, [sp, #48]             ; 16-byte Folded Spill
	stp	x26, x25, [sp, #64]             ; 16-byte Folded Spill
	stp	x24, x23, [sp, #80]             ; 16-byte Folded Spill
	stp	x22, x21, [sp, #96]             ; 16-byte Folded Spill
	stp	x20, x19, [sp, #112]            ; 16-byte Folded Spill
	stp	x29, x30, [sp, #128]            ; 16-byte Folded Spill
	add	x29, sp, #128
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
	ldp	x27, x26, [x0]
	sub	x25, x26, x27
	asr	x8, x25, #3
	add	x8, x8, #1
	lsr	x9, x8, #61
	cbnz	x9, LBB20_19
; %bb.1:
	mov	x19, x0
	mov	x9, x0
	ldr	x10, [x9, #16]!
	mov	x11, #9223372036854775800       ; =0x7ffffffffffffff8
	sub	x10, x10, x27
	asr	x12, x10, #2
	cmp	x12, x8
	csel	x8, x12, x8, hi
	cmp	x10, x11
	mov	x10, #2305843009213693951       ; =0x1fffffffffffffff
	csel	x22, x8, x10, lo
	str	x9, [sp, #40]
	cbz	x22, LBB20_4
; %bb.2:
	lsr	x8, x22, #61
	cbnz	x8, LBB20_20
; %bb.3:
	mov	x20, x1
	lsl	x0, x22, #3
	bl	__Znwm
	mov	x21, x0
	mov	x1, x20
	b	LBB20_5
LBB20_4:
	mov	x21, #0                         ; =0x0
LBB20_5:
	add	x20, x21, x25
	stp	x21, x20, [sp, #8]
	add	x22, x21, x22, lsl #3
	stp	x20, x22, [sp, #24]
Ltmp298:
	mov	x0, x20
	bl	__ZNSt3__16threadC2B9nqe210106IZ5trialI8IsolatedILi64EEEdiibEUlvE_JELi0EEEOT_DpOT0_
Ltmp299:
; %bb.6:
	ldp	x0, x24, [x19]
	subs	x8, x24, x0
	sub	x23, x20, x8
	add	x20, x20, #8
	subs	x10, x24, x0
	b.eq	LBB20_16
; %bb.7:
	sub	x11, x10, #8
	mov	x8, x0
	mov	x9, x23
	cmp	x11, #152
	b.lo	LBB20_13
; %bb.8:
	and	x8, x11, #0xfffffffffffffff8
	add	x9, x0, x8
	add	x9, x9, #8
	cmp	x23, x9
	b.hs	LBB20_10
; %bb.9:
	add	x8, x8, x26
	add	x9, x10, x27
	sub	x8, x8, x9
	add	x8, x8, x21
	add	x12, x8, #8
	mov	x8, x0
	mov	x9, x23
	cmp	x0, x12
	b.lo	LBB20_13
LBB20_10:
	asr	x13, x10, #3
	lsr	x8, x11, #3
	add	x10, x8, #1
	and	x11, x10, #0x3ffffffffffffff8
	lsl	x9, x11, #3
	add	x8, x0, x9
	add	x9, x23, x9
	add	x12, x0, #32
	sub	x13, x25, x13, lsl #3
	add	x13, x13, x21
	add	x13, x13, #32
	movi.2d	v0, #0000000000000000
	mov	x14, x11
LBB20_11:                               ; =>This Inner Loop Header: Depth=1
	ldp	q1, q2, [x12, #-32]
	ldp	q3, q4, [x12]
	stp	q1, q2, [x13, #-32]
	stp	q0, q0, [x12, #-32]
	stp	q0, q0, [x12], #64
	stp	q3, q4, [x13], #64
	subs	x14, x14, #8
	b.ne	LBB20_11
; %bb.12:
	cmp	x10, x11
	b.eq	LBB20_14
LBB20_13:                               ; =>This Inner Loop Header: Depth=1
	ldr	x10, [x8]
	str	x10, [x9], #8
	str	xzr, [x8], #8
	cmp	x8, x24
	b.ne	LBB20_13
LBB20_14:                               ; =>This Inner Loop Header: Depth=1
	bl	__ZNSt3__16threadD1Ev
	add	x0, x0, #8
	cmp	x0, x24
	b.ne	LBB20_14
; %bb.15:
	ldr	x0, [x19]
LBB20_16:
	stp	x23, x20, [x19]
	str	x22, [x19, #16]
	cbz	x0, LBB20_18
; %bb.17:
	bl	__ZdlPv
LBB20_18:
	mov	x0, x20
	ldp	x29, x30, [sp, #128]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #112]            ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #96]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #80]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #64]             ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #48]             ; 16-byte Folded Reload
	add	sp, sp, #144
	ret
LBB20_19:
	bl	__ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEE20__throw_length_errorB9nqe210106Ev
LBB20_20:
	bl	__ZSt28__throw_bad_array_new_lengthB9nqe210106v
LBB20_21:
Ltmp300:
	mov	x19, x0
	add	x0, sp, #8
	bl	__ZNSt3__114__split_bufferINS_6threadERNS_9allocatorIS1_EEED1Ev
	mov	x0, x19
	bl	__Unwind_Resume
Lfunc_end10:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table20:
Lexception10:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end10-Lcst_begin10
Lcst_begin10:
	.uleb128 Lfunc_begin10-Lfunc_begin10    ; >> Call Site 1 <<
	.uleb128 Ltmp298-Lfunc_begin10          ;   Call between Lfunc_begin10 and Ltmp298
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp298-Lfunc_begin10          ; >> Call Site 2 <<
	.uleb128 Ltmp299-Ltmp298                ;   Call between Ltmp298 and Ltmp299
	.uleb128 Ltmp300-Lfunc_begin10          ;     jumps to Ltmp300
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp299-Lfunc_begin10          ; >> Call Site 3 <<
	.uleb128 Lfunc_end10-Ltmp299            ;   Call between Ltmp299 and Lfunc_end10
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end10:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.private_extern	__ZNSt3__16threadC2B9nqe210106IZ5trialI8IsolatedILi64EEEdiibEUlvE_JELi0EEEOT_DpOT0_ ; -- Begin function _ZNSt3__16threadC2B9nqe210106IZ5trialI8IsolatedILi64EEEdiibEUlvE_JELi0EEEOT_DpOT0_
	.globl	__ZNSt3__16threadC2B9nqe210106IZ5trialI8IsolatedILi64EEEdiibEUlvE_JELi0EEEOT_DpOT0_
	.weak_def_can_be_hidden	__ZNSt3__16threadC2B9nqe210106IZ5trialI8IsolatedILi64EEEdiibEUlvE_JELi0EEEOT_DpOT0_
	.p2align	2
__ZNSt3__16threadC2B9nqe210106IZ5trialI8IsolatedILi64EEEdiibEUlvE_JELi0EEEOT_DpOT0_: ; @_ZNSt3__16threadC2B9nqe210106IZ5trialI8IsolatedILi64EEEdiibEUlvE_JELi0EEEOT_DpOT0_
Lfunc_begin11:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception11
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
	mov	x20, x1
	mov	x19, x0
	mov	w0, #8                          ; =0x8
	bl	__Znwm
	mov	x21, x0
Ltmp301:
	bl	__ZNSt3__115__thread_structC1Ev
Ltmp302:
; %bb.1:
	str	x21, [sp, #8]
Ltmp304:
	mov	w0, #32                         ; =0x20
	bl	__Znwm
Ltmp305:
; %bb.2:
	mov	x3, x0
	stp	x0, xzr, [sp]
	str	x21, [x0]
	ldr	q0, [x20]
	stur	q0, [x0, #8]
	ldr	x8, [x20, #16]
	str	x8, [x0, #24]
Ltmp307:
Lloh148:
	adrp	x2, __ZNSt3__114__thread_proxyB9nqe210106INS_5tupleIJNS_10unique_ptrINS_15__thread_structENS_14default_deleteIS3_EEEEZ5trialI8IsolatedILi64EEEdiibEUlvE_EEEEEPvSC_@PAGE
Lloh149:
	add	x2, x2, __ZNSt3__114__thread_proxyB9nqe210106INS_5tupleIJNS_10unique_ptrINS_15__thread_structENS_14default_deleteIS3_EEEEZ5trialI8IsolatedILi64EEEdiibEUlvE_EEEEEPvSC_@PAGEOFF
	mov	x0, x19
	mov	x1, #0                          ; =0x0
	bl	_pthread_create
Ltmp308:
; %bb.3:
	cbnz	w0, LBB21_5
; %bb.4:
	mov	x0, x19
	ldp	x29, x30, [sp, #48]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #32]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #64
	ret
LBB21_5:
Ltmp309:
Lloh150:
	adrp	x1, l_.str.20@PAGE
Lloh151:
	add	x1, x1, l_.str.20@PAGEOFF
	bl	__ZNSt3__120__throw_system_errorEiPKc
Ltmp310:
; %bb.6:
	brk	#0x1
LBB21_7:
Ltmp306:
	mov	x19, x0
	b	LBB21_10
LBB21_8:
Ltmp303:
	mov	x19, x0
	mov	x0, x21
	bl	__ZdlPv
	mov	x0, x19
	bl	__Unwind_Resume
LBB21_9:
Ltmp311:
	mov	x19, x0
	mov	x0, sp
	bl	__ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ5trialI8IsolatedILi64EEEdiibEUlvE_EEENS3_ISA_EEED1B9nqe210106Ev
LBB21_10:
	add	x0, sp, #8
	bl	__ZNSt3__110unique_ptrINS_15__thread_structENS_14default_deleteIS1_EEED1B9nqe210106Ev
	mov	x0, x19
	bl	__Unwind_Resume
	.loh AdrpAdd	Lloh148, Lloh149
	.loh AdrpAdd	Lloh150, Lloh151
Lfunc_end11:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table21:
Lexception11:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end11-Lcst_begin11
Lcst_begin11:
	.uleb128 Lfunc_begin11-Lfunc_begin11    ; >> Call Site 1 <<
	.uleb128 Ltmp301-Lfunc_begin11          ;   Call between Lfunc_begin11 and Ltmp301
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp301-Lfunc_begin11          ; >> Call Site 2 <<
	.uleb128 Ltmp302-Ltmp301                ;   Call between Ltmp301 and Ltmp302
	.uleb128 Ltmp303-Lfunc_begin11          ;     jumps to Ltmp303
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp304-Lfunc_begin11          ; >> Call Site 3 <<
	.uleb128 Ltmp305-Ltmp304                ;   Call between Ltmp304 and Ltmp305
	.uleb128 Ltmp306-Lfunc_begin11          ;     jumps to Ltmp306
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp307-Lfunc_begin11          ; >> Call Site 4 <<
	.uleb128 Ltmp310-Ltmp307                ;   Call between Ltmp307 and Ltmp310
	.uleb128 Ltmp311-Lfunc_begin11          ;     jumps to Ltmp311
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp310-Lfunc_begin11          ; >> Call Site 5 <<
	.uleb128 Lfunc_end11-Ltmp310            ;   Call between Ltmp310 and Lfunc_end11
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end11:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.private_extern	__ZNSt3__114__thread_proxyB9nqe210106INS_5tupleIJNS_10unique_ptrINS_15__thread_structENS_14default_deleteIS3_EEEEZ5trialI8IsolatedILi64EEEdiibEUlvE_EEEEEPvSC_ ; -- Begin function _ZNSt3__114__thread_proxyB9nqe210106INS_5tupleIJNS_10unique_ptrINS_15__thread_structENS_14default_deleteIS3_EEEEZ5trialI8IsolatedILi64EEEdiibEUlvE_EEEEEPvSC_
	.globl	__ZNSt3__114__thread_proxyB9nqe210106INS_5tupleIJNS_10unique_ptrINS_15__thread_structENS_14default_deleteIS3_EEEEZ5trialI8IsolatedILi64EEEdiibEUlvE_EEEEEPvSC_
	.weak_definition	__ZNSt3__114__thread_proxyB9nqe210106INS_5tupleIJNS_10unique_ptrINS_15__thread_structENS_14default_deleteIS3_EEEEZ5trialI8IsolatedILi64EEEdiibEUlvE_EEEEEPvSC_
	.p2align	2
__ZNSt3__114__thread_proxyB9nqe210106INS_5tupleIJNS_10unique_ptrINS_15__thread_structENS_14default_deleteIS3_EEEEZ5trialI8IsolatedILi64EEEdiibEUlvE_EEEEEPvSC_: ; @_ZNSt3__114__thread_proxyB9nqe210106INS_5tupleIJNS_10unique_ptrINS_15__thread_structENS_14default_deleteIS3_EEEEZ5trialI8IsolatedILi64EEEdiibEUlvE_EEEEEPvSC_
Lfunc_begin12:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception12
; %bb.0:
	sub	sp, sp, #48
	stp	x20, x19, [sp, #16]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	mov	x19, x0
	str	x0, [sp, #8]
Ltmp312:
	bl	__ZNSt3__119__thread_local_dataEv
Ltmp313:
; %bb.1:
	ldr	x1, [x19]
	str	xzr, [x19]
	ldr	x0, [x0]
Ltmp314:
	bl	_pthread_setspecific
Ltmp315:
; %bb.2:
	ldr	x8, [x19, #16]
	ldr	w8, [x8]
	cmp	w8, #2
	b.ne	LBB22_4
; %bb.3:
	ldr	x8, [x19, #24]
	ldrsw	x9, [x19, #8]
	ldr	x8, [x8]
	lsl	x9, x9, #6
	mov	w10, #34464                     ; =0x86a0
	movk	w10, #1, lsl #16
	str	x10, [x8, x9]
	b	LBB22_6
LBB22_4:
	mov	w20, #34464                     ; =0x86a0
	movk	w20, #1, lsl #16
LBB22_5:                                ; =>This Inner Loop Header: Depth=1
	ldp	x9, x8, [x19, #16]
	ldr	w9, [x9]
	ldr	w10, [x19, #8]
	cmp	w9, #1
	csel	w9, wzr, w10, eq
	sxtw	x9, w9
	ldr	x8, [x8]
	add	x0, x8, x9, lsl #6
	bl	_add_relaxed
	subs	w20, w20, #1
	b.ne	LBB22_5
LBB22_6:
	ldr	x0, [x19]
	str	xzr, [x19]
	cbz	x0, LBB22_8
; %bb.7:
	bl	__ZNSt3__115__thread_structD1Ev
	bl	__ZdlPv
LBB22_8:
	mov	x0, x19
	bl	__ZdlPv
	mov	x0, #0                          ; =0x0
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #48
	ret
LBB22_9:
Ltmp316:
	mov	x19, x0
	add	x0, sp, #8
	bl	__ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ5trialI8IsolatedILi64EEEdiibEUlvE_EEENS3_ISA_EEED1B9nqe210106Ev
	mov	x0, x19
	bl	__Unwind_Resume
Lfunc_end12:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table22:
Lexception12:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end12-Lcst_begin12
Lcst_begin12:
	.uleb128 Ltmp312-Lfunc_begin12          ; >> Call Site 1 <<
	.uleb128 Ltmp315-Ltmp312                ;   Call between Ltmp312 and Ltmp315
	.uleb128 Ltmp316-Lfunc_begin12          ;     jumps to Ltmp316
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp315-Lfunc_begin12          ; >> Call Site 2 <<
	.uleb128 Lfunc_end12-Ltmp315            ;   Call between Ltmp315 and Lfunc_end12
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end12:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.private_extern	__ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ5trialI8IsolatedILi64EEEdiibEUlvE_EEENS3_ISA_EEED1B9nqe210106Ev ; -- Begin function _ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ5trialI8IsolatedILi64EEEdiibEUlvE_EEENS3_ISA_EEED1B9nqe210106Ev
	.globl	__ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ5trialI8IsolatedILi64EEEdiibEUlvE_EEENS3_ISA_EEED1B9nqe210106Ev
	.weak_def_can_be_hidden	__ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ5trialI8IsolatedILi64EEEdiibEUlvE_EEENS3_ISA_EEED1B9nqe210106Ev
	.p2align	2
__ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ5trialI8IsolatedILi64EEEdiibEUlvE_EEENS3_ISA_EEED1B9nqe210106Ev: ; @_ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ5trialI8IsolatedILi64EEEdiibEUlvE_EEENS3_ISA_EEED1B9nqe210106Ev
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
	cbz	x19, LBB23_4
; %bb.1:
	mov	x20, x0
	ldr	x0, [x19]
	str	xzr, [x19]
	cbz	x0, LBB23_3
; %bb.2:
	bl	__ZNSt3__115__thread_structD1Ev
	bl	__ZdlPv
LBB23_3:
	mov	x0, x19
	bl	__ZdlPv
	mov	x0, x20
LBB23_4:
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
	cbz	x0, LBB24_2
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
LBB24_2:
	mov	x0, x8
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__Z5trialI8IsolatedILi128EEEdiib ; -- Begin function _Z5trialI8IsolatedILi128EEEdiib
	.weak_def_can_be_hidden	__Z5trialI8IsolatedILi128EEEdiib
	.p2align	2
__Z5trialI8IsolatedILi128EEEdiib:       ; @_Z5trialI8IsolatedILi128EEEdiib
Lfunc_begin13:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception13
; %bb.0:
	sub	sp, sp, #160
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
	stur	w1, [x29, #-68]
	sub	w8, w0, #9
	cmn	w8, #9
	b.ls	LBB25_42
; %bb.1:
	mov	x20, x2
	mov	x19, x0
	ubfiz	x21, x19, #7, #32
	mov	x0, x21
	mov	w1, #128                        ; =0x80
	bl	__ZnwmSt11align_val_t
	add	x22, x0, x21
	str	x0, [sp, #48]
	str	x22, [sp, #64]
	mov	x1, x21
	bl	_bzero
	str	x22, [sp, #56]
	stp	xzr, xzr, [sp, #24]
	ubfiz	x0, x19, #3, #32
	str	xzr, [sp, #40]
Ltmp317:
	bl	__Znwm
Ltmp318:
; %bb.2:
	mov	w22, w19
	add	x8, x0, x22, lsl #3
	stp	x0, x0, [sp, #24]
	str	x8, [sp, #40]
	tbz	w20, #0, LBB25_24
; %bb.3:
Ltmp319:
Lloh152:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh153:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh154:
	adrp	x1, l_.str.15@PAGE
Lloh155:
	add	x1, x1, l_.str.15@PAGEOFF
	mov	w2, #7                          ; =0x7
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp320:
; %bb.4:
Ltmp321:
	mov	w1, #128                        ; =0x80
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp322:
; %bb.5:
Ltmp323:
Lloh156:
	adrp	x1, l_.str.16@PAGE
Lloh157:
	add	x1, x1, l_.str.16@PAGEOFF
	mov	w2, #9                          ; =0x9
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp324:
; %bb.6:
Ltmp325:
	mov	x1, x19
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEi
Ltmp326:
; %bb.7:
Ltmp327:
Lloh158:
	adrp	x1, l_.str.17@PAGE
Lloh159:
	add	x1, x1, l_.str.17@PAGEOFF
	mov	w2, #6                          ; =0x6
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp328:
; %bb.8:
	ldur	w1, [x29, #-68]
Ltmp329:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEi
Ltmp330:
; %bb.9:
Ltmp331:
Lloh160:
	adrp	x1, l_.str.18@PAGE
Lloh161:
	add	x1, x1, l_.str.18@PAGEOFF
	mov	w2, #10                         ; =0xa
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp332:
; %bb.10:
	ldp	x20, x23, [sp, #48]
	cmp	x20, x23
	b.eq	LBB25_15
; %bb.11:
	mov	w24, #32                        ; =0x20
Lloh162:
	adrp	x21, __ZNSt3__14coutE@GOTPAGE
Lloh163:
	ldr	x21, [x21, __ZNSt3__14coutE@GOTPAGEOFF]
LBB25_12:                               ; =>This Inner Loop Header: Depth=1
	strb	w24, [sp]
Ltmp333:
	mov	x1, sp
	mov	x0, x21
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp334:
; %bb.13:                               ;   in Loop: Header=BB25_12 Depth=1
Ltmp335:
	mov	x1, x20
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEPKv
Ltmp336:
; %bb.14:                               ;   in Loop: Header=BB25_12 Depth=1
	add	x20, x20, #128
	cmp	x20, x23
	b.ne	LBB25_12
LBB25_15:
	mov	w8, #10                         ; =0xa
	strb	w8, [sp]
Ltmp338:
Lloh164:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh165:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
	mov	x1, sp
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp339:
; %bb.16:
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x20, x0
	cmp	w19, #0
	b.gt	LBB25_25
; %bb.17:
	ldr	x21, [sp, #32]
LBB25_18:
	ldr	x19, [sp, #24]
	cmp	x19, x21
	b.eq	LBB25_21
LBB25_19:                               ; =>This Inner Loop Header: Depth=1
Ltmp356:
	mov	x0, x19
	bl	__ZNSt3__16thread4joinEv
Ltmp357:
; %bb.20:                               ;   in Loop: Header=BB25_19 Depth=1
	add	x19, x19, #8
	cmp	x19, x21
	b.ne	LBB25_19
LBB25_21:
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x19, x0
	ldp	x0, x9, [sp, #48]
	cmp	x0, x9
	b.eq	LBB25_32
; %bb.22:
	mov	x8, #0                          ; =0x0
	mov	x10, x0
LBB25_23:                               ; =>This Inner Loop Header: Depth=1
	ldr	x11, [x10], #128
	add	x8, x11, x8
	cmp	x10, x9
	b.ne	LBB25_23
	b	LBB25_33
LBB25_24:
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x20, x0
LBB25_25:
	mov	w23, #0                         ; =0x0
	ldr	x21, [sp, #32]
	sub	x24, x29, #68
	add	x25, sp, #48
	b	LBB25_27
LBB25_26:                               ;   in Loop: Header=BB25_27 Depth=1
	str	x21, [sp, #32]
	add	w23, w23, #1
	cmp	w19, w23
	b.eq	LBB25_18
LBB25_27:                               ; =>This Inner Loop Header: Depth=1
	str	w23, [sp]
	stp	x24, x25, [sp, #8]
	ldr	x8, [sp, #40]
	cmp	x21, x8
	b.hs	LBB25_30
; %bb.28:                               ;   in Loop: Header=BB25_27 Depth=1
Ltmp344:
	mov	x1, sp
	mov	x0, x21
	bl	__ZNSt3__16threadC2B9nqe210106IZ5trialI8IsolatedILi128EEEdiibEUlvE_JELi0EEEOT_DpOT0_
Ltmp345:
; %bb.29:                               ;   in Loop: Header=BB25_27 Depth=1
	add	x21, x21, #8
	b	LBB25_26
LBB25_30:                               ;   in Loop: Header=BB25_27 Depth=1
Ltmp341:
	add	x0, sp, #24
	mov	x1, sp
	bl	__ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEE24__emplace_back_slow_pathIJZ5trialI8IsolatedILi128EEEdiibEUlvE_EEEPS1_DpOT_
Ltmp342:
; %bb.31:                               ;   in Loop: Header=BB25_27 Depth=1
	mov	x21, x0
	b	LBB25_26
LBB25_32:
	mov	x8, #0                          ; =0x0
LBB25_33:
	mov	w9, #34464                      ; =0x86a0
	movk	w9, #1, lsl #16
	umull	x9, w22, w9
	cmp	x8, x9
	b.ne	LBB25_44
; %bb.34:
	ldr	x21, [sp, #24]
	cbz	x21, LBB25_39
; %bb.35:
	ldr	x0, [sp, #32]
	mov	x8, x21
	cmp	x21, x0
	b.eq	LBB25_38
LBB25_36:                               ; =>This Inner Loop Header: Depth=1
	sub	x0, x0, #8
	bl	__ZNSt3__16threadD1Ev
	cmp	x0, x21
	b.ne	LBB25_36
; %bb.37:
	ldr	x8, [sp, #24]
LBB25_38:
	str	x21, [sp, #32]
	mov	x0, x8
	bl	__ZdlPv
	ldr	x0, [sp, #48]
LBB25_39:
	cbz	x0, LBB25_41
; %bb.40:
	str	x0, [sp, #56]
	mov	w1, #128                        ; =0x80
	bl	__ZdlPvSt11align_val_t
LBB25_41:
	sub	x8, x19, x20
	scvtf	d0, x8
	mov	x8, #145685290680320            ; =0x848000000000
	movk	x8, #16686, lsl #48
	fmov	d1, x8
	fdiv	d0, d0, d1
	ldp	x29, x30, [sp, #144]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #128]            ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #112]            ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #96]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #80]             ; 16-byte Folded Reload
	add	sp, sp, #160
	ret
LBB25_42:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x20, x0
Ltmp365:
Lloh166:
	adrp	x1, l_.str.14@PAGE
Lloh167:
	add	x1, x1, l_.str.14@PAGEOFF
	bl	__ZNSt16invalid_argumentC1B9nqe210106EPKc
Ltmp366:
; %bb.43:
	mov	x0, x20
	bl	__Z5trialI8IsolatedILi128EEEdiib.cold.1
LBB25_44:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x20, x0
Ltmp359:
Lloh168:
	adrp	x1, l_.str.19@PAGE
Lloh169:
	add	x1, x1, l_.str.19@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp360:
; %bb.45:
Ltmp362:
Lloh170:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh171:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh172:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh173:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x20
	bl	___cxa_throw
Ltmp363:
	b	LBB25_56
LBB25_46:
Ltmp364:
	b	LBB25_63
LBB25_47:
Ltmp361:
	mov	x19, x0
	mov	x0, x20
	bl	___cxa_free_exception
	b	LBB25_64
LBB25_48:
Ltmp367:
	mov	x19, x0
	mov	x0, x20
	bl	___cxa_free_exception
	mov	x0, x19
	bl	__Unwind_Resume
LBB25_49:
Ltmp340:
	b	LBB25_63
LBB25_50:
Ltmp343:
	b	LBB25_52
LBB25_51:
Ltmp346:
	str	x21, [sp, #32]
LBB25_52:
	bl	___cxa_begin_catch
	ldp	x19, x20, [sp, #24]
	cmp	x19, x20
	b.eq	LBB25_55
LBB25_53:                               ; =>This Inner Loop Header: Depth=1
Ltmp347:
	mov	x0, x19
	bl	__ZNSt3__16thread4joinEv
Ltmp348:
; %bb.54:                               ;   in Loop: Header=BB25_53 Depth=1
	add	x19, x19, #8
	cmp	x19, x20
	b.ne	LBB25_53
LBB25_55:
Ltmp350:
	bl	___cxa_rethrow
Ltmp351:
LBB25_56:
	brk	#0x1
LBB25_57:
Ltmp349:
	b	LBB25_59
LBB25_58:
Ltmp352:
LBB25_59:
	mov	x19, x0
Ltmp353:
	bl	___cxa_end_catch
Ltmp354:
	b	LBB25_64
LBB25_60:
Ltmp355:
	bl	___clang_call_terminate
LBB25_61:
Ltmp358:
	b	LBB25_63
LBB25_62:
Ltmp337:
LBB25_63:
	mov	x19, x0
LBB25_64:
	add	x0, sp, #24
	bl	__ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEED1B9nqe210106Ev
	ldr	x0, [sp, #48]
	cbnz	x0, LBB25_66
; %bb.65:
	mov	x0, x19
	bl	__Unwind_Resume
LBB25_66:
	str	x0, [sp, #56]
	mov	w1, #128                        ; =0x80
	bl	__ZdlPvSt11align_val_t
	mov	x0, x19
	bl	__Unwind_Resume
	.loh AdrpAdd	Lloh154, Lloh155
	.loh AdrpLdrGot	Lloh152, Lloh153
	.loh AdrpAdd	Lloh156, Lloh157
	.loh AdrpAdd	Lloh158, Lloh159
	.loh AdrpAdd	Lloh160, Lloh161
	.loh AdrpLdrGot	Lloh162, Lloh163
	.loh AdrpLdrGot	Lloh164, Lloh165
	.loh AdrpAdd	Lloh166, Lloh167
	.loh AdrpAdd	Lloh168, Lloh169
	.loh AdrpLdrGot	Lloh172, Lloh173
	.loh AdrpLdrGot	Lloh170, Lloh171
Lfunc_end13:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table25:
Lexception13:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase4-Lttbaseref4
Lttbaseref4:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end13-Lcst_begin13
Lcst_begin13:
	.uleb128 Lfunc_begin13-Lfunc_begin13    ; >> Call Site 1 <<
	.uleb128 Ltmp317-Lfunc_begin13          ;   Call between Lfunc_begin13 and Ltmp317
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp317-Lfunc_begin13          ; >> Call Site 2 <<
	.uleb128 Ltmp332-Ltmp317                ;   Call between Ltmp317 and Ltmp332
	.uleb128 Ltmp340-Lfunc_begin13          ;     jumps to Ltmp340
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp333-Lfunc_begin13          ; >> Call Site 3 <<
	.uleb128 Ltmp336-Ltmp333                ;   Call between Ltmp333 and Ltmp336
	.uleb128 Ltmp337-Lfunc_begin13          ;     jumps to Ltmp337
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp338-Lfunc_begin13          ; >> Call Site 4 <<
	.uleb128 Ltmp339-Ltmp338                ;   Call between Ltmp338 and Ltmp339
	.uleb128 Ltmp340-Lfunc_begin13          ;     jumps to Ltmp340
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp356-Lfunc_begin13          ; >> Call Site 5 <<
	.uleb128 Ltmp357-Ltmp356                ;   Call between Ltmp356 and Ltmp357
	.uleb128 Ltmp358-Lfunc_begin13          ;     jumps to Ltmp358
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp344-Lfunc_begin13          ; >> Call Site 6 <<
	.uleb128 Ltmp345-Ltmp344                ;   Call between Ltmp344 and Ltmp345
	.uleb128 Ltmp346-Lfunc_begin13          ;     jumps to Ltmp346
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp341-Lfunc_begin13          ; >> Call Site 7 <<
	.uleb128 Ltmp342-Ltmp341                ;   Call between Ltmp341 and Ltmp342
	.uleb128 Ltmp343-Lfunc_begin13          ;     jumps to Ltmp343
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp342-Lfunc_begin13          ; >> Call Site 8 <<
	.uleb128 Ltmp365-Ltmp342                ;   Call between Ltmp342 and Ltmp365
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp365-Lfunc_begin13          ; >> Call Site 9 <<
	.uleb128 Ltmp366-Ltmp365                ;   Call between Ltmp365 and Ltmp366
	.uleb128 Ltmp367-Lfunc_begin13          ;     jumps to Ltmp367
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp366-Lfunc_begin13          ; >> Call Site 10 <<
	.uleb128 Ltmp359-Ltmp366                ;   Call between Ltmp366 and Ltmp359
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp359-Lfunc_begin13          ; >> Call Site 11 <<
	.uleb128 Ltmp360-Ltmp359                ;   Call between Ltmp359 and Ltmp360
	.uleb128 Ltmp361-Lfunc_begin13          ;     jumps to Ltmp361
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp362-Lfunc_begin13          ; >> Call Site 12 <<
	.uleb128 Ltmp363-Ltmp362                ;   Call between Ltmp362 and Ltmp363
	.uleb128 Ltmp364-Lfunc_begin13          ;     jumps to Ltmp364
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp363-Lfunc_begin13          ; >> Call Site 13 <<
	.uleb128 Ltmp347-Ltmp363                ;   Call between Ltmp363 and Ltmp347
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp347-Lfunc_begin13          ; >> Call Site 14 <<
	.uleb128 Ltmp348-Ltmp347                ;   Call between Ltmp347 and Ltmp348
	.uleb128 Ltmp349-Lfunc_begin13          ;     jumps to Ltmp349
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp350-Lfunc_begin13          ; >> Call Site 15 <<
	.uleb128 Ltmp351-Ltmp350                ;   Call between Ltmp350 and Ltmp351
	.uleb128 Ltmp352-Lfunc_begin13          ;     jumps to Ltmp352
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp353-Lfunc_begin13          ; >> Call Site 16 <<
	.uleb128 Ltmp354-Ltmp353                ;   Call between Ltmp353 and Ltmp354
	.uleb128 Ltmp355-Lfunc_begin13          ;     jumps to Ltmp355
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp354-Lfunc_begin13          ; >> Call Site 17 <<
	.uleb128 Lfunc_end13-Ltmp354            ;   Call between Ltmp354 and Lfunc_end13
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end13:
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
	.globl	__ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEE24__emplace_back_slow_pathIJZ5trialI8IsolatedILi128EEEdiibEUlvE_EEEPS1_DpOT_ ; -- Begin function _ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEE24__emplace_back_slow_pathIJZ5trialI8IsolatedILi128EEEdiibEUlvE_EEEPS1_DpOT_
	.weak_def_can_be_hidden	__ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEE24__emplace_back_slow_pathIJZ5trialI8IsolatedILi128EEEdiibEUlvE_EEEPS1_DpOT_
	.p2align	2
__ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEE24__emplace_back_slow_pathIJZ5trialI8IsolatedILi128EEEdiibEUlvE_EEEPS1_DpOT_: ; @_ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEE24__emplace_back_slow_pathIJZ5trialI8IsolatedILi128EEEdiibEUlvE_EEEPS1_DpOT_
Lfunc_begin14:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception14
; %bb.0:
	sub	sp, sp, #144
	stp	x28, x27, [sp, #48]             ; 16-byte Folded Spill
	stp	x26, x25, [sp, #64]             ; 16-byte Folded Spill
	stp	x24, x23, [sp, #80]             ; 16-byte Folded Spill
	stp	x22, x21, [sp, #96]             ; 16-byte Folded Spill
	stp	x20, x19, [sp, #112]            ; 16-byte Folded Spill
	stp	x29, x30, [sp, #128]            ; 16-byte Folded Spill
	add	x29, sp, #128
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
	ldp	x27, x26, [x0]
	sub	x25, x26, x27
	asr	x8, x25, #3
	add	x8, x8, #1
	lsr	x9, x8, #61
	cbnz	x9, LBB26_19
; %bb.1:
	mov	x19, x0
	mov	x9, x0
	ldr	x10, [x9, #16]!
	mov	x11, #9223372036854775800       ; =0x7ffffffffffffff8
	sub	x10, x10, x27
	asr	x12, x10, #2
	cmp	x12, x8
	csel	x8, x12, x8, hi
	cmp	x10, x11
	mov	x10, #2305843009213693951       ; =0x1fffffffffffffff
	csel	x22, x8, x10, lo
	str	x9, [sp, #40]
	cbz	x22, LBB26_4
; %bb.2:
	lsr	x8, x22, #61
	cbnz	x8, LBB26_20
; %bb.3:
	mov	x20, x1
	lsl	x0, x22, #3
	bl	__Znwm
	mov	x21, x0
	mov	x1, x20
	b	LBB26_5
LBB26_4:
	mov	x21, #0                         ; =0x0
LBB26_5:
	add	x20, x21, x25
	stp	x21, x20, [sp, #8]
	add	x22, x21, x22, lsl #3
	stp	x20, x22, [sp, #24]
Ltmp368:
	mov	x0, x20
	bl	__ZNSt3__16threadC2B9nqe210106IZ5trialI8IsolatedILi128EEEdiibEUlvE_JELi0EEEOT_DpOT0_
Ltmp369:
; %bb.6:
	ldp	x0, x24, [x19]
	subs	x8, x24, x0
	sub	x23, x20, x8
	add	x20, x20, #8
	subs	x10, x24, x0
	b.eq	LBB26_16
; %bb.7:
	sub	x11, x10, #8
	mov	x8, x0
	mov	x9, x23
	cmp	x11, #152
	b.lo	LBB26_13
; %bb.8:
	and	x8, x11, #0xfffffffffffffff8
	add	x9, x0, x8
	add	x9, x9, #8
	cmp	x23, x9
	b.hs	LBB26_10
; %bb.9:
	add	x8, x8, x26
	add	x9, x10, x27
	sub	x8, x8, x9
	add	x8, x8, x21
	add	x12, x8, #8
	mov	x8, x0
	mov	x9, x23
	cmp	x0, x12
	b.lo	LBB26_13
LBB26_10:
	asr	x13, x10, #3
	lsr	x8, x11, #3
	add	x10, x8, #1
	and	x11, x10, #0x3ffffffffffffff8
	lsl	x9, x11, #3
	add	x8, x0, x9
	add	x9, x23, x9
	add	x12, x0, #32
	sub	x13, x25, x13, lsl #3
	add	x13, x13, x21
	add	x13, x13, #32
	movi.2d	v0, #0000000000000000
	mov	x14, x11
LBB26_11:                               ; =>This Inner Loop Header: Depth=1
	ldp	q1, q2, [x12, #-32]
	ldp	q3, q4, [x12]
	stp	q1, q2, [x13, #-32]
	stp	q0, q0, [x12, #-32]
	stp	q0, q0, [x12], #64
	stp	q3, q4, [x13], #64
	subs	x14, x14, #8
	b.ne	LBB26_11
; %bb.12:
	cmp	x10, x11
	b.eq	LBB26_14
LBB26_13:                               ; =>This Inner Loop Header: Depth=1
	ldr	x10, [x8]
	str	x10, [x9], #8
	str	xzr, [x8], #8
	cmp	x8, x24
	b.ne	LBB26_13
LBB26_14:                               ; =>This Inner Loop Header: Depth=1
	bl	__ZNSt3__16threadD1Ev
	add	x0, x0, #8
	cmp	x0, x24
	b.ne	LBB26_14
; %bb.15:
	ldr	x0, [x19]
LBB26_16:
	stp	x23, x20, [x19]
	str	x22, [x19, #16]
	cbz	x0, LBB26_18
; %bb.17:
	bl	__ZdlPv
LBB26_18:
	mov	x0, x20
	ldp	x29, x30, [sp, #128]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #112]            ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #96]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #80]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #64]             ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #48]             ; 16-byte Folded Reload
	add	sp, sp, #144
	ret
LBB26_19:
	bl	__ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEE20__throw_length_errorB9nqe210106Ev
LBB26_20:
	bl	__ZSt28__throw_bad_array_new_lengthB9nqe210106v
LBB26_21:
Ltmp370:
	mov	x19, x0
	add	x0, sp, #8
	bl	__ZNSt3__114__split_bufferINS_6threadERNS_9allocatorIS1_EEED1Ev
	mov	x0, x19
	bl	__Unwind_Resume
Lfunc_end14:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table26:
Lexception14:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end14-Lcst_begin14
Lcst_begin14:
	.uleb128 Lfunc_begin14-Lfunc_begin14    ; >> Call Site 1 <<
	.uleb128 Ltmp368-Lfunc_begin14          ;   Call between Lfunc_begin14 and Ltmp368
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp368-Lfunc_begin14          ; >> Call Site 2 <<
	.uleb128 Ltmp369-Ltmp368                ;   Call between Ltmp368 and Ltmp369
	.uleb128 Ltmp370-Lfunc_begin14          ;     jumps to Ltmp370
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp369-Lfunc_begin14          ; >> Call Site 3 <<
	.uleb128 Lfunc_end14-Ltmp369            ;   Call between Ltmp369 and Lfunc_end14
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end14:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.private_extern	__ZNSt3__16threadC2B9nqe210106IZ5trialI8IsolatedILi128EEEdiibEUlvE_JELi0EEEOT_DpOT0_ ; -- Begin function _ZNSt3__16threadC2B9nqe210106IZ5trialI8IsolatedILi128EEEdiibEUlvE_JELi0EEEOT_DpOT0_
	.globl	__ZNSt3__16threadC2B9nqe210106IZ5trialI8IsolatedILi128EEEdiibEUlvE_JELi0EEEOT_DpOT0_
	.weak_def_can_be_hidden	__ZNSt3__16threadC2B9nqe210106IZ5trialI8IsolatedILi128EEEdiibEUlvE_JELi0EEEOT_DpOT0_
	.p2align	2
__ZNSt3__16threadC2B9nqe210106IZ5trialI8IsolatedILi128EEEdiibEUlvE_JELi0EEEOT_DpOT0_: ; @_ZNSt3__16threadC2B9nqe210106IZ5trialI8IsolatedILi128EEEdiibEUlvE_JELi0EEEOT_DpOT0_
Lfunc_begin15:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception15
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
	mov	x20, x1
	mov	x19, x0
	mov	w0, #8                          ; =0x8
	bl	__Znwm
	mov	x21, x0
Ltmp371:
	bl	__ZNSt3__115__thread_structC1Ev
Ltmp372:
; %bb.1:
	str	x21, [sp, #8]
Ltmp374:
	mov	w0, #32                         ; =0x20
	bl	__Znwm
Ltmp375:
; %bb.2:
	mov	x3, x0
	stp	x0, xzr, [sp]
	str	x21, [x0]
	ldr	q0, [x20]
	stur	q0, [x0, #8]
	ldr	x8, [x20, #16]
	str	x8, [x0, #24]
Ltmp377:
Lloh174:
	adrp	x2, __ZNSt3__114__thread_proxyB9nqe210106INS_5tupleIJNS_10unique_ptrINS_15__thread_structENS_14default_deleteIS3_EEEEZ5trialI8IsolatedILi128EEEdiibEUlvE_EEEEEPvSC_@PAGE
Lloh175:
	add	x2, x2, __ZNSt3__114__thread_proxyB9nqe210106INS_5tupleIJNS_10unique_ptrINS_15__thread_structENS_14default_deleteIS3_EEEEZ5trialI8IsolatedILi128EEEdiibEUlvE_EEEEEPvSC_@PAGEOFF
	mov	x0, x19
	mov	x1, #0                          ; =0x0
	bl	_pthread_create
Ltmp378:
; %bb.3:
	cbnz	w0, LBB27_5
; %bb.4:
	mov	x0, x19
	ldp	x29, x30, [sp, #48]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #32]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #64
	ret
LBB27_5:
Ltmp379:
Lloh176:
	adrp	x1, l_.str.20@PAGE
Lloh177:
	add	x1, x1, l_.str.20@PAGEOFF
	bl	__ZNSt3__120__throw_system_errorEiPKc
Ltmp380:
; %bb.6:
	brk	#0x1
LBB27_7:
Ltmp376:
	mov	x19, x0
	b	LBB27_10
LBB27_8:
Ltmp373:
	mov	x19, x0
	mov	x0, x21
	bl	__ZdlPv
	mov	x0, x19
	bl	__Unwind_Resume
LBB27_9:
Ltmp381:
	mov	x19, x0
	mov	x0, sp
	bl	__ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ5trialI8IsolatedILi128EEEdiibEUlvE_EEENS3_ISA_EEED1B9nqe210106Ev
LBB27_10:
	add	x0, sp, #8
	bl	__ZNSt3__110unique_ptrINS_15__thread_structENS_14default_deleteIS1_EEED1B9nqe210106Ev
	mov	x0, x19
	bl	__Unwind_Resume
	.loh AdrpAdd	Lloh174, Lloh175
	.loh AdrpAdd	Lloh176, Lloh177
Lfunc_end15:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table27:
Lexception15:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end15-Lcst_begin15
Lcst_begin15:
	.uleb128 Lfunc_begin15-Lfunc_begin15    ; >> Call Site 1 <<
	.uleb128 Ltmp371-Lfunc_begin15          ;   Call between Lfunc_begin15 and Ltmp371
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp371-Lfunc_begin15          ; >> Call Site 2 <<
	.uleb128 Ltmp372-Ltmp371                ;   Call between Ltmp371 and Ltmp372
	.uleb128 Ltmp373-Lfunc_begin15          ;     jumps to Ltmp373
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp374-Lfunc_begin15          ; >> Call Site 3 <<
	.uleb128 Ltmp375-Ltmp374                ;   Call between Ltmp374 and Ltmp375
	.uleb128 Ltmp376-Lfunc_begin15          ;     jumps to Ltmp376
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp377-Lfunc_begin15          ; >> Call Site 4 <<
	.uleb128 Ltmp380-Ltmp377                ;   Call between Ltmp377 and Ltmp380
	.uleb128 Ltmp381-Lfunc_begin15          ;     jumps to Ltmp381
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp380-Lfunc_begin15          ; >> Call Site 5 <<
	.uleb128 Lfunc_end15-Ltmp380            ;   Call between Ltmp380 and Lfunc_end15
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end15:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.private_extern	__ZNSt3__114__thread_proxyB9nqe210106INS_5tupleIJNS_10unique_ptrINS_15__thread_structENS_14default_deleteIS3_EEEEZ5trialI8IsolatedILi128EEEdiibEUlvE_EEEEEPvSC_ ; -- Begin function _ZNSt3__114__thread_proxyB9nqe210106INS_5tupleIJNS_10unique_ptrINS_15__thread_structENS_14default_deleteIS3_EEEEZ5trialI8IsolatedILi128EEEdiibEUlvE_EEEEEPvSC_
	.globl	__ZNSt3__114__thread_proxyB9nqe210106INS_5tupleIJNS_10unique_ptrINS_15__thread_structENS_14default_deleteIS3_EEEEZ5trialI8IsolatedILi128EEEdiibEUlvE_EEEEEPvSC_
	.weak_definition	__ZNSt3__114__thread_proxyB9nqe210106INS_5tupleIJNS_10unique_ptrINS_15__thread_structENS_14default_deleteIS3_EEEEZ5trialI8IsolatedILi128EEEdiibEUlvE_EEEEEPvSC_
	.p2align	2
__ZNSt3__114__thread_proxyB9nqe210106INS_5tupleIJNS_10unique_ptrINS_15__thread_structENS_14default_deleteIS3_EEEEZ5trialI8IsolatedILi128EEEdiibEUlvE_EEEEEPvSC_: ; @_ZNSt3__114__thread_proxyB9nqe210106INS_5tupleIJNS_10unique_ptrINS_15__thread_structENS_14default_deleteIS3_EEEEZ5trialI8IsolatedILi128EEEdiibEUlvE_EEEEEPvSC_
Lfunc_begin16:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception16
; %bb.0:
	sub	sp, sp, #48
	stp	x20, x19, [sp, #16]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	mov	x19, x0
	str	x0, [sp, #8]
Ltmp382:
	bl	__ZNSt3__119__thread_local_dataEv
Ltmp383:
; %bb.1:
	ldr	x1, [x19]
	str	xzr, [x19]
	ldr	x0, [x0]
Ltmp384:
	bl	_pthread_setspecific
Ltmp385:
; %bb.2:
	ldr	x8, [x19, #16]
	ldr	w8, [x8]
	cmp	w8, #2
	b.ne	LBB28_4
; %bb.3:
	ldr	x8, [x19, #24]
	ldrsw	x9, [x19, #8]
	ldr	x8, [x8]
	lsl	x9, x9, #7
	mov	w10, #34464                     ; =0x86a0
	movk	w10, #1, lsl #16
	str	x10, [x8, x9]
	b	LBB28_6
LBB28_4:
	mov	w20, #34464                     ; =0x86a0
	movk	w20, #1, lsl #16
LBB28_5:                                ; =>This Inner Loop Header: Depth=1
	ldp	x9, x8, [x19, #16]
	ldr	w9, [x9]
	ldr	w10, [x19, #8]
	cmp	w9, #1
	csel	w9, wzr, w10, eq
	sxtw	x9, w9
	ldr	x8, [x8]
	add	x0, x8, x9, lsl #7
	bl	_add_relaxed
	subs	w20, w20, #1
	b.ne	LBB28_5
LBB28_6:
	ldr	x0, [x19]
	str	xzr, [x19]
	cbz	x0, LBB28_8
; %bb.7:
	bl	__ZNSt3__115__thread_structD1Ev
	bl	__ZdlPv
LBB28_8:
	mov	x0, x19
	bl	__ZdlPv
	mov	x0, #0                          ; =0x0
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #48
	ret
LBB28_9:
Ltmp386:
	mov	x19, x0
	add	x0, sp, #8
	bl	__ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ5trialI8IsolatedILi128EEEdiibEUlvE_EEENS3_ISA_EEED1B9nqe210106Ev
	mov	x0, x19
	bl	__Unwind_Resume
Lfunc_end16:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table28:
Lexception16:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end16-Lcst_begin16
Lcst_begin16:
	.uleb128 Ltmp382-Lfunc_begin16          ; >> Call Site 1 <<
	.uleb128 Ltmp385-Ltmp382                ;   Call between Ltmp382 and Ltmp385
	.uleb128 Ltmp386-Lfunc_begin16          ;     jumps to Ltmp386
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp385-Lfunc_begin16          ; >> Call Site 2 <<
	.uleb128 Lfunc_end16-Ltmp385            ;   Call between Ltmp385 and Lfunc_end16
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end16:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.private_extern	__ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ5trialI8IsolatedILi128EEEdiibEUlvE_EEENS3_ISA_EEED1B9nqe210106Ev ; -- Begin function _ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ5trialI8IsolatedILi128EEEdiibEUlvE_EEENS3_ISA_EEED1B9nqe210106Ev
	.globl	__ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ5trialI8IsolatedILi128EEEdiibEUlvE_EEENS3_ISA_EEED1B9nqe210106Ev
	.weak_def_can_be_hidden	__ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ5trialI8IsolatedILi128EEEdiibEUlvE_EEENS3_ISA_EEED1B9nqe210106Ev
	.p2align	2
__ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ5trialI8IsolatedILi128EEEdiibEUlvE_EEENS3_ISA_EEED1B9nqe210106Ev: ; @_ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ5trialI8IsolatedILi128EEEdiibEUlvE_EEENS3_ISA_EEED1B9nqe210106Ev
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
	cbz	x19, LBB29_4
; %bb.1:
	mov	x20, x0
	ldr	x0, [x19]
	str	xzr, [x19]
	cbz	x0, LBB29_3
; %bb.2:
	bl	__ZNSt3__115__thread_structD1Ev
	bl	__ZdlPv
LBB29_3:
	mov	x0, x19
	bl	__ZdlPv
	mov	x0, x20
LBB29_4:
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__Z5trialI8IsolatedILi256EEEdiib ; -- Begin function _Z5trialI8IsolatedILi256EEEdiib
	.weak_def_can_be_hidden	__Z5trialI8IsolatedILi256EEEdiib
	.p2align	2
__Z5trialI8IsolatedILi256EEEdiib:       ; @_Z5trialI8IsolatedILi256EEEdiib
Lfunc_begin17:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception17
; %bb.0:
	sub	sp, sp, #160
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
	stur	w1, [x29, #-68]
	sub	w8, w0, #9
	cmn	w8, #9
	b.ls	LBB30_42
; %bb.1:
	mov	x20, x2
	mov	x19, x0
	ubfiz	x21, x19, #8, #32
	mov	x0, x21
	mov	w1, #256                        ; =0x100
	bl	__ZnwmSt11align_val_t
	add	x22, x0, x21
	str	x0, [sp, #48]
	str	x22, [sp, #64]
	mov	x1, x21
	bl	_bzero
	str	x22, [sp, #56]
	stp	xzr, xzr, [sp, #24]
	ubfiz	x0, x19, #3, #32
	str	xzr, [sp, #40]
Ltmp387:
	bl	__Znwm
Ltmp388:
; %bb.2:
	mov	w22, w19
	add	x8, x0, x22, lsl #3
	stp	x0, x0, [sp, #24]
	str	x8, [sp, #40]
	tbz	w20, #0, LBB30_24
; %bb.3:
Ltmp389:
Lloh178:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh179:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh180:
	adrp	x1, l_.str.15@PAGE
Lloh181:
	add	x1, x1, l_.str.15@PAGEOFF
	mov	w2, #7                          ; =0x7
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp390:
; %bb.4:
Ltmp391:
	mov	w1, #256                        ; =0x100
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp392:
; %bb.5:
Ltmp393:
Lloh182:
	adrp	x1, l_.str.16@PAGE
Lloh183:
	add	x1, x1, l_.str.16@PAGEOFF
	mov	w2, #9                          ; =0x9
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp394:
; %bb.6:
Ltmp395:
	mov	x1, x19
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEi
Ltmp396:
; %bb.7:
Ltmp397:
Lloh184:
	adrp	x1, l_.str.17@PAGE
Lloh185:
	add	x1, x1, l_.str.17@PAGEOFF
	mov	w2, #6                          ; =0x6
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp398:
; %bb.8:
	ldur	w1, [x29, #-68]
Ltmp399:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEi
Ltmp400:
; %bb.9:
Ltmp401:
Lloh186:
	adrp	x1, l_.str.18@PAGE
Lloh187:
	add	x1, x1, l_.str.18@PAGEOFF
	mov	w2, #10                         ; =0xa
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp402:
; %bb.10:
	ldp	x20, x23, [sp, #48]
	cmp	x20, x23
	b.eq	LBB30_15
; %bb.11:
	mov	w24, #32                        ; =0x20
Lloh188:
	adrp	x21, __ZNSt3__14coutE@GOTPAGE
Lloh189:
	ldr	x21, [x21, __ZNSt3__14coutE@GOTPAGEOFF]
LBB30_12:                               ; =>This Inner Loop Header: Depth=1
	strb	w24, [sp]
Ltmp403:
	mov	x1, sp
	mov	x0, x21
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp404:
; %bb.13:                               ;   in Loop: Header=BB30_12 Depth=1
Ltmp405:
	mov	x1, x20
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEPKv
Ltmp406:
; %bb.14:                               ;   in Loop: Header=BB30_12 Depth=1
	add	x20, x20, #256
	cmp	x20, x23
	b.ne	LBB30_12
LBB30_15:
	mov	w8, #10                         ; =0xa
	strb	w8, [sp]
Ltmp408:
Lloh190:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh191:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
	mov	x1, sp
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp409:
; %bb.16:
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x20, x0
	cmp	w19, #0
	b.gt	LBB30_25
; %bb.17:
	ldr	x21, [sp, #32]
LBB30_18:
	ldr	x19, [sp, #24]
	cmp	x19, x21
	b.eq	LBB30_21
LBB30_19:                               ; =>This Inner Loop Header: Depth=1
Ltmp426:
	mov	x0, x19
	bl	__ZNSt3__16thread4joinEv
Ltmp427:
; %bb.20:                               ;   in Loop: Header=BB30_19 Depth=1
	add	x19, x19, #8
	cmp	x19, x21
	b.ne	LBB30_19
LBB30_21:
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x19, x0
	ldp	x0, x9, [sp, #48]
	cmp	x0, x9
	b.eq	LBB30_32
; %bb.22:
	mov	x8, #0                          ; =0x0
	mov	x10, x0
LBB30_23:                               ; =>This Inner Loop Header: Depth=1
	ldr	x11, [x10]
	add	x8, x11, x8
	add	x10, x10, #256
	cmp	x10, x9
	b.ne	LBB30_23
	b	LBB30_33
LBB30_24:
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x20, x0
LBB30_25:
	mov	w23, #0                         ; =0x0
	ldr	x21, [sp, #32]
	sub	x24, x29, #68
	add	x25, sp, #48
	b	LBB30_27
LBB30_26:                               ;   in Loop: Header=BB30_27 Depth=1
	str	x21, [sp, #32]
	add	w23, w23, #1
	cmp	w19, w23
	b.eq	LBB30_18
LBB30_27:                               ; =>This Inner Loop Header: Depth=1
	str	w23, [sp]
	stp	x24, x25, [sp, #8]
	ldr	x8, [sp, #40]
	cmp	x21, x8
	b.hs	LBB30_30
; %bb.28:                               ;   in Loop: Header=BB30_27 Depth=1
Ltmp414:
	mov	x1, sp
	mov	x0, x21
	bl	__ZNSt3__16threadC2B9nqe210106IZ5trialI8IsolatedILi256EEEdiibEUlvE_JELi0EEEOT_DpOT0_
Ltmp415:
; %bb.29:                               ;   in Loop: Header=BB30_27 Depth=1
	add	x21, x21, #8
	b	LBB30_26
LBB30_30:                               ;   in Loop: Header=BB30_27 Depth=1
Ltmp411:
	add	x0, sp, #24
	mov	x1, sp
	bl	__ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEE24__emplace_back_slow_pathIJZ5trialI8IsolatedILi256EEEdiibEUlvE_EEEPS1_DpOT_
Ltmp412:
; %bb.31:                               ;   in Loop: Header=BB30_27 Depth=1
	mov	x21, x0
	b	LBB30_26
LBB30_32:
	mov	x8, #0                          ; =0x0
LBB30_33:
	mov	w9, #34464                      ; =0x86a0
	movk	w9, #1, lsl #16
	umull	x9, w22, w9
	cmp	x8, x9
	b.ne	LBB30_44
; %bb.34:
	ldr	x21, [sp, #24]
	cbz	x21, LBB30_39
; %bb.35:
	ldr	x0, [sp, #32]
	mov	x8, x21
	cmp	x21, x0
	b.eq	LBB30_38
LBB30_36:                               ; =>This Inner Loop Header: Depth=1
	sub	x0, x0, #8
	bl	__ZNSt3__16threadD1Ev
	cmp	x0, x21
	b.ne	LBB30_36
; %bb.37:
	ldr	x8, [sp, #24]
LBB30_38:
	str	x21, [sp, #32]
	mov	x0, x8
	bl	__ZdlPv
	ldr	x0, [sp, #48]
LBB30_39:
	cbz	x0, LBB30_41
; %bb.40:
	str	x0, [sp, #56]
	mov	w1, #256                        ; =0x100
	bl	__ZdlPvSt11align_val_t
LBB30_41:
	sub	x8, x19, x20
	scvtf	d0, x8
	mov	x8, #145685290680320            ; =0x848000000000
	movk	x8, #16686, lsl #48
	fmov	d1, x8
	fdiv	d0, d0, d1
	ldp	x29, x30, [sp, #144]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #128]            ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #112]            ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #96]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #80]             ; 16-byte Folded Reload
	add	sp, sp, #160
	ret
LBB30_42:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x20, x0
Ltmp435:
Lloh192:
	adrp	x1, l_.str.14@PAGE
Lloh193:
	add	x1, x1, l_.str.14@PAGEOFF
	bl	__ZNSt16invalid_argumentC1B9nqe210106EPKc
Ltmp436:
; %bb.43:
	mov	x0, x20
	bl	__Z5trialI8IsolatedILi256EEEdiib.cold.1
LBB30_44:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x20, x0
Ltmp429:
Lloh194:
	adrp	x1, l_.str.19@PAGE
Lloh195:
	add	x1, x1, l_.str.19@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp430:
; %bb.45:
Ltmp432:
Lloh196:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh197:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh198:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh199:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x20
	bl	___cxa_throw
Ltmp433:
	b	LBB30_56
LBB30_46:
Ltmp434:
	b	LBB30_63
LBB30_47:
Ltmp431:
	mov	x19, x0
	mov	x0, x20
	bl	___cxa_free_exception
	b	LBB30_64
LBB30_48:
Ltmp437:
	mov	x19, x0
	mov	x0, x20
	bl	___cxa_free_exception
	mov	x0, x19
	bl	__Unwind_Resume
LBB30_49:
Ltmp410:
	b	LBB30_63
LBB30_50:
Ltmp413:
	b	LBB30_52
LBB30_51:
Ltmp416:
	str	x21, [sp, #32]
LBB30_52:
	bl	___cxa_begin_catch
	ldp	x19, x20, [sp, #24]
	cmp	x19, x20
	b.eq	LBB30_55
LBB30_53:                               ; =>This Inner Loop Header: Depth=1
Ltmp417:
	mov	x0, x19
	bl	__ZNSt3__16thread4joinEv
Ltmp418:
; %bb.54:                               ;   in Loop: Header=BB30_53 Depth=1
	add	x19, x19, #8
	cmp	x19, x20
	b.ne	LBB30_53
LBB30_55:
Ltmp420:
	bl	___cxa_rethrow
Ltmp421:
LBB30_56:
	brk	#0x1
LBB30_57:
Ltmp419:
	b	LBB30_59
LBB30_58:
Ltmp422:
LBB30_59:
	mov	x19, x0
Ltmp423:
	bl	___cxa_end_catch
Ltmp424:
	b	LBB30_64
LBB30_60:
Ltmp425:
	bl	___clang_call_terminate
LBB30_61:
Ltmp428:
	b	LBB30_63
LBB30_62:
Ltmp407:
LBB30_63:
	mov	x19, x0
LBB30_64:
	add	x0, sp, #24
	bl	__ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEED1B9nqe210106Ev
	ldr	x0, [sp, #48]
	cbnz	x0, LBB30_66
; %bb.65:
	mov	x0, x19
	bl	__Unwind_Resume
LBB30_66:
	str	x0, [sp, #56]
	mov	w1, #256                        ; =0x100
	bl	__ZdlPvSt11align_val_t
	mov	x0, x19
	bl	__Unwind_Resume
	.loh AdrpAdd	Lloh180, Lloh181
	.loh AdrpLdrGot	Lloh178, Lloh179
	.loh AdrpAdd	Lloh182, Lloh183
	.loh AdrpAdd	Lloh184, Lloh185
	.loh AdrpAdd	Lloh186, Lloh187
	.loh AdrpLdrGot	Lloh188, Lloh189
	.loh AdrpLdrGot	Lloh190, Lloh191
	.loh AdrpAdd	Lloh192, Lloh193
	.loh AdrpAdd	Lloh194, Lloh195
	.loh AdrpLdrGot	Lloh198, Lloh199
	.loh AdrpLdrGot	Lloh196, Lloh197
Lfunc_end17:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table30:
Lexception17:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase5-Lttbaseref5
Lttbaseref5:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end17-Lcst_begin17
Lcst_begin17:
	.uleb128 Lfunc_begin17-Lfunc_begin17    ; >> Call Site 1 <<
	.uleb128 Ltmp387-Lfunc_begin17          ;   Call between Lfunc_begin17 and Ltmp387
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp387-Lfunc_begin17          ; >> Call Site 2 <<
	.uleb128 Ltmp402-Ltmp387                ;   Call between Ltmp387 and Ltmp402
	.uleb128 Ltmp410-Lfunc_begin17          ;     jumps to Ltmp410
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp403-Lfunc_begin17          ; >> Call Site 3 <<
	.uleb128 Ltmp406-Ltmp403                ;   Call between Ltmp403 and Ltmp406
	.uleb128 Ltmp407-Lfunc_begin17          ;     jumps to Ltmp407
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp408-Lfunc_begin17          ; >> Call Site 4 <<
	.uleb128 Ltmp409-Ltmp408                ;   Call between Ltmp408 and Ltmp409
	.uleb128 Ltmp410-Lfunc_begin17          ;     jumps to Ltmp410
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp426-Lfunc_begin17          ; >> Call Site 5 <<
	.uleb128 Ltmp427-Ltmp426                ;   Call between Ltmp426 and Ltmp427
	.uleb128 Ltmp428-Lfunc_begin17          ;     jumps to Ltmp428
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp414-Lfunc_begin17          ; >> Call Site 6 <<
	.uleb128 Ltmp415-Ltmp414                ;   Call between Ltmp414 and Ltmp415
	.uleb128 Ltmp416-Lfunc_begin17          ;     jumps to Ltmp416
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp411-Lfunc_begin17          ; >> Call Site 7 <<
	.uleb128 Ltmp412-Ltmp411                ;   Call between Ltmp411 and Ltmp412
	.uleb128 Ltmp413-Lfunc_begin17          ;     jumps to Ltmp413
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp412-Lfunc_begin17          ; >> Call Site 8 <<
	.uleb128 Ltmp435-Ltmp412                ;   Call between Ltmp412 and Ltmp435
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp435-Lfunc_begin17          ; >> Call Site 9 <<
	.uleb128 Ltmp436-Ltmp435                ;   Call between Ltmp435 and Ltmp436
	.uleb128 Ltmp437-Lfunc_begin17          ;     jumps to Ltmp437
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp436-Lfunc_begin17          ; >> Call Site 10 <<
	.uleb128 Ltmp429-Ltmp436                ;   Call between Ltmp436 and Ltmp429
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp429-Lfunc_begin17          ; >> Call Site 11 <<
	.uleb128 Ltmp430-Ltmp429                ;   Call between Ltmp429 and Ltmp430
	.uleb128 Ltmp431-Lfunc_begin17          ;     jumps to Ltmp431
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp432-Lfunc_begin17          ; >> Call Site 12 <<
	.uleb128 Ltmp433-Ltmp432                ;   Call between Ltmp432 and Ltmp433
	.uleb128 Ltmp434-Lfunc_begin17          ;     jumps to Ltmp434
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp433-Lfunc_begin17          ; >> Call Site 13 <<
	.uleb128 Ltmp417-Ltmp433                ;   Call between Ltmp433 and Ltmp417
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp417-Lfunc_begin17          ; >> Call Site 14 <<
	.uleb128 Ltmp418-Ltmp417                ;   Call between Ltmp417 and Ltmp418
	.uleb128 Ltmp419-Lfunc_begin17          ;     jumps to Ltmp419
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp420-Lfunc_begin17          ; >> Call Site 15 <<
	.uleb128 Ltmp421-Ltmp420                ;   Call between Ltmp420 and Ltmp421
	.uleb128 Ltmp422-Lfunc_begin17          ;     jumps to Ltmp422
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp423-Lfunc_begin17          ; >> Call Site 16 <<
	.uleb128 Ltmp424-Ltmp423                ;   Call between Ltmp423 and Ltmp424
	.uleb128 Ltmp425-Lfunc_begin17          ;     jumps to Ltmp425
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp424-Lfunc_begin17          ; >> Call Site 17 <<
	.uleb128 Lfunc_end17-Ltmp424            ;   Call between Ltmp424 and Lfunc_end17
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end17:
	.byte	1                               ; >> Action Record 1 <<
                                        ;   Catch TypeInfo 1
	.byte	0                               ;   No further actions
	.p2align	2, 0x0
                                        ; >> Catch TypeInfos <<
	.long	0                               ; TypeInfo 1
Lttbase5:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEE24__emplace_back_slow_pathIJZ5trialI8IsolatedILi256EEEdiibEUlvE_EEEPS1_DpOT_ ; -- Begin function _ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEE24__emplace_back_slow_pathIJZ5trialI8IsolatedILi256EEEdiibEUlvE_EEEPS1_DpOT_
	.weak_def_can_be_hidden	__ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEE24__emplace_back_slow_pathIJZ5trialI8IsolatedILi256EEEdiibEUlvE_EEEPS1_DpOT_
	.p2align	2
__ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEE24__emplace_back_slow_pathIJZ5trialI8IsolatedILi256EEEdiibEUlvE_EEEPS1_DpOT_: ; @_ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEE24__emplace_back_slow_pathIJZ5trialI8IsolatedILi256EEEdiibEUlvE_EEEPS1_DpOT_
Lfunc_begin18:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception18
; %bb.0:
	sub	sp, sp, #144
	stp	x28, x27, [sp, #48]             ; 16-byte Folded Spill
	stp	x26, x25, [sp, #64]             ; 16-byte Folded Spill
	stp	x24, x23, [sp, #80]             ; 16-byte Folded Spill
	stp	x22, x21, [sp, #96]             ; 16-byte Folded Spill
	stp	x20, x19, [sp, #112]            ; 16-byte Folded Spill
	stp	x29, x30, [sp, #128]            ; 16-byte Folded Spill
	add	x29, sp, #128
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
	ldp	x27, x26, [x0]
	sub	x25, x26, x27
	asr	x8, x25, #3
	add	x8, x8, #1
	lsr	x9, x8, #61
	cbnz	x9, LBB31_19
; %bb.1:
	mov	x19, x0
	mov	x9, x0
	ldr	x10, [x9, #16]!
	mov	x11, #9223372036854775800       ; =0x7ffffffffffffff8
	sub	x10, x10, x27
	asr	x12, x10, #2
	cmp	x12, x8
	csel	x8, x12, x8, hi
	cmp	x10, x11
	mov	x10, #2305843009213693951       ; =0x1fffffffffffffff
	csel	x22, x8, x10, lo
	str	x9, [sp, #40]
	cbz	x22, LBB31_4
; %bb.2:
	lsr	x8, x22, #61
	cbnz	x8, LBB31_20
; %bb.3:
	mov	x20, x1
	lsl	x0, x22, #3
	bl	__Znwm
	mov	x21, x0
	mov	x1, x20
	b	LBB31_5
LBB31_4:
	mov	x21, #0                         ; =0x0
LBB31_5:
	add	x20, x21, x25
	stp	x21, x20, [sp, #8]
	add	x22, x21, x22, lsl #3
	stp	x20, x22, [sp, #24]
Ltmp438:
	mov	x0, x20
	bl	__ZNSt3__16threadC2B9nqe210106IZ5trialI8IsolatedILi256EEEdiibEUlvE_JELi0EEEOT_DpOT0_
Ltmp439:
; %bb.6:
	ldp	x0, x24, [x19]
	subs	x8, x24, x0
	sub	x23, x20, x8
	add	x20, x20, #8
	subs	x10, x24, x0
	b.eq	LBB31_16
; %bb.7:
	sub	x11, x10, #8
	mov	x8, x0
	mov	x9, x23
	cmp	x11, #152
	b.lo	LBB31_13
; %bb.8:
	and	x8, x11, #0xfffffffffffffff8
	add	x9, x0, x8
	add	x9, x9, #8
	cmp	x23, x9
	b.hs	LBB31_10
; %bb.9:
	add	x8, x8, x26
	add	x9, x10, x27
	sub	x8, x8, x9
	add	x8, x8, x21
	add	x12, x8, #8
	mov	x8, x0
	mov	x9, x23
	cmp	x0, x12
	b.lo	LBB31_13
LBB31_10:
	asr	x13, x10, #3
	lsr	x8, x11, #3
	add	x10, x8, #1
	and	x11, x10, #0x3ffffffffffffff8
	lsl	x9, x11, #3
	add	x8, x0, x9
	add	x9, x23, x9
	add	x12, x0, #32
	sub	x13, x25, x13, lsl #3
	add	x13, x13, x21
	add	x13, x13, #32
	movi.2d	v0, #0000000000000000
	mov	x14, x11
LBB31_11:                               ; =>This Inner Loop Header: Depth=1
	ldp	q1, q2, [x12, #-32]
	ldp	q3, q4, [x12]
	stp	q1, q2, [x13, #-32]
	stp	q0, q0, [x12, #-32]
	stp	q0, q0, [x12], #64
	stp	q3, q4, [x13], #64
	subs	x14, x14, #8
	b.ne	LBB31_11
; %bb.12:
	cmp	x10, x11
	b.eq	LBB31_14
LBB31_13:                               ; =>This Inner Loop Header: Depth=1
	ldr	x10, [x8]
	str	x10, [x9], #8
	str	xzr, [x8], #8
	cmp	x8, x24
	b.ne	LBB31_13
LBB31_14:                               ; =>This Inner Loop Header: Depth=1
	bl	__ZNSt3__16threadD1Ev
	add	x0, x0, #8
	cmp	x0, x24
	b.ne	LBB31_14
; %bb.15:
	ldr	x0, [x19]
LBB31_16:
	stp	x23, x20, [x19]
	str	x22, [x19, #16]
	cbz	x0, LBB31_18
; %bb.17:
	bl	__ZdlPv
LBB31_18:
	mov	x0, x20
	ldp	x29, x30, [sp, #128]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #112]            ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #96]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #80]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #64]             ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #48]             ; 16-byte Folded Reload
	add	sp, sp, #144
	ret
LBB31_19:
	bl	__ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEE20__throw_length_errorB9nqe210106Ev
LBB31_20:
	bl	__ZSt28__throw_bad_array_new_lengthB9nqe210106v
LBB31_21:
Ltmp440:
	mov	x19, x0
	add	x0, sp, #8
	bl	__ZNSt3__114__split_bufferINS_6threadERNS_9allocatorIS1_EEED1Ev
	mov	x0, x19
	bl	__Unwind_Resume
Lfunc_end18:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table31:
Lexception18:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end18-Lcst_begin18
Lcst_begin18:
	.uleb128 Lfunc_begin18-Lfunc_begin18    ; >> Call Site 1 <<
	.uleb128 Ltmp438-Lfunc_begin18          ;   Call between Lfunc_begin18 and Ltmp438
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp438-Lfunc_begin18          ; >> Call Site 2 <<
	.uleb128 Ltmp439-Ltmp438                ;   Call between Ltmp438 and Ltmp439
	.uleb128 Ltmp440-Lfunc_begin18          ;     jumps to Ltmp440
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp439-Lfunc_begin18          ; >> Call Site 3 <<
	.uleb128 Lfunc_end18-Ltmp439            ;   Call between Ltmp439 and Lfunc_end18
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end18:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.private_extern	__ZNSt3__16threadC2B9nqe210106IZ5trialI8IsolatedILi256EEEdiibEUlvE_JELi0EEEOT_DpOT0_ ; -- Begin function _ZNSt3__16threadC2B9nqe210106IZ5trialI8IsolatedILi256EEEdiibEUlvE_JELi0EEEOT_DpOT0_
	.globl	__ZNSt3__16threadC2B9nqe210106IZ5trialI8IsolatedILi256EEEdiibEUlvE_JELi0EEEOT_DpOT0_
	.weak_def_can_be_hidden	__ZNSt3__16threadC2B9nqe210106IZ5trialI8IsolatedILi256EEEdiibEUlvE_JELi0EEEOT_DpOT0_
	.p2align	2
__ZNSt3__16threadC2B9nqe210106IZ5trialI8IsolatedILi256EEEdiibEUlvE_JELi0EEEOT_DpOT0_: ; @_ZNSt3__16threadC2B9nqe210106IZ5trialI8IsolatedILi256EEEdiibEUlvE_JELi0EEEOT_DpOT0_
Lfunc_begin19:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception19
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
	mov	x20, x1
	mov	x19, x0
	mov	w0, #8                          ; =0x8
	bl	__Znwm
	mov	x21, x0
Ltmp441:
	bl	__ZNSt3__115__thread_structC1Ev
Ltmp442:
; %bb.1:
	str	x21, [sp, #8]
Ltmp444:
	mov	w0, #32                         ; =0x20
	bl	__Znwm
Ltmp445:
; %bb.2:
	mov	x3, x0
	stp	x0, xzr, [sp]
	str	x21, [x0]
	ldr	q0, [x20]
	stur	q0, [x0, #8]
	ldr	x8, [x20, #16]
	str	x8, [x0, #24]
Ltmp447:
Lloh200:
	adrp	x2, __ZNSt3__114__thread_proxyB9nqe210106INS_5tupleIJNS_10unique_ptrINS_15__thread_structENS_14default_deleteIS3_EEEEZ5trialI8IsolatedILi256EEEdiibEUlvE_EEEEEPvSC_@PAGE
Lloh201:
	add	x2, x2, __ZNSt3__114__thread_proxyB9nqe210106INS_5tupleIJNS_10unique_ptrINS_15__thread_structENS_14default_deleteIS3_EEEEZ5trialI8IsolatedILi256EEEdiibEUlvE_EEEEEPvSC_@PAGEOFF
	mov	x0, x19
	mov	x1, #0                          ; =0x0
	bl	_pthread_create
Ltmp448:
; %bb.3:
	cbnz	w0, LBB32_5
; %bb.4:
	mov	x0, x19
	ldp	x29, x30, [sp, #48]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #32]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #64
	ret
LBB32_5:
Ltmp449:
Lloh202:
	adrp	x1, l_.str.20@PAGE
Lloh203:
	add	x1, x1, l_.str.20@PAGEOFF
	bl	__ZNSt3__120__throw_system_errorEiPKc
Ltmp450:
; %bb.6:
	brk	#0x1
LBB32_7:
Ltmp446:
	mov	x19, x0
	b	LBB32_10
LBB32_8:
Ltmp443:
	mov	x19, x0
	mov	x0, x21
	bl	__ZdlPv
	mov	x0, x19
	bl	__Unwind_Resume
LBB32_9:
Ltmp451:
	mov	x19, x0
	mov	x0, sp
	bl	__ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ5trialI8IsolatedILi256EEEdiibEUlvE_EEENS3_ISA_EEED1B9nqe210106Ev
LBB32_10:
	add	x0, sp, #8
	bl	__ZNSt3__110unique_ptrINS_15__thread_structENS_14default_deleteIS1_EEED1B9nqe210106Ev
	mov	x0, x19
	bl	__Unwind_Resume
	.loh AdrpAdd	Lloh200, Lloh201
	.loh AdrpAdd	Lloh202, Lloh203
Lfunc_end19:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table32:
Lexception19:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end19-Lcst_begin19
Lcst_begin19:
	.uleb128 Lfunc_begin19-Lfunc_begin19    ; >> Call Site 1 <<
	.uleb128 Ltmp441-Lfunc_begin19          ;   Call between Lfunc_begin19 and Ltmp441
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp441-Lfunc_begin19          ; >> Call Site 2 <<
	.uleb128 Ltmp442-Ltmp441                ;   Call between Ltmp441 and Ltmp442
	.uleb128 Ltmp443-Lfunc_begin19          ;     jumps to Ltmp443
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp444-Lfunc_begin19          ; >> Call Site 3 <<
	.uleb128 Ltmp445-Ltmp444                ;   Call between Ltmp444 and Ltmp445
	.uleb128 Ltmp446-Lfunc_begin19          ;     jumps to Ltmp446
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp447-Lfunc_begin19          ; >> Call Site 4 <<
	.uleb128 Ltmp450-Ltmp447                ;   Call between Ltmp447 and Ltmp450
	.uleb128 Ltmp451-Lfunc_begin19          ;     jumps to Ltmp451
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp450-Lfunc_begin19          ; >> Call Site 5 <<
	.uleb128 Lfunc_end19-Ltmp450            ;   Call between Ltmp450 and Lfunc_end19
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end19:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.private_extern	__ZNSt3__114__thread_proxyB9nqe210106INS_5tupleIJNS_10unique_ptrINS_15__thread_structENS_14default_deleteIS3_EEEEZ5trialI8IsolatedILi256EEEdiibEUlvE_EEEEEPvSC_ ; -- Begin function _ZNSt3__114__thread_proxyB9nqe210106INS_5tupleIJNS_10unique_ptrINS_15__thread_structENS_14default_deleteIS3_EEEEZ5trialI8IsolatedILi256EEEdiibEUlvE_EEEEEPvSC_
	.globl	__ZNSt3__114__thread_proxyB9nqe210106INS_5tupleIJNS_10unique_ptrINS_15__thread_structENS_14default_deleteIS3_EEEEZ5trialI8IsolatedILi256EEEdiibEUlvE_EEEEEPvSC_
	.weak_definition	__ZNSt3__114__thread_proxyB9nqe210106INS_5tupleIJNS_10unique_ptrINS_15__thread_structENS_14default_deleteIS3_EEEEZ5trialI8IsolatedILi256EEEdiibEUlvE_EEEEEPvSC_
	.p2align	2
__ZNSt3__114__thread_proxyB9nqe210106INS_5tupleIJNS_10unique_ptrINS_15__thread_structENS_14default_deleteIS3_EEEEZ5trialI8IsolatedILi256EEEdiibEUlvE_EEEEEPvSC_: ; @_ZNSt3__114__thread_proxyB9nqe210106INS_5tupleIJNS_10unique_ptrINS_15__thread_structENS_14default_deleteIS3_EEEEZ5trialI8IsolatedILi256EEEdiibEUlvE_EEEEEPvSC_
Lfunc_begin20:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception20
; %bb.0:
	sub	sp, sp, #48
	stp	x20, x19, [sp, #16]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	mov	x19, x0
	str	x0, [sp, #8]
Ltmp452:
	bl	__ZNSt3__119__thread_local_dataEv
Ltmp453:
; %bb.1:
	ldr	x1, [x19]
	str	xzr, [x19]
	ldr	x0, [x0]
Ltmp454:
	bl	_pthread_setspecific
Ltmp455:
; %bb.2:
	ldr	x8, [x19, #16]
	ldr	w8, [x8]
	cmp	w8, #2
	b.ne	LBB33_4
; %bb.3:
	ldr	x8, [x19, #24]
	ldrsw	x9, [x19, #8]
	ldr	x8, [x8]
	lsl	x9, x9, #8
	mov	w10, #34464                     ; =0x86a0
	movk	w10, #1, lsl #16
	str	x10, [x8, x9]
	b	LBB33_6
LBB33_4:
	mov	w20, #34464                     ; =0x86a0
	movk	w20, #1, lsl #16
LBB33_5:                                ; =>This Inner Loop Header: Depth=1
	ldp	x9, x8, [x19, #16]
	ldr	w9, [x9]
	ldr	w10, [x19, #8]
	cmp	w9, #1
	csel	w9, wzr, w10, eq
	sxtw	x9, w9
	ldr	x8, [x8]
	add	x0, x8, x9, lsl #8
	bl	_add_relaxed
	subs	w20, w20, #1
	b.ne	LBB33_5
LBB33_6:
	ldr	x0, [x19]
	str	xzr, [x19]
	cbz	x0, LBB33_8
; %bb.7:
	bl	__ZNSt3__115__thread_structD1Ev
	bl	__ZdlPv
LBB33_8:
	mov	x0, x19
	bl	__ZdlPv
	mov	x0, #0                          ; =0x0
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #48
	ret
LBB33_9:
Ltmp456:
	mov	x19, x0
	add	x0, sp, #8
	bl	__ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ5trialI8IsolatedILi256EEEdiibEUlvE_EEENS3_ISA_EEED1B9nqe210106Ev
	mov	x0, x19
	bl	__Unwind_Resume
Lfunc_end20:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table33:
Lexception20:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end20-Lcst_begin20
Lcst_begin20:
	.uleb128 Ltmp452-Lfunc_begin20          ; >> Call Site 1 <<
	.uleb128 Ltmp455-Ltmp452                ;   Call between Ltmp452 and Ltmp455
	.uleb128 Ltmp456-Lfunc_begin20          ;     jumps to Ltmp456
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp455-Lfunc_begin20          ; >> Call Site 2 <<
	.uleb128 Lfunc_end20-Ltmp455            ;   Call between Ltmp455 and Lfunc_end20
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end20:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.private_extern	__ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ5trialI8IsolatedILi256EEEdiibEUlvE_EEENS3_ISA_EEED1B9nqe210106Ev ; -- Begin function _ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ5trialI8IsolatedILi256EEEdiibEUlvE_EEENS3_ISA_EEED1B9nqe210106Ev
	.globl	__ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ5trialI8IsolatedILi256EEEdiibEUlvE_EEENS3_ISA_EEED1B9nqe210106Ev
	.weak_def_can_be_hidden	__ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ5trialI8IsolatedILi256EEEdiibEUlvE_EEENS3_ISA_EEED1B9nqe210106Ev
	.p2align	2
__ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ5trialI8IsolatedILi256EEEdiibEUlvE_EEENS3_ISA_EEED1B9nqe210106Ev: ; @_ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ5trialI8IsolatedILi256EEEdiibEUlvE_EEENS3_ISA_EEED1B9nqe210106Ev
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
	cbz	x19, LBB34_4
; %bb.1:
	mov	x20, x0
	ldr	x0, [x19]
	str	xzr, [x19]
	cbz	x0, LBB34_3
; %bb.2:
	bl	__ZNSt3__115__thread_structD1Ev
	bl	__ZdlPv
LBB34_3:
	mov	x0, x19
	bl	__ZdlPv
	mov	x0, x20
LBB34_4:
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEE24__emplace_back_slow_pathIJZ5trialI6PackedEdiibEUlvE_EEEPS1_DpOT_ ; -- Begin function _ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEE24__emplace_back_slow_pathIJZ5trialI6PackedEdiibEUlvE_EEEPS1_DpOT_
	.weak_def_can_be_hidden	__ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEE24__emplace_back_slow_pathIJZ5trialI6PackedEdiibEUlvE_EEEPS1_DpOT_
	.p2align	2
__ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEE24__emplace_back_slow_pathIJZ5trialI6PackedEdiibEUlvE_EEEPS1_DpOT_: ; @_ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEE24__emplace_back_slow_pathIJZ5trialI6PackedEdiibEUlvE_EEEPS1_DpOT_
Lfunc_begin21:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception21
; %bb.0:
	sub	sp, sp, #144
	stp	x28, x27, [sp, #48]             ; 16-byte Folded Spill
	stp	x26, x25, [sp, #64]             ; 16-byte Folded Spill
	stp	x24, x23, [sp, #80]             ; 16-byte Folded Spill
	stp	x22, x21, [sp, #96]             ; 16-byte Folded Spill
	stp	x20, x19, [sp, #112]            ; 16-byte Folded Spill
	stp	x29, x30, [sp, #128]            ; 16-byte Folded Spill
	add	x29, sp, #128
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
	ldp	x27, x26, [x0]
	sub	x25, x26, x27
	asr	x8, x25, #3
	add	x8, x8, #1
	lsr	x9, x8, #61
	cbnz	x9, LBB35_19
; %bb.1:
	mov	x19, x0
	mov	x9, x0
	ldr	x10, [x9, #16]!
	mov	x11, #9223372036854775800       ; =0x7ffffffffffffff8
	sub	x10, x10, x27
	asr	x12, x10, #2
	cmp	x12, x8
	csel	x8, x12, x8, hi
	cmp	x10, x11
	mov	x10, #2305843009213693951       ; =0x1fffffffffffffff
	csel	x22, x8, x10, lo
	str	x9, [sp, #40]
	cbz	x22, LBB35_4
; %bb.2:
	lsr	x8, x22, #61
	cbnz	x8, LBB35_20
; %bb.3:
	mov	x20, x1
	lsl	x0, x22, #3
	bl	__Znwm
	mov	x21, x0
	mov	x1, x20
	b	LBB35_5
LBB35_4:
	mov	x21, #0                         ; =0x0
LBB35_5:
	add	x20, x21, x25
	stp	x21, x20, [sp, #8]
	add	x22, x21, x22, lsl #3
	stp	x20, x22, [sp, #24]
Ltmp457:
	mov	x0, x20
	bl	__ZNSt3__16threadC2B9nqe210106IZ5trialI6PackedEdiibEUlvE_JELi0EEEOT_DpOT0_
Ltmp458:
; %bb.6:
	ldp	x0, x24, [x19]
	subs	x8, x24, x0
	sub	x23, x20, x8
	add	x20, x20, #8
	subs	x10, x24, x0
	b.eq	LBB35_16
; %bb.7:
	sub	x11, x10, #8
	mov	x8, x0
	mov	x9, x23
	cmp	x11, #152
	b.lo	LBB35_13
; %bb.8:
	and	x8, x11, #0xfffffffffffffff8
	add	x9, x0, x8
	add	x9, x9, #8
	cmp	x23, x9
	b.hs	LBB35_10
; %bb.9:
	add	x8, x8, x26
	add	x9, x10, x27
	sub	x8, x8, x9
	add	x8, x8, x21
	add	x12, x8, #8
	mov	x8, x0
	mov	x9, x23
	cmp	x0, x12
	b.lo	LBB35_13
LBB35_10:
	asr	x13, x10, #3
	lsr	x8, x11, #3
	add	x10, x8, #1
	and	x11, x10, #0x3ffffffffffffff8
	lsl	x9, x11, #3
	add	x8, x0, x9
	add	x9, x23, x9
	add	x12, x0, #32
	sub	x13, x25, x13, lsl #3
	add	x13, x13, x21
	add	x13, x13, #32
	movi.2d	v0, #0000000000000000
	mov	x14, x11
LBB35_11:                               ; =>This Inner Loop Header: Depth=1
	ldp	q1, q2, [x12, #-32]
	ldp	q3, q4, [x12]
	stp	q1, q2, [x13, #-32]
	stp	q0, q0, [x12, #-32]
	stp	q0, q0, [x12], #64
	stp	q3, q4, [x13], #64
	subs	x14, x14, #8
	b.ne	LBB35_11
; %bb.12:
	cmp	x10, x11
	b.eq	LBB35_14
LBB35_13:                               ; =>This Inner Loop Header: Depth=1
	ldr	x10, [x8]
	str	x10, [x9], #8
	str	xzr, [x8], #8
	cmp	x8, x24
	b.ne	LBB35_13
LBB35_14:                               ; =>This Inner Loop Header: Depth=1
	bl	__ZNSt3__16threadD1Ev
	add	x0, x0, #8
	cmp	x0, x24
	b.ne	LBB35_14
; %bb.15:
	ldr	x0, [x19]
LBB35_16:
	stp	x23, x20, [x19]
	str	x22, [x19, #16]
	cbz	x0, LBB35_18
; %bb.17:
	bl	__ZdlPv
LBB35_18:
	mov	x0, x20
	ldp	x29, x30, [sp, #128]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #112]            ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #96]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #80]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #64]             ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #48]             ; 16-byte Folded Reload
	add	sp, sp, #144
	ret
LBB35_19:
	bl	__ZNSt3__16vectorINS_6threadENS_9allocatorIS1_EEE20__throw_length_errorB9nqe210106Ev
LBB35_20:
	bl	__ZSt28__throw_bad_array_new_lengthB9nqe210106v
LBB35_21:
Ltmp459:
	mov	x19, x0
	add	x0, sp, #8
	bl	__ZNSt3__114__split_bufferINS_6threadERNS_9allocatorIS1_EEED1Ev
	mov	x0, x19
	bl	__Unwind_Resume
Lfunc_end21:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table35:
Lexception21:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end21-Lcst_begin21
Lcst_begin21:
	.uleb128 Lfunc_begin21-Lfunc_begin21    ; >> Call Site 1 <<
	.uleb128 Ltmp457-Lfunc_begin21          ;   Call between Lfunc_begin21 and Ltmp457
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp457-Lfunc_begin21          ; >> Call Site 2 <<
	.uleb128 Ltmp458-Ltmp457                ;   Call between Ltmp457 and Ltmp458
	.uleb128 Ltmp459-Lfunc_begin21          ;     jumps to Ltmp459
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp458-Lfunc_begin21          ; >> Call Site 3 <<
	.uleb128 Lfunc_end21-Ltmp458            ;   Call between Ltmp458 and Lfunc_end21
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end21:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.private_extern	__ZNSt3__16threadC2B9nqe210106IZ5trialI6PackedEdiibEUlvE_JELi0EEEOT_DpOT0_ ; -- Begin function _ZNSt3__16threadC2B9nqe210106IZ5trialI6PackedEdiibEUlvE_JELi0EEEOT_DpOT0_
	.globl	__ZNSt3__16threadC2B9nqe210106IZ5trialI6PackedEdiibEUlvE_JELi0EEEOT_DpOT0_
	.weak_def_can_be_hidden	__ZNSt3__16threadC2B9nqe210106IZ5trialI6PackedEdiibEUlvE_JELi0EEEOT_DpOT0_
	.p2align	2
__ZNSt3__16threadC2B9nqe210106IZ5trialI6PackedEdiibEUlvE_JELi0EEEOT_DpOT0_: ; @_ZNSt3__16threadC2B9nqe210106IZ5trialI6PackedEdiibEUlvE_JELi0EEEOT_DpOT0_
Lfunc_begin22:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception22
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
	mov	x20, x1
	mov	x19, x0
	mov	w0, #8                          ; =0x8
	bl	__Znwm
	mov	x21, x0
Ltmp460:
	bl	__ZNSt3__115__thread_structC1Ev
Ltmp461:
; %bb.1:
	str	x21, [sp, #8]
Ltmp463:
	mov	w0, #32                         ; =0x20
	bl	__Znwm
Ltmp464:
; %bb.2:
	mov	x3, x0
	stp	x0, xzr, [sp]
	str	x21, [x0]
	ldr	q0, [x20]
	stur	q0, [x0, #8]
	ldr	x8, [x20, #16]
	str	x8, [x0, #24]
Ltmp466:
Lloh204:
	adrp	x2, __ZNSt3__114__thread_proxyB9nqe210106INS_5tupleIJNS_10unique_ptrINS_15__thread_structENS_14default_deleteIS3_EEEEZ5trialI6PackedEdiibEUlvE_EEEEEPvSB_@PAGE
Lloh205:
	add	x2, x2, __ZNSt3__114__thread_proxyB9nqe210106INS_5tupleIJNS_10unique_ptrINS_15__thread_structENS_14default_deleteIS3_EEEEZ5trialI6PackedEdiibEUlvE_EEEEEPvSB_@PAGEOFF
	mov	x0, x19
	mov	x1, #0                          ; =0x0
	bl	_pthread_create
Ltmp467:
; %bb.3:
	cbnz	w0, LBB36_5
; %bb.4:
	mov	x0, x19
	ldp	x29, x30, [sp, #48]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #32]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #64
	ret
LBB36_5:
Ltmp468:
Lloh206:
	adrp	x1, l_.str.20@PAGE
Lloh207:
	add	x1, x1, l_.str.20@PAGEOFF
	bl	__ZNSt3__120__throw_system_errorEiPKc
Ltmp469:
; %bb.6:
	brk	#0x1
LBB36_7:
Ltmp465:
	mov	x19, x0
	b	LBB36_10
LBB36_8:
Ltmp462:
	mov	x19, x0
	mov	x0, x21
	bl	__ZdlPv
	mov	x0, x19
	bl	__Unwind_Resume
LBB36_9:
Ltmp470:
	mov	x19, x0
	mov	x0, sp
	bl	__ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ5trialI6PackedEdiibEUlvE_EEENS3_IS9_EEED1B9nqe210106Ev
LBB36_10:
	add	x0, sp, #8
	bl	__ZNSt3__110unique_ptrINS_15__thread_structENS_14default_deleteIS1_EEED1B9nqe210106Ev
	mov	x0, x19
	bl	__Unwind_Resume
	.loh AdrpAdd	Lloh204, Lloh205
	.loh AdrpAdd	Lloh206, Lloh207
Lfunc_end22:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table36:
Lexception22:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end22-Lcst_begin22
Lcst_begin22:
	.uleb128 Lfunc_begin22-Lfunc_begin22    ; >> Call Site 1 <<
	.uleb128 Ltmp460-Lfunc_begin22          ;   Call between Lfunc_begin22 and Ltmp460
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp460-Lfunc_begin22          ; >> Call Site 2 <<
	.uleb128 Ltmp461-Ltmp460                ;   Call between Ltmp460 and Ltmp461
	.uleb128 Ltmp462-Lfunc_begin22          ;     jumps to Ltmp462
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp463-Lfunc_begin22          ; >> Call Site 3 <<
	.uleb128 Ltmp464-Ltmp463                ;   Call between Ltmp463 and Ltmp464
	.uleb128 Ltmp465-Lfunc_begin22          ;     jumps to Ltmp465
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp466-Lfunc_begin22          ; >> Call Site 4 <<
	.uleb128 Ltmp469-Ltmp466                ;   Call between Ltmp466 and Ltmp469
	.uleb128 Ltmp470-Lfunc_begin22          ;     jumps to Ltmp470
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp469-Lfunc_begin22          ; >> Call Site 5 <<
	.uleb128 Lfunc_end22-Ltmp469            ;   Call between Ltmp469 and Lfunc_end22
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end22:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.private_extern	__ZNSt3__114__thread_proxyB9nqe210106INS_5tupleIJNS_10unique_ptrINS_15__thread_structENS_14default_deleteIS3_EEEEZ5trialI6PackedEdiibEUlvE_EEEEEPvSB_ ; -- Begin function _ZNSt3__114__thread_proxyB9nqe210106INS_5tupleIJNS_10unique_ptrINS_15__thread_structENS_14default_deleteIS3_EEEEZ5trialI6PackedEdiibEUlvE_EEEEEPvSB_
	.globl	__ZNSt3__114__thread_proxyB9nqe210106INS_5tupleIJNS_10unique_ptrINS_15__thread_structENS_14default_deleteIS3_EEEEZ5trialI6PackedEdiibEUlvE_EEEEEPvSB_
	.weak_definition	__ZNSt3__114__thread_proxyB9nqe210106INS_5tupleIJNS_10unique_ptrINS_15__thread_structENS_14default_deleteIS3_EEEEZ5trialI6PackedEdiibEUlvE_EEEEEPvSB_
	.p2align	2
__ZNSt3__114__thread_proxyB9nqe210106INS_5tupleIJNS_10unique_ptrINS_15__thread_structENS_14default_deleteIS3_EEEEZ5trialI6PackedEdiibEUlvE_EEEEEPvSB_: ; @_ZNSt3__114__thread_proxyB9nqe210106INS_5tupleIJNS_10unique_ptrINS_15__thread_structENS_14default_deleteIS3_EEEEZ5trialI6PackedEdiibEUlvE_EEEEEPvSB_
Lfunc_begin23:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception23
; %bb.0:
	sub	sp, sp, #48
	stp	x20, x19, [sp, #16]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	mov	x19, x0
	str	x0, [sp, #8]
Ltmp471:
	bl	__ZNSt3__119__thread_local_dataEv
Ltmp472:
; %bb.1:
	ldr	x1, [x19]
	str	xzr, [x19]
	ldr	x0, [x0]
Ltmp473:
	bl	_pthread_setspecific
Ltmp474:
; %bb.2:
	ldr	x8, [x19, #16]
	ldr	w8, [x8]
	cmp	w8, #2
	b.ne	LBB37_4
; %bb.3:
	ldr	x8, [x19, #24]
	ldrsw	x9, [x19, #8]
	ldr	x8, [x8]
	mov	w10, #34464                     ; =0x86a0
	movk	w10, #1, lsl #16
	str	x10, [x8, x9, lsl #3]
	b	LBB37_6
LBB37_4:
	mov	w20, #34464                     ; =0x86a0
	movk	w20, #1, lsl #16
LBB37_5:                                ; =>This Inner Loop Header: Depth=1
	ldp	x9, x8, [x19, #16]
	ldr	w9, [x9]
	ldr	w10, [x19, #8]
	cmp	w9, #1
	csel	w9, wzr, w10, eq
	ldr	x8, [x8]
	add	x0, x8, w9, sxtw #3
	bl	_add_relaxed
	subs	w20, w20, #1
	b.ne	LBB37_5
LBB37_6:
	ldr	x0, [x19]
	str	xzr, [x19]
	cbz	x0, LBB37_8
; %bb.7:
	bl	__ZNSt3__115__thread_structD1Ev
	bl	__ZdlPv
LBB37_8:
	mov	x0, x19
	bl	__ZdlPv
	mov	x0, #0                          ; =0x0
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #48
	ret
LBB37_9:
Ltmp475:
	mov	x19, x0
	add	x0, sp, #8
	bl	__ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ5trialI6PackedEdiibEUlvE_EEENS3_IS9_EEED1B9nqe210106Ev
	mov	x0, x19
	bl	__Unwind_Resume
Lfunc_end23:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table37:
Lexception23:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end23-Lcst_begin23
Lcst_begin23:
	.uleb128 Ltmp471-Lfunc_begin23          ; >> Call Site 1 <<
	.uleb128 Ltmp474-Ltmp471                ;   Call between Ltmp471 and Ltmp474
	.uleb128 Ltmp475-Lfunc_begin23          ;     jumps to Ltmp475
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp474-Lfunc_begin23          ; >> Call Site 2 <<
	.uleb128 Lfunc_end23-Ltmp474            ;   Call between Ltmp474 and Lfunc_end23
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end23:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.private_extern	__ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ5trialI6PackedEdiibEUlvE_EEENS3_IS9_EEED1B9nqe210106Ev ; -- Begin function _ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ5trialI6PackedEdiibEUlvE_EEENS3_IS9_EEED1B9nqe210106Ev
	.globl	__ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ5trialI6PackedEdiibEUlvE_EEENS3_IS9_EEED1B9nqe210106Ev
	.weak_def_can_be_hidden	__ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ5trialI6PackedEdiibEUlvE_EEENS3_IS9_EEED1B9nqe210106Ev
	.p2align	2
__ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ5trialI6PackedEdiibEUlvE_EEENS3_IS9_EEED1B9nqe210106Ev: ; @_ZNSt3__110unique_ptrINS_5tupleIJNS0_INS_15__thread_structENS_14default_deleteIS2_EEEEZ5trialI6PackedEdiibEUlvE_EEENS3_IS9_EEED1B9nqe210106Ev
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
	cbz	x19, LBB38_4
; %bb.1:
	mov	x20, x0
	ldr	x0, [x19]
	str	xzr, [x19]
	cbz	x0, LBB38_3
; %bb.2:
	bl	__ZNSt3__115__thread_structD1Ev
	bl	__ZdlPv
LBB38_3:
	mov	x0, x19
	bl	__ZdlPv
	mov	x0, x20
LBB38_4:
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _Z5trialI6PackedEdiib.cold.1
__Z5trialI6PackedEdiib.cold.1:          ; @_Z5trialI6PackedEdiib.cold.1
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
	.p2align	2                               ; -- Begin function _Z5trialI8IsolatedILi64EEEdiib.cold.1
__Z5trialI8IsolatedILi64EEEdiib.cold.1: ; @_Z5trialI8IsolatedILi64EEEdiib.cold.1
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
	.p2align	2                               ; -- Begin function _Z5trialI8IsolatedILi128EEEdiib.cold.1
__Z5trialI8IsolatedILi128EEEdiib.cold.1: ; @_Z5trialI8IsolatedILi128EEEdiib.cold.1
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
	.p2align	2                               ; -- Begin function _Z5trialI8IsolatedILi256EEEdiib.cold.1
__Z5trialI8IsolatedILi256EEEdiib.cold.1: ; @_Z5trialI8IsolatedILi256EEEdiib.cold.1
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
	.asciz	"hw.cachelinesize"

l_.str.1:                               ; @.str.1
	.asciz	"reported_cacheline="

l_.str.2:                               ; @.str.2
	.asciz	"cacheline query unavailable; no assumed universal size\n"

l_.str.3:                               ; @.str.3
	.asciz	"packed"

l_.str.4:                               ; @.str.4
	.asciz	"pad64"

l_.str.5:                               ; @.str.5
	.asciz	"pad128"

l_.str.6:                               ; @.str.6
	.asciz	"pad256"

l_.str.7:                               ; @.str.7
	.asciz	"true_shared"

l_.str.8:                               ; @.str.8
	.asciz	"local"

l_.str.9:                               ; @.str.9
	.asciz	"PASS 216 batches totals verified; zero worker rejected\n"

l_.str.10:                              ; @.str.10
	.asciz	"basic_string"

l_.str.11:                              ; @.str.11
	.asciz	" CPU batch ms p50="

l_.str.12:                              ; @.str.12
	.asciz	" pmax="

l_.str.13:                              ; @.str.13
	.asciz	"vector"

l_.str.14:                              ; @.str.14
	.asciz	"workers [1,8]"

l_.str.15:                              ; @.str.15
	.asciz	"stride="

l_.str.16:                              ; @.str.16
	.asciz	" workers="

l_.str.17:                              ; @.str.17
	.asciz	" mode="

l_.str.18:                              ; @.str.18
	.asciz	" addresses"

l_.str.19:                              ; @.str.19
	.asciz	"lost increments"

l_.str.20:                              ; @.str.20
	.asciz	"thread constructor failed"

.subsections_via_symbols
