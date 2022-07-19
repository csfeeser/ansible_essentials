## Busted Playbook Challenge!

<img src="https://i.redd.it/i4v9op0chrc51.jpg" width="500"/>



Good morning! To get the blood moving today we'll start with a familiar looking playbook-- however, it's broken! Your job is to get it working (no need to improve it).

Please start by getting your environment prepared:

`student@bchd:~$` `cd && wget https://labs.alta3.com/projects/ansible/deploy/setup.sh && bash setup.sh`

Use vim to create a playbook file of your choosing and enter the following. Then test, fix, repeat!

```yaml
---
- name: Tuesday Challenge
  hosts: planet express
  connection: network_cli
  gather_facts: yes

  tasks:
   - name: print out the variable named "result"
     debug:
       var: result
       
   -apt:
        name: sl
       state: present
   name: using apt to install sl
   register: result
```

## SOLUTIONS!

Error message:
```
The offending line appears to be:
   -apt:
   ^ here
```
<details>
<summary>Solution:</summary>
        
Change `-apt` to `- apt`. Always put a whitespace after a `-` in YAML!
      
</details>

***

Error message:
```
The offending line appears to be:

        name: sl
       state: present
       ^ here
```
<details>
<summary>Solution:</summary>
        
This is an indentation error. `name` and `state` are both parameters of the `apt` module and must be lined up the same! Change it to this:
  
```yaml
   - apt:
       name: sl
       state: present
```      
</details>

***

Error message:
```
The offending line appears to be:

        state: present
   name: using apt to install sl
   ^ here
```
<details>
<summary>Solution:</summary>
        
Once again this is an indentation issue. `name`,`register`, and `apt` are all keywords and should have the same indentation. Change it to this:

```yaml
   - apt:
        name: sl
        state: present
     name: using apt to install sl
     register: result
```
</details>


***

Error message:
```
[WARNING]: Could not match supplied host pattern, ignoring: planet                                                                    
[WARNING]: Could not match supplied host pattern, ignoring: express 
```
<details>
<summary>Solution:</summary>
        
Start by checking out our group names in our inventory. `head ~/ans/inv/dev/hosts -n 1`
  
```
[planetexpress]
```

Oops! We wrote the group name incorrectly. Change the `hosts` line to this:
  
```yaml
hosts: planetexpress
```
  
</details>



***

Error message:
```
fatal: [bender]: FAILED! => {"msg": "Unable to automatically determine host network os. Please manually configure ansible_network_os v
alue for this host"}                                                                                                                  
fatal: [fry]: FAILED! => {"msg": "Unable to automatically determine host network os. Please manually configure ansible_network_os valu
e for this host"}
fatal: [zoidberg]: FAILED! => {"msg": "Unable to automatically determine host network os. Please manually configure ansible_network_os
 value for this host"}
fatal: [farnsworth]: FAILED! => {"msg": "Unable to automatically determine host network os. Please manually configure ansible_network_
os value for this host"}
```

<details>
<summary>Solution:</summary>
        
For some reason we are looking at `bender`,`fry`,`zoidberg`, and `farnsworth` as if they are networking devices. Ansible is complaining that we didn't define what network OS they are running.
  
Oops! We set our `connection` value to `network_cli`. These are linux hosts, not networking devices. Change that line to this:
  
```yaml
connection: ssh
```
  
</details>

***

Error message:
```
fatal: [farnsworth]: FAILED! => {"changed": false, "cmd": "apt-get update", "msg": "[Errno 2] No such file or directory", "rc": 2, "stderr": "", "stderr_lines": [], "stdout": "", "stdout_lines": []}
```

<details>
<summary>Solution:</summary>
        
The `farnsworth` host is failing our task that uses `apt` to install an application. Oops- `farnsworth` is a CentOS machine and therefore **cannot use apt.** Since there's no way this will ever work, let's exclude `farnsworth` from this play.
  
```yaml
hosts: planetexpress:!farnsworth   # target all hosts in planetexpress EXCEPT farnsworth
```
  
</details>

***

Error message:
```
ok: [bender] => {
    "result": "VARIABLE IS NOT DEFINED!"
}
ok: [fry] => {
    "result": "VARIABLE IS NOT DEFINED!"
}
ok: [zoidberg] => {
    "result": "VARIABLE IS NOT DEFINED!"
}
ok: [farnsworth] => {
    "result": "VARIABLE IS NOT DEFINED!"
}
```
<details>
<summary>Solution:</summary>
        
While this isn't truly an error (it's not RED), it's definitely not desirable. The problem here is that in Ansible, ORDER MATTERS. For instance, you always put your socks on BEFORE you put on your shoes, right? In this case, we'd better DEFINE the variable `result` before we try to DISPLAY the value of result. Switch the order of your two tasks!
 
```yaml
   - apt: # THIS TASK FIRST
           name: sl
           state: present
     name: using apt to install sl
     register: result
     become: true

   - name: print out the variable named "result"
     debug: # THIS TASK SECOND
       var: result
```
</details>

***

### FULL SOLUTION

<details>
<summary>Click here for full solution:</summary>
  
```yaml
---
- name: Tuesday Challenge
  hosts: planetexpress:!farnsworth
  connection: ssh
  gather_facts: yes

  tasks:
       
   - apt: 
           name: sl
           state: present
     name: using apt to install sl
     register: result
     become: true

   - name: print out the variable named "result"
     debug:
       var: result
```
