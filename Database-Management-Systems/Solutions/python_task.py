from __future__ import print_function

import cx_Oracle
from treelib import Node, Tree
import json
import sys

region_db = {}
dataval = {}
def iterdict(d,h=None):
  if h is not None and h != 'children':
     h=int(h)
  sum = 0.0
  for k,v in d.items():
     if isinstance(v, dict):
         print(k)
         sum = iterdict(v,k)
     elif isinstance(v,list):
         for x in v:
            sum = sum + iterdict(x,k)

     else:
         print('here ',h)
         print (k,":",v)
         sum = v
  if h is not None and h != 'children':
    dataval[h] = sum
    print(region_db[h],' sum is ',sum)
  return sum
         
#tree = Tree()
#tree.create_node("INDIA","INDIA1",data=0)
#tree.create_node("MAHARASHTRA","MAHARASHTRA1",data=1,parent="INDIA1")
#tree.create_node("TAMIL NADU","TAMIL NADU1",data=2,parent="INDIA1")
#tree.create_node("CHENNAI","CHENNAI1",data=5,parent="TAMIL NADU1")
#tree.create_node("NAGPUR","NAGPUR1",data=3,parent="MAHARASHTRA1")
#tree.create_node("VNIT","VNIT1",data=3,parent="NAGPUR1")
#tree.create_node("KORADI","KORADI1",data=3,parent="NAGPUR1")
#tree.create_node("MUMBAI","MUMBAI1",data=4,parent="MAHARASHTRA1")
#complete_data = tree.to_json(with_data=True)
#resp = json.loads(complete_data)
#iterdict(resp)



# Connect as user "hr" with password "welcome" to the "oraclepdb" service running on this computer.


connection = cx_Oracle.connect("BCS53", "BCS53", "192.168.2.25:1521/ORCL")
print('CONNECTION ESTABLISHED')
cursor = connection.cursor()
cursor2 = []
#ASSUMPTION THAT ROOT HAS ID=1
cursor.execute("""
    WITH tb as( SELECT hierarchy.id ID1,region,parent,value from hierarchy LEFT OUTER JOIN hierarchyValues ON hierarchy.id=hierarchyvalues.id) SELECT ID1,region,parent,value from tb connect by prior ID1 = parent start with ID1=1
    """
    )
tree = Tree()
for id,region,parent,data in cursor:
    print(id,end=' ')
    print(region,end=' ')
    if parent is not None:
        print(int(parent),end=' ')
    else:
        print(None,end=' ')
    print(data)
    if parent is not None:
        if data is not None:
            tree.create_node(id,id,data=data,parent=parent)
        else:
            tree.create_node(id,id,data=0,parent=parent)
    else:
        if data is not None:
            tree.create_node(id,id,data=data)
        else:
            tree.create_node(id,id,data=0)
    dataval[region] = 0
    cursor2.append([id,region,parent,data])
    region_db[id] = region

complete_data = tree.to_json(with_data=True)
resp = json.loads(complete_data)
print('JSON RESULT IS ',resp)
iterdict(resp)

for x in dataval:
    print(x,dataval[x])


tree2 = Tree()
for id,region,parent,data in cursor2:
    print('CURSOR 2 ',id,region,parent,data)
    print('')
    region = region + ' (' + str(dataval[id]) + ')'
    if parent is not None:
        if data is not None:
            tree2.create_node(region,id,data=data,parent=parent)
        else:
            tree2.create_node(region,id,data=0,parent=parent)
    else:
        if data is not None:
            tree2.create_node(region,id,data=data)
        else:
            tree2.create_node(region,id,data=0)
tree2.show()


#export LD_LIBRARY_PATH=/opt/oracle/instantclient_18_5