// RUN: mlir-opt %s -test-legalize-patterns="allow-pattern-rollback=0" -verify-diagnostics | FileCheck %s

// Regression for https://github.com/llvm/llvm-project/issues/222543
// Folding an unknown-dialect op (not marked illegal) may create new constants
// that also cannot be legalized by the test target. With pattern rollback
// disabled, that must not fatal-error; the folded IR is kept.

// CHECK-LABEL: func.func @fold_unknown_op_without_rollback
// CHECK-NOT: tosa.add
// CHECK: tosa.const
// CHECK: return
func.func @fold_unknown_op_without_rollback() -> tensor<1x8x8x3xf32> {
  // expected-remark @+1 {{op 'tosa.const' is not legalizable}}
  %0 = "tosa.const"() <{values = dense<2.000000e+00> : tensor<1x8x8x3xf32>}> : () -> tensor<1x8x8x3xf32>
  %1 = "tosa.add"(%0, %0) : (tensor<1x8x8x3xf32>, tensor<1x8x8x3xf32>) -> tensor<1x8x8x3xf32>
  // expected-remark @+1 {{op 'func.return' is not legalizable}}
  return %1 : tensor<1x8x8x3xf32>
}
