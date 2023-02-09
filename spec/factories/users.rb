FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email "foo#{SecureRandom.hex(3)}@bar.com"
    password 'foobar'
    photo_url 'https://picsum.photos/200'
  end

  factory :conversation do
  end
end
