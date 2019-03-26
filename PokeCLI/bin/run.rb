require_relative '../config/environment'


cli = CLI.new
system("clear")
cli.loading_screen
cli.welcome
cli.who_are_you?


# this will run series of cli methods
