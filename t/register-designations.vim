map _  <Plug>(operator-echo)
call operator#user#define('echo', 'OperatorMemorize')
let s:register = ''
function! OperatorMemorize(motion_wise)
  let s:register = v:register
endfunction

" This :normal! overwrites v:register.
onoremap au  :<C-u>normal! v$<Return>

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

  it 'recognizes the last register even if combined with a custom text object'
    Expect Do('_au') ==# '"'
    Expect Do('""_au') ==# '"'
    Expect Do('"A_au') ==# 'A'
    Expect Do('3"x_au') ==# 'x'
    Expect Do('"y8_au') ==# 'y'
  end
end
