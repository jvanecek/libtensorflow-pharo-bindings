Class {
	#name : #CompletedNumberOfTraining,
	#superclass : #TrainingStopCondition,
	#instVars : [
		'stopTrainingEpoch'
	],
	#category : 'MLTrainingModel'
}

{ #category : #'Instance Creation' }
CompletedNumberOfTraining class >> after: aTrainingNumber [

	^self new initializeAfter: aTrainingNumber
]

{ #category : #Initialization }
CompletedNumberOfTraining >> initializeAfter: aTrainingNumber [

	
	stopTrainingEpoch := aTrainingNumber
]

{ #category : #Testing }
CompletedNumberOfTraining >> isModelWellTrainedAccording: aTrainingContext [

	^stopTrainingEpoch < aTrainingContext epochsTrained
]

{ #category : #Printing }
CompletedNumberOfTraining >> printOn: aStream [

	aStream nextPutAll: ('Stop training after <1p> epochs' expandMacrosWith: stopTrainingEpoch)
]