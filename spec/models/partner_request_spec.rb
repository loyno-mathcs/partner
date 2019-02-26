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

  describe "a valid 990" do
    it "requires proof of form 990" do
      partner_stubbed = build(:partner, :with_990_attached)
      expect(build_stubbed(:partner_request, partner: partner_stubbed).partner.export_json.dig(:stability, :form_990_link)).to include("f990.pdf")
     # expect(build_stubbed(:partner_request).partner.proof_of_form_990.attached?).to eq true
    end
  end


  describe "#formatted_items_hash" do
    let(:partner_request) { create(:partner_request_with_items, items_count: 1) }
    it "builds the item hash values for export json" do
      item = partner_request.items.first
      formatted_hash = { item.name => item.quantity }
      expect(partner_request.formatted_items_hash(partner_request.items)).to eql(formatted_hash)
    end
  end

  describe "a request without an item quantity" do
    let(:partner_request) { build(:partner_request) }
    let(:item) { build(:item, name: "test", quantity: nil, partner_request: partner_request) }
    it "fails" do
      partner_request.items << item
      expect(partner_request.save).to be false
      expect(partner_request.errors.messages[:"items.quantity"]).to include("can't be blank")
    end
  end
end
