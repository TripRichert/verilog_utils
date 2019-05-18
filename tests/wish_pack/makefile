formal_wish_pack/empty.phony : formal_wish_pack.sby ../../hdl/wish_pack.v formal/formal_wish_pack.v | hdl
	sby -f formal_wish_pack.sby
	mkdir -p formal_wish_pack
	touch formal_wish_pack/empty.phony

hdl :
	ln -s ../../hdl .

generated/wish_pack.lst : generated/wish_pack
	./generated/wish_pack > $@

generated/wish_pack : ../../hdl/wish_pack.v tb/tb_wish_pack.v ../../simhdl/wish_readIntegers.v ../../simhdl/wish_writeIntegers.v
	iverilog -o generated/wish_pack $^

.phony: wish_pack_phony clean

clean:
	rm -f generated/*
	rm -rf formal_wish_pack
	rm -rf hdl
