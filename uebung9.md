#  Übung 9: Todo-App Fortsetzung 2 (Javascript)

1. Wir haben folgende neue Anforderungen:
	* Projekte haben einen Namen. Ein Task soll maximal zu einem Projekt gehören (belongs_to). Ein Projekt kann mehrere Tasks haben (has_many).
	* Es soll eine Projekt-Seite geben, wo alle Projekte angezeigt werden (Index-Methode des Project-Controllers). 
	* Auf der selben Index-Seite soll man Projekte anlegen können. Projekte kann man nur erstellen, wenn man eingeloggt ist. Die Projekt-Seite soll per Javascript und [Ajax](http://de.wikipedia.org/wiki/Ajax_%28Programmierung%29) umgesetzt werden. 
	* Auf der selben Seite soll man Projekte umbennen und löschen können.
	* Ein Task kann man einem Projekt zuordnen. Ein Projekt kann mehrere Tasks haben.
	* Es soll eine Filterung der Aufgaben geben, so dass nur Aufgaben angezeigt werden, die man selber erstellt hat oder die an einem delegiert worden sind.

2. Ein Task soll maximal zu einem Projekt gehören (belongs_to). Ein Projekt kann mehrere Task haben (has_many).

  Diesmal gehen wir etwas anders vor als beim Task: wir nutzen kein Scaffolding, da wir die meisten dabei generierten Views diesmal nicht brauchen. Wir generieren statt dessen nur das Model und den Controller und fügen dann die Views und die Javascripts selber hinzu.
  
  Als erstes generieren wir das Projekt-Modell.
  
  ```bash
  rails generate model project name
  ```
 
  Die Veränderung muss noch in der Datenbank durchgeführt werden:
  ```bash
  rake db:migrate
  ``` 
    In Project-Model  *app/models/project.rb* fügen wir eine Validation durch, dass der Name des Projects vorhanden seien muss:
  ```ruby
  validates :name, presence: true
  ```
  
  Project und Task sind durch ein Fremdschlüssel *project_id* in der Tasks-Tabelle verbunden. Diesen müssen wir zur Tasks-Tabelle hinzufügen:
  ```bash
  rails generate migration AddProjectIdToTasks project_id:integer:index
  ```

  Die Datenbank muss noch aktualisiert werden:
  ```bash
  rake db:migrate
  ```
  
  In den Modellen müssen wir noch die Relationen hinzufügen. In *app/models/project.rb*:
  ```ruby
  has_many :tasks
  ```
  In *app/models/task.rb*:
  ```ruby
  belongs_to :project
  ```
  
  Ausserdem passen wir wir die Seed-Daten an (in db/seed.db):
  ```ruby
  # ruby encoding: utf-8
  user1 = User.create!(username: "Alice", email: 'alive@alice.com', :password => 'topsecret', :password_confirmation => 'topsecret')
  user2 = User.create!(username: "Bob", email: 'bob@bob.com', :password => 'topsecret', :password_confirmation => 'topsecret')
  project1 = Project.create(name: "Rails-Kurs")
  project2 = Project.create(name: "Startup")
  user1.tasks.create(name: "Todo-Applikation", deadline: Date.today + 7.days, duration: 2, done: false, delegated_id: user2.id, project_id: project1.id)
  user2.tasks.create(name: "Idee für eigene Web-Applikation", deadline: Date.today + 10.days, duration: 2, done: false, project_id: project2.id)
  user1.tasks.create(name: "Rails for Zombies", deadline: Date.today - 2.days, duration: 3, done: false, delegated_id: user2.id)
  user2.tasks.create(name: "Übung 6: Rails Account", deadline: Date.today - 4.days, duration: 3, done: false, project_id: project1.id)
  user1.tasks.create(name: "Übung 1: FizzBuzz", deadline: Date.today - 26.days, duration: 4, done: true, project_id: project1.id)
  user2.tasks.create(name: "Übung 2: Ruby Konto", deadline: Date.today - 20.days, duration: 5, done: true, delegated_id: user1.id)
  ```

  Anschließend laden wir die Seed-Daten in die Datenbank:
  ```bash
  rake db:setup
  ```
  
  Alle Test funktionieren noch:
	```bash
	rake test
	...............
	
	15 tests, 20 assertions, 0 failures, 0 errors, 0 skips
	```
  
3. Es soll eine Projekt-Seite geben, wo alle Projekte angezeigt werden (Index-Methode).

	Wir generieren ein Project-Controller mit einer Index-Methode:
	```bash
	rails generate controller Projects index
	```
	
	Wir laden in der Index-Methode des Controllers alle Projekte (in *app/controllers/project_controller.rb*:
	```ruby
	@projects = Project.all
	```
	
	In *config/routes.rb* löschen wir
	```ruby
	get "projects/index"
	```
	und schreiben statt dessen
	```ruby
	resources :projects, except: [:show]
	```
	da wir alle Resourcen-Routes bis auf Show bald sowieso brauchen.
	
	In *app/views/projects/index.html.erb* löschen wir alles und schreiben statt dessen:
	```html
	<%= link_to 'New Project', new_project_path, id: "new_link", remote: true, :class => "btn btn-success  btn-sm" %>
	
	<h2>Projects</h2>
	
	<table class="table table-hover">
	  <thead>
	    <tr>
	      <th>Name</th>
	      <th></th>
	    </tr>
	  </thead>
	  <tbody>
	    <%= render @projects %>
	  </tbody>
	</table>
	```
	
	Die Zeile ```<%= render @projects %>``` funktioniert wie folgt. ```@projects```ist ein Array von Projekten (haben wir grade im Controller aus der Datenbank geladen). Rails ist nun so clever, dass wenn eine Collection von Modell-Instanzen übergibt, dass dann 1. der Partial für jedes Element im Array extra aufgerufen wird und 2. der Partial-Name aus dem Modell-Name abgeleitet wird. Damit sparen wir uns eine Schleife. Alternativ zu ```<%= render @projects %>``` hätten wir auch länger ```<%= render partial: "project", collection: @projects %>``` schreiben können (exakt gleiche Wirkung).
	
	Den eigentlichen Partial müssen wir noch erstellen. Wir fügen im Ordner  *app/views/projects/* eine neue Date mit dem Namen *_project.html.erb* hinzu (den Partial) und fügen folgendes in die Datei:
	```html
	<tr id="project_<%= project.id %>"> 
	  <td><%= link_to project.name, edit_project_path(project), remote: true %></td>
	
	  <td><%= link_to "Delete", project, :class => "btn btn-danger  btn-sm", remote: true, method: :delete, data: { confirm: 'Are you sure?' } %></td>
	</tr>
	```
	
	Abschließend wollen wir die Navigations-Bar etwas verbessern. Erstens sollen Menu-Punkte für Tasks und Projects links in der Navigations-Bar erscheinen, die aktiv sind, wenn der jeweilige Controller genutzt wird (```<%= "active" if params[:controller] == "projects" %>"```). Dafür nutzen wir die Bootstrap Classe "active" (http://getbootstrap.com/components/#navbar). Ausserdem soll das Menu bei zu kleiner Breite des Browser bzw. bei Smartphones sich zusammenklappen ("collapse") und als Menu-Button oben rechts erscheinen. Wir ersetzten alles in der Datei *app/views/layouts/_navigation.html.erb* mit foglendem:
	
	```html
	<div class="navbar navbar-inverse navbar-fixed-top" role="navigation">
		<div class="container">
			<div class="navbar-header">
				<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
					<span class="sr-only">Toggle navigation</span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
				</button>
				<%= link_to "Todo-App", tasks_path, :class => "navbar-brand" %>
			</div>
			<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
				<ul class="nav navbar-nav">
		      <li class="<%= "active" if params[:controller] == "tasks" %>">
		      	<%= link_to "Tasks", tasks_path %>
		      </li>
		      <li class="<%= "active" if params[:controller] == "projects" %>">
		      	<%= link_to "Projects", projects_path %>
		      </li>
		    </ul>
	
				<ul class="nav navbar-nav navbar-right">
					<% if user_signed_in? %>
					<li>
						<%= link_to 'Logout', destroy_user_session_path, :method=>'delete' %>
					</li>
					<li>
						<%= link_to "Logged in as " + current_user.username, edit_user_registration_path %> 
					</li>
					<% else %>
					<li>
						<%= link_to 'Login', new_user_session_path %>
					</li>
					<li>
						<%= link_to 'Sign up', new_user_registration_path %>
					</li>
					<% end %>
				</ul>
			</div>
		</div>
	</div>
	```
	Sieht gut aus:
	![](https://dl.dropboxusercontent.com/u/10978171/projects.png)
	
	Wenn die Breite des Browsers zu klein ist klappt das Menu zusammen:
	
	![](https://dl.dropboxusercontent.com/u/10978171/iphone.png)
	
	Damit der neue Controller-Test funktioniert, füge in *test/controllers/projects_controller_test.rb* den folgenden Code nach ```class ProjectsControllerTest < ActionController::TestCase``` ein :
	
	```ruby
	include Devise::TestHelpers
	```
	
	Der neue Test für die Index-Funktion läuft:
	```bash
	rake test
	................
	
	16 tests, 21 assertions, 0 failures, 0 errors, 0 skips
	```
	
	Zeit für ein Commit:
	```bash
	git add .
	git commit -m "Index-Seite von Project"
	```
	
4. Auf der selben Index-Seite soll man Projekte anlegen können. Projekte kann man nur erstellen, wenn man eingeloggt ist. Die Projekt-Seite soll per Javascript und [Ajax](http://de.wikipedia.org/wiki/Ajax_%28Programmierung%29) umgesetzt werden. 

	Als erstes müssen wir uns entscheiden, ob wir auch Browser mit ausgeschalteten Javascript unterstützen oder nicht. Rails erleichtert gleichzeitige Unterstützung von Javascript und Nur-HTML Verhalten ungemein mit dem ```respond_to``` Befehl im Controller. Wir entscheiden uns, dass der Nutzer Javascript aktiviert haben muss und unsere Anwendung mit ausgeschaltetem Javascript nicht funktionieren würde (kann man später auch noch ändern).

	Als erstes soll wenn man auf den "New Project" Button drückt, der Button verschwinden und statt dessen ein Formular erscheinen. In *app/views/projects/index.html.erb* ist der "New Project" Button schon mit ```remote: true```als Remote-Link definiert ```<%= link_to 'New Project', new_project_path, id: "new_link", remote: true, :class => "btn btn-success  btn-sm" %>```so dass wir dort nichts ändern brauchen. Der Link ruft die New-Methode im Project-Controller per Javascript auf. Diese Methode müssen wir also erstellen:
	
	```ruby
	def new
	  @project = Project.new
	end
	```
	
	Sieht genau so aus wie im Task-Controller. Der Unterschied ist nun, dass wir kein HTML-View für diese Methode erstellen, sondern ein Javascript view. Wir erstellen eine neue Datei *app/views/project/new.js.erb* und schreiben darin folgendes:
	```javascript
	$('#new_link').hide().after('<%= j render("form") %>');
	$('#project_name').focus();
	$('#cancel_button').clickCancelButton();
	```
	
	Die erste Zeile macht als erstes den "New-Button" mit der ID "new_link" unsichtbar (```$('#new_link').hide()```). Hinter dem Button wird das Formular *form* eingefügt (```.after('<%= j render("form") %>')```). Das ```j``` steht für ```escape_javascript``` und formt das HTML des Formulars so um, dass es per Javascript eingebaut werden kann. 
	
	Die zeite Zeile gibt dem Text-Input-Feld mit der ID "project_name" den Fokus, d.h. der Cursor ist dann im Text-Feld und der Nutzer muss nicht erst in das Feld klicken (```$('#project_name').focus();```). 
	
	Die dritte Zeile fügt dem Cancel-Button die Funktion *clickCancelButton()* hinzu.
	
	Damit dieses drei Zeilen Javascript funktionieren, brauchen wir als erstes das Formular in einem Partial "form". Wir erstellen eine Datei *_form* im Verzeichnis *app/views/project/* und fügen folgendes ein:
	
	```html
	<%= form_for(@project, remote: true, :html => {id: "new_project"}) do |f| %>
		<div class="row form-group">
			<div class="col-xs-4">
				<label class="control-label" for="project_name" id="error-message"></label>
				<%= f.text_field :name, class: "form-control" %>
			</div>
			<div class="col-xs-3 button-group">	
				<%= f.submit "Save", class: "btn btn-primary btn-sm" %>  
				<%= link_to 'Cancel', "", id: "cancel_button", class: "btn btn-default btn-sm" %>
			</div>
		</div>
	<% end %>
	```
	
	Als zweites fügen wir in *app/asssets/javascripts/projects.js.coffee* folgenden Code ein:
	```javascript
	jQuery.fn.clickCancelButton = ->
		@find('#cancel_button').click ->
			$('#new_project').remove()
			$('#new_link').show()
	```
	In der ersten Zeile wird eine neue Javascript-Funktion mit dem Namen *clickCancelButton* definiert (```jQuery.fn.clickCancelButton = ->```). In der zweiten Zeile wird für den HTML-Tag mit der ID "cancel_button" definiert, was beim Click-Ereignis passieren soll (```@find('#cancel_button').click ->```). In den letzen beiden Zeilen wird beschrieben, dass dann als erstes das Formular gelöscht werden soll (```$('#new_project').remove()```) und dann der "New Project" Button wieder erscheinen soll (```$('#new_project').remove()```).
	





