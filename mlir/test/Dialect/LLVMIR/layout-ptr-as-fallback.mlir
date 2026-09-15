// RUN: mlir-opt %s --split-input-file --verify-diagnostics | FileCheck %s

// Nested ptr AS layout may fall back to the enclosing default (!llvm.ptr / AS0)
// entry when checking compatibility. Regression: llvm/llvm-project#222879

// CHECK: module attributes
// CHECK: !llvm.ptr = dense<32> : vector<3xi64>
// CHECK: module attributes
// CHECK: !llvm.ptr<5> = dense<32> : vector<3xi64>
module attributes {
  dlti.dl_spec = #dlti.dl_spec<!llvm.ptr = dense<[32, 32, 32]> : vector<3xi64>>
} {
  module attributes {
    dlti.dl_spec = #dlti.dl_spec<!llvm.ptr<5> = dense<[32, 32, 32]> : vector<3xi64>>
  } {
  }
}

// -----

// Mismatched size vs enclosing AS0 fallback must still be rejected.
// expected-note@below {{enclosing op with data layout}}
module attributes {
  dlti.dl_spec = #dlti.dl_spec<!llvm.ptr = dense<[64, 64, 64]> : vector<3xi64>>
} {
  // expected-error@below {{data layout does not combine with layouts of enclosing ops}}
  module attributes {
    dlti.dl_spec = #dlti.dl_spec<!llvm.ptr<5> = dense<[32, 32, 32]> : vector<3xi64>>
  } {
  }
}
