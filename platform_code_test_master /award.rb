class Award
  attr_reader :name, :expires_in, :quality

  def initialize(name, expires_in, quality)
    @name = name
    @expires_in = expires_in
    @quality = quality
  end

  def update
    case @name
    when get_award_name(0) # 'Blue Compare'
      update_blue_compare_quality
    when get_award_name(1) # 'Blue First'
      update_blue_first_quality
    when get_award_name(2) # 'Blue Star'
      update_blue_star_quality
    when get_award_name(3) # Normal Item
      update_normal_quality
    end
    update_expires_in_value unless @name == get_award_name(4) # "Blue Distinction Plus" remains at 80 quality indefinitely
    ensure_quality # max value does not go over 50 or 80
  end

  def update_blue_compare_quality
    if award_expired?
      @quality = 0 
    elsif @quality <= 50
      if @expires_in <= 5
        @quality += 3
      elsif @expires_in <= 10
        @quality += 2
      elsif @expires_in > 10
        @quality += 1
      end
    end
  end

  def update_expires_in_value
    @expires_in -= 1
  end

  def award_expired?
    return true if @expires_in <= 0
  end

  def ensure_quality
    @quality = 50 if @quality > 50 && @name == get_award_name(0) # Blue Compare
    @quality = 80 if @quality != 80 && @name == get_award_name(4) # Blue Distinction Plus
  end

  def update_blue_first_quality
    @quality += 1 if @quality < 50 # Quality should not exceed 50
    @quality += 1 if award_expired? && @quality < 50 # "Blue First" awards actually increase in quality the older they get
  end

  def update_blue_star_quality
    @quality -= 2 if @quality > 0
    @quality -= 2 if award_expired? && @quality > 0
  end

  def update_normal_quality
    @quality -= 1 if @quality > 0
    @quality -= 1 if award_expired?
  end

end
