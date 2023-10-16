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
    rescue JWT::DecodeError => e
       render json: { error: 'Invalid token' }, status: :unprocessable_entity
    end
    rescue ActiveRecord::RecordNotFound
      render json: "No record found.."
  end

  #------------------OWNER HAS RIGHT TO------------------
    def owner_has_right_to
      unless @current_user.type == "Owner"
        render json: {message: "Customer's don't have the access"}
      end
    end

end
