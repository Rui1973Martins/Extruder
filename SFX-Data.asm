SoundEffectsData:
	defw SoundEffect0Data
	defw SoundEffect1Data
	defw SoundEffect2Data
	defw SoundEffect3Data
	defw SoundEffect4Data
	defw SoundEffect5Data
	defw SoundEffect6Data
	defw SoundEffect7Data

SoundEffect0Data:
	defb 1 ;tone
	defw 10,800,1000,65136,32896
	defb 0
SoundEffect1Data:
	defb 1 ;tone
	defw 6,2200,1024,8192,32896
	defb 0
SoundEffect2Data:
	defb 2 ;noise
	defw 2,2000,28936
	defb 0
SoundEffect3Data:
	defb 1 ;tone
	defw 3,500,80,65531,128
	defb 0
SoundEffect4Data:
	defb 1 ;tone
	defw 4,200,10000,64286,250
	defb 0
SoundEffect5Data:
	defb 1 ;tone
	defw 3,500,1200,120,504
	defb 0
SoundEffect6Data:
	defb 2 ;noise
	defw 2,600,32773
	defb 0
SoundEffect7Data:
	defb 1 ;tone
	defw 5,600,900,32767,16512
	defb 0
