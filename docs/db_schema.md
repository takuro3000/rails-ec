# データベーススキーマ設計書

## 1. ER図（テキスト版）

```
┌─────────────┐       ┌─────────────┐
│   users     │       │ admin_users │
└──────┬──────┘       └─────────────┘
       │
       │ 1:N
       ▼
┌─────────────┐
│  addresses  │
└─────────────┘
       │
       │
┌──────┴──────┐
│   users     │
└──────┬──────┘
       │ 1:N
       ├──────────────────┐
       ▼                  ▼
┌─────────────┐    ┌─────────────┐
│ cart_items  │    │   orders    │
└──────┬──────┘    └──────┬──────┘
       │                  │ 1:N
       │                  ├──────────────────┐
       ▼                  ▼                  ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│  products   │◄───│ order_items │    │  payments   │
└──────┬──────┘    └─────────────┘    └─────────────┘
       │
       │ N:1
       ▼
┌─────────────┐
│ categories  │
└─────────────┘
```

### リレーションシップ概要

```
User
├── has_many :addresses
├── has_many :cart_items
└── has_many :orders

AdminUser
└── (独立したテーブル、顧客とは別管理)

Category
└── has_many :products

Product
├── belongs_to :category
├── has_many :cart_items
├── has_many :order_items
└── has_many_attached :images

CartItem
├── belongs_to :user
└── belongs_to :product

Order
├── belongs_to :user
├── belongs_to :address
├── has_many :order_items
└── has_one :payment

OrderItem
├── belongs_to :order
└── belongs_to :product

Payment
└── belongs_to :order
```

---

## 2. テーブル定義

### 2.1 users（顧客ユーザー）

顧客情報を管理するテーブル。

| カラム名 | 型 | 制約 | デフォルト | 説明 |
|---------|-----|------|-----------|------|
| id | bigint | PK, NOT NULL | auto | 主キー |
| email | string(255) | NOT NULL, UNIQUE | - | メールアドレス |
| password_digest | string(255) | NOT NULL | - | パスワードハッシュ |
| name | string(100) | NOT NULL | - | 氏名 |
| created_at | datetime | NOT NULL | CURRENT_TIMESTAMP | 作成日時 |
| updated_at | datetime | NOT NULL | CURRENT_TIMESTAMP | 更新日時 |

**インデックス**
- `index_users_on_email` (UNIQUE)

---

### 2.2 sessions（ユーザーセッション）

ユーザーのログインセッションを管理するテーブル（Rails 8 Authentication）。

| カラム名 | 型 | 制約 | デフォルト | 説明 |
|---------|-----|------|-----------|------|
| id | bigint | PK, NOT NULL | auto | 主キー |
| user_id | bigint | FK, NOT NULL | - | ユーザーID |
| ip_address | string(45) | | - | IPアドレス |
| user_agent | string(255) | | - | ユーザーエージェント |
| created_at | datetime | NOT NULL | CURRENT_TIMESTAMP | 作成日時 |
| updated_at | datetime | NOT NULL | CURRENT_TIMESTAMP | 更新日時 |

**インデックス**
- `index_sessions_on_user_id`

**外部キー**
- `user_id` → `users.id` (ON DELETE CASCADE)

---

### 2.3 admin_users（管理者ユーザー）

管理者情報を管理するテーブル。顧客とは完全に分離。

| カラム名 | 型 | 制約 | デフォルト | 説明 |
|---------|-----|------|-----------|------|
| id | bigint | PK, NOT NULL | auto | 主キー |
| email | string(255) | NOT NULL, UNIQUE | - | メールアドレス |
| password_digest | string(255) | NOT NULL | - | パスワードハッシュ |
| name | string(100) | NOT NULL | - | 氏名 |
| created_at | datetime | NOT NULL | CURRENT_TIMESTAMP | 作成日時 |
| updated_at | datetime | NOT NULL | CURRENT_TIMESTAMP | 更新日時 |

**インデックス**
- `index_admin_users_on_email` (UNIQUE)

---

### 2.4 admin_sessions（管理者セッション）

管理者のログインセッションを管理するテーブル。

