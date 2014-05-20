class EstimateOption < ActiveRecord::Base
  validates_presence_of :value
  validates_uniqueness_of :value
end
