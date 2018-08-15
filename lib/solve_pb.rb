require 'fileutils'
require 'open-uri'
require 'net/http'
require 'json'
require 'uri'
require 'nokogiri'

require "solve_pb/version"
require "solve_pb/problem"
require "solve_pb/problem_parser"
require "solve_pb/args_inspector"
require "solve_pb/file_generator"

module SolvePb
  module ClassMethods
    def root
      File.dirname __dir__
    end

    def test
      File.join root, "test"
    end

    def main
      args = SolvePb::ArgsInspector.new.parse
      args.nil? ? 'Lack of URL' : SolvePb::FileGenerator.new.generate(args)
    end
  end
  extend ClassMethods
end
