# Check this <https://dev.to/dev0928/python-explore-standard-libraries-2g2n>

#############
# copy
#############

# import copy

# lst = [[1, 2, 3], ['a', 'b']]

# Standard assignment
# dup_lst = lst
# id object is used to check whether objects are pointing to the same reference
# print(id(dup_lst) == id(lst)) # True

# Use copy module's shallow copy
# dup_lst = copy.copy(lst)

# print(id(dup_lst) == id(lst)) # False
# Contents of the object are not duplicated with shallow copy => contents of the objects are pointing to the same reference
# print(id(dup_lst[0]) == id(lst[0])) # True

# Use copy module's deep copy
# dup_lst = copy.deepcopy(lst)

# print(id(dup_lst) == id(lst)) # False
# Contents of the object are duplicated with deep copy => contents of the objects are not pointing to the same reference
# print(id(dup_lst[0]) == id(lst[0])) # False

#############
# enum
#############

# import enum

# class DaysOfWeek(enum.Enum):
#     LUNDI = 1
#     MARDI = 2
#     MERCREDI = 3
#     JEUDI = 4
#     VENDREDI = 5
#     SAMEDI = 6
#     DIMANCHE = 7

# Les membres de l'énumération ont également un attribut qui contient leur nom
#print('Member name of Dimanche : ' + DaysOfWeek.DIMANCHE.name)

#for day in DaysOfWeek:
#    print(day)

#############
# webbrowser
#############

# import webbrowser

# url = 'https://google.com'

# Open URL in user's default browser and bring the browser window to the front
# webbrowser.open(url)

# Open URL in a new tab, if a browser window is already open
# webbrowser.open_new_tab(url)

#############
# pprint
#############

import pprint

book = {
    "title": "Automate the Boring Stuff with Python: Practical Programming for Total Beginners",
    "author": "Al Sweigart",
    "pub_year": 2015
}

print(book)
# {'title': 'Automate the Boring Stuff with Python: Practical Programming for Total Beginners', 'author': 'Al Sweigart', 'pub_year': 2015}

pp = pprint.PrettyPrinter(width=100, compact=True)
# Pretty print arranged keys in alphabetical order here display width is controlled to 100 characters
pp.pprint(book)
# {'author': 'Al Sweigart',
#  'pub_year': 2015,
#  'title': 'Automate the Boring Stuff with Python: Practical Programming for Total Beginners'}
