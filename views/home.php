<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Home</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4bw+/aepP/YC94hEpVNVgiZdgIC5+VKNBQNGCHeKRQN+PtmoHDEXuppvnDJzQIu9" crossorigin="anonymous">
  <link rel="stylesheet" href="public/style.css">
  <link rel="stylesheet" href="public/homeStyle.css">

  <link href='https://unpkg.com/boxicons@2.0.7/css/boxicons.min.css' rel='stylesheet'>
</head>
<body>
  <div class="homeBg">
    <div class="navigationBar">
      <div class="selectNav" style="background-color:white;">
        <a class="homeNav anav" style="color: black;"><i class='bx bxs-home'></i><p class="navShow" >Trang chủ</p></a>
      </div>
      <div class="selectNav">
      <a class="tourInfNav anav" href="tourInf.php"><i class='bx bxs-info-circle' ></i><p class="navShow">Thông tin tour</p></a>
      </div>
      <div class="selectNav">
      <a class="tourInfNav anav" href="addTour.php"><i class='bx bx-plus-circle' ></i><p class="navShow">Thêm tour</p></a>
      </div>
      <div class="selectNav">
      <a class="revStaNav anav" href="revSta.php"><i class='bx bxs-bar-chart-alt-2' ></i><p class="navShow">Thống kê doanh thu</p></a>
      </div>
      <div class="selectNav">
      <a class="logoutNav anav" href="../index.php"><i class='bx bxs-log-out' ></i><p class="navShow">Đăng xuất</p></a>
      </div>
    </div>
    
  </div>
  
</body>
</html>