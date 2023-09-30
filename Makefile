
# make file. Best used to test the building of the Dockerfiles when they do not build in actions
#

MAINVERSION :=`cat ../../VERSION`
VERSION :=`cat VERSION`

build: proxy apps

proxy:
	cd inst/serve ; \
	docker build  --tag="resilientucsd/resilient-games-proxy"  --file=./proxy/Dockerfile . ; \
	docker tag resilientucsd/resilient-games-proxy resilientucsd/resilient-games-proxy:latest ; \
	docker tag resilientucsd/resilient-games-proxy resilientucsd/resilient-games-proxy:$(MAINVERSION)

apps:
	docker build  --tag="resilientucsd/resilient-games-app"  --file=./Dockerfile . ; \
	docker tag resilientucsd/resilient-games-app resilientucsd/resilient-games-app:latest ; \
	docker tag resilientucsd/resilient-games-app resilientucsd/resilient-games-app:$(VERSION)
push:
	echo "You may need to 'docker login'" ;\
	docker push -a resilientucsd/resilient-games-app  ; \
	docker push -a resilientucsd/resilient-games-proxy
