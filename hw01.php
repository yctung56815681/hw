<?php
// $poker = range(0, 51);
// get a new poker
for ($i = 0; $i < 52; $i++) {
    $poker[] = $i;
}

echo "range<br>";
// print poker
$i = 0;
foreach ($poker as $v) {
    printf("%02d ", $v);
    if ((++$i % 13) == 0) {
        echo "<br>";
    }
}

// double check repeat
for ($i = 0; $i < 51; $i++) {
    for ($j = $i + 1; $j < 52; $j++) {
        if ($poker[$i] == $poker[$j]) {
            echo "repeat<br>";
            break;
        }
    }
}
echo "<hr>";

// shuffle($poker);
// get a random poker between 0-th and ($i - 1)-th.
// swap this poker with $i-th poker
for ($i = 51; $i > 0; $i--) {
    $temp = rand(0, $i - 1);
    $temp2 = $poker[$temp];
    $poker[$temp] = $poker[$i];
    $poker[$i] = $temp2;
}

echo "shuffle<br>";
// print poker
$i = 0;
foreach ($poker as $v) {
    printf("%02d ", $v);
    if ((++$i % 13) == 0) {
        echo "<br>";
    }
}

// double check
for ($i = 0; $i < 51; $i++) {
    for ($j = $i + 1; $j < 52; $j++) {
        if ($poker[$i] == $poker[$j]) {
            echo "repeat<br>";
            break;
        }
    }
}
echo "<hr>";
?>

<table border=1 width="100%">
    <?php
$suits = [
    "&spades;",
    "<font color='red'>&hearts;</font>",
    "<font color='red'>&diams;</font>",
    "&clubs;"];
$values = ['A', 2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K'];

$i = 0;
foreach ($poker as $v) {
    // first poker for each player
    if (($i % 13) == 0) {
        echo "<tr>";
    }

    // first to last poker for each plyer
    echo "<td>";

    // 0  ~ 12 is spades
    // 13 ~ 25 is hearts
    // 26 ~ 38 is diams
    // 39 ~ 51 is clubs
    echo $suits[(int) ($v / 13)];
    echo $values[$v % 13];

    echo "</td>";

    // last poker for each player
    if (($i % 13) == 12) {
        echo "</tr>";
    }

    $i++;
}
?>
</table>
