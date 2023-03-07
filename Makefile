.PHONY: server

server:
	bundle exec rackup --host 0.0.0.0 -p 4567

lint:
	bundle exec rubocop -A

deploy:
	flyctl deploy