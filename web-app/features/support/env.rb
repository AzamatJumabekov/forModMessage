require 'capybara'
require 'capybara/cucumber'
require 'capybara/dsl'
require 'selenium-cucumber'
require 'selenium/webdriver'

Capybara.default_driver = :selenium
Capybara.server_port = 9292