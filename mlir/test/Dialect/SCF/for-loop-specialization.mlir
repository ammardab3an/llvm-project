// RUN: mlir-opt %s -scf-for-loop-specialization -split-input-file | FileCheck %s

#map0 = affine_map<()[s0, s1] -> (1024, s0 - s1)>
#map1 = affine_map<()[s0, s1] -> (64, s0 - s1)>

func.func @for(%outer: index, %A: memref<?xf32>, %B: memref<?xf32>,
          %C: memref<?xf32>, %result: memref<?xf32>) {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %d0 = memref.dim %A, %c0 : memref<?xf32>
  %b0 = affine.min #map0()[%d0, %outer]
  scf.for %i0 = %c0 to %b0 step %c1 {
    %B_elem = memref.load %B[%i0] : memref<?xf32>
    %C_elem = memref.load %C[%i0] : memref<?xf32>
    %sum_elem = arith.addf %B_elem, %C_elem : f32
    memref.store %sum_elem, %result[%i0] : memref<?xf32>
  }
  return
}

// CHECK-LABEL:   func @for(
// CHECK-SAME:              [[ARG0:%.*]]: index, [[ARG1:%.*]]: memref<?xf32>, [[ARG2:%.*]]: memref<?xf32>, [[ARG3:%.*]]: memref<?xf32>, [[ARG4:%.*]]: memref<?xf32>) {
// CHECK:           [[CST_0:%.*]] = arith.constant 0 : index
// CHECK:           [[CST_1:%.*]] = arith.constant 1 : index
// CHECK:           [[DIM_0:%.*]] = memref.dim [[ARG1]], [[CST_0]] : memref<?xf32>
// CHECK:           [[MIN:%.*]] = affine.min #{{.*}}(){{\[}}[[DIM_0]], [[ARG0]]]
// CHECK:           [[CST_1024:%.*]] = arith.constant 1024 : index
// CHECK:           [[PRED:%.*]] = arith.cmpi eq, [[MIN]], [[CST_1024]] : index
// CHECK:           scf.if [[PRED]] {
// CHECK:             scf.for [[IDX0:%.*]] = [[CST_0]] to [[CST_1024]] step [[CST_1]] {
// CHECK:               memref.store
// CHECK:             }
// CHECK:           } else {
// CHECK:             scf.for [[IDX0:%.*]] = [[CST_0]] to [[MIN]] step [[CST_1]] {
// CHECK:               memref.store
// CHECK:             }
// CHECK:           }
// CHECK:           return
// CHECK:         }

// -----

// Specializing a for loop with iter_args must yield/replace results
// (same bug class as llvm/llvm-project#205231 for scf.parallel).
#map_min = affine_map<()[s0] -> (s0, 8)>
func.func @for_with_iter_args(%n: index) -> i32 {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %c0_i32 = arith.constant 0 : i32
  %ub = affine.min #map_min()[%n]
  %sum = scf.for %i = %c0 to %ub step %c1 iter_args(%acc = %c0_i32) -> (i32) {
    %one = arith.constant 1 : i32
    %nacc = arith.addi %acc, %one : i32
    scf.yield %nacc : i32
  }
  return %sum : i32
}

// CHECK-LABEL: func @for_with_iter_args
// CHECK:         %[[IF:.*]] = scf.if {{.*}} -> (i32) {
// CHECK:           %[[THEN:.*]] = scf.for
// CHECK:           scf.yield %[[THEN]] : i32
// CHECK:         } else {
// CHECK:           %[[ELSE:.*]] = scf.for
// CHECK:           scf.yield %[[ELSE]] : i32
// CHECK:         }
// CHECK:         return %[[IF]] : i32
