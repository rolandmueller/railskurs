# Git und Github

Wichtige Befehle

## Git Repositorium anlegen

Zwei Möglichkeiten (nur einmal am Anfang notwendig). Nur eins von beiden anwenden. Entweder

### Lokal Verzeichnis als Git Repositorium initialisieren

    git init
   
oder
    
### Existierendes Repository klonen 

    git clone git@github.com:rolandmueller/railskurs.git
    
Im bestehenden Verzeichnis wird ein Verzeichnis railskurs mit den Dateien des Repositorium geklont.

## Neue Dateien zur Versionskontrolle hinzufügen

Eine Datei hinzufügen

    git add dateiname.txt
    
Alle Dateien mit bestimmter Endung hinzufügen

        
    git add *.txt
    
Alle Dateien hinzufügen

    git add .
    
