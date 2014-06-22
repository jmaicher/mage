require 'active_support/concern'

module Roles::NoteAttachable
  extend ActiveSupport::Concern

  included do
    has_many :notes, as: :attachable
  end

end # Roles::NoteAttachable
