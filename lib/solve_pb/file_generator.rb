module SolvePb
  class FileGenerator
    attr_reader :problem, :language

    def generate(args)
      @problem = ProblemParser.new(args[:url]).parse
      @language = args[:lang]
      if problem
        puts "Preparing workspace"
        setup_workspace
      end
    end

    private

    def setup_workspace
      prepare_directory
      prepare_readme
      prepare_main_program
      prepare_sample_input
      prepare_sample_output
      download_pb_statement
    end

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
      create_file_path(problem.sample_input, path)
    end

    def prepare_sample_output
      path = File.join(problem.name, "sample.output")
      create_file_path(problem.sample_output, path)
    end

    def get_main_file_name
      return "main.rb" if language == "ruby"
      return "main.cpp" if language == "c++"
    end

    def prepare_readme
      path = File.join(problem.name, "readme.md")
      create_file_path("[#{problem.name.capitalize} url](#{problem.url})", path)
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

    def create_file_path(content, to_path)
      unless file_exists?(to_path)
        open(to_path, 'w') { |f| f.write(content) }
        puts "\tcreate #{to_path}"
      end
    end
  end
end
