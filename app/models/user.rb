class User < ApplicationRecord
  has_secure_password

  has_many :sales, dependent: :restrict_with_error

  ROLES = %w[superadmin admin staff].freeze

  validates :name, presence: true, length: { maximum: 100 }
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, presence: true, inclusion: { in: ROLES }

  before_save :downcase_email

  scope :superadmins, -> { where(role: "superadmin") }
  scope :admins, -> { where(role: "admin") }
  scope :staff_members, -> { where(role: "staff") }
  scope :active, -> { where(active: true) }

  def superadmin?
    role == "superadmin"
  end

  def admin?
    role == "admin"
  end

  def staff?
    role == "staff"
  end

  def can_manage_users?
    superadmin?
  end

  def can_view_reports?
    superadmin?
  end

  def can_view_dashboard?
    superadmin?
  end

  def can_manage_products?
    superadmin? || admin?
  end

  def can_record_sales?
    superadmin? || admin? || staff?
  end

  def display_role
    case role
    when "superadmin" then "Super Admin"
    when "admin" then "Admin"
    when "staff" then "Staff"
    else role.capitalize
    end
  end

  private

  def downcase_email
    self.email = email.downcase
  end
end
