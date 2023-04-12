## Morning Warmup, Day Three!

<img src="https://miro.medium.com/max/1200/1*sssWakAf5erMGDqt9GACVA.jpeg" width="300"/>

The following will give you a chance to write some new code that uses techniques you've learned in class so far!

1. We'll be using the planetexpress team for this warmup! Run the command below to prepare your environment.

    `student@bchd:~$` `bash ~/px/scripts/full-setup.sh`

0. Edit your inventory file (`~/mycode/inv/dev/hosts`). **Append** the following to it (do not remove anything from your inventory file):

    ```
    [looneytunes]
    bugs        ansible_host=10.10.2.3 ansible_user=bender ansible_python_interpreter=/usr/bin/python3
    taz         ansible_host=10.10.2.4 ansible_user=fry ansible_python_interpreter=/usr/bin/python3
    daffy       ansible_host=10.10.2.5 ansible_user=zoidberg ansible_python_interpreter=/usr/bin/python3
    ```
    
0. Use the `ping` module in an **ad hoc command** to test that you added those hosts correctly! **See Lab 15, Step 10 for an example!**

0. Write a new playbook that uses `looneytunes` as hosts. Have your playbook do the following:
    - Create four new directories in each machine named `lennon`, `mccartney`, `starr`, and `harrison`. **Use the file module.** Can you accomplish this with a single task?
    - Download the `downloadme.txt` file located at the following address and save it to the `~/lennon` directory you just made on each machine. **Use the get_url module.**
        - `https://raw.githubusercontent.com/csfeeser/ansible_essentials/main/data/downloadme.txt`

**BONUS-** Use the **replace module** (lab 24) to replace the string `PLACEHOLDER` in the downloadme.txt file with your own name!

```yaml
    - name: find/replace all strings
      replace:
        path: wherever/the/file/is/located
        regexp: "string I am looking for"
        replace: "string I am replacing it with"
        backup: yes
      become: true
```

<!--
## SOLUTION

```yaml
- name: challenge solution
  hosts: looneytunes
  connection: ssh
  gather_facts: no

  tasks:

    - name: Create a directory if it does not exist
      file:
        path: challenge
        state: directory

    - name: Download file
      get_url:
        url: https://raw.githubusercontent.com/csfeeser/ansible_essentials/main/data/downloadme.txt
        dest: challenge/downloadme.txt
        force: false

    - name: make a copy
      copy:
          src: challenge/downloadme.txt
          dest: challenge/downloadme_edit.txt
          force: no  # it doesn't matter if the content is changed, only if the file exists
          remote_src: yes

    - name: swap PLACEHOLDER for Chad
      replace:
        path: challenge/downloadme_edit.txt
        regexp: 'PLACEHOLDER'
        replace: 'Chad'
```
