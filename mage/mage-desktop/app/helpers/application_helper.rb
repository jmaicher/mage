module ApplicationHelper

  def activity_actor(actor)
    link_to actor.name, '', class: 'actor-link'
  end

  def activity_action(key)
    case key.split(".").last
    when "update"
      "updated"
    when "create"
      "created"
    else
      "????"
    end
  end

  def backlog_item_description(item)
    if item.description.blank?
      item.description
    else
      content_tag :span, "No description provided", class: "empty"
    end
  end

end # ApplicationHelper
