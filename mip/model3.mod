execute PARAMS {
	cplex.tilim = 1*60*60;//1h limit
}

//******** Sets ***********/
{int} L = {18,19,11,12,50,51,52,53,7,8,14,15,62,63,64,65};
{int} I = {50, 51, 52, 53};
{int} O = {62,63,64,65};
{int} A_i = {11, 18};
{int} A_o = {12, 19};
{int} B_i = {7, 14};
{int} B_o = {8, 16};
{int} M_i ={11,18,7,14};

//to be computed from data of the instance
int nBoxes = ...;
range P = 1 .. nBoxes;

int n_eta[P] = ...; 
int L_c[P] = ...; 
int C = ...;

int tfinal=2*(nBoxes+sum(c in P) n_eta[c])+1;
range T = 0 .. tfinal;


range T_1 = 0 .. tfinal - 1;

//******** Data ***********/
float d[L][L] = [[ 0.0, 1.587, 0.61, 1.737, 0.915, 1.065, 1.215, 1.365, 1.881, 2.585, 1.731, 2.435, 1.565, 1.715, 1.87, 2.02 ],
    [ 1.587, 0.0, 1.737, 0.614, 1.622, 1.472, 1.322, 1.172, 0.758, 1.882, 0.608, 1.732, 0.862, 1.012, 1.167, 1.317 ],
    [ 0.61, 1.737, 0.0, 1.887, 0.765, 0.915, 1.065, 1.215, 1.731, 2.435, 1.881, 2.585, 1.715, 1.865, 2.02, 2.17 ],
    [ 1.737, 0.614, 1.887, 0.0, 1.472, 1.322, 1.172, 1.022, 0.608, 1.732, 0.458, 1.882, 1.012, 1.162, 1.317, 1.467 ],
    [ 0.915, 1.622, 0.765, 1.472, 0.0, 0.5, 0.65, 0.8, 1.316, 2.02, 1.466, 2.17, 2.02, 2.17, 2.325, 2.475 ],
    [ 1.065, 1.472, 0.915, 1.322, 0.5, 0.0, 0.5, 0.65, 1.166, 1.87, 1.316, 2.02, 1.87, 2.02, 2.175, 2.325 ],
    [ 1.215, 1.322, 1.065, 1.172, 0.65, 0.5, 0.0, 0.5, 1.016, 1.72, 1.166, 1.87, 1.72, 1.87, 2.025, 2.175 ],
    [ 1.365, 1.172, 1.215, 1.022, 0.8, 0.65, 0.5, 0.0, 0.866, 1.57, 1.016, 1.72, 1.57, 1.72, 1.875, 2.025 ],
    [ 1.881, 0.758, 1.731, 0.608, 1.316, 1.166, 1.016, 0.866, 0.0, 1.576, 0.602, 1.726, 1.156, 1.306, 1.461, 1.611 ],
    [ 2.585, 1.882, 2.435, 1.732, 2.02, 1.87, 1.72, 1.57, 1.576, 0.0, 1.726, 0.61, 1.37, 1.22, 1.065, 0.915 ],
    [ 1.731, 0.608, 1.881, 0.458, 1.466, 1.316, 1.166, 1.016, 0.602, 1.726, 0.0, 1.876, 1.006, 1.156, 1.311, 1.461 ],
    [ 2.435, 1.732, 2.585, 1.882, 2.17, 2.02, 1.87, 1.72, 1.726, 0.61, 1.876, 0.0, 1.22, 1.07, 0.915, 0.765 ],
    [ 1.565, 0.862, 1.715, 1.012, 2.02, 1.87, 1.72, 1.57, 1.156, 1.37, 1.006, 1.22, 0.0, 0.5, 0.655, 0.805 ],
    [ 1.715, 1.012, 1.865, 1.162, 2.17, 2.02, 1.87, 1.72, 1.306, 1.22, 1.156, 1.07, 0.5, 0.0, 0.505, 0.655 ],
    [ 1.87, 1.167, 2.02, 1.317, 2.325, 2.175, 2.025, 1.875, 1.461, 1.065, 1.311, 0.915, 0.655, 0.505, 0.0, 0.5 ],
    [ 2.02, 1.317, 2.17, 1.467, 2.475, 2.325, 2.175, 2.025, 1.611, 0.915, 1.461, 0.765, 0.805, 0.655, 0.5, 0.0 ]];
   

int iR = 18;
int o_i[L] = [1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0];

