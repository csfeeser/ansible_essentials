
# Broken Playbook Challenge: Minecraft Mayhem!

<img src="https://geekflare.com/wp-content/uploads/2021/10/minecraft-hosting-vultr.png" width="500"/>

This troubleshooting challenge will involve the following concepts:

- Error handling
- Blocks and rescue
- Handlers
- Tags

Below is a playbook that prepares an Ubuntu host to run a Minecraft server! Unfortunately, the administrator who wrote this playbook made several mistakes. Some will cause the playbook to fail outright, while others will cause it to behave differently than intended.

Your job is to troubleshoot the playbook, not add new features!

Start with a quick reset of planetexpress.

`student@bchd:~$` `bash ~/px/scripts/full-setup.sh`

#### GOAL: The playbook should accomplish the following:

1. Install Java and Fail2ban on zoidberg.
2. If the application installation fails, uninstall both applications and intentionally fail the playbook with a message explaining what happened.
3. Configure Fail2ban to protect SSH connections.
4. Restart Fail2ban ONLY when its configuration changes.
5. Create a Minecraft directory in the remote user's home directory.
6. Download the Minecraft server JAR file into that directory.
7. Allow administrators to selectively run portions of the playbook using the following tags:
   - `install` - Install applications.
   - `security` - Configure Fail2ban.
   - `minecraft` - Create the directory and download the server.

Use vim to create a playbook file of your choosing and enter the following. Then test, fix, repeat!

### Debugging tip: Not every error will generate a red error message! A playbook that executes successfully isn't necessarily a playbook that does what it is supposed to do. Refer to the goals above to make sure the playbook behaves as intended.

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

    - name: Install applications
      tags: install
      block:

        - name: Update apt cache
          apt:
            update_cache: yes

        - name: Install apps for Minecraft server
          apt:
            name:
              - default-jre-headless
              - fail2ban
            state: present
          ignore_errors: yes

      rescue:

        - name: Uninstall applications
          apt:
            name:
              - default-jre-headless
              - fail2ban
            state: present

        - name: Announce installation failure
          debug:
            msg: "Installation failed! Applications have been uninstalled."

    - name: Setup fail2ban (SSH protection)
      tags: minecraft
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
      tags: security
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
        state: started
```

#### Verify your work!

1. Run your playbook in its entirety. Does it complete successfully?

2. Run your playbook a second time. Does the Fail2ban handler execute even though nothing has changed?

3. Change the `bantime` value in your playbook and run it again. Does the handler execute?

4. Use the `--list-tasks` and `--tags` options to confirm that each tag targets the appropriate tasks.

    ```
    ansible-playbook challenge.yml --tags security --list-tasks
    ```

5. Temporarily add a nonexistent package to the list of applications being installed. Run the playbook with the `install` tag. Does the rescue block execute? Are the applications uninstalled? Does the playbook report a failure?

6. Remove the nonexistent package and run the entire playbook again to restore the Minecraft server environment.

<details>
<summary>Click here for the solution!</summary>
<br>

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

    - name: Install applications
      tags: install
      block:

        - name: Update apt cache
          apt:
            update_cache: yes

        - name: Install apps for Minecraft server
          apt:
            name:
              - default-jre-headless
              - fail2ban
            state: present
          # FIX: Removed ignore_errors. Ignoring an error
          # prevents that error from triggering the rescue block.

      rescue:

        - name: Uninstall applications
          apt:
            name:
              - default-jre-headless
              - fail2ban
            state: absent
            # FIX: "present" installs packages.
            # "absent" uninstalls packages.

        - name: Announce installation failure
          fail:
            msg: "Installation failed! Applications have been uninstalled."
          # FIX: The debug module only displays a message.
          # The fail module displays a message AND intentionally
          # causes the playbook to fail.

    - name: Setup fail2ban (SSH protection)
      tags: security
      # FIX: This block configures security, not Minecraft.
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
          # FIX: The notify value must match the handler's
          # name (or its listen topic).

        - name: Ensure fail2ban is running
          service:
            name: fail2ban
            state: started
            enabled: yes

    - name: Download Minecraft server JAR file
      tags: minecraft
      # FIX: This block prepares Minecraft, not security.
      block:

        - name: Add a directory
          file:
            path: "/home/{{ ansible_user }}/minecraft"
            state: directory
          become: no

        - name: Download Minecraft server
          get_url:
            url: "{{ mc_server_link }}"
            # FIX: get_url uses the "url" parameter, not "src".
            dest: "/home/{{ ansible_user }}/minecraft/minecraft_server.jar"
          become: no

  handlers:

    - name: Restart fail2ban
      service:
        name: fail2ban
        state: restarted
        # FIX: "started" ensures the service is running but
        # does nothing if it is already running.
        # "restarted" restarts the service, allowing it to
        # load the updated configuration.
```

</details>
