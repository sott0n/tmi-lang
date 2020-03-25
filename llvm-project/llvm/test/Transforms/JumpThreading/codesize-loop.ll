; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -jump-threading -S %s -o - | FileCheck %s --check-prefix=DEFAULT
; RUN: opt -jump-threading -S -jump-threading-threshold=6 %s -o - | FileCheck %s --check-prefix=OVERIDE

@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
define i32 @test_minsize(i32 %argc, i8** nocapture readonly %argv) local_unnamed_addr #0 {
; DEFAULT-LABEL: @test_minsize(
; DEFAULT-NEXT:  entry:
; DEFAULT-NEXT:    [[CMP:%.*]] = icmp eq i32 [[ARGC:%.*]], 2
; DEFAULT-NEXT:    br i1 [[CMP]], label [[COND_TRUE:%.*]], label [[COND_END:%.*]]
; DEFAULT:       cond.true:
; DEFAULT-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i8*, i8** [[ARGV:%.*]], i32 1
; DEFAULT-NEXT:    [[TMP0:%.*]] = load i8*, i8** [[ARRAYIDX]], align 4
; DEFAULT-NEXT:    [[CALL:%.*]] = tail call i32 @atoi(i8* [[TMP0]])
; DEFAULT-NEXT:    br label [[COND_END]]
; DEFAULT:       cond.end:
; DEFAULT-NEXT:    [[COND:%.*]] = phi i32 [ [[CALL]], [[COND_TRUE]] ], [ 46, [[ENTRY:%.*]] ]
; DEFAULT-NEXT:    [[TMP1:%.*]] = mul i32 [[COND]], [[COND]]
; DEFAULT-NEXT:    [[TMP2:%.*]] = mul i32 [[TMP1]], [[TMP1]]
; DEFAULT-NEXT:    [[TMP3:%.*]] = mul i32 [[COND]], [[TMP2]]
; DEFAULT-NEXT:    [[TMP4:%.*]] = icmp sgt i32 [[COND]], 0
; DEFAULT-NEXT:    br i1 [[TMP4]], label [[TMP5:%.*]], label [[TMP6:%.*]]
; DEFAULT:       5:
; DEFAULT-NEXT:    br label [[TMP6]]
; DEFAULT:       6:
; DEFAULT-NEXT:    [[TMP7:%.*]] = phi i32 [ [[COND]], [[TMP5]] ], [ 0, [[COND_END]] ]
; DEFAULT-NEXT:    [[TMP8:%.*]] = mul i32 [[TMP3]], [[TMP7]]
; DEFAULT-NEXT:    [[CALL33:%.*]] = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i32 0, i32 0), i32 [[TMP8]])
; DEFAULT-NEXT:    ret i32 0
;
; OVERIDE-LABEL: @test_minsize(
; OVERIDE-NEXT:  entry:
; OVERIDE-NEXT:    [[CMP:%.*]] = icmp eq i32 [[ARGC:%.*]], 2
; OVERIDE-NEXT:    br i1 [[CMP]], label [[COND_END:%.*]], label [[COND_END_THREAD:%.*]]
; OVERIDE:       cond.end:
; OVERIDE-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i8*, i8** [[ARGV:%.*]], i32 1
; OVERIDE-NEXT:    [[TMP0:%.*]] = load i8*, i8** [[ARRAYIDX]], align 4
; OVERIDE-NEXT:    [[CALL:%.*]] = tail call i32 @atoi(i8* [[TMP0]])
; OVERIDE-NEXT:    [[TMP1:%.*]] = mul i32 [[CALL]], [[CALL]]
; OVERIDE-NEXT:    [[TMP2:%.*]] = mul i32 [[TMP1]], [[TMP1]]
; OVERIDE-NEXT:    [[TMP3:%.*]] = mul i32 [[CALL]], [[TMP2]]
; OVERIDE-NEXT:    [[TMP4:%.*]] = icmp sgt i32 [[CALL]], 0
; OVERIDE-NEXT:    br i1 [[TMP4]], label [[COND_END_THREAD]], label [[TMP6:%.*]]
; OVERIDE:       cond.end.thread:
; OVERIDE-NEXT:    [[TMP5:%.*]] = phi i32 [ [[TMP3]], [[COND_END]] ], [ 205962976, [[ENTRY:%.*]] ]
; OVERIDE-NEXT:    [[COND2:%.*]] = phi i32 [ [[CALL]], [[COND_END]] ], [ 46, [[ENTRY]] ]
; OVERIDE-NEXT:    br label [[TMP6]]
; OVERIDE:       6:
; OVERIDE-NEXT:    [[TMP7:%.*]] = phi i32 [ [[TMP5]], [[COND_END_THREAD]] ], [ [[TMP3]], [[COND_END]] ]
; OVERIDE-NEXT:    [[TMP8:%.*]] = phi i32 [ [[COND2]], [[COND_END_THREAD]] ], [ 0, [[COND_END]] ]
; OVERIDE-NEXT:    [[TMP9:%.*]] = mul i32 [[TMP7]], [[TMP8]]
; OVERIDE-NEXT:    [[CALL33:%.*]] = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i32 0, i32 0), i32 [[TMP9]])
; OVERIDE-NEXT:    ret i32 0
;
entry:
  %cmp = icmp eq i32 %argc, 2
  br i1 %cmp, label %cond.true, label %cond.end

