# Botscripts

# TODO

Finish updating everything with the new config setup

---

**Tool to help me host multiple bots on one unix based machine with ease running bash**

**Currently only supports PM2 processes but support for other runtimes will be added along the way when needed**

You will find instructions for how to use this tool for your own machine (if I ever got around to fixing it so it works on any machine and not just 
my own, who knows really)

The script can do the following:
  - Update a bot
  - Navigate to a bot
  - Start and stop a bot in the standard production environment
  - Backup logs for a bot with or without a given suffix
  - Read the logs combined file for a given bot
  - Delete the current logs without any backup
  - Create a new bot project with automatic git setup

When using these scripts, you want to be using the `bot.sh` file. I have it bound to an alias in my `.bashrc` file like below. This lets me call it
like any other command.


```bash
alias bot='~/botScripts/bot.sh'
```

This can easily be inserted into the bashrc file like below. But be careful to use `>>` and not `>` as it will override the whole file if you dont.

```bash
echo "alias bot='~/botScripts/bot.sh' >> ~/.bashrc"
```

# Requirements

  - Bash installation
  - An SSH key called "git" in `~/.ssh`

Below you will find a guide to create this ssh key and how you add it to GitHub.

---

# SSH Guide

**You can choose to have any type of ssh key but im going to show the most basic approach possible.**

Enter the following command into your terminal:

```bash
ssh-keygen
```

This will give you a prompt like:

```
Generating public/private rsa key pair.
Enter file in which to save the key (/home/william/.ssh/id_rsa): 
```

Where you enter a path to your file, which should look like this:

```
Generating public/private rsa key pair.
Enter file in which to save the key (/home/william/.ssh/id_rsa): /home/<YOUR USERNAME>/.ssh/git
```

Example:

```
Generating public/private rsa key pair.
Enter file in which to save the key (/home/william/.ssh/id_rsa): /home/william/.ssh/git
```

Note that you can not use `~` for your specific user directory in this command. The whole path must be specified from root (`/`)

Press enter, you will then be prompted to enter a passphrase, this is required for github ssh usage. You will then be asked to enter
the same passphrase again. If everything went as expected you will now have your keys random art displayed in the terminal, pretty cool 😎

Now we need to copy the public key so we enter the following command in our terminal:

```bash
cat ~/.ssh/git.pub
```

We copy the contents of the key and go to GitHub. Click your avatar and then `Settings`, `SSH and GPG keys`. You will now see a list of all your
keys registered to your GitHub account, could also be empty. Click the `New SSH key` button.

There are 3 fields here. Name, Key type and Key. Name the key whatever you want to name it. Then select `Authentication Key` in the Key type field.
Now paste the contents of your file into the Key field, click `Add SSH key` and you are done. All SSH actions are handled automatically with the script
so you do no have to worry about it after this step.

---

# Create New Bot

When creating a new bot you would call `bot.sh <name> create` and it would create a new directory in `~/bots` with the given name.
It will then initialize an empty git repository in that directory and setting the remote `bot` to the name of your project.
Then it creates a directory `logs` and successively create 3 files `stdout.log`, `stderror.log`, `combined.log` in that directory. 
Then create a directory `oldLogs` to prepare the log backup scripts directory.

---

# Update A Bot

**This command is very verbose for the sake of debugging!**

You would want to call `bot.sh <name> update` to update a bot. This would being by shutting the bot down using PM2.

The following directories are then deleted if present:
  - dist
  - node_modules
  - package-lock.json

- Deleting dist ensures no old JavaScript gets reused when using the TypeScript compiler.
- Deleting node_modules and package-lock.json ensures dependencies are updated regularly.

Thirdly, the entire repo is cloned into a directory called `update` and the working directory is changed into it. After that we delete all the old 
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

---

# Read Logs

You call `bot.sh <name> log read` when you want to read the logs of a specific bot. Using this command gives you the default behaviour of reading
from the `combined.log` file using `cat` with the `-n` flag for line numbers. If you wish to read `stderror.log` or `stdout.log` you call:

```bash
bot.sh <name> logs read stderror
bot.sh <name> logs read stdout
```

---

# Delete Logs

You call `bot.sh <name> logs delete` to completely delete the log entry. These logs are not backed up, just replaced with empty log files.

---

# Backup logs

You use `bot.sh <name> logs backup` when you want to create a backup of your current log directory. This calls `backupLogs.sh` which takes a suffix as 
an argument and creates a directory inside the `oldLogs` directory with a name of the current date and time split with a T like: 
`10:07:2022T00:29:21_<suffix>`. The default suffix coming from the `bot.sh` call is `backup`. You can change this by calling the script like:
`bot.sh <name> logs backup <suffix>`. This would create a custom suffix on the backup directory which could be helpful for organizing your backups.

After this directory has been created all log files are moved into it and new log files are created in the `logs` directory.

---

# Start Bot

To start a bot you simply use `bot.sh <name> start` and it just runs in the production environment out the box as long as all dependencies to run 
are met
