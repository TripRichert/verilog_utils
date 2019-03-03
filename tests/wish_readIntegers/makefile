generated/wish_readIntegers.lst : generated/wish_readIntegers testcases/test0.dat
	./generated/wish_readIntegers > $@

generated/wish_readIntegers : ../../simhdl/wish_readIntegers.v tb/tb_wish_readIntegers.v
	iverilog -o generated/wish_readIntegers $^


clean:
	rm generated/*
