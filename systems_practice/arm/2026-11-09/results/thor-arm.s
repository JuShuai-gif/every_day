	.arch armv8-a
	.file	"main.cpp"
	.text
#APP
	.globl _ZSt21ios_base_library_initv
#NO_APP
	.section	.text._ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EED2Ev,"axG",@progbits,_ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EED5Ev,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EED2Ev
	.type	_ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EED2Ev, %function
_ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EED2Ev:
.LFB7708:
	.cfi_startproc
	ret
	.cfi_endproc
.LFE7708:
	.size	_ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EED2Ev, .-_ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EED2Ev
	.weak	_ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EED1Ev
	.set	_ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EED1Ev,_ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EED2Ev
	.section	.text._ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EED0Ev,"axG",@progbits,_ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EED5Ev,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EED0Ev
	.type	_ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EED0Ev, %function
_ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EED0Ev:
.LFB7710:
	.cfi_startproc
	mov	x1, 40
	b	_ZdlPvm
	.cfi_endproc
.LFE7710:
	.size	_ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EED0Ev, .-_ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EED0Ev
	.section	.text._ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE14_M_get_deleterERKSt9type_info,"axG",@progbits,_ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE14_M_get_deleterERKSt9type_info,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE14_M_get_deleterERKSt9type_info
	.type	_ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE14_M_get_deleterERKSt9type_info, %function
_ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE14_M_get_deleterERKSt9type_info:
.LFB7713:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	adrp	x2, _ZZNSt19_Sp_make_shared_tag5_S_tiEvE5__tag
	add	x2, x2, :lo12:_ZZNSt19_Sp_make_shared_tag5_S_tiEvE5__tag
	mov	x29, sp
	str	x19, [sp, 16]
	.cfi_offset 19, -16
	add	x19, x0, 16
	cmp	x1, x2
	beq	.L4
	ldr	x0, [x1, 8]
	adrp	x1, _ZTSSt19_Sp_make_shared_tag
	add	x1, x1, :lo12:_ZTSSt19_Sp_make_shared_tag
	cmp	x0, x1
	beq	.L4
	ldrb	w2, [x0]
	cmp	w2, 42
	beq	.L6
	bl	strcmp
	cmp	w0, 0
	csel	x19, x19, xzr, eq
.L4:
	mov	x0, x19
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L6:
	.cfi_restore_state
	mov	x19, 0
	mov	x0, x19
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE7713:
	.size	_ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE14_M_get_deleterERKSt9type_info, .-_ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE14_M_get_deleterERKSt9type_info
	.section	.text._ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE10_M_destroyEv,"axG",@progbits,_ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE10_M_destroyEv,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE10_M_destroyEv
	.type	_ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE10_M_destroyEv, %function
_ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE10_M_destroyEv:
.LFB7712:
	.cfi_startproc
	mov	x1, 40
	b	_ZdlPvm
	.cfi_endproc
.LFE7712:
	.size	_ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE10_M_destroyEv, .-_ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE10_M_destroyEv
	.section	.text._ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE10_M_disposeEv,"axG",@progbits,_ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE10_M_disposeEv,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE10_M_disposeEv
	.type	_ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE10_M_disposeEv, %function
_ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE10_M_disposeEv:
.LFB7711:
	.cfi_startproc
	add	x1, x0, 16
	ldr	x0, [x0, 16]
	cbz	x0, .L11
	ldr	x1, [x1, 16]
	sub	x1, x1, x0
	b	_ZdlPvm
	.p2align 2,,3
.L11:
	ret
	.cfi_endproc
.LFE7711:
	.size	_ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE10_M_disposeEv, .-_ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE10_M_disposeEv
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align	3
.LC1:
	.string	"short buffer"
	.text
	.align	2
	.p2align 4,,11
	.global	_Z4packRKSt6vectorIfSaIfEEmmRS1_
	.type	_Z4packRKSt6vectorIfSaIfEEmmRS1_, %function
_Z4packRKSt6vectorIfSaIfEEmmRS1_:
.LFB6940:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA6940
	sub	sp, sp, #112
	.cfi_def_cfa_offset 112
	adrp	x4, :got:__stack_chk_guard
	ldr	x4, [x4, :got_lo12:__stack_chk_guard]
	stp	x29, x30, [sp, 80]
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	add	x29, sp, 80
	ldr	x5, [x4]
	str	x5, [sp, 72]
	mov	x5, 0
	cmp	x2, x1
	bcc	.L14
	ldp	x4, x5, [x0]
	sub	x5, x5, x4
	asr	x5, x5, 2
	cmp	x2, x5, lsr 2
	bhi	.L14
	ldp	x6, x5, [x3]
	sub	x5, x5, x6
	asr	x5, x5, 2
	cmp	x1, x5, lsr 2
	bhi	.L14
	cmp	x1, 3
	bls	.L25
	lsl	x9, x2, 2
	mov	x11, sp
	add	x7, sp, 64
	mov	x8, 0
	mov	x10, 4
	.p2align 3,,7
.L16:
	add	x4, x4, x8, lsl 2
	mov	x5, x11
.L18:
	ldr	q0, [x4]
	add	x4, x4, x9
	str	q0, [x5], 16
	cmp	x5, x7
	bne	.L18
	ld1	{v0.4s - v3.4s}, [x11]
	add	x6, x6, x8, lsl 4
	add	x5, x10, 4
	add	x8, x8, 4
	st4	{v0.4s - v3.4s}, [x6]
	cmp	x5, x1
	bhi	.L15
	ldr	x4, [x0]
	mov	x10, x5
	ldr	x6, [x3]
	b	.L16
.L25:
	mov	x10, 0
	.p2align 3,,7
.L15:
	cmp	x1, x10
	bls	.L13
	ldr	x3, [x3]
	lsl	x4, x2, 2
	ldr	x5, [x0]
	add	x3, x3, x10, lsl 4
.L20:
	add	x2, x5, x10, lsl 2
	mov	x0, 0
.L21:
	ldr	s0, [x2]
	add	x2, x2, x4
	str	s0, [x3, x0, lsl 2]
	add	x0, x0, 1
	cmp	x0, 4
	bne	.L21
	add	x10, x10, 1
	add	x3, x3, 16
	cmp	x1, x10
	bne	.L20
.L13:
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x2, [sp, 72]
	ldr	x1, [x0]
	subs	x2, x2, x1
	mov	x1, 0
	bne	.L32
	ldp	x29, x30, [sp, 80]
	add	sp, sp, 112
	.cfi_remember_state
	.cfi_restore 29
	.cfi_restore 30
	.cfi_def_cfa_offset 0
	ret
.L32:
	.cfi_restore_state
	str	x19, [sp, 96]
	.cfi_offset 19, -16
.L31:
	bl	__stack_chk_fail
.L14:
	.cfi_restore 19
	mov	x0, 16
	str	x19, [sp, 96]
	.cfi_offset 19, -16
	bl	__cxa_allocate_exception
	mov	x19, x0
	adrp	x1, .LC1
	add	x1, x1, :lo12:.LC1
.LEHB0:
	bl	_ZNSt16invalid_argumentC1EPKc
.LEHE0:
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x2, [sp, 72]
	ldr	x1, [x0]
	subs	x2, x2, x1
	mov	x1, 0
	bne	.L31
	adrp	x2, :got:_ZNSt16invalid_argumentD1Ev
	ldr	x2, [x2, :got_lo12:_ZNSt16invalid_argumentD1Ev]
	mov	x0, x19
	adrp	x1, :got:_ZTISt16invalid_argument
	ldr	x1, [x1, :got_lo12:_ZTISt16invalid_argument]
.LEHB1:
	bl	__cxa_throw
.L26:
	mov	x1, x0
	mov	x0, x19
	mov	x19, x1
	bl	__cxa_free_exception
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x2, [sp, 72]
	ldr	x1, [x0]
	subs	x2, x2, x1
	mov	x1, 0
	bne	.L31
	mov	x0, x19
	bl	_Unwind_Resume
