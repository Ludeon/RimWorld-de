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
1. Erstelle (falls noch nicht vorhanden) einen neuen Ordner namens 'German (Deutsch)' im Windows-Pfad '..\Steam\SteamApps\Common\RimWorld\Data\Core\Languages' (und, falls du die Erweiterung besitzt, auch im Pfad '..\Steam\SteamApps\Common\RimWorld\Data\Royalty\Languages').
2. Lade dir die aktuellsten Übersetzunsdateien von https://github.com/Ludeon/RimWorld-de herunter (Clone or Download -> Download ZIP) und entpacke die heruntergeladene zip-Datei.
3. Kopiere den darin enthaltenen Ordner 'Core' in den Windows-Pfad '..\Steam\SteamApps\Common\RimWorld\Data\Core\Languages\German (Deutsch)' (und, falls du die Erweiterung besitzt, auch den Ordner 'Royalty' in den Windows-Pfad '..\Steam\SteamApps\Common\RimWorld\Data\Royalty\Languages\German (Deutsch)'). Ersetze (falls nötig) alle zuvor darin enthaltenen Dateien.
4. Lösche in beiden Pfaden jeweils die Datei 'German (Deutsch).tar' (falls noch vorhanden).

Grammar Resolving vs update-wordinfo.yml
----------------------------------------
To ensure (almost) correct grammar in the game, new labels of items, titles of people etc. have to be added into the text files located in the Core/WordInfo/Gender folder depending on the gender of the word.

This process is done almost automatically thanks to the GitHub workflow file [update-wordinfo.yml](https://github.com/Ludeon/RimWorld-de/blob/master/.github/workflows/update-wordinfo.yml). The only thing left to do manually is to move the new words (Core/WordInfo/Gender/new_words.txt) into Female.txt, Male.txt and Neuter.txt. For details, see [Issue #73](https://github.com/Ludeon/RimWorld-de/issues/73).

Related: [Grammar Resolver (RimWorld Wiki)](https://rimworldwiki.com/wiki/Modding_Tutorials/GrammarResolver)
