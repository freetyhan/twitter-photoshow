#!/usr/bin/env python
# coding: utf-8

# In[1]:





# In[2]:


import twint
import json
import datetime
import os


# In[11]:



def scrape(search, previous_search_time, search_to, filename):    
    """
    :search: takes a string that follows twitter search format
    :search_from: takes a utc timestamp
    :search_to: takes a utc timestamp
    :output_name: takes a string for the name of the output json file   
    
    Note that there is a 15 minute cooldown from twitter 
    """
    #configuration
    config = twint.Config()
    config.Search = search
    config.Limit = 50
    
    config.Since = previous_search_time[0:18]
    #config.Until = search_to.strftime("%Y-%m-%d %H:%M:%S")

    config.Store_json = True
    config.Output = filename

    print(twint.run.Search(config))


# In[4]:


def read_JSON(input_file_name):
    if os.path.exists(input_file_name):    
        tweets = []
        with open(input_file_name, "r") as read_file:
            for line in read_file:
                tweets.append(json.loads(line))

        return tweets
    else:
        return []

def write_JSON(output_file_name, JSON_list): 
    with open(output_file_name, "w") as write_file:
        for tweet in JSON_list:
            json.dump(tweet, write_file)
            write_file.write("\r\n")
            


# In[5]:



        
def create_tweet(twitter_id,created_at, name, username, caption, photo):
    tweet = {
        'twitter_id':twitter_id,
        'created_at': created_at,
        'name': name,
        'username':username,
        'caption':caption,
        'photo':photo

    }
    return tweet   


# In[9]:


#given a string remove any URL or emoji from the string and return the modified string
import re
def strip_emoji(text):
    RE_EMOJI = re.compile('[\U00010000-\U0010ffff]', flags=re.UNICODE)
    return RE_EMOJI.sub(r'', text)
def strip_url(text):
    RE_EMOJI = re.compile("(?P<url>https?://[^\s]+)")
    return RE_EMOJI.sub(r'', text)
    
    


# In[12]:


def scrap_twitter_routine(search = "#tastyindianbistro",previous_search_time = "" ):
        
        current_time = datetime.datetime.now()
        
        filename = "temp/" + str(previous_search_time) + " to " + str(current_time) + ".json"         
        os.makedirs(os.path.dirname(filename), exist_ok=True)
        
        print("Scraping Twitter")
        scrape(search, previous_search_time, current_time, filename)
        
        unformatted_tweets = read_JSON(filename)
        
        #delete the temp file        
        if os.path.exists(filename):
            os.remove(filename)
        
        #convert unformatted tweets and only retain needed information
        
        formatted_tweets = []
        for tweet in unformatted_tweets:            
            for photo in tweet['photos']:                
                name = strip_url(strip_emoji(tweet['name']))
                caption = strip_url(strip_emoji(tweet['tweet']))
                formatted_tweets.append(create_tweet(tweet['id'],tweet['created_at'][0:19],name,tweet["username"],caption,photo)) 
                
        
        #print(formatted_tweets)
        
        filename = "database/" + str(previous_search_time) + " to " + str(current_time) + ".json" 
        os.makedirs(os.path.dirname(filename), exist_ok=True)
        
        if(len(formatted_tweets) != 0):
            write_JSON(filename, formatted_tweets)
            
            filename = "config/" + "latest_created_at_time.txt"
            os.makedirs(os.path.dirname(filename), exist_ok=True)
            write_JSON(filename,[formatted_tweets[0]['created_at']])
            
            filename = "config/" + "latest_handle_search.txt"
            os.makedirs(os.path.dirname(filename), exist_ok=True)
            write_JSON(filename,[search])
        
        #################################################################################

        print("done")
    


# In[ ]:




