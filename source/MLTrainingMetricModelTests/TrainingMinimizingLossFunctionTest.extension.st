Extension { #name : #TrainingMinimizingLossFunctionTest }

{ #category : #'*MLTrainingMetricModelTests' }
TrainingMinimizingLossFunctionTest >> expectedAccuracyAfterOneEpoch [

	self subclassResponsibility
]

{ #category : #'*MLTrainingMetricModelTests' }
TrainingMinimizingLossFunctionTest >> expectedAccuracyThroughTenEpochs [

	self subclassResponsibility
]

{ #category : #'*MLTrainingMetricModelTests' }
TrainingMinimizingLossFunctionTest >> testAccuracyAfterOneEpoch [

	| model summary |

	model := self modelWithTwoOutputUnits.
	summary :=
		self neuralNetworkTrainer
			trackMetricWith: CategoricalPredictionAccuracyTracker new; 
			stopTrainingWhen: (CompletedNumberOfTraining after: 1);
			train: model toFit: self trainingDataset.

	self
		assert: summary historicalTrainingAccuracy
		isArrayCloseTo: self expectedAccuracyAfterOneEpoch
]

{ #category : #'*MLTrainingMetricModelTests' }
TrainingMinimizingLossFunctionTest >> testAccuracyThroughTenEpochs [

	| model summary |

	model := self modelWithTwoOutputUnits.
	summary :=
		self neuralNetworkTrainer
			trackMetricWith: CategoricalPredictionAccuracyTracker new;
			stopTrainingWhen: (CompletedNumberOfTraining after: 10);
			train: model toFit: self trainingDataset.

	self
		assert: summary historicalTrainingAccuracy
		isArrayCloseTo: self expectedAccuracyThroughTenEpochs
]

{ #category : #'*MLTrainingMetricModelTests' }
TrainingMinimizingLossFunctionTest >> testEpochDuration [

	| model summary durations |

	model := self modelWithTwoOutputUnits.
	summary :=
		self neuralNetworkTrainer
			trackMetricWith: EpochDurationTracker new;
			stopTrainingWhen: (CompletedNumberOfTraining after: 10);
			train: model toFit: self trainingDataset.

	durations := summary trainingMetricKnownAs: EpochDurationTracker metricKey.
	self assert: durations size equals: 10.
	self assert: (durations conform: [:duration | duration >= 0])
]

{ #category : #'*MLTrainingMetricModelTests' }
TrainingMinimizingLossFunctionTest >> testFittingLogger [

	| model stream inputInBatches |

	stream := WriteStream on: String new.
	model := self modelWithTwoOutputUnits.

	inputInBatches :=
		(SampleDatasetComputationAware on: tf applying: [:dataset | dataset inBatchesOf: 2])
			bindSetsFrom: self trainingAndValidationDataset.

	self neuralNetworkTrainer
		trackMetricWith: (NeuralNetworkFittingLogger on: stream);
		stopTrainingWhen: (CompletedNumberOfTraining after: 2);
		train: model toFit: inputInBatches.

	self assert: (stream contents subStrings: String crlf) size equals: 25
]

{ #category : #'*MLTrainingMetricModelTests' }
TrainingMinimizingLossFunctionTest >> trainingAndValidationDataset [

	^SampleDataset new
		bindTrainingSetTo: self inputTensor withLabels: self targetTensor;
		bindValidationSetTo: self inputTensor withLabels: self targetTensor;
		yourself
]

{ #category : #'*MLTrainingMetricModelTests' }
TrainingMinimizingLossFunctionTest >> trainingDataset [

	^SampleDataset new
		bindTrainingSetTo: self inputTensor withLabels: self targetTensor;
		yourself
]
