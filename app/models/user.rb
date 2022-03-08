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
    if User.where(admin: true).count == 1 && self.admin? == true
      errors.add(:admin,'なので削除できません。最低一人の管理者が必要です')
      throw(:abort)
    end
  end

  def update_action
    user = User.where(id: self.id).where(admin: true)
    if User.where(admin: true).count == 1 && user.present? && self.admin == false
      errors.add(:admin,'から外せません。最低一人の管理者が必要です')
      throw(:abort)
    end
  end
end
