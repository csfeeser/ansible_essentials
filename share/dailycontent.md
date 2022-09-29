### TUESDAY CONCEPTS:
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

### WEDNESDAY CONCEPTS:
---
```
variable precedence- variables can be set in 22 different places; 
                     which variable value "wins" is based on its location in that hierarchy

JINJA2:
{{ var }}     return value of variable
{% if/for %}  setting logic (loops,conditions) in template

NEW PLAY KEYWORDS:
vars_prompt   prompt user for variable value
handlers      tasks that can be notified to run after changes occur

NEW BLOCK KEYWORDS:
block         just a group of tasks
rescue        task(s) that run after an error occurs in the block
always        task(s) that always run, error or no error

NEW TASK KEYWORDS:
tags          cherry-picking which tasks do/don't run

NEW MODULES:
template      combines a jinja2 template with Ansible vars
service       starts/stops/restarts services
package       auto-detects yum vs. apt for installing apps!
```

### THURSDAY CONCEPTS:
---
```
THURSDAY CONTENT
================
5 Phases of Self Healing Playbooks:
Provisioning       grab/download/read in all your data
Pre-check          set up "fail points" for bogus hosts
Maintenance        making actual changes
Post-check         confirming the changes stuck/are good
Post-Provisioning  leave output describing how things went

PLAY KEYWORDS:
roles              highly organized re-usable playbooks

NEW COMMANDS:
ansible-galaxy collection install  downloads/installs a collection of  
                                   modules/plugins/roles
ansible-galaxy role init           builds a role file structure to fill out

CLOUD:
localhost/local    hosts/connection for cloud configuration
openstacksdk       sends HTTP to openstack on behalf of ansible
boto3              sends HTTP to AWS on behalf of ansible
azuresdk           sends HTTP to azure on behalf of ansible
collections        need appropriate collection for your specific vendor; go to Ansible Galaxy

NEW MODULES:
service_facts       gather state info about all services on host
import_role         call role as task; load role when playbook starts
include_role        call role as task; load role when ENCOUNTERED
```
