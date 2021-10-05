desc "Init DB with required data"
task :initDB do
    p "config.after_initialize start"

    @ROLE = Role.getRole

    @ROLE.keys.each do |key|
      if Role.find_by(name: @ROLE[key])
        p "Role is present: " + @ROLE[key]
        next
      end

      p "Role is not present adding: " + @ROLE[key]
      @role = Role.new(name: @ROLE[key])
      @role.save
    end

    if User.find_by(email: "admin@publiclibrary.com")
      p "config.after_initialize admin exist"
    else
      p "config.after_initialize add admin"
      @adminUser = User.new(email: "admin@publiclibrary.com", password: "12345678")
      @adminUser.roles.append(Role.find_by(name: @ROLE[:admin]))
      @adminUser.save
    end
    p "config.after_initialize end"
end