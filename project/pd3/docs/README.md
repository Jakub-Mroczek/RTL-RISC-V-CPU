# PD3


In this PD, you are required to developed the Execute stage and the register file.
You will also need to develop a testbench.

## Probes

You will need to fill in the `signals.h` in this PD.

## Tests

You will need to pass the `test_pd3` test in this PD.

Make sure your register file module is placed in `project/pd3/design/code/register_file.v` and the module name is `register_file`.

## Testbench

You will need to update your own testbench as specified in the project manual.

Make sure that your design will not report any warning during compilation.

Make sure your testbench correctly when running with different `MEM_PATH` supplied to the `make` command.

For verilator, the command would be `make run VERILATOR=1 TEST=test_pd MEM_PATH=/path/to/memory.x`.

For verilator users, you may use `make run VERILATOR=1 TEST=test_pd MEM_PATH=/path/to/memory.x VCD=1` to get a `.vcd` file in `project/pd3/verif/sim/verilator/test_pd/`. 
Please be aware that `$dumpfile` and `$dumpvars` are not supported in verilator installed on ECE Linux Servers and calling them can lead to compilation errors.



## Submission
In `project/pd1/verif/scripts/`, use `make package VERILATOR=1` to package your code and create a `package.verilator.tar.gz`

You will need to upload the `package.verilator.tar.gz` to learn when done.

Note that you must set your simulator properly as the package name will include
information about the simulator you are using.
The tests may fail if you are not providing the proper simulator name.

