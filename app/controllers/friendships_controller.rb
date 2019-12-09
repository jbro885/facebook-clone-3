# frozen_string_literal: true

class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  def index
    @friends = current_user.friends
    @pending_friends = current_user.pending_friends
    @friends_requests = current_user.friend_requests
  end

  def create
    @friendship = current_user.friendships.build(friendship_params)
    if @friendship.save
      flash[:success] = 'Friend request created.'
    else
      flash[:warning] = 'Friend request failed.'
    end
    redirect_to users_path
  end

  def destroy
    @friendship = Friendship.find(params[:id])
    @friendship.destroy_friendship
    flash[:success] = 'Friendship deleted successfully'
    redirect_to friendships_path
  end

  def update
    @friendship = Friendship.find(params[:id])
    if @friendship.confirm_friendship
      flash[:success] = 'Friendship accepted'
    else
      flash[:warning] = 'Failed to accept Friendship'
    end
    redirect_to friendships_path
  end

  private

  def friendship_params
    params.require(:friendship).permit(:friend_id)
  end
end
