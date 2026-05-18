namespace :admin do
  desc "Promote a user to admin — rake admin:promote EMAIL=user@example.com"
  task promote: :environment do
    email = ENV.fetch("EMAIL") { abort "Usage: rake admin:promote EMAIL=user@example.com" }
    user  = User.find_by!(email: email.downcase)
    user.update!(admin: true)
    puts "✓ #{user.name} (#{user.email}) is now an admin."
  end

  desc "Demote an admin — rake admin:demote EMAIL=user@example.com"
  task demote: :environment do
    email = ENV.fetch("EMAIL") { abort "Usage: rake admin:demote EMAIL=user@example.com" }
    user  = User.find_by!(email: email.downcase)
    user.update!(admin: false)
    puts "✓ #{user.name} (#{user.email}) is no longer an admin."
  end

  desc "List all admins"
  task list: :environment do
    admins = User.where(admin: true)
    if admins.any?
      admins.each { |u| puts "  #{u.name} — #{u.email}" }
    else
      puts "No admins found."
    end
  end
end
