#!/bin/bash

# This script creates a new repository on GitHub, then pushes the local
# repository from the current directory to the new remote directory.

# This script is a slight modification to https://gist.github.com/jerrykrinock/6618003,
# updated to use 'git config user.name' instead of 'git config github.user'.

# Requires an existing local repsotory to work.

# Gather constant vars
CURRENTDIR=${PWD##*/}
GITHUBUSER=$(git config user.name)

# Get user input
echo "Enter name for new repository, or just <return> to make it $CURRENTDIR"
read REPONAME
echo "Enter username for new, or just <return> to make it $GITHUBUSER"
read USERNAME
echo "Enter description for your new repository, on one line, then <return>"
read DESCRIPTION
echo "Enter <return> to make the new repository public, 'x' for private"
read PRIVATE_ANSWER

if [ "$PRIVATE_ANSWER" == "x" ]; then
  PRIVACYWORD=private
  PRIVATE_TF=true
else
  PRIVACYWORD=public
  PRIVATE_TF=false
fi

REPONAME=${REPONAME:-${CURRENTDIR}}
USERNAME=${USERNAME:-${GITHUBUSER}}

echo "This will create a new *$PRIVACYWORD* repository named $REPONAME"
echo "on github.com with the user account $USERNAME, with this description:"
echo $DESCRIPTION
echo "Type 'y' to proceed, or any other character to cancel."
read OK
if [ "$OK" != "y" ]; then
  echo "User cancelled"
  exit
fi

# Curl some JSON to the GitHub API
curl -u $USERNAME https://api.github.com/user/repos -d "{\"name\": \"$REPONAME\", \"description\": \"${DESCRIPTION}\", \"private\": $PRIVATE_TF, \"has_issues\": true, \"has_downloads\": true, \"has_wiki\": false}"

# Set the freshly created repo to the origin and push
# You will need to have added your public key to your GitHub account
git remote add origin https://github.com/$USERNAME/$REPONAME.git
git push -u origin master
