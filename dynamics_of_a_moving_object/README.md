
Codes on Lipschitz parameterization for dynamics of a moving object-see Section V.C in the paper for reference.

Main (important) codes:
1. main_program.m runs the benchmark to compute OSL constant. eps_F and eps_X can be switched to find OSL constant with varying precision.
2. main_program_qib_lb.m computes one of the QIB constants, which is \gamma_l.
3. main_program_qib_lip.m computes one of the QIB constants, which is \gamma_m.
4. main_program_observer_design.m simulate the state estimation using the given constants. It uses MOSEK SDP solver via YALMIP interface.
