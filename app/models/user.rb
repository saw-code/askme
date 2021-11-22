require 'openssl'

class User < ApplicationRecord
  # параметр работы модуля шифрования паролей
  ITERATIONS = 20000
  DIGEST = OpenSSL::Digest::SHA256.new
  REGEXP_URL = /[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&=]*)/i

  attr_accessor :password #виртуальный объект. В чистом виде в базу не попадает(такого поля нет)

  has_many :questions,
           dependent: :destroy #когда объект будет уничтожен, destroy будет вызыван на его связанных объектах

  before_validation :downcase_for_validation

  before_save :encrypt_password

  validates :email,
            :username,
            presence: true

  validates :email,
            :username,
            uniqueness: true

  validates :username,
            length: { maximum: 40 },
            format: { with: /\A[[:word:]]+\z/ }

  validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :password,
            presence: true,
            on: :create

  validates :password,
            confirmation: true

  validates :avatar_url,
            allow_blank: true, #Опция :allow_blank подобна опции :allow_nil. Эта опция пропускает валидацию, если значение атрибута blank?, например nil или пустая строка.
            format: { with: REGEXP_URL } #Этот хелпер проводит валидацию значений атрибутов, тестируя их на соответствие указанному регулярному выражению, которое определяется с помощью опции :with

  def self.authenticate(email, password)
    user = find_by(email: email&.downcase)

    return unless user.present?

    password_hash =
      User.hash_to_string(
        OpenSSL::PKCS5.pbkdf2_hmac(
          password, user.password_salt, ITERATIONS, DIGEST.length, DIGEST
        )
      )

    return unless user.password_hash == password_hash

    user
  end

  def self.hash_to_string(password_hash)
    password_hash.unpack('H*')[0]
  end

  private

  def downcase_for_validation
    email&.downcase!
    username&.downcase!
  end

  def encrypt_password
    if password.present?
      # создаем т.н. "соль" рандомная строка усложняющая задачу хакерам
      self.password_salt = User.hash_to_string(OpenSSL::Random.random_bytes(16))

      # создаем хэш пароля - длинная уникальная строка, из к-й невозможно
      # восстановить исходный пароль
      self.password_hash = User.hash_to_string(
        OpenSSL::PKCS5.pbkdf2_hmac(password, password_salt, ITERATIONS, DIGEST.length, DIGEST)
      )
    end
  end
end
