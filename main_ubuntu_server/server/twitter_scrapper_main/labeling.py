import mysql.connector
import requests
import os
import json

import keras
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd


def download_img(test_directory='images'):
    # first download all images onto a image file

    mydb = mysql.connector.connect(
        host='137.184.230.178', database='photo_gallery', user='aks', password='123', autocommit=True)

    mycursor = mydb.cursor()

    sql = "SELECT id, photo FROM tweets WHERE deleted = 0 AND censored = 0"
    mycursor.execute(sql)
    myresult = mycursor.fetchall()

    if not os.path.exists(test_directory+"/fpp"):
        os.makedirs(test_directory+"/fpp")

    for i in myresult:
        image_id = i[0]
        image_url = i[1]
        img_data = requests.get(image_url).content

        with open(f'{test_directory+"/fpp"}/{image_id.replace("/","")}', 'wb') as handler:
            handler.write(img_data)
    mydb.close()
    print('DONE: downloaded all images in database')


# returns a dict that holds img id's to labels
def model_predict(model_loc, class_loc, test_directory='images',):
    # Predict & submit
    # Uncomment to load previous model
    # model = tf.keras.models.load_model('/kaggle/input/ml-model-v2/whole_model_v4.h5')

    # Test data generator -> Rescale image size
    test_datagen = keras.preprocessing.image.ImageDataGenerator(
        rescale=1./255)

    # apply test_datagen to input files
    test_generator = test_datagen.flow_from_directory(
        directory=test_directory,
        target_size=(256, 256),
        shuffle=False,
        class_mode=None,
        batch_size=1)

    # Get the filenames & remove directory specification in front of filename
    filenames = [filename[4:] for filename in test_generator.filenames]

    # Not predicting in batches but each inidividual item, therefore we need to know the amount of predictions
    nb_samples = len(filenames)

    # Make predictions, returns probabilities for each class
    print(f'Making predictions....')
    model = keras.models.load_model(model_loc)
    model_predictions = model.predict(
        test_generator, steps=nb_samples, verbose=1)

    # Assign prediction to class with highest probability
    y_pred_labels = np.argmax(model_predictions, axis=1)

    # Map predictions to the correct labels
    with open(class_loc, "r") as read_file:
        labels = json.load(read_file)
    print(labels)
    print(y_pred_labels)
    predictions = [labels[str(k)] for k in y_pred_labels]

    # print(predictions)

    # Submit file
    # using zip()
    # to convert lists to dictionary
    label_dict = dict(zip(filenames, predictions))

    return label_dict


def remove_dir(test_directory='images'):
    if os.path.exists(test_directory):
        import shutil
        shutil.rmtree(test_directory)


def update_labels(label_dict, conditional, test_directory='images'):

    mydb = mysql.connector.connect(
        host='137.184.230.178', database='photo_gallery', user='aks', password='123', autocommit=True)
    mycursor = mydb.cursor()

    for i in label_dict:
        tweet_id = i
        tweet_label = label_dict[i].replace("_"," ").title()

        sql = f"UPDATE tweets SET label = '{tweet_label}' WHERE " + conditional.format(tweet_id=tweet_id)
        print(sql)
        mycursor.execute(sql)

    mydb.close()


def main():
    remove_dir()
    download_img()

    label_dict = model_predict(
        model_loc='binary_class_save0.96875acc', class_loc='binary_classes.json')

    update_labels(label_dict=label_dict, conditional="id = '{tweet_id}'")

    label_dict = model_predict(
        model_loc='save0.6137499809265137acc', class_loc='multi_classes.json')

    update_labels(label_dict=label_dict,
                  conditional="id = '{tweet_id}' AND label <> 'Non Food' ")

    remove_dir()
    print("DONE: Labeling all images!")


if __name__ == "__main__":
    main()
