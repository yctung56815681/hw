<?php
// $poker = range(0, 51);
// get a new set of poker cards
for ($i = 0; $i < 52; $i++) {
    $poker[] = $i;
}

echo "range<br>";
// print cards
$i = 0;
foreach ($poker as $v) {
    printf("%02d ", $v);
    if ((++$i % 13) == 0) {
        echo "<br>";
    }
}
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
    // first card
    if (($i % 13) == 0) {
        echo "<tr>";
    }

    // first ~ 13-th cards
    echo "<td>";

    // 0  ~ 12 is spades
    // 13 ~ 25 is hearts
    // 26 ~ 38 is diams
    // 39 ~ 51 is clubs
    echo $suits[(int) ($v / 13)];
    echo $values[$v % 13];

    echo "</td>";

    // 13-th card
    if (($i % 13) == 12) {
        echo "</tr>";
    }

    $i++;
}
?>
</table>
<hr>

<?php
// shuffle($poker);
for ($i = 51; $i > 0; $i--) {
    // get a random poker card between 0-th and ($i - 1)-th.
    $temp = rand(0, $i - 1);

    // swap this poker card with $i-th poker card
    $temp2 = $poker[$temp];
    $poker[$temp] = $poker[$i];
    $poker[$i] = $temp2;
}

echo "shuffle<br>";
// print cards
$i = 0;
foreach ($poker as $v) {
    printf("%02d ", $v);
    if ((++$i % 13) == 0) {
        echo "<br>";
    }
}
?>

<table border=1 width="100%">
    <?php
$i = 0;
foreach ($poker as $v) {
    // first card
    if (($i % 13) == 0) {
        echo "<tr>";
    }

    // first ~ 13-th cards
    echo "<td>";

    // 0  ~ 12 is spades
    // 13 ~ 25 is hearts
    // 26 ~ 38 is diams
    // 39 ~ 51 is clubs
    echo $suits[(int) ($v / 13)];
    echo $values[$v % 13];

    echo "</td>";

    // 13-th card
    if (($i % 13) == 12) {
        echo "</tr>";
    }

    $i++;
}
?>
</table>
<hr>

<?php
echo "deal<br>";
for ($i = 0; $i < 4; $i++) {
    for ($j = 0; $j < 13; $j++) {
        printf("%02d ", $poker[$i + $j * 4]);
    }
    echo "<br>";
}
?>

<table border=1 width="100%">
    <?php
for ($i = 0; $i < 4; $i++) {
    // first card
    echo "<tr>";

    // first ~ 13-th cards
    for ($j = 0; $j < 13; $j++) {
        echo "<td>";

        // 0  ~ 12 is spades
        // 13 ~ 25 is hearts
        // 26 ~ 38 is diams
        // 39 ~ 51 is clubs
        $v = $poker[$i + $j * 4];
        echo $suits[(int) ($v / 13)];
        echo $values[$v % 13];

        echo "</td>";
    }

    // 13-th card
    echo "</tr>";
}
?>
</table>