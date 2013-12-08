# Übung 8: Fortsetzung der Todo-App

1. Zusätzliche Anforderungen
    * Hinzufügen von Unit-Tests, die die Geschäfstlogik des Modells testen
    * Hinzufügen von Functional-Tests, die den Controller testen
    * Im Modell soll es eine Methode geben, die angibt ob Deadline überschritten ist.
    * Im Modell soll es eine Methode geben, die die Differenz zu Heute anzeigt in Tagen.
    * Deadline soll als umgangssprachliger Text ("2 day ago" bzw. "in 1 month") dargestellt werden
    * Man soll sich als User registrieren und ein und ausloggen können (Authentifizierung).
    * Nur wenn man eingeloggt ist, darf man ein Task erstellen (Autorisierung).
    * Ein erstellter Task wird zu dem User zugeordnet, der ihn erstellt. Ein User kann mehrere Tasks haben.
    * Nur wenn man eingeloggt ist und den Task erstellt hat, darf man den Task ändern oder löschen.
    * Ein User soll ein User-Namen haben. Dieser soll nicht doppelt vorkommen und darf nicht leer sein.
    * Im Index-Screen soll für jeden Task der User angezeigt werden, der den Task erstellt hat.
    * Man kann eine Aufgabe einem anderen User delegieren.
    * Im Index-Screen soll für jeden Task der User angezeigt werden, an den der Task delegiert wurde.
    * Eine Aufgabe kann auch geändert werden, wenn man die Aufgabe delegiert bekommen hat.
    * Es soll eine Filterung der Aufgaben geben, so dass nur Aufgaben angezeigt werden, die man selber erstellt hat oder die an einem delegiert worden sind.


2. Hinzufügen von Unit-Tests, die die Geschäfstlogik des Modells testen

   Momentan ist der Unit-Test in *app/tests/models/task_test.rb* auskommentiert und wenn man auf der Konsole
   
   ```bash
   rake test:units
   ```	
   eingibt erhält man:
   ```bash
   0 tests, 0 assertions, 0 failures, 0 errors, 0 skips
   ```
   Unser erster Test in *app/tests/models/task_test.rb*
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
   
   Wir fügen ein zweiten Test in *app/tests/models/task_test.rb* ein
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

   Failure ist wenn ein Assert (Annahme) nicht erfüllt wird. Error ist, wenn das Programm ein Syntax-Fehler hat.  Warum? In der letzten Übung 7 haben wir einiges nach dem Scaffolding geändert. Insbesondere haben wir die Show-Methode gelöscht und die Redirects geändert. Schauen wir uns den ersten Failure an:

   ```bash
   1) Failure:
   TasksControllerTest#test_should_create_task [/Users/roland/Documents/sourcecode/rails_projects/todoapp/test/controllers/tasks_controller_test.rb:24]:
   Expected response to be a redirect to <http://test.host/tasks/980190963> but was a redirect to <http://test.host/tasks>.
   Expected "http://test.host/tasks/980190963" to be === "http://test.host/tasks".
   ```
   
   In *app/tests/controllers/task_controller_test.rb* im Test *test "should create task"* wird erwartet, dass wir auf  Show redirecten:

   ```ruby  
   assert_redirected_to task_path(assigns(:task))
   ```
   
   Wir redirecten aber auf Index. Sofern müssen wir den Test ändern (tasks_url ist die Index-Url):
   
   ```ruby  
   assert_redirected_to tasks_url
   ```   
   
   Und wir haben schon mal ein Failure weniger:
   ```bash
   rake test:functionals

   7 tests, 11 assertions, 2 failures, 1 errors, 0 skips
   ```
   
   Der nächste Failure sieht so aus:
   
   ```bash
   1) Failure:
   TasksControllerTest#test_should_get_index [/Users/roland/Documents/sourcecode/rails_projects/todoapp/test/controllers/tasks_controller_test.rb:11]:
   Expected nil to not be nil.
   ```
   
   In *app/tests/controllers/task_controller_test.rb* im Test *test "should get index"* wird erwartet, dass wir der Instanz-Variable *@tasks* einen Wert hinzuweisen (*assigns*) und diese Wert nicht *nil* ist (```assert_not_nil assigns(:tasks)```):

   ```ruby  
   test "should get index" do
     get :index
     assert_response :success
     assert_not_nil assigns(:tasks)
   end
   ```
   
   Wir haben aber garkeine *@tasks* Variable in der Index-Methode mehr, sondern  *@todo* und *@done* Variablen. Im Test *test "should get index"* ändern wir die Annahmen:
   
   ```ruby  
   test "should get index" do
     get :index
     assert_response :success
     assert_not_nil assigns(:done)
     assert_not_nil assigns(:todo)
   end
   ```
   
   Und wir haben schon wieder ein Failure weniger:
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
   
   Wir haben ein Error weniger:
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
   ist der selbe wie unser erster Fehler: Im Test *test "should update task"* wird erwartet, dass wir auf Show redirecten. Das können wir einfach ändern: 
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
   
   Alle Functional-Test laufen. Wenn wir alle Tests durchlaufen lassen wollen (Functional und Unit) geben wir folgendes in der Konsole ein:

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
    
