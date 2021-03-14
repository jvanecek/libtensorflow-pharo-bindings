Extension { #name : #NeuralNetworkTrainingSummary }

{ #category : #'*MLTrainingMetricModel' }
NeuralNetworkTrainingSummary >> historicalTrainingAccuracy [

	^self trainingMetricKnownAs: CategoricalPredictionAccuracyTracker metricKey
]

{ #category : #'*MLTrainingMetricModel' }
NeuralNetworkTrainingSummary >> trainingMetricKnownAs: aMetricKey [

	^trainingContext trainingMetricKnownAs: aMetricKey
]

{ #category : #'*MLTrainingMetricModel' }
NeuralNetworkTrainingSummary >> validationMetricKnownAs: aMetricKey [

	^trainingContext validationMetricKnownAs: aMetricKey
]
