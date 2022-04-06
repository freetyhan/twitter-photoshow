<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    <title>administrative_page_CPEN391</title>
    <link rel="stylesheet" href="./assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/baguettebox.js/1.10.0/baguetteBox.min.css">
    <link rel="stylesheet" href="./assets/css/Lightbox-Gallery.css">
    <link rel="stylesheet" href="styles.css">
</head>

<body>
    <nav class="navbar navbar-light navbar-expand-md bg-info" style="--bs-secondary: #6c757d;--bs-secondary-rgb: 108,117,125;--bs-body-bg: var(--bs-gray-200);margin-bottom: 10px;--bs-info: #c6c7d6;--bs-info-rgb: 198,199,214;">
        <div class="container-fluid"><a class="navbar-brand" href="index.php">Restaurant Dishes Slideshow <strong>Admin Page</strong></a><button data-bs-toggle="collapse" class="navbar-toggler" data-bs-target="#navcol-1"><span class="visually-hidden">Toggle navigation</span><span class="navbar-toggler-icon"></span></button>
            <div class="collapse navbar-collapse" id="navcol-1">
                <ul class="navbar-nav"></ul><a class="btn btn-primary border rounded ms-auto" role="button" style="background: var(--bs-gray-dark);color: var(--bs-gray-200);" href="mange.php">Manage</a>
            </div>
        </div>
    </nav><!-- Start: 1 Row 2 Columns -->
    <div class="container">
        <div class="row">
            <div class="col-md-6 text-capitalize" style="width: 70%;">
                <div class="row">
                    <div class="col">
                        <h1 class="fs-4">Preview</h1>
                        <hr>
                    </div>
                </div>
                <div class="row">
                    <?php 
                        $connect = mysqli_connect("137.184.230.178", "aks", "123", "photo_gallery");
                        global $connect;
                        if(isset($_POST["sAppColour"])) { // setting background colour
                            $selected_color= $_POST['sColor'];
                            $selected_color_hex = hexdec($selected_color);
                            $colorQuery = "UPDATE configuration SET background_colour = '$selected_color_hex' WHERE id=1";
                            $colorResult = mysqli_query($connect, $colorQuery);
                        }
                        
                        // setting background colour of preview
                        $query = 'SELECT background_colour FROM configuration WHERE id=1';
                        $result = mysqli_query($connect, $query); // this is retrieving colour from database
                        $fetchedResult = mysqli_fetch_assoc($result);
                        $currentColour = dechex($fetchedResult['background_colour']);
                        if($currentColour === 0) $currentColour = '121212';
                        echo '<div class="col" id="imageBackground" style="text-align: center;background: #'.$currentColour.';">'; 

                        if(isset($_POST["sOps"])) { // setting show options
                            $show_twitter_name = (int)isset($_POST['show_twitter_name']);
                            $show_username = (int)isset($_POST['show_username']);
                            $show_caption = (int)isset($_POST['show_caption']);
                            $show_dish_name = (int)isset($_POST['show_dish_name']);

                            $Opsquery1 = "UPDATE configuration SET show_twitter_name = '$show_twitter_name' WHERE id=1";
                            $Opsquery2 = "UPDATE configuration SET show_username = '$show_username' WHERE id=1";
                            $Opsquery3 = "UPDATE configuration SET show_caption = '$show_caption' WHERE id=1";
                            $Opsquery4 = "UPDATE configuration SET show_dish_name = '$show_dish_name' WHERE id=1";

                            $Opsresult1 = mysqli_query($connect, $Opsquery1);
                            $Opsresult2 = mysqli_query($connect, $Opsquery2);
                            $Opsresult3 = mysqli_query($connect, $Opsquery3);
                            $Opsresult4 = mysqli_query($connect, $Opsquery4);
                        }
                    ?>
                        <div id="textover" style="color: #000000; background-color:#FFFFFF; opacity:0.65; margin: 0px 0px; padding: 0px 10px;">
                            <?php // retrieve checkbox selected result to the preview
                                $query = 'SELECT * from configuration WHERE id = 1';
                                $result = mysqli_query($connect, $query);
                                $fetchedResult = mysqli_fetch_assoc($result);
                                if($fetchedResult['show_twitter_name'] == 1) {
                                    echo '<small id="twitter-name">Twitter name<br></small>';
                                }
                                if($fetchedResult['show_username'] == 1) {
                                    echo '<small id="twitter-username">@username<br></small>';
                                }
                                if($fetchedResult['show_caption'] == 1) {
                                    echo '<small id="twitter-caption" >caption <br></small>';
                                }
                                if($fetchedResult['show_dish_name'] == 1) {
                                    echo '<small id="dish-name" >dish name</small>';
                                }
                            ?>
                        </div>
                        <div id="blackCover" class="cover"></div>
                        <img id="testimg" class="img-fluid" src="./assets/img/testing%20photo.jpg" style="background: transparent;width: 500px;" />
                    </div>
                </div>
            </div>
            <div class="col-4 col-md-6 text-capitalize" style="width: 30%;">
                <div class="row">
                    <div class="col-auto">
                        <div class="row">
                            <div class="col">
                                <div class="row">
                                    <div class="col">
                                        <h1 class="fs-5">Twitter Hashtag # or Handle @</h1>
                                        <form action="" method="post">
                                        <textarea id="hash-handle-textarea" name="handles" rows="3" cols="40%" placeholder="Separate each word by comma"><?php 
                                            // code to update handles on save button 
                                            if(isset($_POST["sHandle"])) {
                                                $handles= $_POST['handles'];
                                                $handlesArr = explode(',' , $handles);
                                                $deleteAllQuery = "DELETE FROM usernames";
                                                $deleteAllResult = mysqli_query($connect, $deleteAllQuery); // delete all before displaying
                                                foreach($handlesArr as $value) {
                                                    $insertQuery = "INSERT INTO usernames (username) VALUES ('".$value."')";
                                                    $insertResult = mysqli_query($connect, $insertQuery);
                                                    if ($insertResult == TRUE) {
                                                        // don't do anything unless there is any error
                                                    } else {
                                                        echo '<script>alert("Error inserting handles record: " . $connect->error);</script>';
                                                    }
                                                }
                                            }
                                            
                                            // this is reading current data to the textarea
                                            $query = 'SELECT * from usernames';
                                            $result = mysqli_query($connect, $query);
                                            $usernames = array();
                                            while($username = mysqli_fetch_assoc($result)) { 
                                                $usernames[] = $username['username'];
                                            }
                                            $usernameStr = implode(',', $usernames);
                                            echo($usernameStr);
                                        ?></textarea>
                                        <input type="submit" value="Save" name="sHandle" id="hashHandleButton" class="btn btn-primary" style="background: var(--bs-gray-dark);" onclick="hashHandleParse()"/>
                                        </form>
                                        <hr>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col d-lg-flex align-items-lg-center">
                        <h1 class="fs-5">Background Colour</h1>
                        <form action="" method="post">
                        <input type="color" id="colorInputColor" name="sColor" style="margin: 0px 8px;" value=<?php
                            $query = 'SELECT background_colour FROM configuration WHERE id=1';
                            $result = mysqli_query($connect, $query); // this is retrieving colour from database
                            $fetchedResult = mysqli_fetch_assoc($result);
                            $currentColour = dechex($fetchedResult['background_colour']);
                            echo("#".$currentColour."");
                        ?>
                        />
                        <input type="submit" value="Apply" name="sAppColour" id="colorButton-1" class="btn btn-primary" style="margin: 0px 8px;background: var(--bs-gray-dark);" onclick="changeBackground()"/>
                        </form>
                        <hr>
                    </div>
                </div>
                <div class="row">
                    <div class="col">
                        <div class="row">
                            <div class="col">
                                <div class="row">
                                    <div class="col">
                                        <hr>
                                        <h1 class="fs-5">Display Options</h1>
                                        <form action="" method="post">
                                        <?php // form check retrieved from the database
                                            $query = 'SELECT * from configuration WHERE id = 1';
                                            $result = mysqli_query($connect, $query);
                                            $fetchedResult = mysqli_fetch_assoc($result);
                                            if($fetchedResult['show_twitter_name'] == 1) {
                                                echo '<div class="form-check" onclick="displayOptions()"><input class="form-check-input" type="checkbox" name="show_twitter_name" id="formCheck-1" checked=""><label class="form-check-label" for="formCheck-1">Show&nbsp;Twitter Name<br></label></div>';
                                            }
                                            if($fetchedResult['show_twitter_name'] == 0) {
                                                echo '<div class="form-check" onclick="displayOptions()"><input class="form-check-input" type="checkbox" name="show_twitter_name" id="formCheck-1"><label class="form-check-label" for="formCheck-1">Show&nbsp;Twitter Name<br></label></div>';
                                            }
                                            if($fetchedResult['show_username'] == 1) {
                                                echo '<div class="form-check" onclick="displayOptions()"><input class="form-check-input" type="checkbox" name="show_username" id="formCheck-2" checked=""><label class="form-check-label" for="formCheck-2">Show&nbsp;Twitter Username<br></label></div>';
                                            }
                                            if($fetchedResult['show_username'] == 0) {
                                                echo '<div class="form-check" onclick="displayOptions()"><input class="form-check-input" type="checkbox" name="show_username" id="formCheck-2"><label class="form-check-label" for="formCheck-2">Show&nbsp;Twitter Username<br></label></div>';
                                            }
                                            if($fetchedResult['show_caption'] == 1) {
                                                echo '<div class="form-check" onclick="displayOptions()"><input class="form-check-input" type="checkbox" name="show_caption" id="formCheck-3" checked=""><label class="form-check-label" for="formCheck-3">Show&nbsp;caption<br></label></div>';
                                            }
                                            if($fetchedResult['show_caption'] == 0) {
                                                echo '<div class="form-check" onclick="displayOptions()"><input class="form-check-input" type="checkbox" name="show_caption" id="formCheck-3"><label class="form-check-label" for="formCheck-3">Show&nbsp;caption<br></label></div>';
                                            }
                                            if($fetchedResult['show_dish_name'] == 1) {
                                                echo '<div class="form-check" onclick="displayOptions()"><input class="form-check-input" type="checkbox" name="show_dish_name" id="formCheck-4" checked=""><label class="form-check-label" for="formCheck-4">Show&nbsp;Dish Name<br></label></div>';
                                            }
                                            if($fetchedResult['show_dish_name'] == 0) {
                                                echo '<div class="form-check" onclick="displayOptions()"><input class="form-check-input" type="checkbox" name="show_dish_name" id="formCheck-4"><label class="form-check-label" for="formCheck-4">Show&nbsp;Dish Name<br></label></div>';
                                            }
                                        ?>
                                        <input type="submit" value="Save" name="sOps" class="btn btn-primary" style="margin: 5px 0px;background: var(--bs-gray-dark);"/>
                                        </form>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col">
                                        <hr>
                                        <h1 class="fs-5">Transition Effect</h1>
                                        <form action="" method="post">
                                            <?php
                                                if(isset($_POST["sTran"])) { // setting background colour
                                                    $selected_transition= $_POST['transitionsSel'];
                                                    $tranQuery = "UPDATE configuration SET transition_effect = '$selected_transition' WHERE id=1";
                                                    $tranResult = mysqli_query($connect, $tranQuery);
                                                }
                                            ?>
                                        <select name="transitionsSel" id="mySelect" onchange="transitions()">
                                            <option value="1">Random</option>
                                            <option value="2">Fade</option>
                                            <option value="3">Panning</option>
                                        </select>
                                        <input type="submit" value="Save" name="sTran" class="btn btn-primary" style="margin: 0px 8px;background: var(--bs-gray-dark);"/>
                                        </form>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col">
                                        <hr>
                                        <h1 class="fs-5">Offensive Keywords List</h1>
                                        <form action="" method="post">
                                        <textarea id="keyword-textarea" name="keywords" placeholder="Enter offensive keywords that you don't want. Separate each word by comma &quot;,&quot;" cols="40%"><?php
                                            // code to update keywords on save button 
                                            if(isset($_POST["sKeyApp"])) {
                                                $keywords= $_POST['keywords'];
                                                $keywordsArr = explode(',' , $keywords);
                                                $deleteAllQuery = "DELETE FROM keywords";
                                                $deleteAllResult = mysqli_query($connect, $deleteAllQuery);
                                                foreach($keywordsArr as $value) {
                                                    $insertQuery = "INSERT INTO keywords (keyword) VALUES ('".$value."')";
                                                    $insertResult = mysqli_query($connect, $insertQuery);
                                                    if ($insertResult == TRUE) {
                                                        // don't do anything unless there is any error
                                                    } else {
                                                        echo '<script>alert("Error inserting keywords record: " . $connect->error);</script>';
                                                    }
                                                }
                                            }
                                            
                                            // this is reading current data to the textarea
                                            $query = 'SELECT * from keywords';
                                            $result = mysqli_query($connect, $query);
                                            $keywords = array();
                                            while($keyword = mysqli_fetch_assoc($result)){ 
                                            $keywords[] = $keyword['keyword'];
                                            }
                                            $keywordStr = implode(',', $keywords);
                                            echo($keywordStr);
                                        ?></textarea>
                                        <input type="submit" value="Save" name="sKeyApp" id="hashHandleButton-1" class="btn btn-primary" style="background: var(--bs-gray-dark);" onclick="keywordParse()"/>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div><!-- End: 1 Row 2 Columns -->
    <!-- Start: Lightbox Gallery -->
    <section class="photo-gallery"></section><!-- End: Lightbox Gallery -->
    <script src="./assets/bootstrap/js/bootstrap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/baguettebox.js/1.10.0/baguetteBox.min.js"></script>
    <script src="./assets/js/Lightbox-Gallery.js"></script>
    <script src="manageFunctions.js"></script>
</body>

</html>