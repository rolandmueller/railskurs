# 5. Übung: Langing Page mit HTML / CSS / Bootstrap 

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
    Falls nach dem User und dem Passwort gefragt wurde, hier wird beschriben wie man das automatisieren kann: https://help.github.com/articles/generating-ssh-keys
6.  Generieren Sie einen Controller *Home* mit den Methoden *index* und *about*

    ````bash
    rails generate controller home index about
    ```
7.  Öffnen Sie den Ordner uebung5 in Sublime Text 2 (z.B. durch Drag-and-Drop des Ordners in Sublime Text. 
    Alternativ kann man auch Sublime von der Konsole öffnen: https://github.com/rolandmueller/railskurs/blob/master/sublime_konsole.md )
8.  Erstetzen Sie in *app/views/home/index.html.rb* den Text mit

    ```html
	<div class="jumbotron">
	<h1>Willkommen zur Beispiel-App</h1>
	<p class="lead">
		Dies ist die Homepage für meine Beispiel-App.
	</p>
	<%= link_to "Jetzt Anmelden", '#', class: "btn btn-lg btn-success" %>
	</div>
	
	<div class="row marketing">
	<div class="col-lg-6">
		<h4>Made with Rails</h4>
		<p>Diese App ist mit Ruby on Rails entwickelt</p>
		<p><%= link_to image_tag("rails.png", alt: "Rails"), 'http://rubyonrails.org/' %></p>
	</div>
	<div class="col-lg-6">
		<h4>Made in Berlin</h4>
		<p>Entstanden an der HWR Berlin</p>
		<p><%= link_to image_tag("hwr_logo.jpg", alt: "HWR"), 'http://www.hwr-berlin.de/' %></p>
	</div>
	</div>
    ```
9.  Starten Sie den Rails Server (rails server) 

    ````bash
    rails server
    ```
    
    und schauen Sie sich das Ergebnis im Browser an: [http://localhost:3000/home/index](http://localhost:3000/home/index) 
10. Rails Logo http://rubyonrails.org/images/rails.png runterladen und im Verzeichnis *app/assets/images/* als *rails.png* speichern.
11. HWR Logo http://people.f3.htw-berlin.de/Professoren/Brueggemeier/images/hwr_logo.jpg runterladen und 
im Verzeichnis *app/assets/images/* als *hwr.jpg* speichern.

	Browser reload (F5)
12. Links zu Twitter Bootstrap Stylesheets hinzufügen. In *app/views/layouts/application.html.erb* nach dem title tag einfügen:

	```html
	<!-- Latest compiled and minified CSS -->
	<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.0.2/css/bootstrap.min.css">
	<!-- Optional theme -->
	<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.0.2/css/bootstrap-theme.min.css">
	```
	

	Twitter Bootstrap JavaScript in *app/views/layouts/application.html.erb* kurz vor ``` </body> ``` einfügen:
	```html
	<!-- Latest compiled and minified JavaScript -->
	<script src="//netdna.bootstrapcdn.com/bootstrap/3.0.2/js/bootstrap.min.js"></script>
	```
	speichern und Browser reload (F5)	
13. Folgendes CSS ans Ende der Datei in *app/assets/stylesheets/home.css.scss* hinzufügen

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

	Browser reload (F5)

14. In *app/views/layouts/application.html.erb* ```<%= yield %>``` tag mit Bootstrap container umschließen:

	```html
	<div class="container">
		<%= yield %>
	</div> <!-- /container -->
	```
	
	Browser reload (F5)
15. In *app/views/layouts/application.html.erb* nach dem ```<%= yield %>``` tag (vor dem ```</div>``` tag) Footer einfügen:

	```html
	<div class="footer">
    	<p>&copy; Ihre Name 2013</p>
  	</div>
	```

	Browser reload (F5)

16. In *app/views/layouts/application.html.erb* nach dem ```<div class="container">``` tag (vor dem ```<%= yield %>``` tag) Header mit Navigation einfügen:

	```html
	<div class="header">
		<ul class="nav nav-pills pull-right">
		<li class="active">
			<%= link_to "Home", :controller => "home", :action => "index" %>
		</li>
		<li>
			<%= link_to "About", :controller => "home", :action => "about" %>
		</li>
		</ul>
		<h3 class="text-muted">Beispiel-App</h3>
	</div>
	```

	Browser reload (F5)

17. Fügen Sie eine kurze Beschreibung zu sich in der *About* Seite ein. In *app/views/home/about.html.rb*

	Browser reload (F5) und klicken Sie im Menü auf About und wieder auf Home
18. Ändern Sie die *README.rdoc* Datei. Fügen Sie Ihren Namen und eine kurze Beschreibung des Projekts ein
19. Alles zu git hinzufügen, commiten und pushen:

    ````bash
    git add .
    git commit -m "Meine Landing Page ist fertig! :-)"
    git push origin master
    ```
    Kontrollieren Sie bei Github ob es da ist.
