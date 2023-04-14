# Playbook to Role Conversion


<img src="https://github.com/csfeeser/ansible_essentials/blob/main/data/ansiblebaby.jpg?raw=true" width="300"/>


Below you will find a familiar looking playbook. YOUR GOAL is to:
- Convert the playbook below into a role
- Call your newly created role from a second playbook.

1. First, create your new role's directory structure

    `student@bchd:~/.ansible/roles$` `mkdir -p ~/.ansible/roles && ansible-galaxy init ~/.ansible/roles/challenge`
    
0. Move into your new role.

    `student@bchd:~/.ansible/roles$` `cd ~/.ansible/roles/challenge`

0. If you haven't yet, install the `tree` application, it can really help!

    `student@bchd:~/.ansible/roles$` `sudo apt install tree -y`
    
0. Use the `tree` application to get a better visual of the role you created.

    `student@bchd:~/galaxy/roles/challenge$` `tree ~/.ansible/roles/challenge`

0. The goal is to take the playbook below and convert it into a role structure. Here are some hints on what to do:
   - You will need to edit `vars/main.yml` and `tasks/main.yml`. Cut and paste!
   - You will also need to put `ship.cfg.j2` into the `templates` directory! (below)
       ```
       #Description of  Prof. Farnsworth's ship

        Intergalactic Ship Registration:

          name: {{ ship_name }}
          type: {{ ship_type  }}

          engines:

            type: {{ engines }}
              max capacity: {{ dark_matter_balls }}
            backup: {{ backup_engines }}
       ```
    - All other directories in your role can be removed if you wish. Happy cut/pasting!

0. When you feel you've successfully created the role, try and run it from a playbook! Click the dropdown if you need an example of how this is done.

<details>
<summary>Playbook calling a Role</summary>
<br>

```yaml
---
- name: executing a role
  hosts: zoidberg
  gather_facts: yes
  become: true

  roles:
    - challenge
```

</details>

### CONVERT THE PLAYBOOK BELOW INTO A ROLE!

```yaml
---
- name: Exploring the template module and jinja expressions
  hosts: planetexpress
  gather_facts: no

  vars:
    ship_name: Bessie
    ship_type: Intergalactic
    engines: Dark Matter
    dark_matter_balls: 63
    backup_engines: Chemical

  tasks:
    - name: Configure spaceship registration
      template:  
        src: templates/ship.cfg.j2
        dest: ~/ship.cfg   
```
