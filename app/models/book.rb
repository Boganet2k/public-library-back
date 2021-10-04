class Book < ApplicationRecord
  scope :find_by_title, ->(title) { where("title LIKE ?", "%#{title}%") if title.present? }
  scope :find_by_author, ->(author) { where("author LIKE ?", "%#{author}%") if author.present? }
end
