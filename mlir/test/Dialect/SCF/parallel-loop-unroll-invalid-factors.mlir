// RUN: mlir-opt %s -test-parallel-loop-unrolling='unroll-factors=2,2' | FileCheck %s

// Regression for https://github.com/llvm/llvm-project/issues/222535
// Providing more unroll factors than parallel dims must not assert; the op is
// left unchanged.

// CHECK-LABEL: func.func @one_d_parallel_too_many_factors
// CHECK:         scf.parallel (%{{.*}}) =
// CHECK-SAME:      step (%{{.*}}) {
// CHECK:           memref.load
// CHECK:           scf.reduce
// CHECK-NOT:     affine.apply
func.func @one_d_parallel_too_many_factors(%arg0: memref<4xf16>, %arg1: memref<4xf16>) {
  %c1 = arith.constant 1 : index
  %c4 = arith.constant 4 : index
  %c0 = arith.constant 0 : index
  %cst = arith.constant 1.000000e+00 : f16
  scf.parallel (%iv) = (%c0) to (%c4) step (%c1) {
    %0 = memref.load %arg0[%iv] : memref<4xf16>
    %1 = arith.negf %0 : f16
    %2 = arith.addf %1, %cst : f16
    memref.store %2, %arg1[%iv] : memref<4xf16>
    scf.reduce
  }
  return
}
