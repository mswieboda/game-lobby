class Game < ApplicationRecord
  has_many :lobbies

  before_create :set_key

  def set_key
    self.key = SecureRandom.uuid
  end
end
