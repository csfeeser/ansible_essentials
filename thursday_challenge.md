# Thursday Morning Challenge

<img src="https://geekflare.com/wp-content/uploads/2021/10/minecraft-hosting-vultr.png" width="500"/>

Good morning! Today's challenge will involve the following concepts from yesterday:

- error handling
- handlers
- tags

**Below is playbook that automates installing a Minecraft server on an Ubuntu host! Minecraft is an internationally popular video game that allows players of all ages to get together online and build whatever they want! But installing/maintaining a Minecraft server can be a pain... Ansible to the rescue!**

Start with a quick reset of planetexpress.

`student@bchd:~$` `bash ~/px/scripts/full-setup.sh`

#### Please make the following improvements to this playbook:

1. Add a `rescue` to the "Install apps for minecraft server" block. Have one of the rescue tasks uninstall the applications. Then have a second rescue task throw an intentional error announcing that the apps have been uninstalled.

0. The task "Restart fail2ban" is a conditional task... we only need this task to run if a change to the app `fail2ban` has occurred. Change this task to a handler that is notified by the task "Copy fail2ban (ssh protection)".

0. Add some tags! You may wish to use them in a practical manner while troubleshooting this playbook. 

```yaml
---
- name: Thursday morning challenge
  hosts: zoidberg
  connection: ssh
  gather_facts: no
  become: yes

  vars:
    mc_server_link: https://piston-data.mojang.com/v1/objects/c9df48efed58511cdd0213c56b9013a7b5c9ac1f/server.jar

  tasks:

  - name: install apps
    block:
        - name: Update apt cache
          apt:
            update_cache: yes

        - name: Install apps for minecraft server
          apt:
            name: fail2ban
            state: present

  - name: Setup fail2ban (ssh protection)
    become: yes
    block:

        - name: Update sshd section in jail.local
          ansible.builtin.replace:
            path: /etc/fail2ban/jail.conf
            regexp: |
              (\[sshd\]\n\n# To use more aggressive sshd modes set filter parameter "mode" in jail.local:\n# normal \(default\), ddos, extra or aggressive \(combines all\).\n# See "tests/files/logs/sshd" or "filter.d/sshd.conf" for usage example and details.\n#mode   = normal\nport    = ssh\n)logpath = %\(sshd_log\)s\nbackend = %\(sshd_backend\)s
            replace: |
              \1backend=systemd
            backup: yes

        - name: Copy fail2ban
          copy:
            src: /etc/fail2ban/jail.conf
            dest: /etc/fail2ban/jail.local
            remote_src: true

        - name: Update fail2ban policy
          lineinfile:
            dest: /etc/fail2ban/jail.local
            regexp: "^bantime  = 600$"
            line: "bantime  = 20000"

  - name: Restart fail2ban
    service:
       name: fail2ban
       state: restarted

  - name: download minecraft server jar file
    block:
      - name: Add a directory
        file:
          path: "/home/{{ ansible_user }}/minecraft"
          state: directory

      - name: Download minecraft server
        get_url:
          url: "{{ mc_server_link }}"
          dest: /home/{{ ansible_user }}/minecraft/minecraft_server.jar
```
