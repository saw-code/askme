class Question < ApplicationRecord
  belongs_to :user

  belongs_to :author,
             class_name: 'User',
             optional: true #валидация наличия объекта belongs_to  происходит в случае, если у этой связи не установлен ключ optional: true

  validates :text,
            presence: true

  validates :text,
            length: { maximum: 255 }
end