//******** Decision variables ***********/
dvar boolean x[T][L][L]; // 1 if robot moved from i(L) to j(L) in iteration t 
dvar boolean p[T][P];    // 1 if robot is carrying the box c(P) in iteration t 
dvar boolean b[T][P][L]; // 1 if box c is at location i at iteration t
dvar int+ n[T][P];        // number of operations done on box c in iteration t
dvar boolean sigma[T][P][L]; // 1 if robot picks box c in location i in iteration t 
dvar boolean delta[T][P][L]; // 1 if robot leaves box c in location i in iteration t

//Stage 3 
dvar boolean alpha[T][P]; // 1 if the box c must be operated at a Machine A
dvar boolean beta[T][P]; // 1 if the box c must be operated at a Machine B

dexpr float objective = sum(t in T, i in L, j in L)(x[t,i,j]*d[i,j]);

minimize objective;


subject to {
  
   //Stage 1
	c1_iBox: forall(c in P) b[0][c][L_c[c]] == 1;
	   
	c2_iRobot: x[0][iR][iR] == 1;
	 
	c3_iCarry: forall(c in P) p[0][c] == 0;
	 
	c4_exitBoxes: sum(c in P,i in O) b[tfinal][c][i] >= nBoxes;
	 
	c5_carryCapacity: forall(t in T) sum(c in P) (p[t][c]) <= C;
	 
	c6_robotMov: forall(t in T) sum(i in L, j in L) (x[t][i][j]) == 1; 
	 
	c7_connectivityBox: forall (c in P, t in T) sum(i in L) (b[t][c][i]) + p[t][c] == 1; 
	
	c8_oneBoxPerLocation: forall (i in L, t in T) sum(c in P) (b[t][c][i]) <= 1;
	 
	c9_connectivity: forall (t in T_1, i in L) 
	 	sum (k in L) (x[t][k][i]) >= sum (j in L) (x[t+1][i][j]);
	 	
	c10_pickBox1_robotL: forall (t in 0..tfinal, c in P, j in L)   sigma[t][c][j]  <= sum(i in L)x[t][i][j] ;
	 
	c11_pickBox2_boxL: forall (t in T, c in P, i in L) sigma[t,c,i] <= b[t,c,i]; 
	
	c12_pickBox3_boxTake: forall (t in T_1, c in P, i in L) b[t+1,c,i] <= b[t,c,i] - sigma[t,c,i] + 10 *sum(i in L) delta[t,c,i]; 
	 
	c13_pickBox4_capacityUpdate: forall (t in T_1, c in P) p[t+1, c] <= p[t,c] + sum(i in L) sigma[t,c,i] + 10 *sum(i in L) delta[t,c,i] ;
	
	c14_dropBox1_robotL: forall (t in T, c in P, j in L) delta[t,c,j] <= sum(i in L) x[t,i,j]; 
	
	c15_dropBox2_freeLocation: forall (t in T, c in P, i in L) delta[t,c,i] <= 1 - sum(k in P) b[t,k,i+o_i[i]]; 
	
	c16: forall (t in T, c in P) sum(i in L) delta[t][c][i] <= p[t][c];
	
	c17_dropBox3_boxLeave: forall (t in T_1, c in P, i in L) b[t+1,c,i+o_i[i]] >= delta[t,c,i] -10*sigma[t,c,i]; 
	
	c18_dropBox4_capacityUpdate: forall (t in T_1, c in P) p[t+1, c] >= p[t,c] - sum(i in L) delta[t,c,i] - 10*sum(i in L) sigma[t,c,i];
	
	//Stage 2
	c19_iOperations: forall(c in P) n[0][c] == 0;
	 
	c20_nOperations: forall(c in P) n[tfinal][c] >= n_eta[c];
	
	c21_nOperations_update: forall(t in T_1, c in P ) n[t+1][c] <= n[t][c] + sum(i in M_i) delta[t][c][i];
	
	////Stage 3
	c22_dropBox7_machA_1: forall(t in T,c in P, i in A_i) delta[t,c,i] <= alpha[t][c];
	
	c23_dropBox8_machA_2: forall(t in T,c in P, i in (L diff A_i)) delta[t,c,i] <= 1-alpha[t][c];
	
	c24_dropBox5_machB_1: forall(t in T, c in P, i in B_i) delta[t,c,i] <= beta[t][c]-alpha[t][c];
	 
	c25_dropBox6_machB_2: forall(t in T, c in P, i in (L diff B_i)) delta[t,c,i] <= 1- beta[t][c] + alpha[t][c];
	
	c26_CTbeta: forall(t in T,c in P) 2*beta[t][c] >= n_eta[c] - n[t][c];
	
	c27_CTalpha: forall(t in T,c in P) alpha[t][c] + beta[t][c] <= n_eta[c] - n[t][c];
 }
 
 
 