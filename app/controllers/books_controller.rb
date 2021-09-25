class BooksController < ApplicationController
  include Response
  before_action :set_book, only: [:show, :update, :destroy]

  def index
    @books = Book.all
    json_response(@books)
  end

  def create
    @book = Book.create!(book_params)
    json_response(@book, :created)
  end

  def update
    @book.update(book_params)
    head :no_content
  end

  def show
    @book = Book.find(params[:id])

    if stale?(last_modified: @book.updated_at)
      render json: @book
    end
  end

  def destroy
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
