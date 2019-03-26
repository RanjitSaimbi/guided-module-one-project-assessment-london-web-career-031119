module Styling

  PROMPT = TTY::Prompt.new
  FONT = TTY::Font.new(:doom)
  PASTEL = Pastel.new

  def puts_slow(str)
    chars = str.split(//)
    chars.each do |c|
      print c
      sleep 0.15
    end
    print "\n"
  end

  def puts_medium(str)
    chars = str.split(//)
    chars.each do |c|
      print c
      sleep 0.1
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
      sleep 0.001
    end
    print "\n"
  end

  def music
      options=["Yes", "No"]
      puts ""
      choice=PROMPT.select("Would you like to enable sound?",options)
      case choice
        when options[0]
          @pid = fork{ exec 'afplay', "lib/opening.mp3" }
        when options[1]
      end
    end


end
