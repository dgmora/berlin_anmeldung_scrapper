module BerlinAnmeldungScrapper
  class Scrapper
    include Capybara::DSL
    INITIAL_PAGE = 'https://service.berlin.de/dienstleistung/120686/'.freeze
    def initialize
      @appointments = []
    end

    def run
      spinner.update(title: 'Checking the calendar...')
      visit(INITIAL_PAGE)
      click_on('Termin berlinweit suchen')
      day_urls = all('a').to_a.keep_if { |a| a.text =~ /\d{1,2}/ }
                              .map {|a| a[:href] }
      spinner.success('Ok, now lets check every single day')
      bar(day_urls.count)
      day_urls.each do |day_url|
        scrap_day_page(day_url)
        bar.advance
      end
      bar.finish
    end

    def scrap_day_page(url)
      visit(url)
      raise "Too many requests, the burgeramt has catched you. RUN!" if has_text?('429 Calm down')
      date = all(:xpath, "//div[contains(text(),'Datum')]/following-sibling::div")
              .first { |datum| datum.text =~ /\w+\.\s\d+\.\s\w+\s\d{4}/ }.text
      rows = find('div.timetable').all('tr')
      bar.log(date + " has #{rows.count} appointment(s) available")
      time = nil
      rows.each do |tr|
        # Empty tr represents the same time as the previous appointment
        date_column_text = tr.find('th').text
        time = date_column_text unless date_column_text == ''
        location_link =  tr.find('td').find('a')
        location =  location_link[:text]
        termin_url =  location_link[:href]
        @appointments << Appointment.new(date, time, location, termin_url)
      end
    end

    def locations
      @appointments.map { |appointment| appointment.location }.uniq.sort
    end

    def appointments_for_locations(locations)
      @appointments.keep_if { |appointment| appointment.in?(locations) }.sort
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
      @spinner = TTY::Spinner.new(":spinner :title", format: :spin_2)
      @spinner.update(title: 'Starting ...')
      @spinner.auto_spin
      @spinner
    end
  end
end
