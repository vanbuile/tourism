<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Assignment2</title>
  <link rel="stylesheet" href="public/style.css">
</head>
<body>
  <div class="loginBg">
    <div class="container">
      <center>
        <div class="loginBox" >
          <h1 style="font-family: candara; font-size: 2rem; ">Manager Login</h1>   

            <form action="control/login.php" method="post">
              <input type="text" class="username" name="username" placeholder="username"><br>
              <input type="password" class="password" name="password" placeholder="password"><br>
              <?php if (isset($_GET['error'])) { ?>
                <p class="error" style="font-size: 0.9em"><?php echo $_GET['error']; ?></p>
              <?php } ?>
              <button class="loginButton" type="submit">Login</button>
            </form>
            
        </div>
      </center>
    </div>
  </div>
</body>
</html>