<?php 
  
  require_once("../control/addTour.php")

?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Home</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4bw+/aepP/YC94hEpVNVgiZdgIC5+VKNBQNGCHeKRQN+PtmoHDEXuppvnDJzQIu9" crossorigin="anonymous">
  <link rel="stylesheet" href="public/style.css">
  <link rel="stylesheet" href="public/tourInfStyle.css">
  
  <link href='https://unpkg.com/boxicons@2.0.7/css/boxicons.min.css' rel='stylesheet'>
</head>
<body>
  <div class="homeBg">
    
    <div class="navigationBar">
      <div class="selectNav" >
        <a class="homeNav anav" href="home.php"><i class='bx bxs-home'></i><p class="navShow" >Trang chủ</p></a>
      </div>
      <div class="selectNav">
      <a class="tourInfNav anav" href="tourInf.php"><i class='bx bxs-info-circle' ></i><p class="navShow">Thông tin tour</p></a>
      </div>
      <div class="selectNav" style="background-color:white;">
      <a class="tourInfNav  anav"  style="color: black;"><i class='bx bx-plus-circle' ></i><p class="navShow">Thêm tour</p></a>
      </div>
      <div class="selectNav">
      <a class="revStaNav anav" href="revSta.php"><i class='bx bxs-bar-chart-alt-2' ></i><p class="navShow">Thống kê doanh thu</p></a>
      </div>
      <div class="selectNav">
      <a class="logoutNav anav" href="../index.php"><i class='bx bxs-log-out' ></i><p class="navShow">Đăng xuất</p></a>
      </div>
    </div>
    <div class="mainDisplay">
      <div class="tableMain">
        <div class="container">
          <div class="row">
            <div class="col m-auto">
              <form name="myform" action="" method="post"  enctype="multipart/form-data">
                  <div class="input-group mb-3">
                      <span class="input-group-text" id="tourName">Tour Name</span>
                      <input name="tourName" type="text" id="tourName" class="form-control" placeholder="Fill your tour name here" aria-label="Username" aria-describedby="basic-addon1">
                  </div>
                  <select name="branch_id" class="form-select" id="branch" aria-label="Default select example">
                    <option value=0 selected>Select Branch</option>
                      <?php foreach($branch_ids as $branch_id) {
                        $i = 1;
                        ?>
                        <option value=<?php echo $i;?>><?php echo $branch_id?></option>
                      <?php $i++;}?>
                  </select>
                  
                  <div class="row mt-4">
                    <div class="col">
                      <label for="price1" class="form-label fs-6">Single child price(VND)</label>
                      <input name="SingleChild" type="number" id="price1" min=0 class="form-control" placeholder="0" aria-label="SingleChild" value=0>
                    </div>
                    <div class="col">
                      <label for="price2" class="form-label fs-6">Single adult price(VND)</label>
                      <input name="SingleAdult" type="number" id="price2" min=0 class="form-control" placeholder="0" aria-label="SingleAdult" value=0>
                    </div>
                  </div>
                  <div class="row">
                    <div class="col">
                      <label for="price3" class="form-label fs-6">Group child price(VND)</label>
                      <input name="GroupChild" type="number" id="price3" min=0 class="form-control" placeholder="0" aria-label="GroupChild" value=0>
                    </div>
                    <div class="col">
                      <label for="price4" class="form-label fs-6">Group adult price(VND)</label>
                      <input name="GroupAdult" type="number" id="price4" min=0 class="form-control" placeholder="0" aria-label="GroupAdult" value=0>
                    </div>
                  </div>
                  <div class="row mt-4">
                    <div class="col">
                      <label for="minP" class="form-label fs-6">Minimum person</label>
                      <input name="minP" id="minP" type="number"  min=0 class="form-control" placeholder="-" aria-label="MinP" >
                    </div>
                    <div class="col">
                      <label for="max" class="form-label fs-6">Maximum person</label>
                      <input name="maxP" id="maxP" type="number"  min=0 class="form-control" placeholder="-" aria-label="MinP" >
                    </div>
                    <div class="col">
                      <label for="minG" class="form-label fs-6">Minimum guest per group</label>
                      <input name="minG" id="minG" type="number"  min=0 class="form-control" placeholder="-" aria-label="MinGroup" >
                    </div>
                  </div>
                  <div class="row">
                  <div class="col">
                      <label for="days" class="form-label fs-6">Days</label>
                      <input name="days" id="days" type="number" id="price4" min=0 class="form-control" placeholder="-" aria-label="Days" >
                    </div>
                    <div class="col">
                      <label for="nights" class="form-label fs-6">Nights</label>
                      <input name="nights" id="nights" type="number" id="price3" min=0 class="form-control" placeholder="-" aria-label="Nights">
                    </div>
                    <div class="col">
                      <label for="start" class="form-label fs-6">Start Date</label>
                      <input name="start_date" id="start" type="date"   class="form-control" placeholder="---" aria-label="SDate">
                    </div>
                    
                  </div>
                  <div class="input-group mb-3 mt-4">
                      <input type="file" class="form-control" id="fileToUpload" name="fileToUpload">
                      <label class="input-group-text" for="inputGroupFile02" >Upload image</label>
                  </div>
                  <button type="submit" class="btn btn-success"  name="btnsubmit">Add tour</button>
                  <button type="reset" class="btn btn-dark">Reset</button>
              </form>
            </div>
          </div>
        </div>
      </div>  
    </div>
  </div>
  <script>
 
  //    const form = document.getElementsByTagName('form')[0]
  //    form.addEventListener('submit', e => {
  //     e.preventDefault();
  //     if(validateTour()) form.submit();
      
  // });

    function validateTour() {
      
       var tourName = document.forms["myform"]["tourName"].value
       var branch_id = document.forms["myform"]["branch_id"].value
       var singleChild = document.forms["myform"]["SingleChild"].value
       var singleAdult = document.forms["myform"]["SingleAdult"].value
       var groupChild = document.forms["myform"]["GroupChild"].value
       var groupAdult = document.forms["myform"]["GroupAdult"].value
       var maxP = document.forms["myform"]["maxP"].value
       var minP = document.forms["myform"]["minP"].value
       var days = document.forms["myform"]["days"].value
       var nights = document.forms["myform"]["nights"].value
      
       
       if(tourName ==="") {
          alert("Please fill Tour name!") 
          return false
        }
        if(branch_id === "0") {
          alert("Please choose branch!") 
          return false
        }
        if(maxP === "") {
          alert("Please fill max person!")
          return false
        }
        if(days === "") {
          alert("Please fill days!")
          return false
        }
        if(nights === "") {
          alert("Please fill nights!")
          return false
        }
        //Check type 
        if(!isInt(Number(maxP)) || !isInt(Number(minP))) {
          
          alert("Min/max person must be a integer number!")
          return false
        }
        if(!isInt(Number(days))|| !isInt(Number(nights))) {
          alert("Days/Nights must be a integer number!")
          return false
        }
        //Check logic
        if(singleChild >= singleAdult) {
          alert("Single child price must be less than Single adult price!")
          return false
        }
        if(groupChild >= groupAdult) {
          alert("Group child price must be less than Group adult price!")
          return false
        }
        if(maxP <= minP) {
          alert("Max person must be greater than min person!")
          return false
        }
        return true;
        
    }
    function isInt(value) {
      return !isNaN(value) &&
      parseInt(value) == value &&
      !isNaN(parseInt(value, 10));
    }
  </script>
</body>
</html>