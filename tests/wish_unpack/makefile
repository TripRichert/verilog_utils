#wish_unpack_phony : generated/wish_unpack.smt2
#	yosys-smtbmc -s z3 --dump-vcd generated/wish_unpack.vcd generated/wish_unpack.smt2
#	yosys-smtbmc -s z3 -i --dump-vcd generated/wish_unpack.vcd generated/wish_unpack.smt2
#generated/wish_unpack.smt2: ../../hdl/wish_unpack.v formal/formal_wish_unpack.v
#	yosys -ql generated/wish_unpack.yslog -p 'read_verilog -formal -sv ../../hdl/wish_unpack.v formal/formal_wish_unpack.v; prep -top formal_wish_unpack -nordff; write_smt2 -wires generated/wish_unpack.smt2'

generated/wish_unpack.lst : generated/wish_unpack
	vvp ./generated/wish_unpack > $@

generated/wish_unpack : ../../hdl/wish_unpack.v tb/tb_wish_unpack.v ../../simhdl/wish_readIntegers.v ../../simhdl/wish_writeIntegers.v
	iverilog -o generated/wish_unpack $^

#.phony: wish_unpack_phony clean


clean:
	rm generated/*
