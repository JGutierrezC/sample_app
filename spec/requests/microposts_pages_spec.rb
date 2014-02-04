require 'spec_helper'

describe 'Microposts Pages' do

  subject{page}
  let(:user){FactoryGirl.create(:user)}
  before{sign_in user}

  describe "micropost creation" do

    before {visit root_path}

    describe "with invalid information" do

      it "should not create a micropost" do
        expect{click_button "Post"}.should_not change(Micropost, :count)
      end

      describe "error message" do
        before{click_button "Post"}
        it {should have_content('error')}
      end

    end

    describe "with valid information" do
      before{fill_in 'micropost_content', with:'lorem ipsum dolo'}
      it 'should create a micropost' do
        expect{click_button "Post"}.should change(Micropost, :count).by(1)
      end
    end
  end


end