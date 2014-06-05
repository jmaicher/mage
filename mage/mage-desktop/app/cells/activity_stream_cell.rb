class ActivityStreamCell < Cell::Rails
  helper ApplicationHelper

  def activity(args)
    @activity = args[:activity]

    render view: template_for(@activity)
  end

private

  def template_for activity
    # "backlog_items.new => backlog_items_new 
    template = "#{activity.key.split(".").first}_activity"
    return template if template_exists?("activity_stream/#{template}")
      else default_template
  end

  def default_template
    'default_activity'
  end

end
