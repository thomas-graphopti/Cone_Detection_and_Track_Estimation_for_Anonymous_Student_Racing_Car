function angle=intersection_angle(p1,p2,p3)
u=p1-p2;
v=p3-p2;
u=[u 0];
v=[v 0];
angle = atan2d(norm(cross(u,v)),dot(u,v));
end