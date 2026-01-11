# アーキテクチャ設計書

## 1. 技術スタック

### 1.1 バックエンド

| 技術 | バージョン | 用途 |
|------|-----------|------|
| Ruby | 3.3.x | プログラミング言語 |
| Ruby on Rails | 8.1.2 | Webフレームワーク |
| PostgreSQL | 16.x | データベース |
| Solid Queue | 最新 | バックグラウンドジョブ |
| Solid Cache | 最新 | キャッシュ |
| Solid Cable | 最新 | Action Cable（WebSocket） |

### 1.2 フロントエンド

| 技術 | 用途 |
|------|------|
| Hotwire (Turbo) | SPAライクなページ遷移 |
| Hotwire (Stimulus) | JavaScriptコントローラー |
| Propshaft | アセットパイプライン |
| Importmap | JavaScriptモジュール管理 |
| Tailwind CSS | CSSフレームワーク（推奨） |

### 1.3 ファイルストレージ

| 環境 | サービス |
|------|----------|
| 開発 | ローカルディスク |
| 本番 | Amazon S3 / Cloudflare R2 |

### 1.4 外部サービス

| サービス | 用途 |
|----------|------|
| Stripe | 決済処理 |
| SendGrid / Amazon SES | メール送信（本番） |

### 1.5 開発・デプロイ

| ツール | 用途 |
|--------|------|
| Docker | コンテナ化 |
| Kamal | デプロイ |
| GitHub Actions | CI/CD |
| RuboCop | コードスタイル |
| Brakeman | セキュリティスキャン |

---

## 2. ディレクトリ構成

