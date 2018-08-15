module SolvePb
  class ArgsInspector
    attr_accessor :args

    PARAM = [:url, :lang]

    def initialize
      @args = {}
      ARGV.each_with_index do |arg, index|
        @args[PARAM[index]] = arg 
        if index >= 2
          puts "Only accept two params: url and lang"
          break
        end
      end
    end

    def parse 
      return args if lang_valid? && url_valid?
    end

    private

    def lang_valid?
      valid = true
      if args[:lang].nil?
        puts "Using default language: Ruby"
        @args[:lang] = "ruby"
      elsif supported_language?(args[:lang]) == false
        puts "#{args[:lang]} is not supported yet."
        valid = false
      end
      valid
    end

    def url_valid?
      valid = true
      if args[:url].nil?
        puts "Please input url. Example:"
        puts "$ bundle exec solve https://www.hackerrank.com/challenges/bomber-man"
        valid = false
      end
      valid
    end

    def supported_language?(lang)
      ["c++", "ruby"].include?(lang)
    end
  end
end
