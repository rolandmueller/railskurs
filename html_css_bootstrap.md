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
6.  Generieren Sie einen Controller *Home* mit den Methoden *index* und *about*

    ````bash
    rails generate controller home index about
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
9.  Starten Sie den Rails Server (rails server) 

    ````bash
    rails server
    ```
    
    und schauen Sie sich das Ergebnis im Browser an: [http://localhost:3000/home/index](http://localhost:3000/home/index) 
10. Rails Logo http://rubyonrails.org/images/rails.png runterladen und im Verzeichnis *app/assets/images/* als *rails.png* speichern.
11. HWR Logo http://www.berlin-sciences.com/fileadmin/user_upload/K%C3%B6pfe_der_Wissenschaft/HWR_Berlin_Logo_220x100.jpg runterladen und 
im Verzeichnis *app/assets/images/* als *hwr.jpg* speichern.
11. Links zu Twitter Bootstrap Stylesheets hinzufügen. In *app/views/layouts/application.html.erb* nach dem title tag einfügen:

	```html
	<!-- Latest compiled and minified CSS -->
	<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.0.2/css/bootstrap.min.css">
	<!-- Optional theme -->
	<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.0.2/css/bootstrap-theme.min.css">
	<!-- Latest compiled and minified JavaScript -->
	<script src="//netdna.bootstrapcdn.com/bootstrap/3.0.2/js/bootstrap.min.js"></script>
	```
	speichern und Browser refrechen
	
11. Folgendes CSS ans Ende der Datei in *app/assets/stylesheets/application.css* hinzufügen

	```css
	/* Space out content a bit */
	body {
	  padding-top: 20px;
	  padding-bottom: 20px;
	}
	
	/* Everything but the jumbotron gets side spacing for mobile first views */
	.header,
	.marketing,
	.footer {
	  padding-left: 15px;
	  padding-right: 15px;
	}
	
	/* Custom page header */
	.header {
	  border-bottom: 1px solid #e5e5e5;
	}
	/* Make the masthead heading the same height as the navigation */
	.header h3 {
	  margin-top: 0;
	  margin-bottom: 0;
	  line-height: 40px;
	  padding-bottom: 19px;
	}
	
	/* Custom page footer */
	.footer {
	  padding-top: 19px;
	  color: #777;
	  border-top: 1px solid #e5e5e5;
	}
	
	/* Customize container */
	@media (min-width: 768px) {
	  .container {
	    max-width: 730px;
	  }
	}
	.container-narrow > hr {
	  margin: 30px 0;
	}
	
	/* Main marketing message and sign up button */
	.jumbotron {
	  text-align: center;
	  border-bottom: 1px solid #e5e5e5;
	}
	.jumbotron .btn {
	  font-size: 21px;
	  padding: 14px 24px;
	}
	
	/* Supporting marketing content */
	.marketing {
	  margin: 40px 0;
	}
	.marketing p + h4 {
	  margin-top: 28px;
	}
	
	/* Responsive: Portrait tablets and up */
	@media screen and (min-width: 768px) {
	  /* Remove the padding we set earlier */
	  .header,
	  .marketing,
	  .footer {
	    padding-left: 0;
	    padding-right: 0;
	  }
	  /* Space out the masthead */
	  .header {
	    margin-bottom: 30px;
	  }
	  /* Remove the bottom border on the jumbotron for visual effect */
	  .jumbotron {
	    border-bottom: 0;
	  }
	}
	```
