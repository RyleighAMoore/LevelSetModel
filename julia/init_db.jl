using SQLite

conn = SQLite.DB("perc.sqlite")

SQLite.execute!(conn, """CREATE TABLE IF NOT EXISTS
                         simulations(
                         pc REAL,
                         p1 REAL,
                         p2 REAL,
                         num_surfaces INT,
    start_time TEXT,
    end_time TEXT,
    labeling_neighborhood INT ,
    dec_round INT, 
    deltax REAL,
    accuracy REAL, 
    perc_direction TEXT,
    data_dir TEXT,
    user TEXT)""")
