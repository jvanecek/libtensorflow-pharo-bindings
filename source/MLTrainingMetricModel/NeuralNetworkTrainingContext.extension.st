Extension { #name : #NeuralNetworkTrainingContext }

{ #category : #'*MLTrainingMetricModel' }
NeuralNetworkTrainingContext >> buildCategoricalPredictionAccuracy [

	^CategoricalPredictionAccuracy
		of: modelToTrain
		whenExpectedIs: optimization lossToMinimize targetInputAsLabels
]

{ #category : #'*MLTrainingMetricModel' }
NeuralNetworkTrainingContext >> buildSummaryWriterTo: aLogsLocation [

	^SummaryWriter
		on: modelToTrain currentComputation
		writingTo: aLogsLocation
		appendingToName: '.v2'
		queueingUpTo: 10
		flushingEveryMilliseconds: 1
]
