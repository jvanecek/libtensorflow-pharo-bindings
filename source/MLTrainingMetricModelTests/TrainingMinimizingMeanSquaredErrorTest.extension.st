Extension { #name : #TrainingMinimizingMeanSquaredErrorTest }

{ #category : #'*MLTrainingMetricModelTests' }
TrainingMinimizingMeanSquaredErrorTest >> expectedAccuracyAfterOneEpoch [

	^#(0.5)
]

{ #category : #'*MLTrainingMetricModelTests' }
TrainingMinimizingMeanSquaredErrorTest >> expectedAccuracyThroughTenEpochs [

	^#(0.5 0.5 0.5 0.75 1 1 1 1 1 1)
]
