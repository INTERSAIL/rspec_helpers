# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require 'rails/all'
require 'rspec/rails'
require 'spec_helper'
require 'database_cleaner'

# Require support files
require File.expand_path("../../config/environment", __FILE__)
Dir[File.dirname(__FILE__) + '/support/**/*.rb'].each { |f| require f }

RSpec.configure do |config|
  # Activate factory girl
  config.include FactoryGirl::Syntax::Methods

  ###
  # Database handling
  ###

  # migrate test schema if needed
  ActiveRecord::Migrator.migrate(File.join(Rails.root, 'db/migrate'))

  # Clean database at start of the suite and then
  # just uses transactions
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  # config.around(:each) do |single_test|
  #   DatabaseCleaner.cleaning do
  #     single_test.run
  #   end
  # end

  config.before(:all) do
    DatabaseCleaner.start # usually this is called in setup of a test
    seed_db
  end

  config.after(:all) do
    DatabaseCleaner.clean
  end
end

def seed_db
  @product_1 = FactoryGirl.create(:product)
  # Service
  @service_1 = FactoryGirl.create(:service, product: [@product_1])
  @service_2 = FactoryGirl.create(:service, name: 'Service2', product: [@product_1])
  # Service Center
  @sc_1 = FactoryGirl.create(:service_center)
  # Customers
  @customer_1 = FactoryGirl.create(:customer, service_center: @sc_1, status: 'OK')
  @customer_2 = FactoryGirl.create(:customer, name: 'Customer2', service_center: @sc_1, status: 'OK')
  @customer_sc =FactoryGirl.create(:customer, name: @sc_1.name, service_center: @sc_1, is_cs: true)
  # ServiceContracts
  @service_contract_1 = FactoryGirl.create(:service_contract, service: @service_1, customer: @customer_1, product: @product_1, active: true)
  @service_contract_2 = FactoryGirl.create(:service_contract, service: @service_2, customer: @customer_1, product: @product_1, active: true)
  @service_contract_3 = FactoryGirl.create(:service_contract, service: @service_1, customer: @customer_2, product: @product_1, active: true)
  # ServiceStatuses
  @ss_1 = FactoryGirl.create(:service_status, service: @service_1, customer: @customer_1, product: @product_1, status: 'OK', status_message: 'Ok msg')
  @ss_2 = FactoryGirl.create(:service_status, service: @service_1, customer: @customer_2, product: @product_1, status: 'OK', status_message: 'Ok msg')
  @ss_3 = FactoryGirl.create(:service_status, service: @service_1, customer: @customer_sc, product: @product_1, status: 'OK', status_message: 'Ok msg')
  @ss_4 = FactoryGirl.create(:service_status, service: @service_2, customer: @customer_1, product: @product_1, status: 'WARNING', status_message: 'Ok msg')
  @ss_5 = FactoryGirl.create(:service_status, service: @service_2, customer: @customer_2, product: @product_1, status: 'OK', status_message: 'Ok msg')
  @ss_6 = FactoryGirl.create(:service_status, service: @service_2, customer: @customer_sc, product: @product_1, status: 'OK', status_message: 'Ok msg')
end