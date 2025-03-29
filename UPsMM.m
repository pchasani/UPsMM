function [a, r, g, w, Prior, step] = UPsMM(DATA)
% This function implements an Expectation-Maximization (EM) algorithm
% with a unimodal constraint by merging overlapping and small intervals.
% It ensures that the estimated density of a Pi-sigmoid Mixture Model (PsMM) remains unimodal
% by iteratively optimizing its parameters.
% In that way the Unimodal Pi-sigmoid mixture model (UPSMM) is obtained for modeling unimodal distributions.

% Define global variables used across multiple functions
global Prior Posterior;
global a r g w X;
global K D N;
global NOISE_THRESHOLD step ex BG;

% Sort input data in ascending order
X = sort(DATA);

% Initialization using UU-test that provides the UMM model
[intervals,p,ww,~,~]=fitUU(X);

% --------- Noise Parameters --------
NOISE_THRESHOLD = 0; ex = 4; BG=0;
intervals2=[]; p2=[];

% Adjust the probability weights of the intervals
if size(intervals,1)>1
    for i=1:size(intervals,1)
        p{i,1} = ww(i) * p{i,1};
        intervals2=[intervals2; intervals{i,1}];
        p2=[p2; p{i,1}];
    end
    intervals{1,1}=intervals2;
    p{1,1} = p2;
end

% ---- Input Data ----
Kernels = size(intervals{1,1},1); % Number of initial components
K=Kernels+BG;
[D N] = size(X);
N = size(X,2);

% Initialize parameters for each interval (component)
% 'a' stores the starting points of the intervals
% 'r' represents the interval width (computed using square root)
% 'w' stores initial weights (set to 1 for all components)
a = intervals{1,1}(:,1)';
r = sqrt(intervals{1,1}(:,2)' - intervals{1,1}(:,1)');
w = 1*ones(size(intervals{1,1},1),1)';
Prior = p{1,1}'; % Set initial prior probabilities
g = 1*ones(D,K); % Initialize component scaling factors
Posterior=ones(size(X,2),K); % Preallocate Posterior probability matrix

% ----- Start the EM algorithm -----
myPlot(X,Prior,Posterior,K,a,r,g,w,1);
drawnow;

% ----- Start the EM algorithm -----
step = 1;
mpoint = round(length(X)/2); % Middle point of dataset (used for checking unimodality)

while(1)
    fprintf('step = %d \n',step);
    L1 = - LL(X,a,r,g,w,BG); % Compute log-likelihood before update
    
    % Perform Expectation and Maximization steps
    E_step;
    M_step;
    
    L2 = - LL(X,a,r,g,w,BG); % Compute log-likelihood after update
    
    % Compute second derivative of estimated distribution to check unimodality
    d2f = compute_d2f(X, a, r, g, Prior);
    [h, mpoint, inds_of_false_sign] = iscdf_unimodal(d2f, mpoint);
    
    if h==0 % multimodal
        
        points_of_false_sign = X(inds_of_false_sign); % Identify problematic points (MI-Multimodality Indicators)
        b = a + r.^2; % Compute interval end points
        intervals_ab = [a; b;]'; % Store start and end points of intervals
        
        % Merge very small intervals (threshold: 0.0001)
        size_of_intervals = abs(a-b);
        inds_of_small_intervals = find(size_of_intervals < 0.0001);
        
        if ~isempty(inds_of_small_intervals)
            ind_to_be_merged = inds_of_small_intervals(1);
        else
            % Detect which interval should be merged based on false sign points
            ind_to_be_merged = detect_interval_to_be_merged(points_of_false_sign, intervals_ab);
        end
        
        i_merge = ind_to_be_merged;
        K_bef = K; % Store number of components before merging
        
        % Merge overlapping intervals
        merge_overlap_intervals(i_merge,b,intervals_ab);
        
        % If no overlap was found, merge the closest intervals
        if K_bef == K
            closest = find_closest_interval(intervals_ab(i_merge,:), intervals_ab);
            merge_and_delete(i_merge, closest,intervals_ab);
        end
        
        Posterior = Posterior(:,1:K); % Update Posterior matrix size
        L1 = L2;
        L2 = - LL(X,a,r,g,w,BG); % Recompute log-likelihood
    end
    % Replot updated distribution
    myPlot(X,Prior,Posterior,K,a,r,g,w,1);
    
    % Recompute second derivative after merging
    d2f = compute_d2f(X, a, r, g, Prior);
    [h, mpoint, inds_of_false_sign] = iscdf_unimodal(d2f, mpoint);
    step = step + 1;
    
    % Check for convergence: Likelihood improvement is small and density is unimodal
    if L2 >= L1 && L2 - L1 < 0.01  && h==1
        fprintf('\n----- Unimodal model and Likelihood converged in step = %d -----\n\n', step);
        break
    end
    % Safety break condition (in case of non-convergence)
    if step > 5000
        break;
    end
end