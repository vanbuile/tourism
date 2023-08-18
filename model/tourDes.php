<?php 
require_once("tourismConnection.php");
class TourDes {
    static function insert($tour_id, $schedule_number, $point_of_interest_id, $start_time, $end_time, $description) {
        $conn = DB::getInstance();
        $query = "INSERT INTO tour_destinations VALUES('$tour_id', $schedule_number, $point_of_interest_id,'$start_time', '$end_time','$description')";
        $result = mysqli_query($conn, $query);
    }
}
?>