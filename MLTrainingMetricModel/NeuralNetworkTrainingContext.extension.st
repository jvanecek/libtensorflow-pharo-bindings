Extension { #name : #NeuralNetworkTrainingContext }

{ #category : #'*MLTrainingMetricModel' }
NeuralNetworkTrainingContext >> buildCategoricalPredictionAccuracy [

	^CategoricalPredictionAccuracy
		of: model
		whenExpectedIs: optimization lossToMinimize targetInputAsLabels
]
