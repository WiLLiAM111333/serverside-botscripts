# Botscripts

**THIS WILL NOT WORK IF YOU DO NOT RUN BASH ON YOUR MACHINE!**

These scripts are made with very little experience of bash over a weekend, so any bad bash practises found are not cared for, they will probably stay until I have the time (and need) to put effort into this. The scripts can:
  - Update a bot
  - Backup logs for a bot with or without a given suffix
  - Read the logs combined file for a given bot
  - Delete the current logs without any backup
  - Start a bot in the standard production environment
  - Create a new bot project with automatic git setup

When using these scripts, you want to be using the `bot.sh` file. I have it bound to an alias in my `.bashrc` file like below. This lets me call it like any other command.

```bash
alias bot='~/botScripts/bot.sh'
```

# Create New Bot

When creating a new bot you would call `bot.sh <name>` and it would create a new directory in `~/bots` with the given name.
It will then initialize an empty git repository in that directory an setting the remote `bot` to the name of your project.
Then it creates a directory `logs` and successively create 3 files `stdout.log`, `stderror.log`, `combined.log` in that directory. 
Then create a directory `oldLogs` to prepare the log backup scripts directory.
