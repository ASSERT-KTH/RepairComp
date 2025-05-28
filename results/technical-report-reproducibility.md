# Technical Report: Installation and Execution Issues in Smart Contract Analysis Tools

This report presents the results of our attempts to install and execute the set of APR tools analysed in our work. We focus specifically on tools that exhibited problems during installation or runtime. For each tool, we document the nature of the issue and the actions taken to report or communicate the problem to the respective authors.

### 1\. SCRepair

- **Installation**: Failed  
- **Execution**: Not attempted  
- **Issue**: Installation fails due to missing or unrecognized Python modules. The project's dependency declarations appear to be incomplete or outdated.  
- **Reported via**: [GitHub Issue \#2](https://github.com/xiaoly8/SCRepair/issues/2)

### 2\. DeFinery

- **Installation**: Failed  
- **Execution**: Execution runs successfully for the examples provided in the Docker image.  
- **Issue**: The CMake-based build process fails due to incompatibilities introduced by recent updates in `vcpkg`. This suggests that the tool depends on specific versions of its native dependencies and lacks forward compatibility.  
- **Reported via**: [GitHub Issue \#1](https://github.com/palinatolmach/DeFinery/issues/1)

### 3\. ContractFix

- **Installation**: Failed  
- **Execution**: Not attempted  
- **Issue**: Installation is blocked due to missing and deprecated NPM packages. This indicates that the tool's JavaScript ecosystem dependencies have not been maintained.  
- **Reported via**: [GitHub Issue \#1](https://github.com/research1132/ContractFix/issues/1)

### 4\. SmartRep

- **Installation**: Successful  
- **Execution**: Failed  
- **Issue**: The model training process terminates prematurely at batch 562 due to an unhandled exception. The logs suggest a potential issue with data handling or memory allocation.  
- **Reported via**: [GitHub Issue \#4](https://github.com/AnonymousGithub5/SmartRep/issues/4)

### 5\. ACFIX

- **Installation**: Successful  
- **Execution**: Failed  
- **Issue**: Several required Python modules are not found at runtime. Additionally, based on our testing, the tool appeared to still be under active development and was not in a stable release state.  
- **Reported via**: Email to the authors

### 6\. RLRep

- **Installation**: Successful  
- **Execution**: Failed  
- **Issues**:  
  - Missing Python modules prevent the model from executing end-to-end.  
  - During training, model parameters are not properly updated, indicating a potential flaw in the training loop logic.  
- **Reported via**:  
  - [GitHub Issue \#2](https://github.com/Anonymous123xx/RLRep/issues/2)  
  - [GitHub Issue \#5](https://github.com/Anonymous123xx/RLRep/issues/5)

### 7\. vFix

- **Installation**: Successful  
- **Execution**: Failed  
- **Issue**:   
  - The tool considers a multi-source report for vulnerabilities in a specific format, yet this format is not declared in the documentation, and it can not be inferred from the source code.  
  - The example folder only considers the source code of vulnerable smart contracts.  
- **Reported via**:  
  -  [GitHub Issue \#1](https://github.com/vfixresearch/vFix/issues/1)  
  - Email to the authors

### 8\. ContractTinker

- **Installation**: Successful  
- **Execution**: The tool executed successfully on the example projects provided within the repository.   
- Issues:  
  - Attempts to run the tool on external projects were unsuccessful due to the lack of documentation regarding the expected vulnerability report format. The tool assumes a specific project structure and report format, neither of which is specified in the usage instructions.  
  - The documented dependencies were incomplete, requiring us to manually identify and install the missing components. These have been documented in our fork of the repository ([https://github.com/ASSERT-KTH/ContractTinker](https://github.com/ASSERT-KTH/ContractTinker)) to improve reproducibility.  
  - While the tool generates a patch in the form of a JSON file containing vulnerable and patched fields, it does not automatically apply the patch to the smart contract.  
- **Reported via**:  
  - Email to the authors  
  - [Github Issue \#2](https://github.com/CheWang09/LLM4SMAPR/issues/2)

## Conclusion

This technical audit highlights recurring issues across the examined tools, particularly in dependency management and runtime stability. Several tools lack the necessary infrastructure for reproducibility, including complete installation instructions and properly maintained dependency files. We have reported all reproducible issues to the respective tool maintainers, either via GitHub or direct email, in an effort to contribute to their future development and usability.