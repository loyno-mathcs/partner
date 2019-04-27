require "rails_helper"

RSpec.describe PartnerRequest, type: :model do
  it { is_expected.to have_many(:items).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:partner) }

  describe "a valid PartnerRequest" do
    it "requires a Partner" do
      expect(build_stubbed(:partner_request)).to be_valid
      expect(build_stubbed(:partner_request, partner: nil)).not_to be_valid
    end
  end

  describe "#formatted_items_hash" do
    let(:partner_request) { create(:partner_request_with_items, items_count: 1) }
    it "builds the item hash values for export json" do
      partner_request.reload
      item = partner_request.items.first
      formatted_hash = { item.name => item.quantity }
      expect(partner_request.formatted_items_hash(partner_request.items)).to eql(formatted_hash)
    end
  end

  describe "a request without an item quantity" do
    let(:partner_request) { build(:partner_request) }
    let(:item) { build(:item, name: "test", quantity: nil, partner_request: partner_request) }
    let(:partner_request_with_items) do
      create(:partner_request_with_items,
             items_count: 1,
             items: [build(:item, name: "k_newborn", quantity: 1, partner_request: nil)])
    end
    it "fails when adding a new item" do
      partner_request.items << item
      expect(partner_request.save).to be false
      expect(partner_request.errors.messages[:"items.quantity"]).to include("can't be blank")
    end
    it "fails when modifying attributes on an item" do
      partner_request_with_items.items.first.quantity = nil # not nil when test run
      expect(partner_request_with_items.items.first.quantity).to be nil
      # expect(partner_request_with_items.save).to be true # always fails because of validation
      partner_request_with_items.items.first.name = "k_preemie"
      expect(partner_request_with_items.save).to be false # this is true bc value not being set to nil
      expect(partner_request_with_items.errors.messages[:"items.quantity"]).to include("can't be blank")
    end
  end
end