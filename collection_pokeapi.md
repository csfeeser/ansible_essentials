# Friday Morning Warmup!

<img src="https://i.pinimg.com/736x/4a/4c/df/4a4cdffb8d189b1284636ae4c9e7ae7b.jpg" width="300"/>

Welcome back everyone! Yesterday we learned about collections and how they enable you to download and immediately use new modules and roles.

We're going to use a fun little collection that simplifies accessing the [Pokemon API](pokeapi.co)! This site returns more Pokemon data than you could imagine, including pictures of your favorite battling critters!

Start by heading to the documentation for the collection we're using [here at Ansible Galaxy](https://galaxy.ansible.com/ui/repo/published/rzfeeser/pokeapi/docs/) and read up on what the module in this collection does.

### GOALS:

- There are NO ERRORS in the playbook below! However, it won't run. Figure out why :)
- Add a task that uses the URL saved in the `pic_url_var` variable to download the picture to your `/home/student/static` directory.
- OPTIONAL- add a `vars_prompt` so every time the playbook runs we can be prompted to type in the name of a different Pokemon to download!
  - **IMPORTANT**: if the name of the Pokemon is not LOWERCASE this will fail! Hmmm... is there a tool we learned that can guarantee this?

```yaml
---
- name: Fetch Pokémon data using the pokeapi module
  hosts: localhost
  gather_facts: no

  collections:
    - rzfeeser.pokeapi

  tasks:
    - name: Using the name of a Pokémon, collect API data
      rzfeeser.pokeapi.pokeapi_info:
        resource: pokemon
        name: "mewtwo"
      register: pokemon_data

    - name: the set_fact module lets you declare a new variable mid-play!
      set_fact:
        pic_url_var: "{{ pokemon_data.pokeapi_json.sprites.front_default }}"

    - name: print out the URL to a picture of your selected pokemon
      debug:
        var: pic_url_var
```

### HINTS

<details>
<summary>Why can't this run? I thought it wasn't broken!</summary>

You don't have the collection installed. Run `ansible-galaxy install rzfeeser.pokeapi`

</details>

<details>
<summary>How do I download the picture from the url?</summary>

Use the `get_url` module! Try something like this:

```yaml
- name: download picture
  get_url:
    url: "{{ pic_url_var }}"
    dest: /home/student/static/
```

</details>

<details>
<summary>How do I force the Pokemon's name to be lowercase no matter what the user types in?</summary>

Use the Jinja2 filter `|lower`! Let's assume you wrote a `vars_prompt` that created a variable named `poke_pick`. Your `pokeapi_info` task would look something like this:

```yaml
- name: Using the name of a Pokémon, collect API data
  rzfeeser.pokeapi.pokeapi_info:
    resource: "{{ poke_pick|lower }}" ### add |lower to the end of your variable here
    name: "mewtwo"
  register: pokemon_data
```

</details>