.LEHE1:
	.cfi_endproc
.LFE6940:
	.global	__gxx_personality_v0
	.section	.gcc_except_table,"a",@progbits
.LLSDA6940:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE6940-.LLSDACSB6940
.LLSDACSB6940:
	.uleb128 .LEHB0-.LFB6940
	.uleb128 .LEHE0-.LEHB0
	.uleb128 .L26-.LFB6940
	.uleb128 0
	.uleb128 .LEHB1-.LFB6940
	.uleb128 .LEHE1-.LEHB1
	.uleb128 0
	.uleb128 0
.LLSDACSE6940:
	.text
	.size	_Z4packRKSt6vectorIfSaIfEEmmRS1_, .-_Z4packRKSt6vectorIfSaIfEEmmRS1_
	.global	__aarch64_ldadd4_acq_rel
	.section	.text._ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE24_M_release_last_use_coldEv,"axG",@progbits,_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE24_M_release_last_use_coldEv,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE24_M_release_last_use_coldEv
	.type	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE24_M_release_last_use_coldEv, %function
_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE24_M_release_last_use_coldEv:
.LFB7245:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	ldr	x1, [x0]
	ldr	x1, [x1, 16]
	str	x19, [sp, 16]
	.cfi_offset 19, -16
	mov	x19, x0
	blr	x1
	adrp	x0, :got:__libc_single_threaded
	ldr	x0, [x0, :got_lo12:__libc_single_threaded]
	ldrb	w0, [x0]
	cbz	w0, .L34
	ldr	w0, [x19, 12]
	sub	w1, w0, #1
	str	w1, [x19, 12]
.L35:
	cmp	w0, 1
	beq	.L38
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L38:
	.cfi_restore_state
	ldr	x1, [x19]
	mov	x0, x19
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ldr	x1, [x1, 24]
	mov	x16, x1
	br	x16
	.p2align 2,,3
.L34:
	.cfi_restore_state
	add	x1, x19, 12
	mov	w0, -1
	bl	__aarch64_ldadd4_acq_rel
	b	.L35
	.cfi_endproc
.LFE7245:
	.size	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE24_M_release_last_use_coldEv, .-_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE24_M_release_last_use_coldEv
	.section	.text._ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE10_M_releaseEv,"axG",@progbits,_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE10_M_releaseEv,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE10_M_releaseEv
	.type	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE10_M_releaseEv, %function
_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE10_M_releaseEv:
.LFB6237:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	add	x1, x0, 8
	mov	x29, sp
	str	x19, [sp, 16]
	.cfi_offset 19, -16
	mov	x19, x0
	ldar	x3, [x1]
	mov	x2, 4294967297
	cmp	x3, x2
	beq	.L45
	adrp	x0, :got:__libc_single_threaded
	ldr	x0, [x0, :got_lo12:__libc_single_threaded]
	ldrb	w0, [x0]
	cbz	w0, .L41
	ldr	w0, [x19, 8]
	sub	w1, w0, #1
	str	w1, [x19, 8]
.L42:
	cmp	w0, 1
	beq	.L46
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L41:
	.cfi_restore_state
	mov	w0, -1
	bl	__aarch64_ldadd4_acq_rel
	b	.L42
	.p2align 2,,3
.L45:
	ldr	x1, [x0]
	str	xzr, [x0, 8]
	ldr	x1, [x1, 16]
	blr	x1
	ldr	x1, [x19]
	mov	x0, x19
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ldr	x1, [x1, 24]
	mov	x16, x1
	br	x16
	.p2align 2,,3
.L46:
	.cfi_restore_state
	mov	x0, x19
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	b	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE24_M_release_last_use_coldEv
	.cfi_endproc
.LFE6237:
	.size	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE10_M_releaseEv, .-_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE10_M_releaseEv
	.section	.text._ZNSt5arrayISt10shared_ptrISt6vectorIfSaIfEEELm2EED2Ev,"axG",@progbits,_ZNSt5arrayISt10shared_ptrISt6vectorIfSaIfEEELm2EED5Ev,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt5arrayISt10shared_ptrISt6vectorIfSaIfEEELm2EED2Ev
	.type	_ZNSt5arrayISt10shared_ptrISt6vectorIfSaIfEEELm2EED2Ev, %function
_ZNSt5arrayISt10shared_ptrISt6vectorIfSaIfEEELm2EED2Ev:
.LFB6961:
	.cfi_startproc
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -32
	.cfi_offset 20, -24
	add	x19, x0, 16
	ldr	x20, [x19, 8]
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -16
	.cfi_offset 22, -8
	mov	x21, x0
	add	x1, x20, 8
	mov	x22, 4294967297
	cbz	x20, .L49
	ldar	x0, [x1]
	adrp	x2, :got:__libc_single_threaded
	ldr	x2, [x2, :got_lo12:__libc_single_threaded]
	cmp	x0, x22
	beq	.L57
.L50:
	ldrb	w0, [x2]
	cbz	w0, .L51
	ldr	w0, [x20, 8]
	sub	w1, w0, #1
	str	w1, [x20, 8]
.L52:
	cmp	w0, 1
	beq	.L58
.L49:
	sub	x0, x19, #16
	cmp	x19, x21
	beq	.L59
.L55:
	mov	x19, x0
	ldr	x20, [x19, 8]
	add	x1, x20, 8
	cbz	x20, .L49
	ldar	x0, [x1]
	adrp	x2, :got:__libc_single_threaded
	ldr	x2, [x2, :got_lo12:__libc_single_threaded]
	cmp	x0, x22
	bne	.L50
.L57:
	ldr	x1, [x20]
	str	xzr, [x20, 8]
	mov	x0, x20
	ldr	x1, [x1, 16]
	blr	x1
	ldr	x1, [x20]
	mov	x0, x20
	ldr	x1, [x1, 24]
	blr	x1
	sub	x0, x19, #16
	cmp	x19, x21
	bne	.L55
.L59:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L51:
	.cfi_restore_state
	mov	w0, -1
	bl	__aarch64_ldadd4_acq_rel
	b	.L52
	.p2align 2,,3
.L58:
	mov	x0, x20
	bl	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE24_M_release_last_use_coldEv
	b	.L49
	.cfi_endproc
.LFE6961:
	.size	_ZNSt5arrayISt10shared_ptrISt6vectorIfSaIfEEELm2EED2Ev, .-_ZNSt5arrayISt10shared_ptrISt6vectorIfSaIfEEELm2EED2Ev
	.weak	_ZNSt5arrayISt10shared_ptrISt6vectorIfSaIfEEELm2EED1Ev
	.set	_ZNSt5arrayISt10shared_ptrISt6vectorIfSaIfEEELm2EED1Ev,_ZNSt5arrayISt10shared_ptrISt6vectorIfSaIfEEELm2EED2Ev
	.section	.rodata._ZN4PoolC2Em.str1.8,"aMS",@progbits,1
	.align	3
.LC2:
	.string	"capacity"
	.section	.text._ZN4PoolC2Em,"axG",@progbits,_ZN4PoolC5Em,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN4PoolC2Em
	.type	_ZN4PoolC2Em, %function
_ZN4PoolC2Em:
.LFB6963:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA6963
	stp	x29, x30, [sp, -112]!
	.cfi_def_cfa_offset 112
	.cfi_offset 29, -112
	.cfi_offset 30, -104
	mov	x29, sp
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -64
	.cfi_offset 24, -56
	mov	x24, x0
	mov	x0, 8193
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	str	d8, [sp, 96]
	.cfi_offset 19, -96
	.cfi_offset 20, -88
	.cfi_offset 21, -80
	.cfi_offset 22, -72
	.cfi_offset 25, -48
	.cfi_offset 26, -40
	.cfi_offset 27, -32
	.cfi_offset 28, -24
	.cfi_offset 72, -16
	stp	xzr, xzr, [x24]
	stp	xzr, xzr, [x24, 16]
	cmp	x1, x0
	bhi	.L81
	movi	v8.2s, 0x1
	adrp	x25, _ZTVSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE+16
	lsl	x26, x1, 2
	add	x25, x25, :lo12:_ZTVSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE+16
	lsl	x21, x1, 4
	add	x22, x24, 8
	add	x27, x24, 40
