RimWorld German
================

This is the german translation data for RimWorld.

See this page for license info:

http://ludeon.com/forums/index.php?topic=2933.0

Official Translators
--------------------
- Haplo
- TheEisbaer
- TeiXeR
- Ragnar-F

If you want to be added to the list of translators, there is just one rule:
You have to help with the translations over at least two major releases.
If you've done that and want to be named, you're allowed to change the LanguageInfo.xml file.

Instruction for German Translators
----------------------------------
1. Lade dir die aktuellsten Übersetzungsdateien von https://github.com/Ludeon/RimWorld-de herunter (Code -> Download ZIP) und entpacke die heruntergeladene zip-Datei.
2. Führe die Datei 'Install.bat' aus.

ODER (falls das nicht funktioniert)

1. Lade dir die aktuellsten Übersetzungsdateien von https://github.com/Ludeon/RimWorld-de herunter (Code -> Download ZIP) und entpacke die heruntergeladene zip-Datei.
2. Erstelle (falls noch nicht vorhanden) einen neuen Ordner namens 'German (Deutsch)' im Windows-Pfad '..\Steam\SteamApps\Common\RimWorld\Data\Core\Languages'.
3. Wiederhole Schritt 1 im Pfad '..\Steam\SteamApps\Common\RimWorld\Data\Royalty\Languages', falls du die Erweiterung 'Royalty' besitzt.
Wiederhole den Schritt 1 im Pfad '..\Steam\SteamApps\Common\RimWorld\Data\Ideology\Languages', falls du die Erweiterung 'Ideology' besitzt.
4. Kopiere den Inhalt vom im ZIP-Archiv enthaltenen Ordner 'Core' in den Windows-Pfad '..\Steam\SteamApps\Common\RimWorld\Data\Core\Languages\German (Deutsch)' (und, falls du eine der Erweiterungen besitzt, auch den Inhalt der Ordner 'Royalty' und/oder 'Ideology' in den entsprechenden Windows-Pfad). Ersetze (falls nötig) alle zuvor in 'German (Deutsch)' enthaltenen Dateien.
5. Lösche in allen Pfaden jeweils die Datei 'German (Deutsch).tar' (falls noch vorhanden).

Am Ende müssen die Pfade so aussehen (am Beispiel vom Ordner 'DefInjected'): 

..\Steam\steamapps\common\RimWorld\Data\Core\Languages\German (Deutsch)\DefInjected
..\Steam\steamapps\common\RimWorld\Data\Royalty\Languages\German (Deutsch)\DefInjected
..\Steam\steamapps\common\RimWorld\Data\Ideology\Languages\German (Deutsch)\DefInjected

Grammar Resolving vs update-wordinfo.yml
----------------------------------------
To ensure (almost) correct grammar in the game, new labels of items, titles of people etc. have to be added into the text files located in the Core/WordInfo/Gender folder depending on the gender of the word.

This process is done almost automatically thanks to the GitHub workflow file [update-wordinfo.yml](https://github.com/Ludeon/RimWorld-de/blob/master/.github/workflows/update-wordinfo.yml). The only thing left to do manually is to move the new words (Core/WordInfo/Gender/new_words.txt) into Female.txt, Male.txt and Neuter.txt. For details, see [Issue #73](https://github.com/Ludeon/RimWorld-de/issues/73).

Related: [Grammar Resolver (RimWorld Wiki)](https://rimworldwiki.com/wiki/Modding_Tutorials/GrammarResolver)
