class User < ApplicationRecord
  belongs_to :tenant
  has_many :custom_field_values, dependent: :destroy

  validates :first_name, :last_name, :email, presence: true
end