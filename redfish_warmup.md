# Wednesday Warmup

## Prep

1. Let's freshen our Redfish container. Run this command to stop and remove all running Docker containers>:

    `student@bchd:~$` `docker stop $(docker ps -aq) && docker rm $(docker ps -aq)`

0. Now rebuild your Redfish container.
  
    `student@bchd:~$` `sudo docker run -p 2224:8000 -d --rm dmtf/redfish-mockup-server:latest`
    
0. Confirm your `dmtf/redfish-mockup-server:latest` container is back up and running.

    `student@bchd:~$` `docker ps`
    
    ```
    CONTAINER ID   IMAGE                                                         COMMAND                  CREATED        STATUS                  PORTS                                       NAMES
    966c371aaa2e   dmtf/redfish-mockup-server:latest                             "python /usr/src/app…"   22 hours ago   Up 22 hours (healthy)   0.0.0.0:2224->8000/tcp, :::2224->8000/tcp   thirsty_booth
    ```

0. Confirm that you have your Redfish container in your inventory as a host. A handy way to check this is with the `ansible-inventory` command, which lists all hosts Ansible has access to via its inventory files.

    `student@bchd:~$` `ansible-inventory --graph | grep Redfish`

    ```
      |  |--Redfish
    ```

    > Don't see that output? Your inventory file may have been configured incorrectly/removed. Let Chad know!


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
- **ROCKET SCIENTIST BONUS**: Assuming you were able to `register`/`debug` the output, use `.dot.notation` to slice the CPU data to display the `Model` of the FIRST CPU.

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