.L73:
	mov	x0, 40
.LEHB2:
	bl	_Znwm
.LEHE2:
	mov	x20, x0
	str	d8, [x0, 8]
	mov	x19, x0
	str	x25, [x20], 16
	stp	xzr, xzr, [x0, 16]
	str	xzr, [x20, 16]
	cbz	x26, .L82
	mov	x0, x21
.LEHB3:
	bl	_Znwm
.LEHE3:
	mov	x23, x0
	str	wzr, [x0], 4
	str	x23, [x19, 16]
	add	x23, x23, x21
	str	x23, [x20, 16]
	cmp	x0, x23
	beq	.L63
	sub	x2, x21, #4
	mov	w1, 0
	bl	memset
.L63:
	ldr	x28, [x22]
	stp	x20, x19, [x22, -8]
	str	x23, [x20, 8]
	cbz	x28, .L66
	add	x1, x28, 8
	ldar	x2, [x1]
	mov	x0, 4294967297
	cmp	x2, x0
	beq	.L83
	adrp	x0, :got:__libc_single_threaded
	ldr	x0, [x0, :got_lo12:__libc_single_threaded]
	ldrb	w0, [x0]
	cbz	w0, .L70
	ldr	w0, [x28, 8]
	sub	w1, w0, #1
	str	w1, [x28, 8]
.L71:
	cmp	w0, 1
	beq	.L84
.L66:
	add	x22, x22, 16
	cmp	x27, x22
	bne	.L73
.L85:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldr	d8, [sp, 96]
	ldp	x29, x30, [sp], 112
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_restore 72
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L82:
	.cfi_restore_state
	str	xzr, [x0, 16]
	mov	x23, 0
	str	x21, [x20, 16]
	b	.L63
	.p2align 2,,3
.L70:
	mov	w0, -1
	bl	__aarch64_ldadd4_acq_rel
	b	.L71
	.p2align 2,,3
.L84:
	mov	x0, x28
	bl	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE24_M_release_last_use_coldEv
	b	.L66
	.p2align 2,,3
.L83:
	ldr	x1, [x28]
	str	xzr, [x28, 8]
	mov	x0, x28
	add	x22, x22, 16
	ldr	x1, [x1, 16]
	blr	x1
	ldr	x1, [x28]
	mov	x0, x28
	ldr	x1, [x1, 24]
	blr	x1
	cmp	x27, x22
	bne	.L73
	b	.L85
.L81:
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC2
	mov	x20, x0
	add	x1, x1, :lo12:.LC2
.LEHB4:
	bl	_ZNSt16invalid_argumentC1EPKc
.LEHE4:
	adrp	x2, :got:_ZNSt16invalid_argumentD1Ev
	ldr	x2, [x2, :got_lo12:_ZNSt16invalid_argumentD1Ev]
	mov	x0, x20
	adrp	x1, :got:_ZTISt16invalid_argument
	ldr	x1, [x1, :got_lo12:_ZTISt16invalid_argument]
.LEHB5:
	bl	__cxa_throw
.LEHE5:
.L77:
	mov	x20, x0
	mov	x1, 40
	mov	x0, x19
	mov	x19, x20
	bl	_ZdlPvm
	b	.L68
.L76:
	mov	x19, x0
	b	.L68
.L75:
	mov	x19, x0
	mov	x0, x20
	bl	__cxa_free_exception
.L68:
	mov	x0, x24
	bl	_ZNSt5arrayISt10shared_ptrISt6vectorIfSaIfEEELm2EED1Ev
	mov	x0, x19
.LEHB6:
	bl	_Unwind_Resume
.LEHE6:
	.cfi_endproc
.LFE6963:
	.section	.gcc_except_table
.LLSDA6963:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE6963-.LLSDACSB6963
.LLSDACSB6963:
	.uleb128 .LEHB2-.LFB6963
	.uleb128 .LEHE2-.LEHB2
	.uleb128 .L76-.LFB6963
	.uleb128 0
	.uleb128 .LEHB3-.LFB6963
	.uleb128 .LEHE3-.LEHB3
	.uleb128 .L77-.LFB6963
	.uleb128 0
	.uleb128 .LEHB4-.LFB6963
	.uleb128 .LEHE4-.LEHB4
	.uleb128 .L75-.LFB6963
	.uleb128 0
	.uleb128 .LEHB5-.LFB6963
	.uleb128 .LEHE5-.LEHB5
	.uleb128 .L76-.LFB6963
	.uleb128 0
	.uleb128 .LEHB6-.LFB6963
	.uleb128 .LEHE6-.LEHB6
	.uleb128 0
	.uleb128 0
.LLSDACSE6963:
	.section	.text._ZN4PoolC2Em,"axG",@progbits,_ZN4PoolC5Em,comdat
	.size	_ZN4PoolC2Em, .-_ZN4PoolC2Em
	.weak	_ZN4PoolC1Em
	.set	_ZN4PoolC1Em,_ZN4PoolC2Em
	.section	.text._ZNSt6vectorIfSaIfEED2Ev,"axG",@progbits,_ZNSt6vectorIfSaIfEED5Ev,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt6vectorIfSaIfEED2Ev
	.type	_ZNSt6vectorIfSaIfEED2Ev, %function
_ZNSt6vectorIfSaIfEED2Ev:
.LFB7276:
	.cfi_startproc
	mov	x2, x0
	ldr	x0, [x0]
	cbz	x0, .L86
	ldr	x1, [x2, 16]
	sub	x1, x1, x0
	b	_ZdlPvm
	.p2align 2,,3
.L86:
	ret
	.cfi_endproc
.LFE7276:
	.size	_ZNSt6vectorIfSaIfEED2Ev, .-_ZNSt6vectorIfSaIfEED2Ev
	.weak	_ZNSt6vectorIfSaIfEED1Ev
	.set	_ZNSt6vectorIfSaIfEED1Ev,_ZNSt6vectorIfSaIfEED2Ev
	.section	.rodata.str1.8
	.align	3
.LC3:
	.string	"cannot create std::vector larger than max_size()"
	.align	3
.LC4:
	.string	"capacity lease"
	.align	3
.LC5:
	.string	"oracle"
	.align	3
.LC6:
	.string	"reclamation"
	.align	3
.LC7:
	.string	"PASS "
	.align	3
.LC8:
	.string	" widths: two leases, busy rejection, reclaim, NEON oracle; 2 invalid inputs\n"
	.section	.text.startup,"ax",@progbits
	.align	2
	.p2align 4,,11
	.global	main
	.type	main, %function
main:
.LFB6973:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA6973
	sub	sp, sp, #304
	.cfi_def_cfa_offset 304
	adrp	x1, .LANCHOR0
	add	x1, x1, :lo12:.LANCHOR0
	add	x0, sp, 120
	adrp	x2, :got:__stack_chk_guard
	ldr	x2, [x2, :got_lo12:__stack_chk_guard]
	stp	x29, x30, [sp, 192]
	.cfi_offset 29, -112
	.cfi_offset 30, -104
	add	x29, sp, 192
	ldr	q1, [x1]
	stp	x21, x22, [sp, 224]
	.cfi_offset 21, -80
	.cfi_offset 22, -72
	mov	x22, 16913
	ldr	q0, [x1, 12]
	add	x1, sp, 152
	str	x1, [sp, 8]
	movk	x22, 0x2108, lsl 16
	adrp	x1, :got:__libc_single_threaded
	ldr	x1, [x1, :got_lo12:__libc_single_threaded]
	movk	x22, 0x1084, lsl 32
	str	x1, [sp, 16]
	mov	w1, 1120403456
	stp	x19, x20, [sp, 208]
	movk	x22, 0x842, lsl 48
	stp	x23, x24, [sp, 240]
	stp	x25, x26, [sp, 256]
	.cfi_offset 19, -96
	.cfi_offset 20, -88
	.cfi_offset 23, -64
	.cfi_offset 24, -56
	.cfi_offset 25, -48
	.cfi_offset 26, -40
	mov	x26, x0
	stp	x27, x28, [sp, 272]
	.cfi_offset 27, -32
	.cfi_offset 28, -24
	mov	w27, 0
	mov	x28, 4294967297
	str	d8, [sp, 288]
	.cfi_offset 72, -16
	fmov	s8, w1
	mov	x1, x2
	ldr	x2, [x1]
	str	x2, [sp, 184]
	mov	x2, 0
	str	q1, [sp, 120]
	str	q0, [sp, 132]
