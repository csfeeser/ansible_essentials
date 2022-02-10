## Loops Mini-Challenge

Take the playbook below and edit the `msg` parameter so that it takes the `name` and `groups` value from each dictionary to complete the sentence.

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

<!--
SOLUTION
```
- name: looping dictionaries
  hosts: localhost
  connection: local
  gather_facts: no

  tasks:

  - name: Loop across complex data structures
    debug:
      msg: "A {{ item.name }} is my favorite {{ item.groups }}!"
    loop:
      # what is returned is rep. by "item"
      - { name: 'banana', groups: 'fruit' }
      - { name: 'rousing game of Monopoly', groups: 'pastime' }
      - { name: 'cookie', groups: 'snack' }
      - { name: 'carrot', groups: 'vegetable' }
```
-->
