require 'spec_helper'

describe "Ahthentication" do
  subject { page }

  describe "signin page" do
    before { visit signin_path}

    it {should have_selector('title', text: 'Sign in')}

    describe "with invalid information" do
      before {click_button "Sign in"}
      it {should have_selector('h1', text: 'Sign in')}
      it {should have_selector('div.alert.alert-error', text: 'Incorrect login:')}

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end

    end

    describe "with valid information" do
      let(:user){FactoryGirl.create :user}
      before {
        fill_in "session_email", with: user.email
        fill_in "session_password", with: user.password
        click_button 'Sign in'
      }

      #it {should have_selector 'h1', text: 'Sign in'}
      it {should have_link('Profile', href: user_path(user))}
      it {should have_link('Sign out', href:signout_path)}
      it {should have_link('Settings', href:edit_user_path(user))}
      it {should_not have_link('Sign in', href:signin_path)}

      describe 'followed by a sign out' do
        before {click_link 'Sign out'}
        it {should have_link 'Sign in', href:signin_path}
      end
    end

  end

  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "session_email", with:user.email
          fill_in "session_password", with:user.password
          click_button "Sign in"
        end

        describe "after signin in" do
          it "should render the desired protected page" do
            page.should have_selector('title', text: 'Edit user')
          end
        end
      end
    end

    describe 'for non-signed-in users' do
      let (:user) {FactoryGirl.create :user}

      describe 'in the Users controller' do

        describe 'visiting the edit page' do
          before { visit edit_user_path(user)}
          it {should have_selector('title', text:'Sign in')}
        end

        describe 'submiting to the update action' do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end

        describe "visiting the user's index"  do
          before {visit users_path}
          it{ should have_selector('h1', text: "Sign In")}
        end

      end

    end

    describe "as wrong user" do
      let(:user){FactoryGirl.create(:user)}
      let(:wrongUser){FactoryGirl.create(:user, email:"wrong@example.com")}
      before{sign_in user}

      describe "visting users#edit" do
        before { visit edit_user_path(wrongUser) }
        it {should_not have_selector('title', 'Edit user') }
      end

      describe "Submitting PUT request to Users#Edit " do
        before {put user_path(wrongUser)}
        debugger

        specify {response.should redirect_to(root_path)}
      end
    end
  end
end