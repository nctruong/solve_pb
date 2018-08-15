require 'fileutils'
require 'open-uri'
require 'solve_pb/problem_parser'

module SolvePb
  class FileGenerator
    attr_reader :problem, :language

    def generate(args)
      @problem = ProblemParser.new.parse(args[:url])
      @language = args[:lang]
      if problem
        puts "Preparing workspace"
        create_directory
        create_readme
        create_main_program
        create_sample_input
        create_sample_output
        download_pb_statement
        # create_runsh(problem, language)
      else
        puts "Couldn't fetch problem information. Please raise an issue on https://github.com/nctruong/solve_pb"
      end
    end

    private

    def create_directory
      puts "\tcreate #{File.join(problem.name, '')}"
      Dir.mkdir(problem.name)
    end

    def create_main_program
      main_file_name = get_main_file_name
      main_file_path = File.join(
        SolvePb.root, "template",
        language, main_file_name)
      des_path = File.join(problem.name, main_file_name)
      puts "\tcreate #{des_path}"
      FileUtils.cp(main_file_path, des_path)
    end

    def create_sample_input
      path = File.join(problem.name, "sample.input")
      unless file_exists?(path)
        open(path, 'w') do |f|
          f.write(problem.sample_input)
        end
        puts "\tcreate #{path}"
      end
    end

    def create_sample_output
      path = File.join(problem.name, "sample.output")
      unless file_exists?(path)
        open(path, 'w') do |f|
          f.write(problem.sample_output)
        end
        puts "\tcreate #{path}"
      end
    end

    def create_runsh
      runsh_path = File.join(
        SolvePb.root, "template", language, "compile.sh")
      des_path = File.join(problem.name, "run.sh")
      puts "\tcreate #{des_path}"
      FileUtils.cp(runsh_path, des_path)
      FileUtils.chmod("a+x", des_path)
    end

    def get_main_file_name
      return "main.rb" if language == "ruby"
    end

    def create_readme
      path = File.join(problem.name, "readme.md")
      unless file_exists?(path)
        open(path, 'w') do |f|
          f.write("[#{problem.name.capitalize} url](#{problem.url})")
        end
        puts "\tcreate #{path}"
      end
    end

    def download_pb_statement
      path = File.join(problem.name, "#{problem.name}.pdf")
      unless file_exists?(path)
        download = open(problem.download_pdf)
        IO.copy_stream(download, path)
        puts "\tcreate #{path}"
      end
    end

    def file_exists?(path)
      raise "\tignore #{path}. It already exists." if File.exist?(path)
      false
    end
  end
end
