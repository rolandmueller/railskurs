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
    Wenn Homebrew nicht installiert ist, kann man die wie folgt installieren. Auf der Konsole:
    ```bash
    ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go/install)"
    ```
    
    * Für Linux ```sudo apt-get install imagemagick```
  

2. Carrierwave (https://github.com/carrierwaveuploader/carrierwave) installieren

  Im *Gemfile* folgendes hinzufügen:

  ```ruby
  gem "carrierwave"
  ```
  Und dann auf der Konsole mit
  ```bash
  bundle install
  ```
  installieren.
  
3. Uploader erzeugen

  Auf der Konsole:
  
