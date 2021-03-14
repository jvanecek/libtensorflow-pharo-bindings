Extension { #name : #TensorFlowOperationAbstract }

{ #category : #'*MLTrainingModel' }
TensorFlowOperationAbstract >> += anOperation [

	^self currentComputation
		newOperationOf: 'AssignAdd'
		namePrefixed: 'AssignAdd'
		with: self
		with: anOperation
]
