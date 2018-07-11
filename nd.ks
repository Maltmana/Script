//BUGS
//HAS NO STAGING HANDLING!!


CLEARSCREEN.
SET nd TO nextNode.
SET done TO false.
SET maxAcc TO SHIP:MAXTHRUST/SHIP:MASS.
SET burnDur TO nd:deltav:mag/maxAcc.
SAS OFF.

////DATA
WHEN NOT done THEN {
PRINT "NODE ETA: " + ROUND(nd:eta) + " s. " + " DV: " + ROUND(nd:deltav:mag) + " ms. " + "BURN DURATION: " + ROUND(burnDur) + " s. " AT(0,0).
PRESERVE.
}

//WARP
//SET totalTime to nd:eta - (15 + burnDur/2).
//// endTime to TIME:SECONDS + totalTime.
//SET warpList TO list(5, 10, 50, 100, 1000, 10000, 100000).
//SET highestWarp TO 0.
//FOR warpOption in warpList
//{
//	if totalTime> warpOption
//	{
//		SET highestWarp to highestWarp + 1.
//		PRINT highestWarp.
//	}
//
//}
//SET isWarping TO true.
//WHEN isWarping THEN
//{
//	SET WARP to highestWarp.
//	PRESERVE.
//}
//print totalTime.
//print warpList[highestWarp-1]/2.
//print totalTime - warpList[highestWarp-1]/2.
////WAIT totalTime - warpList[highestWarp-1]/2. //(integral of a linear ramp up is 1/2 * (linear slope) * x2 in this case, ramps up over 1 second, so x2 = 1, slope is just the listed warp rate, so ramp up to 100,000 takes 50,000 seconds for instance)
//WAIT UNTIL nd:eta <= warpList[highestWarp-1]/2.
////WAIT UNTIL nd:eta <= (burnDur/2 + 15).
//SET isWarping TO false.
//SET WARP TO 0.

KUNIVERSE:TIMEWARP:WARPTO(TIME:SECONDS + nd:eta - (15 + burnDur/2)).

//END WARP

LOCK np TO nd:deltav. //set or lock?
LOCK STEERING to np. ///////////////////////rolling out of control.

////DATA
WHEN NOT done THEN {
PRINT "NODE DV: " + ROUND(nd:deltav:x) + ", " + ROUND(nd:deltav:y) + ", " + ROUND(nd:deltav:z) AT(0,1).
PRINT "steering: " + ROUND(STEERING:x) + ", " + ROUND(STEERING:y) + ", " + ROUND(STEERING:z) AT(0,1).
PRESERVE.
} /////////////////////////is this showing?

//WAIT UNTIL vAng(np, ship:facing:vector) < 1. //wait until turned.. not needed

WAIT UNTIL nd:eta <= (burnDur/2). //wait until eta reached

//main
PRINT "BEGIN BURN" AT(0,10).

SET tSet to 0.
LOCK throttle TO tSet.
SET dv0 TO nd:deltav.

//cancel roll
SET STEERINGMANAGER:ROLLPID:KP TO 0.
SET STEERINGMANAGER:ROLLPID:KI TO 0.

UNTIL done
{
	SET maxAcc TO SHIP:MAXTHRUST/SHIP:MASS.
	SET tset TO MIN(nd:deltav:mag/maxAcc, 1).

	if vdot(dv0, nd:deltav) < 0
	{
		CLEARSCREEN.
		PRINT "FINALIZING".
		PRINT "VDOT dv0, nd:deltav IS < 0".
		print "End burn, remain dv " + ROUND(nd:deltav:mag,1) + "m/s, vdot: " + ROUND(vdot(dv0, nd:deltav),1).
		lock throttle to 0.
		break.
	}

	IF nd:deltav:mag < 0.1
	{
		CLEARSCREEN.
		PRINT "FINALIZING".
		PRINT "nd:deltav:mag < 0.1".
		PRINT "DV REMAINING: " + ROUND(nd:deltav:mag, 1).
		PRINT "dv0 nd:dv dotprod: " + ROUND(vdot(dv0,nd:deltav), 1).
		
		WAIT UNTIL vdot(dv0, nd:deltav) < 0.5.
		
		LOCK throttle TO 0.
		CLEARSCREEN.
		PRINT "FINAL DV REMAINING: " + ROUND(nd:deltav:mag, 1) + " FINAL VDOT: " + ROUND(vdot(dv0,nd:deltav), 1).
		SET done TO true.
	}
	
	////DATA
	IF NOT done 
	{
	PRINT "dv0: " + ROUND(dv0:x) + ", " + ROUND(dv0:y) + ", " + ROUND(dv0:z) AT(0,2).
	PRINT "STEERING: " + ROUND(np:x) + ", " + ROUND(np:y) + ", " + ROUND(np:z) AT(0,3).
	}

}

REMOVE nd.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.