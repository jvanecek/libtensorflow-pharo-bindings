Class {
	#name : #TrainingWithTensorboardExperimentTrackerTest,
	#superclass : #TensorFlowComputationBasedTest,
	#category : #NeuralNetworkTrainingMetricModelTests
}

{ #category : #tests }
TrainingWithTensorboardExperimentTrackerTest >> expectedLogFileSize [

	| osKey |

	osKey := { 
		         OSPlatform current version.
		         OSPlatform current subtype.
		         ( OSPlatform current linuxIdentificationParameters at: #ID ifAbsent: [ 'n/a' ] ) }.

	^ Dictionary new
		  at: { 'linux-gnu'. 'x86_64'. 'linuxmint' } put: 4695;
		  at: { 'Win64'. 'x86_64'. 'n/a' } put: 4561;
		  at: osKey
		  ifAbsent: [ self fail: ( 'Do not know the expected size in <1s>' expandMacrosWith: osKey ) ]
]

{ #category : #accessing }
TrainingWithTensorboardExperimentTrackerTest >> modelWithTwoOutputUnits [

	^(SequentialModelBuilder on: tf)
		addDenseLayerSized: 2
			builtWith: [:layer |
				layer
					inputSize: 3;
					weightInitializedToZero;
					biasInitializedTo: #(0.2 0.8)];
		buildApplyingToLogits: [:logits | logits argMaxOnRows]
]

{ #category : #tests }
TrainingWithTensorboardExperimentTrackerTest >> testTrackExperimentWithNoValidation [

	| model folder |

	model := self modelWithTwoOutputUnits.

	( NeuralNetworkTrainer on: tf )
		minimizeSparseCategoricalCrossEntropyUsing: ( GradientDescent scalingBy: 0.2 );
		trackMetricWith: ( TensorboardExperimentTracker storingTo: './test-logs' );
		stopTrainingWhen: ( CompletedNumberOfEpochs after: 10 );
		train: model toFit: self trainingDataset.

	folder := FileSystemAPI current directoryNamed: './test-logs'.
	[ 
	| content |

	content := folder allFileAndDirectoryEntries.
	self assert: content size equals: 4.
	self assert: ( content at: 1 ) basename equals: 'train'.
	self assert: ( content at: 2 ) size equals: self expectedLogFileSize.
	self assert: ( content at: 3 ) basename equals: 'validation'.
	self assert: ( content at: 4 ) size equals: 40
	] ensure: [ folder deleteAll ]
]

{ #category : #tests }
TrainingWithTensorboardExperimentTrackerTest >> testTrackExperimentWithValidationSet [

	| model folder |

	model := self modelWithTwoOutputUnits.

	( NeuralNetworkTrainer on: tf )
		minimizeSparseCategoricalCrossEntropyUsing: ( GradientDescent scalingBy: 0.2 );
		trackMetricWith: ( TensorboardExperimentTracker storingTo: './test-logs' );
		stopTrainingWhen: ( CompletedNumberOfEpochs after: 10 );
		train: model toFit: self trainingDatasetWithValidation.

	folder := FileSystemAPI current directoryNamed: './test-logs'.
	[ 
	| content |

	content := folder allFileAndDirectoryEntries.
	self assert: content size equals: 4.
	self assert: ( content at: 1 ) basename equals: 'train'.
	self assert: ( content at: 2 ) size equals: self expectedLogFileSize.
	self assert: ( content at: 3 ) basename equals: 'validation'.
	self assert: ( content at: 4 ) size equals: 518
	] ensure: [ folder deleteAll ]
]

{ #category : #accessing }
TrainingWithTensorboardExperimentTrackerTest >> trainingDataset [

	^SampleDataset new
		bindTrainingSetTo: #((0 0 1) (0 1 1) (1 0 0) (1 1 1)) asFloatTensor
			withLabels: #(0 1 0 0) asInt32Tensor;
		yourself
]

{ #category : #tests }
TrainingWithTensorboardExperimentTrackerTest >> trainingDatasetWithValidation [

	^SampleDataset new
		bindTrainingSetTo: #((0 0 1) (0 1 1) (1 0 0) (1 1 1)) asFloatTensor
			withLabels: #(0 1 0 0) asInt32Tensor;
		bindValidationSetTo: #((0 0 1) (0 1 1) (1 0 0) (1 1 1)) asFloatTensor
			withLabels: #(0 1 0 0) asInt32Tensor;
		yourself
]
