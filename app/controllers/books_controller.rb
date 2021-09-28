class BooksController < ApplicationController
  include Response
  before_action :authenticate_user!
  before_action :set_book, only: [:show, :update, :destroy]

  def index
    p "index " + current_user.email
    @books = Book.all
    json_response(@books)
  end

  def create
    p "create " + current_user.email
    @book = Book.create!(book_params)
    json_response(@book, :created)
  end

  def update
    p "update " + current_user.email
    @book.update(book_params)
    head :no_content
  end

  def show
    p "show " + current_user.email
    @book = Book.find(params[:id])

    if stale?(last_modified: @book.updated_at)
      render json: @book
    end
  end

  def destroy
    p "destroy " + current_user.email
    @book.destroy
    head :no_content
  end

  def book_params
    # whitelist params
    params.permit(:title, :author, :description)
  end

  def set_book
    @book = Book.find(params[:id])
  end
end
