# Ruby Installationsprobleme mit rbenv

Das heißt `rbenv install 2.3.3` hat ein Fehler ergeben.

## Nur für Windows Subsystem für Linux bzw. Linux Partition (Ubuntu)

Falls Sie mit Windows Subsystem für Linux bzw. mit ihrer Linux Partition Probleme haben Ruby mit dem rbenv zu installieren, hier einige mögliche Bug-Fixes:

1. Möglicher Fehler: Es sind keine Compiler und andere notwendige Packete installiert.

* Fix: Notwendige Packete installieren (im Bash):

    ```bash
    sudo apt-get update
  
    sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev
    ```

2. Möglicher Fehler: Für das Donwload über HTTPS braucht ihr Computer ein aktuelles SSL Packet. Die Verschlüsselungsstärke von 
HTTPS wurde aber in den letzten 
Jahren verbessert und einige ältere SSL Packete (alte openssh Packete) können damit noch nicht umgehehn. 

* Fix:

* Erst altes openssh deinstallieren (im Bash) (für Ubuntu auf Windows bzw. Ubuntu Partition):
    
    ```bash
    sudo apt remove openssl-devel
    ```
* Dann neue libssl1.0-dev installieren (im Bash):
    ```bash  
    sudo apt install libssl1.0-dev
    ```
    
