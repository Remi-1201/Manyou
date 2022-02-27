class Task < ApplicationRecord
  has_many :labelings, dependent: :destroy
  has_many :labels, through: :labelings
  accepts_nested_attributes_for :labels, reject_if: :all_blank, allow_destroy: true
  belongs_to :user

  validates :name, presence: true, length: {maximum: 120}
  validates :details, presence: true, length: {maximum: 1000}
end
