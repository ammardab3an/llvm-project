// RUN: mlir-opt %s --sparse-tensor-codegen | FileCheck %s

// Regression llvm/llvm-project#211187: tensor.insert into a sparse tensor
// under llvm.func must not crash (no enclosing func.func for outlining).
#sparse = #sparse_tensor.encoding<{
  map = (d0, d1) -> (d0 : dense, d1 : compressed)
}>

// CHECK-LABEL: llvm.func @m
llvm.func @m(%arg0: f64) {
  %cst = arith.constant 0.000000e+00 : f64
  %c0 = arith.constant 0 : index
  // CHECK: sparse_tensor.storage_specifier.init
  %0 = bufferization.alloc_tensor() : tensor<128x64xf64, #sparse>
  // CHECK-NOT: tensor.insert
  %inserted = tensor.insert %cst into %0[%c0, %c0] : tensor<128x64xf64, #sparse>
  llvm.return
}
