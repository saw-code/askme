require 'openssl'

class User < ApplicationRecord
  # параметр работы модуля шифрования паролей
  ITERATIONS = 20000
  DIGEST = OpenSSL::Digest::SHA256.new

  has_many :questions

  validates :email, :username, presence: true
  validates :email, :username, uniqueness: true
  validates :username, length: { maximum: 40 }, format: { with: /\A[[:word:]]+\z/ }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  attr_accessor :password

  validates :password, presence: true, on: :create
  validates :password, confirmation: true

  before_validation :downcase_for_username
  before_save :encrypt_password, :downcase_for_username

  def downcase_for_username
    self.username.downcase!
  end

  def encrypt_password
    if self.password.present?
      # создаем т.н. "соль" рандомная строка усложняющая задачу хакерам
      self.password_salt = User.hash_to_string(OpenSSL::Random.random_bytes(16))

      # создаем хэш пароля - длинная уникальная строка, из к-й невозможно
      # восстановить исходный пароль
      self.password_hash = User.hash_to_string(
        OpenSSL::PKCS5.pbkdf2_hmac(self.password, self.password_salt, ITERATIONS, DIGEST.length, DIGEST)
      )
    end
  end

  def self.hash_to_string(password_hash)
    password_hash.unpack('H*')[0]
  end

  def self.authenticate(email, password)
    user = find_by(email: email) # сперва находим кандидата по email

    # ОБРАТИТЕ внимание: сравнивается password_hash, а оригинальный пароль так никогда
    # и не сохраняется нигде
    if user.present? && user.password_hash == User.hash_to_string(
      OpenSSL::PKCS5.pbkdf2_hmac(password, user.password_salt, ITERATIONS, DIGEST.length, DIGEST)
    )
      user
    else
      nil
    end
  end
end
