# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Books", type: :feature do
  before do
    user = FactoryBot.create(:user)
    visit root_path
    sign_in user
    click_button "ログイン"
  end

  it "本の情報を新規登録できること" do
    visit books_path
    click_link "新規登録"
    fill_in "題名", with: "本のタイトル"
    fill_in "覚書", with: "本に関するメモ"
    fill_in "著者", with: "本の作者"
    attach_file "画像", "#{Rails.root}/spec/files/attachment.jpg"
    click_button "登録する"
    expect(page).to have_content "登録に成功しました。"
    click_link "戻る"
    expect(page).to have_content "本のタイトル"
    expect(page).to have_content "本に関するメモ"
    expect(page).to have_content "本の作者"
    expect(page).to have_content "attachment.jpg"
  end

  it "本の情報を一覧ページで読み込めること" do
    book = FactoryBot.create(:book)
    visit books_path
    expect(page).to have_content book.title
  end

  it "本の情報を詳細ページで読み込めること" do
    book = FactoryBot.create(:book)
    visit books_path
    click_link "詳細"
    expect(page).to have_content book.title
  end

  it "本の情報を編集できること" do
    book = FactoryBot.create(:book)
    visit books_path
    click_link "編集"
    fill_in "題名", with: "本のタイトル2"
    fill_in "覚書", with: "本に関するメモ2"
    fill_in "著者", with: "本の作者2"
    attach_file "画像", "#{Rails.root}/spec/files/attachment.jpg"
    click_button "更新する"
    expect(page).to have_content "更新に成功しました。"
    click_link "戻る"
    expect(page).to have_content "本のタイトル2"
    expect(page).to have_content "本に関するメモ2"
    expect(page).to have_content "本の作者2"
    expect(page).to have_content "attachment.jpg"
  end

  it "本の情報を削除できること" do
    book = FactoryBot.create(:book)
    visit books_path
    click_link "削除"
    expect(page).to have_content "削除に成功しました。"
    expect(page).not_to have_content book.title
  end
end
