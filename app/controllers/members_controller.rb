class MembersController < ApplicationController
  before_action :authenticate_user!

  def show
    render json: { message: "If you see this, you're in!" + current_user.email}
  end
end