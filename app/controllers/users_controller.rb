# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    @user = User.find_by! profile_token: params[:id]
    @ideas = @user.ideas
  end
end
