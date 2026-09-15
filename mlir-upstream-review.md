# Fork PRs to review (upstream order)

**Do not merge this PR.** It is only a checklist so review can happen
on GitHub. Tick a box and comment on the line (or on this PR) with
`submit` / `hold` / `close-on-fork`.

Re-check competition before opening an upstream PR:

```bash
gh pr list -R llvm/llvm-project --state all --search NNN
```

Same-file groups — land **one** upstream PR, then rebase the other:

- `DialectConversion.cpp` — #40 and #39
- `LoopFusion.cpp` — #20 and #49
- `SuperVectorize.cpp` — #27 and #31

---

## A — review first (no live competitor, production)

- [ ] 1. [ammardab3an#42](https://github.com/ammardab3an/llvm-project/pull/42) — [issue 222879](https://github.com/llvm/llvm-project/issues/222879) — LLVM ptr AS0 default layout
- [ ] 2. [ammardab3an#2](https://github.com/ammardab3an/llvm-project/pull/2) — [issue 197960](https://github.com/llvm/llvm-project/issues/197960) — Inliner unanalyzable symbol uses
- [ ] 3. [ammardab3an#6](https://github.com/ammardab3an/llvm-project/pull/6) — [issue 205284](https://github.com/llvm/llvm-project/issues/205284) — ACCImplicitData null clause
- [ ] 4. [ammardab3an#13](https://github.com/ammardab3an/llvm-project/pull/13) — [issue 211187](https://github.com/llvm/llvm-project/issues/211187) — Sparse helpers under `llvm.func`
- [ ] 5. [ammardab3an#1](https://github.com/ammardab3an/llvm-project/pull/1) — [issue 189313](https://github.com/llvm/llvm-project/issues/189313) — Pack/unpack dest-cast fold
- [ ] 6. [ammardab3an#45](https://github.com/ammardab3an/llvm-project/pull/45) — [issue 223332](https://github.com/llvm/llvm-project/issues/223332) — Shard duplicate fold
- [ ] 7. [ammardab3an#21](https://github.com/ammardab3an/llvm-project/pull/21) — [issue 216630](https://github.com/llvm/llvm-project/issues/216630) — affine-data-copy dominance
- [ ] 8. [ammardab3an#28](https://github.com/ammardab3an/llvm-project/pull/28) — [issue 218853](https://github.com/llvm/llvm-project/issues/218853) — SPIR-V loop-control operands
- [ ] 9. [ammardab3an#27](https://github.com/ammardab3an/llvm-project/pull/27) — [issue 218120](https://github.com/llvm/llvm-project/issues/218120) — SuperVectorize mask stores
- [ ] 10. [ammardab3an#26](https://github.com/ammardab3an/llvm-project/pull/26) — [issue 218097](https://github.com/llvm/llvm-project/issues/218097) — Sparsifier `arith.minsi`
- [ ] 11. [ammardab3an#44](https://github.com/ammardab3an/llvm-project/pull/44) — [issue 223258](https://github.com/llvm/llvm-project/issues/223258) — Negative indices OOB
- [ ] 12. [ammardab3an#40](https://github.com/ammardab3an/llvm-project/pull/40) — [issue 222543](https://github.com/llvm/llvm-project/issues/222543) — Fold without conversion rollback
- [ ] 13. [ammardab3an#39](https://github.com/ammardab3an/llvm-project/pull/39) — [issue 222539](https://github.com/llvm/llvm-project/issues/222539) — Pattern fail without rollback
- [ ] 14. [ammardab3an#14](https://github.com/ammardab3an/llvm-project/pull/14) — [issue 211591](https://github.com/llvm/llvm-project/issues/211591) — Fusion treats unknown ops as aliasing

## B — later (weaker scope or bail-out risk)

- [ ] 15. [ammardab3an#31](https://github.com/ammardab3an/llvm-project/pull/31) — [issue 220566](https://github.com/llvm/llvm-project/issues/220566) — SuperVectorize bail on broadcast maps
- [ ] 16. [ammardab3an#32](https://github.com/ammardab3an/llvm-project/pull/32) — [issue 220570](https://github.com/llvm/llvm-project/issues/220570) — test-ir-visitors cross-block uses
- [ ] 17. [ammardab3an#35](https://github.com/ammardab3an/llvm-project/pull/35) — [issue 221638](https://github.com/llvm/llvm-project/issues/221638) — `test.region_yield` empty ([upstream #222633](https://github.com/llvm/llvm-project/pull/222633))

## C — submit only if you can defend the delta

- [ ] 18. [ammardab3an#38](https://github.com/ammardab3an/llvm-project/pull/38) — [issue 222535](https://github.com/llvm/llvm-project/issues/222535) — vs [upstream #222644](https://github.com/llvm/llvm-project/pull/222644) (we fail in `SCF/Utils`, they only fix the test pass)
- [ ] 19. [ammardab3an#5](https://github.com/ammardab3an/llvm-project/pull/5) — [issue 205231](https://github.com/llvm/llvm-project/issues/205231) — vs [upstream #212409](https://github.com/llvm/llvm-project/pull/212409) (we also keep `scf.for` results)
- [ ] 20. [ammardab3an#11](https://github.com/ammardab3an/llvm-project/pull/11) — [issue 206625](https://github.com/llvm/llvm-project/issues/206625) — vs [upstream #206692](https://github.com/llvm/llvm-project/pull/206692) (we cover store)
- [ ] 21. [ammardab3an#20](https://github.com/ammardab3an/llvm-project/pull/20) — [issue 216464](https://github.com/llvm/llvm-project/issues/216464) — vs [upstream #216564](https://github.com/llvm/llvm-project/pull/216564) (their v2 is CHANGES_REQUESTED)
- [ ] 22. [ammardab3an#15](https://github.com/ammardab3an/llvm-project/pull/15) — [issue 213905](https://github.com/llvm/llvm-project/issues/213905) — vs [upstream #214996](https://github.com/llvm/llvm-project/pull/214996) (CHANGES_REQUESTED; we reject the illegal combo)
- [ ] 23. [ammardab3an#49](https://github.com/ammardab3an/llvm-project/pull/49) — [issue 212046](https://github.com/llvm/llvm-project/issues/212046) — vs [upstream #212936](https://github.com/llvm/llvm-project/pull/212936) (draft, same idea; same file as #20)

## D — hold while the other PR is alive

- [ ] [ammardab3an#48](https://github.com/ammardab3an/llvm-project/pull/48) — [issue 208198](https://github.com/llvm/llvm-project/issues/208198) — hold for [upstream #208873](https://github.com/llvm/llvm-project/pull/208873) (same file, same assert)
- [ ] [ammardab3an#50](https://github.com/ammardab3an/llvm-project/pull/50) — [issue 206919](https://github.com/llvm/llvm-project/issues/206919) — hold for [upstream #208787](https://github.com/llvm/llvm-project/pull/208787) (production interface; ours is the test pass)

---

> This list was generated by an AI agent. It is not an LLVM patch.
