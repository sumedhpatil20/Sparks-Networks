import json
import requests
import pandas as pd
import snowflake.connector

ctx = snowflake.connector.connect(
    user = "<user_name>",
    password = "<password>",
    account = "<account_url>",
    role = "data_engineer",
    warehouse = "COMPUTE_WH"
)

cs = ctx.cursor()

url1 = """https://619ca0ea68ebaa001753c9b0.mockapi.io/evaluation/dataengineer/jr/v1/users/"""
url2 = """https://619ca0ea68ebaa001753c9b0.mockapi.io/evaluation/dataengineer/jr/v1/messages/"""

def insert_into_users(lst):
    email = lst[8][lst[8].index("@")+1:]
    query = f"""insert into RAW_DB.RAW_SCHEMA.USERS 
    (createdAt,updatedAt,city,country,zipCode,email_domain,birthDate,id,gender,smoking_condition,profession,income) values
    ('{lst[0]}','{lst[1]}','{lst[5]}','{lst[6]}','{lst[7]}','{email}','{lst[9]}','{lst[10]}','{lst[11]}','{lst[12]}','{lst[13]}','{lst[14]}');"""
    # print(query)
    cs.execute(query)

def insert_into_subscriptions(lst):
    query = f"""insert into RAW_DB.RAW_SCHEMA.SUBSCRIPTIONS 
    (user_id,createdAt,startDate,endDate,status,amount) values
    ({lst[0]},'{lst[1]}','{lst[2]}','{lst[3]}','{lst[4]}',{lst[5]});"""
    # print(query)
    cs.execute(query)

r = requests.get(url1)
ln = []
for line in r.iter_lines():
    ln = line 
data = json.loads(ln)
df = pd.json_normalize(data[:])
all_keys = list(df.keys())
subscription_keys = list(df['subscription'][0][0].keys())
# print(subscription_keys)
subscription_data = df['subscription']

for i in range (0,len(df)):
    list_users_row = []
    
    for keys in all_keys:
        if keys != 'subscription':
            list_users_row.append(df[keys][i])
        else:
            list_subscription_rows = []
            for j in range(0,len(subscription_data[i])):
                list_subscription_rows = []
                list_subscription_rows.append(df['id'][i])
                for keys in subscription_keys:
                    if len(subscription_data[i]) != 0 :
                        list_subscription_rows.append(subscription_data[i][j][keys])
                # print("subscription list -----  ",list_subscription_rows)
                insert_into_subscriptions(list_subscription_rows)
                # print()
    # print("users list -----  ",list_users_row)
    insert_into_users(list_users_row)


def insert_into_messages(lst):
    query = f"""insert into RAW_DB.RAW_SCHEMA.MESSAGES 
      (createdAt,receiverId,message_id,senderId) values
      ('{lst[0]}',{lst[2]},{lst[3]},{lst[4]});"""
    # print(query)
    cs.execute(query)

m = requests.get(url2)
ln = []
for line in m.iter_lines():
    ln = line 
data_msg = json.loads(ln)
df_msg = pd.json_normalize(data_msg[:])
all_keys = list(df_msg.keys())
# print(all_keys)
for i in range(0,len(df_msg)):
    list_user_msg = []
    for keys in all_keys:
        # print(keys,df_msg[keys][i])
        list_user_msg.append(df_msg[keys][i])
    insert_into_messages(list_user_msg)

