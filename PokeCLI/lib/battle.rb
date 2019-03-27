require_relative './styling'
class Battle
  include Styling
  attr_reader :user_pokemon, :team_rocket_pokemon, :takeaway
  attr_accessor :user, :array_of_attributes, :user_score, :tr_score

  def initialize(user, user_pokemon, team_rocket_pokemon)
    @user = user
    @user_pokemon = user_pokemon
    @team_rocket_pokemon = team_rocket_pokemon
    @array_of_attributes = ["speed", "special_defense", "special_attack", "defense", "attack"]
    @user_score = 0
    @tr_score = 0
    @takeaway = ["kids", "lunch money", "wife", "coffee"]
  end
  # Just effects to gamify the experience
  def dramatic_into
    system("clear")
    puts_super_fast <<-EOF

              ██████╗  █████╗ ████████╗████████╗██╗     ███████╗██╗
              ██╔══██╗██╔══██╗╚══██╔══╝╚══██╔══╝██║     ██╔════╝██║
              ██████╔╝███████║   ██║      ██║   ██║     █████╗  ██║
              ██╔══██╗██╔══██║   ██║      ██║   ██║     ██╔══╝  ╚═╝
              ██████╔╝██║  ██║   ██║      ██║   ███████╗███████╗██╗
              ╚═════╝ ╚═╝  ╚═╝   ╚═╝      ╚═╝   ╚══════╝╚══════╝╚═╝ 
    EOF
    puts_fast PASTEL.red.bold "You have entered battle!"
    puts ""
    puts_medium PASTEL.green.bold "Preparing AI..."
    puts ""
    puts_medium PASTEL.green.bold("████████ L █ O █ A █ D █ I █ N █ G █████████")
    system("clear")
  end
  #Round 1 - User choosing its attribute to compare with AI 
  def round_1
    puts_super_fast <<-EOF
              ██████╗  ██████╗ ██╗   ██╗███╗   ██╗██████╗      ██╗
              ██╔══██╗██╔═══██╗██║   ██║████╗  ██║██╔══██╗    ███║
              ██████╔╝██║   ██║██║   ██║██╔██╗ ██║██║  ██║    ╚██║
              ██╔══██╗██║   ██║██║   ██║██║╚██╗██║██║  ██║     ██║
              ██║  ██║╚██████╔╝╚██████╔╝██║ ╚████║██████╔╝     ██║
              ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚═════╝      ╚═╝        
    EOF
    puts ""
    # pastel.red('Unicorns') + ' will rule ' + pastel.green('the World!')
    puts_medium PASTEL.white('Jesus! That looks like a ') + PASTEL.bright_white.on_bright_red.bold("#{team_rocket_pokemon.name}!") + PASTEL.white(" It looks angry - Prepare yourself!!")
    puts ""
    options = @array_of_attributes
    choice = PROMPT.select("Select one of the following attributes!", options)
    puts ""
    #The actual battle against the 'AI'
    if @user_pokemon.send(:"#{choice}") > @team_rocket_pokemon.send(:"#{choice}")

      puts_medium PASTEL.white("You used #{choice} with ") + PASTEL.bright_white.on_bright_red.bold("#{@user_pokemon.send(:"#{choice}")} DAMAGE!")
      puts ""
      puts_medium PASTEL.white("Good job! I think you hurt it!, ") + PASTEL.white("Team Rocket only had ") + PASTEL.bright_white.on_bright_red.bold("#{@team_rocket_pokemon.send(:"#{choice}")} DAMAGE!")
      puts ""
      @user_score += 1
      puts_medium PASTEL.white.bold("You need to win one more round to win the battle!")
      puts ""
    else
      # puts_fast "You used #{choice} with #{@team_rocket_pokemon.send(:"#{choice}")} damage!"
      puts_medium PASTEL.white("You used #{choice}. Your pokemon does ") + PASTEL.bright_white.on_bright_red.bold("#{@user_pokemon.send(:"#{choice}")} DAMAGE!")
      puts ""
      puts_medium PASTEL.white("Ouch - their #{@team_rocket_pokemon.name} was too strong for you and did ") + PASTEL.bright_white.on_bright_red.bold("#{@team_rocket_pokemon.send(:"#{choice}")} DAMAGE!")
      @tr_score += 1
      puts ""
      puts_medium PASTEL.white.bold("Team Rocket won the round - if they win the next one, they'll win the battle!")
      puts ""
    end
    #Deleting the selected attribute from user and moves directly to round 2
    @array_of_attributes.delete(choice)
    self.round_2
  end

  def round_2
    puts_super_fast <<-EOF

              ██████╗  ██████╗ ██╗   ██╗███╗   ██╗██████╗     ██████╗ 
              ██╔══██╗██╔═══██╗██║   ██║████╗  ██║██╔══██╗    ╚════██╗
              ██████╔╝██║   ██║██║   ██║██╔██╗ ██║██║  ██║     █████╔╝
              ██╔══██╗██║   ██║██║   ██║██║╚██╗██║██║  ██║    ██╔═══╝ 
              ██║  ██║╚██████╔╝╚██████╔╝██║ ╚████║██████╔╝    ███████╗
              ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚═════╝     ╚══════╝                                                                   
    EOF
    puts ""
    tr_choice = @array_of_attributes.sample
    puts_medium PASTEL.white("It's Team Rocket's turn to attack! They use - ") + PASTEL.bright_red.on_bright_white.bold("#{tr_choice}!")
    puts ""
    if @user_pokemon.send(:"#{tr_choice}") > @team_rocket_pokemon.send(:"#{tr_choice}")
      puts_medium PASTEL.white("Your #{@user_pokemon.name} is stronger with ") + PASTEL.bright_white.on_bright_red.bold("#{@user_pokemon.send(:"#{tr_choice}")} DAMAGE!")
      puts ""
      puts_medium PASTEL.white("Super! Your pokemon is really powerfull! Team Rocket's pokemon only had") + PASTEL.bright_white.on_bright_red.bold("#{@team_rocket_pokemon.send(:"#{tr_choice}")} DAMAGE!")
      puts ""
      @user_score += 1
    else
      puts_medium PASTEL.white("Team Rocket use #{tr_choice} and deal ") + PASTEL.bright_white.on_bright_red.bold("#{@team_rocket_pokemon.send(:"#{tr_choice}")} DAMAGE!")
      puts ""
      puts_medium PASTEL.white("Your pokemon stood no chance but tried by dealing ") + PASTEL.bright_white.on_bright_red.bold("#{@user_pokemon.send(:"#{tr_choice}")} DAMAGE!")
      puts ""
      puts_medium PASTEL.white("Their #{@team_rocket_pokemon.name} wins!")
      puts ""
      @tr_score += 1
    end
    @array_of_attributes.delete(tr_choice)
    self.check_score
  end

  def round_3
    puts_super_fast <<-EOF
              ██████╗  ██████╗ ██╗   ██╗███╗   ██╗██████╗     ██████╗ 
              ██╔══██╗██╔═══██╗██║   ██║████╗  ██║██╔══██╗    ╚════██╗
              ██████╔╝██║   ██║██║   ██║██╔██╗ ██║██║  ██║     █████╔╝
              ██╔══██╗██║   ██║██║   ██║██║╚██╗██║██║  ██║     ╚═══██╗
              ██║  ██║╚██████╔╝╚██████╔╝██║ ╚████║██████╔╝    ██████╔╝
              ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚═════╝     ╚═════╝                                                                 
    EOF
    puts ""
    options = @array_of_attributes
    choice = PROMPT.select("Which attribute do you want to use?! Choose carefully!", options)
    puts ""

    if @user_pokemon.send(:"#{choice}") > @team_rocket_pokemon.send(:"#{choice}")
      puts_medium PASTEL.white("You used #{choice} with ") + PASTEL.bright_white.on_bright_red.bold("#{@user_pokemon.send(:"#{choice}")} DAMAGE!")
      puts ""
      puts_medium PASTEL.white("Great, it's super effective, your pokemon did ") + PASTEL.white("Team Rocket only had ") + PASTEL.bright_white.on_bright_red.bold("#{@team_rocket_pokemon.send(:"#{choice}")} DAMAGE!")
      puts ""
      @user_score += 1
    else
      puts_medium PASTEL.white("You used #{choice} with ") + PASTEL.bright_white.on_bright_red.bold("#{@user_pokemon.send(:"#{choice}")} DAMAGE!")
      puts ""
      puts_medium PASTEL.white("Damn - their #{@team_rocket_pokemon.name} was too strong for you, and beat you with ") + PASTEL.bright_white.on_bright_red.bold("#{@team_rocket_pokemon.send(:"#{choice}")} DAMAGE!")
      @tr_score += 1
      puts ""
    end
    self.check_score
    end
  
  def check_score
    if @user_score == 2
      self.animation
      puts_medium PASTEL.white.bold("Congrats! You managed to beat Team Rocket and catch their #{@team_rocket_pokemon.name}!")
      puts ""
      puts_medium PASTEL.white("Returning to Main Menu...")
      puts ""
      UserPokemon.create({user: @user, pokemon: @team_rocket_pokemon})
    elsif @tr_score == 2
      puts_medium PASTEL.white.bold("Team Rocket were too strong for you! Better luck next time!")
      puts ""
      if @user.pokemons.count > 1
        UserPokemon.find_by({user: @user, pokemon: @user_pokemon}).destroy
        self.animation
        puts_medium PASTEL.white("Team Rocket took your #{@takeaway.sample} and took your ") + PASTEL.bright_white.bold("#{@user_pokemon.name}!")
        puts ""
        puts_medium PASTEL.white("Returning to Main Menu...")
        puts ""
      else
        puts_medium PASTEL.white.bold("You've only got one pokemon left - Team Rocket decided to let you keep it.")
        puts ""
        puts_medium PASTEL.white("Returning to Main Menu...")
        puts ""
      end
      else
        puts_medium PASTEL.white.bold("Get ready - this is the final round!")
        puts ""
        self.round_3
      end
  end
end