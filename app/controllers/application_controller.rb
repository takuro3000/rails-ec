class ApplicationController < ActionController::Base
  include Authentication

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # TODO: 本番環境で有効化を検討
  # allow_browser versions: :modern

  # Importmapの変更でetagを無効化（テストでの互換性のため無効化）
  # stale_when_importmap_changes
end
