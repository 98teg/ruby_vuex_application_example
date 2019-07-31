class UsersController < ApplicationController
  before_action :authenticate!, only: %i[show update destroy]
  before_action :set_user, only: %i[show update destroy]

  # GET /users
  def index
    render_index User.filter(params[:filter])
                     .ordenate(params[:sort])
                     .paginate(params[:page])
  end

  # GET /users/1
  def show
    render_item @user
  end

  # PATCH/PUT /users/1
  def update
    authorize @user
    if @user.update(user_params)
      render_item @user
    else
      render json: @user.errors.details, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    authorize @user
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
end