4. Im Modell soll es eine Methode geben, die angibt ob Deadline überschritten ist.

   Wir fÜgen als ein paar Tests in *app/tests/models/task_test.rb* hinzu
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
   
   Ein Methode, die mit einem Fragezeichen endet, nimmt man in Ruby gerne als Name für Methoden die Wahr oder Falsch zurückliern (boolean).
   
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
   
   Alles läuft. Zeit für ein Commit.
   
   ```bash
    git add .
    git commit -m "is_delayed? Methode in Task eingefügt "
    ```
5.  Im Modell soll es eine Methode geben, die die Differenz zu Heute anzeigt in Tagen.
   Wir fÜgen als ein paar Tests in *app/tests/models/task_test.rb* hinzu
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

	Wenn man in *app/models/task.rb* die Funktion *distance_from_now_in_days* einfügt
	```ruby
	def distance_from_now_in_days
	(self.deadline - Date.today).to_i		
	end
	```
	
	laufen alle Unit-Tests:
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
5.  Deadline soll als umgangssprachliger Text ("2 day ago" bzw. "in 1 month") dargestellt werden. In *app/views/tasks/_table.html.erb* kann folgende Zeile
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
	
	Als nächstes ändern wir die Flash-Nachrichten, für das erfolgreiche oder nicht erfolgreiche Einloggen. Wir erstellen ein Partial *_messages.html.erb* im Verzeichnis *app/views/layout/*. Folgenden Code in *app/views/tasks/index.html.rb* schneiden wir aus und fügen ihn in *app/views/layouts/_messages.html.rb* ein: 
	
	```html	
	<% if notice %> 
	  <p id="notice" class="alert alert-success alert-dismissable fade in" data-dismiss="alert" aria-hidden="true">
	    <%= notice %>
	  <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
	  </p>
	<% end %>
	```	
	
	Dahinter fügen wir noch dasselbe nicht für eine Nachricht (notice) sondern für eine Warnung (alert) ein:
	
	```html	
	<% if alert %> 
	  <p id="notice" class="alert alert-danger alert-dismissable fade in" data-dismiss="alert" aria-hidden="true">
	    <%= alert %>
	  <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
	  </p>
	<% end %>
	```	
	
	Wir binden das Partial in der Datei *app/views/layouts/application.html.rb* nach dem tag ```<div class="container">``` (vor ```<%= yield %>```) wie folgt ein:

	```html	
	<%= render 'layouts/messages' %>
	```
	
	
	Wir brauchen wir noch Log-in und Registrations-Button. Die komplette Navigation-Bar aus *app/views/layouts/application.html.rb*  kopieren wir in ein neues Partial *_navigation.html.erb* im Verzeichnis *app/views/layout/*. 
	
	Anschließend fügen wir die Login/Registrations-links in die Navigations-Bar. Und zwar nach dem *Todo-App* Logo, also nach
	
	```html
	<div class="navbar-header">
	  <%= link_to "Todo-App", tasks_path, :class => "navbar-brand" %>
	</div>
	```
	fügen folgendes ein:
	```htm
	<ul class="nav navbar-nav navbar-right">
	<% if user_signed_in? %>
	  <li>
	    <%= link_to 'Logout', destroy_user_session_path, :method=>'delete' %>
	  </li>
	<% else %>
	  <li>
	    <%= link_to 'Login', new_user_session_path %>
	  </li>
	<% end %>
	<% if user_signed_in? %>
	  <li>
	    <%= link_to 'Edit account', edit_user_registration_path %>
	  </li>
	<% else %>
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
	
	In der Datei *test/fixtures/users.yaml* ersetzen wir den Teil ```one {} two {}``` mit:
	
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

7. Nur wenn man eingeloggt ist, darf man ein Task erstellen (Autorisierung).

	Devise stellt dafür eine Funktion bereit: *authenticate_user!* . Diese wird vor einer Methode aufgerufen, in dem man ein *before_action* definiert. Wir fügen diese Zeile in *app/controllers/task_controllers.rb* vor die andere *before_action* Anweisung:

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
	Damit wird der User "one" von den Fixtures geladen und in die Variable ```@user```gespeichert.
	
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
	
	Wir können ein weiteren Functional-Test hinzufügen, der checkt das man nicht auf die Edit-Seite kommt (sonden redirected wird), wenn man sich nicht eingeloggt hat:
	
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
	
	Wenn wir uns im *db/migrate/* Ordner die letzte Datei anschauen, dann sehen wir das die Migration-Anweisung gut aussieht, und so bleiben kann
	```ruby	
	class AddUserIdToTasks < ActiveRecord::Migration
	  def change
	    add_column :tasks, :user_id, :integer
	    add_index :tasks, :user_id
	  end
	end
	```	
	
	und wir ein Migration durchführen können:
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
	
	Devise gibt den grade eingeloggten User in der Variable *current_user*. 
	
	Die Zeile in der *create* Methode in *app/controllers/task_controller.rb* 
	```ruby	
	@task = Task.new(task_params)
	```		
	ändern wir in 
	```ruby	
	@task = current_user.tasks.new(task_params)
	```
	
	Zeit für ein Commit.
	
	```bash
	git add .
	git commit -m "Task wird dem User zugeordnet, der diesen erstellt"
	```	
	
9. Nur wenn man eingeloggt ist und den Task erstellt hat, darf man den Task ändern oder löschen.

	In der *set_task* Methode in *app/controllers/task_controller.rb* fügen wir nach
	```ruby	
	@task = Task.find(params[:id])
	```		
	ändern wir in 
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

10. Ein User soll ein User-Namen haben. Dieser soll nicht doppelt vorkommen und darf nicht leer sein.

	```bash
	rails generate migration AddUsernameToUsers username
	```
	
	```bash
	rake db:migrate
	```

	```bash
	rails generate devise:views
	```	

	In *app/views/devise/registration/new.html.erb* und *app/views/devise/registration/edit.html.erb* folgenden Code nach ```<%= f.email_field :email, :autofocus => true %></div>```einfügen:	
	```html
	<div><%= f.label :username %><br />
	<%= f.text_field :username %></div>
	```
	
	In *app/controllers/application_controller.rb* fügen wir dies hinzu:

	```ruby	
	before_filter :configure_permitted_parameters, if: :devise_controller?
	
	protected
	
	def configure_permitted_parameters
	  devise_parameter_sanitizer.for(:sign_up) << :username
	end
	```
	
	In *app/models/user.rb* fügen wir folgendes ein:
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
	user1 = User.create!(username: "Alice", email: 'some@user.com', :password => 'topsecret', :password_confirmation => 'topsecret')
	user2 = User.create!(username: "Bob", email: 'test@test.com', :password => 'topsecret', :password_confirmation => 'topsecret')
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

	Wir brauchen in der Task-Tabelle in der Datenbank ein weiteren Fremdschlüssel *delegated_to* . In der Konsole:
	```bash
	rails generate migration AddDelegatedToTasks delegated_id:integer:index
	```
	
	```bash
	rake db:migrate
	```

	In *app/models/user.rb* fügen wir hinzu:
	
	```ruby
	has_many :delegated_tasks, class_name: "Task", foreign_key: "delegated_id"
	``
	
	In *app/models/task.rb* fügen wir hinzu:
	```ruby
	belongs_to :delegated, class_name: "User", foreign_key: "delegated_id"
	```	
	Wir verändern die *db/seed.rb* Datei:
	```ruby
	 User.create!(username: "Bob", email: 'test@test.com', :password => 'topsecret', :password_confirmation => 'topsecret')
	user1.tasks.create(name: "Todo-Applikation", deadline: Date.today + 7.days, duration: 2, done: false, delegated_id: user2.id)
	user2.tasks.create(name: "Idee für eigene Web-Applikation", deadline: Date.today + 10.days, duration: 2, done: false)
	user1.tasks.create(name: "Rails for Zombies", deadline: Date.today - 2.days, duration: 3, done: false, delegated_id: user2.id)
	user2.tasks.create(name: "Übung 6: Rails Account", deadline: Date.today - 4.days, duration: 3, done: false)
	user1.tasks.create(name: "Übung 1: FizzBuzz", deadline: Date.today - 26.days, duration: 4, done: true)
	user2.tasks.create(name: "Übung 2: Ruby Konto", deadline: Date.today - 20.days, duration: 5, done: true, delegated_id: user1.id)
	```
	In *app/views/tasks/_form.html.erb* folgendes hinzufügen:
	```ruby	
	<div class="form-group">
	  <%= f.label :delegated_id %><br>
	  <%= f.select :delegated_id, User.all.collect {|u| [ u.username, u.id ] }, { :include_blank => true, :selected => params[:delegated_id] }, class: "form-control" %>
	</div>	
	```
	In *app/controllers/task_controller.rb* die Zeile in der *task_params* Methode wie folgt öndern:
	```ruby
	params.require(:task).permit(:name, :deadline, :done, :duration, :delegated_id)
	```
13. Im Index-Screen soll für jeden Task der User angezeigt werden, an den der Task delegiert wurde.

	In *app/views/tasks/_form.html.erb* statt ```<th>User</th>``` schreiben wir:
	```html
	<th>Created</th>
	<th>Delegated</th>
	```
	
	Nach ```<td> <%= task.user.username %> </td>``` fügen wir folgendes ein:
	```html
	<td> <%= task.delegated.username if task.delegated %> </td>
	```	
	
14. Eine Aufgabe kann auch geändert werden, wenn man die Aufgabe delegiert bekommen hat.

