<?php
$year = "";
$month = "";
$result = "";

// $jd = gregoriantojd(8, 1, 1752); // --> bug
// $jd = gregoriantojd(9, 1, 1752); // --> bug
// $jd = gregoriantojd(9, 3, 1752); // --> bug, without 9/3 - 9/13
// $jd = gregoriantojd(9, 13, 1752);// --> bug, without 9/3 - 9/13
// $jd = gregoriantojd(9, 14, 1752);
// $jd = gregoriantojd(10, 1, 1752);
// $jd = gregoriantojd(12, 1, 1899);
// $jd = gregoriantojd(1, 1, 1900);
// echo jddayofweek($jd, 0) . "<br>";
// echo jddayofweek($jd, 1) . "<br>";
// echo jddayofweek($jd, 2) . "<br>";

// 4 --> stop leap year --> febrary 28 day
// before 1582, (year % 4 == 0) is leap year
// 1582, wiithout 10/5 - 10/14
// 1752, without 9/3 - 9/13

// test case
// 1752-07-01 wensday
// 1752-08-01 saturday
// 1752-09-01 tuesday
// 1752-10-01 sunday
// 1752-11-01 wensday

// 1899-12-01 friday

// 1900-01-01 monday
// 1900-02-01 thursday
// 1900-03-01 thursday

// 2016-01-01 friday
// 2016-02-01 monday
// 2016-03-01 tuesday

// 2019-01-01 tuesday
// 2019-02-01 friday
// 2019-03-01 friday

// 2019-08-01 thursday

if (isset($_GET["year"]) && isset($_GET["month"])) {
    if ($_GET["year"] != "" && $_GET["month"] != "") {
        $year = $_GET["year"];
        $month = $_GET["month"];
        // echo "西元{$year}年{$month}月<br>";

        if ($year >= 1900) {
            // calculate day offset from 1900-01-01 (monday)
            $day = 0;
            for ($i = 1900; $i < $year; $i++) {
                $day += getYearDay($i);
            }
            for ($i = 1; $i < $month; $i++) {
                $day += getMonthDay($year, $i);
            }

            // 1900-01-01 is monday
            $weekDay = 1;
            $weekDay += $day;

            // calculate week day
            // positive number % 7 = 0, 1, 2, 3, 4, 5, 6
            $weekDay %= 7;
            // echo "{$year}-{$month}-1 >> day={$day} >> weekday={$weekDay}<br>";
        } else {
            // calculate day offset from 1900-01-01 (monday)
            $day = 0;
            for ($i = 1899; $i > $year; $i--) {
                $day += getYearDay($i);
            }
            for ($i = 12; $i >= $month; $i--) {
                $day += getMonthDay($year, $i);
            }

            // 1900-01-01 is monday
            $weekDay = 1;
            $weekDay -= $day;

            // calculate week day
            // negative number % 7 = 0, -1, -2, -3, -4, -5, -6
            $weekDay %= 7;
            if ($weekDay < 0) {
                $weekDay += 7;
            }
            // echo "{$year}-{$month}-1 >> day={$day} >> weekday={$weekDay}<br>";
        }

        $result = "日 一 二 三 四 五 六<br>";
        $monthDay = getMonthLastDay($year, $month);
        $day2 = 1;
        // print first row in one month
        for ($i = 0; $i < $weekDay; $i++) {
            $result = $result . "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
        }
        while ($i < 7) {
            // skip 1752-9-3 ~ 9-13
            if ($year == 1752 && $month == 9 && $day2 >= 3 && $day2 <= 13) {
                $day2++;
                continue;
            }
            if ($day2 < 10) {
                $result = $result . "&nbsp;{$day2}&nbsp;&nbsp;";
            } else {
                $result = $result . "{$day2}&nbsp;";
            }
            $i++;
            $day2++;
        }

        // print second ~ 5th rows in one month, base on total day number in one month
        $result = $result . "<br>";
        while ($day2 <= $monthDay) {
            for ($i = 0; ($i < 7) && ($day2 <= $monthDay); $i++, $day2++) {
                if ($day2 < 10) {
                    $result = $result . "&nbsp;{$day2}&nbsp;&nbsp;";
                } else {
                    $result = $result . "{$day2}&nbsp;";
                }
            }
            $result = $result . "<br>";
        }
    } else {
        if ($_GET["year"] == "") {
            $result = $result . "缺年<br>";
        }
        if ($_GET["month"] == "") {
            $result = $result . "缺月<br>";
        }
    }
} else {
    if (!isset($_GET["year"]) && !isset($_GET["month"])) {
    } else {
        if (!isset($_GET["year"])) {
            $result = $result . "缺年<br>";
        }
        if (!isset($_GET["month"])) {
            $result = $result . "缺月<br>";
        }

    }
}

// get total day number in a specific year
// check leap year
// but 1752/9 is special case.
function getYearDay($y)
{
    if ($y == 1752) {
        return 366 - 11;
    }

    if ($y % 4 == 0) {
        if ($y % 100 == 0) {
            if ($y % 400 == 0) {
                return 366;
            } else {
                return 365;
            }
        } else {
            return 366;
        }
    } else {
        return 365;
    }
}

// get total day number in a specific month
// but 1752/9 is special case.
function getMonthDay($y, $m)
{
    $monthDatArray = array(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
    if ($y == 1752 && $m == 9) {
        return 30 - 11;
    }

    if ($m == 2) {
        if (getYearDay($y) == 366) {
            return $monthDatArray[$m - 1] + 1;
        } else {
            return $monthDatArray[$m - 1];
        }
    } else {
        return $monthDatArray[$m - 1];
    }
}

// get last day number in a specific month
// usually last day number is total day number,
// but 1752/9 is special case. total day number is 30 - 11 = 19, last day number is 30.
function getMonthLastDay($y, $m)
{
    if ($y == 1752 && $m == 9) {
        return 30;
    }
    return getMonthDay($y, $m);
}
?>


<form action="webCalendar.php">
    西元<input name="year" value="<?php echo $year; ?>">年
    <input name="month" value="<?php echo $month; ?>">月
    <input type="submit" value="=">
    <hr>
    <span><?php echo $result; ?></span>
</form>