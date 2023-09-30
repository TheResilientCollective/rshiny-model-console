
# make file. Best used to test the building of the Dockerfiles when they do not build in actions
#

VERSION :=`cat VERSION`
MAINVERSION :=`cat ../../../VERSION`

build: proxy, apps

proxy:
	cd inst/serve/proxy ; \
	docker build  --tag="resilientucsd/resilient-games-proxy:$(MAINVERSION)"  --file=./Dockerfile . ; \
	docker tag resilientucsd/resilient-games-proxy:$(MAINVERSION) resilientucsd/resilient-games-proxy:latest
apps:
	docker build  --tag="resilientucsd/resilient-games-app"  --file=./Dockerfile . ; \
	docker tag resilientucsd/resilient-games-app:$(VERSION) resilientucsd/resilient-games-app:latest
