import pytest
from sqlalchemy import create_engine, func, distinct, and_, not_, select
from sqlalchemy.orm import sessionmaker
from create_tables import Reserve, Boat, Sailor  # Assuming your SQLAlchemy models are defined in a module named your_module

@pytest.fixture
def session():
    engine = create_engine('sqlite:///example.db')
    Session = sessionmaker(bind=engine)
    session = Session()
    yield session
    session.close()

def test_question1(session):
    # Perform the query
    query_result = (
        session.query(Boat.bname, Reserve.bid, func.count().label('rsvps'))
        .join(Reserve, Boat.bid == Reserve.bid)
        .group_by(Boat.bname, Reserve.bid)
        .order_by(Boat.bname, Reserve.bid).all()
    )
    
    # Assert the query result
    expected_result = [
        ('Clipper', 103, 3),
        ('Clipper', 104, 5),
        ('Driftwood', 108, 1),
        ('Driftwood', 109, 4),
        ('Interlake', 101, 2),
        ('Interlake', 102, 3),
        ('Klapser', 110, 3),
        ('Marine', 105, 3),
        ('Marine', 106, 3),
        ('Marine', 107, 1),
        ('Sooney', 111, 1),
        ('Sooney', 112, 1)
    ]
    
    assert query_result == expected_result

def test_question2(session):
    # Perform the query
    query_result = (
        session.query(Sailor.sname, Reserve.sid)
        .join(Boat, Boat.bid == Reserve.bid)
        .join(Sailor, Sailor.sid == Reserve.sid)
        .filter(Boat.color == 'red')
        .group_by(Sailor.sname, Reserve.sid)
        .order_by(Sailor.sname, Reserve.sid)
        .all()
    )
    # Assert the query result
    expected_result = [
        ('dan', 88),
        ('dusting', 22),
        ('dye', 89),
        ('emilio', 23),
        ('figaro', 35),
        ('horatio', 64),
        ('lubber', 31),
        ('ossola', 61),
        ('scruntus', 24),
        ('shaun', 62),
        ('stum', 59)
    ]
    assert query_result == expected_result


def test_question3(session):
    # red boats
    red_boats_subquery = (
    session.query(Sailor.sname, Reserve.sid)
    .join(Boat, and_(Boat.bid == Reserve.bid, Boat.color == 'red'))
    .filter(Sailor.sid == Reserve.sid)
    .subquery()
    )

    # non-red boats
    non_red_boats_subquery = (
        session.query(Sailor.sname, Reserve.sid)
        .join(Boat, and_(Boat.bid == Reserve.bid, not_(Boat.color == 'red')))
        .filter(Sailor.sid == Reserve.sid)
        .group_by(Sailor.sname, Reserve.sid)
        .subquery()
    )

    # Perform the main query to get the difference between the two subqueries
    query_result = (
        session.query(red_boats_subquery.c.sname, red_boats_subquery.c.sid)
        .except_(session.query(non_red_boats_subquery.c.sname, non_red_boats_subquery.c.sid))
        .all()
    )

    # breakpoint()
    # Assert the query result
    expected_result = [
        ('emilio', 23), 
        ('figaro', 35), 
        ('ossola', 61), 
        ('scruntus', 24), 
        ('shaun', 62)
    ]
    assert query_result == expected_result

def test_question4(session):
    # test query
    query_result = (
    session.query(Boat.bname, Reserve.bid, func.count().label('rsvps'))
    .join(Reserve, Boat.bid == Reserve.bid)
    .group_by(Boat.bname, Reserve.bid)
    .order_by(func.count().desc())
    .limit(1)
    .all()
)
    # breakpoint()
    # Assert the query result
    expected_result = [('Clipper', 104, 5)]
    assert query_result == expected_result

def test_question5(session):
    # red boats
    red_boats_subquery = (
    session.query(Sailor.sname, Reserve.sid)
    .join(Boat, and_(Boat.bid == Reserve.bid, Boat.color == 'red'))
    .filter(Sailor.sid == Reserve.sid)
    .subquery()
    )

    # non-red boats
    non_red_boats_subquery = (
        session.query(Sailor.sname, Reserve.sid)
        .join(Boat, and_(Boat.bid == Reserve.bid, not_(Boat.color == 'red')))
        .filter(Sailor.sid == Reserve.sid)
        .group_by(Sailor.sname, Reserve.sid)
        .subquery()
    )

    # Perform the main query to get the difference between the two subqueries
    query_result = (
        session.query(non_red_boats_subquery.c.sname, non_red_boats_subquery.c.sid)
        .except_(session.query(red_boats_subquery.c.sname, red_boats_subquery.c.sid))
        .all()
    )

    # breakpoint()
    # Assert the query result
    expected_result = [
        ('horatio', 74), 
        ('jit', 60), 
        ('vin', 90)
    ]

    assert query_result == expected_result

def test_question6(session):
    # red boats
    avg_age = (
        session.query(func.avg(Sailor.age))
        .filter(Sailor.rating == 10)
        .scalar()
    )
    assert avg_age == 35

    
def test_question7(session):
    # test query
    query_result = (
        session.query(Sailor.rating, func.min(Sailor.sname))
        .group_by(Sailor.rating)
        .order_by(Sailor.rating)
        .all()
    )
    
    expected_result = [
        (1, 'brutus'),
        (3, 'art'),
        (7, 'dusting'),
        (8, 'andy'),
        (9, 'dan'),
        (10, 'jit')
    ]
    assert query_result == expected_result

def test_question8(session):
    # Define the maximum reservations subquery using ORM query constructs
    max_reservations_subquery = (
        session.query(func.count().label('max_rsvps'))
        .filter(Reserve.bid == Boat.bid)
        .filter(Reserve.bid == Reserve.bid)
        .group_by(Reserve.sid)
        .filter(Reserve.bid == Boat.bid)
        .filter(Reserve.sid == Sailor.sid)
        .group_by(Reserve.bid)
        .correlate(Boat)
        .as_scalar()
    )

    # Main query to select distinct boats, sailors, and count of reservations
    query_result = (
        session.query(distinct(Boat.bid), Sailor.sname, func.count().label('rsvps'))
        .join(Reserve, Boat.bid == Reserve.bid)
        .join(Sailor, Sailor.sid == Reserve.sid)
        .group_by(Boat.bid, Sailor.sname)
        .having(func.count().label('rsvps') >= max_reservations_subquery)
        .order_by(Boat.bid)
        .all()
    )
    expected_result = [(101, 'dusting', 1), (101, 'horatio', 1), (102, 'dusting', 1), (102, 'horatio', 1),
                       (102, 'lubber', 1), (103, 'dusting', 1), (103, 'horatio', 1), (103, 'lubber', 1), 
                       (104, 'dusting', 1), (104, 'emilio', 1), (104, 'figaro', 1), (104, 'lubber', 1), 
                       (104, 'scruntus', 1), (105, 'emilio', 1), (105, 'figaro', 1), (105, 'stum', 1), 
                       (106, 'jit', 2), (106, 'stum', 1), (107, 'dan', 1), (108, 'dye', 1), 
                       (109, 'dye', 1), (109, 'jit', 1), (109, 'stum', 1), (109, 'vin', 1), 
                       (110, 'dan', 2), (110, 'shaun', 1), (111, 'dan', 1), (112, 'ossola', 1)
                       ]
    assert query_result == expected_result