class ApplicationMailer < ActionMailer::Base
  default to: SETTINGS.try(:[], :feedback_email).try(:[], 'to')
end
