# 6. Übung: ActiveRecord

1.	Generieren Sie ein neues Rails Projekt uebung6
	
    ````bash
    rails new uebung5
    cd uebung5
    ```
2.	Initialisieren Sie ein Git-Repositorium, fügen Sie alles hinzu und commiten Sie

    ````bash
    git init
    git add .
    git commit -m "Erstes Commit"
    ```
3.	Erzeugen Sie bei Github ein leeres Repositorium (ohne Readme und .gitignore file) mit dem Namen uebung6
4.	Fügen Sie das Github als Remote-Repositorium hinzu 

    ````bash
    git remote add origin ...
    ```
5.  Pushen Sie das Projekt zu Github. Kontrollieren Sie bei Github ob es da ist.

    ````bash
    git push origin master
    ```
    Falls nach dem User und dem Passwort gefragt wurde, hier wird beschriben wie man das automatisieren kann: https://help.github.com/articles/generating-ssh-keys
6.  Generieren Sie drei Modelle '''account''', '''customer''' und '''transaction'''. In der Datenbank soll das so aussehen:

	![](https://dl.dropboxusercontent.com/u/10978171/er-diagramm.jpg)

	Überlegen Sie in welchen Tabellen die Fremdschlüssel seien müssen.
	
	Folgende Attribute sollen die Modelle zusätzlich zu den Fremdschlüsseln haben:
	
	User:
	
	* first_name
	* last_name
	* address
	
	Account:
	* number
	* balance
	
	Transaction:
	* amount
	* description
	* balance_after_transaction

	Generieren Sie die Modelle mit
	
	````bash
	rails generate model ...
	```	
7. Erzeugen Sie 
