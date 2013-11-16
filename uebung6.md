# 6. Übung: ActiveRecord

1.	Generieren Sie ein neues Rails Projekt uebung6
	
    ```bash
    rails new uebung6
    cd uebung6
    ```
2.	Initialisieren Sie ein Git-Repositorium, fügen Sie alles hinzu und commiten Sie

    ```bash
    git init
    git add .
    git commit -m "Erstes Commit"
    ```
3.	Erzeugen Sie bei Github ein leeres Repositorium (ohne Readme und .gitignore file) mit dem Namen uebung6
4.	Fügen Sie das Github als Remote-Repositorium hinzu 

	```bash
	git remote add origin ...
	```
5.  Pushen Sie das Projekt zu Github. Kontrollieren Sie bei Github ob es da ist.

    ````bash
    git push origin master
    ```
    Falls nach dem User und dem Passwort gefragt wurde, hier wird beschriben wie man das automatisieren kann: https://help.github.com/articles/generating-ssh-keys
6.  Generieren Sie drei Modelle ````Account````, ````Customer```` und ````Transaction````. In der Datenbank soll das so aussehen:
	
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
Generieren Sie die Modelle mit ````rails generate model ...````  (siehe Slides bzw http://guides.rubyonrails.org/command_line.html#rails-generate ) und erzeugen die Tabellen in der Datenbank mit ````rake db:migrate````
6. Erzeugen Sie die 1-n Relationen in den drei Modellen	(has_many bzw. belong_to) (siehe Slides oder http://guides.rubyonrails.org/association_basics.html)

7. Erzeugen Sie eine 1-n Relation von Customer zu Transaction über Account (has_many through) (siehe Slides oder http://guides.rubyonrails.org/association_basics.html)

8.  Erzeugen Sie Validatoren (siehe Slides bzw. http://guides.rubyonrails.org/active_record_validations.html), damit
	* first_name, last_name, number, balance, amount, description und balance_after_transaction nicht leer seien könne 
	* balance numerisch seien muss und nicht negative seien kann
	* number nicht doppelt vorkommen darf
  
9. Öffnen Sie die Rails consonel
```bash
rails console
```
	* Kreieren Sie mehrere Customer die ein oder mehrere Konten haben. Füge für zwei Konten mehrere Transactionen durch
	* Suchen Sie einen Kunden. Wieviele Konten hat dieser Kunde? Wieviel Geld ist auf meine Bank deponiert (Summe alle Konten)? Wie ist die Summe alle Konten-Balance eines Kunden?
	* Siehe Slides oder http://guides.rubyonrails.org/active_record_querying.html

10. Erzeugen sie in ````db/seeds.rb```` neue Kunden, mit Konten und Transaktion. Erzeugen Sie diese mit

	```bash
	rake db:setup
	```
11. Wiederholen Sie die Suche nach einem Kunden in der Rails Konsole (````rails console````). Wieviele Konten hat dieser Kunde? Wieviel Geld ist auf meine Bank deponiert (Summe alle Konten)? Wie ist die Summe alle Konten-Balance eines Kunden?   	

12. Erzeugen Sie eine Methode ````withdraw```` und ````deposit```` in der Klasse Account, die Geld abhebt bzw. einzaheln. Sie soll die balance anpassen und eine 
    Transaction für dieses Konto hinzufügen mit abgehoben bzw. eingezahlten Betrag (Amount) (soll negative bei withdral sein), Beschreibung ("Withdrawal" bzw. "Deposit"), und balance_after_transaction.
    Es soll kein Abheben oder Einzahlen von negativen Beträgen möglich sein und der Kontostand darf nach dem Abheben nicht negativ seien. Testen Sie die Methode in der Rails console. 

12. Erzeugen Sie eine Methode ````transfer```` in der Klasse Account, die einen Betrag auf ein anderes Konto überweist. Parameter sollen der Betrag und die Kontonummer (number) des anderen Kontos sein.
    Es sollen bei beiden Konten der Kontostand (Balance) angepasst werden. Für beide Konten soll jeweils eine
    Transaction hinzugefügt werden mit dem Betrag amount (positiv bzw. negative), description ("Transfer to " Kontonummer, bzw. "Transfer from " Kontonummer), und jeweilige balance_after_transaction.
    Es soll kein Überweisen von negativen Beträgen möglich sein und der Kontostand darf nach dem Überweisen nicht negativ seien. Testen Sie die Methode in der Rails console.

13. Erzeugen Sie eine Methode ````statement```` (Kontoauszug), der den Kontostand und den Kunden sowie die Transaktionen eines Kontos ausgibt. Testen Sie die Methode in der Rails console.

14. Ändern Sie die *README.rdoc* Datei. Fügen Sie Ihren Namen und eine kurze Beschreibung des Projekts ein

15. Alles zu git hinzufügen, commiten und pushen:

    ````bash
    git add .
    git commit -m "Alles fertig! Die Kunden können kommen."
    git push origin master
    ```
    Kontrollieren Sie bei Github ob es da ist.
