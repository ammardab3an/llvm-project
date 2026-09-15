// RUN: mlir-opt %s -convert-async-to-llvm -split-input-file -verify-diagnostics

// Regression llvm/llvm-project#216213: creating !async.value of a type that
// cannot be converted to LLVM must fail gracefully, not crash in GEPOp.
func.func @create_value_tensor(%arg0: tensor<4xf32>, %arg1: tensor<4xf32>) -> !async.value<tensor<4xf32>> {
  // expected-error@+1 {{failed to legalize operation 'async.runtime.create'}}
  %0 = async.runtime.create : !async.value<tensor<4xf32>>
  return %0 : !async.value<tensor<4xf32>>
}
