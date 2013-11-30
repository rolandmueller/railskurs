Zeit unsere App der Welt zu zeigen. 

	Wir nutzen Heroku um unsere App zu deployen. Hier gibt es eine Anleitung:
	https://devcenter.heroku.com/articles/getting-started-with-rails4
	
	Einloggen in Heroku auf der Konsole
	```bash
	heroku login
	```
	
	Im *Gemfile* folgendes hinzufügen
	```ruby
	group :production do
	  gem 'pg'
	  gem 'rails_12factor'
	end
	```
	
	In *config/database.yml* den Konfiguration der Produktions-Datenbank mit diesem ersetzen:

	```javascript	
	production:
	  adapter: postgresql
	  encoding: unicode
	  database: task_production
	  pool: 5
	  password:
	```
	
	auf der Konsole die Gems mit bundle install installieren jedoch ohne Productions.
	```bash
	bundle install --without production
	```

	auf der Konsole die Gems mit bundle install installieren jedoch ohne Productions.
	```bash
	git commit -a -m "Update Gemfile.lock fuer Heroku"
	```	

	Auf der Konsole. Muss man nur einmal pro Projekt machen. 
	```bash
	heroku create
	```		

	Auf Heroku den Source-Code pushen:
	```bash
	git push heroku master
	```

	Auch auf Heroku db:migrate durchführen
	```bash
	heroku run rake db:migrate
	```
	
	und wenn man will auch db:setup durchführen
	```bash
	heroku run rake db:setup
	```
	
	Im Browser öffnen:
	```bash
	heroku open
	```
	
	
	