```
rails-ec/
├── app/
│   ├── assets/
│   │   ├── images/
│   │   └── stylesheets/
│   │       └── application.css
│   │
│   ├── controllers/
│   │   ├── application_controller.rb
│   │   ├── concerns/
│   │   │   └── authentication.rb          # 顧客認証concern
│   │   │
│   │   ├── pages_controller.rb             # 静的ページ
│   │   ├── registrations_controller.rb     # 会員登録
│   │   ├── sessions_controller.rb          # ログイン/ログアウト
│   │   ├── passwords_controller.rb         # パスワードリセット
│   │   │
│   │   ├── products_controller.rb          # 商品一覧・詳細
│   │   ├── categories_controller.rb        # カテゴリ一覧
│   │   │
│   │   ├── carts_controller.rb             # カート表示
│   │   ├── cart_items_controller.rb        # カート操作
│   │   │
│   │   ├── addresses_controller.rb         # 配送先住所管理
│   │   ├── orders_controller.rb            # 注文履歴・詳細
│   │   ├── checkouts_controller.rb         # 注文確認・決済
│   │   │
│   │   ├── webhooks/
│   │   │   └── stripe_controller.rb        # Stripe Webhook
│   │   │
│   │   └── admin/
│   │       ├── base_controller.rb          # 管理者認証ベース
│   │       ├── sessions_controller.rb      # 管理者ログイン
│   │       ├── dashboard_controller.rb     # ダッシュボード
│   │       ├── products_controller.rb      # 商品CRUD
│   │       ├── categories_controller.rb    # カテゴリCRUD
│   │       └── orders_controller.rb        # 注文管理
│   │
│   ├── helpers/
│   │   ├── application_helper.rb
│   │   ├── products_helper.rb
│   │   ├── carts_helper.rb
│   │   └── orders_helper.rb
│   │
│   ├── javascript/
│   │   ├── application.js
│   │   └── controllers/                    # Stimulus controllers
│   │       ├── application.js
│   │       ├── index.js
│   │       ├── cart_controller.js          # カート操作
│   │       ├── quantity_controller.js      # 数量増減
│   │       ├── flash_controller.js         # フラッシュメッセージ
│   │       └── image_gallery_controller.js # 画像ギャラリー
│   │
│   ├── jobs/
│   │   ├── application_job.rb
│   │   └── order_confirmation_job.rb       # 注文確認メール送信
│   │
│   ├── mailers/
│   │   ├── application_mailer.rb
│   │   └── order_mailer.rb                 # 注文関連メール
│   │
│   ├── models/
│   │   ├── application_record.rb
│   │   ├── concerns/
│   │   │   └── has_secure_password.rb
│   │   │
│   │   ├── user.rb                         # 顧客ユーザー
│   │   ├── session.rb                      # ユーザーセッション
│   │   ├── admin_user.rb                   # 管理者ユーザー
│   │   ├── admin_session.rb                # 管理者セッション
│   │   ├── address.rb                      # 配送先住所
│   │   ├── category.rb                     # カテゴリ
│   │   ├── product.rb                      # 商品
│   │   ├── cart_item.rb                    # カートアイテム
│   │   ├── order.rb                        # 注文
│   │   ├── order_item.rb                   # 注文明細
│   │   ├── payment.rb                      # 決済
│   │   │
│   │   └── current.rb                      # Current attributes
│   │
│   ├── services/
│   │   ├── cart_service.rb                 # カート操作ロジック
│   │   ├── order_service.rb                # 注文作成ロジック
│   │   ├── stripe_checkout_service.rb      # Stripe連携
│   │   └── order_number_generator.rb       # 注文番号生成
│   │
│   └── views/
│       ├── layouts/
│       │   ├── application.html.erb        # 顧客用レイアウト
│       │   ├── admin.html.erb              # 管理画面用レイアウト
│       │   ├── mailer.html.erb
│       │   └── mailer.text.erb
│       │
│       ├── shared/
│       │   ├── _header.html.erb            # ヘッダー
│       │   ├── _footer.html.erb            # フッター
│       │   ├── _flash.html.erb             # フラッシュメッセージ
│       │   ├── _pagination.html.erb        # ページネーション
│       │   └── _breadcrumbs.html.erb       # パンくずリスト
│       │
│       ├── pages/
│       │   └── home.html.erb               # トップページ
│       │
│       ├── registrations/
│       │   └── new.html.erb                # 会員登録フォーム
│       │
│       ├── sessions/
│       │   └── new.html.erb                # ログインフォーム
│       │
│       ├── passwords/
│       │   ├── new.html.erb                # パスワードリセット申請
│       │   └── edit.html.erb               # 新パスワード設定
│       │
│       ├── products/
│       │   ├── index.html.erb              # 商品一覧
│       │   ├── show.html.erb               # 商品詳細
│       │   └── _product.html.erb           # 商品カード（partial）
│       │
│       ├── categories/
│       │   └── show.html.erb               # カテゴリ商品一覧
│       │
│       ├── carts/
│       │   └── show.html.erb               # カート表示
│       │
│       ├── cart_items/
│       │   ├── _cart_item.html.erb         # カートアイテム（partial）
│       │   ├── create.turbo_stream.erb     # カート追加レスポンス
│       │   ├── update.turbo_stream.erb     # 数量変更レスポンス
│       │   └── destroy.turbo_stream.erb    # 削除レスポンス
│       │
│       ├── addresses/
│       │   ├── index.html.erb              # 住所一覧
│       │   ├── new.html.erb                # 住所追加
│       │   ├── edit.html.erb               # 住所編集
│       │   └── _form.html.erb              # 住所フォーム（partial）
│       │
│       ├── orders/
│       │   ├── index.html.erb              # 注文履歴
│       │   └── show.html.erb               # 注文詳細
│       │
│       ├── checkouts/
│       │   ├── new.html.erb                # 注文確認画面
│       │   ├── success.html.erb            # 決済成功
│       │   └── cancel.html.erb             # 決済キャンセル
│       │
│       ├── order_mailer/
│       │   ├── confirmation.html.erb       # 注文確認メール（HTML）
│       │   └── confirmation.text.erb       # 注文確認メール（テキスト）
│       │
│       └── admin/
│           ├── shared/
│           │   ├── _sidebar.html.erb       # サイドバー
│           │   └── _header.html.erb        # 管理画面ヘッダー
│           │
│           ├── sessions/
│           │   └── new.html.erb            # 管理者ログイン
│           │
│           ├── dashboard/
│           │   └── index.html.erb          # ダッシュボード
│           │
│           ├── products/
│           │   ├── index.html.erb          # 商品一覧
│           │   ├── new.html.erb            # 商品作成
│           │   ├── edit.html.erb           # 商品編集
│           │   ├── show.html.erb           # 商品詳細
│           │   └── _form.html.erb          # 商品フォーム（partial）
│           │
│           ├── categories/
│           │   ├── index.html.erb          # カテゴリ一覧
│           │   ├── new.html.erb            # カテゴリ作成
│           │   ├── edit.html.erb           # カテゴリ編集
│           │   └── _form.html.erb          # カテゴリフォーム（partial）
│           │
│           └── orders/
│               ├── index.html.erb          # 注文一覧
│               └── show.html.erb           # 注文詳細
│
├── config/
│   ├── routes.rb                           # ルーティング定義
│   ├── initializers/
│   │   └── stripe.rb                       # Stripe設定
│   └── locales/
│       └── ja.yml                          # 日本語化
│
├── db/
│   ├── migrate/                            # マイグレーションファイル
│   └── seeds.rb                            # シードデータ
│
├── docs/                                   # ドキュメント
│   ├── requirements.md                     # 要件定義書
│   ├── db_schema.md                        # DB設計書
│   └── architecture.md                     # 本ドキュメント
│
├── lib/
│   └── tasks/
│       └── admin.rake                      # 管理者作成タスク
│
└── spec/                                   # テストファイル（RSpec）
    ├── rails_helper.rb                     # Rails用ヘルパー
    ├── spec_helper.rb                      # RSpec設定
    ├── factories/                          # FactoryBot定義
    │   ├── users.rb
    │   ├── products.rb
    │   ├── categories.rb
    │   ├── orders.rb
    │   └── addresses.rb
    ├── models/                             # モデルスペック
    ├── requests/                           # リクエストスペック（統合テスト）
    ├── services/                           # サービススペック
    ├── mailers/                            # メーラースペック
    └── support/                            # テストサポートファイル
        └── factory_bot.rb
```

