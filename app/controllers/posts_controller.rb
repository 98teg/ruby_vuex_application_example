class PostsController < ApplicationController
  before_action :authenticate!, only: %i[create update destroy]
  before_action :set_post, only: %i[show update destroy]

  # GET /posts
  def index
    render_index Post.filter(params[:filter])
                    .ordenate(params[:sort])
                    .paginate(params[:page])
  end

  # GET /posts/1
  def show
    render_item @post
  end

  # POST /posts
  def create
    @post = Post.new(post_params.merge(user_id: current_user.id))

    if @post.save
      render json: {data: @post.as_json(representation: :basic)}, status: :created, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    authorize @post
    if @post.update(post_params.merge(user_id: current_user.id))
      render_item @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    authorize @post
    @post.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def post_params
    params.require(:data).permit(:title, :content, :image)
  end
end
