class Task < ApplicationRecord
  has_many :labelings, dependent: :destroy
  has_many :labels, through: :labelings
  accepts_nested_attributes_for :labels, reject_if: :all_blank, allow_destroy: true
  belongs_to :user, optional: true

  validates :name, presence: true, length: {maximum: 120}
  validates :detail, presence: true, length: {maximum: 1000}

  enum status: {
    未着手: 0,
    着手中: 1,
    完了: 2
  }

  enum priority: {
    高: 0,
    中: 1,
    低: 2
  }

  # sort by created_at
  scope :sorted, -> { order(created_at: :desc) }
  # sort by status
  scope :status_sort, -> (search_status){ where(status: search_status) }
  scope :priority_sort, -> (search_priority){ where(priority: search_priority) }

  # seach by name/word
  scope :search_sort, -> (search_word){ where('name LIKE ?', "%#{search_word}%") }
  
  scope :kaminari, -> (kaminari_page){ page(kaminari_page).per(10) }
end
