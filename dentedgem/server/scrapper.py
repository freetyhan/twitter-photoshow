from twitter_functions import *
import database_to_MYSQL 
import glob
import os
import mysql.connector
import time

def main():
    mydb = mysql.connector.connect(host='137.184.230.178',database='photo_gallery',user='aks',password='123',autocommit=True)
        
    mycursor = mydb.cursor()

    sql = "SELECT username FROM usernames"
    mycursor.execute(sql)
    myresult = mycursor.fetchall()

    updated_search_list = ""

    for i in myresult:
        updated_search_list += i[0] + " OR "

    print(updated_search_list)

    #if updated_search_list != "":
        #scrap_twitter_routine(search = updated_search_list)
    #else:  
    mydb.close()
    scrap_twitter_routine()


if __name__ == "__main__":
   # while(True):
        print("START Scrappping")
        main()
        print("Done Scrappping")

        print("START: database updates")
        database_to_MYSQL.main()
        print("DONE: database updates")

        #MIN_30 = 60 * 30 #this timer holds 30 Minutes
        #time.sleep(MIN_30)