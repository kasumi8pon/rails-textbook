# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  it "eメールとパスワードがあれば有効な状態であること" do
    user = FactoryBot.create(:user)
    expect(user).to be_valid
  end

  it "eメールがなければ無効な状態であること" do
    user = User.new(email: nil)
    user.valid?
    expect(user.errors[:email]).to include("を入力してください")
  end

  it "パスワードがなければ無効な状態であること" do
    user = User.new(password: nil)
    user.valid?
    expect(user.errors[:password]).to include("を入力してください")
  end

  it "重複したメールアドレスなら無効な状態であること" do
    original_user = FactoryBot.create(:user)
    new_user = User.new(
      email: original_user.email,
      password: "password"
    )
    new_user.valid?
    expect(new_user.errors[:email]).to include("はすでに存在します")
  end
end
