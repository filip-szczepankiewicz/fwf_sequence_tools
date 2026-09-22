# DIME — Double-Isotropic Matched Encoding

## Overview

DIME is a gradient waveform design for tensor-valued diffusion MRI under time-dependent diffusion. 
The method optimizes spherical b-tensor encoding (STE) waveforms together with corresponding matched linear 
b-tensor encoding (LTE) waveforms, while maximizing diffusion weighting within a specified encoding time, 
hardware, and safety limits.


## Citation

*Optimized Gradient Waveforms for Tensor-Valued Diffusion MRI Under Time-Dependent Diffusion Using Double-Isotropic Matched Encoding (DIME).*
F Mortensen, V Olsson, A Grigoriou, S Lasič, M, Molendowska, R Wirestam, and F Szczepankiewicz. *Magnetic Resonance in Medicine*. DOI: [10.1002/mrm.70602]()

**Project repository:** [https://github.com/felixmortensen/DIME](https://github.com/felixmortensen/DIME)

## Requirements

The code is implemented as a MATLAB package (`fwf.gwf.create.dime.*`), and requires:

* MATLAB
  * Optimization Toolbox
  * Statistics and Machine Learning Toolbox
  * Global Optimization Toolbox
* [SAFE PNS/CNS prediction framework](https://github.com/filip-szczepankiewicz/safe_pns_prediction)


## Quick start

The example script is integrated in the mein optimizer. Call it with no input arguments for a demo.

```matlab
gwf = fwf.gwf.create.dime.optimize();
```

The optimization can be tailored. For example:

```matlab
dur  = 40;     % available encoding time per side [ms]
tp   = 6;      % central pause/refocusing interval [ms]
gmax = 0.08;   % maximum gradient amplitude [T/m]
smax = 200;    % maximum slew rate [T/m/s]

hw  = safe_example_hw_peripheral;
opt = fwf.gwf.create.dime.options(gmax, smax, dur);

[gwf, t, x] = fwf.gwf.create.dime.optimize(dur, tp, gmax, smax, hw, opt);
```

`gwf` contains the optimized piecewise-linear gradient control points and `t` is their corresponding time points. 
The waveform can be converted to a regularly sampled numerical waveform using:

```matlab
dt = 0.1e-3; % s
[gwf_num, rf, dt] = fwf.gwf.create.dime.convert.ana2num(gwf, t/1000, dt);
```

The resulting waveform can then be inspected together with its matched LTE waveform and predicted stimulation:

```matlab
fwf.gwf.create.dime.plot.gwfSetAndStim(gwf_num, rf, dt, hw);
```

## Package structure

```text
+fwf.gwf.create.dime/
├── optimize.m              Main waveform optimization
├── options.m               Default optimization settings
├── ut.m                    Example/unit-test configurations
├── +convert/
│   ├── ana2num.m           Convert analytic waveform to numerical samples
│   ├── par2gwf.m           Generate waveform from optimization parameters
│   ├── par2bval.m          Analytical diffusion-weighting calculation
│   ├── par2mval.m          Analytical spectral-moment calculation
│   ├── ste2lte.m           Convert STE to matched LTE
│   ├── ste2lte_matched.m   Spectrally matched LTE projection
│   └── tens2shape.m        Calculate tensor anisotropy
└── +plot/
    └── gwfSetAndStim.m      Plot waveforms and predicted stimulation
```