| カラム名 | 型 | 制約 | デフォルト | 説明 |
|---------|-----|------|-----------|------|
| id | bigint | PK, NOT NULL | auto | 主キー |
| admin_user_id | bigint | FK, NOT NULL | - | 管理者ID |
| ip_address | string(45) | | - | IPアドレス |
| user_agent | string(255) | | - | ユーザーエージェント |
| created_at | datetime | NOT NULL | CURRENT_TIMESTAMP | 作成日時 |
| updated_at | datetime | NOT NULL | CURRENT_TIMESTAMP | 更新日時 |

**インデックス**
- `index_admin_sessions_on_admin_user_id`

**外部キー**
- `admin_user_id` → `admin_users.id` (ON DELETE CASCADE)

---

### 2.5 addresses（配送先住所）

ユーザーの配送先住所を管理するテーブル。

| カラム名 | 型 | 制約 | デフォルト | 説明 |
|---------|-----|------|-----------|------|
| id | bigint | PK, NOT NULL | auto | 主キー |
| user_id | bigint | FK, NOT NULL | - | ユーザーID |
| postal_code | string(7) | NOT NULL | - | 郵便番号（ハイフンなし） |
| prefecture | string(10) | NOT NULL | - | 都道府県 |
| city | string(50) | NOT NULL | - | 市区町村 |
| address_line1 | string(100) | NOT NULL | - | 番地 |
| address_line2 | string(100) | | - | 建物名・部屋番号 |
| recipient_name | string(100) | NOT NULL | - | 届け先氏名 |
| phone_number | string(15) | NOT NULL | - | 電話番号 |
| is_default | boolean | NOT NULL | false | デフォルト住所フラグ |
| created_at | datetime | NOT NULL | CURRENT_TIMESTAMP | 作成日時 |
| updated_at | datetime | NOT NULL | CURRENT_TIMESTAMP | 更新日時 |

**インデックス**
- `index_addresses_on_user_id`
- `index_addresses_on_user_id_and_is_default`

**外部キー**
- `user_id` → `users.id` (ON DELETE CASCADE)

---

### 2.6 categories（カテゴリ）

商品カテゴリを管理するテーブル。

| カラム名 | 型 | 制約 | デフォルト | 説明 |
|---------|-----|------|-----------|------|
| id | bigint | PK, NOT NULL | auto | 主キー |
| name | string(50) | NOT NULL, UNIQUE | - | カテゴリ名 |
| slug | string(50) | NOT NULL, UNIQUE | - | URLスラッグ |
| position | integer | NOT NULL | 0 | 表示順 |
| created_at | datetime | NOT NULL | CURRENT_TIMESTAMP | 作成日時 |
| updated_at | datetime | NOT NULL | CURRENT_TIMESTAMP | 更新日時 |

**インデックス**
- `index_categories_on_name` (UNIQUE)
- `index_categories_on_slug` (UNIQUE)
- `index_categories_on_position`

---

### 2.7 products（商品）

商品情報を管理するテーブル。

| カラム名 | 型 | 制約 | デフォルト | 説明 |
|---------|-----|------|-----------|------|
| id | bigint | PK, NOT NULL | auto | 主キー |
| category_id | bigint | FK, NOT NULL | - | カテゴリID |
| name | string(100) | NOT NULL | - | 商品名 |
| description | text | | - | 商品説明 |
| price | integer | NOT NULL | - | 価格（税込、円） |
| stock | integer | NOT NULL | 0 | 在庫数 |
| is_published | boolean | NOT NULL | false | 公開フラグ |
| created_at | datetime | NOT NULL | CURRENT_TIMESTAMP | 作成日時 |
| updated_at | datetime | NOT NULL | CURRENT_TIMESTAMP | 更新日時 |

**インデックス**
- `index_products_on_category_id`
- `index_products_on_is_published`
- `index_products_on_name`
- `index_products_on_created_at`

**外部キー**
- `category_id` → `categories.id`

**備考**
- 画像はActive Storageで管理（`has_many_attached :images`）
- 論理削除を実装する場合は `deleted_at` カラムを追加

---

### 2.8 cart_items（カートアイテム）

会員ユーザーのカート内商品を管理するテーブル。

| カラム名 | 型 | 制約 | デフォルト | 説明 |
|---------|-----|------|-----------|------|
| id | bigint | PK, NOT NULL | auto | 主キー |
| user_id | bigint | FK, NOT NULL | - | ユーザーID |
| product_id | bigint | FK, NOT NULL | - | 商品ID |
| quantity | integer | NOT NULL | 1 | 数量 |
| created_at | datetime | NOT NULL | CURRENT_TIMESTAMP | 作成日時 |
| updated_at | datetime | NOT NULL | CURRENT_TIMESTAMP | 更新日時 |

