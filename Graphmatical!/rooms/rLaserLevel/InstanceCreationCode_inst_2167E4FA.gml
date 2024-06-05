// Set material
material = GraphType.LASER;

// Equations
equations[0].set("-2-0.5x");
array_push(equations, new Equation(self));
equations[1].set("2-0.5x");

// Set size
setAxesSize(6, 8);

// Regraph
regraphEquations();