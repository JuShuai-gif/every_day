	.build_version macos, 26, 0	sdk_version 26, 5
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__ZN8practice9incrementERNSt3__16atomicIyEEy ; -- Begin function _ZN8practice9incrementERNSt3__16atomicIyEEy
	.p2align	2
__ZN8practice9incrementERNSt3__16atomicIyEEy: ; @_ZN8practice9incrementERNSt3__16atomicIyEEy
	.cfi_startproc
; %bb.0:
	cbz	x1, LBB0_3
; %bb.1:
	mov	w8, #1                          ; =0x1
LBB0_2:                                 ; =>This Inner Loop Header: Depth=1
	ldadd	x8, x9, [x0]
	subs	x1, x1, #1
	b.ne	LBB0_2
LBB0_3:
	ret
	.cfi_endproc
                                        ; -- End function
.subsections_via_symbols
