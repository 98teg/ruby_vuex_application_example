class UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]

  # GET /users
  def index
    @users = User.all

    render_json @users
  end

  # GET /users/1
  def show
    render_json @user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: {data: @user.as_json(representation: :basic)}, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render_json @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(:name, :email)
  end

  def render_json(users)
    render json: {data: users.as_json(representation: :basic)}
  end
end
