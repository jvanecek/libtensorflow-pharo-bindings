Extension { #name : #TrainingMinimizingMeanSquaredErrorTest }

{ #category : #'*NeuralNetworkTrainingMetricModelTests' }
TrainingMinimizingMeanSquaredErrorTest >> expectedAccuracyAfterOneEpoch [

	^#(0.5)
]

{ #category : #'*NeuralNetworkTrainingMetricModelTests' }
TrainingMinimizingMeanSquaredErrorTest >> expectedAccuracyThroughTenEpochs [

	^#(0.5 0.5 0.5 0.75 1 1 1 1 1 1)
]
