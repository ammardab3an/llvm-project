// RUN: mlir-opt %s --sparsifier | FileCheck %s

// `scf` nested in `affine.for` must lower (affine first, then SCF-to-CF).
// Regression: llvm/llvm-project#217895

// CHECK-LABEL: llvm.func @f
// CHECK-NOT: affine.for
func.func @f(%c: i1) -> i64 {
  %z = arith.constant 0 : i64
  %one = arith.constant 1 : i64
  %r = affine.for %i = 0 to 4 iter_args(%acc = %z) -> i64 {
    %v = scf.if %c -> i64 {
      %s = arith.addi %acc, %one : i64
      scf.yield %s : i64
    } else {
      scf.yield %acc : i64
    }
    affine.yield %v : i64
  }
  return %r : i64
}
