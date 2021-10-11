class Reservation < ApplicationRecord

  enum status: [:reserved, :lent]

  belongs_to :user
  belongs_to :book

  default_scope { where(to: nil) }

  scope :is_active, -> { where(to: nil) }
  scope :find_by_code, -> (code) { where("reservations.code ILIKE ?", "%#{code}%")}
  scope :find_by_status, -> (status) { where("reservations.status in (?)", status)}
end
