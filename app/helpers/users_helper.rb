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

  def profile_picture(user)
    # if user.avatar.present?
    #   image_tag user.avatar.url(:original)
    # els
    if user.authentications.where(:provider == "linkedin").any?
      image_tag user.pic_url, class:"medium-thumbnail img-rounded"
    else
      image_tag "default_profile_pic.png", class:"medium-thumbnail img-rounded"
    end
  end

  def small_profile_picture(user)
    # if user.avatar.present?
    #   image_tag user.avatar.url(:original)
    # els
    if user.authentications.where(:provider == "linkedin").any?
      image_tag user.pic_url, class:"small-thumbnail img-rounded"
    else
      image_tag "default_profile_pic.png", class:"small-thumbnail img-rounded"
    end
  end


  def large_profile_picture(user)
    # if user.avatar.present?
    #   image_tag user.avatar.url(:original)
    # els
    if user.authentications.where(:provider == "linkedin").any?
      image_tag user.pic_url, class:"img-polaroid large-thumbnail img-rounded"
    else
      image_tag "default_profile_pic.png", class:"img-polaroid large-thumbnail img-rounded"
    end
  end
end