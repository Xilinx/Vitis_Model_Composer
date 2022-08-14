function matched = state_machine(din)

persistent state, state = xl_state(0,{xlUnsigned, 3, 0});

switch state
    case 0
        if din == 1
            state = 1;
        else
            state = 0;
        end
        matched = 0;
    case 1
        if din == 0
            state = 2;
        else
            state = 1;
        end
        matched = 0;
    case 2
        if din == 1
            state = 3;
        else
            state = 0;
        end
        matched = 0;
    case 3
        if din == 1
            state = 4;
        else
            state = 2; 
        end
        matched = 0;
    case 4
        if din == 0
            state = 0;
        else
            state = 1;
        end
        matched = 1;
    otherwise
        state = 0;
        matched = 0;
end

