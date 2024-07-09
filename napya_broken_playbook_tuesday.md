## Busted Playbook Challenge!

<img src="https://i.redd.it/i4v9op0chrc51.jpg" width="500"/>

Good morning! To get the blood moving today we'll start with a familiar looking playbook-- however, it's broken! Your job is to get it working (no need to improve it).

Please start by getting your environment prepared:

`student@bchd:~$` `bash ~/px/scripts/full-setup.sh`

Use vim to create the playbook below and execute it. Then fix, test, repeat!

`student@bchd:~$` `vim ~/mycode/tuesday_warmup.yml`

```yaml
---
- name: Tuesday Challenge
  hosts: zoidburg

  tasks
   -name: install an app
     apt:
        Name: sl
       state: installed
```

`student@bchd:~$` `ansible-playbook ~/mycode/tuesday_warmup.yml`

### Debugging tip: run the playbook, see what error occurs. Then, focus on ONLY fixing that error. Then run again! Try not to introduce more errors as you go, focus on one thing at a time.

<details>
<summary>Click here for the solution!</summary>
<br>

```yaml
---
- name: Tuesday Challenge
  hosts: zoidberg               # TYPO- zoidberg, not zoidburg (check your inventory file)

  tasks:                        # missing : after tasks
   - name: install an app
     apt:                       # broken indentation; align "apt" with "name" in the line above 
       name: sl                 # case matters- make "name" lower case
       state: installed         # some parameters only accept certain values... change "installed" to "present"
     become: true               # this line is needed so we have the correct permission (sudo) for this task to work
 ```

</details>
