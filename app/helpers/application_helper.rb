module ApplicationHelper
  def round_down(number)
    divisor = 10**Math.log10(number).floor
    i = number / divisor
    remainder = number % divisor
    if remainder == 0
      i * divisor
    else
      (i + 1) * divisor
    end
  end

  def pipeline
    sum = 0
    User.where(bank:false).each do |f| 
      if f.loan_sizes.any?
        amount = f.loan_sizes.first.description.split("$")[-1][0..-2].to_i
        sum += amount
      end
    end
    num = (sum * 3 / 100) * 2
    num = num.round * 100*1000/2 #times 100 to round, times 1000 to get thousands of dollars, divided by 2 for average
    return number_with_delimiter(num, :delimiter => ',')
  end

 def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end  

  def bootstrap_class_for flash_type
    case flash_type
      when :success
        "alert-success"
      when :error
        "alert-error"
      when :alert
        "alert-block"
      when :notice
        "alert-info"
      else
        flash_type.to_s
    end
  end
end
