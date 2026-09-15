// RUN: mlir-opt %s --gpu-to-llvm | FileCheck %s

// Regression llvm/llvm-project#216268: gpu-to-llvm must not crash on a
// function with !async.token and llvm.emit_c_interface. Async structural
// conversions identity-map the token type; signature/C-wrapper conversion
// must reject it rather than build an llvm.func with a null type.
module {
  // CHECK-LABEL: func.func @with_async_token
  // CHECK-SAME: !async.token
  func.func @with_async_token(%arg0: !async.token) attributes {llvm.emit_c_interface} {
    return
  }
}
