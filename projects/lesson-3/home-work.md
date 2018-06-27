C3 Linearization:
  
  contract O  
  contract A is O
  contract B is O
  contract C is O
  contract K1 is A, B
  contract K2 is A, C
  contract Z is K1, K2
  
  求contract Z的继承栈.
  
  根据C3 Linearization算法, 过程及结果如下：
  L(O) := {O}                                   // O has no parents
  L(A) := {A} + merge(L(O), {O})    
        = {A} + merge({O}, {O})                 // choose O, succeed
        = {A, O}
  L(B) := {B} + merge(L(O), {O})    
        = {B} + merge({O}, {O})                 // choose O, succeed
        = {B, O}
  L(C) := {C} + merge(L(O), {O})    
        = {C} + merge({O}, {O})                 // choose O, succeed
        = {C, O}
  L(K1):= {K1} + merge(L(A), L(B), {A, B})     
        = {K1} + merge({A, O}, {B, O}, {A, B})  // choose A, succeed
        = {K1, A} + merge({O}, {B, O}, {B})     // choose O, fail; choose B, succeed
        = {K1, A, B} + merge({O}, {O})          // choose O, succeed
        = {K1, A, B, O}  
  L(K2):= {K2} + merge(L(A), L(C), {A, C})     
        = {K2} + merge({A, O}, {C, O}, {A, C})  // choose A, succeed
        = {K2, A} + merge({O}, {C, O}, {C})     // choose O, fail; choose C, succeed
        = {K2, A, C} + merge({O}, {O})          // choose O, succeed
        = {K2, A, C, O}  
  L(Z) := {Z} + merge(L(K1), L(K2), {K1, K2})     
        = {Z} + merge({K1, A, B, O} , {K2, A, C, O} , {K1, K2})  // choose K1, succeed
        = {Z, K1} + merge({A, B, O} , {K2, A, C, O} , {K2})      // choose A, fail; choose K2, succeed
        = {Z, K1, K2} + merge({A, B, O} , {A, C, O})             // choose A, succeed
        = {Z, K1, K2, A} + merge({B, O} , {C, O})                // choose B, succeed
        = {Z, K1, K2, A, B} + merge({O} , {C, O})                // choose C, succeed
        = {Z, K1, K2, A, B, C} + merge({O} , {O})                // choose O, succeed
        = {Z, K1, K2, A, B, C, O}
        
结果: contract Z的继承栈是{Z, K1, K2, A, B, C, O}.
  
  验算: 将A继承B简写为A<B, 从Z的继承栈可看出
      A < O
      B < O
      C < O
      K1 < A, B
      K2 < A, C
      Z < K1, K2 均成立，所以结果正确.
  
