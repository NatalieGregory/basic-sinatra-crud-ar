require "spec_helper.rb"

# As an anonymous person, I can fill out the
# registration form to create an account

# When submitting the form, I should
# see "Thank you for registering"
#
# This message should go away when I refresh
# the page.

feature "#registration" do
  scenario "creates account upon submit" do
    visit "/registration/"

    fill_in "username", :with => "pgrunde"

    fill_in "password", :with => "drowssap"

    click_button "Register"

    expect(page).to have_content("Thank you for registering")

    visit "/registration/"

    fill_in "username", :with => ""

    click_button "Register"

    expect(page).to have_content("Username is required.")

    fill_in "password", :with => ""

    click_button "Register"

    expect(page).to have_content("Password is required.")

    fill_in "username", :with => ""

    fill_in "password", :with => ""

    click_button "Register"

    expect(page).to have_content("Username and password are required.")
  end
end