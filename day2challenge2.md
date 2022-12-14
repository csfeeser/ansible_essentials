## Morning Warmup, Day Three!

<img src="https://miro.medium.com/max/1200/1*sssWakAf5erMGDqt9GACVA.jpeg" width="300"/>

The following will give you a chance to write some new code that uses techniques you've learned in class so far!

1. We'll be using the planetexpress team for this warmup! Run the command below to prepare your environment.

    `student@bchd:~$` `bash ~/px/scripts/full-setup.sh`

0. Edit your inventory file (`~/mycode/inv/dev/hosts`). **Add/append** the following to it (do not remove anything from your inventory file):

    ```
    [looneytunes]
    bugs        ansible_host=10.10.2.3 ansible_user=bender ansible_python_interpreter=/usr/bin/python3
    taz         ansible_host=10.10.2.4 ansible_user=fry ansible_python_interpreter=/usr/bin/python3
    daffy       ansible_host=10.10.2.5 ansible_user=zoidberg ansible_python_interpreter=/usr/bin/python3
    ```
    
0. Use the `ping` module in an **ad hoc command** to test that you added those hosts correctly! **See Lab 15, Step 11!**

0. Write a new playbook that uses `looneytunes` as hosts. Have your playbook do the following:
    - Create a new directory in each machine called `challenge`. **Use the file module.**
    - Download the `downloadme.txt` file located at the following address and save it to the `~/challenge` directory you just made on each machine. **Use the get_url module.**
        - `https://raw.githubusercontent.com/csfeeser/ansible_essentials/main/data/downloadme.txt`

**BONUS-** Use the **replace module** (lab 24) to replace the string `PLACEHOLDER` in the downloadme.txt file with your own name!

## SOLUTION:

```yaml
- name: Play- grab a file online
  hosts: looneytunes
  connection: ssh
  gather_facts: no

  tasks:
  - name: create a chaCancelllenge directory
    file:
      name: challenge
      state: directory

  - name: downloading downloadme.txt
    get_url:
      url: https://raw.githubusercontent.com/csfeeser/ansible_essentials/main/data/downloadme.txt
      dest: challenge

  - name: swap out PLACEHOLDER for "Chad"
    replace:
      path: ~/challenge/downloadme.txt
      regexp: "PLACEHOLDER"
      replace: "Chad"
      backup: yes
```

### IDEMPOTENT SOLUTION

```yaml
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
