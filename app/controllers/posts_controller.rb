class PostsController < ApplicationController
  before_action :set_post, only: %i[show update destroy]

  # GET /posts
  def index
    @posts = Post.get(params[:filter])
    @posts = Post.order(@posts, params[:sort])
    @posts = Post.paginate(@posts, params[:page])

    render_json @posts
  end

  # GET /posts/1
  def show
    render_json @post
  end

  # POST /posts
  def create
    @post = Post.new(post_params)

    if @post.save
      render json: {data: @post.as_json(representation: :basic)}, status: :created, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    if @post.update(post_params)
      render_json @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def post_params
    params.require(:data).permit(:title, :content, :user_id, :image)
  end

  def render_json(posts)
    render json: {data: posts.as_json(representation: :basic)}
  end
end
