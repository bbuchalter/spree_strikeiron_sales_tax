class AddStrikeironCategoryIdToSpreeProduct < ActiveRecord::Migration
  def change
    add_column :spree_products, :strikeiron_category_id, :string
  end
end
