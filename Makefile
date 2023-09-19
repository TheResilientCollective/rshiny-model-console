
VERSION :=`cat VERSION`


build: proxy, apps

proxy:
	docker build  --tag="resilientucsd/resilient-games-proxy"  --file=./inst/serve/proxy/Dockerfile . ; \
	docker tag resilientucsd/resilient-games-proxy:$(VERSION) resilientucsd/resilient-games-proxy:latest
apps:
	docker build  --tag="resilientucsd/resilient-games-app"  --file=.//Dockerfile . ; \
	docker tag resilientucsd/resilient-games-app:$(VERSION) resilientucsd/resilient-games-app:latest
