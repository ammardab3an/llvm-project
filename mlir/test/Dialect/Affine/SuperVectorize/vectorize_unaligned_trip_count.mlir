// RUN: mlir-opt %s -affine-super-vectorize="virtual-vector-size=4" | FileCheck %s

// When the trip count is not a multiple of the vector width, the last vector
// iteration must be masked so stores do not write past the original scalar
// iteration space. Regression: llvm/llvm-project#218120

// CHECK-LABEL: func @unaligned_trip_count
// CHECK:       affine.for %[[IV:.*]] = 0 to 6 step 4 {
// CHECK:         %[[LEFT:.*]] = affine.apply {{.*}}(%[[IV]])
// CHECK:         %[[MASK:.*]] = vector.create_mask %[[LEFT]] : vector<4xi1>
// CHECK:         vector.mask %[[MASK]] { vector.transfer_read {{.*}} {in_bounds = [true]} {{.*}} }
// CHECK:         vector.mask %[[MASK]] { vector.transfer_write {{.*}} {in_bounds = [true]} {{.*}} }
func.func @unaligned_trip_count(%m: memref<8xi32>) {
  affine.for %j = 0 to 6 {
    %v = affine.load %m[%j] : memref<8xi32>
    %w = arith.addi %v, %v : i32
    affine.store %w, %m[%j] : memref<8xi32>
  }
  return
}

// Aligned trip counts must keep unmasked in-bounds transfers.
// CHECK-LABEL: func @aligned_trip_count
// CHECK-NOT:   vector.create_mask
// CHECK:       vector.transfer_read {{.*}} {in_bounds = [true]}
// CHECK:       vector.transfer_write {{.*}} {in_bounds = [true]}
// CHECK-NOT:   vector.mask
func.func @aligned_trip_count(%m: memref<8xi32>) {
  affine.for %j = 0 to 8 {
    %v = affine.load %m[%j] : memref<8xi32>
    %w = arith.addi %v, %v : i32
    affine.store %w, %m[%j] : memref<8xi32>
  }
  return
}
