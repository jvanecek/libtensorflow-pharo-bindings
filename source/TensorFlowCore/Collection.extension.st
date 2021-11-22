Extension { #name : #Collection }

{ #category : #'*TensorFlowCore' }
Collection >> singleElementsDo: aBlock [ 

	^ self do: [:each | each singleElementsDo: aBlock ]
]

{ #category : #'*TensorFlowCore' }
Collection >> singleElementsInCollection [

	^self isEmpty
		ifTrue: [0]
		ifFalse: [self inject: 0 into: [:prev :each | prev + each singleElementsInCollection]]
]
