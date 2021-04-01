Extension { #name : #NeuralNetworkTrainingSummary }

{ #category : #'*MLTrainingMetricModel' }
NeuralNetworkTrainingSummary >> historicalTrainingAccuracy [

	^trainingContext metricKnownAs: CategoricalPredictionAccuracyTracker metricKey
]
