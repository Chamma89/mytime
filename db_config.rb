# settings for activerecord
require 'active_record'



options = {
	adapter: 'postgresql',
	database: 'mytime',
	

}

ActiveRecord::Base.establish_connection( ENV['DATABASE_URL'] || options)


