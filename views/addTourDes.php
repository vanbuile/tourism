
<?php
  require_once("../control/addTourDes.php")
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
                <form action="" method="post">
                    <input type="hidden" name="tour_id" value="<?php echo $tour_id?>">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <select class="form-select" aria-label="Days" name="schedule_number">
                                <option selected value=0>Select day</option>
                                <?php for($i = 1; $i <= $tour->days; $i++) {?>
                                    <option value=<?php echo $i?>>Day <?php echo $i?></option>
                                <?php }?>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <select class="form-select" aria-label="Attraction" name="point_of_interest_id">
                                <option selected value=0>Select attraction</option>
                                <?php foreach($attractions as $attraction){?>
                                    <option value=<?php echo $attraction->id?>> <?php echo $attraction?></option>
                                <?php }?>
                            </select>
                        </div>
                        
                    </div>
                    <div class="input-group mb-3">
                        <span class="input-group-text">From</span>
                        <input name="start_time" type="time" class="form-control" placeholder="hh:mm:ss" aria-label="StartTime">
                        <span class="input-group-text">To</span>
                        <input name="end_time" type="time" class="form-control" placeholder="hh:mm:ss" aria-label="EndTime">
                    </div>
                    <div class="mb-3">
                        <label for="desc" class="form-label">Description</label>
                        <input type="text" class="form-control" id="desc" aria-describedby="des" name="description">
                    </div>
                    <button type="submit" name="tourDesSubmit" value="Submit btn">Add detail Info</button>
                </form>
               

            </div>
          </div>
        </div>
      </div>  
    </div>
  </div>
  
   
</body>
</html>