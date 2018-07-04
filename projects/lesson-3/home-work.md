### C3 linearization inheritance list

```
L(O) := [O]
L(A) := [A] + merge(L(O),[O]) = [A] + merge([O],[O]) = [A,O]
L(B) := [B,O]
L(C) := [C,O]
L(K1) := [K1] + merge(L(A),L(B),[A,B]) = [K1] + merge([A,O],[B,O],[A,B])
	   = [K1,A] + merge([O],[B,O],[B]) = [K1,A,B] + merge([O],[O]) = [K1,A,B,O]
L(K2) := [K2,A,C,O]
L(Z) := [Z] + merge(L(K1),L(K2),[K1,K2])
		= [Z] + merge([K1,A,B,O],[K2,A,C,O],[K1,K2])
		= [Z,K1] + merge([A,B,O],[K2,A,C,O],[K2])
		= [Z,K1,K2] + merge([A,B,O],[A,C,O])
		= [Z,K1,K2,A] + merge([B,O],[C,O])
		= [Z,K1,K2,A,B] + merge([O],[C,O])
		= [Z,K1,K2,A,B,C] + merge([O],[O])
		= [Z,K1,K2,A,B,C,O]