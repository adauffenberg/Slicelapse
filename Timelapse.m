disp('Resizing images')

D=dir('*.jpg');
numberofimages=numel(D);
sampleimg=getfield(D,'name');
dim=size(imread(sampleimg));
slicewidth=floor(dim(2)/numberofimages);
imageresizewidth=slicewidth*numberofimages;
imageresizeheight=floor((imageresizewidth/dim(2))*dim(1));
mkdir('resizes');
begindir=pwd;
resizedir=strcat(pwd,'\resizes\');
for i=1:numberofimages
    name=getfield(D(i),'name');
    resizedimage=imresize(imread(name),[imageresizeheight,imageresizewidth]);
    folderpathresize=strcat(resizedir,name);
    imwrite(resizedimage,folderpathresize,'jpg')
end
cd('resizes')

disp('Resizing done. Slicing images...')

for i=1:numberofimages
    s_name=(getfield(D(i),'name'));
    imgtobesliced=imread(s_name);
    for j=1:numberofimages
        slice=imgtobesliced(1:imageresizeheight,(-slicewidth+1+(slicewidth*j)):(slicewidth*j),:);
        folderpathslice=strcat(pwd,'\',num2str(i),'_',num2str(j),'.jpg');
        imwrite(slice,folderpathslice,'jpg');   
    end
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
        imagematrix(i,j)={strcat(num2str(imagematrix1(i,j)),'_',num2str(imagematrix2(i,j)),'.jpg')};
    end
end
mkdir('final');

disp('Slice matrix position creation done. Stitching images...')

for i=1:numberofimages
    folderpathfinal=strcat(pwd,'\','final','\','IMG_',num2str(i),'.jpg');
    name=cell2mat(imagematrix(i,1));
    slicematrix=imread(name);
    for j=2:numberofimages
       slicematrix=horzcat(slicematrix,imread(cell2mat(imagematrix(i,j))));
    end
    imwrite(slicematrix,folderpathfinal);
    for j=1:numberofimages
        delete(cell2mat(imagematrix(i,j)))
    end
end
cd(begindir);

disp('All done.')
        
