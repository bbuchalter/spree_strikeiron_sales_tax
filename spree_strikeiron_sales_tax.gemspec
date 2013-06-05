# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_strikeiron_sales_tax'
  s.version     = '0.1'
  s.summary     = 'StrikeIron Sales Tax Adjustments for Spree'
  s.required_ruby_version = '>= 1.8.7'

  s.author            = 'Brian Buchalter'
  s.email             = 'bal711@gmail.com'
  s.homepage          = 'https://github.com/bbuchalter/spree_strikeiron_sales_tax'

  s.files         = `git ls-files`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '1.2.4'
  s.add_dependency 'strikeiron'

  s.add_development_dependency 'rspec-rails', '~> 2.12.0'
  s.add_development_dependency 'sqlite3'
end
