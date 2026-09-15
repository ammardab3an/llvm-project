// RUN: mlir-opt %s -pass-pipeline='builtin.module(func.func(affine-loop-tile{tile-size=8}, affine-loop-fusion))' -split-input-file -verify-diagnostics | FileCheck %s

// Regression test for https://github.com/llvm/llvm-project/issues/212046
// Sibling fusion must not fuse a loop nest that returns values, because the
// sibling loop nest is erased after fusion and its results' external uses
// would be left dangling (assertion failure / segfault). After tiling, the
// two reduction loops below become sibling candidates that both produce
// results used by `arith.addi`; neither should be fused.

// CHECK-LABEL: func @sibling_fusion_skip_result_producing_loops
func.func @sibling_fusion_skip_result_producing_loops() -> i64 {
  %A = memref.alloc() : memref<4xi64>
  %B = memref.alloc() : memref<4xi64>
  %C = memref.alloc() : memref<4xi64>

  affine.for %i = 0 to 4 {
    %a = arith.constant 3 : i64
    affine.store %a, %A[%i] : memref<4xi64>
  }
  %z0 = arith.constant 0 : i64
  affine.for %i = 0 to 4 {
    affine.store %z0, %B[%i] : memref<4xi64>
  }
  %z1 = arith.constant 0 : i64
  affine.for %i = 0 to 4 {
    affine.store %z1, %C[%i] : memref<4xi64>
  }
  affine.for %i = 0 to 4 {
    %v = affine.load %A[%i] : memref<4xi64>
    %k = arith.constant 3 : i64
    %p = arith.muli %v, %k : i64
    affine.store %p, %B[%i] : memref<4xi64>
  }
  affine.for %i = 0 to 4 {
    %v = affine.load %B[%i] : memref<4xi64>
    %k = arith.constant 7 : i64
    %q = arith.addi %v, %k : i64
    affine.store %q, %C[%i] : memref<4xi64>
  }
  %za = arith.constant 0 : i64
  // Both result-producing reduction loops must survive (not fused/erased).
  // CHECK: %[[S0:.*]] = affine.for
  %s0 = affine.for %i = 0 to 4
      iter_args(%a = %za) -> (i64) {
    %v = affine.load %B[%i] : memref<4xi64>
    %na = arith.addi %a, %v : i64
    affine.yield %na : i64
  }
  %zb = arith.constant 0 : i64
  // CHECK: %[[S1:.*]] = affine.for
  %s1 = affine.for %i = 0 to 4
      iter_args(%a = %zb) -> (i64) {
    %v = affine.load %C[%i] : memref<4xi64>
    %na = arith.addi %a, %v : i64
    affine.yield %na : i64
  }
  // CHECK: %[[SUM:.*]] = arith.addi %[[S0]], %[[S1]] : i64
  %sum = arith.addi %s0, %s1 : i64
  memref.dealloc %A : memref<4xi64>
  memref.dealloc %B : memref<4xi64>
  memref.dealloc %C : memref<4xi64>
  // CHECK: return %[[SUM]] : i64
  return %sum : i64
}
