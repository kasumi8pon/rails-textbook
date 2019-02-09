# frozen_string_literal: true

require "rails_helper"

RSpec.describe BooksController, type: :controller do
  before do
    @user = FactoryBot.create(:user)
    @book = FactoryBot.create(:book)
    @book_params = FactoryBot.attributes_for(:book)
  end

  describe "#index" do
    context "認証済みのユーザーとして" do
      it "正常にレスポンスを返すこと" do
        sign_in @user
        get :index
        expect(response).to be_successful
      end
    end

    context "ゲストとして" do
      it "サインイン画面にリダイレクトされること" do
        get :index
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#show" do
    context "認証済みのユーザーとして" do
      it "正常にレスポンスを返すこと" do
        sign_in @user
        get :show, params: { id: @book.id }
        expect(response).to be_successful
      end
    end

    context "ゲストとして" do
      it "サインイン画面にリダイレクトされること" do
        get :show, params: { id: @book.id }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#new" do
    context "認証済みのユーザーとして" do
      it "正常にレスポンスを返すこと" do
        sign_in @user
        get :new
        expect(response).to be_successful
      end
    end

    context "ゲストとして" do
      it "サインイン画面にリダイレクトされること" do
        get :new
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#edit" do
    context "認証済みのユーザーとして" do
      it "正常にレスポンスを返すこと" do
        sign_in @user
        get :edit, params: { id: @book.id }
        expect(response).to be_successful
      end
    end

    context "ゲストとして" do
      it "サインイン画面にリダイレクトされること" do
        get :edit, params: { id: @book.id }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#create" do
    context "認証済みのユーザーとして" do
      it "本が作成されること" do
        sign_in @user
        expect {
          post :create, params: { book: @book_params }
        }.to change(Book, :count).by(1)
      end
    end

    context "ゲストとして" do
      it "本が作成されないこと" do
        expect {
          post :create, params: { book: @book_params }
        }.not_to change(Book, :count)
      end
    end
  end

  describe "#update" do
    context "認証済みのユーザーとして" do
      it "本が更新されること" do
        sign_in @user
        @book_params[:title] = "変更後のタイトル"
        post :update, params: { id: @book.id, book: @book_params }
        expect(@book.reload.title).to eq "変更後のタイトル"
      end
    end

    context "ゲストとして" do
      it "本が更新されないこと" do
        @book_params[:title] = "変更後のタイトル"
        post :update, params: { id: @book.id, book: @book_params }
        expect(@book.reload.title).to eq @book.title
      end
    end
  end

  describe "#destroy" do
    context "認証済みのユーザーとして" do
      it "本が削除されること" do
        sign_in @user
        expect {
          post :destroy, params: { id: @book.id }
        }.to change(Book, :count).by(-1)
      end
    end
    
    context "ゲストとして" do
      it "本が削除されないこと" do
        expect {
          post :destroy, params: { id: @book.id }
        }.not_to change(Book, :count)
      end
    end
  end
end
