module ApplicationHelper

  def display_categories?
    controller_name == 'gifts' && action_name != 'show'
  end

  def display_thanks?
    controller_name == 'gifts' && action_name == 'index'
  end

end
