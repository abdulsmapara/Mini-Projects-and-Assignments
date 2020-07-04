from __future__ import print_function

import cx_Oracle
from treelib import Node, Tree
import json
import sys

region_db = {}
dataval = {}
average_sum={}
num_child = {}

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

def iterdict_again(d,h=None):
  if h is not None and h != 'children':
     h=int(h)
  avg = 0.0
  for k,v in d.items():
     if isinstance(v, dict):
         print(k)
         avg = iterdict_again(v,k)
     elif isinstance(v,list):
         count=0
         for x in v:
            avg = avg + iterdict_again(x,k)
            count=count+1
         avg = avg/count
     else:
         print('here ',h)
         print (k,":",v)
         avg = v
  if h is not None and h != 'children':
    average_sum[h] = avg
    print(region_db[h],' average id is ',avg)
  return avg

connection = cx_Oracle.connect("BCS53", "BCS53", "192.168.2.25:1521/ORCL")
print('CONNECTION ESTABLISHED')
cursor = connection.cursor()
cursor3 = connection.cursor()
cursor2 = []
cursor4 = []
#ASSUMPTION THAT ROOT HAS ID=1
cursor.execute("""
    WITH tb as( SELECT hierarchy.id ID1,region,parent,value,avg from hierarchy LEFT OUTER JOIN hierarchyValues ON hierarchy.id=hierarchyvalues.id) SELECT ID1,region,parent,value,avg from tb connect by prior ID1 = parent start with ID1=1
    """
    )

cursor3.execute("""
    WITH tb as( SELECT hierarchy.id ID1,region,parent,value,avg from hierarchy LEFT OUTER JOIN hierarchyValues ON hierarchy.id=hierarchyvalues.id) SELECT ID1,region,parent,value,avg from tb connect by prior ID1 = parent start with ID1=1
    """
    )

tree = Tree()
for id,region,parent,data,avg in cursor:
    print(id,end=' ')
    print(region,end=' ')
    if parent is not None:
        print(int(parent),end=' ')
    else:
        print(None,end=' ')
    print(data)

    if avg is None:
      avg = 0.0
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
    dataval[id] = 0
    cursor2.append([id,region,parent,data])
    region_db[id] = region

complete_data = tree.to_json(with_data=True)
resp = json.loads(complete_data)
print('JSON RESULT IS ',resp)

iterdict(resp)


tree21 = Tree()
for id,region,parent,data,avg in cursor3:
    data = None
    print(id,end=' ')
    print(region,end=' ')
    if parent is not None:
        print(int(parent),end=' ')
    else:
        print(None,end=' ')
    print(data)
    if avg is None:
      avg = 0.0
    if parent is not None:
        if data is not None:
            tree21.create_node(id,id,data=avg,parent=parent)
        else:
            tree21.create_node(id,id,data=avg,parent=parent)
    else:
        if data is not None:
            tree21.create_node(id,id,data=avg)
        else:
            tree21.create_node(id,id,data=avg)
    cursor4.append([id,region,parent,avg])

print('-----------------finished till here-------------')
complete_data = tree21.to_json(with_data=True)
resp = json.loads(complete_data)
print('JSON RESULT IS ',resp)

iterdict_again(resp)
   
for h in average_sum:
  print(h,' ',average_sum[h])

treefinal = Tree()

for id,region,parent,data in cursor2:
    if parent is not None:
      treefinal.create_node(region+' '+str(dataval[id])+' '+str(average_sum[id]),id,data=0,parent=parent)
    else:
      treefinal.create_node(region+' '+str(dataval[id])+' '+str(average_sum[id]),id,data=0)
treefinal.show()



tree22 = Tree()
for id,region,parent,data in cursor2:
    print('CURSOR 2 ',id,region,parent,data)
    print('')
    region = region + ' (' + str(dataval[id]) + ' ' + str(average_sum[id]) ')'
    if parent is not None:
        if data is not None:
            tree22.create_node(region,id,data=data,parent=parent)
        else:
            tree22.create_node(region,id,data=0,parent=parent)
    else:
        if data is not None:
            tree22.create_node(region,id,data=data)
        else:
            tree22.create_node(region,id,data=0)
tree2.show()


#export LD_LIBRARY_PATH=/opt/oracle/instantclient_18_5
