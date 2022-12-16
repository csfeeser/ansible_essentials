# Day 5 Morning Warmup

<img src="https://geekflare.com/wp-content/uploads/2021/10/minecraft-hosting-vultr.png" width="500"/>

Good morning! Today's warmup will involve the following concepts from yesterday:

- error handling
- Ansible-Vault

**Below is playbook that automates installing a Minecraft server on an Ubuntu host! Minecraft is an internationally popular video game that allows players of all ages to get together online and build whatever they want! But installing/maintaining a Minecraft server can be a pain... Ansible to the rescue!**

Please make the following improvements to this playbook:

1. Add a `rescue` to the "Install apps for minecraft server" block. Have one of the rescue tasks uninstall the applications. Then have a second rescue task throw an intentional error announcing that the apps have been uninstalled.

0. The variable `mc_server_link` is defined in the play vars. While it's not exactly something that needs secured, let's do it anyway! Use Ansible-Vault to save the url as an encrypted string.

0. **OPTIONAL-** The task "Restart fail2ban" is a conditional task... we only need this task to run if a change to the app `fail2ban` has occurred. Change this task to a handler that is notified by the task "Copy fail2ban (ssh protection)".


```yaml
---
- name: Thursday morning challenge
  hosts: bender
  connection: ssh
  gather_facts: no
  become: yes

  vars:
    mc_server_link: https://piston-data.mojang.com/v1/objects/c9df48efed58511cdd0213c56b9013a7b5c9ac1f/server.jar
    
  tasks:

  - name: Install apps for minecraft server
    block:
        - name: Install additional apps via apt
          apt:
            name:
               - fail2ban # enables the linux host to ban IPs with suspicious SSH activity
            state: present

  - name: Copy fail2ban (ssh protection)
    copy:
      content: "get off my dang server"
      dest: /etc/fail2ban/jail.conf

  - name: Restart fail2ban
    service:
      name: fail2ban
      state: restarted

  - name: Add a directory
    file:
      path: "/home/{{ ansible_user }}/minecraft"
      state: directory
      
  - name: Download minecraft server
    get_url:
      url: "{{ mc_server_link }}"
      dest: /home/{{ ansible_user }}/minecraft/minecraft_server.jar
```
