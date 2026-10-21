	.build_version macos, 26, 0	sdk_version 26, 5
	.section	__TEXT,__literal16,16byte_literals
	.p2align	4, 0x0                          ; -- Begin function main
lCPI0_0:
	.long	0                               ; 0x0
	.long	1                               ; 0x1
	.long	2                               ; 0x2
	.long	3                               ; 0x3
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_main
	.p2align	2
_main:                                  ; @main
Lfunc_begin0:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception0
; %bb.0:
	sub	sp, sp, #128
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
	cmp	w0, #2
	b.ne	LBB0_70
; %bb.1:
	mov	x20, x1
	mov	x25, #-10                       ; =0xfffffffffffffff6
	movk	x25, #32767, lsl #48
	ldr	x21, [x1, #8]
	mov	x0, x21
	bl	_strlen
	cmp	x0, x25
	b.hi	LBB0_72
; %bb.2:
	mov	x19, x0
	cmp	x0, #23
	b.hs	LBB0_7
; %bb.3:
	strb	w19, [sp, #47]
	add	x22, sp, #24
	cbnz	x19, LBB0_9
; %bb.4:
	strb	wzr, [x22, x19]
	ldrsb	w24, [sp, #47]
	tbnz	w24, #31, LBB0_10
LBB0_5:
	cmp	w24, #6
	b.ne	LBB0_13
; %bb.6:
	add	x8, sp, #24
	b	LBB0_12
LBB0_7:
	orr	x8, x19, #0x7
	cmp	x8, #23
	mov	w9, #25                         ; =0x19
	csinc	x23, x9, x8, eq
Ltmp0:
	mov	x0, x23
	bl	__Znwm
Ltmp1:
; %bb.8:
	mov	x22, x0
	orr	x8, x23, #0x8000000000000000
	stp	x19, x8, [sp, #32]
	str	x0, [sp, #24]
LBB0_9:
	mov	x0, x22
	mov	x1, x21
	mov	x2, x19
	bl	_memmove
	strb	wzr, [x22, x19]
	ldrsb	w24, [sp, #47]
	tbz	w24, #31, LBB0_5
LBB0_10:
	ldr	x8, [sp, #32]
	cmp	x8, #6
	b.ne	LBB0_13
; %bb.11:
	ldr	x8, [sp, #24]
LBB0_12:
	ldr	w9, [x8]
	ldrh	w8, [x8, #4]
	mov	w10, #25459                     ; =0x6373
	movk	w10, #27745, lsl #16
	cmp	w9, w10
	mov	w9, #29281                      ; =0x7261
	ccmp	w8, w9, #0, eq
	b.eq	LBB0_25
LBB0_13:
	ldr	x21, [x20, #8]
	mov	x0, x21
	bl	_strlen
	cmp	x0, x25
	b.hi	LBB0_76
; %bb.14:
	mov	x19, x0
	cmp	x0, #23
	b.hs	LBB0_19
; %bb.15:
	strb	w19, [sp, #23]
	mov	x22, sp
	cbnz	x19, LBB0_21
; %bb.16:
	strb	wzr, [x22, x19]
	ldrsb	w8, [sp, #23]
	tbnz	w8, #31, LBB0_22
LBB0_17:
	cmp	w8, #4
	b.ne	LBB0_24
; %bb.18:
	ldr	w8, [sp]
	mov	w9, #25966                      ; =0x656e
	movk	w9, #28271, lsl #16
	cmp	w8, w9
	cset	w19, ne
	b	LBB0_28
LBB0_19:
	orr	x8, x19, #0x7
	cmp	x8, #23
	mov	w9, #25                         ; =0x19
	csinc	x23, x9, x8, eq
Ltmp2:
	mov	x0, x23
	bl	__Znwm
Ltmp3:
; %bb.20:
	mov	x22, x0
	orr	x8, x23, #0x8000000000000000
	stp	x19, x8, [sp, #8]
	str	x0, [sp]
LBB0_21:
	mov	x0, x22
	mov	x1, x21
	mov	x2, x19
	bl	_memmove
	strb	wzr, [x22, x19]
	ldrsb	w8, [sp, #23]
	tbz	w8, #31, LBB0_17
LBB0_22:
	ldr	x8, [sp, #8]
	cmp	x8, #4
	b.ne	LBB0_26
; %bb.23:
	ldr	x8, [sp]
	ldr	w8, [x8]
	mov	w9, #25966                      ; =0x656e
	movk	w9, #28271, lsl #16
	cmp	w8, w9
	cset	w19, ne
	b	LBB0_27
LBB0_24:
	mov	w19, #1                         ; =0x1
	b	LBB0_28
LBB0_25:
	mov	w19, #0                         ; =0x0
	tbz	w24, #7, LBB0_30
	b	LBB0_29
LBB0_26:
	mov	w19, #1                         ; =0x1
LBB0_27:
	ldr	x0, [sp]
	bl	__ZdlPv
LBB0_28:
	ldrb	w24, [sp, #47]
	tbz	w24, #7, LBB0_30
LBB0_29:
	ldr	x0, [sp, #24]
	bl	__ZdlPv
LBB0_30:
	cbnz	w19, LBB0_70
; %bb.31:
Ltmp7:
	mov	w0, #4194304                    ; =0x400000
	bl	__Znwm
Ltmp8:
; %bb.32:
	mov	x19, x0
	mov	w1, #4194304                    ; =0x400000
	bl	_bzero
	mov	x8, #0                          ; =0x0
Lloh0:
	adrp	x9, lCPI0_0@PAGE
Lloh1:
	ldr	q0, [x9, lCPI0_0@PAGEOFF]
	movi.4s	v1, #4
	movi.4s	v2, #8
	movi.4s	v3, #12
	mov	w9, #16417                      ; =0x4021
	movk	w9, #128, lsl #16
	dup.4s	v4, w9
	movi.4s	v5, #1, msl #8
	movi.4s	v6, #63, lsl #24
	mov	w9, #-1023541248                ; =0xc2fe0000
	dup.4s	v7, w9
	movi.4s	v16, #16
LBB0_33:                                ; =>This Inner Loop Header: Depth=1
	add.4s	v17, v0, v1
	add.4s	v18, v0, v2
	add.4s	v19, v0, v3
	umull2.2d	v20, v0, v4
	umull.2d	v21, v0, v4
	uzp2.4s	v20, v21, v20
	sub.4s	v21, v0, v20
	usra.4s	v20, v21, #1
	ushr.4s	v20, v20, #8
	mov.16b	v21, v0
	mls.4s	v21, v20, v5
	umull2.2d	v20, v17, v4
	umull.2d	v22, v17, v4
	uzp2.4s	v20, v22, v20
	sub.4s	v22, v17, v20
	usra.4s	v20, v22, #1
	ushr.4s	v20, v20, #8
	mls.4s	v17, v20, v5
	umull2.2d	v20, v18, v4
	umull.2d	v22, v18, v4
	uzp2.4s	v20, v22, v20
	sub.4s	v22, v18, v20
	usra.4s	v20, v22, #1
	ushr.4s	v20, v20, #8
	mls.4s	v18, v20, v5
	umull2.2d	v20, v19, v4
	umull.2d	v22, v19, v4
	uzp2.4s	v20, v22, v20
	sub.4s	v22, v19, v20
	usra.4s	v20, v22, #1
	ushr.4s	v20, v20, #8
	mls.4s	v19, v20, v5
	ucvtf.4s	v20, v21
	ucvtf.4s	v17, v17
	ucvtf.4s	v18, v18
	ucvtf.4s	v19, v19
	fmul.4s	v20, v20, v6
	fmul.4s	v17, v17, v6
	fmul.4s	v18, v18, v6
	fmul.4s	v19, v19, v6
	fadd.4s	v20, v20, v7
	fadd.4s	v17, v17, v7
	fadd.4s	v18, v18, v7
	fadd.4s	v19, v19, v7
	add	x9, x19, x8
	stp	q20, q17, [x9]
	stp	q18, q19, [x9, #32]
	add.4s	v0, v0, v16
	add	x8, x8, #64
	cmp	x8, #1024, lsl #12              ; =4194304
	b.ne	LBB0_33
; %bb.34:
Ltmp10:
	mov	w0, #1048576                    ; =0x100000
	bl	__Znwm
Ltmp11:
; %bb.35:
	mov	x21, x0
	mov	w1, #1048576                    ; =0x100000
	bl	_bzero
Ltmp13:
	mov	w0, #1048576                    ; =0x100000
	bl	__Znwm
Ltmp14:
; %bb.36:
	mov	x22, x0
	mov	w1, #1048576                    ; =0x100000
	bl	_bzero
Ltmp16:
	fmov	s0, #1.00000000
	mov	x0, x19
	mov	x1, x22
	mov	w2, #1048576                    ; =0x100000
	bl	__ZN8practice6scalarEPKfPamf
Ltmp17:
; %bb.37:
	ldr	x24, [x20, #8]
	mov	x0, x24
	bl	_strlen
	cmp	x0, x25
	b.hi	LBB0_73
; %bb.38:
	mov	x23, x0
	cmp	x0, #23
	b.hs	LBB0_43
; %bb.39:
	strb	w23, [sp, #47]
	add	x25, sp, #24
	cbnz	x23, LBB0_45
; %bb.40:
	strb	wzr, [x25, x23]
	ldrsb	w8, [sp, #47]
	tbnz	w8, #31, LBB0_46
LBB0_41:
Lloh2:
	adrp	x24, __ZN8practice4neonEPKfPamf@GOTPAGE
Lloh3:
	ldr	x24, [x24, __ZN8practice4neonEPKfPamf@GOTPAGEOFF]
	cmp	w8, #6
	b.ne	LBB0_49
; %bb.42:
	ldrh	w8, [sp, #28]
	ldr	w9, [sp, #24]
	orr	x8, x9, x8, lsl #32
	rev	x8, x8
	mov	x9, #1634861056                 ; =0x61720000
	movk	x9, #24940, lsl #32
	movk	x9, #29539, lsl #48
	cmp	x8, x9
	cset	w8, hi
	csinv	w8, w8, wzr, hs
Lloh4:
	adrp	x9, __ZN8practice6scalarEPKfPamf@GOTPAGE
Lloh5:
	ldr	x9, [x9, __ZN8practice6scalarEPKfPamf@GOTPAGEOFF]
	cmp	w8, #0
	csel	x24, x9, x24, eq
	b	LBB0_49
LBB0_43:
	orr	x8, x23, #0x7
	cmp	x8, #23
	mov	w9, #25                         ; =0x19
	csinc	x26, x9, x8, eq
Ltmp19:
	mov	x0, x26
	bl	__Znwm
Ltmp20:
; %bb.44:
	mov	x25, x0
	orr	x8, x26, #0x8000000000000000
	stp	x23, x8, [sp, #32]
	str	x0, [sp, #24]
LBB0_45:
	mov	x0, x25
	mov	x1, x24
	mov	x2, x23
	bl	_memmove
	strb	wzr, [x25, x23]
	ldrsb	w8, [sp, #47]
	tbz	w8, #31, LBB0_41
LBB0_46:
Lloh6:
	adrp	x24, __ZN8practice4neonEPKfPamf@GOTPAGE
Lloh7:
	ldr	x24, [x24, __ZN8practice4neonEPKfPamf@GOTPAGEOFF]
	ldp	x0, x8, [sp, #24]
	cmp	x8, #6
	b.ne	LBB0_48
; %bb.47:
	ldrh	w8, [x0, #4]
	ldr	w9, [x0]
	orr	x8, x9, x8, lsl #32
	rev	x8, x8
	mov	x9, #1634861056                 ; =0x61720000
	movk	x9, #24940, lsl #32
	movk	x9, #29539, lsl #48
	cmp	x8, x9
	cset	w8, hi
	csinv	w8, w8, wzr, hs
Lloh8:
	adrp	x9, __ZN8practice6scalarEPKfPamf@GOTPAGE
Lloh9:
	ldr	x9, [x9, __ZN8practice6scalarEPKfPamf@GOTPAGEOFF]
	cmp	w8, #0
	csel	x24, x9, x24, eq
LBB0_48:
	bl	__ZdlPv
LBB0_49:
Ltmp21:
	fmov	s0, #1.00000000
	mov	x0, x19
	mov	x1, x21
	mov	w2, #1048576                    ; =0x100000
	blr	x24
Ltmp22:
; %bb.50:
Ltmp23:
	fmov	s0, #1.00000000
	mov	x0, x19
	mov	x1, x21
	mov	w2, #1048576                    ; =0x100000
	blr	x24
Ltmp24:
; %bb.51:
Ltmp25:
	fmov	s0, #1.00000000
	mov	x0, x19
	mov	x1, x21
	mov	w2, #1048576                    ; =0x100000
	blr	x24
Ltmp26:
; %bb.52:
Ltmp27:
	fmov	s0, #1.00000000
	mov	x0, x19
	mov	x1, x21
	mov	w2, #1048576                    ; =0x100000
	blr	x24
Ltmp28:
; %bb.53:
Ltmp29:
	fmov	s0, #1.00000000
	mov	x0, x19
	mov	x1, x21
	mov	w2, #1048576                    ; =0x100000
	blr	x24
Ltmp30:
; %bb.54:
Ltmp31:
	fmov	s0, #1.00000000
	mov	x0, x19
	mov	x1, x21
	mov	w2, #1048576                    ; =0x100000
	blr	x24
Ltmp32:
; %bb.55:
Ltmp33:
	fmov	s0, #1.00000000
	mov	x0, x19
	mov	x1, x21
	mov	w2, #1048576                    ; =0x100000
	blr	x24
Ltmp34:
; %bb.56:
Ltmp35:
	fmov	s0, #1.00000000
	mov	x0, x19
	mov	x1, x21
	mov	w2, #1048576                    ; =0x100000
	blr	x24
Ltmp36:
; %bb.57:
	mov	w25, #1000                      ; =0x3e8
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x23, x0
LBB0_58:                                ; =>This Inner Loop Header: Depth=1
Ltmp38:
	fmov	s0, #1.00000000
	mov	x0, x19
	mov	x1, x21
	mov	w2, #1048576                    ; =0x100000
	blr	x24
Ltmp39:
; %bb.59:                               ;   in Loop: Header=BB0_58 Depth=1
	; InlineAsm Start
	; InlineAsm End
	subs	w25, w25, #1
	b.ne	LBB0_58
; %bb.60:
	bl	__ZNSt3__16chrono12steady_clock3nowEv
	mov	x24, x0
	mov	x0, x21
	mov	x1, x22
	mov	w2, #1048576                    ; =0x100000
	bl	_memcmp
	cbnz	w0, LBB0_74
; %bb.61:
Ltmp46:
Lloh10:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh11:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh12:
	adrp	x1, l_.str.4@PAGE
Lloh13:
	add	x1, x1, l_.str.4@PAGEOFF
	mov	w2, #10                         ; =0xa
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp47:
; %bb.62:
	mov	x25, x0
	ldr	x20, [x20, #8]
	mov	x0, x20
	bl	_strlen
	mov	x2, x0
Ltmp48:
	mov	x0, x25
	mov	x1, x20
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp49:
; %bb.63:
Ltmp50:
Lloh14:
	adrp	x1, l_.str.5@PAGE
Lloh15:
	add	x1, x1, l_.str.5@PAGEOFF
	mov	w2, #10                         ; =0xa
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp51:
; %bb.64:
Ltmp52:
	mov	w1, #1048576                    ; =0x100000
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp53:
; %bb.65:
Ltmp54:
Lloh16:
	adrp	x1, l_.str.6@PAGE
Lloh17:
	add	x1, x1, l_.str.6@PAGEOFF
	mov	w2, #26                         ; =0x1a
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp55:
; %bb.66:
	sub	x8, x24, x23
	scvtf	d0, x8
	mov	x8, #145685290680320            ; =0x848000000000
	movk	x8, #16686, lsl #48
	fmov	d1, x8
	fdiv	d0, d0, d1
Ltmp57:
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEd
Ltmp58:
; %bb.67:
Ltmp59:
Lloh18:
	adrp	x1, l_.str.7@PAGE
Lloh19:
	add	x1, x1, l_.str.7@PAGEOFF
	mov	w2, #30                         ; =0x1e
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp60:
; %bb.68:
	mov	x0, x22
	bl	__ZdlPv
	mov	x0, x21
	bl	__ZdlPv
	mov	x0, x19
	bl	__ZdlPv
	mov	w0, #0                          ; =0x0
LBB0_69:
	ldp	x29, x30, [sp, #112]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #96]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #80]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #64]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #48]             ; 16-byte Folded Reload
	add	sp, sp, #128
	ret
LBB0_70:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x19, x0
Ltmp65:
Lloh20:
	adrp	x1, l_.str.2@PAGE
Lloh21:
	add	x1, x1, l_.str.2@PAGEOFF
	bl	__ZNSt11logic_errorC2EPKc
Ltmp66:
; %bb.71:
Lloh22:
	adrp	x8, __ZTVSt16invalid_argument@GOTPAGE
Lloh23:
	ldr	x8, [x8, __ZTVSt16invalid_argument@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x19]
Ltmp68:
Lloh24:
	adrp	x1, __ZTISt16invalid_argument@GOTPAGE
Lloh25:
	ldr	x1, [x1, __ZTISt16invalid_argument@GOTPAGEOFF]
Lloh26:
	adrp	x2, __ZNSt16invalid_argumentD1Ev@GOTPAGE
Lloh27:
	ldr	x2, [x2, __ZNSt16invalid_argumentD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
Ltmp69:
	b	LBB0_77
LBB0_72:
Ltmp71:
	bl	__ZNSt3__112basic_stringIcNS_11char_traitsIcEENS_9allocatorIcEEE20__throw_length_errorB9nqe210106Ev
Ltmp72:
	b	LBB0_77
LBB0_73:
Ltmp62:
	bl	__ZNSt3__112basic_stringIcNS_11char_traitsIcEENS_9allocatorIcEEE20__throw_length_errorB9nqe210106Ev
Ltmp63:
	b	LBB0_77
LBB0_74:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x24, x0
Ltmp41:
Lloh28:
	adrp	x1, l_.str.3@PAGE
Lloh29:
	add	x1, x1, l_.str.3@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp42:
; %bb.75:
Ltmp44:
Lloh30:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh31:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh32:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh33:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x24
	bl	___cxa_throw
Ltmp45:
	b	LBB0_77
LBB0_76:
Ltmp4:
	bl	__ZNSt3__112basic_stringIcNS_11char_traitsIcEENS_9allocatorIcEEE20__throw_length_errorB9nqe210106Ev
Ltmp5:
LBB0_77:
	brk	#0x1
LBB0_78:
Ltmp43:
	mov	x23, x1
	mov	x20, x0
	mov	x0, x24
	bl	___cxa_free_exception
	b	LBB0_95
LBB0_79:
Ltmp18:
	b	LBB0_94
LBB0_80:
Ltmp15:
	mov	x23, x1
	mov	x20, x0
	b	LBB0_96
LBB0_81:
Ltmp12:
	mov	x23, x1
	mov	x20, x0
	b	LBB0_97
LBB0_82:
Ltmp9:
	b	LBB0_89
LBB0_83:
Ltmp70:
	b	LBB0_89
LBB0_84:
Ltmp67:
	mov	x23, x1
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	b	LBB0_99
LBB0_85:
Ltmp6:
	mov	x23, x1
	mov	x20, x0
	tbz	w24, #31, LBB0_99
; %bb.86:
	ldr	x0, [sp, #24]
	b	LBB0_98
LBB0_87:
Ltmp64:
	b	LBB0_94
LBB0_88:
Ltmp73:
LBB0_89:
	mov	x23, x1
	mov	x20, x0
	b	LBB0_99
LBB0_90:
Ltmp61:
	b	LBB0_94
LBB0_91:
Ltmp56:
	b	LBB0_94
LBB0_92:
Ltmp37:
	b	LBB0_94
LBB0_93:
Ltmp40:
LBB0_94:
	mov	x23, x1
	mov	x20, x0
LBB0_95:
	mov	x0, x22
	bl	__ZdlPv
LBB0_96:
	mov	x0, x21
	bl	__ZdlPv
LBB0_97:
	mov	x0, x19
LBB0_98:
	bl	__ZdlPv
LBB0_99:
	cmp	w23, #1
	b.ne	LBB0_104
; %bb.100:
	mov	x0, x20
	bl	___cxa_begin_catch
	ldr	x8, [x0]
	ldr	x8, [x8, #16]
	blr	x8
	mov	x19, x0
	bl	_strlen
	mov	x2, x0
Ltmp74:
Lloh34:
	adrp	x0, __ZNSt3__14cerrE@GOTPAGE
Lloh35:
	ldr	x0, [x0, __ZNSt3__14cerrE@GOTPAGEOFF]
	mov	x1, x19
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp75:
; %bb.101:
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #24]
Ltmp76:
	add	x1, sp, #24
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp77:
; %bb.102:
	bl	___cxa_end_catch
	mov	w0, #1                          ; =0x1
	b	LBB0_69
LBB0_103:
Ltmp78:
	mov	x20, x0
Ltmp79:
	bl	___cxa_end_catch
Ltmp80:
LBB0_104:
	mov	x0, x20
	bl	__Unwind_Resume
LBB0_105:
Ltmp81:
	bl	___clang_call_terminate
	.loh AdrpLdr	Lloh0, Lloh1
	.loh AdrpLdrGot	Lloh2, Lloh3
	.loh AdrpLdrGot	Lloh4, Lloh5
	.loh AdrpLdrGot	Lloh6, Lloh7
	.loh AdrpLdrGot	Lloh8, Lloh9
	.loh AdrpAdd	Lloh12, Lloh13
	.loh AdrpLdrGot	Lloh10, Lloh11
	.loh AdrpAdd	Lloh14, Lloh15
	.loh AdrpAdd	Lloh16, Lloh17
	.loh AdrpAdd	Lloh18, Lloh19
	.loh AdrpAdd	Lloh20, Lloh21
	.loh AdrpLdrGot	Lloh26, Lloh27
	.loh AdrpLdrGot	Lloh24, Lloh25
	.loh AdrpLdrGot	Lloh22, Lloh23
	.loh AdrpAdd	Lloh28, Lloh29
	.loh AdrpLdrGot	Lloh32, Lloh33
	.loh AdrpLdrGot	Lloh30, Lloh31
	.loh AdrpLdrGot	Lloh34, Lloh35
Lfunc_end0:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table0:
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
	.uleb128 Ltmp73-Lfunc_begin0            ;     jumps to Ltmp73
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp1-Lfunc_begin0             ; >> Call Site 2 <<
	.uleb128 Ltmp2-Ltmp1                    ;   Call between Ltmp1 and Ltmp2
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp2-Lfunc_begin0             ; >> Call Site 3 <<
	.uleb128 Ltmp3-Ltmp2                    ;   Call between Ltmp2 and Ltmp3
	.uleb128 Ltmp6-Lfunc_begin0             ;     jumps to Ltmp6
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp3-Lfunc_begin0             ; >> Call Site 4 <<
	.uleb128 Ltmp7-Ltmp3                    ;   Call between Ltmp3 and Ltmp7
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp7-Lfunc_begin0             ; >> Call Site 5 <<
	.uleb128 Ltmp8-Ltmp7                    ;   Call between Ltmp7 and Ltmp8
	.uleb128 Ltmp9-Lfunc_begin0             ;     jumps to Ltmp9
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp8-Lfunc_begin0             ; >> Call Site 6 <<
	.uleb128 Ltmp10-Ltmp8                   ;   Call between Ltmp8 and Ltmp10
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp10-Lfunc_begin0            ; >> Call Site 7 <<
	.uleb128 Ltmp11-Ltmp10                  ;   Call between Ltmp10 and Ltmp11
	.uleb128 Ltmp12-Lfunc_begin0            ;     jumps to Ltmp12
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp11-Lfunc_begin0            ; >> Call Site 8 <<
	.uleb128 Ltmp13-Ltmp11                  ;   Call between Ltmp11 and Ltmp13
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp13-Lfunc_begin0            ; >> Call Site 9 <<
	.uleb128 Ltmp14-Ltmp13                  ;   Call between Ltmp13 and Ltmp14
	.uleb128 Ltmp15-Lfunc_begin0            ;     jumps to Ltmp15
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp14-Lfunc_begin0            ; >> Call Site 10 <<
	.uleb128 Ltmp16-Ltmp14                  ;   Call between Ltmp14 and Ltmp16
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp16-Lfunc_begin0            ; >> Call Site 11 <<
	.uleb128 Ltmp17-Ltmp16                  ;   Call between Ltmp16 and Ltmp17
	.uleb128 Ltmp18-Lfunc_begin0            ;     jumps to Ltmp18
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp19-Lfunc_begin0            ; >> Call Site 12 <<
	.uleb128 Ltmp20-Ltmp19                  ;   Call between Ltmp19 and Ltmp20
	.uleb128 Ltmp64-Lfunc_begin0            ;     jumps to Ltmp64
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp20-Lfunc_begin0            ; >> Call Site 13 <<
	.uleb128 Ltmp21-Ltmp20                  ;   Call between Ltmp20 and Ltmp21
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp21-Lfunc_begin0            ; >> Call Site 14 <<
	.uleb128 Ltmp36-Ltmp21                  ;   Call between Ltmp21 and Ltmp36
	.uleb128 Ltmp37-Lfunc_begin0            ;     jumps to Ltmp37
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp38-Lfunc_begin0            ; >> Call Site 15 <<
	.uleb128 Ltmp39-Ltmp38                  ;   Call between Ltmp38 and Ltmp39
	.uleb128 Ltmp40-Lfunc_begin0            ;     jumps to Ltmp40
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp46-Lfunc_begin0            ; >> Call Site 16 <<
	.uleb128 Ltmp55-Ltmp46                  ;   Call between Ltmp46 and Ltmp55
	.uleb128 Ltmp56-Lfunc_begin0            ;     jumps to Ltmp56
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp57-Lfunc_begin0            ; >> Call Site 17 <<
	.uleb128 Ltmp60-Ltmp57                  ;   Call between Ltmp57 and Ltmp60
	.uleb128 Ltmp61-Lfunc_begin0            ;     jumps to Ltmp61
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp60-Lfunc_begin0            ; >> Call Site 18 <<
	.uleb128 Ltmp65-Ltmp60                  ;   Call between Ltmp60 and Ltmp65
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp65-Lfunc_begin0            ; >> Call Site 19 <<
	.uleb128 Ltmp66-Ltmp65                  ;   Call between Ltmp65 and Ltmp66
	.uleb128 Ltmp67-Lfunc_begin0            ;     jumps to Ltmp67
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp68-Lfunc_begin0            ; >> Call Site 20 <<
	.uleb128 Ltmp69-Ltmp68                  ;   Call between Ltmp68 and Ltmp69
	.uleb128 Ltmp70-Lfunc_begin0            ;     jumps to Ltmp70
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp71-Lfunc_begin0            ; >> Call Site 21 <<
	.uleb128 Ltmp72-Ltmp71                  ;   Call between Ltmp71 and Ltmp72
	.uleb128 Ltmp73-Lfunc_begin0            ;     jumps to Ltmp73
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp62-Lfunc_begin0            ; >> Call Site 22 <<
	.uleb128 Ltmp63-Ltmp62                  ;   Call between Ltmp62 and Ltmp63
	.uleb128 Ltmp64-Lfunc_begin0            ;     jumps to Ltmp64
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp63-Lfunc_begin0            ; >> Call Site 23 <<
	.uleb128 Ltmp41-Ltmp63                  ;   Call between Ltmp63 and Ltmp41
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp41-Lfunc_begin0            ; >> Call Site 24 <<
	.uleb128 Ltmp42-Ltmp41                  ;   Call between Ltmp41 and Ltmp42
	.uleb128 Ltmp43-Lfunc_begin0            ;     jumps to Ltmp43
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp44-Lfunc_begin0            ; >> Call Site 25 <<
	.uleb128 Ltmp45-Ltmp44                  ;   Call between Ltmp44 and Ltmp45
	.uleb128 Ltmp56-Lfunc_begin0            ;     jumps to Ltmp56
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp4-Lfunc_begin0             ; >> Call Site 26 <<
	.uleb128 Ltmp5-Ltmp4                    ;   Call between Ltmp4 and Ltmp5
	.uleb128 Ltmp6-Lfunc_begin0             ;     jumps to Ltmp6
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp5-Lfunc_begin0             ; >> Call Site 27 <<
	.uleb128 Ltmp74-Ltmp5                   ;   Call between Ltmp5 and Ltmp74
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp74-Lfunc_begin0            ; >> Call Site 28 <<
	.uleb128 Ltmp77-Ltmp74                  ;   Call between Ltmp74 and Ltmp77
	.uleb128 Ltmp78-Lfunc_begin0            ;     jumps to Ltmp78
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp77-Lfunc_begin0            ; >> Call Site 29 <<
	.uleb128 Ltmp79-Ltmp77                  ;   Call between Ltmp77 and Ltmp79
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp79-Lfunc_begin0            ; >> Call Site 30 <<
	.uleb128 Ltmp80-Ltmp79                  ;   Call between Ltmp79 and Ltmp80
	.uleb128 Ltmp81-Lfunc_begin0            ;     jumps to Ltmp81
	.byte	9                               ;   On action: 5
	.uleb128 Ltmp80-Lfunc_begin0            ; >> Call Site 31 <<
	.uleb128 Lfunc_end0-Ltmp80              ;   Call between Ltmp80 and Lfunc_end0
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
	.byte	1                               ; >> Action Record 4 <<
                                        ;   Catch TypeInfo 1
	.byte	0                               ;   No further actions
	.byte	2                               ; >> Action Record 5 <<
                                        ;   Catch TypeInfo 2
	.byte	0                               ;   No further actions
	.p2align	2, 0x0
                                        ; >> Catch TypeInfos <<
	.long	0                               ; TypeInfo 2
Ltmp110:                                ; TypeInfo 1
	.long	__ZTISt9exception@GOT-Ltmp110
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
	cbz	x2, LBB1_3
; %bb.1:
	movi.2d	v1, #0000000000000000
	mov	w8, #1123942400                 ; =0x42fe0000
	fmov	s2, w8
	mov	w8, #-1023541248                ; =0xc2fe0000
	fmov	s3, w8
LBB1_2:                                 ; =>This Inner Loop Header: Depth=1
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
	b.ne	LBB1_2
LBB1_3:
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
	b.lo	LBB2_4
; %bb.1:
	mov	x8, #0                          ; =0x0
	add	x9, x0, #16
	mov	w10, #1123942400                ; =0x42fe0000
	dup.4s	v1, w10
	mov	w10, #-1023541248               ; =0xc2fe0000
	dup.4s	v2, w10
	mov	x10, x2
LBB2_2:                                 ; =>This Inner Loop Header: Depth=1
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
	b.hi	LBB2_2
; %bb.3:
	subs	x9, x2, x8
	b.hi	LBB2_5
	b	LBB2_11
LBB2_4:
	mov	x8, #0                          ; =0x0
	subs	x9, x2, x8
	b.ls	LBB2_11
LBB2_5:
	cmp	x9, #3
	b.ls	LBB2_8
; %bb.6:
	add	x11, x0, x8, lsl #2
	add	x10, x0, x2, lsl #2
	add	x12, x1, x8
	cmp	x12, x10
	b.hs	LBB2_12
; %bb.7:
	add	x10, x1, x2
	cmp	x11, x10
	b.hs	LBB2_12
LBB2_8:
	mov	x11, x8
LBB2_9:
	sub	x8, x2, x11
	add	x9, x1, x11
	add	x10, x0, x11, lsl #2
	movi.2d	v1, #0000000000000000
	mov	w11, #1123942400                ; =0x42fe0000
	fmov	s2, w11
	mov	w11, #-1023541248               ; =0xc2fe0000
	fmov	s3, w11
LBB2_10:                                ; =>This Inner Loop Header: Depth=1
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
	b.ne	LBB2_10
LBB2_11:
	ret
LBB2_12:
	cmp	x9, #16
	b.hs	LBB2_14
; %bb.13:
	mov	x10, #0                         ; =0x0
	b	LBB2_18
LBB2_14:
	and	x10, x9, #0xfffffffffffffff0
	add	x11, x11, #32
	add	x12, x8, x1
	add	x12, x12, #8
	mov	w13, #-1023541248               ; =0xc2fe0000
	dup.4s	v1, w13
	mov	w13, #1123942400                ; =0x42fe0000
	dup.4s	v2, w13
	mov	x13, x10
LBB2_15:                                ; =>This Inner Loop Header: Depth=1
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
	b.ne	LBB2_15
; %bb.16:
	cmp	x9, x10
	b.eq	LBB2_11
; %bb.17:
	tst	x9, #0xc
	b.eq	LBB2_21
LBB2_18:
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
LBB2_19:                                ; =>This Inner Loop Header: Depth=1
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
	b.ne	LBB2_19
; %bb.20:
	cmp	x9, x12
	b.ne	LBB2_9
	b	LBB2_11
LBB2_21:
	add	x11, x8, x10
	b	LBB2_9
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
Lloh36:
	adrp	x0, l_.str.8@PAGE
Lloh37:
	add	x0, x0, l_.str.8@PAGEOFF
	bl	__ZNSt3__120__throw_length_errorB9nqe210106EPKc
	.loh AdrpAdd	Lloh36, Lloh37
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
Ltmp82:
	mov	x1, x20
	bl	__ZNSt12length_errorC1B9nqe210106EPKc
Ltmp83:
; %bb.1:
Lloh38:
	adrp	x1, __ZTISt12length_error@GOTPAGE
Lloh39:
	ldr	x1, [x1, __ZTISt12length_error@GOTPAGEOFF]
Lloh40:
	adrp	x2, __ZNSt12length_errorD1Ev@GOTPAGE
Lloh41:
	ldr	x2, [x2, __ZNSt12length_errorD1Ev@GOTPAGEOFF]
	mov	x0, x19
	bl	___cxa_throw
LBB5_2:
Ltmp84:
	mov	x20, x0
	mov	x0, x19
	bl	___cxa_free_exception
	mov	x0, x20
	bl	__Unwind_Resume
	.loh AdrpLdrGot	Lloh40, Lloh41
	.loh AdrpLdrGot	Lloh38, Lloh39
Lfunc_end1:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table5:
Lexception1:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end1-Lcst_begin1
Lcst_begin1:
	.uleb128 Lfunc_begin1-Lfunc_begin1      ; >> Call Site 1 <<
	.uleb128 Ltmp82-Lfunc_begin1            ;   Call between Lfunc_begin1 and Ltmp82
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp82-Lfunc_begin1            ; >> Call Site 2 <<
	.uleb128 Ltmp83-Ltmp82                  ;   Call between Ltmp82 and Ltmp83
	.uleb128 Ltmp84-Lfunc_begin1            ;     jumps to Ltmp84
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp83-Lfunc_begin1            ; >> Call Site 3 <<
	.uleb128 Lfunc_end1-Ltmp83              ;   Call between Ltmp83 and Lfunc_end1
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
Lloh42:
	adrp	x8, __ZTVSt12length_error@GOTPAGE
Lloh43:
	ldr	x8, [x8, __ZTVSt12length_error@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x0]
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
	.loh AdrpLdrGot	Lloh42, Lloh43
	.cfi_endproc
                                        ; -- End function
	.private_extern	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m ; -- Begin function _ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
	.globl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
	.weak_def_can_be_hidden	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
	.p2align	2
__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m: ; @_ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Lfunc_begin2:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception2
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
Ltmp85:
	add	x0, sp, #8
	mov	x1, x19
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryC1ERS3_
Ltmp86:
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
Ltmp88:
	add	x8, sp, #24
	mov	x25, x4
	mov	x0, x4
	bl	__ZNKSt3__18ios_base6getlocEv
Ltmp89:
; %bb.4:
Ltmp90:
Lloh44:
	adrp	x1, __ZNSt3__15ctypeIcE2idE@GOTPAGE
Lloh45:
	ldr	x1, [x1, __ZNSt3__15ctypeIcE2idE@GOTPAGEOFF]
	add	x0, sp, #24
	bl	__ZNKSt3__16locale9use_facetERNS0_2idE
Ltmp91:
; %bb.5:
	ldr	x8, [x0]
	ldr	x8, [x8, #56]
Ltmp92:
	mov	w1, #32                         ; =0x20
	blr	x8
Ltmp93:
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
Ltmp95:
	sxtb	w5, w23
	mov	x0, x22
	mov	x1, x20
	bl	__ZNSt3__116__pad_and_outputB9nqe210106IcNS_11char_traitsIcEEEENS_19ostreambuf_iteratorIT_T0_EES6_PKS4_S8_S8_RNS_8ios_baseES4_
Ltmp96:
; %bb.8:
	cbnz	x0, LBB7_10
; %bb.9:
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
	add	x0, x19, x8
	ldr	w8, [x0, #32]
	mov	w9, #5                          ; =0x5
Ltmp98:
	orr	w1, w8, w9
	bl	__ZNSt3__18ios_base5clearEj
Ltmp99:
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
Ltmp100:
	b	LBB7_15
LBB7_13:
Ltmp94:
	mov	x20, x0
	add	x0, sp, #24
	bl	__ZNSt3__16localeD1Ev
	b	LBB7_16
LBB7_14:
Ltmp97:
LBB7_15:
	mov	x20, x0
LBB7_16:
	add	x0, sp, #8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryD1Ev
	b	LBB7_18
LBB7_17:
Ltmp87:
	mov	x20, x0
LBB7_18:
	mov	x0, x20
	bl	___cxa_begin_catch
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
Ltmp101:
	add	x0, x19, x8
	bl	__ZNSt3__18ios_base33__set_badbit_and_consider_rethrowEv
Ltmp102:
; %bb.19:
	bl	___cxa_end_catch
	b	LBB7_11
LBB7_20:
Ltmp103:
	mov	x19, x0
Ltmp104:
	bl	___cxa_end_catch
Ltmp105:
; %bb.21:
	mov	x0, x19
	bl	__Unwind_Resume
LBB7_22:
Ltmp106:
	bl	___clang_call_terminate
	.loh AdrpLdrGot	Lloh44, Lloh45
Lfunc_end2:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table7:
Lexception2:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	155                             ; @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase1-Lttbaseref1
Lttbaseref1:
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end2-Lcst_begin2
Lcst_begin2:
	.uleb128 Ltmp85-Lfunc_begin2            ; >> Call Site 1 <<
	.uleb128 Ltmp86-Ltmp85                  ;   Call between Ltmp85 and Ltmp86
	.uleb128 Ltmp87-Lfunc_begin2            ;     jumps to Ltmp87
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp88-Lfunc_begin2            ; >> Call Site 2 <<
	.uleb128 Ltmp89-Ltmp88                  ;   Call between Ltmp88 and Ltmp89
	.uleb128 Ltmp97-Lfunc_begin2            ;     jumps to Ltmp97
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp90-Lfunc_begin2            ; >> Call Site 3 <<
	.uleb128 Ltmp93-Ltmp90                  ;   Call between Ltmp90 and Ltmp93
	.uleb128 Ltmp94-Lfunc_begin2            ;     jumps to Ltmp94
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp95-Lfunc_begin2            ; >> Call Site 4 <<
	.uleb128 Ltmp96-Ltmp95                  ;   Call between Ltmp95 and Ltmp96
	.uleb128 Ltmp97-Lfunc_begin2            ;     jumps to Ltmp97
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp98-Lfunc_begin2            ; >> Call Site 5 <<
	.uleb128 Ltmp99-Ltmp98                  ;   Call between Ltmp98 and Ltmp99
	.uleb128 Ltmp100-Lfunc_begin2           ;     jumps to Ltmp100
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp99-Lfunc_begin2            ; >> Call Site 6 <<
	.uleb128 Ltmp101-Ltmp99                 ;   Call between Ltmp99 and Ltmp101
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp101-Lfunc_begin2           ; >> Call Site 7 <<
	.uleb128 Ltmp102-Ltmp101                ;   Call between Ltmp101 and Ltmp102
	.uleb128 Ltmp103-Lfunc_begin2           ;     jumps to Ltmp103
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp102-Lfunc_begin2           ; >> Call Site 8 <<
	.uleb128 Ltmp104-Ltmp102                ;   Call between Ltmp102 and Ltmp104
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp104-Lfunc_begin2           ; >> Call Site 9 <<
	.uleb128 Ltmp105-Ltmp104                ;   Call between Ltmp104 and Ltmp105
	.uleb128 Ltmp106-Lfunc_begin2           ;     jumps to Ltmp106
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp105-Lfunc_begin2           ; >> Call Site 10 <<
	.uleb128 Lfunc_end2-Ltmp105             ;   Call between Ltmp105 and Lfunc_end2
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
	.private_extern	__ZNSt3__116__pad_and_outputB9nqe210106IcNS_11char_traitsIcEEEENS_19ostreambuf_iteratorIT_T0_EES6_PKS4_S8_S8_RNS_8ios_baseES4_ ; -- Begin function _ZNSt3__116__pad_and_outputB9nqe210106IcNS_11char_traitsIcEEEENS_19ostreambuf_iteratorIT_T0_EES6_PKS4_S8_S8_RNS_8ios_baseES4_
	.globl	__ZNSt3__116__pad_and_outputB9nqe210106IcNS_11char_traitsIcEEEENS_19ostreambuf_iteratorIT_T0_EES6_PKS4_S8_S8_RNS_8ios_baseES4_
	.weak_def_can_be_hidden	__ZNSt3__116__pad_and_outputB9nqe210106IcNS_11char_traitsIcEEEENS_19ostreambuf_iteratorIT_T0_EES6_PKS4_S8_S8_RNS_8ios_baseES4_
	.p2align	2
__ZNSt3__116__pad_and_outputB9nqe210106IcNS_11char_traitsIcEEEENS_19ostreambuf_iteratorIT_T0_EES6_PKS4_S8_S8_RNS_8ios_baseES4_: ; @_ZNSt3__116__pad_and_outputB9nqe210106IcNS_11char_traitsIcEEEENS_19ostreambuf_iteratorIT_T0_EES6_PKS4_S8_S8_RNS_8ios_baseES4_
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
Ltmp107:
	mov	x0, x19
	mov	x2, x24
	blr	x8
Ltmp108:
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
	cmp	x23, x24
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
Ltmp109:
	mov	x19, x0
	ldrsb	w8, [sp, #31]
	tbz	w8, #31, LBB8_20
; %bb.19:
	ldr	x0, [sp, #8]
	bl	__ZdlPv
LBB8_20:
	mov	x0, x19
	bl	__Unwind_Resume
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
	.uleb128 Ltmp107-Lfunc_begin3           ;   Call between Lfunc_begin3 and Ltmp107
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp107-Lfunc_begin3           ; >> Call Site 2 <<
	.uleb128 Ltmp108-Ltmp107                ;   Call between Ltmp107 and Ltmp108
	.uleb128 Ltmp109-Lfunc_begin3           ;     jumps to Ltmp109
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp108-Lfunc_begin3           ; >> Call Site 3 <<
	.uleb128 Lfunc_end3-Ltmp108             ;   Call between Ltmp108 and Lfunc_end3
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end3:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"scalar"

l_.str.1:                               ; @.str.1
	.asciz	"neon"

l_.str.2:                               ; @.str.2
	.asciz	"usage: probe scalar|neon"

l_.str.3:                               ; @.str.3
	.asciz	"mismatch"

l_.str.4:                               ; @.str.4
	.asciz	"PASS mode="

l_.str.5:                               ; @.str.5
	.asciz	" elements="

l_.str.6:                               ; @.str.6
	.asciz	" repeats=1000 hot_loop_ms="

l_.str.7:                               ; @.str.7
	.asciz	" PMU=not_collected_by_program\n"

l_.str.8:                               ; @.str.8
	.asciz	"basic_string"

.subsections_via_symbols
