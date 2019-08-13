10.times do |n|
  user = User.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name)

  rand(10).times do
    tr = Transaction.create!(user: user, sum: rand(100), transaction_type: 0)
    balance = user.balance
    balance.update!(sum: balance.sum + tr.sum)
  end
end
