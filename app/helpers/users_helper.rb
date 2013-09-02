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

  def profile_picture(user)
    # if user.avatar.present?
    #   image_tag user.avatar.url(:original)
    # els
    if user.authentications.where(:provider == "linkedin").any?
      image_tag user.pic_url, class:"medium-thumbnail img-circle"
    else
      image_tag "default_profile_pic.png", class:"medium-thumbnail img-circle"
    end
  end

  def small_profile_picture(user)
    # if user.avatar.present?
    #   image_tag user.avatar.url(:original)
    # els
    if user.authentications.where(:provider == "linkedin").any?
      image_tag user.pic_url, class:"small-thumbnail img-circle"
    else
      image_tag "default_profile_pic.png", class:"small-thumbnail img-circle"
    end
  end


  def large_profile_picture(user)
    # if user.avatar.present?
    #   image_tag user.avatar.url(:original)
    # els
    if user.authentications.where(:provider == "linkedin").any?
      image_tag user.pic_url, class:"img-polaroid large-thumbnail img-circle"
    else
      image_tag "default_profile_pic.png", class:"img-polaroid large-thumbnail img-circle"
    end
  end
end