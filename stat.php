<?php 

session_start();
const DB_HOST = 'localhost:3307';
const DB_NAME = 'sailormoonstore';
const DB_USER = 'root';
const DB_PASSWORD = '';

function connect() {
    static $pdo;

    if (!$pdo) {
        $pdo = new PDO(
            sprintf("mysql:host=%s;dbname=%s;charset=UTF8", DB_HOST, DB_NAME),
            DB_USER,
            DB_PASSWORD,
            [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
        );
    }
    
    return $pdo;
}

function getAllBranch() {
    $pdo = connect();
    $sql = "SELECT * FROM Branch";
    $statement = $pdo->prepare($sql);
    $result = $statement->fetchAll(PDO::FETCH_ASSOC);
    return $result;
}

// revenue
function getBranchRevenue($bnum, $year) {
    $pdo = connect();
    $sql = "SELECT BranchRevenue(:bnum, :year) AS revenue";
    $statement = $pdo->prepare($sql);
    $statement->bindParam(":bnum", $bnum, PDO::PARAM_INT);
    $statement->bindParam(":year", $year, PDO::PARAM_INT);
    $result = $statement->fetch(PDO::FETCH_ASSOC);
    return $result['revenue'];
}

function getBranchAverageRating($bnum, $year) {
    $pdo = connect();
    $sql = "SELECT BranchAverageRating(:bnum, :year) AS avgRating";
    $statement = $pdo->prepare($sql);
    $statement->bindParam(":bnum", $bnum, PDO::PARAM_INT);
    $statement->bindParam(":year", $year, PDO::PARAM_INT);
    $result = $statement->fetch(PDO::FETCH_ASSOC);
    return $result['avgRating'];
}

//------------------------------------------------------------------
$branches = getAllBranch();
const START_YEAR = 2003;
$current_year = date('Y');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $input_year = filter_input(INPUT_POST, 'year', FILTER_SANITIZE_NUMBER_INT);
    $_SESSION['year'] = $input_year;
    header('Location: stat.php');
} else {
    $input_year = $_SESSION['year'] ?? $current_year;
}

?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Statistics</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <script defer src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL"
        crossorigin="anonymous"></script>

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
        integrity="sha512-Avb2QiuDEEvB4bZJYdft2mNjVShBftLdPG8FJ0V7irTLQ8Uo0qcPxh4Plq7G5tGm0rU+1SPhVotteLpBERwTkw=="
        crossorigin="anonymous" referrerpolicy="no-referrer" />

    <!-- JQuery -->
    <script defer type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

    <!-- CSS & JS -->
    <link rel="stylesheet" href="css/stat.css">
</head>

<body>
    <header>
        <div class="upper">
            <div class="logo">
                <a href="#">
                    <img src="https://sailormoon-store.com/img/usr/common/logo.png" alt="Logo">
                </a>
            </div>

            <div class="search-bar">
                <input type="search" name="search" id="search">

                <span><i class="fa fa-search" aria-hidden="true"></i></span>
            </div>

            <div class="social-media">
                <span><a href="#"><i class="fa-brands fa-x-twitter"></i></a></span>
                <span><a href="#"><i class="fa-brands fa-instagram"></i></a></span>
            </div>

        </div>
        <nav>
            <ul>
                <li><a href="index.php">Home</a></li>
                <li><a href="product.php">Shop</a></li>
                <li><a href="bill.php">Bills</a></li>
                <li><a href="employee.php">Employees</a></li>
                <li><a href="#">Statistics</a></li>
            </ul>
        </nav>
    </header>
    <main>
        <h1>Statistics in <?= $input_year ?></h1>

        <form class="input-year" action="stat.php" method="post">
            <label for="year">Select a year</label>
            <select name="year" id="year">
                <?php for($i = START_YEAR; $i <= $current_year; $i++): ?>
                    <option 
                        value="<?php echo $i ?>" 
                        <?php echo ($i == $input_year) ? 'selected': ''; ?>
                    >
                        <?php echo $i ?>
                    </option>
                <?php endfor ?>
            </select>
            <button type="submit">OK</button>
        </form>

        <div class="row stat-list">
            <?php for ($i=0; $i < count($branches); $i++):?>
                
            <div class="col-sm-6">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Chi nhánh <?= $branches[$i]['name'] ?></h5>
                        <p class="card-text">This branch has an area of <?= $branches[$i]['area'] ?></p>
                        
                        <div class="row">
                            <div class="col-sm-6">
                                <div class="card">
                                    <div class="card-body">
                                        <h6 class="card-title">Total Revenue</h6>

                                        <p class="figure"><?= getBranchRevenue($i, $input_year)  ?></p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="card">
                                    <div class="card-body">
                                        <h6 class="card-title"><?= getBranchAverageRating($i, $input_year) ?></h6>
                                        <p class="figure">4.7</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <?php endfor ?>
        </div>
    </main>
    <footer>
        <p>2023 No Copyright by Sailor Moon Team HCMUT</p>
    </footer>
    <!-- <script>
        $(document).ready(function () {
            $(document).delegate('#year', 'change', function() {
                $.ajax({
                    type: 'GET',
                    contentType: 'application/json;charset=UTF-8',
                    url: 'http://localhost/projects/sailor-moon-store/stat.php',
                    data: JSON.stringify({
                        'year': $('#year').val()
                    }),
                    success: function(result) {
                        console.log('update change successfully');
                    },
                    error: function(error) {
                        alert(error);
                    }
                });
            });
        });
    </script> -->
</body>
</html>