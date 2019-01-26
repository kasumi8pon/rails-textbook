# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Users", type: :feature do
  it "ユーザー登録ができること" do
    visit new_user_registration_path
    fill_in "Eメール", with: "example@example.com"
    attach_file "プロフィール画像", "#{Rails.root}/spec/files/attachment.jpg"
    fill_in "パスワード", with: "example"
    fill_in "パスワード（確認用）", with: "example"
    click_button "新規ユーザー登録"
    expect(page).to have_content "アカウント登録が完了しました。"
    expect(page).to have_content "ログイン中のユーザー example@example.com"
  end

  it "ユーザー情報の編集ができること" do
    user = FactoryBot.create(:user)
    sign_in user
    visit edit_user_registration_path
    fill_in "Eメール", with: "example@example.com"
    attach_file "プロフィール画像", "#{Rails.root}/spec/files/attachment.jpg"
    fill_in "パスワード", with: "example"
    fill_in "パスワード（確認用）", with: "example"
    fill_in "現在のパスワード", with: "password"
    click_button "編集"
    expect(page).to have_content "アカウント情報を変更しました。"
    expect(page).to have_content "ログイン中のユーザー example@example.com"
  end

  it "ユーザーの削除ができること" do
    user = FactoryBot.create(:user)
    sign_in user
    visit edit_user_registration_path
    click_button "ユーザー削除"
    expect(page).to have_content "アカウント登録もしくはログインしてください。"
    expect(page).not_to have_content "ログイン中のユーザー example@example.com"
  end

  it "登録されたユーザーでログインができること" do
    user = FactoryBot.create(:user)
    visit new_user_session_path
    fill_in "Eメール", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログイン"
    expect(page).to have_content "ログインしました。"
    expect(page).to have_content "ログイン中のユーザー #{user.email}"
  end

  it "登録されていないユーザーではログインができないこと" do
    user = FactoryBot.build(:user)
    visit new_user_session_path
    fill_in "Eメール", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログイン"
    expect(page).to have_content "Eメールまたはパスワードが違います。"
  end

  it "パスワードが間違っている場合、ログインできないこと" do
    user = FactoryBot.create(:user)
    visit new_user_session_path
    fill_in "Eメール", with: user.email
    fill_in "パスワード", with: "incorrect#{user.password}"
    click_button "ログイン"
    expect(page).to have_content "Eメールまたはパスワードが違います。"
  end

  it "Facebook認証で初回ログインができること" do
    OmniAuth.config.test_mode = true
    params = { info: { email: "example@example.com" }, provider: "facebook", uid: 12345 }
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(params)
    visit root_path
    click_link "Facebookでログイン", match: :first
    expect(page).to have_content "Facebook アカウントによる認証に成功しました。"
    expect(page).to have_content "ログイン中のユーザー example@example.com"
  end

  it "Facebook認証で、以前ログインしたユーザーとして再度ログインができること" do
    OmniAuth.config.test_mode = true
    user = FactoryBot.create(:user, :sign_up_with_facebook)
    params = { info: { email: user.email }, provider: user.provider, uid: user.uid }
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(params)
    visit root_path
    click_link "Facebookでログイン", match: :first
    expect(page).to have_content "Facebook アカウントによる認証に成功しました。"
    expect(page).to have_content "ログイン中のユーザー #{user.email}"
  end

  it "Facebook認証に失敗した場合、ログインページに戻ること" do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
    visit root_path
    click_link "Facebookでログイン", match: :first
    expect(page).to have_content "アカウント登録もしくはログインしてください"
  end
end
