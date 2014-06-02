class ActivityStreamCell < Cell::Rails

  def activity(args)
    @activity = args[:activity]
    render
  end

end