.L165:
	ldrsw	x19, [x26]
	ldr	x0, [sp, 8]
	mov	x1, x19
.LEHB7:
	bl	_ZN4PoolC1Em
.LEHE7:
	lsl	x21, x19, 2
	mov	x0, 2305843009213693951
	cmp	x21, x0
	bhi	.L299
	movi	v0.4s, 0
	lsl	x23, x19, 4
	str	q0, [sp, 72]
	cbz	x21, .L300
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	str	x0, [sp, 24]
	mov	x0, x23
.LEHB8:
	bl	_Znwm
.LEHE8:
	mov	x20, x0
	add	x24, x0, x23
	str	wzr, [x0], 4
	str	x20, [sp, 64]
	str	x24, [sp, 80]
	cmp	x24, x0
	beq	.L93
	sub	x2, x23, #4
	mov	w1, 0
	bl	memset
.L93:
	mov	x0, x23
	str	x24, [sp, 72]
	stp	xzr, xzr, [sp, 104]
.LEHB9:
	bl	_Znwm
.LEHE9:
	mov	x25, x0
	add	x3, x0, x23
	sub	x4, x24, x20
	str	wzr, [x0], 4
	str	x25, [sp, 96]
	asr	x4, x4, 2
	str	x3, [sp, 112]
	cmp	x0, x3
	beq	.L94
	sub	x2, x23, #4
	mov	w1, 0
	stp	x4, x3, [sp, 24]
	bl	memset
	ldp	x4, x3, [sp, 24]
.L94:
	str	x3, [sp, 104]
	mov	x1, 0
	cmp	x20, x24
	beq	.L92
	.p2align 3,,7
.L95:
	umulh	x3, x1, x22
	sub	x2, x1, x3
	add	x2, x3, x2, lsr 1
	lsr	x2, x2, 4
	lsl	x3, x2, 5
	sub	x2, x3, x2
	sub	x2, x1, x2
	scvtf	s0, x2
	fadd	s1, s0, s8
	str	s0, [x20, x1, lsl 2]
	str	s1, [x25, x1, lsl 2]
	add	x1, x1, 1
	cmp	x4, x1
	bhi	.L95
.L92:
	ldr	x0, [sp, 160]
	cbz	x0, .L96
	add	x1, x0, 8
	ldr	w1, [x1]
	cmp	w1, 1
	beq	.L208
.L96:
	ldr	x1, [sp, 176]
	cbz	x1, .L99
	add	x1, x1, 8
	ldr	w1, [x1]
	add	x20, sp, 168
	cmp	w1, 1
	beq	.L97
.L99:
	mov	x24, 0
	mov	x23, 0
.L102:
	cbz	x0, .L103
	add	x0, x0, 8
	ldr	w0, [x0]
	cmp	w0, 1
	beq	.L209
.L103:
	ldr	x0, [sp, 176]
	cbz	x0, .L105
	add	x0, x0, 8
	ldr	w0, [x0]
	cmp	w0, 1
	beq	.L301
.L105:
	mov	x25, 0
.L108:
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC4
	mov	x21, x0
	add	x1, x1, :lo12:.LC4
.LEHB10:
	bl	_ZNSt11logic_errorC1EPKc
.LEHE10:
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	str	x0, [sp, 24]
	mov	x2, x0
	ldr	x0, [sp, 184]
	ldr	x1, [x2]
	subs	x0, x0, x1
	mov	x1, 0
	bne	.L296
	add	x3, sp, 64
	str	x3, [sp, 40]
	adrp	x2, :got:_ZNSt11logic_errorD1Ev
	ldr	x2, [x2, :got_lo12:_ZNSt11logic_errorD1Ev]
	add	x3, sp, 96
	adrp	x1, :got:_ZTISt11logic_error
	ldr	x1, [x1, :got_lo12:_ZTISt11logic_error]
	mov	x0, x21
	str	x3, [sp, 32]
.LEHB11:
	bl	__cxa_throw
.LEHE11:
.L301:
	add	x25, sp, 168
.L104:
	ldr	x20, [x25]
	add	x0, sp, 96
	mov	x2, x19
	mov	x1, x19
	mov	x3, x20
	str	x0, [sp, 32]
.LEHB12:
	bl	_Z4packRKSt6vectorIfSaIfEEmmRS1_
.LEHE12:
	ldr	x25, [x25, 8]
	cbz	x25, .L106
	adrp	x0, :got:__libc_single_threaded
	ldr	x0, [x0, :got_lo12:__libc_single_threaded]
	ldrb	w0, [x0]
	cbz	w0, .L107
	ldr	w0, [x25, 8]
	add	w0, w0, 1
	str	w0, [x25, 8]
.L106:
	cbz	x23, .L108
	cbz	x20, .L108
	ldr	x0, [sp, 160]
	cbz	x0, .L111
	add	x0, x0, 8
	ldr	w0, [x0]
	cmp	w0, 1
	beq	.L210
.L111:
	ldr	x0, [sp, 176]
	cbz	x0, .L201
	add	x0, x0, 8
	ldr	w0, [x0]
	cmp	w0, 1
	beq	.L302
.L201:
	ldr	x4, [sp, 64]
	mov	x6, 0
	ldr	x3, [sp, 96]
	.p2align 3,,7
.L117:
	cbz	x19, .L121
	ldr	x5, [x23]
	lsl	x1, x6, 2
	mov	x0, 0
	.p2align 3,,7
.L120:
	ldr	s1, [x5, x1]
	ldr	s0, [x4, x0, lsl 2]
	fcmp	s1, s0
	bne	.L119
	ldr	x2, [x20]
	ldr	s0, [x3, x0, lsl 2]
	ldr	s1, [x2, x1]
	fcmp	s1, s0
	bne	.L119
	add	x0, x0, 1
	add	x1, x1, 16
	cmp	x19, x0
	bne	.L120
.L121:
	add	x6, x6, 1
	add	x3, x3, x21
	add	x4, x4, x21
	cmp	x6, 4
	bne	.L117
	cbz	x24, .L126
	add	x1, x24, 8
	ldar	x0, [x1]
	cmp	x0, x28
	beq	.L303
	ldr	x0, [sp, 16]
	ldrb	w0, [x0]
	cbz	w0, .L132
	ldr	w0, [x24, 8]
	sub	w1, w0, #1
	str	w1, [x24, 8]
.L133:
	cmp	w0, 1
	beq	.L304
.L126:
	ldr	x0, [sp, 160]
	cbz	x0, .L128
	add	x0, x0, 8
	ldr	w0, [x0]
	cmp	w0, 1
	beq	.L211
.L128:
	ldr	x0, [sp, 176]
	cbz	x0, .L131
	add	x0, x0, 8
	ldr	w0, [x0]
	cmp	w0, 1
	beq	.L305
.L131:
	mov	x19, 0
.L140:
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC6
	mov	x22, x0
	add	x1, x1, :lo12:.LC6
.LEHB13:
	bl	_ZNSt11logic_errorC1EPKc
