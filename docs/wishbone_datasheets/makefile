default: generated/wish_pack.html generated/wish_readIntegers.html generated/wish_writeIntegers.html

generated/wish_pack.html : wish_pack.adoc | generated
	asciidoc -o generated/wish_pack.html wish_pack.adoc 

generated/wish_readIntegers.html : wish_readIntegers.adoc | generated
	asciidoc -o generated/wish_readIntegers.html wish_readIntegers.adoc

generated/wish_writeIntegers.html : wish_writeIntegers.adoc | generated
	asciidoc -o generated/wish_writeIntegers.html wish_writeIntegers.adoc

generated :
	mkdir -p generated
