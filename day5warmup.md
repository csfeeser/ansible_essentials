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

### "SOLUTION"

- password is "asdf" for the ansible vault variable.

```
---
- name: Thursday morning challenge
  hosts: fry
  connection: ssh
  gather_facts: no
  become: yes

  vars:
    mc_server_link: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          63326332386336666236623738623965333537343930313336653331306362393636353531633233
          6336366137633230613536363030363038346662306536330a343236656539643365303764613461
          32656630653237336232353263353239363665313436303133346132376266643833393236663966
          6361613630626136320a653438303364353232336565353732633039336236366263343137636366
          64666266316666313436626233666635613866316562363832306635393436373939383030616238
          32633137626161643836323836366131336235343461343037663163636136363630363764306230
          64396235653535393364613534366530613465303130303730353139646631626238626138353866
          36316532346366323636356164306565303236633765643562663861393037373063303365666465
          3363

  tasks:

  - name: Install apps for minecraft server
    block:
        - name: Install additional apps via apt
          apt:
            name:
               - fail2ban # enables the linux host to ban IPs with suspicious SSH activity
            state: present
    rescue:
      - name: first
        apt:
          name: fail2ban
          state: absent
      - name: second
        fail:
          msg: "Error in installing application! Uninstalled, exiting..."


  - name: Copy fail2ban (ssh protection)
    copy:
      content: "get off my dang server"
      dest: jail.conf
    notify:
      - Restart fail2ban

  - name: Add a directory
    file:
      path: "/home/{{ ansible_user }}/minecraft"
      state: directory

  - name: Download minecraft server
    get_url:
      url: "{{ mc_server_link }}"
      dest: /home/{{ ansible_user }}/minecraft/minecraft_server.jar

  handlers:

  - name: Restart fail2ban
    service:
      name: fail2ban
      state: restarted
```
