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
	3. Die Seite sollte mit Bootstrap ein nettes Design bekommen.
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
	
