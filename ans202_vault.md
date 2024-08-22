## Challenge: Secure Your Playbook with Ansible Vault

### Task:
Take the provided playbook below and modify it so that the `idrac_password` is securely stored and passed using Ansible Vault.

### Original Playbook:
```yaml
---
- hosts: localhost   
  connection: local
  name: Get Installed Firmware Inventory
  gather_facts: no

  collections:
    - dellemc.openmanage

  vars:
    idrac_ip: 10.0.0.89
    idrac_user: root
    idrac_password: r0gerwilc0  # Convert this to use Ansible Vault

  tasks:
  - name: Get Installed Firmware Inventory.
    idrac_firmware_info:
       idrac_ip: "{{ idrac_ip }}"
       idrac_user: "{{ idrac_user }}"
       idrac_password:  "{{ idrac_password }}"
       validate_certs: False
    register: results

  - name: Display the gathered facts about Firmware
    debug:
      var: results

  - name: Display just the results.firmware_info.Firmware[]ElementNames
    debug:
      var: item.ElementName
    loop: "{{ results.firmware_info.Firmware }}"
```

### Instructions:
1. **Encrypt the Password**: Use Ansible Vault to encrypt the `idrac_password` variable.
2. **Modify the Playbook**: Update the playbook to use the encrypted password.
3. **Test Your Playbook**: Run the playbook to ensure it executes correctly and retrieves the firmware inventory.

### Hints:
- Remember to store the encrypted password in a separate file or within the playbook itself as an encrypted string.
- Ensure the playbook references the encrypted variable correctly.
- Use the `ansible-vault` command line tool to create, edit, and view encrypted files.

---

<details>
  <summary>SOLUTION</summary>

  1. **Create an Encrypted Variable File**:
     - Run the command:  
       ```bash
       ansible-vault create vault.yml
       ```
     - Add the `idrac_password` variable inside the file in the following format:
       ```yaml
       idrac_password: r0gerwilc0
       ```

  2. **Modify the Playbook to Include the Encrypted File**:
     - Update the playbook to remove the plain-text `idrac_password` and include the encrypted variable file:
       ```yaml
       vars_files:
         - vault.yml
       ```

  3. **Run the Playbook with Ansible Vault**:
     - Execute the playbook:
       ```bash
       ansible-playbook playbook.yml --ask-vault-pass
       ```

     This command will prompt you for the vault password and then execute the playbook, passing the encrypted `idrac_password` securely.

  4. **Verify the Output**:
     - Ensure that the firmware inventory is displayed as expected, confirming that the playbook ran successfully using the vaulted password.

  ### Full Updated Playbook:
  ```yaml
  ---
  - hosts: localhost   
    connection: local
    name: Get Installed Firmware Inventory
    gather_facts: no

    collections:
      - dellemc.openmanage

    vars:
      idrac_ip: 10.0.0.89
      idrac_user: root

    vars_files:
      - vault.yml  # Encrypted variable file containing idrac_password

    tasks:
    - name: Get Installed Firmware Inventory.
      idrac_firmware_info:
         idrac_ip: "{{ idrac_ip }}"
         idrac_user: "{{ idrac_user }}"
         idrac_password:  "{{ idrac_password }}"
         validate_certs: False
      register: results

    - name: Display the gathered facts about Firmware
      debug:
        var: results

    - name: Display just the results.firmware_info.Firmware[]ElementNames
      debug:
        var: item.ElementName
      loop: "{{ results.firmware_info.Firmware }}"
  ```
</details>
