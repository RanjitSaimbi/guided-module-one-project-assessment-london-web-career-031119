class Pokemon < ActiveRecord::Base
  has_many :user_pokemons
  has_many :users, through: :user_pokemons
end

