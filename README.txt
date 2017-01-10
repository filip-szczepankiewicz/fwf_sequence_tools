The goal of this library is to provide a small abstraction for encoding blocks of typed vectors in
base64. The base64 string can then be safely stored in the Siemens CSA text field by the ICE
controller, and extracted at a later time. This saves space and allows arbitrary data without
danger of any null characters.

Usage example is found in vectest.c::create()
