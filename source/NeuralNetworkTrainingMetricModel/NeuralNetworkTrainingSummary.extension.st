Extension { #name : #NeuralNetworkTrainingSummary }

{ #category : #'*NeuralNetworkTrainingMetricModel' }
NeuralNetworkTrainingSummary >> historicalTrainingAccuracy [

	^self trainingMetricKnownAs: CategoricalPredictionAccuracyTracker metricKey
]

{ #category : #'*NeuralNetworkTrainingMetricModel' }
NeuralNetworkTrainingSummary >> trainingMetricKnownAs: aMetricKey [

	^trainingContext trainingMetricKnownAs: aMetricKey
]

{ #category : #'*NeuralNetworkTrainingMetricModel' }
NeuralNetworkTrainingSummary >> validationMetricKnownAs: aMetricKey [

	^trainingContext validationMetricKnownAs: aMetricKey
]
