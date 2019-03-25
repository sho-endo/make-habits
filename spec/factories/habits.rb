FactoryBot.define do
  factory :make do
    type { "Make" }
    title { "筋トレをする" }
    rule1 { "歯磨きをしたら１回スクワットをする" }
    rule2 { "めんどくさいと思ったら太ってる自分の写真を見返す" }
    user
  end

  factory :quit do
    type { "Quit" }
    title { "間食をする" }
    rule1 { "仕事中はガムを噛む" }
    rule2 { "お菓子のストックはやめて食べる時は毎回コンビニに行く" }
    user
  end
end
