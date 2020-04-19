CRYSTAL_BIN ?= $(shell which crystal)
SHARDS_BIN ?= $(shell which shards)
AMEBA_BIN ?= bin/ameba

.PHONY: spec

benchmark: benchmark/benchmark.cr
	$(CRYSTAL_BIN) run --release benchmark/benchmark.cr

spec:
	$(CRYSTAL_BIN) spec -Dquiet --warnings=all

ameba:
	$(AMEBA_BIN) src spec benchmark

test: spec ameba