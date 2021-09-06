ghdl -s adder.vhdl
ghdl -a adder.vhdl
ghdl -e adder
ghdl -r adder --ieee-asserts=disable --vcd=testbench.vcd

ghdl -s alu.vhdl
ghdl -a alu.vhdl
ghdl -e alu
ghdl -r alu --ieee-asserts=disable --vcd=testbench.vcd

ghdl -s mux2.vhdl
ghdl -a mux2.vhdl
ghdl -e mux2
ghdl -r mux2 --ieee-asserts=disable --vcd=testbench.vcd

ghdl -s regfile.vhdl
ghdl -a regfile.vhdl
ghdl -e regfile
ghdl -r regfile --ieee-asserts=disable --vcd=testbench.vcd

ghdl -s signext.vhdl
ghdl -a signext.vhdl
ghdl -e signext
ghdl -r signext --ieee-asserts=disable --vcd=testbench.vcd

ghdl -s sl2.vhdl
ghdl -a sl2.vhdl
ghdl -e sl2
ghdl -r sl2 --ieee-asserts=disable --vcd=testbench.vcd

ghdl -s syncresff.vhdl
ghdl -a syncresff.vhdl
ghdl -e syncresff
ghdl -r syncresff --ieee-asserts=disable --vcd=testbench.vcd

ghdl -s aludec.vhdl
ghdl -a aludec.vhdl
ghdl -e aludec
ghdl -r aludec --ieee-asserts=disable --vcd=testbench.vcd

ghdl -s maindec.vhdl
ghdl -a maindec.vhdl
ghdl -e maindec
ghdl -r maindec --ieee-asserts=disable --vcd=testbench.vcd

ghdl -s controller.vhdl
ghdl -a controller.vhdl
ghdl -e controller
ghdl -r controller --ieee-asserts=disable --vcd=testbench.vcd


ghdl -s data_memory.vhdl
ghdl -a data_memory.vhdl
ghdl -e data_memory
ghdl -r data_memory --ieee-asserts=disable --vcd=testbench.vcd

ghdl -s instr_mem.vhdl
ghdl -a instr_mem.vhdl
ghdl -e instr_mem
ghdl -r instr_mem --ieee-asserts=disable --vcd=testbench.vcd

ghdl -s mips_mem.vhdl
ghdl -a mips_mem.vhdl
ghdl -e mips_mem
ghdl -r mips_mem --ieee-asserts=disable --vcd=testbench.vcd

ghdl -s datapath.vhdl
ghdl -a datapath.vhdl
ghdl -e datapath
ghdl -r datapath --ieee-asserts=disable --vcd=testbench.vcd

ghdl -s mips.vhdl
ghdl -a mips.vhdl
ghdl -e mips
ghdl -r mips --ieee-asserts=disable --vcd=testbench.vcd