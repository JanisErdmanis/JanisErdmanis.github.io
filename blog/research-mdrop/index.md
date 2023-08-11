+++
date = "2017-01-01"
rss = "In my master's project, I investigated the behaviour of magnetic fluid droplets formed through induced phase separation under varying magnetic fields. When subjected to fast-rotating magnetic fields of different intensities, these droplets exhibit intricate shapes such as oblate, three-axial, and starfish. The project aimed to determine whether a simple magnetic drop model could explain this complex behaviour under strong magnetic fields, where equilibrium arises from the interplay between scalar surface tension and linear magnetic force."
tags = ["research", "julia"]
+++

# Properties of magnetic fluid droplets created by induced phase separation

~~~
<video width="70%" style="margin: 0 auto; display: block;" controls=""><source src="star.mp4" type="video/mp4"></video>
~~~

In my MSc project, I considered the properties of magnetic fluid droplets created by induced phase separation. Under a fast-rotating magnetic field, these droplets take oblate, three-axial and starfish shapes depending on the magnetic field intensity. It was my task to understand if this rich behaviour for large magnetic fields could be understood with a simple magnetic drop model, where the equilibrium is only between scalar surface tension and linear magnetic force $({\bf M} \cdot \nabla) {\bf H}$ (${\bf B} = \mu {\bf H}$). To answer this question, the task of calculating equilibrium figures and direct comparison with the experiment was set. (see the video on the right for starfish equilibrium calculation).

With equilibrium figure calculations, we validated the ellipsoidal model for calculating critical field value when a transition from oblate to three axial figure happens and for calculating equilibrium figure axes even when the droplet becomes non-ellipsoidal. This knowledge allowed us to find $\mu$ and $\gamma/R_0$ from droplet behaviour in rotating field experiments alone by fitting theory to the experiment.

We compared obtained values with the elongation experiment and found good agreement for $\mu$, but a significant difference for surface tension $\gamma/R_0$. Also, a slight discrepancy was found in the critical field value, where we validated the method with simulation. Thus, surface tension is affected by the magnetic field in an unknown way.

One way we expected these effects to become present was deviations between simple magnetic drop model and experiment at large magnetic fields. Qualitatively we saw the same behaviour - forming sharp tips for the three-axial figure and the shape widening in one direction. Also, we directly compared three-axial and starfish equilibrium figures at $\mu$ and $\gamma/R_0$ values obtained previously. Excellent agreement was observed, thus excluding anisotropic surface tension effects when a droplet is in a rotating field. 

We also did a study transition from three axial figures to starfish. Although we could not induce transition numerically, we demonstrated that starfish become energetically more favourable for large magnetic fields. For small magnetic fields, we could show the existence of a minimal field when higher-order perturbation does not grow. This result also agrees qualitatively with previously derived analytic results from linear perturbation theory for two dimensions. The research can be found in [Erdmanis et al. (2017)](https://arxiv.org/abs/1703.03654).

## Force between magnet and magnetizable body

Although we aimed to make a viscous magnetic droplet simulation to calculate equilibrium figures, we found an astonishing hole in the boundary element literature. Let's say you want to calculate the force between a magnet and a magnetisable body. The usual way considered in the literature is, to sum up all $({\bf M} \cdot \nabla) {\bf H}$ contributions overall volume. But in case ${\bf B} = \mu {\bf H}$ the magnetic force can also be evaluated only from surface magnetic field values 
$${\bf F} = \int ({\bf M} \cdot \nabla) {\bf H} dV = ... \int B_n^2 {\bf n} dS + ... \int H_t^2 {\bf n} dS $$
where $B_n$ and $H_t$ are normal components of magnetic induction and tangential component modulus of magnetic intensity. We found no literature using this formula for force calculation!

Our main issue for making a full 3D viscous droplet simulation to calculate equilibrium figures was the same. Although literature was perfected for making 2D and axisymmetric simulations, it was impossible to generalise that to 3D due to the presence of a strong singularity in boundary integral equations, where we found no consensus on how to integrate them numerically in 3D. To overcome this difficulty, we developed a new way to calculate the magnetic field on the magnetisable body surface.

Firstly we calculated magnetic potential and then, with numerical differentiation, tangential components of magnetic field intensity. The normal components of field induction were further recalculated with the Biot-Savarat integral, which we derived with pure boundary integral formalism and with physical assumptions in [Erdmanis et al. (2017)](https://arxiv.org/abs/1703.03654). 

The physical way uses that the perturbed magnetic field of a linear magnetic body is equivalent to the field as it would come from surface currents only. This allows us to write a formula for the surface current $4 \pi {\bf K}/c = - (\mu -1) {\bf n} \times {\bf H}$, which we can now use in the Biot-Savart integral for calculating magnetic field perturbation everywhere from tangential filed components. It is fascinating that the result is also valid for electric fields where this derivation does not apply! 

Due to simplicity, generality, efficiency and many analytic tests found in an article, we believe that the combined field calculation algorithm will find its use in the industry, where our approach offers precise magnetic field calculation near the magnets and iron parts, calculation of magnetic force for an iron body near the magnet and electric force calculation in an electric field. These are examples of industrial applications that gain a new tool due to pursuing fundamental science. 

**Update: the magnetic field calculation algorithm is now available in [LaplaceBIE](https://github.com/JanisErdmanis/LaplaceBIE.jl).**
