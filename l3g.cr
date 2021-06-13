require "option_parser"

path = "."
write_license = false
commit = false
topush = false

# Prints out text with cool dashes on the side
def pretty_puts(text)
  puts "----- #{text} -----"
end

# Determine if file is in path
def in_path(file : String, path : String) : Bool
  # Creates a path item with the supplied path
  path = Dir.new(path)
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
  p! in_path "l3g", path
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

  parser.on "-p", "--push", "turns on pushing after actions" do
    topush = true
  end

  parser.on "install", "Install l3g to the user dir" do
    install "."
  end

  # Error handling
  parser.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option."
    STDERR.puts parser
    exit(1)
  end
end

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

For more information, please refer to <http://unlicense.org/>
"

# If we need to write, then write license
if write_license
  File.write(path + "/UNLICENSE", license)
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
    pretty_puts "commited to git repo"
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
