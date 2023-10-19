class ApplicationController < ActionController::Base

  before_action do
    ActiveStorage::Current.url_options = { protocol: request.protocol, host: request.host, port: request.port }
  end

  include JsonWebToken

  # ................Authentication request............

  before_action :authenticate_request

  # ...................Authenticate User..................

  def authenticate_request
    begin
      header = request.headers[ 'Authorization' ]
      header = header.split(" ").last if header
      decoded = jwt_decode(header)
      @current_user = User.find(decoded[:user_id])
    rescue StandardError
       render json: { error: 'Invalid token' }, status: :unprocessable_entity
    end
  end

  #------------------OWNER HAS RIGHT TO------------------
    def owner_has_right_to
      # byebug
      unless @current_user.type == "Owner"
        render json: {message: "Customer's don't have the access"}, status: :unauthorized
      end
    end

end
