<?php
require_once("tourismConnection.php");
class Attraction {
    public $id;
    public $name;
    
    public function __construct($id, $name)
    {
        $this->id = $id;
        $this->name = $name;
    }
    static function getAll(){
        $conn = DB::getInstance();
        $query = "SELECT attraction_id, attraction_name FROM  Tourist_attractions";
        $result = mysqli_query($conn, $query);
        $attractions = [];
        while($row = mysqli_fetch_assoc($result)){
            $attractions[] = new Attraction($row['attraction_id'], $row['attraction_name']);
        }
        return $attractions;
    }
}
?>