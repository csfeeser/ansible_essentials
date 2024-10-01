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

<details>
<summary>Click here for the solution!</summary>
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
