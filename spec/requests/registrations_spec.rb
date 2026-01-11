# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Registrations", type: :request do
  describe "GET /sign_up" do
    it "会員登録フォームを表示する" do
      get sign_up_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /sign_up" do
    context "有効なパラメータの場合" do
      let(:valid_params) do
        {
          user: {
            name: "テストユーザー",
            email: "test@example.com",
            password: "password123",
            password_confirmation: "password123"
          }
        }
      end

      it "ユーザーを作成する" do
        expect {
          post sign_up_path, params: valid_params
        }.to change(User, :count).by(1)
      end

      it "セッションを作成する（自動ログイン）" do
        expect {
          post sign_up_path, params: valid_params
        }.to change(Session, :count).by(1)
      end

      it "session_id Cookieを設定する" do
        post sign_up_path, params: valid_params

        expect(cookies[:session_id]).to be_present
      end

      it "トップページにリダイレクトする" do
        post sign_up_path, params: valid_params

        expect(response).to redirect_to(root_path)
      end

      it "フラッシュメッセージを表示する" do
        post sign_up_path, params: valid_params

        expect(flash[:notice]).to eq("会員登録が完了しました")
      end
    end

    context "無効なパラメータの場合" do
      let(:invalid_params) do
        {
          user: {
            name: "",
            email: "invalid-email",
            password: "short",
            password_confirmation: "different"
          }
        }
      end

      it "ユーザーを作成しない" do
        expect {
          post sign_up_path, params: invalid_params
        }.not_to change(User, :count)
      end

      it "セッションを作成しない" do
        expect {
          post sign_up_path, params: invalid_params
        }.not_to change(Session, :count)
      end

      it "422 Unprocessable Entityを返す" do
        post sign_up_path, params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "メールアドレスが重複している場合" do
      before do
        create(:user, email: "existing@example.com")
      end

      let(:duplicate_params) do
        {
          user: {
            name: "新規ユーザー",
            email: "existing@example.com",
            password: "password123",
            password_confirmation: "password123"
          }
        }
      end

      it "ユーザーを作成しない" do
        expect {
          post sign_up_path, params: duplicate_params
        }.not_to change(User, :count)
      end

      it "422 Unprocessable Entityを返す" do
        post sign_up_path, params: duplicate_params

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
