

//LOCK THROTTLE LOCK STEERING
set throt to 1.0.
set dthrot to 0.0.
set steerDir to direction.
set shipPitch to 90.
lock throttle to throt.
LOCK STEERING TO r(0,0,0) + HEADING(steerDir, shipPitch).

//SYSTEMS CHECK
SAS OFF.

	
//BLAST OFF AND WAIT FOR 100MS
print "Blast off!".
stage.

wait until ship:verticalspeed > 100.

//STAGING AND THROTTLE
global stagemaxthrust to ship:maxthrustat(0).
when (ship:maxthrustat(0) < stagemaxthrust or (ship:maxthrustat(0) < 1)) then {
	if stage:ready {
	stage.
	set stagemaxthrust to ship:maxthrustat(0).
	}
	if stage:number > 0 {
	preserve.
	}
} /////////////////////staging and throttle is bugged on some launches and transfers.  nd. bugs out after every burn. circularization takes too long. needs pid.



//PRE 10,000 - GOING TO 45dg
set testaltAtaltTo10k to ship:altitude.//test
set altTo10k to 10000 - ship:altitude.
set dgPerMet to 45/altTo10k.
set dAlt to 0.
set oldAlt to ship:altitude.
until ship:altitude > 10000 {
	//pitch
	set dAlt to ship:altitude - oldAlt.
	set shipPitch to shipPitch - (dgPerMet*dAlt).
	set oldAlt to ship:altitude.
	//throttle

	if ship:altitude < 8000 {
		lock dthrot to 0.005 * (300 - SHIP:VELOCITY:SURFACE:MAG).
		set throt to MIN(1, MAX(0, throt + dthrot)).
	}
	else {
	set throt to 1.
	}

	//DATA
	PRINT "testaltAtaltTo10k " + testaltAtaltTo10k AT(0,0).
	PRINT "altTo10k " + altTo10k AT(0,1).
	PRINT "dAlt " + dAlt AT(0,2).
	PRINT "dgPerMet " + dgPerMet AT(0,3).
	PRINT "shipPitch " + shipPitch AT(0,4).
	PRINT "-------THROTTLE-------" AT(0,5).
	PRINT "dthrot" + dthrot AT(0,6).
	PRINT "throt" + throt AT(0,7).

	//WAIT
	wait 0.1.
}

set testaltAtaltTo70k to ship:altitude.//test
set altTo70k to 70000 - ship:altitude.
set dgPerMet to 45/altTo70k.
set dAlt to 0.
set oldAlt to ship:altitude.

until ship:altitude > 70000 AND SHIP:APOAPSIS > 80000 {
	//pitch
	set dAlt to ship:altitude - oldAlt.
	set shipPitch to shipPitch - (dgPerMet*dAlt).
	set oldAlt to ship:altitude.

	//DATA
	PRINT "testaltAtaltTo70k " + testaltAtaltTo70k AT(0,0).
	PRINT "altTo70k " + altTo70k AT(0,1).
	PRINT "dAlt " + dAlt AT(0,2).
	PRINT "dgPerMet " + dgPerMet AT(0,3).
	PRINT "shipPitch " + shipPitch AT(0,4).
	PRINT "-------THROTTLE-------" AT(0,5).
	PRINT "dthrot" + dthrot AT(0,6).
	PRINT "throt" + throt AT(0,7).

	//WAIT
	wait 0.1.
}

set throt to 0.

until SHIP:PERIAPSIS > 80000 {

	LOCK STEERING TO PROGRADE + R(0,0,0).
	
	IF ETA:APOAPSIS < 30 {
		set throt to 1.
	}
	ELSE {
		set throt to 0.
	}

	//DATA
	PRINT "testaltAtaltTo70k " + testaltAtaltTo70k AT(0,0).
	PRINT "altTo70k " + altTo70k AT(0,1).
	PRINT "dAlt " + dAlt AT(0,2).
	PRINT "dgPerMet " + dgPerMet AT(0,3).
	PRINT "shipPitch " + shipPitch AT(0,4).
	PRINT "-------THROTTLE-------" AT(0,5).
	PRINT "dthrot" + dthrot AT(0,6).
	PRINT "throt" + throt AT(0,7).
	PRINT "-------CIRCULARIZE-------" AT(0,8).
	PRINT "ETA:APOAPSIS " + ETA:APOAPSIS AT(0,9).

	//WAIT
	wait 0.1.
}


//first run = oldAlt=1000, dAlt=0, shipPitch - 0, oldAlt= 1000.
//second run = oldAlt = 1000, altitude = 1010, shipPitch - .005* 10, oldAlt = 1010.


