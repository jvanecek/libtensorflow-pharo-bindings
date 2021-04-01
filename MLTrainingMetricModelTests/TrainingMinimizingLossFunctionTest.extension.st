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
			train: model toFitPredictionFrom: self inputTensor to: self targetTensor.

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
			train: model toFitPredictionFrom: self inputTensor to: self targetTensor.

	self
		assert: summary historicalTrainingAccuracy
		isArrayCloseTo: self expectedAccuracyThroughTenEpochs
]
