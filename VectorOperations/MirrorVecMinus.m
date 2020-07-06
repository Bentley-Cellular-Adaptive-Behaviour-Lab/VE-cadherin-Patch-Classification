% Functoin which takes a vector, reflects it at its near end, makes the values negative
% and returns it with its mirror image as one new vector

function[MirroredVec]=MirrorVecMinus(Vect) 

MirroredVec=[-1*(Vect(length(Vect):-1:2)) Vect];