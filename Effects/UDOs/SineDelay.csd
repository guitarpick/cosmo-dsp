
;SinMod Delay

opcode SineDelay, a, ak
ain, kRange xin
prints "SinDel"				
	kFeedback = 0.2
	aWet = 0.5
	kDryWet = 0.5
	;aRange ctrl7 1, p4, 0.001, 0.5
	kRange scale kRange, 0.5, 0.001
	aSinL poscil kRange, 0.2, 1
	aDelayL delayr 1					;  a delayline, with 1 second maximum delay-time is initialised
	aWetL deltapi aSinL+0.5		; data at a flexible position is read from the delayline 
		 delayw ain+(aWetL*kFeedback)	; the "g.a.Bus" is written to the delayline, - to get a feedbackdelay, the delaysignal (aWet) is also added, but scaled by kFeedback 	
	aOutLtemp = (ain + aWetL); * 0.5	
	xout aOutLtemp
endop
