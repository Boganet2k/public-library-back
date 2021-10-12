class BooksController < ApplicationController
  include Response
  before_action :authenticate_user!
  before_action :checkForAdminPermission, only: [:create, :update, :destroy]
  before_action :set_book, only: [:show, :update, :destroy]

  def index
    if params[:code]
      #Select only available books
      # @books = Book.where.not('exists (?)', Reservation.unscope(where: :to).where('reservations.book_id = books.id and reservations.to is null').select(1))
      @books = Book.joins(:reservations).reservations_with_code(params[:code]).with_status(params[:status]).find_by_title(params[:title]).find_by_author(params[:author])
    else
      @books = Book.includes(:reservations).with_status(params[:status]).find_by_title(params[:title]).find_by_author(params[:author])
    end

    render json: @books, include: 'reservations', status: :ok
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
    @book.deleted_at = DateTime.now

    if @book.available? && @book.save
      head :no_content
    else
      head :error
    end

  end

  def book_params
    # whitelist params
    params.permit(:title, :author, :description)
  end

  def set_book
    @book = Book.find(params[:id])
  end

  def checkForAdminPermission

    @isAccessGranted = false

    @ROLE_ADMIN = Role.getRole[:admin]

    current_user.roles.each do |role|

      if role.name.eql? @ROLE_ADMIN
        @isAccessGranted = true
        break
      end
    end

    if !@isAccessGranted
      json_response(nil, :unauthorized)
    end
  end
end
