## Falls bei Windows Rails wegen JavaRuntime Rails nicht läuft:

1.	NodeJS installieren (64bit oder 32bit je nach Betriebssystem):
*	http://nodejs.org/download/
2.	Zu den Windows Umgebungsvariablen (Path) folgendes hinzufügen:

        C:\Program Files\Nodejs;

*	Windows 8: http://techfrage.de/question/1119/windows-8-umgebungsvariablen-anzeigen-und-andern/
* Windows 7: http://www.java.com/de/download/help/path.xml

3.	Rechner neu starten

Wenn das nichts hilft, dann in jedem Rails Programm im Gemfile folgende hinzufügen:

    gem 'therubyracer' 
    gem 'extjs'

