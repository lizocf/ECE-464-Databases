# PSET 2: Writeup

## Webscraping
I mostly followed this [tutorial](https://oxylabs.io/blog/python-web-scraping) to scrape the IMDB website for the top 250 movies of all time. The first 
step I took was to inspect the top 250 movies [URL](https://www.imdb.com/chart/top/) to find which class the movie titles were listed in. I noticed that there were many ways to do this,
one being to just parse the database for any instance of ``class='ipc-title__text'``. The method I ended up choosing was parsing the entire list-of-movies class
and look for ``h3`` instead. I found this to be easier because it was the most similar to what the tutorial I followed did.
![image](https://github.com/lizocf/ECE-464-Databases/assets/91501112/3864c794-e01c-46dd-a783-b16aa71cf0a2)

I didn't want to keep just the titles of the top 250 movies. I wanted to get the date it was made, the rating of the movie, and its runtime. This seemed to be
a little more difficult than finding the title because each of these was in the same class name.
To get each information, I realized that there was a built-in ``find_next()`` function in BeautifulSoup, which is very neat. :) ![image](https://github.com/lizocf/ECE-464-Databases/assets/91501112/7abd608a-ed30-4d89-b727-a3bb8b9b193f)

## Data Storage
I decided to store each of these features in a pandas DataFrame because I am most familiar in doing so. There were 250 rows in total with four columns: Titles, Ratings, Runtimes, and Dates.
For my NoSQL database, I chose MongoDB. I learned that MongoDB takes in dictionaries as their data, so I converted my top250.csv file back into a dictionary. I also cleaned it up a bit (removed
numbering in each title and add ID's) before adding it to my ``imdb_top_250`` collection. Below are the queries I tested: 
```
# QUERIES

# sort names alphabetically
sort_titles = coll.find().sort("Titles")

# how many of the top 250 movies are rated R?
rated_R = list(coll.find({'Ratings': 'R'}))
num_rated_R = len(rated_R)                              # 99 movies! :o
print(num_rated_R)

# what is the oldest movie in the top 250 list?
oldest = coll.find().sort("Dates").limit(1)             # "The Kid", 1921!
for old in oldest:
    print(old)

# what rank is the newest movie at in the top 250 list?
newest = coll.find().sort("Dates", -1).limit(1)             
for new in newest:
    print(new.get('_id'))                               # Rank: 15, Dune pt 2 :o
```
