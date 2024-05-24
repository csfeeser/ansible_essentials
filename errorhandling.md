# Friday Morning Challenge

<img src="https://geekflare.com/wp-content/uploads/2021/10/minecraft-hosting-vultr.png" width="500"/>

Good morning! Today's challenge will involve the **error handling** concepts we learned yesterday with `block` and `rescue`!

**Below is playbook that (partially) automates installing a Minecraft server on an Ubuntu host! Minecraft is an internationally popular video game that allows players of all ages to get together online and build whatever they want! But installing/maintaining a Minecraft server can be a pain... Ansible to the rescue!**

Start with a quick reset of planetexpress.

`student@bchd:~$` `bash ~/px/scripts/full-setup.sh`

#### Please make the following improvements to this playbook:

1. Add a `rescue` to the "Install apps for minecraft server" block.
    - Have one of the rescue tasks uninstall the applications as part of the recovery process.
    - Then have a second rescue task throw an intentional error announcing that the apps have been uninstalled, thus ending the play.
    - Confirm your rescue works by using this command: `ansible-playbook ~/mycode/friday_warmup.yml -e "pkg_list=['fail2ban','thispackageisntreal']"`
2. Add a `rescue` to the "Setup fail2ban (ssh protection)" block.
    - Have one of the rescue tasks uninstall the applications as part of the recovery process.
    - Then have a second rescue task throw an intentional error announcing that the apps have been uninstalled, thus ending the play.
    - Confirm your rescue works by using this command: `ansible-playbook ~/mycode/friday_warmup.yml -e "config_file_loc='/not/a/real/file/location'"`      

Create the playbook as written below, then get to applying the goals above!

`student@bchd:~$` `vim ~/mycode/friday_warmup.yml`

```yaml
---
- name: Thursday morning challenge
  hosts: zoidberg
  connection: ssh
  gather_facts: no
  become: yes

  vars:
    pkg_list:
      - fail2ban
    config_file_loc: "/etc/fail2ban/jail.conf"

  tasks:

  - name: install apps
    block:
        - name: Update apt cache
          apt:
            update_cache: yes

        - name: Install apps for minecraft server
          apt:
            name: "{{ pkg_list }}"
            state: present

  - name: Setup fail2ban (ssh protection)
    block:
        - name: Copy fail2ban
          copy:
            src: "{{ config_file_loc }}"
            dest: /etc/fail2ban/jail.local
            remote_src: true

        - name: Update fail2ban policy
          lineinfile:
            dest: /etc/fail2ban/jail.local
            regexp: "^bantime  = 600$"
            line: "bantime  = 20000"
```

<details>
<summary>Click here to see the solution!</summary>
```yaml
---
- name: Thursday morning challenge
  hosts: zoidberg
  connection: ssh
  gather_facts: no
  become: yes

  vars:
    pkg_list:
      - fail2ban
    config_file_loc: "/etc/fail2ban/jail.conf"

  tasks:

  - name: install apps
    block:
        - name: Update apt cache
          apt:
            update_cache: yes

        - name: Install apps for minecraft server
          apt:
            name: "{{ pkg_list }}"
            state: present
    rescue:                           ### NEW!
        - name: uninstall apps
          apt:
            name: "{{ pkg_list }}"
            state: absent
        - name: force a failure
          fail:
            msg: Apps failed to install correctly. Uninstalling...

  - name: Setup fail2ban (ssh protection)
    block:
        - name: Copy fail2ban
          copy:
            src: "{{ config_file_loc }}"
            dest: /etc/fail2ban/jail.local
            remote_src: true

        - name: Update fail2ban policy
          lineinfile:
            dest: /etc/fail2ban/jail.local
            regexp: "^bantime  = 600$"
            line: "bantime  = 20000"
    rescue:                              ### NEW
        - name: uninstall apps
          apt:
            name: "{{ pkg_list }}"
            state: absent
        - name: force a failure
          fail:
            msg: Apps failed to configure correctly. Uninstalling...
```
