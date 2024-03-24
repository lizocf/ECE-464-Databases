import pandas as pd
from pymongo import MongoClient
import json

# start mongo docker
# docker pull mongodb/mongodb-community-server:latest
# docker run --name mongodb -p 27017:27017 -d mongodb/mongodb-community-server:latest

# start mongoDB
myclient = MongoClient("mongodb://localhost:27017/")
mydb = myclient["mydatabase"]
coll = mydb["imdb_top_250"]

# fetch data from top250.csv
data = pd.read_csv("top250.csv")
data['Titles'] = data['Titles'].str.split(n=1).str[1]   # get rid of ranking in titles

# convert to dict
data.reset_index(inplace=True)
data = data.rename(columns={"index": "_id"})
data['_id'] = data['_id'] + 1                           # just to make ranking make sense
data.to_csv('top250_mongo.csv', index=False, encoding='utf-8')
data_dict = data.to_dict("records")

# remove all data from collection
coll.delete_many({})


# upload data to mongo
x = coll.insert_many(data_dict)
# print(x.inserted_ids)


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