---

## 3. ルーティング設計

### 3.1 config/routes.rb

```ruby
Rails.application.routes.draw do
  # ヘルスチェック
  get "up" => "rails/health#show", as: :rails_health_check

  # トップページ
  root "pages#home"

  # 顧客認証
  get  "sign_up", to: "registrations#new"
  post "sign_up", to: "registrations#create"
  get  "sign_in", to: "sessions#new"
  post "sign_in", to: "sessions#create"
  delete "sign_out", to: "sessions#destroy"

  # パスワードリセット
  resources :passwords, param: :token, only: [:new, :create, :edit, :update]

  # 商品
  resources :products, only: [:index, :show]
  resources :categories, only: [:show], param: :slug

  # カート
  resource :cart, only: [:show]
  resources :cart_items, only: [:create, :update, :destroy]

  # 配送先住所（要ログイン）
  resources :addresses, except: [:show]

  # 注文（要ログイン）
  resources :orders, only: [:index, :show]

  # チェックアウト（要ログイン）
  resources :checkouts, only: [:new, :create] do
    collection do
      get :success
      get :cancel
    end
  end

  # Stripe Webhook
  namespace :webhooks do
    post "stripe", to: "stripe#create"
  end

  # 管理画面
  namespace :admin do
    root "dashboard#index"

    # 管理者認証
    get  "sign_in", to: "sessions#new"
    post "sign_in", to: "sessions#create"
    delete "sign_out", to: "sessions#destroy"

    # 商品管理
    resources :products

    # カテゴリ管理
    resources :categories, except: [:show]

    # 注文管理
    resources :orders, only: [:index, :show, :update]
  end
end
```

### 3.2 ルーティング一覧

#### 顧客向け（公開）

| メソッド | パス | アクション | 説明 |
|---------|------|----------|------|
| GET | / | pages#home | トップページ |
| GET | /products | products#index | 商品一覧 |
| GET | /products/:id | products#show | 商品詳細 |
| GET | /categories/:slug | categories#show | カテゴリ商品一覧 |

#### 顧客認証

| メソッド | パス | アクション | 説明 |
|---------|------|----------|------|
| GET | /sign_up | registrations#new | 会員登録フォーム |
| POST | /sign_up | registrations#create | 会員登録処理 |
| GET | /sign_in | sessions#new | ログインフォーム |
| POST | /sign_in | sessions#create | ログイン処理 |
| DELETE | /sign_out | sessions#destroy | ログアウト |
| GET | /passwords/new | passwords#new | パスワードリセット申請 |
| POST | /passwords | passwords#create | リセットメール送信 |
| GET | /passwords/:token/edit | passwords#edit | 新パスワード設定フォーム |
| PATCH | /passwords/:token | passwords#update | パスワード更新 |

#### カート

