function partial_dependance(x, y, W, labels, varargin)
// Function to plot partial dependance for one (2d plot) or two (surface plot) variables.

// Syntax
//   partial_dependance(x, y, W, labels)
//   partial_dependance(x, y, W, labels, n)
//   partial_dependance(x, y, W, labels, n, header)
//   partial_dependance(x, y, W, labels, n, header, sf)
//   partial_dependance(x, y, W, labels, n, header, sf, af)
//
// Parameters
// x: n x m matrix of input parameters, each column represents a different parameter
// y: n x p matrix of target values, each column represents a different variable
// W: hypermatrix of weights and biases resulting from trained neural network
// labels: row vector of strings describing one or two variables for partial dependency to be determined, OR vector of indices identifying column nr/s of variables
// n: nr of input values to use
// header: if labels are given as a string, a header of all input columns must be supplied as a row vector of strings.
// sf: string variable identifing simulation function, default 'ann_FFBP_run' 
// af: matrix of strings describing activation function for each layer incl output, default = ['ann_tansig_activ','ann_purelin_activ']

n = 30;
header = [];
sf = 'ann_FFBP_run';
af = repmat('ann_tansig_activ',1,size(W)-1);
af($+1) = 'ann_purelin_activ';

[lhs, rhs] = argn();

if size(varargin) > 0 then
    n = varargin(1); // Overwrite default
    if isempty(n) then
        n = 30;
    end
    
    if size(varargin) > 1 then
        header = varargin(2)
    end
    
    if size(varargin) > 2 then
        sf = varargin(3)
        if isempty(sf) then
            sf = 'ann_FFBP_run';
        end
    end
    
    if size(varargin) > 3 then
        af = varargin(4)
    end
end
    
[nr, nc] = size(x);

if size(labels,2) == 1 then         // single input variable
    if type(labels) == 10 then      // identifyers are a string
        i = find_indices(header, labels);
    else 
        i = labels;
    end
    x_range = (linspace(min(x(:,i)),max(x(:,i)),n))';
    
    for j = 1:n
        x_p = x
        x_p(:,i) = repmat(x_range(j),nr,1);
        y_p =evstr(sf+'(x_p'', W, af)');
        y_p_m_partial(j) = mean(y_p);
    end

    scf(), clf()
    plot(x_range, y_p_m_partial);
    
    // deciles
    xd = gsort(x(:,i), 'g', 'i')
    a = (1:9)'
    loc = a.*(n+1)./10
    x_low = xd(floor(loc))
    x_high = xd(ceil(loc))
    x_int = modulo(loc,1)
    x_deciles = x_low+x_int.*(x_high-x_low)
    
    plot(x_deciles, min(y_p_m_partial)*ones(x_deciles),'k+');
    xlabel('x_2');
    ylabel('Partial dependence');
end

if size(labels,2) == 2 then         // single input variable
    if type(labels) == 10 then      // identifyers are a string
        i = find_indices(header, labels);
    else 
        i = labels;
    end

    x1_range = (linspace(min(x(:,i(1))),max(x(:,i(1))),n))';
    x2_range = (linspace(min(x(:,i(2))),max(x(:,i(2))),n))';

    for j = 1:n
        for k = 1:n
            x_p = x;
            x_p(:,i(1)) = repmat(x1_range(j),nr,1);
            x_p(:,i(2)) = repmat(x2_range(k),nr,1);
            y_p = evstr(sf+'(x_p'', W, af)');
            y_p_m(j,k) = mean(y_p);
        end
    end

    // deciles
    xd = gsort(x(:,i(1)), 'g', 'i')
    a = (1:9)'
    loc = a.*(nr+1)./10
    x_low = xd(floor(loc))
    x_high = xd(ceil(loc))
    x_int = modulo(loc,1)
    x_deciles = x_low+x_int.*(x_high-x_low)
    
    scf(), clf()
    contour( x1_range, x2_range, y_p_m, 7)
    xlabel('x_1');
    ylabel('x_2');
    plot(x_deciles, min(x2_range)*ones(x_deciles),'k+');
end
endfunction
