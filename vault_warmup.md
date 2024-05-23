# Ansible-Vault Directory Challenge!

<img src="https://github.com/csfeeser/ansible_essentials/assets/31425191/e6b48f66-7093-4e24-bd09-f7c0c0e61dd5" width="300"/>

Good morning! To get the blood moving today we are going to improve an already existing playbook! This is what the playbook is SUPPOSED to do:
- Access the host `farnsworth` using SSH with password authentication
- Create directories for a list of popular cartoon characters

Let's start by removing the SSH password from farnsworth's inventory. Run the following command.

`student@bchd:~/mycode$` `wget -O ~/mycode/inv/dev/hosts https://raw.githubusercontent.com/csfeeser/ansible_essentials/main/data/hosts`

> The playbook should now properly fail IF the password `alta3` isn't provided!

Use vim to create a playbook file of your choosing and enter the following.

`student@bchd:~/mycode$` `vim ~/mycode/cartoon_characters.yml`

```yaml
---
- name: Create directories for popular cartoon characters on farnsworth
  hosts: farnsworth
  gather_facts: no

  vars:
    ansible_ssh_pass: alta3

    cartoon_characters:
      - MickeyMouse
      - BugsBunny
      - HomerSimpson
      - SpongeBobSquarePants
      - ScoobyDoo

  tasks:
    - name: Create directories for each cartoon character
      file:
        path: "{{ cartoon_characters.0 }}"
        state: directory
    - name: Create directories for each cartoon character
      file:
        path: "{{ cartoon_characters.1 }}"
        state: directory
    - name: Create directories for each cartoon character
      file:
        path: "{{ cartoon_characters.2 }}"
        state: directory
    - name: Create directories for each cartoon character
      file:
        path: "{{ cartoon_characters.3 }}"
        state: directory
    - name: Create directories for each cartoon character
      file:
        path: "{{ cartoon_characters.4 }}"
        state: directory
```

### Objective 1:

- Use `Lab 58. 💻 Ansible Vault` to help you with this one.
- Instead of having the password `alta3` as plain text in the playbook, **encrypt it** with Ansible Vault!
- Where you put the encrypted password is up to you! (`vars`, `vars_files`)

### Objective 2 (Optional):

- Reduce this playbook from five tasks to one by using a loop!

<details>
<summary>Click here for the solution!</summary>
<br>

### Playbook with Ansible Vault Integration

**NOTE:** the following is just *one way* to secure the `ansible_ssh_pass` using Ansible Vault. You may have done it differently and that's ok!

1. **Encrypt the SSH Password:**
   ```sh
   ansible-vault --vault-id warmup@prompt encrypt_string 'alta3' --name 'ansible_ssh_pass' > ~/mycode/vault.yml
   ```

   - Choose whatever password you like to encrypt it.
   - You can confirm it's done with `batcat ~/mycode/vault.yml`. This will output something like:

   ```yaml
   ansible_ssh_pass: !vault |
     $ANSIBLE_VAULT;1.1;AES256
     31346339326565636365623838623266336662663631393736396561633834333234323039303833
     3864623231623433313334396633383133353533356237340a343837623537643532343331386465
     62356430353834316339626666373234363835373264353963393735313462356366336238353934
     3236663038643731640a313862623165396432353635663362313332336634373163383031366432
     3061
   ```

2. **Update the Playbook to Use the Encrypted Password:**
   ```yaml
   ---
   - name: Create directories for popular cartoon characters on farnsworth
     hosts: farnsworth
     gather_facts: no

     vars:
       cartoon_characters:
         - MickeyMouse
         - BugsBunny
         - HomerSimpson
         - SpongeBobSquarePants
         - ScoobyDoo

     vars_files:   # NEW
       - vault.yml # NEW

     tasks:
       - name: Create directories for each cartoon character
         file:
           path: "{{ item }}"              # NEW
           state: directory
         loop: "{{ cartoon_characters }}"  # NEW

     # delete the rest!
   ```

4. **Run the Playbook with the Vault File:**
   ```sh
   ansible-playbook ~/mycode/cartoon_characters.yml --vault-id warmup@prompt
   ```

</details>
