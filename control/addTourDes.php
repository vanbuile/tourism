<?php

require_once("../model/tour.php");
require_once("../model/attraction.php");

$attractions = Attraction::getAll();
$tour_id = $_REQUEST['tour_id'];

$tour = Tour::get($tour_id);

if(isset($_POST['tourDesSubmit'])){
    TourDes::insert($_POST['tour_id'],
     $_POST['schedule_number'],
     $_POST['point_of_interest_id'],
     $_POST['start_time'],
     $_POST['end_time'],
     $_POST['description']);
     header("Location: ../views/addTourAction.php?tour_id=$tour_id");
}

?>