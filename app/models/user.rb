class User < ApplicationRecord
  has_secure_password

  has_many :sales, dependent: :restrict_with_error

  validates :name, presence: true, length: { maximum: 100 }
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, presence: true, inclusion: { in: %w[owner staff] }

  before_save :downcase_email

  scope :owners, -> { where(role: "owner") }
  scope :staff_members, -> { where(role: "staff") }
  scope :active, -> { where(active: true) }

  def owner?
    role == "owner"
  end

  def staff?
    role == "staff"
  end

  def display_role
    role.capitalize
  end

  private

  def downcase_email
    self.email = email.downcase
  end
end
