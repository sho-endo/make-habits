class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest
  before_destroy :forbid_destroy_last_admin_user
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  has_many :habits, dependent: :destroy
  has_many :makes, dependent: :destroy
  has_many :quits, dependent: :destroy

  # ハッシュ値を返す
  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def self.find_or_create_from_auth_hash(auth_hash)
    provider = auth_hash[:provider]
    uid = auth_hash[:uid]
    name = auth_hash[:info][:name]
    image_url = auth_hash[:info][:image]

    self.find_or_create_by!(provider: provider, uid: uid) do |user|
      user.name = name
      user.email = User.dummy_email(uid, provider)
      user.password = User.new_token
      user.image_url = image_url
      user.activated = true
    end
  end

  def self.dummy_email(uid, provider)
    "#{uid}-#{provider}@dummy.com"
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token)) # rubocop:disable Rails/SkipsModelValidations
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_digest, nil) # rubocop:disable Rails/SkipsModelValidations
  end

  def activate
    update_attribute(:activated, true) # rubocop:disable Rails/SkipsModelValidations
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def reactivate
    update_attribute(:activated, false) # rubocop:disable Rails/SkipsModelValidations
    create_activation_digest and self.save
    send_activation_email
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now) # rubocop:disable Rails/SkipsModelValidations
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private

    def downcase_email
      self.email.downcase!
    end

    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

    def forbid_destroy_last_admin_user
      throw(:abort) if self.admin? && User.where(admin: true).count == 1
    end
end
