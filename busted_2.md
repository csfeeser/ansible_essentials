
# Troubleshooting Challenge: Minecraft Mayhem!

<img src="https://geekflare.com/wp-content/uploads/2021/10/minecraft-hosting-vultr.png" width="500"/>

This troubleshooting challenge will involve the following concepts:

- Error handling
- Handlers
- Tags
- Variable precedence

Below is a playbook that prepares an Ubuntu host to run a Minecraft server! Unfortunately, there are a handful of errors preventing it from working correctly. Your job is to find and fix them!

Start with a quick reset of planetexpress.

`student@bchd:~$` `bash ~/px/scripts/full-setup.sh`

Use vim to create the following playbook.

`student@bchd:~$` `vim ~/mycode/minecraft.yml`

```yaml
---
- name: Minecraft debug challenge
  hosts: zoidberg
  connection: ssh
  gather_facts: no
  become: yes

  vars:
    mc_server_link: https://piston-data.mojang.com/v1/objects/c9df48efed58511cdd0213c56b9013a7b5c9ac1f/server.jar

    mc_packages:
      - default-jre-headless
      - fail2ban

  tasks:

    - name: Install applications
      tags: install
      block:

        - name: Update apt cache
          apt:
            update_cache: yes

        - name: Install apps for Minecraft server
          apt:
            name: "{{ minecraft_packages }}"
            state: present

      rescue:

        - name: Uninstall applications
          apt:
            packages_to_remove:
              - default-jre-headless
              - fail2ban
            state: absent

        - name: Announce installation failure
          fail:
            message: "Installation failed! Applications have been uninstalled."

    - name: Setup fail2ban (SSH protection)
      tags: security
      block:

        - name: Configure fail2ban
          copy:
            dest: /etc/fail2ban/jail.local
            content: |
              [sshd]
              enabled = true
              backend = systemd
              bantime = 20000
          notify: Restart SSH

        - name: Ensure fail2ban is running
          service:
            name: fail2ban
            state: started
            enabled: yes

    - name: Download Minecraft server JAR file
      tags: minecraft
      block:

        - name: Add a directory
          file:
            path: "/home/{{ ansible_user }}/minecraft"
            state: directory
          become: no

        - name: Download Minecraft server
          get_url:
            src: "{{ mc_server_link }}"
            dest: "/home/{{ ansible_user }}/minecraft/minecraft_server.jar"
          become: no

  handlers:

    - name: Restart fail2ban
      service:
        name: fail2ban
        state: restarted
```

#### Challenge 1: Fix the playbook!

Run the playbook.

`student@bchd:~$` `ansible-playbook ~/mycode/minecraft.yml`

Read the error messages, make corrections, and run the playbook again. Repeat this process until the playbook executes successfully.

### Debugging tip: Focus on one error at a time! Ansible's error messages often tell you exactly what is wrong, which parameters are supported, and where in the playbook the error occurred.

#### Challenge 2: Test the error handling!

Just because the playbook runs successfully doesn't mean every task works! Remember that tasks within a rescue section only execute if a task within the associated block fails.

Let's intentionally cause the installation to fail by overriding the `mc_packages` variable with the name of a nonexistent package.

`student@bchd:~$` `ansible-playbook ~/mycode/minecraft.yml --tags install -e 'mc_packages=["this-package-definitely-does-not-exist"]'`

There may be additional errors hiding in the rescue section. Find and fix them!

You will know you have successfully repaired the rescue section when the uninstall task completes successfully and the following intentional error message appears:

```
Installation failed! Applications have been uninstalled.
```

#### Challenge 3: Restore the Minecraft server!

Now that you've successfully tested the error handling, run the playbook normally one final time.

`student@bchd:~$` `ansible-playbook ~/mycode/minecraft.yml`

If the playbook executes without errors, congratulations! You've completed the challenge!

<details>
<summary>Click here for the solution!</summary>
<br>

```yaml
---
- name: Minecraft debug challenge
  hosts: zoidberg
  connection: ssh
  gather_facts: no
  become: yes

  vars:
    mc_server_link: https://piston-data.mojang.com/v1/objects/c9df48efed58511cdd0213c56b9013a7b5c9ac1f/server.jar

    mc_packages:
      - default-jre-headless
      - fail2ban

  tasks:

    - name: Install applications
      tags: install
      block:

        - name: Update apt cache
          apt:
            update_cache: yes

        - name: Install apps for Minecraft server
          apt:
            name: "{{ mc_packages }}"
            # FIX: The variable is named mc_packages,
            # not minecraft_packages.
            state: present

      rescue:

        - name: Uninstall applications
          apt:
            name:
              # FIX: packages_to_remove is not a valid
              # parameter for the apt module.
              - default-jre-headless
              - fail2ban
            state: absent

        - name: Announce installation failure
          fail:
            msg: "Installation failed! Applications have been uninstalled."
            # FIX: The fail module uses msg, not message.

    - name: Setup fail2ban (SSH protection)
      tags: security
      block:

        - name: Configure fail2ban
          copy:
            dest: /etc/fail2ban/jail.local
            content: |
              [sshd]
              enabled = true
              backend = systemd
              bantime = 20000
          notify: Restart fail2ban
          # FIX: The notify value must match the name
          # of an existing handler.

        - name: Ensure fail2ban is running
          service:
            name: fail2ban
            state: started
            enabled: yes

    - name: Download Minecraft server JAR file
      tags: minecraft
      block:

        - name: Add a directory
          file:
            path: "/home/{{ ansible_user }}/minecraft"
            state: directory
          become: no

        - name: Download Minecraft server
          get_url:
            url: "{{ mc_server_link }}"
            # FIX: The get_url module uses url, not src.
            dest: "/home/{{ ansible_user }}/minecraft/minecraft_server.jar"
          become: no

  handlers:

    - name: Restart fail2ban
      service:
        name: fail2ban
        state: restarted
```

</details>
