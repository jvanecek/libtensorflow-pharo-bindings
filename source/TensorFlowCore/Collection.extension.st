Extension { #name : #Collection }

{ #category : #'*TensorFlowCore' }
Collection >> product [
	"Cuis method. To be removed later"
	"Compute the product of all the elements in the receiver"
	^self fold:[ :a :b | a * b]
]
