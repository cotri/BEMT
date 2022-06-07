# BEMT

The implementation of the Blade Element Momentum Theory (BEMT) code is intended to analyze the performance of a given propeller geometry at a constant rotational speed for different advance ratios.

This tool has been developed during my Bachelor Thesis in Aerospace Engineering as a part of the design, validation and optimization of propeller performance with special regard to low Reynolds operating propellers (and thus profiles). This particular tool was implemented alongside CFD simulations to obtain the aerodynamic coefficients needed for BEMT.

The base theory, from which the calculation procedure followed by [bemt.m](functions/bemt.m) is primarily based on, can be found in \[1]. For a list of other references related to BEM theory please refer to [#1](https://github.com/cotri/BEMT/issues/1#issuecomment-1148294460).

The chosen propeller and the one whose geometric characteristics are loaded in the code is the *APC 10x7 Thin Electric*.

## Usage

### Introduction

First of all, this project is ran from the [main.m](main.m) script. It first loads the propeller geometric data and air properties predefined inside [init.m](init.m). Although this last script provides the two lines of code which include both *data/* and *functions/* directories into the search path, they are commented out in favour of decreasing the execution time in each subsequent run. Thus, these two folders need to be manually added before running the script.

Since the BEM theory makes use of some sort of aerodynamic database for interpolating the 2D aerodynamic coefficients at each blade section, the corresponding aerodynamic data is loaded too. This data ([polar_naca_xfoil.mat](polar_naca_xfoil.mat)) is stored in a structure variable where the lift and drag coefficients are sampled for a wide range of angles of attack. Each column (except for the first one, which corresponds to the angle of attack) represents the coefficients' values for a certain Reynolds number in increasing order from left to right defined by the *ReIndex* variable accordingly.

It is worth pointing out that this previouly mentioned data has been extrapolated from XFOIL results obtained for the NACA 4412 profile by the Viterna-Corrigan method \[2].

### User input

Once the bases have been covered, the user input is discussed in the following paragraphs.

To begin with, the user can define which tip loss and/or rotational 3D flow effect models are implemented into the BEMT tool (if any). Among the existing models, the considered ones are:

* Tip loss models
  * Prandtl tip loss factor
  * De Vries correction model present in \[3]

* Rotational 3D flow models
  * H. Snel *et al.* \[4]
  * Z. Du and M. S. Selig \[5]

A fixed rotational regime value, $n$, is required as well as the free stream velocity the propeller is experiencing, $V_{\infty}$. This last variable can be either a range of speeds for which the propeller force coefficients are calculated at each free stream value or single speed which, in that case, the differential force coefficients are represented along the blade span. A brief example of the input-output regarding the free stream velocity is shown below.

```matlab
% Range of free stream velocities
Vinf = 11.5:0.1:23.5
```
![](https://github.com/cotri/BEMT/blob/master/imgs/out_range_Vinf.png)

```matlab
% Single free stream velocity value
Vinf = 18
```
![](https://github.com/cotri/BEMT/blob/master/imgs/out_single_Vinf.png)

## Results

In conclusion, the obtained characteristic curves form the BEMT tool are plotted against the included experimental data for the chosen propeller \[6]. Moreover, the results obtained from adding numerous aerodynamic data sources can be compared in an effort to determine the best fit to the experimental curve. The figure below ilustrates the difference among the experimental wind tunel data (UIUC) and the aerodynamic coefficients inputted from Ostowari \[7] and Simons \[8] works, XFOIL, and CFD simulations with different turbulence models ($S-A$ and $k-k_L-\omega$) with the Du and Selig 3D flow correction.

Overall, the accuracy of the tool is limited by the assumptions made by the BEM theory but it strongly depends on the quality of the aerodynamic data introduced.

![](https://github.com/cotri/BEMT/blob/master/imgs/charCurves_naca_DuSelig.png)

## License

This project is licensed under the GNU GPLv2 License - see the [LICENSE.md](LICENSE.md) file for details.

## References

\[1] D. R. Greatix, «The Propeller», in *Powered Flight: The Engineering of Aerospace Propulsion*, London: Springer-Verlag, 2012, p. 63-76.

\[2] L. A. Viterna and R. D. Corrigan, «Fixed Pitch Rotor Performance of Large Horizontal Axis Wind Turbines», NASA Lewis Res. Center, Cleveland, OH, USA, Rep. 83N19233, Jan. 1982.

\[3] W. Shen et al., «Tip loss corrections for wind turbine computations», Wind Energy, vol. 8, pp. 457-475, 2005.

\[4] H. Snel et al., «Sectional Prediction of 3D Effects for Stalled Flow on Rotating Blades and Comparison with Measurements», in *Proc. European Community Wind Energy Conf.*, Lübeck-Travemünde, Germany, Mar. 1993, pp. 395-399.

\[5] Z. Du and M. S. Selig, «A 3-D Stall-Delay Model for Horizontal Axis Wind Turbine Performance Prediction», in *36th AIAA Aerospace Sciences Meeting and Exhibit, 1998 ASME Wind Energy Symposium*, Reno, NV, USA, Jan. 1998.

\[6] G. Ananda, «UIUC Propeller Data Site - Volume 1», UIUC Applied Aerodynamics Group. 2018. [Online]. Available: https://m-selig.ae.illinois.edu/props/volume-1/propDB-volume-1.html

\[7] C. Ostowari and D. Naik, «Post-Stall Wind Tunnel Data for NACA 4XXX Series Airfoil Sections», Texas A&M Univ., College Station, Dept. of Aerospace Engineering, TX, USA, Tech. Rep. SERI/STR-217-2559, Jan. 1985.

\[8] M. Simons, «Appendix 2», in *Model Aircraft Aerodynamics*, 3rd Ed., U.K.: Argus Books, 1994, p. 271.
