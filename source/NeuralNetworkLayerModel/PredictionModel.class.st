Class {
	#name : #PredictionModel,
	#superclass : #TensorFlowOperationAbstract,
	#category : #NeuralNetworkLayerModel
}

{ #category : #prediction }
PredictionModel >> predictFrom: anInput [

	self subclassResponsibility
]
