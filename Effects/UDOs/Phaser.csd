;Author: Iain McCurdy (2012)
;http://iainmccurdy.org/csound.html

opcode	Phaser,a,akkkkKki
	ain,kmix,krate,kdepth,kfreq,kstages,kfback,ishape	xin		;READ IN INPUT ARGUMENTS
	if ishape=1 then
	 klfo	lfo	kdepth*0.5, krate, 1				;LFO FOR THE PHASER (TRIANGULAR SHAPE)
	elseif ishape=2 then
	 klfo	lfo	kdepth*0.5, krate, 0				;LFO FOR THE PHASER (SINE SHAPE)
	elseif ishape=3 then
	 klfo	lfo	kdepth*0.5, krate, 2				;LFO FOR THE PHASER (SQUARE SHAPE)
	elseif ishape=4 then
	 klfo	lfo	kdepth*0.5, krate, 4				;LFO FOR THE PHASER (SAWTOOTH)
	elseif ishape=5 then
	 klfo	lfo	kdepth*0.5, krate, 5				;LFO FOR THE PHASER (SAWTOOTH)
	elseif ishape=6 then
	 klfo	randomi	-kdepth*0.5, kdepth*0.5, krate*8		;LFO FOR THE PHASER (RANDOMI SHAPE)
	 klfo	portk	klfo, 1/(krate*8)				;SMOOTH CHANGES OF DIRECTION
	elseif ishape=7 then
	 klfo	randomh	-kdepth*0.5, kdepth*0.5, krate			;LFO FOR THE PHASER (RANDOMH SHAPE)
	endif
	aphase	phaser1	ain, cpsoct((klfo+(kdepth*0.5)+kfreq)), kstages, kfback	;PHASER1 IS APPLIED TO THE INPUT AUDIO

	aout ntrpol ain, aphase, kmix

		xout	aout							;SEND AUDIO BACK TO CALLER INSTRUMENT
endop

opcode	Phaser,aa,aakkkkKki

	ainL,ainR,kmix,krate,kdepth,kfreq,kstages,kfback,ishape	xin		;READ IN INPUT ARGUMENTS

	if ishape=1 then
	 klfo	lfo	kdepth*0.5, krate, 1				;LFO FOR THE PHASER (TRIANGULAR SHAPE)
	elseif ishape=2 then
	 klfo	lfo	kdepth*0.5, krate, 0				;LFO FOR THE PHASER (SINE SHAPE)
	elseif ishape=3 then
	 klfo	lfo	kdepth*0.5, krate, 2				;LFO FOR THE PHASER (SQUARE SHAPE)
	elseif ishape=4 then
	 klfo	lfo	kdepth*0.5, krate, 4				;LFO FOR THE PHASER (SAWTOOTH)
	elseif ishape=5 then
	 klfo	lfo	kdepth*0.5, krate, 5				;LFO FOR THE PHASER (SAWTOOTH)
	elseif ishape=6 then
	 klfo	randomi	-kdepth*0.5, kdepth*0.5, krate*8		;LFO FOR THE PHASER (RANDOMI SHAPE)
	 klfo	portk	klfo, 1/(krate*8)				;SMOOTH CHANGES OF DIRECTION
	elseif ishape=7 then
	 klfo	randomh	-kdepth*0.5, kdepth*0.5, krate			;LFO FOR THE PHASER (RANDOMH SHAPE)
	endif
	aphaseL	phaser1	ainL, cpsoct((klfo+(kdepth*0.5)+kfreq)), kstages, kfback	;PHASER1 IS APPLIED TO THE INPUT AUDIO
	aphaseR	phaser1	ainR, cpsoct((klfo+(kdepth*0.5)+kfreq)), kstages, kfback	;PHASER1 IS APPLIED TO THE INPUT AUDIO
	
	aoutL ntrpol ainL, aphaseL, kmix	
	aoutR ntrpol ainR, aphaseR, kmix

		xout	aoutL,aoutR							;SEND AUDIO BACK TO CALLER INSTRUMENT
endop

opcode	Phaser,aa,aa

	ainL,ainR	xin		;READ IN INPUT ARGUMENTS

	aoutL, aoutR Phaser ainL, ainR, 0.5, 0.5, 0.5, 0.5, 8, 0.5, 2

	xout	aoutL,aoutR							;SEND AUDIO BACK TO CALLER INSTRUMENT
endop

