## Busted Playbook Challenge!

<img src="https://i.redd.it/i4v9op0chrc51.jpg" width="500"/>



Good morning! To get the blood moving today we'll start with a familiar looking playbook-- however, it's broken! Your job is to get it working (no need to improve it).

Please start by getting your environment prepared:

`student@bchd:~$` `bash ~/px/scripts/full-setup.sh`

If you're getting tired of seeing cows from `cowsay` yesterday, run this in your bchd machine:

`student@bchd:~$` `sudo apt remove cowsay -y`

```
 _________________
< how dare youuuu >
 -----------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

Use vim to create a playbook file of your choosing and enter the following. Then test, fix, repeat!

### Debugging tip: run the playbook, see what error occurs. Then, focus on ONLY fixing that error. Then run again! Try not to introduce more errors as you go, focus on one thing at a time.

```yaml
---
- name: Tuesday Challenge
  hosts: planet express
  connection: network_cli
  gather_facts: yes

  tasks:
   -name: creating a file
     copy:
        dest: challenge/challengefile.txt
       contents: "Success!"
       
   - name: create a directory
     file: 
       dest: challenge
       state: directry
```

<details>
<summary>Click here for the solution!</summary>
<br>

```yaml
---
- name: Tuesday Challenge
  hosts: planetexpress          # TYPO- planetexpress, not planet express
  connection: ssh               # WRONG CONNECTION- ssh, not network_cli
  gather_facts: yes

  tasks:                        # WRONG TASK ORDER- make dir first, then file
   - name: create a directory
     file: 
       dest: challenge
       state: directory         # TYPO- directory, not directry
 
   - name: creating a file       # SYNTAX- needs a whitespace after the "-"
     copy:                                 # INDENTATION
       dest: challenge/challengefile.txt   # ERRORS ON THESE
       contents: "Success!"                # THREE LINES
 ```

</details>
