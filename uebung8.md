# Übung 8: Fortsetzung der Todo-App

1. Zusätzliche Anforderungen
    * Hinzufügen von Unit-Tests, die die Geschäfstlogik des Modells testen
    * Hinzufügen von Functional-Tests, die den Controller testen
    * Deadline soll als umgangssprachliger Text ("2 day ago" bzw. "in 1 month") dargestellt werden
    * Man soll sich als User registrieren und  ein und ausloggen können (Authentifizierung).
    * Nur wenn man eingeloggt ist, darf man ein Task erstellen (Autorisierung).
    * Ein erstellter Task wird zu dem User, der ihn erstellt zugeordnet. Ein User kann mehrere Tasks haben.
    * Nur wenn man eingeloggt ist und den Task erstellt hat, darf man den Task ändern oder löschen.
    * Es soll eine Projekt-Seite geben, wo man Projekte anlegen, umbennen und löschen kann. Projekte kann man nur erstellen, wenn man eingeloggt ist.
    * Ein Task kann man einem Projekt zuordnen. Ein Projekt kann mehrere Tasks haben.

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
   test "Task kann nicht ohne Name gespeichert werden" do
     task = Task.new
     assert !task.save
   end
   ```  
   
   Das Ausrufezeichen (!) steht für nicht. Also gibt task.save hier falsch zurück und kann die Aufgabe wegen der Validations-Regel nicht speichern. Das was wir erwartet (assert) haben.
   
   ```bash
   rake test:units
   
   # Running tests:
   .

   1 tests, 1 assertions, 0 failures, 0 errors, 0 skips
   ```	
   
   Wir fügen ein zweiten Test in *app/tests/models/task_test.rb* ein
   ```ruby
   test "Task kann mit Name, Deadline und Duraton gespeichert werden" do
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

   Failure ist wenn ein Assert (Annahme) nicht erfüllt wird. Error ist, wenn das Programm ein Syntax-Fehler hat.  Warum? In der letzten Aufgabe haben wir einiges geändert. Insbesondere haben wir die Show-Methode gelöscht und die Redirects geändert. Schauen wir uns den ersten Failure an:

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
   
   Alle Functional-Test laufen. Wenn wir alle Test durchlaufen lass wolle (Functional und Unit) geben wir folgendes in der Konsole ein:

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
    git commit -m "Unit und Functional Test angepasst"
    ```	
    
    
   


