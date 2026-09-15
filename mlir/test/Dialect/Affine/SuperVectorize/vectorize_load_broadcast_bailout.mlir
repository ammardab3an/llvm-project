// RUN: mlir-opt %s -affine-super-vectorize="virtual-vector-size=32,256" | FileCheck %s

// Regression for https://github.com/llvm/llvm-project/issues/220566
// Loads whose indices reuse an IV produce a broadcast result in the
// permutation map; result count then diverges from the strategy vector rank.
// Vectorization must bail out instead of asserting in createReadOrMaskedRead.

// CHECK-LABEL: func.func @load_broadcast_perm_map_unsupported
// CHECK:         affine.for
// CHECK:           affine.for
// CHECK:             affine.for
// CHECK:               affine.for
// CHECK:                 affine.load
// CHECK:                 affine.load
// CHECK:                 affine.store
// CHECK-NOT:     vector.transfer_read
func.func @load_broadcast_perm_map_unsupported() {
  %alloc = memref.alloc() : memref<1x8x8x64xf32>
  %alloc_0 = memref.alloc() : memref<1x18x18x64xf32>
  affine.for %arg0 = 0 to 1 {
    affine.for %arg1 = 0 to 8 {
      affine.for %arg2 = 0 to 64 {
        affine.for %arg3 = 0 to 1 {
          %0 = affine.load %alloc[%arg0, %arg0, %arg1, %arg2] : memref<1x8x8x64xf32>
          %1 = affine.load %alloc_0[%arg0, %arg0 * 2, %arg1 * 2, %arg2] : memref<1x18x18x64xf32>
          %2 = arith.cmpf ogt, %0, %1 : f32
          %3 = arith.select %2, %0, %1 : f32
          affine.store %3, %alloc[%arg0, %arg0, %arg1, %arg2] : memref<1x8x8x64xf32>
        }
      }
    }
  }
  return
}
