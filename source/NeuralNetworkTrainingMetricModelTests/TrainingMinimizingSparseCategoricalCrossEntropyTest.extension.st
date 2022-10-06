Extension { #name : #TrainingMinimizingSparseCategoricalCrossEntropyTest }

{ #category : #'*NeuralNetworkTrainingMetricModelTests' }
TrainingMinimizingSparseCategoricalCrossEntropyTest >> expectedAccuracyAfterOneEpoch [

	^#(0.25)
]

{ #category : #'*NeuralNetworkTrainingMetricModelTests' }
TrainingMinimizingSparseCategoricalCrossEntropyTest >> expectedAccuracyThroughTenEpochs [

	^#(0.25 0.5 0.75 0.75 0.75 0.75 0.75 0.75 0.75 0.75)
]
