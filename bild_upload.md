# Bild-Upload

In vielen Applikationen kann der Nutzer ein Bild hochladen. Sei es das User-Bild oder das Bild eines Artikels. Wie geht das?

Um dies zu simulieren, fügen wir für Nutzer der Todo-Applikation ein Bild-Upload zu ermöglichen.

1. ImageMagick installieren

  Ist nur notwendig, wenn man auf dem Server das Bild automatisch verändern will, also z.B. es verkleinern will. Wenn nicht, kann man diesen Schritt überspringen.
  
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
  
4. Im dem Modell, dass ein Bild haben soll, Uploader und Image-Name hinzufügen.

  Wenn wir z.B. zum User ein Bild hinzufügen will:
  ```bash
  rails generate migration add_image_to_users image:string
  ```
  
