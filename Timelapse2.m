disp('Resizing images...')
D=dir('*.jpg');
numberofimages=numel(D);
sampleimg=getfield(D,'name');
dim=size(imread(sampleimg));
imageresizeheight=0;
imageresizewidth=0;
estimatememory=1*10^12;
f=1/1.05;
value=memory;
while estimatememory >= value.MaxPossibleArrayBytes
f=f*1.05;
slicewidth=floor((dim(2)/numberofimages)/f);
imageresizewidth=slicewidth*numberofimages;
imageresizeheight=floor((imageresizewidth/dim(2))*dim(1));
estimatememory=imageresizewidth*imageresizeheight*3*numberofimages;
end

fprintf(strcat('Quality',':',num2str(imageresizewidth),'x',num2str(imageresizeheight),'\n ....'))
resizedir=strcat(pwd,'\resizes\');
for i=1:numberofimages
    name=getfield(D(i),'name');
    resizedimage=imresize(imread(name),[imageresizeheight,imageresizewidth]);
    imageresizematrix(i)={resizedimage};
    fprintf ('\b\b\b\b\b %03d\n', i)
end

disp('Resizing done. Slicing images...')

for i=1:numberofimages
    imgtobesliced=cell2mat(imageresizematrix(1));
    for j=1:numberofimages
        slice(i,j)={imgtobesliced(1:imageresizeheight,(-slicewidth+1+(slicewidth*j)):(slicewidth*j),:)};
    end
    fprintf ('\b\b\b\b\b %03d\n', i)
    imageresizematrix(1)=[];
end

disp('Slicing done. Creating slice position matrix...')

imagematrix2=repmat(1:numberofimages,numberofimages,1);

for i=1:numberofimages
    for j=1:numberofimages
        imagematrix1(i,j)=mod((i+j-1),numberofimages);
    end
end

imagematrix1(imagematrix1==0)=numberofimages;

for i=1:numberofimages
    for j=1:numberofimages
        imagematrix(i,j,1)={num2str(imagematrix1(i,j))};
        imagematrix(i,j,2)={num2str(imagematrix2(i,j))};
    end
end

mkdir('final');

disp('Matrix creation done. Stitching images...')

for i=1:numberofimages
    folderpathfinal=strcat(pwd,'\','final','\','IMG_',num2str(i),'.jpg');
    slicematrix=cell2mat(slice(str2num(cell2mat(imagematrix(i,1,1))),str2num(cell2mat(imagematrix(i,1,2)))));
    for j=2:numberofimages
       slicematrix=horzcat(slicematrix,cell2mat(slice(str2num(cell2mat(imagematrix(i,j,1))),str2num(cell2mat(imagematrix(i,j,2))))));
    end
    imwrite(slicematrix,folderpathfinal);
    fprintf ('\b\b\b\b\b %03d\n', i)
end

disp('All done.')
        
