# ratf_optimizer

This repository contains the project files for developing optimization solutions based on Mixed Integer Programming (MIP) and Constraint Programming (CP) to address task allocation challenges faced by autonomous robots in a factory setting. The project is inspired by the [RobotAtFactory 4.0](https://github.com/P33a/RobotAtFactory) Competition, which simulates real-world scenarios involving warehouse management and object transportation within a factory environment.

## Prerequisites

* [IBM ILOG CPLEX Studio](https://www.ibm.com/products/ilog-cplex-optimization-studio)
* Python 3 (for scripts)

## Usage

1. Import project in CPLEX Studio using: `File > Import > Existing OPL Projects` and select either the `cp` folder for Constraint Programming or the `mip` folder for Mixed Integer Programming.
2. Run one of the existing configurations:
    * **basic_testing**: Runs the instance defined in the `model.dat` file.
    * **instances_run**: Runs all the instances defined in the `main.dat` file.
    * **grid_search**: Runs the instance defined in the `grid_search.dat` file with all parameter combinations.

Files with data for all the competition instances can be found in the `results` folder of each language. When running the *instances_run* configuration, a new file is created containing the statistical data of each instance, such as: Time to solve, objective function result, gap, lower bound, solution, etc.

In the `scripts` folder, two Python scripts are included:
* **Instance generator**: Generates the `.dat` files for other instances.
* **Data analyzer**: Generates a CSV containing the statistical data for a result set.

## Authors

* João G. Martins: [joao.g.martins@inesctec.pt](mailto:joao.g.martins@inesctec.pt)
* José Pedro Carvalho: [jpcarvalho@fe.up.pt](mailto:jpcarvalho@fe.up.pt)
* Maria S. Lopes: [maris.s.lopes@inesctec.pt](mailto:maris.s.lopes@inesctec.pt)