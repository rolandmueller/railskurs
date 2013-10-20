# Git und Github

Wichtige Befehle

### 1. Git am Anfang einrichten (nur einmal notwendig, gilt für alle Projekte)

Email und Name festelegen. Sollte gleiche email wie bei Github und Herouku sein. Wird auch bei Railsinstaller am Anfang abgefragt, aber kann man so ändern-

    git config --global user.name "Your Name"
    git config --global user.email your.email@example.com

Bei Mac:

    git config --global core.editor "subl -w"

Bei Windows

    git config --global core.editor "sublime_text -w"
    
### 2. Git Repositorium anlegen

Zwei Möglichkeiten (nur einmal am Anfang eines Projektes notwendig). Nur eins von beiden anwenden. Entweder

#### Lokal Verzeichnis als Git Repositorium initialisieren

    git init
   
oder
    
#### Existierendes Repository klonen (aus Remote Repositorium)

    git clone git@github.com:rolandmueller/railskurs.git
    
Im bestehenden Verzeichnis wird ein Verzeichnis railskurs mit den Dateien des Repositorium geklont.

### 3. Änderungen zur Versionskontrolle hinzufügen

Änderungen werden überwacht (Datei ist in der Staging Area)

Eine Datei hinzufügen

    git add dateiname.txt
    
Alle Dateien mit bestimmter Endung hinzufügen
        
    git add *.txt
    
Alle Dateien hinzufügen

    git add .
    
### 4. Commit 

Alle Dateiänderungen, die mit git add vorher hinzugefügt wurden commiten 

    git commit -m "Eine Beschreibung des Commits"

Änderungen hinzufügen und Commit erzeugen 

    git commit -a -m "Eine Beschreibung des Commits"
    
-a Parameter (Add) fügt Änderungen gleich hinzu und danach werden diese sofort commited

### 5. Branching (Versionierung)

Der Branchname *master* ist der Hauptentwicklungszeig.

#### Branch erstellen

    git branch branch-name

#### Branch löschen (-d Delete)

    git branch -d branch-name
    
#### Zu einem Branch wechseln

    git checkout branch-name 
    
Kurzform für Branch erstellen und dann zu diesem wechseln:

    git checkout -b branch-name
    
#### Merge: Änderungen aus dem Branch "branch-name" in den aktuellen Branch verschmelzen

    git merge branch-name
    
### 6. Änderungen mit dem Remote Repository synchronisieren

#### Pull: Lokale  Dateien Updaten 

    git pull

#### Push: Remote Repository Update

Pushe den Master-Branch zum Remote Repositorium mit dem Namen "origin" 

    git push origin master

### 7. Remote Repositorys
  
1.Anzeigen

    git remote -v
    
2.Hinzufügen

    git remote add einname git://github.com/paulboone/ticgit.git

