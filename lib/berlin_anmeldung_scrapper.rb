require 'tty'
require 'pry'
require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
require 'berlin_anmeldung_scrapper/version'
require 'berlin_anmeldung_scrapper/appointment'
require 'berlin_anmeldung_scrapper/scrapper'
require 'berlin_anmeldung_scrapper/runner'

module BerlinAnmeldungScrapper
  Capybara.default_driver = :poltergeist
  Capybara.javascript_driver =  :poltergeist
end
