#!/bin/bash
# Generiert eine neue Kunden-Webseite mit zufälligem Code
# Usage: ./generate-site.sh "Firmenname"

if [ -z "$1" ]; then
  echo "Usage: ./generate-site.sh \"Firmenname\""
  exit 1
fi

FIRMA="$1"
# 8-stelliger zufälliger alphanumerischer Code (lowercase)
CODE=$(cat /dev/urandom | LC_ALL=C tr -dc 'a-z0-9' | head -c 8)

echo "Firma: $FIRMA"
echo "Code:  $CODE"
echo "URL:   https://kfzwerkstatt24.com/$CODE/"

# Ordner erstellen
mkdir -p "$CODE"

# Template kopieren
cp index.html "$CODE/index.html"
cp -r images "$CODE/images" 2>/dev/null

# Firmennamen im Template ersetzen
sed -i '' "s/Mustermann Fahrzeugtechnik/$FIRMA/g" "$CODE/index.html"
sed -i '' "s/Mustermann/$FIRMA/g" "$CODE/index.html"

echo ""
echo "Fertig! Seite erstellt unter: $CODE/"
echo "Jetzt noch committen und pushen:"
echo "  git add $CODE/"
echo "  git commit -m \"Neue Kunden-Seite: $CODE\""
echo "  git push"

# Mapping speichern (privat, nicht im Repo)
echo "$CODE|$FIRMA|$(date +%Y-%m-%d)" >> .site-mapping
