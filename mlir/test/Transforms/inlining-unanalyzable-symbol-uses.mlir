// RUN: mlir-opt %s --allow-unregistered-dialect -inline | FileCheck %s

// Regression test for llvm/llvm-project#197960: inliner must not assert when
// SymbolTable::getSymbolUses returns nullopt for an unanalyzable region (e.g.
// a nested region without a terminator under --allow-unregistered-dialect).

// CHECK-LABEL: func.func @f
func.func @f() {
  // CHECK: "a.b"()
  "a.b"() ({
  }) : () -> ()
  return
}
