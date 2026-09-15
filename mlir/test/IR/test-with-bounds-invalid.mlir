// RUN: mlir-opt %s -split-input-file -verify-diagnostics

// Regression for https://github.com/llvm/llvm-project/issues/203855
// Mismatched bound bitwidths must be a verifier error, not an assert in
// ConstantIntRanges / int-range analysis.
func.func @mismatched_bound_widths() -> i32 {
  // expected-error @+1 {{bound attribute 'umax' width (8) does not match result type width (32)}}
  %0 = test.with_bounds {smax = 127 : i8, smin = 0 : i8, umax = 127 : ui8, umin = 0 : i32} : i32
  return %0 : i32
}
