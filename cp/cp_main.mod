 using CP;
 
{string} datFiles_R1=...;
{string} datFiles_R2=...;
{string} datFiles_R3=...;
{string} datFiles_R2E=...;
{string} datFiles_R2M3=...;
{string} datFiles_R3E=...;
	
main {
    var runR1 = 0;
    var runR2 = 0;
    var runR2E = 1;
    var runR2M3 = 0;
    var runR3 = 0;
    var runR3E = 0;
    
    if(runR1)
    {
        var source = new IloOplModelSource("cp_model.mod");
        var def = new IloOplModelDefinition(source);
        var cp = new IloCP();
		var f=cp.factory;
        for(var datFile in thisOplModel.datFiles_R1)
        {
          	var cp = new IloCP();
			var f=cp.factory;
          	
            var opl = new IloOplModel(def,cp);

            var data2= new IloOplDataSource("results/"+datFile);
            
            opl.addDataSource(data2);
            opl.generate();

	        if(opl.C==1)
	        {
		        var phase1 = f.searchPhase(opl.tasks,f.selectSmallest(f.domainMin()),f.selectSmallest(f.value()));
				var phase2 = f.searchPhase(opl.wtasks,f.selectSmallest(f.domainMin()),f.selectSmallest(f.value()));
				var phase3 = f.searchPhase(opl.Xr,f.selectSmallest(f.domainMin()),f.selectSmallest(f.value()));
				cp.setSearchPhases(phase1,phase2,phase3);
				cp.param.searchtype="IterativeDiving";
  			}
  			if(opl.C==2)
	        {
			    var phase1 = f.searchPhase(opl.tasks,f.selectSmallest(f.domainMin()),f.selectSmallest(f.value()));
				var phase2 = f.searchPhase(opl.wtasks,f.selectSmallest(f.domainMin()),f.selectSmallest(f.value()));
				var phase3 = f.searchPhase(opl.Xr,f.selectSmallest(f.domainMin()),f.selectSmallest(f.value()));
				cp.setSearchPhases(phase1,phase2,phase3);
				cp.param.searchtype="Restart";
  			}		
  			if(opl.C>2)
	        {
				var phase1 = f.searchPhase(opl.tasks,f.selectSmallest(f.successRate()),f.selectSmallest(f.value()));
				var phase2 = f.searchPhase(opl.wtasks,f.selectSmallest(f.successRate()),f.selectSmallest(f.value()));
				var phase3 = f.searchPhase(opl.Xr,f.selectSmallest(f.successRate()),f.selectSmallest(f.value()));
				cp.setSearchPhases(phase1,phase2,phase3);
				cp.param.searchtype="IterativeDiving";
  			}				

            if (cp.solve()) {
                opl.postProcess();
    			var o=new IloOplOutputFile("results/"+datFile+"_res"+".txt");
                writeln("results/"+datFile+"_res"+".txt");
                o.writeln("TimeToSolve= " + cp.info.TotalTime);
			    o.writeln("Objective= " + cp.getObjValue());
			    o.writeln("tf= " + opl.tfinal);
			    o.writeln("RelativeGap= " + cp.info.Gap);
			    o.writeln("LowerBound= " + cp.getObjBound());
			
			    var x = opl.Xr;
			  
			 	for (var t in opl.T_1) {
			        o.writeln("Iteration t = " + t + ", location = " + x[t]);
			    }
				
				o.close();        
		     } 
		     else {
			    writeln("No solution");
			    var o = new IloOplOutputFile("res.txt");
			    o.writeln("No Solution Found yet");
			    o.close();
			}
			
            opl.end();
            cp.end();
		}  		
    }
    
    if(runR2)
    {
        var source = new IloOplModelSource("cp_model.mod");
        var def = new IloOplModelDefinition(source);
        var cp = new IloCP();
		var f=cp.factory;
		
        for(var datFile in thisOplModel.datFiles_R2)
        {
          	var cp = new IloCP();
			var f=cp.factory;
          	
            var opl = new IloOplModel(def,cp);

            var data2= new IloOplDataSource("results/"+datFile);
            writeln("results/"+datFile+"_res"+".txt");
            opl.addDataSource(data2);
            opl.generate();
       
			
			
	        
	        if(opl.C==1)
	        {
		        var phase1 = f.searchPhase(opl.tasks,f.selectSmallest(f.domainMin()),f.selectSmallest(f.value()));
				var phase2 = f.searchPhase(opl.wtasks,f.selectSmallest(f.domainMin()),f.selectSmallest(f.value()));
				var phase3 = f.searchPhase(opl.Xr,f.selectSmallest(f.domainMin()),f.selectSmallest(f.value()));
				cp.setSearchPhases(phase1,phase2,phase3);
				cp.param.searchtype="IterativeDiving";
  			}
  			if(opl.C==2)
	        {
			    var phase1 = f.searchPhase(opl.tasks,f.selectSmallest(f.domainMin()),f.selectSmallest(f.value()));
				var phase2 = f.searchPhase(opl.wtasks,f.selectSmallest(f.domainMin()),f.selectSmallest(f.value()));
				var phase3 = f.searchPhase(opl.Xr,f.selectSmallest(f.domainMin()),f.selectSmallest(f.value()));
				cp.setSearchPhases(phase1,phase2,phase3);
				cp.param.searchtype="Restart";
  			}		
  			if(opl.C>2)
	        {
				var phase1 = f.searchPhase(opl.tasks,f.selectSmallest(f.successRate()),f.selectSmallest(f.value()));
				var phase2 = f.searchPhase(opl.wtasks,f.selectSmallest(f.successRate()),f.selectSmallest(f.value()));
				var phase3 = f.searchPhase(opl.Xr,f.selectSmallest(f.successRate()),f.selectSmallest(f.value()));
				cp.setSearchPhases(phase1,phase2,phase3);
				cp.param.searchtype="IterativeDiving";
  			}		
  			cp.param.TimeLimit = 3600;
  			
            // Solve the model
            if (cp.solve()) {
                opl.postProcess();
    			var o=new IloOplOutputFile("results/"+datFile+"_res"+".txt");
                
                o.writeln("TimeToSolve= " + cp.info.TotalTime);
			    o.writeln("Objective= " + cp.getObjValue());
			    o.writeln("tf= " + opl.tfinal);
			    o.writeln("RelativeGap= " + cp.info.Gap);
			    o.writeln("LowerBound= " + cp.getObjBound());
			
			    // Print decisions
			    var x = opl.Xr;
			    
			    for (var t in opl.T_1) {
			        o.writeln("Iteration t = " + t + ", location = " + x[t]);
			    }
			    
			    o.close();        
			    
            } else {
			    writeln("No solution");
			    var o = new IloOplOutputFile("results/"+datFile+"_res.txt");
			    o.writeln("No Solution Found yet");
			    o.close();
			}
           opl.end();
           cp.end();
            
        }  
    }
    
    if(runR2E)
    {
        var source = new IloOplModelSource("cp_model.mod");
        var def = new IloOplModelDefinition(source);
		var cp = new IloCP();
		var f=cp.factory;
        for(var datFile in thisOplModel.datFiles_R2E)
        {
          	var cp = new IloCP();
			var f=cp.factory;
          	
            var opl = new IloOplModel(def,cp);

            var data2= new IloOplDataSource("results/"+datFile);
            
            opl.addDataSource(data2);
            opl.generate();
           
	        if(opl.C==1)
	        {
		        var phase1 = f.searchPhase(opl.tasks, f.selectSmallest(f.domainMin()), f.selectSmallest(f.value()));
				var phase2 = f.searchPhase(opl.wtasks,f.selectSmallest(f.domainMin()),f.selectSmallest(f.value()));
				var phase3 = f.searchPhase(opl.Xr,f.selectSmallest(f.domainMin()),f.selectSmallest(f.value()));
				cp.setSearchPhases(phase1,phase2,phase3);
				cp.param.searchtype="IterativeDiving";
  			}
  			if(opl.C==2)
	        {
			    var phase1 = f.searchPhase(opl.tasks,f.selectSmallest(f.domainMin()),f.selectSmallest(f.value()));
				var phase2 = f.searchPhase(opl.wtasks,f.selectSmallest(f.domainMin()),f.selectSmallest(f.value()));
				var phase3 = f.searchPhase(opl.Xr,f.selectSmallest(f.domainMin()),f.selectSmallest(f.value()));
				cp.setSearchPhases(phase1,phase2,phase3);
				cp.param.searchtype="Restart";
  			}		
  			if(opl.C>2)
	        {
				var phase1 = f.searchPhase(opl.tasks,f.selectSmallest(f.successRate()),f.selectSmallest(f.value()));
				var phase2 = f.searchPhase(opl.wtasks,f.selectSmallest(f.successRate()),f.selectSmallest(f.value()));
				var phase3 = f.searchPhase(opl.Xr,f.selectSmallest(f.successRate()),f.selectSmallest(f.value()));
				cp.setSearchPhases(phase1,phase2,phase3);
				cp.param.searchtype="IterativeDiving";
  			}	
  			cp.param.TimeLimit = 3000;		

            // Solve the model
            if (cp.solve()) {
                opl.postProcess();
    			var o=new IloOplOutputFile("results/"+datFile+"_res"+".txt");
                writeln("results/"+datFile+"_res"+".txt");
                o.writeln("TimeToSolve= " + cp.info.TotalTime);
			    o.writeln("Objective= " + cp.getObjValue());
			    o.writeln("tf= " + opl.tfinal);
			    o.writeln("RelativeGap= " + cp.info.Gap);
			    o.writeln("LowerBound= " + cp.getObjBound());
			
			    // Print decisions
			    var x = opl.Xr;
			    for (var t in opl.T_1) {
			        o.writeln("Iteration t = " + t + ", location = " + x[t]);
			    }
			    o.close();        
			    
            } else {
			    writeln("No solution");
			    var o = new IloOplOutputFile("res.txt");
			    o.writeln("No Solution Found yet");
			    o.close();
			}
            opl.end();
            cp.end();
            
        }  
    }
    
    if(runR2M3)
    {
        var source = new IloOplModelSource("cp_model.mod");
        var def = new IloOplModelDefinition(source);
		var cp = new IloCP();
		var f=cp.factory;
		
        for(var datFile in thisOplModel.datFiles_R2M3)
        {
          	var cp = new IloCP();
			var f=cp.factory;
            var opl = new IloOplModel(def,cp);
			
            var data2= new IloOplDataSource("results/"+datFile);
            
            opl.addDataSource(data2);
            opl.generate();
	        
	       if(opl.C==1)
	        {
		        var phase1 = f.searchPhase(opl.tasks,f.selectSmallest(f.domainMin()),f.selectSmallest(f.value()));
				var phase2 = f.searchPhase(opl.wtasks,f.selectSmallest(f.domainMin()),f.selectSmallest(f.value()));
				var phase3 = f.searchPhase(opl.Xr,f.selectSmallest(f.domainMin()),f.selectSmallest(f.value()));
				cp.setSearchPhases(phase1,phase2,phase3);
				cp.param.searchtype="IterativeDiving";
  			}
  			if(opl.C==2)
	        {
			    var phase1 = f.searchPhase(opl.tasks,f.selectSmallest(f.domainMin()),f.selectSmallest(f.value()));
				var phase2 = f.searchPhase(opl.wtasks,f.selectSmallest(f.domainMin()),f.selectSmallest(f.value()));
				var phase3 = f.searchPhase(opl.Xr,f.selectSmallest(f.domainMin()),f.selectSmallest(f.value()));
				cp.setSearchPhases(phase1,phase2,phase3);
				cp.param.searchtype="Restart";
  			}		
  			if(opl.C>2)
	        {
				var phase1 = f.searchPhase(opl.tasks,f.selectSmallest(f.successRate()),f.selectSmallest(f.value()));
				var phase2 = f.searchPhase(opl.wtasks,f.selectSmallest(f.successRate()),f.selectSmallest(f.value()));
				var phase3 = f.searchPhase(opl.Xr,f.selectSmallest(f.successRate()),f.selectSmallest(f.value()));
				cp.setSearchPhases(phase1,phase2,phase3);
				cp.param.searchtype="IterativeDiving";
  			}			
			cp.param.TimeLimit = 3600;	

            if (cp.solve()) {
                opl.postProcess();
    			var o=new IloOplOutputFile("results/"+datFile+"_res"+".txt");
                writeln("results/"+datFile+"_res"+".txt");
                o.writeln("TimeToSolve= " + cp.info.TotalTime);
			    o.writeln("Objective= " + cp.getObjValue());
			    o.writeln("tf= " + opl.tfinal);
			    o.writeln("RelativeGap= " + cp.info.Gap);
			    o.writeln("LowerBound= " + cp.getObjBound());
			

			    var x = opl.Xr;
			    for (var t in opl.T_1) {
			        o.writeln("Iteration t = " + t + ", location = " + x[t]);
			    }
			    o.close();    
			        
            } else {
			    writeln("No solution");
			    var o = new IloOplOutputFile("res.txt");
			    o.writeln("No Solution Found yet");
			    o.close();
			}
            opl.end();
            cp.end();
           
        }  
    }
    
    if(runR3)
    {
        var source = new IloOplModelSource("cp_model.mod");
        var def = new IloOplModelDefinition(source);
		
        for(var datFile in thisOplModel.datFiles_R3)
        {
          	var cp = new IloCP();
			var f=cp.factory;
            var opl = new IloOplModel(def,cp);

            var data2= new IloOplDataSource("results/"+datFile);
            
            opl.addDataSource(data2);
            opl.generate();

	        if(opl.C==1)
	        {
		        var phase1 = f.searchPhase(opl.tasks,f.selectSmallest(f.domainMin()),f.selectSmallest(f.value()));
				var phase2 = f.searchPhase(opl.wtasks,f.selectSmallest(f.domainMin()),f.selectSmallest(f.value()));
				var phase3 = f.searchPhase(opl.Xr,f.selectSmallest(f.domainMin()),f.selectSmallest(f.value()));
				cp.setSearchPhases(phase1,phase2,phase3);
				cp.param.searchtype="IterativeDiving";
  			}
  			if(opl.C==2)
	        {
			    var phase1 = f.searchPhase(opl.tasks,f.selectSmallest(f.domainMin()),f.selectSmallest(f.value()));
				var phase2 = f.searchPhase(opl.wtasks,f.selectSmallest(f.domainMin()),f.selectSmallest(f.value()));
				var phase3 = f.searchPhase(opl.Xr,f.selectSmallest(f.domainMin()),f.selectSmallest(f.value()));
				cp.setSearchPhases(phase1,phase2,phase3);
				cp.param.searchtype="Restart";
  			}		
  			if(opl.C>2)
	        {
				var phase1 = f.searchPhase(opl.tasks,f.selectSmallest(f.successRate()),f.selectSmallest(f.value()));
				var phase2 = f.searchPhase(opl.wtasks,f.selectSmallest(f.successRate()),f.selectSmallest(f.value()));
				var phase3 = f.searchPhase(opl.Xr,f.selectSmallest(f.successRate()),f.selectSmallest(f.value()));
				cp.setSearchPhases(phase1,phase2,phase3);
				cp.param.searchtype="IterativeDiving";
  			}			
			cp.param.TimeLimit = 120;	
            // Solve the model
            if (cp.solve()) {
                opl.postProcess();
    			var o=new IloOplOutputFile("results/"+datFile+"_res"+".txt");
                writeln("results/"+datFile+"_res"+".txt");
                o.writeln("TimeToSolve= " + cp.info.TotalTime);
			    o.writeln("Objective= " + cp.getObjValue());
			    o.writeln("tf= " + opl.tfinal);
			    o.writeln("RelativeGap= " + cp.info.Gap);
			    o.writeln("LowerBound= " + cp.getObjBound());
			
			    // Print decisions
			    var x = opl.Xr;
			    for (var t in opl.T_1) {
			        o.writeln("Iteration t = " + t + ", location = " + x[t]);
			    }
			    o.close();        
            } else {
			    writeln("No solution");
			    var o = new IloOplOutputFile("res.txt");
			    o.writeln("No Solution Found yet");
			    o.close();
			}
            opl.end();
            cp.end();
           
        }  
    }
    
    if(runR3E)
    {
        var source = new IloOplModelSource("cp_model.mod");
        var def = new IloOplModelDefinition(source);
        var cp = new IloCP();
        var f = cp.factory;
        for(var datFile in thisOplModel.datFiles_R3E)
        {
          	//var cplex = new IloCplex();
          	var cp = new IloCP();
        	var f = cp.factory;
          	
            var opl = new IloOplModel(def,cp);

            var data2= new IloOplDataSource("results/"+datFile);
            
            opl.addDataSource(data2);
            opl.generate();

	        if(opl.C==1)
	        {
		        var phase1 = f.searchPhase(opl.tasks,f.selectSmallest(f.domainMin()),f.selectSmallest(f.value()));
				var phase2 = f.searchPhase(opl.wtasks,f.selectSmallest(f.domainMin()),f.selectSmallest(f.value()));
				var phase3 = f.searchPhase(opl.Xr,f.selectSmallest(f.domainMin()),f.selectSmallest(f.value()));
				cp.setSearchPhases(phase1,phase2,phase3);
				cp.param.searchtype="IterativeDiving";
  			}
  			if(opl.C==2)
	        {
			    var phase1 = f.searchPhase(opl.tasks,f.selectSmallest(f.domainMin()),f.selectSmallest(f.value()));
				var phase2 = f.searchPhase(opl.wtasks,f.selectSmallest(f.domainMin()),f.selectSmallest(f.value()));
				var phase3 = f.searchPhase(opl.Xr,f.selectSmallest(f.domainMin()),f.selectSmallest(f.value()));
				cp.setSearchPhases(phase1,phase2,phase3);
				cp.param.searchtype="Restart";
  			}		
  			if(opl.C>2)
	        {
				var phase1 = f.searchPhase(opl.tasks,f.selectSmallest(f.successRate()),f.selectSmallest(f.value()));
				var phase2 = f.searchPhase(opl.wtasks,f.selectSmallest(f.successRate()),f.selectSmallest(f.value()));
				var phase3 = f.searchPhase(opl.Xr,f.selectSmallest(f.successRate()),f.selectSmallest(f.value()));
				cp.setSearchPhases(phase1,phase2,phase3);
				cp.param.searchtype="IterativeDiving";
  			}			
			cp.param.TimeLimit = 1800;	
            // Solve the model
            if (cp.solve()) {
                opl.postProcess();
    			var o=new IloOplOutputFile("results/"+datFile+"_res"+".txt");
                writeln("results/"+datFile+"_res"+".txt");
                o.writeln("TimeToSolve= " + cp.info.TotalTime);
			    o.writeln("Objective= " + cp.getObjValue());
			    o.writeln("tf= " + opl.tfinal);
			    o.writeln("RelativeGap= " + cp.info.Gap);
			    o.writeln("LowerBound= " + cp.getObjBound());
			
			    // Print decisions
			    var x = opl.Xr;
			    for (var t in opl.T_1) {
			        o.writeln("Iteration t = " + t + ", location = " + x[t]);
			    }
			    o.close();        
            } else {
			    writeln("No solution");
			    var o = new IloOplOutputFile("res.txt");
			    o.writeln("No Solution Found yet");
			    o.close();
			}
            opl.end();
            cp.end();
            
        }  
    }
}