function Plot_pdf_ecdf(X, y1, y2, y3, type)
% Plots either the Probability Density Function (PDF) or
% the Empirical Cumulative Distribution Function (ECDF)
% along with model-based estimates.
%
% Inputs:
%   X    - Data points
%   y1   - Estimated density/CDF of the UMM model
%   y2   - Estimated density/CDF of the UPsMM model
%   y3   - Estimated density/CDF of the Gaussian model
%   type - 'pdf' for density plots, otherwise plots ECDF

% Pdf plot
if type == 'pdf'
    % Full PDF comparison plot
    figure; set(gcf, 'Position',  [100, 100, 450, 350])
    histogram(X,50,'Normalization','pdf'); hold on;
    p1=plot(X,y1,'r','LineWidth',1.5);hold on;
    p2=plot(X,y2,'b','LineWidth',1.5);   hold on;
    p3 = plot(X,y3,'m','LineWidth',1.5); hold on;
    legend([p1 p2 p3],{'UMM','UPsMM','Gaussian model'});
    legend('boxoff');
    
    % UPsMM model PDF
    figure;
    p1=histogram(X,50,'Normalization','pdf'); hold on;
    p2=plot(X, y2, 'r','LineWidth',1.5); hold on;
    legend([p2],{'U\PisMM'});
    legend('boxoff');
    set(gcf, 'Position',  [100, 100, 400, 300])
    
    % UMM model PDF
    figure;
    p1=histogram(X,50,'Normalization','pdf'); hold on;
    p2=plot(X, y1, 'r','LineWidth',1.5); hold on;
    legend([p2],{'UMM'});
    legend('boxoff');
    set(gcf, 'Position',  [100, 100, 400, 300])
    %     subplot(1,3,3)
    %     histogram(X,50,'Normalization','pdf'); hold on;
    %     plot(X, y3,'r','LineWidth',1.5); hold off;
    
    
else
    % Ecdf plot
    [F,x] = ecdf(X); F=F(2:end); x=x(2:end);
    figure(); set(gcf, 'Position',  [100, 100, 1400, 350])
    
    % ECDF vs UMM
    subplot(1,3,1)
    p1 = plot(x, F, 'c','LineWidth',1.5); hold on;
    p2 = plot(x, y1, 'r','LineWidth',1.5); hold off;
    legend([p1 p2],{'ECDF','UMM'})
    legend('boxoff');
    
    % ECDF vs UPsMM
    subplot(1,3,2)
    p1 = plot(x, F, 'c','LineWidth',1.5); hold on;
    p2 = plot(x, y2, 'b','LineWidth',1.5);
    legend([p1 p2],{'ECDF','UPsMM'},'Location','northwest')
    legend('boxoff');
    
    % ECDF vs Gaussian model
    subplot(1,3,3)
    p1 = plot(x, F,'c','LineWidth',1.5); hold on;
    p2 = plot(x, y3,'m','LineWidth',1.5); hold off;
    legend([p1 p2],{'ECDF','Gaussian model'},'Location','northwest')
    legend('boxoff');
    
    % Error Calculation
    error_UU = abs(F - y1'); % Error for UMM
    error_UPsMM = abs(F - y2); % Error for UPsMM
    error_G = abs(F - y3); % Error for Gaussian model
    
    % Error Plot
    figure(); set(gcf, 'Position',  [100, 100, 450, 350])
    
    % UMM vs UPsMM error
    subplot(2,1,1)
    p1 = plot(x, error_UU,'r','LineWidth',1.5); hold on;
    p2 = plot(x, error_UPsMM,'b','LineWidth',1.5); hold off;
    legend([p1 p2],{'Error: UMM','Error: UPsMM'})
    legend('boxoff');
    
    % Gaussian vs UPsMM error
    subplot(2,1,2)
    p1 = plot(x, error_G,'m','LineWidth',1.5); hold on;
    p2 = plot(x, error_UPsMM,'b','LineWidth',1.5);
    legend([p1 p2],{'Error: Gaussian model','Error: UPsMM'})
    legend('boxoff');
    
end

end
