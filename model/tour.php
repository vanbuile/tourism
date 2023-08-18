<?php require_once("tourismConnection.php");?>
<?php
    
    class Tour{
        public $tour_id;
        public $tour_name;
        public $photo;
        public $start_date;
        public $min_tour_guests;
        public $max_tour_guests;
        public $single_adult_price;
        public $single_child_price;
        public $group_adult_price;
        public $group_child_price;
        public $min_group_guests;
        public $nights;
        public $days;
        public $branch_id;
        public function __construct($tour_id, $tour_name, $photo, $start_date, $min_tour_guests, $max_tour_guests, $single_adult_price, $single_child_price, $group_adult_price, $group_child_price, $min_group_guests, $nights, $days, $branch_id)
        {
            $this->tour_id = $tour_id; 
            $this->tour_name = $tour_name;
            $this->photo = $photo;
            $this->start_date = $start_date;
            $this->min_tour_guests = $min_tour_guests;
            $this->max_tour_guests = $max_tour_guests;
            $this->single_adult_price = $single_adult_price;
            $this->single_child_price = $single_child_price;
            $this->group_adult_price = $group_adult_price;
            $this->group_child_price = $group_child_price;
            $this->min_group_guests = $min_group_guests;
            $this->nights = $nights;
            $this->days = $days;
            $this->branch_id = $branch_id;
        }
        static function insert($tour_name, $photo, $start_date, $min_tour_guests, $max_tour_guests, $single_adult_price, $single_child_price, $group_adult_price, $group_child_price, $min_group_guests, $nights, $days, $branch_id) {
            $conn = DB::getInstance();
            $query = "INSERT INTO `Tours` (tour_name, photo, start_date, min_tour_guests, max_tour_guests, single_adult_price, single_child_price, group_adult_price, group_child_price, min_group_guests, nights, days, branch_id)
            VALUES
            ('$tour_name','$photo', '$start_date', $min_tour_guests, $max_tour_guests, $single_adult_price, $single_child_price, $group_adult_price, $group_child_price, $min_group_guests, $nights, $days, '$branch_id');";
            
            $result = $conn->query($query);
            
        }
        static function getYears(){
            $conn = DB::getInstance();
            $query = "SELECT DISTINCT YEAR(start_date) as year FROM tours";
            $result = mysqli_query($conn,$query);
            $years = [];
            while($row = mysqli_fetch_assoc($result)) {
                $years[] = $row['year'];
            }
            return $years;
        }
        static function get($tour_id) {
            $conn = DB::getInstance();
            $query = " select * from tours where tour_id = '$tour_id'";
            $result = mysqli_query($conn,$query);
            $row = $result->fetch_assoc();
            $tour = new Tour(
                $row['tour_id'],
                $row['tour_name'],
                $row['photo'],
                $row['start_date'],
                $row['min_tour_guests'],
                $row['max_tour_guests'],
                $row['single_adult_price'],
                $row['single_child_price'],
                $row['group_adult_price'],
                $row['group_child_price'],
                $row['min_group_guests'],
                $row['nights'],
                $row['days'],
                $row['branch_id']
            );
            return $tour;

        }
        static function getTours() {
            $conn = DB::getInstance();
            $query = " select * from tours ";
            $result = mysqli_query($conn,$query);
            $tours = [];
            while($row = mysqli_fetch_assoc($result)){
                $tours[] = new Tour(
                    $row['tour_id'],
                    $row['tour_name'],
                    $row['photo'],
                    $row['start_date'],
                    $row['min_tour_guests'],
                    $row['max_tour_guests'],
                    $row['single_adult_price'],
                    $row['single_child_price'],
                    $row['group_adult_price'],
                    $row['group_child_price'],
                    $row['min_group_guests'],
                    $row['nights'],
                    $row['days'],
                    $row['branch_id']
                );
            }
            return $tours;
        }
        static function getId($tour_name) {
            $conn = DB::getInstance();
            $query = "SELECT * FROM tours WHERE tour_name='$tour_name';";
            echo $query;
            $result = mysqli_query($conn,$query);
            $row = mysqli_fetch_assoc($result);
            return $row['tour_id'];
        }
    }
?>
