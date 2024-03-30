class ApplicationMailer < ActionMailer::Base
  default from: email_address_with_name('no-reply@cytonic.net', "CytonicMC")
  include Devise::Mailers::Helpers

  def confirmation_instructions(record, token, opts = {})
    @token = token
    if record.pending_reconfirmation?
      devise_mail(record, :reconfirmation_instructions, opts)
    else
      devise_mail(record, :confirmation_instructions, opts)
    end
  end

  def reset_password_instructions(record, token, opts = {})
    @token = token
    devise_mail(record, :reset_password_instructions, opts)
  end
end
