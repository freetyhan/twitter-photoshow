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
    <nav class="navbar navbar-light navbar-expand-md bg-info" style="--bs-info: #c6c7d6;--bs-info-rgb: 198,199,214;margin-bottom: 10px;">
        <div class="container-fluid"><a class="navbar-brand" href="index.php">Restaurant Dishes Slideshow <strong>Admin Page</strong></a><button data-bs-toggle="collapse" class="navbar-toggler" data-bs-target="#navcol-1"><span class="visually-hidden">Toggle navigation</span><span class="navbar-toggler-icon"></span></button>
            <div class="collapse navbar-collapse" id="navcol-1">
                <ul class="navbar-nav"></ul><a class="btn btn-primary border rounded ms-auto" role="button" style="background: var(--bs-gray-dark);" href="mange.php">Manage</a>
            </div>
        </div>
    </nav>
    <div class="container">
        <h1>Preview photos</h1>
    </div><!-- Start: Lightbox Gallery -->
    <section class="photo-gallery">
        <div class="container">
            <div class="row row-cols-1 row-cols-md-3">
            <?php
            $connect = mysqli_connect("137.184.230.178", "aks", "123", "photo_gallery");
            global $connect;

            if(isset($_POST["sDel"])) { // Delete functionality
                $tweet_id = $_POST["sDelTweet"];
                $deleteQuery = "UPDATE tweets SET deleted = true WHERE id='$tweet_id'";
                $deleteResult = mysqli_query($connect, $deleteQuery);
                if ($deleteResult == TRUE) {
                    echo '<script>alert("This tweet is deleted successfully");</script>';
                } else {
                    echo '<script>alert("Error updating record: " . $connect->error);</script>';
                }
            }

            $query = 'SELECT * FROM tweets WHERE censored = false AND deleted = false';
            $result = mysqli_query($connect, $query); // this is placing tweets
            while($tweet = mysqli_fetch_assoc($result)){ 
                echo '<div class="col mb-4 d-flex">';
                echo '<div class="card">';
                    echo '<img class="card-img-top w-100 d-block" src='.$tweet['photo'].' style="width:244px; height:244px>';
                    echo '<div class="card-body">';
                        echo '<h4 class="card-title">'.$tweet['name'].' (@'.$tweet['username'].')</h4>';
                        echo '<h5 class="card-title">Dish name: '.$tweet['label'].'</h5>';
                        echo '<p class="card-text">'.$tweet['caption']. '.&nbsp;</p><br>';
                        echo '<form action="" method="post">';
                    echo '<input type="submit" value="Delete" name="sDel" id="'.$tweet['id'].'" class="btn btn-delete" formmethod="post"/>';
                        echo '<input type="hidden" name="sDelTweet" value="'.$tweet['id'].'"/>';
                        echo '</form>';
                echo '</div>';
                echo '</div>';
            }        
            ?>
            </div>
        </div>
        <hr>
    </section>
    <script src="./assets/bootstrap/js/bootstrap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/baguettebox.js/1.10.0/baguetteBox.min.js"></script>
    <script src="./assets/js/Lightbox-Gallery.js"></script>
    <script src="manageFunctions.js"></script>
</body>

</html>