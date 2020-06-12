Codes on Lipschitz parameterization for synchronous generator model-see Section V.B in the paper for reference.

Main (important) codes:

1. main_program_fixed_eps_h.m runs the benchmark to compute Lipschitz constant with varying eps_omega using interval-based algorithm.
2. main_program_fixed_eps_omega.m runs the benchmark to compute Lipschitz constant with varying eps_h using interval-based algorithm.
3. main_program_LDS_benchmark.m computes Lipschitz constant via quasi-random search.
4. main_program_globalsearch_benchmark.m computes Lipschitz constant via global search.
5. main_program_globalsearch_2_norm_benchmark.m computes Lipschitz constant via global search using 2-norm of Jacobian.
6. main_program_DSE.m simulate the state estimation using MOSEK SDP solver with YALMIP interface.
