% cvx_solver Gurobi_2;
% cvx_solver_settings('Heuristics',0,'MIPGap',1e-4);
% cvx_solver sdpt3
cvx_solver Mosek
cvx_precision best;
% cvx_solver_settings -clearall
cvx_tic;
% cvx_solver_settings('MSK_DPAR_MIO_TOL_REL_GAP',1e-2)
% param.MSK_DPAR_MIO_TOL_REL_GAP=1e-6; 