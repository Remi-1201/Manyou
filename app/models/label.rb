class Label < ApplicationRecord
  belongs_to :user, optional: true
  has_many :labelings, dependent: :destroy
end
