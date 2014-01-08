module UsersHelper
  def calls_to_action
   [
    "Strike up a conversation...",
    "Open your rolladeck...",
    "Start smiling and start dialing...",
    "Relationships start with a question...",
    "Start with a question: What is their biggest challenge?",
    "Don't close a sale, open a relationship...",
    "Start with a question: What are they most proud of?",
    "What are you waiting for? Contact your match!",
    "They signed up to be contacted...",
    "Your match wants you to contact them...",
    "Make a customer, not a sale...",
    "Victory goes to the bold...",
    "Triumph is just 'Try' with a little umph!",
    "Don't get ready to speak, get ready to listen...",
    "Don't close a sale, open a relationship...",
    "If you don't reach out, your competitor will...",
    "Make a customer, not a sale...",
    "Are you ready to RUUUUUMBLE?"
    ]
  end

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