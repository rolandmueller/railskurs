# 7. Übung: Todo-App

0.	Entwurf

	Wir wollen eine einfache Todo-Applikation programmieren. In der ersten Version soll diese nur Aufgaben 
	verwalten. Eine Aufgabe (```Task```) hat einen Titel (```name```) und ein
	Fälligkeitsdatum (```deadline```), kann entweder feritg sein (```done```)
	oder nicht und dauert eine Anzahl von Stunden (```duration```). Die Datenbank besteht damit nur aus einer
	Tabelle:
	
	![](https://dl.dropboxusercontent.com/u/10978171/database.png)
	
	Die Attrbute ```id```, ```created_at``` und ```updated_at``` werden von Rails standardmäß hinzugefügt, d.h. wir müssen die nicht explizit beim Generieren des Modells angeben.
	
	Für eine erste Gestaltung benutzen wir myBalsamique für den Mockup. Wir haben eigenlich nur zwei wesentliche Screens.  Einerseits die Liste alle Aufgaben (Das wäre die Index-Methode im Controller):
	
	![](https://dl.dropboxusercontent.com/u/10978171/index.png)
	
	und andererseits ein Formular zum Einfügen (New-Methode im Controller) und Ändern (Edit-Methode im Controller) einer Aufgabe:

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

    ````bash
    git push origin master
    ```
    Falls nach dem User und dem Passwort gefragt wurde, hier wird beschriben wie man das automatisieren kann: https://help.github.com/articles/generating-ssh-keys
