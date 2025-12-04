import pymysql

with open('/tmp/hp_updated.html', 'r') as f:
    content = f.read()

conn = pymysql.connect(host='localhost', user='ctfd', password='ctfd', database='ctfd')
cursor = conn.cursor()
cursor.execute("UPDATE pages SET content = %s WHERE route = 'index'", (content,))
conn.commit()
print(f"Updated! Rows affected: {cursor.rowcount}")
conn.close()
