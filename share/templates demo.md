```yaml
pets:
  - pet_name: Spot
    species: dog
    allergies: chocolate

  - pet_name: Socks
    species: cat
    allergies: socks

  - pet_name: Squeaky
    species: hamster
    allergies: sawdust

  - pet_name: Squishy
    species: salamander
    allergies: smoke
```
 
```yaml
{% for x in pets %}
{% if x.species != "cat" %}
NAME: {{ x.pet_name }}
SPECIES: {{ x.species }}
ALLERGIES: {{ x.allergies }}
{% endif %}

{% endfor %} 
```
 
```yaml
- name: showing off the template module
  hosts: localhost
  connection: local
  gather_facts: no

  vars_files:
    - pets.yml

  tasks:

  - name: create a pet registration form
    template:
      src: ~/templates/petinfo.txt # point the way to a j2 template document
      dest: ~/allanimals.txt  
```
