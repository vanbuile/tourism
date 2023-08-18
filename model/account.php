<?php
    require_once("accountConnection.php");
    class Account {
        public $username;
        public $password;

        static function check($username, $password) {
            $conn = DB::getInstance();
            $result = $conn->query("SELECT * FROM managers WHERE username='$username' AND password='$password'");
            return mysqli_num_rows($result) > 0;
        }
    }
?>