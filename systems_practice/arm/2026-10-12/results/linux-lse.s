	.file	"atomic_probe.cpp"
	.text
	.globl	probe_acquire                   // -- Begin function probe_acquire
	.p2align	2
	.type	probe_acquire,@function
probe_acquire:                          // @probe_acquire
	.cfi_startproc
// %bb.0:
	ldar	w0, [x0]
	ret
.Lfunc_end0:
	.size	probe_acquire, .Lfunc_end0-probe_acquire
	.cfi_endproc
                                        // -- End function
	.globl	probe_release                   // -- Begin function probe_release
	.p2align	2
	.type	probe_release,@function
probe_release:                          // @probe_release
	.cfi_startproc
// %bb.0:
	stlr	w1, [x0]
	ret
.Lfunc_end1:
	.size	probe_release, .Lfunc_end1-probe_release
	.cfi_endproc
                                        // -- End function
	.globl	probe_ticket                    // -- Begin function probe_ticket
	.p2align	2
	.type	probe_ticket,@function
probe_ticket:                           // @probe_ticket
	.cfi_startproc
// %bb.0:
	mov	w8, #1                          // =0x1
	ldadd	w8, w0, [x0]
	ret
.Lfunc_end2:
	.size	probe_ticket, .Lfunc_end2-probe_ticket
	.cfi_endproc
                                        // -- End function
	.ident	"Apple clang version 21.0.0 (clang-2100.1.1.101)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
