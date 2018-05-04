# travis makes sure to test the examples whenever Travis CI runs a build
travis:
	cd examples/lambda-go-serverless && make deps test build pack clean
.PHONY: travis