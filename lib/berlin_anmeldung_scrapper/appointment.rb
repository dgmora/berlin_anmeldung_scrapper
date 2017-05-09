module BerlinAnmeldungScrapper
  class Appointment
    attr_accessor :date, :time, :location

    def initialize(date, time, location)
      @date = date
      @time = time
      @location = normalize_location(location)
    end

    def location?(location)
      @location.include?(normalize_location(location))
    end

    def to_s
      "#{@date} - #{@time}: #{@location}"
    end

    private 

    def normalize_location(location)
      # Remove parentheses and 'buergeramt' from location
      # Bürgeramt 1 <location>
      # Bürgeramt <location>
      location.sub(/Bürgeramt\s(\d{1}\s)?/, '').delete('()')
              .gsub('ü', 'u').gsub('Ü','u') # Sorry I suck at this
              .gsub('ä', 'a').gsub('Ä','a')
              .gsub('ö', 'o').gsub('Ö','o') 
              .gsub('ß', 'ss').gsub('ẞ','ss') 
              .downcase
    end
  end
end
