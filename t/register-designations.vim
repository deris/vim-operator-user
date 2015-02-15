map _  <Plug>(operator-echo)
call operator#user#define('echo', 'OperatorEcho')
let s:register = ''
function! OperatorEcho(motion_wise)
  let s:register = v:register
endfunction

function! Do(normal_command)
  execute 'normal' a:normal_command
  return s:register
endfunction

let ToUseRegister = {}
function! ToUseRegister.match(actual, expected)
  return a:actual ==# a:expected
endfunction
call vspec#customize_matcher('to_use_register', ToUseRegister)

describe 'operator#user#define'
  before
    new
  end

  after
    close!
  end

  it 'supports a register designation'
    Expect Do('__') ==# '"'
    Expect Do('""_L') ==# '"'
    Expect Do('"A_w') ==# 'A'
    Expect Do('3"x_w') ==# 'x'
    Expect Do('"y8_G') ==# 'y'
    Expect Do('v_') ==# '"'
    Expect Do('V""_') ==# '"'
    Expect Do('v"A_') ==# 'A'
    Expect Do('V3"x_') ==# 'x'
    Expect Do('v"y8_') ==# 'y'
  end
end
