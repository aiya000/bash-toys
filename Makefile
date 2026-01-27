.PHONY: test
test:
	./run-tests.sh

# Use if want to run skipped tests in `make test`. Maybe should try run `make test` first
.PHONY: test-can-affect-host-os
test-can-affect-host-os:
	BASH_TOYS_TEST_REAL_JOBS=1 ./run-tests.sh
