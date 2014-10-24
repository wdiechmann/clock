class JobberMailer < ActionMailer::Base
  # Default Mail Values
  default from: Rails.application.secrets.admin_email

  def welcome_email(jobber,user)
    @jobber = jobber
    # I am overriding the 'to' default
    mail(from: user.email, to: @jobber.email, subject: t('jobber_mailer.welcome'))
  end

end
