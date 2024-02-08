# Morning Warmup!

Gotta catch 'em all! Check out the [Pokemon API](https://pokeapi.co/) which returns tons of JSON data on your favorite Pokemon characters!

For once, our warmup is NOT broken! The files below are totally syntax-error free, but still, they won't work! Diagnose what is needed to get the playbook running. You MUST use Ansible-Vault to encrypt the name of your Pokemon and you MUST continue using the collection in the playbook! 

Not a Pokemon fan? Here are the names of some Pokemon that will work:
- `Pikachu`
- `Charizard`
- `Mewtwo`
- `Magnemite`

1. Create the following files:

    `student@bchd:~$` `vim ~/mycode/pokemon_name.yml`

    ```yaml
    pokemon_name:  !vault |
              $ANSIBLE_VAULT;1.1;AES256
              OHNOIDONTHAVETHEPASSWORDTOUNLOCKTHISVAULTSTRINGDAGNABBIT366236633138393234346537
              6135353834346337613838323566333765303663396166340a653634393364353732393338363066
              62383962393564323533623535613364333062363036333664333932313863356338666563653564
              3634356264386238340a366636353162636563666435376430346463373532376236376335323633
              3866
    ```

0. And now the playbook:

    `student@bchd:~$` `vim ~/mycode/gotta-catchem-all.yml`
    
    ```yaml
    ---
    - name: Fetch Pokémon data using the pokeapi module
      hosts: localhost
      gather_facts: no
    
      vars_files:
        - pokemon_name.yml
    
      collections:
        - rzfeeser.pokeapi
    
      tasks:
        - name: Retrieve Pokémon data
          rzfeeser.pokeapi.pokeapi_info:
            resource: pokemon
            name: "{{ pokemon_name | lower }}"  # | lower is a jinja2 filter; it will force our variable to lowercase
          register: pokemon_data
    
        - name: Save Pokémon data to a file
          ansible.builtin.copy:
            content: "{{ pokemon_data.pokeapi_json }}"
            dest: "/home/student/static/{{ pokemon_name }}_data.json"
    ```

<details>
<summary><b>SOLUTION</b></summary>

We need to install the collection used in this playbook!

`ansible-galaxy collection install rzfeeser.pokeapi`

We need to fix the file contained our Vault-encrypted Pokemon name.

`ansible-vault encrypt_string 'pikachu' --name 'pokemon_name' > ~/mycode/pokemon_name.yml`

Last but not least, when running the playbook you need to add the `--ask-vault-pass` option, otherwise you can't access your Vault secret.

`ansible-playbook gotta-catchem-all.yml --ask-vault-pass`

</details>
