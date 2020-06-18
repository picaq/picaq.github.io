window.addEventListener("load",showTheTime,false);

function showTheTime() {
	var now = new Date();
    var incr = 5400000; // 90 mins
    var mins = 900000;  // 14 mins
    var wake = new Date(now.getTime() + incr + mins);
    var wake2 = new Date(wake.getTime() + incr);
    var wake3 = new Date(wake2.getTime() + incr);
    var wake4 = new Date(wake3.getTime() + incr);
    var wake5 = new Date(wake4.getTime() + incr);
    var wake6 = new Date(wake5.getTime() + incr);
    var wake7 = new Date(wake6.getTime() + incr);
    var wake8 = new Date(wake7.getTime() + incr);

    document.getElementById("timeNow").innerHTML = showTheHours(now.getHours()) + showZeroFilled(now.getMinutes()) + showZeroFilled(now.getSeconds()) + showAmPm(now);

    document.getElementById("sleepTime").innerHTML = showTheHours(wake.getHours()) + showZeroFilled(wake.getMinutes()) + showAmPm(wake);

    document.getElementById("sleepTime2").innerHTML = showTheHours(wake2.getHours()) + showZeroFilled(wake2.getMinutes()) + showAmPm(wake2);

    document.getElementById("sleepTime3").innerHTML = showTheHours(wake3.getHours()) + showZeroFilled(wake3.getMinutes()) + showAmPm(wake3);

    document.getElementById("sleepTime4").innerHTML = showTheHours(wake4.getHours()) + showZeroFilled(wake4.getMinutes()) + showAmPm(wake4);

    document.getElementById("sleepTime5").innerHTML = showTheHours(wake5.getHours()) + showZeroFilled(wake5.getMinutes()) + showAmPm(wake5);

    document.getElementById("sleepTime6").innerHTML = showTheHours(wake6.getHours()) + showZeroFilled(wake6.getMinutes()) + showAmPm(wake6);

    document.getElementById("sleepTime7").innerHTML = showTheHours(wake7.getHours()) + showZeroFilled(wake7.getMinutes()) + showAmPm(wake7);

    document.getElementById("sleepTime8").innerHTML = showTheHours(wake8.getHours()) + showZeroFilled(wake8.getMinutes()) + showAmPm(wake8);
    
	setTimeout(showTheTime,1000);
	
	function showTheHours(theHour) {	
		if (show24Hour() || (theHour > 0 && theHour < 13)) {
			return theHour;
		}
		if (theHour == 0) {
			return 12;
		}
		return theHour-12;
	}
	
	function showZeroFilled(inValue) {
		if (inValue > 9) {
			return ":" + inValue;
		}
		return ":0" + inValue;
	}

	function show24Hour() {
		return (document.getElementById("show24").checked);
	}
	
	function showAmPm(x) {
		if (show24Hour()) {
			return "";
		}
		if (x.getHours() < 12) {
			return "&thinsp;am";
		}
		return "&thinsp;pm";
	}
}
