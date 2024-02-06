## Busted Playbook Challenge!

<img src="https://i.redd.it/i4v9op0chrc51.jpg" width="500"/>



Good morning! To get the blood moving today we are going to FIX a BROKEN playbook! This is what the playbook is SUPPOSED to do:
- access localhost (our `bchd` VM)
- create a new directory using [the file module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/file_module.html)
- create a new file inside that directory containing the word "Success!" using [the copy module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/copy_module.html)

### Debugging tip: run the playbook, see what error occurs. Then, focus on ONLY fixing that error. Then run again! Try not to introduce more errors as you go, focus on one thing at a time.

Use vim to create a playbook file of your choosing and enter the following.

`student@bchd:~$` `cd ~/mycode`

`student@bchd:~/mycode$` `vim ~/mycode/tuesday_warmup.yml`

```yaml
---
- name: Tuesday Challenge
  hosts: localhost
  connection: network_cli
  gather_facts: no

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

`student@bchd:~/mycode$` `ansible-playbook ~/mycode/tuesday-warmup.yml`

<details>
<summary>Click here for the solution!</summary>
<br>

```yaml
---
- name: Tuesday Challenge
  hosts: localhost
  connection: local             # WRONG CONNECTION- "local," not network_cli
  gather_facts: no

  tasks:                        # WRONG TASK ORDER- make dir first, then file
   - name: create a directory
     file: 
       dest: challenge
       state: directory         # TYPO- directory, not directry
 
   - name: creating a file      
     copy:                                 # INDENTATION
       dest: challenge/challengefile.txt   # ERRORS ON THESE
       content: "Success!"                 # THREE LINES... also it is "content" NOT "contents"
 ```

</details>
