#
#	Makefile
#
.PHONY: help build tags push notify-hub-docker-com

help:
	@echo -e "Please use a command: \n \
		make build v=<2.3-debian> \n \
		make build v=<2.3-debian> prod=true | If you want to build directly production ready images\n \
		make tags $(REPO) \n \
		make tags $(REPO) prod=true | If you want to add production ready images \n \
		make push $(REPO) $(USER) $(PW) \n \
		make notify-hub.docker.com TOKEN=<TOKEN> \n \
	"

build:
	@bash .ci/02_build.sh $(v) $(prod)

tags:
	@bash .ci/03_tagging.sh $(REPO) $(prod)

push:
	@bash .ci/04_push.sh $(REPO) $(USER) $(PW)

notify-hub-docker-com:
	@bash .ci/05_notify_hub.docker.com.sh $(TOKEN)
