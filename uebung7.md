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
	
	Für eine erste Gestaltung benutzen wir [myBalsamique](https://berlin.mybalsamiq.com/) für den [Mockup](http://de.wikipedia.org/wiki/Mock-up). Wir haben eigenlich nur zwei wesentliche Seiten.  Einerseits die Liste alle Aufgaben (Das wäre die Index-Methode im Task-Controller) und andererseits ein Formular zum Einfügen (New-Methode im Controller) und Ändern (Edit-Methode im Controller) einer Aufgabe.
	
	Der Index-View soll ungefähr so aussehen:
	
	![](https://dl.dropboxusercontent.com/u/10978171/index.png)
	
	Es gibt einige Anforderungen an diesen Screen:
	1. Die Seite sollte die Home-Page sein, also bei der Eingabe der Haupt-URL erscheinen. Also während der Entwicklung direkt unter httt://localhost:3000/
	2. Wir brauchen keine Seite für die einzelne Darstellung von Aufgaben (Show-Methode im Task-Controller). Die Liste der Aufgaben reicht völlig aus. D.h. wir müssen die Show-Methode im Controller und die Show-Views entfernen.
	3. Die Seite sollte mit Bootstrap ein netteres Design bekommen.
	4. Man soll die Aufgabe ändern können (Link zur Edit-Methode im Controller), wenn man auf den Namen der Aufgabe klickt. Es soll kein extra Edit-Link oder Edit-Button angezeigt werden.
	5. Offene Aufgaben ("Todos") und erledigte Aufgaben ("Done") sollen in seperaten Listen dargestellt werden.
	6. Für offenen und erledigten Aufgaben soll die Anzahl der Aufgaben und die Summe der Stunden ausgegeben werden ("2 Tasks, 3 Hours).
	7. Die Todo-Liste soll die als letztes erzeugten Tasks oben sein. In der Done-Liste soll der als letztes abgehakten Aufgaben oben sein.
	8. Die erledigten Aufgaben sollen durchgestrichen sein.
	9. Wenn man die Checkbox einer unerledigten Aufgabe anklickt, soll die Aufgabe von der Todo zur Done Liste verschoben werden. Genauso umgekehrt für schon erledigte Aufgaben. D.h. um eine Aufgabe als erledigt zu markieren, musss man nicht erst in den Edit-Screen, sondern muss den Index-Screen nicht verlassen.
	10. Man soll die Aufgaben nach Aufwand (duration) und Deadline sortieren können.

	
	Der New- bzw. Edit-View soll ungefähr so aussehen.

	![](https://dl.dropboxusercontent.com/u/10978171/new.png)
	
	Es gibt einige Anforderungen an diesen Screen:
	
	1. Es soll eine Datum-Auswahl via einem Kalender (Date-Picker) geben.

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
4.	Fügen Sie das Github als Remote-Repositorium hinzu. https://github.com/GITHUB-ACCOUNT-NAME/todoapp.git ist die Adresse Ihres Git-Repositories (Sieht man rechts im Github-Repository bzw. nach erfolgreicher Erstellung des Repositoriums in der Erklärung). 

	```bash
	git remote add origin https://github.com/GITHUB-ACCOUNT-NAME/todoapp.git
	```
5.  Pushen Sie das Projekt zu Github. Kontrollieren Sie bei Github ob es da ist.

    ```bash
    git push origin master
    ```
    
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
	
    ```bash
    rake db:setup
    ```		

11. Öffnen Sie noch ein weitere Konsole (Terminal / Eingabeaufforderung / Rails Command-Prompt) im Verzeichnis *todoapp*. So kann in der einen Konsole der Rails-Server laufen und in der anderen kann man weitere Befehle ausführen. Starten Sie den Rails Server

    ```bash
    rails server
    ```	

	und gehen Sie zu [http://localhost:3000/tasks](http://localhost:3000/tasks)
	
	![](https://dl.dropboxusercontent.com/u/10978171/scaffold1.png)

	

12. Es ist gute Praxis oft zu commiten. Wenn man mit anderen gleichzeitig zusammenarbeitet sollte man auch oft pushen und pullen. Das müssen wir hier nicht. Jedoch sollte man vor einem Commit und insbesondere vor einem Push sich vergewissern das alles läuft.
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
	muss nun so lauten (*tasks_url* ist URL der Index-Methode von Task (Mehrzahl von Task), Siehe auch http://guides.rubyonrails.org/routing.html):

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

	Laden Sie aktuelle Twitter Bootstrap herunter (Anleitung http://rvg.me/using-bootstrap-3-with-rails-4/): 
	https://github.com/twbs/bootstrap/releases/download/v3.0.2/bootstrap-3.0.2-dist.zip 
	
	Die Zip Datei entpacken wir und kopieren die Datei *bootstrap.min.js* im *js* Ordner nach *vendor/assets/javascripts/* und die Datei *bootstrap.min.css* und *bootstrap-theme.min.css* im *css* Ordner nach *vendor/assets/stylesheets/*. Alle Dateien im *fonts* Verzeichnises kopieren wir nach */vendor/assets/*. 
	
	Das *vendor* Verzeichnis ist für Code der nicht von uns programmiert wurden ist. Wir müssen jedoch Javascript und CSS Dateien im *Vendor* Verzeichnis einzeln einbinden. Dies ist nicht für Javascripts und CSS der Fall, die im Verzeichnis *app/assets/javascripts/* bzw. *app/assets/stylesheets/* liegen.
	
	Für das Javascript: In *app/assets/javascripts/application.js* folgende Zeile vor ```//= require turbolinks``` einfügen:
	
	```javascript
	//= require bootstrap.min
	```
	
	 Für das CSS: In *app/assets/stylesheets/application.css* folgende Zeile vor ```*= require_self```einfügen:
	```css
	 *= require bootstrap.min
	 *= require bootstrap-theme.min	 
	```
	Dann in der selben Datei ans Ende Folgendes einfügen:
	```css
	@font-face {
	  font-family: 'Glyphicons Halflings';
	  src: url('../assets/glyphicons-halflings-regular.eot');
	  src: url('../assets/glyphicons-halflings-regular.eot?#iefix') format('embedded-opentype'), 
	       url('../assets/glyphicons-halflings-regular.woff') format('woff'), 
	       url('../assets/glyphicons-halflings-regular.ttf') format('truetype'), 
	       url('../assets/glyphicons-halflings-regular.svg#glyphicons_halflingsregular') format('svg');
	}
	```


	Ausserdem fügen wir noch für mobile Geräte ein [Viewport](https://developer.apple.com/library/safari/documentation/AppleApplications/Reference/SafariWebContent/UsingtheViewport/UsingtheViewport.html) vor dem Title tag ein:
	```html	
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
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
	In *app/views/tasks/index.html.erb* die Tabelle mit der CSS-Class ```table``` stylen (http://getbootstrap.com/css/#tables ):
	```html
	<table class="table  table-hover">	
	```
	
	In *app/views/layouts/application.html.erb* nach dem ```<body>``` Tag fügen wir eine Navigations-Leiste ein (http://getbootstrap.com/components/#navbar):
	```html
	<div class="navbar navbar-inverse navbar-fixed-top" role="navigation">
	  <div class="container">
	    <div class="navbar-header">
	      <a class="navbar-brand" href="#">Todo-App</a>
	    </div>
	  </div>
	</div>
	```
	
	In *app/assets/stylesheets/applications.css* fügen wir folgendes ans Ende:
	```css	
	body {
  	  padding-top: 60px;
	}
	```
	
	Den Link für "New Task" in *app/views/tasks/index.html.erb* verschieben wir von ganz am Ende der Seite nach  nach oben vor dem Überschrift (vor dem h1 Tag). Ausserdem soll er als kleine grüner Button gestylt werden. D.h. es müssen die Bootstrap CSS-Klassen btn, btn-success und btn-sm zugewiesen werden (http://getbootstrap.com/css/#buttons):
	```html	
	<%= link_to 'New Task', new_task_path, class: "btn btn-success btn-sm" %>
	```
	
	Der Delete-Link soll als kleiner roter Button gestylt werden:
	```html		
	<%= link_to 'Destroy', task, class: "btn btn-danger btn-sm", method: :delete, data: { confirm: 'Are you sure?' } %>
	```
	
	In *app/views/tasks/index.html.erb* wollen wir die *notice* mit einem Bootstrap-Alert stylen (http://getbootstrap.com/components/#alerts und http://getbootstrap.com/javascript/#alerts):
	anstatt 
	```html	
  	<p id="notice"><%= notice %></p>
	```	
	das:
	```html	
	<% if notice %> 
	  <p id="notice" class="alert alert-success alert-dismissable fade in" data-dismiss="alert" aria-hidden="true">
	    <%= notice %>
	  <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
	  </p>
	<% end %>
	```	
	
	Nun sieht die Seite schon etwas besser aus:
	
	![](https://dl.dropboxusercontent.com/u/10978171/bootstrap.png)
	
	
	Nun sollten Sie einmal die Anwendung ausprobieren, ob alles funktioniert. Unter http://getbootstrap.com können Sie mehr über Bootstrap erfahren. Anschliessend können wir commiten:

	```bash
	git add .
	git commit -m "Design mit Bootstrap"
	```	

17. Man soll die Aufgabe ändern können (Link zur Edit-Methode im Controller), wenn man auf den Namen der Aufgabe klickt. Es soll kein extra Edit-Link oder Edit-Button angezeigt werden. In *app/views/tasks/index.html.erb* löschen wir 
	```html	
        <td><%= link_to 'Edit', edit_task_path(task) %></td>
	```

	und schreiben statt
	```html	
        <td><%= task.name %></td>
	```	
	```html	
        <td><%= link_to task.name, edit_task_path(task) %></td>
	```	        

	Da wir Spalten in der Tabelle gelöscht haben, brauchen wir weniger Header:
	```html	
	<thead>
	<tr>
	  <th>Name</th>
	  <th>Deadline</th>
	  <th>Done</th>
	  <th>Duration</th>
	  <th></th>
	</tr>
	</thead>
	```	

	Nun sieht die Seite so aus:
	
	![](https://dl.dropboxusercontent.com/u/10978171/kein_edit.png)
	
	Anschliessend können wir commiten:

	```bash
	git commit -am "Edit Link integriert"
	```

17. Offene Aufgaben ("Todos") und erledigte Aufgaben ("Done") sollen in seperaten Listen dargestellt werden.

	In der Index-Methode im Task-Controller *app/controllers/task_controller.rb* schreiben wir statt
	```ruby
   	@tasks = Task.all
	```
	```ruby
    	@done = Task.where(done: true)
    	@todo = Task.where(done: false)
	```


	Im Index-View *app/views/index.html.erb* schneiden wir die komplette Tablle aus (von ```<table>``` bis ```</table>```)  und fügen die diese in eine neue Datei namens *_table.html.erb* im Verzeichnis *app/views/tasks/* ein. Dies ist ein sogenanntes Partial. Anstatt
	```html	
	<% @tasks.each do |task| %>
	```
	schreiben wir 
	```html	
	<% tasks.each do |task| %>
	```	
	*tasks* ist eine lokale Variable die wir dann entweder @done oder @todo übergeben.
	
	Im Index-View *app/views/index.html.erb* ersetzen wir ```<h1>Listing Tasks<h1>``` mit folgendem: 
	```html
	<h2>Todo</h2>
	<%= render partial: "table", locals: {tasks: @todo} %>
	<h2>Done</h2>
	<%= render partial: "table", locals: {tasks: @done} %>
	```

	Nun sieht die Seite so aus:
	
	![](https://dl.dropboxusercontent.com/u/10978171/zwei_listen.png)
	
	Die Spalte *Done* ist jetzt redundant und kann entfernt werden. Folgendes in *app/views/tasks/_table.html.erb* löschen:

	```html
	<th>Done</th>
	```
	```html
	<td><%= task.done %></td>
	```	

	Nun sieht die Seite so aus:
	
	![](https://dl.dropboxusercontent.com/u/10978171/ohne_done.png)
	
	Anschliessend können wir commiten:	
	```bash
	git add .
	git commit -m "Todo und Done Liste getrennt"
	```	

18. Für offenen und erledigten Aufgaben soll die Anzahl der Aufgaben und die Summe der Stunden ausgegeben werden ("2 Tasks, 3 Hours).

	Fügen Sie folgendes hinter Todo in den h2 Tag ein
	```html	
	(<%= pluralize(@todo.count, "Task") %>, <%= pluralize(@todo.sum("duration"), "Hour") %>)
	```
	
	Fügen Sie folgendes hinter Todo in den h2 Tag ein
	```html	
	(<%= pluralize(@done.count, "Task") %>, <%= pluralize(@done.sum("duration"), "Hour") %>)
	```	
	
	Die Rails-Funktion *pluralize* beugt das Wort (Einzahl oder Mehrzahl) je nach erstem Parameter: http://api.rubyonrails.org/classes/ActionView/Helpers/TextHelper.html#method-i-pluralize.  *count* und *sum* sind die Aggregations-Funktionen von ActiveRecord analog zu SQL: http://guides.rubyonrails.org/active_record_querying.html#calculations
	
	Nun sieht die Seite so aus:
	
	![](https://dl.dropboxusercontent.com/u/10978171/kalkulation.png)
	
	
	Der Rails-Helper *pluralize* verändert das Wort im zweiten Parameter ("Task" bzw. "Hour") je nachdem ob der erste Parameter 1 ist ode viele. Wenn wir einen Done-Task löschen, sehen wir das:
	
	![](https://dl.dropboxusercontent.com/u/10978171/one_task_done.png)
	
	Wir können immer für die Datenbank ein neues setup durchführen und die Seed-Daten wieder laden: 
	
	```bash
	rake db:setup
	```	
	
	Nun können wir commiten:	
	```bash
	git add .
	git commit -m "Gesamte Anzahl und Dauer anzeigen"
	```	

19. Die Todo-Liste soll die als letztes erzeugten Tasks oben sein. In der Done-Liste soll der als letztes abgehakten Aufgaben oben sein.

	Wir müssen ordnen http://guides.rubyonrails.org/active_record_querying.html#ordering. In der Index-Methode im Task-Controller *app/controllers/task_controller.rb* schreiben wir 
	```ruby
	@done = Task.where(done: true).order(created_at: :desc)
	@todo = Task.where(done: false).order(updated_at: :desc)
	```

	```bash
	git commit -am "Todo und Done geordnet"
	```

20. New bzw. Edit-View soll besser aussehen. 

	Für die Fehlermeldungen nehmen wir ein Pannel mit Überschrift von Bootstrap
	http://getbootstrap.com/components/#panels. Wir ersetzen den Fehler-Code mit folgendem:
	
	```html	
	  <% if @task.errors.any? %>
	    <div class="panel panel-danger">
	      <div class="panel-heading">
	        <h3 class="panel-title"><%= pluralize(@task.errors.count, "error") %> prohibited this task from being saved:</h3>
	      </div>
	      <div class="panel-body">
	        <ul>
	          <% @task.errors.full_messages.each do |msg| %>
	            <li><%= msg %></li>
	          <% end %>
	        </ul>
	      </div>
	    </div>
	  <% end %>
	```
	
	Das Formular soll auch besser aussehen. Dafür nutzen wir Bootstrap Forms (http://getbootstrap.com/css/#forms). Wir ersetzen in in *app/views/tasks/_form.html.erb* die Zeile 
	
	```html		
	<%= form_for(@task) do |f| %>
	  </div>	
	```
	mit
	```html		
	<%= form_for @task, :html => { :role => "form"} do |f| %>
	  </div>	
	```	
	
	Dann ersetzen wir im unteren Teil des Formulares den Teil mit diesem Code:
	```html		
	  <div class="checkbox">
	    <label>
	      <%= f.check_box :done %> <%= f.label :done %>
	    </label>
	  </div>
	  <div class="form-group">
	    <%= f.label :name %><br>
	    <%= f.text_field :name, class: "form-control", placeholder: "Name of Task" %>
	  </div>
	  <div class="form-group">
	    <%= f.label :deadline %><br>
	    <%= f.date_field :deadline, class: "form-control", placeholder: "Deadline of Task" %>
	  </div>
	  <div class="form-group">
	    <%= f.label :duration %><br>
	    <%= f.text_field :duration, class: "form-control", placeholder: "Duration of Task" %>
	  </div>
	  <div class="actions">
	    <%= f.submit "Save Task", class: "btn btn-primary" %>  <%= link_to 'Cancel', tasks_path, class: "btn btn-default" %>
	  </div>	
	```	
	
	Dann löschen wir in *app/views/tasks/new.html.erb* und  *app/views/tasks/edit.html.erb* folgende Zeile:
	```html		
	<%= link_to 'Back', tasks_path %>
	```
	
	Das Formular sieht schon besser aus:
	
	![](https://dl.dropboxusercontent.com/u/10978171/form.png)
	
	Nun können wir commiten:	
	```bash
	git add .
	git commit -m "Formular mit Bootstrap"
	```
	
21. Es soll eine Datum-Auswahl via einem Kalender geben.

	Wir laden uns den Bootstrap 3 Datepicker runter: http://eternicode.github.io/bootstrap-datepicker/
	Die Zip Datei entpacken wir und kopieren die Datei *bootstrap-datepicker.js* im *js* Ordner nach *vendor/assets/javascripts/* und die Datei *datepicker.css* im *css* Ordner nach *vendor/assets/stylesheets/*. 
	
	Für das Javascript: In *app/assets/javascripts/application.js* folgende Zeile vor ```/= require turbolinks``` einfügen:
	
	```javascript
	//= require bootstrap-datepicker
	```
	
	 Für das CSS: In *app/assets/stylesheets/application.css* folgende Zeile vor ```*= require_self```einfügen:
	```css
	*= require datepicker
	```	
	
	Anschließend kopieren wir diesen Coffeescript Code in *app/assets/javascript/tasks.js.coffee* ans Ende:
	```javascript	
	$(document).on 'ready page:load', ->
	  $('#task_deadline').datepicker({
	  	format: "yyyy-mm-dd",
	  	autoclose: true
	  });
	```
	
	Der Code macht folgendes: Nach dem der Seite geladen wurde (```$(document).on 'ready page:load'```) wird die Datums-Feld (mit der CSS-ID 'task_deadline') mit einem datepicker versehen. Coffeescript vereinfacht die Javascript Programmierung und wird zu Javascript kompiliert (siehe auch http://coffeescript.org/, http://edgeguides.rubyonrails.org/working_with_javascript_in_rails.html oder http://railscasts.com/episodes/267-coffeescript-basics für mehr Informationen). Nach dem man den Rails-Server neu gestartet hat, haben wir ein netten Datepicker.
	
	![](https://dl.dropboxusercontent.com/u/10978171/datepicker.png)
	
	```bash
	git add .
	git commit -m "Bootstrap Date-Picker integriert"
	```
	
22. Die erledigten Aufgaben sollen durchgestrichen sein.

	Wir fügen dieses CSS in *app/assets/stylesheets/application.css* ein
	```css
	.done {
	  text-decoration:line-through;
	}
	```
	
	In *app/views/tasks/index.html.erb* übergeben wir dem Partial die zusätzliche lokale Variable *css_class*:
	```html  
	<%= render partial: "table", locals: {tasks: @todo, css_class: "todo"} %>
	```
	und
	```html  
	<%= render partial: "table", locals: {tasks: @done, css_class: "done"} %>
	```
	
	In *app/views/tasks/_table.html.erb* ändern wir den ```<td>``` Tag in der Zeile 
	```html       
	<td><%= link_to task.name, edit_task_path(task) %></td>
	```
	und fügen dort dynamisch die CSS-Klasse ein. D.h. die CSS-Klasse wird durch die lokale Variable *css_class* bestimmt:
	```html  	
	<td class="<%= css_class %>">
	```

	![](https://dl.dropboxusercontent.com/u/10978171/durchgestrichen.png)	

	```bash
	git add .
	git commit -m "Erledigt Aufgaben durchgestrichen"
	```

22. Wenn man die Checkbox einer unerledigten Aufgabe anklickt, soll die Aufgabe von der Todo zur Done Liste verschoben werden.

	Wir bewerkstelligen dies, in dem in jeder Zeile der Tabelle eine Mini-Form eingefügt wird, die jeweils nur aus einer Checkbox besteht. Diese Form hat auch kein Submit-Button. Für das Submit, fügen wir etwas Javascript hinzu, dass falls die Checkbox geklickt wird, die Form submittet.
	
	In *app/views/tasks/_table.html.erb* fügen wir eine erste Spalte mit einer Checkbox ein.

	Nach ```<thead><tr>```fügen wir eine weitere leere Header-Spalte für die Checkbox ein:
	```html 	
	<th></th>
	```
	
	Nach 
	```html 
	<% tasks.each do |task| %>
	  <tr>
	```
	fügen wir die Mini-Formulare ein (alle haben die CSS-Klasse "checkabele"):
	```html 	
	<td>
	  <%= form_for task do |f| %>
	    <%= f.check_box :done, class: "checkable" %>
	  <% end %>
	</td>
	```
	
	Anschließend fügen wir dieses Coffeescript ans Ende von *app/assets/javascript/tasks.js.coffee*
	```javascript		
	$(document).on 'ready page:load', ->
	  $(".checkable").click ->
	    $(this).parents('form').submit();
	```
	Der Code fügt für alle Elemente mit der CSS-Klasse "checkable" (unsere Checkboxen) folgendes Verhalten hinzu: falls die Checkbox geklickt wird, wird die Form zu dieser Checkbox submittet ```parents('form').sumit()```
	
	```bash
	git add .
	git commit -m "Checkboxen im Index-View"
	```

23. Man soll die Aufgaben nach Aufwand (duration) und Deadline sortieren können.

	In der Index-Methode im Task-Controller ersetzt man den Code mit folgendem:
	```ruby
	if params[:sorting]
	  @done = Task.where(done: true).order(params[:sorting] => :desc)
	  @todo = Task.where(done: false).order(params[:sorting] => :desc)
	else
	  @done = Task.where(done: true).order(created_at: :desc)
	  @todo = Task.where(done: false).order(updated_at: :desc)
	end
	```
	
	In *app/views/tasks/_table.html.erb* ersetzen wir die Header von Deadline und Duration mit diesem:
	```html
	<th><%= link_to "Deadline", tasks_path(sorting: "deadline") %>
	  <% if params[:sorting] == "deadline" %>
	    ^
	  <% end %>
	</th>
	<th><%= link_to "Duration", tasks_path(sorting: "duration") %> 
	  <% if params[:sorting] == "duration" %>
	    ^
	  <% end %> 
	</th>
	```
	
	```bash
	git add .
	git commit -m "Sortierung nach Aufwand und Deadline"
	```
	
24. Ändern Sie die *README.rdoc* Datei. Löschen Sie den Inhalt und fügen Sie Ihren Namen und eine kurze Beschreibung des Projekts ein.
	
	Alles zu git hinzufügen, commiten und pushen:

	````bash
	git add .
	git commit -m "Alles fertig! Ein Task kann ich schon mal abhacken :-)."
	git push origin master
	```
	
	Kontrollieren Sie bei Github ob es da ist.
	
25. Nun ist es Zeit, die Anwendung auf einen Server zu veröffentlichen (sog. Deployment). Auf gehts: https://github.com/rolandmueller/railskurs/blob/master/deployment.md 
