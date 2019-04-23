require "rails_helper"

RSpec.feature "Changing Password To Existing Partner", type: :feature do
  let(:parner_email) { "diapers@example.com" }
  let(:old_password) { "Abc123$!#" }
  let(:new_password) { "Xyz%@#321" }

  before(:each) do
    let(:partner) do
      create(:partner,
             email: partner_email,
             password: old_password)
    end
    visit "/partners/sign_in"
    within("form") do
      fill_in "EMAIL", with: partner_email
      fill_in "PASSWORD", with: old_password
    end
    click_button "Login"
  end

  context "Update Partner" do
    scenario "should be successful" do
      visit "/partners/1/edit"
      click_link "Change your password"
      within("form") do
        fill_in "Email", with: partner_email
        fill_in "Password", with: new_password
        fill_in "Password confirmation", with: new_password
        fill_in "Current password", with: old_password
      end
      click_button "Update"

      expect(page).to have_content "Your account has been successfully updated"

      visit "/partners/sign_in"
      within("form") do
        fill_in "EMAIL", with: partner_email
        fill_in "PASSWORD", with: new_password
      end
      click_button "Login"

      expect(page).to have_content "Signed in successful"

      visit "/partners/sign_in"
      within("form") do
        fill_in "EMAIL", with: partner_email
        fill_in "PASSWORD", with: old_password
      end
      click_button "Login"

      expect(page).to have_content "SIGN IN"
    end
  end
end
