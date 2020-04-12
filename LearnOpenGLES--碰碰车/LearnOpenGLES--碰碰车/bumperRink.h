/*
created with obj2opengl.pl

source file    : ./bumperRink.obj
vertices       : 40
faces          : 60
normals        : 13
texture coords : 0


*/

unsigned int bumperRinkNumVerts = 180;

GLfloat bumperRinkVerts [] = {
  // f 1//1 2//1 3//1
  -4.95, 0, -4.999997,
  -4.95, 0, 4.999997,
  -5.05, 0, 4.999997,
  // f 1//1 3//1 4//1
  -4.95, 0, -4.999997,
  -5.05, 0, 4.999997,
  -5.05, 0, -5,
  // f 5//2 8//2 7//2
  -4.95, 0.5, -4.999995,
  -5.05, 0.5, -4.999998,
  -5.05, 0.5, 4.999996,
  // f 5//2 7//2 6//2
  -4.95, 0.5, -4.999995,
  -5.05, 0.5, 4.999996,
  -4.95, 0.5, 5,
  // f 1//3 5//3 6//3
  -4.95, 0, -4.999997,
  -4.95, 0.5, -4.999995,
  -4.95, 0.5, 5,
  // f 1//3 6//3 2//3
  -4.95, 0, -4.999997,
  -4.95, 0.5, 5,
  -4.95, 0, 4.999997,
  // f 2//4 6//4 7//4
  -4.95, 0, 4.999997,
  -4.95, 0.5, 5,
  -5.05, 0.5, 4.999996,
  // f 2//4 7//4 3//4
  -4.95, 0, 4.999997,
  -5.05, 0.5, 4.999996,
  -5.05, 0, 4.999997,
  // f 3//5 7//5 8//5
  -5.05, 0, 4.999997,
  -5.05, 0.5, 4.999996,
  -5.05, 0.5, -4.999998,
  // f 3//5 8//5 4//5
  -5.05, 0, 4.999997,
  -5.05, 0.5, -4.999998,
  -5.05, 0, -5,
  // f 5//6 1//6 4//6
  -4.95, 0.5, -4.999995,
  -4.95, 0, -4.999997,
  -5.05, 0, -5,
  // f 5//6 4//6 8//6
  -4.95, 0.5, -4.999995,
  -5.05, 0, -5,
  -5.05, 0.5, -4.999998,
  // f 9//1 10//1 11//1
  5.05, 0, -4.999997,
  5.05, 0, 4.999997,
  4.95, 0, 4.999997,
  // f 9//1 11//1 12//1
  5.05, 0, -4.999997,
  4.95, 0, 4.999997,
  4.95, 0, -5,
  // f 13//2 16//2 15//2
  5.05, 0.5, -4.999995,
  4.95, 0.5, -4.999998,
  4.95, 0.5, 4.999996,
  // f 13//2 15//2 14//2
  5.05, 0.5, -4.999995,
  4.95, 0.5, 4.999996,
  5.05, 0.5, 5,
  // f 9//3 13//3 14//3
  5.05, 0, -4.999997,
  5.05, 0.5, -4.999995,
  5.05, 0.5, 5,
  // f 9//3 14//3 10//3
  5.05, 0, -4.999997,
  5.05, 0.5, 5,
  5.05, 0, 4.999997,
  // f 10//4 14//4 15//4
  5.05, 0, 4.999997,
  5.05, 0.5, 5,
  4.95, 0.5, 4.999996,
  // f 10//4 15//4 11//4
  5.05, 0, 4.999997,
  4.95, 0.5, 4.999996,
  4.95, 0, 4.999997,
  // f 11//5 15//5 16//5
  4.95, 0, 4.999997,
  4.95, 0.5, 4.999996,
  4.95, 0.5, -4.999998,
  // f 11//5 16//5 12//5
  4.95, 0, 4.999997,
  4.95, 0.5, -4.999998,
  4.95, 0, -5,
  // f 13//6 9//6 12//6
  5.05, 0.5, -4.999995,
  5.05, 0, -4.999997,
  4.95, 0, -5,
  // f 13//6 12//6 16//6
  5.05, 0.5, -4.999995,
  4.95, 0, -5,
  4.95, 0.5, -4.999998,
  // f 17//1 18//1 19//1
  4.999997, 0, 4.95,
  4.999997, 0, 5.05,
  -4.999998, 0, 5.05,
  // f 17//1 19//1 20//1
  4.999997, 0, 4.95,
  -4.999998, 0, 5.05,
  -4.999996, 0, 4.95,
  // f 21//2 24//2 23//2
  5, 0.5, 4.95,
  -4.999997, 0.5, 4.95,
  -5, 0.5, 5.05,
  // f 21//2 23//2 22//2
  5, 0.5, 4.95,
  -5, 0.5, 5.05,
  4.999994, 0.5, 5.05,
  // f 17//7 21//7 22//7
  4.999997, 0, 4.95,
  5, 0.5, 4.95,
  4.999994, 0.5, 5.05,
  // f 17//7 22//7 18//7
  4.999997, 0, 4.95,
  4.999994, 0.5, 5.05,
  4.999997, 0, 5.05,
  // f 18//8 22//8 23//8
  4.999997, 0, 5.05,
  4.999994, 0.5, 5.05,
  -5, 0.5, 5.05,
  // f 18//8 23//8 19//8
  4.999997, 0, 5.05,
  -5, 0.5, 5.05,
  -4.999998, 0, 5.05,
  // f 19//9 23//9 24//9
  -4.999998, 0, 5.05,
  -5, 0.5, 5.05,
  -4.999997, 0.5, 4.95,
  // f 19//9 24//9 20//9
  -4.999998, 0, 5.05,
  -4.999997, 0.5, 4.95,
  -4.999996, 0, 4.95,
  // f 21//10 17//10 20//10
  5, 0.5, 4.95,
  4.999997, 0, 4.95,
  -4.999996, 0, 4.95,
  // f 21//10 20//10 24//10
  5, 0.5, 4.95,
  -4.999996, 0, 4.95,
  -4.999997, 0.5, 4.95,
  // f 25//1 26//1 27//1
  4.999997, 0, -5.05,
  4.999997, 0, -4.95,
  -4.999998, 0, -4.95,
  // f 25//1 27//1 28//1
  4.999997, 0, -5.05,
  -4.999998, 0, -4.95,
  -4.999996, 0, -5.05,
  // f 29//2 32//2 31//2
  5, 0.5, -5.05,
  -4.999997, 0.5, -5.05,
  -5, 0.5, -4.95,
  // f 29//2 31//2 30//2
  5, 0.5, -5.05,
  -5, 0.5, -4.95,
  4.999994, 0.5, -4.95,
  // f 25//7 29//7 30//7
  4.999997, 0, -5.05,
  5, 0.5, -5.05,
  4.999994, 0.5, -4.95,
  // f 25//7 30//7 26//7
  4.999997, 0, -5.05,
  4.999994, 0.5, -4.95,
  4.999997, 0, -4.95,
  // f 26//8 30//8 31//8
  4.999997, 0, -4.95,
  4.999994, 0.5, -4.95,
  -5, 0.5, -4.95,
  // f 26//8 31//8 27//8
  4.999997, 0, -4.95,
  -5, 0.5, -4.95,
  -4.999998, 0, -4.95,
  // f 27//9 31//9 32//9
  -4.999998, 0, -4.95,
  -5, 0.5, -4.95,
  -4.999997, 0.5, -5.05,
  // f 27//9 32//9 28//9
  -4.999998, 0, -4.95,
  -4.999997, 0.5, -5.05,
  -4.999996, 0, -5.05,
  // f 29//10 25//10 28//10
  5, 0.5, -5.05,
  4.999997, 0, -5.05,
  -4.999996, 0, -5.05,
  // f 29//10 28//10 32//10
  5, 0.5, -5.05,
  -4.999996, 0, -5.05,
  -4.999997, 0.5, -5.05,
  // f 33//1 34//1 35//1
  4.999997, -0.005, -4.999997,
  4.999997, -0.005, 4.999997,
  -4.999998, -0.005, 4.999997,
  // f 33//1 35//1 36//1
  4.999997, -0.005, -4.999997,
  -4.999998, -0.005, 4.999997,
  -4.999996, -0.005, -5,
  // f 37//2 40//2 39//2
  5, 0.005, -4.999995,
  -4.999997, 0.005, -4.999998,
  -5, 0.005, 4.999996,
  // f 37//2 39//2 38//2
  5, 0.005, -4.999995,
  -5, 0.005, 4.999996,
  4.999994, 0.005, 5,
  // f 33//3 37//3 38//3
  4.999997, -0.005, -4.999997,
  5, 0.005, -4.999995,
  4.999994, 0.005, 5,
  // f 33//3 38//3 34//3
  4.999997, -0.005, -4.999997,
  4.999994, 0.005, 5,
  4.999997, -0.005, 4.999997,
  // f 34//11 38//11 39//11
  4.999997, -0.005, 4.999997,
  4.999994, 0.005, 5,
  -5, 0.005, 4.999996,
  // f 34//11 39//11 35//11
  4.999997, -0.005, 4.999997,
  -5, 0.005, 4.999996,
  -4.999998, -0.005, 4.999997,
  // f 35//12 39//12 40//12
  -4.999998, -0.005, 4.999997,
  -5, 0.005, 4.999996,
  -4.999997, 0.005, -4.999998,
  // f 35//12 40//12 36//12
  -4.999998, -0.005, 4.999997,
  -4.999997, 0.005, -4.999998,
  -4.999996, -0.005, -5,
  // f 37//13 33//13 36//13
  5, 0.005, -4.999995,
  4.999997, -0.005, -4.999997,
  -4.999996, -0.005, -5,
  // f 37//13 36//13 40//13
  5, 0.005, -4.999995,
  -4.999996, -0.005, -5,
  -4.999997, 0.005, -4.999998,
};

