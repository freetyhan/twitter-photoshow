from twitter_functions import *
import censorship
import glob
import os
import mysql.connector

def main():
    #find the latest file from the folder called database
    list_of_files = glob.glob('database/*') # * means all if need specific format then *.csv
    if list_of_files != []:
        
        print("START: database INSERT")

        latest_file = max(list_of_files, key=os.path.getctime)

        mydb = mysql.connector.connect(host='137.184.230.178',database='photo_gallery',user='aks',password='123',autocommit=True)   
        mycursor = mydb.cursor()
        
        tweets = read_JSON(latest_file)
        
        sql = f"REPLACE INTO tweets (id,twitter_id,created_at,name,username,caption,photo) VALUES (%s,%s, %s, %s, %s, %s, %s)"
        val = [(str(tweet['twitter_id'])+tweet['photo'][28:],tweet['twitter_id'],tweet['created_at'],tweet['name'],tweet['username'],tweet['caption'],tweet['photo']) for tweet in tweets]
        
        mycursor.executemany(sql, val)

        mydb.commit()
        mydb.close()
        print("DONE: database INSERT")
        
        print("Start: censorship")
        censorship.main()
        print("Done: censorship")
    else:
        print("None found")

if __name__ == "__main__":
    main()
   
        