**インデックス**
- `index_cart_items_on_user_id`
- `index_cart_items_on_product_id`
- `index_cart_items_on_user_id_and_product_id` (UNIQUE)

**外部キー**
- `user_id` → `users.id` (ON DELETE CASCADE)
- `product_id` → `products.id`

---

### 2.9 orders（注文）

注文情報を管理するテーブル。

| カラム名 | 型 | 制約 | デフォルト | 説明 |
|---------|-----|------|-----------|------|
| id | bigint | PK, NOT NULL | auto | 主キー |
| user_id | bigint | FK, NOT NULL | - | ユーザーID |
| order_number | string(20) | NOT NULL, UNIQUE | - | 注文番号 |
| status | enum | NOT NULL | pending | 注文ステータス |
| subtotal | integer | NOT NULL | - | 商品小計（円） |
| shipping_fee | integer | NOT NULL | - | 送料（円） |
| total | integer | NOT NULL | - | 合計金額（円） |
| postal_code | string(7) | NOT NULL | - | 配送先郵便番号 |
| prefecture | string(10) | NOT NULL | - | 配送先都道府県 |
| city | string(50) | NOT NULL | - | 配送先市区町村 |
| address_line1 | string(100) | NOT NULL | - | 配送先番地 |
| address_line2 | string(100) | | - | 配送先建物名 |
| recipient_name | string(100) | NOT NULL | - | 届け先氏名 |
| phone_number | string(15) | NOT NULL | - | 届け先電話番号 |
| ordered_at | datetime | | - | 注文確定日時 |
| created_at | datetime | NOT NULL | CURRENT_TIMESTAMP | 作成日時 |
| updated_at | datetime | NOT NULL | CURRENT_TIMESTAMP | 更新日時 |

**インデックス**
- `index_orders_on_user_id`
- `index_orders_on_order_number` (UNIQUE)
- `index_orders_on_status`
- `index_orders_on_created_at`

**外部キー**
- `user_id` → `users.id`

**備考**
- 配送先情報は注文時点のスナップショットとして保存（addressesへの参照ではなく値をコピー）
- order_numberは `ORD-YYYYMMDD-XXXXX` 形式で自動生成

---

### 2.10 order_items（注文明細）

注文に含まれる商品明細を管理するテーブル。

| カラム名 | 型 | 制約 | デフォルト | 説明 |
|---------|-----|------|-----------|------|
| id | bigint | PK, NOT NULL | auto | 主キー |
| order_id | bigint | FK, NOT NULL | - | 注文ID |
| product_id | bigint | FK, NOT NULL | - | 商品ID |
| product_name | string(100) | NOT NULL | - | 商品名（スナップショット） |
| unit_price | integer | NOT NULL | - | 購入時単価（円） |
| quantity | integer | NOT NULL | - | 数量 |
| subtotal | integer | NOT NULL | - | 小計（円） |
| created_at | datetime | NOT NULL | CURRENT_TIMESTAMP | 作成日時 |
| updated_at | datetime | NOT NULL | CURRENT_TIMESTAMP | 更新日時 |

**インデックス**
- `index_order_items_on_order_id`
- `index_order_items_on_product_id`

**外部キー**
- `order_id` → `orders.id` (ON DELETE CASCADE)
- `product_id` → `products.id`

**備考**
- product_name, unit_priceは注文時点のスナップショット（商品が変更されても注文履歴に影響しない）

---

### 2.11 payments（決済記録）

決済情報を管理するテーブル。

| カラム名 | 型 | 制約 | デフォルト | 説明 |
|---------|-----|------|-----------|------|
| id | bigint | PK, NOT NULL | auto | 主キー |
| order_id | bigint | FK, NOT NULL, UNIQUE | - | 注文ID |
| stripe_checkout_session_id | string(255) | | - | Stripe Checkout Session ID |
| stripe_payment_intent_id | string(255) | | - | Stripe Payment Intent ID |
| amount | integer | NOT NULL | - | 決済金額（円） |
| status | enum | NOT NULL | pending | 決済ステータス |
| paid_at | datetime | | - | 決済完了日時 |
| created_at | datetime | NOT NULL | CURRENT_TIMESTAMP | 作成日時 |
| updated_at | datetime | NOT NULL | CURRENT_TIMESTAMP | 更新日時 |

