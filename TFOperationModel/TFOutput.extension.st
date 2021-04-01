Extension { #name : #TFOutput }

{ #category : #'*TFOperationModel' }
TFOutput >> currentComputation [

	^TensorFlowComputation on: self graph
]

{ #category : #'*TFOperationModel' }
TFOutput >> outputOn: aGraph [

	^self
]

{ #category : #'*TFOperationModel' }
TFOutput >> rank [

	^graph rankOf: self
]

{ #category : #'*TFOperationModel' }
TFOutput >> shape [

	^self rank negative ifTrue: [TensorShape scalar] ifFalse: [graph shapeOf: self]
]
