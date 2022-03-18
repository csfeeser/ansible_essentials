# Friday Challenge

Today's challenges come straight from Adam! These are goals he recommended, so uh... blame him!

ADAM HAS CHARGED YOU TO BE ABLE TO DO THE FOLLOWING:
- Iterating through a loop in the YAML inventory (firewall whitelist with multiple services – ssh, http, https)
- Copying a file from the ansible repo to the remote host
- Copying an unmodified file as-is (test.txt)
- Copying a file and modifying it with a jinja2 template and a variable from the inventory (ntp server)

### Part 1

```yaml
all:
  hosts:
  children:
    planetexpress:
      hosts:
        bender:
          ansible_host: 10.10.2.3
          ansible_user: bender
        fry:
          ansible_host: 10.10.2.4
          ansible_user: fry
        zoidberg:
          ansible_host: 10.10.2.5
          ansible_user: zoidberg
        farnsworth:
          ansible_host: 10.10.2.6
          ansible_user: farnsworth
          ansible_python_interpreter: /usr/bin/python
      vars:
        ansible_python_interpreter: /usr/bin/python3
        ansible_ssh_pass: alta3
```

1. Create a new inventory file using the YAML above. 

0. Add variable `firewall_whitelist` shown below as a **group var** to the inventory above.

    ```yaml
    firewall_whitelist:
     - ssh
     - http
     - https
    ```

0. Create a short playbook that uses the above inventory. Here's a little bit to get you started:

    ```yaml
    - name: looping group vars
      hosts: planetexpress

      tasks:

      - name: permit traffic in default zone for https service
        ansible.posix.firewalld:
          service: https
          permanent: yes
          state: enabled
    ```

0. Edit this playbook so that we **loop** across the `firewall_whitelist` group var, feeding each firewall to the `service` parameter one at a time! [Read more about the firewalld module here!](https://docs.ansible.com/ansible/latest/collections/ansible/posix/firewalld_module.html)

## PART 2

Take your pick of any of the following for part 2!

#### Option 1

1. Copy a file from `bchd` (doesn't matter what file) to all hosts in `planetexpress` (doesn't matter where)

#### Option 2

1. Download the following template: `wget https://raw.githubusercontent.com/csfeeser/ansible_essentials/main/data/challenge_template.j2`

0. Using the template module, create a completed version of `challenge_template.j2` on all `planetexpress` hosts.

#### Option 3

1. The GitHub repo [https://github.com/csfeeser/mycode2](https://github.com/csfeeser/mycode2) has three files in it named `moveme1.txt`, `moveme2.txt`, and `moveme3.txt`. Clone this repo and its contents to the `/tmp` directories of all `planetexpress` hosts.

0. Consider using the [ansible.builtin.git](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/git_module.html) module for this one!
