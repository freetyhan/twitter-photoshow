How to setup the environment for running the code?\
First run the setup.ipynb file in /server/twitter_scrapper_main. This file will download all the ML models, and classes required to run the Labeling.py script\

After downloading just run the main_routine.py file, now the script will run every ~2 minutes\
The imgconvert folder is used to test a shell script to embedd photos with text\
Lastly the database can be create using the schema file given

 - `script.sh` generates an image to be displayed on the DE1 VGA output, with 800x600 resolution with 16-bits color and in array of pixels format. It places the Twitter image in the middle of the image, add color to fill any blank spaces then overlays the Twitter username and caption on the top-left corner. It requires ImageMagick, Noto fonts, and img2c to work correctly.
 - `img2c` is based on the project xpol/img2c on GitHub. It generates a text file with all the pixel colors that makes up the image, in RGB565 format. We modified it to generate an output that can be parsed by DE1 Linux software easier.