.LEHE13:
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	str	x0, [sp, 24]
	mov	x2, x0
	ldr	x0, [sp, 184]
	ldr	x1, [x2]
	subs	x0, x0, x1
	mov	x1, 0
	bne	.L296
	adrp	x2, :got:_ZNSt11logic_errorD1Ev
	ldr	x2, [x2, :got_lo12:_ZNSt11logic_errorD1Ev]
	mov	x0, x22
	adrp	x1, :got:_ZTISt11logic_error
	ldr	x1, [x1, :got_lo12:_ZTISt11logic_error]
.LEHB14:
	bl	__cxa_throw
.LEHE14:
	.p2align 2,,3
.L300:
	str	q0, [sp, 64]
	str	x23, [sp, 80]
	stp	xzr, xzr, [sp, 96]
	str	x23, [sp, 112]
	b	.L92
.L208:
	ldr	x20, [sp, 8]
.L97:
	add	x0, sp, 64
	ldr	x23, [x20]
	mov	x2, x19
	mov	x1, x19
	str	x0, [sp, 40]
	mov	x3, x23
.LEHB15:
	bl	_Z4packRKSt6vectorIfSaIfEEmmRS1_
.LEHE15:
	ldr	x24, [x20, 8]
	cbz	x24, .L293
	adrp	x0, :got:__libc_single_threaded
	ldr	x0, [x0, :got_lo12:__libc_single_threaded]
	ldrb	w0, [x0]
	cbz	w0, .L101
	ldr	w1, [x24, 8]
	ldr	x0, [sp, 160]
	add	w1, w1, 1
	str	w1, [x24, 8]
	b	.L102
.L209:
	ldr	x25, [sp, 8]
	b	.L104
.L101:
	add	x1, x24, 8
	mov	w0, 1
	bl	__aarch64_ldadd4_acq_rel
.L293:
	ldr	x0, [sp, 160]
	b	.L102
.L305:
	add	x24, sp, 168
.L129:
	ldr	x0, [sp, 32]
	mov	x2, x19
	ldr	x21, [x24]
	mov	x1, x19
	mov	x3, x21
.LEHB16:
	bl	_Z4packRKSt6vectorIfSaIfEEmmRS1_
.LEHE16:
	ldr	x19, [x24, 8]
	cbz	x19, .L138
	adrp	x0, :got:__libc_single_threaded
	ldr	x0, [x0, :got_lo12:__libc_single_threaded]
	ldrb	w0, [x0]
	cbz	w0, .L139
	ldr	w0, [x19, 8]
	add	w0, w0, 1
	str	w0, [x19, 8]
.L138:
	cmp	x21, x23
	bne	.L140
	ldp	x1, x3, [x20]
	ldp	x0, x2, [x21]
	sub	x3, x3, x1
	sub	x4, x2, x0
	cmp	x4, x3
	bne	.L140
	cmp	x0, x2
	beq	.L141
	.p2align 3,,7
.L142:
	ldr	s1, [x0]
	ldr	s0, [x1]
	fcmp	s1, s0
	bne	.L140
	add	x0, x0, 4
	add	x1, x1, 4
	cmp	x2, x0
	bne	.L142
.L141:
	add	w27, w27, 1
	cbz	x19, .L144
	add	x1, x19, 8
	ldar	x0, [x1]
	cmp	x0, x28
	beq	.L306
	ldr	x0, [sp, 16]
	ldrb	w0, [x0]
	cbz	w0, .L147
	ldr	w0, [x19, 8]
	sub	w1, w0, #1
	str	w1, [x19, 8]
.L148:
	cmp	w0, 1
	beq	.L307
.L144:
	cbz	x25, .L151
	add	x1, x25, 8
	ldar	x0, [x1]
	cmp	x0, x28
	beq	.L308
	ldr	x0, [sp, 16]
	ldrb	w0, [x0]
	cbz	w0, .L153
	ldr	w0, [x25, 8]
	sub	w1, w0, #1
	str	w1, [x25, 8]
.L154:
	cmp	w0, 1
	beq	.L309
.L151:
	ldr	x0, [sp, 96]
	cbz	x0, .L156
	ldr	x1, [sp, 112]
	sub	x1, x1, x0
	bl	_ZdlPvm
.L156:
	ldr	x0, [sp, 64]
	cbz	x0, .L157
	ldr	x1, [sp, 80]
	sub	x1, x1, x0
	bl	_ZdlPvm
.L157:
	add	x20, sp, 184
	mov	x21, 2
	sub	x20, x20, #16
	ldr	x19, [x20, 8]
	cbz	x19, .L159
	add	x1, x19, 8
	ldar	x0, [x1]
	cmp	x0, x28
	beq	.L310
.L160:
	ldr	x0, [sp, 16]
	ldrb	w0, [x0]
	cbz	w0, .L161
	ldr	w0, [x19, 8]
	sub	w1, w0, #1
	str	w1, [x19, 8]
	cmp	w0, 1
	beq	.L311
.L159:
	cmp	x21, 1
	beq	.L312
.L212:
	ldr	x19, [x20, -8]
	sub	x20, x20, #16
	mov	x21, 1
	cbz	x19, .L159
	add	x1, x19, 8
	ldar	x0, [x1]
	cmp	x0, x28
	bne	.L160
.L310:
	ldr	x1, [x19]
	str	xzr, [x19, 8]
	mov	x0, x19
	ldr	x1, [x1, 16]
	blr	x1
	ldr	x1, [x19]
	mov	x0, x19
	ldr	x1, [x1, 24]
	blr	x1
	cmp	x21, 1
	bne	.L212
	.p2align 3,,7
.L312:
	add	x26, x26, 4
	cmp	w27, 7
	bne	.L165
	ldr	x19, [sp, 8]
	mov	x1, 8194
	mov	x0, x19
.LEHB17:
	bl	_ZN4PoolC1Em
.LEHE17:
	mov	w21, 0
	mov	x0, x19
	bl	_ZNSt5arrayISt10shared_ptrISt6vectorIfSaIfEEELm2EED1Ev
.L190:
	ldr	x0, [sp, 8]
	mov	x1, 1
.LEHB18:
	bl	_ZN4PoolC1Em
.LEHE18:
	ldr	x0, [sp, 160]
	stp	xzr, xzr, [sp, 96]
	str	xzr, [sp, 112]
	cbz	x0, .L166
	add	x0, x0, 8
	ldr	w0, [x0]
	cmp	w0, 1
	beq	.L213
.L166:
	ldr	x0, [sp, 176]
	cbz	x0, .L170
	add	x0, x0, 8
	ldr	w0, [x0]
	cmp	w0, 1
	beq	.L313
.L170:
	ldr	x0, [sp, 32]
	bl	_ZNSt6vectorIfSaIfEED1Ev
	ldr	x0, [sp, 8]
	bl	_ZNSt5arrayISt10shared_ptrISt6vectorIfSaIfEEELm2EED1Ev
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	str	x0, [sp, 24]
	mov	w0, 1
.L88:
	ldr	x3, [sp, 24]
	ldr	x1, [sp, 184]
	ldr	x2, [x3]
	subs	x1, x1, x2
	mov	x2, 0
	bne	.L296
	ldp	x29, x30, [sp, 192]
	ldp	x19, x20, [sp, 208]
	ldp	x21, x22, [sp, 224]
	ldp	x23, x24, [sp, 240]
	ldp	x25, x26, [sp, 256]
	ldp	x27, x28, [sp, 272]
	ldr	d8, [sp, 288]
	add	sp, sp, 304
	.cfi_remember_state
	.cfi_restore 29
	.cfi_restore 30
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_restore 72
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L161:
	.cfi_restore_state
	mov	w0, -1
	bl	__aarch64_ldadd4_acq_rel
	cmp	w0, 1
	bne	.L159
.L311:
	mov	x0, x19
	bl	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE24_M_release_last_use_coldEv
	b	.L159
