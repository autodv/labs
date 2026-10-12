# AutoDV formal verification labs — starter files

Starter files for the six hands-on formal verification labs at
<https://autodv.github.io/labs/>: four model-checking labs with SymbiYosys and
two equivalence-checking labs with EQY, all on the open-source
[OSS CAD Suite](https://github.com/YosysHQ/oss-cad-suite-build).

| Folder | Lab | Track |
| --- | --- | --- |
| `lab-1` | Your First Formal Testbench (saturating counter) | Model checking |
| `lab-2` | Proving a FIFO: Induction and Invariants | Model checking |
| `lab-3` | Arbiter Fairness, Covers and Vacuity | Model checking |
| `lab-4` | Valid/Ready Interfaces, Data Integrity and Engines | Model checking |
| `lab-5` | Equivalence Checking: RTL vs Refactored RTL | Equivalence checking |
| `lab-6` | Equivalence Checking: RTL vs Synthesized Netlist | Equivalence checking |

## Getting started

1. Install the OSS CAD Suite and put its `bin` directory on your `PATH`
   (see the [Lab environment](https://autodv.github.io/lab-environment/) page).
2. Clone this repository (or fork it first to keep your answers on GitHub):

   ```bash
   git clone https://github.com/autodv/labs.git
   cd labs/lab-1
   sby -f updown_counter.sby bmc
   ```

3. Follow the handout for each lab, in order.

Each folder is flat: the design, the formal testbench or EQY configuration with
`TODO` markers, and the tool configuration. Tool work directories are ignored
by git.

Reference solutions and a regression script are in
[autodv/labs-solutions](https://github.com/autodv/labs-solutions). The
untouched starter is tagged `starter-v1`.
