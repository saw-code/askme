class Question < ApplicationRecord
  belongs_to :user

  belongs_to :author,
             class_name: 'User'

  validates :text,
            presence: true

  validates :text,
            length: { maximum: 255 }
end