| メソッド | パス | アクション | 説明 |
|---------|------|----------|------|
| GET | /cart | carts#show | カート表示 |
| POST | /cart_items | cart_items#create | カートに追加 |
| PATCH | /cart_items/:id | cart_items#update | 数量変更 |
| DELETE | /cart_items/:id | cart_items#destroy | カートから削除 |

#### 配送先住所（要ログイン）

| メソッド | パス | アクション | 説明 |
|---------|------|----------|------|
| GET | /addresses | addresses#index | 住所一覧 |
| GET | /addresses/new | addresses#new | 住所追加フォーム |
| POST | /addresses | addresses#create | 住所追加 |
| GET | /addresses/:id/edit | addresses#edit | 住所編集フォーム |
| PATCH | /addresses/:id | addresses#update | 住所更新 |
| DELETE | /addresses/:id | addresses#destroy | 住所削除 |

#### 注文・チェックアウト（要ログイン）

| メソッド | パス | アクション | 説明 |
|---------|------|----------|------|
| GET | /orders | orders#index | 注文履歴 |
| GET | /orders/:id | orders#show | 注文詳細 |
| GET | /checkouts/new | checkouts#new | 注文確認画面 |
| POST | /checkouts | checkouts#create | Stripe決済開始 |
| GET | /checkouts/success | checkouts#success | 決済成功画面 |
| GET | /checkouts/cancel | checkouts#cancel | 決済キャンセル画面 |

#### Webhook

| メソッド | パス | アクション | 説明 |
|---------|------|----------|------|
| POST | /webhooks/stripe | webhooks/stripe#create | Stripe Webhook受信 |

#### 管理者認証

| メソッド | パス | アクション | 説明 |
|---------|------|----------|------|
| GET | /admin/sign_in | admin/sessions#new | 管理者ログインフォーム |
| POST | /admin/sign_in | admin/sessions#create | 管理者ログイン処理 |
| DELETE | /admin/sign_out | admin/sessions#destroy | 管理者ログアウト |

#### 管理画面

| メソッド | パス | アクション | 説明 |
|---------|------|----------|------|
| GET | /admin | admin/dashboard#index | ダッシュボード |
| GET | /admin/products | admin/products#index | 商品一覧 |
| GET | /admin/products/new | admin/products#new | 商品作成フォーム |
| POST | /admin/products | admin/products#create | 商品作成 |
| GET | /admin/products/:id | admin/products#show | 商品詳細 |
| GET | /admin/products/:id/edit | admin/products#edit | 商品編集フォーム |
| PATCH | /admin/products/:id | admin/products#update | 商品更新 |
| DELETE | /admin/products/:id | admin/products#destroy | 商品削除 |
| GET | /admin/categories | admin/categories#index | カテゴリ一覧 |
| GET | /admin/categories/new | admin/categories#new | カテゴリ作成フォーム |
| POST | /admin/categories | admin/categories#create | カテゴリ作成 |
| GET | /admin/categories/:id/edit | admin/categories#edit | カテゴリ編集フォーム |
| PATCH | /admin/categories/:id | admin/categories#update | カテゴリ更新 |
| DELETE | /admin/categories/:id | admin/categories#destroy | カテゴリ削除 |
| GET | /admin/orders | admin/orders#index | 注文一覧 |
| GET | /admin/orders/:id | admin/orders#show | 注文詳細 |
| PATCH | /admin/orders/:id | admin/orders#update | ステータス更新 |

---

## 4. 認証設計

### 4.1 顧客認証

Rails 8の組み込み認証機能をベースに実装。

```ruby
# app/models/user.rb
class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  # ...
end

# app/models/session.rb
class Session < ApplicationRecord
  belongs_to :user
end

# app/models/current.rb
class Current < ActiveSupport::CurrentAttributes
  attribute :session
  delegate :user, to: :session, allow_nil: true
end

# app/controllers/concerns/authentication.rb
module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :set_current_session
    helper_method :signed_in?, :current_user
  end

  private

  def set_current_session
    Current.session = Session.find_by(id: cookies.signed[:session_id])
  end

  def signed_in?
    Current.user.present?
  end

  def current_user
    Current.user
  end

  def require_authentication
    redirect_to sign_in_path, alert: "ログインが必要です" unless signed_in?
  end
end
```

### 4.2 管理者認証

顧客とは完全に分離した認証システム。

