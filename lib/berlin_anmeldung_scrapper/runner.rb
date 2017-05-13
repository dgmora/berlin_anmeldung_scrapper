module BerlinAnmeldungScrapper
  class Runner
    def initialize
      @scrapper = BerlinAnmeldungScrapper::Scrapper.new
      @prompt = TTY::Prompt.new
      @scrapper.run
    end

    def search
      location = @prompt.ask("Where do you want to get an appointment?")
      appointments = @scrapper.appointments_for_locations([location])
      print_appointments(appointments)
    end

    def print_appointments(appointments)
      if appointments.empty? 
        @prompt.say("Sorry, couldn't find anything for #{location}")
        return
      end
      @prompt.say('These are the (40 first) vailable appointments:')
      appointments.first(40).each { |appointment| puts appointment }
    end

    def multiselect
      msg = 'Select where:(Use arrow keys, press Space to select and Enter to finish)'
      locations = @prompt.multi_select(msg, @scrapper.locations.dup, echo: false)
      return 'Please, select a location' if locations.empty?
      appointments = @scrapper.appointments_for_locations(locations)
      print_appointments(appointments)
    end

    def run
      loop do
        action = @prompt.select('What do you want to do?') do |menu|
          menu.choice('Search myself for a location', 1)
          menu.choice('Select from available locations', 2)
          menu.choice('Pry - Interactive console', 3)
          menu.choice('Quit', 4)
        end
        case action
        when 1; then search
        when 2; then multiselect
        when 3; then binding.pry
        when 4; then break
        end
      end
    end
  end
end
