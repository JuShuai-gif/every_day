	.build_version macos, 26, 0	sdk_version 26, 5
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__Z10scalar_dotPKaS0_m          ; -- Begin function _Z10scalar_dotPKaS0_m
	.p2align	2
__Z10scalar_dotPKaS0_m:                 ; @_Z10scalar_dotPKaS0_m
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
	cmp	x2, #32
	b.hi	LBB0_8
; %bb.1:
	cbz	x2, LBB0_7
; %bb.2:
	cbz	x0, LBB0_8
; %bb.3:
	cbz	x1, LBB0_8
; %bb.4:
	mov	w8, #0                          ; =0x0
LBB0_5:                                 ; =>This Inner Loop Header: Depth=1
	ldrsb	w9, [x0], #1
	ldrsb	w10, [x1], #1
	madd	w8, w10, w9, w8
	subs	x2, x2, #1
	b.ne	LBB0_5
; %bb.6:
	mov	x0, x8
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
	ret
LBB0_7:
	mov	w8, #0                          ; =0x0
	mov	x0, x8
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
	ret
LBB0_8:
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
; %bb.9:
	mov	x0, x19
	bl	__Z10scalar_dotPKaS0_m.cold.1
LBB0_10:
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
Lloh2:
	adrp	x8, __ZTVSt16invalid_argument@GOTPAGE
Lloh3:
	ldr	x8, [x8, __ZTVSt16invalid_argument@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x0]
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
	.loh AdrpLdrGot	Lloh2, Lloh3
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _Z10scalar_dotPKaS0_m.cold.1
__Z10scalar_dotPKaS0_m.cold.1:          ; @_Z10scalar_dotPKaS0_m.cold.1
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh4:
	adrp	x1, __ZTISt16invalid_argument@GOTPAGE
Lloh5:
	ldr	x1, [x1, __ZTISt16invalid_argument@GOTPAGEOFF]
Lloh6:
	adrp	x2, __ZNSt16invalid_argumentD1Ev@GOTPAGE
Lloh7:
	ldr	x2, [x2, __ZNSt16invalid_argumentD1Ev@GOTPAGEOFF]
	bl	___cxa_throw
	.loh AdrpLdrGot	Lloh6, Lloh7
	.loh AdrpLdrGot	Lloh4, Lloh5
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"block needs valid pointers and n<=32"

.subsections_via_symbols
