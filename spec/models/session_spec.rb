# frozen_string_literal: true

require "rails_helper"

RSpec.describe Session, type: :model do
  describe "アソシエーション" do
    it { is_expected.to belong_to(:user) }
  end

  describe "セッション作成" do
    let(:user) { create(:user) }

    it "ユーザーに紐づくセッションを作成できる" do
      session = user.sessions.create!(
        ip_address: "192.168.1.1",
        user_agent: "Mozilla/5.0"
      )

      expect(session).to be_persisted
      expect(session.user).to eq(user)
      expect(session.ip_address).to eq("192.168.1.1")
      expect(session.user_agent).to eq("Mozilla/5.0")
    end

    it "ip_addressとuser_agentは任意" do
      session = user.sessions.create!

      expect(session).to be_persisted
      expect(session.ip_address).to be_nil
      expect(session.user_agent).to be_nil
    end
  end
end
