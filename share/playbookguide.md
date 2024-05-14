#### Executing an Ansible playbook
#### AD-HOC Ansible Command (aka Ansible without a Playbook)
```
ansible-playbook setup.yaml -i ~/mycode/inv/dev/hosts -e "var1=value1"
                  ^ playbook   ^                      ^ passing in variable at command line
                               |
                               inventory file location
                                  parameter
```

#### Ansible Doc (look stuff up)
```
ansible-doc -t module <module_name>
    ^       ^         ^ module name to get documentation for
    |       |         
    |       type of documentation (module in this case)
    command
```

#### Ansible Inventory (check inventory hosts)
```
ansible-inventory -i ~/mycode/inv/dev/hosts --list
     ^            ^                          ^ displays inventory in JSON format
     |            |                          
     |            inventory file location    
     command
```

#### AD-HOC Ansible Command (aka Ansible without a Playbook)
```
ansible planetexpress -m command -a "whoami" -i ~/mycode/inv/dev/hosts" -b
        ^ HOST(S)      ^          ^           ^                          ^ "become" (run as root)
                       module     |           |
                                  argument/   inventory file location
                                  parameter
```

#### PLAYBOOK GUIDE
```yaml
- name: demo             #OVERALL GOAL OF THE PLAY
  hosts: planetexpress   #ALL THE HOSTS YOU WISH TO TARGET
  connection: ssh        #LINUX HOSTS? ssh. ROUTERS? network_cli. WINDOWS MACHINE? winrm.
  gather_facts: no       #SHOULD ANSIBLE GATHER INFO ON THOSE HOSTS?
    
  tasks:                 #LISTING ALL THE TASKS YOU'D LIKE TO RUN AGAINST HOSTS
  
  - name: task1          #GOAL OF THE TASK
    apt:                 #NAME OF THE MODULE
      update_cache: true #PARAMETER OF THIS MODULE
    become: yes          #SHOULD THIS TASK BE EXECUTED WITH "ROOT" PRIVILEGE?
```

<!--
#### PLAYBOOK GUIDE
```yaml
- name: demo             #OVERALL GOAL OF THE PLAY
  hosts: planetexpress   #ALL THE HOSTS YOU WISH TO TARGET
  connection: ssh        #LINUX HOSTS? ssh | ROUTERS? network_cli | WINDOWS MACHINE? winrm
  gather_facts: no       #SHOULD ANSIBLE GATHER INFO ON THOSE HOSTS?
  become: yes            #SHOULD EVERY TASK USE ELEVATED PERMISSION? (root)
  become_method: sudo    #WHAT DOES ELEVATED PERMISSION MEAN? (linux host=sudo, router=enable)
  
  vars:                  #DEFINE VARIABLES
    fav_color: red
    fav_icecreams: ["chocolate", "pistachio"]  # JSON STYLE LIST
    fav_books:                                 # YAML STYLE LIST
      - The Hobbit
      - Ender's Game
  
  vars_files:            #IMPORT VARS FROM YAML FILE(S)
    - some/dir/file1.yml
    - another/dir/file2.yml
    
  tasks:                 #LISTING ALL THE TASKS YOU'D LIKE TO RUN AGAINST HOSTS
  
  - name: task1          #GOAL OF THE TASK
    apt:                 #NAME OF THE MODULE
      update_cache: true #PARAMETER OF THIS MODULE
    become: yes          #SHOULD THIS TASK BE EXECUTED WITH "ROOT" PRIVILEGE?
    when: x == y         #WHAT CONDITION NEEDS TO BE TRUE FOR THIS TASK TO RUN
    register: rez        #SAVE OUTPUT FROM THIS TASK INTO A VARIABLE
```
-->
