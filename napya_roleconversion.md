# Playbook to Role Conversion

<img src="https://github.com/csfeeser/ansible_essentials/blob/main/data/ansiblebaby.jpg?raw=true" width="300"/>

### GOAL:
- Convert the playbook below into a role.
- Call your newly created role from a second playbook.

1. First, let's reset any changes we've made to any of our Ansible inventories, configs, and whatnot.

    `student@bchd:~$` `bash ~/px/scripts/full-setup.sh`
   
0. Now create your new role's directory structure. We're naming the role `challenge`.

    `student@bchd:~/.ansible/roles$` `mkdir -p ~/.ansible/roles && ansible-galaxy init ~/.ansible/roles/challenge`
    
0. Move into your new role directory.

    `student@bchd:~/.ansible/roles$` `cd ~/.ansible/roles/challenge`

0. If you haven't yet, install the `tree` application, it can really help!

    `student@bchd:~/.ansible/roles$` `sudo apt install tree -y`
    
0. Use the `tree` application to get a better visual of the role you created.

    `student@bchd:~/galaxy/roles/challenge$` `tree ~/.ansible/roles/challenge`

0. The goal is to take the playbook below and convert it into a role structure. Here are some hints on what to do:
   - You will need to edit `vars/main.yml` and `tasks/main.yml`. Cut and paste!
   - For this basic role, you won't need any other directories besides `var` and `tasks`.
   - Remember that play keywords like `hosts`, `connection`, `gather_facts`, `become`, `become_method`, and the `name` of the play DO NOT belong in roles!
   - If you'd like to see what the inside of a role looks like, check out the [Minecraft server setup role](https://github.com/rzfeeser/ansible-role-minecraft) we looked at the other day!
     
    ```yaml
    ---
    - name: Arista playbook that triggers failure
      hosts: arista_switches
      connection: network_cli
      become: yes
      become_method: enable
      gather_facts: no

      vars:
        ansible_ssh_pass: alta3
        current_os: eos  

      tasks: 
        - name: Back up current running config
          arista.eos.eos_config:
            backup: yes
          register: results
          when: ansible_network_os == "{{ current_os }}"

        - name: Block of change modifications to our switch
          block:
            - name: configure the login banner
              arista.eos.eos_banner:
                banner: login
                text: |
                  this is my login banner
                  that contains a multiline
                  string
                  if this works correctly
                  we should never see the banner because the
                  config will be rolled back by our rescue
                state: present

            - name: trigger a failure (to prompt rescue)
              shell: "/bin/false"

          rescue:
            - name: load configuration from file
              arista.eos.eos_config:
                src: "{{ results.backup_path }}"
                replace: config

          always:
            - name: Some task you "ALWAYS" want to perform
              debug:
                msg: "An ALWAYS task might be the mail module, to send an email to engineers or logging indicating a job just ran and its status."
    ```

0. When you feel you've successfully created the role, try and run it from a playbook! Click the dropdown if you need an example of how this is done.

<details>
<summary>Playbook calling a Role</summary>
<br>

```yaml
---
- name: executing a role
  hosts: arista_switches
  connection: network_cli
  become: yes
  become_method: enable
  gather_facts: no

  roles:
    - challenge
```

</details>

<details>
<summary>Steps to create necessary files for the role</summary>
<br>

1. Create the `vars/main.yml` file and add the necessary variables:

    `student@bchd~$` `vim ~/.ansible/roles/challenge/vars/main.yml`

    ```yaml
    ---
    ansible_ssh_pass: alta3
    current_os: eos
    ```

0. Create the `tasks/main.yml` file and add the tasks:

    `student@bchd~$` `vim ~/.ansible/roles/challenge/tasks/main.yml`

    ```yaml
    ---
    - name: Back up current running config
      arista.eos.eos_config:
        backup: yes
      register: results
      when: ansible_network_os == "{{ current_os }}"

    - name: Block of change modifications to our switch
      block:
        - name: configure the login banner
          arista.eos.eos_banner:
            banner: login
            text: |
              this is my login banner
              that contains a multiline
              string
              if this works correctly
              we should never see the banner because the
              config will be rolled back by our rescue
            state: present

        - name: trigger a failure (to prompt rescue)
          shell: "/bin/false"

      rescue:
        - name: load configuration from file
          arista.eos.eos_config:
            src: "{{ results.backup_path }}"
            replace: config

      always:
        - name: Some task you "ALWAYS" want to perform
          debug:
            msg: "An ALWAYS task might be the mail module, to send an email to engineers or logging indicating a job just ran and its status."
    ```

</details>
