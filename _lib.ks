@lazyglobal off.


// DATA PRINTING
function PrintFromList{
	parameter in_PrintList.
	parameter startAtRow is 0.
	
	local myIterator to in_PrintList:iterator.
	local printAtRow to startAtRow.
	until not myIterator:next {
		print "                                        " at (0,printAtRow). //this clears a line.
		print myIterator:value at (0,printAtRow).
	set printAtRow to printAtRow + 1.
	}
}

function Alert{
	parameter myMessage.
	hudtext(myMessage, 5, 2, 20, white, false).
}

//KOS CRAP
function GetListSize{
	parameter myList.
	local lSize to 0.
	for i in myList {
		set lSize to lSize + 1.
	}
			print lSize.
	return lSize.
}

//MISC
function Pre{
	if sas{
		sas off.
		global sasWasOn to 1.
	}
	else{
		global sasWasOn to 0.
	}

}

function End{
	print "Successfully finished program".
	lock throttle to 0.
	set ship:control:pilotmainthrottle to 0.
	
	if sasWasOn{
		sas on.
	}
}


//SCIENCE AND PARTS
function AllScience{ //WORKS IN UNTIL LOOP
	for myPart in ship:parts{
		if myPart:hasmodule("ModuleScienceExperiment") {
			local eventNameList to myPart:getmodule("ModuleScienceExperiment"):alleventnames.
			local eventNameToDo to "null".

			for eventName in eventNameList {
				set eventNameToDo to eventName. 
			}
			if myPart:getmodule("ModuleScienceExperiment"):hasevent(eventNameToDo) {
				myPart:getmodule("ModuleScienceExperiment"):doevent(eventNameToDo).
				print("DOING " + eventNameToDo + " FOR " + myPart:name).
			}
			else {
				print("null:" + eventNameToDo).
			}
		}	
	}
}
		//if GetListSize(myPart:getmodule("ModuleScienceExperiment"):data) >0 {
			//if myPart:getmodule("ModuleScienceExperiment"):data:sciencevalue >= 1 { //if part has science module:sciencedata:sciencevalue that is more than 1

//ASCENT


function Ascent{ //MUST BE IN UNTIL LOOP
	parameter targetApoapsis to 100000.
	parameter launchAzimuth to 90.
	
	lock steering to heading(launchAzimuth, 90).

	BlastOff().

		Staging().
	
	
	function BlastOff{
		set throttle to 1.
		print "Blast off!".
		until ship:availablethrust > 0 {
			if stage:ready {
				stage.
			}
		}	
	}
	
	function Staging{
		if stage:number > 0 {
			global stageMaxThrust to ship:maxthrustat(0).
			if (ship:maxthrustat(0) < stageMaxThrust or (ship:maxthrustat(0) < 1)){
				if stage:ready {
					stage. //automatically waits a tick
					set stageMaxThrust to ship:maxthrustat(0).
				}
			}
		}
	}
}