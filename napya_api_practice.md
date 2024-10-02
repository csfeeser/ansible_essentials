# Warmup: Accessing TV Show Quotes API with Ansible!

<img src="https://images7.memedroid.com/images/UPLOADED130/556d6aa5c6621.jpeg" width="300"/>

Good morning! Today, we’ll work on accessing a TV show quotes API to get random quotes from various shows. We will use the `uri` module to interact with the API and print out the results.

First, let’s start by getting our environment ready:

`student@bchd~$` `vim tvquotes.yml`

```yaml
---
- name: TV Quotes Playbook
  hosts: localhost

  vars:
    baseurl: "https://quotes.alakhpc.com/quotes"

  tasks:
    - name: Get a random quote from the API
      uri:
        url: "{{ baseurl }}?show=Frasier" 
      register: quote_response

    - name: Print the whole quote response
      debug:
        var: quote_response
```

Run your playbook:

`student@bchd~$` `ansible-playbook tvquotes.yml`

Check out the query parameters that this API supports:

| Query Parameter | Description                                                                 | Example Usage                                                    | Example Response                                                                                                                   |
|-----------------|-----------------------------------------------------------------------------|------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------|
| `show`          | Specifies the TV show from which you want a random quote (see below for available shows)                   | `https://quotes.alakhpc.com/quotes?show=Friends`                 | `{ "show": "Friends", "character": "Chandler", "text": "Could I *be* wearing any more clothes?" }`                                 |
| `short`         | Limits the response to only one-line quotes when set to `true`. Defaults to `false`. | `https://quotes.alakhpc.com/quotes?show=Breaking+Bad&short=true` | `{ "show": "Breaking Bad", "character": "Walter White", "text": "Say my name." }`                                                   |

<details>
<summary>Click here to see the list of available TV shows:</summary>
<br>

> Woah, what's up with all those `%20`s? That's because you can't use spaces in URLs. White spaces are encoded as `%20` so browsers can interpret them properly!

- `How%20I%20Met%20Your%20Mother`
- `The%20Middle`
- `New%20Girl`
- `Suits`
- `3rd%20Rock%20from%20the%20Sun`
- `Arrested%20Development`
- `Malcolm%20in%20the%20Middle`
- `Monk`
- `The%20Fresh%20Prince%20of%20Bel-Air`
- `Parks%20And%20Recreation`
- `Home%20Improvement`
- `Cheers`
- `Modern%20Family`
- `Seinfeld`
- `The%20Office`
- `The%20Goldbergs`
- `Gilmore%20Girls`
- `Frasier`
- `Breaking%20Bad`
- `Scrubs`
- `Boy%20Meets%20World`
- `Everybody%20Loves%20Raymond`
- `The%20Good%20Place`
- `Brooklyn%20Nine-Nine`
- `Everybody%20Hates%20Chris`
- `Lucifer`
- `Schitt's%20Creek`
- `Derry%20Girls`
- `Friends`
- `Stranger%20Things`
- `The%20Golden%20Girls`

</details>

## Your Challenge:

Right now, this playbook will always return quotes from the show *Frasier* (a Chad favorite ❤️). Edit the playbook so that:

---

### **1. The show returning the quote is set by a variable, rather than being hard-coded to *Frasier*.**

<details>
<summary>Gimme a hint!</summary>
<br>

- Hint 1: You’ll need to remove the hard-coded show name and replace it with a variable.

<details>
<summary>Need another hint?</summary>
<br>

- Hint 2: Define a variable, for example, `show_name` and set it to the show you want. Then use `{{ show_name }}` in the URL instead of the hard-coded "Frasier."

<details>
<summary>Want another hint?</summary>
<br>

- Hint 3: Remember that query parameters go at the end of the URL, like this: `?show={{ show_name }}`.

<details>
<summary>Want the solution?</summary>
<br>

```yaml
vars:
  baseurl: "https://quotes.alakhpc.com/quotes"
  show_name: "Friends"  # Replace "Friends" with any other show name

tasks:
  - name: Get a random quote from a specific show
    uri:
      url: "{{ baseurl }}?show={{ show_name }}"
    register: quote_response
```

</details>
</details>
</details>
</details>

---

### **2. Add the `short` query parameter (as shown in the table above) to the URL.**

<details>
<summary>Gimme a hint!</summary>
<br>

- Hint 1: The `short` parameter is another query parameter that should be added to the end of the URL.

<details>
<summary>Need another hint?</summary>
<br>

- Hint 2: Add the `short` parameter with a default value `false` in the query string like you did with the show name.

<details>
<summary>Want another hint?</summary>
<br>

- Hint 3: The URL should look like this: `?show={{ show_name }}&short=false`.

<details>
<summary>Want the solution?</summary>
<br>

```yaml
vars:
  baseurl: "https://quotes.alakhpc.com/quotes"
  show_name: "Friends"  # Variable for the show

tasks:
  - name: Get a random quote with the short parameter
    uri:
      url: "{{ baseurl }}?show={{ show_name }}&short=false"
    register: quote_response
```

</details>
</details>
</details>
</details>

---

### **3. If you have time, define the value of the `short` parameter as a variable as well. Set it to `"false"` by default. It is IMPORTANT that you use "quotes"! (you'll see why)**

<details>
<summary>Gimme a hint!</summary>
<br>

- Hint 1: To make `short` configurable, declare it as a variable in the playbook's `vars` section.

<details>
<summary>Need another hint?</summary>
<br>

- Hint 2: Set the default value of `short` to `false` in the `vars` section, just like `show_name`.

<details>
<summary>Want another hint?</summary>
<br>

- Hint 3: You should declare `short` as a variable like this: `short: false`.

<details>
<summary>Want the solution?</summary>
<br>

```yaml
vars:
  baseurl: "https://quotes.alakhpc.com/quotes"
  show_name: "Friends"
  short: false  # Define the short parameter as a variable

tasks:
  - name: Get a random quote with variables for both show and short
    uri:
      url: "{{ baseurl }}?show={{ show_name }}&short={{ short }}"
    register: quote_response
```

</details>
</details>
</details>
</details>
