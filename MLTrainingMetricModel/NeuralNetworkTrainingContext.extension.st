Extension { #name : #NeuralNetworkTrainingContext }

{ #category : #'*MLTrainingMetricModel' }
NeuralNetworkTrainingContext >> buildCategoricalPredictionAccuracy [

	^CategoricalPredictionAccuracy
		of: modelToTrain
		whenExpectedIs: optimization lossToMinimize targetInputAsLabels
]
