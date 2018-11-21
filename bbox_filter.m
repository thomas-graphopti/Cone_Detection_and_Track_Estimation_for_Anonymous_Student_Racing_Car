function [bbox_Y,bbox_B,bbox_R]=bbox_filter(bbox,im)
%im=cut_frame;
%im=videoFrame;

bbox_Y=[];
bbox_B=[];
bbox_R=[];
im=im2uint8(im);
[bbox_size,~]=size(bbox);
    for i=1:bbox_size
    bound=bbox(i,:);
        if bound(3)*bound(4)<=2000
        im_cut=imcrop(im,bound);
        [width,height,~]=size(im_cut);
        count=zeros(width,height,3);
            for w=1:width
                for h=1:height
                    rgb=im_cut(w,h,:);
                    R=rgb(1);
                    G=rgb(2);
                    B=rgb(3);
                    if R>180&&R<=255 && G>180&&G<=255 && B<=180
                        count(w,h,1)=1;
                    end
                    if R>110&&R<=160 && G>90&&G<=160 && B<=80
                        count(w,h,1)=1;
                    end
%                       if R>70&&R<=120 && G>70&&G<=110 && B<=100 &&B>=60
%                         count(w,h,1)=1;
%                        end
                    if R<=100 && G>100 && B<=255 &&B>100
                        count(w,h,2)=1;
                    end
                    if R>210&&R<=255 && G<=100 && B<=100
                        count(w,h,3)=1;
                    end
                end
            end
            if sum(sum(count(:,:,1)))/(width*height)>=0.05
                bbox_Y=[bbox_Y; bound];
            end
            if sum(sum(count(:,:,2)))/(width*height)>=0.05
                bbox_B=[bbox_B; bound];
            end
            if sum(sum(count(:,:,3)))/(width*height)>=0.05
                bbox_R=[bbox_R; bound];
            end
        end
     end
end