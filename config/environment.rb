require "roda"
require 'active_record'

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || YAML::load(File.open('config/database.yml')))
