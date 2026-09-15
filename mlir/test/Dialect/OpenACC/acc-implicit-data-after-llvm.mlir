// RUN: mlir-opt %s -convert-openmp-to-llvm -convert-vector-to-llvm -acc-implicit-data | FileCheck %s

// Regression for https://github.com/llvm/llvm-project/issues/205284
// Running LLVM conversions before acc-implicit-data must not crash when
// generateDataClauseOpForCandidate returns null.
// CHECK-LABEL: llvm.func @acc_implicit_after_llvm_conversion
func.func @acc_implicit_after_llvm_conversion(%arg0: memref<10xf32>, %arg1: index) {
  %0 = acc.create varPtr(%arg0 : memref<10xf32>) -> memref<10xf32>
  acc.serial dataOperands(%0 : memref<10xf32>) {
    %c0 = arith.constant 0 : index
    %1 = arith.cmpi sge, %arg1, %c0 : index
    cf.assert %1, "error"
    %2 = memref.load %arg0[%arg1] : memref<10xf32>
    acc.yield
  }
  return
}
