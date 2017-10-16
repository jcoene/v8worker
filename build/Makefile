libv8:
	sh build.sh

libv8-docker-linux:
	docker build -t jcoene/v8worker_build .
	$(eval ID := $(shell docker create jcoene/v8worker_build))
	rm -rf ../libv8/linux
	docker cp -a $(ID):/build/libv8/linux ../libv8/
	docker rm $(ID)
