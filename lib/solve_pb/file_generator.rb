module SolvePb
  class FileGenerator
    attr_reader :problem, :language

    def generate(args)
      @problem = ProblemParser.new.parse(args[:url])
      @language = args[:lang]
      if problem
        puts "Preparing workspace"
        prepare_directory
        prepare_readme
        prepare_main_program
        prepare_sample_input
        prepare_sample_output
        download_pb_statement
      end
    end

    private

    def prepare_directory
      puts "\tcreate #{File.join(problem.name, '')}"
      Dir.mkdir(problem.name)
    end

    def prepare_main_program
      main_file_name = get_main_file_name
      main_file_path = File.join(SolvePb.root, "template", language, main_file_name)
      des_path = File.join(problem.name, main_file_name)
      puts "\tcreate #{des_path}"
      FileUtils.cp(main_file_path, des_path)
    rescue
      puts language
      puts main_file_name
    end

    def prepare_sample_input
      path = File.join(problem.name, "sample.input")
      unless file_exists?(path)
        open(path, 'w') { |f| f.write(problem.sample_input) }
        puts "\tcreate #{path}"
      end
    end

    def prepare_sample_output
      path = File.join(problem.name, "sample.output")
      unless file_exists?(path)
        open(path, 'w') { |f| f.write(problem.sample_output) }
        puts "\tcreate #{path}"
      end
    end

    def get_main_file_name
      return "main.rb" if language == "ruby"
      return "main.cpp" if language == "c++"
    end

    def prepare_readme
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
      raise "\tIgnore #{path}. It already exists." if File.exist?(path)
      false
    end
  end
end
