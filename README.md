# Botscripts

This is not meant to be a large project, its meant to be something I can use for my Discord.JS bots. With that in mind I have not gone out of my way 
to add configurations to setup which language and discord library. I'm only documenting it for the sake of "completeness", feature suggestions
and issues are welcome but they might not get prioritized over my current longterm project.

**THIS WILL NOT WORK IF YOU DO NOT RUN BASH ON YOUR MACHINE!**

It is recommended to use this with TypeScript over JavaScript but its not required.

These scripts are made with very little experience of bash over a weekend, so any bad bash practises found are not cared for, they will probably 
stay until I have the time (and need) to put effort into this. The scripts can:

  - Update a bot
  - Backup logs for a bot with or without a given suffix
  - Read the logs combined file for a given bot
  - Delete the current logs without any backup
  - Start a bot in the standard production environment
  - Create a new bot project with automatic git setup

When using these scripts, you want to be using the `bot.sh` file. I have it bound to an alias in my `.bashrc` file like below. This lets me call it 
like any other command.

```bash
alias bot='~/botScripts/bot.sh'
```

# Create New Bot

When creating a new bot you would call `bot.sh <name> create` and it would create a new directory in `~/bots` with the given name.
It will then initialize an empty git repository in that directory and setting the remote `bot` to the name of your project.
Then it creates a directory `logs` and successively create 3 files `stdout.log`, `stderror.log`, `combined.log` in that directory. 
Then create a directory `oldLogs` to prepare the log backup scripts directory.

---

# Update A Bot

**This command is very verbose for the sake of debugging!**

You would want to call `bot.sh <name> update` to update a bot. This would shut the bot down using PM2 and then start an SSH Agent and add 
the `~/.ssh/git` key.

The following directories are deleted if present:
	- dist
	- node_modules
	- package-lock.json

- Deleting dist ensures no old JavaScript gets reused when using the TypeScript compiler.
- Deleting node_modules and package-lock.json ensures dependencies are updated regularly.

Secondly, the entire repo is cloned into a directory called `update` and the working directory is changed into it. After that we delete all the old 
files with new files. This is done by checking if the file exists in both `update` and the root of the bots directory. This makes it so all the files
coming from the GitHub repo get replaced but anything externally added like a `.env` file or `assets` directory does not get removed as they are not
on the repo. After deleting the old files we move the new files into the bots root directory.

After replacing all the old files and moving the new ones its time to install the dependencies using `npm install`. After the main installation 
has been complete, the script checks for a `tsconfig.json` in the root of the bots directory. If present we install the `@types/node` dependency and 
compile using `tsc`. After the compilation is complete we change the working directory into `dist` and delete the directories we find in the `dist` 
and bots root directory. These are entire directories of already transpiled TypeScript code so we can safely remove them without causing harm to the 
application. Afterwards we move the working directory back to the bots root directory and delete the update directory as it is now empty.

After that it removes any files and directories not needed for the JavaScript application to run, such as `tsconfig.json`, `index.d.ts`, `README.md`
etc etc. After cleaning up the project it backs up the logs with the suffix `update` and starts it up.

The SSH Agent process is killed.

---

# Read Logs

You call `bot.sh <name> log read` when you want to read the logs of a specific bot. Using this command gives you the default behaviour of reading
from the `combined.log` file using `cat` with the `-n` flag for line numbers. If you wish to read `stderror.log` or `stdout.log` you call:

```bash
bot.sh <name> log read stderror
bot.sh <name> log read stdout
```

---

# Backup logs

You use `bot.sh <name> log backup` when you want to create a backup of your current log directory. This calls `backupLogs.sh` which takes a suffix as 
an argument and creates a directory inside the `oldLogs` directory with a name of the current date and time split with a T like: 
`10:07:2022T00:29:21_<suffix>`. The default suffix coming from the `bot.sh` call is `backup`. You can change this by calling the script like:
`bot.sh <name> log backup <suffix>`. This would create a custom suffix on the backup directory which could be helpful for organizing your backups.

After this directory has been created all log files are moved into it and new log files are created in the `logs` directory.

---

# Start Bot

To start a bot you simply use `bot.sh <name> start` and it just runs in the production environment out the box as long as all dependencies to run 
are met
