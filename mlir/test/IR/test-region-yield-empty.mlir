// RUN: mlir-opt %s | FileCheck %s
// RUN: mlir-opt %s -mlir-print-op-generic | FileCheck %s --check-prefix=GENERIC

// Regression for https://github.com/llvm/llvm-project/issues/221638
// Empty SingleBlockImplicitTerminator regions must insert a zero-operand
// test.region_yield without crashing.

// CHECK-LABEL: func @empty_cse_region
// CHECK: test.cse_of_single_block_op
func.func @empty_cse_region(%c: f32) -> f32 {
  %0 = test.cse_of_single_block_op inputs(%c) {
  ^bb0(%arg0: f32):
  } : f32 -> f32
  return %0 : f32
}

// CHECK-LABEL: func @empty_region_buffer_based
// CHECK: test.region_buffer_based
func.func @empty_region_buffer_based(%a: memref<f32>, %b: memref<f32>) {
  test.region_buffer_based in(%a : memref<f32>) out(%b : memref<f32>) {
  }
  return
}

// GENERIC-LABEL: "test.cse_of_single_block_op"
// GENERIC: "test.region_yield"() : () -> ()
// GENERIC-LABEL: "test.region_buffer_based"
// GENERIC: "test.region_yield"() : () -> ()
