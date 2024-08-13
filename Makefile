.env:
	echo "UID=$$(id -u)\nGID=$$(id -g)" > .env

configure: .env
	test ${TOKEN}
	docker compose run -it --rm default exercism configure --token ${TOKEN} --workspace=.

submit:
	docker compose run -it --rm default exercism submit "${TARGET}"

%:
	docker compose run -it --rm $@ exercism download --track=$@ --exercise=hello-world
