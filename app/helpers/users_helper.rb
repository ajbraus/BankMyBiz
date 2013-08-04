module UsersHelper
  def us_states
    [
      ['AL'],
      ['AK'],
      ['AZ'],
      ['AR'],
      ['CA'],
      ['CO'],
      ['CT'],
      ['DE'],
      ['DC'],
      ['FL'],
      ['GA'],
      ['HI'],
      ['ID'],
      ['IL'],
      ['IN'],
      ['IA'],
      ['KS'],
      ['KY'],
      ['LA'],
      ['ME'],
      ['MD'],
      ['MA'],
      ['MI'],
      ['MN'],
      ['MS'],
      ['MO'],
      ['MT'],
      ['NE'],
      ['NV'],
      ['NH'],
      ['NJ'],
      ['NM'],
      ['NY'],
      ['NC'],
      ['ND'],
      ['OH'],
      ['OK'],
      ['OR'],
      ['PA'],
      ['PR'],
      ['RI'],
      ['SC'],
      ['SD'],
      ['TN'],
      ['TX'],
      ['UT'],
      ['VT'],
      ['VA'],
      ['WA'],
      ['WV'],
      ['WI'],
      ['WY']
    ]
  end

  def bank_type
    [
      ['Bank'],
      ['Credit Union'],
      ['Factoring Company'],
      ['Private Equity'],
      ['Non-Profit Investment'],
      ['Angel Investment']
    ]
  end

  def business_types
    [
      ['LLC'],
      ['C-Corp'],
      ['SP'],
      ['Partnership'],
      ['LLP'],
      ['Non-Stock']
    ]
  end

  def industries
    [
      ['Service'],
      ['Retail'],
      ['Manufacturing'],
      ['Distribution'],
      ['Construction'],
      ['Restaurant'],
      ['Consulting'],
      ['Entertainment'],
      ['CRE'],
      ['Residential Real Estate'],
      ['Nonprofit'],
      ['Healthcare'],
      ['IT'],
      ['Startup'],
      ['Other']
    ]
  end

  def years_of_operation
    [
      ['0-1'],
      ['2-5'],
      ['5+']
    ]
  end

  def size_revenue
    [
      ['$0-$100k'],
      ['$100k-$1m'],
      ['$1m-$5m'],
      ['$5M-10M'],
      ['$10M and Above']
    ]
  end

  def size_employees
    [
      ['0-6'],
      ['7-24'],
      ['25-99'],
      ['500-999'],
      ['999-2999'],
      ['3000+']
    ]
  end

  def large_profile_picture(user)
    # if user.avatar.present?
    #   image_tag user.avatar.url(:original)
    # els
    if user.authentications.where(:provider == "linkedin").any?
      image_tag user.pic_url, class:"small-thumbnail"
    else
      image_tag "https://s3.amazonaws.com/bankmybiz-production/user/avatars/original/default_profile_pic.png"
    end
  end

  def small_profile_picture(user)
    if user.authentications.where(:provider == "Facebook").any?
      facebook_url = "#{user.authentications.find_by_provider("Facebook").pic_url}"
      image_tag(facebook_url, alt: user.name, class: "profile_picture small_pic" )
    elsif user.authentications.where(:provider == "Twitter").any?
      twitter_picture(user, type: "normal") 
    else
      if user.avatar.url.nil?
        image_tag "https://s3.amazonaws.com/hoosin-production/user/avatars/raster/default_profile_pic.png",
         class: "profile_picture small_pic"
      else
        image_tag user.avatar.url(:raster), class: "profile_picture small_pic"
      end
    end
  end 
end







