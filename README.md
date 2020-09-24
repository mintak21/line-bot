# LineBotのバックエンド3選

## 1. Heroku

[Heroku](https://dashboard.heroku.com/)上にサーバーを立てる。
Procfileを用意して、直接プロセスを実行する方法と、コンテナをビルド&デプロイする方法がある。
ここでは後者のコンテナデプロイの方法をとる。
[Integration](https://devcenter.heroku.com/articles/github-integration)でGithub<->Heroku CD設定はカンタンに可能。ただし、ここでは逐一コマンド実行によって設定・デプロイを実行することとする。

### Limitations

`docker build`を実行する際のcontextの設定位置は、heroku側で`Dockerfile`の配置されているディレクトリに固定されてしまうため、
それを加味した`Dockerfile`記述、またはディレクトリ構成とする必要がある。

### Directory

```text
├── example/
│  └── python/
│     ├── config.py
│     ├── requirements.txt
│     └── server.py
├── heroku.yml
└── herokuDockerfile
```

### Login Heroku CLI

```bash
heroku login # login via Web UI
```

### Create Application

```bash
heroku create ${APP_NAME}
```

### SetUp Container Stack

```bash
heroku stack:set container --app ${APP_NAME}
```

### Setup Config Variables

```bash
heroku config:set ${ENV_NAME}=${ENV_VAR} --app ${APP_NAME}
```

### Deploy specific branches

```bash
git push heroku ${BRANCH_NAME}:master
```

### Utils

```bash
# Display Applications
heroku apps

# Display Logs
heroku logs --app ${APP_NAME}

# Restart Service
heroku ps:scale web=0 --app ${APP_NAME}
heroku ps:scale web=1 --app ${APP_NAME}

# Maintenance Mode
heroku maintenance:on --app ${APP_NAME}
```

### Reference

- [Heroku CLIコマンド](https://devcenter.heroku.com/articles/heroku-cli-commands)
- [ymlを使用しデプロイ](https://devcenter.heroku.com/articles/build-docker-images-heroku-yml)
- [環境変数の設定](https://devcenter.heroku.com/articles/config-vars)
- [Nginxリバースプロキシの設定方法](https://help.heroku.com/YTWRHLVH/how-do-i-make-my-nginx-proxy-connect-to-a-heroku-app-behind-heroku-ssl)
- [Contextを指定できない問題](https://devcenter.heroku.com/articles/build-docker-images-heroku-yml#known-issues-and-limitations)

## 2. AWS Lambda

## 3. GCP Cloud Run
