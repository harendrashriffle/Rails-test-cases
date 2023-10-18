class UsersController < ApplicationController

  skip_before_action :authenticate_request, only: [:create, :user_login, :forgot_password, :reset_password]

  def user_login
    if user = User.find_by(email: params[:email], password_digest: params[:password_digest])
      token = jwt_encode(user_id: user.id)
      render json: { message: "Logged In Successfully..", token: token }
    else
      render json: { error: "Please Check your Email And Password....." }
    end
  end

  def create
    user = User.new(set_params)
    return render json: {errors: user.errors.full_messages} unless user.save
    # UserMailer.welcome_email(user).deliver_now
    render json: {message:"User Created", data: user}
  end

  def show
    render json: @current_user
  end

  def update
    render json: { message: "User profile updated"} if @current_user.update(set_params)
    render json: { errors: @current_user.errors.full_messages }
  end

  def destroy
    return render json: {errors: "Your Account doesn't deleted"} unless @current_user.destroy
    UserMailer.deletion_email(@current_user).deliver_now
    render json: {message: "Your Account deleted succesfully"}
  end

  def forgot_password
    return render json: {message: "Kindly provide email"} if params[:email].blank?
    user = User.find_by(email: params[:email])
    return render json: {message: "Email Not Found"} if user.nil?
    user.update(reset_password_token: SecureRandom.hex(10),reset_password_sent_at: Time.now)
    # UserMailer.password_token(user).deliver_now
    render json: { message: "Password Reset Token has been sent to your email"}
  end

  def reset_password
    return render json: {message: "Email is not present"} if params[:email].blank?
    user = User.find_by(reset_password_token: params[:token])
    if user.present? && user.reset_password_sent_at > 1.minute.ago
      user.update(reset_password_token:nil, password_digest: params[:password_digest])
      render json: {message: "Password Reset Successfully"}
    else
      render json: {message: "Invalid Token"}, status: :unprocessable_entity
    end
  end

#----------------------------PRIVATE METHOD-------------------------------------

  private
    def set_params
      params.permit(:name,:email,:password_digest,:type)
    end
end
