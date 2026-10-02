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
	.globl	_scalar                         ; -- Begin function scalar
	.p2align	2
_scalar:                                ; @scalar
	.cfi_startproc
; %bb.0:
	cbz	x2, LBB1_2
LBB1_1:                                 ; =>This Inner Loop Header: Depth=1
	ldrb	w8, [x0], #1
	add	w8, w8, #1
	strb	w8, [x1], #1
	subs	x2, x2, #1
	b.ne	LBB1_1
LBB1_2:
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_neon                           ; -- Begin function neon
	.p2align	2
_neon:                                  ; @neon
	.cfi_startproc
; %bb.0:
	cmp	x2, #16
	b.lo	LBB2_4
; %bb.1:
	mov	x8, #0                          ; =0x0
	movi.16b	v0, #1
	mov	x9, x2
LBB2_2:                                 ; =>This Inner Loop Header: Depth=1
	ldr	q1, [x0, x8]
	add.16b	v1, v1, v0
	str	q1, [x1, x8]
	add	x8, x8, #16
	sub	x9, x9, #16
	cmp	x9, #15
	b.hi	LBB2_2
; %bb.3:
	subs	x9, x2, x8
	b.hi	LBB2_5
	b	LBB2_7
LBB2_4:
	mov	x8, #0                          ; =0x0
	subs	x9, x2, x8
	b.ls	LBB2_7
LBB2_5:
	add	x10, x1, x8
	add	x8, x0, x8
LBB2_6:                                 ; =>This Inner Loop Header: Depth=1
	ldrb	w11, [x8], #1
	add	w11, w11, #1
	strb	w11, [x10], #1
	subs	x9, x9, #1
	b.ne	LBB2_6
LBB2_7:
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__Z7checkedPKhmPhmm             ; -- Begin function _Z7checkedPKhmPhmm
	.p2align	2
__Z7checkedPKhmPhmm:                    ; @_Z7checkedPKhmPhmm
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
	cmp	x4, x1
	b.hi	LBB3_6
; %bb.1:
	cmp	x4, x3
	b.hi	LBB3_6
; %bb.2:
	cbz	x4, LBB3_5
; %bb.3:
	cbz	x0, LBB3_6
; %bb.4:
	cbz	x2, LBB3_6
LBB3_5:
	mov	x1, x2
	mov	x2, x4
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
	b	_neon
LBB3_6:
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
; %bb.7:
	mov	x0, x19
	bl	__Z7checkedPKhmPhmm.cold.1
LBB3_8:
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
GCC_except_table3:
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
	.globl	_main                           ; -- Begin function main
	.p2align	2
