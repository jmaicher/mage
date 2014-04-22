class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_save :ensure_api_token


  # -- Custom finders ---------------------------------

  def self.find_by_api_token token
    where(api_token: token).first
  end

protected

  def ensure_api_token
    if api_token.blank?
      self.api_token = generate_unique_api_token
    end
  end

  def generate_unique_api_token
    loop do
      token = SecureRandom.hex(32)
      break token unless User.where(api_token: token).exists?
    end
  end

end
