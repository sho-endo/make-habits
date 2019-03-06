User.create!(
  name: "tom",
  email: "tom@ne.jp",
  password: "foobar",
  admin: true,
  activated: true,
)

User.create!(
  name: "john",
  email: "john@ne.jp",
  password: "foobar",
)

50.times do |i|
  User.create(
    name: "hoge",
    email: "test#{i}@ne.jp",
    password: "foobar",
  )
end
