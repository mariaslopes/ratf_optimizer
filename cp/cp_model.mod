using CP;

//******** Sets ***********/
{int} L = {18,19,11,12,50,51,52,53,7,8,14,15,62,63,64,65};
{int} I = {50, 51, 52, 53};
{string} Entries = {"E1","E2","E3","E4"};
{int} O = {62,63,64,65};
{string} Outputs = {"O1","O2","O3","O4"};
{int} A_i = {11, 18};
{int} A_o = {12, 19};
{int} B_i = {7, 14};
{int} B_o = {8, 15};
{int} M_i ={11,18,7,14};
{string} Pickings = ...;
{string} Droppings = ...;
{string} Machines = ...;

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

int nBoxes = ...;
range P = 1 .. nBoxes;
int n_eta[P] = ...; 
int L_c[P] = ...; 
int C = ...;
int tfinal=2*(nBoxes+sum(c in P) n_eta[c])+1;
range T = 0 .. tfinal ;
range T_1 = 0 .. tfinal - 1;

{string} Workers = ...;

{string} Tasks = ...;

{string}  Parts[P] = ...;

tuple Skill {
  string worker;
  string task;
  int    location;  
};
{Skill} Skills = ...;

tuple Precedence {
  string pre;
  string post;
  string type;
};
{Precedence} Precedences[P] = ...;
int Deadline[Tasks];

execute {
  for (var t in Tasks) {
	Deadline[t] =tfinal;
    for (var p in Pickings ){
	    if (t == p) {
	      Deadline[t] = 1;
	    } 
   	}
   	 for (var p in Droppings ){
	    if (t == p) {
	      Deadline[t] = 1;
	    } 
   	}
   		    
  }
}

dvar int Xr[T_1];
dvar interval tasks [c in P][t in Tasks] optional(!(t in Parts[c]))in T size 1..Deadline[t];
dvar interval wtasks[c in P][s in Skills] optional in T size 1..Deadline[s.task] ;
cumulFunction currentCapacity = sum(c in  P, p in Pickings inter Parts[c])  stepAtStart(tasks[c][p], 1) 
							  - sum(c in  P, d in Droppings inter Parts[c]) stepAtEnd(tasks[c][d], 1);
							  
dexpr float objective = sum(i in 0..tfinal-2) d[Xr[i]][Xr[i+1]];						  
minimize objective;

subject to {
	alwaysIn(currentCapacity, 0,tfinal, 0, C);  
	Xr[0] == 18;
 
	forall(i in T_1)
		Xr[i] in L;  
	
	forall(c in P){ 	
  		startOf(tasks[c]["Entry"]) == 0;
		noOverlap(all(t in Pickings union Droppings) tasks[c][t]);
		noOverlap( all(t in Tasks diff Parts[c]) tasks[c][t] );
		
		forall (p in Precedences[c])
	 	{
		   	if (p.type =="startAtEnd")
		    	startAtEnd(tasks[c][p.post],tasks[c][p.pre]);
		    if (p.type=="endAtEnd")
		    	endAtEnd(tasks[c][p.pre],tasks[c][p.post]);
		    if (p.type=="endBeforeStart")
		    	endBeforeStart(tasks[c][p.pre],tasks[c][p.post]);
		}    	
		
		forall (t in Tasks) alternative(tasks[c][t], all(s in Skills: s.task == t ) wtasks[c][s]);
		alternative(tasks[c]["Entry"], all(s in Skills: s.location== L_c[c]) wtasks[c][s]);
		endOf(tasks[c]["Output"])==tfinal;
		forall(w in Workers) noOverlap(all(c in P, s in Skills: s.worker==w) wtasks[c][s]);	
	}      

	forall(t in 1..tfinal-1){
    	forall(c in P)
       	{
	       forall(s in Skills: s.task == "Entry") endOf(wtasks[c][s]) == t => Xr[t] == s.location;
	       forall(s in Skills: s.task == "Output") startOf(wtasks[c][s]) == t => Xr[t] == s.location;
	       forall(s in Skills: s.task in Machines) startOf(wtasks[c][s]) == t => Xr[t] == s.location;
	       forall(s in Skills: s.task in Machines) endOf(wtasks[c][s]) == t => Xr[t] == s.location+1;
	   	}	     	    
   	}
}


