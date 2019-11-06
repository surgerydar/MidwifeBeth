
var longMonths = ["January","February","March","April","May","June","July","August","September","October","November","December"];
var shortMonths = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
var dayMs=1000*60*60*24;

function longMonth(month) {
    return longMonths[ month ];
}

function shortMonth(month) {
    return shortMonths[ month ];
}

function shortDate(time,withYear) {
    var date = new Date(time);
    return date.getDate() + ', ' + shortMonths[ date.getMonth() ] + ( withYear ? ', ' + date.getFullYear() : '' );
}

function shortDateVertical(time,withYear) {
    var date = new Date(time);
    return date.getDate() + '<br/>' + shortMonths[ date.getMonth() ] + ( withYear ? '<br/>' + date.getFullYear() : '' );
}


function daysBetweenDates( date1, date2 ) {
    var ms1 = date1.getTime();
    var ms2 = date2.getTime();
    return daysBetweenMs(ms1,ms2);
}

function daysBetweenMs( ms1, ms2 ) {
    var dMs = ms2 - ms1;
    return Math.round(dMs/dayMs);
}

function getLastDate( start ) {
    var month = start.getMonth();
    var date = start.getDate();
    var temp = new Date(start);
    try {
        do {
            date = temp.getDate();
            temp.setDate(temp.getDate()+1);
        } while( temp.getMonth() === month );
    } catch( err ) {
        console.log( 'getLastDate : error : ' + err );
        console.log( 'temp : ' + temp );
    }

    return date;
}

function getStartOfWeek( start ) {
    var temp = new Date( start );
    while( temp.getDay() > 0 ) temp.setDate(temp.getDate()-1);
    return temp;
}

function getEndOfWeek( start ) {
    var temp = new Date( start );
    while( temp.getDay() < 6 ) temp.setDate(temp.getDate()+1);
    return temp;
}

function getDateSpan(firstDate, secondDate) {
    console.log( 'getDateSpan : ' + firstDate.toString() + ' >> ' + secondDate.toString() );
    var diff_year  = parseInt(secondDate.getFullYear() - firstDate.getFullYear());
    var diff_month = parseInt(secondDate.getMonth() - firstDate.getMonth());
    var diff_day   = parseInt(secondDate.getDate() - firstDate.getDate());

    var span = {};

    while(true) {
        span = {};
        span["y"] = diff_year;

        if(diff_month < 0) {
            diff_year -= 1;
            diff_month += 12;
            continue;
        }
        span["m"] = diff_month;

        if(diff_day < 0) {
            diff_month -= 1;
            diff_day += monthLength(secondDate.getFullYear(), secondDate.getMonth());
            continue;
        }
        span["d"] = diff_day;
        break;
    }

    return span;
}

function monthLength(year, month) {
    var hour = 1000 * 60 * 60;
    var day = hour * 24;
    var this_month = new Date(year, month, 1);
    var next_month = new Date(year, month + 1, 1);
    var length = Math.ceil((next_month.getTime() - this_month.getTime() - hour)/day);

    return length;
}

function formatDateSpan(firstDate, secondDate) {
    let span = getDateSpan(firstDate,secondDate);
    return ( span['y'] && span['y'] > 0 ? span['y'] + ' years ' : '' ) + ( span['m'] && span['m'] > 0 ? span['m'] + ' months ' : '' ) + ( span['d'] && span['d'] > 0 ? span['d'] + ' days' : '' );
}

function formatDuration( start, end ) {
    if ( start && end && start < end ) {
        let ms  = ( end - start );
        let sec = Math.floor((ms / 1000) % 60);
        let min = Math.floor(((ms / (1000*60)) % 60));
        let hr  = Math.floor((ms / (1000*60*60)) % 24);
        return ( hr > 0 ? hr + 'h ' : '' ) + ( min > 0 ? min + 'm ' : '' ) + ( sec > 0 ? sec + 's' : '' );
    }
    return '';
}


function map( value, valueMin, valueMax, targetMin, targetMax ) {
    return ( ( value - valueMin ) / ( valueMax - valueMin ) ) * ( targetMax - targetMin ) + targetMin;
}
