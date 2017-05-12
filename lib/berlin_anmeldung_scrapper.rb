require 'watir'
require 'tty'
require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
require 'berlin_anmeldung_scrapper/version'
require 'berlin_anmeldung_scrapper/appointment'
require 'berlin_anmeldung_scrapper/scrapper'

module BerlinAnmeldungScrapper
  Capybara.default_driver = :poltergeist
  Capybara.javascript_driver =  :poltergeist
end
