## Loops Mini-Challenge

### Before you begin:

Refresh your `planetexpress` hosts as well as your .ansible.cfg and inventory files.

`student@bchd:~$` `cd && wget https://labs.alta3.com/projects/ansible/deploy/setup.sh -qO setup.sh && bash setup.sh`

**PART 1-** Take the playbook below and use the `nineties` variable with your `file` task. Create all the directories using a for loop. Only one task is allowed!  
**SUPER BONUS-** Can you make all the directories lowercase?

```yaml
- name: making dirs
  hosts: bender
  connection: local
  gather_facts: no

  vars: 
    nineties:
      - Teenage
      - Mutant
      - Ninja
      - Turtles
      
  tasks:

  - name: Making directories from a list
    file:
      path: # add the item keyword!
      state: directory
    # add the loop keyword!
```

<details>
<summary>Hint 1: Adding the `loop` keyword</summary>
        
```yaml
  - name: Making directories from a list
    file:
      path: # add the item keyword!
      state: directory
    loop: "{{ nineties }}"
```      
</details>

<details>
<summary>Hint 2: Returning `Teenage`,`Mutant`,`Ninja`, and `Turtles`</summary>

When using a loop, each item returned is represented by the variable `{{ item }}`!
  
```yaml
  - name: Making directories from a list
    file:
      path: "{{ item }}"
      state: directory
    loop: "{{ nineties }}"
```      
</details>

<details>
<summary>Hint 3: Making directory names lowercase</summary>

This is a topic we'll explore in greater detail later-- but Jinja2 has what are known as **filters** that can change objects. In this case, the [|lower](http://www.freekb.net/Article?id=2574) filter will do the job!
  
```yaml
  - name: Making directories from a list
    file:
      path: "{{ item | lower }}"
      state: directory
    loop: "{{ nineties }}"
```      
</details>

***

**PART 2-** Take the playbook below and edit the `msg` parameter so that it takes the `name` and `groups` value from each dictionary to complete the sentence.

```yaml
- name: looping dictionaries
  hosts: localhost
  connection: local
  gather_facts: no

  tasks:

  - name: Loop across complex data structures
    debug:
      msg: # complete this line. Make it read "A _____ is my favorite ____!"
    loop:
      - { name: 'banana', groups: 'fruit' }
      - { name: 'rousing game of Monopoly', groups: 'pastime' }
      - { name: 'cookie', groups: 'snack' }
      - { name: 'carrot', groups: 'vegetable' }
```

<details>
<summary>Hint 1: Using Dot Notation</summary>

Our loop is going over a sequence (aka array/list) of mappings (aka object/dictionary). From each mapping in that list, we want to return the value of `name` and the value of `groups`.  
Here's a breakdown of how `item` would be sliced using dot notation.
  
```
item.name = banana
item.groups = fruit
item.name = rousing game of Monopoly
item.groups = pastime
item.name = cookie
item.groups = snack
item.name = carrot
item.groups = vegetable
```
  
</details>

<details>
<summary>Hint 2: Using Dot Notation with our Loop</summary>

```
  - name: Loop across complex data structures
    debug:
      msg: "A {{ item.name }} is my favorite {{ item.groups }}!"
    loop:
      - { name: 'banana', groups: 'fruit' }
      - { name: 'rousing game of Monopoly', groups: 'pastime' }
      - { name: 'cookie', groups: 'snack' }
      - { name: 'carrot', groups: 'vegetable' }
```
  
</details>
