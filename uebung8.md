# Übung 8: Todo-App Fortsetzung (Authentifizierung mit Devise)

1. Zusätzliche Anforderungen
    * Hinzufügen von Unit-Tests, die die Geschäftslogik des Modells testen
    * Hinzufügen von Functional-Tests, die den Controller testen
    * Im Modell soll es eine Methode geben, die angibt ob Deadline überschritten ist.
    * Im Modell soll es eine Methode geben, die die Differenz zu Heute anzeigt in Tagen.
    * Deadline soll als umgangssprachliger Text ("1 day ago" bzw. "in 20 days") dargestellt werden
    * Man soll sich als User registrieren und ein und ausloggen können (Authentifizierung).
    * Nur wenn man eingeloggt ist, darf man ein Task erstellen (Autorisierung).
    * Ein erstellter Task wird zu dem User zugeordnet, der ihn erstellt. Ein User kann mehrere Tasks haben.
    * Nur wenn man eingeloggt ist und den Task erstellt hat, darf man den Task ändern oder löschen.
    * Ein User soll einen User-Namen haben. Dieser soll nicht doppelt vorkommen und darf nicht leer sein.
    * Im Index-Screen soll für jeden Task der User angezeigt werden, der den Task erstellt hat.
    * Man kann eine Aufgabe einem anderen User delegieren.
    * Im Index-Screen soll für jeden Task der User angezeigt werden, an den der Task delegiert wurde.
    * Eine Aufgabe kann auch geändert werden, wenn man die Aufgabe delegiert bekommen hat.


