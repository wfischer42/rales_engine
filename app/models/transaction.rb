class Transaction < ApplicationRecord
  belongs_to :invoice

  enum result: [:failed, :success]

  scope :success, -> { where(result: :success) }
end
