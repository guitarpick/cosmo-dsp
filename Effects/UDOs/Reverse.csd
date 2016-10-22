/* 	
 ---------------------------------------------------------------
 	Reverse.csd

	Reverse effect - reverse incoming signal

	Author: Alex Hofmann
	COSMO version: Bernt Isak Wærstad

	Date: 2016.09.21

	Arguments: Reverse time, Dry/wet mix
 ---------------------------------------------------------------
*/

; ---------------------------------------------------------------
;		MONO Reverse
; ---------------------------------------------------------------

opcode	Reverse, a, aKk				;nb. CAPITAL K CREATE A K-RATE VARIABLE THAT HAS A USEFUL VALUE ALSO AT I-TIME
	ain,ktime,kdrywet	xin			;READ IN INPUT ARGUMENTS

	ktime scale ktime, 3, 0.1
	Scut sprintfk "Reverse time: %dms", ktime
		puts Scut, ktime
	kdrywet port kdrywet, 0.2

	if kdrywet > 0 then

		ktrig	changed	ktime			;IF ktime CONTROL IS MOVED GENERATE A MOMENTARY '1' IMPULSE
		if ktrig=1 then				;IF A TRIGGER HAS BEEN GENERATED IN THE LINE ABOVE...
			reinit	UPDATE			;...BEGIN A REINITILISATION PASS FROM LABEL 'UPDATE'
		endif					;END OF CONDITIONAL BRANCH

		UPDATE:					;LABEL CALLED 'UPDATE'
		itime	=	i(ktime)		;CREATE AN I-TIME VERSION OF ktime
		aptr	phasor	2/itime			;CREATE A MOVING PHASOR THAT WITH BE USED TO TAP THE DELAY BUFFER
		aptr	=	aptr*itime		;SCALE PHASOR ACCORDING TO THE LENGTH OF THE DELAY TIME CHOSEN BY THE USER
		ienv	ftgentmp	0,0,1024,7,0,(1024*0.01),1,(1024*0.98),1,(0.01*1024),0	;ANTI-CLICK ENVELOPE SHAPE
	 	aenv	poscil	1, 2/itime, ienv	;CREATE A CYCLING AMPLITUDE ENVELOPE THAT WILL SYNC TO THE TAP DELAY TIME PHASOR 
	 	abuffer	delayr	5			;CREATE A DELAY BUFFER
		atap	deltap3	aptr			;READ AUDIO FROM A TAP WITHIN THE DELAY BUFFER
			delayw	ain			;WRITE AUDIO INTO DELAY BUFFER
		rireturn				;RETURN FROM REINITIALISATION PASS
		arev =	atap*aenv			;SEND AUDIO BACK TO CALLER INSTRUMENT. APPLY AMPLITUDE ENVELOPE TO PREVENT CLICKS.
	else
		arev = 0
	endif

	aout ntrpol ain, arev, kdrywet

	xout aout
endop

opcode Reverse, a,a
	a1 xin
	aout Reverse a1, 0.75, 1
	xout aout
endop 


; ---------------------------------------------------------------
;		STEREO Reverse
; ---------------------------------------------------------------

opcode	Reverse, aa, aaKk				;nb. CAPITAL K CREATE A K-RATE VARIABLE THAT HAS A USEFUL VALUE ALSO AT I-TIME
	ainL,ainR,ktime,kdrywet	xin			;READ IN INPUT ARGUMENTS

	ktime scale ktime, 3, 0.1
	Scut sprintfk "Reverse time: %dms", ktime*1000	
		puts Scut, ktime

	kdrywet port kdrywet, 0.2

	if kdrywet > 0 then

		ktrig	changed	ktime			;IF ktime CONTROL IS MOVED GENERATE A MOMENTARY '1' IMPULSE
		if ktrig=1 then				;IF A TRIGGER HAS BEEN GENERATED IN THE LINE ABOVE...
			reinit	UPDATE			;...BEGIN A REINITILISATION PASS FROM LABEL 'UPDATE'
		endif					;END OF CONDITIONAL BRANCH

		UPDATE:					;LABEL CALLED 'UPDATE'
		itime	=	i(ktime)		;CREATE AN I-TIME VERSION OF ktime
		aptr	phasor	2/itime			;CREATE A MOVING PHASOR THAT WITH BE USED TO TAP THE DELAY BUFFER
		aptr	=	aptr*itime		;SCALE PHASOR ACCORDING TO THE LENGTH OF THE DELAY TIME CHOSEN BY THE USER
		ienv	ftgentmp	0,0,1024,7,0,(1024*0.01),1,(1024*0.98),1,(0.01*1024),0	;ANTI-CLICK ENVELOPE SHAPE
	 	aenv	poscil	1, 2/itime, ienv	;CREATE A CYCLING AMPLITUDE ENVELOPE THAT WILL SYNC TO THE TAP DELAY TIME PHASOR

	 	abufferL	delayr	5			;CREATE A DELAY BUFFER
		atapL	deltap3	aptr			;READ AUDIO FROM A TAP WITHIN THE DELAY BUFFER
			delayw	ainL			;WRITE AUDIO INTO DELAY BUFFER

		abufferR	delayr 5
		atapR	deltap3	aptr			;READ AUDIO FROM A TAP WITHIN THE DELAY BUFFER
			delayw	ainR			;WRITE AUDIO INTO DELAY BUFFER

		rireturn				;RETURN FROM REINITIALISATION PASS
		arevL = atapL*aenv
		arevR = atapR*aenv
	else
		arevL = 0
		arevR = 0
	endif

	aoutL ntrpol ainL, arevL, kdrywet
	aoutR ntrpol ainR, arevR, kdrywet



	xout	aoutL, aoutR			;SEND AUDIO BACK TO CALLER INSTRUMENT. APPLY AMPLITUDE ENVELOPE TO PREVENT CLICKS.
endop

opcode	Reverse, aa, aa				;nb. CAPITAL K CREATE A K-RATE VARIABLE THAT HAS A USEFUL VALUE ALSO AT I-TIME
	ainL,ainR xin			;READ IN INPUT ARGUMENTS
	aOutL, aOutR Reverse ainL, ainR, 0.75, 1
	xout aOutL, aOutR
endop
