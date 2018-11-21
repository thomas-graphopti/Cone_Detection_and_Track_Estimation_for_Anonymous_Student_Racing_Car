function result=dist_line_point(Q1,Q2,P1)
%function: return the euclidean distance between line 
%          segment(Q1,Q2 as end point) and point P1
%Q1,Q2,P1 = [x y] in 2D coordinate
%By T.H @ june,2017
Q1=[Q1,0];
Q2=[Q2,0];
P=[P1,0];
result = norm(cross(Q2-Q1,P-Q1))/norm(Q2-Q1);
end