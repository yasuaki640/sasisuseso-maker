<!-- filepath: /Users/yasuaki640/ghq/github.com/yasuaki640/sasisuseso-maker/README.md -->
# sasisuseso-maker

## 概要

「さしすせそ」の法則に基づいた褒め言葉を生成する API サーバーです。

## 主な機能

- `/ping`: サーバーの死活監視用エンドポイント
- `/user/:name`: ユーザー名を指定して情報を取得 (現在はダミーデータを返却)
- `/admin`: Basic 認証で保護されたエンドポイント。ユーザー情報を更新 (現在はダミーデータを更新)

## 使用技術

- Go
- Gin (Web フレームワーク)
- Docker
- AWS (ECR, ECS, CodeBuild, CodePipeline など)

## セットアップ方法 (ローカル開発)

1. Docker Desktop をインストールします。
2. リポジトリをクローンします。
3. リポジトリのルートディレクトリで以下のコマンドを実行します。

   ```bash
   docker-compose up -d --build
   ```

4. `http://localhost:8080` にアクセスして動作を確認します。

## API エンドポイント

### GET /ping

サーバーの稼働状況を確認します。

- レスポンス:
  - `200 OK`: `pong`

### GET /user/:name

指定されたユーザーの情報を取得します。

- パスパラメータ:
  - `name`: ユーザー名
- レスポンス:
  - `200 OK`:
    ```json
    {
        "user": "ユーザー名",
        "value": "値"
    }
    ```
    または
    ```json
    {
        "user": "ユーザー名",
        "status": "no value"
    }
    ```

### POST /admin

Basic 認証が必要です。ユーザーの情報を更新します。

- Basic 認証:
  - `user: foo`, `password: bar`
  - `user: manu`, `password: 123`
- リクエストボディ (JSON):
  ```json
  {
      "value": "更新する値"
  }
  ```
- レスポンス:
  - `200 OK`:
    ```json
    {
        "status": "ok"
    }
    ```
- cURL 例:
  ```bash
  curl -X POST \
    http://localhost:8080/admin \
    -H 'authorization: Basic Zm9vOmJhcg==' \ # foo:bar を Base64 エンコードしたもの
    -H 'content-type: application/json' \
    -d '{"value":"新しい値"}'
  ```

## CI/CD

AWS CodePipeline, CodeBuild, CodeDeploy を使用して、ECR への Docker イメージのプッシュと ECS へのデプロイを自動化しています。

- `deployments/cicd/buildspec.yml`: CodeBuild のビルド仕様ファイル
- `deployments/cicd/appspec.yml`: CodeDeploy のアプリケーション仕様ファイル

## ディレクトリ構成

主要なディレクトリとファイルの説明です。

```
.
├── build/package/docker/Dockerfile  # 本番用および開発用 Dockerfile
├── compose.yml                      # ローカル開発用の Docker Compose 設定
├── deployments/
│   ├── cicd/                        # CI/CD 関連ファイル (buildspec.yml, appspec.yml)
│   └── terraform/                   # AWS インフラ構築用の Terraform コード
├── go.mod                           # Go モジュールファイル
├── go.sum                           # Go モジュールチェックサムファイル
├── main.go                          # アプリケーションのエントリーポイント
└── README.md                        # このファイル
```

## 今後の展望

- 「さしすせそ」の褒め言葉生成ロジックの実装
- データベースとの連携
- 認証機能の強化
- テストコードの拡充
