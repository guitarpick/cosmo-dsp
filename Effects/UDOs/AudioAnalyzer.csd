/*  
 ---------------------------------------------------------------
    AudioAnalyzer.csd

    Severaul audio analyzer utilities converting analysis values 
    to controller parameters

    EnvelopeFollower: 
    Tracks the amplitude of the incoming audio and creates two
    controller parameters - one for quick response, and one for 
    slow response. Use [kVar chnget "EnvelopeFollower"] or
    [kVar chnget "EnvelopeFollowerSlow"] in any other instrument
    to access the values     

    PitchTracker:
    Tracks the pitch of the incoming signal and outputs a controller
    value in Hertz through a channel called "PitchTracker"

    Author: Bernt Isak Wærstad

    Date: 2016.09.21

 ---------------------------------------------------------------
*/
opcode	EnvelopeFollower, aa, aa
	ainL, ainR     xin

    ainMono     = (ainL + ainR) * 0.75

    afollow follow2 ainMono * 4, 0.1, 0.1
    kfollow downsamp afollow
    kfollow portk kfollow, 0.1

    afollowSlow follow2 ainMono * 4, 2, 2
    kfollowSlow downsamp afollowSlow
    kfollowSlow portk kfollowSlow, 0.1

    chnset kfollow, "EnvelopeFollower"
    chnset kfollowSlow, "EnvelopeFollowerSlow"

    xout ainL, ainR

endop

opcode PitchTracker, aa, aaiiiii
    ainL, ainR, imincps, imaxcps, imedian, idowns, irmsmedi      xin

    ; paramters
;    imincps     init 100
;    imaxcps     init 1000
    initfreq    = imincps
;    imedian     init 0
;    idowns      init 4
    iexcps      = imincps

    ainMono     = (ainL + ainR) * 0.75
    ainMono     lowpass2 ainMono, imaxcps, 2

;    irmsmedi    init 0
    kcps,krms   pitchamdf   ainMono*0.2, imincps, imaxcps ,initfreq ,imedian ,idowns ,iexcps ,irmsmedi

    chnset kcps, "PitchTracker"

    xout ainL, ainR
endop

opcode PitchTracker, aa, aaii
    ainL, ainR, imincps, imaxcps xin

    ainL, ainR PitchTracker ainL, ainR, imincps, imaxcps, 0, 4, 0

    xout ainL, ainR
endop


opcode PitchTracker, aa, aa
    ainL, ainR xin 

    ainL, ainR PitchTracker ainL, ainR, 100, 1000

    xout ainL, ainR
endop
