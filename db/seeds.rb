# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts 'Hello World!'
puts '這個種子檔會自動建立一個帳號, 並且随机創建 16 個jobs，16个隐藏的jobs'

create_account = User.create([email: 'admin@admin.com', password: '111111', password_confirmation: '111111', is_admin: 'true'])
puts 'Admin account is created successfully!'

job_info = [
  'Furniture Design',
  'Transportation Design',
  'Product Design',
  'Software design',
  'Stationery Design',
  'Toy Design',
  'Advertisement Design',
  'Package Design',
  'Illustration Design',
  'Animation Design',
  'Web Design',
  'Cosmetics Design',
  'Fashion Design',
  'Jewelry Design',
  'Architects',
  'Interior designer',


]
create_jobs = for i in 1..16 do
                Job.create!([title: job_info[rand(job_info.length)], description: "这是一个公开的工作", wage_upper_bound: rand(40..79) * 1000, wage_lower_bound: rand(20..39) * 1000, is_hidden: 'false'])
              end
for i in 1..16 do
  Job.create!([title: job_info[rand(job_info.length)], description: "这是一个隐藏的工作", wage_upper_bound: rand(40..79) * 1000, wage_lower_bound: rand(20..39) * 1000, is_hidden: 'true'])
end

puts '16 Public jobs created.'
puts '16 Hidden jobs created.'
