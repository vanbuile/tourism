<?php
require_once("../model/tour.php");
require_once("../model/branch.php");
    $branch_ids = Branch::getAllId();
    if(isset($_POST["btnsubmit"])) {

      $target_dir = "../uploads/";
      $target_file = $target_dir . basename($_FILES["fileToUpload"]["name"]);
      $uploadOk = 1;
      $imageFileType = strtolower(pathinfo($target_file,PATHINFO_EXTENSION));

      // Check if image file is a actual image or fake image


      // Check if file already exists
      if (file_exists($target_file)) {
        echo "Sorry, file already exists.";
        $uploadOk = 0;
      }


      if ($uploadOk == 0) {
        echo "Sorry, your file was not uploaded.";
      // if everything is ok, try to upload file
      } else if (!move_uploaded_file($_FILES["fileToUpload"]["tmp_name"], $target_file)) 
          echo "Sorry, there was an error uploading your file.";
      


       $tour_name = $_POST['tourName'];
       $branch_id = $_POST['branch_id'];
       $photo = $target_file;
       $start_date = $_POST['start_date'];
       $min_tour_guest = $_POST['minP'];
       $max_tour_guest = $_POST['maxP'];
       $single_adult_price = $_POST['SingleAdult'];
	     $single_child_price = $_POST['SingleChild'];
	     $group_adult_price = $_POST['GroupAdult'];
	     $group_child_price = $_POST['GroupChild'];
	     $min_group_guests = $_POST['minG'];
       $nights = $_POST['nights'];
       $days = $_POST['days'];

       Tour::insert($tour_name,
        $photo,
        $start_date,
        $min_tour_guest,
        $max_tour_guest,
        $single_adult_price,
        $single_child_price,
        $group_adult_price, 
        $group_child_price,
        $min_group_guests,
        $nights,
        $days,
        "CN".$branch_id
        );
        $id = Tour::getId($tour_name);


        $conn = DB::getInstance();
        for($i = 1; $i<= $day; $i++){
          $query = "INSERT INTO Tour_schedules (tour_id, schedule_number) 
          VALUES('$id',$i)";
          $result = mysqli_query($conn, $query);
        }
        
    /////////////////////////////////////////////////////////// add sth here
        header("Location: ../views/addTourDes.php?tour_id=$id");

    }
    else {
      echo  $_POST['tour_name'];
    }
?>