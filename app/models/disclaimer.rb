class Disclaimer < ApplicationRecord
  belongs_to :user
  validates :statement , presence: true , length: {maximum:1000}
end
