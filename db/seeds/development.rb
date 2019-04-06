user = User.create!(
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

User.create!(
  name: "test_user",
  email: "test_user@example.com",
  password: "test1234",
)
50.times do |i|
  User.create(
    name: "hoge",
    email: "test#{i}@ne.jp",
    password: "foobar",
  )
end

50.times do |i|
  user.makes.create(
    title: "make#{i}",
    rule1: "hoge",
    rule2: "foo",
  )
end

50.times do |i|
  user.quits.create(
    title: "quit#{i}",
    rule1: "hoge",
    rule2: "foo",
  )
end
