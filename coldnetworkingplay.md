### Morning Survey/Challenge

<img src="http://securitynotsupported.com/17-automated-elasticsearch-rolling-updates/automate.jpeg" width="300"/>


Below is a (heavily reduced) play taken from https://public.cyber.mil/stigs/supplemental-automation-content/, a page that contains Ansible playbooks written by the US Department of Defense to automate configuration of Juniper devices.

#### THIS PLAYBOOK IS FOR READING ONLY. RUNNING IT WILL FAIL.

From what we've learned in class, this should be readable! Of course, you must use Google to find the appropriate documentation on these modules to see exactly what it is they do.

### Your challenge:

- **Use what you've learned in class (and Ansible docs) to ascertain what each task is doing.**
- **Put a brief description of each task in our WebEx survey!**

```yaml
- name: reading a play warmup
  hosts: all
  connection: network_cli
  gather_facts: no
  
  vars:
    junosSTIG_stigrule_80813_Manage: True
    junosSTIG_stigrule_81027_Manage: False
    
  tasks:
  
    - name : TASK ONE
      junos_config:
        lines: "{{ junosSTIG_stigrule_80813_set_security_screen_ids_option_statistics_Lines }}"
      when:
        - junosSTIG_stigrule_80813_Manage

    - name: TASK TWO
      junos_command:
        commands:
          - show configuration
        display: xml
      register: configuration
      when:
        - junosSTIG_stigrule_81027_Manage
        
    - name: TASK THREE
      debug:
        var: configuration
      when:
        - junosSTIG_stigrule_81027_Manage 
        
    - name : TASK FOUR
      notify: "save configuration"
      junos_config:
        lines: "{{ junosSTIG_stigrule_81027_set_system_login_class_Lines }}"
      loop: "{{ configuration['output'][0]['rpc-reply']['configuration']['system']['login']['class'] | default([]) }}"
      when:
        - junosSTIG_stigrule_81027_Manage

```
