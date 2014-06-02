class ActivityStreamCell < Cell::Rails

  def show(args)
    @activities = args[:activities]
    render
  end

  def activity(args)
    @activity = args[:activity]
    render
  end

end
