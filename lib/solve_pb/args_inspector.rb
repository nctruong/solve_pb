module SolvePb
  class ArgsInspector
    def parse
      args = [:url, :lang]
      @args = {}
      ARGV.each_with_index do |arg, index|
        @args[args[index]] = arg if index < 2
      end
      if @args[:lang].nil?
        puts "Using default language: Ruby"
        @args[:lang] = "ruby"
      end
      if @args[:url].nil?
        puts "Please input url. Example:"
        puts "$ bundle exec solve https://www.hackerrank.com/challenges/bomber-man"
        return nil
      end
      if @args.size > 2
        puts "More than 2 parameters specified. Ignored last #{ARGV.size - 2} params."
      end
      unless supported_language? @args[:lang]
        puts "#{@args[:lang]} is not supported yet."
        return nil
      end
      return @args
    end

    private
    def supported_language?(lang)
      ["c++", "ruby"].include?(lang)
    end
  end
end
