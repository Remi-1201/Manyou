class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_many :labels, dependent: :destroy
  before_destroy :destroy_action
  before_update :update_action

  has_secure_password
  before_validation { email.downcase! }
  validates :name,  presence: true, length: { maximum: 120 }
  validates :email, presence: true, length: { maximum: 250 },format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: true

  private
  def destroy_action
    user = User.where(id: self.id, admin: true)
    if user.present? && User.where(admin: true).count == 1 && self.admin == false
      throw(:abort)
    end
  end

  def update_action
    user = User.where(id: self.id, admin: true)
    if user.present? && User.where(admin: true).count == 1 && self.admin == false
      errors.add(:admin, 'から外せません。最低一人の管理者が必要です')
      throw(:abort)
    end
  end
end
