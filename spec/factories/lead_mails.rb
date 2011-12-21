# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :lead_mail do
    sequence(:email) { |n| "email#{n}@factory.com" }
    mail_template_id 1
    from_user_id 1 
  end
end
