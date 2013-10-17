# Git und Github

Wichtige Befehle

## Git Repositorium anlegen

Zwei Möglichkeiten (nur einmal am Anfang notwendig). Nur eins von beiden anwenden. Entweder

### Lokal Verzeichnis als Git Repositorium initialisieren

    git init
   
oder
    
### Existierendes Repository klonen (aus Remote Repositorium)

    git clone git@github.com:rolandmueller/railskurs.git
    
Im bestehenden Verzeichnis wird ein Verzeichnis railskurs mit den Dateien des Repositorium geklont.

## Änderungen zur Versionskontrolle hinzufügen

Änderungen werden überwacht (Datei ist in der Staging Area)

Eine Datei hinzufügen

    git add dateiname.txt
    
Alle Dateien mit bestimmter Endung hinzufügen
        
    git add *.txt
    
Alle Dateien hinzufügen

    git add .
    
## Ein Commit erzeugen (Änderungen in das Repositorium einchecken)

    git commit -a -m "Eine Beschreibung des Commits"
    
-a Parameter (Add) fügt Änderungen gleich hinzu und danach werden diese sofort commited

## Remote Repositorys
  
1. Anzeigen

    git remote -v
    
2. Hinzufügen

    git remote add einname git://github.com/paulboone/ticgit.git

