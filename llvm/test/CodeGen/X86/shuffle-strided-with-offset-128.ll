; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefix=SSE --check-prefix=SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.2 | FileCheck %s --check-prefix=SSE --check-prefix=SSE42
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=AVX --check-prefix=AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=AVX --check-prefix=AVX2 --check-prefix=AVX2-SLOW
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2,+fast-variable-shuffle | FileCheck %s --check-prefix=AVX --check-prefix=AVX2 --check-prefix=AVX2-FAST
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f | FileCheck %s --check-prefix=AVX512 --check-prefix=AVX512F
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512vl,+fast-variable-shuffle | FileCheck %s --check-prefixes=AVX512,AVX512VL
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512bw,+fast-variable-shuffle | FileCheck %s --check-prefixes=AVX512,AVX512BW
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512bw,+avx512vl,+fast-variable-shuffle | FileCheck %s --check-prefixes=AVX512,AVX512BWVL

define void @shuffle_v16i8_to_v8i8_1(<16 x i8>* %L, <8 x i8>* %S) nounwind {
; SSE2-LABEL: shuffle_v16i8_to_v8i8_1:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa (%rdi), %xmm0
; SSE2-NEXT:    psrlw $8, %xmm0
; SSE2-NEXT:    packuswb %xmm0, %xmm0
; SSE2-NEXT:    movq %xmm0, (%rsi)
; SSE2-NEXT:    retq
;
; SSE42-LABEL: shuffle_v16i8_to_v8i8_1:
; SSE42:       # %bb.0:
; SSE42-NEXT:    movdqa (%rdi), %xmm0
; SSE42-NEXT:    pshufb {{.*#+}} xmm0 = xmm0[1,3,5,7,9,11,13,15,u,u,u,u,u,u,u,u]
; SSE42-NEXT:    movq %xmm0, (%rsi)
; SSE42-NEXT:    retq
;
; AVX-LABEL: shuffle_v16i8_to_v8i8_1:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovdqa (%rdi), %xmm0
; AVX-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[1,3,5,7,9,11,13,15,u,u,u,u,u,u,u,u]
; AVX-NEXT:    vmovq %xmm0, (%rsi)
; AVX-NEXT:    retq
;
; AVX512-LABEL: shuffle_v16i8_to_v8i8_1:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[1,3,5,7,9,11,13,15,u,u,u,u,u,u,u,u]
; AVX512-NEXT:    vmovq %xmm0, (%rsi)
; AVX512-NEXT:    retq
  %vec = load <16 x i8>, <16 x i8>* %L
  %strided.vec = shufflevector <16 x i8> %vec, <16 x i8> undef, <8 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15>
  store <8 x i8> %strided.vec, <8 x i8>* %S
  ret void
}

define void @shuffle_v8i16_to_v4i16_1(<8 x i16>* %L, <4 x i16>* %S) nounwind {
; SSE2-LABEL: shuffle_v8i16_to_v4i16_1:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pshuflw {{.*#+}} xmm0 = mem[3,1,2,3,4,5,6,7]
; SSE2-NEXT:    pshufhw {{.*#+}} xmm0 = xmm0[0,1,2,3,7,5,6,7]
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; SSE2-NEXT:    pshuflw {{.*#+}} xmm0 = xmm0[1,0,3,2,4,5,6,7]
; SSE2-NEXT:    movq %xmm0, (%rsi)
; SSE2-NEXT:    retq
;
; SSE42-LABEL: shuffle_v8i16_to_v4i16_1:
; SSE42:       # %bb.0:
; SSE42-NEXT:    movdqa (%rdi), %xmm0
; SSE42-NEXT:    pshufb {{.*#+}} xmm0 = xmm0[2,3,6,7,10,11,14,15,u,u,u,u,u,u,u,u]
; SSE42-NEXT:    movq %xmm0, (%rsi)
; SSE42-NEXT:    retq
;
; AVX-LABEL: shuffle_v8i16_to_v4i16_1:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovdqa (%rdi), %xmm0
; AVX-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[2,3,6,7,10,11,14,15,u,u,u,u,u,u,u,u]
; AVX-NEXT:    vmovq %xmm0, (%rsi)
; AVX-NEXT:    retq
;
; AVX512-LABEL: shuffle_v8i16_to_v4i16_1:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[2,3,6,7,10,11,14,15,u,u,u,u,u,u,u,u]
; AVX512-NEXT:    vmovq %xmm0, (%rsi)
; AVX512-NEXT:    retq
  %vec = load <8 x i16>, <8 x i16>* %L
  %strided.vec = shufflevector <8 x i16> %vec, <8 x i16> undef, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  store <4 x i16> %strided.vec, <4 x i16>* %S
  ret void
}

define void @shuffle_v4i32_to_v2i32_1(<4 x i32>* %L, <2 x i32>* %S) nounwind {
; SSE-LABEL: shuffle_v4i32_to_v2i32_1:
; SSE:       # %bb.0:
; SSE-NEXT:    pshufd {{.*#+}} xmm0 = mem[1,3,2,3]
; SSE-NEXT:    movq %xmm0, (%rsi)
; SSE-NEXT:    retq
;
; AVX-LABEL: shuffle_v4i32_to_v2i32_1:
; AVX:       # %bb.0:
; AVX-NEXT:    vpermilps {{.*#+}} xmm0 = mem[1,3,2,3]
; AVX-NEXT:    vmovlps %xmm0, (%rsi)
; AVX-NEXT:    retq
;
; AVX512-LABEL: shuffle_v4i32_to_v2i32_1:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpermilps {{.*#+}} xmm0 = mem[1,3,2,3]
; AVX512-NEXT:    vmovlps %xmm0, (%rsi)
; AVX512-NEXT:    retq
  %vec = load <4 x i32>, <4 x i32>* %L
  %strided.vec = shufflevector <4 x i32> %vec, <4 x i32> undef, <2 x i32> <i32 1, i32 3>
  store <2 x i32> %strided.vec, <2 x i32>* %S
  ret void
}

define void @shuffle_v16i8_to_v4i8_1(<16 x i8>* %L, <4 x i8>* %S) nounwind {
; SSE2-LABEL: shuffle_v16i8_to_v4i8_1:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa (%rdi), %xmm0
; SSE2-NEXT:    pxor %xmm1, %xmm1
; SSE2-NEXT:    movdqa %xmm0, %xmm2
; SSE2-NEXT:    punpckhbw {{.*#+}} xmm2 = xmm2[8],xmm1[8],xmm2[9],xmm1[9],xmm2[10],xmm1[10],xmm2[11],xmm1[11],xmm2[12],xmm1[12],xmm2[13],xmm1[13],xmm2[14],xmm1[14],xmm2[15],xmm1[15]
; SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[0,2,2,3]
; SSE2-NEXT:    pshuflw {{.*#+}} xmm2 = xmm2[1,3,2,3,4,5,6,7]
; SSE2-NEXT:    punpcklbw {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1],xmm0[2],xmm1[2],xmm0[3],xmm1[3],xmm0[4],xmm1[4],xmm0[5],xmm1[5],xmm0[6],xmm1[6],xmm0[7],xmm1[7]
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; SSE2-NEXT:    pshuflw {{.*#+}} xmm0 = xmm0[1,3,2,3,4,5,6,7]
; SSE2-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm2[0],xmm0[1],xmm2[1]
; SSE2-NEXT:    packuswb %xmm0, %xmm0
; SSE2-NEXT:    movd %xmm0, (%rsi)
; SSE2-NEXT:    retq
;
; SSE42-LABEL: shuffle_v16i8_to_v4i8_1:
; SSE42:       # %bb.0:
; SSE42-NEXT:    movdqa (%rdi), %xmm0
; SSE42-NEXT:    pshufb {{.*#+}} xmm0 = xmm0[1,5,9,13,u,u,u,u,u,u,u,u,u,u,u,u]
; SSE42-NEXT:    movd %xmm0, (%rsi)
; SSE42-NEXT:    retq
;
; AVX-LABEL: shuffle_v16i8_to_v4i8_1:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovdqa (%rdi), %xmm0
; AVX-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[1,5,9,13,u,u,u,u,u,u,u,u,u,u,u,u]
; AVX-NEXT:    vmovd %xmm0, (%rsi)
; AVX-NEXT:    retq
;
; AVX512-LABEL: shuffle_v16i8_to_v4i8_1:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[1,5,9,13,u,u,u,u,u,u,u,u,u,u,u,u]
; AVX512-NEXT:    vmovd %xmm0, (%rsi)
; AVX512-NEXT:    retq
  %vec = load <16 x i8>, <16 x i8>* %L
  %strided.vec = shufflevector <16 x i8> %vec, <16 x i8> undef, <4 x i32> <i32 1, i32 5, i32 9, i32 13>
  store <4 x i8> %strided.vec, <4 x i8>* %S
  ret void
}

define void @shuffle_v16i8_to_v4i8_2(<16 x i8>* %L, <4 x i8>* %S) nounwind {
; SSE2-LABEL: shuffle_v16i8_to_v4i8_2:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa (%rdi), %xmm0
; SSE2-NEXT:    pand {{.*}}(%rip), %xmm0
; SSE2-NEXT:    pshuflw {{.*#+}} xmm0 = xmm0[3,1,2,3,4,5,6,7]
; SSE2-NEXT:    pshufhw {{.*#+}} xmm0 = xmm0[0,1,2,3,7,5,6,7]
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; SSE2-NEXT:    pshuflw {{.*#+}} xmm0 = xmm0[1,0,3,2,4,5,6,7]
; SSE2-NEXT:    packuswb %xmm0, %xmm0
; SSE2-NEXT:    movd %xmm0, (%rsi)
; SSE2-NEXT:    retq
;
; SSE42-LABEL: shuffle_v16i8_to_v4i8_2:
; SSE42:       # %bb.0:
; SSE42-NEXT:    movdqa (%rdi), %xmm0
; SSE42-NEXT:    pshufb {{.*#+}} xmm0 = xmm0[2,6,10,14,u,u,u,u,u,u,u,u,u,u,u,u]
; SSE42-NEXT:    movd %xmm0, (%rsi)
; SSE42-NEXT:    retq
;
; AVX-LABEL: shuffle_v16i8_to_v4i8_2:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovdqa (%rdi), %xmm0
; AVX-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[2,6,10,14,u,u,u,u,u,u,u,u,u,u,u,u]
; AVX-NEXT:    vmovd %xmm0, (%rsi)
; AVX-NEXT:    retq
;
; AVX512-LABEL: shuffle_v16i8_to_v4i8_2:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[2,6,10,14,u,u,u,u,u,u,u,u,u,u,u,u]
; AVX512-NEXT:    vmovd %xmm0, (%rsi)
; AVX512-NEXT:    retq
  %vec = load <16 x i8>, <16 x i8>* %L
  %strided.vec = shufflevector <16 x i8> %vec, <16 x i8> undef, <4 x i32> <i32 2, i32 6, i32 10, i32 14>
  store <4 x i8> %strided.vec, <4 x i8>* %S
  ret void
}

define void @shuffle_v16i8_to_v4i8_3(<16 x i8>* %L, <4 x i8>* %S) nounwind {
; SSE2-LABEL: shuffle_v16i8_to_v4i8_3:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa (%rdi), %xmm0
; SSE2-NEXT:    pxor %xmm1, %xmm1
; SSE2-NEXT:    movdqa %xmm0, %xmm2
; SSE2-NEXT:    punpckhbw {{.*#+}} xmm2 = xmm2[8],xmm1[8],xmm2[9],xmm1[9],xmm2[10],xmm1[10],xmm2[11],xmm1[11],xmm2[12],xmm1[12],xmm2[13],xmm1[13],xmm2[14],xmm1[14],xmm2[15],xmm1[15]
; SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[3,1,2,3]
; SSE2-NEXT:    pshuflw {{.*#+}} xmm2 = xmm2[3,1,2,3,4,5,6,7]
; SSE2-NEXT:    punpcklbw {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1],xmm0[2],xmm1[2],xmm0[3],xmm1[3],xmm0[4],xmm1[4],xmm0[5],xmm1[5],xmm0[6],xmm1[6],xmm0[7],xmm1[7]
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[3,1,2,3]
; SSE2-NEXT:    pshuflw {{.*#+}} xmm0 = xmm0[3,1,2,3,4,5,6,7]
; SSE2-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm2[0],xmm0[1],xmm2[1]
; SSE2-NEXT:    packuswb %xmm0, %xmm0
; SSE2-NEXT:    movd %xmm0, (%rsi)
; SSE2-NEXT:    retq
;
; SSE42-LABEL: shuffle_v16i8_to_v4i8_3:
; SSE42:       # %bb.0:
; SSE42-NEXT:    movdqa (%rdi), %xmm0
; SSE42-NEXT:    pshufb {{.*#+}} xmm0 = xmm0[3,7,11,15,u,u,u,u,u,u,u,u,u,u,u,u]
; SSE42-NEXT:    movd %xmm0, (%rsi)
; SSE42-NEXT:    retq
;
; AVX-LABEL: shuffle_v16i8_to_v4i8_3:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovdqa (%rdi), %xmm0
; AVX-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[3,7,11,15,u,u,u,u,u,u,u,u,u,u,u,u]
; AVX-NEXT:    vmovd %xmm0, (%rsi)
; AVX-NEXT:    retq
;
; AVX512-LABEL: shuffle_v16i8_to_v4i8_3:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[3,7,11,15,u,u,u,u,u,u,u,u,u,u,u,u]
; AVX512-NEXT:    vmovd %xmm0, (%rsi)
; AVX512-NEXT:    retq
  %vec = load <16 x i8>, <16 x i8>* %L
  %strided.vec = shufflevector <16 x i8> %vec, <16 x i8> undef, <4 x i32> <i32 3, i32 7, i32 11, i32 15>
  store <4 x i8> %strided.vec, <4 x i8>* %S
  ret void
}

define void @shuffle_v8i16_to_v2i16_1(<8 x i16>* %L, <2 x i16>* %S) nounwind {
; SSE-LABEL: shuffle_v8i16_to_v2i16_1:
; SSE:       # %bb.0:
; SSE-NEXT:    pshufd {{.*#+}} xmm0 = mem[0,2,2,3]
; SSE-NEXT:    pshuflw {{.*#+}} xmm0 = xmm0[1,3,2,3,4,5,6,7]
; SSE-NEXT:    movd %xmm0, (%rsi)
; SSE-NEXT:    retq
;
; AVX1-LABEL: shuffle_v8i16_to_v2i16_1:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpshufd {{.*#+}} xmm0 = mem[0,2,2,3]
; AVX1-NEXT:    vpshuflw {{.*#+}} xmm0 = xmm0[1,3,2,3,4,5,6,7]
; AVX1-NEXT:    vmovd %xmm0, (%rsi)
; AVX1-NEXT:    retq
;
; AVX2-SLOW-LABEL: shuffle_v8i16_to_v2i16_1:
; AVX2-SLOW:       # %bb.0:
; AVX2-SLOW-NEXT:    vpshufd {{.*#+}} xmm0 = mem[0,2,2,3]
; AVX2-SLOW-NEXT:    vpshuflw {{.*#+}} xmm0 = xmm0[1,3,2,3,4,5,6,7]
; AVX2-SLOW-NEXT:    vmovd %xmm0, (%rsi)
; AVX2-SLOW-NEXT:    retq
;
; AVX2-FAST-LABEL: shuffle_v8i16_to_v2i16_1:
; AVX2-FAST:       # %bb.0:
; AVX2-FAST-NEXT:    vmovdqa (%rdi), %xmm0
; AVX2-FAST-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[2,3,10,11,u,u,u,u,u,u,u,u,u,u,u,u]
; AVX2-FAST-NEXT:    vmovd %xmm0, (%rsi)
; AVX2-FAST-NEXT:    retq
;
; AVX512F-LABEL: shuffle_v8i16_to_v2i16_1:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpshufd {{.*#+}} xmm0 = mem[0,2,2,3]
; AVX512F-NEXT:    vpshuflw {{.*#+}} xmm0 = xmm0[1,3,2,3,4,5,6,7]
; AVX512F-NEXT:    vmovd %xmm0, (%rsi)
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: shuffle_v8i16_to_v2i16_1:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512VL-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[2,3,10,11,u,u,u,u,u,u,u,u,u,u,u,u]
; AVX512VL-NEXT:    vmovd %xmm0, (%rsi)
; AVX512VL-NEXT:    retq
;
; AVX512BW-LABEL: shuffle_v8i16_to_v2i16_1:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512BW-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[2,3,10,11,u,u,u,u,u,u,u,u,u,u,u,u]
; AVX512BW-NEXT:    vmovd %xmm0, (%rsi)
; AVX512BW-NEXT:    retq
;
; AVX512BWVL-LABEL: shuffle_v8i16_to_v2i16_1:
; AVX512BWVL:       # %bb.0:
; AVX512BWVL-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512BWVL-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[2,3,10,11,u,u,u,u,u,u,u,u,u,u,u,u]
; AVX512BWVL-NEXT:    vmovd %xmm0, (%rsi)
; AVX512BWVL-NEXT:    retq
  %vec = load <8 x i16>, <8 x i16>* %L
  %strided.vec = shufflevector <8 x i16> %vec, <8 x i16> undef, <2 x i32> <i32 1, i32 5>
  store <2 x i16> %strided.vec, <2 x i16>* %S
  ret void
}

define void @shuffle_v8i16_to_v2i16_2(<8 x i16>* %L, <2 x i16>* %S) nounwind {
; SSE-LABEL: shuffle_v8i16_to_v2i16_2:
; SSE:       # %bb.0:
; SSE-NEXT:    pshufd {{.*#+}} xmm0 = mem[3,1,2,3]
; SSE-NEXT:    pshuflw {{.*#+}} xmm0 = xmm0[2,0,2,3,4,5,6,7]
; SSE-NEXT:    movd %xmm0, (%rsi)
; SSE-NEXT:    retq
;
; AVX1-LABEL: shuffle_v8i16_to_v2i16_2:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpshufd {{.*#+}} xmm0 = mem[3,1,2,3]
; AVX1-NEXT:    vpshuflw {{.*#+}} xmm0 = xmm0[2,0,2,3,4,5,6,7]
; AVX1-NEXT:    vmovd %xmm0, (%rsi)
; AVX1-NEXT:    retq
;
; AVX2-SLOW-LABEL: shuffle_v8i16_to_v2i16_2:
; AVX2-SLOW:       # %bb.0:
; AVX2-SLOW-NEXT:    vpshufd {{.*#+}} xmm0 = mem[3,1,2,3]
; AVX2-SLOW-NEXT:    vpshuflw {{.*#+}} xmm0 = xmm0[2,0,2,3,4,5,6,7]
; AVX2-SLOW-NEXT:    vmovd %xmm0, (%rsi)
; AVX2-SLOW-NEXT:    retq
;
; AVX2-FAST-LABEL: shuffle_v8i16_to_v2i16_2:
; AVX2-FAST:       # %bb.0:
; AVX2-FAST-NEXT:    vmovdqa (%rdi), %xmm0
; AVX2-FAST-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[4,5,12,13,u,u,u,u,u,u,u,u,u,u,u,u]
; AVX2-FAST-NEXT:    vmovd %xmm0, (%rsi)
; AVX2-FAST-NEXT:    retq
;
; AVX512F-LABEL: shuffle_v8i16_to_v2i16_2:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpshufd {{.*#+}} xmm0 = mem[3,1,2,3]
; AVX512F-NEXT:    vpshuflw {{.*#+}} xmm0 = xmm0[2,0,2,3,4,5,6,7]
; AVX512F-NEXT:    vmovd %xmm0, (%rsi)
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: shuffle_v8i16_to_v2i16_2:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512VL-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[4,5,12,13,u,u,u,u,u,u,u,u,u,u,u,u]
; AVX512VL-NEXT:    vmovd %xmm0, (%rsi)
; AVX512VL-NEXT:    retq
;
; AVX512BW-LABEL: shuffle_v8i16_to_v2i16_2:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512BW-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[4,5,12,13,u,u,u,u,u,u,u,u,u,u,u,u]
; AVX512BW-NEXT:    vmovd %xmm0, (%rsi)
; AVX512BW-NEXT:    retq
;
; AVX512BWVL-LABEL: shuffle_v8i16_to_v2i16_2:
; AVX512BWVL:       # %bb.0:
; AVX512BWVL-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512BWVL-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[4,5,12,13,u,u,u,u,u,u,u,u,u,u,u,u]
; AVX512BWVL-NEXT:    vmovd %xmm0, (%rsi)
; AVX512BWVL-NEXT:    retq
  %vec = load <8 x i16>, <8 x i16>* %L
  %strided.vec = shufflevector <8 x i16> %vec, <8 x i16> undef, <2 x i32> <i32 2, i32 6>
  store <2 x i16> %strided.vec, <2 x i16>* %S
  ret void
}

define void @shuffle_v8i16_to_v2i16_3(<8 x i16>* %L, <2 x i16>* %S) nounwind {
; SSE-LABEL: shuffle_v8i16_to_v2i16_3:
; SSE:       # %bb.0:
; SSE-NEXT:    pshufd {{.*#+}} xmm0 = mem[3,1,2,3]
; SSE-NEXT:    pshuflw {{.*#+}} xmm0 = xmm0[3,1,2,3,4,5,6,7]
; SSE-NEXT:    movd %xmm0, (%rsi)
; SSE-NEXT:    retq
;
; AVX1-LABEL: shuffle_v8i16_to_v2i16_3:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpshufd {{.*#+}} xmm0 = mem[3,1,2,3]
; AVX1-NEXT:    vpshuflw {{.*#+}} xmm0 = xmm0[3,1,2,3,4,5,6,7]
; AVX1-NEXT:    vmovd %xmm0, (%rsi)
; AVX1-NEXT:    retq
;
; AVX2-SLOW-LABEL: shuffle_v8i16_to_v2i16_3:
; AVX2-SLOW:       # %bb.0:
; AVX2-SLOW-NEXT:    vpshufd {{.*#+}} xmm0 = mem[3,1,2,3]
; AVX2-SLOW-NEXT:    vpshuflw {{.*#+}} xmm0 = xmm0[3,1,2,3,4,5,6,7]
; AVX2-SLOW-NEXT:    vmovd %xmm0, (%rsi)
; AVX2-SLOW-NEXT:    retq
;
; AVX2-FAST-LABEL: shuffle_v8i16_to_v2i16_3:
; AVX2-FAST:       # %bb.0:
; AVX2-FAST-NEXT:    vmovdqa (%rdi), %xmm0
; AVX2-FAST-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[6,7,14,15,u,u,u,u,u,u,u,u,u,u,u,u]
; AVX2-FAST-NEXT:    vmovd %xmm0, (%rsi)
; AVX2-FAST-NEXT:    retq
;
; AVX512F-LABEL: shuffle_v8i16_to_v2i16_3:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpshufd {{.*#+}} xmm0 = mem[3,1,2,3]
; AVX512F-NEXT:    vpshuflw {{.*#+}} xmm0 = xmm0[3,1,2,3,4,5,6,7]
; AVX512F-NEXT:    vmovd %xmm0, (%rsi)
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: shuffle_v8i16_to_v2i16_3:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512VL-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[6,7,14,15,u,u,u,u,u,u,u,u,u,u,u,u]
; AVX512VL-NEXT:    vmovd %xmm0, (%rsi)
; AVX512VL-NEXT:    retq
;
; AVX512BW-LABEL: shuffle_v8i16_to_v2i16_3:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512BW-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[6,7,14,15,u,u,u,u,u,u,u,u,u,u,u,u]
; AVX512BW-NEXT:    vmovd %xmm0, (%rsi)
; AVX512BW-NEXT:    retq
;
; AVX512BWVL-LABEL: shuffle_v8i16_to_v2i16_3:
; AVX512BWVL:       # %bb.0:
; AVX512BWVL-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512BWVL-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[6,7,14,15,u,u,u,u,u,u,u,u,u,u,u,u]
; AVX512BWVL-NEXT:    vmovd %xmm0, (%rsi)
; AVX512BWVL-NEXT:    retq
  %vec = load <8 x i16>, <8 x i16>* %L
  %strided.vec = shufflevector <8 x i16> %vec, <8 x i16> undef, <2 x i32> <i32 3, i32 7>
  store <2 x i16> %strided.vec, <2 x i16>* %S
  ret void
}

define void @shuffle_v16i8_to_v2i8_1(<16 x i8>* %L, <2 x i8>* %S) nounwind {
; SSE2-LABEL: shuffle_v16i8_to_v2i8_1:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa (%rdi), %xmm0
; SSE2-NEXT:    pxor %xmm1, %xmm1
; SSE2-NEXT:    movdqa %xmm0, %xmm2
; SSE2-NEXT:    punpckhbw {{.*#+}} xmm2 = xmm2[8],xmm1[8],xmm2[9],xmm1[9],xmm2[10],xmm1[10],xmm2[11],xmm1[11],xmm2[12],xmm1[12],xmm2[13],xmm1[13],xmm2[14],xmm1[14],xmm2[15],xmm1[15]
; SSE2-NEXT:    punpcklbw {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1],xmm0[2],xmm1[2],xmm0[3],xmm1[3],xmm0[4],xmm1[4],xmm0[5],xmm1[5],xmm0[6],xmm1[6],xmm0[7],xmm1[7]
; SSE2-NEXT:    punpcklwd {{.*#+}} xmm0 = xmm0[0],xmm2[0],xmm0[1],xmm2[1],xmm0[2],xmm2[2],xmm0[3],xmm2[3]
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,1,1]
; SSE2-NEXT:    packuswb %xmm0, %xmm0
; SSE2-NEXT:    movd %xmm0, %eax
; SSE2-NEXT:    movw %ax, (%rsi)
; SSE2-NEXT:    retq
;
; SSE42-LABEL: shuffle_v16i8_to_v2i8_1:
; SSE42:       # %bb.0:
; SSE42-NEXT:    movdqa (%rdi), %xmm0
; SSE42-NEXT:    pshufb {{.*#+}} xmm0 = xmm0[1,9,u,u,u,u,u,u,u,u,u,u,u,u,u,u]
; SSE42-NEXT:    pextrw $0, %xmm0, (%rsi)
; SSE42-NEXT:    retq
;
; AVX-LABEL: shuffle_v16i8_to_v2i8_1:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovdqa (%rdi), %xmm0
; AVX-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[1,9,u,u,u,u,u,u,u,u,u,u,u,u,u,u]
; AVX-NEXT:    vpextrw $0, %xmm0, (%rsi)
; AVX-NEXT:    retq
;
; AVX512-LABEL: shuffle_v16i8_to_v2i8_1:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[1,9,u,u,u,u,u,u,u,u,u,u,u,u,u,u]
; AVX512-NEXT:    vpextrw $0, %xmm0, (%rsi)
; AVX512-NEXT:    retq
  %vec = load <16 x i8>, <16 x i8>* %L
  %strided.vec = shufflevector <16 x i8> %vec, <16 x i8> undef, <2 x i32> <i32 1, i32 9>
  store <2 x i8> %strided.vec, <2 x i8>* %S
  ret void
}

define void @shuffle_v16i8_to_v2i8_2(<16 x i8>* %L, <2 x i8>* %S) nounwind {
; SSE2-LABEL: shuffle_v16i8_to_v2i8_2:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa (%rdi), %xmm0
; SSE2-NEXT:    pand {{.*}}(%rip), %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; SSE2-NEXT:    pshuflw {{.*#+}} xmm0 = xmm0[1,3,2,3,4,5,6,7]
; SSE2-NEXT:    packuswb %xmm0, %xmm0
; SSE2-NEXT:    movd %xmm0, %eax
; SSE2-NEXT:    movw %ax, (%rsi)
; SSE2-NEXT:    retq
;
; SSE42-LABEL: shuffle_v16i8_to_v2i8_2:
; SSE42:       # %bb.0:
; SSE42-NEXT:    movdqa (%rdi), %xmm0
; SSE42-NEXT:    pshufb {{.*#+}} xmm0 = xmm0[2,10,u,u,u,u,u,u,u,u,u,u,u,u,u,u]
; SSE42-NEXT:    pextrw $0, %xmm0, (%rsi)
; SSE42-NEXT:    retq
;
; AVX-LABEL: shuffle_v16i8_to_v2i8_2:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovdqa (%rdi), %xmm0
; AVX-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[2,10,u,u,u,u,u,u,u,u,u,u,u,u,u,u]
; AVX-NEXT:    vpextrw $0, %xmm0, (%rsi)
; AVX-NEXT:    retq
;
; AVX512-LABEL: shuffle_v16i8_to_v2i8_2:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[2,10,u,u,u,u,u,u,u,u,u,u,u,u,u,u]
; AVX512-NEXT:    vpextrw $0, %xmm0, (%rsi)
; AVX512-NEXT:    retq
  %vec = load <16 x i8>, <16 x i8>* %L
  %strided.vec = shufflevector <16 x i8> %vec, <16 x i8> undef, <2 x i32> <i32 2, i32 10>
  store <2 x i8> %strided.vec, <2 x i8>* %S
  ret void
}

define void @shuffle_v16i8_to_v2i8_3(<16 x i8>* %L, <2 x i8>* %S) nounwind {
; SSE2-LABEL: shuffle_v16i8_to_v2i8_3:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa (%rdi), %xmm0
; SSE2-NEXT:    pxor %xmm1, %xmm1
; SSE2-NEXT:    movdqa %xmm0, %xmm2
; SSE2-NEXT:    punpckhbw {{.*#+}} xmm2 = xmm2[8],xmm1[8],xmm2[9],xmm1[9],xmm2[10],xmm1[10],xmm2[11],xmm1[11],xmm2[12],xmm1[12],xmm2[13],xmm1[13],xmm2[14],xmm1[14],xmm2[15],xmm1[15]
; SSE2-NEXT:    punpcklbw {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1],xmm0[2],xmm1[2],xmm0[3],xmm1[3],xmm0[4],xmm1[4],xmm0[5],xmm1[5],xmm0[6],xmm1[6],xmm0[7],xmm1[7]
; SSE2-NEXT:    punpcklwd {{.*#+}} xmm0 = xmm0[0],xmm2[0],xmm0[1],xmm2[1],xmm0[2],xmm2[2],xmm0[3],xmm2[3]
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[3,3,3,3]
; SSE2-NEXT:    packuswb %xmm0, %xmm0
; SSE2-NEXT:    movd %xmm0, %eax
; SSE2-NEXT:    movw %ax, (%rsi)
; SSE2-NEXT:    retq
;
; SSE42-LABEL: shuffle_v16i8_to_v2i8_3:
; SSE42:       # %bb.0:
; SSE42-NEXT:    movdqa (%rdi), %xmm0
; SSE42-NEXT:    pshufb {{.*#+}} xmm0 = xmm0[3,11,u,u,u,u,u,u,u,u,u,u,u,u,u,u]
; SSE42-NEXT:    pextrw $0, %xmm0, (%rsi)
; SSE42-NEXT:    retq
;
; AVX-LABEL: shuffle_v16i8_to_v2i8_3:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovdqa (%rdi), %xmm0
; AVX-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[3,11,u,u,u,u,u,u,u,u,u,u,u,u,u,u]
; AVX-NEXT:    vpextrw $0, %xmm0, (%rsi)
; AVX-NEXT:    retq
;
; AVX512-LABEL: shuffle_v16i8_to_v2i8_3:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[3,11,u,u,u,u,u,u,u,u,u,u,u,u,u,u]
; AVX512-NEXT:    vpextrw $0, %xmm0, (%rsi)
; AVX512-NEXT:    retq
  %vec = load <16 x i8>, <16 x i8>* %L
  %strided.vec = shufflevector <16 x i8> %vec, <16 x i8> undef, <2 x i32> <i32 3, i32 11>
  store <2 x i8> %strided.vec, <2 x i8>* %S
  ret void
}

define void @shuffle_v16i8_to_v2i8_4(<16 x i8>* %L, <2 x i8>* %S) nounwind {
; SSE2-LABEL: shuffle_v16i8_to_v2i8_4:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa (%rdi), %xmm0
; SSE2-NEXT:    pand {{.*}}(%rip), %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[3,1,2,3]
; SSE2-NEXT:    pshuflw {{.*#+}} xmm0 = xmm0[2,0,2,3,4,5,6,7]
; SSE2-NEXT:    packuswb %xmm0, %xmm0
; SSE2-NEXT:    movd %xmm0, %eax
; SSE2-NEXT:    movw %ax, (%rsi)
; SSE2-NEXT:    retq
;
; SSE42-LABEL: shuffle_v16i8_to_v2i8_4:
; SSE42:       # %bb.0:
; SSE42-NEXT:    movdqa (%rdi), %xmm0
; SSE42-NEXT:    pshufb {{.*#+}} xmm0 = xmm0[4,12,u,u,u,u,u,u,u,u,u,u,u,u,u,u]
; SSE42-NEXT:    pextrw $0, %xmm0, (%rsi)
; SSE42-NEXT:    retq
;
; AVX-LABEL: shuffle_v16i8_to_v2i8_4:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovdqa (%rdi), %xmm0
; AVX-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[4,12,u,u,u,u,u,u,u,u,u,u,u,u,u,u]
; AVX-NEXT:    vpextrw $0, %xmm0, (%rsi)
; AVX-NEXT:    retq
;
; AVX512-LABEL: shuffle_v16i8_to_v2i8_4:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[4,12,u,u,u,u,u,u,u,u,u,u,u,u,u,u]
; AVX512-NEXT:    vpextrw $0, %xmm0, (%rsi)
; AVX512-NEXT:    retq
  %vec = load <16 x i8>, <16 x i8>* %L
  %strided.vec = shufflevector <16 x i8> %vec, <16 x i8> undef, <2 x i32> <i32 4, i32 12>
  store <2 x i8> %strided.vec, <2 x i8>* %S
  ret void
}

define void @shuffle_v16i8_to_v2i8_5(<16 x i8>* %L, <2 x i8>* %S) nounwind {
; SSE2-LABEL: shuffle_v16i8_to_v2i8_5:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa (%rdi), %xmm0
; SSE2-NEXT:    pxor %xmm1, %xmm1
; SSE2-NEXT:    movdqa %xmm0, %xmm2
; SSE2-NEXT:    punpckhbw {{.*#+}} xmm2 = xmm2[8],xmm1[8],xmm2[9],xmm1[9],xmm2[10],xmm1[10],xmm2[11],xmm1[11],xmm2[12],xmm1[12],xmm2[13],xmm1[13],xmm2[14],xmm1[14],xmm2[15],xmm1[15]
; SSE2-NEXT:    punpcklbw {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1],xmm0[2],xmm1[2],xmm0[3],xmm1[3],xmm0[4],xmm1[4],xmm0[5],xmm1[5],xmm0[6],xmm1[6],xmm0[7],xmm1[7]
; SSE2-NEXT:    punpckhwd {{.*#+}} xmm0 = xmm0[4],xmm2[4],xmm0[5],xmm2[5],xmm0[6],xmm2[6],xmm0[7],xmm2[7]
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,1,1]
; SSE2-NEXT:    packuswb %xmm0, %xmm0
; SSE2-NEXT:    movd %xmm0, %eax
; SSE2-NEXT:    movw %ax, (%rsi)
; SSE2-NEXT:    retq
;
; SSE42-LABEL: shuffle_v16i8_to_v2i8_5:
; SSE42:       # %bb.0:
; SSE42-NEXT:    movdqa (%rdi), %xmm0
; SSE42-NEXT:    pshufb {{.*#+}} xmm0 = xmm0[5,13,u,u,u,u,u,u,u,u,u,u,u,u,u,u]
; SSE42-NEXT:    pextrw $0, %xmm0, (%rsi)
; SSE42-NEXT:    retq
;
; AVX-LABEL: shuffle_v16i8_to_v2i8_5:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovdqa (%rdi), %xmm0
; AVX-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[5,13,u,u,u,u,u,u,u,u,u,u,u,u,u,u]
; AVX-NEXT:    vpextrw $0, %xmm0, (%rsi)
; AVX-NEXT:    retq
;
; AVX512-LABEL: shuffle_v16i8_to_v2i8_5:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[5,13,u,u,u,u,u,u,u,u,u,u,u,u,u,u]
; AVX512-NEXT:    vpextrw $0, %xmm0, (%rsi)
; AVX512-NEXT:    retq
  %vec = load <16 x i8>, <16 x i8>* %L
  %strided.vec = shufflevector <16 x i8> %vec, <16 x i8> undef, <2 x i32> <i32 5, i32 13>
  store <2 x i8> %strided.vec, <2 x i8>* %S
  ret void
}

define void @shuffle_v16i8_to_v2i8_6(<16 x i8>* %L, <2 x i8>* %S) nounwind {
; SSE2-LABEL: shuffle_v16i8_to_v2i8_6:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa (%rdi), %xmm0
; SSE2-NEXT:    pand {{.*}}(%rip), %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[3,1,2,3]
; SSE2-NEXT:    pshuflw {{.*#+}} xmm0 = xmm0[3,1,2,3,4,5,6,7]
; SSE2-NEXT:    packuswb %xmm0, %xmm0
; SSE2-NEXT:    movd %xmm0, %eax
; SSE2-NEXT:    movw %ax, (%rsi)
; SSE2-NEXT:    retq
;
; SSE42-LABEL: shuffle_v16i8_to_v2i8_6:
; SSE42:       # %bb.0:
; SSE42-NEXT:    movdqa (%rdi), %xmm0
; SSE42-NEXT:    pshufb {{.*#+}} xmm0 = xmm0[6,14,u,u,u,u,u,u,u,u,u,u,u,u,u,u]
; SSE42-NEXT:    pextrw $0, %xmm0, (%rsi)
; SSE42-NEXT:    retq
;
; AVX-LABEL: shuffle_v16i8_to_v2i8_6:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovdqa (%rdi), %xmm0
; AVX-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[6,14,u,u,u,u,u,u,u,u,u,u,u,u,u,u]
; AVX-NEXT:    vpextrw $0, %xmm0, (%rsi)
; AVX-NEXT:    retq
;
; AVX512-LABEL: shuffle_v16i8_to_v2i8_6:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[6,14,u,u,u,u,u,u,u,u,u,u,u,u,u,u]
; AVX512-NEXT:    vpextrw $0, %xmm0, (%rsi)
; AVX512-NEXT:    retq
  %vec = load <16 x i8>, <16 x i8>* %L
  %strided.vec = shufflevector <16 x i8> %vec, <16 x i8> undef, <2 x i32> <i32 6, i32 14>
  store <2 x i8> %strided.vec, <2 x i8>* %S
  ret void
}

define void @shuffle_v16i8_to_v2i8_7(<16 x i8>* %L, <2 x i8>* %S) nounwind {
; SSE2-LABEL: shuffle_v16i8_to_v2i8_7:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa (%rdi), %xmm0
; SSE2-NEXT:    pxor %xmm1, %xmm1
; SSE2-NEXT:    movdqa %xmm0, %xmm2
; SSE2-NEXT:    punpcklbw {{.*#+}} xmm2 = xmm2[0],xmm1[0],xmm2[1],xmm1[1],xmm2[2],xmm1[2],xmm2[3],xmm1[3],xmm2[4],xmm1[4],xmm2[5],xmm1[5],xmm2[6],xmm1[6],xmm2[7],xmm1[7]
; SSE2-NEXT:    psrlw $8, %xmm0
; SSE2-NEXT:    punpckhwd {{.*#+}} xmm2 = xmm2[4],xmm0[4],xmm2[5],xmm0[5],xmm2[6],xmm0[6],xmm2[7],xmm0[7]
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm2[3,3,3,3]
; SSE2-NEXT:    packuswb %xmm0, %xmm0
; SSE2-NEXT:    movd %xmm0, %eax
; SSE2-NEXT:    movw %ax, (%rsi)
; SSE2-NEXT:    retq
;
; SSE42-LABEL: shuffle_v16i8_to_v2i8_7:
; SSE42:       # %bb.0:
; SSE42-NEXT:    movdqa (%rdi), %xmm0
; SSE42-NEXT:    pshufb {{.*#+}} xmm0 = xmm0[7,15,u,u,u,u,u,u,u,u,u,u,u,u,u,u]
; SSE42-NEXT:    pextrw $0, %xmm0, (%rsi)
; SSE42-NEXT:    retq
;
; AVX-LABEL: shuffle_v16i8_to_v2i8_7:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovdqa (%rdi), %xmm0
; AVX-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[7,15,u,u,u,u,u,u,u,u,u,u,u,u,u,u]
; AVX-NEXT:    vpextrw $0, %xmm0, (%rsi)
; AVX-NEXT:    retq
;
; AVX512-LABEL: shuffle_v16i8_to_v2i8_7:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqa (%rdi), %xmm0
; AVX512-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[7,15,u,u,u,u,u,u,u,u,u,u,u,u,u,u]
; AVX512-NEXT:    vpextrw $0, %xmm0, (%rsi)
; AVX512-NEXT:    retq
  %vec = load <16 x i8>, <16 x i8>* %L
  %strided.vec = shufflevector <16 x i8> %vec, <16 x i8> undef, <2 x i32> <i32 7, i32 15>
  store <2 x i8> %strided.vec, <2 x i8>* %S
  ret void
}

