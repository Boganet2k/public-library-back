class Role < ApplicationRecord

  ROLE = {member: "MEMBER", admin: "ADMIN"}

  has_and_belongs_to_many :users

  def self.getRole
    ROLE
  end
end
