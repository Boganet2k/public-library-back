class Reservation < ApplicationRecord

  enum status: [:reserved, :lent]

  belongs_to :user
  belongs_to :book

  default_scope { where(to: nil) }
end
