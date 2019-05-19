orig_hdl_sources    = ../../hdl/wish_pack.v
orig_formal_sources = ../../formal/formal_wish_pack.sby ../../formal/formal_wish_pack.v
orig_sim_sources    = ../../simhdl/wish_readIntegers.v ../../simhdl/wish_writeIntegers.v tb/tb_wish_pack.v
orig_data_sources   = testcases/test0.dat testcases/test1.dat
orig_all_sources    = $(orig_formal_sources) $(orig_sim_sources) $(orig_hdl_sources) $(orig_data_sources)

define generated_sources_fun
$(foreach source,$1,generated/$(notdir $(source)))
endef

hdl_sources := $(call generated_sources_fun,$(orig_hdl_sources))
formal_sources := $(call generated_sources_fun,$(orig_formal_sources))
sim_sources := $(call generated_sources_fun,$(orig_sim_sources))
data_sources := $(call generated_sources_fun,$(orig_data_sources))
all_sources := $(call generated_sources_fun,$(orig_all_sources))

generated/formal.phony : $(hdl_sources) $(formal_sources)
	cd generated;sby -f formal_wish_pack.sby
	touch generated/formal.phony

define cp_to_generated
generated/$(notdir $1): $1
	cp -f $1 generated/$(notdir $1);chmod -w generated/$(notdir $1);
endef
$(foreach file,$(orig_all_sources), $(eval $(call cp_to_generated,$(file))))

generated/wish_pack.lst : generated/wish_pack $(data_sources)
	cd generated;./wish_pack > $(notdir $@)

generated/wish_pack : $(hdl_sources) $(sim_sources)
	cd generated;iverilog -o wish_pack $(foreach file,$(hdl_sources) $(sim_sources),$(notdir $(file)))

.phony: clean

print-%  : ; @echo $* = $($*)
clean:
	rm -rf generated/*