```ruby
# app/models/admin_user.rb
class AdminUser < ApplicationRecord
  has_secure_password
  has_many :admin_sessions, dependent: :destroy
end

# app/models/admin_session.rb
class AdminSession < ApplicationRecord
  belongs_to :admin_user
end

# app/controllers/admin/base_controller.rb
module Admin
  class BaseController < ApplicationController
    layout "admin"

    before_action :require_admin_authentication

    private

    def current_admin_session
      @current_admin_session ||= AdminSession.find_by(id: cookies.signed[:admin_session_id])
    end

    def current_admin_user
      @current_admin_user ||= current_admin_session&.admin_user
    end
    helper_method :current_admin_user

    def require_admin_authentication
      redirect_to admin_sign_in_path, alert: "管理者ログインが必要です" unless current_admin_user
    end
  end
end
```

---

## 5. サービスクラス設計

### 5.1 CartService

カート操作のビジネスロジックをカプセル化。

```ruby
# app/services/cart_service.rb
class CartService
  def initialize(user: nil, session: {})
    @user = user
    @session = session
  end

  def add(product:, quantity: 1)
    # 在庫チェック、カートへの追加ロジック
  end

  def update(cart_item_or_id, quantity:)
    # 数量更新ロジック
  end

  def remove(cart_item_or_id)
    # 削除ロジック
  end

  def items
    # ユーザーまたはセッションからカートアイテムを取得
  end

  def total
    # 合計金額計算
  end

  def merge_session_cart!
    # ログイン時のセッションカートマージ
  end
end
```

### 5.2 OrderService

注文作成のビジネスロジック。

```ruby
# app/services/order_service.rb
class OrderService
  def initialize(user:, address:, cart_items:)
    @user = user
    @address = address
    @cart_items = cart_items
  end

  def create!
    ActiveRecord::Base.transaction do
      # 在庫確認
      # 注文レコード作成
      # 注文明細作成
      # 決済レコード作成
      # カートクリア
    end
  end

  private

  def calculate_shipping_fee(subtotal)
    subtotal >= 5000 ? 0 : 500
  end
end
```

### 5.3 StripeCheckoutService

Stripe連携ロジック。

```ruby
# app/services/stripe_checkout_service.rb
class StripeCheckoutService
  def initialize(order:)
    @order = order
  end

  def create_checkout_session(success_url:, cancel_url:)
    Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: build_line_items,
      mode: 'payment',
      success_url: success_url,
      cancel_url: cancel_url,
      metadata: { order_id: @order.id }
    )
  end

  private

  def build_line_items
    @order.order_items.map do |item|
      {
        price_data: {
          currency: 'jpy',
          product_data: { name: item.product_name },
          unit_amount: item.unit_price
        },
        quantity: item.quantity
      }
    end
  end
end
```

---

## 6. 外部サービス連携

### 6.1 Stripe設定

```ruby
# config/initializers/stripe.rb
Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)

# Webhook署名検証用
STRIPE_WEBHOOK_SECRET = Rails.application.credentials.dig(:stripe, :webhook_secret)
```

```ruby
# config/credentials.yml.enc（例）
stripe:
  publishable_key: pk_test_xxx
  secret_key: sk_test_xxx
  webhook_secret: whsec_xxx
```

### 6.2 Webhook処理

```ruby
# app/controllers/webhooks/stripe_controller.rb
module Webhooks
  class StripeController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      payload = request.body.read
      sig_header = request.env['HTTP_STRIPE_SIGNATURE']

      begin
        event = Stripe::Webhook.construct_event(
          payload, sig_header, STRIPE_WEBHOOK_SECRET
        )
      rescue JSON::ParserError, Stripe::SignatureVerificationError
        head :bad_request
        return
      end

      case event.type
      when 'checkout.session.completed'
        handle_checkout_completed(event.data.object)
      when 'checkout.session.expired'
        handle_checkout_expired(event.data.object)
      end

      head :ok
    end

    private

    def handle_checkout_completed(session)
      order = Order.find(session.metadata.order_id)
      order.update!(status: :paid, ordered_at: Time.current)
      order.payment.update!(
        status: :completed,
        stripe_payment_intent_id: session.payment_intent,
        paid_at: Time.current
      )
      # 在庫減算
      order.order_items.each do |item|
        item.product.decrement!(:stock, item.quantity)
      end
      # メール送信
      OrderConfirmationJob.perform_later(order)
    end

    def handle_checkout_expired(session)
      order = Order.find(session.metadata.order_id)
      order.update!(status: :cancelled)
      order.payment.update!(status: :failed)
    end
  end
end
```

