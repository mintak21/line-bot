.PHONY: python go

python:
	pip install -r example/python/requirements.txt
	gunicorn example.python.server:app -c example/python/config.py

go:
	go run example/go/sever.go
