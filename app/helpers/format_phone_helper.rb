module FormatPhoneHelper
  # Format phone number as (XXX) XXX-XXXX
  def format_phone(number)

    # return without formatting if number is not present
    if !number.present?
      return
    end

    result = number.gsub(/[^\d]/, '')

    # return without formatting if number is of the wrong length
    if result.length > 10 || result.length < 10
      return number
    end

    "(#{result[0..2]}) #{result[3..5]}-#{result[6..10]}"
  end
end