Strikeiron::Jurisdiction.class_eval do
  def state?
    fips.length == 2 and fips.to_i != 0
  end
  def county?
    fips.length == 3 and fips.to_i != 0
  end
  def fips_type
    return "County" if county?
    return "State" if state?
    return ""
  end
  def fips_name
    fips_name = name
    fips_name = fips_name.titleize if name.respond_to?(:titleize)
    fips_name += " " + fips_type if fips_type != ""
    fips_name
  end

  def tax_name
    fips_name + " Tax"
  end
end
