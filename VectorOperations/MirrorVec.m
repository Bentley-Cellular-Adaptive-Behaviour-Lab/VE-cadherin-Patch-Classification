% Functoin which takes a vector, reflects it at its near end
% and returns it with its mirror image as one new vector

function[MirroredVec]=MirrorVec(Vect) 

MirroredVec=[Vect(length(Vect):-1:2) Vect];