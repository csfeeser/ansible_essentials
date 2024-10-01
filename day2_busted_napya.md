## Busted Playbook Challenge!

<img src="https://i.redd.it/i4v9op0chrc51.jpg" width="500"/>

Good morning! To get the blood moving today we'll start with a familiar looking playbook-- however, it's broken! Your job is to get it working (no need to improve it).

Please start by getting your environment prepared:

`student@bchd:~$` `bash ~/px/scripts/full-setup.sh`

Create a new playbook file of your choosing and enter the following:

`student@bchd~$` `cd && vim day2warmup.yml`

```yaml
---
- name: Tuesday Challenge
  hosts: zoidburg  
  connection: network_cli  
  gather_facts: yes

  vars:
     api_url_address: "http://api.open-notify.org/iss-now.json"

  tasks:
  - name: Display the contents of the variable astrojson
    debug:
      msg: "Current ISS location: {{ astrojson }}"
      var: astrojson                               

  - name: Print out to the screen
      uri:                             
      url: api_url_address   
    register: astrojson
```

### Debugging tip: run the playbook, see what error occurs. Then, focus on ONLY fixing that error. Then run again! Try not to introduce more errors as you go, focus on one thing at a time.

Execute your playbook like so:

`student@bchd~$` `ansible-playbook day2warmup.yml`

### Need some hints without the full solution? Check here!

<details>
<summary>Error: No matching host for zoidburg</summary>
<br>

  - Hint 1: Double-check the host name you're trying to connect to.
  
  <details>
  <summary>Need another hint?</summary>
  <br>
  
  - Hint 2: It might be a spelling mistake. Try comparing the host name to your inventory file.
  
  <details>
  <summary>Want the answer?</summary>
  <br>
  
  - Hint 3: The host is actually spelled "zoidberg" in your inventory.
  
  </details>
  </details>
</details>

<details>
<summary>Error: Unsupported connection type: network_cli</summary>
<br>

- Hint 1: Take a look at the connection type you're using.

<details>
<summary>Need another hint?</summary>
<br>

- Hint 2: Check the documentation for the correct connection type based on your host setup.

<details>
<summary>Want the answer?</summary>
<br>

- Hint 3: The connection should be set to "ssh" for this type of playbook.

</details>
</details>
</details>

<details>
<summary>Error: Unexpected parameter "var" in task "Display the contents of the variable astrojson"</summary>
<br>

- Hint 1: Review the debug task parameters, one of them might be extra.

<details>
<summary>Need another hint?</summary>
<br>

- Hint 2: "msg" and "var" don't go together in the same debug task. You need to remove one.

<details>
<summary>Want the answer?</summary>
<br>

- Hint 3: Remove "var: astrojson" since "msg" is already displaying it.

</details>
</details>
</details>

<details>
<summary>Error: 'uri' is not valid in the current play</summary>
<br>

- Hint 1: Check the indentation in your "uri" task block.

<details>
<summary>Need another hint?</summary>
<br>

- Hint 2: The task might need proper indentation for Ansible to recognize it.

<details>
<summary>Want the answer?</summary>
<br>

- Hint 3: Fix the indentation under "uri" to match Ansible's expected format.

</details>
</details>
</details>


### Full Solution!

<details>
<summary>Click here for the full solution!</summary>
<br>

```yaml
---
- name: Tuesday Challenge
  hosts: zoidberg   # typo in host name!
  connection: ssh   # wrong connection type!
  gather_facts: yes

  vars:
     api_url_address: "http://api.open-notify.org/iss-now.json"

  tasks:

  # tasks were in the wrong order! this first, to send the request:
  - name: Print out to the screen
    uri:                              # indentation error!
      url: "{{ api_url_address }}"    # variables need put in "{{ quotes/curly brackets! }}"
    register: astrojson

  # this task second, to print out the response!
  - name: Display the contents of the variable astrojson
    debug:
      msg: "Current ISS location: {{ astrojson }}" # msg and var are mutually exclusive!
      # var: astrojson                               remove or comment one of these out! 
 ```

</details>
