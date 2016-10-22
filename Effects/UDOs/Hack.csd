/* 	
 ---------------------------------------------------------------
	Hack effect (Square Wave amplitude modulation)

	Author: Alex Hofmann

	COSMO version: Bernt Isak Wærstad
	Date: 2016.09.21
 ---------------------------------------------------------------
*/
opcode Hack, aa, aakk

	ainL, ainR, kDryWet, kFreq  xin

	kFreq expcurve kFreq, 30
	kFreq scale kFreq, 45, 0.5
	Srev sprintfk "Hack freq: %fHz", kFreq
		puts Srev, kFreq 
	kFreq port kFreq, 0.1

	kDryWet scale kDryWet, 1, 0
	Srev sprintfk "Hack Mix: %f", kDryWet
		puts Srev, kDryWet+1 

	kDryWet port kDryWet, 0.1 

	aMod lfo 1, kFreq, 3
	aMod butlp aMod, 300

	aHackL = ainL * (aMod)
	aHackR = ainR * (aMod)
	
	aOutL ntrpol ainL, aHackL, kDryWet
	aOutR ntrpol ainR, aHackR, kDryWet

	xout aOutL, aOutR
	
endop

opcode Hack, aa, aak

	ainL, ainR, kDryWet  xin
	
	aOutL, aOutR Hack ainL, ainR, kDryWet, 0.5

	xout aOutL, aOutR
	
endop

opcode Hack, aa, aa

	ainL, ainR  xin
	
	aOutL, aOutR Hack ainL, ainR, 1, 0.5

	xout aOutL, aOutR
	
endop

