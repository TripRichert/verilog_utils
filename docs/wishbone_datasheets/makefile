adoc_srcs = $(wildcard *.adoc)
adoc_outputs = $(adoc_srcs:.adoc=.html)
pathed_adoc_outputs = $(foreach ad, $(adoc_outputs), generated/$(ad))

default: $(pathed_adoc_outputs)

generated/%.html : %.adoc | generated
	asciidoc -o $@ $<

generated :
	mkdir -p generated

clean :
	rm -r generated
