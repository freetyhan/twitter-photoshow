import mysql.connector
from profanity_filter import ProfanityFilter


def main():

    mydb = mysql.connector.connect(
        host='137.184.230.178', database='photo_gallery', user='aks', password='123', autocommit=True)
    mycursor = mydb.cursor()

    mycursor.execute("SELECT keyword FROM keywords")

    result = mycursor.fetchall()

    pf = ProfanityFilter()
    # changing the formatting
    result = [i[0] for i in result]
    print(result)

    pf.custom_profane_word_dictionaries = {'en': result}

    mycursor = mydb.cursor()

    mycursor.execute("SELECT id, caption FROM tweets")

    result = mycursor.fetchall()

    amt_censored = 0

    mydb.close()

    for i in result:
        tweet_id = i[0]
        # print(i[1])
        if pf.is_clean(i[1]):
            mydb = mysql.connector.connect(
                host='137.184.230.178', database='photo_gallery', user='aks', password='123', autocommit=True)
            mycursor = mydb.cursor()
            mycursor.execute(
                f"UPDATE tweets SET censored = false WHERE id = '{tweet_id}'")
            mydb.close()
        else:
            amt_censored += 1
            mydb = mysql.connector.connect(
                host='137.184.230.178', database='photo_gallery', user='aks', password='123', autocommit=True)
            mycursor = mydb.cursor()
            mycursor.execute(
                f"UPDATE tweets SET censored = true WHERE id = '{tweet_id}'")
            mydb.close()

    print(f"Amount Censored: {amt_censored}")


if __name__ == "__main__":
    main()
