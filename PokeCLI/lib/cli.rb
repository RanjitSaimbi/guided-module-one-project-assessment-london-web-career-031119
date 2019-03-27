# include Styling
require_relative './styling'

class CLI
  include Styling
  # require 'pry'
  attr_reader :user
  attr_accessor :current_selected_pokemon

  def loading_screen
    puts_super_fast <<-EOF
    .::.
    .;:**'            AMC
    `                  0
.:XHHHHk.              db.   .;;.     dH  MX   0
oMMMMMMMMMMM       ~MM  dMMP :MMMMMR   MMM  MR      ~MRMN
QMMMMMb  "MMX       MMMMMMP !MX' :M~   MMM MMM  .oo. XMMM 'MMM
`MMMM.  )M> :X!Hk. MMMM   XMM.o"  .  MMMMMMM X?XMMM MMM>!MMP
'MMMb.dM! XM M'?M MMMMMX.`MMMMMMMM~ MM MMM XM `" MX MMXXMM
~MMMMM~ XMM. .XM XM`"MMMb.~*?**~ .MMX M t MMbooMM XMMMMMP
?MMM>  YMMMMMM! MM   `?MMRb.    `"""   !L"MMMMM XM IMMM
MMMX   "MMMM"  MM       ~%:           !Mh.""" dMI IMMP
'MMM.                                             IMX
~M!M                                             IMP

        A SPECTACULAR GAME BY RANJIT & AZAM
        ___________________________________
    EOF
  end

  def welcome
    puts ""
  end

  def who_are_you?
    puts_super_fast PASTEL.yellow("***************************************************************")
    puts ""
    puts_fast "           Welcome to PokeCLI - Enter your name below!"
    puts ""
    puts_super_fast PASTEL.yellow("***************************************************************")
    puts ""
    name = gets.chomp
    @user = User.find_or_create_by(name: name)
    @user.pokemons.count == 0 ? self.default_pokemon : self.menu
    puts ""
  end

  def default_pokemon
    puts ""
    puts_fast "Hello! My name is Oak. People call me the Pokemon Professor. So your name is #{@user.name}?"
    puts ""
    options = ["Bulbasaur", "Squirtle", "Charmander", "Pikachu"]
    choice = PROMPT.select("I see you don't have any Pokemon with you. Well, I've had a few new ones come in just today - would you like to see?", options)
    puts ""
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
    options = ["Do Battle", "View Pokedex", "Leaderboard", "Switch User", "About","Exit"]
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
      self.switch_user
    when options[4]
      self.about
    when options[5]
      self.exit
    end
  end


    def select_pokemon
      puts_fast "Woah - I think I saw Team Rocket up ahead! Quick - select your pokemon for battle!"
      puts ""
      options = @user.pokemons.all.map {|pokemon| pokemon.name}
      choice = PROMPT.select("Type the name of the pokemon you want to select.", options)
      @current_selected_pokemon = Pokemon.find_by(name: choice)
      puts_fast "Great! You chose #{@current_selected_pokemon.name}! Let's get ready!"
      puts ""
    end

    def random_pokemon
      random = Pokemon.order("RANDOM()").first
    end

    def battle
      select_pokemon
      team_rocket_pokemon = random_pokemon
      new_battle = Battle.new(@user, @current_selected_pokemon, team_rocket_pokemon)
      new_battle.round_1
      self.menu
    end

    def pokedex
      rows = @user.pokemons.map{|p|[p.name, p.speed, p.special_defense, p.special_attack, p.defense, p.attack]}
      table = Terminal::Table.new :title => "POKEDEX", :headings => ['NAME','SPEED', 'SPECIAL DEFENSE', 'SPECIAL ATTACK', 'DEFENCE', 'ATTACK'], :rows => rows, :style => {:all_separators => true}
      table.style = {:width => 110, :padding_left => 2, :border_x => "=", :border_i => "+"}
      puts PASTEL.bright_yellow(table)
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
      choice = PROMPT.select("Please select a pokemon that you would like to set free.", options)
      pokemon_to_set_free = Pokemon.find_by(name: choice)

      if @user.pokemons.count > 1
        UserPokemon.all.find_by({user: @user, pokemon: pokemon_to_set_free}).destroy
        puts ""
        puts_fast "You set #{pokemon_to_set_free.name} free! Goodbye #{pokemon_to_set_free.name}!"
        puts ""
      else
      puts ""
      puts_fast "You've only got one pokemon left - you cannot have less than one pokemon."
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
      puts PASTEL.bright_yellow(table)
      options = ["Back to Menu"]
      choice = PROMPT.select("What would you like to do?", options)
      self.menu if choice == "Back to Menu"
    end

    def leaderboard
      rows = UserPokemon.group(:user).count.map {|item| [item[0].name, item[1]]}
      table = Terminal::Table.new :title => "LEADERBOARD", :headings => ['USER', 'POKEMON COUNT'], :rows => rows, :style => {:all_separators => true}
      table.style = {:width => 70, :padding_left => 2, :border_x => "=", :border_i => "+"}
      puts PASTEL.bright_yellow(table)
      options = ["Back to Menu"]
      choice = PROMPT.select("What would you like to do?", options)
      self.menu if choice == "Back to Menu"
    end

    def switch_user
      
      options = ["Back to Menu"]
      choice = PROMPT.select("What would you like to do?", options)
      self.menu if choice == "Back to Menu"
    end

end
