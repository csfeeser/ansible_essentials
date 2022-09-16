## Final Challenge for JPMC!

Let's build something practical that you can potentially take back to your team(s) next week in using Ansible! Please do the following steps to get set up:

`student@bchd:~$` `mkdir -p ~/mycode/roles && cd ~/mycode/roles`

`student@bchd:~/mycode/roles$` `ansible-galaxy init lastdayrole`

`student@bchd:~/mycode/roles$` `cd ~/mycode/roles/lastdayrole`

### Objectives:

**This will be a read-only playbook, as we don't have the appropriate environment.**
Do the following prior to editing your role:
- go to Ansible Galaxy and install the `netapp.elementsw` collection.
- [CLICK HERE](https://docs.ansible.com/ansible/devel/collections/netapp/elementsw/) for the documentation on each module in this collection.

Edit your role to include the following:

- Include the following variables:

    ```
    elementsw_mvip: 8.8.8.8
    elementsw_password: SEE THE NEXT STEP
    elementsw_hostname: 1.187.255.255
    elementsw_username: awesomestudent
    node-ids: ["1.22.0.1", "1.22.0.2", "1.22.0.3"]
    policysettings: {minIOPS: 100, maxIOPS: 5000, burstIOPS: 20000}
    ```

- Don't put your password in clear text for everyone to see! Use `ansible-vault` to turn your password `alta3` into an encrypted string. Add it to your vars above.

- Add tasks using the following modules. Whenever you need authentication for username/password, use the vars above.
    - `netapp.elementsw.na_elementsw_info`
        - Use this module to gather info about your cluster (`gather_facts` won't work as well as this!)
        - save the output from this task using the `register` keyword in a variable named `results`
        - add a debug task that prints the `results` variable afterward.
    - `na_elementsw_node`
        - Add nodes to your cluster. Use the IP addresses in the `node-ids` var you made earlier.
    - `na_elementsw_qos_policy module`
        - Create a new policy named `platinum`.
        - When setting QOS, use the `policysettings` var you made earlier.
    - **Choose ONE ADDITIONAL module** from the netapp.elementsw collection

### SOLUTION:

**vars/main.yml**
```yaml
---
# vars file for lastdayrole
elementsw_mvip: 8.8.8.8
elementsw_hostname: 1.187.255.255
elementsw_username: awesomestudent
node-ids: ["1.22.0.1", "1.22.0.2", "1.22.0.3"]
policysettings: {minIOPS: 100, maxIOPS: 5000, burstIOPS: 20000}
elementsw_password: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          39393666666235663837306538653761353335383366323966333036613666636439633762313730
          3230663165623837663933303136613637373634316634380a393632383365633430313632623061
          61323463336639653865323661386333336562633864646639303764666265663535386434643063
          6539626466373164300a376530396230613634623133393735386564666364616566626164323833
```

**tasks/main.yml**
```yaml
---
# tasks file for lastdayrole
- name: get all available subsets
  na_elementsw_info:
    hostname: "{{ elementsw_mvip }}"
    username: "{{ elementsw_username }}"
    password: "{{ elementsw_password }}"
    gather_subsets: all
  register: result

- debug:
    var: result
    verbosity: 2

- name: Add node from pending to active cluster
  tags:
  - elementsw_add_node
  na_elementsw_node:
    hostname: "{{ elementsw_hostname }}"
    username: "{{ elementsw_username }}"
    password: "{{ elementsw_password }}"
    state: present
    node_id: "{{ node-ids }}"

- name: Add QOS Policy
  na_elementsw_qos_policy:
    hostname: "{{ elementsw_hostname }}"
    username: "{{ elementsw_username }}"
    password: "{{ elementsw_password }}"
    state: present
    name: platinum
    qos: "{{ policysettings }}"
```

### WHEN YOU ARE FINISHED:

`cd ~/mycode/roles/`

`ansible-galaxy collection init awesomestudent.myfirstcollection`

`cd ~/mycode/roles/awesomestudent/`

`cp -r ~/mycode/roles/lastdayrole ~/mycode/roles/awesomestudent/myfirstcollection/roles`

`ansible-galaxy collection build`

`ansible-galaxy collection install awesomestudent-myfirstcollection-1.0.0.tar.gz`

Congrats! You've built a role, added it to a collection, and then INSTALLED that collection; it's now able to be used on this controller and shared with others! :)
