import scrapper
import time

def main():
    while (True):
        scrapper.main()
        print("SLEEPING")
        time.sleep(120) #sleep every two minutes

if __name__ == "__main__":
    main()
