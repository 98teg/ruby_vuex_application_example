class UsersController < ApplicationController
  before_action :authenticate?, only: %i[show update destroy]
  before_action :set_user, only: %i[show update destroy]

  def authenticate?
    render status: :unauthorized unless authenticate
  end

  # GET /users
  def index
    @users = User.get(params[:filter])
    @users = User.order(@users, params[:sort])
    @users = User.paginate(@users, params[:page])

    render_json @users
  end

  # GET /users/1
  def show
    render_json @user
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
    params.require(:data).permit(:name, :email)
  end

  def render_json(users)
    render json: {data: users.as_json(representation: :basic)}
  end
end
