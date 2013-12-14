# Bild-Upload

In vielen Applikationen kann der Nutzer ein Bild hochladen. Sei es das User-Bild oder das Bild eines Artikels. Wie geht das?

Um dies zu simulieren, fügen wir für Nutzer der Todo-Applikation ein Bild-Upload zu ermöglichen.

1. ImageMagick installieren

  Ist nur notwendig, wenn man auf dem Server das Bild automatisch verändern will, also z.B. es verkleinern will. Wenn nicht, kann man diesen Schritt überspringen. Muss man nur einmal für den Computer machen.
  
  * Wenn Windows: Installer downloaden und installieren: http://www.imagemagick.org/script/binary-releases.php#windows 
  * Wenn Mac: Wie Homebrew installieren.
    ```bash
    brew install imagemagick
    ```
    Wenn Homebrew nicht installiert ist, kann man es auf dem Max wie folgt installieren. Auf dem Terminal:
    ```bash
    ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go/install)"
    ```
    
  * Für Linux ```sudo apt-get install imagemagick```
  
2. Carrierwave (https://github.com/carrierwaveuploader/carrierwave) installieren

  Im *Gemfile* folgendes hinzufügen:

  ```ruby
  gem 'carrierwave'
  ```
  Wenn man *ImageMagick* nutzen will zusätzlich im Gemfile
  ```ruby
  gem 'mini_magick'
  ```  
  
  Und dann auf der Konsole mit
  ```bash
  bundle install
  ```
  installieren.
  
3. Uploader erzeugen

  Auf der Konsole:
  ```bash
  rails generate uploader Image
  ```
  
  Den Image-Uploader kann man auch anders nennen (z.B. Avatar). In *app/uploaders/image_uploader.rb* kann man den Uploader konfigurieren. Für Bilder sollte man bei diesem Abschnitt die Kommentare entfernen:
  ```ruby
  def extension_white_list
    %w(jpg jpeg gif png)
  end
  ```
  
4. Mini-Test Applikation

  Zum vorführen erzeugen wir eine kleine Rails-Applikation die Bilder (Paintings) einer Galerie zeigen soll.
  
  ```bash
  rails new fileuploadapp
  cd fileuploadapp
  rails generate scaffold painting name
  rake db:migrate
  ```
  
4. Im dem Modell, dass ein Bild haben soll, Uploader und Image-Name hinzufügen.

  Wenn wir z.B. zum User ein Bild hinzufügen wollen. 
  
  Als erstes in der *paintings* Tabelle ein *image* Feld hinzufügen:
  ```bash
  rails generate migration add_image_to_paintings image:string
  ```
  und die Datenbank aktualisieren:
  ```bash
  rake db:migrate
  ```
  Dann im Users-Modell in *app/models/paintings.rb* angeben, welcher Uploader und welches Feld dazugehört:
  ```ruby
  mount_uploader :image, ImageUploader
  ```
  
5. Im Formular ein Datei-Upload einbauen.

  Damit ein Datei-Upload mit einem Formular möglich ist, muss das Formular auf *Multipart* umgestellt werden. Wir fügen dafür ```:html => {:multipart => true}``` in die Parameter der *form_for* Funktion. Also z.B. für den User in *app/views/painting/_form.html.erb* ändern wir die erste Zeile, sodass diese so aussieht:
  ```html
  <%= form_for(@painting, :html => {:multipart => true}) do |f| %>
  ```
  
  Vor ```<div class="actions">```fügen wir folgendes hinzu:
  ```html
    <div class="field">
    <%= f.file_field :image %>
  </div>
  <div class="field">
    <%= f.label :remote_image_url, "or image URL" %><br />
    <%= f.text_field :remote_image_url %>
  </div>
  ```
  
  Wenn wir den Rails Server gestartet haben und auf http://localhost:3000/paintings/new gehen, sieht es so aus:
  
  ![](https://dl.dropboxusercontent.com/u/10978171/fileupload.png)
  
  
  
