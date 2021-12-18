Extension { #name : #String }

{ #category : #'*TensorFlowCore' }
String >> asAsciiZ [
	^ self , Character null asString
]

{ #category : #'*TensorFlowCore' }
String >> asTensor [

	^TFString with: self
]

{ #category : #'*TensorFlowCore' }
String >> inferTensorRank [

	^0
]

{ #category : #'*TensorFlowCore' }
String >> inferTensorShape [

	^TensorShape scalar
]

{ #category : #'*TensorFlowCore' }
String >> singleElementsDo: aBlock [

	^ aBlock value: self
]

{ #category : #'*TensorFlowCore' }
String >> singleElementsInCollection [

	^1
]
