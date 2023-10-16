class Owner < User
  has_many :restaurants, dependent: :destroy, foreign_key: 'user_id'
end
