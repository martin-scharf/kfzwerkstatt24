#!/bin/bash
# Generiert eine neue Kunden-Webseite
# URL-Format: kfzwerkstatt24.com/firmenname/code/
# /firmenname/ allein → 404 (nur mit Code erreichbar)
#
# Usage: ./generate-site.sh "Firmenname" "url-slug"
# Beispiel: ./generate-site.sh "Thomas Krug Fahrzeugtechnik" "thomas-krug"

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: ./generate-site.sh \"Firmenname\" \"url-slug\""
  echo "Beispiel: ./generate-site.sh \"Thomas Krug\" \"thomas-krug\""
  exit 1
fi

FIRMA="$1"
SLUG="$2"
# 6-stelliger zufälliger Code (kurz aber nicht erratbar)
CODE=$(cat /dev/urandom | LC_ALL=C tr -dc 'a-z0-9' | head -c 6)

echo "Firma: $FIRMA"
echo "Slug:  $SLUG"
echo "Code:  $CODE"
echo "URL:   https://kfzwerkstatt24.com/$SLUG/$CODE/"

# Ordner erstellen
mkdir -p "$SLUG/$CODE"

# Sperre: /slug/ allein zeigt 404
cat > "$SLUG/index.html" << 'EOF'
<!DOCTYPE html>
<html><head><meta charset="UTF-8"><title>404</title>
<style>body{font-family:sans-serif;display:flex;align-items:center;justify-content:center;height:100vh;background:#111;color:#555;margin:0;}</style>
</head><body><p>Seite nicht gefunden.</p></body></html>
EOF

# Template kopieren (keine Images mehr kopieren - werden zentral referenziert)
cp index.html "$SLUG/$CODE/index.html"

# Firmennamen im Template ersetzen
sed -i '' "s/KFZ-Werkstatt Mustermann/KFZ-Werkstatt $FIRMA/g" "$SLUG/$CODE/index.html"
sed -i '' "s/KFZ Mustermann/KFZ $FIRMA/g" "$SLUG/$CODE/index.html"
sed -i '' "s/Max Mustermann/Max $FIRMA/g" "$SLUG/$CODE/index.html"

# Bild-Pfade anpassen (2 Ebenen tief)
sed -i '' 's|src="images/|src="../../images/|g' "$SLUG/$CODE/index.html"

# Workshop-Email Platzhalter (muss manuell angepasst werden)
echo ""
echo "WICHTIG: Workshop-Email in $SLUG/$CODE/index.html anpassen!"
echo "  Suche nach: workshopEmail: 'service@kfz-mustermann.de'"
echo "  Ersetze mit der echten Werkstatt-Email."

echo ""
echo "Fertig!"
echo "Live-URL:  https://kfzwerkstatt24.com/$SLUG/$CODE/"
echo "Ohne Code: https://kfzwerkstatt24.com/$SLUG/ → 404"
echo ""
echo "Jetzt committen und pushen:"
echo "  git add $SLUG/"
echo "  git commit -m \"Neue Seite: $SLUG\""
echo "  git push"

# Mapping speichern (privat)
echo "$SLUG|$CODE|$FIRMA|$(date +%Y-%m-%d)" >> .site-mapping
