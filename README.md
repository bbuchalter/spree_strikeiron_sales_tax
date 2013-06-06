SpreeStrikeironSalesTax
===========

Uses the StrikeIron API via the strikeiron gem to calculate, apply and lock tax adjustments to orders. Assumes you will not be using any tax functionality from Spree. See below for sample integration. See spec/support/strikeiron_response.yml for sample response.

This gem was created specifically for use with Spree 1-2-stable. It is almost certainly very close to compatible with other Spree versions. Pull requests welcome!

Thanks to Drew Tempelmeyer for his work on the [strikeiron gem](https://github.com/drewtempelmeyer/strikeiron) on which this gem depends.

Setup for Production
--------------------
Add this extension to your Gemfile:

```ruby
gem "spree_strikeiron_sales_tax", :git => "git://github.com/bbuchalter/spree_strikeiron_sales_tax.git"
```

Then run:

```
bundle update
rails g spree_strikeiron_sales_tax:install
bundle exec rake db:migrate
```

### Integration
Create an initializer:

```ruby
# config/initializers/spree_strikeiron_sales_tax.rb

Strikeiron.configure do |config|
  config.user_id  = 'my_username'
  config.password = 'my_password'
end 

if Rails.env.production?
  # This will invoke API
  STRIKEIRON_TAX_CATEGORIES = Strikeiron.tax_categories.freeze
  ENABLE_STRIKEIRON_API = true # will make live API calls
else
  # Must be an array
  STRIKEIRON_TAX_CATEGORIES = [{ :category => "Sample Tax Category", :category_id => "1" }]
  ENABLE_STRIKEIRON_API = false # will use dummy data from ./spec/support/strikeiron_response.yml
end 

STRIKEIRON_TAX_CATEGORIES_FOR_SELECT = STRIKEIRON_TAX_CATEGORIES.map do |cat|
  [ cat.fetch(:category), cat.fetch(:category_id) ]
end.freeze


# Your company's taxable address
FROM_STRIKEIRON_ADDRESS = Strikeiron::Address.new({
  street_address: "920 Broadway",
  city: "New York",
  state: "NY",
  zip_code: "10010"
}).freeze
```

Now, integrate into order workflow. This will vary significantly for each Spree store, but there are two main parts.
Make sure you calculate the tax, and if the order changes, clear the tax. To minimize Strikeiron API calls, it's suggested
to only calculate the tax when the user is ready to make payment. Here is a sample implementation.

```ruby
# app/models/spree/order_decorator.rb
class Spree::Order.class_eval do
  ...

  def clear_taxes!
    adjustments.tax.destroy_all
  end

  def set_taxes!
    clear_taxes!
    
    # Option 1: Creates multiple adjustments with tax amounts for each jurisdiction
    # create_strikeiron_tax_adjustments_by_jurisdiction

    # OR!

    # Option 2: Creates a single adjustment for total tax
    # create_strikeiron_total_tax_adjustment
  end

  ...
end

# app/controllers/spree/checkout_controller_decorator.rb
Spree::CheckoutController.class_eval do
  ...

  before_filter :set_taxes, :only => :edit, :if => "current_order.payment?"

  def set_taxes
    # Checkout in a payment state, recalculate taxes.
    @order.set_taxes! if current_order.payment?
  end
  
  ...
end

# app/controllers/spree/orders_controller_decorator.rb
Spree::OrderController.class_eval do
  ...

  before_filter :clear_taxes, :only => :populate, :if => "current_order.payment?"

  def clear_taxes
    # If order has made it to payment state, then taxes have been set.
    # Now that user has added additional line items, clear the taxes.
    # They will be set again once when they return to checkout.
    current_order.clear_taxes! if current_order.payment?
  end
  
  ...
end
```





Setup for Development
---------------------

This isn't really working right now, the whole sandbox engine app thing is new to me.

```
<fork on github>
git clone git://github.com/$USER/spree_strikeiron_sales_tax
cd spree_strikeiron_sales_tax
bundle install
bundle exec rake sandbox #this will error
cd spec/dummy
```

Create spec/dummy/Gemfile:

```ruby
# spec/dummy/Gemfile

gem 'spree_strikeiron_sales_tax', :path => '../../'
```

Then update config/boot.rb:
```ruby
# replace
gemfile = File.expand_path("../../../../../Gemfile", __FILE__)
# with
gemfile = File.expand_path("../../../../Gemfile", __FILE__)
```

Then run:

```
bundle update
rails g spree_strikeiron_sales_tax:install
bundle exec rake db:migrate
```

Testing
-------

There are passing tests, but can't get them to run right now in the sandbox. Would love to get some help with this.
