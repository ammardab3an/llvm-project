// RUN: mlir-opt %s -test-legalize-patterns="allow-pattern-rollback=0" -verify-diagnostics | FileCheck %s

// Regression for https://github.com/llvm/llvm-project/issues/222539
// Signature conversion may modify an unknown FunctionOpInterface op
// (spirv.func) that cannot be fully legalized by the test target. With
// pattern rollback disabled, that must not fatal-error; the IR is kept.

// CHECK-LABEL: spirv.func @main
// CHECK: spirv.ReturnValue
module {
  spirv.func @main(%arg0: !spirv.array<4 x f32>) -> !spirv.array<4 x f32> "None" {
    // expected-remark @+1 {{op 'spirv.ReturnValue' is not legalizable}}
    spirv.ReturnValue %arg0 : !spirv.array<4 x f32>
  }
}
