# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Interface Posts', type: :feature do
  let(:user) { create(:user) }

  describe 'Interface Posts' do
    before(:each) do
      @post1 = user.posts.create(FactoryBot.attributes_for(:post))
      @post2 = user.posts.create(FactoryBot.attributes_for(:post))
      @post3 = user.posts.create(FactoryBot.attributes_for(:post))
      visit root_path
      within 'form' do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        click_button 'Log in'
      end
    end

    scenario 'Creating a post succesfully!' do
      expect do
        fill_in 'post_content', with: 'This is the content of the post!'
        click_button 'Publish'
        expect(page).to have_content 'Post created successfully.'
        expect(page).to have_content 'This is the content of the post!'
      end.to change(user.posts, :count).by(1)
    end

    scenario "index post with the User's post" do
      expect(page).to have_content(@post1.content)
      expect(page).to have_content(@post2.content)
      expect(page).to have_content(@post3.content)
    end

    # scenario "index post with the User's posts and friend's posts" do
    #  expect(page).to have_content('Error')
    # end

    scenario 'editing posts' do
      click_link 'My Profile'
      within "#post-#{@post1.id}" do
        click_link 'Edit Post'
      end
      expect(page).to have_current_path(edit_post_path(@post1))
    end
  end
end
