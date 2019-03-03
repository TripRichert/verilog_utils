wish_pack_phony : generated/wish_pack.smt2
	yosys-smtbmc -s z3 --dump-vcd generated/wish_pack.vcd generated/wish_pack.smt2
	yosys-smtbmc -s z3 -i --dump-vcd generated/wish_pack.vcd generated/wish_pack.smt2

generated/wish_pack.lst : generated/wish_pack
	./generated/wish_pack > $@

generated/wish_pack : ../../hdl/wish_pack.v tb/tb_wish_pack.v
	iverilog -o generated/wish_pack $^

.phony: wish_pack_phony clean

generated/wish_pack.smt2: ../../hdl/wish_pack.v formal/formal_wish_pack.v
	yosys -ql generated/wish_pack.yslog -p 'read_verilog -formal -sv ../../hdl/wish_pack.v formal/formal_wish_pack.v; prep -top formal_wish_pack -nordff; write_smt2 -wires generated/wish_pack.smt2'

clean:
	rm generated/*
