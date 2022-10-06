Extension { #name : #TFOutput }

{ #category : #'*TensorFlowComputationModel' }
TFOutput >> currentComputation [

	^TensorFlowComputation on: self graph
]

{ #category : #'*TensorFlowComputationModel' }
TFOutput >> rank [

	^graph rankOf: self
]

{ #category : #'*TensorFlowComputationModel' }
TFOutput >> shape [

	^self rank negative ifTrue: [TensorShape scalar] ifFalse: [graph shapeOf: self]
]
