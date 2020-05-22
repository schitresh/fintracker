class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships

  def full_name
    return "#{first_name} #{last_name}".strip if (first_name || last_name)
    "Anonymous"
  end
  
  def stock_already_added?(ticker_symbol)
    stock = Stock.find_by_ticker(ticker_symbol)
    return false unless stock
    UserStock.find_by_stock_id(stock.id).present?
    user_stocks.where(stock_id: stock.id).exists?
  end

  def under_stock_limit?
    user_stocks.count < 10
  end

  def can_add_stock?(ticker_symbol)
    under_stock_limit? && !stock_already_added?(ticker_symbol)
  end

  def self.search(param)
    print param
    param.strip!
    print param
    param.downcase!
    print param
    results = (first_name_matches(param) + last_name_matches(param) + email_matches(param)).uniq
    results
  end

  def self.first_name_matches(param)
    matches('first_name', param)
  end

  def self.last_name_matches(param)
    matches('last_name', param)
  end
  
  def self.email_matches(param)
    matches('email', param)
  end

  def self.matches(field, param)
    User.where("#{field} like ?", "%#{param}%")
  end

  def remove_current_user(users)
    users.reject{ |user| user.id == self.id}
  end

  def friends_with?(friend)
    friendships.where(friend_id: friend.id).count > 0
  end
end
