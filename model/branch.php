<?php 
    require_once("tourismConnection.php");
    class Branch {
        public $branch_id;
        public $branch_name;
        
        public function __construct($branch_id, $branch_name){
            $this->branch_id = $branch_id;
            $this->branch_name = $branch_name;
        }
        static function getAllId(){
            $conn = DB::getInstance();
            $result = $conn->query("SELECT DISTINCT branch_id FROM Branches ORDER BY branch_id");
            $ids = [];
            while($row = mysqli_fetch_assoc($result)){
                $ids[] = $row['branch_id'];
            }
            return $ids;
        }
    }
?>