## Morning Warmup, Day Three!

<img src="https://miro.medium.com/max/1200/1*sssWakAf5erMGDqt9GACVA.jpeg" width="300"/>

The following will give you a chance to write some new code that uses techniques you've learned in class so far!

1. We'll be using the planetexpress team for this warmup! Run the command below to prepare your environment.

    `student@bchd:~$` `bash ~/px/scripts/full-setup.sh`

0. Write a new playbook that uses `planetexpress` as hosts. Have your playbook do the following:
    - Create four new directories in each machine named `lennon`, `mccartney`, `starr`, and `harrison`. **Use the file module.** Can you accomplish this with a single task?
    
        <details>
        <summary>Help please!</summary>

        ```yaml
        - name: making directories!
          file:
            state: directory
            path: "{{ item }}"
          loop:
            - lennon
            - mccartney
            - starr
            - harrison
         ```

        </details>

    - Download the `downloadme.txt` file located at the following address and save it to the `~/lennon` directory you just made on each machine. **Use the get_url module.**
        - `https://raw.githubusercontent.com/csfeeser/ansible_essentials/main/data/downloadme.txt`

        <details>
        <summary>Help please!</summary>

        ```yaml
        - name: download downloadme.txt
          get_url:
            url: https://raw.githubusercontent.com/csfeeser/ansible_essentials/main/data/downloadme.txt
            dest: ~/lennon/downloadme.txt
            force: false
         ```

        </details>
        
    - Use the **replace module** (lab 26) to replace the string `PLACEHOLDER` in the downloadme.txt file with your own name!

        <details>
        <summary>Help please!</summary>

        ```yaml
        - name: find/replace all strings
          replace:
            path: ~/lennon/downloadme.txt
            regexp: "PLACEHOLDER"
            replace: "StudentName"
            backup: yes
          become: true
        ```
    
        </details>
        
<details>
<summary>FULL SOLUTION</summary>

```yaml
- name: day 3 solution
  hosts: planetexpress
  gather_facts: no
  connection: ssh

  tasks:

  - name: making directories!
    file:
      state: directory
      path: "{{ item }}"
    loop:
      - lennon
      - mccartney
      - starr
      - harrison

  - name: download downloadme.txt
    get_url:
      url: https://raw.githubusercontent.com/csfeeser/ansible_essentials/main/data/downloadme.txt
      dest: ~/lennon/downloadme.txt
      force: false

  - name: find/replace all strings
    replace:
      path: lennon/downloadme.txt
      regexp: "PLACEHOLDER"
      replace: "StudentName"
      backup: yes
    become: true
```

</details>
