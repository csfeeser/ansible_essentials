## Busted Playbook Challenge!

<img src="https://www.splunk.com/content/dam/splunk-blogs/images/2015/02/automate-all-the-things.jpg" width="300"/>

Good morning! To get the blood moving today we'll start with a simple playbook-- however, it's broken! Your job is to get it working (no need to improve it).

Please start by getting your environment prepared:

`student@bchd:~$` `bash ~/px/scripts/full-setup.sh`

Create a new playbook file! Name it whatever you like (or use the command below).

`student@bchd:~$` `vim ~/mycode/busted_playbook.yaml`

Paste the BROKEN playbook code below! Then test, fix, repeat!

`student@bchd:~$` `ansible-playbook ~/mycode/busted_playbook.yaml`

### Debugging tip: run the playbook, see what error occurs. Then, focus on ONLY fixing that error. Then run again! Try not to introduce more errors as you go, focus on one thing at a time.

```yaml
---
- name: Tuesday Challenge
  hosts: planet express
  gather_facts: affirmative

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
  gather_facts: yes             # you can use yes, Yes, True, or true (but not affirmative)

  tasks:                        # WRONG TASK ORDER- make dir first, then file
   - name: create a directory
     file: 
       dest: challenge
       state: directory         # TYPO- directory, not directry
 
   - name: creating a file       # SYNTAX- needs a whitespace after the "-"
     copy:                                 # INDENTATION
       dest: challenge/challengefile.txt   # ERRORS ON THESE
       content: "Success!"                 # THREE LINES... also it is "content" NOT "contents"
 ```

</details>
