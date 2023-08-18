<?php
require_once("tourismConnection.php");
class TourAction {
    static function insert ($tour_id, $schedule_number, $action_type, $start_time, $end_time, $description) {
        $conn = DB::getInstance();
        $query = "INSERT INTO Tour_schedule_actions (tour_id, schedule_number, action_type, start_time, end_time, description)
        VALUES ('$tour_id',$schedule_number, '$action_type','$start_time','$end_time', '$description')";
        $result = mysqli_query($conn, $query);
    }
}
?>