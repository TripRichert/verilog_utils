formal_wish_unpack/empty.phony : formal_wish_unpack.sby ../../hdl/wish_unpack.v formal/formal_wish_unpack.v | hdl
	sby -f formal_wish_unpack.sby
	mkdir -p formal_wish_unpack
	touch formal_wish_unpack/empty.phony

hdl :
	ln -s ../../hdl .

generated/wish_unpack.lst : generated/wish_unpack
	./generated/wish_unpack > $@

generated/wish_unpack : ../../hdl/wish_unpack.v tb/tb_wish_unpack.v ../../simhdl/wish_readIntegers.v ../../simhdl/wish_writeIntegers.v
	iverilog -o generated/wish_unpack $^

.phony: wish_unpack_phony clean

clean:
	rm -f generated/*
	rm -rf formal_wish_unpack
	rm -r hdl
