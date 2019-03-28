require_relative './styling'
class Battle
  include Styling
  attr_reader :user_pokemon, :team_rocket_pokemon, :takeaway
  attr_accessor :user, :array_of_attributes, :user_score, :tr_score

  def initialize(user, user_pokemon, team_rocket_pokemon)
    @user = user
    @user_pokemon = user_pokemon
    @team_rocket_pokemon = team_rocket_pokemon
    @array_of_attributes = {Speed: "speed", :"Special Defence" => "special_defense", :"Special Attack" => "special_attack", Defence: "defense", Attack: "attack"}
    @user_score = 0
    @tr_score = 0
    @takeaway = ["kids", "lunch money", "wife", "coffee", "dignity", "trainers", "coat", "new phone", "MacBook", "pet cat"]
  end

  def dramatic_intro
    system("clear")
    puts_super_fast <<-EOF

              ██████╗  █████╗ ████████╗████████╗██╗     ███████╗██╗
              ██╔══██╗██╔══██╗╚══██╔══╝╚══██╔══╝██║     ██╔════╝██║
              ██████╔╝███████║   ██║      ██║   ██║     █████╗  ██║
              ██╔══██╗██╔══██║   ██║      ██║   ██║     ██╔══╝  ╚═╝
              ██████╔╝██║  ██║   ██║      ██║   ███████╗███████╗██╗
              ╚═════╝ ╚═╝  ╚═╝   ╚═╝      ╚═╝   ╚══════╝╚══════╝╚═╝
    EOF
    puts_fast PASTEL.red.bold "TEAM ROCKET WOULD LIKE TO BATTLE"
    puts ""
    puts_medium PASTEL.green.bold "Preparing AI..."
    puts ""
    puts_medium PASTEL.green.bold("████████ L █ O █ A █ D █ I █ N █ G █████████")
    system("clear")
  end

  def refresher
    puts ""
    puts_medium PASTEL.green.bold ("Round Finished - Moving to next round.....")
    puts ""
    puts_fast PASTEL.green.bold("Loading - ██████████████")
    puts ""
    system("clear")
  end

  def main_menu_refresher
    puts ""
    puts_slow PASTEL.green.bold ("Returning to Main Menu...")
    puts ""
    puts_slow PASTEL.green.bold("Loading - ██████████████")
    puts ""
    system("clear")
  end

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
    puts_medium PASTEL.white('Look out! Team Rocket sent out ') + PASTEL.bright_white.on_bright_red.bold("#{team_rocket_pokemon.name}!") + PASTEL.white(" It looks angry - get ready!")
    puts ""
    options = @array_of_attributes
    choice = PROMPT.select("Select one of the following attributes!", options)
    print = choice.split("_").map {|i|i.capitalize}.join(' ')
    puts ""
    #The actual battle against the 'AI'
    if @user_pokemon.send(:"#{choice}") > @team_rocket_pokemon.send(:"#{choice}")

        puts_medium PASTEL.white("You used #{print} with ") + PASTEL.bright_white.on_bright_red.bold("#{@user_pokemon.send(:"#{choice}")} DAMAGE!")
          puts ""
          attack_sound
        puts_medium PASTEL.white("Good job! I think you hurt it! ") + PASTEL.white("Team Rocket could only manage ") + PASTEL.bright_white.on_bright_red.bold("#{@team_rocket_pokemon.send(:"#{choice}")} DAMAGE!")
          puts ""
          attack_sound
        @user_score += 1
        puts_medium PASTEL.white.bold("You only need to win one more round to win the battle!")
          puts ""
          self.refresher
      elsif @user_pokemon.send(:"#{choice}") < @team_rocket_pokemon.send(:"#{choice}")

      puts_medium PASTEL.white("You used #{print} with ") + PASTEL.bright_white.on_bright_red.bold("#{@user_pokemon.send(:"#{choice}")} DAMAGE!")
        puts ""
        attack_sound
      puts_medium PASTEL.white("Ouch - their #{@team_rocket_pokemon.name} was too strong for you and caused ") + PASTEL.bright_white.on_bright_red.bold("#{@team_rocket_pokemon.send(:"#{choice}")} DAMAGE!")
      @tr_score += 1
        puts ""
        attack_sound
      puts_medium PASTEL.white.bold("Team Rocket won the round - if they win the next one, they'll win the battle!")
        puts ""
        self.refresher
      else
        randomizer = [0,1].sample
          if randomizer == 0
            puts_medium PASTEL.white("Looks like Team Rocket's #{@team_rocket_pokemon.name} and your #{@user_pokemon.name} both inflicted ") + PASTEL.bright_white.on_bright_red.bold("#{@team_rocket_pokemon.send(:"#{choice}")} DAMAGE!")
              puts ""
              attack_sound
            puts_medium PASTEL.white.bold("Luckily your #{@user_pokemon.name} managed to dodge and land a hit to win the round!")
              puts ""
              attack_sound
              @user_score += 1
              self.refresher
            else
            puts_medium PASTEL.white("Looks like Team Rocket's #{@team_rocket_pokemon.name} and your #{@user_pokemon.name} both inflicted ") + PASTEL.bright_white.on_bright_red.bold("#{@team_rocket_pokemon.send(:"#{choice}")} DAMAGE!")
              puts ""
              attack_sound
            puts_medium PASTEL.white.bold("Your #{@user_pokemon.name} attacks but Team Rocket's #{@team_rocket_pokemon.name} dodges and manages to land a hit. Team Rocket wins the round!")
              puts ""
              attack_sound
              @tr_score += 1
              self.refresher
      end
    end
    #Deleting the selected attribute from user and moves directly to round 2
    @array_of_attributes.delete_if{|_,v| v == choice}
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
    tr_choice = @array_of_attributes.values.sample
    print = tr_choice.split("_").map {|i|i.capitalize}.join(' ')
    puts_medium PASTEL.white("It's Team Rocket's turn to attack! They use ") + PASTEL.bright_red.on_bright_white.bold("#{print}!")
    puts ""
    if @user_pokemon.send(:"#{tr_choice}") > @team_rocket_pokemon.send(:"#{tr_choice}")
      puts_medium PASTEL.white("Your #{@user_pokemon.name} inflicted ") + PASTEL.bright_white.on_bright_red.bold("#{@team_rocket_pokemon.send(:"#{tr_choice}")} DAMAGE!")
      puts ""
      attack_sound
      puts_medium PASTEL.white("Super! Your pokemon is really powerfull! Team Rocket's #{@team_rocket_pokemon.name} could only manage ") + PASTEL.bright_white.on_bright_red.bold("#{@team_rocket_pokemon.send(:"#{tr_choice}")} DAMAGE!")
      puts ""
      attack_sound
      @user_score += 1
      self.refresher
    elsif @user_pokemon.send(:"#{tr_choice}") < @team_rocket_pokemon.send(:"#{tr_choice}")
      puts_medium PASTEL.white("Team Rocket's #{@team_rocket_pokemon.name} used #{print} and inflicted ") + PASTEL.bright_white.on_bright_red.bold("#{@team_rocket_pokemon.send(:"#{tr_choice}")} DAMAGE!")
      puts ""
      attack_sound
      puts_medium PASTEL.white("#{@user_pokemon.name} could only manage ") + PASTEL.bright_white.on_bright_red.bold("#{@user_pokemon.send(:"#{tr_choice}")} DAMAGE!")
      puts ""
      attack_sound
      puts_medium PASTEL.white("Team Rocket's #{@team_rocket_pokemon.name} wins!")
      puts ""
      @tr_score += 1
      self.refresher
    else
      randomizer = [0,1].sample
      if randomizer == 0
        puts_medium PASTEL.white("Looks like Team Rocket's #{@team_rocket_pokemon.name} and your #{@user_pokemon.name} both inflicted ") + PASTEL.bright_white.on_bright_red.bold("#{@team_rocket_pokemon.send(:"#{tr_choice}")} DAMAGE!")
        puts ""
        attack_sound
        puts_medium PASTEL.white.bold("Luckily your #{@user_pokemon.name} managed to dodge and land a hit to win the round!")
        puts ""
        attack_sound
        @user_score += 1
        self.refresher
      else
        puts_medium PASTEL.white("Looks like Team Rocket's #{@team_rocket_pokemon.name} and your #{@user_pokemon.name} both do ") + PASTEL.bright_white.on_bright_red.bold("#{@team_rocket_pokemon.send(:"#{tr_choice}")} DAMAGE!")
        puts ""
        attack_sound
        puts_medium PASTEL.white.bold("Your #{@user_pokemon.name} attacks but Team Rocket's #{@team_rocket_pokemon.name} dodges and manages to land a hit. Team Rocket wins the round!")
        puts ""
        attack_sound
        @tr_score += 1
        self.refresher
      end
    end
    @array_of_attributes.delete_if{|_,v| v == tr_choice}
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
    print = choice.split("_").map {|i|i.capitalize}.join(' ')
    puts ""

    if @user_pokemon.send(:"#{choice}") > @team_rocket_pokemon.send(:"#{choice}")
      puts_medium PASTEL.white("You used #{print} with ") + PASTEL.bright_white.on_bright_red.bold("#{@user_pokemon.send(:"#{choice}")} DAMAGE!")
      puts ""
      attack_sound
      puts_medium PASTEL.white("Great, it's super effective! ") + PASTEL.white("Team Rocket could only manage ") + PASTEL.bright_white.on_bright_red.bold("#{@team_rocket_pokemon.send(:"#{choice}")} DAMAGE!")
      puts ""
      attack_sound
      @user_score += 1
      system("clear")
    elsif @user_pokemon.send(:"#{choice}") < @team_rocket_pokemon.send(:"#{choice}")
      puts_medium PASTEL.white("You used #{print} with ") + PASTEL.bright_white.on_bright_red.bold("#{@user_pokemon.send(:"#{choice}")} DAMAGE!")
      puts ""
      attack_sound
      puts_medium PASTEL.white("Damn - their #{@team_rocket_pokemon.name} was too strong for you, and inflicted ") + PASTEL.bright_white.on_bright_red.bold("#{@team_rocket_pokemon.send(:"#{choice}")} DAMAGE!")
      @tr_score += 1
      puts ""
      attack_sound
      self.refresher
      else
        randomizer = [0,1].sample
        if randomizer == 0
          puts_medium PASTEL.white("Looks like Team Rocket's #{@team_rocket_pokemon.name} and your #{@user_pokemon.name} both inflicted ") + PASTEL.bright_white.on_bright_red.bold("#{@team_rocket_pokemon.send(:"#{choice}")} DAMAGE!")
          puts ""
          attack_sound
          puts_medium PASTEL.white.bold("Luckily your #{@user_pokemon.name} managed to dodge and land a hit to win the round!")
          puts ""
          attack_sound
          @user_score += 1
          self.refresher
        else
          puts_medium PASTEL.white("Looks like Team Rocket's #{@team_rocket_pokemon.name} and your #{@user_pokemon.name} both inflicted ") + PASTEL.bright_white.on_bright_red.bold("#{@team_rocket_pokemon.send(:"#{choice}")} DAMAGE!")
          puts ""
          attack_sound
          puts_medium PASTEL.white.bold("Your #{@user_pokemon.name} attacks but Team Rocket's #{@team_rocket_pokemon.name} dodges and manages to land a hit. Team Rocket wins the round!")
          puts ""
          attack_sound
          @tr_score += 1
          self.refresher
        end
    end
    self.check_score
    end

  def check_score
    if @user_score == 2
      puts_medium PASTEL.white.bold("Congrats! You beat Team Rocket and caught their #{@team_rocket_pokemon.name}!")
      UserPokemon.create({user: @user, pokemon: @team_rocket_pokemon})
      attack_sound
      self.main_menu_refresher
    elsif @tr_score == 2
      puts_medium PASTEL.white.bold("Team Rocket were too strong for you! Better luck next time!")
      puts ""
      if @user.pokemons.count > 1
        UserPokemon.find_by({user: @user, pokemon: @user_pokemon}).destroy
        puts_medium PASTEL.white("Team Rocket took your #{@takeaway.sample} and your ") + PASTEL.bright_white.bold("#{@user_pokemon.name}!")
        attack_sound
        self.main_menu_refresher
      else
        puts_medium PASTEL.white.bold("You've only got one pokemon left - Team Rocket decided to let you keep it.")
        self.main_menu_refresher
      end

    else
        puts_medium PASTEL.white.bold("This is the final round!")
        puts ""
        puts ""
        self.round_3
      end
  end
end
