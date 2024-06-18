# ratf_optimizer

This repository contains the project files for developing optimization solutions based on Mixed Integer Programming (MIP) and Constraint Programming (CP) to address task allocation challenges faced by autonomous robots in a factory setting. The project is inspired by the [RobotAtFactory 4.0](https://github.com/P33a/RobotAtFactory) Competition, which simulates real-world scenarios involving warehouse management and object transportation within a factory environment.

## Prequesites

* IBM ILOG CPLEX Studio: https://www.ibm.com/products/ilog-cplex-optimization-studio 
* Python 3 for scripts

## Usage

1. Import the desired programming language to CPLEX studio using: `File > Import > Existing OPL Projects` and select either ``cp`` folder for Constraint Programming or ``mip`` folder for Mixed Integer Programming.
2. Run one of the existing configurations:
    * *basic_testing*: runs the instance defined in ``model.dat`` file
    * *instances_run*: runs all the instances defined in `main.dat` file
    * *gird_search*: runs the instance defined in `grid_search.dat` with all parameters combinations

Files with data for all the competition instances can be in the `results` folder of each language. When running the *instances_run* configuration a new file is created containing the statistical data of each instance such as: Time to solve, objective function result, gap, lower bound, solution, ...

In the ``scripts`` folder two python scripts were included:
* Instance generator: to generate the .dat files for other instances 
* Data analyszer: to generate a CSV cointaining the statistical data for a result set

## Authors

* João G. Martins: [joao.g.martins@inesctec.pt](mailto:joao.g.martins@inesctec.pt)
* José Pedro Carvalho: [jpcarvalho@fe.up.pt](mailto:jpcarvalho@fe.up.pt)
* Maria S. Lopes: [maris.s.lopes@inesctec.pt](mailto:maris.s.lopes@inesctec.pt)