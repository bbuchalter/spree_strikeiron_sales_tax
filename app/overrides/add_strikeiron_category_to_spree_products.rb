Deface::Override.new(:virtual_path => "spree/admin/products/_form",
                     :name => "add_strikeiron_category_to_spree_products",
                     :insert_bottom => "[data-hook='admin_product_form_additional_fields']",
                     :partial => "spree/admin/products/add_strikeiron_category_to_spree_products")
