# Playbook to Role Conversion

Below you will find a familiar looking playbook. YOUR GOAL is to:
- Convert the playbook below into a role
- Call your newly created role from a second playbook.

1. First, create a directory for your role to be stored in.

    `student@bchd:~$` `mkdir -p ~/galaxy/roles/`
    
0. First, create your new role's directory structure.

    `student@bchd:~$` `ansible-galaxy init ~/galaxy/roles/challenge`
    
0. Move into your new role.

    `student@bchd:~$` `cd ~/galaxy/roles/challenge`

0. Update your ansible.cfg file so that it knows to look in this directory to find/use your role!

    `student@bchd:~/galaxy/roles/challenge$` `echo "roles_path=~/galaxy/roles/" >> ~/.ansible.cfg`
2. If you haven't yet, install the `tree` application, it can really help!

    `student@bchd:~/galaxy/roles/challenge$` `sudo apt install tree -y`
    
0. We need a file named `index.html` for this playbook to work! Run the following command:

    `echo "Hello world!" > ~/galaxy/roles/challenge/files/index.html`

0. Here's a hint: you will need to edit `vars/main.yml`, `tasks/main.yml`, and `handlers/main.yml`. All other directories in your role can be removed if you wish. Happy cut/pasting!

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
  # if any of these services need installed or
  # updated, then they ALL get restarted
  - name: latest Apache version installed
    package:
      name: "{{ pkgs }}"
      state: latest
    notify:
      - restart_webservices

  - name: Apache enabled and running
    service:
      name: apache2
      enabled: yes
      state: started

  # Copy index.html into the service
  - name: copy index.html
    copy:
      src: index.html  # changed from previous lab
      dest: /var/www/html/

  # if dest is directory download every time
  # but only replace if destination is different
  # https://raw.githubusercontent.com/rzfeeser/
  #              alta3files/master/apache2.conf
  - name: Download a copy of apache2.conf
    get_url:
      url: https://raw.githubusercontent.com/rzfeeser/alta3files/master/apache2.conf
      dest: /etc/apache2/
    notify:
        - restart_apache   # ONLY restart apache if this conf
                           # file needs updated

  # ensure the MySQL service is up and running
  - name: MySQL (MariaDB) is running
    service:
      name: mysql
      enabled: yes
      state: started

  # if this line needs added to my.cnf
  # then ONLY the MySQL service needs restarted
  - name: Modify SQL conf file to listen on all interfaces
    lineinfile:
      dest: /etc/mysql/my.cnf
      regexp: "^bind-address"
      line: "bind-address=0.0.0.0"
    notify:
      - restart_mysql

  # This will ONLY run if the associated tasks run
  # no matter how many times called these tasks
  # will ONLY run once
  handlers:
  - name: restart_apache
    service:
      name: apache2
      state: restarted
    listen: restart_webservices

  ## this is new, restarts MySQL
  - name: restart_mysql
    service:
      name: mysql
      state: restarted
    listen: restart_webservices
```

