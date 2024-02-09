# Playbook to Role Conversion


<img src="https://github.com/csfeeser/ansible_essentials/blob/main/data/ansiblebaby.jpg?raw=true" width="300"/>


### GOAL:
- Convert the playbook below into a role
- Call your newly created role from a second playbook.

1. First, create your new role's directory structure.

    `student@bchd:~/.ansible/roles$` `mkdir -p ~/.ansible/roles && ansible-galaxy init ~/.ansible/roles/challenge`
    
0. Move into your new role.

    `student@bchd:~/.ansible/roles$` `cd ~/.ansible/roles/challenge`

0. If you haven't yet, install the `tree` application, it can really help!

    `student@bchd:~/.ansible/roles$` `sudo apt install tree -y`
    
0. Use the `tree` application to get a better visual of the role you created.

    `student@bchd:~/galaxy/roles/challenge$` `tree ~/.ansible/roles/challenge`

0. The goal is to take the playbook below and convert it into a role structure. Here are some hints on what to do:
   - You will need to edit `vars/main.yml` and `tasks/main.yml`. Cut and paste!
   - For this basic role you won't need any other directories besides `var` and `tasks`.
   - Remember that play keywords like `hosts`, `connection`, `gather_facts`, and the `name` of the play DO NOT belong in roles!
   - If you'd like to see what the inside of a role looks like, check out the [Minecraft server setup role](https://github.com/rzfeeser/ansible-role-minecraft) we looked at the other day!
     
    ```yaml
    ---
    - name: Friday Warmup
      hosts: localhost
      connection: local
      gather_facts: no
      
      vars:
        file_content: "It's Friday!!! Happy Ansiblin'!"
        file_path: "/tmp/friday_dir/"
        file_name: "friday_file.txt"
        
      tasks:
        - name: Ensure /tmp/friday_dir/ exists
          ansible.builtin.file:
            path: "{{ file_path }}"
            state: directory
    
        - name: Create a file in /tmp/friday_dir with content from a variable
          ansible.builtin.copy:
            dest: "{{ file_path }}{{ file_name }}"
            content: "{{ file_content }}"
    
        - name: Display the content of the file
          ansible.builtin.command:
            cmd: "cat {{ file_path }}{{ file_name }}"
          register: cat_output
    
        - name: Show file content
          ansible.builtin.debug:
            msg: "The file content is: '{{ cat_output.stdout }}'"
    ```


0. When you feel you've successfully created the role, try and run it from a playbook! Click the dropdown if you need an example of how this is done.

<details>
<summary>Playbook calling a Role</summary>
<br>

```yaml
---
- name: executing a role
  hosts: localhost
  connection: local
  gather_facts: no

  roles:
    - challenge
```

</details>
