// RUN: mlir-opt %s | FileCheck %s

// Regression for https://github.com/llvm/llvm-project/issues/221590
// collapse_shape verification must tolerate static shapes whose element
// count overflows int64 (identical shapes still preserve element count).
// CHECK-LABEL: func @collapse_shape_int64_product_overflow
func.func @collapse_shape_int64_product_overflow(
    %arg0: tensor<4611686018427387904x2xf32>)
    -> tensor<4611686018427387904x2xf32> {
  // CHECK: tensor.collapse_shape
  %0 = tensor.collapse_shape %arg0 [[0], [1]]
      : tensor<4611686018427387904x2xf32> into tensor<4611686018427387904x2xf32>
  return %0 : tensor<4611686018427387904x2xf32>
}
