Extension { #name : #TrainingMinimizingSparseCategoricalCrossEntropyTest }

{ #category : #'*MLTrainingMetricModelTests' }
TrainingMinimizingSparseCategoricalCrossEntropyTest >> expectedAccuracyAfterOneEpoch [

	^#(0.25)
]

{ #category : #'*MLTrainingMetricModelTests' }
TrainingMinimizingSparseCategoricalCrossEntropyTest >> expectedAccuracyThroughTenEpochs [

	^#(0.25 0.5 0.75 0.75 0.75 0.75 0.75 0.75 0.75 0.75)
]
