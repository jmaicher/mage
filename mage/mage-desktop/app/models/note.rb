require 'carrierwave/orm/activerecord'

class Note < ActiveRecord::Base
  default_scope { order(created_at: :desc) }

  mount_uploader :image, NoteImageUploader

  # -- Associations -------------------------------------

  belongs_to :author, class_name: "User"
  belongs_to :attachable, polymorphic: true

  # -- Validations --------------------------------------

  validates_presence_of :title
  validates_length_of :title, minimum: 5, maximum: 75


  def has_image?
    image.file.nil?
  end

end # Note
