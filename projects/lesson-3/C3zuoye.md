L(O) :=[O]
singleton list [O],bacause O has no parents

L(A) :=[A] + merge(L(O),[O])
merge of its parents' linearizations with the list of parents...
			=[A] + merge([O],[O])
			=[A,O]
single parent's linearization

L(B) :=[B,O]
computed similar to that of A
L(C) :=[C,O]

L[K1] :=[K1] + merge(L(A),L(B),[A,B])
parents,L(A),L(B) and merge them with the parent list [A,B]
			 =[K1] + merge([A,O],[B,O],[A,B])
			 =[K1,A] + merge([O],[B,O],[B])
			 =[K1,A,B] + merge([O],[O])
			 =[K1,A,B,O]
			 
L[K2] :=[K2] + merge(L(A),L(C),[A,C])
			 =[K2] + merge([A,O],[C,O],[A,C])
			 =[K2,A] + merge([O],[C,O],[C])
			 =[K2,A,C] + merge([O],[O])
			 =[K2,A,C,O]
			 
L[Z]	:=[Z] + merge(L(K1),L(K2),[K1,K2])
			 =[Z] + merge([K1,A,B,O],[K2,A,C,O],[K1,K2])
			 =[Z,K1] + merge([A,B,O],[K2,A,C,O],[K2])
			 =[Z,K1,K2] + merge([A,B,O],[A,C,O])
			 =[Z,K1,K2,A] + merge([B,O],[C,O])
			 =[Z,K1,K2,A,B] + merge([O],[C,O])
			 =[Z,K1,K2,A,B,C] + merge([O],[O])
			 =[Z,K1,K2,A,B,C,O]
			 
			 
so,The result is:[Z,K1,K2,A,B,C,O]   //contract Z
			 
