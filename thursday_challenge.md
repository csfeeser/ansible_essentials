# Thursday Morning Challenge

<img src="https://geekflare.com/wp-content/uploads/2021/10/minecraft-hosting-vultr.png" width="500"/>



Good morning! Today's challenge will involve the following concepts from yesterday:

- error handling
- handlers
- vars_prompt

Below is a snippet of tasks taken from the [Minecraft role](https://galaxy.ansible.com/rzfeeser/ansible_role_minecraft) we looked at yesterday. Please make the following improvements:

1. Add a `rescue` to the "Install apps for minecraft server" block. The action that the rescue takes is up to you.

0. The task "Restart fail2ban" is a conditional task... we only need this task to run if a change to the app `fail2ban` has occurred. Change this task to a handler that is notified by the task "Copy fail2ban (ssh protection)".

0. The variable `mc_server_link` is not defined in this playbook. It's not an ideal use of the tool, but pass the url for this variable as a `vars_prompt`. The url is `https://launcher.mojang.com/v1/objects/3cf24a8694aca6267883b17d934efacc5e44440d/server.jar`

0. Add some tags! You may wish to use them in a practical manner while troubleshooting this playbook. 

```yaml
---
- name: Thursday morning challenge
  hosts: bender
  connection: ssh
  gather_facts: no
  become: yes

  tasks:

  - name: Install apps for minecraft server
    block:
        - name: Install additional apps via apt
          apt:
            name:
                    - vim
                    - fail2ban
            state: present

  - name: Copy fail2ban (ssh protection)
    copy:
      content: "get off my dang server"
      dest: /etc/fail2ban/jail.conf

  - name: Restart fail2ban
    service:
      name: fail2ban
      state: restarted

  - name: Download minecraft server
    get_url:
      url: "{{ mc_server_link }}"
      dest: ~/minecraft/minecraft_server.jar
```

<!--
### SOLUTION

```yaml
---
- name: Thursday morning challenge
  hosts: bender
  connection: ssh
  gather_facts: yes
  become: yes

  handlers:

  - name: Restart fail2ban
    service:
      name: fail2ban
      state: restarted

  vars_prompt:
  - name: mc_server_link
    prompt: "What is the URL to the latest minecraft server?"
    private: no
    default: https://launcher.mojang.com/v1/objects/3cf24a8694aca6267883b17d934efacc5e44440d/server.jar

    # not part of the challenge, but this is how to pass a second var from vars_prompt
  - name: user
    prompt: What is your name?
    private: no

  tasks:

  - debug:
      var: user

  - name: Install apps for minecraft server
    block:
        - name: Install additional apps via apt
          apt:
            name:
                    - vim
                    - fail2ban
            state: present

    rescue:
        - fail:
            msg: "Something went wrong when installing these packages!"

  - name: Copy fail2ban (ssh protection)
    copy:
      content: "get off my dang server"
      dest: /etc/fail2ban/jail.conf
    notify:
        - Restart fail2ban

  - name: Add a directory
    ansible.builtin.file:
      path: "/home/{{ ansible_user }}/minecraft"
      state: directory

  - name: Download minecraft server
    get_url:
      url: "{{ mc_server_link }}"
      dest: "/home/{{ ansible_user }}/minecraft/minecraft_server.jar"
```
-->