.L211:
	ldr	x24, [sp, 8]
	b	.L129
.L132:
	mov	w0, -1
	bl	__aarch64_ldadd4_acq_rel
	b	.L133
.L147:
	mov	w0, -1
	bl	__aarch64_ldadd4_acq_rel
	b	.L148
.L153:
	mov	w0, -1
	bl	__aarch64_ldadd4_acq_rel
	b	.L154
.L306:
	ldr	x1, [x19]
	str	xzr, [x19, 8]
	mov	x0, x19
	ldr	x1, [x1, 16]
	blr	x1
	ldr	x1, [x19]
	mov	x0, x19
	ldr	x1, [x1, 24]
	blr	x1
	b	.L144
.L308:
	ldr	x1, [x25]
	str	xzr, [x25, 8]
	mov	x0, x25
	ldr	x1, [x1, 16]
	blr	x1
	ldr	x1, [x25]
	mov	x0, x25
	ldr	x1, [x1, 24]
	blr	x1
	b	.L151
.L303:
	ldr	x1, [x24]
	str	xzr, [x24, 8]
	mov	x0, x24
	ldr	x1, [x1, 16]
	blr	x1
	ldr	x1, [x24]
	mov	x0, x24
	ldr	x1, [x1, 24]
	blr	x1
	b	.L126
.L307:
	mov	x0, x19
	bl	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE24_M_release_last_use_coldEv
	b	.L144
.L213:
	ldr	x19, [sp, 8]
.L167:
	mov	x2, 1
	ldr	x3, [x19]
	mov	x1, x2
	ldr	x0, [sp, 32]
.LEHB19:
	bl	_Z4packRKSt6vectorIfSaIfEEmmRS1_
.LEHE19:
	ldr	x19, [x19, 8]
	cbz	x19, .L170
	adrp	x0, :got:__libc_single_threaded
	ldr	x0, [x0, :got_lo12:__libc_single_threaded]
	ldrb	w0, [x0]
	cbz	w0, .L171
	ldr	w0, [x19, 8]
	add	w0, w0, 1
	str	w0, [x19, 8]
.L172:
	mov	x0, x19
	bl	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE10_M_releaseEv
	b	.L170
.L313:
	add	x19, sp, 168
	b	.L167
.L302:
	add	x0, sp, 168
	str	x0, [sp, 48]
.L112:
	ldr	x0, [sp, 48]
	add	x1, sp, 64
	adrp	x4, :got:__stack_chk_guard
	ldr	x4, [x4, :got_lo12:__stack_chk_guard]
	mov	x2, x19
	ldr	x3, [x0]
	mov	x0, x1
	str	x4, [sp, 24]
	str	x1, [sp, 40]
	mov	x1, x19
	str	x3, [sp, 56]
.LEHB20:
	bl	_Z4packRKSt6vectorIfSaIfEEmmRS1_
.LEHE20:
	ldr	x0, [sp, 48]
	ldr	x2, [x0, 8]
	cbz	x2, .L114
	adrp	x0, :got:__libc_single_threaded
	ldr	x0, [x0, :got_lo12:__libc_single_threaded]
	ldrb	w0, [x0]
	cbz	w0, .L115
	ldr	w0, [x2, 8]
	add	w0, w0, 1
	str	w0, [x2, 8]
.L116:
	ldr	x0, [sp, 56]
	cbz	x0, .L314
	mov	x0, x2
	bl	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE10_M_releaseEv
	b	.L108
.L210:
	ldr	x0, [sp, 8]
	str	x0, [sp, 48]
	b	.L112
.L309:
	mov	x0, x25
	bl	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE24_M_release_last_use_coldEv
	b	.L151
.L304:
	mov	x0, x24
	bl	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE24_M_release_last_use_coldEv
	b	.L126
.L139:
	add	x1, x19, 8
	mov	w0, 1
	bl	__aarch64_ldadd4_acq_rel
	b	.L138
.L107:
	add	x1, x25, 8
	mov	w0, 1
	bl	__aarch64_ldadd4_acq_rel
	b	.L106
.L114:
	ldr	x0, [sp, 56]
	cbnz	x0, .L108
	b	.L201
.L115:
	add	x1, x2, 8
	mov	w0, 1
	str	x2, [sp, 24]
	bl	__aarch64_ldadd4_acq_rel
	ldr	x2, [sp, 24]
	b	.L116
.L314:
	mov	x0, x2
	bl	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE10_M_releaseEv
	b	.L201
.L171:
	add	x1, x19, 8
	mov	w0, 1
	bl	__aarch64_ldadd4_acq_rel
	b	.L172
.L119:
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC5
	mov	x21, x0
	add	x1, x1, :lo12:.LC5
.LEHB21:
	bl	_ZNSt11logic_errorC1EPKc
.LEHE21:
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	str	x0, [sp, 24]
	mov	x2, x0
	ldr	x0, [sp, 184]
	ldr	x1, [x2]
	subs	x0, x0, x1
	mov	x1, 0
	beq	.L122
.L296:
	bl	__stack_chk_fail
.L299:
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	str	x0, [sp, 24]
	mov	x2, x0
	ldr	x0, [sp, 184]
	ldr	x1, [x2]
	subs	x0, x0, x1
	mov	x1, 0
	bne	.L296
	adrp	x0, .LC3
	add	x0, x0, :lo12:.LC3
.LEHB22:
	bl	_ZSt20__throw_length_errorPKc
.LEHE22:
.L228:
	mov	x19, x0
	mov	x20, x1
	cbz	x25, .L182
.L317:
	mov	x0, x25
	bl	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE10_M_releaseEv
.L182:
	cbnz	x24, .L315
.L184:
	ldr	x0, [sp, 32]
	bl	_ZNSt6vectorIfSaIfEED1Ev
.L185:
	ldr	x0, [sp, 40]
	bl	_ZNSt6vectorIfSaIfEED1Ev
.L186:
	ldr	x0, [sp, 8]
	bl	_ZNSt5arrayISt10shared_ptrISt6vectorIfSaIfEEELm2EED1Ev
	mov	x0, x19
	mov	x1, x20
.L187:
	cmp	x1, 1
	bne	.L316
	bl	__cxa_begin_catch
	ldr	x1, [x0]
	ldr	x1, [x1, 16]
	blr	x1
	mov	x1, x0
	adrp	x0, :got:_ZSt4cerr
	ldr	x0, [x0, :got_lo12:_ZSt4cerr]
.LEHB23:
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	mov	w1, 10
	strb	w1, [sp, 96]
	ldr	x3, [x0]
	ldr	x3, [x3, -24]
	add	x2, x0, x3
	ldr	x2, [x2, 16]
	cbz	x2, .L197
	add	x1, sp, 96
	mov	x2, 1
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.LEHE23:
	bl	__cxa_end_catch
.L320:
	mov	w0, 1
	b	.L88
.L225:
.L192:
	cmp	x1, 2
	bne	.L294
	bl	__cxa_begin_catch
	bl	__cxa_end_catch
	cbnz	w21, .L290
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	str	x0, [sp, 24]
	mov	w0, 1
	b	.L88
.L315:
	mov	x0, x24
	bl	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE10_M_releaseEv
	b	.L184
.L219:
	mov	x19, x0
	mov	x20, x1
	mov	x0, x21
	bl	__cxa_free_exception
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	str	x0, [sp, 24]
	add	x0, sp, 64
	str	x0, [sp, 40]
	add	x0, sp, 96
	str	x0, [sp, 32]
	cbnz	x25, .L317
	b	.L182
.L229:
	mov	x19, x0
	add	x0, sp, 64
	str	x0, [sp, 40]
	mov	x20, x1
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	str	x0, [sp, 24]
	mov	x24, 0
	cbnz	x25, .L317
	b	.L182
.L221:
	mov	x20, x0
	mov	x21, x1
	cbz	x19, .L180
