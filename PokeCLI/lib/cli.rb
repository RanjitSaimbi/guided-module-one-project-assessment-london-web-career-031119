# include Styling
require_relative './styling'

class CLI
  include Styling
  # require 'pry'
  attr_reader :user
  attr_accessor :current_selected_pokemon

  def loading_screen
    opening_sound
puts_super_fast PASTEL.yellow("********************************************************************************************************")
puts_super_fast PASTEL.yellow("********************************************************************************************************")
puts_super_fast PASTEL.yellow("********************************************************************************************************")
puts_super_fast PASTEL.yellow("********************************************************************************************************")
puts ""
puts ""


    puts_super_fast <<-EOF
                    ██████╗  ██████╗ ██╗  ██╗███████╗     ██████╗██╗     ██╗
                    ██╔══██╗██╔═══██╗██║ ██╔╝██╔════╝    ██╔════╝██║     ██║
                    ██████╔╝██║   ██║█████╔╝ █████╗█████╗██║     ██║     ██║
                    ██╔═══╝ ██║   ██║██╔═██╗ ██╔══╝╚════╝██║     ██║     ██║
                    ██║     ╚██████╔╝██║  ██╗███████╗    ╚██████╗███████╗██║
                    ╚═╝      ╚═════╝ ╚═╝  ╚═╝╚══════╝     ╚═════╝╚══════╝╚═╝


                                A RANJIT & AZAM PRODUCTION
          EOF
  end

  def welcome
    puts ""
  end


  def who_are_you?
    puts_super_fast PASTEL.yellow("********************************************************************************************************")
    puts_super_fast PASTEL.yellow("********************************************************************************************************")
    puts_super_fast PASTEL.yellow("********************************************************************************************************")
    puts_super_fast PASTEL.yellow("********************************************************************************************************")
    puts ""
    name = PROMPT.ask('What is your name?')
    puts ""
    @user = User.find_or_create_by(name: name)
    @user.pokemons.count == 0 ? self.default_pokemon : self.menu
    puts ""
  end

  def default_pokemon
    puts ""
    puts_fast "Hello! My name is Oak. People call me the Pokemon Professor. So your name is #{@user.name}?"
    puts ""
    options = ["Bulbasaur", "Squirtle", "Charmander", "Pikachu"]
    choice = PROMPT.select("I see you don't have any Pokemon with you. Well, I've had a few new arriavls come in just this morning - would you like to see?", options)
    case choice
    when options[0]
      UserPokemon.create({user: @user, pokemon: Pokemon.find_by(name: "Bulbasaur")})
    when options[1]
      UserPokemon.create({user: @user, pokemon: Pokemon.find_by(name: "Squirtle")})
    when options[2]
      UserPokemon.create({user: @user, pokemon: Pokemon.find_by(name: "Charmander")})
    when options[3]
      UserPokemon.create({user: @user, pokemon: Pokemon.find_by(name: "Pikachu")})
    end
    self.menu
  end

  def menu
    puts ""
    options = ["Battle!", "View Pokedex", "Leaderboard", "Instructions", "Exit"]
    choice = PROMPT.select("Welcome to the Main Menu. Please select an option.", options)
    puts ""
    case choice
    when options[0]
      self.battle
    when options[1]
      self.pokedex
    when options[2]
      self.leaderboard
    when options[3]
      self.instructions
    when options[4]
      self.exit
    end
  end


    def select_pokemon
      puts_fast "Woah - I think I saw Team Rocket up ahead!"
      puts ""
      options = @user.pokemons.all.map {|pokemon| pokemon.name}
      choice = PROMPT.select("Quick - select your Pokemon for battle!", options)
      @current_selected_pokemon = Pokemon.find_by(name: choice)
      puts ""
      puts_fast "Great! You chose #{@current_selected_pokemon.name}! Let's get ready!"
      puts ""
    end

    def random_pokemon
      u = @current_selected_pokemon
      a1 = [u.speed, u.special_defense, u.special_attack, u.defense, u.attack].sort
      r = Pokemon.order(Arel.sql('random()')) - @user.pokemons
      r = r.first
      a2 = [r.speed, r.special_defense, r.special_attack, r.defense, r.attack]
      while a2.none? {|i|i < a1[1]}
        r = Pokemon.order(Arel.sql('random()')).first
        a2 = [r.speed, r.special_defense, r.special_attack, r.defense, r.attack]
      end
      r
    end

    def battle
      select_pokemon
      team_rocket_pokemon = random_pokemon
      new_battle = Battle.new(@user, @current_selected_pokemon, team_rocket_pokemon)
      new_battle.dramatic_intro
      new_battle.round_1
      self.menu
    end

    def pokedex
      @user.reload
      rows = @user.pokemons.map{|p|[p.name, p.speed, p.special_defense, p.special_attack, p.defense, p.attack]}
      table = Terminal::Table.new :title => "POKEDEX", :headings => ['NAME','SPEED', 'SPECIAL DEFENSE', 'SPECIAL ATTACK', 'DEFENCE', 'ATTACK'], :rows => rows, :style => {:all_separators => true}
      table.style = {:width => 110, :padding_left => 2, :border_x => "=", :border_i => "+"}
      puts PASTEL.bright_green(table)
      puts ""
      options = ["Back to Menu", "Set a Pokemon Free", "Pokemon Left to Catch"]
      choice = PROMPT.select("What would you like to do?", options)
      if choice == "Back to Menu"
        self.menu
      elsif choice == "Set a Pokemon Free"
        self.free_pokemon
      elsif choice == "Pokemon Left to Catch"
        self.pokemon_left_to_catch
      end
    end

    def free_pokemon
      puts ""
      options = @user.pokemons.all.map {|pokemon| pokemon.name}
      choice = PROMPT.select("Please select a Pokemon that you would like to set free.", options)
      pokemon_to_set_free = Pokemon.find_by(name: choice)


      if @user.pokemons.count > 1
      puts ""
      choice = PROMPT.yes?("Are you sure you want to set #{pokemon_to_set_free.name} free?")
        if choice
          UserPokemon.all.find_by({user: @user, pokemon: pokemon_to_set_free}).destroy
          puts ""
          puts_fast "You set #{pokemon_to_set_free.name} free! Goodbye #{pokemon_to_set_free.name}!"
          puts ""
        else
          self.menu
        end
      else
      puts ""
      puts_fast "You've only got one Pokemon left - you cannot have less than one pokemon."
      puts ""
      end

      options = ["Back to menu"]
      choice = PROMPT.select("What would you like to do?", options)
      self.menu if choice == "Back to menu"
    end

    def pokemon_left_to_catch
      pokemon_left_array = Pokemon.all - @user.pokemons.all
      i = 0
      rows = pokemon_left_array.map{|p|["#{i += 1}.", p.name, "?"]}
      table = Terminal::Table.new :title => "POKEMON LEFT TO CATCH", :headings => ['NO.','NAME.', 'STATS'], :rows => rows, :style => {:all_separators => true}
      table.style = {:width => 70, :padding_left => 2, :border_x => "=", :border_i => "+"}
      puts PASTEL.bright_green(table)
      puts ""
      puts_fast PASTEL.yellow("#{@user.name} - you still need to catch these Pokemon!")
      puts ""
      options = ["Back to Menu"]
      choice = PROMPT.select("What would you like to do?", options)
      self.menu if choice == "Back to Menu"
    end

    def leaderboard
      rows = UserPokemon.group(:user).count.sort.to_h.map {|item| [item[0].name, item[1]]}
      table = Terminal::Table.new :title => "LEADERBOARD", :headings => ['USER', 'POKEMON COUNT'], :rows => rows, :style => {:all_separators => true}
      table.style = {:width => 70, :padding_left => 2, :border_x => "=", :border_i => "+"}
      puts PASTEL.bright_green(table)
      options = ["Back to Menu"]
      choice = PROMPT.select("What would you like to do?", options)
      self.menu if choice == "Back to Menu"
    end

    def instructions
      system("clear")
      puts_fast PASTEL.cyan("PokeCLI is a turn-based top-trumps game.")
      puts ""
      puts_fast PASTEL.cyan("Each Pokemon has five attributes: SPEED, SPECIAL DEFENSE, SPECIAL ATTACK, DEFENCE and ATTACK.")
      puts ""
      puts_fast PASTEL.cyan("Battle Team Rocket to try and collect as many Pokemon as possible. Select your best Pokemon to face Team Rocket!")
      puts ""
      puts_fast PASTEL.cyan("Each battle is made up of a maximum of three rounds. Select your Pokemon's best attribute to compare it with your opponent's.")
      puts ""
      puts_fast PASTEL.cyan("If you win at least two rounds, you win the battle and your opponent's Pokemon.")
      puts ""
      puts_fast PASTEL.cyan("If you lose, you lose your Pokemon, so be careful!")
      puts ""
      puts_fast PASTEL.cyan("You can inspect all of your Pokemon in the Pokedex.")
      puts ""
      puts_fast PASTEL.cyan("Good luck catching Pokemon, #{@user.name}!")

      options = ["Back to Menu"]
      choice = PROMPT.select("What would you like to do?", options)
      self.menu if choice == "Back to Menu"
    end

    def exit
        puts ""
        puts_super_fast PASTEL.yellow("********************************************************************************************************")
        puts_super_fast PASTEL.yellow("********************************************************************************************************")
        puts_super_fast PASTEL.yellow("********************************************************************************************************")
        puts_super_fast PASTEL.yellow("********************************************************************************************************")
        puts ""

        puts_super_fast <<-EOF

                 ██████╗  ██████╗  ██████╗ ██████╗ ██████╗ ██╗   ██╗███████╗██╗
                ██╔════╝ ██╔═══██╗██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝██╔════╝██║
                ██║  ███╗██║   ██║██║   ██║██║  ██║██████╔╝ ╚████╔╝ █████╗  ██║
                ██║   ██║██║   ██║██║   ██║██║  ██║██╔══██╗  ╚██╔╝  ██╔══╝  ╚═╝
                ╚██████╔╝╚██████╔╝╚██████╔╝██████╔╝██████╔╝   ██║   ███████╗██╗
                 ╚═════╝  ╚═════╝  ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝   ╚══════╝╚═╝
        EOF


        puts ""
        puts_super_fast PASTEL.yellow("********************************************************************************************************")
        puts_super_fast PASTEL.yellow("********************************************************************************************************")
        puts_super_fast PASTEL.yellow("********************************************************************************************************")
        puts_super_fast PASTEL.yellow("********************************************************************************************************")
        exec 'killall afplay'
        exit
    end

end
