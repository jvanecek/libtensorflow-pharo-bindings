Extension { #name : #Object }

{ #category : #'*TensorFlowCore' }
Object >> inferTensorRank [

	^0
]

{ #category : #'*TensorFlowCore' }
Object >> inferTensorShape [

	^TensorShape scalar
]

{ #category : #'*TensorFlowCore' }
Object >> singleElementsDo: aBlock [ 

	^ aBlock value: self 
]

{ #category : #'*TensorFlowCore' }
Object >> singleElementsInCollection [

	^1
]
