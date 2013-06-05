Spree::Order.class_eval do
  def strikeiron_taxes_by_jurisdiction
    tax_for = {}
    strikeiron.tax_values.each do |tv|
      tv.jurisdictions.each do |j|
        current_tax = tax_for[j.tax_name].to_f
        additional_tax = j.tax_amount.to_f
        
        tax_for[j.tax_name] = (current_tax + additional_tax).round(2)
      end
    end
    tax_for
  end

  def strikeiron
    if Rails.env.production?
      @strikeiron_response ||= Strikeiron.sales_tax(:from => FROM_STRIKEIRON_ADDRESS, :to => billing_address.to_strikeiron, :tax_values => strikeiron_line_items ) 
    else
      @strikeiron_response ||= File.open(File.dirname(__FILE__)+"/../../../spec/support/strikeiron_response.txt") { |f| YAML.load(f) }
    end
  end

  def reset_strikeiron
    @strikeiron_response = nil
  end

  def create_strikeiron_tax_adjustments
    strikeiron_taxes_by_jurisdiction.each do |label, amount|
      adjustments.create({:amount =>      amount,
                          :source =>      self,
                          :originator =>  self,
                          :label =>       label,
                          :mandatory =>   true,
                          :locked =>      true,
			  :originator_type => "Spree::TaxRate"}, :without_protection => true)
    end
  end

  def strikeiron_line_items
    line_items.map(&:to_strikeiron).select { |li| !li.nil? }
  end
end
