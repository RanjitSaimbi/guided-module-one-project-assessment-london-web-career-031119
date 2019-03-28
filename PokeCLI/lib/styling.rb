module Styling

  PROMPT = TTY::Prompt.new
  FONT = TTY::Font.new(:starwars)
  PASTEL = Pastel.new

  def puts_slow(str)
    chars = str.split(//)
    chars.each do |c|
      print c
      sleep 0.1
    end
    print "\n"
  end

  def puts_medium(str)
    chars = str.split(//)
    chars.each do |c|
      print c
      sleep 0.03
    end
    print "\n"
  end

  def puts_fast(str)
    chars = str.split(//)
    chars.each do |c|
      print c
      sleep 0.02
    end
    print "\n"
  end

  def puts_super_fast(str)
    chars = str.split(//)
    chars.each do |c|
      print c
      sleep 0.0001
    end
    print "\n"
  end

  def opening_sound
    @pid = fork{ exec 'afplay', "lib/sounds/opening.mp3" }
  end

  def attack_sound
    @pid = fork{ exec 'afplay', "lib/sounds/attack.wav" }
  end



end
