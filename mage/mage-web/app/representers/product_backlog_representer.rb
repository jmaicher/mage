class ProductBacklogRepresenter < BacklogRepresenter
  link :self do
    api_backlog_url
  end
end # ProductBacklogRepresenter
