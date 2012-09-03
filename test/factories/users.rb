# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email                   'foo@email.coom'
    first_name              'Foo'
    last_name               'Fa'
    username                'foo'
    age                     18
    birthday                '04/18/1994'
    password                '123456'
    password_confirmation   '123456'
    gender                  'M'
    
    factory :admin do roles ['ADMIN'] end
    
    factory :registered do roles ['USER'] end
  end
end
