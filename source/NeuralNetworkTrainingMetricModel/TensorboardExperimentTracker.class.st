Class {
	#name : #TensorboardExperimentTracker,
	#superclass : #TrainingMetricTracker,
	#instVars : [
		'logsFolder',
		'trainingWriter',
		'validationWriter'
	],
	#category : #NeuralNetworkTrainingMetricModel
}

{ #category : #'Instance Creation' }
TensorboardExperimentTracker class >> formattedTimestamp [

	| now timestamp |

	now := DateAndTime now.
	timestamp := String streamContents: [ :stream | 
		             stream print: now year.
		             stream nextPutAll: ( now month printPaddedWith: $0 to: 2 ).
		             stream
			             nextPutAll: ( now dayOfMonth printPaddedWith: $0 to: 2 );
			             nextPut: $-;
			             nextPutAll: ( now hour printPaddedWith: $0 to: 2 );
			             nextPutAll: ( now minute printPaddedWith: $0 to: 2 );
			             nextPutAll: ( now second printPaddedWith: $0 to: 2 )
		             ].
	^ timestamp
]

{ #category : #'Instance Creation' }
TensorboardExperimentTracker class >> new [

	^ self storingTo: self formattedTimestamp
]

{ #category : #'Instance Creation' }
TensorboardExperimentTracker class >> storingTo: aLogsLocation [

	^super new initializeStoringTo: aLogsLocation
]

{ #category : #Initialization }
TensorboardExperimentTracker >> initializeStoringTo: aLogsLocation [

	logsFolder := aLogsLocation
]

{ #category : #Processing }
TensorboardExperimentTracker >> measureMetricDuring: aFittingStage onEpochEndWithin: aTrainingContext [

	| writer |

	writer := self suitableWriterFor: aFittingStage.
	self
		writeLastLossValueDuring: aFittingStage within: aTrainingContext using: writer;
		writeLastAccuracyValueDuring: aFittingStage within: aTrainingContext using: writer
]

{ #category : #Processing }
TensorboardExperimentTracker >> measureMetricDuring: aTrainingStage onEpochStartWithin: aNeuralNetworkTrainingContext [

	" do nothing - jvanecek "


]

{ #category : #Processing }
TensorboardExperimentTracker >> measureMetricDuring: aTrainingStage onStepEndUsing: aStepInput within: aNeuralNetworkTrainingContext [


]

{ #category : #Processing }
TensorboardExperimentTracker >> measureMetricDuring: aTrainingStage onStepStartUsing: aStepInput within: aNeuralNetworkTrainingContext [

	" do nothing - jvanecek "


]

{ #category : #Preprocessing }
TensorboardExperimentTracker >> prepareMetricsWithin: aNeuralNetworkTrainingContext [

	trainingWriter :=
		aNeuralNetworkTrainingContext
			buildSummaryWriterTo: (logsFolder asFileReference / 'train') pathString.
	validationWriter :=
		aNeuralNetworkTrainingContext
			buildSummaryWriterTo: (logsFolder asFileReference / 'validation') pathString.
			
	trainingWriter writeGraphSummaryAtStep: 0
]

{ #category : #Processing }
TensorboardExperimentTracker >> suitableWriterFor: aFittingStage [

	^aFittingStage whenTrainDo: [trainingWriter] whenValidationDo: [validationWriter]
]

{ #category : #Processing }
TensorboardExperimentTracker >> writeLastAccuracyValueDuring: aFittingStage within: aTrainingContext using: writer [

	aTrainingContext
		withMetricKnownAs: CategoricalPredictionAccuracyTracker metricKey
		during: aFittingStage
		do: [:accuracyValues |
			writer
				writeScalar: accuracyValues last
				atStep: accuracyValues size - 1
				tagged: 'epoch_accuracy'.
						
			aFittingStage
				whenTrainDo: []
				whenValidationDo: [
					writer
						writeScalar: accuracyValues last
						atStep: aTrainingContext trainingStepValue 
						tagged: 'evaluation_accuracy_vs_iterations']]
]

{ #category : #Processing }
TensorboardExperimentTracker >> writeLastLossValueDuring: aFittingStage within: aTrainingContext using: writer [

	aTrainingContext
		withMetricKnownAs: aTrainingContext lossMetricKey
		during: aFittingStage
		do: [:lossValues |
			writer writeScalar: lossValues last atStep: lossValues size - 1 tagged: 'epoch_loss']
]
