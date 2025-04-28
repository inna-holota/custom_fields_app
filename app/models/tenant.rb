class Tenant < ApplicationRecord
  has_many :custom_fields, dependent: :destroy
  has_many :users, dependent: :destroy

  validates :name, presence: true
end