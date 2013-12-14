# Bild-Upload

In vielen Applikationen kann der Nutzer ein Bild hochladen. Sei es das User-Bild oder das Bild eines Artikels. Wie geht das?

Um dies auszuprobieren, erzeugen wir eine kleine Rails-App für Bilder.

1. Rails Applikation

  Wir erzeugeneine kleine Rails-Applikation die Bilder (Paintings) einer Galerie zeigen soll.
  
  ```bash
  rails new fileuploadapp
  cd fileuploadapp
  rails generate scaffold painting name
  rake db:migrate
  ```
  
2. ImageMagick installieren

  Ist nur notwendig, wenn man auf dem Rechner/Server das Bild automatisch verändern will, also z.B. es verkleinern will. Wenn nicht, kann man diesen Schritt überspringen. Muss man nur einmal pro Computer machen.
  
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
  
3. Carrierwave (https://github.com/carrierwaveuploader/carrierwave) installieren

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
  
4. Uploader erzeugen

  Auf der Konsole:
  ```bash
  rails generate uploader Image
  ```
  
  Den Image-Uploader kann man auch anders nennen (z.B. Avatar). In *app/uploaders/image_uploader.rb* kann man den Uploader konfigurieren. Wenn man nur Bilder hcohladen will, sollte man bei diesem Abschnitt die Kommentare entfernen und nur Bilder zulassen:
  ```ruby
  def extension_white_list
    %w(jpg jpeg gif png)
  end
  ```

5. Im dem Modell, dass ein Bild haben soll, Uploader und Image-Name hinzufügen.

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
  
6. Im Formular ein Datei-Upload einbauen.

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
  
  Im Painting-Controller müssen wir noch *image* und *remote_image_url* erlauben.
  ```ruby
  def painting_params
    params.require(:painting).permit(:name, :image, :remote_image_url)
  end
  ```
  
  Wenn wir den Rails Server gestartet haben und auf http://localhost:3000/paintings/new gehen, sieht es so aus:
  
  ![](https://dl.dropboxusercontent.com/u/10978171/fileupload.png)
  
  
7. Bild darstellen

  Z.B. in *app/views/paintings/show.html.erb* fügen das Image ein:
  
  ```html
  <%= image_tag @painting.image_url if @painting.image? %>
  ```

    ![](https://dl.dropboxusercontent.com/u/10978171/mona_lisa.png)
    
8. Wenn man ImageMagick installiert hat, kann man automatisch die Bilder skallieren lassen.

  In *app/uploaders/image_uploader.rb* kann man verschiedene Versionen erstellen. Z.B. Thumbnails in verschiedener Größe. Wir entfernen die Kommentare von 
  
  ```ruby
  include CarrierWave::MiniMagick
  ```
  und fügen das ein
  ```ruby
  version :thumb do
    process :resize_to_fit => [100, 100]
  end
  ```
  Anstatt *resize_to_fit* hätte man auch *resize_to_fill* nehmen können. Dann wären die kompletten 100x100 pixel ausgefüllt worden, jedoch einiges vom Bild eventuell vom Bid abgeschnitten worden.
  
  In *app/views/paintings/index.html.erb* kann man das Bild hinter ```<td><%= painting.name %></td>```hinzufügen:
  ```html
  <td><%= image_tag painting.image_url(:thumb) if painting.image? %></td>
  ```
  
  ![](https://dl.dropboxusercontent.com/u/10978171/thumbnails.png)
  
  Man kann auch noch andere Varianten in definieren
  ```ruby
  version :normal do
    process :resize_to_fit => [300, 300]
  end
  ```
  
  und dann z.B. das Bild in *app/views/paintings/show.html.erb* in der Normal-Skalierten Variante zeigen:
    ```html
  <td><%= image_tag painting.image_url(:normal) if painting.image? %></td>
  ```
  
9. Um das auf Heroku zum laufen zu bringen, siehe https://github.com/carrierwaveuploader/carrierwave/wiki/How-to%3A-Make-Carrierwave-work-on-Heroku und mich fragen.
  