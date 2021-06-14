require "option_parser"

# These are the default values used by the parser
path = "."
_write_license = false
_commit = false
_topush = false
_debug = false

# --------------------------- Builtin functions ---------------------------

# Prints out text with cool dashes on the side
def pretty_puts(text : String)
  width = 10
  puts "-" * width + " #{text} " + "-" * width
end

# Commits the path it's given
def commit(_path : String)
  system "git add #{_path}"
  system "git commit -m \"Commited auto-magically because l3gacy was too lazy to actually write a commit message for this.\""
  pretty_puts "Commited #{_path} to the local repo"
end

def write_license(_commit : Bool, _path : String)
  # license is set here
  license = "This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <http://unlicense.org/>"

  File.write _path + "/UNLICENSE", license
  pretty_puts "Written license to #{_path}"
  if _commit
    # If commiting to a git repo
    commit "UNLICENSE"
  end
end

# Determine if file is in path
def in_path(file : String, path : String) : Bool
  # Creates a path item with the supplied path
  path = Dir.new path

  # Flags if the file has been found
  _found = false

  path.each do |itered|
    # If the file is the one were looking for, mark it as found
    if itered == file
      _found = true
    end
  end

  # Return that
  _found
end

def init
  pretty_puts "Create git repo"
  system "git init"
  pretty_puts "Commiting"
  commit "."
  write_license true, "."
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
    STDERR.puts "ERROR: The l3g binary is not avalible in the current directory"
    exit 1
  end
end

def create_project(_type : String)
  case _type
  # When NextJs is the type of the project, this code runs
  when "nextjs"
    pretty_puts "Using yarn"
    system "yarn create next-app"
    write_license true, "."
  end
end

OptionParser.parse do |parser|
  parser.banner = "L3gacy's toolkit"

  parser.on "init", "initialize a new project" do
    init
    _write_license = true
  end

  parser.on "nextjs", "Create a new nextjs project" do
    create_project "next"
  end

  # license generation
  parser.on "license", "Generate license" do
    # Write license to file
    _write_license = true
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
    puts "version 0.3"
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
    _commit = true
  end

  parser.on "-p", "--push", "Turns on pushing after actions" do
    _topush = true
  end

  parser.on "-d", "--debug", "Does whatever I'm needing to debug" do
    _debug = true
  end

  # Error handling
  parser.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option."
    STDERR.puts parser
    exit(1)
  end
end

# Debug runs if debug flag is set
if _debug
  p! pretty_puts "Nothing here for now!"
end

# If we need to write, then write license
if _write_license
  if _commit
    write_license true, "."
  else
    write_license false, "."
  end
  exit
end

# This little block runs if the commit flag is true
if _commit
  commit path
end

# This little block runs if the push flag is true
if _topush
  system "git push"
  pretty_puts "pushed (hopefully)"
end
