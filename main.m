%%%% Computer Vision %%%%
%%%% Final Project %%%%
%T.Hu&W.J.Duan
%June 2017
clc
clear all
%% Read the video
%videoFileReader=vision.VideoFileReader('../Videos/TU Brno Racing - Formula Student Germany 2014 - Onboard.mp4');
videoFileReader=vision.VideoFileReader('E:\Study\IN4393 Computer Vision\project\Project\CNN\image_dataset\video\TUfast eb016 - FSG AutoX 2016.mp4');
v=VideoWriter('result.avi');
%% Specify the foler for images.
greenDir=fullfile('E:\Study\IN4393 Computer Vision\project\Project\CNN\image_dataset\positive_test');
negativeFolder = fullfile('E:\Study\IN4393 Computer Vision\project\Project\CNN\image_dataset\video\negative');
addpath(greenDir);
%% Create |imageDatastore| object containing negative images.
greenConeImages=imageDatastore(greenDir);
%%
negativeImages=imageDatastore(negativeFolder);
[length_neg ~]=size(greenConeImages.Files);
greenConeRegion=ones(length(greenConeImages.Files),4);
for ii=1:length(greenConeImages.Files)
    imsize=size(imread(cell2mat(greenConeImages.Files(ii))));
    greenConeRegion(ii,:)=[1 1 imsize(2) imsize(1)];
end
greenConeInstances=table(greenConeImages.Files,greenConeRegion);
%% train the green cone detector by HOG features
% trainCascadeObjectDetector('yellowConeDetector.xml',greenConeInstances,...
%     negativeFolder,...
%     'FeatureType','HOG','NumCascadeStages',20,'FalseAlarmRate',0.1,'ObjectTrainingSize',[27 23],'NegativeSamplesFactor',2);
yellowDetector=vision.CascadeObjectDetector('yellowConeDetector.xml');
%% play the video
%Create a video player object for displaying video frames.
videoInfo    = info(videoFileReader);
videoPlayer  = vision.VideoPlayer('Position',[300 300 videoInfo.VideoSize]);
open(v);
while ~isDone(videoFileReader)
    videoFrame=step(videoFileReader);
    cut_frame=imcrop(videoFrame,[300 280 800 190]);
    bbox=step(yellowDetector,cut_frame);
    %-------------------------detect the cone----------------------------
    [bbox_Y,bbox_B,bbox_R]=bbox_filter(bbox,cut_frame);
    [a1,~]=size(bbox_Y);
    bbox_Y_buff=[];
for i =1:a1
    if bbox_Y(i,2)>20
        bbox_Y_buff=[bbox_Y_buff;bbox_Y(i,:)];
    end
end
bbox_Y=bbox_Y_buff;
    bbox_Y_s=bbox_Y;
    if ~isempty(bbox)
             bbox(:,1)=bbox(:,1)+300;
    bbox(:,2)=bbox(:,2)+280;
    videoOut = insertObjectAnnotation(videoFrame,'rectangle',bbox,'Original detect');
    videoOut=   videoFrame;
    else
       videoOut=   videoFrame;
      end 
   
      if ~isempty(bbox_R)
            bbox_R(:,1)=bbox_R(:,1)+300;
    bbox_R(:,2)=bbox_R(:,2)+280;
    videoOut = insertObjectAnnotation(videoOut,'rectangle',bbox_R,'Red cone');
    end
       if ~isempty(bbox_B)
             bbox_B(:,1)=bbox_B(:,1)+300;
    bbox_B(:,2)=bbox_B(:,2)+280;
    videoOut = insertObjectAnnotation(videoOut,'rectangle',bbox_B,'Blue cone');
       end
       if ~isempty(bbox_Y)
             bbox_Y(:,1)=bbox_Y(:,1)+300;
    bbox_Y(:,2)=bbox_Y(:,2)+280;
    videoOut = insertObjectAnnotation(videoOut,'rectangle',bbox_Y,'Yellow cone');
       end
       %-------------------------------detect the lane--------------------
    videoOut=LaneSideDetector(bbox_Y_s,videoOut);
    
    writeVideo(v,videoOut);
   
    step(videoPlayer,videoOut);
%     figure(5);
%     clf;
%     if ~isempty(bbox_Y)       
%         mid_coor_new=bbox_Y_s(:,1:2)+bbox_Y_s(:,3:4)/2;
%         plot(mid_coor_new(:,1),mid_coor_new(:,2),'x');
%         xlim([0 800]);
%         ylim([0 190]);
%         text(267,180,'lo');
%         text(533,180,'ro');
%         [a1,~]=size(bbox_Y_s);
%     for i=1:a1
%     text(mid_coor_new(i,1),mid_coor_new(i,2),num2str(i));
%     end
%     end
%     title('position of cone in interested area');
end
% Release resources
 close(v);
release(yellowDetector);
release(videoFileReader);
release(videoPlayer);

%%
