% load result.mat

%avg = avg(1:19);
%psnr = psnr(1:19);
%time = time(1:19);
%c = c(1:19);

dx = -0.05;
dy = 0.3;

scatter(psnr,avg,3*time,'filled')

text(psnr+dx,avg+dy,c,'FontSize',18)


ylabel("optimal edge deviation")
xlabel("PSNR")

set(gca, 'FontSize', 26);