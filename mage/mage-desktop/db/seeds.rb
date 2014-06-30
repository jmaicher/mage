unless User.count > 0

  # -- Users -------------------------------------------------

  users = [
    { email: "jmaicher@mail.upb.de", name: "Julian Maicher", password: "magicpass" },
    { email: "klecks@upb.de", name: "Adrian Hülsmann", password: "magicpass" },
    { email: "julian.maicher@gmail.com", name: "Andre Nolte", password: "magicpass" },
    { email: "dinah.grueterich@gmail.com", name: "Dinah Grueterich", password: "magicpass" }
  ]

  users.each do |params|
    params[:password_confirmation] = params[:password]
    User.create! params
  end


  # -- Estimate options -------------------------------------

  estimates = {}
  estimate_options = [0, 1, 2, 3, 5, 8, 13, 20, 40, 100]
  estimate_options.each do |value|
    option = EstimateOption.create! value: value
    estimates[value] = option
  end


  # -- Backlog items ----------------------------------------

  backlog_items = [
    {
      title: "Create PBIs",
      description: "As a PO I want to create PBIs with basic information in order to represent requirements",
      tag_list: "backlog management, desktop"
    },
    {
      title: "Visualize Product Backlog",
      description: "As a PO I want to have a simple visualization of the PB n order to have an overview about the current requirements",
      tag_list: "backlog management, desktop"
    },
    {
      title: "Update PBIs",
      description: "As a PO I want to update PBIs in order to reflect changes to already captured requirements",
      tag_list: "backlog management, desktop"
    },
    {
      title: "Delete PBIs",
      description: "As a PO I want to delete PBIs in order to remove unnecessary requirements from the Product Backlog",
      tag_list: "backlog management, desktop"
    },
    {
      title: "Remove tags from PBIs",
      description: "As a PO I want to remove tags from PBIs in order to maintain the organization/taxonomy of the requirements",
      tag_list: "tagging, desktop"
    },
    {
      title: "Prioritize PBIs",
      description: "As a PO I want to manually order PBIs in order to express what's currently most/least valuable",
      tag_list: "backlog management, desktop"
    },
    {
      title: "Visualize Product Backlog on MT table",
      description: "As a PO I want to have a visualization of the Product Backlog on a MT table in order to present/discuss requirements in a collaborative setting",
      tag_list: "grooming, table"
    },
    {
      title: "Rearrange PBIs with gestures",
      description: "As a grooming participant I want to rotate and move PBIs freely in order to explore the Product Backlog",
      tag_list: "grooming, table"
    },
    {
      title: "Assign tags to PBIs",
      description: "As a PO I want to assign tags to PBIs in order to freely organize the requirements",
      tag_list: "tagging, desktop"
    },
    {
      title: "Assign predefined tags to PBIs",
      description: "As a PO I want to assign predefined tags to PBIs in order to quickly annotate requirements for later recall",
      tag_list: "tagging, table"
    },
    {
      title: "Remove tags from PBIs",
      description: "As a PO I want to remove tags from PBIs in order to maintain the organization/taxonomy of the requirements",
      tag_list: "tagging, desktop"
    },
    {
      title: "Shift focus to single PBI",
      description: "As a grooming facilitator I want to shift the focus to a single PBI in order to concentrate the collaborative effort on a single requirement",
      tag_list: "grooming, table"
    },
    {
      title: "Create ideas on mobile",
      description: "As a mobile user I want to create product ideas in order to quickly persist an idea for later recall",
      tag_list: "ideas, mobile"
    },
    {
      title: "Show ideas on mobile",
      description: "As a mobile user I want to have a list of product ideas in order to quickly access the collection of existing ideas",
      tag_list: "ideas, mobile"
    },
    {
      title: "Create ideas on desktop",
      description: "As a desktop user I want to create product ideas in order to express a new idea for the product",
      tag_list: "ideas, desktop"
    },
    {
      title: "Show ideas on desktop",
      description: "As a PO I want to have a list of product ideas in order to get input shaping and evolving the product vision",
      tag_list: "ideas, desktop"
    },
    {
      title: "Remove ideas",
      description: "As author of an idea I want to remove a created idea in order to express that this idea should be discarded",
      tag_list: "ideas"
    },
    {
      title: "Show additional details for PBI when focused on table",
      description: "As a grooming participant I want to get additional information for the focused PBI in order to have more input for decision making",
      tag_list: "grooming, board, table"
    },
    {
      title: "Join grooming activity",
      description: "As a grooming participant I want to join the grooming activity at the table in order to actively participate in the meeting",
      tag_list: "grooming, mobile, table"
    },
    {
      title: "Initiate planning poker",
      description: "As a PO I want to initiate planning poker for a given PBI in order to get an estimate from the DT",
      tag_list: "poker, table"
    },
    {
      title: "Participate in planning poker",
      description: "As a DT member I want to participate in planning poker in order to actively contribute to finding an estimate for a given PBI",
      tag_list: "poker, mobile"
    },
    {
      title: "Show planning poker results",
      description: "As a PO I want to see the planning poker results in order to see if there is a clear tendency",
      tag_list: "poker, board"
    },
    {
      title: "Allow decision based on planning poker results",
      description: "As a PO I want to accept an estimate and make a decision if there is a clear tendency",
      tag_list: "poker, board"
    },
    {
      title: "Start a new planning poker round",
      description: "As a PO I want to start a new planning poker round when no consensus has been reached",
      tag_list: "poker, board"
    },
    {
      title: "Prioritize PBIs with drag & drop",
      description: "As a PO I want to manually (re-)order PBIs with drag & drop in order to have an easy and intuitive way to do so",
      tag_list: "backlog management, desktop"
    },
    {
      title: "Show focused story in context menu",
      description: "As a grooming participant I want to see the focused story in the context menu in order to quickly access story-specific features",
      tag_list: "grooming, mobile, table"
    },
    {
      title: "Assign acceptance criteria to PBIs",
      description: "As a PO I want to assign acceptance criteria to a PBI in order to signal the DT what needs to be done to completely implement the requirement",
      tag_list: "requirements management, desktop"
    },
    {
      title: "Change notifications for Product Backlog",
      description: "As a member of the Scrum Team I want to get change notifications in the activity stream when the Product Backlog is updated",
      tag_list: "awareness, desktop"
    },
    {
      title: "Automatic generation of meeting protocols",
      description: "As a member of the Scrum Team I want to have automatically generated meeting protocols in order to comprehend and trace meeting activities afterwards",
      tag_list: "awareness, grooming, table, desktop"
    },
    {
      title: "Sprint creation",
      description: "As a PO I want to create a new Sprint in order to initiate Sprint Planning",
      tag_list: "sprint planning, desktop"
    },
    {
      title: "Assignment of PBIs to a Sprint",
      description: "As a Sprint Planner I want to assign PBIs to the Sprint Backlog",
      tag_list: "sprint planning, desktop"
    },
    {
      title: "Task decomposition of assigned PBIs",
      description: "As a member of the Development Team I want to assign tasks to PBIs in the Sprint Backlog",
      tag_list: "sprint planning, desktop"
    },
    {
      title: "Visualization of the remaining capacity",
      description: "As a member of the Development Team I want to have a visualization of the remaining capactiy in order to recognize potential over-commitment",
      tag_list: "sprint planning, awareness, desktop"
    },
    {
      title: "Transform ideas into PBIs",
      description: "",
      tag_list: "epic, ideas"
    },
    {
      title: "Allow annotations and updates to product ideas",
      description: "",
      tag_list: "epic, ideas"
    },
    {
      title: "Filtering of PBIs",
      description: "",
      tag_list: "epic, backlog management"
    },
    {
      title: "Make sprint progress visible with burndown/burnup charts",
      description: "",
      tag_list: "epic, progress tracking"
    },
    {
      title: "Make temporal relations (dependencies) between PBIs explicit and visible",
      description: "",
      tag_list: "epic, backlog management"
    },
    {
      title: "Track sprint progress with task board",
      description: "",
      tag_list: "epic, progress tracking"
    },
    {
      title: "Refine PBIs",
      description: "",
      tag_list: "epic, grooming"
    },
    {
      title: "Support for process-level inspection",
      description: "",
      tag_list: "epic, retrospectives"
    },
    {
      title: "Support for Sprint Planning",
      description: "",
      tag_list: "epic, sprint planning"
    }
  ]

  backlog = ProductBacklog.get_or_create
  backlog_items.each do |params|
    item = BacklogItem.create params
    backlog.insert(item)
  end


  # -- Demo ------------------------------------------

  params = {
    title: "Show additional information for focused PBIs",
    description: "As a grooming participant I want to see additional information for the currently focused PBI on the board in order to have more input for decision making",
    tag_list: "board, grooming, interactive workspace, needs discussion",
    estimate: estimates[5]
  }
  item = BacklogItem.create params
  backlog.insert(item)

  acceptance_criteria = [
    "Board should display additional details immediately when PBI is focused on table",
    "Show the basic information: Title, description, tags, estimate",
    "Display the acceptance criteria",
    "Show historical information about the PBI"
  ]

  acceptance_criteria.each do |description|
    item.acceptance_criteria.create description: description
  end
end
