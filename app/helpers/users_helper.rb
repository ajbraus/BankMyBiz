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

  def image_url(user)
    if user.avatar.present?
      user.avatar.url(:original)
    elsif user.authentications.where(:provider == "linkedin").any?
      user.pic_url
    else
      "http://bankmybiz.com/assets/default_profile_pic.png"
    end
  end

  def profile_picture(user)
    if user.avatar.present?
      image_tag user.avatar.url(:original), class:"medium-thumbnail img-circle"
    elsif user.authentications.where(:provider == "linkedin").any?
      image_tag user.pic_url, class:"medium-thumbnail img-circle"
    else
      image_tag "default_profile_pic.png", class:"medium-thumbnail img-circle"
    end
  end

  def small_profile_picture(user)
    if user.avatar.present?
      image_tag user.avatar.url(:original), class:"small-thumbnail img-circle"
    elsif user.authentications.where(:provider == "linkedin").any?
      image_tag user.pic_url, class:"small-thumbnail img-circle"
    else
      image_tag "default_profile_pic.png", class:"small-thumbnail img-circle"
    end
  end


  def large_profile_picture(user)
    if user.avatar.present?
      image_tag user.avatar.url(:original), class:"img-polaroid large-thumbnail img-circle"
    elsif user.authentications.where(:provider == "linkedin").any?
      image_tag user.pic_url, class:"img-polaroid large-thumbnail img-circle"
    else
      image_tag "default_profile_pic.png", class:"img-polaroid large-thumbnail img-circle"
    end
  end
end