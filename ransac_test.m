%test for lane detection
clc;
close all;
im = imread('E:\Study\IN4393 Computer Vision\project\Project\CNN\image_dataset\video\images_cut\411.jpg');
detector=vision.CascadeObjectDetector('greenConeDetector.xml');
bbox=step(detector,im);

[a,~]=size(bbox);
bbox_new=[];
for i=1:a
if bbox(i,3)*bbox(i,4)<4000
    bbox_new=[bbox_new; bbox(i,:)];
end
end
[a,~]=size(bbox_new);
mid_coor=bbox_new(:,1:2)+bbox_new(:,3:4)/2;
cut=bbox(:,1:2);
videoOut = insertObjectAnnotation(im,'rectangle',bbox,'d');
figure(1);
 
 for i=1:a
videoOut=insertText(videoOut,bbox(i,1:2),num2str(i));
 end
videoOut=insertText(videoOut,[267 180],'Left O');
videoOut=insertText(videoOut,[533 180],'Right O');
imshow(videoOut);
% figure(3);
% plot(mid_coor(:,1),mid_coor(:,2),'o');
% xlim([0 800]);
% ylim([0 190]);
% text(267,180,'lo');
% text(533,180,'ro');
%  
%  for i=1:a
% text(mid_coor(i,1),mid_coor(i,2),num2str(i));
%  end
 [bbox_Y,bbox_B,bbox_R]=bbox_filter_hsv(bbox,im);
[a1,~]=size(bbox_Y);

 if ~isempty(bbox_Y)
     videoOut2 = insertObjectAnnotation(im,'rectangle',bbox_Y,'Yellow cone');
 end
 videoOut2=insertText(videoOut2,[267 180],'Left O');
videoOut2=insertText(videoOut2,[533 180],'Right O');
for i=1:a1
videoOut2=insertText(videoOut2,bbox_Y(i,1:2),num2str(i));
 end
 figure(4);
 imshow(videoOut2);
 figure(5);
 mid_coor_new=bbox_Y(:,1:2)+bbox_Y(:,3:4)/2;
plot(mid_coor_new(:,1),mid_coor_new(:,2),'x');
xlim([0 800]);
ylim([0 190]);
text(267,180,'lo');
text(533,180,'ro');
ol=[200 190];
or=[600 190];
for i=1:a1
text(mid_coor_new(i,1),mid_coor_new(i,2),num2str(i));
end
min_cost=inf;
min_coor=[400 0];
min_state=zeros(a1,1);
min_cost_step=zeros(a1,1);
%%
%%RANSAC
for iteration=1:10
%FIT Model
for y=-100:5:0
    for x=0:2:800
        cost=0;
        state=zeros(a1,1);
        for i=1:a1
            if dist_line_point(ol,[x y],mid_coor_new(i,:))>dist_line_point(or,[x y],mid_coor_new(i,:))
            cost_step(i)=dist_line_point(or,[x y],mid_coor_new(i,:));
             cost=cost+dist_line_point(or,[x y],mid_coor_new(i,:));
            
            state(i)=1;
            else
                cost_step(i)=dist_line_point(ol,[x y],mid_coor_new(i,:));
                cost=cost+dist_line_point(ol,[x y],mid_coor_new(i,:));
            end
        end
            if cost<min_cost
                min_cost=cost;
                min_state=state;
                min_coor=[x y];
                min_cost_step=cost_step;
            end
     end
end

%inliers detemination


%best model decide

end

%% filter and hashing

bbox_Y_l=[];
bbox_Y_r=[];
for i=1:a1
    if min_state(i)==1
        bbox_Y_r=[bbox_Y_r;bbox_Y(i,:)];
    else
        bbox_Y_l=[bbox_Y_l;bbox_Y(i,:)];
    end
end
if ~isempty(bbox_Y_r)
bbox_Y_r=sortrows(bbox_Y_r,2);
end
if ~isempty(bbox_Y_l)
bbox_Y_l=sortrows(bbox_Y_l,2);
end
if ~isempty(bbox_Y_r)
mid_Y_r=bbox_Y_r(:,1:2)+bbox_Y_r(:,3:4)/2;
end
if ~isempty(bbox_Y_l)
mid_Y_l=bbox_Y_l(:,1:2)+bbox_Y_l(:,3:4)/2;
end
%or_new=[600 190];
%ol_new=[250 190];
mid_Y_r=[mid_Y_r;or];
mid_Y_l=[mid_Y_l;ol];
[ar ~]=size(mid_Y_r);
[al ~]=size(mid_Y_l);
%%drawing line
%%
videoOut3=videoOut2;
for i=1:ar-1
videoOut3=insertShape(videoOut3,'Line',[mid_Y_r(i,1) mid_Y_r(i,2) mid_Y_r(i+1,1) mid_Y_r(i+1,2)],'LineWidth',5,'Color','red');
end
for i=1:al-1
videoOut3=insertShape(videoOut3,'Line',[mid_Y_l(i,1) mid_Y_l(i,2) mid_Y_l(i+1,1) mid_Y_l(i+1,2)],'LineWidth',5,'Color','green');    
end
videoOut3=insertShape(videoOut3,'Line',[or(1) or(2) min_coor(1) min_coor(2)],'LineWidth',5,'Color','blue');
videoOut3=insertShape(videoOut3,'Line',[ol(1) ol(2) min_coor(1) min_coor(2)],'LineWidth',5,'Color','blue');

figure(6);
imshow(videoOut3);


    

