class Feedback
  def initialize(email:, message:, recaptcha:)
    @email = email
    @message = message
    @recaptcha = recaptcha
  end

  def valid?
    return false unless recaptcha
    return false if message.blank?

    return false if email.present? && !email.match?(/[^\s]@[^\s]/)

    true
  end

  def error
    return unless recaptcha

    return 'Please fill out the comments field' if message.blank?

    return if email.blank?

    'Please fill in a valid email'
  end

  private

  attr_reader :email, :message, :recaptcha
end
