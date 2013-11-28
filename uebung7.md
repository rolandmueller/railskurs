# 7. Übung: Todo-App

0.	Entwurf

	Wir wollen eine einfache Todo-Applikation programmieren. In der ersten Version soll diese nur Aufgaben 
	verwalten. Eine Aufgabe (```Task```) hat einen Titel (```name```) und ein
	Fälligkeitsdatum (```deadline```), kann entweder feritg sein (```done```)
	oder nicht und dauert eine Anzahl von Stunden (```duration```). Die Datenbank besteht damit nur aus einer
	Tabelle:
	
	![](https://dl.dropboxusercontent.com/u/10978171/database.png)
	
	Die Attrbute ```id```, ```created_at``` und ```updated_at``` werden von Rails standardmäß hinzugefügt, d.h. wir müssen diese nicht explizit beim Generieren des Modells angeben.
	
	Es sollen keine Aufgaben ohne einen Namen, eine Deadline und eine Dauer geben und Dauer ist numerisch (Validations-Regeln). 
	
	Für eine erste Gestaltung benutzen wir myBalsamique für den Mockup. Wir haben eigenlich nur zwei wesentliche Screens.  Einerseits die Liste alle Aufgaben (Das wäre die Index-Methode im Task-Controller) und andererseits ein Formular zum Einfügen (New-Methode im Controller) und Ändern (Edit-Methode im Controller) einer Aufgabe.
	
	Der Index-View soll ungefähr so aussehen:
	
	![](https://dl.dropboxusercontent.com/u/10978171/index.png)
	
	Es gibt einige Anforderungen an diesen Screen:
	1. Die Seite sollte die Home-Page sein, also bei der Eingabe der Haupt-URL erscheinen. Also während der Entwicklung direkt unter httt://localhost:3000/
	2. Wir brauchen keine Seite für die einzelne Darstellung von Aufgaben (Show-Methode im Task-Controller). Die Liste der Aufgaben reicht völlig aus. D.h. wir müssen die Show-Methode im Controller und die Show-Views entfernen.
	3. Die Seite sollte mit Bootstrap ein netteres Design bekommen.
	4. Offene Aufgaben ("Todos") und erledigte Aufgaben ("Done") sollen in seperaten Listen dargestellt werden.
	5. Für offenen und erledigten Aufgaben soll die Anzahl der Aufgaben und die Summe der Stunden ausgegeben werden ("2 Tasks, 3 Hours).
	6. Man soll die Aufgabe ändern können (Link zur Edit-Methode im Controller), wenn man auf den Namen der Aufgabe klickt. Es soll kein extra Edit-Link oder Edit-Button angezeigt werden.
	7. Wenn man die Checkbox einer unerledigten Aufgabe anklickt, soll die Aufgabe von der Todo zur Done Liste verschoben werden. Genauso umgekehrt für schon erledigte Aufgaben. D.h. um eine Aufgabe als erledigt zu markieren, musss man nicht erst in den Edit-Screen, sondern muss den Inde-Screen nicht verlassen.
	8. Man soll die Aufgaben nach Aufwand (duration) und Deadline sortieren können.
	
	Der New- bzw. Edit-View soll ungefähr so aussehen.

	![](https://dl.dropboxusercontent.com/u/10978171/new.png)
	
	Es gibt einige Anforderungen an diesen Screen:
	1. Es soll eine Datum-Auswahl via einem Kalender geben.
	2. Den Aufwand soll man mit einem numerischen Stepper verändern können.

1.	Generieren Sie ein neues Rails Projekt todoapp
	
    ```bash
    rails new todoapp
    cd todoapp
    ```
2.	Initialisieren Sie ein Git-Repositorium, fügen Sie alles hinzu und commiten Sie

    ```bash
    git init
    git add .
    git commit -m "Erstes Commit"
    ```
3.	Erzeugen Sie bei Github ein leeres Repositorium (ohne Readme und .gitignore file) mit dem Namen todoapp
4.	Fügen Sie das Github als Remote-Repositorium hinzu. ... Ist die Adresse Ihres Git-Repositories (Bei mir z.B.
https://github.com/rolandmueller/railskurs.git, Sieht man rechts in Github). 

	```bash
	git remote add origin ...
	```
5.  Pushen Sie das Projekt zu Github. Kontrollieren Sie bei Github ob es da ist.

    ```bash
    git push origin master
    ```
    Falls nach dem User und dem Passwort gefragt wurde, hier wird beschriben wie man das automatisieren kann: https://help.github.com/articles/generating-ssh-keys
    
6.  Wir generieren ein Gerüst (Scaffold) für das Modell ```Task```

    ```bash
    rails generate scaffold task name deadline:date done:boolean duration:float
    ```	
7.  und erzeugen die Tabelle in der Datenbank

    ```bash
    rake db:migrate
    ```	

8. Öffne das komplette Projekt in Sublime Text 2 in dem Sie z.B. den Ordner *todoapp* in Sublime schieben oder im Menu File | Open den Ordner *todoapp* öffnen.


10. Erzeugen Sie ein paar Aufgaben mithilfe einer Seed-Datei. Kopiere diese Daten in der Datei *db/seeds.rb*
```ruby
Task.create(name: "Todo-Applikation", deadline: Date.today + 7.days, duration: 2, done: false)
Task.create(name: "Idee für eigene Web-Applikation", deadline: Date.today + 10.days, duration: 2, done: false)
Task.create(name: "Rails for Zombies", deadline: Date.today - 2.days, duration: 3, done: false)
Task.create(name: "Übung 6: Rails Account", deadline: Date.today - 4.days, duration: 3, done: false)
Task.create(name: "Übung 1: FizzBuzz", deadline: Date.today - 26.days, duration: 4, done: true)
Task.create(name: "Übung 2: Ruby Konto", deadline: Date.today - 20.days, duration: 5, done: true)
```

	Beachten Sie, dass wir die Deadline dynamisch basierend vom heutigen Tag (```Date.today```) um einige Tage (z.B. ```7.days```) vor oder zurückgesetzt haben. Die Methode ```days``` wurde durch Rails zu der Integer-Klasse hinzugefügt. Damit kann man Integers als Datums-Tage umwandeln.

11. Öffnen Sie noch ein weitere Konsole (Terminal / Eingabeaufforderung / Rails Command-Prompt) im Verzeichnis *todoapp*. So kann in der einen Konsole der Rails-Server laufen und in der anderen kann man weitere Befehle ausführen. Starten Sie den Rails Server

    ```bash
    rails server
    ```	

	und gehen Sie zu [http://localhost:3000/tasks](http://localhost:3000/tasks)
	
	![](https://dl.dropboxusercontent.com/u/10978171/scaffold1.png)

	

12. Es ist gute Praxis oft zu commiten. Wenn man mit anderen gleichzeitig zusammenarbeitet sollte man auch oft pushen. Das müssen wir hier nicht. Jedoch sollte man vor einem Commit und insbesondere vor einem Push sich vergewissern das alles läuft.
    ```bash
    git add .
    git commit -m "Task Scaffold und Seed Daten"
    ```	

13. Starten wir mit den Anforderungen zur Geschäftslogik und den Validierungsregeln: Es sollen keine Aufgaben ohne einen Namen, eine Deadline und eine Dauer geben und Dauer ist numerisch. Dafür fügen wir folgendes in die ```Task``` Model-Klasse (in *app/models/task.rb*):
```ruby
validates :name, presence: true
validates :deadline, presence: true
validates :duration, presence: true, numericality: true 
```

	Wenn Sie nun in [http://localhost:3000/tasks/new](http://localhost:3000/tasks/new) eine Aufgabe ohne Namen und mit einer nicht numerischen Dauer eingeben, erhalten Sie folgende:
	
	![](https://dl.dropboxusercontent.com/u/10978171/validation.png)
 
	Wir commiten die Änderungen
    
    ```bash
    git add .
    git commit -m "Validationsregeln hinzugefügt"
    ```	

	Man hätte alternativ auch ```git commit -am "Validation-Regeln"``` schreiben können. Das ```-a``` im *commit* steht für *Add*.  Wir brauchen kein ```git add . ``` schreiben, weil keine neuen Dateien erzeugt wurden. Dies reicht aus, wenn schon bestehende Daten verändert werden. Ansonsten muss man mit ```git add .``` die Dateien erst hinzufügen. 

14. Die Index-Seite sollte die Home-Page sein. In *config/routes.rb* verändern wir die auskommentierte Zeile 
	```ruby
	# You can have the root of your site routed with "root"
	# root 'welcome#index'
	```
	
	und schreiben statt dessen
	```ruby
	root 'tasks#index'
	```

	Nun weist [http://localhost:3000](http://localhost:3000) auf die Index-Methode des Task-Controllers.

    ```bash
    git commit -am "Home-Page verändert"
    ```

15. Wir brauchen keine Seite für die einzelne Darstellung von Aufgaben (Show). D.h. wir können einiges löschen.

	Im Task-Controller (*app/controllers/task_controller.rb*) kann die Show-Methode gelöscht werden und die before-action Zeile
	```ruby
	before_action :set_task, only: [:show, :edit, :update, :destroy]
	```
	wie folgt verändert werden:
	```ruby
	before_action :set_task, only: [:edit, :update, :destroy]
	```
	
	Wir brauchen auch keine Route zur Show-Methode mehr. In *config/routes.rb* kann die zweite Zeile wie folgt verändert werden:
	```ruby	
	  resources :tasks, except: [:show]
	```
	
	Falls eine Aufgabe erfolgreich kreiert wurde (Create-Methode) bzw. verändert wurde (Update-Methode) wird normalerweise auf die Show-Methode umgeleitet (Redirect). Das müssen wir ändern. Nun soll auf die Index-Methode umgeleitet werden. Diese Zeile
	```ruby	
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
	```
	muss nun so lauten (*tasks_path* ist Link zur Index-Methode von Task (Mehrzahl von Task), Siehe auch http://guides.rubyonrails.org/routing.html):

	```ruby	
	format.html { redirect_to tasks_url, notice: 'Task was successfully created.' }
	```
	
	Das selbe gilt für die Update-Methode. Statt
	```ruby	
	format.html { redirect_to @task, notice: 'Task was successfully updated.' }
 	```
 	muss es so heissen:
	```ruby	
        format.html { redirect_to tasks_url, notice: 'Task was successfully updated.' }
	```	
	
	Nun sollte man auch die Links zur Show-Methode im *app/views/index.html.erb* löschen. Folgende Zeile kann weg:
	```html
	 <td><%= link_to 'Show', task %></td>
	```
	
	Auch in *app/views/edit.html.erb* kann das weg:
	```html
	<%= link_to 'Show', @task %> |
	```	
	
	Ausserdem kann die Datei *app/views/tasks/show.html.erb* gelöscht werden. Da wir auch *git* mitteilen wollen, 	dass diese Datei gelöscht werden soll, geben wir folgendes in der Konsole ein (rm steht für remove)
	
	```bash	
	git rm app/views/tasks/show.html.erb
	```
	
	In der Datei *app/views/tasks/index.html.erb* sollte man jedoch noch die Meldung, die vorher im Show-View war, einfügen:
	
	```html	
	<p id="notice"><%= notice %></p>
	```

	Nun sollten Sie einmal die Anwendung ausprobieren, ob alles funktioniert. Wenn ja, dann commiten wir:

	```bash
	git add .
	git commit -m "Show in Task gelöscht"
	```	

16. Die Seite sollte mit Bootstrap ein netteres Design bekommen. Sie sollten nach jedem Schritt immer wieder den Browser refreshen (F5) um die Veränderung im Design zu sehen.

	Links zu Twitter Bootstrap Stylesheets hinzufügen. In *app/views/layouts/application.html.erb* nach dem 
	title tag einfügen:

	```html
	<!-- Latest compiled and minified CSS -->
	<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.0.2/css/bootstrap.min.css">
	<!-- Optional theme -->
	<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.0.2/css/bootstrap-theme.min.css">
	```

	Twitter Bootstrap JavaScript in *app/views/layouts/application.html.erb* kurz vor ``` </body> ``` einfügen:
	```html
	<!-- Latest compiled and minified JavaScript -->
	<script src="//netdna.bootstrapcdn.com/bootstrap/3.0.2/js/bootstrap.min.js"></script>
	```

	Wir löschen den Stylesheet von Scaffold
	```bash
	git rm app/assets/stylesheets/scaffolds.css.scss
	```
	
	In *app/views/layouts/application.html.erb* ```<%= yield %>``` tag mit Bootstrap container umschließen:
	```html
	<div class="container">
		<%= yield %>
	</div> <!-- /container -->
	```
	In *app/views/tasks/index.html.erb* die Tabelle mit der CSS-Class ```table``` stylen:
	```html
	<table class="table">	
	```
	
	In *app/views/layouts/application.html.erb* nach dem ```<body>``` Tag fügen wir eine Navigations-Leiste ein:
	```html
	<div class="navbar navbar-inverse navbar-fixed-top" role="navigation">
	  <div class="container">
	    <div class="navbar-header">
	      <a class="navbar-brand" href="#">Todo-App</a>
	    </div>
	  </div>
	</div>
	```
	
	Den Link für "New Task" in *app/views/tasks/index.html.erb* verschieben wir von ganz am Ende der Seite nach ganz nach oben. Ausserdem bekommt er noch die Bootstrap CSS-Klassen btn und btn-success zugewiesen:
	```html	
	<%= link_to 'New Task', new_task_path, :class => "btn btn-success" %>
	```
	
	Danach sieht die Seite schon etwas besser aus:
	
	![](https://dl.dropboxusercontent.com/u/10978171/bootstrap.png)

	