2. Hinzufügen von Unit-Tests, die die Geschäfstlogik des Modells testen (für Tests siehe auch http://guides.rubyonrails.org/testing.html und Slides)

   Momentan ist der Unit-Test in *test/models/task_test.rb* auskommentiert und wenn man auf der Konsole
   
   ```bash
   rake test:units
   ```	
   eingibt erhält man:
   ```bash
   0 tests, 0 assertions, 0 failures, 0 errors, 0 skips
   ```
   Unser erster Test in *test/models/task_test.rb*. Wir fügen einen Test hinzu der prüft, dass man eine leere Aufgabe nicht speichern kann.
   ```ruby
   test "task can not be saved without name" do
     task = Task.new
     assert !task.save
   end
   ```  
   
   Das Ausrufezeichen (!) steht für nicht. Also gibt task.save hier falsch zurück und kann die Aufgabe wegen der Validations-Regel nicht speichern. Das ist dass, was wir erwartet (assert) haben.
   
   ```bash
   rake test:units
   
   # Running tests:
   .

   1 tests, 1 assertions, 0 failures, 0 errors, 0 skips
   ```	
   
   Wir fügen einen zweiten Test in *test/models/task_test.rb* ein, der testet, ob man einen vollständig ausgefüllten Task speichern kann:
   ```ruby
   test "task can be saved with name, deadline and duraton" do
     task = Task.new
     task.name = "Eine Aufgabe"
     task.deadline = Date.today + 7.days
     task.duration = 5.0
     assert task.save
   end   
   ``` 
   
   ```bash
   rake test:units
   
   # Running tests:
   ..

   2 tests, 2 assertions, 0 failures, 0 errors, 0 skips
   ```

3. Hinzufügen von Functional-Tests, die den Controller testen

   Wenn man auf der Konsole
   ```bash
   rake test:functionals
   ```	
   eingibt erhält man:
   ```bash
   7 tests, 12 assertions, 3 failures, 1 errors, 0 skips
   ```

   Failure ist wenn ein Assert (Annahme) nicht erfüllt wird. Error ist, wenn das Programm ein Syntax-Fehler hat. Die Functional-Tests (in *test/controllers*) wurden vom *generate scaffold* Befehl mit generiert. Warum funktionieren sie nicht mehr? In der letzten Übung 7 haben wir einiges nach dem Scaffolding geändert. Insbesondere haben wir die Show-Methode gelöscht und die Redirects geändert. Schauen wir uns den ersten Failure an:

   ```bash
   1) Failure:
   TasksControllerTest#test_should_create_task [/Users/roland/Documents/sourcecode/rails_projects/todoapp/test/controllers/tasks_controller_test.rb:24]:
   Expected response to be a redirect to <http://test.host/tasks/980190963> but was a redirect to <http://test.host/tasks>.
   Expected "http://test.host/tasks/980190963" to be === "http://test.host/tasks".
   ```
   
   In *test/controllers/task_controller_test.rb* im Test *test "should create task"* wird erwartet, dass wir auf  Show redirecten:

   ```ruby  
   assert_redirected_to task_path(assigns(:task))
   ```
   
   Wir redirecten aber nun auf Index. Sofern müssen wir den Test ändern (tasks_url ist die Index-Url):
   
   ```ruby  
   assert_redirected_to tasks_url
   ```   
   
   Und nach 
   ```bash
   rake test:functionals
   ```
   haben wir schon mal einen Failure weniger:
   ```bash
   
   7 tests, 11 assertions, 2 failures, 1 errors, 0 skips
   ```
   
   Der nächste Failure sieht so aus:
   
   ```bash
   1) Failure:
   TasksControllerTest#test_should_get_index [/Users/roland/Documents/sourcecode/rails_projects/todoapp/test/controllers/tasks_controller_test.rb:11]:
   Expected nil to not be nil.
   ```
   
   In *test/controllers/task_controller_test.rb* im Test *test "should get index"* wird erwartet, dass wir der Instanz-Variable *@tasks* einen Wert hinzuweisen (*assigns*) und dieser Wert nicht *nil* ist (```assert_not_nil assigns(:tasks)```):

   ```ruby  
   test "should get index" do
     get :index
     assert_response :success
     assert_not_nil assigns(:tasks)
   end
   ```
   
   Wir haben aber gar keine *@tasks* Variable in der Index-Methode mehr, sondern  *@todo* und *@done* Variablen. Im Test *test "should get index"* ändern wir die Annahmen:
   
   ```ruby  
   test "should get index" do
     get :index
     assert_response :success
     assert_not_nil assigns(:done)
     assert_not_nil assigns(:todo)
   end
   ```
   
   Und wir haben schon wieder einen Failure weniger:
   ```bash
   rake test:functionals

   7 tests, 12 assertions, 1 failures, 1 errors, 0 skips
   ```

   Der nächste Fehler:
 
   ```bash
   1) Error:
   TasksControllerTest#test_should_show_task:
   ActionController::UrlGenerationError: No route matches {:id=>"980190962", :controller=>"tasks", :action=>"show"}
    test/controllers/tasks_controller_test.rb:29:in `block in <class:TasksControllerTest>'
   ```  
   
   Wir haben kein *Show* mehr und können den Test *test "should show task"* löschen.
   
   Nun haben wir einen Error weniger:
   ```bash
   rake test:functionals

   6 tests, 12 assertions, 1 failures, 0 errors, 0 skips
   ```
   
   Der letzte Fehler:
   ```bash   
   1) Failure:
   TasksControllerTest#test_should_update_task [/Users/roland/Documents/sourcecode/rails_projects/todoapp/test/controllers/tasks_controller_test.rb:35]:
   Expected response to be a redirect to <http://test.host/tasks/980190962> but was a redirect to <http://test.host/tasks>.
   Expected "http://test.host/tasks/980190962" to be === "http://test.host/tasks".
   ```
   
   ist der selbe, wie unser erster Fehler: Im Test *test "should update task"* wird erwartet, dass wir auf Show redirecten. Das können wir einfach ändern: 
   Anstatt
   ```ruby  
   assert_redirected_to task_path(assigns(:task))
   ```     
   muss es heißen:
   ```ruby  
   assert_redirected_to tasks_url
   ```      
   
   ```bash
   rake test:functionals

   # Running tests:

   ......
   
   Finished tests in 0.191144s, 31.3899 tests/s, 57.5482 assertions/s.
   
   6 tests, 11 assertions, 0 failures, 0 errors, 0 skips
   ```
   
   Alle Functional-Test laufen. Wenn wir alle Tests durchlaufen lassen wollen (Functional und Unit Tests) geben wir folgendes in der Konsole ein:

   ```bash
   rake test

   # Running tests:

   ........
   
   Finished tests in 0.204614s, 39.0980 tests/s, 63.5343 assertions/s.
   
   8 tests, 13 assertions, 0 failures, 0 errors, 0 skips
   ```
   
   Alles läuft. Zeit für ein Commit.
   
   ```bash
    git add .
    git commit -m "Unit und Functional Tests angepasst"
    ```	
    
4. Im Modell soll es eine Methode geben, die angibt ob die Deadline überschritten ist.

   Wir fügen erst ein paar Tests in *test/models/task_test.rb* hinzu, die die Funktionalität testen, die wir danach entwickeln wollen (sog. Test-Driven Development (TDD)).
   ```ruby
   test "is delayed" do
     task = Task.new
     task.deadline = Date.today - 10.days
     assert task.is_delayed?
   end
   test "is not delayed" do
     task = Task.new
     task.deadline = Date.today + 10.days
     assert !task.is_delayed?
   end
   test "is not delayed if deadline is today" do
     task = Task.new
     task.deadline = Date.today
     assert !task.is_delayed?
   end
   ```
   
   Wenn in Ruby der Name einer Methode mit einem Fragezeichen endet, deutet das darauf hin, dass die Methoden  Wahr oder Falsch zurückliefern soll (boolean).
   
   Wenn man auf der Konsole
   ```bash
   rake test:units
   ```	
   eingibt erhält man 3 Fehler, weil *is_delayed?* noch nicht definiert ist:
   ```bash
   EEE..
   
   5 tests, 2 assertions, 0 failures, 3 errors, 0 skips
   ```
   
   Wenn man in *app/models/task.rb* die Funktion *is_delayed?* einfügt
   ```ruby
   def is_delayed?
     self.deadline < Date.today
   end
   ```
   
   laufen alle Unit-Tests:
   ```bash
   rake test:units
   .....

   5 tests, 5 assertions, 0 failures, 0 errors, 0 skips
   ```   
   
   und natürlich alle Tests zusammen auch:
   ```bash
   rake test
   ...........
   
   Finished tests in 0.157968s, 69.6344 tests/s, 101.2863 assertions/s.
   
   11 tests, 16 assertions, 0 failures, 0 errors, 0 skips
   ```   
   
   Alles läuft. Wir commiten.
   
   ```bash
    git add .
    git commit -m "is_delayed? Methode in Task eingefügt "
    ```
5.  Im Modell soll es eine Methode geben, die die Differenz in Tagen zu Heute zurückgibt.
   Wir fügen ein paar Tests in *test/models/task_test.rb* hinzu:
   	```ruby
	test "destance in days from today" do
	  task = Task.new
	  task.deadline = Date.today
	  assert_equal 0, task.distance_from_now_in_days
	end
	
	test "destance in days from yesterday" do
	  task = Task.new
	  task.deadline = Date.today - 1
	  assert_equal -1, task.distance_from_now_in_days
	end
	
	test "destance in days from tomorrow" do
	  task = Task.new
	  task.deadline = Date.today + 1
	  assert_equal 1, task.distance_from_now_in_days
	end 
   	```
	Wenn man auf der Konsole
	```bash
	rake test:units
	```	
	eingibt erhält man 3 Fehler, weil *distance_from_now_in_day* noch nicht definiert ist:
	```bash
	EEE.....
	
	8 tests, 5 assertions, 0 failures, 3 errors, 0 skips
	```

	In *app/models/task.rb* fügen wir die Funktion *distance_from_now_in_days* hinzu:
	```ruby
	def distance_from_now_in_days
	  (self.deadline - Date.today).to_i		
	end
	```
	*to_i* (to integer) wandelt die Variable um in ein *Integer*.
	
	Alle Unit-Tests laufen:
	```bash
	rake test:units
	.......
	
	8 tests, 8 assertions, 0 failures, 0 errors, 0 skips
	```   
	
	und alle Tests zusammen auch:
	```bash
	rake test
	..............
	
	Finished tests in 0.165166s, 84.7632 tests/s, 115.0358 assertions/s.
	
	14 tests, 19 assertions, 0 failures, 0 errors, 0 skips
	```   
	
	Zeit für ein Commit.
	
	```bash
	git add .
	git commit -m "distance_from_now_in_days Methode in Task eingefügt "
	```   
5.  Deadline soll als umgangssprachliger Text ("1 day ago" bzw. "in 20 days") dargestellt werden. In *app/views/tasks/_table.html.erb* kann folgende Zeile
	```ruby
	<td><%= task.deadline %></td>
	```  
	
	wie folgt geändert werden:
	```ruby
        <td>
          <%= "in " if !task.is_delayed? %> 
          <%= pluralize(task.distance_from_now_in_days.abs, "Day")  %>
          <%= " ago " if task.is_delayed? %> 
        </td>
	```  
	Man kann die if-Abfrage auch nach einem Statement schreiben. *abs* steht für Absolut-Betrag der Zahl. Die *pluralize* Funktion von Rails kennen wir schon von der letzten Aufgabe. 

	![](https://dl.dropboxusercontent.com/u/10978171/index-mit-days.png)

6. Man soll sich als User registrieren und ein und ausloggen können (Authentifizierung).

	Wir nutzen dafür das Gem *devise* (https://github.com/plataformatec/devise). Ein *Gem* ist ein Ruby Paket. Rails ist auch ein Ruby Gem. Wenn man ein Gem zu einem Projekt hinzufügen will muss man als erstes dieses in der Datei *Gemfile* hinzufügen:
	
	```ruby
	gem 'devise'
	```
	
	Anschließend installieren wir dies mit 
	```bash
	bundle install
	```	
	
	Dann können wir den Devise Generator starten:
	```bash
	rails generate devise:install
	```	

	Der Output sagt uns, was wir noch machen müssen:
	
	Als erstes fügen wir in *config/environments/development.rb* folgende Zeile hinzu:
	
	```ruby	
	config.action_mailer.default_url_options = { :host => 'localhost:3000' }
	```	
	
	
	Die zweite Anmerkung "2. Ensure you have defined root_url to *something* in your config/routes.rb." haben wir schon erledigt, da wir schon ein Route zum Root (Home-Page) haben.
	
	Als nächstes ändern wir die Flash-Nachrichten (http://guides.rubyonrails.org/action_controller_overview.html#the-flash), für das erfolgreiche oder nicht erfolgreiche Einloggen. Wir erstellen ein Partial *_messages.html.erb* im Verzeichnis *app/views/layout/*. Folgenden Code in *app/views/tasks/index.html.rb* für die Nachricht (*notice*) schneiden wir aus und fügen ihn in *app/views/layouts/_messages.html.rb* ein: 
	
	```html	
	<% if notice %> 
	  <p id="notice" class="alert alert-success alert-dismissable fade in" data-dismiss="alert" aria-hidden="true">
	    <%= notice %>
	  <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
	  </p>
	<% end %>
	```	
	
	Dahinter fügen wir nicht dasselbe, sondern für eine Warnung ein *alert* ein:
	
	```html	
	<% if alert %> 
	  <p id="notice" class="alert alert-danger alert-dismissable fade in" data-dismiss="alert" aria-hidden="true">
	    <%= alert %>
	  <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
	  </p>
	<% end %>
	```	
	
	Wir binden das Partial in der Datei *app/views/layouts/application.html.rb* nach dem Tag ```<div class="container">``` (vor ```<%= yield %>```) wie folgt ein:

	```html	
	<%= render 'layouts/messages' %>
	```
	
	In diesem Fall müssen wir beim Aufruf zum Partial den Ordner zusätzlich mitteilen, dass für alle verschiedenen Controller der immer selbe Partial geladen werden soll. Ohne die */layout* Angabe würde für den Tasks-Controller im View im Tasks-Ordner gesucht.
	
	Nun brauchen wir noch den Log-in und Registrations-Button. Die komplette Navigation-Bar aus *app/views/layouts/application.html.rb*  kopieren wir in ein neues Partial *_navigation.html.erb* im Verzeichnis *app/views/layout/*. 
	
	Anschließend fügen wir die Login/Registrations-links in die Navigations-Bar. Und zwar nach dem *Todo-App* Logo, also nach
	
	```html
	<div class="navbar-header">
	  <%= link_to "Todo-App", tasks_path, :class => "navbar-brand" %>
	</div>
	```
	fügen folgendes ein (Logout und Edit Account Button wenn eingeloggt, Login und Sign Up Buttom wenn nicht eingeloggt):
	```html
	<ul class="nav navbar-nav navbar-right">
	<% if user_signed_in? %>
	  <li>
	    <%= link_to 'Logout', destroy_user_session_path, :method=>'delete' %>
	  </li>
	  <li>
	    <%= link_to 'Edit account', edit_user_registration_path %>
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
	```
	
	Das Navigations-Parial binden wir wieder in der Datei *app/views/layouts/application.html.rb* vor ```<div class="container">``` wie folgt ein:

	```html	
	<%= render 'layouts/navigation' %>
	```
	Nun müssen wir noch ein Devise-Model für die User generieren. Auf der Konsole:
	```bash
	rails generate devise user
	```
	
	Und die User-Tabelle in der Datenbank erzeugen:
	```bash
	rake db:migrate
	```
	
	Nun muss man den Server noch mal stoppen und starten. Anschließend kann man sich einloggen. Einmal bitte alles manuell ausprobieren (registrieren, login, logout).
	
	![](https://dl.dropboxusercontent.com/u/10978171/login.png)
	
	Als nächstes müssen wir noch zwei Sachen machen, damit auch die Test laufen. In *test/controllers/task_controller.rb* fügen wir nach ```class TasksControllerTest < ActionController::TestCase```folgendes ein:
	
	```ruby
	include Devise::TestHelpers
	```
	
	Dies ist ein Test-Helfer von Devise für die Functional-Tests.
	
	Außerdem müssen wir die Fixtures der User noch ändern. Fixtures sind Test-Daten für die Tests. In der Datei *test/fixtures/users.yaml* ersetzen wir den Teil ```one {} two {}``` mit:
	
	```javascript	
	one:
	  id: 1
	  email: 'some@user.com'
	  encrypted_password: <%= User.new.send(:password_digest, 'password') %>
	
	two:
	  id: 2
	  email: 'test@test.com'
	  encrypted_password: <%= User.new.send(:password_digest, 'password') %>
	```
	
	Alle Tests laufen noch:
	```bash
	rake test
	..............
	
	Finished tests in 0.165166s, 84.7632 tests/s, 115.0358 assertions/s.
	
	14 tests, 19 assertions, 0 failures, 0 errors, 0 skips
	```   
	
	Zeit für ein Commit.
	
	```bash
	git add .
	git commit -m "Authentifizierung mit Devise"
	```

7. Nur wenn man eingeloggt ist, darf man eine Task erstellen (Autorisierung).

	Devise stellt dafür eine Funktion bereit: *authenticate_user!*. Diese wird vor einer Controller-Methode aufgerufen, in dem man ein *before_action* definiert. Wir fügen diese Zeile in *app/controllers/task_controllers.rb* vor die andere *before_action* Anweisung:

	```ruby	
	before_action :authenticate_user!, except: [:index]
	```
	
	Wenn wir dann ausgeloggt sind und eine Aufgabe erstellen, ändern oder löschen wollen, werden wir zum Login umgeleitet:
	
	![](https://dl.dropboxusercontent.com/u/10978171/autorisierung.png)
	
	Wenn wir eingeloggt sind, können wir Aufgaben erstellen, ändern oder löschen.
	
	Nun müssen wir noch unsere Functional-Tests anpassen.
	
	Devise stellt die beiden Methoden ```sign_in``` und ```sign_out``` für die Functioanl-Test bereit.
	
	In *test/controllers/tasks_controller_test.rb* fügen wir in der Methode ```setup do``` folgendes hinzu:
	```ruby	
	@user = users(:one)
	```
	Damit wird der User "one" von den Fixtures (Test-Daten) geladen und in die Variable ```@user```gespeichert.
	
	Anschließend fügen wir in allen Tests außer für den Test der Index-Methode (```test "should get index" do```) folgende Zeile als erstes hinzu: 	
	```ruby	
	sign_in @user
	```
	
	Alle Tests laufen noch:
	```bash
	rake test
	..............
	
	Finished tests in 0.165166s, 84.7632 tests/s, 115.0358 assertions/s.
	
	14 tests, 19 assertions, 0 failures, 0 errors, 0 skips
	```
	
	Wir können ein weiteren Functional-Test hinzufügen, der checkt dass man nicht auf die Edit-Seite kommt (sonden redirected wird), wenn man sich nicht eingeloggt hat:
	
	```ruby	
	test "should not get edit if not logged in" do
	  get :edit, id: @task
	  assert_response :redirect
	end
	```	
	
	Alle Tests laufen noch:
	```bash
	rake test
	...............
	
	15 tests, 20 assertions, 0 failures, 0 errors, 0 skips
	```
	
	Zeit für ein Commit.
	
	```bash
	git add .
	git commit -m "Autorisierung alles außer Index"
	```
8. Ein erstellter Task wird zu dem User zugeordnet, der ihn erstellt. Ein User kann mehrere Tasks haben.

	Dafür müssen wir in der Task-Tabelle in der Datenbank ein Fremdschlüssel *user_id* einfügen. In der Konsole:
	```bash
	rails generate migration AddUserIdToTasks user_id:integer:index
	```	
	
	Mit *:index* wird gleich noch ein Index für den Fremdschlüssel *user_id* erzeugt. Wenn wir uns im *db/migrate/* Ordner die letzte Datei anschauen, sehen wir, dass die Migration-Anweisung gut aussieht, und so bleiben kann:
	```ruby	
	class AddUserIdToTasks < ActiveRecord::Migration
	  def change
	    add_column :tasks, :user_id, :integer
	    add_index :tasks, :user_id
	  end
	end
	```	
	
	und wir eine Migration durchführen können:
	```bash
	rake db:migrate
	```
	
	Anschließend verknüpfen wir beide Modelle:
	
	In *app/models/task.rb* fügen wir hinzu:
	```ruby	
	belongs_to :user
	```	

	Und in *app/models/user.rb* fügen wir hinzu:
	```ruby	
	has_many :tasks
	```	
	
	Nun müssen wir noch für neu erstellte Tasks den Fremdschlüssel auf den grade eingeloggten User setzten:
	
	Devise gibt uns den grade eingeloggten User in der Variable *current_user*. 
	
	Die Zeile in der *create* Methode in *app/controllers/task_controller.rb* 
	```ruby	
	@task = Task.new(task_params)
	```		
	ändern wir in 
	```ruby	
	@task = current_user.tasks.new(task_params)
	```
	
	Der Task wird damit für den *current_user* erstellt und der Fremdschlüssel *user_id* im neuen Task wird automatisch auf die *id* vom *current_user* gesetzt. Alternativ hätten wir auch den Fremdschlüssel *user_id* extra setzen können.
	
	Zeit für ein Commit.
	
	```bash
	git add .
	git commit -m "Task wird dem User zugeordnet, der diesen erstellt"
	```	
	
9. Nur wenn man die Task erstellt hat, darf man die Task ändern oder löschen.

	In der *set_task* Methode in *app/controllers/task_controller.rb* fügen wir nach
	```ruby	
	@task = Task.find(params[:id])
	```		
	folgendes ein  (wenn die Task nicht vom aktuellen User ist, darf der User diese nicht ändern/löschen sondern wir redirected mit einem Alert-Nachricht) 
	```ruby	
	if @task.user_id != current_user.id
	  redirect_to tasks_url, alert: 'You can edit only your own Tasks.'
	end
	```
	Damit die Tests laufen, müssen wir in den Fixtures noch den Fremdschlüssel hinzufügen:
	In der Datei *test/fixtures/tasks.yaml* fügen wir *user_id: 1* hinzu :
	
	```javascript	
	one:
	  name: MyString
	  deadline: 2013-11-28
	  done: false
	  duration: 1.5
	  user_id: 1
	
	two:
	  name: MyString
	  deadline: 2013-11-28
	  done: false
	  duration: 1.5
	  user_id: 1
	```	

	Alle Tests laufen noch:
	```bash
	rake test
	...............
	
	15 tests, 20 assertions, 0 failures, 0 errors, 0 skips
	```
	
	Zeit für ein Commit.
	
	```bash
	git add .
	git commit -m "Task kann nur geändert werden vom Ersteller"
	```	

	Aufgabe: Füge ein Functional-Test hinzu, der checkt, dass der zweite User nicht die Tasks des ersten ändern kann.

10. Ein User soll einen User-Namen haben. Dieser soll nicht doppelt vorkommen und darf nicht leer sein.

	Auf der Konsole:
	```bash
	rails generate migration AddUsernameToUsers username
	```
	
	Datenbank aktualisieren:
	```bash
	rake db:migrate
	```

	Wir müssen nun die Views von Devise ändern, da dort kein *username* vorhanden ist. Dafür generieren wir diese erst:
	```bash
	rails generate devise:views
	```	

	In *app/views/devise/registration/new.html.erb* und *app/views/devise/registration/edit.html.erb* folgenden Code nach ```<%= f.email_field :email, :autofocus => true %></div>```einfügen:	
	```html
	<div><%= f.label :username %><br />
	<%= f.text_field :username %></div>
	```
	
	Rails checkt zur Sicherheit, welche Attribute man einem Model zuweisen kann. Da wir ein weiteres Attribut *username* haben, müssen wir diesen check für Devise erweitern und *username* erlauben. In *app/controllers/application_controller.rb* fügen wir dies hinzu:

	```ruby	
	before_filter :configure_permitted_parameters, if: :devise_controller?
	
	protected
	
	def configure_permitted_parameters
	  devise_parameter_sanitizer.for(:sign_up) << :username
	end
	```
	
	In *app/models/user.rb* fügen wir die Validationsregeln für *username* ein:
	```ruby
	validates :username, presence:  true, uniqueness: true
	```
	
	In *app/views/layouts/_navigation.html.erb* ändern wir die Zeile
	```html
	<%= link_to 'Edit account', edit_user_registration_path %>
	```
	
	mit
	```html
	<%= link_to "Logged in as " + current_user.username, edit_user_registration_path %> 
	```
	damit wir auch wissen, mit welchem User wir eingeloggt sind.
	
	
	Die Fixtures der User ergänzen wir um den Usernamen. In *test/fixtures/users.yaml:
	```javascript	
	one:
	  id: 1
	  email: 'some@user.com'
	  username: 'Alice'
	  encrypted_password: <%= User.new.send(:password_digest, 'password') %>
	
	two:
	  id: 2
	  email: 'test@test.com'
	  username: 'Bob'
	  encrypted_password: <%= User.new.send(:password_digest, 'password') %>
	```
	
	Alle Tests laufen noch:
	```bash
	rake test
	...............
	
	15 tests, 20 assertions, 0 failures, 0 errors, 0 skips
	```
	
	Zeit für ein Commit.
	
	```bash
	git add .
	git commit -m "Username zu User hinzugefügt"
	```		

11. Im Index-Screen soll für jeden Task der User angezeigt werden, der den Task erstellt hat.

	Als erstes können wir die Seed-Daten anpassen(in db/seed.db):

	```ruby
	# ruby encoding: utf-8
	user1 = User.create!(username: "Alice", email: 'alice@alice.com', :password => 'topsecret', :password_confirmation => 'topsecret')
	user2 = User.create!(username: "Bob", email: 'bob@bob.com', :password => 'topsecret', :password_confirmation => 'topsecret')
	user1.tasks.create(name: "Todo-Applikation", deadline: Date.today + 7.days, duration: 2, done: false)
	user2.tasks.create(name: "Idee für eigene Web-Applikation", deadline: Date.today + 10.days, duration: 2, done: false)
	user1.tasks.create(name: "Rails for Zombies", deadline: Date.today - 2.days, duration: 3, done: false)
	user2.tasks.create(name: "Übung 6: Rails Account", deadline: Date.today - 4.days, duration: 3, done: false)
	user1.tasks.create(name: "Übung 1: FizzBuzz", deadline: Date.today - 26.days, duration: 4, done: true)
	user2.tasks.create(name: "Übung 2: Ruby Konto", deadline: Date.today - 20.days, duration: 5, done: true)
	```
	
	und die Datenbank updaten:

	```bash
	rake db:setup
	```
	
	In *app/views/tasks/_table.html.erb* fügen wir nach ```<th>Name</th>```
	
	```html
	<th>User</th>
	```
	ein. Und nach ```<td class="<%= css_class %>"><%= link_to task.name, edit_task_path(task) %></td>```fügen wir 
	```html
	<td> <%= task.user.username %> </td>
	```
	ein.
	
	Sieht gut aus:
	![](https://dl.dropboxusercontent.com/u/10978171/username.png)
	
	Alle Tests laufen noch:
	```bash
	rake test
	...............
	
	15 tests, 20 assertions, 0 failures, 0 errors, 0 skips
	```
	
	Zeit für ein Commit.
	
	```bash
	git add .
	git commit -m "User der den Task erstellt hat wird in Index-Tabelle angezeigt"
	```

12. Man kann eine Aufgabe einem anderen User delegieren.

	Wir brauchen in der Task-Tabelle in der Datenbank einen weiteren Fremdschlüssel *delegated_id* . In der Konsole:
	```bash
	rails generate migration AddDelegatedToTasks delegated_id:integer:index
	```
	
	```bash
	rake db:migrate
	```
	
	In *app/models/user.rb* fügen wir hinzu:
	
	```ruby
	has_many :delegated_tasks, class_name: "Task", foreign_key: "delegated_id"
	```
	Hier müssen wir ausnahmsweise den Namen des Fremdschlüssels und den Namen der anderen Tabelle angeben, da dieser anhand des Namens der Verbindung nicht automatisch abgeleitet werden kann. User und Task sind ja durch zwei Fremdschlüssel verbunden (wer hat die Aufgabe erstellt und an wen wurde es delegiert).
	
	
	In *app/models/task.rb* fügen wir hinzu:
	```ruby
	belongs_to :delegated, class_name: "User", foreign_key: "delegated_id"
	```	
	Wir verändern die *db/seed.rb* Datei:
	```ruby
	# ruby encoding: utf-8
	user1 = User.create!(username: "Alice", email: 'alice@alice.com', :password => 'topsecret', :password_confirmation => 'topsecret')
	 user2 = User.create!(username: "Bob", email: 'bob@bob.com', :password => 'topsecret', :password_confirmation => 'topsecret')
	user1.tasks.create(name: "Todo-Applikation", deadline: Date.today + 7.days, duration: 2, done: false, delegated_id: user2.id)
	user2.tasks.create(name: "Idee für eigene Web-Applikation", deadline: Date.today + 10.days, duration: 2, done: false)
	user1.tasks.create(name: "Rails for Zombies", deadline: Date.today - 2.days, duration: 3, done: false, delegated_id: user2.id)
	user2.tasks.create(name: "Übung 6: Rails Account", deadline: Date.today - 4.days, duration: 3, done: false)
	user1.tasks.create(name: "Übung 1: FizzBuzz", deadline: Date.today - 26.days, duration: 4, done: true)
	user2.tasks.create(name: "Übung 2: Ruby Konto", deadline: Date.today - 20.days, duration: 5, done: true, delegated_id: user1.id)
	```
	In *app/views/tasks/_form.html.erb* fügen wir in dem Formular ein Dropdown Menü der User hinzu, sodass wir auswählen können, an wen wir die Task delegieren:
	```ruby	
	<div class="form-group">
	  <%= f.label :delegated_id %><br>
	  <%= f.select :delegated_id, User.all.collect {|u| [ u.username, u.id ] }, { :include_blank => true, :selected => @task.delegated_id}, class: "form-control" %>
	</div>	
	```
	
	```f.select``` erzeugt ein Drop-Down Menü im Formular für das Feld *delegated_id* (http://guides.rubyonrails.org/form_helpers.html#the-select-and-option-tags). ```f.select``` erwartet als zweiten Parameter ein Array für die Menü-Punkte. Es soll der *username* angezeigt werden aber die *id* in *delegated_id* gespeichert werden. Rails erlaubt das mit einem Array von Paaren, etwa so ```[['Alice', 1], ['Bob', 2], ...]``` . Da wir aber diese Array dynamisch aus der Tabelle generieren wollen, nutzen wir die Array-Methode *collect* (http://www.ruby-doc.org/core-2.0.0/Array.html#method-i-collect) um aus der User-Tabelle so ein Array von username, id Paaren zu generieren  (```User.all.collect {|u| [ u.username, u.id ] }```). Der dritte Parameter gibt an, dass es eine leere Auswahl gibt  (```:include_blank => true```)  und dass der aktuelle Wert von *@task.delegated_id* im Drop-Down selektiert ist (```:selected => @task.delegated_id```).
	
	Wir haben ein weiteres Attribut und müssen die Zuweisung dieses Attributes explizit erlauben. Warum? Die Massenzuweisung ist zwar bequem, aber kann, wenn man nicht aufpasst zu Sicherheitslöchern führen, sog. Mass assignment vulnerability http://en.wikipedia.org/wiki/Mass_assignment_vulnerability. Darum gibt es in Rails 4 die Strategie, alle möglichen (```permit```) bzw. erforderlichen (```permit```) Attribute in einer "White List"  explizit anzugeben. Das Konzept heißt *Strong Parameter*  (http://guides.rubyonrails.org/action_controller_overview.html#strong-parameters)  In *app/controllers/task_controller.rb* die Zeile in der *task_params* Methode wie folgt öndern:
	```ruby
	params.require(:task).permit(:name, :deadline, :done, :duration, :delegated_id)
	```

13. Im Index-Screen soll für jede Task der User angezeigt werden, an den die Task delegiert wurde.
	
	In *app/views/tasks/_table.html.erb* statt ```<th>User</th>``` schreiben wir:
	```html
	<th>Created</th>
	<th>Delegated</th>
	```
	
	Nach ```<td> <%= task.user.username %> </td>``` fügen wir folgendes ein:
	```html
	<td> <%= task.delegated.username if task.delegated %> </td>
	```	
	
14. Eine Aufgabe kann auch geändert werden, wenn man die Aufgabe delegiert bekommen hat.

	In *app/controllers/task_controller.rb* ändern wir diese Zeile
	```ruby
	if @task.user_id != current_user.id 
	```
	wie folgt:
	```ruby
	if @task.user_id != current_user.id && @task.delegated_id != current_user.id
	```
	
	Alle Tests laufen noch:
	```bash
	rake test
	...............
	
	15 tests, 20 assertions, 0 failures, 0 errors, 0 skips
	```
	
	Zeit für ein Commit.
	
	```bash
	git add .
	git commit -m "Tasks können geändert vom delegierten User geändert werden"
	```
	
	Und auf Github sichern:
	```bash
	git push origin master
	```
	
15. Deployment

	Alles fertig. Zeit für ein Deployment. (Wenn Sie Heroku noch nie für dieses Projekt eingerichtet haben, dann zu https://github.com/rolandmueller/railskurs/blob/master/deployment.md). Da wir schon alles grade committed haben, können wir mit Git den Source-Code zu Heroku pushen.

	```bash
	git push heroku master
	```
	Genauso wie auf den lokalem PC müssen wir auf Heroku ein rake db:migrate durchführen, da wir das User-Model erstellt haben.
	```bash
	heroku run rake db:migrate
	```
	
	Wenn man will, kann man auch die Datenbank mit den seed.rb Daten füllen, durch rake db:setup 
	```bash
	heroku run rake db:setup
	```
	
	Anschließend kann man die eigene Anwendung im Browser öffnen:
	```bash
	heroku open
	```
	
	Man kann sich sogar remote auf Heroku auf die Rails Konsole einloggen und sich die Daten auf diese Weise anschauen und ändern:
	```bash
	heroku run rails console
	```	
	
