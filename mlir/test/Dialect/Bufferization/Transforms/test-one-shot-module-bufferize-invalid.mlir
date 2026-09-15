// RUN: mlir-opt %s -test-one-shot-module-bufferize -split-input-file -verify-diagnostics

// Test that the pass fails gracefully instead of asserting inside
// `MemRefType::get` when a function signature contains a tensor whose element
// type is not a valid memref element type (e.g. an LLVM array type). See
// https://github.com/llvm/llvm-project/issues/206919.

// expected-error @below {{'func.func' op cannot bufferize tensor with element type '!llvm.array<1 x i32>': not a valid memref element type}}
func.func private @sparse_csr(tensor<f64>) -> tensor<!llvm.array<1 x i32>>

// -----

// An invalid element type on a function argument should also be rejected
// gracefully.

// expected-error @below {{'func.func' op cannot bufferize tensor with element type '!llvm.array<4 x i32>': not a valid memref element type}}
func.func private @arg_with_bad_element_type(tensor<!llvm.array<4 x i32>>) -> ()
