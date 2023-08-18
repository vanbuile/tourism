<?php 
require_once("../model/account.php");
if (isset($_POST['username']) && isset($_POST['password'])) {

	$uname = $_POST['username'];
	$pass = $_POST['password'];

	if (empty($uname)) {
		header("Location: ../index.php?error=username is required");
	    exit();
	}else if(empty($pass)){
        header("Location: ../index.php?error=password is required");
	    exit();
	}else{
		if (Account::check($uname, $pass)) {
			header("Location: ../views/home.php?");
		 	exit();
			 }else{
		 	header("Location: ../index.php?error=Incorrect username or password");
	        exit();
	    }
    }
}else{
	header("Location: ../index.php");
	exit();
}