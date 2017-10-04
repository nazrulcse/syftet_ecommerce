class UsersController < ApplicationController
  before_action :authenticate_user!

  def my_account

  end
end