<table border=1 width="100%">
    <?php
// fill all prime number flags to true, 1 is the first element
$num = 100;
$prime = array_fill(0, $num, true);

// 1 is special number, not prime number
$prime[0] = false;
// start to check prime number from 2 to $num
for ($i = 2; $i <= $num; $i++) {
    for ($j = 2; $j < $i; $j++) {
        // if divisible, not a prime number
        if (($i % $j) == 0) {
            $prime[$i - 1] = false;
        }
    }
}

for ($i = 1; $i <= $num; $i++) {
    // merge 10 numbers into a row
    if (($i % 10) == 1) {
        echo "<tr>";
    }
    // set background color to pink for prime number
    if ($prime[$i - 1]) {
        echo "<td bgcolor='pink'>{$i}</td>";
    } else {
        echo "<td>{$i}</td>";
    }
    // merge 10 numbers into a row
    if (($i % 10) == 0) {
        echo "</tr>";
    }
}
?>
</table>