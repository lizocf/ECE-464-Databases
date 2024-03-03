from sqlalchemy import create_engine, Column, Integer, String, Date, ForeignKey
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base
from datetime import datetime

engine = create_engine('sqlite:///example.db')
Base = declarative_base()

class Sailor(Base):
    __tablename__ = 'sailors'

    sid = Column(Integer, primary_key=True)
    sname = Column(String(30))
    rating = Column(Integer)
    age = Column(Integer)

    # Define the relationship between Sailor and Reserve
    reserves = relationship("Reserve", back_populates="sailor")

class Reserve(Base):
    __tablename__ = 'reserves'

    sid = Column(Integer, ForeignKey('sailors.sid'), primary_key=True)
    bid = Column(Integer, ForeignKey('boats.bid'), primary_key=True)
    day = Column(Date, primary_key=True)

    sailor = relationship("Sailor", back_populates="reserves")
    boat = relationship("Boat")

class Boat(Base):
    __tablename__ = 'boats'

    bid = Column(Integer, primary_key=True)
    bname = Column(String(20))
    color = Column(String(10))
    length = Column(Integer)

    # Define the relationship between Boat and Reserve
    reserves = relationship("Reserve")

Base.metadata.create_all(engine)