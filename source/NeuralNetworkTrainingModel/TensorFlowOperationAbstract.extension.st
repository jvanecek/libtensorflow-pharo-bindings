Extension { #name : #TensorFlowOperationAbstract }

{ #category : #'*NeuralNetworkTrainingModel' }
TensorFlowOperationAbstract >> += anOperation [

	^self currentComputation
		newOperationOf: 'AssignAdd'
		namePrefixed: 'AssignAdd'
		with: self
		with: anOperation
]
