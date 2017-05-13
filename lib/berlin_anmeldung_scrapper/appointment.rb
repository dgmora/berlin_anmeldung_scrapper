module BerlinAnmeldungScrapper
  class Appointment
    attr_accessor :date, :time, :location

    def initialize(date, time, location, termin_url)
      @date = date
      @time = time
      # You want to keep the pretty-name location, so you don't normalize it.
      @location = clean(location)
      @termin_url = termin_url
    end

    def in?(locations)
      locations.map do |l|
        if normalize_location(@location).include?(normalize_location(l))
          return true
        end
      end
      return false
    end

    def to_s
      "#{@date} - #{@time}: #{@location}"
    end

    def <=>(other)
      (@date + @time + @location) <=> (other.date + other.time + other.location)
    end

    private 

    def clean(location)
      # Bürgeramt 1 <location>
      # Bürgeramt <location>
      # Remove parentheses and 'buergeramt' from location
      location.sub(/Bürgeramt\s(\d{1}\s)?/, '').delete('()')
    end

    def normalize_location(location)
      clean(location).gsub('ü', 'u').gsub('Ü','u') # Sorry I suck at this
                     .gsub('ä', 'a').gsub('Ä','a')
                     .gsub('ö', 'o').gsub('Ö','o') 
                     .gsub('ß', 'ss').gsub('ẞ','ss') 
                     .downcase
    end
  end
end