**インデックス**
- `index_payments_on_order_id` (UNIQUE)
- `index_payments_on_stripe_checkout_session_id`
- `index_payments_on_stripe_payment_intent_id`

**外部キー**
- `order_id` → `orders.id` (ON DELETE CASCADE)

---

## 3. Enum定義

### 3.1 order_status（注文ステータス）

```ruby
# app/models/order.rb
enum :status, {
  pending: 0,    # 未決済
  paid: 1,       # 決済済
  cancelled: 2   # キャンセル
}, default: :pending
```

### 3.2 payment_status（決済ステータス）

```ruby
# app/models/payment.rb
enum :status, {
  pending: 0,    # 決済待ち
  completed: 1,  # 決済完了
  failed: 2,     # 決済失敗
  refunded: 3    # 返金済
}, default: :pending
```

---

## 4. Active Storage テーブル

Rails Active Storageが自動生成するテーブル。

### 4.1 active_storage_blobs

| カラム名 | 型 | 説明 |
|---------|-----|------|
| id | bigint | 主キー |
| key | string | ストレージキー |
| filename | string | ファイル名 |
| content_type | string | MIMEタイプ |
| metadata | text | メタデータ |
| service_name | string | ストレージサービス名 |
| byte_size | bigint | ファイルサイズ |
| checksum | string | チェックサム |
| created_at | datetime | 作成日時 |

### 4.2 active_storage_attachments

| カラム名 | 型 | 説明 |
|---------|-----|------|
| id | bigint | 主キー |
| name | string | 関連名（例: images） |
| record_type | string | 関連モデル名（例: Product） |
| record_id | bigint | 関連レコードID |
| blob_id | bigint | Blob ID |
| created_at | datetime | 作成日時 |

### 4.3 active_storage_variant_records

| カラム名 | 型 | 説明 |
|---------|-----|------|
| id | bigint | 主キー |
| blob_id | bigint | Blob ID |
| variation_digest | string | バリエーションダイジェスト |

---

## 5. インデックス設計方針

### 5.1 検索・フィルタ用インデックス

| テーブル | カラム | 用途 |
|---------|--------|------|
| products | name | 商品名検索 |
| products | category_id | カテゴリ絞り込み |
| products | is_published | 公開商品フィルタ |
| orders | status | ステータスフィルタ |
| orders | user_id | ユーザーの注文履歴 |

### 5.2 一意性制約用インデックス

| テーブル | カラム | 用途 |
|---------|--------|------|
| users | email | メールアドレス重複防止 |
| admin_users | email | メールアドレス重複防止 |
| orders | order_number | 注文番号重複防止 |
| cart_items | user_id, product_id | 同一商品の重複防止 |

### 5.3 ソート用インデックス

| テーブル | カラム | 用途 |
|---------|--------|------|
| products | created_at | 新着順ソート |
| orders | created_at | 注文日時順ソート |
| categories | position | 表示順ソート |

---

## 6. マイグレーション実行順序

1. `create_users` - ユーザーテーブル
2. `create_sessions` - セッションテーブル
3. `create_admin_users` - 管理者テーブル
4. `create_admin_sessions` - 管理者セッションテーブル
5. `create_addresses` - 住所テーブル
6. `create_categories` - カテゴリテーブル
7. `create_products` - 商品テーブル
8. `create_cart_items` - カートアイテムテーブル
9. `create_orders` - 注文テーブル
10. `create_order_items` - 注文明細テーブル
11. `create_payments` - 決済テーブル

---

## 7. シードデータ

### 7.1 初期管理者

```ruby
# db/seeds.rb
AdminUser.find_or_create_by!(email: 'admin@example.com') do |admin|
  admin.name = '管理者'
  admin.password = 'password123'
end
```

### 7.2 カテゴリ

```ruby
categories = [
  { name: 'ファッション', slug: 'fashion', position: 1 },
  { name: '家電', slug: 'electronics', position: 2 },
  { name: '食品', slug: 'food', position: 3 },
  { name: '書籍', slug: 'books', position: 4 },
  { name: 'その他', slug: 'others', position: 5 }
]

categories.each do |cat|
  Category.find_or_create_by!(slug: cat[:slug]) do |category|
    category.name = cat[:name]
    category.position = cat[:position]
  end
end
```
