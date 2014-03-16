class ProductBacklog < Backlog

  def self.get
    self.all.first or ProductBacklog.create
  end

end

