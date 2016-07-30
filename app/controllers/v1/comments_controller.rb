module V1
  class CommentsController < ApiController

    def index
      render json: User.find(params[:id]).comments
    end
  end
end
