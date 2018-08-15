module SolvePb
  class Problem

    attr_accessor :url, :name, :sample_input, :sample_output

    def initialize(url, name, sample_input, sample_output)
      @url = url
      @name = name
      @sample_input = sample_input
      @sample_output = sample_output
    end

    def download_pdf
      "https://www.hackerrank.com/rest/contests/master/challenges/#{name}/download_pdf?language=English"
    end
  end
end
