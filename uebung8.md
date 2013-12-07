# Übung 8: Fortsetzung der Todo-App

1. Zusätzliche Anforderungen
    * Hinzufügen von Unit-Tests, die die Geschäfstlogik des Modells testen
    * Hinzufügen von Unit-Tests, die den Controller testen
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
   erhält man:
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
   


