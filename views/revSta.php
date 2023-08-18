<?php
  require_once("../control/tour.php");
  
  $dataPoints = array(
    array("x"=> 10, "y"=> 41),
    array("x"=> 20, "y"=> 35, "indexLabel"=> "Lowest"),
    array("x"=> 30, "y"=> 50),
    array("x"=> 40, "y"=> 45),
    array("x"=> 50, "y"=> 52),
    array("x"=> 60, "y"=> 68),
    array("x"=> 70, "y"=> 38),
    array("x"=> 80, "y"=> 71, "indexLabel"=> "Highest"),
    array("x"=> 90, "y"=> 52),
    array("x"=> 100, "y"=> 60),
    array("x"=> 110, "y"=> 36),
    array("x"=> 120, "y"=> 49)
  );
	
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Home</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4bw+/aepP/YC94hEpVNVgiZdgIC5+VKNBQNGCHeKRQN+PtmoHDEXuppvnDJzQIu9" crossorigin="anonymous">
  <link rel="stylesheet" href="public/style.css">
  <link rel="stylesheet" href="public/revStaStyle.css">
  <link href='https://unpkg.com/boxicons@2.0.7/css/boxicons.min.css' rel='stylesheet'>
</head>
<body>
  <script>
    window.onload = function () {
    
      var chart = new CanvasJS.Chart("chartContainer", {
        animationEnabled: true,
        exportEnabled: true,
        theme: "light1", // "light1", "light2", "dark1", "dark2"
        title:{
          text: "Simple Column Chart with Index Labels"
        },
        axisY:{
          includeZero: true
        },
        data: [{
          type: "column", //change type to bar, line, area, pie, etc
          //indexLabel: "{y}", //Shows y value on all Data Points
          indexLabelFontColor: "#5A5757",
          indexLabelPlacement: "outside",   
          dataPoints: <?php echo json_encode($dataPoints, JSON_NUMERIC_CHECK); ?>
        }]
      });
      chart.render();
    
    }
  </script>
  
  <script src="https://cdn.canvasjs.com/canvasjs.min.js"></script>
  <div class="homeBg">
    
    <div class="navigationBar">
      <div class="selectNav" >
        <a class="homeNav anav" href="home.php"><i class='bx bxs-home'></i><p class="navShow" >Trang chủ</p></a>
      </div>
      <div class="selectNav">
      <a class="tourInfNav anav" href="tourInf.php"><i class='bx bxs-info-circle' ></i><p class="navShow">Thông tin tour</p></a>
      </div>
      <div class="selectNav">
      <a class="tourInfNav anav" href="addTour.php"><i class='bx bx-plus-circle' ></i></i><p class="navShow">Thêm tour</p></a>
      </div>
      <div class="selectNav" style="background-color:white;">
      <a class="revStaNav anav" style="color: black;"><i class='bx bxs-bar-chart-alt-2' ></i><p class="navShow">Thống kê doanh thu</p></a>
      </div>
      <div class="selectNav">
      <a class="logoutNav anav" href="../index.php"><i class='bx bxs-log-out' ></i><p class="navShow">Đăng xuất</p></a>
      </div>
    </div>
    <div class="mainDisplay">
    <label for="years">Chọn năm cần thống kê:</label>
    <select name="years" id="years">
    <?php
      foreach($years as $year)
      {
    ?>
      <option value=<?php echo $year?>><?php echo $year?></option>" 
    <?php
      }
    ?>
    </select>
      <div id="chartContainer" style="height: 370px; width: 100%;"></div>
    </div>
  </div>
  
</body>
</html>