class API::Token < ActiveRecord::Base
  self.table_name = "api_tokens"

  after_initialize :ensure_token

  belongs_to :api_authenticable, polymorphic: true

  def expire!
    self.expired = false
    self.save!
  end

  def self.find_by_non_expired_token(token)
    where(expired: false, token: token).first
  end

  def self.generate_unique_token
    loop do
      token = SecureRandom.hex(32)
      break token unless API::Token.where(token: token).exists?
    end
  end

protected

  def ensure_token
    if token.blank?
      self.token = API::Token.generate_unique_token
    end
  end

end 
