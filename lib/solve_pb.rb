require "byebug"
require "solve_pb/version"
require "solve_pb/version"
require "solve_pb/problem"
require "solve_pb/problem_parser"
require "solve_pb/command_line"
require "solve_pb/file_generator"

module SolvePb
  def self.root
    File.dirname __dir__
  end

  def self.test
    File.join root, "test"
  end

  def self.main
    args = SolvePb::Commandline.new.parse
    if args
      SolvePb::FileGenerator.new.generate(args)
    else
      puts "Doing nothing. Abort!"
    end
  end
end
