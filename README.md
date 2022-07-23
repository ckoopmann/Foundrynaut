## Issues
- No transaction specific gas limits  (Gatekeeper)
- Simulation treats transactions as if they are all on the same block even when using --slow (CoinFlip)
- Sending funds with selfdestruct to tx.origin leads to stack overflow
