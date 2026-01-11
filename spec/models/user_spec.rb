# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  describe "バリデーション" do
    subject { build(:user) }

    describe "name" do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_length_of(:name).is_at_least(2).is_at_most(50) }
    end

    describe "email" do
      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.to validate_uniqueness_of(:email) }

      it "有効なメールアドレス形式を受け入れる" do
        valid_emails = %w[user@example.com USER@foo.COM user+tag@example.org]
        valid_emails.each do |email|
          subject.email = email
          expect(subject).to be_valid
        end
      end

      it "無効なメールアドレス形式を拒否する" do
        invalid_emails = %w[user@ plainaddress user@@example.com]
        invalid_emails.each do |email|
          subject.email = email
          expect(subject).not_to be_valid
        end
      end
    end

    describe "password" do
      it { is_expected.to validate_presence_of(:password).on(:create) }
      it { is_expected.to validate_length_of(:password).is_at_least(8).on(:create) }
    end
  end

  describe "アソシエーション" do
    it { is_expected.to have_many(:sessions).dependent(:destroy) }
  end

  describe "has_secure_password" do
    let(:user) { create(:user, password: "password123") }

    it "パスワードが正しい場合に認証成功" do
      expect(user.authenticate("password123")).to eq(user)
    end

    it "パスワードが間違っている場合に認証失敗" do
      expect(user.authenticate("wrongpassword")).to be_falsey
    end
  end

  describe "セッションの削除" do
    it "ユーザー削除時にセッションも削除される" do
      user = create(:user)
      user.sessions.create!(ip_address: "127.0.0.1", user_agent: "Test Agent")

      expect { user.destroy }.to change(Session, :count).by(-1)
    end
  end
end
