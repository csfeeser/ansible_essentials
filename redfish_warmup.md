# Redfish Warmup

<img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRI1DLRSo38oL8Nm5Fxo64zhew0aXBLsyFuOQ&s" width="300"/>

## Prep
    
1. Confirm your `dmtf/redfish-mockup-server:latest` container is up and running.

    `student@bchd:~$` `docker ps`
    
    ```
    CONTAINER ID   IMAGE                                                         COMMAND                  CREATED        STATUS                  PORTS                                       NAMES
    966c371aaa2e   dmtf/redfish-mockup-server:latest                             "python /usr/src/app…"   22 hours ago   Up 22 hours (healthy)   0.0.0.0:2224->8000/tcp, :::2224->8000/tcp   thirsty_booth
    ```

    > Don't see it? Use this to rebuild it: `sudo docker run -p 2224:8000 -d --rm dmtf/redfish-mockup-server:latest`

0. Confirm that you have your Redfish container in your inventory as a host. A handy way to check this is with the `ansible-inventory` command, which lists all hosts Ansible has access to via its inventory files.

    `student@bchd:~$` `ansible-inventory --graph | grep Redfish`

    ```
      |  |--Redfish
    ```

0. If you don't see that output, it means that your inventory was reset at some point by our bash script. No worries! Open the dropdown below and PASTE the entire bash block at your command line. Super easy.

<details>
<summary>CLICK HERE FOR REDFISH INVENTORY FIX</summary>
    
```bash
#!/bin/bash

# Set BASEURL using FQDN discovery
export BASEURL="aux1-$(hostname -d).live.alta3.com"

# Define the file to check/update
HOSTS_FILE=~/mycode/inv/dev/hosts

# Create the file if it doesn't exist
mkdir -p ~/mycode/inv/dev
touch "$HOSTS_FILE"

# Check and append if needed
if ! grep -q "\[redfish\]" "$HOSTS_FILE" || ! grep -q "baseuri=$BASEURL" "$HOSTS_FILE"; then
  echo -e "\n[redfish]\nRedfish     baseuri=$BASEURL username=root password=null" >> "$HOSTS_FILE"
  echo "Redfish inventory block added."
else
  echo "Redfish inventory block already present."
fi
```

</details>

## Procedure

1. Create a new BROKEN playbook for our warmup today.
   
    `student@bchd:~$` `vim ~/mycode/wed_warmup.yaml`
   
    ```yaml
    ---
    - name: Wednesday Warmup
      hosts: bluefish
      connection: local
      gather_facts: false
    
      - name: Get CPU model
        ansible.general.redfish_info:
          category: Systems
          command: GetCpuInventory
          baseuri: "{{ baseuri }}"
    
      - name: Restart system power gracefully
        ansible.general.redfish_command:
          category: Systems
          command: PowerForceOff
          resource_id: BMC
          baseuri: "{{ baseuri }}"
    ```

#### GOALS:

The playbook above is broken and won't run! Not only that, the tasks are not accomplishing what they are supposed to! Edit the playbook above to do the following:

- Execute without error.
- One task is supposed to gather info about the CPU inventory of our server.
- One task is supposed to send a command to **restart the server gracefully**.
- **BONUS**: Tasks are missing! `register` the output from both tasks above and print them out with `debug`.    
- **SUPER BONUS**: Assuming you were able to `register`/`debug` the output, use `.dot.notation` to slice the CPU data to display the `Model` of the FIRST CPU.

<details>
<summary><b>SOLUTION</b></summary>

```yaml
---
- name: Wednesday Warmup
  hosts: Redfish
  connection: local
  gather_facts: false

  tasks:
  - name: Get CPU model
    community.general.redfish_info:
      category: Systems
      command: GetCpuInventory
      baseuri: "{{ baseuri }}"
      username: "{{ username }}"
      password: "{{ password }}"
    register: cpuinventory

  - name: bonus
    debug:
      var: cpuinventory

  - name: rocket scientist bonus
    debug:
      var: cpuinventory.redfish_facts.cpu.entries.0.1.0.Model

  - name: Restart system power gracefully
    community.general.redfish_command:
      category: Systems
      command: PowerGracefulRestart
      resource_id: 437XR1138R2
      baseuri: "{{ baseuri }}"
      username: "{{ username }}"
      password: "{{ password }}"
    register: powerresult

  - name: bonus
    debug:
      var: powerresult
```

</details>
