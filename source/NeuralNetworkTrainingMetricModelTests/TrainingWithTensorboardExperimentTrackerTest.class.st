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
		         ( self linuxIdentificationParameters at: #ID ifAbsent: [ 'n/a' ] ) }.

	^ Dictionary new
		  at: { 'linux-gnu'. 'x86_64'. 'linuxmint' } put: 5072;
		  at: { 'linux-gnu'. 'x86_64'. 'ubuntu' } put: 4773;
		  at: { 'Win64'. 'x86_64'. 'n/a' } put: 4561;
		  at: osKey
		  ifAbsent: [ self fail: ( 'Do not know the expected size for <1p>' expandMacrosWith: osKey ) ]
]

{ #category : #tests }
TrainingWithTensorboardExperimentTrackerTest >> linuxIdentificationParameters [
	"see https://www.freedesktop.org/software/systemd/man/os-release.html "

	| props extractor |
	props := Dictionary new.
	OSPlatform current isUnix ifFalse: [ ^props ].
	extractor := [ '/etc/os-release' asFileReference contents linesDo: [ :each | 
		props at: (each copyUpTo: $=) asSymbol put: (each copyAfter: $=) ]].

	"Do nothing when it does not exist"
	[ extractor value ] on: FileDoesNotExistException do: [ self error: 'Only available on distributions supporting the linux standard base (LSB)' ].
	^ props
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
	self assert: ( content at: 4 ) size equals: 1188
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
