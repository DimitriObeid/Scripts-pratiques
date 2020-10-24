#!/usr/bin/env bash

# Ce script sert à créer rapidement un fichier de raccourcis à l'emplacement souhaité
# Il suffira de remplir les champs vides

path=$1		# Chemin du fichier à créer, incluant son nom

if test "$#" -ne 1; then
	echo "Usage : ./desktop.sh /chemin/du/fichier.desktop"
	exit 1
fi

cat <<-EOF > "$path"
[Desktop Entry]
Name=
Comment=
Exec=
Icon=
Terminal=false
Type=Application
Categories=;
EOF

if test "$?" -eq 0; then
	echo "Le fichier $path a été créé avec succès"
	exit 0
else
	echo "Une erreur s'est produite lors de la création du fichier"
	exit 1
fi
