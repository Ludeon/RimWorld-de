RimWorld German
================

This is the german translation data for RimWorld.

See this page for license info:

http://ludeon.com/forums/index.php?topic=2933.0

Official Translators
--------------------
Active:
- [Ragnar-F](https://github.com/Ragnar-F) (main translator)
- [TeiXeR](https://github.com/TeiXeR)

Inactive:
- [HaploX1](https://github.com/HaploX1)
- [TheEisbaer](https://github.com/TheEisbaer)

Aktuellste Übersetzungsdateien verwenden
----------------------------------------
Die folgenden Schritte beschreiben, wie du die aktuellsten Übersetzungsdateien in dieser Repo für RimWorld verwenden kannst. Dies ist zum Beispiel nützlich, wenn eine neue Erweiterung erschienen ist, aber die neuesten Übersetzungsdateien noch nicht übernommen worden sind.
1. Lade dir die [aktuellsten Übersetzungsdateien](https://github.com/Ludeon/RimWorld-de/archive/refs/heads/master.zip) herunter und entpacke die heruntergeladene ZIP-Datei.
2. Führe die Datei 'install.bat' aus.

ODER (falls das nicht funktioniert)

1. Lade dir die [aktuellsten Übersetzungsdateien](https://github.com/Ludeon/RimWorld-de/archive/refs/heads/master.zip) herunter und entpacke die heruntergeladene ZIP-Datei.
2. Erstelle in jedem der folgenden Ordner einen neuen Ordner namens 'German (Deutsch)'. Sollte der Ordner 'German (Deutsch)' bereits vorhanden sein, ist es ratsam, diesen vorher zu leeren:
    ```
    <Pfad-zu-RimWorld>\Data\Biotech\Languages\
    <Pfad-zu-RimWorld>\Data\Core\Languages\
    <Pfad-zu-RimWorld>\Data\Ideology\Languages\
    <Pfad-zu-RimWorld>\Data\Royalty\Languages\
    ```
    &lt;Pfad-zu-RimWorld&gt; ist standardmäßig ```C:\Program Files\Steam\steamapps\common\RimWorld```
    
    Beachte, dass einige Ordner fehlen können. Core ist immer vorhanden. Der Rest ist abhängig davon, welche RimWorld-Erweiterungen du gekauft und installiert hast. 
4. Kopiere den Inhalt vom im ZIP-Archiv enthaltenen Ordner 'Core' in ```<Pfad-zu-RimWorld>\Data\Core\Languages\German (Deutsch)```. Wiederhole das für die restlichen Erweiterungen, sofern nötig.
5. Lösche in allen oben genannten Pfaden jeweils die Datei 'German (Deutsch).tar', um RimWorld zu zwingen, die Übersetzungsdateien im Ordner 'German (Deutsch)' zu verwenden.

Um diese Prozedur wieder rückgängig zu machen bzw. RimWorld wieder die standardmäßig bereitgestellten Übersetzungsdateien verwenden zu lassen, sind folgende Schritte notwendig:

1. Lösche in allen oben genannten Pfaden jeweils den Ordner 'German (Deutsch)'.
2. Rechtsklicke in Steam auf RimWorld und klicke auf 'Eigenschaften'.
3. Navigiere zu 'Lokale Dateien' und klicke auf 'Spieldateien auf Fehler überprüfen...', um die gelöschten TAR-Dateien wiederzuherstellen.

Grammar Resolving vs update-wordinfo.yml
----------------------------------------
To ensure (almost) correct grammar in the game, new labels of items, titles of people etc. have to be added into the text files located in the Core/WordInfo/Gender folder depending on the gender of the word.

This process is done almost automatically thanks to the GitHub workflow file [update-wordinfo.yml](https://github.com/Ludeon/RimWorld-de/blob/master/.github/workflows/update-wordinfo.yml). The only thing left to do manually is to move the new words (Core/WordInfo/Gender/new_words.txt) into Female.txt, Male.txt, Neuter.txt or Other.txt.

Details:

This workflow is triggered every time a commit is pushed to the master branch. When triggered, it scans XML files located in specific folders for specific tag elements. For the current list of folders being scanned, search for ```$paths```. For the current list of tag elements being parsed to get the words, search for ```.label```. New words are stored in Core/WordInfo/Gender/new_words.txt and must be manually sorted into either Female.txt, Male.txt, Neuter.txt or Other.txt. The words are automatically converted to lowercase and sorted alphabetically within their list.

Note that Other.txt has no function. It rather serves as a storage place for words that are neither feminine, masculine nor neutral. In German language this would be for example plural words.

Helpful links
-------------
[Grammar Resolver (RimWorld Wiki)](https://rimworldwiki.com/wiki/Modding_Tutorials/GrammarResolver)
