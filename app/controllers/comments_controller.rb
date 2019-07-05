class CommentsController < ApplicationController
  before_action :authenticate?, only: %i[create update destroy]
  before_action :set_comment, only: %i[show update destroy]

  def authenticate?
    render status: :unauthorized unless authenticate
  end

  # GET /comments
  def index
    @comments = Comment.get(params[:filter])
    @comments = Comment.order(@comments, params[:sort])
    @comments = Comment.paginate(@comments, params[:page])

    render_json @comments
  end

  # GET /comments/1
  def show
    render_json @comment
  end

  # POST /comments
  def create
    @comment = Comment.new(comment_params)

    if @comment.save
      CommentNotificationMailer.with(comment: @comment)
                               .send_notification.deliver_later
      render json: @comment, status: :created, location: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(comment_params)
      render_json @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def comment_params
    params.require(:data).permit(:content, :user_id, :post_id)
  end

  def render_json(comments)
    render json: {data: comments.as_json(representation: :basic)}
  end
end
