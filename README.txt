The Free Waveform header tools were written by
Filip Szczepankiewicz and Isaiah Norton

The goal of this library is threefold:

1. To provide a small abstraction to ENCODE blocks of typed vectors in base64. By doing so we can easily store the gradient waveform in the dicom header. This saves space and allows arbitrary data without
danger of any null characters.
-See example in vectest.c::create()

2. To provide tools that can DECODE the stored information. These are implemented primarily in MATLAB, but some instructions can be found for PYTHON.
-See examples in fwf_decode_example_matlab.m and fwf_decode_example_python.py

3. To provide tools that can extract sequence configurations from specific implementations of the Free Waveform (FWF) sequence. Currently this is implemented at Siemens MRI systems with FWF version 1.12 or later.
-See example in fwf_siemens_example.m
