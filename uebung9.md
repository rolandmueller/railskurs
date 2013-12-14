#  Übung 9: Todo-App Fortsetzung 2 (Javascript)

1. Wir haben folgende neue Anforderungen:
	* Projekte haben einen Namen. Ein Task soll maximal zu einem Projekt gehören (belongs_to). Ein Projekt kann mehrere Tasks haben (has_many).
	* Es soll eine Projekt-Seite geben, wo alle Projekte angezeigt werden (Index-Methode des Project-Controllers). 
	* Auf der selben Index-Seite soll man Projekte anlegen können. Projekte kann man nur erstellen, wenn man eingeloggt ist. Die Projekt-Seite soll per Javascript und [Ajax](http://de.wikipedia.org/wiki/Ajax_%28Programmierung%29) umgesetzt werden. 
	* Auf der selben Seite soll man Projekte umbennen und löschen können.
	* Ein Task kann man einem Projekt zuordnen.

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
	
	Zeit für ein Commit:
	```bash
	git add .
	git commit -m "Project-Modell erstellt"
	```
  
3. Es soll eine Projekt-Seite geben, wo alle Projekte angezeigt werden (Index-Methode).

	Wir generieren ein Project-Controller mit einer Index-Methode:
	```bash
	rails generate controller Projects index
	```
	
	Wir laden in der Index-Methode des Controllers alle Projekte (in *app/controllers/project_controller.rb*):
	```ruby
	def index
	  @projects = Project.all
	end
	```
	
	Nach ```class ProjectsController < ApplicationController``` fügen wir folgende Zeile hinzu: 
	```ruby
	before_action :authenticate_user!
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
	
	setup do
	  @project = tasks(:one)
	  @user = users(:one)
	end
	```
	
	Im Index-Test fügen wir noch den User-Login (```sign_in @user```) zur Methode hinzu:
	```ruby
	test "should get index" do
	  sign_in @user
	  get :index
	  assert_response :success
	end
	```
	
	Wir ändern auch die Fixtures in *test/fixtures/projects.yaml* mit folgendem:
	```javascript
	one:
		name: "Project 1"
	
	two:
		name: "Project 2"
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
	
	Die zweite Zeile gibt dem Text-Input-Feld mit der ID "project_name" den Fokus, d.h. der Cursor ist dann im Text-Feld und der Nutzer muss nicht erst in das Feld klicken (```$('#project_name').focus();```). 
	
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
	
	
	Probieren Sie aus, ob der "New Project" und der "Cancel" Button funktioniert:
	![](https://dl.dropboxusercontent.com/u/10978171/project_form.png)
	
	Wir fügen in *test/controllers/projects_controller_test.rb* folgenden Test hinzu:
	```rub
	test "should get new" do
	  sign_in @user
	  xhr :get, :new
	  assert_response :success
	end
	```
	
	```xhr :get, :new``` ist ein Ajax-Aufruf der New-Methode mttels *get*: 
	Der neue Test  läuft:
	```bash
	rake test
	.................
	
	17 tests, 22 assertions, 0 failures, 0 errors, 0 skips
	```
	
	Zeit für ein Commit:
	```bash
	git add .
	git commit -m "New Project und Cancel Button"
	```
	
5. Wenn man das Formular abschickt, wird ans Ende der Liste das neue Projekt hinzugefügt, das Formular verschwindet und statt dessen erscheint der "New Project" Button.

	In *app/controllers/projects_controller.rb* fügen wir folgendes ein:
	
	```ruby
	def create
	  @project = Project.new(project_params)
	  @project.save
	end
	```
	
	Ganz ans Ende des Controllers fügen wir noch dies hinzu:
	```ruby
	private
		def project_params
		  params.require(:project).permit(:name)
		end 
	```

	Damit erlauben wir dass das Attribut *name* von Rails verarbeitet wird. *private* sagt, dass diese Methoden danach nur innerhalb des Controllers aufgerufen werden können, nicht von aussen. Das heißt wenn wir weitere Methoden zum Controller hinzufügen, müssen diese **oberhalb** von *private* sein. Ansonsten kann man diese nicht vom Internet aus aufrufen.
	
	Abschließend müssen wir noch ein View für die Controller-Methode *create* erstellen. Es soll jedoch nicht HTML dem Browser gesendet werden, sondern Javascript. Darum erstellen wir im Verzeichnis *app/views/projects/* die Datei *create.js.erb* und fügen ein:
	
	```javascript
	$('#new_project').remove();
	$('#new_link').show();
	$('tbody').append('<%= j render(@project) %>');
	```
	Die erste Zeile entfernt das Formular mit der ID *new_project* (```$('#new_project').remove();```). Die zweite Zeile läßt den "New Project" Button mit der ID *new_link* wieder erscheinen (```$('#new_link').show();```). Die letzte Zeile fügt ans Ende der Tabelle (HTML-Tag ```tbody```) das grade neu erstellte Projekt mittels des Project-Partials ```$('tbody').append('<%= j render(@project) %>')```. 
	
	Probieren Sie das hinzufügen von Projekten aus. 
	
	Wir fügen in *test/controllers/projects_controller_test.rb* folgenden Test hinzu:
	```ruby
	test "should create project" do
	  sign_in @user
	  assert_difference('Project.count') do
	    xhr :post, :create, project: { name: "Project Name" }
	  end
	  assert_response :success
	end
	```
	Der neue Test  läuft:
	```bash
	rake test
	..................
	
	18 tests, 24 assertions, 0 failures, 0 errors, 0 skips
	```
	
	Wenn alles funktioniert ist es Zeit für ein Commit:
	```bash
	git add .
	git commit -m "Create Project"
	```	

6. Fehler-Meldung bei leerem oder schon vorhandenem Projekt.

	Wenn man momentan ein Projekt ohne Name oder mit schon bestehendem Namen im Formular abschickt, erscheint dieses in der Liste und es gibt keine Fehlermeldung. Sobald man aber ein Refresh der Seite macht, sind diese falschen Eintröge weg. Das müssen wir ändern.
	
	In *app/controllers/projects_controller.rb* ändern wir die create-Methode wie folgt:
	
	```ruby
	def create
	  @project = Project.new(project_params)
	  if !@project.save
	    render action: 'error'
	  end
	end
	```
	D.h. wenn man das Projekt nicht speichern kann (save gibt Falsch zurück), dann soll der Error-View gerendert werden. 
	
	
	In *app/views/projects/* fügen wir die Datei *error.js.erb* hinzu mit folgendem Inhalt:
	```javascript
	$(".form-group").addClass("has-error");
	$("#error-message").html("<%= j @project.errors.full_messages[0] %>");
	```
	
	Die erste Zeile fügt eine *has-error* CSS-Class zur *form-group* hinzu. *has-error* ist eine Bootstrap CSS-Klasse die das Eingabe-Feld Rot färbt (http://getbootstrap.com/css/#forms-control-states). In der zweiten Zeile wir im inneren des Tags mit der ID "error-message" (```$("#error-message").html()```, die die erste Fehlermeldung vom Project-Objekt ausgeben (```<%= j @project.errors.full_messages[0] %>```).
	
	![](https://dl.dropboxusercontent.com/u/10978171/error_js.png) 

	Wir fügen in *test/controllers/projects_controller_test.rb* folgenden Test hinzu:
	```ruby
	test "should not create project" do
	  sign_in @user
	  assert_no_difference('Project.count') do
	    xhr :post, :create, project: { name: "" }
	  end
	  assert_response :success
	end
	```
	Der neue Test  läuft:
	```bash
	rake test
	...................
	
	19 tests, 26 assertions, 0 failures, 0 errors, 0 skips
	```
	
	Probieren Sie es aus. Wenn alles funktioniert ist es Zeit für ein Commit:
	```bash
	git add .
	git commit -m "Fehler-Meldungen für Project"
	```

7. Ein Projekt kann man löschen.

	Im *app/controller/projects_controller.rb* fügen wir über *private* die Destroy-Methode hinzu:
	
	```ruby
	def destroy
	  @project = Project.find(params[:id])
	  @project.destroy
	end
	```
	
	Wir erzeugen eine neue Datei *destroy.js.erb* in *app/views/projects/* und fügen folgendes ein:
	
	```javascript
	$('#new_project').remove();
	$('#new_link').show();
	$('#project_<%= @project.id %>').remove();
	```
	
	Die ersten beiden Zeilen löschen das Formular und machen den "New Projekt" Button wieder sichtbar. Die dritte Zeile entfernt das Element mit der CSS-ID ```project_<%= @project.id %>```. 
	
	Probieren Sie es aus. 
	
	Wir fügen in *test/controllers/projects_controller_test.rb* folgenden Test hinzu:
	```ruby
	test "should destroy project" do
	  sign_in @user
	  assert_difference('Project.count', -1) do
	    xhr :delete, :destroy, id: @project
	  end
	  assert_response :success
	end
	```
	Der neue Test  läuft:
	```bash
	rake test
	....................
	
	20 tests, 28 assertions, 0 failures, 0 errors, 0 skips
	```
	
	Wenn alles funktioniert ist es Zeit für ein Commit:
	```bash
	git add .
	git commit -m "Löschen von Projekten"
	```
	
8. Ein Projekt kann man editieren.

	Im *app/controller/projects_controller.rb* fügen wir vor *private* die Edit-Methode hinzu:
	
	```ruby
	def edit
	  @project = Project.find(params[:id])
	end
	```
	
	Wir erzeugen eine neue Datei *edit.js.erb* in *app/views/projects/* und fügen folgendes ein: 
	```javascript
	$('#new_project').remove();
	$('#new_link').hide().after('<%= j render("form") %>');
	$('#project_name').focus();
	$('#cancel_button').clickCancelButton();
	```
	Die erste Zeile löscht das Formular, wenn es eins gibt. Die zwiete Zeile macht als erstes den "New-Button" mit der ID "new_link" unsichtbar (```$('#new_link').hide()```). Hinter dem Button wird das Formular *form* eingefügt (```.after('<%= j render("form") %>')```). Das ```j``` steht für ```escape_javascript``` und formt das HTML des Formulars so um, dass es per Javascript eingebaut werden kann. 	Die dritte Zeile gibt dem Text-Input-Feld mit der ID "project_name" den Fokus, d.h. der Cursor ist dann im Text-Feld und der Nutzer muss nicht erst in das Feld klicken (```$('#project_name').focus();```). Die vierte Zeile fügt dem Cancel-Button die Funktion *clickCancelButton()* hinzu.
	
	Nun wollen wir dass Änderungen vom Projekt auch in der Datenbank aktualisiert werdeb. Im *app/controller/projects_controller.rb* fügen wir vor *private* die Update-Methode hinzu:
	
	```ruby
	def update
	  @project = Project.find(params[:id])
	  if !@project.update(project_params)
	    render action: 'error'
	  end
	end
	```
	Der Code funktioniert ziemlich ähnlich wie die Create-Methode. Wenn wir nicht updaten können wegen Validierungs-Fehlern, d.h. update falsch zurück gibt ```if !@project.update(project_params)```, wird der *error* View gerendert.
	
	Wir erzeugen eine neue Datei *update.js.erb* in *app/views/projects/* und fügen folgendes ein: 
	```javascript
	$('#new_project').remove();
	$('#new_link').show();
	$('#project_<%= @project.id %>').replaceWith('<%= j render(@project) %>');
	```
	Die ersten beiden Zeilen kennen wir schon. Die letzte ersetzt (```replace_with```) das aktualisierte Element mit der ID ```project_<%= @project.id %>```mit dem aktualisierten Wert des Projekts. Dabei wird der Partial "project" gerendert und "escaped" (```j```) (```<%= j render(@project) %>```). 
	
	
	Probieren Sie es aus. 
	
	Wir fügen in *test/controllers/projects_controller_test.rb* folgende Tests hinzu:
	```ruby
	test "should get edit" do
	  sign_in @user
	  xhr :get, :edit, id: @project
	  assert_response :success
	end
	
	test "should update project" do
	  sign_in @user
	  xhr :patch, :update, id: @project, project: { name: @project.name }
	  assert_response :success
	end
	```
	Der neue Test  läuft:
	```bash
	rake test
	......................
	
	22 tests, 30 assertions, 0 failures, 0 errors, 0 skips
	```
	
	Wenn alles funktioniert ist es Zeit für ein Commit:
	```bash
	git add .
	git commit -m "Edit und Update Projects"
	```
	
9. Wir wollen noch ein paar Javascript Effekte hinzufügen. Dafür nutzen wir jQuery UI (http://jqueryui.com/) eine Bibliothek, die auf jQuery aufbaut. 

	Als erstes müssen wir diese intstallieren. In der Datei *Gemfile* fügen wir nach ```gem 'jquery-rails'```folgende Zeile hinzu: 
	
	```ruby
	gem 'jquery-ui-rails'
	```
	
	Annschließend installieren wir das Gem, in dem wir auf der Konsole folgendes ausführen:
	```bash
	bundle install
	```
	
	Dann fügen wir in *app/assets/javascripts/application.js* nach ```//= require jquery```folgendes ein:
	```javascript
	//= require jquery.ui.effect.all
	```
	
	Nun können wir die jQuery UI Effekte nutzen. Als erstes sollen eingefügte oder aktualisierte Porjekte gehighlightet werden. Wir fügen in *app/views/projects/create.js.erb* als letzte Zeile folgendes hinzu:
	```javascript
	$('#project_<%= @project.id %>').effect("highlight");
	```
	In *app/views/projects/update.js.erb* fügen wir als letzte Zeile  das selbe hinzu:
	```javascript
	$('#project_<%= @project.id %>').effect("highlight");
	```

	Einmal ausprobieren bitte.
	
	Dann fügen in *app/views/projects/error.js.erb* als letzte Zeile folgendes hinzu:
	```javascript
	$("#new_project").effect("shake");
	```	
	
	Einmal ausprobieren, in dem man ein leeres Projekt zu speichern versucht. Wenn alles funktioniert ist es Zeit für ein Commit:
	```bash
	git add .
	git commit -m "Effekte in Project für Create, Update und Error"
	```
	
10. Ein Task kann man einem Projekt zuordnen.

	Wir müssen das Formular für den Task um eine Drop-Down-Auswahl (*Select*) für das Projekt erweitern. Im View-Ordner von Task ändern wir das Form-Partial *app/views/tasks/_form.html.erb* und fügen vor ```<div class="actions">``` folgendes hinzu:
	```html
	<div class="form-group">
		<%= f.label :project_id %><br>
		<%= f.select :project_id, Project.all.collect {|p| [ p.name, p.id ] }, { :include_blank => true, :selected => @task.project_id}, class: "form-control" %>
	</div>
	```
	Der Code funktioniert genauso wie der für die Auswahl des Users zum delegieren.
	
	Im Tasks-Controller müssen wir *project_id* noch erlauben, in dem wir dieses zur Methode *task_params* hinzufügen:
	```ruby
	def task_params
	  params.require(:task).permit(:name, :deadline, :done, :duration, :delegated_id, :project_id)
	end
	```
	
	Dann wollen wir das Projekt noch im Index-Tasks anzeigen. Dafür müssen wir das Partial *app/views/tasks/_table.html.erb* ändern. Vor ```<th>Created</th>```fügen wir einen weiteren Table-Header(```<th>```) hinzu:
	```html
	<th>Project</th>
	```
	Vor ```<td> <%= task.user.username %> </td>```geben wir dann den Projectnamen der Aufgabe aus, wenn es ein Projekt gibt:
	```html
	<td> <%= task.project.name if task.project %> </td>
	```
	
	![](https://dl.dropboxusercontent.com/u/10978171/index-mit-project.png) 
	
	```bash
	git add .
	git commit -m "Task kann Projekt zugeordnet werden + Task-Index mit Projekt"
	```
