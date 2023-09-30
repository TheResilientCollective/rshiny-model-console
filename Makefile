
# make file. Best used to test the building of the Dockerfiles when they do not build in actions
#

MAINVERSION :=`cat ../../VERSION`
VERSION :=`cat VERSION`

build: proxy apps

proxy:
	cd inst/serve ; \
	docker build  --tag="resilientucsd/resilient-games-proxy"  --file=./proxy/Dockerfile . ; \
	docker tag resilientucsd/resilient-games-proxy:$(MAINVERSION) resilientucsd/resilient-games-proxy:latest

apps:
	docker build  --tag="resilientucsd/resilient-games-app"  --file=./Dockerfile . ; \
	docker tag resilientucsd/resilient-games-app:$(VERSION) resilientucsd/resilient-games-app:latest

push:
	echo "You may need to 'docker login'" ;\
	docker push -a resilientucsd/resilient-games-app  ; \
	docker push -a resilientucsd/resilient-games-proxy
