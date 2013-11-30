Zeit unsere App der Welt zu zeigen. 

Wir nutzen Heroku um unsere App zu deployen. (siehe auch
https://devcenter.heroku.com/articles/getting-started-with-rails4):

Voraussetzung:
* Sie haben bereits auf Heroku https://www.heroku.com/ einen Account erstellt. Wir sollten für die Anmeldung die selbe Email wir bei Github nutzen.
* Sie haben Heroku Toolbelt auf ihrem Rechner installiert https://toolbelt.heroku.com/

Wenn ja, dann weiter:	

Wir ersetzen wir im *Gemfile* die folgende Zeile
```ruby	
gem 'sqlite3'
```
mit diesem:
```ruby
group :development do
  gem 'sqlite3'
end
group :test do
  gem 'sqlite3'
end
group :production do
  gem 'pg'
  gem 'rails_12factor'
end
```
Der Grund ist, dass Heroku die Datenbank Postgress (pg) nutzt und nicht wie wir bis jetzt sqlite.

Auf der Konsole installieren wir die Gems mit bundle install jedoch ohne die Production-Gems.
```bash
bundle install --without production
```

Da Heroku das Projekt über Git gepusht bekommt (genauso wie Github) müssen wir die Änderungen noch commiten.
```bash
git commit -a -m "Update Gemfile.lock fuer Heroku"
```	
	
Einloggen in Heroku auf der Konsole
```bash
heroku login
```

Auf der Konsole kreieren wir einen neuen Heroku Server. Muss man nur einmal pro Projekt machen. 
```bash
heroku create
```		

Die Authentifikation mit Heroku erfolgt über ssh. Wenn noch keine ssh-keys bestehen, erzeugen wir diese:
```bash
ssh-keygen -t rsa
```	

Und teilen der Heroku die ssh-keys mit
```bash
heroku keys:add
```	

Nun pushen wir mit git den Source-Code zu Heroku:
```bash
git push heroku master
```

Genauso wie auf den lokalem PC müssen wir auf Heroku ein rake db:migrate durchführen
```bash
heroku run rake db:migrate
```

und wenn man will auch kann man die Datenbank mit den seed.rb Daten füllen, durch rake db:setup 
```bash
heroku run rake db:setup
```

Anschließend kann man die eigene Anwendung im Browser öffnen:
```bash
heroku open
```

Heroku weisst der App ein zufällig erstellten Namen zu. Den kann man wie folgt ändern (Name muss aber frei sein):
```bash
heroku apps:rename mein-neuer-appname
```	

Die URL Ihrer App ist dann http://mein-neuer-appname.herokuapp.com z.B. http://hwr-berlin-todoapp.herokuapp.com/

Falls wir nun Änderungen im Projekt haben, müssen wir nur diese commiten und dann nach Heroku pushen. Falls wir neue Modelle erstellt haben oder die sonstwie Datenbank geändert haben, müssen wir danach noch ein db:migrate auf Heroku dürchführen, sonst nicht.
