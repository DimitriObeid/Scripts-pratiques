#!/usr/bin/env bash

username="DimitriObeid"
confpath="/home/dimob/Projets/Linux-reinstall/.git/config"

# On initialise une variable nommée 'x' à 0.
# Cette variable sert à compter chaque numéro de ligne.
x=0

# On affiche le contenu du fichier de configuration de Git, puis on lit ces lignes.
cat "$confpath" | while read -r line; do
    x=$(( x+1 ))

    # On récupère la ligne 7 du fichier de configuration local de Git.
    if [ $x -eq 7 ]; then
        echo "$line" > /tmp/git_tmp.line
        break
    fi
done

line=$(cat /tmp/git_tmp.line)

# Dans le cas où le protocole utilisé est le protocole HTTPS.
if test "$line" = "url = https://github.com/$username/Linux-reinstall"; then
    stty_orig=$(stty -g) # save original terminal setting.
    stty -echo           # turn-off echoing.
    
    IFS= read -rp "Entrez votre mot de passe Git : " gitpasswd  # read the password.
    stty "$stty_orig"    # restore terminal setting.
    echo ""
    
    # On enregistre chaque fichier entré dans un tableau nommé "gitfiles" (l'option '-a' de la commande "read" permet d'enregistrer chaque valeur entrée dans un tableau).
    read -rpa "Entrez les noms des fichiers à commit depuis la racine du projet : " gitfiles
    echo ""
    
    read -rp "Entrez le nom du commit : " gitcommit
    echo ""

    # Faire un tableau et le parcourir via une boucle.
    for _ in ${#gitfiles[@]}; do
        echo "$_"
        git add "$gitfiles"
    done
    
    git commit -m "$gitcommit" && git push
    
# Dans le cas où le protocole utilisé est le protocole SSH.
elif test "$line" = "url = git@github.com:$username/Linux-reinstall"; then
    read -rp "Entrez les noms des fichiers à commit : " gitfiles
    echo ""
    
    read -rp "Entrez le nom du commit : " gitcommit
    echo ""
    
    git add "$gitfiles" && git commit -m "$gitcommit" && git push
fi

exit 0
