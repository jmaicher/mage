# -- Users -------------------------------------------------

users = [
  { email: "jmaicher@mail.upb.de", password: "magicpass" },
  { email: "klecks@upb.de", password: "magicpass" }
]

users.each do |params|
  params[:password_confirmation] = params[:password]
  User.create! params
end


# -- Backlog items ----------------------------------------

backlog_items = [
  { title: "Create PBIs", description: "As a PO I want to create PBIs with basic information in order to represent requirements" },
  { title: "Visualize Product Backlog", description: "As a PO I want to have a simple visualization of the PB n order to have an overview about the current requirements" },
  { title: "Prioritize PBIs", description: "As a PO I want to manually order PBIs in order to express what's currently most/least valuable" }
]

backlog = ProductBacklog.get
backlog_items.each do |params|
  item = BacklogItem.new params
  backlog.insert(item)
end


# -- Estimate options -------------------------------------

estimate_options = [0, 1, 2, 3, 5, 8, 13, 20, 40, 100]
estimate_options.each do |value|
  EstimateOption.create! value: value
end


