// RUN: mlir-opt --test-emulate-narrow-int="memref-load-bitwidth=32" --verify-diagnostics %s

// Regression test for https://github.com/llvm/llvm-project/issues/208198
//
// The narrow-type-emulation type converter widens the memref element type
// (e.g. f16 -> i32) whenever its bitwidth is below `memref-load-bitwidth`, but
// the vector.transfer_read conversion pattern only handles *sub-byte* element
// types (< 8 bits). For non-sub-byte element types such as f16, the pattern
// used to hit an `assert(subByteBits < 8)` inside `fitsInMultiByteContainerTy`.
// It must instead bail out gracefully so the pass reports a legalization
// failure instead of crashing.

func.func @vector_transfer_read_f16(%arg0: memref<4x?x16xf16>, %arg1: index, %arg2: index, %arg3: index) -> () {
  %cst = arith.constant 3.0 : f16
  // expected-error @+1 {{failed to legalize operation 'vector.transfer_read'}}
  %1 = vector.transfer_read %arg0[%arg1, %arg2, %arg3], %cst : memref<4x?x16xf16>, vector<8xf16>
  return
}