.L319:
	mov	x0, x19
	bl	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE10_M_releaseEv
.L180:
	add	x0, sp, 64
	str	x0, [sp, 40]
	mov	x19, x20
	mov	x24, 0
	mov	x20, x21
	cbnz	x25, .L317
	b	.L182
.L224:
	mov	x2, x1
	cmp	x2, 2
	bne	.L318
	bl	__cxa_begin_catch
	mov	w21, 1
	bl	__cxa_end_catch
	b	.L190
.L318:
	mov	x1, x2
	adrp	x2, :got:__stack_chk_guard
	ldr	x2, [x2, :got_lo12:__stack_chk_guard]
	str	x2, [sp, 24]
	b	.L187
.L218:
	adrp	x2, :got:__stack_chk_guard
	ldr	x2, [x2, :got_lo12:__stack_chk_guard]
	mov	x19, x0
	add	x0, sp, 64
	str	x2, [sp, 24]
	str	x0, [sp, 40]
	mov	x20, x1
	cbnz	x24, .L315
	b	.L184
.L217:
	adrp	x2, :got:__stack_chk_guard
	ldr	x2, [x2, :got_lo12:__stack_chk_guard]
	mov	x19, x0
	mov	x20, x1
	add	x0, sp, 96
	stp	x2, x0, [sp, 24]
	b	.L184
.L222:
	mov	x20, x0
	mov	x21, x1
	mov	x0, x22
	bl	__cxa_free_exception
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	str	x0, [sp, 24]
	cbnz	x19, .L319
	b	.L180
.L216:
	adrp	x2, :got:__stack_chk_guard
	ldr	x2, [x2, :got_lo12:__stack_chk_guard]
	mov	x19, x0
	mov	x20, x1
	add	x0, sp, 64
	str	x2, [sp, 24]
	str	x0, [sp, 40]
	b	.L185
.L223:
.L294:
	adrp	x2, :got:__stack_chk_guard
	ldr	x2, [x2, :got_lo12:__stack_chk_guard]
	str	x2, [sp, 24]
	b	.L187
.L316:
	ldr	x3, [sp, 24]
	ldr	x1, [sp, 184]
	ldr	x2, [x3]
	subs	x1, x1, x2
	mov	x2, 0
	bne	.L296
.LEHB24:
	bl	_Unwind_Resume
.LEHE24:
.L197:
.LEHB25:
	bl	_ZNSo3putEc
.LEHE25:
	bl	__cxa_end_catch
	b	.L320
.L227:
	mov	x19, x0
	bl	__cxa_end_catch
	ldr	x2, [sp, 24]
	ldr	x0, [sp, 184]
	ldr	x1, [x2]
	subs	x0, x0, x1
	mov	x1, 0
	mov	x0, x19
	bne	.L296
.LEHB26:
	bl	_Unwind_Resume
.LEHE26:
.L226:
	mov	x19, x0
	mov	x20, x1
	ldr	x0, [sp, 32]
	bl	_ZNSt6vectorIfSaIfEED1Ev
	ldr	x0, [sp, 8]
	bl	_ZNSt5arrayISt10shared_ptrISt6vectorIfSaIfEEELm2EED1Ev
	mov	x0, x19
	mov	x1, x20
	b	.L192
.L215:
	mov	x19, x0
	mov	x20, x1
	b	.L186
.L122:
	adrp	x2, :got:_ZNSt11logic_errorD1Ev
	ldr	x2, [x2, :got_lo12:_ZNSt11logic_errorD1Ev]
	add	x3, sp, 64
	adrp	x1, :got:_ZTISt11logic_error
	ldr	x1, [x1, :got_lo12:_ZTISt11logic_error]
	mov	x0, x21
	str	x3, [sp, 40]
.LEHB27:
	bl	__cxa_throw
.LEHE27:
.L220:
	mov	x19, x0
	mov	x20, x1
	mov	x0, x21
	bl	__cxa_free_exception
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	str	x0, [sp, 24]
	add	x0, sp, 64
	str	x0, [sp, 40]
	cbnz	x25, .L317
	b	.L182
.L290:
	adrp	x0, :got:_ZSt4cout
	ldr	x0, [x0, :got_lo12:_ZSt4cout]
	adrp	x1, .LC7
	add	x1, x1, :lo12:.LC7
.LEHB28:
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	mov	w1, 7
	bl	_ZNSolsEi
	adrp	x1, .LC8
	add	x1, x1, :lo12:.LC8
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
.LEHE28:
	adrp	x1, :got:__stack_chk_guard
	ldr	x1, [x1, :got_lo12:__stack_chk_guard]
	mov	w0, 0
	str	x1, [sp, 24]
	b	.L88
	.cfi_endproc
.LFE6973:
	.section	.gcc_except_table
	.align	2
.LLSDA6973:
	.byte	0xff
	.byte	0x9b
	.uleb128 .LLSDATT6973-.LLSDATTD6973
.LLSDATTD6973:
	.byte	0x1
	.uleb128 .LLSDACSE6973-.LLSDACSB6973
.LLSDACSB6973:
	.uleb128 .LEHB7-.LFB6973
	.uleb128 .LEHE7-.LEHB7
	.uleb128 .L223-.LFB6973
	.uleb128 0x1
	.uleb128 .LEHB8-.LFB6973
	.uleb128 .LEHE8-.LEHB8
	.uleb128 .L215-.LFB6973
	.uleb128 0x3
	.uleb128 .LEHB9-.LFB6973
	.uleb128 .LEHE9-.LEHB9
	.uleb128 .L216-.LFB6973
	.uleb128 0x3
	.uleb128 .LEHB10-.LFB6973
	.uleb128 .LEHE10-.LEHB10
	.uleb128 .L219-.LFB6973
	.uleb128 0x3
	.uleb128 .LEHB11-.LFB6973
	.uleb128 .LEHE11-.LEHB11
	.uleb128 .L228-.LFB6973
	.uleb128 0x3
	.uleb128 .LEHB12-.LFB6973
	.uleb128 .LEHE12-.LEHB12
	.uleb128 .L218-.LFB6973
	.uleb128 0x3
	.uleb128 .LEHB13-.LFB6973
	.uleb128 .LEHE13-.LEHB13
	.uleb128 .L222-.LFB6973
	.uleb128 0x3
	.uleb128 .LEHB14-.LFB6973
	.uleb128 .LEHE14-.LEHB14
	.uleb128 .L221-.LFB6973
	.uleb128 0x3
	.uleb128 .LEHB15-.LFB6973
	.uleb128 .LEHE15-.LEHB15
	.uleb128 .L217-.LFB6973
	.uleb128 0x3
	.uleb128 .LEHB16-.LFB6973
	.uleb128 .LEHE16-.LEHB16
	.uleb128 .L229-.LFB6973
	.uleb128 0x3
	.uleb128 .LEHB17-.LFB6973
	.uleb128 .LEHE17-.LEHB17
	.uleb128 .L224-.LFB6973
	.uleb128 0x5
	.uleb128 .LEHB18-.LFB6973
	.uleb128 .LEHE18-.LEHB18
	.uleb128 .L225-.LFB6973
	.uleb128 0x5
	.uleb128 .LEHB19-.LFB6973
	.uleb128 .LEHE19-.LEHB19
	.uleb128 .L226-.LFB6973
	.uleb128 0x7
	.uleb128 .LEHB20-.LFB6973
	.uleb128 .LEHE20-.LEHB20
	.uleb128 .L228-.LFB6973
	.uleb128 0x3
	.uleb128 .LEHB21-.LFB6973
	.uleb128 .LEHE21-.LEHB21
	.uleb128 .L220-.LFB6973
	.uleb128 0x3
	.uleb128 .LEHB22-.LFB6973
	.uleb128 .LEHE22-.LEHB22
	.uleb128 .L215-.LFB6973
	.uleb128 0x3
	.uleb128 .LEHB23-.LFB6973
	.uleb128 .LEHE23-.LEHB23
	.uleb128 .L227-.LFB6973
	.uleb128 0
	.uleb128 .LEHB24-.LFB6973
	.uleb128 .LEHE24-.LEHB24
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB25-.LFB6973
	.uleb128 .LEHE25-.LEHB25
	.uleb128 .L227-.LFB6973
	.uleb128 0
	.uleb128 .LEHB26-.LFB6973
	.uleb128 .LEHE26-.LEHB26
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB27-.LFB6973
	.uleb128 .LEHE27-.LEHB27
	.uleb128 .L228-.LFB6973
	.uleb128 0x3
	.uleb128 .LEHB28-.LFB6973
	.uleb128 .LEHE28-.LEHB28
	.uleb128 .L223-.LFB6973
	.uleb128 0x1
