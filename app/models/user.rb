class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :jwt_authenticatable,
         :registerable,
         jwt_revocation_strategy: JwtDenylist

  has_and_belongs_to_many :roles

  before_save :fillDefaultRole

  def fillDefaultRole
    p "User fillDefaultRole roles.length: " + roles.length.to_s

    if roles.length == 0
      @ROLE = Role.getRole

      @memberRole = Role.find_by(name: @ROLE[:member])

      p "User fillDefaultRole @memberRole: " + @memberRole.name

      roles.append(@memberRole)
    end
  end

  def jwt_payload

    @rolesName = []

    roles.each do |role|
      @rolesName.append(role.name)
    end

    { 'roles' => [@rolesName.join(",")], "login" => email }
  end
end
