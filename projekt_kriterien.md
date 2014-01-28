## Kriterien für das Rails Projekt

1. Projekt-Beschreibung in README.

	1. Projekt-Name
	2. Vor- und Nachnamen und Matrikel-Nummern der Team-Mitglieder
	3. Link zur Heroku-Demo
	4. Ausführliche Beschreibung:
		
		* Beschreibung des Projekts
		* Beschreibung der technischen Umsetzung
	
2. Fehlerfreiheit (Applikation funktioniert)

3. Code Qualität

	1. Code ist korrekt eingerückt
	2. Klassen, Methoden und Variablen haben sprechende Namen (Englisch oder Deutsch ist egal, wobei bei Rails mit Englisch vieles einfacher ist)
	3. Kommentare: Kann in Englisch oder Deutsch sein
	4. Model-Struktur: Datenbank-Struktur bildet das Problem geeignet ab
	5. Controller-Struktur: Controller sind sinnvoll strukturiert. REST-strukturierte Controller machen das Leben einfacher , d.h. für ein Modell werden folgende Methoden im Controller genutzt: index, show, new, edit, destroy, create und update. Manchmal braucht man nicht alle Methoden (z.B. in der Todoapp haben wir keine Show Methode gebraucht).

3. Funktionalität
	* Mir ist lieber eine kleine Applikation in hoher Qualität als eine sehr komplexe Applikation in geringer Qualität. 
		
5. Keine Sicherheitslücken
	* Authentifikation und Authorizierung gemäß ihren Projekt-Anforderungen
	* Nicht Passwort unverschlüsselt in der Datenbank speichern. Devise verschlüsselt das Passwort für Sie.
	* Keine Passwörter oder andere sensibele Daten im Source-Code

6. 	Tests (Unit und Functional Tests)
