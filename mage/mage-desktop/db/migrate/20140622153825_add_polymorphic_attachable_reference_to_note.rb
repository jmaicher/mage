class AddPolymorphicAttachableReferenceToNote < ActiveRecord::Migration
  def change
    add_reference :notes, :attachable, polymorphic: true, index: true
  end
end
