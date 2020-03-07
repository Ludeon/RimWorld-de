#!/usr/bin/env bash

########################################
# Functions
########################################
# Mainly to make the script more readable

# Removes BOMs, comments and blank lines from the stream
clean() { sed -e 's/\xEF\xBB\xBF/\n/' | grep -av '^//' | grep -avE '^[[:space:]]*$' ; }

# Removes the file lines passed as the first parameter from the stream
exclude() { grep -avxFf "$1" ; }

# Keeps only the file lines passed as the first parameter in the stream
intersect() { grep -axFf "$1" ; }

# Removes duplicates from the stream
unique() { sort --unique ; }

# Extract the element's content used by the translation system from the stream
extract_tag_content() {
  grep -aE '\.(label|labelMale|labelMalePlural|labelFemale|labelFemalePlural|pawnSingular|pawnsPlural)>' \
  | sed 's/^.*>\([^<]*\)<.*$/\1/' ;
}
extract_tag_male_content() { grep -aE '\.(labelMale|labelMalePlural)>' | sed 's/^.*>\([^<]*\)<.*$/\1/' ; }
extract_tag_female_content() { grep -aE '\.(labelFemale|labelFemalePlural)>' | sed 's/^.*>\([^<]*\)<.*$/\1/' ; }

# Passes all in lowercase
to_lowercase() { PERLIO=:utf8 perl -ne 'print lc $_' ;  }

########################################
# Start of the script
########################################
set -ex

# Go to the root of the project
cd $(dirname $(readlink -f $0))/../..

# Create a temporary folder and make sure it is deleted at the end
WORKDIR=$(mktemp -d)
trap "rm -rf $WORKDIR" EXIT

# Force the language for tools that take it into account
export LANG=de_DE.UTF-8 LC_ALL=de_DE.UTF-8

# List of all words coming from XML
cat */DefInjected/{PawnKind,Faction,Thing,WorldObject}Def/*.xml | extract_tag_content | to_lowercase | unique > $WORKDIR/all

# Add labelMale* into WordInfo/Gender/Male.txt
cat */WordInfo/Gender/Male.txt > $WORKDIR/all_males.txt
cat */DefInjected/{PawnKind,Faction,Thing,WorldObject}Def/*.xml | extract_tag_male_content >> $WORKDIR/all_males.txt
cat $WORKDIR/all_males.txt | to_lowercase | unique > Core/WordInfo/Gender/Male.txt

# Add labelFemale* into WordInfo/Gender/Female.txt
cat */WordInfo/Gender/Female.txt > $WORKDIR/all_females.txt
cat */DefInjected/{PawnKind,Faction,Thing,WorldObject}Def/*.xml | extract_tag_female_content >> $WORKDIR/all_females.txt
cat $WORKDIR/all_females.txt | to_lowercase | unique > Core/WordInfo/Gender/Female.txt

# List of words already classified
cat Core/WordInfo/Gender/{Male,Female}.txt | unique > $WORKDIR/wordinfo

# Add new words into WordInfo/Gender/new_words.txt
exclude $WORKDIR/wordinfo < $WORKDIR/all | unique > Core/WordInfo/Gender/new_words.txt

# Removes obsolete words from WordInfo/Gender/{Male,Female}.txt files
for GENDER in Male Female; do
  intersect $WORKDIR/all < Core/WordInfo/Gender/$GENDER.txt > $WORKDIR/$GENDER.txt
  mv $WORKDIR/$GENDER.txt Core/WordInfo/Gender/$GENDER.txt
done
