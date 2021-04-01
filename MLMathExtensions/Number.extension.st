Extension { #name : #Number }

{ #category : #'*MLMathExtensions' }
Number >> sigmoid [

	" sigmoid function "

	^1 / (1 + (self negated exp))
]
