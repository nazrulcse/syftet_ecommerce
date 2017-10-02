module ApplicationHelper
  # TODO: need to delete this two methods and activate cancan
  def can? *args
    true
  end

  def cannot? *args
    true
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
