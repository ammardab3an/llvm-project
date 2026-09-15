// RUN: mlir-opt %s --sparsifier | FileCheck %s

// `arith.minsi` in a `linalg.generic` body must be modeled by the sparsifier.
// Regression: llvm/llvm-project#218097

#map = affine_map<(d0, d1) -> (d0, d1)>
#sparse = #sparse_tensor.encoding<{ map = (d0, d1) -> (d0 : compressed, d1 : compressed) }>

// CHECK-LABEL: llvm.func @main
// CHECK-NOT: linalg.generic
// CHECK-NOT: arith.minsi
func.func @main() -> tensor<2x4xi32> {
  %cst = arith.constant dense<[[4, 0, 9, 4], [0, -1, -9, 0]]> : tensor<2x4xi32>
  %c0 = arith.constant 0 : i32
  %s = sparse_tensor.convert %cst : tensor<2x4xi32> to tensor<2x4xi32, #sparse>
  %e = tensor.empty() : tensor<2x4xi32>
  %f = linalg.fill ins(%c0 : i32) outs(%e : tensor<2x4xi32>) -> tensor<2x4xi32>
  %r = linalg.generic {indexing_maps = [#map, #map], iterator_types = ["parallel", "parallel"]}
       ins(%s : tensor<2x4xi32, #sparse>) outs(%f : tensor<2x4xi32>) {
    ^bb0(%in: i32, %out: i32):
      %a = arith.minsi %in, %out : i32
      linalg.yield %a : i32
  } -> tensor<2x4xi32>
  return %r : tensor<2x4xi32>
}
