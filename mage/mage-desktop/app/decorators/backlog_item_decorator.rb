class BacklogItemDecorator < Draper::Decorator
  delegate_all

  def has_description?
    ! object.description.blank?
  end

  def description
    unless object.description.blank?
      object.description    
    else
      "This item has currently no description" 
    end
  end

end
