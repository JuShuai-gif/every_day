	.build_version macos, 26, 0	sdk_version 26, 5
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__Z6faultsv                     ; -- Begin function _Z6faultsv
	.p2align	2
__Z6faultsv:                            ; @_Z6faultsv
Lfunc_begin0:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception0
; %bb.0:
	sub	sp, sp, #176
	stp	x20, x19, [sp, #144]            ; 16-byte Folded Spill
	stp	x29, x30, [sp, #160]            ; 16-byte Folded Spill
	add	x29, sp, #160
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	movi.2d	v0, #0000000000000000
	stp	q0, q0, [sp, #112]
	stp	q0, q0, [sp, #80]
	stp	q0, q0, [sp, #48]
	stp	q0, q0, [sp, #16]
	str	q0, [sp]
	mov	x1, sp
	mov	w0, #0                          ; =0x0
	bl	_getrusage
	cbnz	w0, LBB0_2
; %bb.1:
	ldr	x0, [sp, #64]
	ldp	x29, x30, [sp, #160]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #144]            ; 16-byte Folded Reload
	add	sp, sp, #176
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
	bl	__Z6faultsv.cold.1
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
	.globl	__Z5chasePKhym                  ; -- Begin function _Z5chasePKhym
	.p2align	2
__Z5chasePKhym:                         ; @_Z5chasePKhym
	.cfi_startproc
; %bb.0:
	cbz	x2, LBB1_2
LBB1_1:                                 ; =>This Inner Loop Header: Depth=1
	ldr	x1, [x0, x1]
	subs	x2, x2, #1
	b.ne	LBB1_1
LBB1_2:
	mov	x0, x1
	ret
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__literal16,16byte_literals
	.p2align	4, 0x0                          ; -- Begin function _Z5trialmmm
lCPI2_0:
	.quad	0                               ; 0x0
	.quad	1                               ; 0x1
lCPI2_1:
	.quad	0                               ; 0x0
	.quad	9223372036854775807             ; 0x7fffffffffffffff
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__Z5trialmmm
	.p2align	2
__Z5trialmmm:                           ; @_Z5trialmmm
Lfunc_begin1:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception1
; %bb.0:
	stp	d9, d8, [sp, #-112]!            ; 16-byte Folded Spill
	stp	x28, x27, [sp, #16]             ; 16-byte Folded Spill
	stp	x26, x25, [sp, #32]             ; 16-byte Folded Spill
	stp	x24, x23, [sp, #48]             ; 16-byte Folded Spill
	stp	x22, x21, [sp, #64]             ; 16-byte Folded Spill
	stp	x20, x19, [sp, #80]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #96]             ; 16-byte Folded Spill
	add	x29, sp, #96
	sub	sp, sp, #2752
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
	mov	x25, x2
	mov	x22, x1
	mov	x19, x0
	mul	x26, x1, x0
	add	x0, sp, #2560
	mov	x1, x26
	bl	__ZN7MappingC2Em
	str	x19, [sp, #48]                  ; 8-byte Folded Spill
	cbz	x19, LBB2_5
; %bb.1:
	lsr	x8, x19, #61
	cbnz	x8, LBB2_79
; %bb.2:
	lsl	x21, x19, #3
Ltmp3:
	mov	x0, x21
	bl	__Znwm
Ltmp4:
; %bb.3:
	mov	x23, x0
	add	x20, x0, x21
	mov	x1, x21
	bl	_bzero
	sub	x8, x21, #8
	cmp	x8, #56
	b.hs	LBB2_6
; %bb.4:
	mov	x8, #0                          ; =0x0
	mov	x9, x23
	b	LBB2_9
LBB2_5:
	mov	x20, #0                         ; =0x0
	mov	x23, #0                         ; =0x0
	b	LBB2_10
LBB2_6:
	lsr	x8, x8, #3
	add	x10, x8, #1
	and	x8, x10, #0x3ffffffffffffff8
	add	x9, x23, x8, lsl #3
Lloh2:
	adrp	x11, lCPI2_0@PAGE
Lloh3:
	ldr	q0, [x11, lCPI2_0@PAGEOFF]
	add	x11, x23, #32
	mov	w12, #2                         ; =0x2
	dup.2d	v1, x12
	mov	w12, #4                         ; =0x4
	dup.2d	v2, x12
	mov	w12, #6                         ; =0x6
	dup.2d	v3, x12
	mov	w12, #8                         ; =0x8
	dup.2d	v4, x12
	mov	x12, x8
LBB2_7:                                 ; =>This Inner Loop Header: Depth=1
	add.2d	v5, v0, v1
	add.2d	v6, v0, v2
	add.2d	v7, v0, v3
	stp	q0, q5, [x11, #-32]
	stp	q6, q7, [x11], #64
	add.2d	v0, v0, v4
	subs	x12, x12, #8
	b.ne	LBB2_7
; %bb.8:
	cmp	x10, x8
	b.eq	LBB2_10
LBB2_9:                                 ; =>This Inner Loop Header: Depth=1
	str	x8, [x9], #8
	add	x8, x8, #1
	cmp	x9, x20
	b.ne	LBB2_9
LBB2_10:
	sub	x19, x29, #256
	mov	w8, #1011                       ; =0x3f3
	str	w8, [sp, #56]
	mov	w9, #1                          ; =0x1
	mov	w10, #35173                     ; =0x8965
	movk	w10, #27655, lsl #16
	add	x11, sp, #56
LBB2_11:                                ; =>This Inner Loop Header: Depth=1
	eor	w8, w8, w8, lsr #30
	madd	w8, w8, w10, w9
	str	w8, [x11, x9, lsl #2]
	add	x9, x9, #1
	cmp	x9, #624
	b.ne	LBB2_11
; %bb.12:
	str	xzr, [sp, #2552]
	sub	x8, x20, x23
	asr	x8, x8, #3
	cmp	x8, #2
	str	x23, [sp, #40]                  ; 8-byte Folded Spill
	b.lt	LBB2_20
; %bb.13:
	mov	x24, x22
Lloh4:
	adrp	x9, lCPI2_1@PAGE
Lloh5:
	ldr	q0, [x9, lCPI2_1@PAGEOFF]
	str	q0, [x19]
	sub	x19, x20, #8
	cmp	x23, x19
	b.hs	LBB2_19
; %bb.14:
	sub	x20, x8, #1
	mov	x21, x23
	mov	x22, x23
	b	LBB2_16
LBB2_15:                                ;   in Loop: Header=BB2_16 Depth=1
	add	x22, x22, #8
	sub	x20, x20, #1
	add	x21, x21, #8
	cmp	x22, x19
	b.hs	LBB2_19
LBB2_16:                                ; =>This Inner Loop Header: Depth=1
	str	xzr, [sp, #2576]
	str	x20, [sp, #2584]
Ltmp8:
	sub	x0, x29, #256
	add	x1, sp, #56
	add	x2, sp, #2576
	bl	__ZNSt3__124uniform_int_distributionIlEclINS_23mersenne_twister_engineIjLm32ELm624ELm397ELm31ELj2567483615ELm11ELj4294967295ELm7ELj2636928640ELm15ELj4022730752ELm18ELj1812433253EEEEElRT_RKNS1_10param_typeE
Ltmp9:
; %bb.17:                               ;   in Loop: Header=BB2_16 Depth=1
	cbz	x0, LBB2_15
; %bb.18:                               ;   in Loop: Header=BB2_16 Depth=1
	ldr	x8, [x22]
	ldr	x9, [x21, x0, lsl #3]
	str	x9, [x22]
	str	x8, [x21, x0, lsl #3]
	b	LBB2_15
LBB2_19:
	mov	x22, x24
	sub	x19, x29, #256
LBB2_20:
	movi.2d	v0, #0000000000000000
	stp	q0, q0, [x19, #112]
	stp	q0, q0, [x19, #80]
	stp	q0, q0, [x19, #48]
	stp	q0, q0, [x19, #16]
	str	q0, [x19]
Ltmp11:
	sub	x1, x29, #256
	mov	w0, #0                          ; =0x0
	bl	_getrusage
Ltmp12:
; %bb.21:
	ldr	x20, [sp, #48]                  ; 8-byte Folded Reload
	cbnz	w0, LBB2_69
; %bb.22:
	ldur	x24, [x29, #-192]
	cbz	x20, LBB2_29
; %bb.23:
	cmp	x20, #1
	b.ne	LBB2_25
; %bb.24:
	mov	x8, #0                          ; =0x0
	b	LBB2_28
LBB2_25:
	mov	x8, #0                          ; =0x0
	mov	w9, #1                          ; =0x1
	sub	x9, x9, x20
	add	x10, x23, #8
LBB2_26:                                ; =>This Inner Loop Header: Depth=1
	ldp	x12, x11, [x10, #-8]
	mul	x11, x11, x22
	ldr	x13, [sp, #2560]
	mul	x12, x12, x22
	str	x11, [x13, x12]
	sub	x8, x8, #1
	add	x10, x10, #8
	cmp	x9, x8
	b.ne	LBB2_26
; %bb.27:
	neg	x8, x8
LBB2_28:
	add	x9, x8, #1
	cmp	x9, x20
	csinc	x9, xzr, x8, eq
	ldr	x9, [x23, x9, lsl #3]
	mul	x9, x9, x22
	ldr	x10, [sp, #2560]
	ldr	x8, [x23, x8, lsl #3]
	mul	x8, x8, x22
	str	x9, [x10, x8]
LBB2_29:
	movi.2d	v0, #0000000000000000
	stp	q0, q0, [x19, #112]
	stp	q0, q0, [x19, #80]
	stp	q0, q0, [x19, #48]
	stp	q0, q0, [x19, #16]
	str	q0, [x19]
Ltmp19:
	sub	x1, x29, #256
	mov	w0, #0                          ; =0x0
	bl	_getrusage
Ltmp20:
; %bb.30:
	str	x26, [sp, #32]                  ; 8-byte Folded Spill
	cbnz	w0, LBB2_71
; %bb.31:
	ldur	x19, [x29, #-192]
	ldr	x8, [x23]
	mul	x26, x8, x22
	ldr	x21, [sp, #2560]
	mov	x0, x21
	mov	x1, x26
	mov	x2, x20
	bl	__Z5chasePKhym
	cmp	x0, x26
	b.ne	LBB2_73
; %bb.32:
	lsl	x2, x20, #1
	mov	x0, x21
	mov	x1, x26
	bl	__Z5chasePKhym
	adrp	x20, _sink@PAGE
	str	x0, [x20, _sink@PAGEOFF]
	movi.2d	v0, #0000000000000000
	sub	x8, x29, #256
	stp	q0, q0, [x8, #112]
	stp	q0, q0, [x8, #80]
	stp	q0, q0, [x8, #48]
	stp	q0, q0, [x8, #16]
	str	q0, [x8]
Ltmp33:
	sub	x1, x29, #256
	mov	w0, #0                          ; =0x0
	bl	_getrusage
Ltmp34:
; %bb.33:
	stp	x25, x22, [sp, #16]             ; 16-byte Folded Spill
	cbnz	w0, LBB2_75
; %bb.34:
	mov	x21, #0                         ; =0x0
	mov	x27, #0                         ; =0x0
	mov	x22, #0                         ; =0x0
	sub	x8, x19, x24
	str	x8, [sp, #8]                    ; 8-byte Folded Spill
	ldur	x8, [x29, #-192]
	str	x8, [sp]                        ; 8-byte Folded Spill
	mov	w19, #11                        ; =0xb
	mov	x23, #9223372036854775800       ; =0x7ffffffffffffff8
	mov	x25, #2305843009213693951       ; =0x1fffffffffffffff
	b	LBB2_36
LBB2_35:                                ;   in Loop: Header=BB2_36 Depth=1
	str	d8, [x27], #8
	subs	w19, w19, #1
	b.eq	LBB2_43
LBB2_36:                                ; =>This Inner Loop Header: Depth=1
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x24, x0
	ldr	x0, [sp, #2560]
	mov	x1, x26
	mov	w2, #262144                     ; =0x40000
	bl	__Z5chasePKhym
	str	x0, [x20, _sink@PAGEOFF]
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	sub	x8, x0, x24
	scvtf	d8, x8, #18
	cmp	x27, x22
	b.lo	LBB2_35
; %bb.37:                               ;   in Loop: Header=BB2_36 Depth=1
	sub	x28, x27, x21
	asr	x24, x28, #3
	add	x8, x24, #1
	lsr	x9, x8, #61
	cbnz	x9, LBB2_67
; %bb.38:                               ;   in Loop: Header=BB2_36 Depth=1
	sub	x9, x22, x21
	asr	x10, x9, #2
	cmp	x10, x8
	csel	x8, x10, x8, hi
	cmp	x9, x23
	csel	x22, x8, x25, lo
	lsr	x8, x22, #61
	cbnz	x8, LBB2_68
; %bb.39:                               ;   in Loop: Header=BB2_36 Depth=1
	lsl	x0, x22, #3
Ltmp41:
	bl	__Znwm
Ltmp42:
; %bb.40:                               ;   in Loop: Header=BB2_36 Depth=1
	add	x27, x0, x28
	add	x22, x0, x22, lsl #3
	sub	x24, x27, x24, lsl #3
	str	d8, [x27], #8
	mov	x0, x24
	mov	x1, x21
	mov	x2, x28
	bl	_memcpy
	cbz	x21, LBB2_42
; %bb.41:                               ;   in Loop: Header=BB2_36 Depth=1
	mov	x0, x21
	bl	__ZdlPv
LBB2_42:                                ;   in Loop: Header=BB2_36 Depth=1
	mov	x21, x24
	subs	w19, w19, #1
	b.ne	LBB2_36
LBB2_43:
Ltmp49:
	sub	x2, x29, #256
	mov	x0, x21
	mov	x1, x27
	ldr	x19, [sp, #40]                  ; 8-byte Folded Reload
	bl	__ZNSt3__16__sortIRNS_6__lessIddEEPdEEvT0_S5_T_
Ltmp50:
	ldr	x20, [sp, #32]                  ; 8-byte Folded Reload
; %bb.44:
Ltmp51:
Lloh6:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh7:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh8:
	adrp	x1, l_.str.2@PAGE
Lloh9:
	add	x1, x1, l_.str.2@PAGEOFF
	mov	w2, #6                          ; =0x6
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp52:
; %bb.45:
Ltmp53:
	ldr	x1, [sp, #48]                   ; 8-byte Folded Reload
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp54:
; %bb.46:
Ltmp55:
Lloh10:
	adrp	x1, l_.str.3@PAGE
Lloh11:
	add	x1, x1, l_.str.3@PAGEOFF
	mov	w2, #8                          ; =0x8
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp56:
; %bb.47:
Ltmp57:
	ldr	x1, [sp, #24]                   ; 8-byte Folded Reload
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp58:
; %bb.48:
Ltmp59:
Lloh12:
	adrp	x1, l_.str.4@PAGE
Lloh13:
	add	x1, x1, l_.str.4@PAGEOFF
	mov	w2, #16                         ; =0x10
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp60:
; %bb.49:
Ltmp61:
	mov	x1, x20
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp62:
; %bb.50:
Ltmp63:
Lloh14:
	adrp	x1, l_.str.5@PAGE
Lloh15:
	add	x1, x1, l_.str.5@PAGEOFF
	mov	w2, #15                         ; =0xf
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp64:
; %bb.51:
	ldr	x9, [sp, #16]                   ; 8-byte Folded Reload
	add	x8, x9, x20
	sub	x8, x8, #1
	udiv	x1, x8, x9
Ltmp65:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp66:
; %bb.52:
Ltmp67:
Lloh16:
	adrp	x1, l_.str.6@PAGE
Lloh17:
	add	x1, x1, l_.str.6@PAGEOFF
	mov	w2, #20                         ; =0x14
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp68:
; %bb.53:
Ltmp69:
	ldr	x1, [sp, #8]                    ; 8-byte Folded Reload
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEl
Ltmp70:
; %bb.54:
Ltmp71:
Lloh18:
	adrp	x1, l_.str.7@PAGE
Lloh19:
	add	x1, x1, l_.str.7@PAGEOFF
	mov	w2, #13                         ; =0xd
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp72:
; %bb.55:
	mov	x20, x0
	movi.2d	v0, #0000000000000000
	sub	x8, x29, #256
	stp	q0, q0, [x8, #112]
	stp	q0, q0, [x8, #80]
	stp	q0, q0, [x8, #48]
	stp	q0, q0, [x8, #16]
	str	q0, [x8]
Ltmp73:
	sub	x1, x29, #256
	mov	w0, #0                          ; =0x0
	bl	_getrusage
Ltmp74:
; %bb.56:
	cbnz	w0, LBB2_77
; %bb.57:
	ldur	x8, [x29, #-192]
	ldr	x9, [sp]                        ; 8-byte Folded Reload
	sub	x1, x8, x9
Ltmp80:
	mov	x0, x20
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEl
Ltmp81:
; %bb.58:
Ltmp82:
Lloh20:
	adrp	x1, l_.str.8@PAGE
Lloh21:
	add	x1, x1, l_.str.8@PAGEOFF
	mov	w2, #17                         ; =0x11
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp83:
; %bb.59:
	ldr	d0, [x21, #40]
Ltmp84:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp85:
; %bb.60:
Ltmp86:
Lloh22:
	adrp	x1, l_.str.9@PAGE
Lloh23:
	add	x1, x1, l_.str.9@PAGEOFF
	mov	w2, #5                          ; =0x5
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp87:
; %bb.61:
	ldr	d0, [x21, #80]
Ltmp88:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp89:
; %bb.62:
	mov	w8, #10                         ; =0xa
	sturb	w8, [x29, #-256]
Ltmp90:
	sub	x1, x29, #256
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp91:
; %bb.63:
	mov	x0, x21
	bl	__ZdlPv
	mov	x0, x19
	bl	__ZdlPv
	ldr	x0, [sp, #2560]
	ldr	x1, [sp, #2568]
Ltmp93:
	bl	_munmap
Ltmp94:
; %bb.64:
	cbz	w0, LBB2_66
; %bb.65:
Ltmp95:
Lloh24:
	adrp	x0, __ZNSt3__14cerrE@GOTPAGE
Lloh25:
	ldr	x0, [x0, __ZNSt3__14cerrE@GOTPAGEOFF]
Lloh26:
	adrp	x1, l_.str.17@PAGE
Lloh27:
	add	x1, x1, l_.str.17@PAGEOFF
	mov	w2, #14                         ; =0xe
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp96:
LBB2_66:
	add	sp, sp, #2752
	ldp	x29, x30, [sp, #96]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #80]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #64]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #48]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #32]             ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #16]             ; 16-byte Folded Reload
	ldp	d9, d8, [sp], #112              ; 16-byte Folded Reload
	ret
LBB2_67:
Ltmp46:
	bl	__ZNSt3__16vectorIdNS_9allocatorIdEEE20__throw_length_errorB9nqe210106Ev
Ltmp47:
	b	LBB2_80
LBB2_68:
Ltmp44:
	bl	__ZSt28__throw_bad_array_new_lengthB9nqe210106v
Ltmp45:
	b	LBB2_80
LBB2_69:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x21, x0
Ltmp13:
Lloh28:
	adrp	x1, l_.str@PAGE
Lloh29:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp14:
; %bb.70:
Ltmp16:
Lloh30:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh31:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh32:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh33:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x21
	bl	___cxa_throw
Ltmp17:
	b	LBB2_80
LBB2_71:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x21, x0
Ltmp21:
Lloh34:
	adrp	x1, l_.str@PAGE
Lloh35:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp22:
; %bb.72:
Ltmp24:
Lloh36:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh37:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh38:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh39:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x21
	bl	___cxa_throw
Ltmp25:
	b	LBB2_80
LBB2_73:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x21, x0
Ltmp27:
Lloh40:
	adrp	x1, l_.str.1@PAGE
Lloh41:
	add	x1, x1, l_.str.1@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp28:
; %bb.74:
Ltmp30:
Lloh42:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh43:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh44:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh45:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x21
	bl	___cxa_throw
Ltmp31:
	b	LBB2_80
LBB2_75:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x21, x0
Ltmp35:
Lloh46:
	adrp	x1, l_.str@PAGE
Lloh47:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp36:
; %bb.76:
Ltmp38:
Lloh48:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh49:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh50:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh51:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x21
	bl	___cxa_throw
Ltmp39:
	b	LBB2_80
LBB2_77:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x22, x0
Ltmp75:
Lloh52:
	adrp	x1, l_.str@PAGE
Lloh53:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp76:
; %bb.78:
Ltmp78:
Lloh54:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh55:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh56:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh57:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x22
	bl	___cxa_throw
Ltmp79:
	b	LBB2_80
LBB2_79:
Ltmp5:
	bl	__ZNSt3__16vectorImNS_9allocatorImEEE20__throw_length_errorB9nqe210106Ev
Ltmp6:
LBB2_80:
	brk	#0x1
LBB2_81:
Ltmp77:
	mov	x20, x0
	mov	x0, x22
	bl	___cxa_free_exception
	b	LBB2_99
LBB2_82:
Ltmp37:
	b	LBB2_85
LBB2_83:
Ltmp32:
	mov	x20, x0
	b	LBB2_102
LBB2_84:
Ltmp29:
LBB2_85:
	mov	x20, x0
	mov	x0, x21
	bl	___cxa_free_exception
	b	LBB2_102
LBB2_86:
Ltmp23:
	b	LBB2_88
LBB2_87:
Ltmp15:
LBB2_88:
	mov	x20, x0
	mov	x0, x21
	bl	___cxa_free_exception
	b	LBB2_101
LBB2_89:
Ltmp7:
	mov	x20, x0
	b	LBB2_103
LBB2_90:
Ltmp40:
	mov	x20, x0
	b	LBB2_102
LBB2_91:
Ltmp26:
	mov	x20, x0
	b	LBB2_101
LBB2_92:
Ltmp18:
	mov	x20, x0
	b	LBB2_101
LBB2_93:
Ltmp97:
	bl	___clang_call_terminate
LBB2_94:
Ltmp10:
	mov	x20, x0
	b	LBB2_101
LBB2_95:
Ltmp43:
	b	LBB2_98
LBB2_96:
Ltmp92:
	b	LBB2_98
LBB2_97:
Ltmp48:
LBB2_98:
	mov	x20, x0
LBB2_99:
	cbz	x21, LBB2_101
; %bb.100:
	mov	x0, x21
	bl	__ZdlPv
LBB2_101:
	ldr	x8, [sp, #40]                   ; 8-byte Folded Reload
	cbz	x8, LBB2_103
LBB2_102:
	ldr	x0, [sp, #40]                   ; 8-byte Folded Reload
	bl	__ZdlPv
LBB2_103:
	add	x0, sp, #2560
	bl	__ZN7MappingD1Ev
	mov	x0, x20
	bl	__Unwind_Resume
	.loh AdrpLdr	Lloh2, Lloh3
	.loh AdrpLdr	Lloh4, Lloh5
	.loh AdrpAdd	Lloh8, Lloh9
	.loh AdrpLdrGot	Lloh6, Lloh7
	.loh AdrpAdd	Lloh10, Lloh11
	.loh AdrpAdd	Lloh12, Lloh13
	.loh AdrpAdd	Lloh14, Lloh15
	.loh AdrpAdd	Lloh16, Lloh17
	.loh AdrpAdd	Lloh18, Lloh19
	.loh AdrpAdd	Lloh20, Lloh21
	.loh AdrpAdd	Lloh22, Lloh23
	.loh AdrpAdd	Lloh26, Lloh27
	.loh AdrpLdrGot	Lloh24, Lloh25
	.loh AdrpAdd	Lloh28, Lloh29
	.loh AdrpLdrGot	Lloh32, Lloh33
	.loh AdrpLdrGot	Lloh30, Lloh31
	.loh AdrpAdd	Lloh34, Lloh35
	.loh AdrpLdrGot	Lloh38, Lloh39
	.loh AdrpLdrGot	Lloh36, Lloh37
	.loh AdrpAdd	Lloh40, Lloh41
	.loh AdrpLdrGot	Lloh44, Lloh45
	.loh AdrpLdrGot	Lloh42, Lloh43
	.loh AdrpAdd	Lloh46, Lloh47
	.loh AdrpLdrGot	Lloh50, Lloh51
	.loh AdrpLdrGot	Lloh48, Lloh49
	.loh AdrpAdd	Lloh52, Lloh53
	.loh AdrpLdrGot	Lloh56, Lloh57
	.loh AdrpLdrGot	Lloh54, Lloh55
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
	.uleb128 Lfunc_begin1-Lfunc_begin1      ; >> Call Site 1 <<
	.uleb128 Ltmp3-Lfunc_begin1             ;   Call between Lfunc_begin1 and Ltmp3
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp3-Lfunc_begin1             ; >> Call Site 2 <<
	.uleb128 Ltmp4-Ltmp3                    ;   Call between Ltmp3 and Ltmp4
	.uleb128 Ltmp7-Lfunc_begin1             ;     jumps to Ltmp7
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp4-Lfunc_begin1             ; >> Call Site 3 <<
	.uleb128 Ltmp8-Ltmp4                    ;   Call between Ltmp4 and Ltmp8
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp8-Lfunc_begin1             ; >> Call Site 4 <<
	.uleb128 Ltmp9-Ltmp8                    ;   Call between Ltmp8 and Ltmp9
	.uleb128 Ltmp10-Lfunc_begin1            ;     jumps to Ltmp10
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp11-Lfunc_begin1            ; >> Call Site 5 <<
	.uleb128 Ltmp12-Ltmp11                  ;   Call between Ltmp11 and Ltmp12
	.uleb128 Ltmp18-Lfunc_begin1            ;     jumps to Ltmp18
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp19-Lfunc_begin1            ; >> Call Site 6 <<
	.uleb128 Ltmp20-Ltmp19                  ;   Call between Ltmp19 and Ltmp20
	.uleb128 Ltmp26-Lfunc_begin1            ;     jumps to Ltmp26
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp33-Lfunc_begin1            ; >> Call Site 7 <<
	.uleb128 Ltmp34-Ltmp33                  ;   Call between Ltmp33 and Ltmp34
	.uleb128 Ltmp40-Lfunc_begin1            ;     jumps to Ltmp40
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp41-Lfunc_begin1            ; >> Call Site 8 <<
	.uleb128 Ltmp42-Ltmp41                  ;   Call between Ltmp41 and Ltmp42
	.uleb128 Ltmp43-Lfunc_begin1            ;     jumps to Ltmp43
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp42-Lfunc_begin1            ; >> Call Site 9 <<
	.uleb128 Ltmp49-Ltmp42                  ;   Call between Ltmp42 and Ltmp49
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp49-Lfunc_begin1            ; >> Call Site 10 <<
	.uleb128 Ltmp91-Ltmp49                  ;   Call between Ltmp49 and Ltmp91
	.uleb128 Ltmp92-Lfunc_begin1            ;     jumps to Ltmp92
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp93-Lfunc_begin1            ; >> Call Site 11 <<
	.uleb128 Ltmp96-Ltmp93                  ;   Call between Ltmp93 and Ltmp96
	.uleb128 Ltmp97-Lfunc_begin1            ;     jumps to Ltmp97
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp46-Lfunc_begin1            ; >> Call Site 12 <<
	.uleb128 Ltmp45-Ltmp46                  ;   Call between Ltmp46 and Ltmp45
	.uleb128 Ltmp48-Lfunc_begin1            ;     jumps to Ltmp48
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp45-Lfunc_begin1            ; >> Call Site 13 <<
	.uleb128 Ltmp13-Ltmp45                  ;   Call between Ltmp45 and Ltmp13
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp13-Lfunc_begin1            ; >> Call Site 14 <<
	.uleb128 Ltmp14-Ltmp13                  ;   Call between Ltmp13 and Ltmp14
	.uleb128 Ltmp15-Lfunc_begin1            ;     jumps to Ltmp15
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp16-Lfunc_begin1            ; >> Call Site 15 <<
	.uleb128 Ltmp17-Ltmp16                  ;   Call between Ltmp16 and Ltmp17
	.uleb128 Ltmp18-Lfunc_begin1            ;     jumps to Ltmp18
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp17-Lfunc_begin1            ; >> Call Site 16 <<
	.uleb128 Ltmp21-Ltmp17                  ;   Call between Ltmp17 and Ltmp21
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp21-Lfunc_begin1            ; >> Call Site 17 <<
	.uleb128 Ltmp22-Ltmp21                  ;   Call between Ltmp21 and Ltmp22
	.uleb128 Ltmp23-Lfunc_begin1            ;     jumps to Ltmp23
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp24-Lfunc_begin1            ; >> Call Site 18 <<
	.uleb128 Ltmp25-Ltmp24                  ;   Call between Ltmp24 and Ltmp25
	.uleb128 Ltmp26-Lfunc_begin1            ;     jumps to Ltmp26
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp25-Lfunc_begin1            ; >> Call Site 19 <<
	.uleb128 Ltmp27-Ltmp25                  ;   Call between Ltmp25 and Ltmp27
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp27-Lfunc_begin1            ; >> Call Site 20 <<
	.uleb128 Ltmp28-Ltmp27                  ;   Call between Ltmp27 and Ltmp28
	.uleb128 Ltmp29-Lfunc_begin1            ;     jumps to Ltmp29
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp30-Lfunc_begin1            ; >> Call Site 21 <<
	.uleb128 Ltmp31-Ltmp30                  ;   Call between Ltmp30 and Ltmp31
	.uleb128 Ltmp32-Lfunc_begin1            ;     jumps to Ltmp32
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp31-Lfunc_begin1            ; >> Call Site 22 <<
	.uleb128 Ltmp35-Ltmp31                  ;   Call between Ltmp31 and Ltmp35
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp35-Lfunc_begin1            ; >> Call Site 23 <<
	.uleb128 Ltmp36-Ltmp35                  ;   Call between Ltmp35 and Ltmp36
	.uleb128 Ltmp37-Lfunc_begin1            ;     jumps to Ltmp37
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp38-Lfunc_begin1            ; >> Call Site 24 <<
	.uleb128 Ltmp39-Ltmp38                  ;   Call between Ltmp38 and Ltmp39
	.uleb128 Ltmp40-Lfunc_begin1            ;     jumps to Ltmp40
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp39-Lfunc_begin1            ; >> Call Site 25 <<
	.uleb128 Ltmp75-Ltmp39                  ;   Call between Ltmp39 and Ltmp75
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp75-Lfunc_begin1            ; >> Call Site 26 <<
	.uleb128 Ltmp76-Ltmp75                  ;   Call between Ltmp75 and Ltmp76
	.uleb128 Ltmp77-Lfunc_begin1            ;     jumps to Ltmp77
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp78-Lfunc_begin1            ; >> Call Site 27 <<
	.uleb128 Ltmp79-Ltmp78                  ;   Call between Ltmp78 and Ltmp79
	.uleb128 Ltmp92-Lfunc_begin1            ;     jumps to Ltmp92
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp5-Lfunc_begin1             ; >> Call Site 28 <<
	.uleb128 Ltmp6-Ltmp5                    ;   Call between Ltmp5 and Ltmp6
	.uleb128 Ltmp7-Lfunc_begin1             ;     jumps to Ltmp7
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp6-Lfunc_begin1             ; >> Call Site 29 <<
	.uleb128 Lfunc_end1-Ltmp6               ;   Call between Ltmp6 and Lfunc_end1
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end1:
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
	.globl	__ZN7MappingD1Ev                ; -- Begin function _ZN7MappingD1Ev
	.weak_def_can_be_hidden	__ZN7MappingD1Ev
	.p2align	2
__ZN7MappingD1Ev:                       ; @_ZN7MappingD1Ev
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
	mov	x19, x0
	ldr	x0, [x0]
	ldr	x1, [x19, #8]
Ltmp98:
	bl	_munmap
Ltmp99:
; %bb.1:
	cbz	w0, LBB3_3
; %bb.2:
Ltmp100:
Lloh58:
	adrp	x0, __ZNSt3__14cerrE@GOTPAGE
Lloh59:
	ldr	x0, [x0, __ZNSt3__14cerrE@GOTPAGEOFF]
Lloh60:
	adrp	x1, l_.str.17@PAGE
Lloh61:
	add	x1, x1, l_.str.17@PAGEOFF
	mov	w2, #14                         ; =0xe
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp101:
LBB3_3:
	mov	x0, x19
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
	ret
LBB3_4:
Ltmp102:
	bl	___clang_call_terminate
	.loh AdrpAdd	Lloh60, Lloh61
	.loh AdrpLdrGot	Lloh58, Lloh59
Lfunc_end2:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table3:
Lexception2:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase1-Lttbaseref1
Lttbaseref1:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end2-Lcst_begin2
Lcst_begin2:
	.uleb128 Ltmp98-Lfunc_begin2            ; >> Call Site 1 <<
	.uleb128 Ltmp101-Ltmp98                 ;   Call between Ltmp98 and Ltmp101
	.uleb128 Ltmp102-Lfunc_begin2           ;     jumps to Ltmp102
	.byte	1                               ;   On action: 1
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
	.globl	_main                           ; -- Begin function main
	.p2align	2
_main:                                  ; @main
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
Ltmp103:
	mov	w0, #29                         ; =0x1d
	bl	_sysconf
Ltmp104:
; %bb.1:
	mov	x19, x0
	cmp	x0, #0
	b.gt	LBB4_4
; %bb.2:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp143:
Lloh62:
	adrp	x1, l_.str.10@PAGE
Lloh63:
	add	x1, x1, l_.str.10@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp144:
; %bb.3:
Ltmp146:
Lloh64:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh65:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh66:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh67:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
Ltmp147:
	b	LBB4_18
LBB4_4:
Ltmp105:
Lloh68:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh69:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh70:
	adrp	x1, l_.str.11@PAGE
Lloh71:
	add	x1, x1, l_.str.11@PAGEOFF
	mov	w2, #16                         ; =0x10
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp106:
; %bb.5:
Ltmp107:
	mov	x1, x19
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp108:
; %bb.6:
Ltmp109:
Lloh72:
	adrp	x1, l_.str.12@PAGE
Lloh73:
	add	x1, x1, l_.str.12@PAGEOFF
	mov	w2, #35                         ; =0x23
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp110:
; %bb.7:
Ltmp112:
	mov	w0, #1                          ; =0x1
	mov	w1, #64                         ; =0x40
	mov	x2, x19
	bl	__Z5trialmmm
Ltmp113:
; %bb.8:
Ltmp114:
	mov	w0, #1                          ; =0x1
	mov	x1, x19
	mov	x2, x19
	bl	__Z5trialmmm
Ltmp115:
; %bb.9:
Ltmp116:
	mov	w0, #16                         ; =0x10
	mov	w1, #64                         ; =0x40
	mov	x2, x19
	bl	__Z5trialmmm
Ltmp117:
; %bb.10:
Ltmp118:
	mov	w0, #16                         ; =0x10
	mov	x1, x19
	mov	x2, x19
	bl	__Z5trialmmm
Ltmp119:
; %bb.11:
Ltmp120:
	mov	w0, #256                        ; =0x100
	mov	w1, #64                         ; =0x40
	mov	x2, x19
	bl	__Z5trialmmm
Ltmp121:
; %bb.12:
Ltmp122:
	mov	w0, #256                        ; =0x100
	mov	x1, x19
	mov	x2, x19
	bl	__Z5trialmmm
Ltmp123:
; %bb.13:
Ltmp124:
	mov	w0, #4096                       ; =0x1000
	mov	w1, #64                         ; =0x40
	mov	x2, x19
	bl	__Z5trialmmm
Ltmp125:
; %bb.14:
Ltmp126:
	mov	w0, #4096                       ; =0x1000
	mov	x1, x19
	mov	x2, x19
	bl	__Z5trialmmm
Ltmp127:
; %bb.15:
Ltmp129:
	mov	x0, sp
	mov	x1, #0                          ; =0x0
	bl	__ZN7MappingC2Em
Ltmp130:
; %bb.16:
	mov	x0, sp
	bl	__ZN7MappingD1Ev
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp137:
Lloh74:
	adrp	x1, l_.str.13@PAGE
Lloh75:
	add	x1, x1, l_.str.13@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp138:
; %bb.17:
Ltmp140:
Lloh76:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh77:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh78:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh79:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
Ltmp141:
LBB4_18:
	brk	#0x1
LBB4_19:
Ltmp139:
	b	LBB4_29
LBB4_20:
Ltmp131:
	cmp	w1, #2
	b.ne	LBB4_24
; %bb.21:
	bl	___cxa_begin_catch
Ltmp132:
	bl	___cxa_end_catch
Ltmp133:
; %bb.22:
Ltmp135:
Lloh80:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh81:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh82:
	adrp	x1, l_.str.14@PAGE
Lloh83:
	add	x1, x1, l_.str.14@PAGEOFF
	mov	w2, #63                         ; =0x3f
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp136:
; %bb.23:
	mov	w0, #0                          ; =0x0
	b	LBB4_36
LBB4_24:
	b	LBB4_32
LBB4_25:
Ltmp134:
	b	LBB4_32
LBB4_26:
Ltmp142:
	b	LBB4_32
LBB4_27:
Ltmp128:
	b	LBB4_32
LBB4_28:
Ltmp145:
LBB4_29:
	mov	x20, x1
	mov	x21, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x1, x20
	mov	x0, x21
	b	LBB4_32
LBB4_30:
Ltmp111:
	b	LBB4_32
LBB4_31:
Ltmp148:
LBB4_32:
	cmp	w1, #1
	b.ne	LBB4_37
; %bb.33:
	bl	___cxa_begin_catch
	ldr	x8, [x0]
	ldr	x8, [x8, #16]
	blr	x8
	mov	x19, x0
	bl	_strlen
	mov	x2, x0
Ltmp149:
Lloh84:
	adrp	x0, __ZNSt3__14cerrE@GOTPAGE
Lloh85:
	ldr	x0, [x0, __ZNSt3__14cerrE@GOTPAGEOFF]
	mov	x1, x19
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp150:
; %bb.34:
	mov	w8, #10                         ; =0xa
	strb	w8, [sp]
Ltmp151:
	mov	x1, sp
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp152:
; %bb.35:
	bl	___cxa_end_catch
	mov	w0, #1                          ; =0x1
LBB4_36:
	ldp	x29, x30, [sp, #48]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #32]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #64
	ret
LBB4_37:
	bl	__Unwind_Resume
LBB4_38:
Ltmp153:
	mov	x19, x0
Ltmp154:
	bl	___cxa_end_catch
Ltmp155:
; %bb.39:
	mov	x0, x19
	bl	__Unwind_Resume
LBB4_40:
Ltmp156:
	bl	___clang_call_terminate
	.loh AdrpAdd	Lloh62, Lloh63
	.loh AdrpLdrGot	Lloh66, Lloh67
	.loh AdrpLdrGot	Lloh64, Lloh65
	.loh AdrpAdd	Lloh70, Lloh71
	.loh AdrpLdrGot	Lloh68, Lloh69
	.loh AdrpAdd	Lloh72, Lloh73
	.loh AdrpAdd	Lloh74, Lloh75
	.loh AdrpLdrGot	Lloh78, Lloh79
	.loh AdrpLdrGot	Lloh76, Lloh77
	.loh AdrpAdd	Lloh82, Lloh83
	.loh AdrpLdrGot	Lloh80, Lloh81
	.loh AdrpLdrGot	Lloh84, Lloh85
Lfunc_end3:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table4:
Lexception3:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase2-Lttbaseref2
Lttbaseref2:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end3-Lcst_begin3
Lcst_begin3:
	.uleb128 Ltmp103-Lfunc_begin3           ; >> Call Site 1 <<
	.uleb128 Ltmp104-Ltmp103                ;   Call between Ltmp103 and Ltmp104
	.uleb128 Ltmp148-Lfunc_begin3           ;     jumps to Ltmp148
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp104-Lfunc_begin3           ; >> Call Site 2 <<
	.uleb128 Ltmp143-Ltmp104                ;   Call between Ltmp104 and Ltmp143
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp143-Lfunc_begin3           ; >> Call Site 3 <<
	.uleb128 Ltmp144-Ltmp143                ;   Call between Ltmp143 and Ltmp144
	.uleb128 Ltmp145-Lfunc_begin3           ;     jumps to Ltmp145
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp146-Lfunc_begin3           ; >> Call Site 4 <<
	.uleb128 Ltmp147-Ltmp146                ;   Call between Ltmp146 and Ltmp147
	.uleb128 Ltmp148-Lfunc_begin3           ;     jumps to Ltmp148
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp105-Lfunc_begin3           ; >> Call Site 5 <<
	.uleb128 Ltmp110-Ltmp105                ;   Call between Ltmp105 and Ltmp110
	.uleb128 Ltmp111-Lfunc_begin3           ;     jumps to Ltmp111
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp112-Lfunc_begin3           ; >> Call Site 6 <<
	.uleb128 Ltmp127-Ltmp112                ;   Call between Ltmp112 and Ltmp127
	.uleb128 Ltmp128-Lfunc_begin3           ;     jumps to Ltmp128
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp129-Lfunc_begin3           ; >> Call Site 7 <<
	.uleb128 Ltmp130-Ltmp129                ;   Call between Ltmp129 and Ltmp130
	.uleb128 Ltmp131-Lfunc_begin3           ;     jumps to Ltmp131
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp130-Lfunc_begin3           ; >> Call Site 8 <<
	.uleb128 Ltmp137-Ltmp130                ;   Call between Ltmp130 and Ltmp137
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp137-Lfunc_begin3           ; >> Call Site 9 <<
	.uleb128 Ltmp138-Ltmp137                ;   Call between Ltmp137 and Ltmp138
	.uleb128 Ltmp139-Lfunc_begin3           ;     jumps to Ltmp139
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp140-Lfunc_begin3           ; >> Call Site 10 <<
	.uleb128 Ltmp141-Ltmp140                ;   Call between Ltmp140 and Ltmp141
	.uleb128 Ltmp142-Lfunc_begin3           ;     jumps to Ltmp142
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp141-Lfunc_begin3           ; >> Call Site 11 <<
	.uleb128 Ltmp132-Ltmp141                ;   Call between Ltmp141 and Ltmp132
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp132-Lfunc_begin3           ; >> Call Site 12 <<
	.uleb128 Ltmp133-Ltmp132                ;   Call between Ltmp132 and Ltmp133
	.uleb128 Ltmp134-Lfunc_begin3           ;     jumps to Ltmp134
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp135-Lfunc_begin3           ; >> Call Site 13 <<
	.uleb128 Ltmp136-Ltmp135                ;   Call between Ltmp135 and Ltmp136
	.uleb128 Ltmp142-Lfunc_begin3           ;     jumps to Ltmp142
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp136-Lfunc_begin3           ; >> Call Site 14 <<
	.uleb128 Ltmp149-Ltmp136                ;   Call between Ltmp136 and Ltmp149
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp149-Lfunc_begin3           ; >> Call Site 15 <<
	.uleb128 Ltmp152-Ltmp149                ;   Call between Ltmp149 and Ltmp152
	.uleb128 Ltmp153-Lfunc_begin3           ;     jumps to Ltmp153
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp152-Lfunc_begin3           ; >> Call Site 16 <<
	.uleb128 Ltmp154-Ltmp152                ;   Call between Ltmp152 and Ltmp154
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp154-Lfunc_begin3           ; >> Call Site 17 <<
	.uleb128 Ltmp155-Ltmp154                ;   Call between Ltmp154 and Ltmp155
	.uleb128 Ltmp156-Lfunc_begin3           ;     jumps to Ltmp156
	.byte	9                               ;   On action: 5
	.uleb128 Ltmp155-Lfunc_begin3           ; >> Call Site 18 <<
	.uleb128 Lfunc_end3-Ltmp155             ;   Call between Ltmp155 and Lfunc_end3
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end3:
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
Ltmp191:                                ; TypeInfo 2
	.long	__ZTISt16invalid_argument@GOT-Ltmp191
Ltmp192:                                ; TypeInfo 1
	.long	__ZTISt9exception@GOT-Ltmp192
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
	.globl	__ZN7MappingC2Em                ; -- Begin function _ZN7MappingC2Em
	.weak_def_can_be_hidden	__ZN7MappingC2Em
	.p2align	2
__ZN7MappingC2Em:                       ; @_ZN7MappingC2Em
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
	stp	xzr, x1, [x0]
	cbz	x1, LBB6_3
; %bb.1:
	mov	x19, x0
	mov	x0, #0                          ; =0x0
	mov	w2, #3                          ; =0x3
	mov	w3, #4098                       ; =0x1002
	mov	w4, #-1                         ; =0xffffffff
	mov	x5, #0                          ; =0x0
	bl	_mmap
	cmn	x0, #1
	b.eq	LBB6_5
; %bb.2:
	str	x0, [x19]
	mov	x0, x19
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
	ret
LBB6_3:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp160:
Lloh86:
	adrp	x1, l_.str.15@PAGE
Lloh87:
	add	x1, x1, l_.str.15@PAGEOFF
	bl	__ZNSt16invalid_argumentC1B9nqe210106EPKc
Ltmp161:
; %bb.4:
	mov	x0, x19
	bl	__ZN7MappingC2Em.cold.2
LBB6_5:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp157:
Lloh88:
	adrp	x1, l_.str.16@PAGE
Lloh89:
	add	x1, x1, l_.str.16@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp158:
; %bb.6:
	mov	x0, x19
	bl	__ZN7MappingC2Em.cold.1
LBB6_7:
Ltmp159:
	b	LBB6_9
LBB6_8:
Ltmp162:
LBB6_9:
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x0, x20
	bl	__Unwind_Resume
	.loh AdrpAdd	Lloh86, Lloh87
	.loh AdrpAdd	Lloh88, Lloh89
Lfunc_end4:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table6:
Lexception4:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end4-Lcst_begin4
Lcst_begin4:
	.uleb128 Lfunc_begin4-Lfunc_begin4      ; >> Call Site 1 <<
	.uleb128 Ltmp160-Lfunc_begin4           ;   Call between Lfunc_begin4 and Ltmp160
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp160-Lfunc_begin4           ; >> Call Site 2 <<
	.uleb128 Ltmp161-Ltmp160                ;   Call between Ltmp160 and Ltmp161
	.uleb128 Ltmp162-Lfunc_begin4           ;     jumps to Ltmp162
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp161-Lfunc_begin4           ; >> Call Site 3 <<
	.uleb128 Ltmp157-Ltmp161                ;   Call between Ltmp161 and Ltmp157
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp157-Lfunc_begin4           ; >> Call Site 4 <<
	.uleb128 Ltmp158-Ltmp157                ;   Call between Ltmp157 and Ltmp158
	.uleb128 Ltmp159-Lfunc_begin4           ;     jumps to Ltmp159
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp158-Lfunc_begin4           ; >> Call Site 5 <<
	.uleb128 Lfunc_end4-Ltmp158             ;   Call between Ltmp158 and Lfunc_end4
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end4:
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
Lloh90:
	adrp	x8, __ZTVSt16invalid_argument@GOTPAGE
Lloh91:
	ldr	x8, [x8, __ZTVSt16invalid_argument@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x0]
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
	.loh AdrpLdrGot	Lloh90, Lloh91
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
Ltmp163:
	add	x0, sp, #8
	mov	x1, x19
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryC1ERS3_
Ltmp164:
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
Ltmp166:
	add	x8, sp, #24
	mov	x25, x4
	mov	x0, x4
	bl	__ZNKSt3__18ios_base6getlocEv
Ltmp167:
; %bb.4:
Ltmp168:
Lloh92:
	adrp	x1, __ZNSt3__15ctypeIcE2idE@GOTPAGE
Lloh93:
	ldr	x1, [x1, __ZNSt3__15ctypeIcE2idE@GOTPAGEOFF]
	add	x0, sp, #24
	bl	__ZNKSt3__16locale9use_facetERNS0_2idE
Ltmp169:
; %bb.5:
	ldr	x8, [x0]
	ldr	x8, [x8, #56]
Ltmp170:
	mov	w1, #32                         ; =0x20
	blr	x8
Ltmp171:
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
Ltmp173:
	sxtb	w5, w23
	mov	x0, x22
	mov	x1, x20
	bl	__ZNSt3__116__pad_and_outputB9nqe210106IcNS_11char_traitsIcEEEENS_19ostreambuf_iteratorIT_T0_EES6_PKS4_S8_S8_RNS_8ios_baseES4_
Ltmp174:
; %bb.8:
	cbnz	x0, LBB8_10
; %bb.9:
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
	add	x0, x19, x8
	ldr	w8, [x0, #32]
	mov	w9, #5                          ; =0x5
Ltmp176:
	orr	w1, w8, w9
	bl	__ZNSt3__18ios_base5clearEj
Ltmp177:
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
Ltmp178:
	b	LBB8_15
LBB8_13:
Ltmp172:
	mov	x20, x0
	add	x0, sp, #24
	bl	__ZNSt3__16localeD1Ev
	b	LBB8_16
LBB8_14:
Ltmp175:
LBB8_15:
	mov	x20, x0
LBB8_16:
	add	x0, sp, #8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryD1Ev
	b	LBB8_18
LBB8_17:
Ltmp165:
	mov	x20, x0
LBB8_18:
	mov	x0, x20
	bl	___cxa_begin_catch
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
Ltmp179:
	add	x0, x19, x8
	bl	__ZNSt3__18ios_base33__set_badbit_and_consider_rethrowEv
Ltmp180:
; %bb.19:
	bl	___cxa_end_catch
	b	LBB8_11
LBB8_20:
Ltmp181:
	mov	x19, x0
Ltmp182:
	bl	___cxa_end_catch
Ltmp183:
; %bb.21:
	mov	x0, x19
	bl	__Unwind_Resume
LBB8_22:
Ltmp184:
	bl	___clang_call_terminate
	.loh AdrpLdrGot	Lloh92, Lloh93
Lfunc_end5:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table8:
Lexception5:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase3-Lttbaseref3
Lttbaseref3:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end5-Lcst_begin5
Lcst_begin5:
	.uleb128 Ltmp163-Lfunc_begin5           ; >> Call Site 1 <<
	.uleb128 Ltmp164-Ltmp163                ;   Call between Ltmp163 and Ltmp164
	.uleb128 Ltmp165-Lfunc_begin5           ;     jumps to Ltmp165
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp166-Lfunc_begin5           ; >> Call Site 2 <<
	.uleb128 Ltmp167-Ltmp166                ;   Call between Ltmp166 and Ltmp167
	.uleb128 Ltmp175-Lfunc_begin5           ;     jumps to Ltmp175
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp168-Lfunc_begin5           ; >> Call Site 3 <<
	.uleb128 Ltmp171-Ltmp168                ;   Call between Ltmp168 and Ltmp171
	.uleb128 Ltmp172-Lfunc_begin5           ;     jumps to Ltmp172
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp173-Lfunc_begin5           ; >> Call Site 4 <<
	.uleb128 Ltmp174-Ltmp173                ;   Call between Ltmp173 and Ltmp174
	.uleb128 Ltmp175-Lfunc_begin5           ;     jumps to Ltmp175
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp176-Lfunc_begin5           ; >> Call Site 5 <<
	.uleb128 Ltmp177-Ltmp176                ;   Call between Ltmp176 and Ltmp177
	.uleb128 Ltmp178-Lfunc_begin5           ;     jumps to Ltmp178
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp177-Lfunc_begin5           ; >> Call Site 6 <<
	.uleb128 Ltmp179-Ltmp177                ;   Call between Ltmp177 and Ltmp179
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp179-Lfunc_begin5           ; >> Call Site 7 <<
	.uleb128 Ltmp180-Ltmp179                ;   Call between Ltmp179 and Ltmp180
	.uleb128 Ltmp181-Lfunc_begin5           ;     jumps to Ltmp181
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp180-Lfunc_begin5           ; >> Call Site 8 <<
	.uleb128 Ltmp182-Ltmp180                ;   Call between Ltmp180 and Ltmp182
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp182-Lfunc_begin5           ; >> Call Site 9 <<
	.uleb128 Ltmp183-Ltmp182                ;   Call between Ltmp182 and Ltmp183
	.uleb128 Ltmp184-Lfunc_begin5           ;     jumps to Ltmp184
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp183-Lfunc_begin5           ; >> Call Site 10 <<
	.uleb128 Lfunc_end5-Ltmp183             ;   Call between Ltmp183 and Lfunc_end5
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end5:
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
Ltmp185:
	mov	x0, x19
	mov	x2, x24
	blr	x8
Ltmp186:
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
Ltmp187:
	mov	x19, x0
	ldrsb	w8, [sp, #31]
	tbz	w8, #31, LBB9_20
; %bb.19:
	ldr	x0, [sp, #8]
	bl	__ZdlPv
LBB9_20:
	mov	x0, x19
	bl	__Unwind_Resume
Lfunc_end6:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table9:
Lexception6:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end6-Lcst_begin6
Lcst_begin6:
	.uleb128 Lfunc_begin6-Lfunc_begin6      ; >> Call Site 1 <<
	.uleb128 Ltmp185-Lfunc_begin6           ;   Call between Lfunc_begin6 and Ltmp185
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp185-Lfunc_begin6           ; >> Call Site 2 <<
	.uleb128 Ltmp186-Ltmp185                ;   Call between Ltmp185 and Ltmp186
	.uleb128 Ltmp187-Lfunc_begin6           ;     jumps to Ltmp187
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp186-Lfunc_begin6           ; >> Call Site 3 <<
	.uleb128 Lfunc_end6-Ltmp186             ;   Call between Ltmp186 and Lfunc_end6
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
Lloh94:
	adrp	x0, l_.str.18@PAGE
Lloh95:
	add	x0, x0, l_.str.18@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh94, Lloh95
	.cfi_endproc
                                        ; -- End function
	.private_extern	__ZNSt3__120__throw_length_errorB9nqe210106EPKc ; -- Begin function _ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.globl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.weak_def_can_be_hidden	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.p2align	2
__ZNSt3__120__throw_length_errorB9nqe210106EPKc: ; @_ZNSt3__120__throw_length_errorB9nqe210106EPKc
Lfunc_begin7:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception7
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
Ltmp188:
	mov	x1, x20
	bl	__ZNSt12length_errorC1B9nqe210106EPKc
Ltmp189:
; %bb.1:
Lloh96:
	adrp	x1, __ZTISt12length_error@GOTPAGE
Lloh97:
	ldr	x1, [x1, __ZTISt12length_error@GOTPAGEOFF]
Lloh98:
	adrp	x2, __ZNSt12length_errorD1Ev@GOTPAGE
Lloh99:
	ldr	x2, [x2, __ZNSt12length_errorD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
LBB11_2:
Ltmp190:
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x0, x20
	bl	__Unwind_Resume
	.loh AdrpLdrGot	Lloh98, Lloh99
	.loh AdrpLdrGot	Lloh96, Lloh97
Lfunc_end7:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table11:
Lexception7:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end7-Lcst_begin7
Lcst_begin7:
	.uleb128 Lfunc_begin7-Lfunc_begin7      ; >> Call Site 1 <<
	.uleb128 Ltmp188-Lfunc_begin7           ;   Call between Lfunc_begin7 and Ltmp188
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp188-Lfunc_begin7           ; >> Call Site 2 <<
	.uleb128 Ltmp189-Ltmp188                ;   Call between Ltmp188 and Ltmp189
	.uleb128 Ltmp190-Lfunc_begin7           ;     jumps to Ltmp190
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp189-Lfunc_begin7           ; >> Call Site 3 <<
	.uleb128 Lfunc_end7-Ltmp189             ;   Call between Ltmp189 and Lfunc_end7
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end7:
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
Lloh100:
	adrp	x8, __ZTVSt12length_error@GOTPAGE
Lloh101:
	ldr	x8, [x8, __ZTVSt12length_error@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x0]
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
	.loh AdrpLdrGot	Lloh100, Lloh101
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
Lloh102:
	adrp	x1, __ZTISt20bad_array_new_length@GOTPAGE
Lloh103:
	ldr	x1, [x1, __ZTISt20bad_array_new_length@GOTPAGEOFF]
Lloh104:
	adrp	x2, __ZNSt20bad_array_new_lengthD1Ev@GOTPAGE
Lloh105:
	ldr	x2, [x2, __ZNSt20bad_array_new_lengthD1Ev@GOTPAGEOFF]
	bl	___cxa_throw
	.loh AdrpLdrGot	Lloh104, Lloh105
	.loh AdrpLdrGot	Lloh102, Lloh103
	.cfi_endproc
                                        ; -- End function
	.private_extern	__ZNSt3__16vectorImNS_9allocatorImEEE20__throw_length_errorB9nqe210106Ev ; -- Begin function _ZNSt3__16vectorImNS_9allocatorImEEE20__throw_length_errorB9nqe210106Ev
	.globl	__ZNSt3__16vectorImNS_9allocatorImEEE20__throw_length_errorB9nqe210106Ev
	.weak_def_can_be_hidden	__ZNSt3__16vectorImNS_9allocatorImEEE20__throw_length_errorB9nqe210106Ev
	.p2align	2
__ZNSt3__16vectorImNS_9allocatorImEEE20__throw_length_errorB9nqe210106Ev: ; @_ZNSt3__16vectorImNS_9allocatorImEEE20__throw_length_errorB9nqe210106Ev
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh106:
	adrp	x0, l_.str.19@PAGE
Lloh107:
	add	x0, x0, l_.str.19@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh106, Lloh107
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__literal16,16byte_literals
	.p2align	4, 0x0                          ; -- Begin function _ZNSt3__124uniform_int_distributionIlEclINS_23mersenne_twister_engineIjLm32ELm624ELm397ELm31ELj2567483615ELm11ELj4294967295ELm7ELj2636928640ELm15ELj4022730752ELm18ELj1812433253EEEEElRT_RKNS1_10param_typeE
lCPI15_0:
	.quad	64                              ; 0x40
	.quad	32                              ; 0x20
lCPI15_1:
	.quad	4294967296                      ; 0x100000000
	.quad	0                               ; 0x0
	.section	__TEXT,__text,regular,pure_instructions
	.private_extern	__ZNSt3__124uniform_int_distributionIlEclINS_23mersenne_twister_engineIjLm32ELm624ELm397ELm31ELj2567483615ELm11ELj4294967295ELm7ELj2636928640ELm15ELj4022730752ELm18ELj1812433253EEEEElRT_RKNS1_10param_typeE
	.globl	__ZNSt3__124uniform_int_distributionIlEclINS_23mersenne_twister_engineIjLm32ELm624ELm397ELm31ELj2567483615ELm11ELj4294967295ELm7ELj2636928640ELm15ELj4022730752ELm18ELj1812433253EEEEElRT_RKNS1_10param_typeE
	.weak_def_can_be_hidden	__ZNSt3__124uniform_int_distributionIlEclINS_23mersenne_twister_engineIjLm32ELm624ELm397ELm31ELj2567483615ELm11ELj4294967295ELm7ELj2636928640ELm15ELj4022730752ELm18ELj1812433253EEEEElRT_RKNS1_10param_typeE
	.p2align	2
__ZNSt3__124uniform_int_distributionIlEclINS_23mersenne_twister_engineIjLm32ELm624ELm397ELm31ELj2567483615ELm11ELj4294967295ELm7ELj2636928640ELm15ELj4022730752ELm18ELj1812433253EEEEElRT_RKNS1_10param_typeE: ; @_ZNSt3__124uniform_int_distributionIlEclINS_23mersenne_twister_engineIjLm32ELm624ELm397ELm31ELj2567483615ELm11ELj4294967295ELm7ELj2636928640ELm15ELj4022730752ELm18ELj1812433253EEEEElRT_RKNS1_10param_typeE
	.cfi_startproc
; %bb.0:
	ldp	x8, x0, [x2]
	subs	x8, x0, x8
	b.eq	LBB15_14
; %bb.1:
	sub	sp, sp, #96
	stp	x20, x19, [sp, #64]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #80]             ; 16-byte Folded Spill
	add	x29, sp, #80
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	add	x19, x8, #1
	cbz	x19, LBB15_7
; %bb.2:
	clz	x8, x19
	lsl	x9, x19, x8
	tst	x9, #0x7fffffffffffffff
	mov	w9, #63                         ; =0x3f
	cinc	x9, x9, ne
	sub	x10, x9, x8
	stp	x1, x10, [sp]
	add	x8, x10, #31
	lsr	x9, x8, #5
	udiv	w8, w10, w9
	stp	x8, x9, [sp, #16]
	mov	x11, #-1                        ; =0xffffffffffffffff
	lsl	x11, x11, x8
	and	x11, x11, #0x100000000
	cmp	w8, #64
	csel	x11, x11, xzr, lo
	str	x11, [sp, #40]
	eor	x12, x11, #0x100000000
	udiv	x11, x11, x9
	cmp	x12, x11
	b.ls	LBB15_5
; %bb.3:
	add	x9, x9, #1
	and	w8, w10, #0xff
	and	w11, w9, #0xff
	udiv	w8, w8, w11
	stp	x8, x9, [sp, #16]
	cmp	w8, #63
	b.hi	LBB15_8
; %bb.4:
	mov	x11, #-1                        ; =0xffffffffffffffff
	lsl	x11, x11, x8
	and	x11, x11, #0x100000000
	str	x11, [sp, #40]
LBB15_5:
	and	w11, w9, #0xff
	and	w10, w10, #0xff
	udiv	w12, w10, w11
	msub	w10, w12, w11, w10
	sub	x9, x9, x10
	str	x9, [sp, #32]
	mov	x20, x2
	cmp	x8, #63
	b.hs	LBB15_9
; %bb.6:
	add	x9, x8, #1
	mov	w10, #-2147483648               ; =0x80000000
	lsr	x10, x10, x8
	lsl	x9, x10, x9
	str	x9, [sp, #48]
	neg	w9, w8
	mov	w10, #-1                        ; =0xffffffff
	lsr	w9, w10, w9
	cmp	x8, #0
	csel	w9, wzr, w9, eq
	str	w9, [sp, #56]
	mvn	w9, w8
	lsr	w9, w10, w9
	cmp	x8, #31
	csinv	w8, w9, wzr, lo
	b	LBB15_10
LBB15_7:
	str	x1, [sp]
Lloh108:
	adrp	x8, lCPI15_0@PAGE
Lloh109:
	ldr	q0, [x8, lCPI15_0@PAGEOFF]
	stur	q0, [sp, #8]
	mov	w8, #2                          ; =0x2
	dup.2d	v0, x8
	stur	q0, [sp, #24]
Lloh110:
	adrp	x8, lCPI15_1@PAGE
Lloh111:
	ldr	q0, [x8, lCPI15_1@PAGEOFF]
	stur	q0, [sp, #40]
	movi.2d	v0, #0xffffffffffffffff
	str	d0, [sp, #56]
	mov	x0, sp
	bl	__ZNSt3__125__independent_bits_engineINS_23mersenne_twister_engineIjLm32ELm624ELm397ELm31ELj2567483615ELm11ELj4294967295ELm7ELj2636928640ELm15ELj4022730752ELm18ELj1812433253EEEmE6__evalENS_17integral_constantIbLb1EEE
	b	LBB15_13
LBB15_8:
	mov	x20, x2
	msub	w8, w8, w9, w10
	sub	x8, x9, w8, uxtb
	stp	x8, xzr, [sp, #32]
	mov	w8, #64                         ; =0x40
LBB15_9:
	str	xzr, [sp, #48]
	neg	w9, w8
	mov	w8, #-1                         ; =0xffffffff
	lsr	w9, w8, w9
	str	w9, [sp, #56]
LBB15_10:
	str	w8, [sp, #60]
LBB15_11:                               ; =>This Inner Loop Header: Depth=1
	mov	x0, sp
	bl	__ZNSt3__125__independent_bits_engineINS_23mersenne_twister_engineIjLm32ELm624ELm397ELm31ELj2567483615ELm11ELj4294967295ELm7ELj2636928640ELm15ELj4022730752ELm18ELj1812433253EEEmE6__evalENS_17integral_constantIbLb1EEE
	cmp	x0, x19
	b.hs	LBB15_11
; %bb.12:
	ldr	x8, [x20]
	add	x0, x8, x0
LBB15_13:
	ldp	x29, x30, [sp, #80]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #64]             ; 16-byte Folded Reload
	add	sp, sp, #96
LBB15_14:
	ret
	.loh AdrpLdr	Lloh110, Lloh111
	.loh AdrpLdr	Lloh108, Lloh109
	.cfi_endproc
                                        ; -- End function
	.private_extern	__ZNSt3__125__independent_bits_engineINS_23mersenne_twister_engineIjLm32ELm624ELm397ELm31ELj2567483615ELm11ELj4294967295ELm7ELj2636928640ELm15ELj4022730752ELm18ELj1812433253EEEmE6__evalENS_17integral_constantIbLb1EEE ; -- Begin function _ZNSt3__125__independent_bits_engineINS_23mersenne_twister_engineIjLm32ELm624ELm397ELm31ELj2567483615ELm11ELj4294967295ELm7ELj2636928640ELm15ELj4022730752ELm18ELj1812433253EEEmE6__evalENS_17integral_constantIbLb1EEE
	.globl	__ZNSt3__125__independent_bits_engineINS_23mersenne_twister_engineIjLm32ELm624ELm397ELm31ELj2567483615ELm11ELj4294967295ELm7ELj2636928640ELm15ELj4022730752ELm18ELj1812433253EEEmE6__evalENS_17integral_constantIbLb1EEE
	.weak_def_can_be_hidden	__ZNSt3__125__independent_bits_engineINS_23mersenne_twister_engineIjLm32ELm624ELm397ELm31ELj2567483615ELm11ELj4294967295ELm7ELj2636928640ELm15ELj4022730752ELm18ELj1812433253EEEmE6__evalENS_17integral_constantIbLb1EEE
	.p2align	2
__ZNSt3__125__independent_bits_engineINS_23mersenne_twister_engineIjLm32ELm624ELm397ELm31ELj2567483615ELm11ELj4294967295ELm7ELj2636928640ELm15ELj4022730752ELm18ELj1812433253EEEmE6__evalENS_17integral_constantIbLb1EEE: ; @_ZNSt3__125__independent_bits_engineINS_23mersenne_twister_engineIjLm32ELm624ELm397ELm31ELj2567483615ELm11ELj4294967295ELm7ELj2636928640ELm15ELj4022730752ELm18ELj1812433253EEEmE6__evalENS_17integral_constantIbLb1EEE
	.cfi_startproc
; %bb.0:
	stp	x20, x19, [sp, #-16]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	.cfi_offset w19, -8
	.cfi_offset w20, -16
	mov	w9, #-272236544                 ; =0xefc60000
	mov	w10, #22144                     ; =0x5680
	movk	w10, #40236, lsl #16
	mov	w11, #45279                     ; =0xb0df
	movk	w11, #39176, lsl #16
	ldr	x12, [x0, #32]
	mov	x13, #3361                      ; =0xd21
	movk	x13, #8402, lsl #16
	movk	x13, #53773, lsl #32
	movk	x13, #3360, lsl #48
	mov	x8, #0                          ; =0x0
	cbz	x12, LBB16_5
; %bb.1:
	mov	x15, #0                         ; =0x0
	ldr	x14, [x0]
	ldr	x16, [x0, #40]
	ldr	x17, [x0, #16]
	ldr	x1, [x14, #2496]
	mov	w2, #624                        ; =0x270
LBB16_2:                                ; =>This Inner Loop Header: Depth=1
	mov	x3, x1
	add	x1, x1, #1
	lsr	x4, x1, #4
	umulh	x4, x4, x13
	lsr	x4, x4, #1
	msub	x1, x4, x2, x1
	ldr	w4, [x14, x3, lsl #2]
	and	w4, w4, #0x80000000
	ldr	w5, [x14, x1, lsl #2]
	and	w6, w5, #0x7ffffffe
	orr	w4, w6, w4
	add	x6, x3, #397
	lsr	x7, x6, #4
	umulh	x7, x7, x13
	lsr	x7, x7, #1
	msub	x6, x7, x2, x6
	ldr	w6, [x14, x6, lsl #2]
	tst	w5, #0x1
	csel	w5, w11, wzr, ne
	eor	w5, w5, w6
	eor	w4, w5, w4, lsr #1
	str	w4, [x14, x3, lsl #2]
	eor	w3, w4, w4, lsr #11
	and	w4, w10, w3, lsl #7
	eor	w3, w4, w3
	and	w4, w9, w3, lsl #15
	eor	w3, w4, w3
	eor	w3, w3, w3, lsr #18
	cmp	x16, x3
	b.ls	LBB16_2
; %bb.3:                                ;   in Loop: Header=BB16_2 Depth=1
	lsl	x8, x8, x17
	cmp	x17, #64
	csel	x8, x8, xzr, lo
	ldr	w4, [x0, #56]
	and	w3, w4, w3
	add	x8, x8, x3
	add	x15, x15, #1
	cmp	x15, x12
	b.ne	LBB16_2
; %bb.4:
	str	x1, [x14, #2496]
LBB16_5:
	ldr	x14, [x0, #24]
	cmp	x12, x14
	b.hs	LBB16_10
; %bb.6:
	ldr	x15, [x0]
	ldr	x16, [x0, #48]
	ldr	x17, [x0, #16]
	add	x1, x17, #1
	ldr	x3, [x15, #2496]
	mov	w2, #624                        ; =0x270
LBB16_7:                                ; =>This Inner Loop Header: Depth=1
	mov	x4, x3
	add	x3, x3, #1
	lsr	x5, x3, #4
	umulh	x5, x5, x13
	lsr	x5, x5, #1
	msub	x3, x5, x2, x3
	ldr	w5, [x15, x4, lsl #2]
	and	w5, w5, #0x80000000
	ldr	w6, [x15, x3, lsl #2]
	and	w7, w6, #0x7ffffffe
	orr	w5, w7, w5
	add	x7, x4, #397
	lsr	x19, x7, #4
	umulh	x19, x19, x13
	lsr	x19, x19, #1
	msub	x7, x19, x2, x7
	ldr	w7, [x15, x7, lsl #2]
	tst	w6, #0x1
	csel	w6, w11, wzr, ne
	eor	w6, w6, w7
	eor	w5, w6, w5, lsr #1
	str	w5, [x15, x4, lsl #2]
	eor	w4, w5, w5, lsr #11
	and	w5, w10, w4, lsl #7
	eor	w4, w5, w4
	and	w5, w9, w4, lsl #15
	eor	w4, w5, w4
	eor	w4, w4, w4, lsr #18
	cmp	x16, x4
	b.ls	LBB16_7
; %bb.8:                                ;   in Loop: Header=BB16_7 Depth=1
	lsl	x8, x8, x1
	cmp	x17, #63
	csel	x8, x8, xzr, lo
	ldr	w5, [x0, #60]
	and	w4, w5, w4
	add	x8, x8, x4
	add	x12, x12, #1
	cmp	x12, x14
	b.ne	LBB16_7
; %bb.9:
	str	x3, [x15, #2496]
LBB16_10:
	mov	x0, x8
	ldp	x20, x19, [sp], #16             ; 16-byte Folded Reload
	ret
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
Lloh112:
	adrp	x0, l_.str.19@PAGE
Lloh113:
	add	x0, x0, l_.str.19@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh112, Lloh113
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _Z6faultsv.cold.1
__Z6faultsv.cold.1:                     ; @_Z6faultsv.cold.1
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
	.p2align	2                               ; -- Begin function _ZN7MappingC2Em.cold.1
__ZN7MappingC2Em.cold.1:                ; @_ZN7MappingC2Em.cold.1
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
	.p2align	2                               ; -- Begin function _ZN7MappingC2Em.cold.2
__ZN7MappingC2Em.cold.2:                ; @_ZN7MappingC2Em.cold.2
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh114:
	adrp	x1, __ZTISt16invalid_argument@GOTPAGE
Lloh115:
	ldr	x1, [x1, __ZTISt16invalid_argument@GOTPAGEOFF]
Lloh116:
	adrp	x2, __ZNSt16invalid_argumentD1Ev@GOTPAGE
Lloh117:
	ldr	x2, [x2, __ZNSt16invalid_argumentD1Ev@GOTPAGEOFF]
	bl	___cxa_throw
	.loh AdrpLdrGot	Lloh116, Lloh117
	.loh AdrpLdrGot	Lloh114, Lloh115
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
	.asciz	"getrusage"

	.globl	_sink                           ; @sink
.zerofill __DATA,__common,_sink,8,3
l_.str.1:                               ; @.str.1
	.asciz	"broken ring"

l_.str.2:                               ; @.str.2
	.asciz	"nodes="

l_.str.3:                               ; @.str.3
	.asciz	" stride="

l_.str.4:                               ; @.str.4
	.asciz	" reserved_bytes="

l_.str.5:                               ; @.str.5
	.asciz	" virtual_pages="

l_.str.6:                               ; @.str.6
	.asciz	" first_touch_minflt="

l_.str.7:                               ; @.str.7
	.asciz	" warm_minflt="

l_.str.8:                               ; @.str.8
	.asciz	" ns_per_load_p50="

l_.str.9:                               ; @.str.9
	.asciz	" p95="

l_.str.10:                              ; @.str.10
	.asciz	"page size query"

l_.str.11:                              ; @.str.11
	.asciz	"host_page_bytes="

l_.str.12:                              ; @.str.12
	.asciz	" sample=262144 dependent CPU loads\n"

l_.str.13:                              ; @.str.13
	.asciz	"empty rejection"

l_.str.14:                              ; @.str.14
	.asciz	"PASS 8 rings, rejected zero; TLB counters and board unverified\n"

l_.str.15:                              ; @.str.15
	.asciz	"empty mapping"

l_.str.16:                              ; @.str.16
	.asciz	"mmap"

l_.str.17:                              ; @.str.17
	.asciz	"munmap failed\n"

l_.str.18:                              ; @.str.18
	.asciz	"basic_string"

l_.str.19:                              ; @.str.19
	.asciz	"vector"

.subsections_via_symbols
