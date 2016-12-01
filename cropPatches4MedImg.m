%the infant brain images, the are three type images: T1( xx_cbq.hdr), T2
%(xx_cbq-T2.hdr), label(xx-ls-corrected.hdr)
%I convert the label images to 0,1,2,3
function readMRCTimgFile()
addpath('/home/dongnie/Desktop/Caffes/software/NIfTI_20140122');
addpath('/home/dongnie/Desktop/Caffes/software/REST_V1.9_140508/REST_V1.9_140508');
% instensity image
d=32;
len=13;
step=6;
rate=1;
path='./';
ids=[1 2 3 4 5 6 7 8 9 10 11];
%flipIDs=[12 13 15 16 18 20 21 22];

for i=1:length(ids)
    id=ids(i);
    ctfilename='prostate_%dto1_CT.nii',id
    [ctimg cthead]=rest_ReadNiftiImage([path,ctfilename]);
    %info = analyze75info([path,labelfilename]);
    %labelimg = analyze75read(info);%
%     labelimg(find(labelimg>200))=3;%white matter
%     labelimg(find(labelimg>100))=2;%gray matter
%     labelimg(find(labelimg>4))=1;%csf
    
     mrfilename=sprintf('prostate_%dto1_MRI.nii',id);
    [mrimg mrhead]=rest_ReadNiftiImage([path,mrfilename]);
    
%     words=regexp(t1filename,'_','split');
%     word=words{1};
%     word=lower(word);
%     saveFilename=sprintf('%s',word);
    %crop areas
    cnt=cropCubic(mrimg,ctimg,id,d,step,rate);
    
    
  
    
end
% 
% t1filename='NORMAL01_cbq.hdr';
% info = analyze75info([path,t1filename]);
% t1img = analyze75read(info);
% 
% t2filename='NORMAL01_cbq-T2.hdr';
% info = analyze75info([path,t2filename]);
% t2img = analyze75read(info);
% 
% labelfilename='NORMAL01-ls-corrected.hdr';
% info = analyze75info([path,labelfilename]);
% labelimg = analyze75read(info);

return


%crop width*height*length from mat,and stored as image
%note,matData is 3 channels, matSet is 1 channel
%d: the patch size
function cubicCnt=cropCubic(matFA,matSeg,fileID,d,step,rate)   
    eps=1e-2;
    if nargin<6
    	rate=1/4;
    end
    if nargin<5
        step=4;
    end
    if nargin<4
        d=16;
    end
    [row,col,len]=size(matFA);
    %[rowData,colData,lenData]=size(matT1);
   
    %if row~=rowData||col~=colData||len~=lenData
     %   fprintf('size of matData and matSeg is not consistent\n');
     %   exit
    %end
    cubicCnt=0;
    fid=fopen('trainProstate_list.txt','a');

    for i=1:step:row-d+1
        for j=1:step:col-d+1
            for k=1:step:len-d+1%there is no overlapping in the 3rd dim
                volSeg=single(matSeg(i:i+d-1,j:j+d-1,k:k+d-1));
                if sum(volSeg(:))<eps%all zero submat
                    continue;
                end
                cubicCnt=cubicCnt+1;
                volFA=single(matFA(i:i+d-1,j:j+d-1,k:k+d-1));
                trainFA(:,:,:,1,cubicCnt)=volFA;
                trainSeg(:,:,:,1,cubicCnt)=volSeg;
            end
        end
    end
     trainFA=single(trainFA);
     trainSeg=single(trainSeg);
     h5create(sprintf('train32_%d.hdf5',fileID),'/dataMR',size(trainFA),'Datatype','single');
     h5write(sprintf('train32_%d.hdf5',fileID),'/dataMR',trainFA);
     h5create(sprintf('train32_%d.hdf5',fileID),'/dataCT',size(trainSeg),'Datatype','single');
     h5write(sprintf('train32_%d.hdf5',fileID),'/dataCT',trainSeg);
     clear trainFA;
     clear trainSeg;
     fprintf(fid,sprintf('train32_%d.hdf5\n',fileID));	
     fclose(fid);
return
