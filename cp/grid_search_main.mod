// This is the main file that calls the CP model and data file, and executes the model

// Include the CP model file
include "cp_model.mod";

main {
	var source1 = new IloOplModelSource("cp_model.mod");
    var def = new IloOplModelDefinition(source1);   
  	var cp = new IloCP();
    var opl = new IloOplModel(def,cp);
    var data2= new IloOplDataSource("grid_search.dat");
    opl.addDataSource(data2);
    opl.generate();
    var f=cp.factory;
    var var_selectors = new Array(
        f.selectSmallest(f.domainSize()),
        f.selectSmallest(f.domainMin()),
        f.selectSmallest(f.domainMax()),
        f.selectSmallest(f.regretOnMin()),
        f.selectSmallest(f.regretOnMax()),
        f.selectSmallest(f.successRate()),
        f.selectSmallest(f.impact()),
        f.selectSmallest(f.localImpact()),
        f.selectSmallest(f.ImpactOfLastBranch()),
        f.selectSmallest(f.domainSize()),
        f.selectLargest(f.domainMin()),
        f.selectLargest(f.domainMax()),
        f.selectLargest(f.regretOnMin()),
        f.selectLargest(f.regretOnMax()),
        f.selectLargest(f.successRate()),
        f.selectLargest(f.impact()),
        f.selectLargest(f.localImpact()),
        f.selectLargest(f.ImpactOfLastBranch()),
        f.selectRandomVar()); 
    var var_selectors_string = new Array(
    	"f.selectSmallest(f.domainSize())",
        "f.selectSmallest(f.domainMin())",
        "f.selectSmallest(f.domainMax())",
        "f.selectSmallest(f.regretOnMin())",
        "f.selectSmallest(f.regretOnMax())",
        "f.selectSmallest(f.successRate())",
        "f.selectSmallest(f.impact())",
        "f.selectSmallest(f.localImpact())",
        "f.selectSmallest(f.ImpactOfLastBranch())",
        "f.selectSmallest(f.domainSize())",
        "f.selectLargest(f.domainMin())",
        "f.selectLargest(f.domainMax())",
        "f.selectLargest(f.regretOnMin())",
        "f.selectLargest(f.regretOnMax())",
        "f.selectLargest(f.successRate())",
        "f.selectLargest(f.impact())",
        "f.selectLargest(f.localImpact())",
        "f.selectLargest(f.ImpactOfLastBranch())",
        "f.selectRandomVar()");
    var value_selectors = new Array(
        f.selectSmallest(f.value()),
        f.selectSmallest(f.valueImpact()),
        f.selectSmallest(f.valueSuccessRate()),
        f.selectLargest(f.value()),
        f.selectLargest(f.valueImpact()),
        f.selectLargest(f.valueSuccessRate()),
        f.selectRandomValue());
   var value_selectors_string = new Array(
        "f.selectSmallest(f.value())",
        "f.selectSmallest(f.valueImpact())",
        "f.selectSmallest(f.valueSuccessRate())",
        "f.selectLargest(f.value())",
        "f.selectLargest(f.valueImpact())",
        "f.selectLargest(f.valueSuccessRate())",
        "f.selectRandomValue()");
    var search_types = new Array("IterativeDiving","Restart");
    
	for(var type=0;type<search_types.length; type++)
		{
			for(var var_=0; var_ <var_selectors.length; var_++  )
			{
				for(var value=0; value <value_selectors.length; value++ )
				{
				   var opl = new IloOplModel(def,cp);
				   opl.addDataSource(data2);
				   opl.generate();
				   var phase1 = f.searchPhase(opl.tasks,var_selectors[var_],value_selectors[value]);
				   var phase2 = f.searchPhase(opl.wtasks,var_selectors[var_],value_selectors[value]);
				   var phase3 = f.searchPhase(opl.Xr,var_selectors[var_],value_selectors[value]);
				   cp.setSearchPhases(phase1,phase2,phase3);
				   cp.param.searchtype=search_types[type];
				   cp.param.TimeLimit =1200;
				   if (cp.solve()) 
				   {
				   	opl.postProcess();
				    var o = new IloOplOutputFile("grid_search/C=1/"+search_types[type]+"_"+
				    							var_selectors_string[var_]+"_"+value_selectors_string[value]+".txt");				    
				    o.writeln("TimeToSolve= " + cp.info.SolveTime);
				    o.writeln("Objective= " + cp.getObjValue());
				    o.writeln("tf= " + opl.tfinal);
				    o.writeln("RelativeGap= " + cp.info.Gap);
				    o.writeln("LowerBound= " + cp.getObjBound());
				    // Print decisions
				    var x = opl.Xr;
				    for (var t in opl.T_1)  o.writeln("Iteration t = " + t + ", location = " + x[t]);
				    o.close();
				   } 
				   cp.clearModel();
				   cp.clearStartingPoint();
				   opl.end();
				   			  
				}		
			}
 		}
 } 							
	

              
    
      