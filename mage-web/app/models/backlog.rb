class Backlog < ActiveRecord::Base

  has_many :backlog_item_assignments
  has_many :items, through: :backlog_item_assignments, source: :backlog_item

  def insert(item)
    assignment = BacklogItemAssignment.new backlog_item: item, priority: nil
    self.backlog_item_assignments << assignment
  end

  def insert_at(item, target_priority)
    raise StandardError("Item belongs to different backlog") unless item.backlog == self
    item_assignment = item.backlog_assignment

    if target_priority.nil? or target_priority == self.append_priority
      item_assignment.priority = target_priority
      item_assignment.save!
      return
    end

    return if item.priority == target_priority or target_priority < 0 or target_priority > self.append_priority
    
    current_priority = item.backlog_assignment.priority

    transaction do
      item_assignment.priority = nil
      item_assignment.save!

      if current_priority.nil? or current_priority > target_priority
        from = current_priority.nil? ? max_priority : current_priority - 1
        to = target_priority

        from.downto(to) do |i|
          assignment = find_backlog_item_assignment_by_priority(i)
          assignment.increment!(:priority)
        end
      else
        from = current_priority + 1
        to = target_priority
        
        from.upto(to) do |i|
          assignment = find_backlog_item_assignment_by_priority(i)
          assignment.decrement!(:priority)
        end
      end

      item_assignment.priority = target_priority
      item_assignment.save!
    end # transaction

  end

  def max_priority
    backlog_item_assignments.prioritized.last.try(:priority)
  end

  def append_priority
    (max_priority or 0) + 1
  end

private

  def find_backlog_item_assignment_by_priority(priority)
    self.backlog_item_assignments.where(priority: priority).first
  end

end
