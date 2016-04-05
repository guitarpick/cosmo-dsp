opcode Chorus, aa, aak
	ain1, ain2, kFeedback xin
prints "chorus.." 	
	aWetL init 0.0
	aWetR init 0.0
	kDryWet = 0.5
		kFeedback scale kFeedback, 1, 0.001
	aSinL poscil 0.001, 3, 1
	aSinR poscil 0.001, 1, 1
	aDelayL delayr 5.25					;  a delayline, with 1 second maximum delay-time is initialised
	aWetL deltapi aSinL+(0.1/2)		; data at a flexible position is read from the 
		 delayw ain1+(aWetL*kFeedback)	; the "g.a.Bus" is written to the delayline, - to get a feedbackdelay, the delaysignal (aWet) is also added, but scaled by kFeedback 
	aDelayR delayr 5.25					;  a delayline, with 1 second maximum delay-time is initialised
	;aWetR	deltapi aSinR+0.22+kgDelTim	
	aWetR	deltapi aSinR+0.02+(0.1/2)				; data at a flexible position is read from the delayline 
		  delayw ain2+(aWetR*kFeedback)	; the "g.a.Bus" is written to the delayline, - to get a feedbackdelay, the delaysignal (aWet) is also added, but scaled by kFeedback 
xout aWetL, aWetR
endop

