class CreateUserPokemons < ActiveRecord::Migration[5.2]
  def change
    create_table :user_pokemons do |t|
      t.integer :user_id
      t.integer :pokemon_id
    end
  end
end
