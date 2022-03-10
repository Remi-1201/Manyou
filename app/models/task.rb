class Task < ApplicationRecord
  has_many :labelings, dependent: :destroy
  has_many :labels, through: :labelings, source: :label
  belongs_to :user, optional: true

  validates :name, presence: true, length: {maximum: 120}
  validates :detail, presence: true, length: {maximum: 1000}
  validates :deadline, presence: true

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
  scope :priority_sort, -> { order(priority: :asc) }
  scope :deadline_sorted, -> { order(deadline: :desc) }
  scope :label_sort, -> (search_label){
    tasks = Labeling.where(label_id: search_label)
    ids = tasks.map{ |task| task.task_id }
    where(id: ids)
  }

  # seach by name/word
  scope :search_sort, -> (search_word){ where('name LIKE ?', "%#{search_word}%") }  
  scope :kaminari, -> (kaminari_page){ page(kaminari_page).per(10) }
  scope :current_user_sort, -> (current_user_id){ where(user_id: current_user_id) }
end
