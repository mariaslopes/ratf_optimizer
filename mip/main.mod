{string} datFiles_R1=...;
{string} datFiles_R2=...;
{string} datFiles_R3=...;
	
main {
    var runR1 = 1;
    var runR2 = 0;
    var runR3 = 0;
    
    if(runR1)
    {
        var source1 = new IloOplModelSource("model1.mod");
        var def = new IloOplModelDefinition(source1);

        for(var datFile in thisOplModel.datFiles_R1)
        {
          	var cplex = new IloCplex();
            var opl = new IloOplModel(def,cplex);

            var data2= new IloOplDataSource("results/"+ datFile);
            
            opl.addDataSource(data2);
            opl.generate();
           

            if (cplex.solve()) {  
                opl.postProcess();
                var o=new IloOplOutputFile("results/"+ datFile+"_res"+".txt");
                o.writeln("TimeToSolve= " + cplex.getSolvedTime()); 
                o.writeln("Objective= " + cplex.getObjValue());
                o.writeln("NumberOfIterations= " + cplex.getNiterations());
                o.writeln("NumberOfConstrains= " + cplex.getNrows());
                o.writeln("NumberOfVariables= " + cplex.getNcols());
                o.writeln("tf= " + opl.tfinal);
                o.writeln("RelativeGap= " + cplex.getMIPRelativeGap());
                o.writeln("LowerBound= " + cplex.getBestObjValue());
                
                
                //print robot decisions
                var x = opl.x;
                
                for (var t in opl.T) {
                    for (var i in opl.L) {
                        for (var j in opl.L) {
                            if (opl.x[t][i][j] == 1) {
                                o.writeln("Iteration t = " + t + ", location = " + j);
                            }
                        }
                    }
                }
                o.close();
                writeln("Model " + datFile + "OBJ = " + cplex.getObjValue());
            } else {
                writeln("No solution");
                var o=new IloOplOutputFile(datFile+"_res"+".txt");
                o.writeln("No Solution Found yet");
                o.close();
            }
            opl.end();
        }  
    }

    if(runR2)
    {
        var source2 = new IloOplModelSource("model2.mod");
        var cplex = new IloCplex();
        var def = new IloOplModelDefinition(source2);

        for(var datFile in thisOplModel.datFiles_R2)
        {
            var opl = new IloOplModel(def,cplex);

            var data2= new IloOplDataSource(datFile);
            
            opl.addDataSource(data2);
            opl.generate();

            if (cplex.solve()) {  
                opl.postProcess();
                var o=new IloOplOutputFile(datFile+"_res"+".txt");
                o.writeln("TimeToSolve= " + cplex.getSolvedTime()); 
                o.writeln("Objective= " + cplex.getObjValue());
                o.writeln("NumberOfIterations= " + cplex.getNiterations());
                o.writeln("NumberOfConstrains= " + cplex.getNrows());
                o.writeln("NumberOfVariables= " + cplex.getNcols());
                o.writeln("tf= " + opl.tfinal);
                o.writeln("RelativeGap= " + cplex.getMIPRelativeGap());
                o.writeln("LowerBound= " + cplex.getBestObjValue());
                
                //print robot decisions
                var x = opl.x;
                
                for (var t in opl.T) {
                    for (var i in opl.L) {
                        for (var j in opl.L) {
                            if (opl.x[t][i][j] == 1) {
                                o.writeln("Iteration t = " + t + ", location = " + j);
                            }
                        }
                    }
                }
                o.close();
                writeln("Model " + datFile + "OBJ = " + cplex.getObjValue());
            } else {
                writeln("No solution");
                var o=new IloOplOutputFile(datFile+"_res"+".txt");
                o.writeln("No Solution Found yet");
                o.close();
            }
            opl.end();
        }  
    }

    if(runR3){
        var source3 = new IloOplModelSource("model3.mod");
        var cplex = new IloCplex();
        var def = new IloOplModelDefinition(source3);

        for(var datFile in thisOplModel.datFiles_R3)
        {
            var opl = new IloOplModel(def,cplex);

            var data2= new IloOplDataSource(datFile);
            
            opl.addDataSource(data2);
            opl.generate();

            if (cplex.solve()) {  
                opl.postProcess();
                var o=new IloOplOutputFile(datFile+"_res"+".txt");
                o.writeln("TimeToSolve= " + cplex.getSolvedTime()); 
                o.writeln("Objective= " + cplex.getObjValue());
                o.writeln("NumberOfIterations= " + cplex.getNiterations());
                o.writeln("NumberOfConstrains= " + cplex.getNrows());
                o.writeln("NumberOfVariables= " + cplex.getNcols());
                o.writeln("tf= " + opl.tfinal);
                o.writeln("RelativeGap= " + cplex.getMIPRelativeGap());
                o.writeln("LowerBound= " + cplex.getBestObjValue());
                
                //print robot decisions
                var x = opl.x;
                
                for (var t in opl.T) {
                    for (var i in opl.L) {
                        for (var j in opl.L) {
                            if (opl.x[t][i][j] == 1) {
                                o.writeln("Iteration t = " + t + ", location = " + j);
                            }
                        }
                    }
                }
                o.close();
                writeln("Model " + datFile + "OBJ = " + cplex.getObjValue());
            } else {
                writeln("No solution");
                var o=new IloOplOutputFile(datFile+"_res"+".txt");
                o.writeln("No Solution Found yet");
                o.close();
            }
            opl.end();
        }  
    }

}