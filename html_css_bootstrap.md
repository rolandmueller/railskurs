# 5. Übung: HTML / CSS / Bootstrap 

1.	Generieren Sie ein neues Rails Projekt uebung5
	
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
3.	Erzeugen Sie bei Github ein leeres Repositorium mit dem Namen uebung5
4.	Fügen Sie das Github als Remote-Repositorium hinzu 

    ````bash
    git remote add origin ...
    ```
5.  Pushen Sie das Projekt zu Github. Kontrollieren Sie bei Github ob es da ist.

    ````bash
    git push origin master
    ```
    Falls nach dem User und dem Passwort gefragt wurden, hier wird beschriben wie man das automatisieren kann: https://help.github.com/articles/generating-ssh-keys
6.  Generieren Sie einen Controller *Home* mit einer Methode *index*

    ````bash
    rails generate controller Home index
    ```
7.  Öffnen Sie den Ordner uebung5 in Sublime Text 2 (z.B. durch Drag-and-Drop des Ordners)
8.  Erstetzen Sie in app/views/home/index.html.rb den Text mit

    ```html
    <div class="center hero-unit">
        <h1>Willkommen zur Beispiel-App</h1>
        <h2>
            Dies ist die Homepage für meine Beispiel-App.
        </h2>
        <%= link_to "Jetzt Anmelden", '#', class: "btn btn-large btn-primary" %>
    </div>
    <%= link_to image_tag("rails.png", alt: "Rails"), 'http://rubyonrails.org/' %>
    ```
9.  Starten Sie den Rails Server (rails server) und schauen Sie sich das Ergebnis im Browser an.
