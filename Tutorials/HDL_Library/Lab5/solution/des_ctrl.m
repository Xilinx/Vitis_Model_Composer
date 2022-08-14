function ctrl = des_ctrl(start, dec, reset)
persistent state, state = xl_state(0, {xlUnsigned, 4, 0});
persistent decrypt, decrypt = xl_state(0, {xlBoolean});
if reset
    decrypt = dec;
    if decrypt
        state = 15;
    else
        state = 0;
    end
    ctrl = 0;
else
    switch state
        case 0
            decrypt = dec;
            if start
                state = 1;
                ctrl = 2;
            else
                state = 0;
                ctrl = 0;
            end
        case 1
            if decrypt
                ctrl = 1;
            else
                ctrl = 0;
            end
            state = state + 1;
        case 2
            ctrl = 1;
            state = state + 1;
        case 3
            ctrl = 1;
            state = state + 1;
        case 4
            ctrl = 1;
            state = state + 1;
        case 5
            ctrl = 1;
            state = state + 1;
        case 6
            ctrl = 1;
            state = state + 1;
        case 7
            if decrypt
                ctrl = 0;
            else
                ctrl = 1;
            end
            state = state + 1;
        case 8
            if decrypt
                ctrl = 1;
            else
                ctrl = 0;
            end
            state = state + 1;
        case 9
            ctrl = 1;
            state = state + 1;
        case 10
            ctrl = 1;
            state = state + 1;
        case 11
            ctrl = 1;
            state = state + 1;
        case 12
            ctrl = 1;
            state = state + 1;
        case 13
            ctrl = 1;
            state = state + 1;
        case 14
            if decrypt
                ctrl = 0;
            else
                ctrl = 1;
            end
            state = state + 1;
        otherwise
            ctrl = 0;
            state = 0;
    end
end
if decrypt
    ctrl = ctrl + 4;
end

        