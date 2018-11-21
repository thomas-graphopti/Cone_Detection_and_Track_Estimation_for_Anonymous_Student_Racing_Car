function state=divide_bbox(bbox_Y)
ol=[200 190];
or=[600 190];
mid_coor_new=bbox_Y(:,1:2)+bbox_Y(:,3:4)/2;
min_cost=inf;
min_coor=[400 0];
[a,~]=size(mid_coor_new);
min_state=zeros(a,1);
for y=-100:1:0
    for x=0:1:800
        cost=0;
        state=zeros(5,1);
        for i=1:a
            if dist_line_point(ol,[x y],mid_coor_new(i,:))>dist_line_point(or,[x y],mid_coor_new(i,:))
            cost=cost+dist_line_point(or,[x y],mid_coor_new(i,:));
            state(i)=1;
            else
                cost=cost+dist_line_point(ol,[x y],mid_coor_new(i,:));
            end
        end
            if cost<min_cost
                min_cost=cost;
                min_state=state;
                min_coor=[x y];
            end
     end
end
state=min_state;
end