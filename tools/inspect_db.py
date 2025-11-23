import sqlite3

try:
    conn = sqlite3.connect('../include/db/site.db')
    cursor = conn.cursor()
    
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
    tables = cursor.fetchall()
    
    for table in tables:
        table_name = table[0]
        print(f"Table: {table_name}")
        
        cursor.execute(f"PRAGMA table_info({table_name});")
        columns = cursor.fetchall()
        for col in columns:
            # col[1] is name, col[2] is type
            print(f"  - {col[1]} ({col[2]})")
        print("")
        
    conn.close()
except Exception as e:
    print(f"Error: {e}")
