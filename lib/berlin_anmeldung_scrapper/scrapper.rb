module BerlinAnmeldungScrapper
  class Scrapper
    INITIAL_PAGE = 'https://service.berlin.de/dienstleistung/120686/'.freeze
    attr_accessor :b
    def initialize
      spinner
      @b = Watir::Browser.new(:chrome)
    end

    def run
      spinner.update(title: 'Checking the calendar...')
      b.goto(INITIAL_PAGE)
      b.a(text: 'Termin berlinweit suchen').click
      day_urls = b.as.select { |a| a.text =~ /\d{1,2}/ }.map {|a| a.href }
      spinner.success('Ok, now lets check every single day')
      bar(day_urls.count)
      @appointments = day_urls.collect do |day_url|
        scrap_day_page(day_url)
        bar.advance
      end
    end

    def scrap_day_page(url)
      b.goto(url)
      date = b.div(text: 'Datum').next_sibling.text
      time = nil
      b.div(class: 'timetable').trs.collect do |tr|
        # Empty tr represents the same time as the previous appointment
        time = tr.th.text unless tr.th.text == ''
        location =  tr.td.text
        Appointment.new(date, time, location)
      end
    end

    def locations
      @appointments.map {|appointment| appointment.location}.uniq
    end

    def appointments_for_location(location)
      @appointments.keep_if { |appointment| appointment.location?(location) }
    end

    private 

    def bar(count = nil)
      return @bar if @bar
      format = '[:bar] Inspecting appointment pages | ' \
               ':eta estimated, :elapsed elapsed (:percent)'
      @bar = TTY::ProgressBar.new(format, total: count)
      @bar
    end

    def spinner
      return @spinner if @spinner
      @spinner = TTY::Spinner.new("[:spinner] :title", format: :spin_2)
      @spinner.update(title: 'Starting ...')
      @spinner.auto_spin
      @spinner
    end
  end
end
