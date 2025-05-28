# RepairComp

## Overview
A comprehensive comparison of Automated Program Repair (APR) tools for Solidity smart contracts.

This repository accompanies our research paper [Do Automated Fixes Truly Mitigate Smart Contract Exploits?](https://arxiv.org/pdf/2501.04600), [arXiv:2501.04600](https://arxiv.org/abs/2501.04600)

```bibtex
@techreport{2501.04600,
 title = {Do Automated Fixes Truly Mitigate Smart Contract Exploits?},
 year = {2025},
 author = {Sofia Bobadilla and Monica Jin and Martin Monperrus},
 url = {http://arxiv.org/pdf/2501.04600},
 number = {2501.04600},
 institution = {arXiv},
}
```

The sister repository is [sb-heists](https://github.com/ASSERT-KTH/sb-heists), our exploit benchmark and patch evaluator for smartbugs-curated.

## Evaluated APR Tools

- [SmartShield](https://github.com/ASSERT-KTH/SmartShield)
- [sGuard](https://github.com/ASSERT-KTH/sGuard)
- [Elysium](https://github.com/ASSERT-KTH/Elysium)
- [TIPS](https://github.com/ASSERT-KTH/TIPS)
- [SmartFix](https://github.com/ASSERT-KTH/SmartFix-Artifact)
- [SGuard+](https://github.com/ASSERT-KTH/sGuardPlus)
- [SolGPT](https://github.com/ASSERT-KTH/solgpt)

**Note**: These repos are our own forks, some of them have been modified from their original source code to add missing dependencies and fix minor errors.

Discarded tools, see <https://github.com/ASSERT-KTH/RepairComp/blob/main/results/technical-report-reproducibility.md>:

- [ContractTinker](https://github.com/ASSERT-KTH/ContractTinker)
- [Aroc](https://github.com/ASSERT-KTH/TSE-Aroc)


## Dataset

[Smartbugs-curated](https://github.com/ASSERT-KTH/smartbugs-curated) - Curated vulnerability dataset