cond.true:                                        ; preds = %entry
  %arrayidx = getelementptr inbounds i8*, i8** %argv, i32 1
  %0 = load i8*, i8** %arrayidx, align 4
  %call = tail call i32 @atoi(i8* %0)
  br label %cond.end

cond.end:                                         ; preds = %entry, %cond.true
  %cond = phi i32 [ %call, %cond.true ], [ 46, %entry ]
  %1 = mul i32 %cond, %cond
  %2 = mul i32 %1, %1
  %3 = mul i32 %cond, %2
  %4 = icmp sgt i32 %cond, 0
  %spec.select = select i1 %4, i32 %cond, i32 0
  %5 = mul i32 %3, %spec.select
  %call33 = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i32 0, i32 0), i32 %5) #4
  ret i32 0
}

define i32 @test_optsize(i32 %argc, i8** nocapture readonly %argv) local_unnamed_addr #1 {
; DEFAULT-LABEL: @test_optsize(
; DEFAULT-NEXT:  entry:
; DEFAULT-NEXT:    [[CMP:%.*]] = icmp eq i32 [[ARGC:%.*]], 2
; DEFAULT-NEXT:    br i1 [[CMP]], label [[COND_END:%.*]], label [[COND_END_THREAD:%.*]]
; DEFAULT:       cond.end:
; DEFAULT-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i8*, i8** [[ARGV:%.*]], i32 1
; DEFAULT-NEXT:    [[TMP0:%.*]] = load i8*, i8** [[ARRAYIDX]], align 4
; DEFAULT-NEXT:    [[CALL:%.*]] = tail call i32 @atoi(i8* [[TMP0]])
; DEFAULT-NEXT:    [[TMP1:%.*]] = mul i32 [[CALL]], [[CALL]]
; DEFAULT-NEXT:    [[TMP2:%.*]] = mul i32 [[TMP1]], [[TMP1]]
; DEFAULT-NEXT:    [[TMP3:%.*]] = mul i32 [[CALL]], [[TMP2]]
; DEFAULT-NEXT:    [[TMP4:%.*]] = icmp sgt i32 [[CALL]], 0
; DEFAULT-NEXT:    br i1 [[TMP4]], label [[COND_END_THREAD]], label [[TMP6:%.*]]
; DEFAULT:       cond.end.thread:
; DEFAULT-NEXT:    [[TMP5:%.*]] = phi i32 [ [[TMP3]], [[COND_END]] ], [ 205962976, [[ENTRY:%.*]] ]
; DEFAULT-NEXT:    [[COND2:%.*]] = phi i32 [ [[CALL]], [[COND_END]] ], [ 46, [[ENTRY]] ]
; DEFAULT-NEXT:    br label [[TMP6]]
; DEFAULT:       6:
; DEFAULT-NEXT:    [[TMP7:%.*]] = phi i32 [ [[TMP5]], [[COND_END_THREAD]] ], [ [[TMP3]], [[COND_END]] ]
; DEFAULT-NEXT:    [[TMP8:%.*]] = phi i32 [ [[COND2]], [[COND_END_THREAD]] ], [ 0, [[COND_END]] ]
; DEFAULT-NEXT:    [[TMP9:%.*]] = mul i32 [[TMP7]], [[TMP8]]
; DEFAULT-NEXT:    [[CALL33:%.*]] = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i32 0, i32 0), i32 [[TMP9]])
; DEFAULT-NEXT:    ret i32 0
;
; OVERIDE-LABEL: @test_optsize(
; OVERIDE-NEXT:  entry:
; OVERIDE-NEXT:    [[CMP:%.*]] = icmp eq i32 [[ARGC:%.*]], 2
; OVERIDE-NEXT:    br i1 [[CMP]], label [[COND_END:%.*]], label [[COND_END_THREAD:%.*]]
; OVERIDE:       cond.end:
; OVERIDE-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i8*, i8** [[ARGV:%.*]], i32 1
; OVERIDE-NEXT:    [[TMP0:%.*]] = load i8*, i8** [[ARRAYIDX]], align 4
; OVERIDE-NEXT:    [[CALL:%.*]] = tail call i32 @atoi(i8* [[TMP0]])
; OVERIDE-NEXT:    [[TMP1:%.*]] = mul i32 [[CALL]], [[CALL]]
; OVERIDE-NEXT:    [[TMP2:%.*]] = mul i32 [[TMP1]], [[TMP1]]
; OVERIDE-NEXT:    [[TMP3:%.*]] = mul i32 [[CALL]], [[TMP2]]
; OVERIDE-NEXT:    [[TMP4:%.*]] = icmp sgt i32 [[CALL]], 0
; OVERIDE-NEXT:    br i1 [[TMP4]], label [[COND_END_THREAD]], label [[TMP6:%.*]]
; OVERIDE:       cond.end.thread:
; OVERIDE-NEXT:    [[TMP5:%.*]] = phi i32 [ [[TMP3]], [[COND_END]] ], [ 205962976, [[ENTRY:%.*]] ]
; OVERIDE-NEXT:    [[COND2:%.*]] = phi i32 [ [[CALL]], [[COND_END]] ], [ 46, [[ENTRY]] ]
; OVERIDE-NEXT:    br label [[TMP6]]
; OVERIDE:       6:
; OVERIDE-NEXT:    [[TMP7:%.*]] = phi i32 [ [[TMP5]], [[COND_END_THREAD]] ], [ [[TMP3]], [[COND_END]] ]
; OVERIDE-NEXT:    [[TMP8:%.*]] = phi i32 [ [[COND2]], [[COND_END_THREAD]] ], [ 0, [[COND_END]] ]
; OVERIDE-NEXT:    [[TMP9:%.*]] = mul i32 [[TMP7]], [[TMP8]]
; OVERIDE-NEXT:    [[CALL33:%.*]] = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i32 0, i32 0), i32 [[TMP9]])
; OVERIDE-NEXT:    ret i32 0
;
entry:
  %cmp = icmp eq i32 %argc, 2
  br i1 %cmp, label %cond.true, label %cond.end

cond.true:                                        ; preds = %entry
  %arrayidx = getelementptr inbounds i8*, i8** %argv, i32 1
  %0 = load i8*, i8** %arrayidx, align 4
  %call = tail call i32 @atoi(i8* %0)
  br label %cond.end

cond.end:                                         ; preds = %entry, %cond.true
  %cond = phi i32 [ %call, %cond.true ], [ 46, %entry ]
  %1 = mul i32 %cond, %cond
  %2 = mul i32 %1, %1
  %3 = mul i32 %cond, %2
  %4 = icmp sgt i32 %cond, 0
  %spec.select = select i1 %4, i32 %cond, i32 0
  %5 = mul i32 %3, %spec.select
  %call33 = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i32 0, i32 0), i32 %5) #4
  ret i32 0
}
declare i32 @atoi(i8* nocapture) local_unnamed_addr
declare i32 @printf(i8* nocapture readonly, ...) local_unnamed_addr

attributes #0 = { minsize optsize }
attributes #1 = { optsize }

