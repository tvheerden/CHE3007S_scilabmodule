function [p] = percentile(x, y, varargin)
    // Determination of user selected percentile for vectors or matrices
    //
    // Syntax
    //  [p] = percentile(x, y)
    //  [p] = percentile(x, y, dim)
    //
    // Parameters
    // x: matrix or vector of date for which we would like to determine percentiles
    // y: percentile to be calculated
    // dim: dimension along which to determine percentile, default is '*' all data, 'r' or 'c' also available for row-wise and column-wise operations
    
    [lhs, rhs] = argn();
    method = 'g';
    dim = '*';
    if rhs > 2 then
        dim = varargin(1);
    end

    if dim == 'r' then
        method = 'r'
    elseif dim == 'c' then
        method = 'c'
    end
    
    [xd, i] = gsort(x, method, 'i');
    n = size(x, dim);
    loc = (n+1)*y/100;
    
    if loc > n then
        printf('\ndataset may be too small for determination of %.1f th percentile', y);
        if dim == 'c' then
            low = xd(:,$-1);
            high = xd(:,$);
        elseif dim == 'r' then
            low = xd($-1,:);
            high = xd($,:);
        else
            low = xd($-1);
            high = xd($);
        end
        ys = 100*linspace(0,n,n-1)./n
        ylow = ys($-1)
        yhigh = ys($)
        p = low + (y-ylow).*(high-low)./(yhigh - ylow)
    
    elseif loc <1 then
        printf('\ndataset may be too small for determination of %.1f th percentile', y);
        if dim == 'c' then
            low = xd(:,1);
            high = xd(:,2);
        elseif dim == 'r' then
            low = xd(1,:);
            high = xd(2,:);
        else
            low = xd(1);
            high = xd(2);
        end
        ys = 100*linspace(0,n,n-1)./n
        ylow = ys(1)
        yhigh = ys(2)
        p = low + (y-ylow)*(high-low)/(yhigh - ylow)
    
    else
        if dim == 'c' then
            low = xd(:,floor(loc));
            high = xd(:,ceil(loc));
        elseif dim == 'r' then
            low = xd(floor(loc),:);
            high = xd(ceil(loc),:);
        else
            low = xd(floor(loc));
            high = xd(ceil(loc));
        end
        x_int = modulo(loc,1);
        p = low+x_int.*(high-low);  // interpolation
    end
endfunction

