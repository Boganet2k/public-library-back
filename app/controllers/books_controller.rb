class BooksController < ApplicationController

  def index
    @books = Book.all
    render json: @books
  end

  def show
    @book = Book.find(params[:id])

    if stale?(last_modified: @book.updated_at)
      render json: @book
    end
  end
end
