
EXTENSION 	= complex_ext
DATA 		= complex_ext--0.1.sql
DOCS		= README.md

TESTS 	= $(wildcard tests/sql/*.sql)
REGRESS = $(patsubst tests/sql/%.sql,%,$(TESTS))
REGRESS_OPTS =--temp-instance=/tmp/tmp_check --inputdir=./tests --outputdir=./output


PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
export LD_LIBRARY_PATH := $(shell $(PG_CONFIG) --libdir)
include $(PGXS)

