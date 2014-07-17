require "spec_helper.rb"

feature "homepage" do
  scenario "should have a button" do
    visit "/"
    expect(page).to have_content("Register")
  end
end
feature "registration_form" do
  scenario "links to registration form" do
    visit "/"
    click_link "Register"
    expect(page).to have_content("username")
  end


end

feature "User Authentication" do
  before(:each) do
    visit "/"
    click_link "Register"

    fill_in "username", :with => "pgrunde"
    fill_in "password", :with => "drowssap"

    click_button "Register"

    click_link "Register"

    fill_in "username", :with => "luke"
    fill_in "password", :with => "evan"

    click_button "Register"

    fill_in "Username", :with => "pgrunde"
    fill_in "Password", :with => "drowssap"

    click_button "Login"
  end
  scenario "allows user to login" do
    expect(page).to have_content("Welcome, pgrunde!")

    expect(page).to have_content("Logout")

    expect(page).to have_no_content("Login")

    expect(page).to have_no_content("Register")
  end
  scenario "allows user to log out" do
    click_link "Logout"
    expect(page).to have_content("Register")
    expect(page).to have_content("Username")
  end

  scenario "A logged in user can view a list of ALL users on the homepage" do

    expect(page).to have_content("luke")

  end

end