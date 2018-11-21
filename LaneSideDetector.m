function im_out=LaneSideDetector(bbox_Y,im)
%im=videoOut;
[a1,~]=size(bbox_Y);
ol=[100 190];
or=[800 190];
bbox_Y_l=[];
bbox_Y_r=[];
mid_Y_r=[];
mid_Y_l=[];
if ~isempty(bbox_Y)
    mid_coor_new=bbox_Y(:,1:2)+bbox_Y(:,3:4)/2;  

    
% Ransac
%init
min_cost=inf;
min_coor=[400 0];
min_state=zeros(a1,1);
best_cost=inf;
inliers=mid_coor_new;
best_model=inliers;

for t=1:5
%fit model
for y=-50:10:0
    for x=0:5:800
        cost=0;
        [aii,~]=size(inliers);
        state=zeros(aii,1);
        for i=1:aii
            if dist_line_point(ol,[x y],inliers(i,:))>dist_line_point(or,[x y],inliers(i,:))
            cost=cost+dist_line_point(or,[x y],inliers(i,:));
            state(i)=1;
            else
                cost=cost+dist_line_point(ol,[x y],inliers(i,:));
            end
        end
            if cost<min_cost
                min_cost=cost;
                min_state=state;
                min_coor=[x y];
                model=inliers;
            end
     end
end
%error compute

%determine inliers
[r1,~]=size(mid_coor_new);
for ri=1:r1
    error(ri)=min(dist_line_point(ol,min_coor,mid_coor_new(ri,:)),dist_line_point(or,min_coor,mid_coor_new(ri,:)));
end
inliers_buff=[];
for rii=1:r1
    if error(rii)<2*mean(error)
        inliers_buff=[inliers_buff;mid_coor_new(rii,:)];
    end
end
inliers=inliers_buff;
%
if min_cost<best_cost
    best_cost=min_cost;
    best_model=model;
    best_state=min_state;
end
end
%end RANSAC
[aa,~]=size(best_model);
mid_Y_r=[];
 mid_Y_l=[];
for i5=1:aa
    if best_state(i5)==1
        mid_Y_r=[mid_Y_r;best_model(i5,:)];
    else
        mid_Y_l=[mid_Y_l;best_model(i5,:)]; 
    end
end


% [r1,~]=size(bbox_Y_r);
% [l1,~]=size(bbox_Y_l);
% 
% if ~isempty(bbox_Y_r)
%     bbox_Y_r=sortrows(bbox_Y_r,2);
% end
% if ~isempty(bbox_Y_l)
%     bbox_Y_l=sortrows(bbox_Y_l,2);
% end
% if ~isempty(bbox_Y_r)
%     mid_Y_r=bbox_Y_r(:,1:2)+bbox_Y_r(:,3:4)/2;
% end
% if ~isempty(bbox_Y_l)
%     mid_Y_l=bbox_Y_l(:,1:2)+bbox_Y_l(:,3:4)/2;
% end
if ~isempty( mid_Y_r)
    mid_Y_r=sortrows(mid_Y_r,2);
end
if ~isempty( mid_Y_l)
    mid_Y_l=sortrows(mid_Y_l,2);
end
mid_Y_r=[mid_Y_r;or];
mid_Y_l=[mid_Y_l;ol];

[ar ~]=size(mid_Y_r);
[al ~]=size(mid_Y_l);



% %linearlize
for x1=1:5
[ar ~]=size(mid_Y_r);
[al ~]=size(mid_Y_l);
mid_Y_r_f=mid_Y_r(1,:);
mid_Y_l_f=mid_Y_l(1,:);
if ar>=2
for i=2:ar-1
    if intersection_angle(mid_Y_r(i-1,:),mid_Y_r(i,:),mid_Y_r(i+1,:))>=90
        mid_Y_r_f=[mid_Y_r_f;mid_Y_r(i,:)];
    end
end
mid_Y_r=[mid_Y_r_f;or];
end
if al>=2
for i=2:al-1
    if intersection_angle(mid_Y_l(i-1,:),mid_Y_l(i,:),mid_Y_l(i+1,:))>=90
        mid_Y_l_f=[mid_Y_l_f;mid_Y_l(i,:)];
    end
end
mid_Y_l=[mid_Y_l_f;ol];
end

end

[ar ~]=size(mid_Y_r);
[al ~]=size(mid_Y_l);
mid_Y_r=mid_Y_r+[300 280];
mid_Y_l=mid_Y_l+[300 280];

im_out=im;
    for i=1:ar-1
        im_out=insertShape(im_out,'Line',[mid_Y_r(i,1) mid_Y_r(i,2) mid_Y_r(i+1,1) mid_Y_r(i+1,2)],'LineWidth',5,'Color','red');
    end
    for i=1:al-1
        im_out=insertShape(im_out,'Line',[mid_Y_l(i,1) mid_Y_l(i,2) mid_Y_l(i+1,1) mid_Y_l(i+1,2)],'LineWidth',5,'Color','green');    
    end

else
     im_out=im;
     end
end