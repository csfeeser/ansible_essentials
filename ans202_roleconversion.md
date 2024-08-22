# Playbook to Role Conversion


<img src="https://github.com/csfeeser/ansible_essentials/blob/main/data/ansiblebaby.jpg?raw=true" width="300"/>


Below you will find a familiar looking playbook. YOUR GOAL is to:
- Convert the playbook below into a role
- Call your newly created role from a second playbook.

1. Create a directory for your role to be stored in.

    `student@bchd:~$` `mkdir -p ~/galaxy/roles/`
    
0. Create your new role's directory structure.

    `student@bchd:~$` `ansible-galaxy init ~/galaxy/roles/challenge`
    
0. Move into your new role.

    `student@bchd:~$` `cd ~/galaxy/roles/challenge`

0. If you haven't yet, install the `tree` application, it can really help!

    `student@bchd:~/galaxy/roles/challenge$` `sudo apt install tree -y`
    
0. Use the `tree` application to get a better visual of the role you created.

    `student@bchd:~/galaxy/roles/challenge$` `tree`
    
0. Update your ansible.cfg file so that it knows to look in this directory to find/use your role!

    `student@bchd:~/galaxy/roles/challenge$` `echo -e "\nroles_path=~/galaxy/roles/" >> ~/.ansible.cfg`
    
### CONVERT THE FOLLOWING INTO A ROLE!

```yaml
---
- name: DellEMC PowerEdge - Making contact with DellEMC PowerEdge
  hosts: localhost
  connection: local
  gather_facts: no
  vars:
          idrac_ip: "10.0.0.89"
          idrac_user: "root"
          idrac_password: "r0gerwilc0"
  tasks:
        - name: Poll iDRAC lifecycle status
          dellemc.openmanage.idrac_lifecycle_controller_status_info:
                  validate_certs: False        # in production, turn this to True
                  idrac_ip: "{{ idrac_ip }}"
                  idrac_user: "{{ idrac_user }}"
                  idrac_password: "{{ idrac_password }}"
          register: results

        - name: Display the information collected on the Lifecycle Controller
          debug:
                  var: results
```

Call your new role like so:

```yaml
- name: DellEMC PowerEdge - Making contact with DellEMC PowerEdge
  hosts: localhost
  connection: local
  gather_facts: no

  roles:
    - challenge
```
