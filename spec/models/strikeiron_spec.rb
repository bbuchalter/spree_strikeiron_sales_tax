require "spec_helper"

describe "Strikeiron" do
  let(:strikeiron_response_path) { Rails.root + "spec/support/strikeiron_response.txt" }
  let(:strikeiron_response) { File.open(strikeiron_response_path) { |f| YAML.load(f) }.freeze }
  let(:order) { Spree::Order.new }

  before do
    order.stub(strikeiron: strikeiron_response)
  end

  it "should have two tax values" do
    assert_equal 2, order.strikeiron.tax_values.count
  end

  it "should aggegrate taxes for each jursidication" do
    expected_value = {
      "New York County Tax" => 18.63,
      "New York State Tax" => 16.56,
      "Metro Commuter Trans. District Tax" => 1.55
    }
    assert_equal expected_value, order.strikeiron_taxes_by_jurisdiction
  end
end
