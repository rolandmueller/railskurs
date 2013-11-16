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
	
	Customer:
	
	* first_name
	* last_name
	* address
	
	Account:
	* number
	* balance (default Wert 0)
	
	Transaction:
	* amount
	* description
	* balance_after_transaction

	Generieren Sie die Modelle mit
````bash
rails generate model ...
```	
6. Erzeugen Sie die 1-n Relationen in den drei Modellen	(has_many bzw. belong_to)

7. Erzeugen Sie eine 1-n Relation von Customer zu Transaction über Account (has_many through) 

8.  Erzeugen Sie Validatoren, damit
	* first_name, last_name, number, balance, amount, description und balance_after_transaction nicht leer seien könne 
	* balance numerisch seien muss und nicht negative seien kann
	* number nicht doppelt vorkommen darf
	sieh Slides oder http://guides.rubyonrails.org/active_record_validations.html für Validatoren
  
9. Öffnen Sie die Rails consonel
````bash
rails console
```
	* Kreieren Sie mehrere Customer die ein oder mehrere Konten haben. Füge für zwei Konten mehrere Transactionen durch
	* Suchen Sie einen Kunden. Wieviele Konten hat dieser Kunde? Wieviel Geld ist auf meine Bank deponiert (Summe alle Konten)? Wie ist die Summe alle Konten-Balance eines Kunden?   	
10. Erzeugen Sie eine Methode '''withdraw'' und '''deposit'' in der Klasse Account, die Geld abhebt bzw. einzaheln. Sie soll die balance anpassen und eine 
    Transaction für dieses Konto hinzufügen mit abgehoben bzw. eingezahlten Betrag (Amount), Beschreibung ("Withdrawal" bzw. "Deposit"), und balance_after_transaction	

