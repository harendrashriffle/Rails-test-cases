class Customer < User
  has_many :orders, dependent: :destroy, foreign_key: 'user_id'
  has_one :cart, dependent: :destroy, foreign_key: 'user_id'
end
