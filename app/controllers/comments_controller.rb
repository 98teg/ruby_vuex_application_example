class CommentsController < ApplicationController
  include RailsAuthorize

  before_action :authenticate!, only: %i[create update destroy]
  before_action :set_comment, only: %i[show update destroy]

  # GET /comments
  def index
    render_index Comment.filter(params[:filter])
                        .ordenate(params[:sort])
                        .paginate(params[:page])
  end

  # GET /comments/1
  def show
    render_item @comment
  end

  # POST /comments
  def create
    @comment = Comment.new(comment_params.merge(user_id: current_user.id))

    if @comment.save
      render json: @comment, status: :created, location: @comment
    else
      render json: @comment.errors.details, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /comments/1
  def update
    authorize @comment
    if @comment.update(comment_params)
      render_item @comment
    else
      render json: @comment.errors.details, status: :unprocessable_entity
    end
  end

  # DELETE /comments/1
  def destroy
    authorize @comment
    @comment.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def comment_params
    params.require(:data).permit(:content, :post_id)
  end
end
