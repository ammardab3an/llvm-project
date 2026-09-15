// RUN: mlir-opt %s -pass-pipeline='builtin.module(func.func(test-scf-parallel-loop-collapsing{collapsed-indices-0=0,1}))' | FileCheck %s

// Regression for https://github.com/llvm/llvm-project/issues/216218
// Collapsing must not erase an scf.parallel whose results are still used.
// CHECK-LABEL: func @collapse_preserves_reduction_results
func.func @collapse_preserves_reduction_results() {
  %c0 = arith.constant 0 : index
  %c10 = arith.constant 10 : index
  %c1 = arith.constant 1 : index
  // CHECK: %[[R:.*]] = scf.parallel
  // CHECK: scf.reduce
  // CHECK: %[[ADD:.*]] = arith.addi %[[R]], %[[R]]
  %0 = scf.parallel (%arg0, %arg1) = (%c0, %c0) to (%c10, %c10) step (%c1, %c1) init (%c0) -> index {
    %4 = arith.addi %arg0, %arg1 : index
    scf.reduce(%4 : index) {
    ^bb0(%arg2: index, %arg3: index):
      %5 = arith.addi %arg2, %arg3 : index
      scf.reduce.return %5 : index
    }
  }
  %2 = arith.addi %0, %0 : index
  // CHECK: return
  return
}
