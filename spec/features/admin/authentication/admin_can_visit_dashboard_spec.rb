require 'rails_helper'

  feature "admin dashboard" do
    feature "admin can visit the admin dashboard" do
      scenario "I will see a heading on the page that says Admin Dashboard" do
        admin_user = User.create(first_name: "Admin", last_name: "McAdmin", email: "admin@admin.com", password: "boom")
        role = Role.create(title: "platform_admin")
        admin_user.roles << role
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin_user)

        visit admin_dashboard_index_path
        expect(page).to have_content("Admin Dashboard")
      end
    end
  end

  describe "as a logged in user when I visit /admin/dashboard" do
    it "I see a 404 error" do
      default_user = User.create(first_name: "Admin", last_name: "McAdmin", email: "admin@admin.com", password: "boom")
      role = Role.create(title: "registered_user")
      default_user.roles << role
      allow_any_instance_of(ApplicationController).to receive(:current_user). and_return(default_user)

      expect {
        visit admin_dashboard_index_path
      }.to raise_error(ActionController::RoutingError)
    end
  end


  describe "as a visitor when I visit /admin/dashboard" do
    it "I see a 404 error" do
      expect {
        visit admin_dashboard_index_path
      }.to raise_error(ActionController::RoutingError)
    end
  end


feature "as an Admin" do
  describe "when I log into my account" do

    it "I am redirected to the Admin Dashboard" do
      admin = User.create(first_name: "Admin", last_name: "McAdmin", email: "admin@admin.com", password: "boom")
      role = Role.create(title: "platform_admin")
      admin.roles << role

      visit login_path


      fill_in "session[email]", with: admin.email
      fill_in "session[password]", with: admin.password
      within(".login-path") do
        click_on("Login")
      end

      expect(page).to have_content("Admin Dashboard")

      expect(current_path).to eq(admin_dashboard_index_path)
    end
  end
end
