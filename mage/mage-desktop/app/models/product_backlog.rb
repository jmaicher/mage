class ProductBacklog < Backlog
  def self.get
    self.all.first || ProductBacklog.create
  end
end # ProductBacklog
