; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S %s -scalarize-masked-mem-intrin -mtriple=x86_64-linux-gnu | FileCheck %s

define void @scalarize_v2i64(i64* %p, <2 x i1> %mask, <2 x i64> %data) {
; CHECK-LABEL: @scalarize_v2i64(
; CHECK-NEXT:    [[SCALAR_MASK:%.*]] = bitcast <2 x i1> [[MASK:%.*]] to i2
; CHECK-NEXT:    [[TMP1:%.*]] = and i2 [[SCALAR_MASK]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ne i2 [[TMP1]], 0
; CHECK-NEXT:    br i1 [[TMP2]], label [[COND_STORE:%.*]], label [[ELSE:%.*]]
; CHECK:       cond.store:
; CHECK-NEXT:    [[TMP3:%.*]] = extractelement <2 x i64> [[DATA:%.*]], i64 0
; CHECK-NEXT:    store i64 [[TMP3]], i64* [[P:%.*]], align 1
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i64, i64* [[P]], i32 1
; CHECK-NEXT:    br label [[ELSE]]
; CHECK:       else:
; CHECK-NEXT:    [[PTR_PHI_ELSE:%.*]] = phi i64* [ [[TMP4]], [[COND_STORE]] ], [ [[P]], [[TMP0:%.*]] ]
; CHECK-NEXT:    [[TMP5:%.*]] = and i2 [[SCALAR_MASK]], -2
; CHECK-NEXT:    [[TMP6:%.*]] = icmp ne i2 [[TMP5]], 0
; CHECK-NEXT:    br i1 [[TMP6]], label [[COND_STORE1:%.*]], label [[ELSE2:%.*]]
; CHECK:       cond.store1:
; CHECK-NEXT:    [[TMP7:%.*]] = extractelement <2 x i64> [[DATA]], i64 1
; CHECK-NEXT:    store i64 [[TMP7]], i64* [[PTR_PHI_ELSE]], align 1
; CHECK-NEXT:    br label [[ELSE2]]
; CHECK:       else2:
; CHECK-NEXT:    ret void
;
  call void @llvm.masked.compressstore.v2i64.p0v2i64(<2 x i64> %data, i64* %p, <2 x i1> %mask)
  ret void
}

define void @scalarize_v2i64_ones_mask(i64* %p, <2 x i64> %data) {
; CHECK-LABEL: @scalarize_v2i64_ones_mask(
; CHECK-NEXT:    [[ELT0:%.*]] = extractelement <2 x i64> [[DATA:%.*]], i64 0
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i64, i64* [[P:%.*]], i32 0
; CHECK-NEXT:    store i64 [[ELT0]], i64* [[TMP1]], align 1
; CHECK-NEXT:    [[ELT1:%.*]] = extractelement <2 x i64> [[DATA]], i64 1
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i64, i64* [[P]], i32 1
; CHECK-NEXT:    store i64 [[ELT1]], i64* [[TMP2]], align 1
; CHECK-NEXT:    ret void
;
  call void @llvm.masked.compressstore.v2i64.p0v2i64(<2 x i64> %data, i64* %p, <2 x i1> <i1 true, i1 true>)
  ret void
}

define void @scalarize_v2i64_zero_mask(i64* %p, <2 x i64> %data) {
; CHECK-LABEL: @scalarize_v2i64_zero_mask(
; CHECK-NEXT:    ret void
;
  call void @llvm.masked.compressstore.v2i64.p0v2i64(<2 x i64> %data, i64* %p, <2 x i1> <i1 false, i1 false>)
  ret void
}

define void @scalarize_v2i64_const_mask(i64* %p, <2 x i64> %data) {
; CHECK-LABEL: @scalarize_v2i64_const_mask(
; CHECK-NEXT:    [[ELT1:%.*]] = extractelement <2 x i64> [[DATA:%.*]], i64 1
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i64, i64* [[P:%.*]], i32 0
; CHECK-NEXT:    store i64 [[ELT1]], i64* [[TMP1]], align 1
; CHECK-NEXT:    ret void
;
  call void @llvm.masked.compressstore.v2i64.p0v2i64(<2 x i64> %data, i64* %p, <2 x i1> <i1 false, i1 true>)
  ret void
}

declare void @llvm.masked.compressstore.v2i64.p0v2i64(<2 x i64>, i64*, <2 x i1>)
