% VL_DEMO_COVDET Demo: VL_COVDET()

% --------------------------------------------------------------------
%                                                               Basics
% --------------------------------------------------------------------

im = vl_impattern('roofs1') ;
im = im(end-255:end,1:320,:) ;

figure(1) ; clf ;
image(im) ; axis image off ;
vl_demo_print('covdet_basic_image') ;

imgs = im2single(rgb2gray(im)) ;
frames = vl_covdet(imgs, 'verbose') ;

hold on ;
vl_plotframe(frames) ;
vl_demo_print('covdet_basic_frames') ;

% --------------------------------------------------------------------
%                                                    Affine adaptation
% --------------------------------------------------------------------

frames = vl_covdet(imgs, 'estimateAffineShape', true, 'verbose') ;

figure(2) ; clf ;
image(im) ; axis image off ; hold on ;
vl_plotframe(frames) ;
vl_demo_print('covdet_affine_frames',.8) ;

% --------------------------------------------------------------------
%                                              Estimating orientations
% --------------------------------------------------------------------

frames = vl_covdet(imgs, 'estimateOrientation', true, 'verbose') ;

figure(3) ; clf ;
image(im) ; axis image off ; hold on ;
vl_plotframe(frames) ;
vl_demo_print('covdet_oriented_frames',.8) ;

% --------------------------------------------------------------------
%                                                   Extracting patches
% --------------------------------------------------------------------

[frames, patches] = vl_covdet(imgs, 'descriptor', 'patch') ;

figure(4) ; clf ;
w = sqrt(size(patches,1)) ;
vl_imarraysc(reshape(patches(:,1:10*10), w,w,[])) ;
axis image off ; hold on ; colormap gray ;
vl_demo_print('covdet_patches') ;

[frames, patches] = vl_covdet(imgs, ...
                              'descriptor', 'patch' ,...
                              'estimateAffineShape', true, ...
                              'estimateOrientation', false) ;

figure(5) ; clf ;
w = sqrt(size(patches,1)) ;
vl_imarraysc(reshape(patches(:,1:10*10), w,w,[])) ;
axis image off ; hold on ; colormap gray ;
vl_demo_print('covdet_affine_patches') ;

% --------------------------------------------------------------------
%                                                  Different detectors
% --------------------------------------------------------------------

names = {'DoG', 'Hessian', ...
         'HarrisLaplace', 'HessianLaplace', ...
         'MultiscaleHarris', 'MultiscaleHessian'} ;
figure(6) ; clf ;
for i = 1:numel(names)
  frames = vl_covdet(imgs, 'method', names{i}) ;

  vl_tightsubplot(3,2,i, 'margintop',0.025) ;
  imagesc(im) ; axis image off ;
  hold on ;
  vl_plotframe(frames) ;
  title(names{i}) ;
end

vl_figaspect(2/3) ;
vl_demo_print('covdet_detectors',.9) ;

% --------------------------------------------------------------------
%                                                        Custom frames
% --------------------------------------------------------------------

delta = 30 ;
xr = delta:delta:size(im,2)-delta+1 ;
yr = delta:delta:size(im,1)-delta+1 ;
[x,y] = meshgrid(xr,yr) ;
frames = [x(:)'; y(:)'] ;
frames(end+1,:) = delta/2 ;

[frames, patches] = vl_covdet(imgs, ...
                              'frames', frames, ...
                              'estimateAffineShape', true, ...
                              'estimateOrientation', true) ;

figure(7) ; clf ;
imagesc(im) ;
axis image off ; hold on ; colormap gray ;
vl_plotframe(frames) ;
vl_demo_print('covdet_custom_frames',.8) ;