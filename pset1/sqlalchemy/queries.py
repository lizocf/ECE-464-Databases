from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from create_tables import Sailor, Reserve, Boat
import pytest
# from populate_sailors import Session

# Create a session
engine = create_engine('sqlite:///example.db')
Session = sessionmaker(bind=engine)
session = Session()

# Query all sailors
all_sailors = session.query(Sailor).all()

# Print the data
# for sailor in all_sailors:
    # print(sailor.sid, sailor.sname, sailor.rating, sailor.age)

# Query all reserves
all_reserves = session.query(Reserve).all()

# Print the data
for reserve in all_reserves:
    print(reserve.sid, reserve.bid, reserve.day)

# Query all boats
all_boats = session.query(Boat).all()

# Print the data
# for boat in all_boats:
#     print(boat.bid, boat.bname, boat.color, boat.length)