_main:                                  ; @main
Lfunc_begin2:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception2
; %bb.0:
	sub	sp, sp, #176
	stp	d9, d8, [sp, #64]               ; 16-byte Folded Spill
	stp	x28, x27, [sp, #80]             ; 16-byte Folded Spill
	stp	x26, x25, [sp, #96]             ; 16-byte Folded Spill
	stp	x24, x23, [sp, #112]            ; 16-byte Folded Spill
	stp	x22, x21, [sp, #128]            ; 16-byte Folded Spill
	stp	x20, x19, [sp, #144]            ; 16-byte Folded Spill
	stp	x29, x30, [sp, #160]            ; 16-byte Folded Spill
	add	x29, sp, #160
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
	mov	x19, #0                         ; =0x0
Lloh6:
	adrp	x8, ___stack_chk_guard@GOTPAGE
Lloh7:
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
Lloh8:
	ldr	x8, [x8]
	str	x8, [sp, #56]
	b	LBB5_2
LBB5_1:                                 ;   in Loop: Header=BB5_2 Depth=1
	add	x19, x19, #1
	cmp	x19, #258
	b.eq	LBB5_18
LBB5_2:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB5_4 Depth 2
                                        ;       Child Loop BB5_9 Depth 3
	mov	x25, #0                         ; =0x0
	add	x21, x19, #2
	b	LBB5_4
LBB5_3:                                 ;   in Loop: Header=BB5_4 Depth=2
	mov	x0, x22
	bl	__ZdlPv
	mov	x0, x20
	bl	__ZdaPv
	add	x25, x25, #1
	cmp	x25, #16
	b.eq	LBB5_1
LBB5_4:                                 ;   Parent Loop BB5_2 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB5_9 Depth 3
Ltmp6:
	add	x0, x25, x19
	bl	__Znam
Ltmp7:
; %bb.5:                                ;   in Loop: Header=BB5_4 Depth=2
	mov	x20, x0
	add	x1, x25, x19
	bl	_bzero
Ltmp9:
	mov	x0, x21
	bl	__Znwm
Ltmp10:
; %bb.6:                                ;   in Loop: Header=BB5_4 Depth=2
	mov	x22, x0
	mov	w1, #165                        ; =0xa5
	mov	x2, x21
	bl	_memset
	cbz	x19, LBB5_10
; %bb.7:                                ;   in Loop: Header=BB5_4 Depth=2
Ltmp12:
	mov	x0, x19
	bl	__Znwm
Ltmp13:
; %bb.8:                                ;   in Loop: Header=BB5_4 Depth=2
	mov	x23, x0
	add	x26, x0, x19
	mov	x1, x19
	bl	_bzero
	mov	x8, #0                          ; =0x0
	add	x24, x20, x25
LBB5_9:                                 ;   Parent Loop BB5_2 Depth=1
                                        ;     Parent Loop BB5_4 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	add	w9, w8, w8, lsl #4
	strb	w9, [x24, x8]
	add	x8, x8, #1
	cmp	x19, x8
	b.ne	LBB5_9
	b	LBB5_11
LBB5_10:                                ;   in Loop: Header=BB5_4 Depth=2
	mov	x23, #0                         ; =0x0
	mov	x26, #0                         ; =0x0
	add	x24, x20, x25
LBB5_11:                                ;   in Loop: Header=BB5_4 Depth=2
	mov	x0, x24
	mov	x1, x23
	mov	x2, x19
	bl	_scalar
	add	x1, x22, #1
	mov	x0, x24
	mov	x2, x19
	bl	_neon
	sub	x2, x26, x23
	add	x1, x22, #1
	mov	x0, x23
	bl	_memcmp
	cbnz	w0, LBB5_16
; %bb.12:                               ;   in Loop: Header=BB5_4 Depth=2
	ldrb	w8, [x22]
	cmp	w8, #165
	b.ne	LBB5_16
; %bb.13:                               ;   in Loop: Header=BB5_4 Depth=2
	add	x8, x22, x21
	ldurb	w8, [x8, #-1]
	cmp	w8, #165
	b.ne	LBB5_16
; %bb.14:                               ;   in Loop: Header=BB5_4 Depth=2
	cbz	x23, LBB5_3
; %bb.15:                               ;   in Loop: Header=BB5_4 Depth=2
	mov	x0, x23
	bl	__ZdlPv
	b	LBB5_3
LBB5_16:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x24, x0
Ltmp15:
Lloh9:
	adrp	x1, l_.str@PAGE
Lloh10:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp16:
; %bb.17:
Ltmp18:
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
Ltmp19:
	b	LBB5_77
LBB5_18:
Ltmp21:
	add	x0, sp, #16
	bl	__ZN5GuardC2Ev
Ltmp22:
; %bb.19:
	mov	x23, #0                         ; =0x0
Lloh15:
	adrp	x24, l_constinit@PAGE
Lloh16:
	add	x24, x24, l_constinit@PAGEOFF
	b	LBB5_21
LBB5_20:                                ;   in Loop: Header=BB5_21 Depth=1
	add	x23, x23, #4
	cmp	x23, #32
	b.eq	LBB5_35
LBB5_21:                                ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB5_25 Depth 2
	ldr	w19, [x24, x23]
	ldp	x9, x8, [sp, #16]
	add	x8, x8, x9
	sub	x21, x8, x19
	cbz	w19, LBB5_26
; %bb.22:                               ;   in Loop: Header=BB5_21 Depth=1
Ltmp24:
	mov	x0, x19
	bl	__Znwm
Ltmp25:
; %bb.23:                               ;   in Loop: Header=BB5_21 Depth=1
	mov	x20, x0
	mov	x1, x19
	bl	_bzero
Ltmp27:
	mov	x0, x19
	bl	__Znwm
Ltmp28:
; %bb.24:                               ;   in Loop: Header=BB5_21 Depth=1
	mov	x22, x0
	add	x26, x20, x19
	add	x25, x0, x19
	mov	x1, x19
	bl	_bzero
	mov	x8, #0                          ; =0x0
LBB5_25:                                ;   Parent Loop BB5_21 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	strb	w8, [x21, x8]
	add	x8, x8, #1
	cmp	x19, x8
	b.ne	LBB5_25
	b	LBB5_27
LBB5_26:                                ;   in Loop: Header=BB5_21 Depth=1
	mov	x25, #0                         ; =0x0
	mov	x22, #0                         ; =0x0
	mov	x26, #0                         ; =0x0
	mov	x20, #0                         ; =0x0
LBB5_27:                                ;   in Loop: Header=BB5_21 Depth=1
	mov	x0, x21
	mov	x1, x22
	mov	x2, x19
	bl	_scalar
	mov	x0, x21
	mov	x1, x20
	mov	x2, x19
	bl	_neon
	sub	x2, x26, x20
	sub	x8, x25, x22
	cmp	x2, x8
	b.ne	LBB5_33
; %bb.28:                               ;   in Loop: Header=BB5_21 Depth=1
	mov	x0, x20
	mov	x1, x22
	bl	_memcmp
	cbnz	w0, LBB5_33
; %bb.29:                               ;   in Loop: Header=BB5_21 Depth=1
	cbz	x22, LBB5_31
; %bb.30:                               ;   in Loop: Header=BB5_21 Depth=1
	mov	x0, x22
	bl	__ZdlPv
LBB5_31:                                ;   in Loop: Header=BB5_21 Depth=1
	cbz	x20, LBB5_20
; %bb.32:                               ;   in Loop: Header=BB5_21 Depth=1
	mov	x0, x20
	bl	__ZdlPv
	b	LBB5_20
LBB5_33:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x23, x0
Ltmp30:
Lloh17:
	adrp	x1, l_.str@PAGE
Lloh18:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp31:
; %bb.34:
Ltmp33:
Lloh19:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh20:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh21:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh22:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x23
	bl	___cxa_throw
Ltmp34:
	b	LBB5_77
LBB5_35:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x20, x0
Ltmp36:
Lloh23:
	adrp	x1, l_.str.1@PAGE
Lloh24:
	add	x1, x1, l_.str.1@PAGEOFF
	bl	__ZNSt11logic_errorC2EPKc
Ltmp37:
; %bb.36:
Lloh25:
	adrp	x8, __ZTVSt16invalid_argument@GOTPAGE
Lloh26:
	ldr	x8, [x8, __ZTVSt16invalid_argument@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x20]
Ltmp39:
Lloh27:
	adrp	x1, __ZTISt16invalid_argument@GOTPAGE
Lloh28:
	ldr	x1, [x1, __ZTISt16invalid_argument@GOTPAGEOFF]
Lloh29:
	adrp	x2, __ZNSt16invalid_argumentD1Ev@GOTPAGE
Lloh30:
	ldr	x2, [x2, __ZNSt16invalid_argumentD1Ev@GOTPAGEOFF]
	mov	x0, x20
	bl	___cxa_throw
Ltmp40:
	b	LBB5_77
LBB5_37:
Ltmp41:
	mov	x19, x1
	mov	x21, x0
	b	LBB5_39
LBB5_38:
Ltmp38:
	mov	x19, x1
	mov	x21, x0
	mov	x0, x20
	bl	___cxa_free_exception
LBB5_39:
	cmp	w19, #2
	b.ne	LBB5_101
; %bb.40:
	mov	x0, x21
	bl	___cxa_begin_catch
Ltmp42:
	bl	___cxa_end_catch
Ltmp43:
; %bb.41:
Ltmp45:
	mov	w0, #4097                       ; =0x1001
	bl	__Znwm
Ltmp46:
; %bb.42:
	mov	x19, x0
	mov	w1, #250                        ; =0xfa
	mov	w2, #4097                       ; =0x1001
	bl	_memset
Ltmp48:
	mov	w0, #4097                       ; =0x1001
	bl	__Znwm
Ltmp49:
; %bb.43:
	mov	x20, x0
	mov	w1, #4097                       ; =0x1001
	bl	_bzero
	mov	x9, #0                          ; =0x0
	str	wzr, [sp, #12]
Lloh31:
	adrp	x10, _scalar@PAGE
Lloh32:
	add	x10, x10, _scalar@PAGEOFF
Lloh33:
	adrp	x8, _neon@PAGE
Lloh34:
	add	x8, x8, _neon@PAGEOFF
	stp	x10, x8, [sp, #40]
	mov	x23, #4575657221408423936       ; =0x3f80000000000000
LBB5_44:                                ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB5_47 Depth 2
                                        ;       Child Loop BB5_48 Depth 3
	mov	w28, #0                         ; =0x0
	mov	x22, #0                         ; =0x0
	mov	x25, #0                         ; =0x0
	mov	x21, #0                         ; =0x0
	str	x9, [sp]                        ; 8-byte Folded Spill
	add	x8, sp, #40
	ldr	x24, [x8, x9]
	b	LBB5_47
LBB5_45:                                ;   in Loop: Header=BB5_47 Depth=2
	str	d8, [x25], #8
LBB5_46:                                ;   in Loop: Header=BB5_47 Depth=2
	add	w28, w28, #1
	cmp	w28, #120
	b.eq	LBB5_58
LBB5_47:                                ;   Parent Loop BB5_44 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB5_48 Depth 3
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x26, x0
	mov	x27, #0                         ; =0x0
LBB5_48:                                ;   Parent Loop BB5_44 Depth=1
                                        ;     Parent Loop BB5_47 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
Ltmp51:
	mov	x0, x19
	mov	x1, x20
	mov	w2, #4097                       ; =0x1001
	blr	x24
Ltmp52:
; %bb.49:                               ;   in Loop: Header=BB5_48 Depth=3
	ldrb	w8, [x20, x27]
	ldr	w9, [sp, #12]
	add	w8, w9, w8
	str	w8, [sp, #12]
	add	x27, x27, #1
	cmp	x27, #128
	b.ne	LBB5_48
; %bb.50:                               ;   in Loop: Header=BB5_47 Depth=2
	cmp	w28, #19
	b.ls	LBB5_46
; %bb.51:                               ;   in Loop: Header=BB5_47 Depth=2
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	sub	x8, x0, x26
	scvtf	d0, x8
	mov	x8, #70368744177664             ; =0x400000000000
	movk	x8, #16527, lsl #48
	fmov	d1, x8
	fdiv	d0, d0, d1
	fmov	d1, x23
	fmul	d8, d0, d1
	cmp	x25, x22
	b.lo	LBB5_45
; %bb.52:                               ;   in Loop: Header=BB5_47 Depth=2
	sub	x26, x25, x21
	asr	x27, x26, #3
	add	x8, x27, #1
	lsr	x9, x8, #61
	cbnz	x9, LBB5_75
; %bb.53:                               ;   in Loop: Header=BB5_47 Depth=2
	sub	x9, x22, x21
	asr	x10, x9, #2
	cmp	x10, x8
	csel	x8, x10, x8, hi
	mov	x10, #9223372036854775800       ; =0x7ffffffffffffff8
	cmp	x9, x10
	mov	x9, #2305843009213693951        ; =0x1fffffffffffffff
	csel	x22, x8, x9, lo
	lsr	x8, x22, #61
	cbnz	x8, LBB5_76
; %bb.54:                               ;   in Loop: Header=BB5_47 Depth=2
	lsl	x0, x22, #3
Ltmp54:
	bl	__Znwm
Ltmp55:
; %bb.55:                               ;   in Loop: Header=BB5_47 Depth=2
	add	x25, x0, x26
	add	x22, x0, x22, lsl #3
	sub	x27, x25, x27, lsl #3
	str	d8, [x25], #8
	mov	x0, x27
	mov	x1, x21
	mov	x2, x26
	bl	_memcpy
	cbz	x21, LBB5_57
; %bb.56:                               ;   in Loop: Header=BB5_47 Depth=2
	mov	x0, x21
	bl	__ZdlPv
LBB5_57:                                ;   in Loop: Header=BB5_47 Depth=2
	mov	x21, x27
	b	LBB5_46
LBB5_58:                                ;   in Loop: Header=BB5_44 Depth=1
Ltmp62:
	add	x2, sp, #39
	mov	x0, x21
	mov	x1, x25
	bl	__ZNSt3__16__sortIRNS_6__lessIddEEPdEEvT0_S5_T_
Ltmp63:
; %bb.59:                               ;   in Loop: Header=BB5_44 Depth=1
Lloh35:
	adrp	x8, _scalar@PAGE
Lloh36:
	add	x8, x8, _scalar@PAGEOFF
	cmp	x24, x8
Lloh37:
	adrp	x8, l_.str.3@PAGE
Lloh38:
	add	x8, x8, l_.str.3@PAGEOFF
Lloh39:
	adrp	x9, l_.str.2@PAGE
Lloh40:
	add	x9, x9, l_.str.2@PAGEOFF
	csel	x1, x9, x8, eq
	mov	w8, #4                          ; =0x4
	mov	w9, #6                          ; =0x6
	csel	x2, x9, x8, eq
Ltmp64:
Lloh41:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh42:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp65:
; %bb.60:                               ;   in Loop: Header=BB5_44 Depth=1
Ltmp66:
Lloh43:
	adrp	x1, l_.str.4@PAGE
Lloh44:
	add	x1, x1, l_.str.4@PAGEOFF
	mov	w2, #23                         ; =0x17
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp67:
; %bb.61:                               ;   in Loop: Header=BB5_44 Depth=1
	ldr	d0, [x21, #392]
Ltmp68:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp69:
; %bb.62:                               ;   in Loop: Header=BB5_44 Depth=1
Ltmp70:
Lloh45:
	adrp	x1, l_.str.5@PAGE
Lloh46:
	add	x1, x1, l_.str.5@PAGEOFF
	mov	w2, #5                          ; =0x5
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp71:
; %bb.63:                               ;   in Loop: Header=BB5_44 Depth=1
	ldr	d0, [x21, #752]
Ltmp72:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp73:
; %bb.64:                               ;   in Loop: Header=BB5_44 Depth=1
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #39]
Ltmp74:
	add	x1, sp, #39
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp75:
; %bb.65:                               ;   in Loop: Header=BB5_44 Depth=1
	mov	x0, x21
	bl	__ZdlPv
	ldr	x9, [sp]                        ; 8-byte Folded Reload
	add	x9, x9, #8
	cmp	x9, #16
	b.ne	LBB5_44
; %bb.66:
Ltmp77:
Lloh47:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh48:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh49:
	adrp	x1, l_.str.6@PAGE
Lloh50:
	add	x1, x1, l_.str.6@PAGEOFF
	mov	w2, #5                          ; =0x5
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp78:
; %bb.67:
Ltmp79:
	mov	w1, #4128                       ; =0x1020
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp80:
; %bb.68:
Ltmp81:
Lloh51:
	adrp	x1, l_.str.7@PAGE
Lloh52:
	add	x1, x1, l_.str.7@PAGEOFF
	mov	w2, #69                         ; =0x45
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp82:
; %bb.69:
	ldr	w1, [sp, #12]
Ltmp83:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEj
Ltmp84:
; %bb.70:
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #40]
Ltmp85:
	add	x1, sp, #40
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp86:
; %bb.71:
	mov	x0, x20
	bl	__ZdlPv
	mov	x0, x19
	bl	__ZdlPv
	ldp	x8, x0, [sp, #16]
	lsl	x1, x8, #1
Ltmp104:
	bl	_munmap
Ltmp105:
; %bb.72:
	cbz	w0, LBB5_74
; %bb.73:
Ltmp106:
Lloh53:
	adrp	x0, __ZNSt3__14cerrE@GOTPAGE
Lloh54:
	ldr	x0, [x0, __ZNSt3__14cerrE@GOTPAGEOFF]
Lloh55:
	adrp	x1, l_.str.11@PAGE
Lloh56:
	add	x1, x1, l_.str.11@PAGEOFF
	mov	w2, #22                         ; =0x16
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp107:
LBB5_74:
	mov	w0, #0                          ; =0x0
	b	LBB5_120
LBB5_75:
Ltmp59:
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_length_errorB9nqe210106Ev
Ltmp60:
	b	LBB5_77
LBB5_76:
Ltmp57:
	bl	__ZSt28__throw_bad_array_new_lengthB9nqe210106v
Ltmp58:
LBB5_77:
	brk	#0x1
LBB5_78:
Ltmp50:
	mov	x22, x1
	mov	x23, x0
	b	LBB5_90
LBB5_79:
Ltmp47:
	mov	x22, x1
	mov	x23, x0
	b	LBB5_91
LBB5_80:
Ltmp44:
	b	LBB5_94
LBB5_81:
Ltmp108:
	b	LBB5_126
LBB5_82:
Ltmp87:
	mov	x22, x1
	mov	x23, x0
	b	LBB5_89
LBB5_83:
Ltmp76:
	b	LBB5_87
LBB5_84:
Ltmp56:
	b	LBB5_87
LBB5_85:
Ltmp61:
	b	LBB5_87
LBB5_86:
Ltmp53:
LBB5_87:
	mov	x22, x1
	mov	x23, x0
	cbz	x21, LBB5_89
; %bb.88:
	mov	x0, x21
	bl	__ZdlPv
LBB5_89:
	mov	x0, x20
	bl	__ZdlPv
LBB5_90:
	mov	x0, x19
	bl	__ZdlPv
LBB5_91:
	mov	x21, x23
	mov	x19, x22
	b	LBB5_101
LBB5_92:
Ltmp29:
	mov	x19, x1
	mov	x21, x0
	b	LBB5_100
LBB5_93:
Ltmp26:
LBB5_94:
	mov	x19, x1
	mov	x21, x0
	b	LBB5_101
LBB5_95:
Ltmp35:
	mov	x19, x1
	mov	x21, x0
	b	LBB5_97
LBB5_96:
Ltmp32:
	mov	x19, x1
	mov	x21, x0
	mov	x0, x23
	bl	___cxa_free_exception
LBB5_97:
	cbz	x22, LBB5_99
; %bb.98:
	mov	x0, x22
	bl	__ZdlPv
LBB5_99:
	cbz	x20, LBB5_101
LBB5_100:
	mov	x0, x20
	bl	__ZdlPv
LBB5_101:
	ldp	x8, x0, [sp, #16]
	lsl	x1, x8, #1
Ltmp88:
	bl	_munmap
Ltmp89:
; %bb.102:
	cbz	w0, LBB5_115
; %bb.103:
Ltmp90:
Lloh57:
	adrp	x0, __ZNSt3__14cerrE@GOTPAGE
Lloh58:
	ldr	x0, [x0, __ZNSt3__14cerrE@GOTPAGEOFF]
Lloh59:
	adrp	x1, l_.str.11@PAGE
Lloh60:
	add	x1, x1, l_.str.11@PAGEOFF
	mov	w2, #22                         ; =0x16
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp91:
	b	LBB5_115
LBB5_104:
Ltmp92:
	b	LBB5_126
LBB5_105:
Ltmp23:
	b	LBB5_108
LBB5_106:
Ltmp14:
	mov	x19, x1
	mov	x21, x0
	b	LBB5_113
LBB5_107:
Ltmp8:
LBB5_108:
	mov	x19, x1
	mov	x21, x0
	b	LBB5_115
LBB5_109:
Ltmp11:
	mov	x19, x1
	mov	x21, x0
	b	LBB5_114
LBB5_110:
Ltmp20:
	mov	x19, x1
	mov	x21, x0
	cbnz	x23, LBB5_112
	b	LBB5_113
LBB5_111:
Ltmp17:
	mov	x19, x1
	mov	x21, x0
	mov	x0, x24
	bl	___cxa_free_exception
	cbz	x23, LBB5_113
LBB5_112:
	mov	x0, x23
	bl	__ZdlPv
LBB5_113:
	mov	x0, x22
	bl	__ZdlPv
LBB5_114:
	mov	x0, x20
	bl	__ZdaPv
LBB5_115:
	cmp	w19, #1
	b.ne	LBB5_127
; %bb.116:
	mov	x0, x21
	bl	___cxa_begin_catch
	ldr	x8, [x0]
	ldr	x8, [x8, #16]
	blr	x8
	mov	x19, x0
	bl	_strlen
	mov	x2, x0
Ltmp93:
Lloh61:
	adrp	x0, __ZNSt3__14cerrE@GOTPAGE
Lloh62:
	ldr	x0, [x0, __ZNSt3__14cerrE@GOTPAGEOFF]
	mov	x1, x19
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp94:
; %bb.117:
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #16]
Ltmp95:
	add	x1, sp, #16
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp96:
; %bb.118:
Ltmp101:
	bl	___cxa_end_catch
Ltmp102:
; %bb.119:
	mov	w0, #1                          ; =0x1
LBB5_120:
	ldr	x8, [sp, #56]
Lloh63:
	adrp	x9, ___stack_chk_guard@GOTPAGE
Lloh64:
	ldr	x9, [x9, ___stack_chk_guard@GOTPAGEOFF]
Lloh65:
	ldr	x9, [x9]
	cmp	x9, x8
	b.ne	LBB5_122
; %bb.121:
	ldp	x29, x30, [sp, #160]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #144]            ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #128]            ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #112]            ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #96]             ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #80]             ; 16-byte Folded Reload
	ldp	d9, d8, [sp, #64]               ; 16-byte Folded Reload
	add	sp, sp, #176
	ret
LBB5_122:
	bl	___stack_chk_fail
LBB5_123:
Ltmp103:
	mov	x21, x0
	mov	x0, x21
	bl	__Unwind_Resume
LBB5_124:
Ltmp97:
	mov	x21, x0
Ltmp98:
	bl	___cxa_end_catch
Ltmp99:
	b	LBB5_127
LBB5_125:
Ltmp100:
LBB5_126:
	mov	x21, x0
	cbnz	w1, LBB5_128
LBB5_127:
	mov	x0, x21
	bl	__Unwind_Resume
LBB5_128:
	mov	x0, x21
	bl	___clang_call_terminate
	.loh AdrpLdrGotLdr	Lloh6, Lloh7, Lloh8
	.loh AdrpAdd	Lloh9, Lloh10
	.loh AdrpLdrGot	Lloh13, Lloh14
	.loh AdrpLdrGot	Lloh11, Lloh12
	.loh AdrpAdd	Lloh15, Lloh16
	.loh AdrpAdd	Lloh17, Lloh18
	.loh AdrpLdrGot	Lloh21, Lloh22
	.loh AdrpLdrGot	Lloh19, Lloh20
	.loh AdrpAdd	Lloh23, Lloh24
	.loh AdrpLdrGot	Lloh29, Lloh30
	.loh AdrpLdrGot	Lloh27, Lloh28
	.loh AdrpLdrGot	Lloh25, Lloh26
	.loh AdrpAdd	Lloh33, Lloh34
	.loh AdrpAdd	Lloh31, Lloh32
	.loh AdrpLdrGot	Lloh41, Lloh42
	.loh AdrpAdd	Lloh39, Lloh40
	.loh AdrpAdd	Lloh37, Lloh38
	.loh AdrpAdd	Lloh35, Lloh36
	.loh AdrpAdd	Lloh43, Lloh44
	.loh AdrpAdd	Lloh45, Lloh46
	.loh AdrpAdd	Lloh49, Lloh50
	.loh AdrpLdrGot	Lloh47, Lloh48
	.loh AdrpAdd	Lloh51, Lloh52
	.loh AdrpAdd	Lloh55, Lloh56
	.loh AdrpLdrGot	Lloh53, Lloh54
	.loh AdrpAdd	Lloh59, Lloh60
	.loh AdrpLdrGot	Lloh57, Lloh58
	.loh AdrpLdrGot	Lloh61, Lloh62
	.loh AdrpLdrGotLdr	Lloh63, Lloh64, Lloh65
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
	.uleb128 Ltmp9-Ltmp7                    ;   Call between Ltmp7 and Ltmp9
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp9-Lfunc_begin2             ; >> Call Site 3 <<
	.uleb128 Ltmp10-Ltmp9                   ;   Call between Ltmp9 and Ltmp10
	.uleb128 Ltmp11-Lfunc_begin2            ;     jumps to Ltmp11
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp10-Lfunc_begin2            ; >> Call Site 4 <<
	.uleb128 Ltmp12-Ltmp10                  ;   Call between Ltmp10 and Ltmp12
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp12-Lfunc_begin2            ; >> Call Site 5 <<
	.uleb128 Ltmp13-Ltmp12                  ;   Call between Ltmp12 and Ltmp13
	.uleb128 Ltmp14-Lfunc_begin2            ;     jumps to Ltmp14
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp13-Lfunc_begin2            ; >> Call Site 6 <<
	.uleb128 Ltmp15-Ltmp13                  ;   Call between Ltmp13 and Ltmp15
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp15-Lfunc_begin2            ; >> Call Site 7 <<
	.uleb128 Ltmp16-Ltmp15                  ;   Call between Ltmp15 and Ltmp16
	.uleb128 Ltmp17-Lfunc_begin2            ;     jumps to Ltmp17
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp18-Lfunc_begin2            ; >> Call Site 8 <<
	.uleb128 Ltmp19-Ltmp18                  ;   Call between Ltmp18 and Ltmp19
	.uleb128 Ltmp20-Lfunc_begin2            ;     jumps to Ltmp20
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp21-Lfunc_begin2            ; >> Call Site 9 <<
	.uleb128 Ltmp22-Ltmp21                  ;   Call between Ltmp21 and Ltmp22
	.uleb128 Ltmp23-Lfunc_begin2            ;     jumps to Ltmp23
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp24-Lfunc_begin2            ; >> Call Site 10 <<
	.uleb128 Ltmp25-Ltmp24                  ;   Call between Ltmp24 and Ltmp25
	.uleb128 Ltmp26-Lfunc_begin2            ;     jumps to Ltmp26
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp25-Lfunc_begin2            ; >> Call Site 11 <<
	.uleb128 Ltmp27-Ltmp25                  ;   Call between Ltmp25 and Ltmp27
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp27-Lfunc_begin2            ; >> Call Site 12 <<
	.uleb128 Ltmp28-Ltmp27                  ;   Call between Ltmp27 and Ltmp28
	.uleb128 Ltmp29-Lfunc_begin2            ;     jumps to Ltmp29
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp28-Lfunc_begin2            ; >> Call Site 13 <<
	.uleb128 Ltmp30-Ltmp28                  ;   Call between Ltmp28 and Ltmp30
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp30-Lfunc_begin2            ; >> Call Site 14 <<
	.uleb128 Ltmp31-Ltmp30                  ;   Call between Ltmp30 and Ltmp31
	.uleb128 Ltmp32-Lfunc_begin2            ;     jumps to Ltmp32
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp33-Lfunc_begin2            ; >> Call Site 15 <<
	.uleb128 Ltmp34-Ltmp33                  ;   Call between Ltmp33 and Ltmp34
	.uleb128 Ltmp35-Lfunc_begin2            ;     jumps to Ltmp35
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp34-Lfunc_begin2            ; >> Call Site 16 <<
	.uleb128 Ltmp36-Ltmp34                  ;   Call between Ltmp34 and Ltmp36
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp36-Lfunc_begin2            ; >> Call Site 17 <<
	.uleb128 Ltmp37-Ltmp36                  ;   Call between Ltmp36 and Ltmp37
	.uleb128 Ltmp38-Lfunc_begin2            ;     jumps to Ltmp38
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp39-Lfunc_begin2            ; >> Call Site 18 <<
	.uleb128 Ltmp40-Ltmp39                  ;   Call between Ltmp39 and Ltmp40
	.uleb128 Ltmp41-Lfunc_begin2            ;     jumps to Ltmp41
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp40-Lfunc_begin2            ; >> Call Site 19 <<
	.uleb128 Ltmp42-Ltmp40                  ;   Call between Ltmp40 and Ltmp42
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp42-Lfunc_begin2            ; >> Call Site 20 <<
	.uleb128 Ltmp43-Ltmp42                  ;   Call between Ltmp42 and Ltmp43
	.uleb128 Ltmp44-Lfunc_begin2            ;     jumps to Ltmp44
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp45-Lfunc_begin2            ; >> Call Site 21 <<
	.uleb128 Ltmp46-Ltmp45                  ;   Call between Ltmp45 and Ltmp46
	.uleb128 Ltmp47-Lfunc_begin2            ;     jumps to Ltmp47
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp46-Lfunc_begin2            ; >> Call Site 22 <<
	.uleb128 Ltmp48-Ltmp46                  ;   Call between Ltmp46 and Ltmp48
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp48-Lfunc_begin2            ; >> Call Site 23 <<
	.uleb128 Ltmp49-Ltmp48                  ;   Call between Ltmp48 and Ltmp49
	.uleb128 Ltmp50-Lfunc_begin2            ;     jumps to Ltmp50
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp49-Lfunc_begin2            ; >> Call Site 24 <<
	.uleb128 Ltmp51-Ltmp49                  ;   Call between Ltmp49 and Ltmp51
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp51-Lfunc_begin2            ; >> Call Site 25 <<
	.uleb128 Ltmp52-Ltmp51                  ;   Call between Ltmp51 and Ltmp52
	.uleb128 Ltmp53-Lfunc_begin2            ;     jumps to Ltmp53
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp54-Lfunc_begin2            ; >> Call Site 26 <<
	.uleb128 Ltmp55-Ltmp54                  ;   Call between Ltmp54 and Ltmp55
	.uleb128 Ltmp56-Lfunc_begin2            ;     jumps to Ltmp56
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp55-Lfunc_begin2            ; >> Call Site 27 <<
	.uleb128 Ltmp62-Ltmp55                  ;   Call between Ltmp55 and Ltmp62
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp62-Lfunc_begin2            ; >> Call Site 28 <<
	.uleb128 Ltmp75-Ltmp62                  ;   Call between Ltmp62 and Ltmp75
	.uleb128 Ltmp76-Lfunc_begin2            ;     jumps to Ltmp76
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp77-Lfunc_begin2            ; >> Call Site 29 <<
	.uleb128 Ltmp86-Ltmp77                  ;   Call between Ltmp77 and Ltmp86
	.uleb128 Ltmp87-Lfunc_begin2            ;     jumps to Ltmp87
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp104-Lfunc_begin2           ; >> Call Site 30 <<
	.uleb128 Ltmp107-Ltmp104                ;   Call between Ltmp104 and Ltmp107
	.uleb128 Ltmp108-Lfunc_begin2           ;     jumps to Ltmp108
	.byte	9                               ;   On action: 5
	.uleb128 Ltmp59-Lfunc_begin2            ; >> Call Site 31 <<
	.uleb128 Ltmp58-Ltmp59                  ;   Call between Ltmp59 and Ltmp58
	.uleb128 Ltmp61-Lfunc_begin2            ;     jumps to Ltmp61
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp58-Lfunc_begin2            ; >> Call Site 32 <<
	.uleb128 Ltmp88-Ltmp58                  ;   Call between Ltmp58 and Ltmp88
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp88-Lfunc_begin2            ; >> Call Site 33 <<
	.uleb128 Ltmp91-Ltmp88                  ;   Call between Ltmp88 and Ltmp91
	.uleb128 Ltmp92-Lfunc_begin2            ;     jumps to Ltmp92
	.byte	9                               ;   On action: 5
	.uleb128 Ltmp91-Lfunc_begin2            ; >> Call Site 34 <<
	.uleb128 Ltmp93-Ltmp91                  ;   Call between Ltmp91 and Ltmp93
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp93-Lfunc_begin2            ; >> Call Site 35 <<
	.uleb128 Ltmp96-Ltmp93                  ;   Call between Ltmp93 and Ltmp96
	.uleb128 Ltmp97-Lfunc_begin2            ;     jumps to Ltmp97
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp101-Lfunc_begin2           ; >> Call Site 36 <<
	.uleb128 Ltmp102-Ltmp101                ;   Call between Ltmp101 and Ltmp102
	.uleb128 Ltmp103-Lfunc_begin2           ;     jumps to Ltmp103
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp102-Lfunc_begin2           ; >> Call Site 37 <<
	.uleb128 Ltmp98-Ltmp102                 ;   Call between Ltmp102 and Ltmp98
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp98-Lfunc_begin2            ; >> Call Site 38 <<
	.uleb128 Ltmp99-Ltmp98                  ;   Call between Ltmp98 and Ltmp99
	.uleb128 Ltmp100-Lfunc_begin2           ;     jumps to Ltmp100
	.byte	9                               ;   On action: 5
	.uleb128 Ltmp99-Lfunc_begin2            ; >> Call Site 39 <<
	.uleb128 Lfunc_end2-Ltmp99              ;   Call between Ltmp99 and Lfunc_end2
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
Ltmp146:                                ; TypeInfo 2
	.long	__ZTISt16invalid_argument@GOT-Ltmp146
Ltmp147:                                ; TypeInfo 1
	.long	__ZTISt9exception@GOT-Ltmp147
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
	.globl	__ZN5GuardC2Ev                  ; -- Begin function _ZN5GuardC2Ev
	.weak_def_can_be_hidden	__ZN5GuardC2Ev
	.p2align	2
__ZN5GuardC2Ev:                         ; @_ZN5GuardC2Ev
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
	mov	x19, x0
	mov	w0, #29                         ; =0x1d
	bl	_sysconf
	stp	x0, xzr, [x19]
	sub	x8, x0, #1
	mov	w9, #16777215                   ; =0xffffff
	cmp	x8, x9
	b.hs	LBB7_4
; %bb.1:
	lsl	x1, x0, #1
	mov	x0, #0                          ; =0x0
	mov	w2, #3                          ; =0x3
	mov	w3, #4098                       ; =0x1002
	mov	w4, #-1                         ; =0xffffffff
	mov	x5, #0                          ; =0x0
	bl	_mmap
	cmn	x0, #1
	b.eq	LBB7_6
; %bb.2:
	str	x0, [x19, #8]
	ldr	x1, [x19]
	add	x0, x0, x1
	mov	w2, #0                          ; =0x0
	bl	_mprotect
	cbnz	w0, LBB7_8
; %bb.3:
	mov	x0, x19
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
	ret
LBB7_4:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp109:
Lloh66:
	adrp	x1, l_.str@PAGE
Lloh67:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp110:
; %bb.5:
	mov	x0, x19
	bl	__ZN5GuardC2Ev.cold.1
LBB7_6:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp115:
Lloh68:
	adrp	x1, l_.str.8@PAGE
Lloh69:
	add	x1, x1, l_.str.8@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp116:
; %bb.7:
	mov	x0, x19
	bl	__ZN5GuardC2Ev.cold.3
LBB7_8:
	ldp	x8, x0, [x19]
	lsl	x1, x8, #1
	bl	_munmap
	cbz	w0, LBB7_10
; %bb.9:
Lloh70:
	adrp	x0, __ZNSt3__14cerrE@GOTPAGE
Lloh71:
	ldr	x0, [x0, __ZNSt3__14cerrE@GOTPAGEOFF]
Lloh72:
	adrp	x1, l_.str.9@PAGE
Lloh73:
	add	x1, x1, l_.str.9@PAGEOFF
	mov	w2, #23                         ; =0x17
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
LBB7_10:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp112:
Lloh74:
	adrp	x1, l_.str.10@PAGE
Lloh75:
	add	x1, x1, l_.str.10@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp113:
; %bb.11:
	mov	x0, x19
	bl	__ZN5GuardC2Ev.cold.2
LBB7_12:
Ltmp114:
	b	LBB7_15
LBB7_13:
Ltmp117:
	b	LBB7_15
LBB7_14:
Ltmp111:
LBB7_15:
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x0, x20
	bl	__Unwind_Resume
	.loh AdrpAdd	Lloh66, Lloh67
	.loh AdrpAdd	Lloh68, Lloh69
	.loh AdrpAdd	Lloh72, Lloh73
	.loh AdrpLdrGot	Lloh70, Lloh71
	.loh AdrpAdd	Lloh74, Lloh75
Lfunc_end3:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table7:
Lexception3:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end3-Lcst_begin3
Lcst_begin3:
	.uleb128 Lfunc_begin3-Lfunc_begin3      ; >> Call Site 1 <<
	.uleb128 Ltmp109-Lfunc_begin3           ;   Call between Lfunc_begin3 and Ltmp109
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp109-Lfunc_begin3           ; >> Call Site 2 <<
	.uleb128 Ltmp110-Ltmp109                ;   Call between Ltmp109 and Ltmp110
	.uleb128 Ltmp111-Lfunc_begin3           ;     jumps to Ltmp111
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp110-Lfunc_begin3           ; >> Call Site 3 <<
	.uleb128 Ltmp115-Ltmp110                ;   Call between Ltmp110 and Ltmp115
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp115-Lfunc_begin3           ; >> Call Site 4 <<
	.uleb128 Ltmp116-Ltmp115                ;   Call between Ltmp115 and Ltmp116
	.uleb128 Ltmp117-Lfunc_begin3           ;     jumps to Ltmp117
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp116-Lfunc_begin3           ; >> Call Site 5 <<
	.uleb128 Ltmp112-Ltmp116                ;   Call between Ltmp116 and Ltmp112
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp112-Lfunc_begin3           ; >> Call Site 6 <<
	.uleb128 Ltmp113-Ltmp112                ;   Call between Ltmp112 and Ltmp113
	.uleb128 Ltmp114-Lfunc_begin3           ;     jumps to Ltmp114
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp113-Lfunc_begin3           ; >> Call Site 7 <<
	.uleb128 Lfunc_end3-Ltmp113             ;   Call between Ltmp113 and Lfunc_end3
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end3:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
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
Ltmp118:
	add	x0, sp, #8
	mov	x1, x19
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryC1ERS3_
Ltmp119:
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
Ltmp121:
	add	x8, sp, #24
	mov	x25, x4
	mov	x0, x4
	bl	__ZNKSt3__18ios_base6getlocEv
Ltmp122:
; %bb.4:
Ltmp123:
Lloh76:
	adrp	x1, __ZNSt3__15ctypeIcE2idE@GOTPAGE
Lloh77:
	ldr	x1, [x1, __ZNSt3__15ctypeIcE2idE@GOTPAGEOFF]
	add	x0, sp, #24
	bl	__ZNKSt3__16locale9use_facetERNS0_2idE
Ltmp124:
; %bb.5:
	ldr	x8, [x0]
	ldr	x8, [x8, #56]
Ltmp125:
	mov	w1, #32                         ; =0x20
	blr	x8
Ltmp126:
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
Ltmp128:
	sxtb	w5, w23
	mov	x0, x22
	mov	x1, x20
	bl	__ZNSt3__116__pad_and_outputB9nqe210106IcNS_11char_traitsIcEEEENS_19ostreambuf_iteratorIT_T0_EES6_PKS4_S8_S8_RNS_8ios_baseES4_
Ltmp129:
; %bb.8:
	cbnz	x0, LBB8_10
; %bb.9:
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
	add	x0, x19, x8
	ldr	w8, [x0, #32]
	mov	w9, #5                          ; =0x5
Ltmp131:
	orr	w1, w8, w9
	bl	__ZNSt3__18ios_base5clearEj
Ltmp132:
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
Ltmp133:
	b	LBB8_15
LBB8_13:
Ltmp127:
	mov	x20, x0
	add	x0, sp, #24
	bl	__ZNSt3__16localeD1Ev
	b	LBB8_16
LBB8_14:
Ltmp130:
LBB8_15:
	mov	x20, x0
LBB8_16:
	add	x0, sp, #8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryD1Ev
	b	LBB8_18
LBB8_17:
Ltmp120:
	mov	x20, x0
LBB8_18:
	mov	x0, x20
	bl	___cxa_begin_catch
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
Ltmp134:
	add	x0, x19, x8
	bl	__ZNSt3__18ios_base33__set_badbit_and_consider_rethrowEv
Ltmp135:
; %bb.19:
	bl	___cxa_end_catch
	b	LBB8_11
LBB8_20:
Ltmp136:
	mov	x19, x0
Ltmp137:
	bl	___cxa_end_catch
Ltmp138:
; %bb.21:
	mov	x0, x19
	bl	__Unwind_Resume
LBB8_22:
Ltmp139:
	bl	___clang_call_terminate
	.loh AdrpLdrGot	Lloh76, Lloh77
Lfunc_end4:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table8:
Lexception4:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase1-Lttbaseref1
Lttbaseref1:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end4-Lcst_begin4
Lcst_begin4:
	.uleb128 Ltmp118-Lfunc_begin4           ; >> Call Site 1 <<
	.uleb128 Ltmp119-Ltmp118                ;   Call between Ltmp118 and Ltmp119
	.uleb128 Ltmp120-Lfunc_begin4           ;     jumps to Ltmp120
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp121-Lfunc_begin4           ; >> Call Site 2 <<
	.uleb128 Ltmp122-Ltmp121                ;   Call between Ltmp121 and Ltmp122
	.uleb128 Ltmp130-Lfunc_begin4           ;     jumps to Ltmp130
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp123-Lfunc_begin4           ; >> Call Site 3 <<
	.uleb128 Ltmp126-Ltmp123                ;   Call between Ltmp123 and Ltmp126
	.uleb128 Ltmp127-Lfunc_begin4           ;     jumps to Ltmp127
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp128-Lfunc_begin4           ; >> Call Site 4 <<
	.uleb128 Ltmp129-Ltmp128                ;   Call between Ltmp128 and Ltmp129
	.uleb128 Ltmp130-Lfunc_begin4           ;     jumps to Ltmp130
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp131-Lfunc_begin4           ; >> Call Site 5 <<
	.uleb128 Ltmp132-Ltmp131                ;   Call between Ltmp131 and Ltmp132
	.uleb128 Ltmp133-Lfunc_begin4           ;     jumps to Ltmp133
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp132-Lfunc_begin4           ; >> Call Site 6 <<
	.uleb128 Ltmp134-Ltmp132                ;   Call between Ltmp132 and Ltmp134
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp134-Lfunc_begin4           ; >> Call Site 7 <<
	.uleb128 Ltmp135-Ltmp134                ;   Call between Ltmp134 and Ltmp135
	.uleb128 Ltmp136-Lfunc_begin4           ;     jumps to Ltmp136
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp135-Lfunc_begin4           ; >> Call Site 8 <<
	.uleb128 Ltmp137-Ltmp135                ;   Call between Ltmp135 and Ltmp137
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp137-Lfunc_begin4           ; >> Call Site 9 <<
	.uleb128 Ltmp138-Ltmp137                ;   Call between Ltmp137 and Ltmp138
	.uleb128 Ltmp139-Lfunc_begin4           ;     jumps to Ltmp139
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp138-Lfunc_begin4           ; >> Call Site 10 <<
	.uleb128 Lfunc_end4-Ltmp138             ;   Call between Ltmp138 and Lfunc_end4
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
Ltmp140:
	mov	x0, x19
	mov	x2, x24
	blr	x8
Ltmp141:
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
Ltmp142:
	mov	x19, x0
	ldrsb	w8, [sp, #31]
	tbz	w8, #31, LBB9_20
; %bb.19:
	ldr	x0, [sp, #8]
	bl	__ZdlPv
LBB9_20:
	mov	x0, x19
	bl	__Unwind_Resume
Lfunc_end5:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table9:
Lexception5:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end5-Lcst_begin5
Lcst_begin5:
	.uleb128 Lfunc_begin5-Lfunc_begin5      ; >> Call Site 1 <<
	.uleb128 Ltmp140-Lfunc_begin5           ;   Call between Lfunc_begin5 and Ltmp140
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp140-Lfunc_begin5           ; >> Call Site 2 <<
	.uleb128 Ltmp141-Ltmp140                ;   Call between Ltmp140 and Ltmp141
	.uleb128 Ltmp142-Lfunc_begin5           ;     jumps to Ltmp142
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp141-Lfunc_begin5           ; >> Call Site 3 <<
	.uleb128 Lfunc_end5-Ltmp141             ;   Call between Ltmp141 and Lfunc_end5
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
Lloh78:
	adrp	x0, l_.str.12@PAGE
Lloh79:
	add	x0, x0, l_.str.12@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh78, Lloh79
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
Ltmp143:
	mov	x1, x20
	bl	__ZNSt12length_errorC1B9nqe210106EPKc
Ltmp144:
; %bb.1:
Lloh80:
	adrp	x1, __ZTISt12length_error@GOTPAGE
Lloh81:
	ldr	x1, [x1, __ZTISt12length_error@GOTPAGEOFF]
Lloh82:
	adrp	x2, __ZNSt12length_errorD1Ev@GOTPAGE
Lloh83:
	ldr	x2, [x2, __ZNSt12length_errorD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
LBB11_2:
Ltmp145:
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x0, x20
	bl	__Unwind_Resume
	.loh AdrpLdrGot	Lloh82, Lloh83
	.loh AdrpLdrGot	Lloh80, Lloh81
Lfunc_end6:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table11:
Lexception6:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end6-Lcst_begin6
Lcst_begin6:
	.uleb128 Lfunc_begin6-Lfunc_begin6      ; >> Call Site 1 <<
	.uleb128 Ltmp143-Lfunc_begin6           ;   Call between Lfunc_begin6 and Ltmp143
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp143-Lfunc_begin6           ; >> Call Site 2 <<
	.uleb128 Ltmp144-Ltmp143                ;   Call between Ltmp143 and Ltmp144
	.uleb128 Ltmp145-Lfunc_begin6           ;     jumps to Ltmp145
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp144-Lfunc_begin6           ; >> Call Site 3 <<
	.uleb128 Lfunc_end6-Ltmp144             ;   Call between Ltmp144 and Lfunc_end6
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
Lloh84:
	adrp	x8, __ZTVSt12length_error@GOTPAGE
Lloh85:
	ldr	x8, [x8, __ZTVSt12length_error@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x0]
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
	.loh AdrpLdrGot	Lloh84, Lloh85
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
Lloh86:
	adrp	x1, __ZTISt20bad_array_new_length@GOTPAGE
Lloh87:
	ldr	x1, [x1, __ZTISt20bad_array_new_length@GOTPAGEOFF]
Lloh88:
	adrp	x2, __ZNSt20bad_array_new_lengthD1Ev@GOTPAGE
Lloh89:
	ldr	x2, [x2, __ZNSt20bad_array_new_lengthD1Ev@GOTPAGEOFF]
	bl	___cxa_throw
	.loh AdrpLdrGot	Lloh88, Lloh89
	.loh AdrpLdrGot	Lloh86, Lloh87
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
Lloh90:
	adrp	x0, l_.str.13@PAGE
Lloh91:
	add	x0, x0, l_.str.13@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh90, Lloh91
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
	bl	_OUTLINED_FUNCTION_0
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _Z7checkedPKhmPhmm.cold.1
__Z7checkedPKhmPhmm.cold.1:             ; @_Z7checkedPKhmPhmm.cold.1
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh92:
	adrp	x1, __ZTISt16invalid_argument@GOTPAGE
Lloh93:
	ldr	x1, [x1, __ZTISt16invalid_argument@GOTPAGEOFF]
Lloh94:
	adrp	x2, __ZNSt16invalid_argumentD1Ev@GOTPAGE
Lloh95:
	ldr	x2, [x2, __ZNSt16invalid_argumentD1Ev@GOTPAGEOFF]
	bl	___cxa_throw
	.loh AdrpLdrGot	Lloh94, Lloh95
	.loh AdrpLdrGot	Lloh92, Lloh93
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZN5GuardC2Ev.cold.1
__ZN5GuardC2Ev.cold.1:                  ; @_ZN5GuardC2Ev.cold.1
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
	.p2align	2                               ; -- Begin function _ZN5GuardC2Ev.cold.2
__ZN5GuardC2Ev.cold.2:                  ; @_ZN5GuardC2Ev.cold.2
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
	.p2align	2                               ; -- Begin function _ZN5GuardC2Ev.cold.3
__ZN5GuardC2Ev.cold.3:                  ; @_ZN5GuardC2Ev.cold.3
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
	.asciz	"contract failed"

l_.str.1:                               ; @.str.1
	.asciz	"length/capacity"

	.section	__TEXT,__const
	.p2align	2, 0x0                          ; @constinit
l_constinit:
	.long	0                               ; 0x0
	.long	1                               ; 0x1
	.long	15                              ; 0xf
	.long	16                              ; 0x10
	.long	17                              ; 0x11
	.long	31                              ; 0x1f
	.long	32                              ; 0x20
	.long	33                              ; 0x21

	.section	__TEXT,__cstring,cstring_literals
l_.str.2:                               ; @.str.2
	.asciz	"scalar"

l_.str.3:                               ; @.str.3
	.asciz	"neon"

l_.str.4:                               ; @.str.4
	.asciz	" CPU batch_mean_us p50="

l_.str.5:                               ; @.str.5
	.asciz	" p95="

l_.str.6:                               ; @.str.6
	.asciz	"PASS "

l_.str.7:                               ; @.str.7
	.asciz	" offset/length cases, 8 guard-page tails, invalid capacity; checksum="

l_.str.8:                               ; @.str.8
	.asciz	"mmap failed"

l_.str.9:                               ; @.str.9
	.asciz	"munmap rollback failed\n"

l_.str.10:                              ; @.str.10
	.asciz	"mprotect failed"

l_.str.11:                              ; @.str.11
	.asciz	"munmap cleanup failed\n"

l_.str.12:                              ; @.str.12
	.asciz	"basic_string"

l_.str.13:                              ; @.str.13
	.asciz	"vector"

.subsections_via_symbols
