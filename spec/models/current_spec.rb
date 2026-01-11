# frozen_string_literal: true

require "rails_helper"

RSpec.describe Current, type: :model do
  describe "session属性" do
    let(:user) { create(:user) }
    let(:session) { user.sessions.create!(ip_address: "127.0.0.1") }

    after do
      Current.reset
    end

    it "セッションを設定・取得できる" do
      Current.session = session
      expect(Current.session).to eq(session)
    end
  end

  describe "userへのデリゲート" do
    let(:user) { create(:user) }
    let(:session) { user.sessions.create!(ip_address: "127.0.0.1") }

    after do
      Current.reset
    end

    it "セッションが設定されている場合、ユーザーを取得できる" do
      Current.session = session
      expect(Current.user).to eq(user)
    end

    it "セッションが設定されていない場合、nilを返す" do
      Current.session = nil
      expect(Current.user).to be_nil
    end
  end
end
