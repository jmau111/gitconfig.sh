# gitconfig.sh

Light Bash script to configure your Linux/Unix machine for Git. It contains a short list of configuration files and commands you might need to start.

## Disclaimer

1. it should be compatible with most Linux distributions and Unix-like systems
2. configs are minimalist on purpose
3. the name of this repo is just another acronym, nothing suspicious

## How to use

```
git clone https://github.com/jmau111/gitconfig.sh
cd gitconfig.sh
chmod +x gitconfig.sh
./gitconfig.sh -b "main" -e "myemail@mysite.com" -u "The Undertaker"
```

You can specify the name and the email you want to associate with your commits. People usually use a no-reply email for privacy purposes, as such email will be **public** in your public repositories.

## Usage 

```
The installer for gitconfig.sh

USAGE:
    ./gitconfig.sh [ -b BRANCH_NAME ] [ -e "EMAIL" ] [ -u "USERNAME" ]

OPTIONS:
      -h  Usage
      -b  The default branch name (default is "main")
      -u  required: The name that will be associated with commits
      -e  required: The email that will be associated with commits
```

## Files

* `.gitconfig`: main config file for your Git activities (the script only overrides some settings and add a few aliases)
* `.gitignore_global`: main config file for all files that should be ignored by Git

## Safety first

As these files control Git, the script backs up any existing config in `~/gitconfig-backups` before proceeding.
