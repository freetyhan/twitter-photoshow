import scrapper
import time

def main():
    while (True):
        scrapper.main()
        print("SLEEPING")
        time.sleep(60) #sleep every one minutes

if __name__ == "__main__":
    main()
