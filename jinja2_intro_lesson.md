# Jinja2 and the Ansible Template Module

### Lab Objective

  - To build Jinja templates and gain and understanding of how templating can be leveraged with NetBox.  

### Procedure

1. Jinja2 is a templating engine that helps transform raw data into dynamic content. Its core features include variables `{{ variable }}` for data insertion, control structures such as loops `{% for item in list %}` and conditional statements `{% if condition %}`, alongside filters `{{ name | capitalize }}` for data formatting. This functionality is key in customizing text outputs, making it a valuable tool for tasks involving NetBox.
  
0. To save us from hopping around inside of Netbox and making a lot of changes we'll have to undo later, head to this free [Jinja2 templating site](https://j2live.ttl255.com/). This site is designed to help you test a Jinja Template, and is perfect for learning how they work. Copy the information below into the 'Jinja2 Template' and 'Jinja2 Data' fields respectively:

    **Jinja2 Template**
    ```
    Welcome to {{ name }}'s Pet Store!
    We have the following animals for adoption:
    
    NAME: {{ petname }}
    SPECIES: {{ petspecies }}
    PREFERRED FOOD: {{ petfavfood }}
    ```

     **Jinja2 Data**
     ```
     {
       "name": "<YOUR NAME HERE>",
       "petname": "Spot",
       "petspecies": "dog",
       "petfavfood": "kibble"
     }
     ```

    Click the `Render Template` button.

    <details><Summary>Rendered Template</Summary>

    Welcome to Frank's Pet Store!
    We have the following animals for adoption:
  
    NAME: Spot
    SPECIES: dog
    PREFERRED FOOD: kibble

    </details>

0. You'll see the that the JSON key's values replaced the template's variable named between the double curly braces. You'll see our rendered template on the right. Note if even a single character is wrong it can throw off the final result.

0. Jinja templates can, of course, manage complex data structures beyond simple JSON. In this example, we observe Jinja utilizing control structures, specifically a 'for' loop, to iterate over a collection of objects. This allows dynamic generation of content based on the properties of each object in the 'pets' list

    **Jinja2 Template** box:
    ```
    Welcome to {{ name }}'s Pet Store!
    We have the following animals for adoption:
    
    {% for each_pet in pets %}
    NAME: {{ each_pet.petname }}
    SPECIES: {{ each_pet.petspecies }}
    PREFERRED FOOD: {{ each_pet.petfavfood }}
    {% endfor %}
    ```

    **Jinja2 Data** box:
    ```
    {
      "name": "Chad",
      "pets": [
        {
          "petname": "Spot",
          "petspecies": "dog",
          "petfavfood": "kibble"
        },
        {
          "petname": "Socks",
          "petspecies": "cat",
          "petfavfood": "tuna"
        },
        {
          "petname": "Berzerker",
          "petspecies": "hamster",
          "petfavfood": "fingers"
        }
      ]
    }
    ```

    Click the `Render Template` button.

    <details><Summary>Rendered Template</Summary>
    
    Welcome to Chad's Pet Store!
    We have the following animals for adoption:
    
    
    NAME: Spot
    SPECIES: dog
    PREFERRED FOOD: kibble
    
    NAME: Socks
    SPECIES: cat
    PREFERRED FOOD: tuna
    
    NAME: Berzerker
    SPECIES: hamster
    PREFERRED FOOD: fingers

    </details>

0. Next, we'll introduce an additional layer of complexity by integrating an 'if' condition within the 'for' loop, effectively filtering the displayed data based on specific criteria:
   
    **Jinja2 Template** box:
    ```
    Welcome to {{ name }}'s Pet Store!
    We have the following animals for adoption:
    
    {% for each_pet in pets %}{% if each_pet.petfavfood != "fingers" %}
    NAME: {{ each_pet.petname }}
    SPECIES: {{ each_pet.petspecies }}
    PREFERRED FOOD: {{ each_pet.petfavfood }}
    {% endif %}{% endfor %}
    ```

    Click the `Render Template` button.
