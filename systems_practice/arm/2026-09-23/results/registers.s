	.build_version macos, 26, 0	sdk_version 26, 5
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_write_w                        ; -- Begin function write_w
	.p2align	2
_write_w:                               ; @write_w
	.cfi_startproc
; %bb.0:
	; InlineAsm Start
	mov	w0, w0
	; InlineAsm End
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_add_lanes                      ; -- Begin function add_lanes
	.p2align	2
_add_lanes:                             ; @add_lanes
	.cfi_startproc
; %bb.0:
	ldr	q0, [x0]
	ldr	q1, [x1]
	add.4s	v0, v1, v0
	str	q0, [x2]
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
	mov	x0, #0                          ; =0x0
	bl	_write_w
	cbnz	x0, LBB2_47
; %bb.1:
Ltmp0:
Lloh0:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh1:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh2:
	adrp	x1, l_.str.1@PAGE
Lloh3:
	add	x1, x1, l_.str.1@PAGEOFF
	mov	w2, #8                          ; =0x8
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp1:
; %bb.2:
	ldr	x8, [x0]
	ldur	x8, [x8, #-24]
	add	x8, x0, x8
	ldr	w9, [x8, #8]
	mov	w10, #-75                       ; =0xffffffb5
	and	w9, w9, w10
	orr	w9, w9, #0x8
	str	w9, [x8, #8]
Ltmp2:
	mov	x1, #0                          ; =0x0
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEy
Ltmp3:
; %bb.3:
Ltmp4:
Lloh4:
	adrp	x1, l_.str.2@PAGE
Lloh5:
	add	x1, x1, l_.str.2@PAGEOFF
	mov	w2, #18                         ; =0x12
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp5:
; %bb.4:
Ltmp6:
	mov	x1, #0                          ; =0x0
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEy
Ltmp7:
; %bb.5:
	ldr	x8, [x0]
	ldur	x8, [x8, #-24]
	add	x8, x0, x8
	ldr	w9, [x8, #8]
	mov	w10, #-75                       ; =0xffffffb5
	and	w9, w9, w10
	orr	w9, w9, #0x2
	str	w9, [x8, #8]
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #31]
Ltmp8:
	add	x1, sp, #31
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp9:
; %bb.6:
	mov	x0, #22136                      ; =0x5678
	movk	x0, #4660, lsl #16
	movk	x0, #65535, lsl #48
	bl	_write_w
	mov	w8, #22136                      ; =0x5678
	movk	w8, #4660, lsl #16
	cmp	x0, x8
	b.ne	LBB2_47
; %bb.7:
Ltmp10:
Lloh6:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh7:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh8:
	adrp	x1, l_.str.1@PAGE
Lloh9:
	add	x1, x1, l_.str.1@PAGEOFF
	mov	w2, #8                          ; =0x8
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp11:
; %bb.8:
	ldr	x8, [x0]
	ldur	x8, [x8, #-24]
	add	x8, x0, x8
	ldr	w9, [x8, #8]
	mov	w10, #-75                       ; =0xffffffb5
	and	w9, w9, w10
	orr	w9, w9, #0x8
	str	w9, [x8, #8]
Ltmp12:
	mov	x1, #22136                      ; =0x5678
	movk	x1, #4660, lsl #16
	movk	x1, #65535, lsl #48
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEy
Ltmp13:
; %bb.9:
Ltmp14:
Lloh10:
	adrp	x1, l_.str.2@PAGE
Lloh11:
	add	x1, x1, l_.str.2@PAGEOFF
	mov	w2, #18                         ; =0x12
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp15:
; %bb.10:
Ltmp16:
	mov	w1, #22136                      ; =0x5678
	movk	w1, #4660, lsl #16
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEy
Ltmp17:
; %bb.11:
	ldr	x8, [x0]
	ldur	x8, [x8, #-24]
	add	x8, x0, x8
	ldr	w9, [x8, #8]
	mov	w10, #-75                       ; =0xffffffb5
	and	w9, w9, w10
	orr	w9, w9, #0x2
	str	w9, [x8, #8]
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #31]
Ltmp18:
	add	x1, sp, #31
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp19:
; %bb.12:
	mov	x0, #-1                         ; =0xffffffffffffffff
	bl	_write_w
	mov	w8, #-1                         ; =0xffffffff
	cmp	x0, x8
	b.ne	LBB2_47
; %bb.13:
Ltmp26:
Lloh12:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh13:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh14:
	adrp	x1, l_.str.1@PAGE
Lloh15:
	add	x1, x1, l_.str.1@PAGEOFF
	mov	w2, #8                          ; =0x8
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp27:
; %bb.14:
	ldr	x8, [x0]
	ldur	x8, [x8, #-24]
	add	x8, x0, x8
	ldr	w9, [x8, #8]
	mov	w10, #-75                       ; =0xffffffb5
	and	w9, w9, w10
	orr	w9, w9, #0x8
	str	w9, [x8, #8]
Ltmp28:
	mov	x1, #-1                         ; =0xffffffffffffffff
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEy
Ltmp29:
; %bb.15:
Ltmp30:
Lloh16:
	adrp	x1, l_.str.2@PAGE
Lloh17:
	add	x1, x1, l_.str.2@PAGEOFF
	mov	w2, #18                         ; =0x12
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp31:
; %bb.16:
Ltmp32:
	mov	w1, #-1                         ; =0xffffffff
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEy
Ltmp33:
; %bb.17:
	ldr	x8, [x0]
	ldur	x8, [x8, #-24]
	add	x8, x0, x8
	ldr	w9, [x8, #8]
	mov	w10, #-75                       ; =0xffffffb5
	and	w9, w9, w10
	orr	w9, w9, #0x2
	str	w9, [x8, #8]
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #31]
Ltmp34:
	add	x1, sp, #31
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp35:
; %bb.18:
Lloh18:
	adrp	x0, l___const.main.x@PAGE
Lloh19:
	add	x0, x0, l___const.main.x@PAGEOFF
Lloh20:
	adrp	x1, l___const.main.y@PAGE
Lloh21:
	add	x1, x1, l___const.main.y@PAGEOFF
	add	x2, sp, #12
	bl	_add_lanes
	ldr	w8, [sp, #12]
	cmp	w8, #11
	b.ne	LBB2_45
; %bb.19:
Ltmp37:
Lloh22:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh23:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh24:
	adrp	x1, l_.str.4@PAGE
Lloh25:
	add	x1, x1, l_.str.4@PAGEOFF
	mov	w2, #4                          ; =0x4
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp38:
; %bb.20:
Ltmp39:
	mov	x1, #0                          ; =0x0
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp40:
; %bb.21:
	mov	w8, #61                         ; =0x3d
	strb	w8, [sp, #31]
Ltmp41:
	add	x1, sp, #31
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp42:
; %bb.22:
Ltmp43:
	mov	w1, #11                         ; =0xb
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEj
Ltmp44:
; %bb.23:
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #31]
Ltmp45:
	add	x1, sp, #31
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp46:
; %bb.24:
	ldr	w8, [sp, #16]
	cmp	w8, #22
	b.ne	LBB2_45
; %bb.25:
Ltmp47:
Lloh26:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh27:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh28:
	adrp	x1, l_.str.4@PAGE
Lloh29:
	add	x1, x1, l_.str.4@PAGEOFF
	mov	w2, #4                          ; =0x4
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp48:
; %bb.26:
Ltmp49:
	mov	w1, #1                          ; =0x1
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp50:
; %bb.27:
	mov	w8, #61                         ; =0x3d
	strb	w8, [sp, #31]
Ltmp51:
	add	x1, sp, #31
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp52:
; %bb.28:
Ltmp53:
	mov	w1, #22                         ; =0x16
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEj
Ltmp54:
; %bb.29:
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #31]
Ltmp55:
	add	x1, sp, #31
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp56:
; %bb.30:
	ldr	w8, [sp, #20]
	cmp	w8, #33
	b.ne	LBB2_45
; %bb.31:
Ltmp57:
Lloh30:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh31:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh32:
	adrp	x1, l_.str.4@PAGE
Lloh33:
	add	x1, x1, l_.str.4@PAGEOFF
	mov	w2, #4                          ; =0x4
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp58:
; %bb.32:
Ltmp59:
	mov	w1, #2                          ; =0x2
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp60:
; %bb.33:
	mov	w8, #61                         ; =0x3d
	strb	w8, [sp, #31]
Ltmp61:
	add	x1, sp, #31
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp62:
; %bb.34:
Ltmp63:
	mov	w1, #33                         ; =0x21
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEj
Ltmp64:
; %bb.35:
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #31]
Ltmp65:
	add	x1, sp, #31
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp66:
; %bb.36:
	ldr	w8, [sp, #24]
	cbnz	w8, LBB2_45
; %bb.37:
Ltmp73:
Lloh34:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh35:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh36:
	adrp	x1, l_.str.4@PAGE
Lloh37:
	add	x1, x1, l_.str.4@PAGEOFF
	mov	w2, #4                          ; =0x4
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp74:
; %bb.38:
Ltmp75:
	mov	w1, #3                          ; =0x3
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEm
Ltmp76:
; %bb.39:
	mov	w8, #61                         ; =0x3d
	strb	w8, [sp, #31]
Ltmp77:
	add	x1, sp, #31
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp78:
; %bb.40:
Ltmp79:
	mov	w1, #0                          ; =0x0
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEElsEj
Ltmp80:
; %bb.41:
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #31]
Ltmp81:
	add	x1, sp, #31
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp82:
; %bb.42:
Ltmp84:
Lloh38:
	adrp	x0, __ZNSt3__14coutE@GOTPAGE
Lloh39:
	ldr	x0, [x0, __ZNSt3__14coutE@GOTPAGEOFF]
Lloh40:
	adrp	x1, l_.str.5@PAGE
Lloh41:
	add	x1, x1, l_.str.5@PAGEOFF
	mov	w2, #51                         ; =0x33
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp85:
; %bb.43:
	mov	w0, #0                          ; =0x0
LBB2_44:
	ldp	x29, x30, [sp, #64]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #48]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #80
	ret
LBB2_45:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x21, x0
Ltmp67:
Lloh42:
	adrp	x1, l_.str.3@PAGE
Lloh43:
	add	x1, x1, l_.str.3@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp68:
; %bb.46:
Ltmp70:
Lloh44:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh45:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh46:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh47:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x21
	bl	___cxa_throw
Ltmp71:
	b	LBB2_49
LBB2_47:
	mov	w0, #16                         ; =0x10
	bl	___cxa_allocate_exception
	mov	x21, x0
Ltmp20:
Lloh48:
	adrp	x1, l_.str@PAGE
Lloh49:
	add	x1, x1, l_.str@PAGEOFF
	bl	__ZNSt13runtime_errorC1EPKc
Ltmp21:
; %bb.48:
Ltmp23:
Lloh50:
	adrp	x1, __ZTISt13runtime_error@GOTPAGE
Lloh51:
	ldr	x1, [x1, __ZTISt13runtime_error@GOTPAGEOFF]
Lloh52:
	adrp	x2, __ZNSt13runtime_errorD1Ev@GOTPAGE
Lloh53:
	ldr	x2, [x2, __ZNSt13runtime_errorD1Ev@GOTPAGEOFF]
	mov	x0, x21
	bl	___cxa_throw
Ltmp24:
LBB2_49:
	brk	#0x1
LBB2_50:
Ltmp86:
	b	LBB2_58
LBB2_51:
Ltmp25:
	b	LBB2_58
LBB2_52:
Ltmp22:
	b	LBB2_55
LBB2_53:
Ltmp72:
	b	LBB2_58
LBB2_54:
Ltmp69:
LBB2_55:
	mov	x20, x1
	mov	x19, x0
	mov	x0, x21
	bl	___cxa_free_exception
	b	LBB2_59
LBB2_56:
Ltmp36:
	b	LBB2_58
LBB2_57:
Ltmp83:
LBB2_58:
	mov	x20, x1
	mov	x19, x0
LBB2_59:
	cmp	w20, #1
	b.ne	LBB2_64
; %bb.60:
	mov	x0, x19
	bl	___cxa_begin_catch
	ldr	x8, [x0]
	ldr	x8, [x8, #16]
	blr	x8
	mov	x19, x0
	bl	_strlen
	mov	x2, x0
Ltmp87:
Lloh54:
	adrp	x0, __ZNSt3__14cerrE@GOTPAGE
Lloh55:
	ldr	x0, [x0, __ZNSt3__14cerrE@GOTPAGEOFF]
	mov	x1, x19
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp88:
; %bb.61:
	mov	w8, #10                         ; =0xa
	strb	w8, [sp, #12]
Ltmp89:
	add	x1, sp, #12
	mov	w2, #1                          ; =0x1
	bl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Ltmp90:
; %bb.62:
	bl	___cxa_end_catch
	mov	w0, #1                          ; =0x1
	b	LBB2_44
LBB2_63:
Ltmp91:
	mov	x19, x0
Ltmp92:
	bl	___cxa_end_catch
Ltmp93:
LBB2_64:
	mov	x0, x19
	bl	__Unwind_Resume
LBB2_65:
Ltmp94:
	bl	___clang_call_terminate
	.loh AdrpAdd	Lloh2, Lloh3
	.loh AdrpLdrGot	Lloh0, Lloh1
	.loh AdrpAdd	Lloh4, Lloh5
	.loh AdrpAdd	Lloh8, Lloh9
	.loh AdrpLdrGot	Lloh6, Lloh7
	.loh AdrpAdd	Lloh10, Lloh11
	.loh AdrpAdd	Lloh14, Lloh15
	.loh AdrpLdrGot	Lloh12, Lloh13
	.loh AdrpAdd	Lloh16, Lloh17
	.loh AdrpAdd	Lloh20, Lloh21
	.loh AdrpAdd	Lloh18, Lloh19
	.loh AdrpAdd	Lloh24, Lloh25
	.loh AdrpLdrGot	Lloh22, Lloh23
	.loh AdrpAdd	Lloh28, Lloh29
	.loh AdrpLdrGot	Lloh26, Lloh27
	.loh AdrpAdd	Lloh32, Lloh33
	.loh AdrpLdrGot	Lloh30, Lloh31
	.loh AdrpAdd	Lloh36, Lloh37
	.loh AdrpLdrGot	Lloh34, Lloh35
	.loh AdrpAdd	Lloh40, Lloh41
	.loh AdrpLdrGot	Lloh38, Lloh39
	.loh AdrpAdd	Lloh42, Lloh43
	.loh AdrpLdrGot	Lloh46, Lloh47
	.loh AdrpLdrGot	Lloh44, Lloh45
	.loh AdrpAdd	Lloh48, Lloh49
	.loh AdrpLdrGot	Lloh52, Lloh53
	.loh AdrpLdrGot	Lloh50, Lloh51
	.loh AdrpLdrGot	Lloh54, Lloh55
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
	.uleb128 Ltmp35-Ltmp0                   ;   Call between Ltmp0 and Ltmp35
	.uleb128 Ltmp36-Lfunc_begin0            ;     jumps to Ltmp36
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp37-Lfunc_begin0            ; >> Call Site 2 <<
	.uleb128 Ltmp82-Ltmp37                  ;   Call between Ltmp37 and Ltmp82
	.uleb128 Ltmp83-Lfunc_begin0            ;     jumps to Ltmp83
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp84-Lfunc_begin0            ; >> Call Site 3 <<
	.uleb128 Ltmp85-Ltmp84                  ;   Call between Ltmp84 and Ltmp85
	.uleb128 Ltmp86-Lfunc_begin0            ;     jumps to Ltmp86
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp85-Lfunc_begin0            ; >> Call Site 4 <<
	.uleb128 Ltmp67-Ltmp85                  ;   Call between Ltmp85 and Ltmp67
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp67-Lfunc_begin0            ; >> Call Site 5 <<
	.uleb128 Ltmp68-Ltmp67                  ;   Call between Ltmp67 and Ltmp68
	.uleb128 Ltmp69-Lfunc_begin0            ;     jumps to Ltmp69
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp70-Lfunc_begin0            ; >> Call Site 6 <<
	.uleb128 Ltmp71-Ltmp70                  ;   Call between Ltmp70 and Ltmp71
	.uleb128 Ltmp72-Lfunc_begin0            ;     jumps to Ltmp72
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp71-Lfunc_begin0            ; >> Call Site 7 <<
	.uleb128 Ltmp20-Ltmp71                  ;   Call between Ltmp71 and Ltmp20
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp20-Lfunc_begin0            ; >> Call Site 8 <<
	.uleb128 Ltmp21-Ltmp20                  ;   Call between Ltmp20 and Ltmp21
	.uleb128 Ltmp22-Lfunc_begin0            ;     jumps to Ltmp22
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp23-Lfunc_begin0            ; >> Call Site 9 <<
	.uleb128 Ltmp24-Ltmp23                  ;   Call between Ltmp23 and Ltmp24
	.uleb128 Ltmp25-Lfunc_begin0            ;     jumps to Ltmp25
	.byte	5                               ;   On action: 3
	.uleb128 Ltmp24-Lfunc_begin0            ; >> Call Site 10 <<
	.uleb128 Ltmp87-Ltmp24                  ;   Call between Ltmp24 and Ltmp87
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp87-Lfunc_begin0            ; >> Call Site 11 <<
	.uleb128 Ltmp90-Ltmp87                  ;   Call between Ltmp87 and Ltmp90
	.uleb128 Ltmp91-Lfunc_begin0            ;     jumps to Ltmp91
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp90-Lfunc_begin0            ; >> Call Site 12 <<
	.uleb128 Ltmp92-Ltmp90                  ;   Call between Ltmp90 and Ltmp92
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp92-Lfunc_begin0            ; >> Call Site 13 <<
	.uleb128 Ltmp93-Ltmp92                  ;   Call between Ltmp92 and Ltmp93
	.uleb128 Ltmp94-Lfunc_begin0            ;     jumps to Ltmp94
	.byte	7                               ;   On action: 4
	.uleb128 Ltmp93-Lfunc_begin0            ; >> Call Site 14 <<
	.uleb128 Lfunc_end0-Ltmp93              ;   Call between Ltmp93 and Lfunc_end0
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
Ltmp123:                                ; TypeInfo 1
	.long	__ZTISt9exception@GOT-Ltmp123
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
	.private_extern	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m ; -- Begin function _ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
	.globl	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
	.weak_def_can_be_hidden	__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
	.p2align	2
__ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m: ; @_ZNSt3__124__put_character_sequenceB9nqe210106IcNS_11char_traitsIcEEEERNS_13basic_ostreamIT_T0_EES7_PKS4_m
Lfunc_begin1:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception1
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
Ltmp95:
	add	x0, sp, #8
	mov	x1, x19
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryC1ERS3_
Ltmp96:
; %bb.1:
	ldrb	w8, [sp, #8]
	cmp	w8, #1
	b.ne	LBB4_10
; %bb.2:
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
	add	x4, x19, x8
	ldr	x22, [x4, #40]
	ldr	w24, [x4, #8]
	ldr	w23, [x4, #144]
	cmn	w23, #1
	b.ne	LBB4_7
; %bb.3:
Ltmp98:
	add	x8, sp, #24
	mov	x25, x4
	mov	x0, x4
	bl	__ZNKSt3__18ios_base6getlocEv
Ltmp99:
; %bb.4:
Ltmp100:
Lloh56:
	adrp	x1, __ZNSt3__15ctypeIcE2idE@GOTPAGE
Lloh57:
	ldr	x1, [x1, __ZNSt3__15ctypeIcE2idE@GOTPAGEOFF]
	add	x0, sp, #24
	bl	__ZNKSt3__16locale9use_facetERNS0_2idE
Ltmp101:
; %bb.5:
	ldr	x8, [x0]
	ldr	x8, [x8, #56]
Ltmp102:
	mov	w1, #32                         ; =0x20
	blr	x8
Ltmp103:
; %bb.6:
	mov	x23, x0
	add	x0, sp, #24
	bl	__ZNSt3__16localeD1Ev
	mov	x4, x25
	str	w23, [x25, #144]
LBB4_7:
	mov	w8, #176                        ; =0xb0
	and	w8, w24, w8
	add	x3, x20, x21
	cmp	w8, #32
	csel	x2, x3, x20, eq
Ltmp105:
	sxtb	w5, w23
	mov	x0, x22
	mov	x1, x20
	bl	__ZNSt3__116__pad_and_outputB9nqe210106IcNS_11char_traitsIcEEEENS_19ostreambuf_iteratorIT_T0_EES6_PKS4_S8_S8_RNS_8ios_baseES4_
Ltmp106:
; %bb.8:
	cbnz	x0, LBB4_10
; %bb.9:
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
	add	x0, x19, x8
	ldr	w8, [x0, #32]
	mov	w9, #5                          ; =0x5
Ltmp108:
	orr	w1, w8, w9
	bl	__ZNSt3__18ios_base5clearEj
Ltmp109:
LBB4_10:
	add	x0, sp, #8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryD1Ev
LBB4_11:
	mov	x0, x19
	ldp	x29, x30, [sp, #96]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #80]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #64]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #48]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #112
	ret
LBB4_12:
Ltmp110:
	b	LBB4_15
LBB4_13:
Ltmp104:
	mov	x20, x0
	add	x0, sp, #24
	bl	__ZNSt3__16localeD1Ev
	b	LBB4_16
LBB4_14:
Ltmp107:
LBB4_15:
	mov	x20, x0
LBB4_16:
	add	x0, sp, #8
	bl	__ZNSt3__113basic_ostreamIcNS_11char_traitsIcEEE6sentryD1Ev
	b	LBB4_18
LBB4_17:
Ltmp97:
	mov	x20, x0
LBB4_18:
	mov	x0, x20
	bl	___cxa_begin_catch
	ldr	x8, [x19]
	ldur	x8, [x8, #-24]
Ltmp111:
	add	x0, x19, x8
	bl	__ZNSt3__18ios_base33__set_badbit_and_consider_rethrowEv
Ltmp112:
; %bb.19:
	bl	___cxa_end_catch
	b	LBB4_11
LBB4_20:
Ltmp113:
	mov	x19, x0
Ltmp114:
	bl	___cxa_end_catch
Ltmp115:
; %bb.21:
	mov	x0, x19
	bl	__Unwind_Resume
LBB4_22:
Ltmp116:
	bl	___clang_call_terminate
	.loh AdrpLdrGot	Lloh56, Lloh57
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
	.uleb128 Ltmp95-Lfunc_begin1            ; >> Call Site 1 <<
	.uleb128 Ltmp96-Ltmp95                  ;   Call between Ltmp95 and Ltmp96
	.uleb128 Ltmp97-Lfunc_begin1            ;     jumps to Ltmp97
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp98-Lfunc_begin1            ; >> Call Site 2 <<
	.uleb128 Ltmp99-Ltmp98                  ;   Call between Ltmp98 and Ltmp99
	.uleb128 Ltmp107-Lfunc_begin1           ;     jumps to Ltmp107
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp100-Lfunc_begin1           ; >> Call Site 3 <<
	.uleb128 Ltmp103-Ltmp100                ;   Call between Ltmp100 and Ltmp103
	.uleb128 Ltmp104-Lfunc_begin1           ;     jumps to Ltmp104
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp105-Lfunc_begin1           ; >> Call Site 4 <<
	.uleb128 Ltmp106-Ltmp105                ;   Call between Ltmp105 and Ltmp106
	.uleb128 Ltmp107-Lfunc_begin1           ;     jumps to Ltmp107
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp108-Lfunc_begin1           ; >> Call Site 5 <<
	.uleb128 Ltmp109-Ltmp108                ;   Call between Ltmp108 and Ltmp109
	.uleb128 Ltmp110-Lfunc_begin1           ;     jumps to Ltmp110
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp109-Lfunc_begin1           ; >> Call Site 6 <<
	.uleb128 Ltmp111-Ltmp109                ;   Call between Ltmp109 and Ltmp111
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp111-Lfunc_begin1           ; >> Call Site 7 <<
	.uleb128 Ltmp112-Ltmp111                ;   Call between Ltmp111 and Ltmp112
	.uleb128 Ltmp113-Lfunc_begin1           ;     jumps to Ltmp113
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp112-Lfunc_begin1           ; >> Call Site 8 <<
	.uleb128 Ltmp114-Ltmp112                ;   Call between Ltmp112 and Ltmp114
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp114-Lfunc_begin1           ; >> Call Site 9 <<
	.uleb128 Ltmp115-Ltmp114                ;   Call between Ltmp114 and Ltmp115
	.uleb128 Ltmp116-Lfunc_begin1           ;     jumps to Ltmp116
	.byte	1                               ;   On action: 1
	.uleb128 Ltmp115-Lfunc_begin1           ; >> Call Site 10 <<
	.uleb128 Lfunc_end1-Ltmp115             ;   Call between Ltmp115 and Lfunc_end1
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
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
	.private_extern	__ZNSt3__116__pad_and_outputB9nqe210106IcNS_11char_traitsIcEEEENS_19ostreambuf_iteratorIT_T0_EES6_PKS4_S8_S8_RNS_8ios_baseES4_ ; -- Begin function _ZNSt3__116__pad_and_outputB9nqe210106IcNS_11char_traitsIcEEEENS_19ostreambuf_iteratorIT_T0_EES6_PKS4_S8_S8_RNS_8ios_baseES4_
	.globl	__ZNSt3__116__pad_and_outputB9nqe210106IcNS_11char_traitsIcEEEENS_19ostreambuf_iteratorIT_T0_EES6_PKS4_S8_S8_RNS_8ios_baseES4_
	.weak_def_can_be_hidden	__ZNSt3__116__pad_and_outputB9nqe210106IcNS_11char_traitsIcEEEENS_19ostreambuf_iteratorIT_T0_EES6_PKS4_S8_S8_RNS_8ios_baseES4_
	.p2align	2
__ZNSt3__116__pad_and_outputB9nqe210106IcNS_11char_traitsIcEEEENS_19ostreambuf_iteratorIT_T0_EES6_PKS4_S8_S8_RNS_8ios_baseES4_: ; @_ZNSt3__116__pad_and_outputB9nqe210106IcNS_11char_traitsIcEEEENS_19ostreambuf_iteratorIT_T0_EES6_PKS4_S8_S8_RNS_8ios_baseES4_
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
	mov	x19, x0
	cbz	x0, LBB5_16
; %bb.1:
	mov	x23, x5
	mov	x20, x4
	mov	x22, x3
	mov	x21, x2
	mov	x24, x1
	ldr	x26, [x4, #24]
	sub	x25, x2, x1
	cmp	x25, #1
	b.lt	LBB5_3
; %bb.2:
	ldr	x8, [x19]
	ldr	x8, [x8, #96]
	mov	x0, x19
	mov	x1, x24
	mov	x2, x25
	blr	x8
	cmp	x0, x25
	b.ne	LBB5_15
LBB5_3:
	sub	x8, x22, x24
	cmp	x26, x8
	b.le	LBB5_12
; %bb.4:
	mov	x9, #-9                         ; =0xfffffffffffffff7
	movk	x9, #32767, lsl #48
	sub	x24, x26, x8
	cmp	x24, x9
	b.hs	LBB5_17
; %bb.5:
	cmp	x24, #23
	b.hs	LBB5_7
; %bb.6:
	strb	w24, [sp, #31]
	add	x25, sp, #8
	b	LBB5_8
LBB5_7:
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
LBB5_8:
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
Ltmp117:
	mov	x0, x19
	mov	x2, x24
	blr	x8
Ltmp118:
; %bb.9:
	ldrsb	w8, [sp, #31]
	tbnz	w8, #31, LBB5_11
; %bb.10:
	cmp	x0, x24
	b.ne	LBB5_15
	b	LBB5_12
LBB5_11:
	ldr	x8, [sp, #8]
	mov	x23, x0
	mov	x0, x8
	bl	__ZdlPv
	mov	x0, x23
	cmp	x0, x24
	b.ne	LBB5_15
LBB5_12:
	sub	x22, x22, x21
	cmp	x22, #1
	b.lt	LBB5_14
; %bb.13:
	ldr	x8, [x19]
	ldr	x8, [x8, #96]
	mov	x0, x19
	mov	x1, x21
	mov	x2, x22
	blr	x8
	cmp	x0, x22
	b.ne	LBB5_15
LBB5_14:
	str	xzr, [x20, #24]
	b	LBB5_16
LBB5_15:
	mov	x19, #0                         ; =0x0
LBB5_16:
	mov	x0, x19
	ldp	x29, x30, [sp, #96]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #80]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #64]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #48]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #112
	ret
LBB5_17:
	bl	__ZNSt3__112basic_stringIcNS_11char_traitsIcEENS_9allocatorIcEEE20__throw_length_errorB9nqe210106Ev
LBB5_18:
Ltmp119:
	mov	x19, x0
	ldrsb	w8, [sp, #31]
	tbz	w8, #31, LBB5_20
; %bb.19:
	ldr	x0, [sp, #8]
	bl	__ZdlPv
LBB5_20:
	mov	x0, x19
	bl	__Unwind_Resume
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
	.uleb128 Ltmp117-Lfunc_begin2           ;   Call between Lfunc_begin2 and Ltmp117
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp117-Lfunc_begin2           ; >> Call Site 2 <<
	.uleb128 Ltmp118-Ltmp117                ;   Call between Ltmp117 and Ltmp118
	.uleb128 Ltmp119-Lfunc_begin2           ;     jumps to Ltmp119
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp118-Lfunc_begin2           ; >> Call Site 3 <<
	.uleb128 Lfunc_end2-Ltmp118             ;   Call between Ltmp118 and Lfunc_end2
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end2:
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
Lloh58:
	adrp	x0, l_.str.6@PAGE
Lloh59:
	add	x0, x0, l_.str.6@PAGEOFF
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
Ltmp120:
	mov	x1, x20
	bl	__ZNSt12length_errorC1B9nqe210106EPKc
Ltmp121:
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
LBB7_2:
Ltmp122:
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
GCC_except_table7:
Lexception3:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end3-Lcst_begin3
Lcst_begin3:
	.uleb128 Lfunc_begin3-Lfunc_begin3      ; >> Call Site 1 <<
	.uleb128 Ltmp120-Lfunc_begin3           ;   Call between Lfunc_begin3 and Ltmp120
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp120-Lfunc_begin3           ; >> Call Site 2 <<
	.uleb128 Ltmp121-Ltmp120                ;   Call between Ltmp120 and Ltmp121
	.uleb128 Ltmp122-Lfunc_begin3           ;     jumps to Ltmp122
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp121-Lfunc_begin3           ; >> Call Site 3 <<
	.uleb128 Lfunc_end3-Ltmp121             ;   Call between Ltmp121 and Lfunc_end3
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
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"W/X observation mismatch"

l_.str.1:                               ; @.str.1
	.asciz	"input=0x"

l_.str.2:                               ; @.str.2
	.asciz	" write_W_read_X=0x"

	.section	__TEXT,__literal16,16byte_literals
	.p2align	2, 0x0                          ; @__const.main.x
l___const.main.x:
	.long	1                               ; 0x1
	.long	2                               ; 0x2
	.long	3                               ; 0x3
	.long	4294967295                      ; 0xffffffff

	.p2align	2, 0x0                          ; @__const.main.y
l___const.main.y:
	.long	10                              ; 0xa
	.long	20                              ; 0x14
	.long	30                              ; 0x1e
	.long	1                               ; 0x1

	.section	__TEXT,__cstring,cstring_literals
l_.str.3:                               ; @.str.3
	.asciz	"V lane observation mismatch"

l_.str.4:                               ; @.str.4
	.asciz	"lane"

l_.str.5:                               ; @.str.5
	.asciz	"PASS 3 W/X cases + 4 V lanes; CPU observation only\n"

l_.str.6:                               ; @.str.6
	.asciz	"basic_string"

.subsections_via_symbols