GLfloat bumperRinkNormals [] = {
  // f 1//1 2//1 3//1
  0, -1, 0,
  0, -1, 0,
  0, -1, 0,
  // f 1//1 3//1 4//1
  0, -1, 0,
  0, -1, 0,
  0, -1, 0,
  // f 5//2 8//2 7//2
  0, 1, 0,
  0, 1, 0,
  0, 1, 0,
  // f 5//2 7//2 6//2
  0, 1, 0,
  0, 1, 0,
  0, 1, 0,
  // f 1//3 5//3 6//3
  1, 0, 0,
  1, 0, 0,
  1, 0, 0,
  // f 1//3 6//3 2//3
  1, 0, 0,
  1, 0, 0,
  1, 0, 0,
  // f 2//4 6//4 7//4
  -2.599999999116e-05, -1.99999999932e-06, 0.99999999966,
  -2.599999999116e-05, -1.99999999932e-06, 0.99999999966,
  -2.599999999116e-05, -1.99999999932e-06, 0.99999999966,
  // f 2//4 7//4 3//4
  -2.599999999116e-05, -1.99999999932e-06, 0.99999999966,
  -2.599999999116e-05, -1.99999999932e-06, 0.99999999966,
  -2.599999999116e-05, -1.99999999932e-06, 0.99999999966,
  // f 3//5 7//5 8//5
  -1, 0, 0,
  -1, 0, 0,
  -1, 0, 0,
  // f 3//5 8//5 4//5
  -1, 0, 0,
  -1, 0, 0,
  -1, 0, 0,
  // f 5//6 1//6 4//6
  2.5999999991004e-05, 3.999999998616e-06, -0.999999999654,
  2.5999999991004e-05, 3.999999998616e-06, -0.999999999654,
  2.5999999991004e-05, 3.999999998616e-06, -0.999999999654,
  // f 5//6 4//6 8//6
  2.5999999991004e-05, 3.999999998616e-06, -0.999999999654,
  2.5999999991004e-05, 3.999999998616e-06, -0.999999999654,
  2.5999999991004e-05, 3.999999998616e-06, -0.999999999654,
  // f 9//1 10//1 11//1
  0, -1, 0,
  0, -1, 0,
  0, -1, 0,
  // f 9//1 11//1 12//1
  0, -1, 0,
  0, -1, 0,
  0, -1, 0,
  // f 13//2 16//2 15//2
  0, 1, 0,
  0, 1, 0,
  0, 1, 0,
  // f 13//2 15//2 14//2
  0, 1, 0,
  0, 1, 0,
  0, 1, 0,
  // f 9//3 13//3 14//3
  1, 0, 0,
  1, 0, 0,
  1, 0, 0,
  // f 9//3 14//3 10//3
  1, 0, 0,
  1, 0, 0,
  1, 0, 0,
  // f 10//4 14//4 15//4
  -2.599999999116e-05, -1.99999999932e-06, 0.99999999966,
  -2.599999999116e-05, -1.99999999932e-06, 0.99999999966,
  -2.599999999116e-05, -1.99999999932e-06, 0.99999999966,
  // f 10//4 15//4 11//4
  -2.599999999116e-05, -1.99999999932e-06, 0.99999999966,
  -2.599999999116e-05, -1.99999999932e-06, 0.99999999966,
  -2.599999999116e-05, -1.99999999932e-06, 0.99999999966,
  // f 11//5 15//5 16//5
  -1, 0, 0,
  -1, 0, 0,
  -1, 0, 0,
  // f 11//5 16//5 12//5
  -1, 0, 0,
  -1, 0, 0,
  -1, 0, 0,
  // f 13//6 9//6 12//6
  2.5999999991004e-05, 3.999999998616e-06, -0.999999999654,
  2.5999999991004e-05, 3.999999998616e-06, -0.999999999654,
  2.5999999991004e-05, 3.999999998616e-06, -0.999999999654,
  // f 13//6 12//6 16//6
  2.5999999991004e-05, 3.999999998616e-06, -0.999999999654,
  2.5999999991004e-05, 3.999999998616e-06, -0.999999999654,
  2.5999999991004e-05, 3.999999998616e-06, -0.999999999654,
  // f 17//1 18//1 19//1
  0, -1, 0,
  0, -1, 0,
  0, -1, 0,
  // f 17//1 19//1 20//1
  0, -1, 0,
  0, -1, 0,
  0, -1, 0,
  // f 21//2 24//2 23//2
  0, 1, 0,
  0, 1, 0,
  0, 1, 0,
  // f 21//2 23//2 22//2
  0, 1, 0,
  0, 1, 0,
  0, 1, 0,
  // f 17//7 21//7 22//7
  0.9999999995795, 0, 2.89999999878055e-05,
  0.9999999995795, 0, 2.89999999878055e-05,
  0.9999999995795, 0, 2.89999999878055e-05,
  // f 17//7 22//7 18//7
  0.9999999995795, 0, 2.89999999878055e-05,
  0.9999999995795, 0, 2.89999999878055e-05,
  0.9999999995795, 0, 2.89999999878055e-05,
  // f 18//8 22//8 23//8
  -0, 0, 1,
  -0, 0, 1,
  -0, 0, 1,
  // f 18//8 23//8 19//8
  -0, 0, 1,
  -0, 0, 1,
  -0, 0, 1,
  // f 19//9 23//9 24//9
  -0.9999999997075, -2.9999999991225e-06, -2.399999999298e-05,
  -0.9999999997075, -2.9999999991225e-06, -2.399999999298e-05,
  -0.9999999997075, -2.9999999991225e-06, -2.399999999298e-05,
  // f 19//9 24//9 20//9
  -0.9999999997075, -2.9999999991225e-06, -2.399999999298e-05,
  -0.9999999997075, -2.9999999991225e-06, -2.399999999298e-05,
  -0.9999999997075, -2.9999999991225e-06, -2.399999999298e-05,
  // f 21//10 17//10 20//10
  0, 0, -1,
  0, 0, -1,
  0, 0, -1,
  // f 21//10 20//10 24//10
  0, 0, -1,
  0, 0, -1,
  0, 0, -1,
  // f 25//1 26//1 27//1
  0, -1, 0,
  0, -1, 0,
  0, -1, 0,
  // f 25//1 27//1 28//1
  0, -1, 0,
  0, -1, 0,
  0, -1, 0,
  // f 29//2 32//2 31//2
  0, 1, 0,
  0, 1, 0,
  0, 1, 0,
  // f 29//2 31//2 30//2
  0, 1, 0,
  0, 1, 0,
  0, 1, 0,
  // f 25//7 29//7 30//7
  0.9999999995795, 0, 2.89999999878055e-05,
  0.9999999995795, 0, 2.89999999878055e-05,
  0.9999999995795, 0, 2.89999999878055e-05,
  // f 25//7 30//7 26//7
  0.9999999995795, 0, 2.89999999878055e-05,
  0.9999999995795, 0, 2.89999999878055e-05,
  0.9999999995795, 0, 2.89999999878055e-05,
  // f 26//8 30//8 31//8
  -0, 0, 1,
  -0, 0, 1,
  -0, 0, 1,
  // f 26//8 31//8 27//8
  -0, 0, 1,
  -0, 0, 1,
  -0, 0, 1,
  // f 27//9 31//9 32//9
  -0.9999999997075, -2.9999999991225e-06, -2.399999999298e-05,
  -0.9999999997075, -2.9999999991225e-06, -2.399999999298e-05,
  -0.9999999997075, -2.9999999991225e-06, -2.399999999298e-05,
  // f 27//9 32//9 28//9
  -0.9999999997075, -2.9999999991225e-06, -2.399999999298e-05,
  -0.9999999997075, -2.9999999991225e-06, -2.399999999298e-05,
  -0.9999999997075, -2.9999999991225e-06, -2.399999999298e-05,
  // f 29//10 25//10 28//10
  0, 0, -1,
  0, 0, -1,
  0, 0, -1,
  // f 29//10 28//10 32//10
  0, 0, -1,
  0, 0, -1,
  0, 0, -1,
  // f 33//1 34//1 35//1
  0, -1, 0,
  0, -1, 0,
  0, -1, 0,
  // f 33//1 35//1 36//1
  0, -1, 0,
  0, -1, 0,
  0, -1, 0,
  // f 37//2 40//2 39//2
  0, 1, 0,
  0, 1, 0,
  0, 1, 0,
  // f 37//2 39//2 38//2
  0, 1, 0,
  0, 1, 0,
  0, 1, 0,
  // f 33//3 37//3 38//3
  1, 0, 0,
  1, 0, 0,
  1, 0, 0,
  // f 33//3 38//3 34//3
  1, 0, 0,
  1, 0, 0,
  1, 0, 0,
  // f 34//11 38//11 39//11
  -0, -0.000118999999157421, 0.9999999929195,
  -0, -0.000118999999157421, 0.9999999929195,
  -0, -0.000118999999157421, 0.9999999929195,
  // f 34//11 39//11 35//11
  -0, -0.000118999999157421, 0.9999999929195,
  -0, -0.000118999999157421, 0.9999999929195,
  -0, -0.000118999999157421, 0.9999999929195,
  // f 35//12 39//12 40//12
  -0.9999999897755, -0.000142999998537897, -0,
  -0.9999999897755, -0.000142999998537897, -0,
  -0.9999999897755, -0.000142999998537897, -0,
  // f 35//12 40//12 36//12
  -0.9999999897755, -0.000142999998537897, -0,
  -0.9999999897755, -0.000142999998537897, -0,
  -0.9999999897755, -0.000142999998537897, -0,
  // f 37//13 33//13 36//13
  0, 0.000214999995030813, -0.999999976887501,
  0, 0.000214999995030813, -0.999999976887501,
  0, 0.000214999995030813, -0.999999976887501,
  // f 37//13 36//13 40//13
  0, 0.000214999995030813, -0.999999976887501,
  0, 0.000214999995030813, -0.999999976887501,
  0, 0.000214999995030813, -0.999999976887501,
};

