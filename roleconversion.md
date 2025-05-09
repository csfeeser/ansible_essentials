# Playbook to Role Conversion


<img src="https://raw.githubusercontent.com/csfeeser/ansible_essentials/refs/heads/main/ansiblememe.png" width="400"/>


Below you will find a familiar looking playbook. YOUR GOAL is to:
- Convert the playbook below into a role
- Call your newly created role from a second playbook.

1. Let's first restart our nodes and Ansible files.

    `student@bchd:~$` `bash ~/px/scripts/full-setup.sh`

0. Create a directory for your role to be stored in.

    `student@bchd:~$` `mkdir -p ~/galaxy/roles/`
    
0. Create your new role's directory structure.

    `student@bchd:~$` `ansible-galaxy init ~/galaxy/roles/challenge`
    
0. Move into your new role.

    `student@bchd:~$` `cd ~/galaxy/roles/challenge`

0. If you haven't yet, install the `tree` application, it can really help!

    `student@bchd:~/galaxy/roles/challenge$` `sudo apt install tree -y`
    
0. Use the `tree` application to get a better visual of the role you created.

    `student@bchd:~/galaxy/roles/challenge$` `tree`
    
0. Update your ansible.cfg file so that it knows to look in this directory to find/use your role!

    `student@bchd:~/galaxy/roles/challenge$` `echo -e "\nroles_path=~/galaxy/roles/" >> ~/.ansible.cfg`
    
0. We need a file named `index.html` for this playbook to work! Run the following command:

    `echo "Hello world!" > ~/galaxy/roles/challenge/files/index.html`

0. Here's a hint: you will need to edit `vars/main.yml`, `tasks/main.yml`, and `handlers/main.yml`. All other directories in your role can be removed if you wish. Happy cut/pasting!

0. When you feel you've successfully created the role, try and run it on `zoidberg`! Click the dropdown if you need an example of how this is done.

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
- name: Apache server installed
  hosts: web
  gather_facts: no
  become: yes

  vars:
    pkgs:
     - apache2
     - mariadb-server
     - mariadb-client
  
  tasks:

  # the package module tries to select
  # yum or apt or pkg5 (etc) automatically
  - name: latest Apache version installed
    package:
      name: "{{ pkgs }}"
      state: latest
    notify:
      - restart_apache

  - name: Apache enabled and running
    service:
      name: apache2
      enabled: yes
      state: started

  # Copy index.html into the service
  - name: copy index.html
    copy:
      src: index.html
      dest: /var/www/html/

  - name: Download a copy of apache2.conf
    get_url:
      url: https://raw.githubusercontent.com/rzfeeser/alta3files/master/apache2.conf
      dest: /etc/apache2/
    notify:
        - restart_apache   # ONLY restart apache if this conf
                           # file needs updated

  # This will ONLY run if the notifying task runs yellow
  handlers:
  - name: restart_apache
    service:
      name: apache2
      state: restarted
```

<details>
<summary>SOLUTION</summary>

First, make sure you've run all the steps at the beginning of the lab to initiate a role directory. Then you can run the following commands:

---

`vim ~/galaxy/roles/challenge/vars/main.yml`

```yaml
---
pkgs:
  - apache2
  - mariadb-server
  - mariadb-client
```
---

`vim ~/galaxy/roles/challenge/tasks/main.yml`

```yaml
---
- name: latest Apache version installed
  package:
    name: "{{ pkgs }}"
    state: latest
  notify:
    - restart_apache

- name: Apache enabled and running
  service:
    name: apache2
    enabled: yes
    state: started

- name: copy index.html
  copy:
    src: index.html
    dest: /var/www/html/

- name: Download a copy of apache2.conf
  get_url:
    url: https://raw.githubusercontent.com/rzfeeser/alta3files/master/apache2.conf
    dest: /etc/apache2/
  notify:
    - restart_apache
```

---

`vim ~/galaxy/roles/challenge/handlers/main.yml`

```yaml
---
- name: restart_apache
  service:
    name: apache2
    state: restarted
```

---

Then make a playbook calling the role and execute it.

`vim ~/mycode/role_challenge.yml`

```yaml
---
- name: executing a role
  hosts: zoidberg
  gather_facts: yes
  become: true

  roles:
    - challenge
```

`ansible-playbook ~/mycode/role_challenge.yml`

</details>
