Extension { #name : #TrainingMinimizingCategoricalCrossEntropyTest }

{ #category : #'*NeuralNetworkTrainingMetricModelTests' }
TrainingMinimizingCategoricalCrossEntropyTest >> expectedAccuracyAfterOneEpoch [

	^#(0.5)
]

{ #category : #'*NeuralNetworkTrainingMetricModelTests' }
TrainingMinimizingCategoricalCrossEntropyTest >> expectedAccuracyThroughTenEpochs [

	^#(0.5 0.5 0.5 0.5 0.5 0.5 0.75 0.75 0.75 0.75)
]
