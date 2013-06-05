Spree::Address.class_eval do
  def to_strikeiron
    Strikeiron::Address.new(:street_address => address1.to_s, :city => city.to_s, :state => state.try(:abbr).to_s, :zip_code => zipcode.to_s)
  end
end
