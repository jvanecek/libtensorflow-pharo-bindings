Class {
	#name : #ImportedModel,
	#superclass : #PredictionModel,
	#instVars : [
		'inputName',
		'currentComputation'
	],
	#category : #NeuralNetworkLayerModel
}

{ #category : #'instance creation' }
ImportedModel class >> on: aTensorFlowComputation loadedFrom: aFileName inputNamed: anInputNodeName outputNamed: anOutputNodesName [

	^self new
		initializeOn: aTensorFlowComputation
		loadedFrom: aFileName
		inputNamed: anInputNodeName
		outputNamed: anOutputNodesName
]

{ #category : #accessing }
ImportedModel >> currentComputation [

	^currentComputation
]

{ #category : #initialization }
ImportedModel >> initializeOn: aTensorFlowComputation loadedFrom: aFileName inputNamed: anInputNodeName outputNamed: anOutputNodeName [

	currentComputation := aTensorFlowComputation.
	currentComputation importGraphFrom: aFileName.
	inputName := anInputNodeName.
	value := currentComputation operationNamed: anOutputNodeName
]

{ #category : #prediction }
ImportedModel >> predictFrom: aFeatureTensor [

	^self computeWith: (
		Dictionary new
			at: inputName put: aFeatureTensor;
			yourself)
]