---

## 7. セキュリティ設計

### 7.1 認証・認可

| 対策 | 実装方法 |
|------|----------|
| パスワード保護 | `has_secure_password`（bcrypt） |
| セッション管理 | DBセッション + 署名付きCookie |
| CSRF対策 | Rails標準（`protect_from_forgery`） |
| 認可 | コントローラーレベルのbefore_action |

### 7.2 入力検証

| 対策 | 実装方法 |
|------|----------|
| SQLインジェクション | ActiveRecordのパラメータバインド |
| XSS | ERBの自動エスケープ |
| Strong Parameters | コントローラーでのパラメータ制限 |

### 7.3 Stripe Webhook

| 対策 | 実装方法 |
|------|----------|
| 署名検証 | `Stripe::Webhook.construct_event` |
| CSRF無効化 | `skip_before_action :verify_authenticity_token` |

### 7.4 本番環境

| 対策 | 実装方法 |
|------|----------|
| HTTPS強制 | `config.force_ssl = true` |
| セキュリティヘッダー | `config.content_security_policy` |
| クレデンシャル管理 | Rails暗号化credentials |

---

## 8. パフォーマンス設計

### 8.1 N+1対策

```ruby
# 商品一覧
Product.includes(:category).with_attached_images

# 注文一覧
Order.includes(:order_items, :payment)

# カート
current_user.cart_items.includes(product: { images_attachments: :blob })
```

### 8.2 ページネーション

```ruby
# Pagy gemを使用
include Pagy::Backend

def index
  @pagy, @products = pagy(Product.published.order(created_at: :desc), items: 12)
end
```

### 8.3 画像最適化

```ruby
# app/models/product.rb
class Product < ApplicationRecord
  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [300, 300]
    attachable.variant :medium, resize_to_limit: [600, 600]
  end
end
```

---

## 9. Gem一覧

### 9.1 追加予定のGem

```ruby
# Gemfile（追加分）

# 認証
gem "bcrypt", "~> 3.1.7"

# 決済
gem "stripe"

# ページネーション
gem "pagy"

# CSSフレームワーク
gem "tailwindcss-rails"

# 日本語化
gem "rails-i18n"
gem "enum_help"

group :development, :test do
  # ファクトリ
  gem "factory_bot_rails"
  # フェイクデータ
  gem "faker"
end

group :test do
  # テストフレームワーク
  gem "rspec-rails"
  gem "shoulda-matchers"
end
```

---

## 10. 環境変数

### 10.1 開発環境

```bash
# .env（開発用、gitignore対象）
STRIPE_PUBLISHABLE_KEY=pk_test_xxx
STRIPE_SECRET_KEY=sk_test_xxx
STRIPE_WEBHOOK_SECRET=whsec_xxx
```

### 10.2 本番環境

Rails credentialsを使用。

```bash
# 編集コマンド
bin/rails credentials:edit

# 構造
stripe:
  publishable_key: pk_live_xxx
  secret_key: sk_live_xxx
  webhook_secret: whsec_xxx
```

---

## 11. デプロイ構成

### 11.1 Docker

既存の`Dockerfile`をベースに使用。

### 11.2 Kamal

既存の`config/deploy.yml`をベースに設定。

```yaml
# config/deploy.yml（抜粋）
service: rails-ec

servers:
  web:
    - xxx.xxx.xxx.xxx

registry:
  server: ghcr.io
  username: your-github-username
  password:
    - KAMAL_REGISTRY_PASSWORD

env:
  secret:
    - RAILS_MASTER_KEY
    - STRIPE_SECRET_KEY
    - STRIPE_WEBHOOK_SECRET
```

### 11.3 CI/CD

GitHub Actionsで自動テスト・デプロイ。

```yaml
# .github/workflows/ci.yml（既存ファイルを拡張）
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:16
        env:
          POSTGRES_PASSWORD: postgres
        ports:
          - 5432:5432
    steps:
      - uses: actions/checkout@v4
      - uses: ruby/setup-ruby@v1
        with:
          bundler-cache: true
      - run: bin/rails db:setup
      - run: bundle exec rspec
      - run: bin/rubocop
      - run: bin/brakeman
```
