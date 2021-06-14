require "option_parser"

# These are the default values used by the parser
path = "."
write_license = false
commit = false
topush = false
debug = false

# Prints out text with cool dashes on the side
def pretty_puts(text : String)
  width = 10
  puts "-" * width + " #{text} " + "-" * width
end

# Determine if file is in path
def in_path(file : String, path : String) : Bool
  # Creates a path item with the supplied path
  path = Dir.new path
  # Flags if the file has been found
  found = false

  path.each do |itered|
    # If the file is the one were looking for, mark it as found
    if itered == file
      found = true
    end
  end

  # Return that
  found
end

def install(path : String)
  # Test for the binary in the local directory
  if in_path "l3g", path
    puts "The binary has been found! Commencing install process."
    pretty_puts "Moving Binary to /usr/bin/"
    puts "You may need to put in your password to move the file"
    # Just run a command
    system "sudo mv ./l3g /usr/bin/"
    puts "Move has been attempted! The l3g command should work now."
  else
    puts "ERROR: The l3g binary is not avalible in the current directory"
  end
end

OptionParser.parse do |parser|
  parser.banner = "L3gacy's toolkit"

  parser.on "init", "initialize a new project" do
    system "git init"
    pretty_puts "Git repo initialized"
    write_license = true
  end

  # license generation
  parser.on "license", "Generate license" do
    # Write license to file
    write_license = true
    # no exit, just continue
  end

  parser.on "git-config", "configure git with my info" do
    # configures git with my info
    system "git config --global user.email \"l3gacy.b3ta@disroot.org\""
    system "git config --global user.name \"l3gacyb3ta\""
    pretty_puts "git configured"
  end

  # Installs the binary to /usr/bin
  parser.on "install", "Install l3g to the user dir" do
    install "."
  end

  # Version info
  parser.on "-v", "--version", "Show version" do
    puts "version 0.1"
    exit
  end

  # Help
  parser.on "-h", "--help", "Show help" do
    puts parser
    exit
  end

  # sets up path
  parser.on "-d PATH", "--dir=PATH", "Specify path for command, defaults to ." do |_path|
    path = _path
  end

  parser.on "-c", "--commit", "Commit to git repo" do
    commit = true
  end

  parser.on "-p", "--push", "Turns on pushing after actions" do
    topush = true
  end

  parser.on "-d", "--debug", "Does whatever I'm needing to debug" do
    debug = true
  end

  # Error handling
  parser.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option."
    STDERR.puts parser
    exit(1)
  end
end

# license is set here
license = "Do whatever you want with this software. I don't want it"

#
if debug
  puts "Nothing here for now!"
end

# If we need to write, then write license
if write_license
  File.write path + "/UNLICENSE", license
  pretty_puts "written license to #{path}"
  if commit
    # If commiting to a git repo
    # add it
    system "git add #{path + "/UNLICENSE"}"
    # oooo pretty
    pretty_puts "added #{path + "/UNLICENSE"} to git repo"
    # commit
    system "git commit -m \"Added license\""
    # tell the user
    pretty_puts "Commited to git repo!"
  end
  exit
end

if commit
  system "git add #{path}"
  system "git commit -m \"Commited auto-magically because l3gacy was too lazy to actually write a commit message for this.\""
end

if topush
  system "git push"
  pretty_puts "pushed (hopefully)"
end
