SHELL := /bin/bash

tests:
	symfony console doctrine:database:drop --force --env=test || true
	symfony console doctrine:database:create --env=test
	symfony console doctrine:migrations:migrate -n --env=test
	symfony console doctrine:fixtures:load -n --env=test
	symfony php bin/phpunit $@
.PHONY: tests

server-start:
	symfony server:start -d;
	symfony run -d --watch=config,src,templates,vendor symfony console messenger:consume async -vv;
	cd spa; API_ENDPOINT=`symfony var:export SYMFONY_PROJECT_DEFAULT_ROUTE_URL --dir=..` symfony run -d --watch=webpack.config.js yarn encore dev --watch; \
	symfony server:start -d --passthru=index.html;
.PHONY: server-run

server-stop:
	symfony server:stop;
	cd spa; symfony server:stop; \
.PHONY: server-stop