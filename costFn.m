function cost = costFn(fis, model, minData)
    % Update workspace variable for the controller.
    assignin('base','costFnFis',fis)

    % Run simulation programatically
    simOut = sim(model, ...
                 'SimulationMode', 'normal', ...
                 'SaveState','on', ...
                 'StateSaveName','xout', ...
                 'SaveOutput','on', ...
                 'OutputSaveName','yout', ...
                 'SaveFormat','dataset');

    % Get data for cost function (practice)
    cart_pos = simOut.yout.get('cart_pos').Values;
    pen_pos = simOut.yout.get('pen_pos').Values;

    % Cost function
    cart_pos_rms = rms(cart_pos.data);
    pen_pos_rms = rms(pen_pos.data);
    cost = 0.1 * cart_pos_rms + 3 * pen_pos_rms;
    
    % Update minimum costs and corresponding FIS if
    % it's smaller than the current minimum
    if cost < minData.MinCost
        minData.MinCost = cost;
        minData.MinFis = fis;
    end
end