.LLSDACSE6973:
	.byte	0x1
	.byte	0
	.byte	0
	.byte	0x7d
	.byte	0x2
	.byte	0x7b
	.byte	0
	.byte	0x7d
	.align	2
	.4byte	DW.ref._ZTISt16invalid_argument-.
	.4byte	DW.ref._ZTISt9exception-.
.LLSDATT6973:
	.section	.text.startup
	.size	main, .-main
	.weak	_ZTSSt11_Mutex_baseILN9__gnu_cxx12_Lock_policyE2EE
	.section	.rodata._ZTSSt11_Mutex_baseILN9__gnu_cxx12_Lock_policyE2EE,"aG",@progbits,_ZTSSt11_Mutex_baseILN9__gnu_cxx12_Lock_policyE2EE,comdat
	.align	3
	.type	_ZTSSt11_Mutex_baseILN9__gnu_cxx12_Lock_policyE2EE, %object
	.size	_ZTSSt11_Mutex_baseILN9__gnu_cxx12_Lock_policyE2EE, 47
_ZTSSt11_Mutex_baseILN9__gnu_cxx12_Lock_policyE2EE:
	.string	"St11_Mutex_baseILN9__gnu_cxx12_Lock_policyE2EE"
	.weak	_ZTISt11_Mutex_baseILN9__gnu_cxx12_Lock_policyE2EE
	.section	.data.rel.ro._ZTISt11_Mutex_baseILN9__gnu_cxx12_Lock_policyE2EE,"awG",@progbits,_ZTISt11_Mutex_baseILN9__gnu_cxx12_Lock_policyE2EE,comdat
	.align	3
	.type	_ZTISt11_Mutex_baseILN9__gnu_cxx12_Lock_policyE2EE, %object
	.size	_ZTISt11_Mutex_baseILN9__gnu_cxx12_Lock_policyE2EE, 16
_ZTISt11_Mutex_baseILN9__gnu_cxx12_Lock_policyE2EE:
	.xword	_ZTVN10__cxxabiv117__class_type_infoE+16
	.xword	_ZTSSt11_Mutex_baseILN9__gnu_cxx12_Lock_policyE2EE
	.weak	_ZTSSt19_Sp_make_shared_tag
	.section	.rodata._ZTSSt19_Sp_make_shared_tag,"aG",@progbits,_ZTSSt19_Sp_make_shared_tag,comdat
	.align	3
	.type	_ZTSSt19_Sp_make_shared_tag, %object
	.size	_ZTSSt19_Sp_make_shared_tag, 24
_ZTSSt19_Sp_make_shared_tag:
	.string	"St19_Sp_make_shared_tag"
	.weak	_ZTSSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE
	.section	.rodata._ZTSSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE,"aG",@progbits,_ZTSSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE,comdat
	.align	3
	.type	_ZTSSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE, %object
	.size	_ZTSSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE, 52
_ZTSSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE:
	.string	"St16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE"
	.weak	_ZTISt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE
	.section	.data.rel.ro._ZTISt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE,"awG",@progbits,_ZTISt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE,comdat
	.align	3
	.type	_ZTISt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE, %object
	.size	_ZTISt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE, 24
_ZTISt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE:
	.xword	_ZTVN10__cxxabiv120__si_class_type_infoE+16
	.xword	_ZTSSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE
	.xword	_ZTISt11_Mutex_baseILN9__gnu_cxx12_Lock_policyE2EE
	.weak	_ZTSSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE
	.section	.rodata._ZTSSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE,"aG",@progbits,_ZTSSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE,comdat
	.align	3
	.type	_ZTSSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE, %object
	.size	_ZTSSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE, 81
_ZTSSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE:
	.string	"St23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE"
	.weak	_ZTISt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE
	.section	.data.rel.ro._ZTISt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE,"awG",@progbits,_ZTISt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE,comdat
	.align	3
	.type	_ZTISt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE, %object
	.size	_ZTISt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE, 24
_ZTISt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE:
	.xword	_ZTVN10__cxxabiv120__si_class_type_infoE+16
	.xword	_ZTSSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE
	.xword	_ZTISt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE
	.weak	_ZTVSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE
	.section	.data.rel.ro.local._ZTVSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE,"awG",@progbits,_ZTVSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE,comdat
	.align	3
	.type	_ZTVSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE, %object
	.size	_ZTVSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE, 56
_ZTVSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE:
	.xword	0
	.xword	_ZTISt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE
	.xword	_ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EED1Ev
	.xword	_ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EED0Ev
	.xword	_ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE10_M_disposeEv
	.xword	_ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE10_M_destroyEv
	.xword	_ZNSt23_Sp_counted_ptr_inplaceISt6vectorIfSaIfEESaIvELN9__gnu_cxx12_Lock_policyE2EE14_M_get_deleterERKSt9type_info
	.weak	_ZZNSt19_Sp_make_shared_tag5_S_tiEvE5__tag
	.section	.rodata._ZZNSt19_Sp_make_shared_tag5_S_tiEvE5__tag,"aG",@progbits,_ZZNSt19_Sp_make_shared_tag5_S_tiEvE5__tag,comdat
	.align	3
	.type	_ZZNSt19_Sp_make_shared_tag5_S_tiEvE5__tag, %gnu_unique_object
	.size	_ZZNSt19_Sp_make_shared_tag5_S_tiEvE5__tag, 16
_ZZNSt19_Sp_make_shared_tag5_S_tiEvE5__tag:
	.zero	16
	.section	.rodata
	.align	3
	.set	.LANCHOR0,. + 0
.LC0:
	.word	0
	.word	1
	.word	3
	.word	4
	.word	5
	.word	17
	.word	8193
	.hidden	DW.ref._ZTISt16invalid_argument
	.weak	DW.ref._ZTISt16invalid_argument
	.section	.data.rel.local.DW.ref._ZTISt16invalid_argument,"awG",@progbits,DW.ref._ZTISt16invalid_argument,comdat
	.align	3
	.type	DW.ref._ZTISt16invalid_argument, %object
	.size	DW.ref._ZTISt16invalid_argument, 8
DW.ref._ZTISt16invalid_argument:
	.xword	_ZTISt16invalid_argument
	.hidden	DW.ref._ZTISt9exception
	.weak	DW.ref._ZTISt9exception
	.section	.data.rel.local.DW.ref._ZTISt9exception,"awG",@progbits,DW.ref._ZTISt9exception,comdat
	.align	3
	.type	DW.ref._ZTISt9exception, %object
	.size	DW.ref._ZTISt9exception, 8
DW.ref._ZTISt9exception:
	.xword	_ZTISt9exception
	.hidden	DW.ref.__gxx_personality_v0
	.weak	DW.ref.__gxx_personality_v0
	.section	.data.rel.local.DW.ref.__gxx_personality_v0,"awG",@progbits,DW.ref.__gxx_personality_v0,comdat
	.align	3
	.type	DW.ref.__gxx_personality_v0, %object
	.size	DW.ref.__gxx_personality_v0, 8
DW.ref.__gxx_personality_v0:
	.xword	__gxx_personality_v0
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
