## TUESDAY CONCEPTS:
---

```
NEW PLAY KEYWORDS:
vars        set variables in the play itself
vars_files  set vars in .yml files, then import into play

NEW TASK KEYWORDS:
register    capture task's return values in a variable
loop        pull one value at a time from a list
when

NEW MODULES:
raw         "low down and dirty," runs SSH commands
shell       executes commands through a bash shell (/bin/sh)
user        create/delete/modify users
group       create/delete/modify groups
file        create/delete/modify files AND directories
copy        copy files to hosts OR populate a new file with content
get_url     download files
uri         send HTTP requests, process HTTP responses
pip         install python packages on remote hosts
blockinfile add blocks of text to existing files
lineinfile  find/replace ONE string in a file
replace     find/replace ALL strings in a file
git         use git commands on remote machines
htpasswd    updates the htpasswd password file
```
