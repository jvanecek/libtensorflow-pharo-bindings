Extension { #name : #NeuralNetworkTrainingContext }

{ #category : #'*NeuralNetworkTrainingMetricModel' }
NeuralNetworkTrainingContext >> buildSummaryWriterTo: aLogsLocation [

	^SummaryWriter
		on: modelToTrain currentComputation
		writingTo: aLogsLocation
		appendingToName: '.v2'
		queueingUpTo: 10
		flushingEveryMilliseconds: 1
]
