class Book < ApplicationRecord

  #Book status was added to reduce complex reservations query
  enum status: [:available, :reserved, :lent]

  has_many :reservations

  scope :find_by_title, -> (title) { where("title ILIKE ?", "%#{title}%") if title.present? }
  scope :find_by_author, -> (author) { where("author ILIKE ?", "%#{author}%") if author.present? }
  scope :reservations_with_code, -> (code) { merge(Reservation.find_by_code(code)) if code.present?}
  scope :with_status, -> (status) { where("books.status in (?)", status) if status.present?}
end
