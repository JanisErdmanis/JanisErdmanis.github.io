+++
date = "2017-01-01"
rss = "At a nanoscale at cold sub kelvin temperatures and large magnetic fields, an electron for a few centimetres flows like photons on optical fiber coherently. This enables envisioning an electron interferometer experiment on a solid state device; thus, a question on preparing an electron quantum state becomes important. In my BSc thesis project, I derived and, using Python, computed the resulting state of an electron emitted from an electric field veil lowering one of its barriers."
tags = ["research", "phd"]
+++

# Understanding quantum state of emitted electron

~~~
<video width="70%" style="margin: 0 auto; display: block;" controls=""><source src="optimal-pulse.mp4#t=2" type="video/mp4"></video>
~~~

Like optical fibers for photons, the Quantum Hall effect carries electrons along its edge channels. This similarity makes it possible to conduct electron interferometry experiments in a solid-state device. Although now it is an ambitious setting because of many difficulties, knowledge of how electron emission protocol from an on-demand electron source affects its quantum state and its quantumness could become useful in the future.

For this purpose, we did consider the toy model Hamiltonian:

$$ H = \epsilon |d\rangle \langle d| + \sum_k E_k |k\rangle \langle k| + \sum_k V_k |k\rangle \langle d| + h.c. $$

  where $|d\rangle$ is a state of the quantum dot, and $|k\rangle$ are evenly spaced energy states on the quantum Hall edge channel. In the experiments, it is possible to obtain exponential tunnelling rate time dependence. But with wide band approximation, we may say that process is described with a couplings $\sqrt{2 \pi \rho} V_k(t) = \sqrt{\hbar/\tau} e^{t/2\tau}$. The animation shows the corresponding emission when the energy of the quantum dot state remains steady. For a more detailed analysis, see my [BSc thesis summary](artefacts/BScSummary.pdf). 

In a more realistic case, quantum dot coupling depends on energy which could be deduced by considering a parabolic potential barrier. In the case of a static barrier, emission can be initiated by driving the quantum dot potential up until the electron tunnels. This case is analysed by [Kashcheyevs & Samuelsson (2017)](https://arxiv.org/abs/1701.02637).
