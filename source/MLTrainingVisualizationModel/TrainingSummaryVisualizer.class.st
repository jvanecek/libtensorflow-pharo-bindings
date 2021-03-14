Class {
	#name : #TrainingSummaryVisualizer,
	#superclass : #Object,
	#category : #MLTrainingVisualizationModel
}

{ #category : #'as yet unclassified' }
TrainingSummaryVisualizer >> viewLossAndAccuracyOf: aTrainingSummary [

	| b ds |

	b := RTGrapher new.
	b extent: 400 @ 300.

	ds := RTData new.
	ds label: 'Loss'.
	ds interaction popup.
	ds points: aTrainingSummary historicalTrainingLoss.
	ds connectColor: Color blue.
	ds y: #yourself.
	b add: ds.

	ds := RTData new.
	ds label: 'Accuracy'.
	ds interaction popup.
	ds points: aTrainingSummary historicalTrainingAccuracy.
	ds connectColor: Color red.
	ds y: #yourself.
	b add: ds.

	b axisX
		noDecimal;
		title: 'Epoch'.
	b legend.
	b build.
	^ b view
]
