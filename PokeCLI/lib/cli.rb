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
    choice = gets.chomp.to_i
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
    puts ""
    self.menu
  end

  def menu
    puts "Welcome to the Main Menu."
    puts "Press 1 to do battle!"
    puts "Press 2 to view your Pokedex"
    choice = gets.chomp.to_i
    case choice
    when 1
      self.battle
    when 2
      self.pokedex
    end
  end


    def select_pokemon
      puts "Woah - I think I saw Team Rocket up ahead! Quick - select your pokemon for battle!"
      @user.pokemons.all.each {|pokemon| puts "#{pokemon.name}"}
      puts "Type the name of the pokemon you want to select."
      choice = gets.chomp
      @current_selected_pokemon = Pokemon.find_by(name: choice)
      puts "Great! You chose #{@current_selected_pokemon.name}! Let's get ready!"
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

    end

end
