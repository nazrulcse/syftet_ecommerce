module ApplicationHelper
  # TODO: need to delete this two methods and activate cancan
  def can? *args
    true
  end

  def cannot? *args
    true
  end
end
