<CsoundSynthesizer>
<CsOptions>
;-odac:hw:1,0 -iadc:hw:1 -d -+rtaudio=ALSA -b512 -B2048 -j4 --realtime
-odac -iadc0 -b128 -B512 -m0d
</CsOptions>
<CsInstruments>
sr      = 44100
ksmps  	= 128
0dbfs	= 1
nchnls 	= 2

#include "UDOs/Reverb.csd"
#include "UDOs/Lowpass.csd"
#include "UDOs/AudioAnalyzer.csd"
#include "UDOs/Phaser.csd"


instr 1 
	#include "../includes/adc_channels.inc"
	#include "../includes/gpio_channels.inc"

	aL, aR ins

	aL, aR EnvelopeFollower aL, aR
	aL, aR PitchTracker aL, aR

	kcps chnget "PitchTracker"

	kcps scale kcps/1000, 0.99, 0.7
	;printk2 kcps

	kamp chnget "EnvelopeFollowerSlow"
	;printk2 kamp
	kamp scale kamp, 1, 0.2

	; Lowpass_Stereo arguments: cutoff, resonance
	;aL, aR Lowpass aL, aR, kamp, 0.7, 0.5 ;gkpot2, gkpot3


	; Reverb arguments: decay, cutoff, mix
	aL, aR Reverb aL, aR, kcps, 1.2-kamp, 0.2 ; gkpot0, gkpot1, gktoggle0
	; gkled0 = gktoggle0

	aL, aR Phaser aL, aR, 0.5, 0.8, 1, 0.8, 12, 0.75, 2

	outs aL, aR

endin


</CsInstruments>
<CsScore>
i1 0 86400
</CsScore>
</CsoundSynthesizer>


