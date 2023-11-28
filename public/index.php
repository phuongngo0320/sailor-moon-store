<?php

require __DIR__ . '/../src/bootstrap.php';

?>

<?php view('header', 
    [
        'title' => 'Welcome',
        'style' => 'index.css',
        'script' => 'index.js'
    ]
) 
?>

<header>
    <img src="https://sailormoon-store.com/img/usr/common/logo.png" alt="Logo">
</header>
<p>Welcome <?= DB_USER ?>, you got: 
    <?= 
        RegionModel::getRegionByName('Da Nang')->__toString()
    ?>
</p>

<?php view('footer') ?>