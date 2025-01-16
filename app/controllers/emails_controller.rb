class EmailsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_applicant

  def new
    @email = Email.new
  end

  def create
    @email = Email.new(email_params)
    @email.applicant = @applicant
    @email.user = current_user
    if @email.save
      render turbo_stream: turbo_stream.prepend(
        "flash-container",
        partial: "shared/flash",
        locals: { level: :success, content: "Email sent!" }
      )
    else
      render turbo_stream: turbo_stream.replace(
        "email-form",
        partial: "form",
        locals: { email: @email, applicant: @applicant }
      ), status: :unprocessable_entity
    end
  end

  private
    def set_applicant
      @applicant = Applicant.find params[:applicant_id]
    end

    def email_params
      params.require(:email).permit(:subject, :body)
    end
end
