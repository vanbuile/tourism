<?php 
  require_once("../control/tour.php");
  

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
      <div class="selectNav" style="background-color:white;">
      <a class="tourInfNav anav"  style="color: black;"><i class='bx bxs-info-circle' ></i><p class="navShow">Thông tin tour</p></a>
      </div>
      <div class="selectNav">
      <a class="tourInfNav anav"  href="addTour.php"><i class='bx bx-plus-circle' ></i><p class="navShow">Thêm Tour</p></a>
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
              
                <table class="table table-bordered">
                  <tr>
                    <td> Tour ID </td>
                    <td> Tour Name </td>
                    <td> Photo </td>
                    <td> Start Date </td>
                    <td> Edit  </td>
                    <td> Delete </td>
                  </tr>

                  <?php 
                          
                    foreach($tours as $tour)
                    {
                      
                  ?>
                    <tr>
                      <td><?php echo $tour->tour_id?></td>
                      <td><?php echo $tour->tour_name ?></td>
                      <td><?php echo $tour->photo ?></td>
                      <td><?php echo $tour->start_date?></td>
                      <td><a href="#" class='bx bxs-pencil'>Edit</a></td>
                      <td><a href="#" class="btn btn-danger">Delete</a></td>
                    </tr>        
                  <?php 
                          }  
                  ?>                                                                    
                            

                </table>
              
            </div>
          </div>
        </div>
      </div>  
    </div>
  </div>
</body>
</html>


