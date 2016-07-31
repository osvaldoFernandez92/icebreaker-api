module V1
  class UsersController < ApiController
    before_action :authenticate_request, only: [:show, :me, :update]

    def index
      render json: User.all, each_serializer: UserSerializer
    end

    # POST /v1/users
    def create
      user = User.new(register_params)
      return render status: :bad_request, json: { errors: user.errors } unless user.save
      ids = braintree_request(user, :create_customer, 'BraintreeCreateCustomerWorker')
      render status: :created,
             location: status_api_v1_braintree_requests_url(jid: ids[:job_id],
                                                            rid: ids[:req_id]),
             json: user, serializer: UserSerializer, with_token: UserJwt.new(user).generate_token
    end

    # GET /v1/users/:id
    def show
      return render status: :ok, json: current_user,
                    serializer: UserSerializer
    end

    # PUT /v1/users/:id
    def update
      return render status: :bad_request, json: { errors: current_user.errors } unless
        current_user.update(edit_params)
      render status: :ok, json: current_user, serializer: UserSerializer
    end

    def me
     render status: :ok, json: current_user, serializer: UserSerializer
    end

    private

    def register_params
      params.permit(
        email: Parameters.string,
        password: Parameters.string
      )
    end

    def edit_params
      params.permit(:first_name, :last_name, :gender, :age, :description, interests: [])
    end
  end
end
