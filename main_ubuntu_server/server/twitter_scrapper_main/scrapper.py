from twitter_functions import *
import database_to_MYSQL
import img_convert
import mysql.connector


def scrap():
    mydb = mysql.connector.connect(
        host='137.184.230.178', database='photo_gallery', user='aks', password='123', autocommit=True)

    mycursor = mydb.cursor()

    sql = "SELECT username FROM usernames"
    mycursor.execute(sql)
    myresult = mycursor.fetchall()

    updated_search_list = ""

    for i in myresult:
        updated_search_list += i[0] + " OR "

    print(updated_search_list)

    mydb.close()

    # if updated_search_list != "":
    #scrap_twitter_routine(search = updated_search_list)
    # else:

    scrap_twitter_routine()


def main():
    # while(True):
    print("START Scrappping")
    scrap()
    print("Done Scrappping")

    print("START: database updates")
    database_to_MYSQL.main()
    print("DONE: database updates")

    print("START: sending images to linux server")
    img_convert.main()
    print("DONE: sending images to linux server")


    # MIN_30 = 60 * 30 #this timer holds 30 Minutes
    # time.sleep(MIN_30)
if __name__ == "__main__":
    main()
