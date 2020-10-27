#!/bin/bash
mkdir temp
python3 -m pip install $1 -t temp

version="$(python3 -V)"
version="${version:7}"
version="${version//"."/-}" 

file="$1$version"

rm -f /package/$1.zip

cd temp
zip -r /package/$file.zip *
