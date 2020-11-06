#!/usr/bin/env bash

#***** Variables *****
confpath="$HOME/Projets/$root/.git/config"  # Git config path
project_root=git rev-parse --show-toplevel  # Project root directory
username="DimitriObeid"                     # Your username

#***** Code *****
# Initializing a variable named 'x' at 0.
# This variable will be incremented after reading each line.
x=0

# Displayig the Git configuration file content, before reading its lines until the 7th line, which contains the information about the project URL according to the used communication protocol.
cat "$confpath" | while read -r line; do
    x=$(( x+1 ))

    if [ $x -eq 7 ]; then
        echo "$line" > /tmp/git_tmp.line
        break
    fi
done

line=$(cat /tmp/git_tmp.line)

# If the HTTPS protocol is used, the script asks for your Git password to write it during the push step.
# Don't worry, it won't be used or stored for malicious usage, as the variable will be erased at the end of the script.
if test "$line" = "url = https://github.com/$username/$project_root"; then
    stty_orig=$(stty -g) # Saving original terminal setting.
    stty -echo           # Turning off echoing to avoid displaying the user's password.
    
    IFS= read -rp "Enter your Git password : " gitpasswd  # read the password.
    stty "$stty_orig"    # Restore terminal setting.
    echo ""
    
fi

# Each file is registered into an array named "gitfiles" (the '-a' option of the "read" command allows to save each entered value in an array).
read -rpa "Enter the name of all the file to commit from the project root directory : " gitfiles
echo ""
    
read -rp "Enter the commit's name : " gitcommit
echo ""

# Browsing the "gitfiles" array via a loop.
for _ in ${#gitfiles[@]}; do
    echo "$_"
    git add "$gitfiles"
done

# Again, we check if the HTTPS protocol is used, since Git will ask your Git username and password, so the script can write the entered username and password.
if [ "$line" = "url = https://github.com/$username/$project_root" ]; then
    git commit -m "$gitcommit" && git push
else
    git commit -m "$gitcommit" && git push
fi

exit 0
