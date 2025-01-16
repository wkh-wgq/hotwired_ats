class ApplicantMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.applicant_mailer.contact.subject
  #
  def contact(email:)
    @email = email
    @applicant = @email.applicant
    @user = @email.user

    mail(
      to: @applicant.email,
      form: @user.email,
      subject: @email.subject
    )
  end
end
