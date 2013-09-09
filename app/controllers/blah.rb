  if matches.none? ||matches.last.created_at < Date.yesterday
    @available_users =er.all.reject { |r| r ==|| r.bank ==bank || r.in?(u.matched_users) }
    @matches = @available_users.select do |s| 
      if s.ages.any? &&ages.any?
        with_age = (s.age_ids &age_ids).present?
      end
      if s.industries &&industries.any?
        with_industry = (s.industry_ids &industry_ids).present?
      end
      if s.locations.any? &&locations.any?
        with_location = (s.location_ids &location_ids).present?
      end
      if s.employee_sizes.any? &&employee_sizes.any?
        with_employee_size = (s.employee_size_ids &employee_size_ids).present?
      end
      if s.revenue_sizes.any? &&revenue_sizes.any?
        with_revenue_size = (s.revenue_size_ids &revenue_size_ids).present?
      end
      if s.business_types.any? &&business_types.any?
        with_business_type = (s.business_type_ids &business_type_ids).present?
      end

      with_age == true ||
      with_industry == true ||
      with_location == true ||
      with_employee_size == true ||
      with_revenue_size == true ||
      with_business_type == true
    end
    
   matched_users << @matches.first if @matches.any?
  end

  #PEERS
  ifpeers.none? ||peers.last.created_at < Date.yesterday
    @available_users =er.all.reject { |r| r ==|| r.bank !=bank || r.in?(u.peered_users) }
    @peers = @available_users.select do |s| 
      if s.ages.any? &&ages.any?
        with_age = (s.age_ids &age_ids).present?
      end
      if s.industries &&industries.any?
        with_industry = (s.industry_ids &industry_ids).present?
      end
      if s.locations.any? &&locations.any?
        with_location = (s.location_ids &location_ids).present?
      end
      if s.employee_sizes.any? &&employee_sizes.any?
        with_employee_size = (s.employee_size_ids &employee_size_ids).present?
      end
      if s.revenue_sizes.any? &&revenue_sizes.any?
        with_revenue_size = (s.revenue_size_ids &revenue_size_ids).present?
      end
      if s.business_types.any? &&business_types.any?
        with_business_type = (s.business_type_ids &business_type_ids).present?
      end

      with_age == true ||
      with_industry == true ||
      with_location == true ||
      with_employee_size == true ||
      with_revenue_size == true ||
      with_business_type == true
    end

    if @peers.count >= 3
     peered_users << @peers.first(3) 
    elsif @peers.count == 2
     peered_users << @peers.first(2) 
    elsif @peers.count == 1
     peered_users << @peers.first 
    end
  end
end