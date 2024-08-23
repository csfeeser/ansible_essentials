### Challenge Lab: Fixing and Enhancing a Playbook

**Objective:**  
Behold our last busted playbook to fix! You should recognize this playbook from the labs, but alas, it is riddled with very common errors... some obvious, some not. Your objective is to do the following:

1. **Identify Syntax Errors:**
   - Identify and correct the syntax errors to ensure the playbook runs successfully.

2. **Enhance the Playbook:**
   - Add a fail task in the rescue block so that the playbook stops execution if iDRAC logs are collected due to an unhealthy status.

**Provided Playbook:**

```yaml
name: Full audit of iDRAC interface
hosts: localhost   
connection: local 
gather_facts: False 

vars:
  my_ip: "10.0.0.89"
  my_user: 'root'
  my_password: r0gerwilc0
  
tasks:

- name: PRECHECKING - Check Health of iDRAC
  block:
    - name: Show status of the Lifecycle Controller
      dellemc.openmanage.idrac_lifecycle_controller_status_info:
        idrac_ip: "{{ myip }}"
        idrac_user: "{{ myuser }}"
        idrac_password: "{{ mypassword }}"
        validate_certs: False
      register: results

    - assert:
        that: results.lc_status_info.LCReady != true
        success_msg: iDRAC is healthy
        fail_msg: iDRAC is unhealthy

rescue:
    - name: Collect Logs when iDRAC is unhealthy
      dellemc.openmanage.idrac_lifecycle_controller_logs:
        idrac_ip: "{{ myip }}"
        idrac_user: "{{ myuser }}"
        idrac_password: "{{ mypassword }}"
        validate_certs: False
        share_name: "/tmp/export_lc"
```

<details>
<summary>SOLUTION</summary>

```yaml
---
# missing dash in front of "name"
- name: Full audit of iDRAC interface
  hosts: localhost   
  connection: local 
  gather_facts: False 

  vars:
    my_ip: "10.0.0.89"
    my_user: 'root'
    my_password: r0gerwilc0
    
  tasks:

  # Corrected indentation and variable names
  - name: PRECHECKING - Check Health of iDRAC
    block:
      - name: Show status of the Lifecycle Controller
        dellemc.openmanage.idrac_lifecycle_controller_status_info:
          idrac_ip: "{{ my_ip }}"              # fixed variable name from myip to my_ip
          idrac_user: "{{ my_user }}"          # fixed variable name from myuser to my_user
          idrac_password: "{{ my_password }}"  # fixed variable name from mypassword to my_password
          validate_certs: False
        register: results

      - assert:
          that:
            - results.lc_status_info.LCReady == true  # fixed condition to check for true
          success_msg: iDRAC is healthy
          fail_msg: iDRAC is unhealthy

    rescue:
      # Fixed indentation and added a fail task
      - name: Collect Logs when iDRAC is unhealthy
        dellemc.openmanage.idrac_lifecycle_controller_logs:
          idrac_ip: "{{ my_ip }}"              # fixed variable name from myip to my_ip
          idrac_user: "{{ my_user }}"          # fixed variable name from myuser to my_user
          idrac_password: "{{ my_password }}"  # fixed variable name from mypassword to my_password
          validate_certs: False
          share_name: "/tmp/export_lc"

      - name: Fail the playbook due to unhealthy iDRAC
        fail:
          msg: "Playbook stopped as iDRAC is unhealthy and logs have been collected."
```

</details>
