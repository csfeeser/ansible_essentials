# Ansible-Vault Directory Challenge!

<img src="https://github.com/csfeeser/ansible_essentials/assets/31425191/e6b48f66-7093-4e24-bd09-f7c0c0e61dd5" width="300"/>

Good morning! To get the blood moving today we are going to improve an already existing playbook! This is what the playbook is SUPPOSED to do:
- Access the host `farnsworth` using SSH with password authentication
- Create directories for a list of popular cartoon characters

**STEP ONE.** Reset your inventory and planetexpress hosts with our bash reset command.

`student@bchd:~$` `bash ~/px/scripts/full-setup.sh`

**STEP TWO.** Remove the SSH password from farnsworth's inventory. Run the following command.

`student@bchd:~/mycode$` `wget -O ~/mycode/inv/dev/hosts https://raw.githubusercontent.com/csfeeser/ansible_essentials/main/data/hosts`

**STEP THREE.** Confirm that farnsworth is no longer accessible with the following command.

`student@bchd:~$` `ansible farnsworth -m ping`

```
farnsworth | UNREACHABLE! => {
    "changed": false,
    "msg": "Failed to connect to the host via ssh: Warning: Permanently added '10.10.2.6' (RSA) to the list of known hosts.\r\nfarnsworth@10.10.2.6: Permission denied (publickey,gssapi-keyex,gssapi-with-mic,password).",
    "unreachable": true
}
```

**STEP FOUR.** Paste the following playbook into vim.

```yaml
---
- name: Create directories for popular cartoon characters on farnsworth
  hosts: farnsworth
  gather_facts: no

  vars:
    ansible_ssh_pass: alta3

  tasks:
    - name: Retrieve Create directories for each cartoon character
      uri:
        url: https://thesimpsonsquoteapi.glitch.me/quotes
      register: quotedata

    - name: display quote
      debug:
        var: quotedata
```

### Objective 1:

- Use [Lab 42. 💻 Securing Playbooks with Vault](https://live.alta3.com/content/napya/labs/content/napya/LAB_napya_ansible_vault_for_networking.html) to help you with this one.
- Instead of having the variable `ansible_ssh_pass` defining the password `alta3` as plain text in the playbook, **encrypt it** with Ansible Vault!
     > The variable *must* be `ansible_ssh_pass`, no variations.
- Where you put the encrypted password is up to you! (`vars`, `vars_files`)

### Objective 2 (Optional):

- The Simpsons Quote API is a funny open API. [Check out the documentation.](https://thesimpsonsquoteapi.glitch.me/) Can you edit the URL with a query parameter so it returns FIVE quotes instead of one?

<details>
<summary>Click here for the solution!</summary>
<br>

### Playbook with Ansible Vault Integration

**NOTE:** the following is just *one way* to secure the `ansible_ssh_pass` using Ansible Vault. You may have done it differently and that's ok!

1. **Encrypt the SSH Password:**
   ```sh
   ansible-vault encrypt_string 'alta3' --name 'ansible_ssh_pass' --vault-id warmup@prompt > ~/mycode/vault.yml
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

     vars_files:   # NEW
       - vault.yml # NEW

     tasks:
      - name: Retrieve Create directories for each cartoon character
        uri:
          url: https://thesimpsonsquoteapi.glitch.me/quotes?count=5   ## "count" query param is NEW
        register: quotedata
  
      - name: display quote
        debug:
          var: quotedata
   ```

</details>
