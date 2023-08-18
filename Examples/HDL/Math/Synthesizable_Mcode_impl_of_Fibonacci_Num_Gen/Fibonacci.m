% This function defines a fibonacci calculator.
% Copyright(C) 2006 by  Xilinx, Inc. All rights reserved.

function [z, valid] = fibonacci(n, load) 
  init_0 = 1;
  init_1 = 1;
  init_counter = 1;
  precision = {xlUnsigned, 64, 0};

  % initialize state variables
  persistent register0, register0 = xl_state(init_0, precision);
  persistent register1, register1 = xl_state(init_1, precision);
  persistent counter, counter = xl_state(init_counter, {xlUnsigned, 8, 0} );
  persistent n_register, n_register = xl_state(0, {xlUnsigned, 8, 0} );
  
  %check status of the computation
  notDone = n_register > counter;

  % get outputs
  valid = ~notDone && ~load;
  z = register0;
  
  if load  % load initial values
      n_register = n;    
      register0 = init_0;
      register1 = init_1;
      counter = init_counter;
  elseif notDone  % do computation
      y = register0 + register1;
      register1 = register0;
      register0 = y;
      counter = counter + 1;
  end
  
