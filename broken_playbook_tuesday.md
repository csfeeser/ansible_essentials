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
- name: Tuesday challenge
  hosts: planet express
  connection: winrm
  become: true

  tasks:
    -name: Write "Happy Tuesday!" into a file
      shell: echo "Happy Tuesday!" > day2/message.txt

    - name: Create the day2 directory
      file:
         path: day2
        state: directry
```

<details>
<summary>Click here for the solution!</summary>
<br>

```yaml
---
- name: Tuesday challenge
  hosts: planetexpress    # FIX: hosts must match inventory name exactly (planetexpress, not "planet express")
  become: true
  connection: ssh         # FIX: connection should be ssh (winrm is for Windows targets)
  tasks:
    
    # FIX: wrong task order! The directory must exist BEFORE you write to a file inside it    - name: Create the day2 directory
      file:
        path: day2        # FIX: incorrect indentation 
        state: directory  # FIX: "directry" typo corrected to "directory"

    - name: Write "Happy Tuesday!" into a file  # FIX: missing a space after "- name"
      shell: echo "Happy Tuesday!" > day2/message.txt
 ```

</details>
