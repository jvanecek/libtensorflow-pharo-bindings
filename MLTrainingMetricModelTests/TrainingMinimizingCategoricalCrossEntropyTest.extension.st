Extension { #name : #TrainingMinimizingCategoricalCrossEntropyTest }

{ #category : #'*MLTrainingMetricModelTests' }
TrainingMinimizingCategoricalCrossEntropyTest >> expectedAccuracyAfterOneEpoch [

	^#(0.5)
]

{ #category : #'*MLTrainingMetricModelTests' }
TrainingMinimizingCategoricalCrossEntropyTest >> expectedAccuracyThroughTenEpochs [

	^#(0.5 0.5 0.5 0.5 0.5 0.5 0.75 0.75 0.75 0.75)
]
