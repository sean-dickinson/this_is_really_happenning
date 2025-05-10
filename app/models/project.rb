class Project < ApplicationRecord
  has_many :project_users, dependent: :destroy
  has_many :users, through: :project_users

  validates :name, presence: true
  validate :ensure_owner!

  private

  def ensure_owner!
    unless project_users.any? { |pu| pu.role.to_s == "owner" }
      errors.add(:base, "Project must have at least one owner")
    end
  end
end
