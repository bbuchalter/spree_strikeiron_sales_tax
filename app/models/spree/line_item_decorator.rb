Spree::LineItem.class_eval do
  def to_strikeiron
    return unless variant.product.strikeiron_category_id.present? and self.amount > 0
    Strikeiron::TaxValue.new(:category_id => variant.product.strikeiron_category_id.to_s, :amount => self.amount.to_s)
  end
end
