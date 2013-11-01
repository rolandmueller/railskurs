## Um von der Konsole Sublime Text aufrufen zu können, muss man den Path zu Sublime noch hinzufügen:

### Für Windows:

Zu den Windows Umgebungsvariablen (Path) folgendes hinzufügen:

    C:\Program Files\Sublime Text 2\sublime_text.exe
    
* Windows 8: http://techfrage.de/question/1119/windows-8-umgebungsvariablen-anzeigen-und-andern/
* Windows 7: http://www.java.com/de/download/help/path.xml

Danach kann man von der Konsole mit

    sublime_text dateiname.rb
    
die Datei öffnen. Wenn man ein ganzen Verzeichnis öffnen will, im Verzeichnis dies ausführen:

    sublime_text .
        
### Für Mac:

Im Terminal folgendes ausführen:

    ln -s "/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl" ~/bin/subl
    
Danach kann man von der Konsole mit

    subl dateiname.rb
    
die Datei öffnen. Wenn man ein ganzen Verzeichnis öffnen will, im Verzeichnis dies ausführen:

    subl .



