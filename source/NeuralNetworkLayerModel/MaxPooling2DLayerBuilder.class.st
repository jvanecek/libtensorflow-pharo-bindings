Class {
	#name : #MaxPooling2DLayerBuilder,
	#superclass : #Object,
	#instVars : [
		'input',
		'poolSize'
	],
	#category : #NeuralNetworkLayerModel
}

{ #category : #'instance creation' }
MaxPooling2DLayerBuilder class >> receiving: anInputTensor [ 

	^ self new initializeReceiving: anInputTensor	
]

{ #category : #building }
MaxPooling2DLayerBuilder >> build [

	^ MaxPooling2D
		on: input currentComputation
		reducing: input
		inWindowsOf: poolSize
		shiftedBy: poolSize
]

{ #category : #initialization }
MaxPooling2DLayerBuilder >> initializeReceiving: anInputTensor [

	input := anInputTensor.
	poolSize := #(2 2).
	
]
