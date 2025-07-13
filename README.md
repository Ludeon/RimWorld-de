RimWorld German
================

This is the german translation data for RimWorld.

See this page for license info:

http://ludeon.com/forums/index.php?topic=2933.0

Official Translators
--------------------
Active:
- [Ragnar-F](https://github.com/Ragnar-F) (main translator)

Inactive:
- [HaploX1](https://github.com/HaploX1)
- [TeiXeR](https://github.com/TeiXeR)
- [TheEisbaer](https://github.com/TheEisbaer)

Table of Contents
-----------------
- [Neueste Übersetzungsdateien verwenden](#neueste-übersetzungsdateien-verwenden)
- [Grammar Resolving](#grammar-resolving)
- [Helpful links & mods](#helpful-links--mods)

Neueste Übersetzungsdateien verwenden
-------------------------------------
Neue Übersetzungsänderungen sind normalerweise erst mit der nächsten RimWorld-Version verfügbar. Es gibt jedoch Ausnahmefälle, in denen es sinnvoll ist, die neuesten Übersetzungsdateien zu verwenden, z.B. wenn ein neuer DLC erschienen ist, aber die neuesten Übersetzungsdateien noch nicht übernommen wurden.
Die folgenden Schritte beschreiben, wie man die neuesten Übersetzungsdateien in RimWorld verwenden kann:

Automatische Methode (empfohlen):

1. Ladet die neuesten Übersetzungsdateien als [ZIP-Datei](https://github.com/Ludeon/RimWorld-de/archive/refs/heads/master.zip) herunter und entpackt sie.
2. Führt die Datei 'install.bat' aus.

Manuelle Methode:

1. Ladet die neuesten Übersetzungsdateien als [ZIP-Datei](https://github.com/Ludeon/RimWorld-de/archive/refs/heads/master.zip) herunter und entpackt sie.
2. Erstellt in jedem der folgenden Ordner einen neuen Unterordner namens 'German (Deutsch)'. Wenn dieser Unterordner bereits existiert, ist es ratsam, ihn zuerst zu leeren:
    ```
    <Pfad-zu-RimWorld>\Data\Anomaly\Languages\
    <Pfad-zu-RimWorld>\Data\Biotech\Languages\
    <Pfad-zu-RimWorld>\Data\Core\Languages\
    <Pfad-zu-RimWorld>\Data\Ideology\Languages\
    <Pfad-zu-RimWorld>\Data\Odyssey\Languages\
    <Pfad-zu-RimWorld>\Data\Royalty\Languages\
    ```
    &lt;Pfad-zu-RimWorld&gt; ist standardmäßig ```C:\Programme (x86)\Steam\steamapps\common\RimWorld```
    
    Beachtet, dass einige Ordner fehlen können. Core ist immer vorhanden. Der Rest hängt davon ab, welche DLCs ihr gekauft und installiert habt. 
4. Kopiert den Inhalt des entpackten Ordners 'Core' in den neu erstellten Ordner ```<Pfad-zu-RimWorld>\Data\Core\Languages\German (Deutsch)```. Wiederholt dies für die restlichen DLCs, sofern nötig.
5. Löscht in jedem oben genannten Pfad die Datei 'German (Deutsch).tar', um RimWorld zu zwingen, die Übersetzungsdateien im Ordner 'German (Deutsch)' zu verwenden.

Um dies wieder rückgängig zu machen, sind folgende Schritte notwendig:

1. Löscht in jedem oben genannten Pfad den Ordner 'German (Deutsch)'.
2. Rechtsklickt in Steam auf RimWorld und klickt auf 'Eigenschaften'.
3. Navigiert zu 'Installierte Dateien' und klickt auf 'Dateien auf Fehler überprüfen', um die gelöschten TAR-Dateien wiederherzustellen.

Grammar Resolving
-----------------
To ensure proper grammar, labels of pawn types, items, backstory titles, etc. (called nouns) need to be added to the text files located in the WordInfo folder. Core and each DLC have this folder.
- WordInfo/Gender can be used to specify the gender of a noun. Just add the nouns in lowercase to the appropriate text file (Male, Female, Neuter).
- decline.txt can be used to specify the different cases of a noun (e.g. genitive or accusative). The file itself contains usage details.
- plural.txt can be used to specify the plural form of a noun. The file itself contains usage details. This overrides the game's pluralization.

This process is done almost automatic, thanks to the GitHub workflow file [update-wordinfo.yml](https://github.com/Ludeon/RimWorld-de/blob/master/.github/workflows/update-wordinfo.yml). The workflow is triggered every time a commit is pushed to the master branch, and runs the PowerShell script [update-wordinfo.ps1](https://github.com/Ludeon/RimWorld-de/blob/master/update-wordinfo.ps1), which in turn runs the following PowerShell scripts:
- [update-wordinfo-gender.ps1](https://github.com/Ludeon/RimWorld-de/blob/master/update-wordinfo-gender.ps1) searches for specific labels in specific XML files, converts them to lowercase, and alphabetically assigns them to Male.txt, Female.txt, Neuter.txt, or Other.txt, which are located in WordInfo/Gender (Core and each DLC have these files). If a label cannot be assigned automatically, it will be added to new_words.txt. These labels must be assigned manually. Other.txt is for labels that are neither male, female, nor neuter.
- [update-wordinfo-decline.ps1](https://github.com/Ludeon/RimWorld-de/blob/master/update-wordinfo-decline.ps1) searches for specific labels in specific XML files and adds them to WordInfo\decline.txt (Core and each DLC have this file).
- [update-wordinfo-plural.ps1](https://github.com/Ludeon/RimWorld-de/blob/master/update-wordinfo-plural.ps1) searches for specific labels in specific XML files and adds them to WordInfo\plural.txt (Core and each DLC have this file).

Helpful links & mods
--------------------
- [Grammar Resolver (RimWorld Wiki)](https://rimworldwiki.com/wiki/Modding_Tutorials/GrammarResolver)
- [Rim Language Hot Reload](https://steamcommunity.com/sharedfiles/filedetails/?id=2569378701)
